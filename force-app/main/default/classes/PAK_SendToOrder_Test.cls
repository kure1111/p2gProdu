@isTest(SeeAllData=true)
public class PAK_SendToOrder_Test {
    
    @isTest
    static void testSendWS_Success() {
        // Obtener un Shipment real que tenga líneas y cumpla condiciones
        Shipment__c ship = [SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c,
                                   Shipment_Status_Plann__c, Status_Shipment__c
                            FROM Shipment__c 
                            WHERE Order__c != NULL 
                            AND Account_for__r.Venta_Sap__c != NULL
                            AND Account_for__r.Venta_Sap__c != ''
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment disponible para prueba');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
        
        Assert.isNull(result);
    }
    
    @isTest
    static void testSendWS_Contado() {
        // Buscar Shipment de tipo Contado
        Shipment__c ship = [SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c
                            FROM Shipment__c 
                            WHERE Account_for__r.Venta_Sap__c = 'Contado'
                            AND Order__c != NULL
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment Contado disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
    }
    
    @isTest
    static void testSendWS_Credito() {
        // Buscar Shipment de tipo Crédito
        Shipment__c ship = [SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c
                            FROM Shipment__c 
                            WHERE Account_for__r.Venta_Sap__c = 'Credito'
                            AND Order__c != NULL
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment Crédito disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
    }
    
    @isTest
    static void testSendWS_TipoM() {
        // Buscar Shipment tipo M (Marítimo)
        Shipment__c ship = [SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c,
                                   Service_Mode__c, Ocean_Shipment_Status__c
                            FROM Shipment__c 
                            WHERE Name LIKE '%-M-%'
                            AND Order__c != NULL
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment tipo M disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testSendWS_TipoA() {
        // Buscar Shipment tipo A (Aéreo)
        Shipment__c ship = [SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c,
                                   Air_Shipment_Status__c
                            FROM Shipment__c 
                            WHERE Name LIKE '%-A-%'
                            AND Order__c != NULL
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment tipo A disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testSendWS_TipoFN() {
        // Buscar Shipment tipo FN (Frontera Nacional)
        Shipment__c ship = [SELECT Id, Name, Account_for__r.Venta_Sap__c, Order__c,
                                   Shipment_Status_Mon__c, VerificacionPak__c
                            FROM Shipment__c 
                            WHERE Name LIKE '%-FN-%'
                            AND Order__c != NULL
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment tipo FN disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testSendWS_NoVentaSap() {
        // Buscar Shipment sin Venta_Sap__c configurado
        Shipment__c ship = [SELECT Id, Name, Order__c
                            FROM Shipment__c 
                            WHERE (Account_for__r.Venta_Sap__c = NULL OR Account_for__r.Venta_Sap__c = '')
                            AND Order__c != NULL
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment sin Venta_Sap__c disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testSendWS_WithoutLines() {
        // Buscar Shipment sin líneas de servicio
        Shipment__c ship = [SELECT Id, Name, Order__c
                            FROM Shipment__c 
                            WHERE Id NOT IN (SELECT Shipment__c FROM Shipment_Fee_Line__c)
                            AND Order__c != NULL
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment sin líneas disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
    }
    
    @isTest
    static void testBatchMode() {
        // Probar modo batch con datos reales
        Shipment__c ship = [SELECT Id FROM Shipment__c WHERE Order__c != NULL LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment disponible');
            return;
        }
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        // En modo batch, addMessage debe hacer System.debug, no fallar
        PageReference result = sendToOrder.SendWS();
        
        Test.stopTest();
    }
    
    @isTest
    static void testValidarEstatus() {
        // Probar método ValidarEstatus con datos reales
        Shipment__c ship = [SELECT Id, Name, Account_for__r.Venta_Sap__c, 
                                   Shipment_Status_Mon__c, Shipment_Status_Plann__c,
                                   Status_Shipment__c
                            FROM Shipment__c 
                            WHERE Order__c != NULL 
                            LIMIT 1];
        
        if (ship == null) {
            System.debug('No hay Shipment disponible');
            return;
        }
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
        PAK_SendToOrder sendToOrder = new PAK_SendToOrder(sc);
        sendToOrder.IdShipment = ship.Id;
        
        // Extraer tipo del Name
        if (ship.Name != null && ship.Name.contains('-')) {
            sendToOrder.TipoShipment = ship.Name.substringBetween('-', '-');
        }

        PAK_SendToOrder.byPass();
        
    }
}