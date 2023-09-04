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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Route__c =route.Id, Authorized_Credit__c = true, Quotation_Status__c ='Quote being prepared',  Service_Type__c = ship.Freight_Mode__c, Only_Warehouse_Service__c = ship.Only_Warehouse_Service__c);
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
    
    
    public static testMethod void NEU_Edit_Shipments_Program2_2()
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Route__c =route.Id, Authorized_Credit__c = true, Quotation_Status__c ='Quote being prepared',  Service_Type__c = ship.Freight_Mode__c, Only_Warehouse_Service__c = ship.Only_Warehouse_Service__c);
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
    }
    
    public static testMethod void NEU_Edit_Shipments_Program2_3()
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Route__c =route.Id, Authorized_Credit__c = true, Quotation_Status__c ='Quote being prepared',  Service_Type__c = ship.Freight_Mode__c, Only_Warehouse_Service__c = ship.Only_Warehouse_Service__c);
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
          
        uda.setFreight_Mode_id('Sea');
        uda.getFreight_Mode_id();
        List<SelectOption> accl=uda.getaccountList();
        uda.setLinesTypeNumber(1);
        uda.getLinesTypeNumber();      
        uda.setNotConsolidatedNumber(1);
         uda.setLinesTypeNumber(2);
        for(NEU_Edit_Shipments_Program.Line_s line: uda.getLines_update())
        {
                line.selected=true;
                line.selected2=true;
                line.check_full=true;
                break;
        }
          
        uda.orden_quotes='quote_line.Item_Name__r.Name-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Item_Supplier_Owner__r.Name-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.ETD__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Supplier_Quote_Line__r.Delivery_Date__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Import_Export_Quote__r.Account_for__r.Name-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Delivery_Date__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Delivery_Number__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Import_Export_Quote__r.Supplier_Account__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Name-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Import_Export_Quote__r.Name-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Units__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Price__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Amount__c-asc';
        uda.go_compare();
        uda.orden_quotes='quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name-asc';
        uda.go_compare();
        uda.getcontainers();
        uda.getcontainer_selected();
        uda.setcontainer_selected(null);
        uda.applyLines();
        uda.splitQuoteLine(quote.Id,3);
        uda.getList_import_export_supplier_order();
          
        NEU_Edit_Shipments_Program.Import_Export_Supplier_Order_s ieso = new NEU_Edit_Shipments_Program.Import_Export_Supplier_Order_s(importexportquote, true, uda);
        ieso.getnumero_dias2();
        uda.orden_cabeceras = 'numero_dias';
        uda.actualizar_import_export_supplier_order();
        //uda.applyLines2(1);
    }
    
    public static testMethod void NEU_Edit_Shipments_Program3()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

       Shipment_Program__c ship_program = new Shipment_Program__c(Last_Container_Load__c =10, Destination_Address__c='tst', Number_of_Containers__c=10, Number_of_Packages__c=10, Number_of_Pallets__c=10, Total_Gross_Volume_m3__c=10, Total_Gross_Weight_Kg__c=10);
       insert ship_program;
       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
       Account a = list_accounts[0];
       insert a;
       Account sup = list_accounts[1];
       insert sup;
       Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
       insert supplyproject;
       Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
       insert suprequest;
       Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
       insert ship;
       Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
       insert c;
       Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
       insert d;
       Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
       insert g;

       Supplier_Quote__c supquote = new Supplier_Quote__c( Customer__c = a.Id, Supplier__c = sup.Id,Supply_Project__c= supplyproject.Id,Supplier_Quote_Status__c='Approved');
       insert supquote;
       Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000);
       insert sup_quote_lines;
       Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id, Supplier_Quote_Line__c = sup_quote_lines.Id , Supplier_Quote__c=supquote.Id );
       insert shipline;
       sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000);
       insert sup_quote_lines;
       shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id, Supplier_Quote_Line__c = sup_quote_lines.Id , Supplier_Quote__c=supquote.Id );
       insert shipline;
        
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
       uda.setLinesTypeNumber(3);      
       List<SelectOption> accl=uda.getaccountList();
       uda.setrouteid(route.id);
       uda.getLines();
       uda.setrouteid(null);
       uda.setNotConsolidatedNumber(1);
       accl=uda.getaccountList();
       uda.setaccountid(new Set<string>{a.ID});
       uda.getaccountid();
       uda.getaccountName();
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
      
       for(NEU_Edit_Shipments_Program.Line_s line: uda.getLines_update())
       {
            line.getId();
            line.selected=true;
            line.selected2=true;
            line.check_full=true;
            line.shipment_line.Units_Shipped__c=1;
       }

       uda.orden_quotes='total_pallet_linea-asc';
       uda.go_compare();
       uda.orden_quotes='total_volumen_linea-asc';
       uda.go_compare();
       uda.orden_quotes='total_peso_linea-asc';
       uda.go_compare();
       uda.orden_quotes='extension-asc';
       uda.go_compare();
       uda.orden_quotes='totalcajas-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Delivery_Date__c-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Delivery_Number__c-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Name-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Supplier_Quote__r.Name-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Quantity__c-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Item__r.Name-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Supplier_Quote__r.Supplier__r.Name-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Supplier_Quote__r.Customer__r.Name-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Total_Amount__c-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Net_Amount__c-asc';
       uda.go_compare();
       uda.orden_quotes='supplier_line.Supplier_Quote__r.Supply_Project__r.Name-asc';
       uda.go_compare();
       uda.orden_quotes='shipment_line.Shipment__r.Name-asc';
       uda.go_compare_update();
       uda.orden_quotes='shipment_line.Name-shipment_line.Unit_Origin_Sell_Price__c-asc';
       uda.go_compare_update();
       uda.orden_quotes='shipment_line.Unit_Origin_Sell_Price__c-asc';
       uda.go_compare_update();
       uda.orden_quotes='shipment_line.Shipment__r.Supply_Project__r.Name-asc';
       uda.go_compare_update();
       uda.orden_quotes='shipment_line.Sell_Origin_Amount__c-asc';
       uda.go_compare_update();
       //uda.applyLines();
       uda.getShowLines();
       uda.getShowShoppingCartLines();
       uda.getShowShoppingCartLines_update();
       uda.getShowImportExportItemLines();
       uda.getShowImportExportItemLines_update();
       uda.getShowSupplierQuoteLines();
       uda.getShowSupplierQuoteLines_update();
       uda.getShowConsolidated();
       uda.getcontainers();
       uda.getcontainer_selected();
       uda.setcontainer_selected(null);
       uda.getrouteid();
       uda.setrouteid(null);
       uda.getnotAuthorizedNumber();
       uda.setnotAuthorizedNumber(false);
       uda.getNotConsolidatedNumber();
       uda.getfiltro_fecha();
       uda.cambio_de_fecha();
       uda.setNotConsolidatedNumber(1);
       uda.splitSupQuoteLine(sup_quote_lines.Id, 10);
      
     }
     
     /*public static testMethod void NEU_Edit_Shipments_Program4()
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_program.Id, Service_Type__c='FTL', Only_Warehouse_Service__c = true);
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Route__c =route.Id, Authorized_Credit__c = true, Quotation_Status__c ='Quote being prepared',  Service_Type__c = ship.Freight_Mode__c, Only_Warehouse_Service__c = ship.Only_Warehouse_Service__c);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
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
        
        importexportquote.Quotation_Status__c ='Approved as Succesful';
        update importexportquote;
        
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id, Quote_Item_Line__c = quote.Id ,   Import_Export_Quote__c=importexportquote.Id );
        insert shipline;
        quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id, Quote_Item_Line__c = quote.Id ,   Import_Export_Quote__c=importexportquote.Id, Units_Shipped__c = 0 );
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
          
        uda.setFreight_Mode_id('Sea');
        uda.getFreight_Mode_id();
        List<SelectOption> accl=uda.getaccountList();
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
                line.unidades_iniciales = '10';
                break;
          }
          //uda.applyLines2(1);
          for(NEU_Edit_Shipments_Program.Line_s line: uda.getLines_update())
          {
                line.selected=true;
                line.selected2=true;
                line.check_full=true;
                line.unidades_iniciales = '10';
                break;
          }
          uda.applyLines2(1);
          
          uda.orden_quotes='quote_line.Item_Name__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Item_Supplier_Owner__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.ETD__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Supplier_Quote_Line__r.Delivery_Date__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Import_Export_Quote__r.Account_for__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Delivery_Date__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Delivery_Number__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Import_Export_Quote__r.Supplier_Account__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Name-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Import_Export_Quote__r.Name-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Units__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Price__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Amount__c-asc';
          uda.go_compare();
          uda.orden_quotes='quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name-asc';
          uda.go_compare();
          uda.getcontainers();
          uda.getcontainer_selected();
          uda.setcontainer_selected(null);
          uda.applyLines();
          uda.splitQuoteLine(quote.Id,3);
          uda.getList_import_export_supplier_order();
          
          NEU_Edit_Shipments_Program.Import_Export_Supplier_Order_s ieso = new NEU_Edit_Shipments_Program.Import_Export_Supplier_Order_s(importexportquote, true, uda);
          ieso.getnumero_dias2();
          uda.orden_cabeceras = 'numero_dias';
          uda.actualizar_import_export_supplier_order();
          uda.applyLines2(1);
    }*/
}