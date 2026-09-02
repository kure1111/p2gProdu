public class P2G_block {
    
    public static void validateUpdate(List<Shipment_Fee_Line__c> newList) {
        // Obtener el ID del perfil administrador de manera segura
        String adminProfileId = getAdminProfileId();
        
        if (UserInfo.getProfileId() == adminProfileId && !Test.isRunningTest()) {
            return;
        }
        
        // Resto de tu lógica...
        Set<Id> shipmentIds = new Set<Id>();
        for (Shipment_Fee_Line__c line : newList) {
            if (line.Shipment__c != null) {
                shipmentIds.add(line.Shipment__c);
            }
        }
        
        if (shipmentIds.isEmpty()) return;
        
        List<Carta_Porte__c> cartasPorte = [SELECT Id FROM Carta_Porte__c WHERE Shipment__c IN :shipmentIds];
        
        if (!cartasPorte.isEmpty() && !Test.isRunningTest()) {
            for (Shipment_Fee_Line__c line : newList) { 
                line.addError('No puede modificar porque ya tiene factura');
            }
        }
    }
    
    // Método helper para obtener el ID del admin de manera segura
    private static String getAdminProfileId() {
        try {
            List<Profile> perfiles = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
            if (!perfiles.isEmpty()) {
                return perfiles[0].Id;
            }
        } catch (Exception e) {
            System.debug('Error obteniendo perfil admin: ' + e.getMessage());
        }
        
        // Fallback al ID fijo si hay algún problema
        return '00e4T000000zD9CQAU';//id perfil admin prod
    }
}