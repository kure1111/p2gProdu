public with sharing class NEU_NewInvoiceButton 
{
	public pagereference redirect()
	{
		string redirect_address = '';
		string prefix = Schema.getGlobalDescribe().get('Invoice__c').getDescribe().getKeyPrefix();
		
		if(Apexpages.currentPage().getParameters().get('import_export_id') != null)
		{
			List<Customer_Quote__c> import_export = [select Id, Name, Account_for__c, Account_for__r.Name from Customer_Quote__c where Id =: Apexpages.currentPage().getParameters().get('import_export_id')];
			
			if(import_export.size() > 0)
				redirect_address = '/'+prefix+'/e?CF00N4T000005tUzl='+import_export[0].Name+'&CF00N4T000005tUzl_lkid='+import_export[0].Id+'&retURL=%2F'+import_export[0].Id+'&Name=<Se creará automáticamente>&CF00N4T000005tVIx='+import_export[0].Account_for__r.Name+'&CF00N4T000005tVIx_lkid='+import_export[0].Account_for__c;
		}
		if(Apexpages.currentPage().getParameters().get('shipment_id') != null)
		{
			List<Shipment__c> shipment = [select Id, Name, Account_for__c, Account_for__r.Name from Shipment__c where Id =: Apexpages.currentPage().getParameters().get('shipment_id')];
			
			if(shipment.size() > 0)
			{
				List<Shipment_Consolidation_Data__c> shipment_consolidation_data = [select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipment__c =: shipment[0].Id];
				
				if(shipment_consolidation_data.size() > 0)
					redirect_address = '/'+prefix+'/e?CF00N4T000005tVJa='+shipment[0].Name+'&CF00N4T000005tVJa_lkid='+shipment[0].Id+'&CF00N4T000005tUzl='+shipment_consolidation_data[0].Import_Export_Quote__r.Name+'&CF00N4T000005tUzl_lkid='+shipment_consolidation_data[0].Import_Export_Quote__c+'&retURL=%2F'+shipment[0].Id+'&Name=<Se creará automáticamente>&CF00N4T000005tVIx='+shipment[0].Account_for__r.Name+'&CF00N4T000005tVIx_lkid='+shipment[0].Account_for__c;
			}
		}
		
		PageReference pgReturnPage;
        String returnUrl = redirect_address;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
	}    
}