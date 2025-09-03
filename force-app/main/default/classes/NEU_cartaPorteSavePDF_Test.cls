@isTest(SeeAllData=true)
public class NEU_cartaPorteSavePDF_Test {

    // Clase Mock interna para simular el callout HTTP
    class MockHttpResponseCartaPorte implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true, "message": "PDF generado exitosamente"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testConstructorAndCrear() {
        Shipment__c shipment = [SELECT Id, Name, Account_for__c, Traslado_Ingreso__c 
                                FROM Shipment__c 
                                WHERE Account_for__c != null 
                                LIMIT 1];

        // Mock de la llamada HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCartaPorte());

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        NEU_CartaPorteSavePDF controller = new NEU_CartaPorteSavePDF(sc);
        
        try {
            controller.test();
            controller.crear();
        } catch (Exception e) {
            System.debug('Excepción inesperada durante crear(): ' + e.getMessage());
            System.assert(false, 'No se esperaba una excepción en crear() si el mock está configurado correctamente.');
        }
        Test.stopTest();
    }

    @isTest
    static void testSavePdfSinCP() {
        Shipment__c shipment = [SELECT Id, Name 
                                FROM Shipment__c 
                                WHERE Id != null 
                                LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        NEU_CartaPorteSavePDF controller = new NEU_CartaPorteSavePDF(sc);
        
        Test.startTest();
        controller.savePdfSinCP();
        Test.stopTest();
    }

    @isTest
    static void testSavePdf() {
        Shipment__c shipment = [SELECT Id, Name 
                                FROM Shipment__c 
                                WHERE Id != null 
                                LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        NEU_CartaPorteSavePDF controller = new NEU_CartaPorteSavePDF(sc);

        controller.errorMessage = 'ad';

        Test.startTest();
        PageReference pr = controller.savePdf();
        Test.stopTest();
    }

    @isTest
    static void testRefreshData() {
        Shipment__c shipment = [SELECT Id, Name 
                                FROM Shipment__c 
                                WHERE Id != null 
                                LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        NEU_CartaPorteSavePDF controller = new NEU_CartaPorteSavePDF(sc);
        
        Test.startTest();
        controller.refresh_data();
        Test.stopTest();
    }
}