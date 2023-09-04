@isTest
public class Pak_ShipmentClosedBatch_TEST {
    @testSetup 
    static void CreateObjects() {
         
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        a.Segment__c='Nuevo';
        insert a;
        
         
         List<Account> list_accountsb = NEU_Utils.getAccounts('Transporter,');
        Account b = list_accountsb[0];
        b.Segment__c='Nuevo';
        insert b;
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = b.Id;
        //operador.Truckstop_Email__c = 'test@neurored.com.test';
        insert operador;
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
        insert vehicle;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-FN-20-107000',
                                            carrier__C = b.id,
                                           Freight_Mode__c='Road', 
                                           Service_Mode__c ='NATIONAL', 
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now(),
                                           Traslado_Ingreso__c = 'Traslado'
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
	}
     @isTest 
  static void testVoid() {
     Test.StartTest();
     	Pak_ShipmentClosedBatch sh1 = new Pak_ShipmentClosedBatch();
			String sch = '0 0 23 * * ?';
			system.schedule('Pak_ShipmentClosedBatch', sch, sh1);
	  Test.stopTest();

  }
}