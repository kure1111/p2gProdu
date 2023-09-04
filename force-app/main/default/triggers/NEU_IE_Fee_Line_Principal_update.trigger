trigger NEU_IE_Fee_Line_Principal_update on Import_Export_Fee_Line__c(after update) {
	
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    Set<Id>itemids=new Set<Id>();
    for(Import_Export_Fee_Line__c line:trigger.new)
    {
        Import_Export_Fee_Line__c oldline=trigger.oldMap.get(line.Id);
        if((line.Sell_Amount__c != oldline.Sell_Amount__c)||(line.Quote_Buy_Price__c != oldline.Quote_Buy_Price__c))
            itemids.add(line.Id);
    }
    if(itemids.size()>0)
    {
        List<Import_Export_Fee_Line__c>charges=[select Id,Service_Rate__c,Quote_Buy_Price__c,Quote_Sell_Price__c,Import_Export_Service_Line__c from Import_Export_Fee_Line__c where Rate_Type__c='% of Charge' and Import_Export_Service_Line__c IN:itemids];
        if(charges.size()>0)
        {
            for(Import_Export_Fee_Line__c line:charges)
            {
                Import_Export_Fee_Line__c master=trigger.newMap.get(line.Import_Export_Service_Line__c);
                line.Quote_Sell_Price__c=NEU_Utils.safeDecimal(master.Sell_Amount__c)*NEU_Utils.safeDecimal(line.Service_Rate__c)/100;
                line.Quote_Buy_Price__c=NEU_Utils.safeDecimal(master.Buy_Amount__c)*NEU_Utils.safeDecimal(line.Service_Rate__c)/100;
            }
            update charges;
        }
    }
}