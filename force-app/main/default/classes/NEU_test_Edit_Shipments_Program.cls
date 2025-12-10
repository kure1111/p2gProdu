@isTest
private class NEU_test_Edit_Shipments_Program
{

     public static testMethod void NEU_Edit_Shipments_Program()
     {
         NEU_StaticVariableHelper.setBoolean1(true);

        Shipment_Program__c ship_program = new Shipment_Program__c(Last_Container_Load__c =10, Destination_Address__c='tst', Number_of_Containers__c=10, Number_of_Packages__c=10, Number_of_Pallets__c=10, Total_Gross_Volume_m3__c=10, Total_Gross_Weight_Kg__c=10);
        insert ship_program;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Account sup = list_accounts[2];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
        insert suprequest;
        Shipment__c ship = new Shipment__c(Name='das',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
        insert ship;
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
      
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Pallet_Container_Type__c pallet_container2 = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container2;

        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id,Status__c='Close',Authorized_Credit__c=true);
        insert shop;
        Shopping_Cart_line__c shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = g.Id, Units__c=10, Consolidated__c = false,  Supplier__c = sup.Id);
        insert shoplines;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id,   Customer_Order_Line__c = shoplines.Id ,     Customer_Order__c=shop.Id );
        insert shipline;
        shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = g.Id, Units__c=10, Consolidated__c = false,  Supplier__c = sup.Id);
        insert shoplines;
        shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id,   Customer_Order_Line__c = shoplines.Id ,     Customer_Order__c=shop.Id );
        insert shipline;

        shop = new Shopping_Cart__c(Customer__c=b.Id,Status__c='Close',Authorized_Credit__c=true);
        insert shop;
        shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = g.Id, Units__c=10, Consolidated__c = false,  Supplier__c = sup.Id);
        insert shoplines;


          NEU_Edit_Shipments_Program uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
          ship_program.Pallet_Container_Type__c=pallet_container.Id;
          ship_program.Type_of_Lines__c=null; 
          uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
          ship_program.Type_of_Lines__c='Customer Order Lines';
          uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
          ship_program.Type_of_Lines__c='Supplier Quote Lines';
          ship_program.Freight_Mode__c='Road'; 
          ship_program.Route__c=route.id; 
          uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
          ship_program.Type_of_Lines__c='Quote Item Lines';
          uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
          
          uda.ordenacion_quotes=uda.ordenacion_quotes;
          uda.TotalNumberBoxes=uda.TotalNumberBoxes;
          uda.TotalNumberPallets=uda.TotalNumberPallets;
          uda.Grossweight=uda.Grossweight;
          uda.Cube=uda.Cube;
          uda.TotalNumberCont=uda.TotalNumberCont;
          uda.FreeSpaceCont=uda.FreeSpaceCont;
          uda.porc_ocupacion=uda.porc_ocupacion;
          uda.total_pallet_linea=uda.total_pallet_linea;
          uda.max_peso_container=uda.max_peso_container;
          uda.max_volumen_container=uda.max_volumen_container;
          uda.num_cont_x_pallet=uda.num_cont_x_pallet;
          uda.la_lista_no_cero=uda.la_lista_no_cero;
          uda.decimalSep=uda.decimalSep;
          uda.thousandSep=uda.thousandSep;
          
          uda.setFreight_Mode_id('Sea');
          uda.getFreight_Mode_id();
          List<SelectOption> accl=uda.getaccountList();
          uda.setLinesTypeNumber(1);
          uda.getLinesTypeNumber();      
          uda.setrouteid(route.id);
          accl=uda.getaccountList();
          Set<String> lista_ids_cuentas = new Set<String>();
          lista_ids_cuentas.add(a.ID);
          uda.setaccountid(lista_ids_cuentas); 
          uda.getaccountid();
          uda.getaccountName();
          uda.getLines_update();
          
          for(NEU_Edit_Shipments_Program.Line_s line:uda.getLines())
          {
                line.getintegersupply();
                line.getFinalUnits();
                line.getFinalStock();
                line.getId();
                line.getHeaderId();
                line.getItemId();
                line.getItemType();
                line.getSupplierId();
                line.getItemName();
                line.getFamilyName();
                line.selected=true;
                line.selected2=true;
                line.check_full=true;
                break;
          }
          
          for(NEU_Edit_Shipments_Program.Line_s line: uda.getLines_update())
          {
                line.selected=true;
                line.selected2=true;
                line.check_full=true;
                break;
          }
          
          uda.orden_quotes='shopping_line.Item_Name__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Supplier__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Shopping_Cart__r.Customer__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Shopping_Cart__r.Delivery_Date__c-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Name-shopping_line.Shopping_Cart__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Shopping_Cart__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Units__c-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Units__c-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Amount__c-asc';
          uda.go_compare();
          uda.orden_quotes='shopping_line.Net_Price__c-asc';
          uda.go_compare();
    
    
          uda.getcontainers();
          uda.getcontainer_selected();
          uda.setcontainer_selected(null);
          uda.applyLines();
          uda.splitShoppingCartLine(shoplines.Id,3);
          uda.actualizar_import_export_supplier_order();
          uda.actualizar_import_export_supplier_order_put_null();
      
    }
    
    public static testMethod void NEU_Edit_Shipments_Program2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        Shipment_Program__c ship_program = new Shipment_Program__c(Last_Container_Load__c =10, Destination_Address__c='tst', Number_of_Containers__c=10, Number_of_Packages__c=10, Number_of_Pallets__c=10, Total_Gross_Volume_m3__c=10, Total_Gross_Weight_Kg__c=10);
        insert ship_program;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account b = list_accounts[1];
        insert b;
        Account sup = list_accounts[2]; 
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
        insert suprequest;
        Shipment__c ship = new Shipment__c(Name='das',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
        insert ship;
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
      
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Pallet_Container_Type__c pallet_container2 = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container2;
		

        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Route__c =route.Id, Authorized_Credit__c = true, Quotation_Status__c ='Approved as Succesful');
        User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional


        Customer_Quote__c importexportquote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name = '.';
        importexportquote.Consignee__c = a.Id;
        importexportquote.Supplier_Account__c = sup.Id;
        importexportquote.Route__c =route.Id;
        importexportquote.Only_Warehouse_Service__c = ship.Only_Warehouse_Service__c;
        importexportquote.Service_Type__c = ship.Freight_Mode__c;
        importexportquote.Authorized_Credit__c = true;
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
        List<Quote_Item_Line__c > query_quote_item = new List<Quote_Item_Line__c >();
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        query_quote_item.add(quote);
        quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        query_quote_item.add(quote);
        insert query_quote_item;
        
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
        
        importexportquote.Quotation_Status__c ='Approved as Succesful';
        update importexportquote;
        
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id, Quote_Item_Line__c = quote.Id ,   Import_Export_Quote__c=importexportquote.Id );
        insert shipline;
        
        shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id, Quote_Item_Line__c = quote.Id ,   Import_Export_Quote__c=importexportquote.Id );
        insert shipline;
        Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c(Shipments_Program__c = ship_program.Id, Import_Export_Quote__c = importexportquote.Id, Shipment__c = ship.Id);
        insert new_shipment_consolidation_data;

		ship_program.Freight_Mode__c = 'Sea';
        NEU_Edit_Shipments_Program uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
        ship_program.Pallet_Container_Type__c=pallet_container.Id;
        ship_program.Type_of_Lines__c=null;
        uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
        ship_program.Type_of_Lines__c='Customer Order Lines';
        uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
        ship_program.Type_of_Lines__c='Supplier Quote Lines';
        ship_program.Freight_Mode__c='Road'; 
        ship_program.Route__c=route.id; 
        uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
        ship_program.Type_of_Lines__c='Quote Item Lines';
        uda = new NEU_Edit_Shipments_Program(new ApexPages.StandardController( ship_program ));
          
        uda.ordenacion_quotes=uda.ordenacion_quotes;
        uda.TotalNumberBoxes=uda.TotalNumberBoxes;
        uda.TotalNumberPallets=uda.TotalNumberPallets;
        uda.Grossweight=uda.Grossweight;
        uda.Cube=uda.Cube;
        uda.TotalNumberCont=uda.TotalNumberCont;
        uda.FreeSpaceCont=uda.FreeSpaceCont;
        uda.porc_ocupacion=uda.porc_ocupacion;
        uda.total_pallet_linea=uda.total_pallet_linea;
        uda.max_peso_container=uda.max_peso_container;
        uda.max_volumen_container=uda.max_volumen_container;
        uda.num_cont_x_pallet=uda.num_cont_x_pallet;
        uda.la_lista_no_cero=uda.la_lista_no_cero;
        uda.decimalSep=uda.decimalSep;
        uda.thousandSep=uda.thousandSep;
        uda.byPass();
        uda.byPass2();
        uda.byPass3();
        uda.setFreight_Mode_id('Sea');
        uda.getFreight_Mode_id();
        List<SelectOption> accl=uda.getaccountList();
        uda.setLinesTypeNumber(1);
        uda.getLinesTypeNumber();      
        uda.setNotConsolidatedNumber(1);
        uda.setrouteid(route.id);
        accl=uda.getaccountList();
        uda.setaccountid(new Set<string>{a.ID});
        uda.getaccountid();
        uda.getaccountName();
        uda.getLines_update();
        uda.setLinesTypeNumber(2);      
        uda.setnotAuthorizedNumber(false);
        uda.setNotConsolidatedNumber(1);
        accl=uda.getaccountList();
        uda.setrouteid(route.id);
        uda.getList_import_export_supplier_order();
        uda.cambio_de_fecha();
        uda.getLines();
        accl=uda.getaccountList();
        uda.setrouteid(null);
        accl=uda.getaccountList();
        uda.setaccountid(new Set<string>{a.ID});
        uda.getaccountid();
        uda.getaccountName();
        uda.getLines_update();
        uda.getList_import_export_supplier_order();
        uda.cambio_de_fecha();
        uda.setLinesTypeNumber(2);
        for(NEU_Edit_Shipments_Program.Line_s line: uda.getLines())
        {
                line.getintegersupply();
                line.getFinalUnits();
                line.getFinalStock();
                line.getId();
                line.getHeaderId();
                line.getItemId();
                line.getItemType();
                line.getSupplierId();
                line.getItemName();
                line.getFamilyName();
                line.selected=true;
                line.selected2=true;
                line.check_full=true;
                break;
        }
        //uda.applyLines2(1);
        uda.setLinesTypeNumber(2);
        for(NEU_Edit_Shipments_Program.Line_s line: uda.getLines_update())
        {
                line.selected=true;
                line.selected2=true;
                line.check_full=true;
                break;
        }
        //uda.applyLines2(1);
          
       
    }
    
    

    
}