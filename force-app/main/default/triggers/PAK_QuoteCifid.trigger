trigger PAK_QuoteCifid on Customer_Quote__c (after insert, after update) {
    /*if(NEU_StaticVariableHelper.getBoolean1())
    return;
    System.debug('PAK_QuoteCifid ***');
    Set<Id> idsQuote;
    
    if(Trigger.isInsert){
        System.debug('PAK_QuoteCifid *** Insert');
        idsQuote = new Set<Id>();
        for(Customer_Quote__c cq : trigger.New){
            if(cq.IMPAK__c != null && cq.IMPAK__c == 'Si' && !idsQuote.contains(cq.Id)){
                idsQuote.add(cq.Id);
            }
        }
        System.debug('PAK_QuoteCifid *** Ids: ' + idsQuote);
        if(idsQuote.size()>0 && PAK_SendquoteCifid.firstRun){
            PAK_SendquoteCifid.firstRun = false;
            PAK_SendquoteCifid.send(idsQuote);
        }
    }
    
    if(Trigger.isUpdate){
        System.debug('PAK_QuoteCifid *** Update');
        idsQuote = new Set<Id>();
        for(Customer_Quote__c cq : trigger.New){
            if(cq.IMPAK__c != null && cq.IMPAK__c == 'Si' && !idsQuote.contains(cq.Id) && 
               (Trigger.oldMap.get(cq.Id).Quotation_Status__c != cq.Quotation_Status__c || Trigger.oldMap.get(cq.Id).CurrencyIsoCode != cq.CurrencyIsoCode || Trigger.oldMap.get(cq.Id).Sales_Incoterm__c != cq.Sales_Incoterm__c || Trigger.oldMap.get(cq.Id).Freight_Mode__c != cq.Freight_Mode__c || Trigger.oldMap.get(cq.Id).Service_Mode__c != cq.Service_Mode__c || Trigger.oldMap.get(cq.Id).Service_Type__c != cq.Service_Type__c || Trigger.oldMap.get(cq.Id).Country_ofLoad__c != cq.Country_ofLoad__c || Trigger.oldMap.get(cq.Id).State_of_Load__c != cq.State_of_Load__c || 
                Trigger.oldMap.get(cq.Id).Site_of_Load__c != cq.Site_of_Load__c || Trigger.oldMap.get(cq.Id).ETD__c != cq.ETD__c || Trigger.oldMap.get(cq.Id).Origin_Address__c != cq.Origin_Address__c || Trigger.oldMap.get(cq.Id).Move_Type__c != cq.Move_Type__c || Trigger.oldMap.get(cq.Id).Country_ofDischarge__c != cq.Country_ofDischarge__c || Trigger.oldMap.get(cq.Id).State_of_Discharge__c != cq.State_of_Discharge__c || Trigger.oldMap.get(cq.Id).Site_of_Discharge__c != cq.Site_of_Discharge__c || Trigger.oldMap.get(cq.Id).ETA__c != cq.ETA__c || 
                Trigger.oldMap.get(cq.Id).Destination_Address__c != cq.Destination_Address__c || Trigger.oldMap.get(cq.Id).Trade_License__c != cq.Trade_License__c || Trigger.oldMap.get(cq.Id).Merchandise_has_being_paid__c != cq.Merchandise_has_being_paid__c || Trigger.oldMap.get(cq.Id).Service_Type_St__c != cq.Service_Type_St__c || Trigger.oldMap.get(cq.Id).Customer_Type__c != cq.Customer_Type__c || Trigger.oldMap.get(cq.Id).Account_for__c != cq.Account_for__c || Trigger.oldMap.get(cq.Id).Customs__c != cq.Customs__c || Trigger.oldMap.get(cq.Id).Merchandise_Insurance__c != cq.Merchandise_Insurance__c || 
                Trigger.oldMap.get(cq.Id).Workplace_Account_Owner__c != cq.Workplace_Account_Owner__c || Trigger.oldMap.get(cq.Id).Email_Account_Owner__c != cq.Email_Account_Owner__c || Trigger.oldMap.get(cq.Id).Final_Client_Pak__c != cq.Final_Client_Pak__c)){
                idsQuote.add(cq.Id);
            }
        }
        System.debug('PAK_QuoteCifid *** Ids: ' + idsQuote);
        if(idsQuote.size()>0 && PAK_SendquoteCifid.firstRun){
            PAK_SendquoteCifid.firstRun = false;
            PAK_SendquoteCifid.send(idsQuote);
        }
    }*/
}