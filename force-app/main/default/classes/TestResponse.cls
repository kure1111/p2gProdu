@isTest
public class TestResponse {
    @isTest
    public static void tst() {
        
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = a.Id;
        operador.Truckstop_Email__c = 'test@test.com.test';
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
                                           ATD__c = Datetime.now(),
                                           Approved_date_time__c= Datetime.now()
                                          );
        insert ship;
        
        
        Response__c r = new Response__c();
        r.Shipment__c = ship.id;
        r.Message__c = 'Orden de Venta creada:4009208';// 'Orden de Venta creada:200000029 Solicitud de Compra creada:200000029';
        insert r;
        
        Response__c r2 = new Response__c();
        r2.Message__c = 'Orden de Venta Actualizada: 200000 Solicitud de Compra creada:300019';
        insert r2;
        
        Response__c r3 = new Response__c();
        r3.Shipment__c = ship.id;
        r3.Message__c = 'Orden de Venta Actualizada: 104010';
        insert r3;
        
        Response__c r4 = new Response__c();
        r4.Shipment__c = ship.id;
        r4.Message__c = 'Solicitud de Compra Actualizada: 103795';
        insert r4;
        
         Response__c r5 = new Response__c();
        r5.Shipment__c = ship.id;
        r5.Message__c = 'Solicitud de Compra Actualizada: 1012516 / Esta Linea no se actualizo porque ya tiene una OC (DocEntry=52758) - ItemCode: CADA2';
        insert r5;
   
    }
}