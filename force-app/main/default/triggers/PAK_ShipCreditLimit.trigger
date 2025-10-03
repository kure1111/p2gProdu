trigger PAK_ShipCreditLimit on Shipment_Fee_Line__c (before insert, before update) {
    
    if(Test.isRunningTest() || (!RecursiveCheck.triggerMonitor.contains('PAK_ShipCreditLimit'))){
        RecursiveCheck.triggerMonitor.add('PAK_ShipCreditLimit');
        
        if(Trigger.isInsert){
            //if(!Test.isRunningTest()){PAK_ShipCreditLimit.CalcularSaldo(Trigger.New);}
            //PAK_ShipCreditLimit.UpdateCarrier(Trigger.New); 
        }
        
        if(Trigger.isUpdate){
            //P2G_block.validateUpdate(Trigger.New);
            PAK_ShipCreditLimit.CalcularUpdate(Trigger.New, Trigger.oldMap);
            //P2G_synchronizationSFSAP.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
            //PAK_ShipCreditLimit.CalcularUpdate(Trigger.new[0],Trigger.oldMap.get(Trigger.new[0].Id));
        }
        

    }
    
}