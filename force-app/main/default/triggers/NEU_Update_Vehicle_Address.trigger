trigger NEU_Update_Vehicle_Address on Vehicle__c (before insert,before update) {

  if(NEU_StaticVariableHelper.getBoolean1())
    return;

  for(Vehicle__c s:trigger.new)
    {
      if(trigger.isInsert)
      {
        if((s.Last_Location__Longitude__s!=null)||(s.Last_Location__Latitude__s!=null))
        {
          s.Last_Location_Time__c=System.now();
          s.Last_Address__c=null;
        }
      }
      else if(trigger.isUpdate)
      {
        Vehicle__c o=Trigger.oldMap.get(s.ID);
        if((s.Last_Location__Longitude__s!=o.Last_Location__Longitude__s)||(s.Last_Location__Latitude__s!=o.Last_Location__Latitude__s))
        {
          s.Last_Location_Time__c=System.now();
          s.Last_Address__c=null;
        }
      }
    }
}