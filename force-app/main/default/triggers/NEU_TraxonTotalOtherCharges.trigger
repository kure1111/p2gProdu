trigger NEU_TraxonTotalOtherCharges on Waybill_Other_Charge__c (after insert, after update, before delete) 
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;
        
    if(trigger.isInsert)
    {
    	set<Id> ids_waybill = new set<Id>();
    	
    	for(Waybill_Other_Charge__c woc : trigger.new)
    	{
    		ids_waybill.add(woc.Waybill__c);    		
    	}
    	
    	List<Air_Waybill__c> air_waybill = [select Id, Name, Total_Other_Charges_Due_Agent__c, Total_Other_Charges_Due__c from Air_Waybill__c where Id IN : ids_waybill];
    	List<Waybill_Other_Charge__c> charges = [select Id, Name, Charge_Amount__c, Other_Charge_Rate__c, Recipient_of_Charge_Amount__c, Waybill__c 
    	from Waybill_Other_Charge__c where Waybill__c IN : ids_waybill];
    	
    	for(Air_Waybill__c w : air_waybill)
    	{
    		w.Total_Other_Charges_Due_Agent__c = 0;
    		w.Total_Other_Charges_Due__c = 0;
    				
    		for(Waybill_Other_Charge__c c : charges)
    		{
    			if(w.Id == c.Waybill__c)
    			{
    				if(c.Recipient_of_Charge_Amount__c == 'A')
    					w.Total_Other_Charges_Due_Agent__c += (c.Charge_Amount__c != null ? c.Charge_Amount__c : 0);
    				if(c.Recipient_of_Charge_Amount__c == 'C')
    					w.Total_Other_Charges_Due__c += (c.Charge_Amount__c != null ? c.Charge_Amount__c : 0);
    			}
    		}
    	}
    	
    	update air_waybill;
    }
    
    if(trigger.isUpdate)
    {
        set<Id> ids_waybill = new set<Id>();
    	
    	for(Waybill_Other_Charge__c woc : trigger.new)
    	{
    		Waybill_Other_Charge__c old_woc = Trigger.oldMap.get(woc.Id);
    		
    		if(woc.Charge_Amount__c != old_woc.Charge_Amount__c || woc.Recipient_of_Charge_Amount__c != old_woc.Recipient_of_Charge_Amount__c)
    			ids_waybill.add(woc.Waybill__c);
    	}
    	
    	List<Air_Waybill__c> air_waybill = [select Id, Name, Total_Other_Charges_Due_Agent__c, Total_Other_Charges_Due__c from Air_Waybill__c where Id IN : ids_waybill];
    	List<Waybill_Other_Charge__c> charges = [select Id, Name, Charge_Amount__c, Other_Charge_Rate__c, Recipient_of_Charge_Amount__c, Waybill__c 
    	from Waybill_Other_Charge__c where Waybill__c IN : ids_waybill];
    	
    	for(Air_Waybill__c w : air_waybill)
    	{
    		w.Total_Other_Charges_Due_Agent__c = 0;
    		w.Total_Other_Charges_Due__c = 0;
    				
    		for(Waybill_Other_Charge__c c : charges)
    		{
    			if(w.Id == c.Waybill__c)
    			{
    				if(c.Recipient_of_Charge_Amount__c == 'A')
    					w.Total_Other_Charges_Due_Agent__c += (c.Charge_Amount__c != null ? c.Charge_Amount__c : 0);
    				if(c.Recipient_of_Charge_Amount__c == 'C')
    					w.Total_Other_Charges_Due__c += (c.Charge_Amount__c != null ? c.Charge_Amount__c : 0);
    			}
    		}
    	}
    	
    	update air_waybill;
    }
    
    if(trigger.isDelete)
    {
        set<Id> ids_waybill = new set<Id>();
    	set<Id> ids_woc = new set<Id>();
    	
    	for(Waybill_Other_Charge__c woc : trigger.old)
    	{
    		ids_woc.add(woc.Id);
    		ids_waybill.add(woc.Waybill__c);
    	}
    	
    	List<Air_Waybill__c> air_waybill = [select Id, Name, Total_Other_Charges_Due_Agent__c, Total_Other_Charges_Due__c from Air_Waybill__c where Id IN : ids_waybill];
    	List<Waybill_Other_Charge__c> charges = [select Id, Name, Charge_Amount__c, Other_Charge_Rate__c, Recipient_of_Charge_Amount__c, Waybill__c 
    	from Waybill_Other_Charge__c where Waybill__c IN : ids_waybill and Id NOT IN : ids_woc];
    	
    	for(Air_Waybill__c w : air_waybill)
    	{
    		w.Total_Other_Charges_Due_Agent__c = 0;
    		w.Total_Other_Charges_Due__c = 0;
    				
    		for(Waybill_Other_Charge__c c : charges)
    		{
    			if(w.Id == c.Waybill__c)
    			{
    				if(c.Recipient_of_Charge_Amount__c == 'A')
    					w.Total_Other_Charges_Due_Agent__c += (c.Charge_Amount__c != null ? c.Charge_Amount__c : 0);
    				if(c.Recipient_of_Charge_Amount__c == 'C')
    					w.Total_Other_Charges_Due__c += (c.Charge_Amount__c != null ? c.Charge_Amount__c : 0);
    			}
    		}
    	}
    	
    	update air_waybill;
    }
}