/**
 * Created by magrinan on 31/05/2019.
 */
@isTest
private class NEU_test_CQL {

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

        Test.startTest();

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
        Shipment__c ship = new Shipment__c(name = 'sp-fn-23-098765',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true,Route__c=route.Id,Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id);
        Shipment__c shipR = new Shipment__c(name = 'sp-fn-23-098768',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
        Shipment__c shipi = new Shipment__c(name = 'sp-fn-23-098769',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_for_Catalog_Price_List__c=d.Id,Conversion_Rate_Date__c = system.today(), Only_Warehouse_Service__c = true, Site_of_Load__c=localizacion.Id,Site_of_Discharge__c=localizacion2.Id, Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id,State_of_Load__c=state.Id,State_of_Discharge__c=state.Id,Route__c=route.Id);
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

        Test.stopTest();

        NEU_OM_ShipFeeLinesPriceListYDiscount uda = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController( ship ));
       NEU_OM_ShipFeeLinesPriceListYDiscount PLD = NEW NEU_OM_ShipFeeLinesPriceListYDiscount();
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
       /* //Fin clase NEUEBUSCM_Shipment_Fee_Line_s
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
        udashipi.getshipfeeLines_all_for_route();*/

        system.debug( 'Prueba realizada');

    }

    /*public static testMethod void testNEU_OM_ShipFeeLinesPriceListYDiscount_2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');

        Test.startTest();

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

        Test.stopTest();

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

        Test.startTest();

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

        Test.stopTest();

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
        //udafilter.change_ratio_category();
        udafilter.record.Service_Mode__c='NATIONAL';
        udafilter.setnewcategory('Road Freights');
        //udafilter.getFee_List_Price();
        udafilter.setnewcategory('Sea Freights');
        udafilter.getIE_lines();
        udafilter.create_shipment_service_ie();
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

        udafilter.metodo1();
        udafilter.metodo2();
        udafilter.metodo3();
        udafilter.metodo4();

        system.debug( 'Prueba realizada_Discount2_Metodo1');

    }

    public static testMethod void testNEU_OM_ShipFeeLinesPriceListYDiscount2_2()
    {
        Test.startTest();

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
        udafilter.change_ratio_category();
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

        Test.stopTest();

    }*/

    public static testMethod void testNEU_OM_CQLPriceListYDiscount() {//ok

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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        importexportquote.Account_for__r=a;
        Subfamily__c s = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert s;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = s.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        List<Customer_Quote__c> lista_import_export_quote = new List<Customer_Quote__c>();
        List<Quote_Item_Line__c> listado_de_lineas = new List<Quote_Item_Line__c>();
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =25, Item_Name__c= g.Id);
        insert quote;
        lista_import_export_quote.add(importexportquote);
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote2;
        lista_import_export_quote.add(importexportquote2);
        Quote_Item_Line__c quote3 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =45, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote3;
        listado_de_lineas.add(quote3);
        Customer_Quote__c importexportquote4 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote4;
        lista_import_export_quote.add(importexportquote4);
        Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote4.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =50, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote4;
        listado_de_lineas.add(quote4);
        Customer_Quote__c importexportquote5 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote5;
        lista_import_export_quote.add(importexportquote5);
        Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =80, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote5;
        listado_de_lineas.add(quote5);
        Customer_Quote__c importexportquote6 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote6;
        lista_import_export_quote.add(importexportquote6);
        Quote_Item_Line__c quote6 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote6.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =100, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote6;
        listado_de_lineas.add(quote6);
        Customer_Quote__c importexportquote7 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote7;
        lista_import_export_quote.add(importexportquote7);
        Quote_Item_Line__c quote7 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote7.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =125, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote7;
        listado_de_lineas.add(quote7);
        Customer_Quote__c importexportquote8 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote8;
        lista_import_export_quote.add(importexportquote8);
        Quote_Item_Line__c quote8 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote8.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =150, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote8;
        listado_de_lineas.add(quote8);
        Customer_Quote__c importexportquote9 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote9;
        lista_import_export_quote.add(importexportquote9);
        Quote_Item_Line__c quote9 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote9.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =200, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote9;
        listado_de_lineas.add(quote9);

        insert listado_de_lineas;


        update importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        List<Fee__c> listado_fees = new List<Fee__c>();
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        //insert fee2;
        listado_fees.add(fee2);
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        //insert fee3;
        listado_fees.add(fee3);
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee4;
        listado_fees.add(fee4);
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee5;
        listado_fees.add(fee5);
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee6;
        listado_fees.add(fee6);
        Fee__c fee16 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee6;
        listado_fees.add(fee16);
        Fee__c fee17 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        //insert fee6;
        listado_fees.add(fee17);
        Fee__c fee18 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee6;
        listado_fees.add(fee18);
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee7;
        listado_fees.add(fee7);
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee8;
        listado_fees.add(fee8);
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee9;
        listado_fees.add(fee9);


        Fee__c fee19 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee9;
        listado_fees.add(fee19);

        Fee__c fee20 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        //insert fee9;
        listado_fees.add(fee20);

        Fee__c fee21 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee9;
        listado_fees.add(fee21);


        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee10;
        listado_fees.add(fee10);
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee11;
        listado_fees.add(fee11);
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee12;
        listado_fees.add(fee12);
        Fee__c fee22 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee12;
        listado_fees.add(fee22);
        Fee__c fee23 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        //insert fee12;
        listado_fees.add(fee23);
        Fee__c fee24 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee12;
        listado_fees.add(fee24);

        Fee__c fee13 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        //insert fee13;
        listado_fees.add(fee13);
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        // insert fee14;
        listado_fees.add(fee14);
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        //insert fee15;
        listado_fees.add(fee15);
        insert listado_fees;


        String lista_import_export_id = '';
        if(lista_import_export_quote!= null)
            if(lista_import_export_quote.size()>0)
                for(Customer_Quote__c lieq : lista_import_export_quote)
                {
                    lista_import_export_id += '\''+lieq.Id +'\''+',';
                }
        List<Customer_Quote__c> consulta_import_export  = Database.query('select Id,  State_of_Load__c, State_of_Discharge__c, Total_Services_Std_Buy_Amount_number__c, Total_Services_Sell_Amount_number__c,  Delivery_Cartage__c, Container_Count__c , Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode,' : '')+'               Account_for__c,Container_Type__c,Catalog_Price_List__r.Business_Area__c,Catalog_Price_List__r.Family__c,Account_for__r.Business_Area__c,Catalog_Price_List__c,                Route__c,                 Site_of_Load__c,Site_of_Discharge__c,                Account_for_Price_List__c,Country_ofLoad__c, Country_ofDischarge__c,                Pickup_Cartage__c, Purchase_Incoterm__c,Sales_Incoterm__c,Supplier_Account__c,                Total_Weight_Kg2__c,  Total_Volume_m3_2__c from Customer_Quote__c where id IN ('+lista_import_export_id.subString(0,lista_import_export_id.length()-1)+')');


        NEU_OM_CQLPriceListYDiscount uda = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[0] ));
        uda.chekeados =true;
        uda.setnewcategory('Disbursement');
        uda.categories();
        //string value = uda.getnewcategory();
        uda.getquotefeeLines();
        uda.getFee_List_Price();

        uda.getrecordtype();
        //uda.Fee_List_Price[0].mylist[0].selected = true;
        uda.crearlineaquoteitem();
        uda.update_route();
        uda.return_import_export();
        uda.id_oi = quote2.Id;
        uda.delete_fee_select();

        NEU_OM_CQLPriceListYDiscount uda1 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[1] ));
        uda1.chekeados =true;
        uda1.setnewcategory('Disbursement');
        uda1.categories();
        //uda1.getFee_List_Price();
        system.debug( 'Prueba realizada' );
        //Bloque Test_Pass_Test
        uda1.metodo1();
        uda1.metodo2();
        uda1.metodo3();
        uda1.metodo4();
        uda1.metodo5();
        uda1.metodo7();
        uda1.metodo8();
        uda1.metodo9();
        uda1.metodo10();
        uda1.metodo11();
        uda1.metodo12();
        uda1.metodo13();
        uda1.metodo14();
        uda1.metodo15();
    }

    public static testMethod void testNEU_OM_CQLPriceListYDiscount1_1() {

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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        importexportquote.Account_for__r=a;
        Subfamily__c s = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert s;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = s.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        List<Customer_Quote__c> lista_import_export_quote = new List<Customer_Quote__c>();
        List<Quote_Item_Line__c> listado_de_lineas = new List<Quote_Item_Line__c>();
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =25, Item_Name__c= g.Id);
        insert quote;
        lista_import_export_quote.add(importexportquote);
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote2;
        lista_import_export_quote.add(importexportquote2);
        Quote_Item_Line__c quote3 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =45, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote3;
        listado_de_lineas.add(quote3);
        Customer_Quote__c importexportquote4 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote4;
        lista_import_export_quote.add(importexportquote4);
        Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote4.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =50, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote4;
        listado_de_lineas.add(quote4);
        Customer_Quote__c importexportquote5 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote5;
        lista_import_export_quote.add(importexportquote5);
        Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =80, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote5;
        listado_de_lineas.add(quote5);
        Customer_Quote__c importexportquote6 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote6;
        lista_import_export_quote.add(importexportquote6);
        Quote_Item_Line__c quote6 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote6.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =100, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote6;
        listado_de_lineas.add(quote6);
        Customer_Quote__c importexportquote7 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote7;
        lista_import_export_quote.add(importexportquote7);
        Quote_Item_Line__c quote7 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote7.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =125, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote7;
        listado_de_lineas.add(quote7);
        Customer_Quote__c importexportquote8 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote8;
        lista_import_export_quote.add(importexportquote8);
        Quote_Item_Line__c quote8 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote8.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =150, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote8;
        listado_de_lineas.add(quote8);
        Customer_Quote__c importexportquote9 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote9;
        lista_import_export_quote.add(importexportquote9);
        Quote_Item_Line__c quote9 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote9.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =200, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote9;
        listado_de_lineas.add(quote9);

        insert listado_de_lineas;


        update importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        List<Fee__c> listado_fees = new List<Fee__c>();
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        //insert fee2;
        listado_fees.add(fee2);
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        //insert fee3;
        listado_fees.add(fee3);
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee4;
        listado_fees.add(fee4);
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee5;
        listado_fees.add(fee5);
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee6;
        listado_fees.add(fee6);
        Fee__c fee16 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee6;
        listado_fees.add(fee16);
        Fee__c fee17 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        //insert fee6;
        listado_fees.add(fee17);
        Fee__c fee18 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee6;
        listado_fees.add(fee18);
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee7;
        listado_fees.add(fee7);
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee8;
        listado_fees.add(fee8);
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee9;
        listado_fees.add(fee9);


        Fee__c fee19 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee9;
        listado_fees.add(fee19);

        Fee__c fee20 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        //insert fee9;
        listado_fees.add(fee20);

        Fee__c fee21 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee9;
        listado_fees.add(fee21);


        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee10;
        listado_fees.add(fee10);
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee11;
        listado_fees.add(fee11);
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee12;
        listado_fees.add(fee12);
        Fee__c fee22 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee12;
        listado_fees.add(fee22);
        Fee__c fee23 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        //insert fee12;
        listado_fees.add(fee23);
        Fee__c fee24 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
        //insert fee12;
        listado_fees.add(fee24);

        Fee__c fee13 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        //insert fee13;
        listado_fees.add(fee13);
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        // insert fee14;
        listado_fees.add(fee14);
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        //insert fee15;
        listado_fees.add(fee15);
        insert listado_fees;


        String lista_import_export_id = '';
        if(lista_import_export_quote!= null)
            if(lista_import_export_quote.size()>0)
                for(Customer_Quote__c lieq : lista_import_export_quote)
                {
                    lista_import_export_id += '\''+lieq.Id +'\''+',';
                }
        List<Customer_Quote__c> consulta_import_export  = Database.query('select Id, State_of_Load__c, State_of_Discharge__c, Total_Services_Sell_Amount_number__c, Total_Services_Std_Buy_Amount_number__c, Delivery_Cartage__c, Container_Count__c , Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode,' : '')+'               Account_for__c,Container_Type__c,Catalog_Price_List__r.Business_Area__c,Catalog_Price_List__r.Family__c,Account_for__r.Business_Area__c,Catalog_Price_List__c,                Route__c,                 Site_of_Load__c,Site_of_Discharge__c,                Account_for_Price_List__c,Country_ofLoad__c, Country_ofDischarge__c,                Pickup_Cartage__c, Purchase_Incoterm__c,Sales_Incoterm__c,Supplier_Account__c,                Total_Weight_Kg2__c,  Total_Volume_m3_2__c from Customer_Quote__c where id IN ('+lista_import_export_id.subString(0,lista_import_export_id.length()-1)+')');

        NEU_OM_CQLPriceListYDiscount uda4 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[4] ));
        uda4.chekeados =true;
        uda4.setnewcategory('Disbursement');
        uda4.categories();
        uda4.getFee_List_Price();

        NEU_OM_CQLPriceListYDiscount uda5 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[5] ));
        uda5.chekeados =true;
        uda5.setnewcategory('Disbursement');
        uda5.categories();
        uda5.getFee_List_Price();

        uda5.orden_fees_filtro = 'line.Name';
        uda5.orden_fees_filtro_modo ='desc';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Valid_Until__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'weight_factor';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'total_sell';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'total_buy';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Account_for__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Carrier_Account__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Delivery_Zone__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Port_Airport__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.TT_Days__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Rate_Type__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Fee_Rate__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Container_Type__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Pallet_Type__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Min__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Max_M3__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Max_Kgs__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Buy_Rate__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line.Volumetric_Factor__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line_quote.Units__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line_quote.Quote_Sell_Price__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line_quote.Discount__c';
        uda5.go_compare_fees_filtro();

        uda5.orden_fees_filtro = 'line_quote.Quote_Buy_Price__c';
        uda5.go_compare_fees_filtro();
    }

    public static testMethod void testNEU_OM_CQLPriceListYDiscount7() {

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a =list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c s = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert s;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = s.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Quote_Item_Line__c quote_line = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =1, Total_Shipping_Weight_Kgs__c =1, Item_Name__c = g.Id);
        insert quote_line;
        system.debug('holaa'+importexportquote.Total_Volume_m3_2__c);
        string import_export_id = importexportquote.Id;
        List<Customer_Quote__c> query_customer_quote = database.query('select id'+NEU_CurrencyUtils.CurrencyISOCode('')+', Name, State_of_Load__c, State_of_Discharge__c, Total_Services_Sell_Amount_number__c, Total_Services_Std_Buy_Amount_number__c,Total_Volume_m3_2__c, Account_for__c,Catalog_Price_List__r.Business_Area__c, Catalog_Price_List__r.Family__c, Account_for__r.Business_Area__c, Catalog_Price_List__c, Route__c, Site_of_Load__c, Site_of_Discharge__c, Container_Count__c, Account_for_Price_List__c, Country_ofLoad__c, Delivery_Cartage__c, Country_ofDischarge__c, Total_Services_Std_Buy_Amount__c, Total_Services_Sell_Amount__c,   Pickup_Cartage__c, Purchase_Incoterm__c, Sales_Incoterm__c, Supplier_Account__c, Total_Weight_Kg2__c, Container_Type__c, Enable_Route_Options__c, Site_of_Load__r.Name, Country_ofLoad__r.Name, Site_of_Discharge__r.Name, Country_ofDischarge__r.Name, Route__r.Port_Airport_of_Load__r.Name, Route__r.Country_of_Load__r.Name, Route__r.Name, Route__r.Port_Airport_of_Discharge__r.Name, Route__r.Country_of_Discharge__r.Name from Customer_Quote__c where Id=: import_export_id');
        List<Fee__c> listado_fees = new List<Fee__c>();
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 45,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee);
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 50,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee2);
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 80,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee3);
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 100,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee4);
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 150,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee5);
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 200,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee6);
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 5000,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee7);
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 7500,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        listado_fees.add(fee8);
        insert listado_fees;
        NEU_OM_CQLPriceListYDiscount cqlpricelistydiscount = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( query_customer_quote[0] ));
        cqlpricelistydiscount.setnewcategory('Disbursement');
        cqlpricelistydiscount.getFee_List_Price();

    }

}