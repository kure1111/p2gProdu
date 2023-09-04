/**
 * Created by jamarin on 06/05/2019.
 */

@isTest
private class NEU_test_SchedulerReport
{

    static testMethod void ProcessSchedulerReport() {
        NEU_StaticVariableHelper.setBoolean1(true);
        Test.startTest();
        Account buyer = new Account();
        buyer.Name = 'Test';
        insert buyer;

        Scheduler_Shipment_Services_Lines__c schedulerReport = new Scheduler_Shipment_Services_Lines__c();
        schedulerReport.Historical_Time__c = ' Month';
        schedulerReport.Cron_Expression__c = '0 0 0 30 12 ? 2099';
        schedulerReport.Contact_Emails_Sent__c = 'joseantonio@neurored.com';
        schedulerReport.Document_Name__c = 'Test';
        schedulerReport.Email_Template__c = 'Generic';

        schedulerReport.Sender_Name__c = 'Test Sender Name';
        schedulerReport.Cc_email__c = 'joseantonio@neurored.com;test@test.com';
        schedulerReport.CCO_email__c = 'joseantonio@neurored.com;test@test.com';
        schedulerReport.Subject_mail__c = 'Test subject';
        schedulerReport.Body_mail__c = '<p>Test mail scheduler report</p><p>Another Line</p>';
        schedulerReport.Email_Template__c = 'Generic';

        insert schedulerReport;

        ProcessSchedulerReport sched = new ProcessSchedulerReport();
        Id job_id = System.schedule('test', '0 0 0 30 12 ? 2099', sched);
        System.assertNotEquals(null, job_id);

        Test.stopTest();
    }

    static testMethod void DeleteSchedulerReport() {
        NEU_StaticVariableHelper.setBoolean1(true);
        Scheduler_Shipment_Services_Lines__c schedulerReport = new Scheduler_Shipment_Services_Lines__c();
        schedulerReport.Name = 'Test';
        insert schedulerReport;

        ApexPages.currentPage().getParameters().put('test', 'test');
        DeleteSchedulerReport dsr = new DeleteSchedulerReport(new ApexPages.StandardController(schedulerReport));
        dsr.delete_record();
        system.debug( 'Delete done' );
    }

    static testMethod void DeactivateSchedulerReport() {
        NEU_StaticVariableHelper.setBoolean1(true);
        Scheduler_Shipment_Services_Lines__c schedulerReport = new Scheduler_Shipment_Services_Lines__c();
        schedulerReport.Name = 'Test';
        insert schedulerReport;

        ApexPages.currentPage().getParameters().put('test', 'test');
        DeactivateSchedulerReport dsr = new DeactivateSchedulerReport(new ApexPages.StandardController(schedulerReport));
        dsr.deactivate_record();
        system.debug( 'Deactivate done' );
    }

    static testMethod void RefreshSchedulerReport() {
        NEU_StaticVariableHelper.setBoolean1(true);
        Test.startTest();
        Account buyer = new Account();
        buyer.Name = 'Test';
        insert buyer;

        Scheduler_Shipment_Services_Lines__c schedulerReport = new Scheduler_Shipment_Services_Lines__c();
        schedulerReport.Cron_Expression__c = '0 0 0 * * ?';
        schedulerReport.Contact_Emails_Sent__c = 'test@test.com';
        schedulerReport.Body_mail__c = 'Test';
        insert schedulerReport;
        ApexPages.currentPage().getParameters().put('test', 'test');
        RefreshSchedulerReport rsr = new RefreshSchedulerReport(new ApexPages.StandardController(schedulerReport));
        rsr.refresh();
        system.debug( 'Refresh done' );
        Test.stopTest();
    }

}