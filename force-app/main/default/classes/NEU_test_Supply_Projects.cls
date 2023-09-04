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
private class NEU_test_Supply_Projects {

   static testMethod void test_NEU_MD_PriceComparison()
   {
    NEU_StaticVariableHelper.setBoolean1(true);
      List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Supplier,Customer,');
      Account a = list_accounts[0];
      insert a;
      Account a2 = list_accounts[1];
      insert a2;
      Account b = list_accounts[2];
      insert b;
      
     
      Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
      insert Country;
      Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
      insert localizacion;
      Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
      insert route;
      Warehouse__c almacen = new Warehouse__c(Name='test', Account_Owner__c=a.Id, Country__c=Country.Id, Location__c=localizacion.Id);
      insert almacen;
      Delivery_Zone__c delivery_zone = new Delivery_Zone__c(Name= 'test', Port_Airport__c=localizacion.Id, Warehouse__c=almacen.Id);
      insert delivery_zone;
      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
      insert supplyproject;
      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Delivery_Zone__c = delivery_zone.Id, Supplier_Quote_Status__c = 'Approved', Route__c=route.Id);
      insert supquote;
      Supplier_Quote__c supquote2 = new Supplier_Quote__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Supplier_Quote_Status__c = 'Approved', Route__c=route.Id);
      insert supquote2;
      Supplier_to_Invite__c sup_to_invi = new Supplier_to_Invite__c (Name = 'test supplier', Account__c = a.Id , Supply_Project__c = supplyproject.Id);
      insert sup_to_invi;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Sales');
      insert c;
      Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily', Url_Image__c='www.g&ooid=gle.&es');
      insert d;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id, HS_Code_Text__c='54895464');
      insert item;
      Sourcing_Item__c item2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id, HS_Code_Text__c='54895464');
      insert item2;
      Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
      insert items_supply;
      Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item_to_Supply__c=items_supply.Id, Active__c=true, Item__c= item.Id);
      insert sup_quote_lines;
     
      Supplier_Quote_Line__c sup_quote_lines2 = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item_to_Supply__c=items_supply.Id, Active__c=true, Item__c= item.Id);
      insert sup_quote_lines2;
      Supplier_Quote_Line__c sup_quote_lines3 = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote2.Id, Name=' test quote line', Item_to_Supply__c=items_supply.Id, Active__c=true, Item__c= item.Id);
      insert sup_quote_lines3;
      Supplier_Quote_Line__c sup_quote_lines4 = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote2.Id, Name=' test quote line', Item_to_Supply__c=items_supply.Id, Active__c=true, Item__c= item.Id);
      insert sup_quote_lines4;
      
      Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
      insert fee;
      Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container',Standard_Rate__c = true, Account_for__c = a.Id);
      insert fee2;
      Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container',Standard_Rate__c = true, Account_for__c = a.Id);
      insert fee3;
      Supplier_Quote_Order_Fee_Line__c sup_quotefeeline = new Supplier_Quote_Order_Fee_Line__c(Name= 'test supquote fee line', Supplier_Quote_Order__c = supquote.Id, Fee_Name__c = fee.Id);
      insert sup_quotefeeline;
  
      Container_Type__c cont_type = new Container_Type__c(Name='test container', Cargo_Volume_m3__c = 100, Cargo_Weight_Kg__c = 100);
      insert cont_type;
      NEU_MD_PriceComparison  uda = new NEU_MD_PriceComparison (new ApexPages.StandardController( supplyproject ));
      uda.delivery_zone_selected =
      uda.sup_list ='['+a.Id+','+a2.Id+']';
      uda.it_list = '['+item.Id+','+item2.Id+']';
      uda.carga_filtros();
      uda.go_compare();
      uda.id_oi = sup_quote_lines.Id;
      uda.desactive_lines();
      uda.calculate_std_fees();
      uda.calculate_duty();
      uda.refresh();
      NEU_MD_PriceComparison.Data_1 line;
      NEU_MD_PriceComparison.Data_2 line2;
    }
    
    
    static testMethod void test_NEU_OM_UploadItems()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;//supplier
        Account b = list_accounts[1];
        insert b;//buyer
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test family',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c = c.id, Account_Owner__c = b.Id , E_Commerce__c = true);
        insert item;
         Sourcing_Item__c item2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c = c.id, Account_Owner__c = b.Id , E_Commerce__c = true);
        insert item2;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Items_to_Supply__c items_supply2 = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply2;
        NEU_OM_UploadItems ui = new NEU_OM_UploadItems(new ApexPages.StandardController( supplyproject ));
        ui.family_list=ui.family_list;
        ui.get_oi_from_family();
        ui.id_oi = items_supply2.Id;
        ui.create_oi();
        ui.delete_oi();
        ui.return_project();
    }
    
    static testMethod void test_NEU_OM_UploadItemsN()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;//supplier
        Account b = list_accounts[1];
        insert b;//buyer
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id,Business_Area__c = 'Sales');
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test family',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c = c.id, Account_Owner__c = b.Id , E_Commerce__c = true);
        insert item;
        Sourcing_Item__c item2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c = c.id, Account_Owner__c = b.Id , E_Commerce__c = true);
        insert item2;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Items_to_Supply__c items_supply2 = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply2;
        NEU_OM_UploadItems ui = new NEU_OM_UploadItems(new ApexPages.StandardController( supplyproject ));
        ui.id_family='1';
        ui.actual_items_family=ui.actual_items_family;
        ui.new_items=ui.new_items;
        ui.id_family='2';
        ui.actual_items_family=ui.actual_items_family;
        ui.new_items=ui.new_items;
        ui.id_family=c.Id;
        ui.actual_items_family=ui.actual_items_family;
        ui.new_items=ui.new_items;
        ui.current_family=ui.current_family;
        ui.nombre_de_items=ui.nombre_de_items;
        ui.decimalSep=ui.decimalSep;
        ui.thousandSep=ui.thousandSep;
        return;
    }
    
    public static testMethod void test_NEU_OM_Upload_Suppliers_to_Invite() {//ok
NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Supplier,Supplier,Customer,');
        Account a = list_accounts[0];
        a.Status_Account__c = 'Partner';
        insert a;
        Account pre = list_accounts[1];
        a.Status_Account__c = 'Premium';
        insert pre;
        Account ac =list_accounts[2];
        a.Status_Account__c = 'Active';
        insert ac;
        Account b = list_accounts[3];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        NEU_OM_Upload_Suppliers_to_Invite uda = new NEU_OM_Upload_Suppliers_to_Invite(new ApexPages.StandardController( supplyproject ));
        uda.getlista_todos_suppliers();
        uda.getnewcategories();
        uda.getnewcategory();
        uda.setnewcategory(c.Id);
        uda.getlista_suppliers();
        uda.crearsupplierinvite();
        uda.delete_supplier_select();
        uda.return_project();
      
        system.debug( 'Prueba realizada' );
    }
    
     public static testMethod void test_NEU_Clone_Supply_Projects()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c( Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Associated_Document__c associated_document = new Associated_Document__c(Name='test associated document', Supply_Project__c =supplyproject.Id, Account__c= b.Id );
        insert associated_document;
        Product_Family__c family = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert family;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        NEU_Clone_Supply_Projects csp = new NEU_Clone_Supply_Projects(new ApexPages.StandardController( supplyproject ));
        csp.duplicate_supply_projects();
    }
    
    public static testMethod void test_NEU_OM_Send_Requests()//ok
    {
       NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
        insert supplierequest;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id);
        insert supplierequestline;
        Associated_Document__c associated_document = new Associated_Document__c(Name='test associated document', Supply_Project__c =supplyproject.Id, Account__c= b.Id );
        insert associated_document;
        
        NEU_OM_Send_Requests sr = new NEU_OM_Send_Requests(new ApexPages.StandardController( supplyproject ));
        sr.getassociated_documents();
        sr.getlista_suppliers();
        sr.getlista_items();
        sr.getInfo_item();
        sr.send_request();
        sr.return_project();
        system.debug( 'Prueba realizada' );
    }
    
    static testMethod void NEU_OM_UploadItems() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account new_account = list_accounts[0];
        new_account.Status_Account__c = 'Active';
        insert new_account;
        
        
        Product_Family__c new_family = new Product_Family__c();
        new_family.Name = 'Family Test';
        insert new_family;
        
        Supply_Project__c new_supply_project = new Supply_Project__c();
        new_supply_project.Name = 'Supply Project Test';
        new_supply_project.Customer__c = new_account.Id;
        insert new_supply_project;
        
        Sourcing_Item__c new_item = new Sourcing_Item__c();
        new_item.Name = 'Item Test';
        new_item.Account_Owner__c = new_account.Id;
        new_item.Sourcing_Family__c = new_family.Id;
        insert new_item;
        
        Sourcing_Item__c new_item2 = new Sourcing_Item__c();
        new_item2.Name = 'Item Test2';
        new_item2.Account_Owner__c = new_account.Id;
        new_item2.Sourcing_Family__c = new_family.Id;
        insert new_item2;
        
        Items_to_Supply__c new_item_supply = new Items_to_Supply__c();
        new_item_supply.Sourcing_Item__c = new_item.Id;
        new_item_supply.Supply_Project__c = new_supply_project.Id;
        insert new_item_supply;
        
        Items_to_Supply__c new_item_supply2 = new Items_to_Supply__c();
        new_item_supply2.Sourcing_Item__c = new_item2.Id;
        new_item_supply2.Supply_Project__c = new_supply_project.Id;
        insert new_item_supply2;
        
        NEU_OM_UploadItems ui = new NEU_OM_UploadItems(new ApexPages.StandardController( new_supply_project ));
        NEU_OM_UploadItems.items_s item;
        List<NEU_OM_UploadItems.items_s> lista_items = new List<NEU_OM_UploadItems.items_s>();
        lista_items.add(new NEU_OM_UploadItems.items_s(null,null,'','','','',0,0,0,'',false,null,'EUR'));
        List<NEU_OM_UploadItems.items_s> lista_items2 = new List<NEU_OM_UploadItems.items_s>();
        lista_items2.add(new NEU_OM_UploadItems.items_s(null,null,'test','test','test','test',10,10,10,'test',true,null,'EUR'));
        ui.new_items = lista_items2;
        ui.items_to_save = lista_items2;
        ui.id_oi = new_item_supply.Id;
        ui.id_family = new_family.Id;
        ui.get_oi_from_family();
       
        ui.create_oi();
        ui.crearlineaSupplyitem();
        ui.delete_oi();
        ui.return_project();
        ui.esta_creado_el_item = false;
        ui.crearlineaSupplyitem();
    }
    
    
    static testMethod void NEU_OM_UploadItems2() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account new_account = list_accounts[0];
        new_account.Status_Account__c = 'Active';
        insert new_account;
        
        Product_Family__c new_family = new Product_Family__c();
        new_family.Name = 'Family Test';
        insert new_family;
        
        Supply_Project__c new_supply_project = new Supply_Project__c();
        new_supply_project.Name = 'Supply Project Test';
        new_supply_project.Customer__c = new_account.Id;
        insert new_supply_project;
        
        Sourcing_Item__c new_item = new Sourcing_Item__c();
        new_item.Name = 'Item Test';
        new_item.Account_Owner__c = new_account.Id;
        new_item.Sourcing_Family__c = new_family.Id;
        insert new_item;
        
        Sourcing_Item__c new_item2 = new Sourcing_Item__c();
        new_item2.Name = 'Item Test2';
        new_item2.Account_Owner__c = new_account.Id;
        new_item2.Sourcing_Family__c = new_family.Id;
        insert new_item2;
        
        Items_to_Supply__c new_item_supply = new Items_to_Supply__c();
        new_item_supply.Sourcing_Item__c = new_item.Id;
        new_item_supply.Supply_Project__c = new_supply_project.Id;
        insert new_item_supply;
        
        Items_to_Supply__c new_item_supply2 = new Items_to_Supply__c();
        new_item_supply2.Sourcing_Item__c = new_item2.Id;
        new_item_supply2.Supply_Project__c = new_supply_project.Id;
        insert new_item_supply2;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = new_account.Id,
        Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', 
        Country_ofLoad__c= Country.Id, Site_of_Load__c =localizacion.Id,Country_ofDischarge__c= Country.Id,
        Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address', Supply_Project_Name__c = new_supply_project.Id);//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = new_account.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10, Supply_Project__c=new_supply_project.Id );
        insert quote2;
        
        Import_Export_Fee_Line__c quote3 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10, Supply_Project__c=new_supply_project.Id );
        insert quote3;
        Import_Export_Fee_Line__c quote4 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10, Supply_Project__c=new_supply_project.Id );
        insert quote4;
        
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Account_for__c = new_account.Id,
        Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', 
        Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,
        Site_of_Discharge__c = localizacion.Id, Destination_Address__c='test address', Supply_Project_Name__c = new_supply_project.Id);//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote2;
        
        Import_Export_Fee_Line__c quote5 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10, Supply_Project__c=new_supply_project.Id );
        insert quote5;
        
        NEU_OM_UploadItems ui = new NEU_OM_UploadItems(new ApexPages.StandardController( new_supply_project ));
        NEU_OM_UploadItems.items_s item;
        List<NEU_OM_UploadItems.items_s> lista_items = new List<NEU_OM_UploadItems.items_s>();
        lista_items.add(new NEU_OM_UploadItems.items_s(null,null,'','','','',0,0,0,'',false,null,'EUR'));
        List<NEU_OM_UploadItems.items_s> lista_items2 = new List<NEU_OM_UploadItems.items_s>();
        lista_items2.add(new NEU_OM_UploadItems.items_s(null,null,'test','test','test','test',10,10,10,'test',true,null,'EUR'));
        ui.new_items = lista_items2;
        ui.items_to_save = lista_items2;
        ui.id_oi = new_item_supply.Id;
        ui.id_family = new_family.Id;
        ui.get_oi_from_family();
       
        ui.create_oi();
       // ui.crearlineaSupplyitem();
       
        ui.delete_oi();
        ui.return_project();
    }
    
    static testMethod void NEU_OM_Upload_Suppliers_to_Invite() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account new_account = list_accounts[0];
        new_account.Status_Account__c = 'Active';
        insert new_account;
        
        Account new_supplier = list_accounts[1];
        new_supplier.Status_Account__c = 'Active';
        insert new_supplier;
        
        Contact new_contact = new Contact();
        new_contact.LastName = 'Contact Test';
        new_contact.AccountId = new_supplier.Id;
        new_contact.Email = 'test@test.com';
        insert new_contact;
        
        Product_Family__c new_family = new Product_Family__c();
        new_family.Name = 'Family Test';
        insert new_family;
        
        Supply_Project__c new_supply_project = new Supply_Project__c();
        new_supply_project.Name = 'Supply Project Test';
        new_supply_project.Customer__c = new_account.Id;
        insert new_supply_project;
        
        Sourcing_Item__c new_item = new Sourcing_Item__c();
        new_item.Name = 'Item Test';
        new_item.Account_Owner__c = new_account.Id;
        new_item.Sourcing_Family__c = new_family.Id;
        insert new_item;
        
        Items_to_Supply__c new_item_supply = new Items_to_Supply__c();
        new_item_supply.Sourcing_Item__c = new_item.Id;
        new_item_supply.Supply_Project__c = new_supply_project.Id;
        insert new_item_supply;
        
        Supplier_to_Invite__c new_supplier_to_invite = new Supplier_to_Invite__c();
        new_supplier_to_invite.Supply_Project__c = new_supply_project.Id;
        new_supplier_to_invite.Account__c = new_supplier.Id;
        new_supplier_to_invite.Responsible_for_the_Project__c = new_contact.Id;
        insert new_supplier_to_invite;
        
        //List<SelectOption> lista_seleccion = new List<SelectOption>();
        //lista_seleccion.add(new SelectOption(new_contact.Id,new_contact.Name));
        
        NEU_OM_Upload_Suppliers_to_Invite usti = new NEU_OM_Upload_Suppliers_to_Invite(new ApexPages.StandardController( new_supply_project ));
        NEU_OM_Upload_Suppliers_to_Invite.Supplier_s suppliers;
        List<NEU_OM_Upload_Suppliers_to_Invite.Supplier_s> lista_suppliers = new List<NEU_OM_Upload_Suppliers_to_Invite.Supplier_s>();
        lista_suppliers.add(new NEU_OM_Upload_Suppliers_to_Invite.Supplier_s(new_supplier,false,false,null,''));
        
        usti.id_oi = new_supplier.Id;
        usti.getlista_todos_suppliers();
        usti.getnewcategories();
        usti.getnewcategory();
        usti.setnewcategory(new_family.Id);
        usti.getlista_suppliers();
        usti.crearsupplierinvite();
        usti.delete_supplier_select();
        usti.return_project();
    }
    
    static testMethod void test_NEU_OM_Upload_Suppliers_to_Invite2() {
      NEU_StaticVariableHelper.setBoolean1(true);
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Supplier,Customer,');
      Account a = list_accounts[0];
      insert a;
      Account a2 = list_accounts[1];
      a2.Efficiency_Level__c='3';
      a2.Delivery_Times__c='2';
      a2.Prices__c = '2';
      a2.Quality_Products__c = '2';
      insert a2;
      Account b = list_accounts[2];
      insert b;
      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
      insert supplyproject; 
      Supplier_to_Invite__c su_to_invi = new Supplier_to_Invite__c(Name='test sup',Account__c=a.Id, Supply_Project__c = supplyproject.Id);   
      insert su_to_invi;
      
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
      insert c;
      Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily', Url_Image__c='www.g&ooid=gle.&es');
      insert d;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
      insert item;
      Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
      insert items_supply;
      Family_Supplied__c subsup = new Family_Supplied__c(Family__c= c.Id, Supplier_Account__c= a.Id);
      insert subsup;
      Family_Supplied__c subsup2 = new Family_Supplied__c(Family__c= c.Id, Supplier_Account__c= a2.Id);
      insert subsup2;
      NEU_OM_Upload_Suppliers_to_Invite uda = new NEU_OM_Upload_Suppliers_to_Invite(new ApexPages.StandardController( supplyproject ));
      uda.setnewcategory(c.Id);
      uda.getlista_todos_suppliers();
      uda.getnewcategories();
      uda.getnewcategory();
      
      uda.getlista_suppliers();
      for(NEU_OM_Upload_Suppliers_to_Invite.Supplier_s us : uda.getlista_suppliers())
      {
          us.selected = true;
      }
      
      uda.orden_quotes='line.Efficiency_Level_Score__c-asc';
      uda.go_compare();
      uda.orden_quotes='line.Delivery_Times_Score__c-asc';
      uda.go_compare();
      uda.orden_quotes='line.Colaboration_Score__c-asc';
      uda.go_compare();
      uda.orden_quotes='line.Prices_Score__c-asc';
      uda.go_compare();
      uda.orden_quotes='line.Quality_Products_Score__c-asc';
      uda.go_compare();
      uda.orden_quotes='line.contact_select-asc';
      uda.go_compare();
      uda.orden_quotes='line.Description-asc';
      uda.go_compare();
      uda.orden_quotes='line.Activity_Sector__c-asc';
      uda.go_compare();
      uda.orden_quotes='line.Brand_Name__c-asc';
      uda.go_compare();
      uda.orden_quotes='line.Name-asc';
      uda.go_compare();
      
      uda.crearsupplierinvite();
      uda.delete_supplier_select();
      uda.return_project();
      List<SelectOption> subfamilies2 = new List<SelectOption>();
      subfamilies2 = uda.subfamilies;
      List<SelectOption> items1 = new List<SelectOption>();
      items1 = uda.items;
      
    }
    
    public static testMethod void test_NEU_OM_Send_Requests2()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
      Account a = list_accounts[0];
      insert a;
      Account b = list_accounts[1];
      insert b;
      Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
      insert contacto;
      Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto2;
      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
      insert supplyproject;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
      insert c;
      Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
      insert d;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
      insert item;
      Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
      insert items_supply;
      Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
      insert supin;
      Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
      insert supin2;
      Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
      insert supplierequest;
      Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id);
      insert supplierequestline;
      Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
      insert Country;
      Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
      insert localizacion;
      supplyproject.Country_of_Load__c = Country.Id;
      update supplyproject;
      List<Folder> directorio = new List<Folder>();
      directorio = [Select Id, Name from Folder limit 2];
     // Blob body_document;
     // body_document = Blob.valueOf('Some Text');
      //Document documentos = new Document(Name='test document', body=body_document, FolderId=directorio[1].Id);
     // insert documentos;
      Associated_Document__c associated_document = new Associated_Document__c(Name='test associated document', Supply_Project__c =supplyproject.Id, Account__c= b.Id, Document_URL__c='www..dfsafdasfa?file=+documentos.Id+&oid=');
      insert associated_document;
        
      NEU_OM_Send_Requests sr = new NEU_OM_Send_Requests(new ApexPages.StandardController( supplyproject ));
      sr.name_item_selected = 'test';
      sr.total_peso_ficheros = 10;
      sr.bytesocupados = 10;
      sr.porc_ocupacion = '10';
      sr.all_country_load = 'all';
      sr.all_port_load = 'all';
     // sr.documents_s = new sr.documents_s();
      List<NEU_OM_Send_Requests.documents_s> documents = new List<NEU_OM_Send_Requests.documents_s >();
    
      documents.add(new NEU_OM_Send_Requests.documents_s(false, 'test name', 'document type', 'document reference', 'document descripcion', 'document url', 'idoc', 10, '100%'));
      sr.getassociated_documents();
      sr.getlista_suppliers();
      sr.getlista_items();
      sr.getInfo_item();
      for(NEU_OM_Send_Requests.Items_s it: sr.getlista_items())
      {
        it.selected = true;
      }
      for(NEU_OM_Send_Requests.Supplier_s it: sr.getlista_suppliers())
      {
        it.selected=true;
      }
      sr.getInfo_item();
      
      
      for(NEU_OM_Send_Requests.documents_s it: sr.getassociated_documents())
      {
        it.selected=true;
      }

      sr.send_request();
      sr.return_project();
      system.debug( 'Prueba realizada' );
    }
    
      public static testMethod void testNEU_OM_FollowersSupplyProject() {//ok
      	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
      
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        
       NEU_OM_FollowersSupplyProject uda = new NEU_OM_FollowersSupplyProject(new ApexPages.StandardController( supplyproject ));
        
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
      }
      
      public static testMethod void testNEU_OM_FollowersSupplyProject2() {//ok
      	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
      
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        NEU_OM_FollowersSupplyProject uda = new NEU_OM_FollowersSupplyProject(new ApexPages.StandardController( supplyproject ));
        List<NEU_OM_FollowersSupplyProject.follower_s> lista_de_followers = new List<NEU_OM_FollowersSupplyProject.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersSupplyProject.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersSupplyProject.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersSupplyProject.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersSupplyProject.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersSupplyProject.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
      }
      
      static testMethod void test_NEU_OM_ProjectSteps() {
      	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        NEU_OM_ProjectSteps proy = new NEU_OM_ProjectSteps(new ApexPages.StandardController( supplyproject ));
        system.debug( 'Prueba realizada' );
    }

}