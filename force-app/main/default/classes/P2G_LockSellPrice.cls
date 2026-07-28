public class P2G_LockSellPrice {
    public static void  validateSellPriceLock(List<Shipment_Fee_Line__c> newServiceLines, Map<Id, Shipment_Fee_Line__c>  oldMap) {
        Set<Id> shipmentIds = new Set<Id>();
        Set<Id> serviceRateIds = new Set<Id>();
		        
        for (Shipment_Fee_Line__c newServiceLine : newServiceLines)  {
            Shipment_Fee_Line__c oldServiceLines = oldMap.get(newServiceLine.Id);
            
            if (newServiceLine.Shipment__c != null && newServiceLine.Shipment_Sell_Price__c != oldServiceLines.Shipment_Sell_Price__c) {
                    shipmentIds.add(newServiceLine.Shipment__c);
                
                if (newServiceLine.Service_Rate_Name__c != null) {
                    serviceRateIds.add(newServiceLine.Service_Rate_Name__c);
            	}
			}
        }
        
        if (shipmentIds.isEmpty() || serviceRateIds.isEmpty()) {
            return;
        }
        
        Map<Id, Shipment__c> shipmentMap = new Map<Id, Shipment__c>(
        [
            SELECT Id, Account_for__c, Account_for__r.Bloqueo_Tarifario__c 
            FROM Shipment__c 
            WHERE Id IN :shipmentIds
        ]  
        );
        System.debug('shipmentMap: ' + shipmentMap);
        
        Map<Id, Fee__c> serviceRateMap = new Map<Id, Fee__c>(
        [
            SELECT Id, Name, Route__c, Route__r.Name, SAP_Service_Type__c, Account_for__c
            FROM Fee__c 
            WHERE Id IN :serviceRateIds
        ]
        );
		System.debug('ServiceRateMap: ' + serviceRateMap);
		        
        Set<Id> routeIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        for (Fee__c serviceRate : serviceRateMap.values()) {
            if (serviceRate.Route__c != null) {
                routeIds.add(serviceRate.Route__c);
            }
            
            if(serviceRate.Account_for__c != null) {
                accountIds.add(serviceRate.Account_for__c);
            }
        }
        System.debug('set de Route Ids: '+ routeIds);
		System.debug('set de Account Ids: '+ accountIds);
        
        if(routeIds.isEmpty() || accountIds.isEmpty()) {
            return;
        }
        
        Map<Id,Set<Id>> accountAndRoutes = new Map<Id, Set<Id>>();

        for (Fee__c tarifarioOriginal : [
            SELECT Id, Name, Route__c, Account_for__c, Valid_Until__c, CustomRate__c
            FROM Fee__c
            WHERE Route__c IN :routeIds AND Account_for__c IN :accountIds AND CustomRate__c = true AND Valid_Until__c >= TODAY
        ]) {
            if (!accountAndRoutes.containsKey(tarifarioOriginal.Route__c)) {
                accountAndRoutes.put(tarifarioOriginal.Route__c, new Set<Id>());
            }
            accountAndRoutes.get(tarifarioOriginal.Route__c).add(tarifarioOriginal.Account_for__c);
        }
        System.debug('Mapa accounts y routes: ' + accountAndRoutes);
        
		for (Shipment_Fee_Line__c newServiceLine : newServiceLines)  {
            Shipment_Fee_Line__c oldServiceLines = oldMap.get(newServiceLine.Id);
            
            Shipment__c shipment = shipmentMap.get(newServiceLine.Shipment__c);
            Fee__c serviceRate = serviceRateMap.get(newServiceLine.Service_Rate_Name__c);
            
            Boolean accountHasBloqueoTarifario = 
                shipment != null &&
                shipment.Account_for__c != null &&
                shipment.account_for__r.Bloqueo_tarifario__c == true;
            System.debug('accountHasBloqueoTarifario: ' + accountHasBloqueoTarifario);
            
            Boolean routeHasTarifario = 
                serviceRate != null &&
                serviceRate.Route__c != null &&
                serviceRate.Account_for__c !=null &&
                (newServiceLine.SAP_Service_Type__c  == 'FLETE NACIONAL (IC) (FN)' || newServiceLine.SAP_Service_Type__c  == 'SERVICIOS LOGISTICOS NACIONALES FN (IC) (FN)') &&
				accountAndRoutes.containsKey(serviceRate.Route__c) &&
                accountAndRoutes.get(serviceRate.Route__c).contains(serviceRate.Account_for__c);
            System.debug('routeHasTarifario: ' + routeHasTarifario);

            if(accountHasBloqueoTarifario && routeHasTarifario) {
                newServiceLine.Shipment_Sell_Price__c.addError('No es posible modificar el Precio de Venta de un Tarifario.');
            }
        }
    }
}