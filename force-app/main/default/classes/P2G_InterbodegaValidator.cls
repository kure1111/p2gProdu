public class P2G_InterbodegaValidator {
    public static void main (List<Shipment__c> shipments){
        Set<Id> shipmentsId = new Set<Id>();
        for(Shipment__c ships : shipments) {
            shipmentsId.add(ships.Id);
        }
        List<Shipment__c> queryShipments = [SELECT Id, Account_for__c, Account_Origin_Address__c, Account_Destination_Address__c, Interbodegas__c FROM Shipment__c WHERE id IN :shipmentsId];

        Set<Id> matches = verifyAdresses(queryShipments);

        List<Shipment__c> shipmentsToUpdate = new List<Shipment__c>();

        for (Shipment__c shipment : queryShipments){
            if(matches.contains(shipment.Id)) {
                shipment.Interbodegas__c = true;
                shipmentsToUpdate.add(shipment);
            }
        }
        if(!shipmentsToUpdate.isEmpty()) {
            update shipmentsToUpdate;
        }
    }

    // El catalogo vive en Interbodega_Ruta__c (antes hardcodeado aqui):
    // un renglon con origen+destino marca esa ruta exacta; un renglon
    // "Toda la cuenta" marca cualquier viaje de la cuenta.
    private static Set<Id> verifyAdresses(List<Shipment__c> shipments) {
        Set<String> rutas = new Set<String>();
        Set<Id> cuentasCompletas = new Set<Id>();
        for (Interbodega_Ruta__c regla : [SELECT Cuenta__c, Origen__c, Destino__c, Toda_La_Cuenta__c FROM Interbodega_Ruta__c WHERE Activa__c = true]) {
            if (regla.Toda_La_Cuenta__c) {
                cuentasCompletas.add(regla.Cuenta__c);
            } else {
                rutas.add(regla.Cuenta__c + '|' + regla.Origen__c + '|' + regla.Destino__c);
            }
        }

        Set<Id> shipmentsFound = new Set<Id>();
        for (Shipment__c shipment : shipments) {
            String currentInfo = shipment.Account_for__c + '|' + shipment.Account_Origin_Address__c + '|' + shipment.Account_Destination_Address__c;
            if (cuentasCompletas.contains(shipment.Account_for__c) || rutas.contains(currentInfo)){
                shipmentsFound.add(shipment.Id);
            }
        }
        return shipmentsFound;
    }

}
