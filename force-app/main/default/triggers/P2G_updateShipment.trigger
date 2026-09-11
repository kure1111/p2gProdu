trigger P2G_updateShipment on Customer_Quote__c (after update) {
    // una sola pasada en bloque; la clase filtra Last_Shipment__c != null
    // y omite el update cuando el Shipment ya tiene los mismos valores
    P2G_updateShipmentInCustomerQuote.updateShipments(trigger.new);
}
