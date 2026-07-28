@isTest
public class P2G_ServiceRateDeactivation_ScheduleTest {
	@isTest
    static void execute() {
        
    Test.startTest();
    	// cron job = Seconds Minutes Hours Day_of_month Month Day_of_week Year(opcional)    
    	String cron = '0 0 0 * * ? 2099';
        
    	System.Schedule('Test Job', cron, new P2G_ServiceRateDeactivation_Schedule());
        
    	Test.stopTest();
            List<CronTrigger> ct = [
            SELECT Id, CronExpression, TimesTriggered, State
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Test Job'
        ];
        
        System.assert(!ct.isEmpty(), 'El job programado no fue creado');
        }
    }