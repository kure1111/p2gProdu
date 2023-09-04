public with sharing class NEU_Commercial_Info_IE 
{
	public Customer_Quote__c record=null;
    public NEU_Commercial_Info_IE(ApexPages.StandardController stdController) 
    {
    	if (!Test.isRunningTest())
        stdController.AddFields(new String[]
        {
            'Id','Name'
        });
        record=(Customer_Quote__c)stdController.getRecord();
    }
}