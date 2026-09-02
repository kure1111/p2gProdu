public class P2G_ConsolidatedRouteAssignment {
    public static void analyzeCustomerQuote(List<Customer_Quote__c> newCustomerQuote) {
        
        Set<Id> quoteIds = new Set<Id>();
        for (Customer_Quote__c quote : newCustomerQuote) {
            quoteIds.add(quote.Id);
        }
        
        if(quoteIds.isEmpty()) {
            return;
        }
        
        List<Customer_Quote__c> queriedQuotes = [
            SELECT Id, Name, Route__c, Country_ofLoad__r.Name, Country_ofDischarge__r.Name
            FROM Customer_Quote__c
            WHERE Id IN :quoteIds
        ];
        
        Set<Id> routeIds = getRouteIds(queriedQuotes);
        
        if (routeIds.isEmpty()){
            return;
        }
        
        Map<Id, Carrier_Line_Load_Point__c> routeMap = getRoutesWithoutConsolidated(routeIds);
        
        if(routeMap.isEmpty()){
            return;
        }
        
        Map<String, Consolidated_Route__c> existingConsolidatedRoutes = getExistingConsolidatedRoutes(routeMap);
        
        Map<Id, Consolidated_Route__c> consolidatedByRoute = resolveConsolidatedRoutes(routeMap, existingConsolidatedRoutes);
        
        insertNewConsolidatedRoutes(consolidatedByRoute);
        
        updateRoutes(consolidatedByRoute);
        
    }
    // Obtener Route__c Id del IEQO creado    
    private static Set<Id> getRouteIds(List<Customer_Quote__c> customerQuotes) {
        Set<Id> routeIds = new Set<Id>();
        
        for(Customer_Quote__c customerQuote : customerQuotes) {
            if (customerQuote.Route__c != null && 
                customerQuote.Name.startsWith('FN') && 
                customerQuote.Country_ofLoad__r.Name == 'Mexico' && 
                customerQuote.Country_ofLoad__c != null &&
                customerQuote.Country_ofDischarge__r.Name == 'Mexico' &&
                customerQuote.Country_ofDischarge__c != null) {

                	routeIds.add(customerQuote.Route__c);
            }
        }
        return routeIds;
    }
    // consulta la ruta y guarda las que no tienen ruta consolidada
    private static Map<Id, Carrier_Line_Load_Point__c> getRoutesWithoutConsolidated (Set<Id> routeIds) {
        return new Map<Id,Carrier_Line_Load_Point__c> ([
            SELECT Id, Name, Port_Airport_of_Load__c, Port_Airport_of_Discharge__c, ConsolidatedRouteName__c FROM Carrier_Line_Load_Point__c WHERE Id IN :routeIds AND ConsolidatedRouteName__c = null
        ]);
    }

    // Buscar en el catalogo de ruta consolidada si existe una con el mismo nombre de route__c
    private static Map<String, Consolidated_Route__c> getExistingConsolidatedRoutes(Map<Id, Carrier_Line_Load_Point__c> routeMap) {
        Set<String> routeNames = new Set<String>();
        
        for (Carrier_Line_Load_Point__c route : routeMap.values()) {
            if(!String.isBlank(route.Name)) {
                routeNames.add(route.Name);
            }
        }
        Map<String, Consolidated_Route__c> consolidatedRouteByName = new Map<String, Consolidated_Route__c>();
        
        if (routeNames.isEmpty()) {
            return consolidatedRouteByName;
        }
        
        for (Consolidated_Route__c consolidated : [SELECT Id,Name, SiteOfLoad__c, SiteOfDischarge__c FROM Consolidated_Route__c WHERE Name IN :routeNames]) {
            consolidatedRouteByName.put(consolidated.Name, consolidated);
        }
    	return consolidatedRouteByName;
    }

    // Si no tiene ruta consolidada el Route__c, crear una nueva a partir del nombre de route__c y asignarla
    private static Map<Id,Consolidated_Route__c> resolveConsolidatedRoutes(
        Map<Id,Carrier_Line_Load_Point__c> routeMap, Map<String, Consolidated_Route__c> existingConsolidatedRoutes) {
            
            Map<Id, Consolidated_Route__c> consolidatedRoutes = new Map<Id,Consolidated_Route__c>();
            Map<String,Consolidated_Route__c> newConsolidatedRouteByName = new Map<String,Consolidated_Route__c>();
            
            for (Carrier_Line_Load_Point__c route : routeMap.values()) {
                if (String.isBlank(route.Name)) {
                    continue; //A;adir debug log o error
                }
                if (existingConsolidatedRoutes.containsKey(route.Name)) {
                    consolidatedRoutes.put(route.Id,existingConsolidatedRoutes.get(route.Name));
                    continue;
                }
                
                if(newConsolidatedRouteByName.containsKey(route.Name)) {
                    consolidatedRoutes.put(route.Id, newConsolidatedRouteByName.get(route.Name));
                    continue;
                }
                Consolidated_Route__c newConsolidatedRoute = new Consolidated_Route__c(
                    Name = route.Name,
                    SiteOfLoad__c = route.Port_Airport_of_Load__c, 
                    SiteOfDischarge__c = route.Port_Airport_of_Discharge__c
                );
                
                newConsolidatedRouteByName.put(route.Name, newConsolidatedRoute);
                consolidatedRoutes.put(route.Id, newConsolidatedRoute);
            }
            return consolidatedRoutes;
        }
        
    private static void insertNewConsolidatedRoutes(Map<Id, Consolidated_Route__c> consolidatedRouteNames) {
        Map<String, Consolidated_Route__c> newConsolidatedByName = new Map<String, Consolidated_Route__c>();
        
        for(Consolidated_Route__c consolidated :consolidatedRouteNames.values()){
            if(consolidated.Id == null) {
                newConsolidatedByName.put(consolidated.Name, consolidated);
            }
        }
        if (!newConsolidatedByName.isEmpty()) {
            insert newConsolidatedByName.values();
        }
    }
    
    private static void updateRoutes(Map<Id, Consolidated_Route__c> consolidatedByRoute) {
		// actualizar rutas con la ruta consolidada creada
		List<Carrier_Line_Load_Point__c> routesToUpdate = new List<Carrier_Line_Load_Point__c>();
        
        for(Id routeId : consolidatedByRoute.keySet()) {
            Consolidated_Route__c consolidatedRoute = consolidatedByRoute.get(routeId);
            
            Carrier_Line_Load_Point__c routeToUpdate = new Carrier_Line_Load_Point__c(Id = routeId, ConsolidatedRouteName__c = consolidatedRoute.Id);
            
            routesToUpdate.add(routetoUpdate);
        }
        if (!routesToUpdate.isEmpty()) {
            update routesToUpdate;
        }
    }
}