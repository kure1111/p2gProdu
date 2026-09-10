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
        Boolean sandbox = isSandbox();
        System.debug('Estatus, ¿es sandbox? '+sandbox);
        if (sandbox) {
            return true;
        } else {
            accountId = '0014T000005QxaZQAS';
        }
        Shipment__c shipment = [SELECT Id, Account_for__c, Account_for__r.Name FROM Shipment__c WHERE Id = :shipmentId LIMIT 1];
        return shipment.Account_for__c == accountId;
    }
    
    @AuraEnabled
    public static Boolean isSandbox(){
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
    @AuraEnabled
    public static void updateShipmentData(String shipmentId, List<String> datosOrigen, List<String> datosDestino) {
        if (String.isBlank(shipmentId)) return;
        
        try {
            String datosCombinadosOrigen = buildComposedString(datosOrigen, 'RFC DESTINATARIO:', 'DESTINATARIO:');
            String datosCombinadosDestino = buildComposedString(datosDestino, 'RFC Destino:', 'Razon Social:');
            
            Shipment__c shipmentToUpdate = new Shipment__c(
                Id = shipmentId,
                Datos_Carta_Porte__c = datosCombinadosOrigen,
                Datos_Carta_Porte_Destino__c = datosCombinadosDestino
            );
            update shipmentToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException('Error al actualizar el envío: ' + e.getMessage());
        }
    }
    
    private static String buildComposedString(List<String> datos, String prefijo1, String prefijo2) {
        if (datos == null || datos.isEmpty()) return '';
        
        List<String> parts = new List<String>();
        if (datos.size() > 0 && String.isNotBlank(datos[0])) {
            parts.add(prefijo1 + datos[0]);
        }
        if (datos.size() > 1 && String.isNotBlank(datos[1])) {
            parts.add(prefijo2 + datos[1]);
        }
        return String.join(parts, ',');
    }

    @AuraEnabled
    public static String getDatosCartaPorte(String shipmentId) {
        try {
            Shipment__c shipment = [SELECT Id, Datos_Carta_Porte__c FROM Shipment__c WHERE Id = :shipmentId];
            return shipment.Datos_Carta_Porte__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getDatosCartaPorteBoth(String shipmentId) {
        try {
            Shipment__c shipment = getShipment(shipmentId);
            Customer_Quote__c quote = getRelatedCustomerQuote(shipmentId);
            
            String origen = buildOrigenString(shipment.Datos_Carta_Porte__c, quote);
            String destino = buildDestinoString(shipment.Datos_Carta_Porte_Destino__c, quote);

            Map<String, String> result = new Map<String, String>();
            result.put('origen', origen);
            result.put('destino', destino);
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @TestVisible
    private static Shipment__c getShipment(String shipmentId) {
        return [SELECT Id, Datos_Carta_Porte__c, Datos_Carta_Porte_Destino__c
                FROM Shipment__c
                WHERE Id = :shipmentId
                LIMIT 1];
    }

    @TestVisible
    private static Customer_Quote__c getRelatedCustomerQuote(String shipmentId) {
        List<Customer_Quote__c> quotes = [SELECT Account_for__r.TAX_ID__c, Account_for__r.Name,
                                                 Client_of_Client__r.TAX_ID__c, Client_of_Client__r.Name
                                          FROM Customer_Quote__c
                                          WHERE Last_Shipment__c = :shipmentId
                                          LIMIT 1];
        if (!quotes.isEmpty()) {
            return quotes[0];
        }
        return null;
    }

    @TestVisible
    private static String buildOrigenString(String campoOrigenEnvio, Customer_Quote__c quote) {        
        if (String.isNotBlank(campoOrigenEnvio)) {
            return campoOrigenEnvio;
        }                
        if (quote != null) {
            String rfc = quote.Account_for__r.TAX_ID__c != null ? quote.Account_for__r.TAX_ID__c : '';
            String nombre = quote.Account_for__r.Name != null ? quote.Account_for__r.Name : '';
            return 'RFC DESTINATARIO:' + rfc + ',DESTINATARIO:' + nombre;
        }                
        return '';
    }

    @TestVisible    
    private static String buildDestinoString(String campoDestinoEnvio, Customer_Quote__c quote) {
        if (String.isNotBlank(campoDestinoEnvio)) {
            return campoDestinoEnvio;
        }        
        if (quote != null) {
            String rfc = quote.Client_of_Client__r.TAX_ID__c != null ? quote.Client_of_Client__r.TAX_ID__c : '';
            String razon = quote.Client_of_Client__r.Name != null ? quote.Client_of_Client__r.Name : '';
            return 'RFC Destino:' + rfc + ',Razon Social:' + razon;
        }
        
        return '';
    }
    
	@AuraEnabled
    public static Shipment__c getShipmentIsInverted(Id shipmentId){
        return [SELECT Id, isInverted__c FROM Shipment__c WHERE Id=:shipmentId];
    }
    
    @AuraEnabled
    public static void updateFieldIsInverted(Id shipmentId){
        Shipment__c getShipment= getShipmentIsInverted(shipmentId);       
        System.debug('getShipment '+ getShipment);
        if(getShipment!=null){  
            boolean flag = getShipment.isInverted__c;
            getShipment.isInverted__c= !flag;
            update getShipment;
        }        
    }
    
}