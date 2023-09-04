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
private class NEU_test_Supplier_QuoteOrder {

     public static testMethod void NEU_OM_SupQuOr_FeeLinesPriceListDiscount_test()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
         insert supplyproject;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id);
         insert supquote;
        
         
         Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
         insert fee;
         Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
         insert fee2;
         Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
         insert fee3;
         Supplier_Quote_Order_Fee_Line__c sup_quotefeeline = new Supplier_Quote_Order_Fee_Line__c(Name= 'test supquote fee line', Supplier_Quote_Order__c = supquote.Id, Fee_Name__c = fee.Id);
         insert sup_quotefeeline;
         Price_List__c price_list = new Price_List__c(Name = 'Test lista');
         NEU_OM_SupQuOr_FeeLinesPriceListDiscount uda = new NEU_OM_SupQuOr_FeeLinesPriceListDiscount(new ApexPages.StandardController( supquote ));
         uda.chekeados = true;
         uda.nombre_route ='test route';
         uda.id_oi =sup_quotefeeline.Id;
         uda.getrecordtype();
        // uda.setrecordtype('Other fee'Other Service Charges' // uda.getrecordtype();
        // uda.getrecordtype();
         uda.getnewcategories();
         uda.setnewcategory('Disbursement');
         uda.getnewcategory();
         uda.categories();
         uda.getsup_quote_order_feeLines();
         uda.getFee_List_Price();
         //uda.Fee_List_Price[0].mylist[0].selected = true;
         
         for(NEU_OM_SupQuOr_FeeLinesPriceListDiscount.Supplier_QuoteOrder_Fee_Line_s sqf: uda.Fee_List_Price)
         {
            sqf.selected = true;
         }
         
         uda.crearlineaquoteitem();
         uda.update_route();
         uda.delete_fee_select();
         uda.return_supplier_quote();
     }
     
     public static testMethod void NEU_SQO_Entry()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c;
         Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
         insert d;
         Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
         insert g;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
         insert supquote;
         Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=5);
         insert sup_quote_lines;
         Warehouse__c ware = new Warehouse__c(Name='test warehause', Account_Owner__c = a.Id);
         insert ware;
         warehouse_Storage_Bin__c ware_storage = new Warehouse_Storage_Bin__c(Name='test warehause', Warehouse__c = ware.Id);
         insert ware_storage;
         Shipment__c ship = new Shipment__c(Account_for__c = b.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
         insert ship;
         Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c= g.Id,Units_Shipped__c=10, Supplier_Quote_Line__c = sup_quote_lines.Id, Supplier_Quote__c = supquote.Id);
         insert shipline;
         Inventory_Entry__c sentry = new Inventory_Entry__c(Item__c = g.Id, Shipment_Item_Line__c = shipline.Id, Units_Entry__c=10000,Warehouse_Storage_Bin__c= ware_storage.Id, Warehouse__c = ware.Id);
         insert sentry;
         Inventory_Entry__c sentry2 = new Inventory_Entry__c(Item__c = g.Id, Units_Entry__c=10000,Warehouse_Storage_Bin__c= ware_storage.Id, Warehouse__c = ware.Id);
         insert sentry2;
         NEU_SQO_Entry se = new NEU_SQO_Entry(new ApexPages.StandardController( supquote ));
         se.idLine = sup_quote_lines.Id;
         se.updidLineItem = sup_quote_lines.Id;
         se.idItem = g.Id;
         string decimales = se.decimalSep;
         string miles = se.thousandSep;
         se.cancelLines();
         se.getLines();
         se.newItemSelected();
         
         se.getStockEntries();
         for(NEU_SQO_Entry.Line_s sel: se.getLines())
         {
            sel.selected = true;
            sel.units = 10;
         }
         se.applyLines();
         NEU_SQO_Entry.Warehouse_Storage_Bin_s wsb = new NEU_SQO_Entry.Warehouse_Storage_Bin_s(ware_storage);
         wsb.unitsSep = '1000';
         wsb.units = 100;
         wsb.newUnits = 1000;
         string unidades = wsb.unitsSep;
         string unidades_puntuacion = wsb.newUnitsSep;
         wsb.getId();
         wsb.getWharehouse_Id();
         wsb.getWharehouse_Name();
         wsb.getStorage_Bin();
         wsb.getName();
         wsb.newUnits = 1000;
         
         se.totalunits = se.totalunits;
         se.pendingunits = se.pendingunits;
         se.fullline = se.fullline;
         se.nombreitem = se.nombreitem;
         se.alertuser = se.alertuser;
         
         NEU_SQO_Entry.Line_s new_entry = new NEU_SQO_Entry.Line_s(sup_quote_lines, true,'extension test',10,wsb,sup_quote_lines.Id);
         new_entry.unitsSep = new_entry.unitsSep;
         new_entry.getFinalStock();
         new_entry.getHeaderId();
         new_entry.getItemName();
         new_entry.getFamilyName();
         List<NEU_SQO_Entry.Line_s> new_list_NEU_SQO_Entry_Line_s = new List<NEU_SQO_Entry.Line_s>();
         new_list_NEU_SQO_Entry_Line_s.add(new_entry);
         se.Lines = new_list_NEU_SQO_Entry_Line_s;
         for(NEU_SQO_Entry.Line_s sel: se.Lines)
         {
            sel.selected = true;
            sel.fullline = false;
         }
         se.newItemSelected();
         se.updateStockEntries();
         se.idLineItem = sup_quote_lines.Id;
         se.getStockEntries();
         
        // se.updateStockEntries(); 

     }
     
      public static testMethod void NEU_SQO_Entry2()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c;
         Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
         insert d;
         Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
         insert g;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
         insert supquote;
         Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=10);
         insert sup_quote_lines;

         NEU_SQO_Entry se = new NEU_SQO_Entry(new ApexPages.StandardController( supquote ));
         se.idLine = sup_quote_lines.Id;
         se.updidLineItem = sup_quote_lines.Id;
         se.idItem = g.Id;
         string decimales = se.decimalSep;
         string miles = se.thousandSep;
         se.cancelLines();
         se.getLines();
         se.newItemSelected();
         
         se.getStockEntries();
         for(NEU_SQO_Entry.Line_s sel: se.getLines())
         {
            sel.selected = true;
            sel.units = 10;
         }
         se.applyLines();
         se.updateStockEntries(); 

     }
     
     public static testMethod void test_NEU_Update_conversion_Rate_SQO()
     {
        NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
         Account a = list_accounts[0];
         insert a;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
         insert supquote;
         NEU_Update_conversion_Rate_SQO uda = new NEU_Update_conversion_Rate_SQO(new ApexPages.StandardController( supquote ));
         uda.refresh_lines();
     }
     
     public static testMethod void NEU_OM_SupQuOr_FeeLinesPriceListDiscount_test2()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         ApexPages.currentPage().getParameters().put('test', 'test');
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
         insert supplyproject;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c;
         Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c2;
         Price_List__c price_list2= new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = b.Id);
         insert price_list2;
         Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = price_list2.Id);
         insert d;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id, Customer__c = b.Id);
         insert supquote;
         Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
         insert fee;
         Supplier_Quote_Order_Fee_Line__c sup_quotefeeline = new Supplier_Quote_Order_Fee_Line__c(Name= 'test supquote fee line', Supplier_Quote_Order__c = supquote.Id, Fee_Name__c = fee.Id);
         insert sup_quotefeeline;
         Price_List__c price_list = new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = b.Id);
         insert price_list;
         NEU_OM_SupQuOr_FeeLinesPriceListDiscount uda = new NEU_OM_SupQuOr_FeeLinesPriceListDiscount(new ApexPages.StandardController( supquote ));
         uda.chekeados = true;
         uda.getnewcategories();
         uda.setnewcategory('Disbursement');
         uda.getnewcategory();
         uda.categories();
         uda.getsup_quote_order_feeLines();
         uda.getFee_List_Price();
        
         List<NEU_OM_SupQuOr_FeeLinesPriceListDiscount.Supplier_QuoteOrder_Fee_Line_s> atpd = new List<NEU_OM_SupQuOr_FeeLinesPriceListDiscount.Supplier_QuoteOrder_Fee_Line_s>();
         atpd.add(new NEU_OM_SupQuOr_FeeLinesPriceListDiscount.Supplier_QuoteOrder_Fee_Line_s(sup_quotefeeline,null ,true,'estension test', '10','10', '0','10',null, 'EUR'));
         atpd.add(new NEU_OM_SupQuOr_FeeLinesPriceListDiscount.Supplier_QuoteOrder_Fee_Line_s(sup_quotefeeline,null ,true,'estension test', '10','10', '0','10',null, 'EUR'));
         for(NEU_OM_SupQuOr_FeeLinesPriceListDiscount.Supplier_QuoteOrder_Fee_Line_s lo : atpd)
         {
            lo.selected = true;
         }
         
          for(NEU_OM_SupQuOr_FeeLinesPriceListDiscount.Supplier_QuoteOrder_Fee_Line_s lo : uda.getFee_List_Price())
         {
            lo.selected = true;
         }
       
         uda.crearlineaquoteitem();
         uda.update_route();
     }
     
     static testMethod void NEU_Search_Supplier_Quote_Hidden()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Date_Limit__c = date.newInstance(2001, 3, 21));
         insert supplyproject;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c;
         Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c2;
         Price_List__c price_list2= new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = b.Id);
         insert price_list2;
         Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = price_list2.Id);
         insert d;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id, Customer__c = b.Id, Supplier_Quote_Status__c='Consolidated', RecordTypeId = Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Hidden Quote').getRecordTypeId());
         insert supquote;
         
        NEU_Search_Supplier_Quote_Hidden ssqh = new NEU_Search_Supplier_Quote_Hidden();
        
        Id job_id = System.schedule('test', '0 0 0 30 12 ? 2099', ssqh);
        System.assertNotEquals(null, job_id);
        //ssqh.execute(job_id);
     }
     
     public static testMethod void NEU_CloneSupplierQuoteOrder()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         ApexPages.currentPage().getParameters().put('test', 'test');
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
         insert supplyproject;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c;
         Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c2;
         Price_List__c price_list2= new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = b.Id);
         insert price_list2;
         Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = price_list2.Id);
         insert d;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id, Customer__c = b.Id, Supplier_Quote_Status__c='Consolidated');
         insert supquote;
         Supplier_Quote__c supquote2 = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id, Customer__c = b.Id);
         insert supquote2;
         Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
         insert fee;
         Supplier_Quote_Order_Fee_Line__c sup_quotefeeline = new Supplier_Quote_Order_Fee_Line__c(Name= 'test supquote fee line', Supplier_Quote_Order__c = supquote.Id, Fee_Name__c = fee.Id);
         insert sup_quotefeeline;
         Price_List__c price_list = new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = b.Id);
         insert price_list;
         NEU_CloneSupplierQuoteOrder uda = new NEU_CloneSupplierQuoteOrder(new ApexPages.StandardController( supquote ));
         uda.duplicate_order();
         //uda.splitQuoteLine(supquote.Id,supquote2.Id);
         //uda.splitQuote(supquote.Id);
     }
     
     
     
     static testMethod void NEU_Standard_Duty_Calculator_Suppl_Quote() {
        
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
        
        Supplier_Quote__c supquote = new Supplier_Quote__c( Customer__c = a.Id, Supplier__c = sup.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000);
        insert sup_quote_lines;
        
         
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        
        Supplier_Quote__c supquote2 = new Supplier_Quote__c(Supplier__c=sup.Id, Customer__c = a.Id, Supplier_Quote_Status__c='Consolidated', Route__c=route.Id);
        insert supquote2;
        Supplier_Quote_Line__c sup_quote_lines2 = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote2.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000);
        insert sup_quote_lines2;
        
        NEU_Standard_Duty_Calculator_Suppl_Quote ie = new NEU_Standard_Duty_Calculator_Suppl_Quote(new ApexPages.StandardController( supquote ));
        ie.calcular_tasas();
        ie.refresh();
        ie.volver();
        NEU_Standard_Duty_Calculator_Suppl_Quote ie2 = new NEU_Standard_Duty_Calculator_Suppl_Quote(new ApexPages.StandardController( supquote2 ));
        ie2.calcular_tasas();
        
       }
       
     
     static testMethod void NEU_Standard_Fee_Calculation()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
         insert supplyproject;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c;
         Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c2;
         Price_List__c price_list2= new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = b.Id);
         insert price_list2;
         Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = price_list2.Id);
         insert d;
         Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
         insert Country;
         Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
         insert localizacion;
         Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
         insert route;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id, Customer__c = b.Id, Supplier_Quote_Status__c='Consolidated', Route__c=route.Id);
         insert supquote;
         Supplier_Quote__c supquote2 = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id, Customer__c = b.Id);
         insert supquote2;
         Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
         insert fee;
         Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Standard_Rate__c=true, Account_for__c = a.Id);
         insert fee2;
         Supplier_Quote_Order_Fee_Line__c sup_quotefeeline = new Supplier_Quote_Order_Fee_Line__c(Name= 'test supquote fee line', Supplier_Quote_Order__c = supquote.Id, Fee_Name__c = fee.Id);
         insert sup_quotefeeline;
         Supplier_Quote_Order_Fee_Line__c sup_quotefeeline2 = new Supplier_Quote_Order_Fee_Line__c(Name= 'test supquote fee line',
         Supplier_Quote_Order__c = supquote.Id, Fee_Name__c = fee2.Id);
         insert sup_quotefeeline2;
         Price_List__c price_list = new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = b.Id);
         insert price_list;
         
         List<Fee__c> list_service_rate = new List<Fee__c>();
         Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add( fee4);
         Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee5);
         Fee__c fee17 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee17);
         Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee3);
         Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee15); 
         Fee__c fee16 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee16); 
         Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee6); 
         Fee__c fee19 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee19); 
         Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee7); 
         Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee8); 
         Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee9); 
         Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee10); 
         Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee11);
         Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee12);
         Fee__c fee18 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id);
         list_service_rate.add(  fee18);
         insert list_service_rate;
         NEU_Standard_Fee_Calculation uda = new NEU_Standard_Fee_Calculation(new ApexPages.StandardController( supquote ));
        
         uda.crear_fee_estandar();
         
         uda.cancel();
         NEU_Standard_Fee_Calculation sfc = new NEU_Standard_Fee_Calculation(supquote2);
    //     uda.NEU_Standard_Fee_Calculation(supquote);
         
     }
     
     
       public static testMethod void NEU_OM_Shipment_Management_test()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Master_Box_Length_cm__c=1000, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c=10 );
        insert item;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Pallet_Container_Type__c pallet_container2 = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container2;
        Item_Pallet_Type__c item_pallet = new Item_Pallet_Type__c(Name='item pallet', Item_Name__c=item.Id, Packages_Pallet__c=10, Pallet_Type__c=pallet.Id);
        insert item_pallet;
        Supplier_Quote__c sup_quote = new Supplier_Quote__c(Supplier__c = sup.Id, Supplier_Quote_Status__c = 'Approved', Max_Deliveries__c = 10);
        insert sup_quote;//supplier Max_Shipment__c
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=sup_quote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000);
        insert sup_quote_lines;
        Supplier_Quote__c sup_quote2 = new Supplier_Quote__c(Supplier__c = sup.Id, Supplier_Quote_Status__c = 'Approved', Customer__c=a.Id);
        insert sup_quote2;//customer
        Supplier_Quote_Line__c sup_quote_lines2 = new Supplier_Quote_Line__c(Supplier_Quote__c=sup_quote2.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000);
        insert sup_quote_lines2;
        NEU_OM_Shipment_Management uda = new NEU_OM_Shipment_Management(new ApexPages.StandardController( sup_quote ));
        uda.setcontainer_selected(pallet_container.Id);
        uda.getcontainer_selected();
        uda.getcontainers();
        uda.setNumero_shipment_selected('1');
        uda.getNumero_shipment_selected();
        uda.getNumero_shipment();
        uda.getlistado_supplierquoteline();
        Supplier_Quote_Line__c sup_quote_lines3 = new Supplier_Quote_Line__c(Supplier_Quote__c=sup_quote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=10000);
        insert sup_quote_lines3;
        Supplier_Quote_Line__c sup_quote_lines4 = new Supplier_Quote_Line__c(Supplier_Quote__c=sup_quote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=10000);
        insert sup_quote_lines4;
        
        uda.Recalcular();
      //  NEU_OM_Shipment_Management.splitSupQuoteLine(sup_quote_lines3.Id,10, null, 1, 'observations test');
        uda.Actualizar_lineas();
        uda.cancelar();
        uda.guardar_nuevos_deliverys();
        uda.decimalSep = uda.decimalSep;
        uda.thousandSep = uda.thousandSep;
        
        NEU_OM_Shipment_Management.supplier_quote_line_s new_su_qu_li = new NEU_OM_Shipment_Management.supplier_quote_line_s (sup_quote_lines, item, true, 'test observacion', 10,10 ,10 ,10 ,10,
        10,false,'',null,'',system.today(), '','',10,10,10,10,10);
        new_su_qu_li.totalpesoSep =  new_su_qu_li.totalpesoSep; 
        
        new_su_qu_li.unidades_x_caja_lineaSep =  new_su_qu_li.unidades_x_caja_lineaSep;
        new_su_qu_li.totalcajasSep =  new_su_qu_li.totalcajasSep;
        new_su_qu_li.cantidad_inicialSep =  new_su_qu_li.cantidad_inicialSep;
        new_su_qu_li.UnitsSep =  new_su_qu_li.UnitsSep;
        new_su_qu_li.supplySep =  new_su_qu_li.supplySep;
        new_su_qu_li.total_pallet_lineaSep =  new_su_qu_li.total_pallet_lineaSep;
        
        new_su_qu_li.volumen_master_boxSep =  new_su_qu_li.volumen_master_boxSep;
        
        
        //NEU_OM_Shipment_Management.splitSupQuoteLine(sup_quote_lines.Id,10, null,'1', 'obser test');
     }
     
      public static testMethod void testNEU_OM_FollowersSupplierQuote() {//ok
      	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        
        Account b = list_accounts[1];
        insert b;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id);
        insert supquote;
        List<EntitySubscription> entitysubcription = [select Id, SubscriberId from EntitySubscription where SubscriberId =: UserInfo.getUserId() limit 10];

        NEU_OM_FollowersSupplierQuote uda = new NEU_OM_FollowersSupplierQuote(new ApexPages.StandardController( supquote ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
  }
  
    public static testMethod void testNEU_OM_FollowersSupplierQuote2() {//ok
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Account b = list_accounts[1];
        insert b;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id);
        insert supquote;
        List<EntitySubscription> entitysubcription = [select Id, SubscriberId from EntitySubscription where SubscriberId =: UserInfo.getUserId() limit 10];

        NEU_OM_FollowersSupplierQuote uda = new NEU_OM_FollowersSupplierQuote(new ApexPages.StandardController( supquote ));
        List<NEU_OM_FollowersSupplierQuote.follower_s> lista_de_followers = new List<NEU_OM_FollowersSupplierQuote.follower_s>();
        List<User> listauser = [select id, Name from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersSupplierQuote.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersSupplierQuote.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersSupplierQuote.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersSupplierQuote.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersSupplierQuote.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
  }
  
  
  
   static testMethod void test_NEU_OM_Sup_Quote_OrderSteps() 
       {
       	NEU_StaticVariableHelper.setBoolean1(true);
          ApexPages.currentPage().getParameters().put('test', 'test');
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
          insert supquote;
          
          NEU_OM_Sup_Quote_OrderSteps gpcc = new NEU_OM_Sup_Quote_OrderSteps(new ApexPages.StandardController( supquote ));
          gpcc.todorelleno = true;
          gpcc.condescuento = true;
          gpcc.condescuentocreate = true;
          gpcc.urlCQLPriceList = 'testurl';
          gpcc.urlCreateItemsLines = 'testurlcreateitems';
          system.debug( 'Prueba realizada' );
         
       }
       
        static testMethod void test_NEU_OM_Start_Clearance_SupplierQuote() {
      NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id);
        insert supquote;
        Product_Family__c family = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Auto-Parts');
        insert family;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id, Weight_Kgs__c=10 );
        insert item;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000);
        insert sup_quote_lines;
        
        NEU_OM_Start_Clearance_SupplierQuote uda = new NEU_OM_Start_Clearance_SupplierQuote(new ApexPages.StandardController( supquote ));
        uda.idlineaitem = sup_quote_lines.Id;
        uda.getlist_category();
        uda.getlista_subcategorias();
        uda.getlista_items();
        uda.getDutyCalculatorInfo();
        uda.getshipmentItemLines();
        uda.getshipmentItemLines2();
        uda.applyLines();
        uda.calculate_taxes ();
        uda.calcular_hs_codes();
    }
    
      static testMethod void test_NEU_OM_Save_Generate_Quote_Order () 
       {
       	NEU_StaticVariableHelper.setBoolean1(true);
          ApexPages.currentPage().getParameters().put('test', 'test');
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
          insert supquote;
          
          NEU_OM_Save_Generate_Quote_Order  sgqo = new NEU_OM_Save_Generate_Quote_Order (new ApexPages.StandardController( supquote ));
          Blob b = Blob.valueOf('Test Data');
          sgqo.documento_asociado.Name='Test document.test';
          sgqo.documento_asociado.AuthorId = UserInfo.getUserId();
          sgqo.documento_asociado.IsPublic=true;
          sgqo.documento_asociado.Body = b;
          sgqo.crear();
          system.debug( 'Prueba realizada' );
         
       }
       
       static testMethod void test_NEU_OM_Save_Generate_Quote_Order_pdf  () 
       {
       	NEU_StaticVariableHelper.setBoolean1(true);
          ApexPages.currentPage().getParameters().put('test', 'test');
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
          insert supquote;
          Product_Family__c family = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Auto-Parts');
          insert family;
          Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
          insert subfamily;
          Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id, Weight_Kgs__c=10 );
          insert item;
          Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000);
          insert sup_quote_lines;
        
          NEU_OM_Save_Generate_Quote_Order_pdf   sgqo = new NEU_OM_Save_Generate_Quote_Order_pdf  (new ApexPages.StandardController( supquote ));
          
          
       }
    
}