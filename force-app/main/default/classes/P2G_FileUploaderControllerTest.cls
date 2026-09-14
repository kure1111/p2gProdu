@isTest
public class P2G_FileUploaderControllerTest {

    static Integer counter = 0;

    static String generateCustomerId() {
        counter++;
        Long base = 3585000000L;
        Long id = base + counter;
        return String.valueOf(id);
    }

    static Account createDefaultAccount() {
        String customerId = generateCustomerId();
        Account defaultAcc = new Account(
            Name = 'Ejemplo Cuenta Defecto ' + customerId,
            Customer_Id__c = customerId
        );
        insert defaultAcc;
        return defaultAcc;
    }

    static SAP_Service_Type__c getValidSAPServiceType(String code) {
        List<SAP_Service_Type__c> existing = [
            SELECT Id FROM SAP_Service_Type__c
            WHERE Code__c = :code AND Activo__c = true AND Group__c = 'SP-FN-FLETE NACIONAL'
            LIMIT 1
        ];
        if (!existing.isEmpty()) return existing[0];

        SAP_Service_Type__c newSap = new SAP_Service_Type__c(
            Name = 'SAP ' + code + ' ' + generateCustomerId(),
            Code__c = code,
            Activo__c = true,
            Group__c = 'SP-FN-FLETE NACIONAL'
        );
        insert newSap;
        return newSap;
    }

    static Container_Type__c getValidContainerType() {
        String name = 'Container Test ' + generateCustomerId();
        Container_Type__c cont = new Container_Type__c(Name = name);
        insert cont;
        return cont;
    }

    static TestData createTestData(String tipo) {
        String customerId = generateCustomerId();
        Account acc = new Account(
            Name = (tipo == 'proveedores' ? 'Proveedor Test ' : 'Cliente Test ') + customerId,
            Customer_Id__c = customerId
        );
        insert acc;

        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(
            Name = 'Ruta Test ' + customerId
        );
        insert route;

        route = [SELECT Name FROM Carrier_Line_Load_Point__c WHERE Id = :route.Id];

        SAP_Service_Type__c sap = getValidSAPServiceType('FTN');
        Container_Type__c container = getValidContainerType();

        return new TestData(acc, route.Name, sap, sap, container);
    }

    class TestData {
        Account account;
        String routeName;
        SAP_Service_Type__c sapSell;
        SAP_Service_Type__c sapBuy;
        Container_Type__c container;
        TestData(Account acc, String rName, SAP_Service_Type__c sSell, SAP_Service_Type__c sBuy, Container_Type__c c) {
            this.account = acc;
            this.routeName = rName;
            this.sapSell = sSell;
            this.sapBuy = sBuy;
            this.container = c;
        }
    }

    static String buildCSVProveedor(String proveedor, String customerId, String ruta,
                                String sapSell, String sapBuy, String sellRate,
                                String validFrom, String validUntil, String containerType) {
        String header = 'Nombre del Proveedor,Customer ID,Ruta,Sap service Type Sell,Sap service Type Buy,Sell Rate,Valid From dd/mm/yyyy,Valid Until dd/mm/yyyy,Container Type';
        String row = proveedor + ',' + customerId + ',' + ruta + ',' + sapSell + ',' + sapBuy + ',' + sellRate + ',' + validFrom + ',' + validUntil + ',' + containerType;
        return header + '\n' + row;
    }

    static String headerClientes() {
        return 'Nombre del Cliente,Customer ID,Ruta,Sap service Type Sell,Sap service Type Buy,Sell Rate ,Valid From dd/mm/yyyy,Valid Until dd/mm/yyyy,Container Type';
    }

    static String filaCliente(TestData data, String sellRate) {
        return data.account.Name + ',' + data.account.Customer_Id__c + ',' + data.routeName + ',' +
               data.sapSell.Name + ',' + data.sapBuy.Name + ',' + sellRate + ',01/07/2026,01/07/2027,' + data.container.Name;
    }

    @isTest
    static void testSuccessProveedores() {
        Account defaultAccount = createDefaultAccount();

        TestData data = createTestData('proveedores');

        String csv = buildCSVProveedor(
            data.account.Name,
            data.account.Customer_Id__c,
            data.routeName,
            data.sapSell.Name,
            data.sapBuy.Name,
            '250.00',
            '01/06/2026',
            '01/06/2027',
            data.container.Name
        );

        Test.startTest();
        String resultado = P2G_FileUploaderController.procesarCSV(csv, 'proveedores');
        Test.stopTest();

        System.assert(resultado.contains('Registros insertados'), 'No se insertó el registro esperado');
        List<Fee__c> fees = [SELECT Id FROM Fee__c];
        System.assertEquals(1, fees.size(), 'Debe haber exactamente un Fee creado');
    }

    // El formato REAL de la plantilla: Excel exporta el Sell Rate con moneda
    // entre comillas ("$27,000") y el header trae "Sell Rate " con espacio.
    @isTest
    static void testClientesFormatoPlantilla() {
        TestData data = createTestData('clientes');
        String csv = headerClientes() + '\n' +
            data.account.Name + ',' + data.account.Customer_Id__c + ',' + data.routeName + ',' +
            data.sapSell.Name + ',' + data.sapBuy.Name + ',"$27,000",01/07/2026,01/07/2027,' + data.container.Name;

        Test.startTest();
        String resultado = P2G_FileUploaderController.procesarCSV(csv, 'clientes');
        Test.stopTest();

        System.assert(resultado.contains('Registros insertados exitosamente: 1'), 'Debio insertar 1: ' + resultado);
        Fee__c fee = [SELECT Fee_Rate__c, Valid_From__c, Valid_Until__c, Account_for__c FROM Fee__c LIMIT 1];
        System.assertEquals(27000, fee.Fee_Rate__c, 'El "$27,000" con comillas debe leerse como 27000');
        System.assertEquals(Date.newInstance(2026, 7, 1), fee.Valid_From__c, 'Fecha dd/mm/yyyy');
        System.assertEquals(data.account.Id, fee.Account_for__c);
    }

    // Volumen: 60 filas en una sola transaccion (el motor viejo moria con ~20
    // por hacer 5 consultas por fila). Se asegura ademas que el consumo de SOQL
    // sea constante, no por fila.
    @isTest
    static void testVolumen60Filas() {
        TestData data = createTestData('clientes');
        String csv = headerClientes();
        for (Integer i = 0; i < 60; i++) {
            csv += '\n' + filaCliente(data, '"$' + String.valueOf(10000 + i) + '"');
        }

        Test.startTest();
        Integer q0 = Limits.getQueries();
        String resultado = P2G_FileUploaderController.procesarCSV(csv, 'clientes');
        Integer consumidas = Limits.getQueries() - q0;
        Test.stopTest();

        System.assert(resultado.contains('Registros insertados exitosamente: 60'), 'Debio insertar 60: ' + resultado);
        System.assertEquals(60, [SELECT COUNT() FROM Fee__c], 'Deben existir 60 fees');
        System.assert(consumidas < 15, 'El consumo de SOQL debe ser constante, no por fila. Consumidas: ' + consumidas);
    }

    // Errores por fila: valores que no existen se reportan con fila y valor,
    // y las filas buenas SI se insertan.
    @isTest
    static void testErroresPorFila() {
        TestData data = createTestData('clientes');
        String csv = headerClientes() + '\n' +
            filaCliente(data, '15000') + '\n' +
            ',,,,,,,,' + '\n' +
            data.account.Name + ',' + data.account.Customer_Id__c + ',RUTA QUE NO EXISTE,' +
            data.sapSell.Name + ',' + data.sapBuy.Name + ',15000,01/07/2026,01/07/2027,' + data.container.Name + '\n' +
            data.account.Name + ',' + data.account.Customer_Id__c + ',' + data.routeName + ',' +
            'SERVICIOS LOGISTICOS NACIONALE FN (IC) (FN),' + data.sapBuy.Name + ',15000,01/07/2026,01/07/2027,' + data.container.Name + '\n' +
            filaCliente(data, 'no-es-numero');

        Test.startTest();
        String resultado = P2G_FileUploaderController.procesarCSV(csv, 'clientes');
        Test.stopTest();

        System.assert(resultado.contains('Registros insertados exitosamente: 1'), 'Solo la fila buena: ' + resultado);
        System.assert(!resultado.contains('Fila 3:'), 'La fila vacia (,,,,,,,,) debe ignorarse sin error: ' + resultado);
        System.assert(resultado.contains('No se encontró Ruta "RUTA QUE NO EXISTE"'), 'Error de ruta con el valor: ' + resultado);
        System.assert(resultado.contains('No se encontró SAP Service Type "SERVICIOS LOGISTICOS NACIONALE FN (IC) (FN)"'), 'Error de SAP type: ' + resultado);
        System.assert(resultado.contains('Sell Rate inválido'), 'Error de rate: ' + resultado);
    }

    @isTest
    static void testParsers() {
        // parser CSV: comillas con comas adentro y comillas escapadas
        List<String> campos = P2G_FileUploaderController.parseCsvLine('A,"$27,000",C,"dice ""hola""",');
        System.assertEquals(5, campos.size());
        System.assertEquals('$27,000', campos[1]);
        System.assertEquals('dice "hola"', campos[3]);
        System.assertEquals('', campos[4]);

        System.assertEquals(27000, P2G_FileUploaderController.parseImporte('$27,000'));
        System.assertEquals(27000.50, P2G_FileUploaderController.parseImporte('27000.50'));
        System.assertEquals(Date.newInstance(2026, 12, 31), P2G_FileUploaderController.parseDate('31/12/2026'));
        System.assertEquals(null, P2G_FileUploaderController.parseDate(''));

        try {
            P2G_FileUploaderController.parseImporte('abc');
            System.assert(false, 'Debio tronar con rate invalido');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Sell Rate inválido'));
        }
        try {
            P2G_FileUploaderController.parseDate('aa/bb/cccc');
            System.assert(false, 'Debio tronar con fecha invalida');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Fecha inválida'));
        }
    }
}
