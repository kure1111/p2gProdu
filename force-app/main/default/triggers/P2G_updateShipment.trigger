trigger P2G_updateShipment on Customer_Quote__c (after update) {
    List<Shipment__c> listShip = new List<Shipment__c>();
    for(Customer_Quote__c quote : trigger.new){
        if(quote.Last_Shipment__c != null){
            //se utilizo la clase test
            System.debug('Entra al trigger P2G_updateAddressShipment');
            P2G_updateShipmentInCustomerQuote.updateShipment(quote);
        }
    }
}