@isTest (seeAllData=true)
public class ServiceGoogle_Test {
    @isTest
    public static void getDistance()
    {      
        ServiceGoogle services = new ServiceGoogle();
        services.googleMapsDistanceKM(22.023033,-102.285602,19.6248115,-99.18076289999999);   
    }
    
    @isTest
    public static void getDistanceMI()
    {      
        ServiceGoogle services = new ServiceGoogle();
        services.googleMapsDistanceMI(22.023033,-102.285602,19.6248115,-99.18076289999999);   
    }
    
    @isTest
    public static void getDistanceQuote()
    {      
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        
        Customer_Quote__c cq = new Customer_Quote__c();
        cq.Team__c = 'P2G';
        cq.Account_for__c = a.id;
        cq.Quotation_status__c ='Quote being prepared';
        cq.Only_Warehouse_Service__c  = true;
        cq.Freight_Mode__c = 'Road';
        cq.Service_Mode__c = 'NATIONAL';
        cq.Name = 'FN-21-003507';
        cq.Destination_Address__c = 'Hola';
        cq.Origin_Address__c = 'Hola';
        cq.Origin_Location__Latitude__s = 22.023033;
        cq.Origin_Location__Longitude__s = -102.285602; 
        cq.Destination_Location__Latitude__s =19.6248115;
        cq.Destination_Location__Longitude__s =-99.18076289999999;
        
        insert cq;
        
        list<Customer_Quote__c> quotes = new list<Customer_Quote__c>();
		quotes.add(cq);

        String jsonString = json.serialize(quotes);
        DistanceIEQ.googleMapsDistanceKM(jsonString);   
    }
    
    /*@isTest
    public static void getDistanceShipment()
    {      
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        insert a;
        
         List<Account> list_accountsp = NEU_Utils.getAccounts('Transporter,');
        Account P = list_accountsp[0];
        insert P;
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = P.Id;
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
                                           CARRIER__c = P.ID,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now(),
                                           Origin_Location__Latitude__s = 22.023033, 
                                           Origin_Location__Longitude__s = -102.285602, 
                                           Destination_Location__Latitude__s =19.6248115 ,
                                           Destination_Location__Longitude__s =-99.18076289999999
                                          );
        insert ship;
       
        
        list<Shipment__c> quotes = new list<Shipment__c>();
		quotes.add(ship);

        String jsonString = json.serialize(quotes);
        
         system.debug('jsonString ' + jsonString);
        
        
        DistanceIEQ.googleMapsDistanceKMShipment(jsonString);   
    }*/
    
}