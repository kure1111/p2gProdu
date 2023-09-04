public with sharing class NEU_Update_conversion_Rate_SQO {

	private ApexPages.StandardController con;
	private Supplier_Quote__c record;
	public NEU_Update_conversion_Rate_SQO(ApexPages.StandardController stdController) 
    {
		if(!Test.isRunningTest()) stdController.AddFields(new String[]{'Id','Conversion_Rate_Date__c'});
		con=stdController;
        record = (Supplier_Quote__c)con.getRecord();
    }

 	public PageReference refresh_lines()
    {
    	record.Conversion_Rate_Date__c=Date.today();
    	con.save();
    	return con.view();
    }
}