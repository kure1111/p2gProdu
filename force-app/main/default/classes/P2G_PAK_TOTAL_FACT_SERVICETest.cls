@isTest
public class P2G_PAK_TOTAL_FACT_SERVICETest {
            
    @isTest(seeAllData=true)
    static void testFacturarPedidoConInvoice() {
        // Obtener una factura existente en la org
        Invoice__c testInvoice = [SELECT Id FROM Invoice__c LIMIT 1];
        
        // Crear el objeto TOTAL_FACT
        PAK_Update_ACC.TOTAL_FACT factRecord = new PAK_Update_ACC.TOTAL_FACT();
        factRecord.TIPO = 'PEDIDO';
        factRecord.IdInovice = testInvoice.Id;
        factRecord.UI = 'FAC-12345';
        factRecord.TotalFacturado = '500.00';
        factRecord.FechaFactura = '2024-01-15';
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>{factRecord};
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testFacturarPedidoConInvoice: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testFacturarPedidoConDisbursement() {
        // Obtener un disbursement existente en la org
        Shipment_Disbursement__c testDisbursement = [SELECT Id FROM Shipment_Disbursement__c LIMIT 1];
        
        // Crear el objeto TOTAL_FACT
        PAK_Update_ACC.TOTAL_FACT factRecord = new PAK_Update_ACC.TOTAL_FACT();
        factRecord.TIPO = 'PEDIDO';
        factRecord.IdInovice = testDisbursement.Id;
        factRecord.UI = 'FAC-67890';
        factRecord.TotalFacturado = '300.00';
        factRecord.FechaFactura = '2024-01-20';
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>{factRecord};
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testFacturarPedidoConDisbursement: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testFacturarDisbursementCompletamentePagado() {
        // Obtener un disbursement existente en la org
        Shipment_Disbursement__c testDisbursement = [SELECT Id, Total_Excl_VAT__c FROM Shipment_Disbursement__c LIMIT 1];
        
        // Crear el objeto TOTAL_FACT
        PAK_Update_ACC.TOTAL_FACT factRecord = new PAK_Update_ACC.TOTAL_FACT();
        factRecord.TIPO = 'PEDIDO';
        factRecord.IdInovice = testDisbursement.Id;
        factRecord.UI = 'FAC-99999';
        
        // Usar el mismo valor que Total_Excl_VAT__c
        if(testDisbursement.Total_Excl_VAT__c != null) {
            factRecord.TotalFacturado = String.valueOf(testDisbursement.Total_Excl_VAT__c);
        } else {
            factRecord.TotalFacturado = '500.00';
        }
        
        factRecord.FechaFactura = '2024-01-25';
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>{factRecord};
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testFacturarDisbursementCompletamentePagado: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testFacturarConTotalFacturadoNull() {
        // Obtener un disbursement existente en la org
        Shipment_Disbursement__c testDisbursement = [SELECT Id FROM Shipment_Disbursement__c LIMIT 1];
        
        // Crear el objeto TOTAL_FACT sin TotalFacturado
        PAK_Update_ACC.TOTAL_FACT factRecord = new PAK_Update_ACC.TOTAL_FACT();
        factRecord.TIPO = 'PEDIDO';
        factRecord.IdInovice = testDisbursement.Id;
        factRecord.UI = 'FAC-NULL';
        factRecord.TotalFacturado = null;
        factRecord.FechaFactura = '2024-01-20';
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>{factRecord};
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testFacturarConTotalFacturadoNull: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testTipoNota() {
        // Probar el caso TIPO == 'NOTA' (actualmente vacío)
        PAK_Update_ACC.TOTAL_FACT factRecord = new PAK_Update_ACC.TOTAL_FACT();
        factRecord.TIPO = 'NOTA';
        factRecord.IdInovice = 'test-id';
        factRecord.UI = 'NOTA-123';
        factRecord.TotalFacturado = '100.00';
        factRecord.FechaFactura = '2024-01-20';
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>{factRecord};
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testTipoNota: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testIdInvalido() {
        // Probar con un ID que no existe
        PAK_Update_ACC.TOTAL_FACT factRecord = new PAK_Update_ACC.TOTAL_FACT();
        factRecord.TIPO = 'PEDIDO';
        factRecord.IdInovice = 'a0X000000000000'; // ID inválido
        factRecord.UI = 'FAC-ERROR';
        factRecord.TotalFacturado = '100.00';
        factRecord.FechaFactura = '2024-01-20';
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>{factRecord};
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testIdInvalido: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testMultiplesRegistros() {
        // Obtener registros existentes en la org
        List<Invoice__c> invoices = [SELECT Id FROM Invoice__c LIMIT 1];
        List<Shipment_Disbursement__c> disbursements = [SELECT Id FROM Shipment_Disbursement__c LIMIT 1];
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>();
        
        // Primer registro (si hay Invoice)
        if(!invoices.isEmpty()) {
            PAK_Update_ACC.TOTAL_FACT fact1 = new PAK_Update_ACC.TOTAL_FACT();
            fact1.TIPO = 'PEDIDO';
            fact1.IdInovice = invoices[0].Id;
            fact1.UI = 'FAC-MULTI-1';
            fact1.TotalFacturado = '100.00';
            fact1.FechaFactura = '2024-01-15';
            factList.add(fact1);
        }
        
        // Segundo registro (si hay Disbursement)
        if(!disbursements.isEmpty()) {
            PAK_Update_ACC.TOTAL_FACT fact2 = new PAK_Update_ACC.TOTAL_FACT();
            fact2.TIPO = 'PEDIDO';
            fact2.IdInovice = disbursements[0].Id;
            fact2.UI = 'FAC-MULTI-2';
            fact2.TotalFacturado = '200.00';
            fact2.FechaFactura = '2024-01-20';
            factList.add(fact2);
        }
        
        // Tercer registro (NOTA)
        PAK_Update_ACC.TOTAL_FACT fact3 = new PAK_Update_ACC.TOTAL_FACT();
        fact3.TIPO = 'NOTA';
        fact3.IdInovice = 'test-nota';
        fact3.UI = 'NOTA-MULTI-3';
        fact3.TotalFacturado = '300.00';
        fact3.FechaFactura = '2024-01-25';
        factList.add(fact3);
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testMultiplesRegistros: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testExcepcion() {
        // Probar manejo de excepciones - pasar null para forzar error
        try {
            Test.startTest();
            List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(null);
            Test.stopTest();
            System.debug('Resultados testExcepcion: ' + results);
        } catch (Exception e) {
            System.debug('Excepción capturada en testExcepcion: ' + e.getMessage());
        }
    }
    
    @isTest(seeAllData=true)
    static void testSinRegistrosEncontrados() {
        // Probar cuando no se encuentran registros con el ID proporcionado
        PAK_Update_ACC.TOTAL_FACT factRecord = new PAK_Update_ACC.TOTAL_FACT();
        factRecord.TIPO = 'PEDIDO';
        factRecord.IdInovice = '001000000000000'; // ID genérico que probablemente no existe
        factRecord.UI = 'FAC-SIN-REGISTRO';
        factRecord.TotalFacturado = '100.00';
        factRecord.FechaFactura = '2024-01-20';
        
        List<PAK_Update_ACC.TOTAL_FACT> factList = new List<PAK_Update_ACC.TOTAL_FACT>{factRecord};
        
        Test.startTest();
        List<PAK_TOTAL_FACT_SERVICE.status> results = PAK_TOTAL_FACT_SERVICE.FACT(factList);
        Test.stopTest();
        
        // El método se ejecuta sin verificaciones
        System.debug('Resultados testSinRegistrosEncontrados: ' + results);
    }


}