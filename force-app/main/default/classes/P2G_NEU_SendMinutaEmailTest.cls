@isTest
public class P2G_NEU_SendMinutaEmailTest {
    /*@testSetup
static void setupTestData() {        
Account testAccount = new Account(Name = 'Test Account');

insert testAccount;

Contact testContact = new Contact(
FirstName = 'Test',
LastName = 'Contact',
Email = 'tes1212t@example.com',
AccountId = testAccount.Id,
Title = 'Test Title'
);
insert testContact;

Event testEvent = new Event(
Subject = 'Test Meeting',
StartDateTime = DateTime.now(),
EndDateTime = DateTime.now().addHours(1),
WhoId = testContact.Id,
OwnerId = UserInfo.getUserId(),
Motivo_Minuta__c = 'Desarrollo Comercial',
Location = 'Pak2go',
Objetivo__c = 'Test Objetivo',
Comments_Pric__c = 'Test Comments',
Temas_Pendientes__c = 'Test Temas Pendientes',
Proxima_Reunion__c = Date.today().addDays(7),
TipoMeeting__c='Videoconferencia'
);
insert testEvent;

EventRelation er = new EventRelation(
EventId = testEvent.Id,
RelationId = testContact.Id,
Status = 'Accepted'
);
insert er;

Event_Issues__c issue = new Event_Issues__c(
Id_Calendar_Event__c = testEvent.Id,
Topic__c = 'Test Topic',
Situation__c = 'Test Situation',
User__c = UserInfo.getUserId(),
Date__c = Date.today()
);
insert issue;
}
*/
    @isTest(SeeAllData=true)
    static void testConstructor() {
        
        Event testEvent = [SELECT Id FROM Event LIMIT 1];
        
        Test.setCurrentPage(Page.NEU_SendMinutaEmail);
        ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
        
        Test.startTest();
        NEU_SendMinutaEmail controller = new NEU_SendMinutaEmail(sc);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testSendEmailSuccess() {
        Event testEvent = [SELECT Id FROM Event WHERE Location!=null AND Objetivo__c!=null LIMIT 1];
        
        Test.setCurrentPage(Page.NEU_SendMinutaEmail);
        ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
        NEU_SendMinutaEmail controller = new NEU_SendMinutaEmail(sc);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        controller.send_email();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testSendEmailFailure() {
        Event testEvent = [SELECT Id FROM Event LIMIT 1];
        
        Test.setCurrentPage(Page.NEU_SendMinutaEmail);
        ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
        NEU_SendMinutaEmail controller = new NEU_SendMinutaEmail(sc);
        
        controller.defaultTo = '';
        
        Test.startTest();
        controller.send_email();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testGeneratePdf() {
        Event testEvent = [SELECT Id FROM Event LIMIT 1];
        
        Test.setCurrentPage(Page.NEU_SendMinutaEmail);
        ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
        NEU_SendMinutaEmail controller = new NEU_SendMinutaEmail(sc);
        
        Test.startTest();
        Blob pdf = controller.generatePdf(testEvent.Id);
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void testReturnEvent() {
        Event testEvent = [SELECT Id FROM Event LIMIT 1];
        
        Test.setCurrentPage(Page.NEU_SendMinutaEmail);
        ApexPages.StandardController sc = new ApexPages.StandardController(testEvent);
        NEU_SendMinutaEmail controller = new NEU_SendMinutaEmail(sc);
        
        Test.startTest();
        PageReference result = controller.return_event();
        Test.stopTest();
    }
    
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success":true}');
            res.setStatusCode(200);
            return res;
        }
    }
}