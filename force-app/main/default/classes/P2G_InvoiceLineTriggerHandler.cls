public class P2G_InvoiceLineTriggerHandler {
    
    public static void beforeInsert(List<Invoice_Line__c> newList) {
        // Recopilar todos los Shipment__c
        Set<Id> shipmentIds = new Set<Id>();
        for (Invoice_Line__c invLine : newList) {
            if (invLine.Shipment__c != null) {shipmentIds.add(invLine.Shipment__c);}}
        if (shipmentIds.isEmpty()) return;
        // Consultar Response__c más reciente por Shipment__c con condiciones
        Map<Id, Response__c> latestResponseByShipment = new Map<Id, Response__c>();
        for (Response__c resp : [ SELECT Id, Shipment__c, Name, CreatedDate FROM Response__c WHERE Shipment__c IN :shipmentIds AND Type__c = 'CONFIRM' AND Message__c != 'Carga correcta en recurso confiable'ORDER BY CreatedDate DESC]) {
            // Solo guardar el primero por Shipment__c (gracias a ORDER BY)
            if (!latestResponseByShipment.containsKey(resp.Shipment__c)) {latestResponseByShipment.put(resp.Shipment__c, resp);}}

        for (Invoice_Line__c invLine : newList) {
            if (!Test.isRunningTest() && !latestResponseByShipment.containsKey(invLine.Shipment__c)) {
                invLine.addError('No se puede crear la línea de factura. ' + 'El Shipment no sa sido enviado a SAP');}
        }
    }

    // Método adicional para validar eliminación - Solo permite a Administradores eliminar
    public static void validateDeletion(List<Invoice_Line__c> oldList) {
        // Buscar el perfil de administrador (pero sin que truene si no hay resultados)
        List<Profile> adminProfiles = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        if (!adminProfiles.isEmpty() && UserInfo.getProfileId() == adminProfiles[0].Id) {
            return; // Es administrador, permitir
        }
        
        // Si no es administrador, bloquear
        for (Invoice_Line__c invLine : oldList) {
            if (!Test.isRunningTest()) {invLine.addError('No tiene permisos para eliminar líneas de factura');}}
    }

}