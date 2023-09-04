@isTest()
public class PAK_ShipmentEstatusSAP_test {
    
    static testMethod void testEXPOMAR() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
        insert a;
        Operadores__c operador = new Operadores__c();
        operador.Account__c = a.Id;
        operador.Truckstop_Email__c = 'test@test.com';
        insert operador;
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
        insert vehicle;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-M-19-078949',
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Shipment_Status__c= 'ETD';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
    static testMethod void testIMPOMAR() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        insert a;
        Operadores__c operador = new Operadores__c();
        operador.Account__c = a.Id;
        operador.Truckstop_Email__c = 'test@neurored.com.test';
        insert operador;
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
        insert vehicle;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-M-19-078949',
                                           Only_Warehouse_Service__c = true,
                                           Ocean_Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Ocean_Shipment_Status__c = 'Booking Confirmation';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
    static testMethod void testAir() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        insert a;
        Operadores__c operador = new Operadores__c();
        operador.Account__c = a.Id;
        operador.Truckstop_Email__c = 'test@neurored.com.test';
        insert operador;
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
        insert vehicle;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-A-19-078949',
                                           Only_Warehouse_Service__c = true,
                                           Air_Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Air_Shipment_Status__c = 'Contact with Origin';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
    static testMethod void testFN() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        insert a;
        Operadores__c operador = new Operadores__c();
        operador.Account__c = a.Id;
        operador.Truckstop_Email__c = 'test@neurored.com.test';
        insert operador;
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
        insert vehicle;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-FN-20-107098',
                                           Freight_Mode__c='Road', 
                                           Service_Mode__c ='NATIONAL', 
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Shipment_Status_Plann__c= 'In Progress';
        ship.Shipment_Status_Mon__c = 'Finished_M';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
}