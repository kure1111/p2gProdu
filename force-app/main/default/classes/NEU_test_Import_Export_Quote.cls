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
private class NEU_test_Import_Export_Quote {

  static testMethod void test_NEU_MD_GenerateShipment() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        
        NEU_MD_GenerateShipment uda = new NEU_MD_GenerateShipment(new ApexPages.StandardController( importexportquote ));
        uda.generate_shipment(); 
   
     }
     
     static testMethod void test_NEU_Aditional_Discounts() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Discount_Rule__c discount_rule = new Discount_Rule__c(Name='test', Enabled__c = true);
        insert discount_rule;
        NEU_Aditional_Discounts uda = new NEU_Aditional_Discounts(new ApexPages.StandardController( importexportquote ));
        string decimalsep = uda.decimalSep;
        string thousandsep = uda.thousandSep;
        
        List<NEU_Aditional_Discounts.Import_Export_Discount_Line_s> listadiscount = uda.lines;
        uda.apply_lines();
        uda.return_quote();
     }
     
     static testMethod void test_NEU_Generate_Supplier_Orders() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000, Units_x_Master_Box__c=10 );
        insert g;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Units__c=1000, Expense_Amount__c = 100, Item_Supplier_Owner__c = sup.Id);
        insert quote;
        NEU_Generate_Supplier_Orders  gso = new NEU_Generate_Supplier_Orders(new ApexPages.StandardController( importexportquote ));
        gso.generate();
     }
     
     static testMethod void test_NEU_Order_Confirmation_IE_details_pdf() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        ApexPages.currentPage().getParameters().put('services_charges', 'true');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a =list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Per Kg', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Concept_1_Sell_Price__c =10, Concept_2_Sell_Price__c = 10, Concept_3_Sell_Price__c =10, Concept_4_Sell_Price__c = 10, Concept_5_Sell_Price__c =10);
        insert quote_fee;
        NEU_Order_Confirmation_IE_details_pdf  ocid = new NEU_Order_Confirmation_IE_details_pdf(new ApexPages.StandardController( importexportquote ));
     }
     
     static testMethod void test_NEU_Order_Confirmation_IE_pdf() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        ApexPages.currentPage().getParameters().put('services_charges', 'true');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account sup =list_accounts[1];
        insert sup;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Per Kg', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Concept_1_Sell_Price__c =10, Concept_2_Sell_Price__c = 10, Concept_3_Sell_Price__c =10, Concept_4_Sell_Price__c = 10, Concept_5_Sell_Price__c =10);
        insert quote_fee;
        NEU_Order_Confirmation_IE_pdf  ocid = new NEU_Order_Confirmation_IE_pdf(new ApexPages.StandardController( importexportquote ));
     }
     
     static testMethod void test_NEU_IE_Notifications_PDF() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Per Kg', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Concept_1_Sell_Price__c =10, Concept_2_Sell_Price__c = 10, Concept_3_Sell_Price__c =10, Concept_4_Sell_Price__c = 10, Concept_5_Sell_Price__c =10);
        insert quote_fee;
        NEU_IE_Notifications_PDF  ie_notification = new NEU_IE_Notifications_PDF(new ApexPages.StandardController( importexportquote ));
        ie_notification.load_template();
        ie_notification.load_template_booking_english();
        ie_notification.load_template_booking_spanish();
     }
     
     static testMethod void test_NEU_IE_Notifications_save_PDF() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,'); 
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        NEU_IE_Notifications_save_PDF  ie_notification = new NEU_IE_Notifications_save_PDF(new ApexPages.StandardController( importexportquote ));
        ie_notification.crear();
     }
     
      static testMethod void test_NEU_IE_Comparison_PDF() {
        NEU_StaticVariableHelper.setBoolean1(true);
	
	
		
		Account shipper_test = new Account();
		shipper_test.Name = 'Account Test'; 
		shipper_test.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		shipper_test.Business_Area__c = 'Auto-Parts';
		insert shipper_test;
		
		Account customer_test = new Account();
		customer_test.Name = 'Account Test'; 
		customer_test.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		customer_test.Business_Area__c = 'Auto-Parts';
		insert customer_test;
		
		Contact contact_test = new Contact();
		contact_test.AccountId = shipper_test.Id;
		contact_test.LastName = 'Contact Test';
		insert contact_test;
		
		Product_Family__c product_family_test1 = new Product_Family__c();
		product_family_test1.Name = 'Product Family Test';
		product_family_test1.Business_Area__c = 'Auto-Parts';
		insert product_family_test1;
		
		Product_Family__c product_family_test2 = new Product_Family__c();
		product_family_test2.Name = 'Product Family Test';
		product_family_test2.Business_Area__c = 'Auto-Parts';
		insert product_family_test2;
		
		Price_List__c price_list_test = new Price_List__c();
		price_list_test.Name = 'Price List Test';
		price_list_test.Business_Area__c = 'Auto-Parts'; 
		price_list_test.Family__c = product_family_test1.Id;
		price_list_test.Items_Account_Owner__c = customer_test.Id;
		insert price_list_test;
		
		Country__c country_test = new Country__c();
		country_test.Name = 'Country Test';
		country_test.ISO_Code__c = 'EUR';
		insert country_test;
		
		Location__c location_test = new Location__c();
		location_test.Name = 'Location Test'; 
		location_test.City__c = 'City Test';
		location_test.Country__c = country_test.Id;
		location_test.Subdivision__c = 'Subdivison Test'; 
		location_test.UNLOCODE__c = 'ABC';
		insert location_test;
		
		Customer_Quote__c import_export_test = new Customer_Quote__c(); 
		import_export_test.Catalog_Price_List__c = price_list_test.id; 
		import_export_test.Account_for__c = customer_test.Id;
		import_export_test.Contact__c = contact_test.Id; 
		import_export_test.Service_Type__c = 'LCL Cargo';
		import_export_test.Move_Type__c = 'Door to Door';
		import_export_test.Origin_Address__c = 'Address Test'; 
		import_export_test.Country_ofLoad__c = country_test.Id; 
		import_export_test.Site_of_Load__c = location_test.Id;
		import_export_test.Country_ofDischarge__c = country_test.Id;
		import_export_test.Site_of_Discharge__c = location_test.Id; 
		import_export_test.Destination_Address__c = 'Address Test'; 
		import_export_test.Supplier_Account__c = shipper_test.Id; 
		import_export_test.Freight_Mode__c = 'Air';
		import_export_test.Service_Mode__c = 'Import'; 
		import_export_test.Only_Warehouse_Service__c = true;
		insert import_export_test;
		
		Fee__c fee_test = new Fee__c();
		fee_test.Name = 'Fee Test';
		fee_test.Fee_Category__c = 'Disbursement'; 
		fee_test.Rate_Type__c = 'Fixed';
		fee_test.Account_for__c = shipper_test.Id;
		insert fee_test;
		
		Import_Export_Fee_Line__c fee_line_test = new Import_Export_Fee_Line__c();
		fee_line_test.Import_Export_Quote__c = import_export_test.id;
		fee_line_test.Name = '001';
		fee_line_test.Service_Rate_Name__c = fee_test.Id; 
		fee_line_test.Extension_Service_Name__c = 'Extension Service Name Test'; 
		fee_line_test.Discount__c = 10;
		fee_line_test.Quote_Buy_Price__c = 10; 
		fee_line_test.Quote_Sell_Price__c = 10;
		fee_line_test.Units__c = 10;
		insert fee_line_test;
		
		NEU_IE_Comparison_PDF ie_comparison_pdf = new NEU_IE_Comparison_PDF(new ApexPages.StandardController(import_export_test));
     }
     
     static testMethod void test_NEU_IE_Route_Shipments_map() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,'); 
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import',Port_of_Transshipment_3__c='test transshipment 3', Port_of_Transshipment_2__c='test transshipment 2',Port_of_Transshipment_1__c='test transshipment 1', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Consolidation_Data__c ship_conso_data = new Shipment_Consolidation_Data__c(Name='test', Shipment__c = ship.Id , Import_Export_Quote__c = importexportquote.Id);
        insert ship_conso_data;
        NEU_IE_Route_Shipments_map  ie_route_ship_map = new NEU_IE_Route_Shipments_map(new ApexPages.StandardController( importexportquote ));
     }
     /*
     public static testMethod void test_NEU_Generate_Shipments() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Units__c = 10);
        insert quote;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        NEU_Generate_Shipments  gs = new NEU_Generate_Shipments(new ApexPages.StandardController( importexportquote ));

         
        gs.decimalSep = gs.decimalSep;
        gs.thousandSep = gs.thousandSep;
        gs.filter_shipment = gs.filter_shipment;
        gs.filter_program = gs.filter_program;
        gs.filter_vessel = gs.filter_vessel;
        gs.getcontainers();
        gs.new_route();
        gs.search_routes();
        gs.getrouteid();
        gs.setrouteid(route.Id);
        gs.actualizar_table_route();
        gs.new_filter_route.Country_of_Load__c= Country.Id;
        gs.new_filter_route.Country_of_Discharge__c= Country.Id;
        gs.getlist_route();
        gs.getnumero_dias2();
        gs.getShowLines();
        gs.getShowImportExportItemLines();
        gs.getLines();
        gs.orden_quotes  = 'total_pallet_linea-asc';
        gs.go_compare();
         gs.direccion_selected = gs.direccion_selected;
         gs.direccion_selected_destination = gs.direccion_selected_destination;
         gs.alertuser=gs.alertuser;
         gs.TotalNumberBoxes = gs.TotalNumberBoxes;
         gs.TotalNumberPallets=gs.TotalNumberPallets;
         gs.Grossweight = gs.Grossweight;
         gs.Cube=gs.Cube;
         gs.FreeSpaceCont=gs.FreeSpaceCont;
         gs.porc_ocupacion=gs.porc_ocupacion;
         gs.total_pallet_linea=gs.total_pallet_linea;
         gs.container_selected=gs.container_selected;
         gs.currency_cuenta=gs.currency_cuenta;
         gs.linea_modificada=gs.linea_modificada;
         gs.max_peso_container=gs.max_peso_container;
         gs.max_volumen_container=gs.max_volumen_container;
         gs.num_cont_x_pallet=gs.num_cont_x_pallet;
         gs.la_lista_no_cero=gs.la_lista_no_cero;
         gs.searchDestinationAddress=gs.searchDestinationAddress;
         gs.searchOriginAddress=gs.searchOriginAddress;
        for(NEU_Generate_Shipments.Line_s l : gs.getLines())
            l.selected = true;
        gs.applyLines();
        gs.splitQuoteLine(quote.Id,1);
         gs.check_shipment_created();
         gs.shipment_truckstop.Freight_MOde__c = 'Road';
         gs.createTrackingTruckstop();

        NEU_Generate_Shipments.Line_s lines_obj = new NEU_Generate_Shipments.Line_s(quote, true, '', 10, quote.Id, 10, 10, 10, false,'', 10, 10, 10, false);
        NEU_Generate_Shipments.Line_s lines_obj2 = new NEU_Generate_Shipments.Line_s(quote, true, '', 8, quote.Id, 8, 8, 8, false,'', 8, 8, 8, false);
        lines_obj.getintegersupply();
        lines_obj.getFinalUnits();
        lines_obj.getFinalStock();
        lines_obj.getId();
        lines_obj.getHeaderId();
        lines_obj.getItemId();
        lines_obj.getItemType();
        lines_obj.getSupplierId();
        lines_obj.getItemName();
        lines_obj.getFamilyName();
        lines_obj.campo_compare='total_pallet_linea';
        lines_obj.orden_de_comparacion='asc';
        lines_obj.compareTo(lines_obj);
        
        lines_obj.campo_compare='total_pallet_linea';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='total_volumen_linea';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='total_peso_linea';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='extension';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='totalcajas';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Item_Name__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Item_Supplier_Owner__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Account_for__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Delivery_Date__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Delivery_Number__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Supplier_Account__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Units__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Price__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.ETD__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Supplier_Quote_Line__r.Delivery_Date__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Amount__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        
     }
     */
     static testMethod void test_NEU_Track_Trace_IE() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');
        insert importexportquote;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Consolidation_Data__c ship_conso_data = new Shipment_Consolidation_Data__c(Name='test', Shipment__c = ship.Id , Import_Export_Quote__c = importexportquote.Id);
        insert ship_conso_data;
        NEU_Track_Trace_IE  ttie = new NEU_Track_Trace_IE(new ApexPages.StandardController( importexportquote ));
        
     }
     
     public static testMethod void test_NEU_OM_CreateItemsLines() {//ok
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c  importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c = 2, Total_Shipping_Weight_Kgs__c = 8, Total_Shipping_Volume_m3__c = 8);
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Per Kg', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote_fee;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_CreateItemsLines gpcc=new NEU_OM_CreateItemsLines(new ApexPages.StandardController( importexportquote ));
        system.debug( 'Prueba realizada' );
        gpcc.nuevo_item = quote;
        gpcc.crearlineaquoteitem();
        gpcc.getquoteItemLines();
        string decimalsep = gpcc.decimalSep;
        string thousandsep = gpcc.thousandSep;
        
        
        gpcc.update_lineas_ie();
    }
    
     public static testMethod void test_NEU_Calculate_Margin_at_Destination() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c=a.Id);
        insert b;
        Customer_Quote__c  importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Margin_at_Destination__c = 10);
        insert quote;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_Calculate_Margin_at_Destination cmad=new NEU_Calculate_Margin_at_Destination(new ApexPages.StandardController( importexportquote ));
        cmad.decimalSep=cmad.decimalSep;
        cmad.thousandSep=cmad.thousandSep;
        cmad.margin_general=cmad.margin_general;
        List<NEU_Calculate_Margin_at_Destination.Line_s> listado_lineas_new = new List<NEU_Calculate_Margin_at_Destination.Line_s>();
        listado_lineas_new.add(new NEU_Calculate_Margin_at_Destination.Line_s(quote,10,10,10,10,10,'MXN',10));
         listado_lineas_new.add(new NEU_Calculate_Margin_at_Destination.Line_s(quote,11,11,11,11,11,'MXN',11));
       // cmad.Lines = listado_lineas_new;
        
        cmad.getShowImportExportItemLines();
        cmad.getLines();
        cmad.save_margin();
        cmad.orden_quotes = 'totalsellamount-asc';
        cmad.go_compare();
        
        NEU_Calculate_Margin_at_Destination.Line_s nueva_clase = new NEU_Calculate_Margin_at_Destination.Line_s(quote,10,10,10,10,10,'MXN',10);
        nueva_clase.getId();
        nueva_clase.orden_de_comparacion = 'asc';
        nueva_clase.campo_compare = 'totalsellamount';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'precio_margin';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'unitoriginprice';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Units__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Import_Export_Quote__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Number__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Date__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Item_Name__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]); 
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Extension_Item_Name__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Import_Export_Quote__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Number__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Date__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Item_Name__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Extension_Item_Name__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
    }
    
     public static testMethod void testNEU_OM_FollowersImportExport() {//ok
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
         Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        NEU_OM_FollowersImportExport uda = new NEU_OM_FollowersImportExport(new ApexPages.StandardController( importexportquote ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
    }
    
    public static testMethod void test_NEU_Split_Quotation() {
    	
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id,Units__c=1);
        insert quote2;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Total_Shipping_Weight_Kgs__c=1, Total_Shipping_Volume_m3__c=1);
        insert quote;
        quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items2', Total_Shipping_Weight_Kgs__c=2, Total_Shipping_Volume_m3__c=2);
        insert quote;
        
        importexportquote=[select Id,Name,Total_Weight_Kg2__c,Total_Volume_m3_2__c from Customer_Quote__c where Id=:importexportquote.Id];
        NEU_Split_Quotation  ib = new NEU_Split_Quotation (new ApexPages.StandardController(importexportquote));
        ib.getShowImportExportItemLines();
        ib.margin_general=ib.margin_general;
        ib.compareField='selected';
        ib.sorting();
        ib.compareField='Name';
        ib.sorting();
        ib.cancel();
        ib.generate();
        ib.getLines()[0].selected=true;
        ib.generate();
    }
    
     public static testMethod void testNEU_OM_FollowersImportExport2() {//ok
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
         Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        NEU_OM_FollowersImportExport uda = new NEU_OM_FollowersImportExport(new ApexPages.StandardController( importexportquote ));
        List<NEU_OM_FollowersImportExport.follower_s> lista_de_followers = new List<NEU_OM_FollowersImportExport.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersImportExport.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersImportExport.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersImportExport.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersImportExport.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersImportExport.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
    }
    
    public static testMethod void test_NEU_Import_Export_Quote_pdf() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
		
		List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c(); 
        importexportquote.Account_for__c = account_test.Id;
        importexportquote.Freight_Mode__c = 'Air';
        importexportquote.Service_Mode__c = 'Import'; 
        importexportquote.Service_Type__c = 'LCL Cargo';
        importexportquote.Move_Type__c = 'Door to Door';
        importexportquote.Origin_Address__c = 'Address Test'; 
        importexportquote.Destination_Address__c = 'Address Test';
        insert importexportquote;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Sercie Rate Test';
		service_rate.Fee_Category__c = 'Disbursement';
		service_rate.Rate_Type__c = 'Per Kg';
		service_rate.Account_for__c = account_test.Id;
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
    		
        NEU_Import_Export_Quote_pdf_ES uda = new NEU_Import_Export_Quote_pdf_ES(new ApexPages.StandardController( importexportquote ));
        NEU_Import_Export_Quote_pdf ieqpdf = new NEU_Import_Export_Quote_pdf(new ApexPages.StandardController( importexportquote ));
    }
    
    static testMethod void NEU_Supplier_Delivery_Schedule()
    {
        /*
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Max_Deliveries__c = 10, Only_Warehouse_Service__c = true);
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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
        */
    }
    
    static testMethod void NEU_Supplier_Delivery_Schedule2()
    {
        /*
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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
        */
        
    }
    
     static testMethod void NEU_Supplier_Delivery_Schedule3()
    {
        /*
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        insert list_quote_item;
        
        NEU_Supplier_Delivery_Schedule uda = new NEU_Supplier_Delivery_Schedule(new ApexPages.StandardController( importexportquote ));
        uda.splitQuoteLine(quote.Id, 1, system.Today(), '1', 'test observations',10,10);
        uda.splitSupQuoteLine(sup_quote_lines.Id, 10, system.today(), '1', 'test observations',10,10);
        */
    }
    
     static testMethod void NEU_Supplier_Delivery_Schedule4()
    {
        /*
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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
        */
    }
    
    static testMethod void NEU_Supplier_Delivery_Schedule5()
    {
        /*
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup =list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
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
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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
        */
    }
    
    static testMethod void NEU_Standard_Fee_Calculation_Imp_Exp()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1]; 
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Route__c=route.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000);
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote_fee;
        Fee__c fee1 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee1;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee2;
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee3;
         
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee4; 
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee5; 
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee6; 
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee7; 
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee8; 
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee9; 
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee10; 
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee11; 
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee12; 
        Fee__c fee13 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1, Account_for__c = a.Id);
        insert fee13; 
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1, Account_for__c = a.Id);
        insert fee14; 
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1, Account_for__c = a.Id);
        insert fee15;  
        NEU_Standard_Fee_Calculation_Imp_Exp ie = new NEU_Standard_Fee_Calculation_Imp_Exp(new ApexPages.StandardController( importexportquote ));
        ie.crear_fee_estandar();
        ie.cancel();
         
    }
    
       static testMethod void test_NEU_Standard_Duty_Calculator() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
       
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000);
        insert quote;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Route__c=route.Id, Only_Warehouse_Service__c = true);
        insert importexportquote2;
        Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000);
        insert quote2;
        NEU_Standard_Duty_Calculator ie = new NEU_Standard_Duty_Calculator(new ApexPages.StandardController( importexportquote ));
        ie.calcular_tasas();
        ie.refresh();
        ie.volver();
        NEU_Standard_Duty_Calculator ie2 = new NEU_Standard_Duty_Calculator(new ApexPages.StandardController( importexportquote2 ));
        ie2.calcular_tasas();
       }
       
       static testMethod void test_NEU_Import_ExportSteps_SHPR() {
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
       // Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
       // insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        NEU_Import_ExportSteps_SHPR ie = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote ));
        system.debug( 'Prueba realizada' );
    }
    
      static testMethod void test_NEU_Import_ExportSteps_SHPR2() {
      	
      	NEU_StaticVariableHelper.setBoolean1(true);
      	
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        //Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
        //insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote2;
        Customer_Quote__c importexportquote4 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote4;
        Customer_Quote__c importexportquote5 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote5;
        Task nueva_tarea = new Task(WhatId = importexportquote4.Id);
        insert nueva_tarea;
        Associated_Document__c documento_asociado = new Associated_Document__c ( Name = importexportquote2.Name +'%', Import_Export_Quote__c = importexportquote2.Id, Account__c = a.Id);
        insert documento_asociado;
        
        Customer_Quote__c importexportquote3 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote3;
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote3.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote;
        Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote5;
         Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        
        NEU_Import_ExportSteps_SHPR ie = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote ));
        NEU_Import_ExportSteps_SHPR ie2 = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote2 ));
        NEU_Import_ExportSteps_SHPR ie3 = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote3 ));
        system.debug( 'Prueba realizada' );
    }
        
      static testMethod void test_NEU_Import_ExportSteps_SHPR2B() {
      	
      	NEU_StaticVariableHelper.setBoolean1(true);
      	
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a =list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        //Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
        //insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote2;
        Customer_Quote__c importexportquote4 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote4;
        Customer_Quote__c importexportquote5 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote5;
        Task nueva_tarea = new Task(WhatId = importexportquote4.Id);
        insert nueva_tarea;
        Associated_Document__c documento_asociado = new Associated_Document__c ( Name = importexportquote2.Name +'%', Import_Export_Quote__c = importexportquote2.Id, Account__c = a.Id);
        insert documento_asociado;
        
        Customer_Quote__c importexportquote3 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote3;
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote3.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote;
        Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote5;
         Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        
        NEU_Import_ExportSteps_SHPR ie4 = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote4 ));
        NEU_Import_ExportSteps_SHPR ie5 = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote5 ));
        system.debug( 'Prueba realizada' );
    }
     static testMethod void test_NEU_OM_Import_ExportSteps() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
       // Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
       // insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        NEU_OM_Import_ExportSteps ie = new NEU_OM_Import_ExportSteps(new ApexPages.StandardController( importexportquote ));
        system.debug( 'Prueba realizada' );
    }
    
      static testMethod void test_NEU_OM_Import_ExportSteps2() {
      	
      	NEU_StaticVariableHelper.setBoolean1(true);
      	
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        //Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
        //insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote2;
        Customer_Quote__c importexportquote4 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote4;
        Customer_Quote__c importexportquote5 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote5;
        Task nueva_tarea = new Task(WhatId = importexportquote4.Id);
        insert nueva_tarea;
        Associated_Document__c documento_asociado = new Associated_Document__c ( Name = importexportquote2.Name +'%', Import_Export_Quote__c = importexportquote2.Id, Account__c = a.Id);
        insert documento_asociado;
        
        Customer_Quote__c importexportquote3 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote3;
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote3.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote;
        Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote5;
         Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        
        NEU_OM_Import_ExportSteps ie = new NEU_OM_Import_ExportSteps(new ApexPages.StandardController( importexportquote ));
        NEU_OM_Import_ExportSteps ie2 = new NEU_OM_Import_ExportSteps(new ApexPages.StandardController( importexportquote2 ));
        NEU_OM_Import_ExportSteps ie3 = new NEU_OM_Import_ExportSteps(new ApexPages.StandardController( importexportquote3 ));
        system.debug( 'Prueba realizada' );
    }
      static testMethod void test_NEU_OM_Import_ExportSteps2B() {
      	
      	NEU_StaticVariableHelper.setBoolean1(true);
      	
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        //Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
        //insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote2;
        Customer_Quote__c importexportquote4 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote4;
        Customer_Quote__c importexportquote5 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote5;
        Task nueva_tarea = new Task(WhatId = importexportquote4.Id);
        insert nueva_tarea;
        Associated_Document__c documento_asociado = new Associated_Document__c ( Name = importexportquote2.Name +'%', Import_Export_Quote__c = importexportquote2.Id, Account__c = a.Id);
        insert documento_asociado;
        
        Customer_Quote__c importexportquote3 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote3;
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote3.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote;
        Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote5;
         Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        
        NEU_OM_Import_ExportSteps ie4 = new NEU_OM_Import_ExportSteps(new ApexPages.StandardController( importexportquote4 ));
        NEU_OM_Import_ExportSteps ie5 = new NEU_OM_Import_ExportSteps(new ApexPages.StandardController( importexportquote5 ));
        system.debug( 'Prueba realizada' );
    }

    public static testMethod void text_NEU_CloneImportExport()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Route__c=route.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000);
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote_fee;
        Fee__c fee1 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee1;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee2;
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee3;

        NEU_CloneImportExport ie = new NEU_CloneImportExport(new ApexPages.StandardController( importexportquote ));
        ie.duplicate_order();
        ie.back_record();
        String res=ie.resultado;
    }
    

}