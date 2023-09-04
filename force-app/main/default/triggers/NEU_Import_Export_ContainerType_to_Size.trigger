trigger NEU_Import_Export_ContainerType_to_Size on Customer_Quote__c (before insert, before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}		
	
  if(!RecursiveCheck.triggerMonitor.contains('NEU_Import_Export_ContainerType_to_Size')){
    RecursiveCheck.triggerMonitor.add('NEU_Import_Export_ContainerType_to_Size');
    Set<String>names=new Set<String>();
    for(Customer_Quote__c s : trigger.new)
      if(s.Container_Type__c == null && String.IsNotEmpty(s.Container_Size__c))
          names.add(s.Container_Size__c);
    if(names.size()>0)
    {
        Map<String,Id>cs=new Map<String,Id>();
        for(Container_Type__c c:[select Id, Name from Container_Type__c where Name IN:names])
          cs.put(c.Name,c.Id);
        for(Customer_Quote__c s : trigger.new)
        {
          if(s.Container_Type__c == null && String.IsNotEmpty(s.Container_Size__c))
              s.Container_Type__c=cs.get(s.Container_Size__c);
        }
    }
  }
}