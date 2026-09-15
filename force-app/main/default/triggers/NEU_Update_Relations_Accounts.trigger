trigger NEU_Update_Relations_Accounts on Shipment__c (after insert) {

	if(NEU_StaticVariableHelper.getBoolean1())
		return;

   Set<Id> ids=new Set<Id>();
    for(Shipment__c s:trigger.new)
    {

        ids.add(s.Id);
    }

    // El update se hace SOLO cuando de verdad hay algo que copiar de la cuenta:
    // el update incondicional re-disparaba toda la cadena de triggers y flows de
    // update dentro del mismo insert aunque ningun campo cambiara.
    List<Shipment__c> list_update_shipments = new List<Shipment__c>();
    for(Shipment__c s: [select id, Name, Consignee__c , Consignee_Contact__c , Notify_Party__c , Shipper__c , Shipper_Contact__c , Supplier_Account__c,  Account_for__r.Consignee__c, Account_for__r.Consignee_Contact__c, Account_for__r.Notify_Party__c, Supplier_Account__r.Shipper__c, Supplier_Account__r.Shipper_Contact__c from Shipment__c where id in: ids])
    {
        Boolean cambio = false;
        if(s.Consignee__c == null && s.Account_for__r.Consignee__c != null)
        {
            s.Consignee__c = s.Account_for__r.Consignee__c;
            cambio = true;
        }
        if(s.Consignee_Contact__c == null && s.Account_for__r.Consignee_Contact__c != null)
        {
            s.Consignee_Contact__c = s.Account_for__r.Consignee_Contact__c;
            cambio = true;
        }
        if(s.Notify_Party__c == null && s.Account_for__r.Notify_Party__c != null)
        {
            s.Notify_Party__c = s.Account_for__r.Notify_Party__c;
            cambio = true;
        }

        if(s.Supplier_Account__c != null)
        {
            if(s.Shipper__c == null && s.Supplier_Account__r.Shipper__c != null)
            {
                s.Shipper__c = s.Supplier_Account__r.Shipper__c;
                cambio = true;
            }
            if(s.Shipper_Contact__c == null && s.Supplier_Account__r.Shipper_Contact__c != null)
            {
                s.Shipper_Contact__c = s.Supplier_Account__r.Shipper_Contact__c;
                cambio = true;
            }
        }

        if(cambio)
        {
            list_update_shipments.add(s);
        }
    }
    if(!list_update_shipments.isEmpty())
    {
        update list_update_shipments;
    }

}
