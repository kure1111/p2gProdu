public class P2G_ServiceRateCurrency_Handler {

    public static void serviceRateCurrencyIsoCode(List<Fee__c> newRecords, Map<Id, Fee__c> oldMap) {        
        // Mapa ServiceRate
        Map<Id, String> serviceRateIds = new Map<Id, String>();
        
        //IDs de los usuarios que realizaron modificaciones en los registros
        Set<String> userIds = new Set<String>();
      
      
        System.debug('New Records '+newRecords);
        System.debug('Old Map '+oldMap);
        for (Fee__c serviceRate : newRecords) {
            Fee__c oldRecord = oldMap.get(serviceRate.Id);            
            // Se verifica si el CurrencyIsoCode ha cambiado
            if (oldRecord != null && serviceRate.CurrencyIsoCode != oldRecord.CurrencyIsoCode) {
                userIds.add(serviceRate.LastModifiedById);
                serviceRateIds.put(serviceRate.Id, serviceRate.CurrencyIsoCode);
            }
        }
        System.debug('userIds '+userIds);
        
        if (serviceRateIds.isEmpty()) {
            System.debug('No hay registros con cambios en CurrencyIsoCode.');
            return;
        }
        
        Map<Id, User> users = new Map<Id, User>([
            SELECT Id, ProfileId 
            FROM User 
            WHERE Id IN :userIds limit 1
        ]);
        
        System.debug('Mapa de usuarios '+users);
        
        // Filtrado de registros modificados por un administrador
        Map<Id, String> filteredServiceRateIds = new Map<Id, String>();
        for (Fee__c serviceRate : newRecords) {
            Fee__c oldRecord = oldMap.get(serviceRate.Id);
            if (serviceRateIds.containsKey(serviceRate.Id)) {
                
                User modifiedByUser = users.get(serviceRate.LastModifiedById);
                System.debug('Información del usuario '+ modifiedByUser+'\nProfile '+modifiedByUser.ProfileId);
                //USER.GET PARA OBTENER LOS DATOS
                if (modifiedByUser != null && modifiedByUser.ProfileId == '00e4T000000zD9CQAU' 
                    && serviceRate.CurrencyIsoCode!=oldRecord.CurrencyIsoCode) {
                    filteredServiceRateIds.put(serviceRate.Id, serviceRate.CurrencyIsoCode);
                    System.debug('FilteredServuce Rate Ids '+ filteredServiceRateIds);
                }
            }
        }
        
        if (filteredServiceRateIds.isEmpty()) {
            System.debug('No hay registros modificados por un administrador.');
            return;
        }
        
        // Actualizar Shipment_Fee_Line__c
        List<Shipment_Fee_Line__c> spSLList = [
            SELECT Id, CurrencyIsoCode, Service_Rate_Name__c 
            FROM Shipment_Fee_Line__c 
            WHERE Service_Rate_Name__c IN :filteredServiceRateIds.keySet() limit 1
        ];
        
        List<Shipment_Fee_Line__c> spUpdate = new List<Shipment_Fee_Line__c>();
        for (Shipment_Fee_Line__c sp : spSLList) {
            if (sp.CurrencyIsoCode != filteredServiceRateIds.get(sp.Service_Rate_Name__c)) {
                sp.CurrencyIsoCode = filteredServiceRateIds.get(sp.Service_Rate_Name__c);
                spUpdate.add(sp);
            }
        }
        
        if (!spUpdate.isEmpty()) {
            update spUpdate;
        }
        
        // Actualizar Import_Export_Fee_Line__c
        List<Import_Export_Fee_Line__c> impExpSLList = [
            SELECT Id, CurrencyIsoCode, Service_Rate_Name__c 
            FROM Import_Export_Fee_Line__c 
            WHERE Service_Rate_Name__c IN :filteredServiceRateIds.keySet() limit 1
        ];
        
        List<Import_Export_Fee_Line__c> ieUpdate = new List<Import_Export_Fee_Line__c>();
        for (Import_Export_Fee_Line__c ieSL : impExpSLList) {
            if (ieSL.CurrencyIsoCode != filteredServiceRateIds.get(ieSL.Service_Rate_Name__c)) {
                ieSL.CurrencyIsoCode = filteredServiceRateIds.get(ieSL.Service_Rate_Name__c);
                ieUpdate.add(ieSL);
            }
        }
        
        if (!ieUpdate.isEmpty()) {
            update ieUpdate;
        }
    }  

}