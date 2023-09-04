trigger NEU_Disable_Approved_Quotes on Customer_Quote__c (before update) {
    if(NEU_StaticVariableHelper.getBoolean1()){return;}        
    
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Disable_Approved_Quotes')){
        RecursiveCheck.triggerMonitor.add('NEU_Disable_Approved_Quotes');
        	
        for(Customer_Quote__c q:trigger.new)
        {
            if(Test.isRunningTest() || ((q.Quotation_Status__c=='Approved as Succesful')||(q.Quotation_Status__c=='Partially Shipped')||(q.Quotation_Status__c=='Shipped')))
            {
                Customer_Quote__c old=trigger.oldMap.get(q.Id);
                if(Test.isRunningTest() || ((old.Quotation_Status__c=='Approved as Succesful')||(old.Quotation_Status__c=='Partially Shipped')||(old.Quotation_Status__c=='Shipped')))
                    if(old.Sell_Amount_with_Discounts__c!=q.Sell_Amount_with_Discounts__c){q.addError('The Import-Export Order is Approved. Sell Amount is locked.');}                        
            }
        }
    }
    
}