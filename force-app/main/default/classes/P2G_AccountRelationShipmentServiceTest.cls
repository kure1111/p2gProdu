@isTest(seeAllData=true)
public class P2G_AccountRelationShipmentServiceTest {

    
    @isTest(seeAllData=true)
    static void testCuentaNuevaPorFecha() {
        // Buscar cuentas existentes creadas en el último mes
        Date oneMonthAgo = Date.today().addMonths(-1);
        List<Account> recentAccounts = [
            SELECT Id, Name, CreatedDate, Estatus_cuenta__c 
            FROM Account 
            WHERE CreatedDate >= :oneMonthAgo
            LIMIT 1
        ];
        
        if(recentAccounts.isEmpty()) {
            System.debug('No se encontraron cuentas creadas en el último mes');
            return;
        }
        
        Account testAccount = recentAccounts[0];
        String originalStatus = testAccount.Estatus_cuenta__c;
        
        Test.startTest();
        P2G_AccountRelationShipmentService service = new P2G_AccountRelationShipmentService();
        service.main(new List<Account>{testAccount});
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, Estatus_cuenta__c FROM Account WHERE Id = :testAccount.Id];
        System.debug('Cuenta nueva por fecha - ID: ' + testAccount.Id + 
                    ', Nombre: ' + testAccount.Name + 
                    ', Estatus original: ' + originalStatus + 
                    ', Estatus nuevo: ' + updatedAccount.Estatus_cuenta__c);
    }
    
    @isTest(seeAllData=true)
    static void testCuentaRecurrenteConShipments() {
        // Buscar cuentas con shipments en los últimos 12 meses
        List<AggregateResult> accountsWithShipments = [
            SELECT Account_for__c accId, COUNT(Id) total
            FROM Shipment__c
            WHERE CreatedDate = LAST_N_MONTHS:12
            AND Shipment_Status_Plann__c != 'Cancel'
            GROUP BY Account_for__c
            HAVING COUNT(Id) > 0
            LIMIT 1
        ];
        
        if(accountsWithShipments.isEmpty()) {
            System.debug('No se encontraron cuentas con shipments en los últimos 12 meses');
            return;
        }
        
        Id accountId = (Id) accountsWithShipments[0].get('accId');
        Account testAccount = [SELECT Id, Name, CreatedDate, Estatus_cuenta__c 
                              FROM Account WHERE Id = :accountId];
        
        // Verificar que la cuenta sea antigua (más de 1 mes)
        Date oneMonthAgo = Date.today().addMonths(-1);
        if(testAccount.CreatedDate.date() >= oneMonthAgo) {
            System.debug('La cuenta es reciente, no aplica para prueba de recurrente');
            return;
        }
        
        String originalStatus = testAccount.Estatus_cuenta__c;
        
        Test.startTest();
        P2G_AccountRelationShipmentService service = new P2G_AccountRelationShipmentService();
        service.main(new List<Account>{testAccount});
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, Estatus_cuenta__c FROM Account WHERE Id = :testAccount.Id];
        System.debug('Cuenta recurrente con shipments - ID: ' + testAccount.Id + 
                    ', Nombre: ' + testAccount.Name + 
                    ', Total shipments: ' + accountsWithShipments[0].get('total') +
                    ', Estatus original: ' + originalStatus + 
                    ', Estatus nuevo: ' + updatedAccount.Estatus_cuenta__c);
    }
    
    @isTest(seeAllData=true)
    static void testCuentaAntiguaSinShipments() {
        // Buscar cuentas antiguas (más de 1 mes) sin shipments en los últimos 12 meses
        Date oneMonthAgo = Date.today().addMonths(-1);
        
        List<Account> oldAccounts = [
            SELECT Id, Name, CreatedDate, Estatus_cuenta__c
            FROM Account
            WHERE CreatedDate < :oneMonthAgo
            AND Id NOT IN (
                SELECT Account_for__c
                FROM Shipment__c
                WHERE CreatedDate = LAST_N_MONTHS:12
                AND Shipment_Status_Plann__c != 'Cancel'
            )
            LIMIT 1
        ];
        
        if(oldAccounts.isEmpty()) {
            System.debug('No se encontraron cuentas antiguas sin shipments');
            return;
        }
        
        Account testAccount = oldAccounts[0];
        String originalStatus = testAccount.Estatus_cuenta__c;
        
        Test.startTest();
        P2G_AccountRelationShipmentService service = new P2G_AccountRelationShipmentService();
        service.main(new List<Account>{testAccount});
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, Estatus_cuenta__c FROM Account WHERE Id = :testAccount.Id];
        System.debug('Cuenta antigua sin shipments - ID: ' + testAccount.Id + 
                    ', Nombre: ' + testAccount.Name + 
                    ', Fecha creación: ' + testAccount.CreatedDate +
                    ', Estatus original: ' + originalStatus + 
                    ', Estatus nuevo: ' + updatedAccount.Estatus_cuenta__c);
    }
    
    @isTest(seeAllData=true)
    static void testCuentaConShipmentsCancelados() {
        // Buscar cuentas con shipments cancelados pero sin shipments activos
        Date oneMonthAgo = Date.today().addMonths(-1);
        
        List<Account> accountsWithCanceledShipments = [
            SELECT Id, Name, CreatedDate, Estatus_cuenta__c
            FROM Account
            WHERE CreatedDate < :oneMonthAgo
            AND Id IN (
                SELECT Account_for__c
                FROM Shipment__c
                WHERE Shipment_Status_Plann__c = 'Cancel'
                AND CreatedDate = LAST_N_MONTHS:12
            )
            AND Id NOT IN (
                SELECT Account_for__c
                FROM Shipment__c
                WHERE Shipment_Status_Plann__c != 'Cancel'
                AND CreatedDate = LAST_N_MONTHS:12
            )
            LIMIT 1
        ];
        
        if(accountsWithCanceledShipments.isEmpty()) {
            System.debug('No se encontraron cuentas con solo shipments cancelados');
            return;
        }
        
        Account testAccount = accountsWithCanceledShipments[0];
        String originalStatus = testAccount.Estatus_cuenta__c;
        
        // Contar shipments cancelados para debug
        Integer canceledCount = [
            SELECT COUNT() FROM Shipment__c
            WHERE Account_for__c = :testAccount.Id
            AND Shipment_Status_Plann__c = 'Cancel'
            AND CreatedDate = LAST_N_MONTHS:12
        ];
        
        Test.startTest();
        P2G_AccountRelationShipmentService service = new P2G_AccountRelationShipmentService();
        service.main(new List<Account>{testAccount});
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, Estatus_cuenta__c FROM Account WHERE Id = :testAccount.Id];
        System.debug('Cuenta con shipments cancelados - ID: ' + testAccount.Id + 
                    ', Nombre: ' + testAccount.Name + 
                    ', Shipments cancelados: ' + canceledCount +
                    ', Estatus original: ' + originalStatus + 
                    ', Estatus nuevo: ' + updatedAccount.Estatus_cuenta__c);
    }
    
    @isTest(seeAllData=true)
    static void testMultiplesCuentas() {
        // Buscar hasta 3 cuentas en diferentes escenarios
        Date oneMonthAgo = Date.today().addMonths(-1);
        
        // 1. Cuenta nueva (creada en el último mes)
        List<Account> newAccounts = [
            SELECT Id, Name, CreatedDate, Estatus_cuenta__c
            FROM Account
            WHERE CreatedDate >= :oneMonthAgo
            LIMIT 1
        ];
        
        // 2. Cuenta recurrente (antigua con shipments)
        List<AggregateResult> recurrentData = [
            SELECT Account_for__c accId, COUNT(Id) total
            FROM Shipment__c
            WHERE CreatedDate = LAST_N_MONTHS:12
            AND Shipment_Status_Plann__c != 'Cancel'
            GROUP BY Account_for__c
            HAVING COUNT(Id) > 0
            LIMIT 1
        ];
        
        // 3. Cuenta antigua sin shipments
        List<Account> oldNoShipAccounts = [
            SELECT Id, Name, CreatedDate, Estatus_cuenta__c
            FROM Account
            WHERE CreatedDate < :oneMonthAgo
            AND Id NOT IN (
                SELECT Account_for__c
                FROM Shipment__c
                WHERE CreatedDate = LAST_N_MONTHS:12
            )
            LIMIT 1
        ];
        
        List<Account> accountsToProcess = new List<Account>();
        Map<Id, String> originalStatuses = new Map<Id, String>();
        
        // Agregar cuenta nueva
        if(!newAccounts.isEmpty()) {
            accountsToProcess.add(newAccounts[0]);
            originalStatuses.put(newAccounts[0].Id, newAccounts[0].Estatus_cuenta__c);
            System.debug('Cuenta nueva encontrada: ' + newAccounts[0].Name);
        }
        
        // Agregar cuenta recurrente
        if(!recurrentData.isEmpty()) {
            Id recurrentId = (Id) recurrentData[0].get('accId');
            Account recurrentAcc = [SELECT Id, Name, CreatedDate, Estatus_cuenta__c 
                                   FROM Account WHERE Id = :recurrentId];
            if(recurrentAcc.CreatedDate.date() < oneMonthAgo) {
                accountsToProcess.add(recurrentAcc);
                originalStatuses.put(recurrentAcc.Id, recurrentAcc.Estatus_cuenta__c);
                System.debug('Cuenta recurrente encontrada: ' + recurrentAcc.Name + 
                           ', Shipments: ' + recurrentData[0].get('total'));
            }
        }
        
        // Agregar cuenta antigua sin shipments
        if(!oldNoShipAccounts.isEmpty()) {
            accountsToProcess.add(oldNoShipAccounts[0]);
            originalStatuses.put(oldNoShipAccounts[0].Id, oldNoShipAccounts[0].Estatus_cuenta__c);
            System.debug('Cuenta antigua sin shipments encontrada: ' + oldNoShipAccounts[0].Name);
        }
        
        if(accountsToProcess.isEmpty()) {
            System.debug('No se encontraron cuentas para probar múltiples escenarios');
            return;
        }
        
        Test.startTest();
        P2G_AccountRelationShipmentService service = new P2G_AccountRelationShipmentService();
        service.main(accountsToProcess);
        Test.stopTest();
        
        // Verificar resultados
        for(Account acc : accountsToProcess) {
            Account updatedAcc = [SELECT Id, Estatus_cuenta__c FROM Account WHERE Id = :acc.Id];
            System.debug('Resultado múltiple - Cuenta: ' + acc.Name + 
                        ', ID: ' + acc.Id +
                        ', Estatus original: ' + originalStatuses.get(acc.Id) + 
                        ', Estatus nuevo: ' + updatedAcc.Estatus_cuenta__c);
        }
    }
    
    @isTest(seeAllData=true)
    static void testListaVacia() {
        Test.startTest();
        P2G_AccountRelationShipmentService service = new P2G_AccountRelationShipmentService();
        service.main(new List<Account>());
        Test.stopTest();
        
        System.debug('Prueba con lista vacía completada');
    }
    
    @isTest(seeAllData=true)
    static void testGetCountByShipment() {
        // Probar el método estático directamente
        Set<Id> testIds = new Set<Id>();
        
        // Buscar algunas cuentas con shipments
        List<AggregateResult> accountsWithShipments = [
            SELECT Account_for__c accId
            FROM Shipment__c
            WHERE CreatedDate = LAST_N_MONTHS:12
            AND Shipment_Status_Plann__c != 'Cancel'
            GROUP BY Account_for__c
            LIMIT 2
        ];
        
        for(AggregateResult ar : accountsWithShipments) {
            testIds.add((Id) ar.get('accId'));
        }
        
        // Agregar un ID inválido para probar
        testIds.add('001000000000000000');
        
        Test.startTest();
        Map<Id, Integer> result = P2G_AccountRelationShipmentService.getCountByShipment(testIds);
        Test.stopTest();
        
        System.debug('Resultado getCountByShipment - tamaño mapa: ' + result.size());
        for(Id accId : result.keySet()) {
            System.debug('Cuenta ' + accId + ' tiene ' + result.get(accId) + ' shipments');
        }
    }
    
    
    //clase test para el batch
@isTest(seeAllData=true)
    static void testConstructor() {
        Test.startTest();
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        Test.stopTest();
        
        System.debug('Constructor ejecutado correctamente');
    }
    
    @isTest(seeAllData=true)
    static void testBatchExecute() {
        // Buscar cuentas que cumplan con los criterios del batch
        List<Account> testAccounts = [
            SELECT Id, Name, TAX_ID__c, Record_Type_Name__c, Customer_Id__c, CreatedDate 
            FROM Account 
            WHERE Record_Type_Name__c = 'Customer' 
            AND TAX_ID__c != NULL 
            AND Customer_Id__c != NULL
            AND Owner.SalesEmployer__c != NULL
            LIMIT 5
        ];
        
        if(testAccounts.isEmpty()) {
            System.debug('No se encontraron cuentas para probar el batch');
            return;
        }
        
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        
        Test.startTest();
        // Ejecutar el método execute directamente
        service.execute(null, testAccounts);
        Test.stopTest();
        
        System.debug('Batch execute completado para ' + testAccounts.size() + ' cuentas');
    }        
    
    @isTest(seeAllData=true)
    static void testBatchFinish() {
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        
        Test.startTest();
        service.finish(null);
        Test.stopTest();
        
        System.debug('Batch finish ejecutado correctamente');
    }
    
    /*@isTest(seeAllData=true)
    static void testBatchCompleto() {
        // Buscar cuentas que cumplan con los criterios
        List<Account> testAccounts = [
            SELECT Id, Name, TAX_ID__c, Record_Type_Name__c, Customer_Id__c, CreatedDate 
            FROM Account 
            WHERE Record_Type_Name__c = 'Customer' 
            AND TAX_ID__c != NULL 
            AND Customer_Id__c != NULL
            AND Owner.SalesEmployer__c != NULL
            LIMIT 1
        ];
        
        if(testAccounts.isEmpty()) {
            System.debug('No se encontraron cuentas para probar el batch completo');
            return;
        }
        
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        
        Test.startTest();
        // Probar el ciclo completo del batch
        Database.QueryLocator locator = service.start(null);
        service.execute(null, testAccounts);
        service.finish(null);
        Test.stopTest();
        
        System.debug('Batch completo ejecutado correctamente');
    }*/
    
    /*@isTest(seeAllData=true)
    static void testBatchConDiferentesEscenarios() {
        // Crear o buscar cuentas en diferentes escenarios
        
        // 1. Cuenta nueva (creada en el último mes)
        List<Account> newAccounts = [
            SELECT Id, Name, TAX_ID__c, Record_Type_Name__c, Customer_Id__c, CreatedDate,Owner.SalesEmployer__c 
            FROM Account 
            WHERE Record_Type_Name__c = 'Customer' 
            AND TAX_ID__c != NULL 
            AND Customer_Id__c != NULL
            AND Owner.SalesEmployer__c != NULL
            AND CreatedDate = LAST_N_DAYS:30
            LIMIT 1
        ];
        
        // 2. Cuenta antigua con shipments
        List<AggregateResult> accountsWithShipments = [
            SELECT Account_for__c accId
            FROM Shipment__c
            WHERE CreatedDate = LAST_N_MONTHS:12
            AND Shipment_Status_Plann__c != 'Cancel'
            GROUP BY Account_for__c
            LIMIT 1
        ];
        
        List<Account> accountsToProcess = new List<Account>();
        
        if(!newAccounts.isEmpty()) {
            accountsToProcess.add(newAccounts[0]);
            System.debug('Cuenta nueva encontrada: ' + newAccounts[0].Name);
        }
        
        if(!accountsWithShipments.isEmpty()) {
            Id accountId = (Id) accountsWithShipments[0].get('accId');
            Account recurrentAccount = [SELECT Id, Name, TAX_ID__c, Record_Type_Name__c, Customer_Id__c, CreatedDate 
                                       FROM Account WHERE Id = :accountId];
            accountsToProcess.add(recurrentAccount);
            System.debug('Cuenta recurrente encontrada: ' + recurrentAccount.Name);
        }
        
        if(accountsToProcess.isEmpty()) {
            System.debug('No se encontraron cuentas para probar escenarios');
            return;
        }
        
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        
        Test.startTest();
        service.execute(null, accountsToProcess);
        Test.stopTest();
        
        System.debug('Batch con diferentes escenarios ejecutado para ' + accountsToProcess.size() + ' cuentas');
    }*/
    
    @isTest(seeAllData=true)
    static void testBatchConListaVacia() {
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        
        Test.startTest();
        service.execute(null, new List<Account>());
        Test.stopTest();
        
        System.debug('Batch con lista vacía ejecutado correctamente');
    }
    
    @isTest(seeAllData=true)
    static void testConsultaSOQL() {
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        
        Test.startTest();
        // Verificar que la consulta sea válida
        String soql = service.consultaSOQL;
        List<Account> results = Database.query(soql + ' LIMIT 1');
        Test.stopTest();
        
        System.debug('Consulta SOQL válida, resultados: ' + results.size());
    }
    
    /*@isTest(seeAllData=true)
    static void testEjecucionCompletaBatch() {
        // Esta prueba ejecuta el batch de manera asíncrona
        P2G_AccountUsageService service = new P2G_AccountUsageService();
        
        Test.startTest();
        Database.executeBatch(service, 10);
        Test.stopTest();
        
        System.debug('Batch ejecutado asíncronamente');
    }*/
}