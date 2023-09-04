public with sharing class DeleteSchedulerReport {
    public Scheduler_Shipment_Services_Lines__c record;
    ApexPages.StandardController con;

    public DeleteSchedulerReport(ApexPages.StandardController stdController) {
        con = stdController;
        try {
            record = [select Id, Cron_Job_Id__c from Scheduler_Shipment_Services_Lines__c where id = :con.getRecord().id];
        } catch( Exception ee) {
            record = new Scheduler_Shipment_Services_Lines__c();
        }
    }

    public Pagereference delete_record()
    {
        for (CronTrigger t : [select Id from CronTrigger where Id = :record.Cron_Job_Id__c])
        {
            System.abortJob(t.Id);
        }

        delete record;

        PageReference pgReturnPage;
        String returnUrl = '/a27/o';
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
}