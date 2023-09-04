public with sharing class NEU_NewDisbursementButton 
{
	public pagereference redirect()
	{
		string redirect_address = '';
		string prefix = Schema.getGlobalDescribe().get('Shipment_Disbursement__c').getDescribe().getKeyPrefix();
		
		if(Apexpages.currentPage().getParameters().get('import_export_id') != null)
		{
			List<Customer_Quote__c> import_export = [select Id, Name, Supplier_Account__c, Supplier_Account__r.Name from Customer_Quote__c where Id =: Apexpages.currentPage().getParameters().get('import_export_id')];
			
			if(import_export.size() > 0)
			{
				redirect_address = '/'+prefix+'/e?CF00N0Y00000Oj0bA='+import_export[0].Name+'&CF00N0Y00000Oj0bA_lkid='+import_export[0].Id+'&retURL=%2F'+import_export[0].Id+'&Name=<Se creará automáticamente>';
				if(import_export[0].Supplier_Account__c != null)
					redirect_address += '&CF00N0Y00000Oj0KV='+import_export[0].Supplier_Account__r.Name+'&CF00N0Y00000Oj0KV_lkid='+import_export[0].Supplier_Account__c;
			}
				
		}
		if(Apexpages.currentPage().getParameters().get('shipment_id') != null)
		{
			List<Shipment__c> shipment = [select Id, Name, Supplier_Account__c, Supplier_Account__r.Name from Shipment__c where Id =: Apexpages.currentPage().getParameters().get('shipment_id')];
			
			if(shipment.size() > 0)
			{
				List<Customer_Quote__c> import_export = [select Id, Name from Customer_Quote__c where Last_Shipment__c =: shipment[0].Id];

				if(import_export.size() > 0)
				{
					redirect_address = '/'+prefix+'/e?CF00N0Y00000Oj0bd='+shipment[0].Name+'&CF00N0Y00000Oj0bd_lkid='+shipment[0].Id+'&CF00N0Y00000Oj0bA='+import_export[0].Name+'&CF00N0Y00000Oj0bA_lkid='+import_export[0].Id+'&retURL=%2F'+import_export[0].Id+'&Name=<Se creará automáticamente>';
					if(shipment[0].Supplier_Account__c != null)
						redirect_address += '&CF00N0Y00000Oj0KV='+shipment[0].Supplier_Account__r.Name+'&CF00N0Y00000Oj0KV_lkid='+shipment[0].Supplier_Account__c;
				}
			}
		}
		
		PageReference pgReturnPage;
        String returnUrl = redirect_address;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
	}    
}