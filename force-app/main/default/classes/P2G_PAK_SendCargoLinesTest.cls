@isTest(SeeAllData=true)
public class P2G_PAK_SendCargoLinesTest {
        
    public class PAK_SendCargoLinesMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            
            if (req.getEndpoint().contains('/services/Soap/u/')) {
                res.setBody(
                    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' +
                    '<soapenv:Body>' +
                    '<loginResponse xmlns="urn:partner.soap.sforce.com">' +
                    '<result>' +
                    '<sessionId>TEST_SESSION_ID</sessionId>' +
                    '</result>' +
                    '</loginResponse>' +
                    '</soapenv:Body>' +
                    '</soapenv:Envelope>'
                );
            }            
            else {
                res.setBody('<response>OK</response>');
            }

            return res;
        }
    }
    
    @isTest
    static void testSendOperationThree() {

        Test.setMock(HttpCalloutMock.class, new PAK_SendCargoLinesMock());

        Quote_Item_Line__c line = [
            SELECT Id
            FROM Quote_Item_Line__c
            WHERE Id != null
            LIMIT 1
        ];

        Set<Id> ids = new Set<Id>{ line.Id };

        Test.startTest();
        PAK_SendCargoLines.send(ids, 3);
        Test.stopTest();
    }
    
    @isTest
    static void testSendOperationOther() {

        Quote_Item_Line__c line = [
            SELECT Id
            FROM Quote_Item_Line__c
            WHERE Id != null
            LIMIT 1
        ];

        Set<Id> ids = new Set<Id>{ line.Id };

        Test.startTest();
        PAK_SendCargoLines.send(ids, 1);
        Test.stopTest();
    }
    
    @isTest
    static void testLogin() {

        Test.setMock(HttpCalloutMock.class, new PAK_SendCargoLinesMock());

        Test.startTest();
        PAK_SendCargoLines.login();
        Test.stopTest();
    }
    
    @isTest
    static void testSendCargoLines() {

        Test.setMock(HttpCalloutMock.class, new PAK_SendCargoLinesMock());

        Test.startTest();
        PAK_SendCargoLines.sendCargoLines('<test>body</test>');
        Test.stopTest();
    }
}