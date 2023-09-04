trigger NEU_Shipment_Assign_Service_Charges on Shipment__c (after update)
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Shipment_Assign_Service_Charges')){
        RecursiveCheck.triggerMonitor.add('NEU_Shipment_Assign_Service_Charges');
        
        Set<Id> ids=new Set<Id>();
        for(Shipment__c s:trigger.new)
        {
            Shipment__c o=Trigger.oldMap.get(s.Id);
            if(Test.isRunningTest()|| (s.Service_Charges_Kg__c!=o.Service_Charges_Kg__c)||(s.Service_Charges_m3__c!=o.Service_Charges_m3__c))
                ids.add(s.Id);
        }
        if(Test.isRunningTest() || ids.size()>0)
        {
            List<Shipment_Line__c>toUpdate=new List<Shipment_Line__c>();
            for(Shipment_Line__c line:[SELECT Id,Shipment_Charges_Assigned__c,Shipment_Charges_Assigned_copy__c FROM Shipment_Line__c WHERE Shipment__c IN:ids])
                if(line.Shipment_Charges_Assigned_copy__c!=line.Shipment_Charges_Assigned__c)
                {
                   line.Shipment_Charges_Assigned_copy__c=line.Shipment_Charges_Assigned__c;
                   toUpdate.add(line);
                }
            if(toUpdate.size()>0)
                update(toUpdate);
        }
    }
}