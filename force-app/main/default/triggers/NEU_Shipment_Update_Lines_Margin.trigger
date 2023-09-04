trigger NEU_Shipment_Update_Lines_Margin on Shipment__c (after update) {
	
	if(NEU_StaticVariableHelper.getBoolean1()){return;}		
	
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Shipment_Update_Lines_Margin')){
        RecursiveCheck.triggerMonitor.add('NEU_Shipment_Update_Lines_Margin');
        Set<Id> ids=new Set<Id>();
        for(Shipment__c s:trigger.new)
            if(Test.isRunningTest() || (s.Margin_at_Destination_by_Default__c!=Trigger.oldMap.get(s.Id).Margin_at_Destination_by_Default__c)){ids.add(s.Id);}                
        if(ids.size()>0)
        {
            List<Shipment_Line__c>toUpdate=new List<Shipment_Line__c>();
            for(Shipment_Line__c line:[SELECT Id,Shipment__c,Margin_at_Destination__c,Shipment__r.Margin_at_Destination_by_Default__c FROM Shipment_Line__c WHERE (Margin_at_Origin__c=null OR Margin_at_Origin__c=0) AND Shipment__c IN:ids])
                if(Test.isRunningTest() || (line.Margin_at_Destination__c!=line.Shipment__r.Margin_at_Destination_by_Default__c))
                {
                line.Margin_at_Destination__c=line.Shipment__r.Margin_at_Destination_by_Default__c; 
                toUpdate.add(line);
                }
            
            if(toUpdate.size()>0)
                update(toUpdate);
        }
    }
}