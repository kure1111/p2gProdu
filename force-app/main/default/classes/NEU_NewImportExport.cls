public with sharing class NEU_NewImportExport 
{
	public NEU_NewImportExport(ApexPages.StandardController std) 
	{
  	}
  
  	public PageReference redirect_new_importexport()
  	{
    	//Sacamos el id del record_type (Import-Export Quote)
    	Id record_type = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
    
    	//Sacamos el prefijo de la tab de Import-Export Quote
    	String prefix = Schema.getGlobalDescribe().get('Customer_Quote__c').getDescribe().getKeyPrefix();
    
    	PageReference retURL = new PageReference('/'+prefix+'/e?RecordType='+record_type+'&Name=<Se creará automáticamente>&00N0Y00000S3rz2=CUSTOMER CREATED&nooverride=1');
        retURL.setRedirect(true);
        return retURL;
  	}   
}