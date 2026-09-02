trigger NEU_Update_Shipment_Locations on Shipment__c (before update) {
    
/*  if(NEU_StaticVariableHelper.getBoolean1() ||  System.isFuture() == true)
        return; 
    
  for(Shipment__c s:trigger.new)
    {
      Shipment__c o=Trigger.oldMap.get(s.ID);
      if(s.Origin_Address__c!=o.Origin_Address__c)
      {
        s.Origin_Location__Latitude__s=null;
        s.Origin_Location__Longitude__s=null;
      }
      if(s.Destination_Address__c!=o.Destination_Address__c)
      {
        s.Destination_Location__Latitude__s=null;
        s.Destination_Location__Longitude__s=null;
      }
    }*/
}