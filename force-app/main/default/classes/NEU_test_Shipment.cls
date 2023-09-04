/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_Shipment {

     
     static testMethod void test_NEU_ConfirmShipmentQuote()
     {
         NEU_StaticVariableHelper.setBoolean1(true);

          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = list_accounts[0];
          insert a;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          NEU_ConfirmShipmentQuote uda = new NEU_ConfirmShipmentQuote(new ApexPages.StandardController( ship ));
          uda.confirm_quote();
      
     }    
     
     static testMethod void test_NEU_ConfirmShipmentRequest()
     {

         NEU_StaticVariableHelper.setBoolean1(true);

          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = list_accounts[0];
          insert a;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          NEU_ConfirmShipmentRequest uda = new NEU_ConfirmShipmentRequest(new ApexPages.StandardController( ship ));
          uda.confirm_request();
     }  
          
     public static testMethod void testNEU_OM_FollowersShipment()
     {//ok

         NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_OM_FollowersShipment uda = new NEU_OM_FollowersShipment(new ApexPages.StandardController( ship ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
  }
  
  
  public static testMethod void test_NEU_New_Service_Rate_Internal()
  {
      NEU_StaticVariableHelper.setBoolean1(true);
      
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account carrier = list_accounts[1];
        insert carrier;
        Contact contacto = new Contact(AccountId = carrier.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id ,Marketplace_Auction__c = true, Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, Shipment_Quoted_Marketplace__c =ship.Id, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Carrier_Account__c = carrier.Id, Account_for__c = a.Id);
        insert fee;
        ApexPages.currentPage().getParameters().put('secret', '10');
        ApexPages.currentPage().getParameters().put('email', 'oscar@neurored.com');
        ApexPages.currentPage().getParameters().put('shipment', ship.Id);
        NEU_New_Service_Rate_Internal nsri = new NEU_New_Service_Rate_Internal(new ApexPages.StandardController( fee ));
        nsri.record2=nsri.record2;
        nsri.shipment_obj=nsri.shipment_obj;
        nsri.id_oi=nsri.id_oi;
        nsri.ruta_id=nsri.ruta_id;
        nsri.rate_type_mod=nsri.rate_type_mod;
        nsri.routes=nsri.routes;
        nsri.route_selected_id=nsri.route_selected_id;
        nsri.route_selected_Name=nsri.route_selected_Name;
        nsri.acabo_de_guardar=nsri.acabo_de_guardar;
        nsri.route_selected_id2=nsri.route_selected_id2;
        nsri.route_selected_Name2=nsri.route_selected_Name2;
        nsri.getlistado_fees_carrier();
        nsri.go_compare_fees_filtro();
        nsri.getcarrier_id();
        nsri.setcarrier_id(null);
        nsri.getranking();
        nsri.setranking(null);
        nsri.create_new_fee();
        nsri.getlistado_rate_type();
        nsri.decimalSep=nsri.decimalSep;
        nsri.thousandSep=nsri.thousandSep;
        nsri.check_fee();
        List<Shipment__c> listado_shipment_selected = new List<Shipment__c>();
        listado_shipment_selected.add(ship);
        nsri.shipment_selected = listado_shipment_selected;
        nsri.update_Ranking();
        nsri.update_ranking_send_email();
        nsri.send_form();
        nsri.id_oi=fee.id;
        nsri.load_fee_select();
        nsri.record=fee;
        nsri.send_form();
    }

    public static testMethod void test_NEU_New_Service_Rate_Internalroute()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
       
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account carrier = list_accounts[1];
        insert carrier;
        Contact contacto = new Contact(AccountId = carrier.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id ,Marketplace_Auction__c = true, Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, Shipment_Quoted_Marketplace__c =ship.Id, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Carrier_Account__c = carrier.Id, Account_for__c = a.Id);
        insert fee;
        ApexPages.currentPage().getParameters().put('secret', '10');
        ApexPages.currentPage().getParameters().put('email', 'oscar@neurored.com');
        ApexPages.currentPage().getParameters().put('route', route.Id);
        NEU_New_Service_Rate_Internal nsri = new NEU_New_Service_Rate_Internal(new ApexPages.StandardController( fee ));
        nsri.check_fee();
        nsri.create_new_fee();
        nsri.record=fee;
        nsri.update_Ranking();
        nsri.update_ranking_send_email();
    }
    
    public static testMethod void test_NEU_New_Service_Rate_Internalship_prog()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
      
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account carrier = list_accounts[1];
        insert carrier;
        Contact contacto = new Contact(AccountId = carrier.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
        insert ship_prog;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id ,Marketplace_Auction__c = true , Inbound_Consolidation_Program__c = ship_prog.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, Shipment_Quoted_Marketplace__c =ship.Id, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Carrier_Account__c = carrier.Id, Account_for__c = a.Id);
        insert fee;
        ApexPages.currentPage().getParameters().put('secret', '10');
        ApexPages.currentPage().getParameters().put('email', 'oscar@neurored.com');
        ApexPages.currentPage().getParameters().put('ships_program', ship_prog.Id);
        NEU_New_Service_Rate_Internal nsri = new NEU_New_Service_Rate_Internal(new ApexPages.StandardController( fee ));
        nsri.check_fee();
        nsri.create_new_fee();
        nsri.record=fee;
        nsri.update_Ranking();
        nsri.update_ranking_send_email();
    }
    
    public static testMethod void test_NEU_StaticVariableHelper() 
    {
        NEU_StaticVariableHelper svh = new NEU_StaticVariableHelper();
        NEU_StaticVariableHelper.setBoolean1(true);
        NEU_StaticVariableHelper.getBoolean1();
    }
    
    public static testMethod void test_NEU_New_Service_Rate_Internalie()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
      
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account carrier = list_accounts[1];
        insert carrier;
        Contact contacto = new Contact(AccountId = carrier.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id ,Marketplace_Auction__c = true, Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, Shipment_Quoted_Marketplace__c =ship.Id, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Carrier_Account__c = carrier.Id, Account_for__c = a.Id);
        insert fee;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address'); 
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        ApexPages.currentPage().getParameters().put('secret', '10');
        ApexPages.currentPage().getParameters().put('email', 'oscar@neurored.com');
        ApexPages.currentPage().getParameters().put('import_export', importexportquote.Id);
        NEU_New_Service_Rate_Internal nsri = new NEU_New_Service_Rate_Internal(new ApexPages.StandardController( fee ));
        nsri.check_fee();
        nsri.create_new_fee();
        nsri.record=fee;
        nsri.update_Ranking();
        nsri.update_ranking_send_email();
    }
  
    public static testMethod void test_NEU_FreightSourcingQuote()
    {//ok

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Route__c = route.Id, Active__c= true, Account_for__c = a.Id);
        insert fee;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id, Only_Warehouse_Service__c = true);
        insert ship;
        NEU_FreightSourcingQuote fsq = new NEU_FreightSourcingQuote(new ApexPages.StandardController( ship ));
        fsq.ordenar_tabla_fees();
  }
  
  
  
      public static testMethod void testNEU_OM_FollowersShipment2()
      {//ok

          NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_OM_FollowersShipment uda = new NEU_OM_FollowersShipment(new ApexPages.StandardController( ship ));
        List<NEU_OM_FollowersShipment.follower_s> lista_de_followers = new List<NEU_OM_FollowersShipment.follower_s>();
        List<User> listauser = [select id, Name from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersShipment.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersShipment.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersShipment.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersShipment.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersShipment.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
  }
  
  
  
  
  
      static testMethod void test_NEU_OM_Save_Generate_Quote_Shipment()
      {

          NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        NEU_OM_Save_Generate_Quote_Shipment gpcc = new NEU_OM_Save_Generate_Quote_Shipment(new ApexPages.StandardController( ship ));
        system.debug( 'Prueba realizada' );
        Blob b = Blob.valueOf('Test Data');
        gpcc.documento_asociado.Name='Test document.test';
        gpcc.documento_asociado.AuthorId = UserInfo.getUserId();
        gpcc.documento_asociado.IsPublic=true;
        gpcc.documento_asociado.Body = b;
        gpcc.crear();
    }
    
    static testMethod void test_NEU_SP_Track_Trace()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_SP_Track_Trace sptt = new NEU_SP_Track_Trace(new ApexPages.StandardController( ship ));
       
    }
    
    static testMethod void test_NEU_Shipment_Notifications_PDF()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       NEU_Shipment_Notifications_PDF ship_notification = new NEU_Shipment_Notifications_PDF(new ApexPages.StandardController( ship ));
       ship_notification.load_template();
       ship_notification.load_template_arrival_confirmation_english();
       ship_notification.load_template_arrival_confirmation_spanish();
       ship_notification.load_template_arrival_notification_english();
       ship_notification.load_template_arrival_notification_spanish();
       ship_notification.load_template_shipment_tracking_english();
       ship_notification.load_template_shipment_tracking_spanish();
       ship_notification.load_template_departure_confirmation_english();
       ship_notification.load_template_departure_confirmation_spanish();
       ship_notification.load_template_departure_confirmationFI_english();
       ship_notification.load_template_departure_confirmationFI_spanish();
       ship_notification.load_template_booking_confirmation_english();
       ship_notification.load_template_booking_confirmation_spanish();
       ship_notification.load_template_departure_timetable_english();
       ship_notification.load_template_departure_timetable_spanish();
        ship_notification.load_template_fn_estandar_english();
        ship_notification.load_template_fn_estandar_spanish();
        ship_notification.load_template_fn_manantiales_asuncion_english();
        ship_notification.load_template_fn_manantiales_asuncion_spanish();
        ship_notification.load_template_fn_cerveceria_modelo_english();
        ship_notification.load_template_fn_cerveceria_modelo_spanish();
        ship_notification.load_template_fn_owens_english();
        ship_notification.load_template_fn_owens_spanish();
        ship_notification.load_template_fn_kimberly_clark_english();
        ship_notification.load_template_fn_kimberly_clark_spanish();
        ship_notification.load_template_fn_bonafont_english();
        ship_notification.load_template_fn_bonafont_spanish();
        ship_notification.load_template_fn_barcel_english();
        ship_notification.load_template_fn_barcel_spanish();
        ship_notification.load_template_fn_sealy_english();
        ship_notification.load_template_fn_sealy_spanish();
        ship_notification.load_template_shipment_tracking_english_ata();
        ship_notification.load_template_shipment_tracking_spanish_ata();
        ship_notification.load_template_fn_estandar_customer_english();
        ship_notification.load_template_fn_estandar_customer_spanish();
        ship_notification.load_template_pto_estandar_english();
        ship_notification.load_template_pto_estandar_spanish();
        ship_notification.load_template_air_shipment_tracking_english();
        ship_notification.load_template_air_shipment_tracking_spanish();









       
    }
    
    static testMethod void test_NEU_Shipment_Notifications_save_PDF()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       NEU_Shipment_Notifications_save_PDF ship_notification = new NEU_Shipment_Notifications_save_PDF(new ApexPages.StandardController( ship ));
       Blob b = Blob.valueOf('Test Data');
       ship_notification.documento_asociado.Name='Test document.test';
       ship_notification.documento_asociado.AuthorId = UserInfo.getUserId();
       ship_notification.documento_asociado.IsPublic=true;
       ship_notification.documento_asociado.Body = b;
       ship_notification.crear();
       ship_notification.return_page();
    }
    
     static testMethod void test_NEU_OM_Shipment_Steps()
     {

         NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;

        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
       
        system.debug( 'Prueba realizada' );
    }
    
      static testMethod void test_NEU_OM_Shipment_Steps2()
      {

          NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
       
        system.debug( 'Prueba realizada' );
    }
    
      static testMethod void test_NEU_OM_Shipment_Steps3()
      {

          NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
       
        system.debug( 'Prueba realizada' );
    }
    
      static testMethod void test_NEU_OM_Shipment_Steps4()
      {

          NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Customs_Value__c=10);
        insert shipline;

        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
       
        system.debug( 'Prueba realizada' );
    }
    
    static testMethod void test_NEU_OM_GenerateQuote_Shipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        NEU_OM_GenerateQuote_Shipment gpcc = new NEU_OM_GenerateQuote_Shipment(new ApexPages.StandardController( ship ));
        
    }
    
    
    static testMethod void NEU_Standard_Fee_Calculation_Shipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = sup.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c =route.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id);
        insert shipline;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Standard_Rate__c  = true, Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        List<Fee__c>feesToAdd=new List<Fee__c>();
        Fee__c fee1 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee1);
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee2);
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee3);
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee4);
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee5);
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee6);
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee7);
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee8);
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee9);
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee10);
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee11);
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee12);
        insert feesToAdd;
        
        NEU_Standard_Fee_Calculation_Shipment ie = new NEU_Standard_Fee_Calculation_Shipment(new ApexPages.StandardController( ship ));
        ie.crear_fee_estandar();
        ie.cancel();
    }
    
    static testMethod void test_NEU_SendDocuments_Shipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        a.Status_Account__c = 'Active';
        insert a;

        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email='oscar@neurored.com');
        insert contacto;
        Account sup = list_accounts[1];
        insert sup;

        Contact contacto2 = new Contact(AccountId = sup.Id, LastName='test contact2', Email='oscar2@neurored.com');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Supplier_Account__c = sup.Id, Only_Warehouse_Service__c = true);
        insert ship;
        ContentVersion cvFile = new ContentVersion();//Es el fichero en sí mismo
        cvFile.ContentLocation = 'S'; //S==SALESFORCE
        Blob blobtest = Blob.valueOf('Test Data');
        cvFile.VersionData = blobtest;
        cvFile.Title = 'Test document';
        cvFile.PathOnClient = 'Test document';
        insert cvFile;

        Associated_Document__c documentos_asociados = new Associated_Document__c(Name='test associated document', Account__c=a.Id, Shipment__c=ship.Id);
        insert documentos_asociados;

        NEU_SendDocuments_Shipment ie = new NEU_SendDocuments_Shipment(new ApexPages.StandardController( ship ));
        List<NEU_SendDocuments_Shipment.documents_s> associated_documents_new = new List<NEU_SendDocuments_Shipment.documents_s>();
        associated_documents_new.add(new NEU_SendDocuments_Shipment.documents_s(true, 'pdf.pdf','pdf', 'reference', 'description', '', documentos_asociados.Id, cvFile.Id,0,'10'));

        ie.associated_documents = associated_documents_new;

        List<NEU_SendDocuments_Shipment.contacto_s> clientes_contacntos_new = new List<NEU_SendDocuments_Shipment.contacto_s>();
        clientes_contacntos_new.add(new NEU_SendDocuments_Shipment.contacto_s(contacto, true, 'oscar@neurored.com'));

        List<NEU_SendDocuments_Shipment.cuenta_s> clientes_seleccionados_new = new List<NEU_SendDocuments_Shipment.cuenta_s>();
        clientes_seleccionados_new.add(new NEU_SendDocuments_Shipment.cuenta_s(a, clientes_contacntos_new,'Customer'));
        ie.clientes_seleccionados = clientes_seleccionados_new;
        ie.send_email();
        ie.return_shipment();

        ie.optionTemplate = 1;
        ie.load_template();
        ie.add_link_to_body();
        ie.add_link_to_body2();

    }
    
    static testMethod void test_NEU_Order_Confirmation_Shipment_save_pdf()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       NEU_Order_Confirmation_Shipment_save_pdf uda = new NEU_Order_Confirmation_Shipment_save_pdf(new ApexPages.StandardController( ship ));
       Blob b = Blob.valueOf('Test Data');
       uda.documento_asociado.Name='Test document.test';
       uda.documento_asociado.AuthorId = UserInfo.getUserId();
       uda.documento_asociado.IsPublic=true;
       uda.documento_asociado.Body = b;
       uda.crear();
        
     }
     
     static testMethod void test_NEU_Proforma_Invoice_pdf()
     {

         NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('services_charges', 'true');
       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       Product_Family__c fam = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
       insert fam;
       Subfamily__c subfam = new Subfamily__c(Product_Family__c = fam.Id, Name = 'test subfamily');
       insert subfam;
       Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfam.Id, Sourcing_Family__c =fam.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
       insert item;
       List<Shipment_Line__c> listado_lineas_ship = new List<Shipment_Line__c>();
       Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline);
       Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline2);
       Shipment_Line__c shipline3 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline3);
       Shipment_Line__c shipline4 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline4);
       Shipment_Line__c shipline5 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline5);
       Shipment_Line__c shipline6 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline6);
       Shipment_Line__c shipline7 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline7);
       Shipment_Line__c shipline8 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline8);
       Shipment_Line__c shipline9 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline9);
       Shipment_Line__c shipline10 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline10);
       Shipment_Line__c shipline11 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
       listado_lineas_ship.add(shipline11);
       Shipment_Line__c shipline12 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Expense_Amount__c=100);
       listado_lineas_ship.add(shipline12);
       insert listado_lineas_ship;
       NEU_Proforma_Invoice_pdf uda = new NEU_Proforma_Invoice_pdf(new ApexPages.StandardController( ship ));
       
     }
     
     static testMethod void test_NEU_Proforma_Invoice_save_pdf()
     {

         NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       NEU_Proforma_Invoice_save_pdf uda = new NEU_Proforma_Invoice_save_pdf(new ApexPages.StandardController( ship ));
       Blob b = Blob.valueOf('Test Data');
       uda.documento_asociado.Name='Test document.test';
       uda.documento_asociado.AuthorId = UserInfo.getUserId();
       uda.documento_asociado.IsPublic=true;
       uda.documento_asociado.Body = b;
       uda.crear();
     }
     
     static testMethod void test_NEU_Shipment_Exporter_Steps()
     {

         NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       Associated_Document__c documentos_asociados = new Associated_Document__c(Name='test associated  Shipping_Marks document', Account__c=a.Id, Shipment__c=ship.Id);
       insert documentos_asociados;
       Associated_Document__c documentos_asociados2 = new Associated_Document__c(Name='test aDeliveryNote document', Account__c=a.Id, Shipment__c=ship.Id, Document_Type__c ='Order Confirmation');
       insert documentos_asociados2;
       Associated_Document__c documentos_asociados3 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, Shipment__c=ship.Id, Document_Type__c ='Proforma Invoice');
       insert documentos_asociados3;
       Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Customs_Value__c  =100);
       insert shipline;
       Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
       insert fee;
       Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
       insert shipfeeline;
       NEU_Shipment_Exporter_Steps uda = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
       
     }
     
     
     static testMethod void test_NEU_Order_Confirmation_Shipment_pdf()
     {

         NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       Product_Family__c fam = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
       insert fam;
       Subfamily__c subfam = new Subfamily__c(Product_Family__c = fam.Id, Name = 'test subfamily');
       insert subfam;
       Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfam.Id, Sourcing_Family__c =fam.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
       insert item;
       Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Expense_Amount__c = 10);
       insert shipline;
       Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Standard_Rate__c  = true, Account_for__c = a.Id);
       insert fee;
       Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
       insert shipfeeline; 
       ApexPages.currentPage().getParameters().put('services_charges', 'true');
       NEU_Order_Confirmation_Shipment_pdf uda = new NEU_Order_Confirmation_Shipment_pdf(new ApexPages.StandardController( ship ));
       
     }
    
    
    static testMethod void test_NEU_Standard_Duty_Calculator_Shipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = sup.Id);
        insert b; 
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id);
        insert shipline;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        
        Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id, Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship2.Id, Name= 'test ship line',  Item_Name__c = g.Id);
        insert shipline2;
        
        NEU_Standard_Duty_Calculator_Shipment ie = new NEU_Standard_Duty_Calculator_Shipment(new ApexPages.StandardController( ship ));
        ie.calcular_tasas();
        ie.refresh();
        ie.volver();
        NEU_Standard_Duty_Calculator_Shipment ie2 = new NEU_Standard_Duty_Calculator_Shipment(new ApexPages.StandardController( ship2 ));
        ie2.calcular_tasas();
       }
       
       
    static testMethod void test_NEU_OM_CreateShipmentsItemsLines()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Shipping_Weight_Kg__c =100, Units_Shipped__c = 100);
        insert shipline;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Account_for__c = a.Id);
        insert fee;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Account_for__c = a.Id);
        insert fee2;
        Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c(Shipment__c =ship.Id, Service_Rate_Name__c=fee.Id, Units__c = 10, Shipment_Sell_Price__c = 100);
        insert ship_fee_line;
        Shipment_Fee_Line__c ship_fee_line2 = new Shipment_Fee_Line__c(Shipment__c =ship.Id, Service_Rate_Name__c=fee2.Id, Units__c = 10, Shipment_Sell_Price__c = 100);
        insert ship_fee_line2;
        /*
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id,
        Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');
        insert importexportquote;
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;
        Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Name = 'Test ',Import_Export_Quote__c = quote.Id    );
        insert scd;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');
        insert importexportquote;
        Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert scd;
*/
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Last_Shipment__c = ship.Id);
        insert importexportquote;
        Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert scd;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id);
        insert shipline2;


        pallet_warehouse__c pw = new pallet_warehouse__c(Name = 'test_pallet', Height_cm__c=100, lenght_cm__c=100, width_cm__c=100, Import_export__c = importexportquote.Id, shipment__c = ship.Id);

        NEU_OM_CreateShipmentsItemsLines gpcc=new NEU_OM_CreateShipmentsItemsLines(new ApexPages.StandardController( ship ));
        gpcc.nuevo_item = shipline;
        gpcc.crearlineaquoteitem();
        gpcc.getShipmentItemsLines();
        gpcc.update_lineas_ship();
        gpcc.goToPallets();
        gpcc.decimalSep = '';
        gpcc.thousandSep = '';
    }
    
    /*public static testMethod void testNEU_OM_ShipFeeLinesPriceListYDiscount_antig()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee2;
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee3;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
    
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        List<Fee__c>feesToAdd=new List<Fee__c>();
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee4); 
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee5); 
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee6); 
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee14); 
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee15); 
        Fee__c fee16 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee16); 
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee7); 
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee8); 
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee9); 
        Fee__c fee17 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee17); 
        Fee__c fee18 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee18); 
        Fee__c fee19 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee19); 
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee10); 
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee11); 
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee12);
        Fee__c fee20 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee20);
        Fee__c fee21 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee21);
        Fee__c fee22 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee22);
        insert feesToAdd; 
        
        
        NEU_OM_ShipFeeLinesPriceListYDiscount uda = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController( ship ));
        string value = '';
        
        uda.chekeados = true;
        uda.getnewcategories();
        uda.getnewcategory();
        uda.setnewcategory(fee.Fee_Category__c);
        uda.getrecordtype();
        uda.setrecordtype(fee.RecordTypeId);
        uda.getFee_List_Price();
        uda.getshipfeeLines();
        uda.categories();
        for(NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s sfl: uda.Fee_List_Price)
            sfl.selected = true;
        uda.crearlineaquoteitem();
        uda.update_route();
        uda.id_oi = shipfeeline.Id;
        uda.delete_fee_select();
        uda.return_shipment();
        
        system.debug( 'Prueba realizada' );
    }*/

    public static testMethod void testNEU_OM_ShipFeeLinesPriceListYDiscount()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        //Añadimos varios pallet en la clase
        Pallet_warehouse__c pallet_wa = new pallet_warehouse__c();
        pallet_wa.Height_cm__c = 20;
        pallet_wa.lenght_cm__c = 20;
        insert pallet_wa;
        List<Country__c> countrylisttest = new List<Country__c>();
        Country__c country = new Country__c(Name='test country', ISO_Code__c='EUR');
        Country__c country2 = new Country__c(Name='test country2', ISO_Code__c='EUR');
        countrylisttest.add(country);
        countrylisttest.add(country2);
        insert countrylisttest;
        List<State__c> statelisttest = new List<State__c>();
        State__c state = new State__c(Name = 'test state', ISO_Code_2c__c = 'te', country__c = country.Id);
        State__c state2 = new State__c(Name = 'test state2', ISO_Code_2c__c = 't', country__c = country2.Id);
        statelisttest.add(state);
        statelisttest.add(state2);
        insert statelisttest;
        List<Location__c> locationlisttest = new List<Location__c>();
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c=country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state.Id);
        Location__c localizacion2 = new Location__c(Name='test localizacion2', City__c='test city2', Country__c=country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state2.Id);
        locationlisttest.add(localizacion);
        locationlisttest.add(localizacion2);
        insert locationlisttest;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=country2.Id, Country_of_Load__c=country.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id,State_of_Load__c = state.Id, State_of_Discharge__c = state2.Id);
        insert route;
        List<Shipment__c> shiplisttest = new List<Shipment__c>();
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true,Route__c=route.Id,Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id);
        Shipment__c shipR = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
        Shipment__c shipi = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
        shiplisttest.add(ship);
        shiplisttest.add(shipR);
        shiplisttest.add(shipi);
        insert shiplisttest;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        List<Container_Type__c> contalisttest = new List<Container_Type__c>();
        Container_Type__c container = new Container_Type__c(Cargo_Volume_m3__c=100,Cargo_Weight_Kg__c=100,Height_cm__c=100,Length_cm__c=100,Pallet_Configuration__c='test pallet',Teus__c=100,Width_cm__c=100);
        Container_Type__c container2 = new Container_Type__c(Cargo_Volume_m3__c=10,Cargo_Weight_Kg__c=10,Height_cm__c=10,Length_cm__c=10,Pallet_Configuration__c='test pallet2',Teus__c=10,Width_cm__c=10);
        contalisttest.add(container);
        contalisttest.add(container2);
        insert contalisttest;
        Delivery_Zone__c delivery = new Delivery_Zone__c(Kms__c=10,Miles__c=20,Port_Airport__c=localizacion.Id,Test_upload__c=true);
        insert delivery;
        List<Fee__c> fl_test = new List<Fee__c>();
        Fee__c fee = new Fee__c(Name = 'testconstringlargoparacomprobarunavariabletrunavariabletiabletetiabletetetiablet', Fee_Category__c = 'Clearing Cost', Rate_Type__c = 'Fixed', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(10),Valid_From__c=system.today(),Port_Airport__c=localizacion.Id,TT_Days__c='59',Container_Type__c=container.Id,Route__c=route.Id,Max_Kgs__c=545,Max_M3__c=4,Min__c=8,Buy_Rate__c=58,Fee_Rate__c=191,Volumetric_Factor__c=143);
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Drayages', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=556,Max_M3__c=7,Min__c=10,Buy_Rate__c=57,Rate_Type__c='Per Container',Fee_Rate__c=11,Volumetric_Factor__c=145);
        Fee__c fee3 = new Fee__c(Name = 'test fees3', Fee_Category__c = 'Drayages', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=55,Max_M3__c=71,Min__c=11,Buy_Rate__c=57,Rate_Type__c='Per Container',Fee_Rate__c=12,Volumetric_Factor__c=140);
        Fee__c fee4 = new Fee__c(Name = 'test fees4', Fee_Category__c = 'POD Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='561',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=53,Max_M3__c=72,Min__c=12,Buy_Rate__c=58,Rate_Type__c='Per Container',Fee_Rate__c=13,Volumetric_Factor__c=141);
        Fee__c fee5 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142);
        Fee__c fee6 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'Other Service Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142);
        fl_test.add(fee);
        fl_test.add(fee2);
        fl_test.add(fee3);
        fl_test.add(fee4);
        fl_test.add(fee5);
        fl_test.add(fee6);
        insert fl_test;
        List<Shipment_Fee_Line__c> sfl_test = new List<Shipment_Fee_Line__c>();
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
        Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee2.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline3 = new Shipment_Fee_Line__c(Name='test shipment fee line3', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee3.Id , Shipment__c= shipi.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline4 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee4.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline5 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline6 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee6.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        sfl_test.add(shipfeeline);
        sfl_test.add(shipfeeline2);
        sfl_test.add(shipfeeline3);
        sfl_test.add(shipfeeline4);
        sfl_test.add(shipfeeline5);
        sfl_test.add(shipfeeline6);
        insert  sfl_test;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Last_Shipment__c = ship.Id);
        insert importexportquote;
        Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert scd;
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;
        NEU_OM_ShipFeeLinesPriceListYDiscount uda = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController( ship ));
        //string value = '';
        ////Get/Set de variables
        uda.chekeados_ie =uda.chekeados_ie;
        uda.id_oi=uda.id_oi;
        uda.listado_ids_carrier=uda.listado_ids_carrier;
        uda.url_sailing_schedule=uda.url_sailing_schedule;
        uda.url_alibaba=uda.url_alibaba;
        uda.show_all_categories=uda.show_all_categories;
        uda.show_all_categories_all_lines=uda.show_all_categories_all_lines;
        uda.fee_currency=uda.fee_currency;
        List<SelectOption> currencys = new List<SelectOption>();

        List<NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s> atpd = new List<NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s>();
        atpd.add(new NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s(null,shipfeeline,true,'extension test', '10', '10', '0', '10', null,UserInfo.getDefaultCurrency(),uda,10, true));
        atpd.add(new NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s(null,shipfeeline,true,'extension test', '10', '10', '0', '10', null, UserInfo.getDefaultCurrency(),uda,10, true));

        for(NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s lo: atpd)
        {
            lo.selected = true;
        }
        uda.categories();
        uda.setnewcategory('Disbursement');
        uda.setrecordtype('Other Service Charges');
        uda.getrecordtype();
        uda.getFee_List_Price();
        uda.getshipfeeLines();
        System.debug(uda.getnewcategories()+' Categoria de prueba');
        uda.chekeados = true;
        //Inicio clase NEUEBUSCM_Shipment_Fee_Line_s
        List<SelectOption> currencystemp=new List<SelectOption>();
        currencystemp.add(new SelectOption('EN','EN'));
        List<SelectOption> currencystemp2=new List<SelectOption>();
        currencystemp2.add(new SelectOption('ES','EN'));
        NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s item = new NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s(fee,shipfeeline,true,'test extension','test unit','test sell','test discount','test buy',currencystemp,'test currency user',uda,10,true);
        NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s item2 = new NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s(fee2,shipfeeline2,true,'test extension2','test unit2','test sell2','test discount2','test buy2',currencystemp2,'test currency user2',uda,20,true);
        item.total_buy=item.total_buy;
        item.total_sell=item.total_sell;
        item.total_sell='20';
        item.total_buy='22';
        item2.total_sell='10';
        item2.total_buy='12';
        //Comparacion en el filtro
        uda.orden_fees_filtro='line.Name';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Name';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Valid_Until__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Valid_Until__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Valid_Until__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='weight_factor';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='weight_factor';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_sell';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_sell';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_buy';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_buy';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Account_for__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Account_for__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Carrier_Account__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Carrier_Account__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Route__r.Name';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Route__r.Name';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Delivery_Zone__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Delivery_Zone__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.CreatedDate';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.CreatedDate';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Port_Airport__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Port_Airport__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.TT_Days__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.TT_Days__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Rate_Type__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Rate_Type__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Fee_Rate__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Fee_Rate__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Container_Type__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Container_Type__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Pallet_Type__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Pallet_Type__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_Kgs__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_Kgs__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_M3__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_M3__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Buy_Rate__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Buy_Rate__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Min__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Min__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Volumetric_Factor__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Volumetric_Factor__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Units__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Units__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Sell_Price__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Sell_Price__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Discount_Charge__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Discount_Charge__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Buy_Price__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Buy_Price__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        //Fin comparaciones filtro
        uda.crearlineaquoteitem();
        uda.Fee_List_Price= new List<NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s>();
        uda.Fee_List_Price.add(item2);
        uda.crearlineaquoteitem();
        //Fin clase NEUEBUSCM_Shipment_Fee_Line_s
        //Inicio de clase Shipment_Fee_Line_all_s
        List<NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_currency_s> shiplistcur = new List<NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_currency_s>();
        shiplistcur.add(new NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_currency_s(shipfeeline, Neu_currencyUtils.getCurrencyIsoCode(shipfeeline)));
        NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_all_s shipitemtest = new NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_all_s(uda,'testLoad','testDischarge',shiplistcur,23,25,6);
        shipitemtest.gettotal_buy_format();
        shipitemtest.gettotal_sell_format();
        shipitemtest.total_buy=null;
        shipitemtest.total_sell=null;
        shipitemtest.gettotal_buy_format();
        shipitemtest.gettotal_sell_format();
        //Fin clase Shipment_Fee_Line_all_s
        uda.change_ratio_category();
        uda.update_sites_countries();
        uda.return_shipment();
        uda.checkExistRoute();
        NEU_OM_ShipFeeLinesPriceListYDiscount.remove1('Prúeba');
        uda.all_accounts_filter();
        uda.all_carriers_filter();
        uda.filter_new_carrier();
        uda.getshipfeeLines_all_for_route();
        uda.all_containers_filter();
        uda.getshipfeeLines_all();
        uda.getshipfeeLines_without();
        uda.buscar_paises_sites();
        uda.getshipment_filter();
        uda.sortList(6);
        uda.setshipment_filter(ship);
        uda.getservice_rate_filter();
        uda.setservice_rate_filter(fee);
        uda.decimalSep=uda.decimalSep;
        uda.thousandSep=uda.thousandSep;
        uda.sum_buy_amount_ie_string=uda.sum_buy_amount_ie_string;
        uda.sum_sell_amount_ie_string=uda.sum_sell_amount_ie_string;

        NEU_OM_ShipFeeLinesPriceListYDiscount udafilter = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController( ship ));
        udafilter.change_ratio_category();
        udafilter.record.Service_Mode__c='NATIONAL';
        udafilter.setnewcategory('Road Freights');
        udafilter.getFee_List_Price();
        udafilter.setnewcategory('Sea Freights');
        udafilter.getIE_lines();
        for(NEU_OM_ShipFeeLinesPriceListYDiscount.IE_Fee_Line_s ie_fee : udafilter.IE_lines){
           ie_fee.selected=true;
        }
        udafilter.create_shipment_service_ie();
        udafilter.change_ratio_category();
        udafilter.setnewcategory('Drayages');
        udafilter.change_ratio_category();
        udafilter.setnewcategory('Other Service Charges');
        udafilter.getshipfeeLines_all();
        udafilter.all_routes_filter();
        udafilter.update_check_show_all_categories();
        udafilter.update_check_hidden_all_categories();
        NEU_OM_ShipFeeLinesPriceListYDiscount.IE_Fee_Line_s itemie = new NEU_OM_ShipFeeLinesPriceListYDiscount.IE_Fee_Line_s(udafilter,shipfeeline2,true,'test idIE');
        itemie.selected=itemie.selected;
        itemie.id=itemie.id;
        itemie.total_sell=itemie.total_sell;
        itemie.total_buy=itemie.total_buy;
        itemie.getValue('test shipment fee line');
        udafilter.create_new_service_rate();
        udafilter.shipment_filter.Carrier__c=a.Id;
        udafilter.shipment_filter.Country_of_Load__c=country.Id;
        udafilter.shipment_filter.Country_of_Discharge__c=country.Id;
        udafilter.shipment_filter.Site_of_Load__c=localizacion.Id;
        udafilter.shipment_filter.Site_of_Discharge__c=localizacion2.Id;
        udafilter.shipment_filter.State_of_Discharge__c=state.Id;
        udafilter.shipment_filter.State_of_Load__c=state.Id;
        udafilter.shipment_filter.Container_Type__c=container.Id;
        udafilter.shipment_filter.Delivery_Cartage__c=delivery.Id;
        udafilter.createNewRoute();
        //Pruebas con shipment_filter
        udafilter.anterior_siguiente_fee();
        udafilter.buscar_paises_sites();
        udafilter.shipment_filter.Pickup_Cartage__c=delivery.Id;
        udafilter.shipment_filter.Site_of_Discharge__c=null;
        udafilter.shipment_filter.Site_of_Load__c=null;
        udafilter.shipment_filter.Site_of_Discharge__c=localizacion2.Id;
        udafilter.shipment_filter.Site_of_Load__c=localizacion.Id;
        udafilter.shipment_filter.Route__c=route.Id;
        udafilter.record.Route__c=null;
        uda.crearlineaquoteitem();
        udafilter.shipment_filter.Country_of_Load__c=null;
        udafilter.shipment_filter.Country_of_Discharge__c=null;
        udafilter.shipment_filter.Site_of_Load__c=null;
        udafilter.shipment_filter.Site_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Load__c=null;
        udafilter.shipment_filter.Container_Type__c=null;
        udafilter.totals_custom.total_Services_Sell_Amount_s_currency='1213';
        new NEU_OM_ShipFeeLinesPriceListYDiscount.totales_s(ship);


        //Metodos varios para testear
        udafilter.getshipfeeLines_all_for_route();
        udafilter.update_route();
        udafilter.delete_fee_select();
        udafilter.update_record();
        udafilter.record=null;
        udafilter.update_record();
        udafilter.go_compare_fees_filtro();
        udafilter.search_name_filter();
        udafilter.go_compare_fees_filtro_insertados();
        NEU_OM_ShipFeeLinesPriceListYDiscount udashipi = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController( shipi ));
        udashipi.getshipfeeLines_all_for_route();

        system.debug( 'Prueba realizada');

    }

    public static testMethod void testNEU_OM_ShipFeeLinesPriceListYDiscount_2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        List<Country__c> countrylisttest = new List<Country__c>();
        Country__c country = new Country__c(Name='test country', ISO_Code__c='EUR');
        Country__c country2 = new Country__c(Name='test country2', ISO_Code__c='EUR');
        countrylisttest.add(country);
        countrylisttest.add(country2);
        insert countrylisttest;
        List<State__c> statelisttest = new List<State__c>();
        State__c state = new State__c(Name = 'test state', ISO_Code_2c__c = 'te', country__c = country.Id);
        State__c state2 = new State__c(Name = 'test state2', ISO_Code_2c__c = 't', country__c = country2.Id);
        statelisttest.add(state);
        statelisttest.add(state2);
        insert statelisttest;
        List<Location__c> locationlisttest = new List<Location__c>();
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c=country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state.Id);
        Location__c localizacion2 = new Location__c(Name='test localizacion2', City__c='test city2', Country__c=country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state2.Id);
        locationlisttest.add(localizacion);
        locationlisttest.add(localizacion2);
        insert locationlisttest;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=country2.Id, Country_of_Load__c=country.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id,State_of_Load__c = state.Id, State_of_Discharge__c = state2.Id);
        insert route;
        List<Shipment__c> shiplisttest = new List<Shipment__c>();
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true,Route__c=route.Id,Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id);
        Shipment__c shipR = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
        shiplisttest.add(ship);
        shiplisttest.add(shipR);
        insert shiplisttest;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        List<Container_Type__c> contalisttest = new List<Container_Type__c>();
        Container_Type__c container = new Container_Type__c(Cargo_Volume_m3__c=100,Cargo_Weight_Kg__c=100,Height_cm__c=100,Length_cm__c=100,Pallet_Configuration__c='test pallet',Teus__c=100,Width_cm__c=100);
        Container_Type__c container2 = new Container_Type__c(Cargo_Volume_m3__c=10,Cargo_Weight_Kg__c=10,Height_cm__c=10,Length_cm__c=10,Pallet_Configuration__c='test pallet2',Teus__c=10,Width_cm__c=10);
        contalisttest.add(container);
        contalisttest.add(container2);
        insert contalisttest;
        Delivery_Zone__c delivery = new Delivery_Zone__c(Kms__c=10,Miles__c=20,Port_Airport__c=localizacion.Id,Test_upload__c=true);
        insert delivery;
        List<Fee__c> fl_test = new List<Fee__c>();
        Fee__c fee = new Fee__c(Name = 'testconstringlargoparacomprobarunavariabletrunavariabletiabletetiabletetetiablet', Fee_Category__c = 'Fixed', Rate_Type__c = 'Fixed', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(10),Valid_From__c=system.today(),Port_Airport__c=localizacion.Id,TT_Days__c='59',Container_Type__c=container.Id,Route__c=route.Id,Max_Kgs__c=545,Max_M3__c=4,Min__c=8,Buy_Rate__c=58,Fee_Rate__c=191,Volumetric_Factor__c=143);
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Fixed', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=556,Max_M3__c=7,Min__c=10,Buy_Rate__c=57,Rate_Type__c='Per W/M',Fee_Rate__c=11,Volumetric_Factor__c=145, Active__c=true);
        Fee__c fee3 = new Fee__c(Name = 'test fees3', Fee_Category__c = 'Other Service Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=55,Max_M3__c=71,Min__c=11,Buy_Rate__c=57,Rate_Type__c='Per Kg',Fee_Rate__c=12,Volumetric_Factor__c=140, Active__c=true);
        Fee__c fee4 = new Fee__c(Name = 'test fees4', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='561',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=53,Max_M3__c=72,Min__c=12,Buy_Rate__c=58,Rate_Type__c='Per M3',Fee_Rate__c=13,Volumetric_Factor__c=141, Active__c=true);
        Fee__c fee5 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142, Active__c=true);
        Fee__c fee6 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142);
        Fee__c fee7 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per TON',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee8 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Kg',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee9 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per W/M',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee10 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Fixed',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee11 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Pallet',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        fl_test.add(fee);
        fl_test.add(fee2);
        fl_test.add(fee3);
        fl_test.add(fee4);
        fl_test.add(fee5);
        fl_test.add(fee6);
        fl_test.add(fee7);
        fl_test.add(fee8);
        fl_test.add(fee9);
        fl_test.add(fee10);
        fl_test.add(fee11);
        insert fl_test;
        List<Shipment_Fee_Line__c> sfl_test = new List<Shipment_Fee_Line__c>();
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
        Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee2.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline3 = new Shipment_Fee_Line__c(Name='test shipment fee line3', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee3.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline4 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee4.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline5 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline6 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee6.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline7 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee7.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline8 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee8.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline9 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee9.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline10 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee10.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline11 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee11.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        sfl_test.add(shipfeeline);
        sfl_test.add(shipfeeline2);
        sfl_test.add(shipfeeline3);
        sfl_test.add(shipfeeline4);
        sfl_test.add(shipfeeline5);
        sfl_test.add(shipfeeline6);
        sfl_test.add(shipfeeline7);
        sfl_test.add(shipfeeline8);
        sfl_test.add(shipfeeline9);
        sfl_test.add(shipfeeline10);
        sfl_test.add(shipfeeline11);
        insert  sfl_test;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Last_Shipment__c = ship.Id);
        insert importexportquote;
        Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert scd;
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;
        NEU_OM_ShipFeeLinesPriceListYDiscount uda = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController( ship ));


        NEU_OM_ShipFeeLinesPriceListYDiscount udafilter = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController( ship ));
        udafilter.create_new_service_rate();
        udafilter.getFee_List_Price();
        udafilter.shipment_filter.Carrier__c=a.Id;
        udafilter.shipment_filter.Country_of_Load__c=country.Id;
        udafilter.shipment_filter.Country_of_Discharge__c=country2.Id;
        udafilter.shipment_filter.Site_of_Load__c=localizacion.Id;
        udafilter.shipment_filter.Site_of_Discharge__c=localizacion2.Id;
        udafilter.shipment_filter.State_of_Discharge__c=state2.Id;
        udafilter.shipment_filter.State_of_Load__c=state.Id;
        udafilter.shipment_filter.Container_Type__c=container.Id;
        udafilter.shipment_filter.Delivery_Cartage__c=delivery.Id;
        udafilter.shipment_filter.Pickup_Cartage__c=delivery.Id;
        udafilter.shipment_filter.Route__c=route.Id;
        udafilter.createNewRoute();
        udafilter.getFee_List_Price();
        udafilter.shipment_filter.Carrier__c=a.Id;
        udafilter.shipment_filter.Country_of_Load__c=null;
        udafilter.shipment_filter.Country_of_Discharge__c=null;
        udafilter.shipment_filter.Site_of_Load__c=null;
        udafilter.shipment_filter.Site_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Load__c=null;
        udafilter.shipment_filter.Container_Type__c=null;
        udafilter.shipment_filter.Delivery_Cartage__c=null;
        udafilter.shipment_filter.Pickup_Cartage__c=null;
        udafilter.shipment_filter.Route__c=null;
        udafilter.getFee_List_Price();
        udafilter.buscar_paises_sites();
        udafilter.crearlineaquoteitem();
        udafilter.getshipfeeLines_all_for_route();
        udafilter.getIE_lines();
        udafilter.otherFees=null;
        List<SelectOption> ohterfees_test_lista=udafilter.otherFees;
        udafilter.go_compare_fees_filtro_insertados();
        for (NEU_OM_ShipFeeLinesPriceListYDiscount.IE_Fee_Line_s ie_fee: udafilter.IE_lines){
            ie_fee.selected=true;
        }
        udafilter.create_shipment_service_ie();
        udafilter.shipment_filter.Route__c=null;
        udafilter.anterior_siguiente_fee();

        system.debug('Prueba realizada_Discount2_Metodo2');

    }

    public static testMethod void testNEU_OM_ShipFeeLinesPriceListYDiscount2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        List<Country__c> countrylisttest = new List<Country__c>();
        Country__c country = new Country__c(Name='test country', ISO_Code__c='EUR');
        Country__c country2 = new Country__c(Name='test country2', ISO_Code__c='EUR');
        countrylisttest.add(country);
        countrylisttest.add(country2);
        insert countrylisttest;
        List<State__c> statelisttest = new List<State__c>();
        State__c state = new State__c(Name = 'test state', ISO_Code_2c__c = 'te', country__c = country.Id);
        State__c state2 = new State__c(Name = 'test state2', ISO_Code_2c__c = 't', country__c = country2.Id);
        statelisttest.add(state);
        statelisttest.add(state2);
        insert statelisttest;
        List<Location__c> locationlisttest = new List<Location__c>();
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c=country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state.Id);
        Location__c localizacion2 = new Location__c(Name='test localizacion2', City__c='test city2', Country__c=country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state2.Id);
        locationlisttest.add(localizacion);
        locationlisttest.add(localizacion2);
        insert locationlisttest;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=country2.Id, Country_of_Load__c=country.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id,State_of_Load__c = state.Id, State_of_Discharge__c = state2.Id);
        insert route;
        List<Shipment__c> shiplisttest = new List<Shipment__c>();
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true,Route__c=route.Id,Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id);
        Shipment__c shipR = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
        Shipment__c shipi = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
        shiplisttest.add(ship);
        shiplisttest.add(shipR);
        shiplisttest.add(shipi);
        insert shiplisttest;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        List<Container_Type__c> contalisttest = new List<Container_Type__c>();
        Container_Type__c container = new Container_Type__c(Cargo_Volume_m3__c=100,Cargo_Weight_Kg__c=100,Height_cm__c=100,Length_cm__c=100,Pallet_Configuration__c='test pallet',Teus__c=100,Width_cm__c=100);
        Container_Type__c container2 = new Container_Type__c(Cargo_Volume_m3__c=10,Cargo_Weight_Kg__c=10,Height_cm__c=10,Length_cm__c=10,Pallet_Configuration__c='test pallet2',Teus__c=10,Width_cm__c=10);
        contalisttest.add(container);
        contalisttest.add(container2);
        insert contalisttest;
        Delivery_Zone__c delivery = new Delivery_Zone__c(Kms__c=10,Miles__c=20,Port_Airport__c=localizacion.Id,Test_upload__c=true);
        insert delivery;
        List<Fee__c> fl_test = new List<Fee__c>();
        Fee__c fee = new Fee__c(Name = 'testconstringlargoparacomprobarunavariabletrunavariabletiabletetiabletetetiablet', Fee_Category__c = 'Clearing Cost', Rate_Type__c = 'Fixed', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(10),Valid_From__c=system.today(),Port_Airport__c=localizacion.Id,TT_Days__c='59',Container_Type__c=container.Id,Route__c=route.Id,Max_Kgs__c=545,Max_M3__c=4,Min__c=8,Buy_Rate__c=58,Fee_Rate__c=191,Volumetric_Factor__c=143);
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Drayages', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=556,Max_M3__c=7,Min__c=10,Buy_Rate__c=57,Rate_Type__c='Per Container',Fee_Rate__c=11,Volumetric_Factor__c=145);
        Fee__c fee3 = new Fee__c(Name = 'test fees3', Fee_Category__c = 'Drayages', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=55,Max_M3__c=71,Min__c=11,Buy_Rate__c=57,Rate_Type__c='Per Container',Fee_Rate__c=12,Volumetric_Factor__c=140);
        Fee__c fee4 = new Fee__c(Name = 'test fees4', Fee_Category__c = 'POD Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='561',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=53,Max_M3__c=72,Min__c=12,Buy_Rate__c=58,Rate_Type__c='Per Container',Fee_Rate__c=13,Volumetric_Factor__c=141);
        Fee__c fee5 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142);
        Fee__c fee6 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'Other Service Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142);
        fl_test.add(fee);
        fl_test.add(fee2);
        fl_test.add(fee3);
        fl_test.add(fee4);
        fl_test.add(fee5);
        fl_test.add(fee6);
        insert fl_test;
        List<Shipment_Fee_Line__c> sfl_test = new List<Shipment_Fee_Line__c>();
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
        Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee2.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline3 = new Shipment_Fee_Line__c(Name='test shipment fee line3', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee3.Id , Shipment__c= shipi.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline4 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee4.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline5 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline6 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee6.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        sfl_test.add(shipfeeline);
        sfl_test.add(shipfeeline2);
        sfl_test.add(shipfeeline3);
        sfl_test.add(shipfeeline4);
        sfl_test.add(shipfeeline5);
        sfl_test.add(shipfeeline6);
        insert  sfl_test;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Last_Shipment__c = ship.Id);
        insert importexportquote;
        Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert scd;
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;
        NEU_OM_ShipFeeLinesPriceListYDiscount2 uda = new NEU_OM_ShipFeeLinesPriceListYDiscount2(new ApexPages.StandardController( ship ));
        //string value = '';
        ////Get/Set de variables
        uda.chekeados_ie =uda.chekeados_ie;
        uda.id_oi=uda.id_oi;
        uda.listado_ids_carrier=uda.listado_ids_carrier;
        uda.url_sailing_schedule=uda.url_sailing_schedule;
        uda.url_alibaba=uda.url_alibaba;
        uda.newRejectionReasons=uda.newRejectionReasons;
        uda.newRejection=uda.newRejection;
        uda.CarrierIdRejection=uda.CarrierIdRejection;
        uda.show_all_categories=uda.show_all_categories;
        uda.show_all_categories_all_lines=uda.show_all_categories_all_lines;
        uda.fee_currency=uda.fee_currency;
        List<SelectOption> currencys = new List<SelectOption>();

        List<NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s> atpd = new List<NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s>();
        atpd.add(new NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s(null,shipfeeline,true,'extension test', '10', '10', '0', '10', null,UserInfo.getDefaultCurrency(),uda,10, true));
        atpd.add(new NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s(null,shipfeeline,true,'extension test', '10', '10', '0', '10', null, UserInfo.getDefaultCurrency(),uda,10, true));

        for(NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s lo: atpd)
        {
            lo.selected = true;
        }
        uda.categories();
        uda.setnewcategory('Disbursement');
        uda.setrecordtype('Other Service Charges');
        uda.getrecordtype();
        uda.getFee_List_Price();
        uda.getshipfeeLines();
        uda.chekeados = true;
        //Inicio clase NEUEBUSCM_Shipment_Fee_Line_s
        List<SelectOption> currencystemp=new List<SelectOption>();
        currencystemp.add(new SelectOption('EN','EN'));
        List<SelectOption> currencystemp2=new List<SelectOption>();
        currencystemp2.add(new SelectOption('ES','EN'));
        NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s item = new NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s(fee,shipfeeline,true,'test extension','test unit','test sell','test discount','test buy',currencystemp,'test currency user',uda,10,true);
        NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s item2 = new NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s(fee2,shipfeeline2,true,'test extension2','test unit2','test sell2','test discount2','test buy2',currencystemp2,'test currency user2',uda,20,true);
        item.total_buy=item.total_buy;
        item.total_sell=item.total_sell;
        item.total_sell='20';
        item.total_buy='22';
        item2.total_sell='10';
        item2.total_buy='12';
        //Comparacion en el filtro
        uda.orden_fees_filtro='line.Name';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Name';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Valid_Until__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Valid_Until__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Valid_Until__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='weight_factor';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='weight_factor';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_sell';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_sell';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_buy';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='total_buy';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Account_for__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Account_for__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Carrier_Account__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Carrier_Account__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Route__r.Name';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Route__r.Name';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Delivery_Zone__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Delivery_Zone__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.CreatedDate';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.CreatedDate';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Port_Airport__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Port_Airport__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.TT_Days__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.TT_Days__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Rate_Type__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Rate_Type__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Fee_Rate__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Fee_Rate__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Container_Type__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Container_Type__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Pallet_Type__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Pallet_Type__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_Kgs__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_Kgs__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_M3__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Max_M3__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Buy_Rate__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Buy_Rate__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Min__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Min__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Volumetric_Factor__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='line.Volumetric_Factor__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Units__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Units__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Sell_Price__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Sell_Price__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Discount_Charge__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Discount_Charge__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Buy_Price__c';
        uda.orden_fees_filtro_modo='asc';
        item.compareTo(item2);
        uda.orden_fees_filtro='ship_fee_line.Shipment_Buy_Price__c';
        uda.orden_fees_filtro_modo='dsc';
        item.compareTo(item2);
        //Fin comparaciones filtro
        uda.Fee_List_Price_Road.add(item);
        uda.new_rejection();
        uda.crearlineaquoteitem();
        uda.Fee_List_Price= new List<NEU_OM_ShipFeeLinesPriceListYDiscount2.NEUEBUSCM_Shipment_Fee_Line_s>();
        uda.Fee_List_Price.add(item2);
        uda.crearlineaquoteitem();
        //Fin clase NEUEBUSCM_Shipment_Fee_Line_s
        //Inicio de clase Shipment_Fee_Line_all_s
        List<NEU_OM_ShipFeeLinesPriceListYDiscount2.Shipment_Fee_Line_currency_s> shiplistcur = new List<NEU_OM_ShipFeeLinesPriceListYDiscount2.Shipment_Fee_Line_currency_s>();
        shiplistcur.add(new NEU_OM_ShipFeeLinesPriceListYDiscount2.Shipment_Fee_Line_currency_s(shipfeeline, Neu_currencyUtils.getCurrencyIsoCode(shipfeeline)));
        NEU_OM_ShipFeeLinesPriceListYDiscount2.Shipment_Fee_Line_all_s shipitemtest = new NEU_OM_ShipFeeLinesPriceListYDiscount2.Shipment_Fee_Line_all_s(uda,'testLoad','testDischarge',shiplistcur,23,25,6);
        shipitemtest.gettotal_buy_format();
        shipitemtest.gettotal_sell_format();
        shipitemtest.total_buy=null;
        shipitemtest.total_sell=null;
        shipitemtest.gettotal_buy_format();
        shipitemtest.gettotal_sell_format();
        //Fin clase Shipment_Fee_Line_all_s
        String str = uda.getFeeFiltersQueryString('test','test');
        uda.change_ratio_category();
        uda.update_sites_countries();
        uda.return_shipment();
        uda.checkExistRoute();
        NEU_OM_ShipFeeLinesPriceListYDiscount2.remove1('Prúeba');
        uda.all_accounts_filter();
        uda.all_carriers_filter();
        uda.filter_new_carrier();
        uda.new_rejection();
        uda.getshipfeeLines_all_for_route();
        uda.all_containers_filter();
        uda.getshipfeeLines_all();
        uda.getshipfeeLines_without();
        uda.buscar_paises_sites();
        uda.getshipment_filter();
        uda.sortList(6);
        uda.setshipment_filter(ship);
        uda.getservice_rate_filter();
        uda.setservice_rate_filter(fee);
        uda.decimalSep=uda.decimalSep;
        uda.thousandSep=uda.thousandSep;
        uda.sum_buy_amount_ie_string=uda.sum_buy_amount_ie_string;
        uda.sum_sell_amount_ie_string=uda.sum_sell_amount_ie_string;

        NEU_OM_ShipFeeLinesPriceListYDiscount2 udafilter = new NEU_OM_ShipFeeLinesPriceListYDiscount2(new ApexPages.StandardController( ship ));
        udafilter.change_ratio_category();
        udafilter.record.Service_Mode__c='NATIONAL';
        udafilter.setnewcategory('Road Freights');
        udafilter.getFee_List_Price();
        udafilter.setnewcategory('Sea Freights');
        udafilter.getIE_lines();
        udafilter.create_shipment_service_ie();
        udafilter.change_ratio_category();
        udafilter.setnewcategory('Drayages');
        udafilter.change_ratio_category();
        udafilter.setnewcategory('Other Service Charges');
        udafilter.getshipfeeLines_all();
        udafilter.all_routes_filter();
        udafilter.update_check_show_all_categories();
        udafilter.update_check_hidden_all_categories();
        NEU_OM_ShipFeeLinesPriceListYDiscount2.IE_Fee_Line_s itemie = new NEU_OM_ShipFeeLinesPriceListYDiscount2.IE_Fee_Line_s(udafilter,shipfeeline2,true,'test idIE');
        itemie.selected=itemie.selected;
        itemie.id=itemie.id;
        itemie.total_sell=itemie.total_sell;
        itemie.total_buy=itemie.total_buy;
        itemie.getValue('test shipment fee line');
        udafilter.create_new_service_rate();
        udafilter.shipment_filter.Carrier__c=a.Id;
        udafilter.shipment_filter.Country_of_Load__c=country.Id;
        udafilter.shipment_filter.Country_of_Discharge__c=country.Id;
        udafilter.shipment_filter.Site_of_Load__c=localizacion.Id;
        udafilter.shipment_filter.Site_of_Discharge__c=localizacion.Id;
        udafilter.shipment_filter.State_of_Discharge__c=state.Id;
        udafilter.shipment_filter.State_of_Load__c=state.Id;
        udafilter.shipment_filter.Container_Type__c=container.Id;
        udafilter.shipment_filter.Delivery_Cartage__c=delivery.Id;
        udafilter.getFeeFiltersQueryString('test','test');
        //Pruebas con shipment_filter
        udafilter.anterior_siguiente_fee();
        udafilter.buscar_paises_sites();
        udafilter.getFeeFiltersQueryString('test','test');
        udafilter.shipment_filter.Pickup_Cartage__c=delivery.Id;
        udafilter.getFeeFiltersQueryString('test','test');
        udafilter.shipment_filter.Site_of_Discharge__c=null;
        udafilter.getFeeFiltersQueryString('test','test');
        udafilter.shipment_filter.Site_of_Load__c=null;
        udafilter.getFeeFiltersQueryString('test','test');
        udafilter.shipment_filter.Site_of_Discharge__c=localizacion2.Id;
        udafilter.getFeeFiltersQueryString('test','test');
        udafilter.shipment_filter.Site_of_Load__c=localizacion.Id;
        udafilter.shipment_filter.Route__c=route.Id;
        udafilter.record.Route__c=null;
        uda.crearlineaquoteitem();
        udafilter.getFeeFiltersQueryString('test','test');
        udafilter.shipment_filter.Country_of_Load__c=null;
        udafilter.shipment_filter.Country_of_Discharge__c=null;
        udafilter.shipment_filter.Site_of_Load__c=null;
        udafilter.shipment_filter.Site_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Load__c=null;
        udafilter.shipment_filter.Container_Type__c=null;
        udafilter.getFeeFiltersQueryString('test','test');
        udafilter.totals_custom.total_Services_Sell_Amount_s_currency='1213';
        new NEU_OM_ShipFeeLinesPriceListYDiscount2.totales_s(ship);


        //Metodos varios para testear
        udafilter.getshipfeeLines_all_for_route();
        udafilter.update_route();
        udafilter.delete_fee_select();
        udafilter.update_record();
        udafilter.record=null;
        udafilter.update_record();
        udafilter.go_compare_fees_filtro();
        udafilter.search_name_filter();
        NEU_OM_ShipFeeLinesPriceListYDiscount2 udashipi = new NEU_OM_ShipFeeLinesPriceListYDiscount2(new ApexPages.StandardController( shipi ));
        udashipi.getshipfeeLines_all_for_route();

        system.debug( 'Prueba realizada_Discount2_Metodo1');

    }

    public static testMethod void testNEU_OM_ShipFeeLinesPriceListYDiscount2_2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        List<Country__c> countrylisttest = new List<Country__c>();
        Country__c country = new Country__c(Name='test country', ISO_Code__c='EUR');
        Country__c country2 = new Country__c(Name='test country2', ISO_Code__c='EUR');
        countrylisttest.add(country);
        countrylisttest.add(country2);
        insert countrylisttest;
        List<State__c> statelisttest = new List<State__c>();
        State__c state = new State__c(Name = 'test state', ISO_Code_2c__c = 'te', country__c = country.Id);
        State__c state2 = new State__c(Name = 'test state2', ISO_Code_2c__c = 't', country__c = country2.Id);
        statelisttest.add(state);
        statelisttest.add(state2);
        insert statelisttest;
        List<Location__c> locationlisttest = new List<Location__c>();
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c=country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state.Id);
        Location__c localizacion2 = new Location__c(Name='test localizacion2', City__c='test city2', Country__c=country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',state__c=state2.Id);
        locationlisttest.add(localizacion);
        locationlisttest.add(localizacion2);
        insert locationlisttest;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=country2.Id, Country_of_Load__c=country.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id,State_of_Load__c = state.Id, State_of_Discharge__c = state2.Id);
        insert route;
        List<Shipment__c> shiplisttest = new List<Shipment__c>();
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true,Route__c=route.Id,Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id);
        Shipment__c shipR = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
        shiplisttest.add(ship);
        shiplisttest.add(shipR);
        insert shiplisttest;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        List<Container_Type__c> contalisttest = new List<Container_Type__c>();
        Container_Type__c container = new Container_Type__c(Cargo_Volume_m3__c=100,Cargo_Weight_Kg__c=100,Height_cm__c=100,Length_cm__c=100,Pallet_Configuration__c='test pallet',Teus__c=100,Width_cm__c=100);
        Container_Type__c container2 = new Container_Type__c(Cargo_Volume_m3__c=10,Cargo_Weight_Kg__c=10,Height_cm__c=10,Length_cm__c=10,Pallet_Configuration__c='test pallet2',Teus__c=10,Width_cm__c=10);
        contalisttest.add(container);
        contalisttest.add(container2);
        insert contalisttest;
        Delivery_Zone__c delivery = new Delivery_Zone__c(Kms__c=10,Miles__c=20,Port_Airport__c=localizacion.Id,Test_upload__c=true);
        insert delivery;
        List<Fee__c> fl_test = new List<Fee__c>();
        Fee__c fee = new Fee__c(Name = 'testconstringlargoparacomprobarunavariabletrunavariabletiabletetiabletetetiablet', Fee_Category__c = 'Fixed', Rate_Type__c = 'Fixed', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(10),Valid_From__c=system.today(),Port_Airport__c=localizacion.Id,TT_Days__c='59',Container_Type__c=container.Id,Route__c=route.Id,Max_Kgs__c=545,Max_M3__c=4,Min__c=8,Buy_Rate__c=58,Fee_Rate__c=191,Volumetric_Factor__c=143);
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Fixed', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=556,Max_M3__c=7,Min__c=10,Buy_Rate__c=57,Rate_Type__c='Per W/M',Fee_Rate__c=11,Volumetric_Factor__c=145, Active__c=true);
        Fee__c fee3 = new Fee__c(Name = 'test fees3', Fee_Category__c = 'Other Service Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='56',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=55,Max_M3__c=71,Min__c=11,Buy_Rate__c=57,Rate_Type__c='Per Kg',Fee_Rate__c=12,Volumetric_Factor__c=140, Active__c=true);
        Fee__c fee4 = new Fee__c(Name = 'test fees4', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='561',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=53,Max_M3__c=72,Min__c=12,Buy_Rate__c=58,Rate_Type__c='Per M3',Fee_Rate__c=13,Volumetric_Factor__c=141, Active__c=true);
        Fee__c fee5 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142, Active__c=true);
        Fee__c fee6 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Container',Fee_Rate__c=14,Volumetric_Factor__c=142);
        Fee__c fee7 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per TON',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee8 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Kg',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee9 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per W/M',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee10 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Fixed',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        Fee__c fee11 = new Fee__c(Name = 'test fees5', Fee_Category__c = 'POL Charges', Account_for__c = a.Id,Valid_Until__c=system.today().addDays(5),Valid_From__c=system.today().addDays(1),Port_Airport__c=localizacion2.Id,TT_Days__c='562',Container_Type__c=container2.Id,Route__c=route.Id,Max_Kgs__c=59,Max_M3__c=73,Min__c=13,Buy_Rate__c=59,Rate_Type__c='Per Pallet',Fee_Rate__c=14,Volumetric_Factor__c=142,Active__c=true);
        fl_test.add(fee);
        fl_test.add(fee2);
        fl_test.add(fee3);
        fl_test.add(fee4);
        fl_test.add(fee5);
        fl_test.add(fee6);
        fl_test.add(fee7);
        fl_test.add(fee8);
        fl_test.add(fee9);
        fl_test.add(fee10);
        fl_test.add(fee11);
        insert fl_test;
        List<Shipment_Fee_Line__c> sfl_test = new List<Shipment_Fee_Line__c>();
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
        Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee2.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline3 = new Shipment_Fee_Line__c(Name='test shipment fee line3', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee3.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline4 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee4.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline5 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline6 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee6.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline7 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee7.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline8 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee8.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline9 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee9.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline10 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee10.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        Shipment_Fee_Line__c shipfeeline11 = new Shipment_Fee_Line__c(Name='test shipment fee line2', Discount_Charge__c=84, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee11.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=60, Units__c=30, Shipment_Buy_Price__c=100);
        sfl_test.add(shipfeeline);
        sfl_test.add(shipfeeline2);
        sfl_test.add(shipfeeline3);
        sfl_test.add(shipfeeline4);
        sfl_test.add(shipfeeline5);
        sfl_test.add(shipfeeline6);
        sfl_test.add(shipfeeline7);
        sfl_test.add(shipfeeline8);
        sfl_test.add(shipfeeline9);
        sfl_test.add(shipfeeline10);
        sfl_test.add(shipfeeline11);
        insert  sfl_test;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Last_Shipment__c = ship.Id);
        insert importexportquote;
        Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert scd;
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;
        NEU_OM_ShipFeeLinesPriceListYDiscount2 uda = new NEU_OM_ShipFeeLinesPriceListYDiscount2(new ApexPages.StandardController( ship ));


        NEU_OM_ShipFeeLinesPriceListYDiscount2 udafilter = new NEU_OM_ShipFeeLinesPriceListYDiscount2(new ApexPages.StandardController( ship ));
        udafilter.create_new_service_rate();
        udafilter.getFee_List_Price();
        udafilter.shipment_filter.Carrier__c=a.Id;
        udafilter.shipment_filter.Country_of_Load__c=country.Id;
        udafilter.shipment_filter.Country_of_Discharge__c=country2.Id;
        udafilter.shipment_filter.Site_of_Load__c=localizacion.Id;
        udafilter.shipment_filter.Site_of_Discharge__c=localizacion2.Id;
        udafilter.shipment_filter.State_of_Discharge__c=state2.Id;
        udafilter.shipment_filter.State_of_Load__c=state.Id;
        udafilter.shipment_filter.Container_Type__c=container.Id;
        udafilter.shipment_filter.Delivery_Cartage__c=delivery.Id;
        udafilter.shipment_filter.Pickup_Cartage__c=delivery.Id;
        udafilter.shipment_filter.Route__c=route.Id;
        udafilter.createNewRoute();
        udafilter.getFee_List_Price();
        udafilter.shipment_filter.Carrier__c=a.Id;
        udafilter.shipment_filter.Country_of_Load__c=null;
        udafilter.shipment_filter.Country_of_Discharge__c=null;
        udafilter.shipment_filter.Site_of_Load__c=null;
        udafilter.shipment_filter.Site_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Discharge__c=null;
        udafilter.shipment_filter.State_of_Load__c=null;
        udafilter.shipment_filter.Container_Type__c=null;
        udafilter.shipment_filter.Delivery_Cartage__c=null;
        udafilter.shipment_filter.Pickup_Cartage__c=null;
        udafilter.shipment_filter.Route__c=null;
        udafilter.getFee_List_Price();
        udafilter.buscar_paises_sites();
        udafilter.crearlineaquoteitem();
        udafilter.getshipfeeLines_all_for_route();
        udafilter.getIE_lines();
        udafilter.otherFees=null;
        List<SelectOption> ohterfees_test_lista=udafilter.otherFees;
        udafilter.go_compare_fees_filtro_insertados();
        for (NEU_OM_ShipFeeLinesPriceListYDiscount2.IE_Fee_Line_s ie_fee: udafilter.IE_lines){
            ie_fee.selected=true;
        }
        udafilter.create_shipment_service_ie();
        udafilter.shipment_filter.Route__c=null;
        udafilter.anterior_siguiente_fee();

        system.debug('Prueba realizada_Discount2_Metodo2');

    }
    
    public static testMethod void testNEU_Ground_Track_Trace()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_Stop_B__c  = a.Id,
        Account_Stop_C__c = a.Id, Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import',
        Account_Stop_C__c = a.Id, Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment__c ship3 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_Stop_B__c  = a.Id,
        Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
        insert ship3;
        NEU_Ground_Track_Trace gtt = new NEU_Ground_Track_Trace(new ApexPages.StandardController( ship ));
        NEU_Ground_Track_Trace gtt2 = new NEU_Ground_Track_Trace(new ApexPages.StandardController( ship2 ));
        NEU_Ground_Track_Trace gtt3 = new NEU_Ground_Track_Trace(new ApexPages.StandardController( ship3 ));
    }
     
    public static testMethod void testNEU_ShipmentOrderSteps()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        NEU_ShipmentOrderSteps sos = new NEU_ShipmentOrderSteps(new ApexPages.StandardController( ship ));
        NEU_ShipmentQuoteSteps sqs = new NEU_ShipmentQuoteSteps(new ApexPages.StandardController( ship ));
        NEU_ShipmentRequestSteps srs = new NEU_ShipmentRequestSteps(new ApexPages.StandardController( ship ));
         
    }

    public static testMethod void tes_NEU_Updated_Position_of_Ship()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_Updated_Position_of_Ship uda = new NEU_Updated_Position_of_Ship(new ApexPages.StandardController( ship ));
        uda.create_feed();
    }

      public static testMethod void testNEU_OM_Start_Clearance_Shipment()
      {//57 los httprequest

          NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Customer_Price_List__c d2 = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d2;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id);
        insert shipline;
        
        NEU_OM_Start_Clearance_Shipment uda = new NEU_OM_Start_Clearance_Shipment(new ApexPages.StandardController( ship ));
        
     //   uda.idlineactualizar=quote.Id;
    //    uda.idlineaitem=quote.Id;
        uda.idlineactualizar = shipline.Id;
        uda.idlineaitem = shipline.Id;
        uda.applyLines();
        
        uda.calculate_taxes();
        uda.getlist_category();
        uda.getlista_items();
        uda.getlista_subcategorias();
        uda.getshipmentItemLines();
        uda.getshipmentItemLines2();
        
      }

    public static testMethod void testNEU_OM_CreateShipmenItemsLineDiscount()
    {//con price list

          NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'false');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=b.Id,List_Price__c=10 );
        insert f;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Catalog_Price_List__c= b.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        NEU_OM_CreateShipmenItemsLineDiscount uda = new NEU_OM_CreateShipmenItemsLineDiscount(new ApexPages.StandardController( ship ));
        
        string field_accountpricelist = 'pricelist';
        field_accountpricelist = b.Id;
        uda.getfamily_field();
        uda.setfamily_field(c.Id);
        uda.getShipmentItemsLines();
        uda.crearlineaquoteitem();
        uda.getItem_List_Price();
        uda.nombrepricelist = d.Name;
        uda.families();
        String family =c.Id;
        for(NEU_OM_CreateShipmenItemsLineDiscount.NEUEBUSCM_Shipment_Item_Line_s sil : uda.getFamilyList(family))
            sil.selected  = true;
        
        uda.crearlineaquoteitem();
        uda.getTempPrice_List();
        uda.setTempPrice_List(b.Id);
        uda.categories();
        uda.getpricelists();
        uda.setnewcategory('Disbursement');
        uda.delete_item_line_select();
        uda.return_shipment();
        uda.accountpricelist = uda.accountpricelist;
        uda.listado_familias = uda.listado_familias;
        uda.listado_accountpricelist = uda.listado_accountpricelist;
        uda.field_accountpricelist = uda.field_accountpricelist;
        uda.listado_pricelist = uda.listado_pricelist;
        uda.field_pricelist = uda.field_pricelist;
        uda.listadodecheck = uda.listadodecheck;
        uda.bloqueolookup = uda.bloqueolookup;
        uda.idaccountpricelist = uda.idaccountpricelist;
        uda.getFamilyList(c.Id);
        uda.setTempPrice_List('test');
    }
    
    public static testMethod void testNEU_OM_CreateShipmenItemsLineDiscount2()
    {//con account price list

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'true');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts',Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Price_List__c apricelist = new Customer_Price_List__c(Name='test', Customer__c= a.Id, Price_List__c=b.Id);
        insert apricelist;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=b.Id,List_Price__c=10 );
        insert f;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import',Account_for_Catalog_Price_List__c=apricelist.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        NEU_OM_CreateShipmenItemsLineDiscount uda = new NEU_OM_CreateShipmenItemsLineDiscount(new ApexPages.StandardController( ship ));
       
        string field_accountpricelist = 'pricelist';
        field_accountpricelist = b.Id;
        uda.getfamily_field();
        uda.setfamily_field(c.Id);
        uda.getShipmentItemsLines();
        uda.crearlineaquoteitem();
        uda.getItem_List_Price();
        String family =c.Id;
        uda.getFamilyList(family);
        uda.nombrepricelist = d.Name;
        uda.families();
        for(NEU_OM_CreateShipmenItemsLineDiscount.NEUEBUSCM_Shipment_Item_Line_s sil : uda.getFamilyList(family))
            sil.selected  = true;
        uda.crearlineaquoteitem();
    }
    
    static testMethod void test_NEU_ShipmentsSearch()
    {

        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', ETA_Point_of_Discharge__c =system.today(), ETD_from_Point_of_Load__c = system.today(), Only_Warehouse_Service__c = true);
        insert ship;
        NEU_ShipmentsSearch ss = new NEU_ShipmentsSearch();
        ss.orden_ship_filtro_orders = 'Name';
        ss.orden_ship_filtro_orders_modo = 'asc';
        ss.orden_ship_filtro_request = 'Name';
        ss.orden_ship_filtro_request_modo = 'asc';
        ss.orden_ship_filtro_quotes = 'Name';
        ss.orden_ship_filtro_quotes_modo = 'asc';
        ss.sta_list = '';
        ss.serv_list = '';
        ss.getETD_operator_list();
        ss.getETA_operator_list();
        ss.carga_filtros();
        ss.go_compare_ship_order();
        ss.go_compare_ship_request();
        ss.search_shipments();
        ss.go_compare_ship_quote();
        ss.anterior_siguiente_Instalacion();
        ss.anterior_siguiente_order();
        ss.anterior_siguiente_request();
         
    }
    
      static testMethod void test_NEU_OM_Save_SLI()
      {
          NEU_StaticVariableHelper.setBoolean1(true);
          
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        NEU_OM_Save_SLI gpcc = new NEU_OM_Save_SLI(new ApexPages.StandardController( ship ));
        system.debug( 'Prueba realizada' );
        Blob b = Blob.valueOf('Test Data');
        gpcc.documento_asociado.Name='Test document.test';
        gpcc.documento_asociado.AuthorId = UserInfo.getUserId();
        gpcc.documento_asociado.IsPublic=true;
        gpcc.documento_asociado.Body = b;
        gpcc.crear();
      
    }
    

    
    static testMethod void Generate_SLI_test() 
    {

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account account_test = list_accounts[0];
        insert account_test;
		Account supplier_test = list_accounts[1];
        insert supplier_test;
		
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;

        Transport_Packaging_Data__c transport_packaging_data_test = new Transport_Packaging_Data__c();
        transport_packaging_data_test.Shipment__c = shipment_test.Id;
        transport_packaging_data_test.Name = 'SPD Test';
        insert transport_packaging_data_test;
        
        Shipment_Disbursement__c shipment_disbursement_test = new Shipment_Disbursement__c();
        shipment_disbursement_test.Shipment__c = shipment_test.Id;
        shipment_disbursement_test.Account__c = supplier_test.Id;
        insert shipment_disbursement_test;
        
        NEU_OM_Generate_SLI gsli = new NEU_OM_Generate_SLI(new ApexPages.StandardController(shipment_test));
        gsli.update_shipment();
    }

    static testMethod void NEU_Create_Disbursement_Service_Item()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

        Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        insert a;

        Account b = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales');
        insert b;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;

        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = shipment_test.Id, Name= 'test ship line');
        insert shipline;

        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;

        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= shipment_test.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;

        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;

        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC', IATA_Code__c='IAC');
        insert localizacion;

        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id,
                Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress',
                Country_ofLoad__c= Country.Id, Site_of_Load__c =localizacion.Id,Country_ofDischarge__c= Country.Id,
                Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');
        insert importexportquote;

        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;

        Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=shipment_test.Id, Account__c=b.Id, Conversion_Rate_to_Imp_Exp_Currency__c = 1, Import_Export_Quote_Order__c = importexportquote.id);
        insert shipdis;

        Disbursement_Line__c dl = new Disbursement_Line__c(Name='Test DL', Disbursement__c=shipdis.Id);
        insert dl;

        Shipment_Service_Line_Disbursement__c shipDisLine = new Shipment_Service_Line_Disbursement__c(Shipment_Disbursement__c = shipdis.Id, Shipment_Service_Line__c = shipfeeline.Id);
        insert shipDisLine;



        Shipment_Item_Line_Disbursement__c shipItemLine = new Shipment_Item_Line_Disbursement__c(Shipment_Disbursement__c = shipdis.Id, Shipment_Item_Line__c = shipline.Id);
        insert shipItemLine;

        NEU_Create_Disbursement_Service_Item c=new NEU_Create_Disbursement_Service_Item(new ApexPages.StandardController(shipdis));
        for(NEU_Create_Disbursement_Service_Item.Disbursement_ie_services_s l:c.Lines_ie_services)
        {
            l.selected=true;
            string qbps = l.Quote_Buy_Price_String;
            string bas = l.Buy_Amount_String;
            decimal dob = l.Disbursement_Outstanding_Balance;
            string dobs = l.Disbursement_Outstanding_Balance_String;
            decimal dobb = l.Disbursement_Outstanding_Base;
            break;
        }
        for(NEU_Create_Disbursement_Service_Item.DisbursementS_s l:c.Lines_shipment_services)
        {
            l.selected=true;
            string sbps = l.Shipment_Buy_Price_String;
            string bas = l.Buy_Amount_String;
            decimal dob = l.Disbursement_Outstanding_Balance;
            string dobs = l.Disbursement_Outstanding_Balance_String;
            decimal dobb = l.Disbursement_Outstanding_Base;
            break;
        }
        c.sorting(0,'selected',1);
        c.sorting(1,'selected',1);
        c.generate();
        c.cancel();
        c.generate();
        c.decimalSep=c.decimalSep;
        c.thousandSep=c.thousandSep;
        c.new_disbursement_line();
        c.new_line_disbursementline_empty();

        string dcs=c.Disbursement_Currency_String;
        c.quit_line_select();
        c.delete_line_select();
    }

    /*
    static testMethod void NEU_Create_Invoice_Service_Item()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');

        Account a = list_accounts[0];
        insert a;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;

        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = shipment_test.Id, Name= 'test ship line');
        insert shipline;
        shipline = new Shipment_Line__c(Shipment__c = shipment_test.Id, Name= 'test ship line');
        insert shipline;

        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= shipment_test.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= shipment_test.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;

        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');
        insert importexportquote;

        Invoice__c i_test = new Invoice__c();
        i_test.Import_Export_Quote_Order__c = importexportquote.Id;
        i_test.Account__c = a.Id;
        i_test.Shipment__c = shipment_test.Id;
        insert i_test;

        Invoice_Line__c line = new Invoice_Line__c();
        line.Name = 'test';
        line.Invoice__c = i_test.Id;
        line.Import_Export_Quote_Order__c = importexportquote.Id;
        line.Amount__c = 100;
        line.Concept__c = 'test';
        line.Total_VAT__c = 100;
        line.Unit_Price__c = 100;
        line.Units__c = 1;
        line.VAT__c = '';
        insert line;

        NEU_Create_Invoice_Service_Item c=new NEU_Create_Invoice_Service_Item(new ApexPages.StandardController(i_test));
        for(NEU_Create_Invoice_Service_Item.Line_s l:c.Lines)
        {
            l.selected=true;
            break;
        }
        for(NEU_Create_Invoice_Service_Item.LineS_s l:c.LinesS)
        {
            l.selected=true;
            break;
        }
        //c.sortList(0);
        //c.sortList(1);
        c.sortList(2);
        c.sortList(3);
        c.sortList(4);
        String tString = c.Invoice_Currency_String;
        NEU_Create_Invoice_Service_Item.Invoice_Line_s testLine = new NEU_Create_Invoice_Service_Item.Invoice_Line_s(c);
        testLine.getValue('selected');
        String testVat = testLine.total_include_vatString;

        c.sorting(0,'selected',1);
        c.sorting(1,'selected',1);
        c.new_invoice_line();
        c.new_line_invoiceline_empty();
        c.generate();
        c.cancel();
        c.updateLines();
        c.generate();
        c.delete_line_select();
        List<NEU_Create_Invoice_Service_Item.Line_ie_item_s> testList1 =  c.Lines_ie_item;
        List<NEU_Create_Invoice_Service_Item.Invoice_Line_s> testList2 = c.Lines_invoices;
        c.decimalSep=c.decimalSep;
        c.thousandSep=c.thousandSep;
        //c.bypasstest();
    }
    */


    static testMethod void NEU_Create_Invoice_Service_Item2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        insert list_accounts;
        Account account =  list_accounts[0];
        Account sup = list_accounts[1];

        //Customer Quote
        Customer_Quote__c importexportquote 	= new Customer_Quote__c();
        importexportquote.Account_for__c 		= account.Id;
        importexportquote.Freight_Mode__c 		='Air';
        importexportquote.Service_Mode__c 		='Import';
        importexportquote.Service_Type__c	 	='LCL Cargo';
        importexportquote.Move_Type__c 			= 'Door to Door';
        importexportquote.Origin_Address__c 	= 'tst adrress';
        importexportquote.Destination_Address__c = 'test address';
        insert importexportquote;

        //Invoice
        Invoice__c invoice 						= new Invoice__c();
        invoice.Import_Export_Quote_Order__c 	= importexportquote.Id;
        invoice.Account__c 						= account.Id;
        insert invoice;

        Invoice__c invoice2						= new Invoice__c();
        invoice2.Import_Export_Quote_Order__c 	= importexportquote.Id;
        invoice2.Account__c						= account.Id;
        insert invoice2;

        //Invoice Line
        Invoice_Line__c invoiceLine = new Invoice_Line__c();
        invoiceLine.Invoice__c = invoice.Id;
        insert invoiceLine;

        //Fee
        Fee__c fee 			= new Fee__c();
        fee.Name 			= 'test fees';
        fee.Fee_Category__c = 'Disbursement';
        fee.Rate_Type__c	= 'Fixed';
        fee.Account_for__c	= account.Id;
        insert fee;

        //Shipment
        Shipment__c shipment_test 		= new Shipment__c();
        shipment_test.Account_for__c 	= account.Id;
        shipment_test.Freight_Mode__c 	= 'Sea';
        shipment_test.Service_Mode__c 	= 'Import';
        shipment_test.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;

        //Shipment Line
        Shipment_Line__c shipline 		= new Shipment_Line__c();
        shipline.Shipment__c 			= shipment_test.Id;
        shipline.Import_Export_Quote__c = invoice.Import_Export_Quote_Order__c;
        shipline.Name					= 'test ship line';
        insert shipline;

        //Invoice_Item_Line
        Invoice_Item_Line__c invoiceItemLine 	= new Invoice_Item_Line__c();
        invoiceItemLine.Invoice__c 				= invoice.Id;
        invoiceItemLine.Shipment_Item_Line__c	= shipline.Id;
        insert invoiceItemLine;

        shipline 				= new Shipment_Line__c();
        shipline.Import_Export_Quote__c = invoice.Import_Export_Quote_Order__c;
        shipline.Shipment__c 	= shipment_test.Id;
        shipline.Name			= 'test ship line';
        insert shipline;


        //Shipment Fee Line
        Shipment_Fee_Line__c shipfeeline 		= new Shipment_Fee_Line__c();
        shipfeeline.Name 						= 'test shipment fee line';
        shipfeeline.Discount_Charge__c 			= 8;
        shipfeeline.Extension_Service_Name__c	='test extension';
        shipfeeline.Service_Rate_Name__c 		= fee.Id;
        shipfeeline.Shipment__c 				= shipment_test.Id;
        shipfeeline.Shipment_Sell_Price__c 		= 10;
        shipfeeline.Units__c 					= 10;
        shipfeeline.Import_Export_Quote__c		= invoice.Import_Export_Quote_Order__c;
        shipfeeline.Shipment_Buy_Price__c 		= 10;
        insert shipfeeline;

        shipfeeline 							= new Shipment_Fee_Line__c();
        shipfeeline.Name						= 'test shipment fee line';
        shipfeeline.Discount_Charge__c 			= 8;
        shipfeeline.Extension_Service_Name__c 	= 'test extension';
        shipfeeline.Service_Rate_Name__c 		= fee.Id;
        shipfeeline.Shipment__c 				= shipment_test.Id;
        shipfeeline.Shipment_Sell_Price__c 		= 10;
        shipfeeline.Import_Export_Quote__c		= invoice.Import_Export_Quote_Order__c;
        shipfeeline.Units__c	 				= 10;
        shipfeeline.Shipment_Buy_Price__c 		= 10;
        insert shipfeeline;

        //Invoice_Service_Line
        Invoice_Service_Line__c invoiceServiceLine  = new Invoice_Service_Line__c();
        invoiceServiceLine.Invoice__c = invoice.Id;
        invoiceServiceLine.Shipment_Service_Line__c = shipfeeline.Id;
        insert invoiceServiceLine;

        //Family
        List<Product_Family__c> listFamily = NEU_Data_Generator.getFamilies(1);
        insert listFamily;

        //complete test data generator
        NEU_Data_Generator.getImportExport(account, 'Road', 1);
        NEU_Data_Generator.getPriceList(account, listFamily[0]);
        NEU_Data_Generator.getShipment(account, 'Road');
        NEU_Data_Generator.getShipmentConsolidation(shipment_test, importexportquote);
        NEU_Data_Generator.getAssociatedDocument(account, importexportquote);
        NEU_Data_Generator.getShopping(account);
        NEU_Data_Generator.getClaim(account);
        NEU_Data_Generator.getTransport(shipment_test);
        NEU_Data_Generator.getShipmentDisbursement(account);


    //Subfamily
        List<Subfamily__c> listSubFamily = NEU_Data_Generator.getSubFamilies(listFamily.get(0));
        insert listSubFamily;

        //Item
        List<Sourcing_Item__c> listItem = NEU_Data_Generator.getSourcingItems(account, listFamily.get(0), listSubFamily.get(0));
        insert listItem;

        //Supply_Project
        List<Supply_Project__c> listSupplyProject = NEU_Data_Generator.getSupplyProject(account);
        insert listSupplyProject;

        //Supplier_Request_RF
        List<Supplier_Request_RFP__c> listSupplierRequestRFP = NEU_Data_Generator.getSupplierRequestRFP(sup, listSupplyProject.get(0));
        insert listSupplierRequestRFP;

        //Supplier_Quote
        List<Supplier_Quote__c> listSupplierQuote = NEU_Data_Generator.getSupplierQuote(sup, listSupplyProject.get(0),
                listSupplierRequestRFP.get(0));
        insert listSupplierQuote;

        //Supplier Quote Line
        List<Supplier_Quote_Line__c> listSupplierQuoteLine = NEU_Data_Generator.getSupplierQuoteLine(listSupplierQuote.get(0), listItem.get(0),
                listSupplierRequestRFP.get(0));
        Supplier_Quote_Line__c supplierQuoteLine = listSupplierQuoteLine.get(0);
        insert supplierQuoteLine;

        //Quote_Item_Line
        List<Quote_Item_Line__c> listQuoteItemLine 	= NEU_Data_Generator.getQuoteItemLine(importexportquote, 2);
        Quote_Item_Line__c quoteItemLine 			= listQuoteItemLine.get(0);
        quoteItemLine.Import_Export_Quote__c 		= importexportquote.Id;
        insert quoteItemLine;

        Quote_Item_Line__c quoteItemLine2 			= listQuoteItemLine.get(1);
        quoteItemLine2.Import_Export_Quote__c 		= importexportquote.Id;
        insert quoteItemLine2;

        //Fee
        List<Fee__c> ListFee = NEU_Data_Generator.getFee(sup, 2);
        insert ListFee;

        //Import_Export_Fee_Line
        List<Import_Export_Fee_Line__c> listIeFeeLine 	= NEU_Data_Generator.getImportExportFeeLine(ListFee.get(0), importexportquote);
        List<Import_Export_Fee_Line__c> listIeFeeLine2 	= NEU_Data_Generator.getImportExportFeeLine(ListFee.get(1), importexportquote);
        insert listIeFeeLine;
        insert listIeFeeLine2;

        //Import_Export_Service_Line_Invoice
        Import_Export_Service_Line_Invoice__c ieServiceLineInvoice 	= new Import_Export_Service_Line_Invoice__c();
        ieServiceLineInvoice.Import_Export_Service_Line__c 			= listIeFeeLine.get(0).Id;
        ieServiceLineInvoice.Invoice__c 							= invoice.Id;
        insert ieServiceLineInvoice;

        ieServiceLineInvoice 	= new Import_Export_Service_Line_Invoice__c();
        ieServiceLineInvoice.Invoice__c 							= invoice2.Id;
        ieServiceLineInvoice.Import_Export_Service_Line__c 			= listIeFeeLine2.get(0).Id;
        insert ieServiceLineInvoice;

        //Import_Export_Item_Line_Invoice
        List<Import_Export_Item_Line_Invoice__c> listIeItemLine = new List<Import_Export_Item_Line_Invoice__c>();
        Import_Export_Item_Line_Invoice__c ieItemLineInvoice = new Import_Export_Item_Line_Invoice__c();
        ieItemLineInvoice.Import_Export_Item_Line__c =	quoteItemLine.Id;
        ieItemLineInvoice.Invoice__c = invoice.Id;
        listIeItemLine.add(ieItemLineInvoice);

        insert listIeItemLine;

        NEU_Create_Invoice_Service_Item page = new NEU_Create_Invoice_Service_Item(new ApexPages.StandardController(invoice));
        //page.id_linea = importexportquote.Id;
        page.id_linea =  quoteItemLine.Id;
        String sqs;
        Decimal dqs;

        for(NEU_Create_Invoice_Service_Item.Line_s lista : page.Lines)
        {
            lista.selected = true;
            sqs = lista.Quote_Sell_Net_Price_String;
            sqs = lista.Sell_Net_Amount_String;
            sqs = lista.Invoice_Outstanding_Balance_String;
            dqs = lista.Invoice_Outstanding_Base;
            break;
        }
        for(NEU_Create_Invoice_Service_Item.LineS_s lista : page.LinesS)
        {
            lista.selected = true;
            sqs =  lista.Quote_Sell_Net_Price_String;
            sqs = lista.Sell_Net_Amount_String;
            sqs = lista.Invoice_Outstanding_Balance_String;
            dqs = lista.Invoice_Outstanding_Base;
            break;
        }
        page.sorting(0,'selected',1);
        page.sorting(1,'selected',1);
        page.sortList(4);
        page.generate();
        page.new_invoice_line();
        page.quit_line_select();
        page.id_line 		= page.id_line;
        page.new_line_invoiceline_empty();
        page.delete_line_select();
        page.cancel();
        page.updateLines();
        page.decimalSep 	= page.decimalSep;
        page.thousandSep 	= page.thousandSep;


    }//fin test


    static testMethod void NEU_ShipmentsSearch() 
    {

        NEU_StaticVariableHelper.setBoolean1(true);
    
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;

        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.ETD_from_Point_of_Load__c=System.today();
        shipment_test.Route__c=route.Id;
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;

        NEU_ShipmentsSearch c = new NEU_ShipmentsSearch();
        c.shipment_status=c.shipment_status;
        c.shipments_requests=c.shipments_requests;
        c.shipments_quotes=c.shipments_quotes;
        c.shipments_orders=c.shipments_quotes;
        c.sta_list=c.sta_list;
        c.serv_list=c.serv_list;
        c.sta_list='[]';
        c.serv_list='[]';
        c.id_record_type_requests=c.id_record_type_requests;
        c.id_record_type_quotes=c.id_record_type_quotes;
        c.id_record_type_orders=c.id_record_type_orders;
        c.orden_ship_filtro_orders=c.orden_ship_filtro_orders;
        c.orden_ship_filtro_orders_modo=c.orden_ship_filtro_orders_modo;
        c.orden_ship_filtro_quotes=c.orden_ship_filtro_quotes;
        c.orden_ship_filtro_quotes_modo=c.orden_ship_filtro_quotes_modo;
        c.orden_ship_filtro_request=c.orden_ship_filtro_request;
        c.orden_ship_filtro_request_modo=c.orden_ship_filtro_request_modo;
        c.orden_ship_filtro_orders='Name';
        c.orden_ship_filtro_orders_modo='asc';
        c.orden_ship_filtro_quotes='Name';
        c.orden_ship_filtro_quotes_modo='asc';
        c.orden_ship_filtro_request='Name';
        c.orden_ship_filtro_request_modo='asc';
        c.url_tracking_externa=c.url_tracking_externa;
        c.params=c.params;
        c.ETD_operator_selected=c.ETD_operator_selected;
        c.getETD_operator_list();
        c.ETA_operator_selected=c.ETA_operator_selected;
        c.getETA_operator_list();
        c.carga_filtros();
        c.record.ETD_from_Point_of_Load__c=System.today();
        c.record.ETA_Point_of_Discharge__c=System.today();
        c.record.Route__c=route.Id;
        c.ETD_operator_selected='not equal to';
        c.ETA_operator_selected='not equal to';
        c.go_compare_ship_order();
        c.go_compare_ship_quote();
        c.go_compare_ship_request();
        c.search_shipments();
        
    }
   
    static testMethod void NEU_Shipment_View_Route() 
    {

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;

       NEU_Shipment_View_Route sr=new NEU_Shipment_View_Route(new ApexPages.StandardController( shipment_test ));
    }

    static testMethod void NEU_Delete_Trigger()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account carrier = list_accounts[1];
        insert carrier;
        Contact contacto = new Contact(AccountId = carrier.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id ,Marketplace_Auction__c = true, Only_Warehouse_Service__c = true);
        insert ship;

        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,
                Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address', Last_Shipment__c = ship.Id, Quotation_Status__c = 'Quote being prepared');
        insert importexportquote;
        
        Product_Family__c f = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert f;
        Subfamily__c d = new Subfamily__c(Product_Family__c = f.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =f.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000,Units__c=10);
        insert quote;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Sercie Rate Test';
		service_rate.Fee_Category__c = 'Disbursement';
		service_rate.Rate_Type__c = 'Per Kg';
		service_rate.Account_for__c = a.Id;
        insert service_rate;
		
		Import_Export_Fee_Line__c ie_service_line = new Import_Export_Fee_Line__c();
		ie_service_line.Import_Export_Quote__c = importexportquote.Id;
		ie_service_line.Name = '001'; 
		ie_service_line.Service_Rate_Name__c = service_rate.Id; 
		ie_service_line.Extension_Service_Name__c = 'Test Name'; 
		ie_service_line.Discount__c = 10; 
		ie_service_line.Quote_Buy_Price__c = 10; 
		ie_service_line.Quote_Sell_Price__c = 10;
		ie_service_line.Units__c = 10;
        insert ie_service_line;
		
        delete ship;
    }

    
    static testMethod void NEU_TrackTraceShipment() 
    {
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
		
		Shipment_Stop__c new_shipment_stop = new Shipment_Stop__c();
		new_shipment_stop.Shipment__c = shipment_test.Id;
		insert new_shipment_stop;
		
		List<Event__c> newevents = new List<Event__c>();
		Event__c new_event = new Event__c();
		newevents.add(new_event);
		
		Shipment_Track__c shipment_track = new Shipment_Track__c();
		List<Shipment_Stop__c> list_stops = new List<Shipment_Stop__c>();
		List<NEU_TrackTraceShipment.Route_Point_s> list_route_points = new List<NEU_TrackTraceShipment.Route_Point_s>();
		Shipment__c shipment = new Shipment__c();
		Event__c event = new Event__c();
		
		shipment = NEU_TrackTraceShipment.getShipment(shipment_test.Id);
		shipment_track = NEU_TrackTraceShipment.getShipmentTrack(shipment_test.Id);
		list_stops = NEU_TrackTraceShipment.getRoadData(shipment_test.Id);
       	list_route_points = NEU_TrackTraceShipment.getRoutePoints(shipment_test);
    }
    
    static testMethod void NEU_AssociatedDocuments() 
    {
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
		
		Shipment__c shipment = new Shipment__c();
		List<Associated_Document__c> associated_documents = new List<Associated_Document__c>();
		
		shipment = NEU_AssociatedDocuments.getShipment(shipment_test.Id);
		associated_documents = NEU_AssociatedDocuments.getDocuments(shipment_test.Id);
		associated_documents = NEU_AssociatedDocuments.createAssociatedDocuments(shipment_test.Id, new string[]{'00|00'});   
		associated_documents = NEU_AssociatedDocuments.deleteDocument(shipment_test.Id, '');   	
    }
    
    static testMethod void NEU_InvoiceDocuments() 
    {
		NEU_StaticVariableHelper.setBoolean1(true);
		
		List<Associated_Document__c> associated_documents = new List<Associated_Document__c>();
		
		associated_documents = NEU_InvoiceDocuments.getDocuments();
    }
    
    static testMethod void NEU_RoadTrackTrace()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
    	
    	Country__c country_test = new Country__c();
    	country_test.Name = 'Country Test';
    	country_test.ISO_Code__c = 'EUR';
        insert country_test;
        
        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test'; 
        location_test.Country__c = country_test.Id; 
        location_test.Subdivision__c = 'Sbudivision'; 
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;
    	
    	Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        shipment_test.Direccion_Monitoreo__c = 'Test';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
    	
    	Shipment_Stop__c new_shipment_stop = new Shipment_Stop__c();
		new_shipment_stop.Shipment__c = shipment_test.Id;
		insert new_shipment_stop;
    	
    	NEU_RoadTrackTrace rtt = new NEU_RoadTrackTrace(new ApexPages.StandardController(shipment_test));
    }
    
    static testMethod void NEU_Shipment_Warnings()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
    	
    	Country__c country_test = new Country__c();
    	country_test.Name = 'Country Test';
    	country_test.ISO_Code__c = 'EUR';
        insert country_test;
        
        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test'; 
        location_test.Country__c = country_test.Id; 
        location_test.Subdivision__c = 'Sbudivision'; 
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;
    	
    	Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        shipment_test.Direccion_Monitoreo__c = 'Test';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
        
        NEU_Shipment_Warnings rtt = new NEU_Shipment_Warnings(new ApexPages.StandardController(shipment_test));
        
        NEU_WarningsRecords wr = new NEU_WarningsRecords();
    	wr.setobject_selected('Shipment__c');
    	wr.getobject_selected();
    	wr.setid_record_selected(shipment_test.Id);
    	wr.getid_record_selected();
    	wr.load_warnings();
    }
    
    static testMethod void NEU_CreateEntriesExitsFromShipment()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Country__c country_test = new Country__c();
    	country_test.Name = 'Country Test';
    	country_test.ISO_Code__c = 'EUR';
        insert country_test;
        
        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test'; 
        location_test.Country__c = country_test.Id; 
        location_test.Subdivision__c = 'Subdivision'; 
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;
    	
    	Warehouse__c warehouse_test = new Warehouse__c();
    	warehouse_test.Name = 'Warehouse Test';
    	warehouse_test.Total_Space_m2__c = 100;
    	insert warehouse_test;
    	
    	Warehouse_Storage_Bin__c warehouse_sb_test = new Warehouse_Storage_Bin__c();
    	warehouse_sb_test.Name = 'WSB';
    	warehouse_sb_test.Warehouse__c = warehouse_test.Id;
    	insert warehouse_sb_test;
    	
    	Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Road';
        shipment_test.Service_Mode__c = 'NATIONAL';
        shipment_test.Service_Type__c = 'FTL';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        shipment_test.Warehouse__c = warehouse_test.Id;
        shipment_test.Warehouse_Movement_Type__c = 'Entries (In)';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
        
        Sourcing_Item__c item_test = new Sourcing_Item__c();
        item_test.Name = 'Item Test';
        item_test.Account_Owner__c = account_test.Id;
        insert item_test;

        Sourcing_Item__c item_test2 = new Sourcing_Item__c();
        item_test2.Name = 'Item Test2';
        item_test2.Account_Owner__c = account_test.Id;
        insert item_test2;

        Shipment_Line__c shipment_line_test = new Shipment_Line__c();
        shipment_line_test.Name = '001';
        shipment_line_test.Item_Name__c = item_test.Id;
        shipment_line_test.Shipment__c = shipment_test.Id;
        shipment_line_test.Units_Shipped__c = 100;
        insert shipment_line_test;

        Shipment_Line__c shipment_line_test2 = new Shipment_Line__c();
        shipment_line_test2.Name = '001';
        shipment_line_test2.Item_Name__c = item_test2.Id;
        shipment_line_test2.Shipment__c = shipment_test.Id;
        shipment_line_test2.Units_Shipped__c = 200;
        insert shipment_line_test2;
    	
    	Inventory_Entry__c inventory_entry_test = new Inventory_Entry__c();
    	inventory_entry_test.Warehouse__c = warehouse_test.Id;
    	inventory_entry_test.Warehouse_Storage_Bin__c = warehouse_sb_test.Id;
    	inventory_entry_test.Item__c = item_test.Id;
    	inventory_entry_test.Shipment__c = shipment_test.Id;
    	inventory_entry_test.Shipment_Item_Line__c = shipment_line_test.Id;
    	inventory_entry_test.Units_Entry__c = 100;
    	insert inventory_entry_test;
    	
    	Inventory_Exit__c inventory_exit_test = new Inventory_Exit__c();
    	inventory_exit_test.Inventory_Entry__c = inventory_entry_test.Id;
    	inventory_exit_test.Warehouse__c = warehouse_test.Id;
    	inventory_exit_test.Warehouse_Storage_Bin__c = warehouse_sb_test.Id;
    	inventory_exit_test.Item__c = item_test.Id;
    	inventory_exit_test.Shipment__c = shipment_test.Id;
    	inventory_exit_test.Shipment_Item_Line__c = shipment_line_test.Id;
    	inventory_exit_test.Units_Picked__c = 10;
    	insert inventory_exit_test;
    	
    	NEU_CreateEntriesExitsFromShipment ceefs = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
        ceefs.create_entries();
    	ceefs.return_shipment();

        shipment_test.Warehouse_Movement_Type__c = 'Deliveries (Out)';
    	update shipment_test;

    	NEU_CreateEntriesExitsFromShipment ceefs2 = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
    	ceefs2.create_exits();
        //Añadimos varios pallet en la clase
        Pallet_warehouse__c pallet_wa = new pallet_warehouse__c();
        pallet_wa.Height_cm__c = 20;
        pallet_wa.lenght_cm__c = 20;
        insert pallet_wa;
        Pallet_warehouse__c pallet_wa2 = new pallet_warehouse__c();
        pallet_wa2.Height_cm__c = 40;
        pallet_wa2.lenght_cm__c = 40;
        insert pallet_wa2;

        shipment_line_test.pallet_warehouse__c = pallet_wa.Id;
        shipment_line_test2.pallet_warehouse__c = pallet_wa2.Id;
        update shipment_line_test;
        update shipment_line_test2;
        NEU_CreateEntriesExitsFromShipment ceefsWA = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
        //Creacion de NEU_CreateEntriesExitsFromShipment con selected a true
        NEU_CreateEntriesExitsFromShipment ceefsbucle = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
        for(NEU_CreateEntriesExitsFromShipment.exit_lines_pallets_s pl : ceefsbucle.palletLinesExits){
            for(NEU_CreateEntriesExitsFromShipment.exit_s e : pl.ex){
                e.selected=true;
            }
        }
        ceefsbucle.create_entries();
        //Forzamos el caso de error en caso de shipment incorrecto
        NEU_CreateEntriesExitsFromShipment ceefsError = new NEU_CreateEntriesExitsFromShipment(null);


        NEU_GenerateWEDoc gwed = new NEU_GenerateWEDoc(new ApexPages.StandardController(shipment_test));


    	
    	NEU_GenerateWEDocSave gweds = new NEU_GenerateWEDocSave(new ApexPages.StandardController(shipment_test));
    	gweds.crear();
    }
    
    static testMethod void NEU_ShipmentConfirmToInvoice()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Country__c country_test = new Country__c();
    	country_test.Name = 'Country Test';
    	country_test.ISO_Code__c = 'EUR';
        insert country_test;
        
        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test'; 
        location_test.Country__c = country_test.Id; 
        location_test.Subdivision__c = 'Subdivision'; 
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;
    	
    	Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Road';
        shipment_test.Service_Mode__c = 'NATIONAL';
        shipment_test.Service_Type__c = 'FTL';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        insert shipment_test;
        
        NEU_ShipmentConfirmToInvoice scti = new NEU_ShipmentConfirmToInvoice(new ApexPages.StandardController(shipment_test));
        scti.update_shipment();
    }
    
    static testMethod void NEU_CreateInventoryExits()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Country__c country_test = new Country__c();
    	country_test.Name = 'Country Test';
    	country_test.ISO_Code__c = 'EUR';
        insert country_test;
        
        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test'; 
        location_test.Country__c = country_test.Id; 
        location_test.Subdivision__c = 'Subdivision'; 
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;
    	
    	Warehouse__c warehouse_test = new Warehouse__c();
    	warehouse_test.Name = 'Warehouse Test';
    	warehouse_test.Total_Space_m2__c = 100;
    	insert warehouse_test;
    	
    	Warehouse_Storage_Bin__c warehouse_sb_test = new Warehouse_Storage_Bin__c();
    	warehouse_sb_test.Name = 'WSB';
    	warehouse_sb_test.Warehouse__c = warehouse_test.Id;
    	insert warehouse_sb_test;
    	
    	Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Road';
        shipment_test.Service_Mode__c = 'NATIONAL';
        shipment_test.Service_Type__c = 'FTL';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        shipment_test.Warehouse__c = warehouse_test.Id;
        shipment_test.Warehouse_Movement_Type__c = 'Entries (In)';
        insert shipment_test;
        
        Sourcing_Item__c item_test = new Sourcing_Item__c();
        item_test.Name = 'Item Test';
        item_test.Account_Owner__c = account_test.Id;
        insert item_test;

        Shipment_Line__c shipment_line_test = new Shipment_Line__c();
        shipment_line_test.Name = '001';
        shipment_line_test.Item_Name__c = item_test.Id;
        shipment_line_test.Shipment__c = shipment_test.Id;
        shipment_line_test.Units_Shipped__c = 100;
        insert shipment_line_test;

        Shipment_Line__c shipment_line_test2 = new Shipment_Line__c();
        shipment_line_test2.Name = '002';
        shipment_line_test2.Item_Name__c = item_test.Id;
        shipment_line_test2.Shipment__c = shipment_test.Id;
        shipment_line_test2.Units_Shipped__c = 100;
        insert shipment_line_test2;
    	
    	Warehouse_Exit_Order__c warehouse_exit_order_test = new Warehouse_Exit_Order__c();
    	warehouse_exit_order_test.Account_for_Customer__c = account_test.Id;
    	warehouse_exit_order_test.Warehouse__c = warehouse_test.Id;
    	insert warehouse_exit_order_test;
    	
    	Inventory_Entry__c inventory_entry_test = new Inventory_Entry__c();
    	inventory_entry_test.Warehouse__c = warehouse_test.Id;
    	inventory_entry_test.Warehouse_Storage_Bin__c = warehouse_sb_test.Id;
    	inventory_entry_test.Item__c = item_test.Id;
    	inventory_entry_test.Shipment__c = shipment_test.Id;
    	inventory_entry_test.Shipment_Item_Line__c = shipment_line_test.Id;
    	inventory_entry_test.Units_Entry__c = 100;
    	insert inventory_entry_test;
    	
    	Inventory_Exit__c inventory_exit_test = new Inventory_Exit__c();
    	inventory_exit_test.Inventory_Entry__c = inventory_entry_test.Id;
    	inventory_exit_test.Warehouse__c = warehouse_test.Id;
    	inventory_exit_test.Warehouse_Storage_Bin__c = warehouse_sb_test.Id;
    	inventory_exit_test.Item__c = item_test.Id;
    	inventory_exit_test.Shipment__c = shipment_test.Id;
    	inventory_exit_test.Shipment_Item_Line__c = shipment_line_test.Id;
    	inventory_exit_test.Units_Picked__c = 10;
    	inventory_exit_test.Warehouse_Exit_Order__c = warehouse_exit_order_test.Id;
    	insert inventory_exit_test;

    	NEU_CreateInventoryExits cie = new NEU_CreateInventoryExits(new ApexPages.StandardController( warehouse_test));
    	cie.search_entries();
    	cie.create_exits();
    	cie.return_warehouse();

        //Añadimos varios pallet en la clase
        Pallet_warehouse__c pallet_wa = new pallet_warehouse__c();
        pallet_wa.Height_cm__c = 20;
        pallet_wa.lenght_cm__c = 20;
        insert pallet_wa;
        Pallet_warehouse__c pallet_wa2 = new pallet_warehouse__c();
        pallet_wa2.Height_cm__c = 40;
        pallet_wa2.lenght_cm__c = 40;
        insert pallet_wa2;

        shipment_line_test.pallet_warehouse__c = pallet_wa.Id;
        shipment_line_test2.pallet_warehouse__c = pallet_wa2.Id;
        update shipment_line_test;
        update shipment_line_test2;
        //Creamos una clase con un pallet asignado
        NEU_CreateInventoryExits cie2 = new NEU_CreateInventoryExits(new ApexPages.StandardController( warehouse_test));
        cie2.search_entries();
        cie2.create_exits();
        cie2.return_warehouse();

        //Forzamos el error para pasar por el catch
        NEU_CreateInventoryExits cieError = new NEU_CreateInventoryExits(null);


        NEU_GenerateWEDocExitOrder gwedeo = new NEU_GenerateWEDocExitOrder(new ApexPages.StandardController(warehouse_exit_order_test));
    	
    	NEU_GenerateWEDocExitOrderSave gwedeos = new NEU_GenerateWEDocExitOrderSave(new ApexPages.StandardController(warehouse_exit_order_test));
    	gwedeos.crear();
    }
}