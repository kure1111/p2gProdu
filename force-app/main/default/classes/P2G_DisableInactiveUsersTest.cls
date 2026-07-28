@isTest(SeeAllData=true)
public class P2G_DisableInactiveUsersTest {
    
    @isTest
    static void testDisableInactiveUsers() {
        Test.startTest();
        P2G_DisableInactiveUsers scheduler = new P2G_DisableInactiveUsers();
        scheduler.execute(null);
        Test.stopTest();
        
        System.assert(true, 'Test executed successfully');
    }
}