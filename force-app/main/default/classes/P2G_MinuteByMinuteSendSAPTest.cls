@isTest(SeeAllData=true)
public class P2G_MinuteByMinuteSendSAPTest {
    
    @isTest
    static void testProcesarUnSoloId() {
        // Buscar un Shipment real que cumpla condiciones para enviar a SAP
        List<Shipment__c> existingShipments = [
            SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c
            FROM Shipment__c
            WHERE Order__c != NULL
            AND Account_for__r.Venta_Sap__c != NULL
            AND Account_for__r.Venta_Sap__c != ''
            LIMIT 1
        ];
        
        // Si no hay datos, crear datos de prueba
        if (existingShipments.isEmpty()) {
            System.debug('No hay Shipments existentes, se crearán datos de prueba');
            // Crear datos mínimos para prueba
            Account testAccount = new Account(Name = 'Test Account', Venta_Sap__c = 'Contado');
            insert testAccount;
            
            Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft', EffectiveDate = Date.today());
            insert testOrder;
            
            Shipment__c testShipment = new Shipment__c(
                Name = 'SHIP-TEST-001',
                Order__c = testOrder.Id,
                Account_for__c = testAccount.Id,
                Status_Shipment__c = 'Send to Sap',
                Shipment_Status_Plann__c = 'In Progress'
            );
            insert testShipment;
            
            existingShipments = new List<Shipment__c>{ testShipment };
        }
        
        List<Id> ids = new List<Id>{ existingShipments[0].Id };
        
        Test.startTest();
        P2G_MinuteByMinuteSendSAP processor = new P2G_MinuteByMinuteSendSAP(ids);
        System.enqueueJob(processor);
        Test.stopTest();
    }
    
    @isTest
    static void testProcesarMultiplesIds() {
        // Buscar varios Shipments reales
        List<Shipment__c> existingShipments = [
            SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c
            FROM Shipment__c
            WHERE Order__c != NULL
            AND Account_for__r.Venta_Sap__c != NULL
            AND Account_for__r.Venta_Sap__c != ''
            LIMIT 3
        ];
        
        // Si no hay suficientes, crear datos de prueba
        if (existingShipments.size() < 2) {
            System.debug('No hay suficientes Shipments, se crearán datos de prueba');
            Account testAccount = new Account(Name = 'Test Account Multi', Venta_Sap__c = 'Credito');
            insert testAccount;
            
            List<Shipment__c> testShipments = new List<Shipment__c>();
            for (Integer i = 0; i < 3; i++) {
                Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft', EffectiveDate = Date.today());
                insert testOrder;
                
                testShipments.add(new Shipment__c(
                    Name = 'SHIP-TEST-MULTI-' + i,
                    Order__c = testOrder.Id,
                    Account_for__c = testAccount.Id,
                    Status_Shipment__c = 'Send to Sap',
                    Shipment_Status_Plann__c = 'In Progress'
                ));
            }
            insert testShipments;
            existingShipments = testShipments;
        }
        
        List<Id> ids = new List<Id>();
        for (Shipment__c s : existingShipments) {
            ids.add(s.Id);
        }
        
        Test.startTest();
        P2G_MinuteByMinuteSendSAP processor = new P2G_MinuteByMinuteSendSAP(ids);
        System.enqueueJob(processor);
        Test.stopTest();
    }
    
    @isTest
    static void testListaVacia() {
        List<Id> ids = new List<Id>();
        
        Test.startTest();
        P2G_MinuteByMinuteSendSAP processor = new P2G_MinuteByMinuteSendSAP(ids);
        System.enqueueJob(processor);
        Test.stopTest();
    }
    @isTest
    static void testShipmentSinOrder() {
        // Buscar o crear Shipment sin Order
        List<Shipment__c> shipmentsSinOrder = [
            SELECT Id
            FROM Shipment__c
            WHERE Order__c = NULL
            LIMIT 1
        ];
        
        if (shipmentsSinOrder.isEmpty()) {
            // Crear Shipment sin Order
            Account testAccount = new Account(Name = 'Test Account Sin Order', Venta_Sap__c = 'Contado');
            insert testAccount;
            
            Shipment__c testShipment = new Shipment__c(
                Name = 'SHIP-TEST-NO-ORDER',
                Account_for__c = testAccount.Id,
                Status_Shipment__c = 'Send to Sap',
                Shipment_Status_Plann__c = 'In Progress'
            );
            insert testShipment;
            shipmentsSinOrder = new List<Shipment__c>{ testShipment };
        }
        
        List<Id> ids = new List<Id>{ shipmentsSinOrder[0].Id };
        
        Test.startTest();
        P2G_MinuteByMinuteSendSAP processor = new P2G_MinuteByMinuteSendSAP(ids);
        System.enqueueJob(processor);
        Test.stopTest();
    }
    
    @isTest
    static void testProcesamientoPorMinuto() {
        // Buscar Shipments reales
        List<Shipment__c> existingShipments = [
            SELECT Id
            FROM Shipment__c
            WHERE Order__c != NULL
            LIMIT 2
        ];
        
        if (existingShipments.size() < 2) {
            // Crear datos de prueba
            Account testAccount = new Account(Name = 'Test Account Minutes', Venta_Sap__c = 'Credito');
            insert testAccount;
            
            List<Shipment__c> testShipments = new List<Shipment__c>();
            for (Integer i = 0; i < 2; i++) {
                Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft', EffectiveDate = Date.today());
                insert testOrder;
                
                testShipments.add(new Shipment__c(
                    Name = 'SHIP-TEST-MIN-' + i,
                    Order__c = testOrder.Id,
                    Account_for__c = testAccount.Id,
                    Status_Shipment__c = 'Send to Sap',
                    Shipment_Status_Plann__c = 'In Progress'
                ));
            }
            insert testShipments;
            existingShipments = testShipments;
        }
        
        List<Id> ids = new List<Id>();
        for (Shipment__c s : existingShipments) {
            ids.add(s.Id);
        }
        
        Test.startTest();
        P2G_MinuteByMinuteSendSAP processor = new P2G_MinuteByMinuteSendSAP(ids);
        System.enqueueJob(processor);
        //PAK_SendToOrder.TestMetodo();
        
        Test.stopTest();
    }
}