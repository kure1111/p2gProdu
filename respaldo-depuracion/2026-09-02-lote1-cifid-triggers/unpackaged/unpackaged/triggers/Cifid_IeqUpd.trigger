trigger Cifid_IeqUpd on Customer_Quote__c (after update) {
    /*if(NEU_StaticVariableHelper.getBoolean1())
    return;
    System.debug('CIFID_TRIGGER ****');
    Set<Id> ieqIds = new Set<Id>();
    for(Customer_Quote__c quote : Trigger.New){
        if(quote.Impak_Request__c && !ieqIds.contains(quote.Id) && 
           (Trigger.oldMap.get(quote.Id).Quotation_Status__c != quote.Quotation_Status__c || 
            Trigger.oldMap.get(quote.Id).Total_Services_Std_Buy_Amount_number__c != quote.Total_Services_Std_Buy_Amount_number__c || 
            Trigger.oldMap.get(quote.Id).Pricing_Executive__c != quote.Pricing_Executive__c || 
            Trigger.oldMap.get(quote.Id).Date_Pricing_responded__c != quote.Date_Pricing_responded__c || 
            Trigger.oldMap.get(quote.Id).External_Final_Client_WS__c != quote.External_Final_Client_WS__c)){
            ieqIds.add(quote.Id);
        }
    }
    System.debug('CIFID_TRIGGER ids **** ' + ieqIds);
    if(ieqIds.size()>0 && Cifid_SendUpdateIeq.firstRun){      
        Cifid_SendUpdateIeq.firstRun = false;
        Cifid_SendUpdateIeq.send(ieqIds);
    }*/
}