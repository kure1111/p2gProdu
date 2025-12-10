@isTest
public class P2G_NEU_EventIssuesTest {
    @isTest(SeeAllData=true)
    static void testConstructorWithValidData() {
        // Get test event
        Event testEvent = [SELECT Id FROM Event LIMIT 1];
        
        // Create standard controller
        ApexPages.StandardController stdController = new ApexPages.StandardController(testEvent);
        
        Test.startTest();
        NEU_EventIssues controller = new NEU_EventIssues(stdController);
        Test.stopTest();
    }

}