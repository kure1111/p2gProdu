trigger P2G_ImportExportServiceLineCurrency_Trigger on Import_Export_Fee_Line__c (after update) {
    P2G_ImpExpSerLinCurrency_Handler.updateCurrencyIsoCodeImpExpSerLin(Trigger.new,Trigger.oldMap);
}