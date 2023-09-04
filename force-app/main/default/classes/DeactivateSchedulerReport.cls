public with sharing class DeactivateSchedulerReport {
    public Scheduler_Shipment_Services_Lines__c record;
    ApexPages.StandardController con;

    public DeactivateSchedulerReport(ApexPages.StandardController stdController) {
        con = stdController;
        try {
            record = [select Id, Cron_Job_Id__c,Processed__c from Scheduler_Shipment_Services_Lines__c where id = :con.getRecord().id];
        } catch( Exception ee) {
            record = new Scheduler_Shipment_Services_Lines__c();
        }
    }

    public Pagereference deactivate_record()
    {
        for (CronTrigger t : [select Id from CronTrigger where Id = :record.Cron_Job_Id__c])
        {
            System.abortJob(t.Id);
        }

        record.Cron_Job_Id__c = '';
        record.Processed__c = false;
        update record;

        PageReference pgReturnPage;
        String returnUrl = record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
}