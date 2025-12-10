trigger P2G_ShipmentServiceLineCurrency_Trigger on Shipment_Fee_Line__c (after update) {
    P2G_SPSerLinCurrency_Handler.updateCurrencyIsoCodeShipmentSerLin(Trigger.new, Trigger.oldMap);
}