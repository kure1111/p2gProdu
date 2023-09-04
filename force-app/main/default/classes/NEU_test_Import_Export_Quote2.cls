/**
 * Created by jamarin on 08/01/2019.
 */
@isTest
private class NEU_test_Import_Export_Quote2 {
    /*

    public static testMethod void testNEU_OM_Start_Clearance() {//57 los httprequest

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;

        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;

        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;

        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id);
        insert quote;

        NEU_OM_Start_Clearance uda = new NEU_OM_Start_Clearance(new ApexPages.StandardController( importexportquote ));

        uda.idlineactualizar=quote.Id;
        uda.idlineaitem=quote.Id;
        uda.applyLines();
        uda.calcular_hs_codes();
        uda.calculate_taxes();
        uda.getlist_category();
        uda.getlista_items();
        uda.getlista_subcategorias();
        uda.getquoteItemLines();
        uda.getquoteItemLine2();
    }

    public static testMethod void testNEU_OM_Start_Clearance2() {//57 los httprequest

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;

        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        NEU_OM_Start_Clearance uda = new NEU_OM_Start_Clearance(new ApexPages.StandardController( importexportquote ));

        uda.idlineactualizar=quote.Id;
        uda.idlineaitem=quote.Id;
        uda.getDutyCalculatorInfo();
        //Test.setMock(HttpCalloutMock.class, new NEU_OM_TestHttpResponse());

        // HttpResponse res = uda.res;

        /*   HttpResponse res = new HttpResponse();

          String contentType = res.getHeader('Content-Type');
          System.assert(contentType == 'application/json');

          String actualValue = res.getBody();
          String expectedValue = '{"foo":"bar"}';

          System.assertEquals(actualValue, expectedValue);
          System.assertEquals(200, res.getStatusCode());*/
/*
    }


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
        uda1.getFee_List_Price();
        system.debug( 'Prueba realizada' );
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

    public static testMethod void test_NEU_DO_save_pdf()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,Customer,Customer,');
        Account a = list_accounts[0];
        insert a;


        //Contacts por Test account
        Contact contact1 = new Contact(AccountId = a.Id, LastName='test contact1', Email='test1@test.com', MobilePhone = '111222333', Phone = '85111222333', Fax = '574552222');
        insert contact1;

        //Final Delivery Account
        Account id_fd = list_accounts[1];
        insert id_fd;

        Contact id_fd_c1 = new Contact(AccountId = a.Id, LastName='test contact2', Email='test2@test.com', MobilePhone = '111222334', Phone = '85111222334', Fax = '574552222');
        insert id_fd_c1;


        //Shipper and Consigne
        Account aShipper = list_accounts[2];
        insert aShipper;
        Account aConsigne = list_accounts[3];
        insert aConsigne;

        Customer_Quote__c  importexportquote = new Customer_Quote__c( Account_for__c = a.Id, DO_Release_Date__c = system.today(), DO_Release_Valid_To__c = system.today().adddays(3),
                DO_Release_to_Company__c = a.Id, DO_Contact_1_Release_to_Company__c = contact1.Id,
                Supplier_Account__c = aShipper.Id, Consignee__c = aConsigne.Id, Contact__c = contact1.Id, DO_Shipment_Pickup__c = id_fd.Id, DO_Contact_1_Shipment_Pickup__c = id_fd_c1.Id, Only_Warehouse_Service__c = true);

        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000, Units_x_Master_Box__c=10 );
        insert g;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Units__c=1000, Expense_Amount__c = 100);
        insert quote;
        NEU_DO_save_pdf anie=new NEU_DO_save_pdf(new ApexPages.StandardController( importexportquote ));
        anie.return_page();
        anie.crear();
        anie.generar_pdf();


        importexportquote.DO_Release_to_Company__c = null;
        importexportquote.DO_Shipment_Pickup__c = null;
        importexportquote.DO_Release_Date__c = null;
        importexportquote.DO_Release_Valid_To__c = null;
        importexportquote.DO_Remarks__c = 'test test test';
        importexportquote.DO_Remarks_Shipment_Pickup__c = 'test test test';
        importexportquote.Contact__c = null;
        update importexportquote;

        NEU_DO_save_pdf anie1=new NEU_DO_save_pdf(new ApexPages.StandardController( importexportquote ));
        anie1.return_page();
        anie1.crear();
        anie1.generar_pdf();

        importexportquote.Freight_Mode__c= 'Sea';
        importexportquote.B_L_Status__c = 'Original';
        update importexportquote;

        NEU_DO_save_pdf anie2=new NEU_DO_save_pdf(new ApexPages.StandardController( importexportquote ));
        anie2.return_page();
        anie2.crear();
        anie2.generar_pdf();


        importexportquote.Freight_Mode__c= 'Air';
        importexportquote.DO_Release_Date__c = null;
        importexportquote.DO_Release_Valid_To__c = null;
        update importexportquote;

        NEU_DO_save_pdf anie3=new NEU_DO_save_pdf(new ApexPages.StandardController( importexportquote ));
        anie3.return_page();
        anie3.crear();
        anie3.generar_pdf();
    }


    public static testMethod void test_NEU_DO_pdf()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,Customer,Customer,');
        Account a = list_accounts[0];
        insert a;


        //Contacts por Test account
        Contact contact1 = new Contact(AccountId = a.Id, LastName='test contact1', Email='test1@test.com', MobilePhone = '111222333', Phone = '85111222333', Fax = '574552222');
        insert contact1;
        Contact contact2 = new Contact(AccountId = a.Id, LastName='test contact2', Email='test2@test.com', MobilePhone = '111222333', Phone = '85111222333', Fax = '574552222');
        insert contact2;
        Contact contact3 = new Contact(AccountId = a.Id, LastName='test contact3', Email='test3@test.com', MobilePhone = '111222333', Phone = '85111222333', Fax = '574552222');
        insert contact3;

        //Final Delivery Account
        Account id_fd = list_accounts[1];
        insert id_fd;

        Contact id_fd_c1 = new Contact(AccountId = a.Id, LastName='test contact4', Email='test4@test.com', MobilePhone = '111222334', Phone = '85111222334', Fax = '574552222');
        insert id_fd_c1;
        Contact id_fd_c2 = new Contact(AccountId = a.Id, LastName='test contact5', Email='test5@test.com', MobilePhone = '111222335', Phone = '85111222335', Fax = '574552222');
        insert id_fd_c2;
        Contact id_fd_c3 = new Contact(AccountId = a.Id, LastName='test contact6', Email='test6@test.com', MobilePhone = '111222336', Phone = '85111222336', Fax = '574552222');
        insert id_fd_c3;

        //Shipper and Consigne
        Account aShipper = list_accounts[2];
        insert aShipper;
        Account aConsigne = list_accounts[3];
        insert aConsigne;

        Customer_Quote__c  importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Supplier_Account__c = aShipper.Id, Consignee__c = aConsigne.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000, Units_x_Master_Box__c=10 );
        insert g;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Units__c=1000, Expense_Amount__c = 100);
        insert quote;


        //Set Parameters
        ApexPages.currentPage().getParameters().put('id', importexportquote.Id);
        ApexPages.currentPage().getParameters().put('id_rc', a.Id);
        ApexPages.currentPage().getParameters().put('id_rc_c1', contact1.Id);
        ApexPages.currentPage().getParameters().put('id_fd', id_fd.Id);
        ApexPages.currentPage().getParameters().put('id_fd_c1', id_fd_c1.Id);
        ApexPages.currentPage().getParameters().put('remarks', 'test past test');
        ApexPages.currentPage().getParameters().put('shipment_pick_up', 'test past test');

        NEU_DO_pdf anie=new NEU_DO_pdf(new ApexPages.StandardController( importexportquote ));
    }

    public static  testMethod void testNEU_OM_CQLPriceListYDiscount5() {//ok

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
        Subfamily__c s = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert s;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = s.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        List<Fee__c> list_fee_to_insert = new List<Fee__c>();
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee12);
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee14);
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee15);
        insert list_fee_to_insert;

        List<Customer_Quote__c> lista_import_export_quote = new List<Customer_Quote__c>();
        Customer_Quote__c importexportquote10 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote10;
        List<Quote_Item_Line__c> listado_quote_item = new List<Quote_Item_Line__c>();
        lista_import_export_quote.add(importexportquote10);
        Quote_Item_Line__c quote10 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote10.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =250, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote10;
        listado_quote_item.add(quote10);
        Customer_Quote__c importexportquote11 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote11;
        lista_import_export_quote.add(importexportquote11);
        Quote_Item_Line__c quote11 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote11.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =300, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote11;
        listado_quote_item.add(quote11);
        Customer_Quote__c importexportquote12 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote12;
        lista_import_export_quote.add(importexportquote12);
        Quote_Item_Line__c quote12 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote12.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =500, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote12;
        listado_quote_item.add(quote12);
        Customer_Quote__c importexportquote13 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote13;
        lista_import_export_quote.add(importexportquote13);
        Quote_Item_Line__c quote13 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote13.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =1000, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote13;
        listado_quote_item.add(quote13);

        insert listado_quote_item;

        String lista_import_export_id = '';
        if(lista_import_export_quote!= null)
            if(lista_import_export_quote.size()>0)
                for(Customer_Quote__c lieq : lista_import_export_quote)
                {
                    lista_import_export_id += '\''+lieq.Id +'\''+',';
                }
        List<Customer_Quote__c> consulta_import_export = Database.query('select Id, State_of_Load__c, State_of_Discharge__c, Total_Services_Sell_Amount_number__c, Total_Services_Std_Buy_Amount_number__c, Container_Type__c, Container_Type__r.Name, Container_Count__c, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode,' : '')+'               Account_for__c,Catalog_Price_List__r.Business_Area__c,Catalog_Price_List__r.Family__c,Account_for__r.Business_Area__c,Catalog_Price_List__c,                Route__c,                Site_of_Load__c,Site_of_Discharge__c,                Account_for_Price_List__c,Country_ofLoad__c, Country_ofDischarge__c,Pickup_Cartage__c, Purchase_Incoterm__c,Sales_Incoterm__c,Supplier_Account__c,Total_Weight_Kg2__c,  Total_Volume_m3_2__c,                Delivery_Cartage__c from Customer_Quote__c where id IN ('+lista_import_export_id.subString(0,lista_import_export_id.length()-1)+')');

        NEU_OM_CQLPriceListYDiscount uda10 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[0] ));
        uda10.chekeados =true;
        uda10.setnewcategory('Disbursement');
        uda10.categories();
        uda10.getFee_List_Price();
        NEU_OM_CQLPriceListYDiscount uda11 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[1] ));
        uda11.chekeados =true;
        uda11.setnewcategory('Disbursement');
        uda11.categories();
        uda11.getFee_List_Price();
        NEU_OM_CQLPriceListYDiscount uda12 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[2] ));
        uda12.chekeados =true;
        uda12.setnewcategory('Disbursement');
        uda12.categories();
        uda12.getFee_List_Price();
        NEU_OM_CQLPriceListYDiscount uda13 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[3] ));
        uda13.chekeados =true;
        uda13.setnewcategory('Disbursement');
        uda13.categories();
        uda13.getFee_List_Price();


    }

    public static  testMethod void testNEU_OM_CQLPriceListYDiscount5_3()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Quote_Item_Line__c> listado_quote_item = new List<Quote_Item_Line__c>();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Subfamily__c s = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert s;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = s.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        List<Fee__c> list_fee_to_insert = new List<Fee__c>();
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee12);
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee14);
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee15);
        insert list_fee_to_insert;

        List<Customer_Quote__c> lista_import_export_quote = new List<Customer_Quote__c>();
        Customer_Quote__c importexportquote14 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote14;
        lista_import_export_quote.add(importexportquote14);
        Quote_Item_Line__c quote14 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote14.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =1500, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote14;
        listado_quote_item.add(quote14);
        Customer_Quote__c importexportquote15 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote15;
        lista_import_export_quote.add(importexportquote15);
        Quote_Item_Line__c quote15 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote15.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =2000, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        // insert quote15;
        listado_quote_item.add(quote15);
        Customer_Quote__c importexportquote16 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote16;
        lista_import_export_quote.add(importexportquote16);
        Quote_Item_Line__c quote16 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote16.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =2500, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        // insert quote16;
        listado_quote_item.add(quote16);

        Customer_Quote__c importexportquote17 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote17;
        lista_import_export_quote.add(importexportquote17);
        Quote_Item_Line__c quote17 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote17.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =3000, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        //insert quote17;
        listado_quote_item.add(quote17);

        insert listado_quote_item;

        String lista_import_export_id = '';
        if(lista_import_export_quote!= null)
            if(lista_import_export_quote.size()>0)
                for(Customer_Quote__c lieq : lista_import_export_quote)
                {
                    lista_import_export_id += '\''+lieq.Id +'\''+',';
                }
        List<Customer_Quote__c> consulta_import_export = Database.query('select Id, State_of_Load__c, State_of_Discharge__c, Total_Services_Sell_Amount_number__c, Total_Services_Std_Buy_Amount_number__c, Name, Container_Type__c, Container_Type__r.Name, Container_Count__c, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode,' : '')+'               Account_for__c,Catalog_Price_List__r.Business_Area__c,Catalog_Price_List__r.Family__c,Account_for__r.Business_Area__c,Catalog_Price_List__c,                Route__c,                Site_of_Load__c,Site_of_Discharge__c,                Account_for_Price_List__c,Country_ofLoad__c, Country_ofDischarge__c,Pickup_Cartage__c, Purchase_Incoterm__c,Sales_Incoterm__c,Supplier_Account__c,Total_Weight_Kg2__c,  Total_Volume_m3_2__c,                Delivery_Cartage__c from Customer_Quote__c where id IN ('+lista_import_export_id.subString(0,lista_import_export_id.length()-1)+')');

        NEU_OM_CQLPriceListYDiscount uda14 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[0] ));
        uda14.chekeados =true;
        uda14.setnewcategory('Disbursement');
        uda14.categories();
        uda14.getFee_List_Price();
        NEU_OM_CQLPriceListYDiscount uda15 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[1] ));
        uda15.chekeados =true;
        uda15.setnewcategory('Disbursement');
        uda15.categories();
        uda15.getFee_List_Price();
    }

    public static  testMethod void testNEU_OM_CQLPriceListYDiscount5_2()
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
        Subfamily__c s = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert s;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = s.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        List<Fee__c> list_fee_to_insert = new List<Fee__c>();
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee12);
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee14);
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id);
        list_fee_to_insert.add( fee15);
        insert list_fee_to_insert;
        Customer_Quote__c importexportquote17 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Conversion_Rate_Date__c =system.today(), Only_Warehouse_Service__c = true);
        insert importexportquote17;
        NEU_OM_CQLPriceListYDiscount uda17 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( importexportquote17 ));
        uda17.chekeados =true;
        uda17.setnewcategory('Disbursement');
        uda17.categories();
        uda17.getFee_List_Price();
        uda17.update_record();
    }

    public static  testMethod void testNEU_OM_CQLPriceListYDiscount6() {

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Conversion_Rate_Date__c =system.today(), Only_Warehouse_Service__c = true);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Other Service Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee2;
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'POL Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee3;
        Import_Export_Fee_Line__c ie_fee_line = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id, Name = 'lineas items', Service_Rate_Name__c= fee.Id, Units__c = 100, Quote_Sell_Price__c = 10);
        insert ie_fee_line;
        Import_Export_Fee_Line__c ie_fee_line2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id, Name = 'lineas items', Service_Rate_Name__c= fee2.Id, Units__c = 100, Quote_Sell_Price__c = 10);
        insert ie_fee_line2;
        Import_Export_Fee_Line__c ie_fee_line3 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id, Name = 'lineas items', Service_Rate_Name__c= fee3.Id, Units__c = 100, Quote_Sell_Price__c = 10);
        insert ie_fee_line3;
        NEU_OM_CQLPriceListYDiscount cqlplyd = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( importexportquote ));

        cqlplyd.getquotefeeLines_all();
        cqlplyd.getquotefeeLines_all_for_route();
        List<SelectOption> new_list_option=cqlplyd.otherFees;

        cqlplyd.go_compare_fees_filtro();
        cqlplyd.go_compare_fees_filtro_insertados();
        NEU_OM_CQLPriceListYDiscount.Import_Export_Fee_Line_all_s iefla = new NEU_OM_CQLPriceListYDiscount.Import_Export_Fee_Line_all_s(cqlplyd, '','',null,10,10,10);
        iefla.gettotal_buy_format();
        iefla.gettotal_sell_format();
        cqlplyd.update_sites_countries();
    }

    public static  testMethod void testNEU_OM_CQLPriceListYDiscount5_1() {

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Customer_Quote__c> lista_import_export_quote = new List<Customer_Quote__c>();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Subfamily__c s = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert s;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = s.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Customer_Quote__c importexportquote18 = new Customer_Quote__c(Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote18;
        lista_import_export_quote.add(importexportquote18);
        Quote_Item_Line__c quote18 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote18.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =5000, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        insert quote18;
        Customer_Quote__c importexportquote19 = new Customer_Quote__c( Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote19;
        lista_import_export_quote.add(importexportquote19);
        Quote_Item_Line__c quote19 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote19.id,Name = 'lineas items', Total_Shipping_Volume_m3__c =7500, Total_Shipping_Weight_Kgs__c =100, Item_Name__c= g.Id);
        insert quote19;

        String lista_import_export_id = '';
        if(lista_import_export_quote!= null)
            if(lista_import_export_quote.size()>0)
                for(Customer_Quote__c lieq : lista_import_export_quote)
                {
                    lista_import_export_id += '\''+lieq.Id +'\''+',';
                }

        List<Customer_Quote__c> consulta_import_export = Database.query('select Id, State_of_Load__c, State_of_Discharge__c, Total_Services_Sell_Amount_number__c, Total_Services_Std_Buy_Amount_number__c,  Container_Type__c, Container_Type__r.Name, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode,' : '')+'               Account_for__c,Catalog_Price_List__r.Business_Area__c,Catalog_Price_List__r.Family__c,Account_for__r.Business_Area__c,Catalog_Price_List__c,                Route__c,                 Site_of_Load__c,Site_of_Discharge__c,                Account_for_Price_List__c,Country_ofLoad__c, Country_ofDischarge__c,                Pickup_Cartage__c, Purchase_Incoterm__c,Sales_Incoterm__c,Supplier_Account__c,                Total_Weight_Kg2__c,  Total_Volume_m3_2__c,     Delivery_Cartage__c from Customer_Quote__c where id IN ('+lista_import_export_id.subString(0,lista_import_export_id.length()-1)+')');

        NEU_OM_CQLPriceListYDiscount uda18 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[0]));
        uda18.chekeados =true;
        uda18.setnewcategory('Disbursement');
        uda18.categories();
        uda18.getFee_List_Price();
        NEU_OM_CQLPriceListYDiscount uda19 = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( consulta_import_export[1] ));
        uda19.chekeados =true;
        uda19.setnewcategory('Disbursement');
        uda19.categories();
        uda19.getFee_List_Price();
        uda19.getimp_ext_filter();
        uda19.setimp_ext_filter(importexportquote19);
        string decimales = uda19.decimalSep;
        string decimales2 = uda19.thousandSep;
        uda19.all_accounts_filter();
        uda19.all_containers_filter();
        uda19.getquotefeeLines_all();




    }


    public static testMethod void testNEU_OM_CQLPriceListYDiscount3() {//ok

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Conversion_Rate_Date__c =system.today(), Only_Warehouse_Service__c = true);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee2;
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee3;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;

        NEU_OM_CQLPriceListYDiscount uda = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( importexportquote ));
        uda.chekeados =true;
        string value = '';
        uda.getFee_List_Price();
        uda.getquotefeeLines();
        uda.categories();
        uda.crearlineaquoteitem();
        system.debug( 'Prueba realizada' );
    }

    public static testMethod void testNEU_OM_CQLPriceListYDiscount2() {//ok

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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Account_for_Price_List__c =d.Id, Conversion_Rate_Date__c =system.today(), Only_Warehouse_Service__c = true);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee2;
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee3;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;

        NEU_OM_CQLPriceListYDiscount uda = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController( importexportquote ));
        uda.setnewcategory('Disbursement');
        uda.categories();
        uda.getquotefeeLines();
        //string value = uda.getnewcategory();
        uda.getFee_List_Price();
        NEU_OM_CQLPriceListYDiscount.NEUEBUSCM_Quote_Fee_Line_s lines8 = new NEU_OM_CQLPriceListYDiscount.NEUEBUSCM_Quote_Fee_Line_s(fee, null, true,  'extension name','10','10','10','10',null,'MXN',0,null,'',0,'','',null,10, false);
        uda.chekeados = true;
        for(NEU_OM_CQLPriceListYDiscount.NEUEBUSCM_Quote_Fee_Line_s line: uda.getFee_List_Price())
        {
            line.selected= true;
        }

        uda.crearlineaquoteitem();


        system.debug( 'Prueba realizada' );
    }


    public static testMethod void test_NEU_OM_CreateItemsLines2() {//ok

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
        Customer_Quote__c  importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c = 2, Total_Shipping_Weight_Kgs__c = 8, Total_Shipping_Volume_m3__c = 8);
        insert quote;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_CreateItemsLines gpcc=new NEU_OM_CreateItemsLines(new ApexPages.StandardController( importexportquote ));
        system.debug( 'Prueba realizada' );
        gpcc.nuevo_item = quote;
        gpcc.crearlineaquoteitem();
        gpcc.getquoteItemLines();
    }

    public static testMethod void test_NEU_OM_Save_Generate_Quote() {//ok

        NEU_StaticVariableHelper.setBoolean1(true);

        Customer_Quote__c cotizacion = new Customer_Quote__c();
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_Save_Generate_Quote gpcc=new NEU_OM_Save_Generate_Quote(new ApexPages.StandardController( cotizacion ));
        system.debug( 'Prueba realizada' );
        gpcc.crear();
    }


    public static testMethod void test_NEU_FreightSourcingQuote_IE() {//ok

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Route__c=route.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Route__c = route.Id, Active__c= true, Account_for__c = a.Id);
        insert fee;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_FreightSourcingQuote_IE fsq = new NEU_FreightSourcingQuote_IE(new ApexPages.StandardController( importexportquote ));
        fsq.ordenar_tabla_fees();
        system.debug( 'Prueba realizada' );
    }



    public static testMethod void testNEU_OM_CreateItemsLinesAndDiscount() {//con price list

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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=b.Id,List_Price__c=10 );
        insert f;
        NEU_OM_CreateItemsLinesAndDiscount uda = new NEU_OM_CreateItemsLinesAndDiscount(new ApexPages.StandardController( importexportquote ));

        string field_accountpricelist = 'pricelist';
        field_accountpricelist = b.Id;



        uda.getquoteItemLines();

        uda.crearlineaquoteitem();
        uda.getItem_List_Price();
        String family =c.Id;
        uda.getFamilyList(family);
        //uda.chekeados=true;
        uda.Item_List_Price[0].mylist[0].selected = true;
        uda.crearlineaquoteitem();
        uda.categories();
        string decimales = uda.decimalSep;
        string miles = uda.thousandSep;
        uda.getTempPrice_List();
        uda.setTempPrice_List(b.Id);
        uda.setnewcategory('Disbursement');
        uda.getpricelists();
        uda.delete_item_line_select();
    }

    public static testMethod void testNEU_OM_CreateItemsLinesAndDiscount2() {//con account price list

        NEU_StaticVariableHelper.setBoolean1(true);

        ApexPages.currentPage().getParameters().put('test', 'true');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Price_List__c apricelist = new Customer_Price_List__c(Name='test', Customer__c= a.Id, Price_List__c=b.Id);
        insert apricelist;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for_Price_List__c=apricelist.Id , Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;

        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=b.Id,List_Price__c=10 );
        insert f;
        NEU_OM_CreateItemsLinesAndDiscount uda = new NEU_OM_CreateItemsLinesAndDiscount(new ApexPages.StandardController( importexportquote ));

        string field_accountpricelist = 'pricelist';
        field_accountpricelist = b.Id;
        uda.getquoteItemLines();

        uda.crearlineaquoteitem();
        uda.getItem_List_Price();
        String family =c.Id;
        uda.getFamilyList(family);
        // uda.chekeados=true;
        uda.Item_List_Price[0].mylist[0].selected = true;
        uda.crearlineaquoteitem();
    }

    public static testMethod void testNEU_OM_CreateItemsLinesAndDiscount3() {//con price list

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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=b.Id,List_Price__c=10 );
        insert f;
        NEU_OM_CreateItemsLinesAndDiscount uda = new NEU_OM_CreateItemsLinesAndDiscount(new ApexPages.StandardController( importexportquote ));

        string field_accountpricelist = 'pricelist';
        field_accountpricelist = b.Id;


        uda.categories();
    }


    public static testMethod void test_NEU_OM_GenerateQuote()
    {//ok

        NEU_StaticVariableHelper.setBoolean1(true);

        Customer_Quote__c cotizacion = new Customer_Quote__c();
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_GenerateQuote gpcc=new NEU_OM_GenerateQuote(new ApexPages.StandardController( cotizacion ));
        system.debug( 'Prueba realizada' );
    }
    public static testMethod void text_NEU_CloneImportExport()
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

        NEU_CloneImportExport ie = new NEU_CloneImportExport(new ApexPages.StandardController( importexportquote ));
        ie.duplicate_order();
        String res=ie.resultado;
    }
    public static testMethod void NEU_Import_Export_Quotes_Search()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c f = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert f;
        Subfamily__c d = new Subfamily__c(Product_Family__c = f.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =f.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = a.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = b.id, Account_for__c = a.Id, Route__c=route.Id, Quotation_Status__c = 'Quote being prepared', Only_Warehouse_Service__c = true);
        insert importexportquote;
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

        NEU_Import_Export_Quotes_Search c = new NEU_Import_Export_Quotes_Search();
        c.ie_status=c.ie_status;
        c.service_mode=c.service_mode;
        c.record=c.record;
        c.ie_quotes=c.ie_quotes;
        c.ie_orders=c.ie_orders;
        c.sta_list=c.sta_list;
        c.serv_list=c.serv_list;
        c.sta_list='[]';
        c.serv_list='[]';
        c.id_record_type_quote=c.id_record_type_quote;
        c.id_record_type_order=c.id_record_type_order;
        c.orden_filtro_quotes=c.orden_filtro_quotes;
        c.orden_filtro_quotes_modo=c.orden_filtro_quotes_modo;
        c.orden_filtro_order=c.orden_filtro_order;
        c.orden_filtro_order_modo=c.orden_filtro_order_modo;
        c.orden_filtro_quotes='Name';
        c.orden_filtro_quotes_modo='asc';
        c.orden_filtro_order='Name';
        c.orden_filtro_order_modo='asc';
        c.id_quote=c.id_quote;
        c.params=c.params;
        c.ETD_operator_selected=c.ETD_operator_selected;
        c.getETD_operator_list();
        c.ETA_operator_selected=c.ETA_operator_selected;
        c.getETA_operator_list();
        c.carga_filtros();
        c.id_quote=importexportquote.id;
        c.update_quote_now();
        c.record.Route__c=route.Id;
        c.ETD_operator_selected='not equal to';
        c.ETA_operator_selected='not equal to';
        c.go_compare_quote();
        c.go_compare_orders();
        c.search_import_export_quote_order();
    }


    public static testMethod void test_NEU_Import_Export_Warnings()
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
        importexportquote.Origin_Address__c = 'tst adrress';
        importexportquote.Destination_Address__c = 'test address';
        insert importexportquote;

        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;

        Shipment_Line__c shipline = new Shipment_Line__c();
        shipline.Shipment__c = ship.Id;
        shipline.Name = 'test ship line';
        shipline.Customs_Value__c = 433.02;
        insert shipline;

        Invoice__c i_test = new Invoice__c();
        i_test.Import_Export_Quote_Order__c = importexportquote.Id;
        i_test.Shipment__c = ship.Id;
        i_test.Account__c = account_test.Id;
        Date date1 = System.today().addDays(-2);
        Date date2 = System.today();
        i_test.Payable_Before__c = date1;
        i_test.Date_of_Invoice__c = date2;
        insert i_test;

        Invoice_Line__c il = new Invoice_Line__c();
        il.Invoice__c = i_test.Id;
        il.Units__c = 10;
        il.Unit_Price__c = 433.02;
        il.Amount__c= 433.02;
        insert il;

        NEU_Import_Export_Warnings uda = new NEU_Import_Export_Warnings(new ApexPages.StandardController( importexportquote ));
        system.debug('Test Ok Warnings Account');
    }

    public static testMethod void test_NEU_Import_Export_Warnings_1()
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
        importexportquote.Origin_Address__c = 'tst adrress';
        importexportquote.Destination_Address__c = 'test address';
        insert importexportquote;

        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;

        Shipment_Line__c shipline = new Shipment_Line__c();
        shipline.Shipment__c = ship.Id;
        shipline.Name = 'test ship line';
        shipline.Customs_Value__c = 0;
        insert shipline;

        Invoice__c i_test = new Invoice__c();
        i_test.Import_Export_Quote_Order__c = importexportquote.Id;
        i_test.Shipment__c = ship.Id;
        i_test.Account__c = account_test.Id;
        Date date1 = System.today().addDays(-2);
        Date date2 = System.today();
        i_test.Payable_Before__c = date1;
        i_test.Date_of_Invoice__c = date2;
        insert i_test;

        NEU_Import_Export_Warnings uda = new NEU_Import_Export_Warnings(new ApexPages.StandardController( importexportquote ));
        system.debug('Test_1 Ok Warnings Account');
    }

    public static testMethod void NEU_NewImportExport()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;

        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id,
                Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress',
                Destination_Address__c='test address');
        insert importexportquote;

        NEU_NewImportExport nie = new NEU_NewImportExport(new ApexPages.StandardController( importexportquote ));
        nie.redirect_new_importexport();
    }

    public static testMethod void NEU_Import_Export_Quote_save_pdf()
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
        service_rate.Name = 'Service Rate Test';
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

        NEU_Import_Export_Quote_save_pdf ieqspdf = new NEU_Import_Export_Quote_save_pdf(new ApexPages.StandardController( importexportquote ));
        ieqspdf.getnewcategories();
        ieqspdf.refresh_data();
        ieqspdf.crear();
    }

    public static testMethod void NEU_Import_Export_Controller()
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

        Quote_Item_Line__c new_cargo_line = new Quote_Item_Line__c();
        new_cargo_line.Import_Export_Quote__c = importexportquote.Id;
        new_cargo_line.Name = '001';
        insert new_cargo_line;

        Customer_Quote__c import_export = new Customer_Quote__c();
        string notes = '';
        List<Quote_Item_Line__c> cargo_lines = new List<Quote_Item_Line__c>();
        NEU_Import_Export_Controller.Import_Export_Cargo_Line_s cargo_line_s = new NEU_Import_Export_Controller.Import_Export_Cargo_Line_s();
        List<string> currency_options = new List<string>();
        boolean status = false;
        List<Customer_Quote__c> import_export_quotes = new List<Customer_Quote__c>();

        import_export = NEU_Import_Export_Controller.getImportExport(importexportquote.Id);
        notes = NEU_Import_Export_Controller.getImportExportNotes(importexportquote.Id);
        cargo_lines = NEU_Import_Export_Controller.getLines(importexportquote.Id);
        cargo_line_s = NEU_Import_Export_Controller.initializeCargoLine(importexportquote.Id);
        NEU_Import_Export_Controller.saveCargoLine('', importexportquote.Id, '');
        cargo_lines = NEU_Import_Export_Controller.deleteCargoLine(new_cargo_line.Id, importexportquote.Id);
        currency_options = NEU_Import_Export_Controller.getCurrencyOptions();
        NEU_Import_Export_Controller.sendToPak2Go(importexportquote.Id);
        NEU_Import_Export_Controller.confirmToPak2Go(importexportquote.Id);
        NEU_Import_Export_Controller.rejectQuote(importexportquote.Id, '');
        status = NEU_Import_Export_Controller.getPending('');
        import_export_quotes = NEU_Import_Export_Controller.getImportExportsByStatus('');
    }
*/
}