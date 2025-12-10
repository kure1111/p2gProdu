public class P2G_Validacion_Datos_CartaPorte {
    public class ShipmentWrapper {
        @AuraEnabled public String nameAccount;
        @AuraEnabled public String idAccount;
        @AuraEnabled public String addressDestination;
        @AuraEnabled public String idShipment;
        @AuraEnabled public String nameShipment;
    }
    
    @AuraEnabled
    public static Boolean getAccountByShipment(String shipmentId){
        String accountId;
        Boolean sandbox= isSandbox();
        System.debug('Estatus, ¿es sandbox? '+sandbox);
        if (sandbox) {
            accountId='001RL00000EVzAPYA1';
        }else{
            accountId='0014T000005QxaZQAS';
        }
        Shipment__c shipment = [SELECT Id, Account_for__c, Account_for__r.Name FROM Shipment__c WHERE Id=: shipmentId LIMIT 1];
        if (shipment.Account_for__c==accountId) {
            return true;
        }else{
            return false;
        }
        
    }
    
    @AuraEnabled
    public static Boolean isSandbox(){
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        return isSandbox;
    }    
    
    @AuraEnabled
    public static void updateShipmentData(String shipmentId, List<String> datos) {        
        if (datos != null && !datos.isEmpty() && String.isNotBlank(shipmentId)) {
            try {                
                List<String> parts = new List<String>();
                            
                if (datos.size() > 0 && String.isNotBlank(datos[0])) {
                    parts.add('RFC DESTINATARIO:' + datos[0]);
                }
                                
                if (datos.size() > 1 && String.isNotBlank(datos[1])) {
                    parts.add('DESTINATARIO:' + datos[1]);
                }
                                                                
                String datosCombinados = String.join(parts, ',');
                
                // Actualizar el registro
                Shipment__c shipmentToUpdate = new Shipment__c(
                    Id = shipmentId,
                    Datos_Carta_Porte__c = datosCombinados
                );
                
                update shipmentToUpdate;
            } catch (Exception e) {
                throw new AuraHandledException('Error al actualizar el envío: ' + e.getMessage());
            }
        }        
    }


    @AuraEnabled
    public static string getDatosCartaPorte(String shipmentId){
        try {
            Shipment__c shipment= [SELECT Id, Datos_Carta_Porte__c FROM Shipment__c WHERE Id=: shipmentId];
            return shipment.Datos_Carta_Porte__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    
}