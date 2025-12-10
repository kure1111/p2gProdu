@isTest
public class P2G_Cifid_SendShipLinesTest {

    @isTest(SeeAllData=true)
    static void testSendOperation3() {
        List<Shipment_Fee_Line__c> lines = [SELECT Id FROM Shipment_Fee_Line__c LIMIT 1];
        Set<Id> lineIds = new Map<Id, Shipment_Fee_Line__c>(lines).keySet();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CifidMockResponseGenerator());
        Cifid_SendShipLines.send(lineIds, 3);
        Test.stopTest();
        
    }

	@isTest(SeeAllData=true)
    static void testSendOtherOperation() {
        List<Shipment_Fee_Line__c> lines = [SELECT Id FROM Shipment_Fee_Line__c LIMIT 1];
        Set<Id> lineIds = new Map<Id, Shipment_Fee_Line__c>(lines).keySet();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CifidMockResponseGenerator());
        Cifid_SendShipLines.send(lineIds, 1);
        Test.stopTest();

        System.assertEquals(true, Cifid_SendShipLines.firstRun, 'firstRun debería permanecer true');
    }

    @isTest(SeeAllData=true)
    static void testLogin() {
        // Insertar credenciales de prueba si es necesario
        Cred_Cifid__c credencial = new Cred_Cifid__c(
            Usuario__c = 'test@example.com',
            Password__c = 'password',
            Token__c = 'token'
        );
        insert credencial;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CifidMockResponseGenerator());
        HttpResponse response = Cifid_SendShipLines.login();
        Test.stopTest();

        System.assertNotEquals(null, response, 'La respuesta no debería ser nula');
    }

    private class CifidMockResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml');
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com"><soapenv:Body><loginResponse><result><sessionId>TEST_SESSION_ID</sessionId></result></loginResponse></soapenv:Body></soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
        }
    }
}