@isTest
public class P2G_ScheduleOppoCloseDateExtendidaTest {
	@isTest(SeeAllData=true)
    public static void ScheduleOppoCloseDateExtendidaTest(){
        Test.startTest();
        P2G_ScheduleOppoCloseDateExtendida myJob = new P2G_ScheduleOppoCloseDateExtendida();
        DateTime startTime = System.now().addSeconds(5);//addMinutes(1)
        String cronExpr = startTime.second() + ' ' + startTime.minute() + ' ' + startTime.hour() + ' ' + startTime.day() + ' ' + startTime.month() + ' ? ' + startTime.year();
        String jobName = 'Email job '+cronExpr;
        myJob.execute(null);
        Test.stopTest();
    }
}