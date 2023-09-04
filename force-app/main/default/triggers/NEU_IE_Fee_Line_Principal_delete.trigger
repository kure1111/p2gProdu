trigger NEU_IE_Fee_Line_Principal_delete on Import_Export_Fee_Line__c(before delete) 
{
  if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    List<Import_Export_Fee_Line__c>toDelete= [select Id from Import_Export_Fee_Line__c where Rate_Type__c='% of Charge' and Import_Export_Service_Line__c IN: trigger.old];
    if(toDelete.size()>0)
        delete toDelete;
}