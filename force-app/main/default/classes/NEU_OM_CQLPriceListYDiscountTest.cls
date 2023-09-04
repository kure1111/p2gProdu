@isTest()
public class NEU_OM_CQLPriceListYDiscountTest {
@testSetup
    static void Setup(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Arrastre De puerto';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        account_test.Requiere_Acuse_Sap__c = 'Si';
        insert account_test;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Country__c country = new Country__c(Name='Mxico', ISO_Code__c='MEX');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='xalapa', State__c=state.Id,Country__c=country.Id);
        insert location;
        Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        insert container;
        Price_List__c price = new Price_List__c();
        price.Name = 'Price List Test';
        price.Items_Account_Owner__c = account_test.Id;
        insert price;
        Customer_Price_List__c priceList = new Customer_Price_List__c();
        priceList.Customer__c = account_test.Id;
		priceList.Name = 'Customer Price List Test';	
		priceList.Price_List__c = price.Id;
        insert priceList;
        Warehouse__c ware = new Warehouse__c();
        ware.Name = 'Warehouse test';
        insert ware;
        Delivery_Zone__c pickup = new Delivery_Zone__c();
        pickup.Name = 'pickup test';
        pickup.Port_Airport__c = location.id;
        pickup.Kms__c = 2;
        pickup.Miles__c = 7;
        pickup.Warehouse__c = ware.Id;
        insert pickup;
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name='.';
        quote.Account_for__c = account_test.Id;
        quote.Account_for_Price_List__c = priceList.Id;
        quote.Team__c = 'P2G';
        quote.Quotation_Status__c = 'Quote being prepared';
        quote.Customer_Reference__c = 'holi';
        quote.Valid_From__c = system.today();
        quote.Valid_Until__c = system.today();
        quote.Comercio_Exterior__c = 'No';
        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'NATIONAL';
        quote.Service_Type__c = 'FTL';
        quote.CurrencyIsoCode = 'MXN';
        quote.Country_ofLoad__c = location.Country__c;
        quote.State_of_Load__c = location.State__c;
        quote.Site_of_Load__c = location.Id;
        quote.Country_ofDischarge__c = location.Country__c;
        quote.State_of_Discharge__c = location.State__c;
        quote.Site_of_Discharge__c = location.Id;
        quote.ETD__c = Date.today();
        quote.ETA__c = Date.today();
        quote.Container_Type__c = container.Id;
        quote.Community_Status__c = 'CUSTOMER CREATED';
        quote.Pricing_Executive__c= userT.Id;
        quote.Operations_Exec__c = userT.Id;
        quote.Purchase_Incoterm__c = 'CFR';
        quote.Sales_Incoterm__c = 'CFR';
        quote.Pickup_Cartage__c = pickup.Id;
        quote.Delivery_Cartage__c = pickup.Id;
        insert quote;
        SAP_Service_Type__c sap = new SAP_Service_Type__c();
        sap.Name = 'INTERNACIONAL AEREO (IC) (A)';
        sap.Code__c = 'A-INT_AEREO_(IC)';
        sap.Group__c = 'SP-FN-FLETE NACIONAL';
        sap.Activo__c = true;
        insert sap;
        String recordTypeI = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c serviceRate = new Fee__c();
        serviceRate.RecordTypeId = recordTypeI;
        serviceRate.Name = 'Flete Nacional'; //
        serviceRate.Route__c = quote.Route__c; 
        serviceRate.CurrencyIsoCode = 'MXN'; 
        serviceRate.Fee_Category__c = 'Road Freights'; 
        serviceRate.Group__c = 'SP-FN-FLETE NACIONAL'; 
        serviceRate.SAP_Service_Type__c = sap.Id; //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        serviceRate.Container_Type__c = container.Id;
        serviceRate.TT_Days__c = '1';
        serviceRate.Rate_Type__c = 'Fixed';
        serviceRate.Account_for__c = account_test.Id;
        serviceRate.Active__c=true;
        serviceRate.Fee_Rate__c = 0;
        serviceRate.Buy_Rate__c = 0;
        serviceRate.Valid_From__c = Date.valueOf('2023-06-12');
        serviceRate.Valid_Until__c = Date.valueOf('2023-06-13');
        insert serviceRate;
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
		serviceLine.Import_Export_Quote__c = quote.Id;
        serviceLine.Name = '003';
        serviceLine.Conversion_Rate_to_Currency_Header__c= integer.valueOf('1');
        serviceLine.Tarifario_ServRate__c = integer.valueOf('1');
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = serviceRate.Id;
        serviceLine.Quote_Sell_Price__c = 0;
        serviceLine.Quote_Buy_Price__c = 0;
        serviceLine.Quote_Buy_Price_Number__c = 12;
        serviceLine.Conversion_Rate_to_Currency_Header__c = 21;
        insert serviceLine;
        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FN-23-000783';
        new_shipment.Freight_Mode__c= 'Road';
        new_shipment.Service_Type__c= 'FTL';
        new_shipment.ETA_Point_of_Discharge__c = Date.valueOf('2023-05-2');
        new_shipment.ETD_from_Point_of_Load__c = Date.valueOf('2023-05-12');
        new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(08,0,0,0);
        new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(08,0,0,0);
        new_shipment.Route__c = quote.Route__c;
        new_shipment.Account_for__c= account_test.Id;
        new_shipment.Country_of_Discharge__c = country.Id;
        new_shipment.Country_of_Load__c = country.Id;
        new_shipment.State_of_Discharge__c = state.Id;
        new_shipment.State_of_Load__c = state.Id;
        new_shipment.Site_of_Discharge__c = location.Id;
        new_shipment.Site_of_Load__c = location.Id;
        new_shipment.Container_Type__c = container.Id;
        new_shipment.Service_Mode__c = 'NATIONAL';
        new_shipment.Traslado_Ingreso__c = 'Ingreso';
        insert new_shipment;
    }
    @isTest
    static void NEU_OM_CQLPriceListYDiscountTest(){
        Customer_Quote__c quote = [SELECT id,Name,RecordTypeId,Account_for__c,Team__c,Quotation_Status__c,Pricing_Executive__c,
                                    Sales_Incoterm__c,Container_Type__c,Country_ofLoad__r.Name, Country_ofLoad__r.ISO_Code__c,
                                    Country_ofLoad__c,State_of_Discharge__c,State_of_Discharge__r.Name,State_of_Discharge__r.Iso_Code__c,
                                    Customer_Reference__c,Valid_From__c,Valid_Until__c,Comercio_Exterior__c,Freight_Mode__c,
                                    Purchase_Incoterm__c,Delivery_Cartage__c,State_of_Load__c,State_of_Load__r.Name,State_of_Load__r.Iso_Code__c,
                                    Site_of_Load__c,Site_of_Load__r.Name,Site_of_Discharge__c,Site_of_Discharge__r.Name,Service_Mode__c,
                                    Service_Type__c,CurrencyIsoCode,Route__c,Account_for_Price_List__c,Pickup_Cartage__r.Name,
                                    Pickup_Cartage__r.Kms__c,Pickup_Cartage__r.Miles__c,Pickup_Cartage__r.Port_Airport__c,
                                    Pickup_Cartage__r.Warehouse__c,ETD__c,Pickup_Cartage__c,Country_ofDischarge__c,Country_ofDischarge__r.Name,
                                   Country_ofDischarge__r.ISO_Code__c,ETA__c,Community_Status__c,Operations_Exec__c,
                                   Total_Services_Std_Buy_Amount_number__c,Total_Services_Sell_Amount_number__c
                                   FROM Customer_Quote__c WHERE Customer_Reference__c =: 'holi' LIMIT 1];
        Fee__c fee = [SELECT Id, Name, Valid_From__c,Valid_Until__c,Account_for__c FROM Fee__c WHERE Fee_Category__c = 'Road Freights' LIMIT 1];
        Shipment__c ship = [SELECT Id, Name FROM Shipment__c WHERE Name = 'SP-FN-23-000783' LIMIT 1];
        List<Import_Export_Fee_Line__c> lines = [SELECT Id, Name, Service_Rate_Name__c FROM Import_Export_Fee_Line__c];
        Test.startTest();
        PageReference pageRef = Page.NEU_OM_CQLPriceListYDiscount;
         Test.setCurrentPage(pageRef);
         ApexPages.StandardController sc = new ApexPages.StandardController(quote);
         NEU_OM_CQLPriceListYDiscount testPak = new NEU_OM_CQLPriceListYDiscount(sc);
        testPak.setnewcategory('Sea Freights');
        testPak.setnewcategory('Air Freights');
        testPak.setnewcategory('Drayages');
        testPak.setnewcategory('Other Service Charges');
        testPak.setnewcategory('Test');
        testPak.change_ratio_category();
        Customer_Quote__c quoteTest = testPak.getimp_ext_filter();
        testPak.setimp_ext_filter(quote);
        Fee__c feeTest = testPak.getservice_rate_filter();
        testPak.setservice_rate_filter(fee);
        String deci = testPak.decimalSep;
        String thou = testPak.thousandSep;
        String getreco = testPak.getrecordtype();
        Shipment__c getship = testPak.getship_filter();
        testPak.setship_filter(ship);
        testPak.setrecordtype('var');
        testPak.update_record();
        testPak.refresh_button();
        testPak.all_accounts_filter();
        testPak.all_carriers_filter();
        testPak.filter_new_carrier();
        testPak.all_containers_filter();
        List<Import_Export_Fee_Line__c> getquotefee = testPak.getquotefeeLines();
        List<Import_Export_Fee_Line__c> getquoteall = testPak.getquotefeeLines_all();
        List<NEU_OM_CQLPriceListYDiscount.Import_Export_Fee_Line_currency_s> getquotewithout = testPak.getquotefeeLines_without();
        List<NEU_OM_CQLPriceListYDiscount.Import_Export_Fee_Line_all_s> getquoteroute = testPak.getquotefeeLines_all_for_route();
        testPak.go_compare_fees_filtro();
        testPak.search_name_filter();
        Boolean check = testPak.checkExistRoute();
        testPak.buscar_paises_sites();
        testPak.createNewRoute();
        List<SelectOption> other = testPak.otherFees;
        //testPak.anterior_siguiente_order();
        testPak.go_compare_fees_filtro_insertados();
        testPak.update_check_show_all_categories();
        testPak.update_check_hidden_all_categories();
        //List<NEU_OM_CQLPriceListYDiscount.NEUEBUSCM_Quote_Fee_Line_s> getfee = testPak.getFee_List_Price();//
        string getcurrency = testPak.get_currency_object();
        String getfilters = testPak.getfilters_query();
        NEU_OM_CQLPriceListYDiscount.Import_Export_Fee_Line_all_s iefla = new NEU_OM_CQLPriceListYDiscount.Import_Export_Fee_Line_all_s(testPak, '','',null,10,10,10);
        iefla.gettotal_buy_format();
        iefla.gettotal_sell_format();
        testPak.create_new_service_rate();
        testPak.crearlineaquoteitem();
        NEU_OM_CQLPriceListYDiscount.dividirLineas(lines);
        testPak.delete_fee_select();
        testPak.return_import_export();
        testPak.update_sites_countries();
        testPak.update_route();
        testPak.getSociedadSap();
        testPak.change_ratio_category();
        //testPak.NEUEBUSCM_Quote_Fee_Line_s NEUEBUSCM = new te.NEUEBUSCM_Quote_Fee_Line_s();
        List<SelectOption> options = new List<SelectOption>(); 
        //NEU_OM_CQLPriceListYDiscount.NEUEBUSCM_Quote_Fee_Line_s() ;
        testPak.metodo1();
        testPak.metodo2();
        Test.stopTest();
    }
}