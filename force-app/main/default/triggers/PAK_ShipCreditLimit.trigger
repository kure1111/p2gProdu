trigger PAK_ShipCreditLimit on Shipment_Fee_Line__c (before insert, before update) {
    
    if(Test.isRunningTest() || (!RecursiveCheck.triggerMonitor.contains('PAK_ShipCreditLimit'))){
        RecursiveCheck.triggerMonitor.add('PAK_ShipCreditLimit');
        
        if(Trigger.isInsert){
            if(!Test.isRunningTest()){PAK_ShipCreditLimit.CalcularSaldo(Trigger.New);}
            //PAK_ShipCreditLimit.UpdateCarrier(Trigger.New); 
        }
        
        if(Trigger.isUpdate){
            if(!Test.isRunningTest()){PAK_ShipCreditLimit.CalcularUpdate(Trigger.New, Trigger.oldMap);} 
        }
    }
    
}