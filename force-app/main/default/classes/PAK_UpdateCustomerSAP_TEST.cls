@isTest(SeeAllData=true)
public class PAK_UpdateCustomerSAP_TEST {

    // Clase interna para simular respuesta HTTP
    class PAK_MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"SUCCESS","message":"Mock response"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testSendWS() {
        // Registrar el mock
        Test.setMock(HttpCalloutMock.class, new PAK_MockHttpResponse());

        // Obtener un Account existente y válido
        Account acc = [
            SELECT Id 
            FROM Account 
            WHERE 
                Name != null 
                AND NEU_Email__c != null 

            LIMIT 1
        ];

        ApexPages.StandardController sc = new ApexPages.StandardController(acc);

        Test.startTest();
        PAK_UpdateCustomerSAP controller = new PAK_UpdateCustomerSAP(sc);
        controller.SendWS();
        controller.byPass();
        Test.stopTest();
    }
}