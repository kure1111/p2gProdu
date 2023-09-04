trigger NEU_ShipmentContainerType_to_Size on Shipment__c (before insert, before update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    if(!RecursiveCheck.triggerMonitor.contains('NEU_ShipmentContainerType_to_Size')){
     	RecursiveCheck.triggerMonitor.add('NEU_ShipmentContainerType_to_Size');
        for(Shipment__c s : trigger.new)
  		{            
            if(s.Container_Type__c == null && s.Container_Size__c != null)
            {
              List<Container_Type__c> containers = [select Id, Name from Container_Type__c where Name =: s.Container_Size__c];
              if(containers.size() > 0)
                s.Container_Type__c = containers[0].Id;
            }
        }
    }      
}