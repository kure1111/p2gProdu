public class P2G_reenvioCartaPorte {
    @InvocableMethod
    public static void callSavePdf(List<Id> shipmentIds) {
        try {
            System.debug('shipmentIds: '+shipmentIds);
            for (Id shipmentId : shipmentIds) {
                ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Shipment__c WHERE Id = :shipmentId]);

                NEU_CartaPorteSavePDF cartaPorteSavePDF = new NEU_CartaPorteSavePDF(sc);

                cartaPorteSavePDF.crear();
            }
        } catch (Exception e) {
            System.debug('Error P2G_reenvioCartaPorte: ' + e.getMessage());
            //throw e;
        }
    }

}