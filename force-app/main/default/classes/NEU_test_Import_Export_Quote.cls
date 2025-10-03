@isTest
private class NEU_test_Import_Export_Quote {
    static testMethod void NEU_Supplier_Delivery_Schedule()
    {
        
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

        Customer_Quote__c importexportquote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name = '.';
        importexportquote.Account_for__c = a.Id;
        importexportquote.Team__c = 'P2G';
        importexportquote.Quotation_Status__c = 'Quote being prepared';
        importexportquote.Customer_Reference__c = 'hola soy una prueba';
        importexportquote.Valid_From__c = System.today();
        importexportquote.Valid_Until__c = System.today();
        importexportquote.Comercio_Exterior__c = 'No';
        importexportquote.Freight_Mode__c = 'Road';
        importexportquote.Service_Mode__c = 'NATIONAL';
        importexportquote.Service_Type__c = 'FTL';
        importexportquote.CurrencyIsoCode = 'MXN';
        importexportquote.ETD__c = Date.today();
        importexportquote.ETA__c = Date.today();
        importexportquote.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote.Pricing_Executive__c = userT.Id;
        importexportquote.Operations_Exec__c = userT.Id;
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
       
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000, Units_x_Master_Box__c=10 );
        insert g;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000,Expense_Amount__c =10);
        insert sup_quote_lines;
        List<Quote_Item_Line__c > list_quote_item = new List<Quote_Item_Line__c >();
        Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id,Supplier_Quote__c=supquote.Id,Expense_Amount__c =10);
        list_quote_item.add(quote4);
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Item_Name__c= g.Id, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id, Supplier_Quote__c=supquote.Id,Expense_Amount__c =10);
        list_quote_item.add(quote);
        Shipment__c ship = new Shipment__c(Name='fgf',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        insert list_quote_item;
        NEU_Supplier_Delivery_Schedule uda = new NEU_Supplier_Delivery_Schedule(new ApexPages.StandardController( importexportquote ));
        uda.id_principal_check = quote.Id;
        uda.getcontainer_selected();
        uda.getcontainers();
        uda.setcontainer_selected(pallet_container.Id);
        uda.getNumero_shipment();
        uda.getNumero_shipment_selected();
        uda.setNumero_shipment_selected('1');
        
        uda.getlistado_supplierquoteline();
        
        
        uda.calculo_auto();
        uda.Recalcular();
        uda.Actualizar_lineas();
        
        uda.cancelar();
        uda.guardar_nuevos_deliverys();
        uda.byPass();
        
    }
    
    static testMethod void NEU_Supplier_Delivery_Schedule2()
    {
        
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

Customer_Quote__c importexportquote = new Customer_Quote__c();
String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
importexportquote.RecordTypeId = recordTypeId;
importexportquote.Name = '.';
importexportquote.Account_for__c = a.Id;
importexportquote.Team__c = 'P2G';
importexportquote.Quotation_Status__c = 'Quote being prepared';
importexportquote.Customer_Reference__c = 'hola soy una prueba';
importexportquote.Valid_From__c = System.today();
importexportquote.Valid_Until__c = System.today();
importexportquote.Comercio_Exterior__c = 'No';
importexportquote.Freight_Mode__c = 'Road';
importexportquote.Service_Mode__c = 'NATIONAL';
importexportquote.Service_Type__c = 'FTL';
importexportquote.CurrencyIsoCode = 'MXN';
importexportquote.ETD__c = Date.today();
importexportquote.ETA__c = Date.today();
importexportquote.Community_Status__c = 'CUSTOMER CREATED';
importexportquote.Pricing_Executive__c = userT.Id;
importexportquote.Operations_Exec__c = userT.Id;
insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
       
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000 );
        insert g;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Max_Shipment__c=10, Contract_Duration__c=10);
        insert supplierequest;
        
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id, Supplier_Request_RFP__c =supplierequest.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000, Supplier_Request_RFP__c =supplierequest.Id);
        insert sup_quote_lines;
        List<Quote_Item_Line__c > list_quote_item = new List<Quote_Item_Line__c >();
        Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id,Supplier_Quote__c=supquote.Id);
        list_quote_item.add(quote4);
         Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Item_Name__c= g.Id, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id, Supplier_Quote__c=supquote.Id);
        list_quote_item.add(quote);
        Shipment__c ship = new Shipment__c(Name='fgf',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        insert list_quote_item;
        
        NEU_Supplier_Delivery_Schedule uda = new NEU_Supplier_Delivery_Schedule(new ApexPages.StandardController( importexportquote ));
        uda.id_principal_check = quote.Id;
        uda.getcontainer_selected();
        uda.getcontainers();
        uda.setcontainer_selected(pallet_container.Id);
        uda.getNumero_shipment();
        uda.getNumero_shipment_selected();
        uda.setNumero_shipment_selected('1');
        
        uda.getlistado_supplierquoteline();
        
        List<SelectOption> select_options = new List<SelectOption>();
        select_options.add(new SelectOption('1','1'));
         List<NEU_Supplier_Delivery_Schedule.supplier_quote_line_s> atpd = new List<NEU_Supplier_Delivery_Schedule.supplier_quote_line_s>();
         
         
          atpd.add(new NEU_Supplier_Delivery_Schedule.supplier_quote_line_s(quote,g,true, 
        'test observaciones', 10, 10, 10, 10,
         10, 10, false, 
         '', select_options , '2',
          system.today(), quote.Id, quote.Id, 10 , false,
          sup_quote_lines, false, 10, 10, 10));
        
         uda.listado_supplierquoteline = atpd;
        uda.calculo_auto();
        uda.Recalcular();
        uda.Actualizar_lineas();
        
        uda.cancelar();
        
        
    }
    
     static testMethod void NEU_Supplier_Delivery_Schedule3()
    {
        
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

Customer_Quote__c importexportquote = new Customer_Quote__c();
String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
importexportquote.RecordTypeId = recordTypeId;
importexportquote.Name = '.';
importexportquote.Account_for__c = a.Id;
importexportquote.Team__c = 'P2G';
importexportquote.Quotation_Status__c = 'Quote being prepared';
importexportquote.Customer_Reference__c = 'hola soy una prueba';
importexportquote.Valid_From__c = System.today();
importexportquote.Valid_Until__c = System.today();
importexportquote.Comercio_Exterior__c = 'No';
importexportquote.Freight_Mode__c = 'Road';
importexportquote.Service_Mode__c = 'NATIONAL';
importexportquote.Service_Type__c = 'FTL';
importexportquote.CurrencyIsoCode = 'MXN';
importexportquote.ETD__c = Date.today();
importexportquote.ETA__c = Date.today();
importexportquote.Community_Status__c = 'CUSTOMER CREATED';
importexportquote.Pricing_Executive__c = userT.Id;
importexportquote.Operations_Exec__c = userT.Id;
insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
       
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000 );
        insert g;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Max_Shipment__c=10, Contract_Duration__c=10);
        insert supplierequest;
        
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id, Supplier_Request_RFP__c =supplierequest.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000, Supplier_Request_RFP__c =supplierequest.Id, Expense_Amount__c = 100);
        insert sup_quote_lines;
        List<Quote_Item_Line__c > list_quote_item = new List<Quote_Item_Line__c >();
        Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id,Supplier_Quote__c=supquote.Id);
        list_quote_item.add(quote4);
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Item_Name__c= g.Id, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id, Supplier_Quote__c=supquote.Id, Expense_Amount__c =100);
        list_quote_item.add(quote);
        Shipment__c ship = new Shipment__c(Name='fgf',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        insert list_quote_item;
        
        NEU_Supplier_Delivery_Schedule uda = new NEU_Supplier_Delivery_Schedule(new ApexPages.StandardController( importexportquote ));
        uda.splitQuoteLine(quote.Id, 1, system.Today(), '1', 'test observations',10,10);
        uda.splitSupQuoteLine(sup_quote_lines.Id, 10, system.today(), '1', 'test observations',10,10);
        
    }
    
     static testMethod void NEU_Supplier_Delivery_Schedule4()
    {
        
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

Customer_Quote__c importexportquote = new Customer_Quote__c();
String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
importexportquote.RecordTypeId = recordTypeId;
importexportquote.Name = '.';
importexportquote.Account_for__c = a.Id;
importexportquote.Team__c = 'P2G';
importexportquote.Quotation_Status__c = 'Quote being prepared';
importexportquote.Customer_Reference__c = 'hola soy una prueba';
importexportquote.Valid_From__c = System.today();
importexportquote.Valid_Until__c = System.today();
importexportquote.Comercio_Exterior__c = 'No';
importexportquote.Freight_Mode__c = 'Road';
importexportquote.Service_Mode__c = 'NATIONAL';
importexportquote.Service_Type__c = 'FTL';
importexportquote.CurrencyIsoCode = 'MXN';
importexportquote.ETD__c = Date.today();
importexportquote.ETA__c = Date.today();
importexportquote.Community_Status__c = 'CUSTOMER CREATED';
importexportquote.Pricing_Executive__c = userT.Id;
importexportquote.Operations_Exec__c = userT.Id;
importexportquote.Catalog_Price_List__c = b.id;

insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
       
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000 );
        insert g;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id, Max_Shipment__c=10);
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Max_Shipment__c=10,  Contract_Duration__c=10);
        insert supplierequest;
        
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id, Supplier_Request_RFP__c =supplierequest.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000, Supplier_Request_RFP__c =supplierequest.Id);
        insert sup_quote_lines;
        List<Quote_Item_Line__c > list_quote_item = new List<Quote_Item_Line__c >();
        Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id,Supplier_Quote__c=supquote.Id);
        list_quote_item.add(quote4);
         Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Item_Name__c= g.Id, Units__c=10, Supplier_Quote_Line__c=sup_quote_lines.Id, Supplier_Quote__c=supquote.Id);
        list_quote_item.add(quote);
        Shipment__c ship = new Shipment__c(Name='fgf',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        insert list_quote_item;
        NEU_Supplier_Delivery_Schedule uda = new NEU_Supplier_Delivery_Schedule(new ApexPages.StandardController( importexportquote ));
         List<SelectOption> select_options = new List<SelectOption>();
        select_options.add(new SelectOption('1','1'));
         List<NEU_Supplier_Delivery_Schedule.supplier_quote_line_s> atpd = new List<NEU_Supplier_Delivery_Schedule.supplier_quote_line_s>();
         
         
          atpd.add(new NEU_Supplier_Delivery_Schedule.supplier_quote_line_s(quote,g,true, 
        'test observaciones', 10, 10, 10, 10,
         10, 10, false, 
         '', select_options , '2',
          system.today(), quote.Id, quote.Id, 10 , false,
          sup_quote_lines, false, 10, 10, 10));
        
         uda.listado_supplierquoteline = atpd;
         uda.id_principal_check = quote.Id;
         
        uda.calculo_auto();
        
    }
    
    static testMethod void NEU_Supplier_Delivery_Schedule5()
    {
        
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup =list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

Customer_Quote__c importexportquote = new Customer_Quote__c();
String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
importexportquote.RecordTypeId = recordTypeId;
importexportquote.Name = '.';
importexportquote.Account_for__c = a.Id;
importexportquote.Team__c = 'P2G';
importexportquote.Quotation_Status__c = 'Quote being prepared';
importexportquote.Customer_Reference__c = 'hola soy una prueba';
importexportquote.Valid_From__c = System.today();
importexportquote.Valid_Until__c = System.today();
importexportquote.Comercio_Exterior__c = 'No';
importexportquote.Freight_Mode__c = 'Road';
importexportquote.Service_Mode__c = 'NATIONAL';
importexportquote.Service_Type__c = 'FTL';
importexportquote.CurrencyIsoCode = 'MXN';
importexportquote.ETD__c = Date.today();
importexportquote.ETA__c = Date.today();
importexportquote.Community_Status__c = 'CUSTOMER CREATED';
importexportquote.Pricing_Executive__c = userT.Id;
importexportquote.Operations_Exec__c = userT.Id;
importexportquote.Catalog_Price_List__c = b.id;
importexportquote.Only_Warehouse_Service__c = true;
insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
       
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000 );
        insert g;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id, Max_Shipment__c=10);
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Max_Shipment__c=10,  Contract_Duration__c=10);
        insert supplierequest;
        
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id, Supplier_Request_RFP__c =supplierequest.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000, Supplier_Request_RFP__c =supplierequest.Id);
        insert sup_quote_lines;
        List<Quote_Item_Line__c > list_quote_item = new List<Quote_Item_Line__c >();
        Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Units__c=10);
        list_quote_item.add(quote4);
         Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Item_Name__c= g.Id, Units__c=10);
        list_quote_item.add(quote);
        Shipment__c ship = new Shipment__c(Name='fgf',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        insert list_quote_item;
        NEU_Supplier_Delivery_Schedule uda = new NEU_Supplier_Delivery_Schedule(new ApexPages.StandardController( importexportquote ));
         List<SelectOption> select_options = new List<SelectOption>();
        select_options.add(new SelectOption('1','1'));
         List<NEU_Supplier_Delivery_Schedule.supplier_quote_line_s> atpd = new List<NEU_Supplier_Delivery_Schedule.supplier_quote_line_s>();
         
         
          atpd.add(new NEU_Supplier_Delivery_Schedule.supplier_quote_line_s(quote,g,true, 
        'test observaciones', 0, 10, 10, 10,
         10, 10, false, 
         '', select_options , '2',
          system.today(), quote.Id, quote.Id, 10 , false,
          sup_quote_lines, false, 10, 10, 10));
        
         uda.listado_supplierquoteline = atpd;
         uda.id_principal_check = quote.Id;
         
        uda.calculo_auto();
        
    }
    

}