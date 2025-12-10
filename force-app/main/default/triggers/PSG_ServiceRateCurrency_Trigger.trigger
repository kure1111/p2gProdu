trigger PSG_ServiceRateCurrency_Trigger on Fee__c (after update) {
    P2G_ServiceRateCurrency_Handler.serviceRateCurrencyIsoCode(Trigger.new,Trigger.oldMap);
}