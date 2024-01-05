@isTest
private class P2G_scheduleAsignacionOperacionesTest {
    @isTest
    static void testScheduledJob() {
        Test.startTest();
        P2G_scheduleAsignacionOperaciones scheduledJob = new P2G_scheduleAsignacionOperaciones();
        scheduledJob.execute(null);
        Test.stopTest();
    }
}