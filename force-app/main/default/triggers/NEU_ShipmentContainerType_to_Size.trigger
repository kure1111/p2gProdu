trigger NEU_ShipmentContainerType_to_Size on Shipment__c (before insert, before update)
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}

    if(!RecursiveCheck.triggerMonitor.contains('NEU_ShipmentContainerType_to_Size')){
     	RecursiveCheck.triggerMonitor.add('NEU_ShipmentContainerType_to_Size');
        // una sola query con todos los sizes pendientes (antes era una por registro)
        Set<String> sizes = new Set<String>();
        for(Shipment__c s : trigger.new)
  		{
            if(s.Container_Type__c == null && s.Container_Size__c != null)
            {
                sizes.add(s.Container_Size__c);
            }
        }
        if(sizes.size() > 0)
        {
            Map<String, Id> containerPorNombre = new Map<String, Id>();
            for(Container_Type__c ct : [select Id, Name from Container_Type__c where Name IN :sizes])
            {
                if(!containerPorNombre.containsKey(ct.Name))
                {
                    containerPorNombre.put(ct.Name, ct.Id);
                }
            }
            for(Shipment__c s : trigger.new)
            {
                if(s.Container_Type__c == null && s.Container_Size__c != null && containerPorNombre.containsKey(s.Container_Size__c))
                {
                    s.Container_Type__c = containerPorNombre.get(s.Container_Size__c);
                }
            }
        }
    }
}
