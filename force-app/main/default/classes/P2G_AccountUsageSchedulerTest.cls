@isTest
private class P2G_AccountUsageSchedulerTest {

    @isTest
    static void testScheduler() {

        Test.startTest();

        String cronExp = '0 0 4 ? * 2 *';

        System.schedule(
            'Test P2G Account Usage Scheduler',
            cronExp,
            new P2G_AccountUsageScheduler()
        );

        Test.stopTest();
        
    }
}