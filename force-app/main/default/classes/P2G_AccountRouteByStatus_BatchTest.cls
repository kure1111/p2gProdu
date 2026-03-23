@isTest
public class P2G_AccountRouteByStatus_BatchTest {
        
    @isTest(seeAllData=true)
    static void testConstructor() {
        Test.startTest();
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        Test.stopTest();
        
        System.debug('Constructor ejecutado, consultaSOQL: ' + batch.consultaSOQL);
    }
    
    /*
    @isTest(seeAllData=true)
    static void testStart() {
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        
        Test.startTest();
        Database.QueryLocator locator = batch.start(null);
        Test.stopTest();
        
        System.debug('Start ejecutado correctamente');
    }
    */
    
    @isTest(seeAllData=true)
    static void testExecuteConAmbosEstatus() {
        // Buscar oportunidades que cumplan los criterios
        List<Opportunity> testOpps = [
            SELECT Id, Account.Id, Account.Name, Import_Export_Quote_Order__r.Route__c, 
                   CreatedDate, Import_Export_Quote_Order__r.Route__r.Name, 
                   Account.Estatus_cuenta__c
            FROM Opportunity
            WHERE Import_Export_Quote_Order__r.Route__r.Name != null
            AND Account.Estatus_cuenta__c IN ('Nuevo', 'Recurrente')
            LIMIT 10
        ];
        
        if(testOpps.isEmpty()) {
            System.debug('No se encontraron oportunidades para probar');
            return;
        }
        
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        
        Test.startTest();
        batch.execute(null, testOpps);
        Test.stopTest();
        
        System.debug('Execute completado con ' + testOpps.size() + ' oportunidades');
    }
    
    @isTest(seeAllData=true)
    static void testExecuteSoloNuevos() {
        // Buscar solo oportunidades con cuentas nuevas
        List<Opportunity> newCustomerOpps = [
            SELECT Id, Account.Id, Account.Name, Import_Export_Quote_Order__r.Route__c, 
                   CreatedDate, Import_Export_Quote_Order__r.Route__r.Name, 
                   Account.Estatus_cuenta__c
            FROM Opportunity
            WHERE Import_Export_Quote_Order__r.Route__r.Name != null
            AND Account.Estatus_cuenta__c = 'Nuevo'
            LIMIT 5
        ];
        
        if(newCustomerOpps.isEmpty()) {
            System.debug('No se encontraron oportunidades con cuentas nuevas');
            return;
        }
        
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        
        Test.startTest();
        batch.execute(null, newCustomerOpps);
        Test.stopTest();
        
        System.debug('Execute con cuentas nuevas completado');
    }
    
    @isTest(seeAllData=true)
    static void testExecuteSoloRecurrentes() {
        // Buscar solo oportunidades con cuentas recurrentes
        List<Opportunity> recurrentCustomerOpps = [
            SELECT Id, Account.Id, Account.Name, Import_Export_Quote_Order__r.Route__c, 
                   CreatedDate, Import_Export_Quote_Order__r.Route__r.Name, 
                   Account.Estatus_cuenta__c
            FROM Opportunity
            WHERE Import_Export_Quote_Order__r.Route__r.Name != null
            AND Account.Estatus_cuenta__c = 'Recurrente'
            LIMIT 5
        ];
        
        if(recurrentCustomerOpps.isEmpty()) {
            System.debug('No se encontraron oportunidades con cuentas recurrentes');
            return;
        }
        
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        
        Test.startTest();
        batch.execute(null, recurrentCustomerOpps);
        Test.stopTest();
        
        System.debug('Execute con cuentas recurrentes completado');
    }
    
    @isTest(seeAllData=true)
    static void testExecuteConListaVacia() {
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        
        Test.startTest();
        batch.execute(null, new List<Opportunity>());
        Test.stopTest();
        
        System.debug('Execute con lista vacía completado');
    }
    
    @isTest(seeAllData=true)
    static void testFinish() {
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
        
        Test.startTest();
        batch.finish(null);
        Test.stopTest();
        
        System.debug('Finish ejecutado correctamente');
    }
     
    @isTest(seeAllData=true)
    static void testConsultaSOQL() {
        P2G_AccountRouteByStatus_Batch batch = new P2G_AccountRouteByStatus_Batch();
    
        Test.startTest();   
    
        // Opción 1: Usar Database.getQueryLocator (recomendado para probar el batch)
        Database.QueryLocator ql = batch.start(null);
        System.assertNotEquals(null, ql, 'QueryLocator no debería ser null');
        
        // Opción 2: Probar la consulta directamente reemplazando el binding
        String soql = batch.consultaSOQL;
        
        // Reemplazar :startDate con el valor real formateado para la prueba
        DateTime testStartDate = batch.startDate;
        String fechaFormateada = testStartDate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String soqlPrueba = soql.replace(':startDate', fechaFormateada);
        
        // Ejecutar la consulta de prueba
        List<Opportunity> results = Database.query(soqlPrueba + ' LIMIT 1');
        
        Test.stopTest();
    }                
     
          
}