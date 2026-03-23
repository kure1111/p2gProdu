@isTest
private class P2G_AccountRouteByStatusTest {
        
    
    // Test para customerTypeGroups
    @isTest
    static void testCustomerTypeGroups() {
        Test.startTest();
        
        P2G_AccountRouteByStatus.customerTypeGroups groups = new P2G_AccountRouteByStatus.customerTypeGroups();
        System.assertNotEquals(null, groups.newCustomer);
        System.assertNotEquals(null, groups.recurrentCustomer);
        System.assertEquals(0, groups.newCustomer.size());
        System.assertEquals(0, groups.recurrentCustomer.size());
        
        Test.stopTest();
    }
    
    // Test para groupAccountsByCustomerStatus
    @isTest(seeAllData=true)
    static void testGroupAccountsByCustomerStatus() {
        // Buscar oportunidades con ambos estatus
        List<Opportunity> testOpps = [
            SELECT Id, Account.Id, Account.Name, Account.Estatus_cuenta__c,
                   Import_Export_Quote_Order__r.Route__c, Import_Export_Quote_Order__r.Route__r.Name
            FROM Opportunity
            WHERE Account.Estatus_cuenta__c IN ('Nuevo', 'Recurrente')
            AND Import_Export_Quote_Order__r.Route__r.Name != null
            LIMIT 10
        ];
        
        if(testOpps.isEmpty()) {
            System.debug('No se encontraron oportunidades para probar');
            return;
        }
        
        Test.startTest();
        P2G_AccountRouteByStatus.customerTypeGroups groups = P2G_AccountRouteByStatus.groupAccountsByCustomerStatus(testOpps);
        Test.stopTest();
        
        System.debug('Nuevos: ' + groups.newCustomer.size() + ', Recurrentes: ' + groups.recurrentCustomer.size());
    }
    
    // Test para getAccountIds
    @isTest(seeAllData=true)
    static void testGetAccountIds() {
        List<Opportunity> testOpps = [
            SELECT Id, Account.Id
            FROM Opportunity
            WHERE AccountId != null
            LIMIT 5
        ];
        
        if(testOpps.isEmpty()) {
            System.debug('No se encontraron oportunidades');
            return;
        }
        
        Test.startTest();
        Set<Id> accountIds = P2G_AccountRouteByStatus.getAccountIds(testOpps);
        Test.stopTest();
        
        System.debug('Account IDs encontrados: ' + accountIds.size());
    }
    
    // Test para getRouteAccountsByAccountId
    @isTest(seeAllData=true)
    static void testGetRouteAccountsByAccountId() {
        List<Route_by_Account__c> existingRoutes = [
            SELECT Account__c FROM Route_by_Account__c 
            WHERE Account__c != null 
            LIMIT 1
        ];
        
        if(existingRoutes.isEmpty()) {
            System.debug('No hay Route_by_Account__c existentes');
            return;
        }
        
        Set<Id> accountIds = new Set<Id>{existingRoutes[0].Account__c};
        
        Test.startTest();
        List<Route_by_Account__c> routes = P2G_AccountRouteByStatus.getRouteAccountsByAccountId(accountIds);
        Test.stopTest();
        
        System.debug('Rutas encontradas: ' + routes.size());
    }
    
    // Test para generateRouteAccountExistKeyMap
    @isTest(seeAllData=true)
    static void testGenerateRouteAccountExistKeyMap() {
        List<Route_by_Account__c> testRoutes = [
            SELECT Id, Account__c, Route__c, Name
            FROM Route_by_Account__c
            WHERE Account__c != null AND Route__c != null
            LIMIT 5
        ];
        
        Test.startTest();
        Map<String, Route_by_Account__c> resultMap = P2G_AccountRouteByStatus.generateRouteAccountExistKeyMap(testRoutes);
        Test.stopTest();
        
        System.debug('Map generado con ' + resultMap.size() + ' elementos');
    }
    
    
    // Test para recentOpportunitiesByAccount
    @isTest(seeAllData=true)
    static void testRecentOpportunitiesByAccount() {
        List<Account> testAccounts = [SELECT Id FROM Account LIMIT 3];
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }
        
        Test.startTest();
        List<Opportunity> recentOpps = P2G_AccountRouteByStatus.recentOpportunitiesByAccount(accountIds, 3);
        Test.stopTest();
        
        System.debug('Oportunidades recientes: ' + recentOpps.size());
    }
    
    // Test para getNewCustomerByRoute
    @isTest(seeAllData=true)
    static void testGetNewCustomerByRoute() {
        // Buscar oportunidades de cuentas nuevas
        List<Opportunity> newCustomerOpps = [
            SELECT Id, Account.Id, Account.Name, Import_Export_Quote_Order__r.Route__c,
                   Import_Export_Quote_Order__r.Route__r.Name
            FROM Opportunity
            WHERE Account.Estatus_cuenta__c = 'Nuevo'
            AND Import_Export_Quote_Order__r.Route__c != null
            LIMIT 5
        ];
        
        if(newCustomerOpps.isEmpty()) {
            System.debug('No hay oportunidades de cuentas nuevas');
            return;
        }
        
        Test.startTest();
        P2G_AccountRouteByStatus.getNewCustomerByRoute(newCustomerOpps);
        Test.stopTest();
        
        System.debug('getNewCustomerByRoute ejecutado');
    }
    
    // Test para getRecurrentAccountByRoute
    @isTest(seeAllData=true)
    static void testGetRecurrentAccountByRoute() {
        // Buscar oportunidades de cuentas recurrentes
        List<Opportunity> recurrentCustomerOpps = [
            SELECT Id, Account.Id, Account.Name, Import_Export_Quote_Order__r.Route__c,
                   Import_Export_Quote_Order__r.Route__r.Name
            FROM Opportunity
            WHERE Account.Estatus_cuenta__c = 'Recurrente'
            AND Import_Export_Quote_Order__r.Route__c != null
            LIMIT 5
        ];
        
        if(recurrentCustomerOpps.isEmpty()) {
            System.debug('No hay oportunidades de cuentas recurrentes');
            return;
        }
        
        Test.startTest();
        P2G_AccountRouteByStatus.getRecurrentAccountByRoute(recurrentCustomerOpps);
        Test.stopTest();
        
        System.debug('getRecurrentAccountByRoute ejecutado');
    }
    
    // Test con datos vacíos para getNewCustomerByRoute
    @isTest(seeAllData=true)
    static void testGetNewCustomerByRouteEmptyList() {
        Test.startTest();
        P2G_AccountRouteByStatus.getNewCustomerByRoute(new List<Opportunity>());
        Test.stopTest();
        
        System.debug('getNewCustomerByRoute con lista vacía ejecutado');
    }
    
    // Test con datos vacíos para getRecurrentAccountByRoute
    @isTest(seeAllData=true)
    static void testGetRecurrentAccountByRouteEmptyList() {
        Test.startTest();
        P2G_AccountRouteByStatus.getRecurrentAccountByRoute(new List<Opportunity>());
        Test.stopTest();
        
        System.debug('getRecurrentAccountByRoute con lista vacía ejecutado');
    }
        
    // Test para el flujo completo
    @isTest(seeAllData=true)
    static void testFlujoCompleto() {
        // Buscar oportunidades de ambos tipos
        List<Opportunity> allOpps = [
            SELECT Id, Account.Id, Account.Name, Import_Export_Quote_Order__r.Route__c,
                   Import_Export_Quote_Order__r.Route__r.Name, Account.Estatus_cuenta__c
            FROM Opportunity
            WHERE Account.Estatus_cuenta__c IN ('Nuevo', 'Recurrente')
            AND Import_Export_Quote_Order__r.Route__c != null
            LIMIT 10
        ];
        
        if(allOpps.isEmpty()) {
            System.debug('No hay oportunidades para probar flujo completo');
            return;
        }
        
        Test.startTest();
        
        // 1. Agrupar por estatus
        P2G_AccountRouteByStatus.customerTypeGroups grupos = P2G_AccountRouteByStatus.groupAccountsByCustomerStatus(allOpps);
        
        // 2. Procesar nuevos
        if(!grupos.newCustomer.isEmpty()) {
            P2G_AccountRouteByStatus.getNewCustomerByRoute(grupos.newCustomer);
        }
        
        // 3. Procesar recurrentes
        if(!grupos.recurrentCustomer.isEmpty()) {
            P2G_AccountRouteByStatus.getRecurrentAccountByRoute(grupos.recurrentCustomer);
        }
        
        Test.stopTest();
        
        System.debug('Flujo completo ejecutado');
    }
}