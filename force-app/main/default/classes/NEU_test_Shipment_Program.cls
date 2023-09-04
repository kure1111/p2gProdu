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
private class NEU_test_Shipment_Program {

    /*static testMethod void test_NEU_Allocate_Costs_to_Ship_Service_Lines() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,Transporter,Transporter,');
        List<Account> list_accounts_insert= new List<Account>();
        Account a = list_accounts[0];
        list_accounts_insert.add(a);
        Account a2 = list_accounts[1];
        list_accounts_insert.add(a2);
        Account sup = list_accounts[2];
        list_accounts_insert.add(sup);
        Account sup2 = list_accounts[3];
        list_accounts_insert.add(sup2);
        insert list_accounts_insert;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
        insert ship_prog;
        Shipment_Program__c ship_prog2 = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
        insert ship_prog2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert shipconsodata;
        List<Fee__c>Fee_to_insert = new List<Fee__c>();
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        Fee_to_insert.add( fee);
        Fee__c fee2 = new Fee__c(Name = 'test fees2', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id, Valid_Until__c = system.today()-1, Max_M3__c = 6,Max_Kgs__c =10, Buy_Rate__c = 80, Volumetric_Factor__c = 100);
        Fee_to_insert.add( fee2);
        Fee__c fee3 = new Fee__c(Name = 'test fees3', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id, Valid_Until__c =system.today(), Carrier_Account__c = sup.Id, Min__c = 100, Max_M3__c = 8, Buy_Rate__c = 100);
        Fee_to_insert.add( fee3);
        Fee__c fee4 = new Fee__c(Name = 'test fees3', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id, Valid_Until__c =system.today(), Carrier_Account__c = sup.Id, Min__c = 100, Max_M3__c = 8, Buy_Rate__c = 100);
        Fee_to_insert.add( fee4);
        insert Fee_to_insert;
        
        Import_Export_Fee_Line__c iefl = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert iefl;
        Import_Export_Fee_Line__c iefl2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee2.Id);
        insert iefl2;
        Shipment_Program_Line__c  ship_prog_line = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog.Id, Units__c = 10, Service_Rate_Name__c = fee2.Id);
        insert ship_prog_line;
        Shipment_Program_Line__c  ship_prog_line2 = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog.Id, Units__c = 10);
        insert ship_prog_line2;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route');
        insert route;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee4.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline2;
        Ship_Service_Consol__c new_ship_service_consol = new Ship_Service_Consol__c(Name='test', Cost_Allocated__c = 10, Shipments_Program_Service_Line__c = ship_prog_line2.Id, Shipment_Service_Line__c = shipfeeline.Id);
        insert new_ship_service_consol;
        
        
        NEU_Allocate_Costs_to_Ship_Service_Lines acssl = new NEU_Allocate_Costs_to_Ship_Service_Lines(new ApexPages.StandardController(ship_prog));
        acssl.all_accounts_filter();
        acssl.all_containers_filter();
        acssl.getshipfeeLines();
        acssl.all_routes_filter();
        acssl.go_compare_all_service_rate_ie();
        acssl.setnewcategory('Disbursement');
        acssl.getFee_List_Price();
        for(NEU_Allocate_Costs_to_Ship_Service_Lines.Ship_Prog_Fee_Line_s ls : acssl.getFee_List_Price())
            ls.selected = true;
        acssl.getList_Fee_Shipment_Import_Export();
        acssl.chekeados = true;
        acssl.crear_shipment_service_lines();
        acssl.crearlineashipprog();
        acssl.delete_fee_select();
        acssl.return_shipment();
        acssl.update_route();
        acssl.setnewcategory('Disbursement');
        acssl.getFee_List_Price();
        acssl.go_compare_fees_filtro();
        acssl.getrecordtype();
        acssl.decimalSep = '10';
        acssl.thousandSep = '100';
        acssl.getshipment_filter();
        acssl.setshipment_filter(ship);
        acssl.setnewcategory('Disbursement');
        acssl.getFee_List_Price();

        acssl.orden_fees_filtro ='line.Name';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Valid_Until__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Account_for__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Carrier_Account__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Delivery_Zone__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.TT_Days__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Rate_Type__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Fee_Rate__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Container_Type__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Min__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Max_M3__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Max_Kgs__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Buy_Rate__c';
        acssl.go_compare_fees_filtro();
        acssl.orden_fees_filtro ='line.Volumetric_Factor__c';
        acssl.go_compare_fees_filtro();
        
        acssl.orden_fees_filtro_insertados_all  ='IE_fee_line.Units__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.decimalSep = acssl.decimalSep;
        acssl.thousandSep = acssl.thousandSep;
        
        //acssl.go_compare_fees_filtro2();
        acssl.go_compare_fees_filtro_insertados();
        acssl.getFee_List_Price2();
        acssl.crear_inbound_shipment_service_lines();
        acssl.delete_ship_fee_line_select();
        //NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s lf = new NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s();
        acssl.setnewcategory('Warehouse');
        Shipment_Consolidation_Data__c shipconsodata2 = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id, Shipments_Program__c =ship_prog.Id);
        insert shipconsodata2;
        Shipment_Consolidation_Data__c shipconsodata3 = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id, Shipments_Program__c =ship_prog2.Id);
        insert shipconsodata3;
        List<Fee__c> list_to_insert_fee = new List<Fee__c>();
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        list_to_insert_fee.add(fee5);
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per W/M', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        list_to_insert_fee.add( fee6);
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        list_to_insert_fee.add( fee7);
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        list_to_insert_fee.add( fee8);
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        list_to_insert_fee.add( fee9);
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        list_to_insert_fee.add( fee10);
        insert list_to_insert_fee;
        List<Shipment_Fee_Line__c> Shipment_Fee_Line_to_insert = new List<Shipment_Fee_Line__c>();
        Shipment_Fee_Line__c shipfeeline3 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        Shipment_Fee_Line_to_insert.add( shipfeeline3);
        Import_Export_Fee_Line__c quote_line = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee5.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote_line;
        Shipment_Fee_Line__c shipfeeline4 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline4);
        Shipment_Fee_Line__c shipfeeline5 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline5);
        Shipment_Fee_Line__c shipfeeline6 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline6);
        Shipment_Fee_Line__c shipfeeline7 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee6.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline7);
        Shipment_Fee_Line__c shipfeeline8 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee7.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline8);
        Shipment_Fee_Line__c shipfeeline9 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee8.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline9);
        Shipment_Fee_Line__c shipfeeline10 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee9.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline10);
        Shipment_Fee_Line__c shipfeeline11 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee10.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        Shipment_Fee_Line_to_insert.add(shipfeeline11);
        insert Shipment_Fee_Line_to_insert;
        acssl.shipment_filter.Account_for__c = a2.Id;
        acssl.getFee_List_Price2();
        acssl.getFee_List_Price();
        List<NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s> new_list_allocate = new List<NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s>();
        NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s lineas_orden = new NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s(acssl, ship, null, true, 10, '',null, true, '', ship_prog2.Id);
        new_list_allocate.add(lineas_orden);
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Units__c';
        
        //new_list_allocate.sort();
        Shipment_Program_Line__c  ship_prog_line3 = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog.Id, Units__c = 10);
	    insert ship_prog_line3;
        Ship_Service_Consol__c new_Ship_Service_Consol2 = new Ship_Service_Consol__c(Shipment_Service_Line__c = shipfeeline4.Id, Shipments_Program_Service_Line__c =ship_prog_line3.Id);
        insert new_Ship_Service_Consol2;  
        acssl.getList_Fee_Shipment_Import_Export();
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Units__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Quote_Sell_Price__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Import_Export_Quote__r.Name';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Import_Export_Quote__r.Account_for__r.Name';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Import_Export_Quote__r.Consignee__r.Name';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Route__r.Name';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Discount__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Sell_Amount__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Quote_Buy_Price__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'buy_amount';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Container_Type__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'shipment.Total_Weight_Kg__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'shipment.Total_Volume_m3__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Fee__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Sell_Rate__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Rate_Type__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.TT_Days__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Carrier_Account__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Port_Airport__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Carrier_Account__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Service_Rate_Name__r.Fee_Category__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'shipment.Account_for__c';
        acssl.go_compare_all_service_rate_ie();
        acssl.orden_fees_filtro_insertados_all = 'shipment.Name';
        acssl.go_compare_all_service_rate_ie();
        for(NEU_Allocate_Costs_to_Ship_Service_Lines.Ship_Prog_Fee_Line_s spfl : acssl.Fee_List_Price2)
            spfl.selected = true;   
        acssl.crear_inbound_shipment_service_lines();
        for(NEU_Allocate_Costs_to_Ship_Service_Lines.Ship_fee_lines_import_export_s sflie : acssl.List_Fee_Shipment_Import_Export)
            for(NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s spfl : sflie.list_fees)
                spfl.selected = true;   
        acssl.crear_shipment_service_lines();
    }*/
    
    static testMethod void test_NEU_SPG_Track_Trace() 
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',Total_Gross_Volume_m3__c  = 10, Total_Gross_Weight_Kg__c  = 10, Number_of_Packages__c =10);
        insert ship_prog;
        NEU_SPG_Track_Trace spg_t=new NEU_SPG_Track_Trace(new ApexPages.StandardController( ship_prog ));
    }
    
    static testMethod void test_NEU_SP_Notifications_PDF() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',Total_Gross_Volume_m3__c  = 10, Total_Gross_Weight_Kg__c  = 10, Number_of_Packages__c =10);
        insert ship_prog;
        NEU_SP_Notifications_PDF spg_t=new NEU_SP_Notifications_PDF(new ApexPages.StandardController( ship_prog ));
        spg_t.load_template();
        spg_t.load_template_booking_english();
        spg_t.load_template_booking_spanish();
        
    }
    
    static testMethod void test_NEU_SP_Notifications_save_PDF() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',Total_Gross_Volume_m3__c  = 10, Total_Gross_Weight_Kg__c  = 10, Number_of_Packages__c =10);
        insert ship_prog;
        NEU_SP_Notifications_save_PDF spg_t=new NEU_SP_Notifications_save_PDF(new ApexPages.StandardController( ship_prog ));
        Blob b = Blob.valueOf('Test Data');
        spg_t.documento_asociado.Name='Test document.test';
        spg_t.documento_asociado.AuthorId = UserInfo.getUserId();
        spg_t.documento_asociado.IsPublic=true;
        spg_t.documento_asociado.Body = b;
        spg_t.crear();
        spg_t.return_page();
        
        
    }
    
    static testMethod void test_NEU_Ground_Track_Trace_Planning() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',Total_Gross_Volume_m3__c  = 10, Total_Gross_Weight_Kg__c  = 10, Number_of_Packages__c =10);
        insert ship_prog;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country2;
        Location__c localizacion3 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion3;

        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Freight_Mode__c='Road',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address', Quotation_Status__c = 'Approved as Succesful');
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Freight_Mode__c='Road',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address', Quotation_Status__c = 'Quote being prepared');
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
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog.Id,  Country_of_Load__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_of_Discharge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Equip_Placed__c = system.today(),ETD_from_Point_of_Load__c = system.today(),ETA_Point_of_Discharge__c = system.today(),Equip_Unloaded__c = system.today(),Origin_Address__c ='test',Destination_Address__c='test', Only_Warehouse_Service__c = true);
        insert ship;
        
        
       // coordenadas_longitud
       // coordenadas_add
        
        Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog.Id,  Country_of_Load__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_of_Discharge__c= Country.Id,Site_of_Discharge__c= localizacion.Id,Equip_Placed__c = system.today(),ETD_from_Point_of_Load__c = system.today(),ETA_Point_of_Discharge__c = system.today(),Equip_Unloaded__c = system.today(),Origin_Address__c ='test',Destination_Address__c='test', Only_Warehouse_Service__c = true);
        insert ship2;
        NEU_Shipment_Program_View_Route r=new NEU_Shipment_Program_View_Route(new ApexPages.StandardController( ship_prog ));
        for(NEU_Shipment_Program_View_Route.shipment_s s:r.list_shipment_related_load)
        {
            String st=s.Loading_Time;
            st=s.Unloading_Time;
            st=s.Transit_time;
            st=s.Transit_time_Discharge;
        }
        NEU_Ground_Track_Trace_Planning gttp = new NEU_Ground_Track_Trace_Planning(new ApexPages.StandardController( ship_prog ));
        for(NEU_Ground_Track_Trace_Planning.shipment_s s:gttp.list_shipment_related_load)
        {
            String st=s.Loading_Time;
            st=s.Unloading_Time;
            st=s.Transit_time;
            st=s.Transit_time_Discharge;
        }
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_load_up();
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_load_down();
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_discharge_up();
        gttp.id_shipment_pos=ship2.id;
        gttp.reorder_discharge_down();
        
        gttp.save_coordenadas();
        gttp.save_changes_shipments();
        
    }
    static testMethod void test_NEU_Allocate_Costs_to_Ship_Service_Lines3() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route2;
        Shipment_Program__c ship_prog3 = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10', Route__c =route2.Id);
        insert ship_prog3;
        NEU_Allocate_Costs_to_Ship_Service_Lines acssl2 = new NEU_Allocate_Costs_to_Ship_Service_Lines(new ApexPages.StandardController(ship_prog3));
        ApexPages.currentPage().getParameters().put('pes', 'Warehouse');
        
        acssl2.getnewcategories();
        acssl2.all_carriers_filter();
        acssl2.filter_new_carrier();
        acssl2.getFee_List_Price2();
        acssl2.go_compare_fees_filtro2();
        
        List<Fee__c>feesToAdd=new List<Fee__c>();
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Account_for__c = a.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        feesToAdd.add( fee10);
        Fee__c fee24 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee24); 
        Fee__c fee25 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee25); 
        Fee__c fee26 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee26); 
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee14); 
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee15); 
        Fee__c fee16 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee16); 
        Fee__c fee27 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee27); 
        Fee__c fee28 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee28); 
        Fee__c fee29 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee29); 
        Fee__c fee17 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee17); 
        Fee__c fee18 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee18); 
        Fee__c fee19 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee19); 
        Fee__c fee30 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee30); 
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
        acssl2.setnewcategory('Disbursement');
        acssl2.Fee_List_Price = null;
        acssl2.getFee_List_Price();
        
        acssl2.setnewcategory('Warehouse');
        acssl2.Fee_List_Price = null;
        acssl2.getFee_List_Price();
        Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog3.Id, Route__c = route2.Id, Site_of_Discharge__c =localizacion.Id , Site_of_Load__c = localizacion.Id,Country_of_Discharge__c= Country.Id, Country_of_Load__c = Country.Id, Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment__c ship3 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog3.Id, Route__c = route2.Id, Only_Warehouse_Service__c = true);
        insert ship3;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c(Shipment__c = ship2.Id, Import_Export_Quote__c = importexportquote.Id);
        insert new_shipment_consolidation_data;
        Import_Export_Fee_Line__c quote_line = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee28.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote_line;
        Import_Export_Fee_Line__c quote_line2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee28.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote_line2;
        Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee28.Id , Shipment__c= ship2.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line2.Id);
        insert ship_fee_line;
        Shipment_Fee_Line__c ship_fee_line2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee28.Id , Shipment__c= ship2.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        insert ship_fee_line2;
        Shipment_Program_Line__c  ship_prog_line3 = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog3.Id, Units__c = 10, Service_Rate_Name__c = fee28.Id, Inbound_Shipment__c = ship2.Id);
        insert ship_prog_line3;

        Ship_Service_Consol__c new_ship_service_consol3 = new Ship_Service_Consol__c(Shipment_Service_Line__c = ship_fee_line.Id, Shipments_Program_Service_Line__c = ship_prog_line3.Id);
        insert new_ship_service_consol3;
        acssl2.List_Fee_Shipment_Import_Export = null;
        acssl2.getList_Fee_Shipment_Import_Export();
        acssl2.setnewcategory('Disbursement');
        acssl2.List_Fee_Shipment_Import_Export = null; 
        acssl2.getList_Fee_Shipment_Import_Export();
        
    }
    
     static testMethod void test_NEU_Allocate_Costs_to_Ship_Service_Lines2() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,Transporter,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account a2 = list_accounts[1];
        insert a2;
        Account sup = list_accounts[2];
        insert sup;
        Account sup2 =list_accounts[3];
        insert sup2;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
        insert ship_prog;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog.Id, Only_Warehouse_Service__c = true);
        insert ship;
        NEU_Allocate_Costs_to_Ship_Service_Lines acssl = new NEU_Allocate_Costs_to_Ship_Service_Lines(new ApexPages.StandardController(ship_prog));
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a2.Id, Carrier_Account__c = sup2.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        insert fee5;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Import_Export_Fee_Line__c quote_line = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee5.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote_line;
        Shipment_Fee_Line__c shipfeeline4 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee5.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        insert shipfeeline4;
        List<NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s> new_list_allocate = new List<NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s>();
        NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s lineas_orden = new NEU_Allocate_Costs_to_Ship_Service_Lines.Lineas_fees_s(acssl, ship, null, true, 10, '',null, true, '', ship_prog.Id);
        new_list_allocate.add(lineas_orden);
        acssl.orden_fees_filtro_insertados_all = 'IE_fee_line.Units__c';
        new_list_allocate.sort();
        Shipment_Program_Line__c  ship_prog_line3 = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog.Id, Units__c = 10);
        insert ship_prog_line3;
        Ship_Service_Consol__c new_Ship_Service_Consol2 = new Ship_Service_Consol__c(Shipment_Service_Line__c = shipfeeline4.Id, Shipments_Program_Service_Line__c =ship_prog_line3.Id);
        insert new_Ship_Service_Consol2;  
        acssl.getList_Fee_Shipment_Import_Export();
    }
    
    static testMethod void test_NEU_SendDocuments_Shipments_Program() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email='oscar@neurored.com');
        insert contacto;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto2 = new Contact(AccountId = sup.Id, LastName='test contact2', Email='oscar2@neurored.com');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Supplier_Account__c = sup.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Associated_Document__c documentos_asociados = new Associated_Document__c(Name='test associated document', Account__c=a.Id, Shipment__c=ship.Id);
        insert documentos_asociados;

      
        NEU_SendDocuments_Shipments_Program sdsp = new NEU_SendDocuments_Shipments_Program(new ApexPages.StandardController( ship ));
        List<NEU_SendDocuments_Shipments_Program.documents_s> associated_documents_new = new List<NEU_SendDocuments_Shipments_Program.documents_s>();
        associated_documents_new.add(new NEU_SendDocuments_Shipments_Program.documents_s(true, 'pdf.pdf','pdf', 'reference', 'description', '', documentos_asociados.Id, 0,'10'));
        sdsp.associated_documents = associated_documents_new;
        
        List<NEU_SendDocuments_Shipments_Program.contacto_s> clientes_contacntos_new = new List<NEU_SendDocuments_Shipments_Program.contacto_s>();
        clientes_contacntos_new.add(new NEU_SendDocuments_Shipments_Program.contacto_s(contacto, true, 'oscar@neurored.com'));
        
        List<NEU_SendDocuments_Shipments_Program.cuenta_s> clientes_seleccionados_new = new List<NEU_SendDocuments_Shipments_Program.cuenta_s>();
        clientes_seleccionados_new.add(new NEU_SendDocuments_Shipments_Program.cuenta_s(a, clientes_contacntos_new,'Customer', ship.Id));
        
        List<NEU_SendDocuments_Shipments_Program.shipments_s> shipments_seleccionados_new = new List<NEU_SendDocuments_Shipments_Program.shipments_s>();
        shipments_seleccionados_new.add(new NEU_SendDocuments_Shipments_Program.shipments_s(ship, clientes_seleccionados_new));
        
        
        sdsp.shipments_related  = shipments_seleccionados_new;
        sdsp.send_email();
        sdsp.return_shipment_program();
        sdsp.add_link_to_body();
    	
    }
    
    
    static testMethod void NEU_FreightRates_ShipmentsPrograms() {
    	
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
	    insert ship_prog;
	    
    	NEU_FreightRates_ShipmentsPrograms fsp = new NEU_FreightRates_ShipmentsPrograms(new ApexPages.StandardController(ship_prog));
    	fsp.ordenar_tabla_fees();
    	
    }
}