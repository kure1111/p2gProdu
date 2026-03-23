@isTest
public class P2G_AccountRouteByStatus_ScheduleTest {

    @isTest
    static void testScheduleExecution() {
        
        Test.startTest();
        
        String cronExp = '0 0 0 1 1 ? 2050';
        
        System.schedule(
            'Test Account Route By Status Schedule',
            cronExp,
            new P2G_AccountRouteByStatus_Schedule()
        );
        
        Test.stopTest();
        
        List<CronTrigger> ct = [
            SELECT Id, CronExpression, TimesTriggered, State
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Test Account Route By Status Schedule'
        ];
        
        System.assert(!ct.isEmpty(), 'El job programado no fue creado');
    }
}