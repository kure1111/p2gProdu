trigger NEU_Waybill_Master on Waybill_Master__c (before insert, before update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
        return;
        
	if(trigger.isUpdate == true)
	{
		for(Waybill_Master__c wbm:trigger.new)
		{
			Waybill_Master__c old_wbm = Trigger.oldMap.get(wbm.Id);
			if(old_wbm.Count__c > wbm.Count__c || old_wbm.Starting_Number__c != wbm.Starting_Number__c)
				wbm.addError('This field is read only');
		}
	}
	if(trigger.isInsert == true)
	{
		List<Waybill_Master__c> master = [SELECT Id, Airline__c, Starting_Number__c, Recycle__c FROM Waybill_Master__c];
		
		for(Waybill_Master__c wbm : trigger.new)
		{
			for(Waybill_Master__c m : master)
			{
				if(m.Airline__c == wbm.Airline__c && m.Starting_Number__c == wbm.Starting_Number__c && !m.Recycle__c)
					wbm.addError('The Waybill Master already exists');
			}
		}
	}
}