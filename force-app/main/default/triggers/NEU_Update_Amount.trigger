trigger NEU_Update_Amount on Import_Export_Discount_Line__c (after insert,after update)
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return;

	List<Id>ids=new List<Id>();
    for(Import_Export_Discount_Line__c s:trigger.new)
    	if(s.Amount_copy__c!=s.Amount__c)
	    	ids.add(s.Id);
    if(ids.size()>0)
    {
	    List<Import_Export_Discount_Line__c>toUpdate=[select Id,Amount_copy__c,Amount__c from Import_Export_Discount_Line__c where Id IN:ids];
	    for(Import_Export_Discount_Line__c s:toUpdate)
	    	s.Amount_copy__c=s.Amount__c;
		update toUpdate;
    }
}