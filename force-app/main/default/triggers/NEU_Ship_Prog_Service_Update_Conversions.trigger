trigger NEU_Ship_Prog_Service_Update_Conversions on Shipment_Program_Line__c (before insert, before update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    if(trigger.isInsert)
      NEU_CurrencyUtils.lineBeforeInsert('Shipment_Program__c','Shipments_Program__c',trigger.new);
    if(trigger.isUpdate)
      NEU_CurrencyUtils.lineBeforeUpdate('Shipment_Program__c','Shipments_Program__c',trigger.new,trigger.oldMap);
}