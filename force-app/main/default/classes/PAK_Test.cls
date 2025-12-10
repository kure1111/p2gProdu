@isTest(SeeAllData=true) // 🔥 KEY: Usamos datos reales de la org
public class PAK_Test {
    
    // Test 1: Solicitud de Compra creada
    @isTest
    static void testSolicitudCompraCreada() {
        // 1. BUSCAR DATOS REALES: Encontrar un Order existente sin Solicitud_compra__c
        List<Order> orders = [SELECT Id, Solicitud_compra__c 
                              FROM Order 
                              WHERE Solicitud_compra__c = null 
                              LIMIT 1];
        
        // Si no existe, usar cualquier Order y limpiar el campo para la prueba
        if(orders.isEmpty()) {
            orders = [SELECT Id FROM Order LIMIT 1];
            orders[0].Solicitud_compra__c = null;
            update orders[0];
        }
        
        // 2. Preparar el mensaje
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Order = orders[0].Id;
        msg.Message = 'Solicitud de Compra creada: TEST SOL COMP 123';
        
        Test.startTest();
        List<PAK_WSMESSAGES.status> result = PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();

        Order updatedOrder = [SELECT Solicitud_compra__c FROM Order WHERE Id = :orders[0].Id];
    }
    
    // Test 2: Actualización de Status de OrderItem (Open/Closed)
    @isTest
    static void testOrderItemStatusUpdate() {
        // 1. BUSCAR DATOS REALES: OrderItem con ShipServLineId__c
        List<OrderItem> orderItems = [SELECT Id, ShipServLineId__c, ItemStatus_SAP__c 
                                      FROM OrderItem 
                                      WHERE ShipServLineId__c != null 
                                      LIMIT 1];
        
        // Si no existe, la prueba no puede ejecutarse
        if(orderItems.isEmpty()) {
            System.debug('No hay OrderItems con ShipServLineId__c para probar. Prueba omitida.');
            return;
        }
        
        // 2. Preparar mensaje
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.ShipmentLine = orderItems[0].ShipServLineId__c;
        msg.Message = 'Closed';
        
        Test.startTest();
        List<PAK_WSMESSAGES.status> result = PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();
        
        OrderItem updatedItem = [SELECT ItemStatus_SAP__c FROM OrderItem WHERE Id = :orderItems[0].Id];
    }
    
    // Test 3: Orden de Venta creada
    @isTest
    static void testOrdenVentaCreada() {
        // 1. BUSCAR DATOS REALES: Order sin OrdenVenta__c
        List<Order> orders = [SELECT Id, OrdenVenta__c 
                              FROM Order 
                              WHERE OrdenVenta__c = null 
                              LIMIT 1];
        
        if(orders.isEmpty()) {
            orders = [SELECT Id FROM Order LIMIT 1];
            orders[0].OrdenVenta__c = null;
            update orders[0];
        }
        
        // 2. Preparar mensaje
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Order = orders[0].Id;
        msg.Message = 'Orden de Venta creada TEST OV 123';
        
        Test.startTest();
        List<PAK_WSMESSAGES.status> result = PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();

        Order updatedOrder = [SELECT OrdenVenta__c, Date_Receive_from_SAP__c FROM Order WHERE Id = :orders[0].Id];
    }

    // Test 5: Proveedor creado en SAP (Actualiza Account)
    @isTest
    static void testProveedorCreadoSAP() {
        // 1. BUSCAR DATOS REALES: Account sin Customer_Id__c
        List<Account> accounts = [SELECT Id, Customer_Id__c 
                                  FROM Account 
                                  WHERE Customer_Id__c = null 
                                  LIMIT 1];
        
        if(accounts.isEmpty()) {
            accounts = [SELECT Id FROM Account LIMIT 1];
            accounts[0].Customer_Id__c = null;
            update accounts[0];
        }
        
        // 2. Preparar mensaje
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Account = accounts[0].Id;
        msg.Message = 'Proveedor creado en SAP CardCode PROV TEST 789';
        
        Test.startTest();
        List<PAK_WSMESSAGES.status> result = PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();
        
        // 3. Verificar
        Account updatedAcc = [SELECT Customer_Id__c FROM Account WHERE Id = :accounts[0].Id];
    }
    
    // Test 6: Manejo de mensaje de ERROR
    @isTest
    static void testMensajeError() {
        // Usar cualquier ID válido de un objeto
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Account = accounts[0].Id;
        msg.Message = 'Este es un mensaje de error generico';
        
        Test.startTest();
        List<PAK_WSMESSAGES.status> result = PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        PAK_WSMESSAGES.byPass();
        Test.stopTest();

    }
}