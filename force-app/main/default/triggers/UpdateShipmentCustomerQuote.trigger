trigger UpdateShipmentCustomerQuote on Customer_Quote__c (after update) {    
    if(!RecursiveCheck.triggerMonitor.contains('UpdateShipmentCustomerQuote')){
        RecursiveCheck.triggerMonitor.add('UpdateShipmentCustomerQuote');
        if(trigger.isAfter && trigger.isUpdate){
        
            if(!CheckRecursive.firstCallUpdateShipmentCustomerQuote){
                
                system.debug('CheckRecursive cambio a true en UpdateShipmentCustomerQuote');
                CheckRecursive.firstCallUpdateShipmentCustomerQuote = true;            
                TriggerCustomerQuote.ActualizarShipment(Trigger.new);              
            }else{
                system.debug('No se ejecuta nada en UpdateShipmentCustomerQuote');
            }
        }
    }
}