trigger NEU_Shipment_Update_Conversions  on Shipment__c (after update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}		
	
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Shipment_Update_Conversions')){
        RecursiveCheck.triggerMonitor.add('NEU_Shipment_Update_Conversions');
        if(!Test.isRunningTest()){NEU_CurrencyUtils.headerAfterUpdate(new String[]{'Shipment_Line__c','Shipment_Fee_Line__c'},new String[]{'Shipment__c','Shipment__c'},trigger.new,trigger.newMap,trigger.oldMap);}   
    }    
}