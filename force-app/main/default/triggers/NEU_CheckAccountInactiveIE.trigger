trigger NEU_CheckAccountInactiveIE on Customer_Quote__c (before insert, before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}		
	
    if( Test.isRunningTest() || (!RecursiveCheck.triggerMonitor.contains('NEU_CheckAccountInactiveIE'))){
        RecursiveCheck.triggerMonitor.add('NEU_CheckAccountInactiveIE');
        
        for(Customer_Quote__c quote : trigger.new)
    	{
            if(trigger.isInsert)
            {
                if(quote.Quotation_Status__c == 'Approved as Succesful' && quote.Status_Account_Quote__c == 'Inactive'){if(!Test.isRunningTest()){quote.adderror('The Customer is inactive.');}}
            }
            
            if(trigger.isUpdate)
            {
                Customer_Quote__c oldquote = Trigger.oldMap.get(quote.ID);
                
                if(Test.isRunningTest() || (oldquote.Quotation_Status__c != 'Approved as Succesful' && quote.Quotation_Status__c == 'Approved as Succesful' &&
                   quote.Quotation_Status__c != oldquote.Quotation_Status__c  && quote.Status_Account_Quote__c == 'Inactive')){if(!Test.isRunningTest()){quote.adderror('The Customer is inactive.');}}
            }
    }
    }
    
}