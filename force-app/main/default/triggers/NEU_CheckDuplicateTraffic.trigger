trigger NEU_CheckDuplicateTraffic on Traffic__c (before insert)
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return;
	
	for(Traffic__c traffic : trigger.new)
	{
		traffic.Duplicate_Checker__c = '';
  		traffic.Duplicate_Checker__c += traffic.Account__c+''+traffic.Freight_Mode__c+''+traffic.Service_Type__c;
  		traffic.Duplicate_Checker__c += traffic.Container_Type__c+''+traffic.Service_Mode__c+''+traffic.Site_of_Load__c+''+traffic.Site_of_Discharge__c;
	}
}