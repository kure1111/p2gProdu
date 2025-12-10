@isTest
public class P2G_Scheduled_UPD_CurrencyTest {
	@isTest(SeeAllData=true)
    static void testBatchExecution() {
        // Obtener los datos de prueba
        Shipment__c testShipment = [SELECT Id FROM Shipment__c LIMIT 1];
        Shipment_Fee_Line__c testFeeLine = [SELECT Id, Conversion_Rate_to_Currency_Header__c 
                                           FROM Shipment_Fee_Line__c 
                                           WHERE Shipment__c = :testShipment.Id 
                                           LIMIT 1];
        
        // Mock de NEU_CurrencyUtils
        Test.setMock(HttpCalloutMock.class, new CurrencyUtilsMock());
        
        Test.startTest();
        
        // Instanciar y ejecutar el batch
        P2G_Scheduled_UPD_Currency batch = new P2G_Scheduled_UPD_Currency();
        Database.executeBatch(batch);
        
        Test.stopTest();                
    }
    
    @isTest(SeeAllData=true)
    static void testBatchWithNoUpdatesNeeded() {
        // Obtener los datos de prueba
        Shipment__c testShipment = [SELECT Id FROM Shipment__c LIMIT 1];
        Shipment_Fee_Line__c testFeeLine = [SELECT Id, Conversion_Rate_to_Currency_Header__c 
                                           FROM Shipment_Fee_Line__c 
                                           WHERE Shipment__c = :testShipment.Id 
                                           LIMIT 1];
        
        // Mock de NEU_CurrencyUtils que devuelve la misma tasa actual
        Test.setMock(HttpCalloutMock.class, new CurrencyUtilsMock(17.5));
        
        Test.startTest();
        
        P2G_Scheduled_UPD_Currency batch = new P2G_Scheduled_UPD_Currency();
        Database.executeBatch(batch);
        
        Test.stopTest();                
    }
        
    @isTest
    static void testFinishMethod() {
        // Configurar datos para el finish
        P2G_Scheduled_UPD_Currency batch = new P2G_Scheduled_UPD_Currency();
        batch.totalRecordsProcessed = 5;
        batch.totalRecordsUpdated = 2;
        batch.tasaCambio = 20.5;
        batch.processedSPLIds.add('a0JRQ000006Qr212AC');
        batch.conversionChanges.put('a0JRQ000006Qr212AC', new Map<String, Decimal>{
            'oldValue' => 17.5,
            'newValue' => 20.5
        });
        
        Test.startTest();
        
        // Ejecutar finish manualmente
        batch.finish(null);
        
        Test.stopTest();                
    }
    
    // Mock class para simular las llamadas HTTP de NEU_CurrencyUtils
    private class CurrencyUtilsMock implements HttpCalloutMock {
        private Decimal mockRate;
        
        public CurrencyUtilsMock() {
            this.mockRate = 20.5; // Valor por defecto
        }
        
        public CurrencyUtilsMock(Decimal customRate) {
            this.mockRate = customRate;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"rates":{"MXN":' + mockRate + '}}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    // Test para cubrir el código de NEU_CurrencyUtils si es necesario
    @isTest
    static void testCurrencyUtilsIntegration() {
        // Mock para la llamada HTTP
        Test.setMock(HttpCalloutMock.class, new CurrencyUtilsMock());
        
        Test.startTest();
        
        NEU_CurrencyUtils currencyUtils = new NEU_CurrencyUtils();
        Decimal rate = currencyUtils.getConversionRate('USD', 'MXN', Date.today());
        
        Test.stopTest();
    }
}