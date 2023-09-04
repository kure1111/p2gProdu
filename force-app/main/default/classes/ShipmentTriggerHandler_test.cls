@isTest
public class ShipmentTriggerHandler_test {
/*static testMethod void ShipmentTriggerHandlerTest() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
        insert a;
    	Operadores__c operador = new Operadores__c();
		operador.Account__c = a.Id;
		operador.Truckstop_Email__c = 'test@neurored.com.test';
		insert operador;
  
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-FN-20-107098',
                                           Freight_Mode__c='Road', 
                                           Service_Mode__c ='NATIONAL', 
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId()
                                          );
        insert ship;
    	ship.Shipment_Status_Plann__c= 'Confirmed';
        update ship;
       
    }
    static testMethod void ShipmentTriggerHandlerTestInProgress() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
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
    	ship.Shipment_Status_Plann__c= 'In Progress';
        update ship;
       
    }
    static testMethod void ShipmentTriggerHandlerTest2() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
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
                                           name = 'SP-T-19-078949',
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
    	ship.Shipment_Status_Plann__c= 'In Progress';
        update ship;
       
    }
    static testMethod void ShipmentTriggerHandlerTest3() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
        insert a;
    	Operadores__c operador = new Operadores__c();
		operador.Account__c = a.Id;
		operador.Truckstop_Email__c = 'test@neurored.com.test';
		insert operador;
  		Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
        insert vehicle;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-T-19-078949',
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
    	ship.Shipment_Status_Plann__c= 'Confirmed';
        update ship;
       
    }
     static testMethod void ShipmentTriggerHandlerTest4() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
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
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
    	ship.Shipment_Status__c= 'ETD';
        update ship;
       
    }
     static testMethod void ShipmentTriggerHandlerTest5() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
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
    	ship.Ocean_Shipment_Status__c= 'ETD';
        update ship;
       
    }
     static testMethod void ShipmentTriggerHandlerTest6() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
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
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
    	ship.Shipment_Status__c = 'Booking Confirmation';
        update ship;
       
    }
     static testMethod void ShipmentTriggerHandlerTest7() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
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
    	ship.Ocean_Shipment_Status__c = 'Booking Confirmation';
        update ship;
       
    }
    static testMethod void ShipmentTriggerHandlerTest8() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
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
    	ship.Air_Shipment_Status__c = 'Contact with Origin';
        update ship;
       
    }
    static testMethod void ShipmentTriggerHandlerTest9() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
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
    	ship.Air_Shipment_Status__c = 'Flight Confirmation';
         List<Shipment_Fee_Line__c> lstUpd = new List<Shipment_Fee_Line__c>();
        
        Shipment_Fee_Line__c sfl = new Shipment_Fee_Line__c();
        sfl.Shipment__c = ship.Id;
        sfl.Name = '001';
        sfl.SAP__c = false;
        lstUpd.add(sfl);
        
        Shipment_Fee_Line__c sfl2 = new Shipment_Fee_Line__c();
        sfl2.Shipment__c = ship.Id;
        sfl2.Name = '002';
        sfl2.SAP__c = false;
        lstUpd.add(sfl2);
        
        insert lstUpd;
        update ship;
        
       
    }*/
   static testMethod void ShipmentTriggerHandlerTest11() {
        // TO DO: implement unit test
       /* NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
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
    	ship.Air_Shipment_Status__c = 'Flight Confirmation';
         List<Shipment_Fee_Line__c> lstUpd = new List<Shipment_Fee_Line__c>();
        
        Shipment_Fee_Line__c sfl = new Shipment_Fee_Line__c();
        sfl.Shipment__c = ship.Id;
        sfl.Name = '001';
        sfl.SAP__c = false;
        lstUpd.add(sfl);
        
        Shipment_Fee_Line__c sfl2 = new Shipment_Fee_Line__c();
        sfl2.Shipment__c = ship.Id;
        sfl2.Name = '002';
        sfl2.SAP__c = false;
        lstUpd.add(sfl2);
        
        insert lstUpd;
        update ship;*/
        test.startTest();
        //set<string> setShipmentIds = new set<string>();
       // setShipmentIds.add(ship.Id);
     //  PAK_SendToSap.sendShipment(setShipmentIds,  new set<string>());
       ShipmentTriggerHandler t = new ShipmentTriggerHandler();
        t.TestMetodo();
       PAK_SendToSap.TestMetodo();
        test.stopTest();
            
       
    }
    
}