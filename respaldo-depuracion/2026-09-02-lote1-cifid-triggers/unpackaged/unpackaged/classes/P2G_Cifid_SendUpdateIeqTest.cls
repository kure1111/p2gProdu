@isTest
public class P2G_Cifid_SendUpdateIeqTest {

    @isTest(SeeAllData=true)
    static void testSendMethod() {
        List<Customer_Quote__c> quotes = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        Set<Id> quoteIds = new Map<Id, Customer_Quote__c>(quotes).keySet();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CifidMockResponseGenerator());
        Cifid_SendUpdateIeq.send(quoteIds);
        Test.stopTest();

        System.assertEquals(true, Cifid_SendUpdateIeq.firstRun, 'firstRun debería permanecer true');
    }

    @isTest(SeeAllData=true)
    static void testLoginMethod() {
        // Insertar credenciales de prueba
        Cred_Cifid__c credencial = new Cred_Cifid__c(
            Usuario__c = 'test@example.com',
            Password__c = 'password123',
            Token__c = 'securityToken'
        );
        insert credencial;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CifidMockResponseGenerator());
        HttpResponse response = Cifid_SendUpdateIeq.login();
        Test.stopTest();

        System.assertNotEquals(null, response, 'La respuesta no debería ser nula');
        System.assertEquals(200, response.getStatusCode(), 'El código de estado debería ser 200');
    }

    @isTest(SeeAllData=true)
    static void testEmptyInput() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CifidMockResponseGenerator());
        Cifid_SendUpdateIeq.send(new Set<Id>());
        Test.stopTest();

        // Verificar que no hay excepciones con entrada vacía
        System.assert(true, 'El método debería manejar conjuntos vacíos sin errores');
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