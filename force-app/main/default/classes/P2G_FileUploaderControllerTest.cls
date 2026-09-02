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
}