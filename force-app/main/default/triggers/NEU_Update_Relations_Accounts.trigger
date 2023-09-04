trigger NEU_Update_Relations_Accounts on Shipment__c (after insert) {
	
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
   Set<Id> ids=new Set<Id>();
    for(Shipment__c s:trigger.new)
    {
      
        ids.add(s.Id);
    }
    
    List<Shipment__c> list_update_shipments = [select id, Name, Consignee__c , Consignee_Contact__c , Notify_Party__c , Shipper__c , Shipper_Contact__c ,   Account_for__r.Consignee__c, Account_for__r.Consignee_Contact__c, Account_for__r.Notify_Party__c, Supplier_Account__r.Shipper__c, Supplier_Account__r.Shipper_Contact__c from Shipment__c where id in: ids];
    for(Shipment__c s: list_update_shipments )
    {
        if(s.Consignee__c == null)
            s.Consignee__c = s.Account_for__r.Consignee__c;
        if(s.Consignee_Contact__c == null)
            s.Consignee_Contact__c = s.Account_for__r.Consignee_Contact__c;
        if(s.Notify_Party__c == null)
            s.Notify_Party__c = s.Account_for__r.Notify_Party__c;
            
        if(s.Supplier_Account__c != null)
        {
            if(s.Shipper__c == null)
                s.Shipper__c = s.Supplier_Account__r.Shipper__c;
            if(s.Shipper_Contact__c == null)
                s.Shipper_Contact__c = s.Supplier_Account__r.Shipper_Contact__c ;
        }
    }
    update list_update_shipments;

}