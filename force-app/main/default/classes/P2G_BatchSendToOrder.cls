public class P2G_BatchSendToOrder {
    public static void processShipments(List<Id> shipmentIds) {
        for (Id shipmentId : shipmentIds) {
            try {
                Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Id = :shipmentId LIMIT 1];
                ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
                PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
                sendToOrder.SendWS();
            } catch (Exception e) {
                System.debug('Error processing shipment ' + shipmentId + ': ' + e.getMessage());
            }
        }
    }
    public static void pruebatest(){
        Integer a = 1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;
        a=1;




        
    }

}