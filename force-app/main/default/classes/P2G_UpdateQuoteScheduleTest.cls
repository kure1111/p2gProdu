@isTest
public class P2G_UpdateQuoteScheduleTest {
    @isTest(SeeAllData=true)
    static void ScheduleTest(){
        Customer_Quote__c quote = new Customer_Quote__c(Id='a0I4T000004Wmt9UAC');
        Test.startTest();
        P2G_UpdateQuoteSchedule myJob = new P2G_UpdateQuoteSchedule(quote.Id);
        DateTime startTime = System.now().addSeconds(5);
        String cronExpr = startTime.second() + ' ' + startTime.minute() + ' ' + startTime.hour() + ' ' + startTime.day() + ' ' + startTime.month() + ' ? ' + startTime.year();
        String jobName = 'Email job '+cronExpr;
        myJob.execute(null);
        Test.stopTest();
    }
    
}