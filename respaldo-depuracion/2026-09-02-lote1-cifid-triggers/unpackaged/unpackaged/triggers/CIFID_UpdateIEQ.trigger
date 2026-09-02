trigger CIFID_UpdateIEQ on Import_Export_Fee_Line__c (after insert, after update, after delete) {
    /*if(NEU_StaticVariableHelper.getBoolean1())
    return;
    System.debug('CIFID_UpdateIEQ ***');
    Map<Id, Id> mapLineQuote = new Map<Id, Id>(); 
    Set<Id> idsLines = new Set<Id>();
    
    for(Import_Export_Fee_Line__c iefl : Trigger.isDelete ? Trigger.Old : Trigger.New){
        if(Trigger.isUpdate && !mapLineQuote.containsKey(iefl.Id) && 
           (Trigger.OldMap.get(iefl.Id).Service_Rate_Category__c != iefl.Service_Rate_Category__c || Trigger.OldMap.get(iefl.Id).Service_Rate_Name__c != iefl.Service_Rate_Name__c || 
            Trigger.OldMap.get(iefl.Id).Units__c != iefl.Units__c || Trigger.OldMap.get(iefl.Id).Quote_Sell_Price__c != iefl.Quote_Sell_Price__c || 
            Trigger.OldMap.get(iefl.Id).Sell_Amount__c != iefl.Sell_Amount__c || Trigger.OldMap.get(iefl.Id).Quote_Buy_Price__c != iefl.Quote_Buy_Price__c || Trigger.OldMap.get(iefl.Id).Buy_Amount__c != iefl.Buy_Amount__c || 
            Trigger.OldMap.get(iefl.Id).Carrier__c != iefl.Carrier__c)){
                mapLineQuote.put(iefl.Id, iefl.Import_Export_Quote__c);
            }else if(!mapLineQuote.containsKey(iefl.Id)){
                mapLineQuote.put(iefl.Id, iefl.Import_Export_Quote__c);
            }
    }
    System.debug('CIFID_UpdateIEQ *** idsLines : ' + mapLineQuote.keySet());
    
    for(Customer_Quote__c q : [SELECT Id, Impak_Request__c, IMPAK__c FROM Customer_Quote__c WHERE Id IN:mapLineQuote.values()]){
        for(Id idLine : mapLineQuote.keySet()){
            if((q.Impak_Request__c || q.IMPAK__c == 'Si') && mapLineQuote.get(idLine) == q.Id && !idsLines.contains(idLine)){
                idsLines.add(idLine);
            }
        }
    }
    
    System.debug('CIFID_UpdateIEQ *** idsLines impak: ' + idsLines);
    
    if(Trigger.isInsert){     
        System.debug('CIFID_UpdateIEQ *** isInsert');
        if(idsLines.size()>0 && Cifid_SendUpdateIeq.firstRun){
            Cifid_SendQuoteLines.firstRun = false;
            Cifid_SendQuoteLines.send(idsLines, 1);
        }
    }
    if(Trigger.isUpdate){
        System.debug('CIFID_UpdateIEQ *** isUpdate');
        if(idsLines.size()>0 && Cifid_SendUpdateIeq.firstRun){
            Cifid_SendQuoteLines.firstRun = false;
            Cifid_SendQuoteLines.send(idsLines, 2);
        }
    }
    if(Trigger.isDelete){
        System.debug('CIFID_UpdateIEQ *** isDelete');
        if(idsLines.size()>0 && Cifid_SendUpdateIeq.firstRun){
            System.debug('CIFID_UpdateIEQ *** Sent');
            Cifid_SendQuoteLines.firstRun = false;
            Cifid_SendQuoteLines.send(idsLines, 3);
        }
    }*/
}