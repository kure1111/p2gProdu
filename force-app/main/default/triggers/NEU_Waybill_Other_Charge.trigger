trigger NEU_Waybill_Other_Charge on Waybill_Other_Charge__c (before insert, before update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
  		return;
  		
    if(trigger.isUpdate == true || trigger.isInsert == true)
    {
    	Set<Id> list_waybill = new Set<Id>();
    	for(Waybill_Other_Charge__c wb:trigger.new)
        	list_waybill.add(wb.Waybill__c);

    	Air_Waybill__c awb = [SELECT Id, Total_Chargeable_Weight__c FROM Air_Waybill__c WHERE Id IN : list_waybill];
    	for(Waybill_Other_Charge__c aoc:trigger.new)
        {
        	if(aoc.Other_Charge_Rate__c != 0)
        		aoc.Charge_Amount__c=awb.Total_Chargeable_Weight__c*aoc.Other_Charge_Rate__c;
        }
    }
}