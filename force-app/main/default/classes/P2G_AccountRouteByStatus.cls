public class P2G_AccountRouteByStatus {
    public class customerTypeGroups{
        public List<Opportunity> newCustomer = new List<Opportunity>();
		public List<Opportunity> recurrentCustomer = new List<Opportunity>();
        }
    
    public class wrapperAccountRoute{
        public String nameAcc {get; set;}
        public Id accId {get; set;}
        public String nameRoute {get; set;}
        public Id routeId {get; set;}
        public Integer countAccRoute {get; set;}
                
        public wrapperAccountRoute(){
            this.countAccRoute = 0;
        }
                
        public wrapperAccountRoute(String nameAcc, Id accId, String nameRoute, Id routeId){
            this.nameAcc = nameAcc;
            this.accId = accId;
            this.nameRoute = nameRoute;
            this.routeId = routeId;
            this.countAccRoute = 1;
        }
                
        public void incrementCount(){
            this.countAccRoute++;
        }
    }    
    
    /*
    public static List<Opportunity> getAccountsWithRoutes(){
        return [
            SELECT Id, Account.Name, AccountId, Import_Export_Quote_Order__r.Route__c,   
            Import_Export_Quote_Order__r.Route__r.Name, Account.Estatus_cuenta__c 
			FROM Opportunity
			WHERE Account.Estatus_cuenta__c IN ('Nuevo','Recurrente') AND Import_Export_Quote_Order__r.Route__r.Name != null
        ];
    }
	*/
    
    public static customerTypeGroups groupAccountsByCustomerStatus(List<Opportunity> listOpportunities){
        //List<Opportunity> accs = getAccountsWithRoutes();
        customerTypeGroups accountType = new customerTypeGroups();
        
        for (Opportunity opp : listOpportunities){
            if (opp.Account.Estatus_cuenta__c == 'Nuevo'){
                accountType.newCustomer.add(opp);
            } else if (opp.Account.Estatus_cuenta__c == 'Recurrente') {
                accountType.recurrentCustomer.add(opp);
            }
        }
        return accountType;
        }
    
    //Metodo para la obtencion de ids de las cuentas obtenidas de las oportunidades
    public static SET<Id> getAccountIds(List<Opportunity> listOpportunity){
        SET<Id> accountIds=new SET<Id>();
        for(Opportunity opp: listOpportunity){
            accountIds.add(opp.Account.Id);
        }        
        return accountIds;
    }
    
    
    //Metodo para la obtencion de RouteAccount por Account Id
    public static List<Route_by_Account__c> getRouteAccountsByAccountId(Set<Id> accountIds){        
        return [SELECT Id, Account__c, Route__c, Name 
                FROM Route_by_Account__c 
                WHERE Account__c IN :accountIds];

    }

    public static Map<String, Route_by_Account__c> generateRouteAccountExistKeyMap(List<Route_by_Account__c> listRouteAcc){
		Map<String, Route_by_Account__c> existingRoutesMap = new Map<String, Route_by_Account__c>();       
        for(Route_by_Account__c route : listRouteAcc){
                String key = route.Account__c + '_' + route.Route__c;
                existingRoutesMap.put(key, route);
       	} 
        return existingRoutesMap;
    }
    
    public static void upsertRouteAccount(List<Route_by_Account__c> routesToUpsert){
        Map<String, Route_by_Account__c> uniqueRoutes = new Map<String, Route_by_Account__c>();
        for(Route_by_Account__c route : routesToUpsert){
            String key = route.Account__c + '_' + route.Route__c;
            uniqueRoutes.put(key, route);
        }            
        try {
            System.debug('Upsert uniqueRoutes.values() '+uniqueRoutes.values());
            upsert uniqueRoutes.values();
            System.debug('Registros de Route_by_Account__c procesados para RECURRENTES: ' + uniqueRoutes.size());
        } catch (DmlException e) {
            System.debug('Error al guardar Route_by_Account__c: ' + e.getMessage());
        }
    }
    
    public static List<Opportunity> recentOpportunitiesByAccount(Set<Id> accountIds,Integer monthsToConsider){
        //obtenemos la fecha actual y tomamos en cuenta el número de meses a considerar
        DateTime startDate = System.now().addMonths(-monthsToConsider);
        return [ SELECT Id, AccountId, Account.Name, Import_Export_Quote_Order__r.Route__c,
                Import_Export_Quote_Order__r.Route__r.Name, CreatedDate
                FROM Opportunity
                WHERE AccountId IN :accountIds
                AND CreatedDate >= :startDate
                AND Import_Export_Quote_Order__r.Route__c != null
            ]; 
    }

    
    public static void getNewCustomerByRoute(List<Opportunity> listOppNewCustomers){
        List<Route_by_Account__c> routesToUpsert = new List<Route_by_Account__c>();
        Map<String, Route_by_Account__c> existingRoutesMap = new Map<String, Route_by_Account__c>();
        //Listado de ids de las Cuentas
        Set<Id> accountIds = getAccountIds(listOppNewCustomers);
                                
        List<Route_by_Account__c> listRouteAcc=new List<Route_by_Account__c>();
        
        if(!accountIds.isEmpty()){            
            listRouteAcc =getRouteAccountsByAccountId(accountIds); 
        }                        
        //Verificamos que haya registros existentes en el obj
        if(!listRouteAcc.isEmpty()){           
            existingRoutesMap=generateRouteAccountExistKeyMap(listRouteAcc);        	 
        }
                        
        for(Opportunity opp : listOppNewCustomers){               
            Id accountId = opp.Account.Id;
            Id routeId = opp.Import_Export_Quote_Order__r.Route__c;
            String key = accountId + '_' + routeId;
            
            if(existingRoutesMap.containsKey(key)){                    
                Route_by_Account__c existingRoute = existingRoutesMap.get(key);
                if(existingRoute.Name != 'Nuevo'){
                    existingRoute.Name = 'Nuevo';
                }                
                routesToUpsert.add(existingRoute);                    
			} else {                    
                Route_by_Account__c newRoute = new Route_by_Account__c();
                newRoute.Account__c = accountId;
                newRoute.Route__c = routeId;
                newRoute.Name = 'Nuevo';                                        
                routesToUpsert.add(newRoute); 
                //Agrega el nuevo registro con su llave y datos del nuevo objeto
                existingRoutesMap.put(key, newRoute);
           	}            
        }
        
        if(!routesToUpsert.isEmpty()){
            upsertRouteAccount(routesToUpsert);                       
        }
    }
    
        
    public static void getRecurrentAccountByRoute(List<Opportunity> listOppRecurrentCustomers){
        
        Map<Id, wrapperAccountRoute> mapRecurrentCustomer = new Map<Id, wrapperAccountRoute>();        
        
        //Listado de ids de las cuentas
        Set<Id> accountIds = getAccountIds(listOppRecurrentCustomers);
    	Map<String, Route_by_Account__c> existingRoutesMapbyAccRecurrent = new Map<String, Route_by_Account__c>();
    	List<Route_by_Account__c> routesToUpsert = new List<Route_by_Account__c>();                
        
        //Obtenemos la cantidad de meses a considerar
        Integer monthsToConsider = Integer.valueOf(System.Label.monthsToConsider);
		                
        if(!accountIds.isEmpty()){
            Map<Id, List<Opportunity>> opportunitiesByAccount = new Map<Id, List<Opportunity>>();  
            
            //Obtenemos el listado de Oportunidades recientes en base al custom label y los clientes obtenidos
            List<Opportunity> recentOpportunities = recentOpportunitiesByAccount(accountIds, monthsToConsider);

            if(!recentOpportunities.isEmpty()){
            	for(Opportunity opp : recentOpportunities){
                    if(opp.AccountId != null){
                        //Se revisa si existe una clave con el valor de esa cuenta
                        if(!opportunitiesByAccount.containsKey(opp.AccountId)){
                            //En caso de que no agrega el valor de la cuenta
                            opportunitiesByAccount.put(opp.AccountId, new List<Opportunity>());
                        }                    
                        //Se vincula a nuestro listado la oportunidad encontrada
                        opportunitiesByAccount.get(opp.AccountId).add(opp);
                    }
                }    
            }                        
            
            //Obtenemos el listado de las cuentas con rutas existentes
            List<Route_by_Account__c> listRouteAccExist = getRouteAccountsByAccountId(accountIds);            
            
            for(Route_by_Account__c routeAcc : listRouteAccExist){
                //se valida que los campos de ruta y cuenta no esten vacios
                if(routeAcc.Account__c != null && routeAcc.Route__c != null){
                    //se crea un key con los ids obtenidos
                    String key = routeAcc.Account__c + '_' + routeAcc.Route__c;
                    //se agrega en el mapa el identificador y el registro obtenido
                    existingRoutesMapbyAccRecurrent.put(key, routeAcc);
                }
        	}
                       
            for(Opportunity opp : listOppRecurrentCustomers){                    
                Id accountId = opp.Account.Id;
                String nameAcc= opp.Account.Name;
                Id routeId = opp.Import_Export_Quote_Order__r.Route__c;
                String routeName = opp.Import_Export_Quote_Order__r.Route__r.Name;
                String key = accountId + '_' + routeId;                                       
                
                Boolean isRecurrent = false;
                
                if(opportunitiesByAccount.containsKey(accountId)){
                    // Contar oportunidades de esta cuenta con la misma ruta en el período
                    Integer countInPeriod = 0;
                    for(Opportunity recentOpp : opportunitiesByAccount.get(accountId)){
                        if(recentOpp.Import_Export_Quote_Order__r.Route__c == routeId &&
                           recentOpp.Id != opp.Id){
                            countInPeriod++;
                        }
                    }
                                
                    if(countInPeriod > 0){
                        isRecurrent = true;
                    }
            	}
                                
                if(mapRecurrentCustomer.containsKey(accountId)){
                    wrapperAccountRoute wrap = mapRecurrentCustomer.get(accountId);
                    wrap.incrementCount();
                } else {
                    wrapperAccountRoute newWrapper = new wrapperAccountRoute(
                        nameAcc,
                        accountId,
                        routeName,
                        routeId
                    );
                    mapRecurrentCustomer.put(accountId, newWrapper);
                }
                                
                if(existingRoutesMapbyAccRecurrent.containsKey(key)){                    
                    Route_by_Account__c existingRoute = existingRoutesMapbyAccRecurrent.get(key);                                        
                    if(isRecurrent && existingRoute.Name != 'Recurrente'){
                        existingRoute.Name = 'Recurrente';
                    }                                            
                    routesToUpsert.add(existingRoute);
                    
                } else {
                    // Crear nuevo registro
                    Route_by_Account__c newRoute = new Route_by_Account__c();
                    newRoute.Account__c = accountId;
                    newRoute.Route__c = routeId;
                    newRoute.Name = isRecurrent ? 'Recurrente' : 'Nuevo';                                        
                    routesToUpsert.add(newRoute);
                    existingRoutesMapbyAccRecurrent.put(key, newRoute);
                }                                
            }                
        }
        
        if(!routesToUpsert.isEmpty()){
            upsertRouteAccount(routesToUpsert);                       
	    }                                     
    }   
    
}