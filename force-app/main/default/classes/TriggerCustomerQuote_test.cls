@isTest()
public class TriggerCustomerQuote_test {
    
    @isTest
    public static void pruebaFN(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = a.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Type__c = 'Shipping Address	';
        insert address;
        
        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = a.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=19.6248115;
        address2.Address_Coordinates__Longitude__s=-99.18076289999999;
        address2.Type__c = 'Shipping Address	';
        insert address2;
        
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
          cq.Account_Origin_Address__c = address.id;
        cq.Account_Destination_Address__c = address2.id;
        
        insert cq;
        
        
        list<Customer_Quote__c> listaRegistros = new list<Customer_Quote__c>();
        listaRegistros.add(cq);
        TriggerCustomerQuote.ActualizarShipment(listaRegistros);
        
        
        /*cq.Account_Origin_Address__c = null;
        cq.Account_Destination_Address__c = null;
        cq.Team__c = 'WCA';
        cq.Freight_Mode__c = 'Sea';
        cq.Service_Mode__c = 'Import';
        update cq;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Units__c = 1,Total_Shipping_Weight_Kgs__c= 1);
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote2;
        
        cq.Destination_Address__c = 'Hola 2';
        cq.Origin_Address__c = 'Hola 2';
        cq.Account_Origin_Address__c = address.id;
        cq.Account_Destination_Address__c = address2.id;
        cq.Quotation_status__c = 'Approved as Succesful';
        update cq;
        */
    /*    cq.Account_Origin_Address__c = null;
        cq.Account_Destination_Address__c = null;  
        update cq;
      */  
        
    }

    @isTest
    public static void pruebaFI(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = a.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Type__c = 'Shipping Address	';
        insert address;
        
        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = a.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=19.6248115;
        address2.Address_Coordinates__Longitude__s=-99.18076289999999;
        address2.Type__c = 'Shipping Address	';
        insert address2;
        
        Customer_Quote__c cq = new Customer_Quote__c();
        cq.Team__c = 'P2G';
        cq.Account_for__c = a.id;
        cq.Quotation_status__c ='Quote being prepared';
        cq.Only_Warehouse_Service__c  = true;
        cq.Freight_Mode__c = 'Road';
        cq.Service_Mode__c = 'NATIONAL';
        cq.Name = 'FI-21-003507';
        
        cq.Destination_Address__c = 'Hola';
        cq.Origin_Address__c = 'Hola';
        insert cq;
        
       /* cq.Account_Origin_Address__c = null;
        cq.Account_Destination_Address__c = null;
        cq.Freight_Mode__c = 'Sea';
        cq.Service_Mode__c = 'Import';
        update cq;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Units__c = 1,Total_Shipping_Weight_Kgs__c= 1);
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote2;
        
        cq.Destination_Address__c = 'Hola 2';
        cq.Origin_Address__c = 'Hola 2';
        cq.Account_Origin_Address__c = address.id;
        cq.Account_Destination_Address__c = address2.id;
        
        
        cq.Quotation_status__c = 'Approved as Succesful';
        update cq;
        */
        
       /* cq.Account_Origin_Address__c = null;
        cq.Account_Destination_Address__c = null;  
        
        update cq;
        */
    }
    
    
    static testMethod void testFN() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = a.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Type__c = 'Shipping Address	';
        insert address;
        
        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = a.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=19.6248115;
        address2.Address_Coordinates__Longitude__s=-99.18076289999999;
        address2.Type__c = 'Shipping Address	';
        insert address2;
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = a.Id;
        operador.Operador_Validado__c = true;
        //operador.Truckstop_Email__c = 'test@neurored.com.test';
        insert operador;
        
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403, Vehiculo_Validado__c = true);//, 2.17403
        insert vehicle;
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-FN-20-107098',
                                           Freight_Mode__c='Road', 
                                           Service_Mode__c ='NATIONAL', 
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           Traslado_Ingreso__c = 'Ingreso',
                                           //National_Operator__c = operador.Id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now(),
                                           Approved_date_time__c= Datetime.now()
                                          );
        insert ship;
        
        ship.Shipment_Status_Plann__c = 'Confirmed';
        ship.Account_Origin_Address__c = address.id;
        SHIP.Account_Destination_Address__c = address2.id;
        
        update ship;
        
    }
    
    static testMethod void testFI() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = a.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Type__c = 'Shipping Address	';
        insert address;
        
        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = a.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=19.6248115;
        address2.Address_Coordinates__Longitude__s=-99.18076289999999;
        address2.Type__c = 'Shipping Address	';
        insert address2;
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = a.Id;
        operador.Operador_Validado__c = true;
        //operador.Truckstop_Email__c = 'test@neurored.com.test';
        insert operador;
        
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403,Vehiculo_Validado__c = true);//, 2.17403
        insert vehicle;
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-FI-20-107098',
                                           Freight_Mode__c='Road', 
                                           Service_Mode__c ='NATIONAL', 
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           Traslado_Ingreso__c = 'Ingreso',
                                           //National_Operator__c = operador.Id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now(),
                                           Approved_date_time__c= Datetime.now()
                                          );
        insert ship;
        ship.Shipment_Status_Plann__c = 'Confirmed';
        ship.Account_Destination_Address__c = address2.id;
        SHIP.Account_Origin_Address__c = address.id;
        update ship;
        
    }
    
    @isTest
    public static void pruebaAIR(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        
        
        Customer_Quote__c cq = new Customer_Quote__c();
        cq.Team__c = 'WCA';
        cq.Account_for__c = a.id;
        cq.Quotation_status__c ='Quote being prepared';
        cq.Only_Warehouse_Service__c  = true;
        cq.Freight_Mode__c = 'Sea';
        cq.Service_Mode__c = 'Import';
        cq.Name = 'FN-21-003507';
        
        insert cq;
        
        cq.Freight_Mode__c = 'Air';
        cq.Service_Mode__c = 'EXPORT';
        update cq;
        
        
        update cq;
        
        
    }
    
    @isTest
    public static void pruebasIMPORT(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
		list<Customer_Quote__c> quotes = new list<Customer_Quote__c>();
        
        Customer_Quote__c q1 = getQuote('P2G','Road','IMPORT','FTL','FN-21-003507' );
        quotes.add(q1);
         Customer_Quote__c q2 = getQuote('P2G','Road','IMPORT','LTL','FN-21-003508' );
        quotes.add(q2);
         Customer_Quote__c q3 = getQuote('P2G','Road','IMPORT','FP','FN-21-003509' );
        quotes.add(q3);
         Customer_Quote__c q4 = getQuote('P2G','Road','IMPORT','FO','FN-21-003510' );
        quotes.add(q4);
         Customer_Quote__c q5 = getQuote('P2G','Road','IMPORT','TARIMAS','FN-21-003511' );
        quotes.add(q5);
         Customer_Quote__c q6 = getQuote('P2G','Road','IMPORT','MAYOREO','FN-21-003507' );
        quotes.add(q6);

        insert quotes;
        
        
    }
    
     @isTest
    public static void pruebasEXPORT(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
		list<Customer_Quote__c> quotes = new list<Customer_Quote__c>();
      
         Customer_Quote__c q7 = getQuote('P2G','Road','EXPORT','FTL','FN-21-003521' );
        quotes.add(q7);
         Customer_Quote__c q8 = getQuote('P2G','Road','EXPORT','LTL','FN-21-003522' );
        quotes.add(q8);
         Customer_Quote__c q9 = getQuote('P2G','Road','EXPORT','FP','FN-21-003523' );
        quotes.add(q9);
         Customer_Quote__c q10 = getQuote('P2G','Road','EXPORT','FO','FN-21-003524' );
        quotes.add(q10);
         Customer_Quote__c q11 = getQuote('P2G','Road','EXPORT','TARIMAS','FN-21-003525' );
        quotes.add(q11);
         Customer_Quote__c q12 = getQuote('P2G','Road','EXPORT','MAYOREO','FN-21-003526' );
        quotes.add(q12);
        
        
        insert quotes;
        
        
    }
    
     @isTest
    public static void pruebasNATIONAL(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
		list<Customer_Quote__c> quotes = new list<Customer_Quote__c>();
        
          Customer_Quote__c q13 = getQuote('P2G','Road','NATIONAL','FTL','FN-21-003531' );
        quotes.add(q13);
         Customer_Quote__c q14 = getQuote('P2G','Road','NATIONAL','LTL','FN-21-003532' );
        quotes.add(q14);
         Customer_Quote__c q15 = getQuote('P2G','Road','NATIONAL','FP','FN-21-003533' );
        quotes.add(q15);
         Customer_Quote__c q16 = getQuote('P2G','Road','NATIONAL','FO','FN-21-003534' );
        quotes.add(q16);
         Customer_Quote__c q17 = getQuote('P2G','Road','NATIONAL','TARIMAS','FN-21-003535' );
        quotes.add(q17);
         Customer_Quote__c q18 = getQuote('P2G','Road','NATIONAL','MAYOREO','FN-21-003536' );
        quotes.add(q18);
         Customer_Quote__c q19 = getQuote('P2G','Road','NATIONAL','Extras','FN-21-003537' );
        quotes.add(q19);
        
        insert quotes;
        
        
    }
    
         @isTest
    public static void pruebasINTERNATIONAL(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
		list<Customer_Quote__c> quotes = new list<Customer_Quote__c>();
        
          Customer_Quote__c q19 = getQuote('P2G','Air','INTERNATIONAL','PAQUETERIA','FN-21-003537' );
        quotes.add(q19);
         Customer_Quote__c q20 = getQuote('P2G','Air','INTERNATIONAL','CARGA','FN-21-003538' );
        quotes.add(q20);
          Customer_Quote__c q21 = getQuote('P2G','Road','INTERNATIONAL','PAQUETERIA','FN-21-003537' );
        quotes.add(q21);
         Customer_Quote__c q22 = getQuote('P2G','Air','PORT','CARGA','FN-21-003538' );
        quotes.add(q22);
         Customer_Quote__c q16 = getQuote('WCA','Air','EXPORT','CARGA','FN-21-003534' );
        quotes.add(q16);
        
        insert quotes;
        
        
    }
    
     @isTest
    public static void pruebasAIRS(){
        NEU_StaticVariableHelper.setBoolean1(false);
        
		list<Customer_Quote__c> quotes = new list<Customer_Quote__c>();
        
          Customer_Quote__c q13 = getQuote('P2G','Air','IMPORT','PAQUETERIA','FN-21-003531' );
        quotes.add(q13);
         Customer_Quote__c q14 = getQuote('P2G','Air','IMPORT','CARGA','FN-21-003532' );
        quotes.add(q14);
         Customer_Quote__c q15 = getQuote('P2G','Air','EXPORT','PAQUETERIA','FN-21-003533' );
        quotes.add(q15);
         Customer_Quote__c q16 = getQuote('P2G','Air','EXPORT','CARGA','FN-21-003534' );
        quotes.add(q16);
         Customer_Quote__c q17 = getQuote('P2G','Air','NATIONAL','PAQUETERIA','FN-21-003535' );
        quotes.add(q17);
         Customer_Quote__c q18 = getQuote('P2G','Air','NATIONAL','CARGA','FN-21-003536' );
        quotes.add(q18);
          Customer_Quote__c q19 = getQuote('P2G','Air','NATIONAL','ENVIO NACIONAL','FN-21-003539' );
        quotes.add(q19);
       
        
        
        insert quotes;
        
        
    }
    
    public static Customer_Quote__c getQuote(string team, string freight, string serviceMode, string Stype, string name)
    {
         List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        
       Customer_Quote__c cq = new Customer_Quote__c();
        cq.Team__c = team;
        cq.Account_for__c = a.id;
        cq.Quotation_status__c ='Quote being prepared';
        cq.Only_Warehouse_Service__c  = true;
        cq.Freight_Mode__c = freight;
        cq.Service_Mode__c = serviceMode;
        cq.Name = name;
        cq.Service_Type__c = Stype; 
        
        return cq;
    }
    
}