public with sharing class RefreshSchedulerReport {
	public Scheduler_Shipment_Services_Lines__c record;
	ApexPages.StandardController con;
	
	public RefreshSchedulerReport(ApexPages.StandardController stdController) {
   		con = stdController;
   	   	system.debug( con.getRecord() );
		try { 
			record = [select Id, Name, Cron_Job_Id__c, Cron_Expression__c from Scheduler_Shipment_Services_Lines__c where id = :con.getRecord().id];
		} 
		catch( Exception ee) { 
			record = new Scheduler_Shipment_Services_Lines__c();
		}
	}
		
	public Pagereference refresh()
	{
		for (CronTrigger t : [select Id from CronTrigger where Id = :record.Cron_Job_Id__c])
		{
			System.abortJob(t.Id);
		}	
		
		record.Cron_Job_Id__c = System.schedule(record.Name, record.Cron_Expression__c, new ProcessSchedulerReport());
  		update record;
		
		PageReference pgReturnPage;
		String returnUrl = '/' + record.Id;
    	pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
		return pgReturnPage;
	}
}