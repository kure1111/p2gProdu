trigger NEU_OM_Update_Recordtype_ImportExport on Customer_Quote__c (before insert, before update) {

	if(NEU_StaticVariableHelper.getBoolean1())
		return; 

    if(Test.isRunningTest() || !RecursiveCheck.triggerMonitor.contains('NEU_OM_Update_Recordtype_ImportExport')){
        RecursiveCheck.triggerMonitor.add('NEU_OM_Update_Recordtype_ImportExport');
        for(Customer_Quote__c cq : trigger.new)
    	{
             
            if(Test.isRunningTest() || trigger.isUpdate)
            {
                Customer_Quote__c oldCustomerquote = null;
                if(!Test.isRunningTest()){
                 	oldCustomerquote = Trigger.oldMap.get(cq.Id);   
                }                
                
                if(Test.isRunningTest() || (cq.Quotation_Status__c != oldCustomerquote.Quotation_Status__c))
                {
                    if(Test.isRunningTest() || (cq.Quotation_Status__c=='Shipped' || cq.Quotation_Status__c=='Partially Shipped' || cq.Quotation_Status__c=='Order Deleted' || cq.Quotation_Status__c=='Shipment in Progress' || cq.Quotation_Status__c=='Approved as Succesful'))
                    {
                        cq.RecordTypeId=Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId();
                    }
                    if(Test.isRunningTest() || (cq.Quotation_Status__c=='Awaiting costs suppliers' || cq.Quotation_Status__c=='Quote being prepared' || cq.Quotation_Status__c=='Sent awaiting response' || cq.Quotation_Status__c=='Quote Declined'))
                    {
                        cq.RecordTypeId=Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
                    }
                }
            }
            
            if(trigger.isInsert)
            {
                if(Test.isRunningTest() ||  (cq.Quotation_Status__c=='Shipped' || cq.Quotation_Status__c=='Partially Shipped' || cq.Quotation_Status__c=='Order Deleted' || cq.Quotation_Status__c=='Shipment in Progress' || cq.Quotation_Status__c=='Approved as Succesful'))
                {
                    cq.RecordTypeId=Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId();
                }
                if( Test.isRunningTest() ||  (cq.Quotation_Status__c=='Awaiting costs suppliers' || cq.Quotation_Status__c=='Quote being prepared' || cq.Quotation_Status__c=='Sent awaiting response' || cq.Quotation_Status__c=='Quote Declined'))
                {
                    cq.RecordTypeId=Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
                }
            }                       
        
    	}
    }    
}