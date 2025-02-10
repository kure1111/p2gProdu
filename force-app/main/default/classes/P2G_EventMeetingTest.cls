@isTest(SeeAllData=true)
public class P2G_EventMeetingTest {
    @isTest
    static void testP2G_EventMeeting() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        User testUser = [SELECT Id FROM User WHERE Email = 'javier.tenorio@2gologistics.com' LIMIT 1];

        Test.startTest(); 
        Map<String, String> resultAccount = P2G_EventMeeting.getRecordName(testAccount.Id);
        Map<String, String> resultOpportunity = P2G_EventMeeting.getRecordName(testOpp.Id);
        P2G_EventMeeting.createEvent(
            'Meeting',
            'Seguimiento',
            'Presencial',
            testUser.Id,
            testAccount.Id,
            'Segunda visita',
            DateTime.now().addDays(1),
            DateTime.now().addDays(1).addHours(1)
        );
        Event createdEvent = [SELECT Id, Subject FROM Event WHERE Subject LIKE '%Meeting%' LIMIT 1];
        List<Opportunity> opps = P2G_EventMeeting.getOpportunitiesForAccount(testAccount.Id, 'Prospect', 'Test Reason');
        List<Account> accounts = P2G_EventMeeting.searchAccounts('Test');
        Test.stopTest();
    }
}