trigger NEU_Air_Waybill_Line_Recalculate_CW on Air_Waybill_Line__c (before insert, before update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
        return;
        
    if(trigger.isUpdate == true || trigger.isInsert == true)
    {
    	Set<Id> list_waybill = new Set<Id>();
    	for(Air_Waybill_Line__c wb:trigger.new)
        	list_waybill.add(wb.Air_Waybill__c);
        	
        Air_Waybill__c awb = [SELECT Id, Total_Gross_Weight__c, Total_Volumetric_Weight__c 
        						FROM Air_Waybill__c WHERE Id IN : list_waybill];
    
    	for(Air_Waybill_Line__c line:trigger.new)
        {
        	if(awb.Total_Gross_Weight__c > awb.Total_Volumetric_Weight__c)
	    	{
	    		line.Chargeable_Weight__c = line.Gross_Weight__c.setScale(2);
	    	}
	    	else
	    	{
	    		line.Chargeable_Weight__c = line.Volumetric_Weight__c.setScale(2);
	    	}	    	 			
        }		 
    }
}