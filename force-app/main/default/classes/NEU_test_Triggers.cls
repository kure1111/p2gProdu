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
private class NEU_test_Triggers {

    @IsTest(SeeAllData=true) public static void NEU_OM_Create_Feed() //ok
     {
        
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Chatter_Feed_Guest_User__c feeguest = new Chatter_Feed_Guest_User__c(Feed_Text__c='test', Record_Id__c= importexportquote.Id );
        test.startTest();
            insert feeguest;
            feeguest.Feed_Text__c='test2';
            feeguest.Record_Id__c=importexportquote.Id;
            update feeguest;
         test.stopTest();
     }
     
     static testMethod void NEU_Update_Vehicle_Address() //ok
     {
           Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
           insert vehicle;
           update vehicle;
     }
     
	static testMethod void NEU_Update_IE_Cargo_Invoice_Lines_Conversion_Rate() //ok
	{
		List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = account_test.Id;
        importexportquote.Quotation_Status__c = 'Quote being prepared'; 
        importexportquote.Origin_Address__c = '';
        importexportquote.Destination_Address__c = '';
        importexportquote.Only_Warehouse_Service__c = true;
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'MXN');  
        insert importexportquote;
        
        Quote_Item_Line__c quote_item = new Quote_Item_Line__c();
        quote_item.Import_Export_Quote__c = importexportquote.Id;
        quote_item.Name = 'lineas items';
        insert quote_item;
        
        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
        Invoice__c new_invoice = new Invoice__c();
        new_invoice.Name = 'test';
        new_invoice.Import_Export_Quote_Order__c = importexportquote.Id; 
        new_invoice.Shipment__c = ship.Id;
        new_invoice.Account__c = account_test.Id;
        new_invoice.Date_of_Invoice__c = system.today();
        insert new_invoice;
        
     	Import_Export_Item_Line_Invoice__c ie_item_line_invoice = new Import_Export_Item_Line_Invoice__c();
     	ie_item_line_invoice.Amount_Allocated__c = 10;
     	ie_item_line_invoice.Conversion_Rate_to_Cargo_Line_Currency__c = 1; 
     	ie_item_line_invoice.Import_Export_Item_Line__c = quote_item.Id;
     	ie_item_line_invoice.Invoice__c = new_invoice.Id;
     	insert ie_item_line_invoice;
	}
     
	static testMethod void NEU_Update_Invoice_Lines_Conversion_Rate () //ok
    {
		List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = account_test.Id;
        importexportquote.Quotation_Status__c = 'Quote being prepared'; 
        importexportquote.Origin_Address__c = '';
        importexportquote.Destination_Address__c = '';  
        importexportquote.Only_Warehouse_Service__c = true;
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'MXN');  
        insert importexportquote;
        
        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
        Invoice__c new_invoice = new Invoice__c();
        new_invoice.Name = 'test';
        new_invoice.Import_Export_Quote_Order__c = importexportquote.Id;
        new_invoice.Shipment__c = ship.Id; 
        new_invoice.Account__c = account_test.Id;
        new_invoice.Date_of_Invoice__c = system.today();
        insert new_invoice;
        
        Fee__c fee = new Fee__c();
        fee.Name = 'test fees';
        fee.Fee_Category__c = 'Disbursement'; 
        fee.Rate_Type__c = '% of Charge';
        fee.Account_for__c = account_test.Id;
        insert fee;
        
        Import_Export_Fee_Line__c quote1 = new Import_Export_Fee_Line__c();
        quote1.Import_Export_Quote__c = importexportquote.Id;
        quote1.Name = 'lineas items';
        quote1.Service_Rate_Name__c = fee.Id;
        insert quote1;
        
     	Import_Export_Service_Line_Invoice__c ie_service_line_invoice = new Import_Export_Service_Line_Invoice__c();
     	ie_service_line_invoice.Amount_Allocated__c = 10;
     	ie_service_line_invoice.Conversion_Rate_to_Service_Line_Currency__c = 1; 
     	ie_service_line_invoice.Import_Export_Service_Line__c = quote1.Id;
     	ie_service_line_invoice.Invoice__c = new_invoice.Id;
     	insert ie_service_line_invoice;
	}
     
	static testMethod void NEU_Update_Invoice_Ship_Lines_Conversion_Rate() //ok
    {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = b;
        account_test.Credit_Terms__c = '15 days';
        insert account_test;

        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = account_test.Id;
        importexportquote.Quotation_Status__c = 'Quote being prepared';
        importexportquote.Origin_Address__c = '';
        importexportquote.Destination_Address__c = '';
        importexportquote.Only_Warehouse_Service__c = true;
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'MXN');
        insert importexportquote;

        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;

        Invoice__c new_invoice = new Invoice__c();
        new_invoice.Name = 'test';
        new_invoice.Import_Export_Quote_Order__c = importexportquote.Id;
        new_invoice.Shipment__c = ship.Id;
        new_invoice.Account__c = account_test.Id;
        new_invoice.Date_of_Invoice__c = system.today();
        insert new_invoice;

        Fee__c fee = new Fee__c();
        fee.Name = 'test fees';
        fee.Fee_Category__c = 'Disbursement';
        fee.Rate_Type__c = '% of Charge';
        fee.Account_for__c = account_test.Id;
        insert fee;

        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c();
        shipfeeline.Name = 'test shipment fee line';
        shipfeeline.Import_Export_Quote__c = importexportquote.Id;
        shipfeeline.Discount_Charge__c = 8;
        shipfeeline.Extension_Service_Name__c = 'test extension';
        shipfeeline.Service_Rate_Name__c = fee.Id;
        shipfeeline.Shipment__c = ship.Id;
        shipfeeline.Shipment_Sell_Price__c = 10;
        shipfeeline.Units__c = 10;
        shipfeeline.Shipment_Buy_Price__c = 10;
        insert shipfeeline;

     	Invoice_Service_Line__c invoice_service = new Invoice_Service_Line__c();
     	invoice_service.Amount__c = 10;
     	invoice_service.Conversion_Rate_to_Service_Line_Currency__c = 1;
     	invoice_service.Invoice__c = new_invoice.Id;
     	invoice_service.Shipment_Service_Line__c = shipfeeline.Id;
     	insert invoice_service;
     }

	static testMethod void NEU_Update_Shipment_Cargo_Invoice_Lines_Conversion_Rate() //ok
	{
     	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;

        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = account_test.Id;
        importexportquote.Quotation_Status__c = 'Quote being prepared';
        importexportquote.Origin_Address__c = '';
        importexportquote.Destination_Address__c = '';
        importexportquote.Only_Warehouse_Service__c = true;
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'MXN');
        insert importexportquote;

        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;

        Invoice__c new_invoice = new Invoice__c();
        new_invoice.Name = 'test';
        new_invoice.Import_Export_Quote_Order__c = importexportquote.Id;
        new_invoice.Shipment__c = ship.Id;
        new_invoice.Account__c = account_test.Id;
        new_invoice.Date_of_Invoice__c = system.today();
        insert new_invoice;

        Shipment_Line__c shipline = new Shipment_Line__c();
        shipline.Shipment__c = ship.Id;
        shipline.Name = 'test ship line';
        insert shipline;

     	Invoice_Item_Line__c invoice_item_line = new Invoice_Item_Line__c();
     	invoice_item_line.Amount__c = 10;
     	invoice_item_line.Conversion_Rate_to_Cargo_Line_Currency__c = 1;
     	invoice_item_line.Invoice__c = new_invoice.Id;
     	invoice_item_line.Shipment_Item_Line__c = shipline.Id;
     	insert invoice_item_line;
	}


     public static void NEU_Update_IE_Route() //ok
     {
          Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = acc;
          insert a;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
          insert importexportquote2;
          Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
          insert shipconsodata;
          shipconsodata.Import_Export_Quote__c = importexportquote2.Id;
          update shipconsodata;
     }

      public static void NEU_Update_IE_Total_Shipments_Services_Buy_Amount() //ok
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          insert a;
          Account carrier = list_accounts[1];
          insert carrier;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id, Carrier_Account__c = carrier.Id);
          insert fee;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
          insert importexportquote2;
          Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Import_Export_Quote__c =importexportquote.Id, Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
          insert shipfeeline;
          shipfeeline.Import_Export_Quote__c = importexportquote2.Id;
          update shipfeeline;
          delete shipfeeline;
     }


     static testMethod void NEU_IE_Fee_Line_Principal_delete()
     {
          Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = acc;
          insert a;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id);
          insert fee;
          Import_Export_Fee_Line__c quote1 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
          insert quote1;
          Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Import_Export_Service_Line__c = quote1.Id);
          insert quote2;
          delete quote1;
     }

     static testMethod void NEU_Update_Total_Disbursement_Excl_VAT()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id);
          insert shipdis;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Disbursement_Line__c dis_line = new Disbursement_Line__c(Disbursement__c = shipdis.Id, Shipment__c= ship.Id, Import_Export_Quote_Order__c =importexportquote.Id , Amount__c =100);
          insert dis_line;
          dis_line.Amount__c = 1000;
          update dis_line;
          delete dis_line;

     }

     static testMethod void NEU_Update_Disbursement_Lines_Conversion_Rate()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id);
          insert shipdis;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id, Fee__c = 10);
          insert fee;
          Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Quote_Sell_Price__c= 10, Units__c = 10);
          insert quote;
          Import_Export_Service_Line_Disbursement__c ie_service_line_disburser = new Import_Export_Service_Line_Disbursement__c(Disbursement__c = shipdis.Id, Import_Export_Service_Line__c = quote.Id);
          insert ie_service_line_disburser;
     }

     static testMethod void NEU_Update_Disbursement_IE_Cargo_Lines_Conversion_Rate()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id);
          insert shipdis;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Quote_Item_Line__c quote_item = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
          insert quote_item;
          Import_Export_Cargo_Line_Disbursement__c ie_line_disbursement = new Import_Export_Cargo_Line_Disbursement__c(Disbursement__c = shipdis.Id, Import_Export_Cargo_Line__c = quote_item.Id);
          insert ie_line_disbursement;
     }

     static testMethod void NEU_IE_Fee_Line_Principal_update()
     {
          Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = acc;
          insert a;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id, Fee__c = 10);
          insert fee;
          Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Quote_Sell_Price__c= 10, Units__c = 10);
          insert quote;
          Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Import_Export_Service_Line__c = quote.Id);
          insert quote2;
          quote.Quote_Sell_Price__c = 100;
          update quote;

     }

     static testMethod void NEU_IE_Fee_Line_Principal_update2()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id);
          insert shipdis;
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Disbursement_Line__c dis_line = new Disbursement_Line__c(Disbursement__c = shipdis.Id, Shipment__c= ship.Id, Import_Export_Quote_Order__c =importexportquote.Id , Amount__c =100);
          insert dis_line;

     }

     static testMethod void NEU_Shipment_Fee_Line_Principal_delete()
     {
          Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = acc;
          insert a;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id);
          insert fee;
          Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
          insert shipfeeline;
          Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10,    Shipment_Service_Line__c  = shipfeeline.Id);
          insert shipfeeline2;
          delete shipfeeline;
     }

     static testMethod void NEU_Shipment_Fee_Line_Principal_update()
     {
          Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = acc;
          insert a;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id);
          insert fee;
          Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
          insert shipfeeline;
          Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10,   Shipment_Service_Line__c  = shipfeeline.Id);
          insert shipfeeline2;
          shipfeeline.Shipment_Sell_Price__c = 100;
          update shipfeeline;

     }

     static testMethod void NEU_EmailAlertsShipment()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          insert a;
          Account carrier = list_accounts[1];
          insert carrier;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', RecordTypeId = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Request').getRecordTypeId(), Only_Warehouse_Service__c = true);
          insert ship;
          ship.RecordTypeId = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Quote').getRecordTypeId();
          update ship;
          ship.RecordTypeId = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Order').getRecordTypeId();
          update ship;

     }

     static testMethod void NEU_Import_Export_ContainerType_to_Size()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          a.ActiveSap__c = true;
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Container_Size__c = '20" Container');
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Quote being prepared', Container_Size__c = '20" Container', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
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
     }

     static testMethod void NEU_ShipmentContainerType_to_Size()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          insert a;
          Account carrier = list_accounts[1];
          insert carrier;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Container_Size__c = '20" Container', Only_Warehouse_Service__c = true);
          insert ship;
     }

     static testMethod void NEU_Import_export_Update_Route()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          a.ActiveSap__c = true;
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country;
          Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country2;
          Country__c Country3 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country3;
          Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion;
          Location__c localizacion2 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion2;
          Location__c localizacion3 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion3;
          Location__c localizacion4 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion4;
          Location__c localizacion5 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country3.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion5;
          Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
          insert route;

          //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Route__c = route.Id, Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Quote being prepared', Route__c = route.Id, Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
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

          /*Customer_Quote__c importexportquote2 = new Customer_Quote__c( Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '');
          insert importexportquote2;
          Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items',Units__c=10);
          insert quote2;

		Import_Export_Fee_Line__c ie_service_line2 = new Import_Export_Fee_Line__c();
		ie_service_line2.Import_Export_Quote__c = importexportquote2.Id;
		ie_service_line2.Name = '001';
		ie_service_line2.Service_Rate_Name__c = service_rate.Id;
		ie_service_line2.Extension_Service_Name__c = 'Test Name';
		ie_service_line2.Discount__c = 10;
		ie_service_line2.Quote_Buy_Price__c = 10;
		ie_service_line2.Quote_Sell_Price__c = 10;
		ie_service_line2.Units__c = 10;
        insert ie_service_line2;

          importexportquote2.Quotation_Status__c ='Approved as Succesful';
          update importexportquote2;

          //Customer_Quote__c importexportquote3 = new Customer_Quote__c( Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful',  Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
          Customer_Quote__c importexportquote3 = new Customer_Quote__c( Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared',  Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '');
          insert importexportquote3;
          Quote_Item_Line__c quote3 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote3.id,Name = 'lineas items',Units__c=10);
          insert quote3;

		Import_Export_Fee_Line__c ie_service_line3 = new Import_Export_Fee_Line__c();
		ie_service_line3.Import_Export_Quote__c = importexportquote3.Id;
		ie_service_line3.Name = '001';
		ie_service_line3.Service_Rate_Name__c = service_rate.Id;
		ie_service_line3.Extension_Service_Name__c = 'Test Name';
		ie_service_line3.Discount__c = 10;
		ie_service_line3.Quote_Buy_Price__c = 10;
		ie_service_line3.Quote_Sell_Price__c = 10;
		ie_service_line3.Units__c = 10;
        insert ie_service_line3;

          importexportquote3.Quotation_Status__c ='Approved as Succesful';
          update importexportquote3;

          //Customer_Quote__c importexportquote4 = new Customer_Quote__c( Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful',  Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country2.Id , Country_ofDischarge__c = Country2.Id);
          Customer_Quote__c importexportquote4 = new Customer_Quote__c( Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared',  Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country2.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '');
          insert importexportquote4;
          Quote_Item_Line__c quote4 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote4.id,Name = 'lineas items',Units__c=10);
          insert quote4;

		Import_Export_Fee_Line__c ie_service_line4 = new Import_Export_Fee_Line__c();
		ie_service_line4.Import_Export_Quote__c = importexportquote4.Id;
		ie_service_line4.Name = '001';
		ie_service_line4.Service_Rate_Name__c = service_rate.Id;
		ie_service_line4.Extension_Service_Name__c = 'Test Name';
		ie_service_line4.Discount__c = 10;
		ie_service_line4.Quote_Buy_Price__c = 10;
		ie_service_line4.Quote_Sell_Price__c = 10;
		ie_service_line4.Units__c = 10;
        insert ie_service_line4;

          importexportquote4.Quotation_Status__c ='Approved as Succesful';
          update importexportquote4;

          //Customer_Quote__c importexportquote5 = new Customer_Quote__c( Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful',  Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country2.Id , Country_ofDischarge__c = Country2.Id);
          Customer_Quote__c importexportquote5 = new Customer_Quote__c( Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared',  Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country2.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '');
          insert importexportquote5;
          Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items',Units__c=10);
          insert quote5;

		Import_Export_Fee_Line__c ie_service_line5 = new Import_Export_Fee_Line__c();
		ie_service_line5.Import_Export_Quote__c = importexportquote5.Id;
		ie_service_line5.Name = '001';
		ie_service_line5.Service_Rate_Name__c = service_rate.Id;
		ie_service_line5.Extension_Service_Name__c = 'Test Name';
		ie_service_line5.Discount__c = 10;
		ie_service_line5.Quote_Buy_Price__c = 10;
		ie_service_line5.Quote_Sell_Price__c = 10;
		ie_service_line5.Units__c = 10;
        insert ie_service_line5;

          importexportquote5.Quotation_Status__c ='Approved as Succesful';
          update importexportquote5;

          importexportquote4.Site_of_Load__c = localizacion4.Id;
          update importexportquote4;*/
     }

      static testMethod void NEU_Import_export_Update_Route2()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          a.ActiveSap__c = true;
          insert a;
          Account sup = list_accounts[1];
          insert sup;
          Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country;
          Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country2;
          Country__c Country3 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country3;
          Country__c Country4 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country4;
          Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion;
          Location__c localizacion2 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion2;
          Location__c localizacion3 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion3;
          Location__c localizacion4 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion4;
          Location__c localizacion5 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country3.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion5;
          Location__c localizacion6 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country4.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion6;
          Carrier_Line_Load_Point__c route_leg1 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id );
          insert route_leg1;
          Carrier_Line_Load_Point__c route_leg2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion3.Id, Port_Airport_of_Load__c=localizacion.Id);
          insert route_leg2;
          Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion3.Id, Port_Airport_of_Load__c=localizacion.Id);
          insert route;

          //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
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
          importexportquote.Site_of_Discharge__c = null;
          update importexportquote;

          //Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
          Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote2;
          Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items',Units__c=10);
          insert quote2;

		Import_Export_Fee_Line__c ie_service_line2 = new Import_Export_Fee_Line__c();
		ie_service_line2.Import_Export_Quote__c = importexportquote2.Id;
		ie_service_line2.Name = '001';
		ie_service_line2.Service_Rate_Name__c = service_rate.Id;
		ie_service_line2.Extension_Service_Name__c = 'Test Name';
		ie_service_line2.Discount__c = 10;
		ie_service_line2.Quote_Buy_Price__c = 10;
		ie_service_line2.Quote_Sell_Price__c = 10;
		ie_service_line2.Units__c = 10;
        insert ie_service_line2;

          importexportquote2.Quotation_Status__c ='Approved as Succesful';
          update importexportquote2;


     }

     static testMethod void NEU_Shipment_Program_copy()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          insert a;
          Account carrier = list_accounts[1];
          insert carrier;
          Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
          insert ship_prog;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Container_Size__c = '20" Container', Inbound_Consolidation_Program__c = ship_prog.Id, Only_Warehouse_Service__c = true);
          insert ship;
          Customer_Quote__c  importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c(Import_Export_Quote__c = importexportquote.Id , Shipment__c =ship.Id, Shipments_Program__c = ship_prog.Id );
          insert new_shipment_consolidation_data;
          ship_prog.Truck_Number__c = 'test';
          ship_prog.Planned_ETD__c = system.today();
          update ship_prog;
     }

     static testMethod void NEU_Shipment_Update_Route()
     {
          Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = acc;
          insert a;
          Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country;
          Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country2;
          Country__c Country3 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country3;
          Country__c Country4 = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country4;
          Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion;
          Location__c localizacion2 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion2;
          Location__c localizacion3 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion3;
          Location__c localizacion4 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion4;
          Location__c localizacion5 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country3.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion5;
          Location__c localizacion6 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country4.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion6;
          Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
          insert route;
          List<Shipment__c>ships=new List<Shipment__c>();
          Shipment__c ship = new Shipment__c( Account_for__c = a.Id, Route__c = route.Id, Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion2.Id , Country_of_Load__c= Country.Id , Country_of_Discharge__c = Country.Id, Only_Warehouse_Service__c = true);
          ships.add(ship);
          Shipment__c ship2 = new Shipment__c( Account_for__c = a.Id, Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_of_Load__c= Country.Id , Country_of_Discharge__c = Country2.Id, Only_Warehouse_Service__c = true);
          ships.add(ship2);
          Shipment__c ship3 = new Shipment__c( Account_for__c = a.Id, Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_of_Load__c= Country.Id , Country_of_Discharge__c = Country2.Id, Only_Warehouse_Service__c = true);
          ships.add(ship3);
          Shipment__c ship4 = new Shipment__c( Account_for__c = a.Id, Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_of_Load__c= Country2.Id , Country_of_Discharge__c = Country2.Id, Only_Warehouse_Service__c = true);
          ships.add(ship4);
          Shipment__c ship5 = new Shipment__c( Account_for__c = a.Id, Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_of_Load__c= Country2.Id , Country_of_Discharge__c = Country2.Id, Only_Warehouse_Service__c = true);
          ships.add(ship5);
          insert ships;
          Carrier_Line_Load_Point__c route_leg1 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id );
          insert route_leg1;
          Carrier_Line_Load_Point__c route_leg2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion3.Id, Port_Airport_of_Load__c=localizacion.Id);
          insert route_leg2;
          Carrier_Line_Load_Point__c route2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion3.Id, Port_Airport_of_Load__c=localizacion.Id);
          insert route2;
          ships.clear();
          Shipment__c ship6 = new Shipment__c( Account_for__c = a.Id, Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_of_Load__c= Country2.Id , Country_of_Discharge__c = Country2.Id, Only_Warehouse_Service__c = true);
          ships.add(ship6);
          Shipment__c ship7 = new Shipment__c( Account_for__c = a.Id,  Site_of_Load__c = localizacion3.Id, Site_of_Discharge__c = localizacion3.Id , Country_of_Load__c= Country2.Id , Country_of_Discharge__c = Country2.Id, Only_Warehouse_Service__c = true);
          ships.add(ship7);
          insert ships;
          ship6.Site_of_Discharge__c = null;
          update ship6;
     }

     static testMethod void NEU_Shipment_Fee_Line_copies()
     {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10);
        insert shipfeeline;
        Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10);
        insert shipfeeline2;
     }

     static testMethod void NEU_Ship_Prog_Service_Update_Conversions()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
          Account a = list_accounts[0];
          insert a;
          Account carrier = list_accounts[1];
          insert carrier;
          Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2);
          insert ship_prog;
          Shipment_Program_Line__c  ship_prog_line = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog.Id, Units__c = 10);
          insert ship_prog_line;
          update ship_prog_line;

     }

      static testMethod void NEU_Update_Amount() //ok
     {
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
          Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
          insert route;

          //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Route__c = route.Id);
          Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Route__c = route.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
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

          Discount_Rule__c dr = new Discount_Rule__c (Name='test discount' );
          insert dr;
          Import_Export_Discount_Line__c  iedl = new Import_Export_Discount_Line__c  (Discount_Rule__c = dr.Id, Import_Export_Quote_Order__c = importexportquote.Id , Amount_copy__c =10 , Discount__c = 10 );
          insert iedl ;
     }

     static testMethod void NEU_MD_IEQ_RT() //ok
     {

            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
            Account a = list_accounts[0];
            a.ActiveSap__c = true;
            insert a;
           	Account sup = list_accounts[1];
            insert sup;
            //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful');
            Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
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

            importexportquote.Quotation_Status__c='Approved as Succesful';
            update importexportquote;

            importexportquote.Quotation_Status__c='Quote being prepared';
            update importexportquote;
     }

     static testMethod void NEU_OM_CalculateTotalFeesImportExport() //ok
     {

            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
            Account a = list_accounts[0];
            a.ActiveSap__c = true;
            insert a;
            Account sup = list_accounts[1];
            insert sup;
            Price_List__c b = new Price_List__c(Name = 'Test acount', Items_Account_Owner__c = a.Id);
            insert b;
            Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = a.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
            insert importexportquote;
            Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
            insert c;
            Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
            insert d;
            Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
            insert quote;
            Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
            insert fee;
            Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
            insert quote2;
            Import_Export_Fee_Line__c Import_Export_Fee_Line = new Import_Export_Fee_Line__c();
            Import_Export_Fee_Line = [select Id, Name, Sell_Amount__c from Import_Export_Fee_Line__c limit 1];
            Import_Export_Fee_Line__c iefl = new Import_Export_Fee_Line__c();

            delete quote2;

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

            importexportquote.Quotation_Status__c='Approved as Succesful';
            update importexportquote;
    }

    static testMethod void NEU_JE_Update_Import_Export_Addresses ()
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,Transporter,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account a2 = list_accounts[1];
        insert a2;
        Account a3 = list_accounts[2];
        insert a3;
        Account a4 = list_accounts[3];
        insert a4;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Account_Address__c ad=new Account_Address__c(Account__c=a.id,Address__c='test',Type__c='Shipping Address');
        insert ad;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Supplier_Account__c= a3.Id,Destination_Address__c='test' ,Origin_Address__c='',Account_Origin_Address__c=ad.id,Consignee__c=a.id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Supplier_Account__c= a3.Id,Origin_Address__c='',Consignee__c=a.id,Account_Destination_Address__c=ad.id, Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote2;
        Customer_Quote__c importexportquote3 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Supplier_Account__c= a3.Id,Origin_Address__c='',Consignee__c=a.id, Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote3;
        importexportquote.Supplier_Account__c= a4.Id;
        update importexportquote;
        importexportquote2.Supplier_Account__c= a4.Id;
        importexportquote2.Destination_Address__c = null;
        update importexportquote2;
        importexportquote3.Supplier_Account__c= a4.Id;
        importexportquote3.Destination_Address__c = null;
        update importexportquote3;
     }

     static testMethod void NEU_Fields_copy_item_to_production_plan()
     {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a =list_accounts[0];
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
        g.Forecasting_Unit__c = 'Packaging/Container Unit';
        update g;

     }

     static testMethod void NEU_Check_Standard_Fees()
     {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        insert a;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Active__c = true, Standard_Rate__c = true, Route__c= route.Id, Account_for__c = a.Id);
        insert fee2;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Active__c = true, Standard_Rate__c = true, Route__c= route.Id, Account_for__c = a.Id);
        insert fee;
     }
     
     static testMethod void NEU_ImportExport_Update_Lines_Margin ()
     {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address', Margin_at_Destination_by_Default__c=10);//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote2;
        Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items');
        insert quote2;
        importexportquote.Margin_at_Destination_by_Default__c = 10;
        update importexportquote;
     }
     
     static testMethod void NEU_OM_UpdateFoLaborProgram ()
     {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        a.Account_Executive_User__c = userinfo.getUserId();
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        NEU_Factory__c line_factory = new NEU_Factory__c(Name='test factroy', Account_Owner__c = a.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert line_factory;
        Labor_Program__c labor_program = new Labor_Program__c(Bank_Holidays__c = 10, External_Legal_days__c = 10, Factory_Line__c =line_factory.Id , Equipment_Process_Trial_Scheduled_Mo__c=10);
        insert labor_program;
     }
     
     static testMethod void NEU_Shipment_Update_Lines_Margin ()
     {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        a.Account_Executive_User__c = userinfo.getUserId();
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import',Margin_at_Destination_by_Default__c =0, Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        ship.Margin_at_Destination_by_Default__c = 10;
        update ship;
     }
     
     static testMethod void NEU_JE_Update_Shipment_Addresses ()
     {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account carrier = list_accounts[1];
        insert carrier;
        Account_Address__c ad=new Account_Address__c(Account__c=a.id,Address__c='test',Type__c='Shipping Address');
        insert ad;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Supplier_Account__c= carrier.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Origin_Address__c='test', Destination_Address__c ='test', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Supplier_Account__c= carrier.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Consignee__c=a.id, Destination_Address__c ='test', Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment__c ship3 = new Shipment__c(Account_for__c = a.Id, Supplier_Account__c= carrier.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Origin_Address__c='test',Consignee__c=a.id,Account_Destination_Address__c=ad.id, Only_Warehouse_Service__c = true);
        insert ship3;
        
     }
     
     static testMethod void NEU_Conversion_Rate_Disbursement_Date()
     {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id, Invoice_Date__c= system.today(),Import_Export_Quote_Order__c =importexportquote.Id);
        insert shipdis;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id, Fee__c = 10);
        insert fee;
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Quote_Sell_Price__c= 10, Units__c = 10);
        insert quote;
        Import_Export_Service_Line_Disbursement__c ie_service_line_disburser = new Import_Export_Service_Line_Disbursement__c(Disbursement__c = shipdis.Id, Import_Export_Service_Line__c = quote.Id);
        insert ie_service_line_disburser;
        Quote_Item_Line__c quote_item = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote_item;
        Import_Export_Cargo_Line_Disbursement__c ie_line_disbursement = new Import_Export_Cargo_Line_Disbursement__c(Disbursement__c = shipdis.Id, Import_Export_Cargo_Line__c = quote_item.Id);
        insert ie_line_disbursement;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
        insert shipfeeline;
        Shipment_Service_Line_Disbursement__c ship_service_lines = new Shipment_Service_Line_Disbursement__c(Shipment_Disbursement__c = shipdis.Id , Shipment_Service_Line__c =shipfeeline.Id);
        insert ship_service_lines;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id , E_Commerce__c = true);
        insert item;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Shipping_Weight_Kg__c = 100);
        insert shipline;
        
     }
     
     static testMethod void NEU_JE_Update_Transport_Packaging_Data_Addresses()
     {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id, Ship_from_Door_Account__c = a.Id, Ship_from_Door_Address__c ='', Ship_to_Door_Address__c = '', Ship_to_Door_Account__c = a.Id);
        insert transporpack;
        
     }
     
     static testMethod void NEU_LaunchIntegrationWC()
     {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route', Last_Receipt_Information_from_WCN__c = system.Today());
        insert route;
        route.Last_Receipt_Information_from_WCN__c = system.Today().adddays(1);
        update route;
        
     }
     
     static testMethod void NEU_Quote_Item_Line_copy()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto2;
          Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto;
          Account sup = list_accounts[1];
          insert sup;
          Account sup2 = list_accounts[2];
          insert sup2;
          Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
          insert b;
          Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
          insert scm_contract;
          Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
          insert c;
          Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
          insert d;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=sup.Id, Delivery_Account__c= sup.Id, DeliveryAddress__c='', Receipt_Address__c ='', Customer__c = a.Id);
          insert supquote;
          Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item', Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
          insert item;
          Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Name='test', Item__c= item.Id, Price__c =10, Item_Units_x_Packaging__c =1, Number_of_Containers__c =10, Packaging_Height_cm__c =1000, Packaging_Weight_kg__c = 1000, Quantity__c = 10, Supplier_Item_Weight_kg__c = 10 , Supplier_Quote__c = supquote.Id);
          insert supquoteline;
          Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c =100,  Supplier_Quote_Line__c= supquoteline.Id, Supplier_Quote__c = supquote.Id);
          insert quote;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
          insert fee;
          Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
          insert quote2;
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          
     }

     static testMethod void NEU_OM_Update_Suppliers_Quotes_Addresses()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Supplier');
          Account a = list_accounts[0];
          insert a;
          Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto2;
          Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto;
          Account sup = list_accounts[1];
          insert sup;
          Account sup2 = list_accounts[2];
          insert sup2;
          Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
          insert b;
          Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
          insert scm_contract;
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
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id, Delivery_Account__c = sup.Id, DeliveryAddress__c='', Receipt_Address__c ='', Customer__c = a.Id);
          insert supquote;
          supquote.Delivery_Account__c = sup2.Id;
          update supquote;
     }
        
     static testMethod void NEU_Supplier_Quote_Line_Copy()
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto2;
          Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto;
          Account sup = list_accounts[1];
          insert sup;
          Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
          insert b;
          Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
          insert scm_contract;
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
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=sup.Id, Delivery_Account__c = sup.Id, DeliveryAddress__c='', Receipt_Address__c ='', Customer__c = a.Id);
          insert supquote;
          Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item', Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
          insert item;
          Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Name='test', Item__c= item.Id, Price__c =10, Item_Units_x_Packaging__c =1, Number_of_Containers__c =10, Packaging_Height_cm__c =1000, Packaging_Weight_kg__c = 1000, Quantity__c = 10, Supplier_Item_Weight_kg__c = 10 , Supplier_Quote__c = supquote.Id);
          insert supquoteline;
          
     }
     
     
     
     static testMethod void NEU_Supplier_Quote_Order_Fee_Line_copy()
     {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Order_Fee_Line__c sup_quote_order_fee = new Supplier_Quote_Order_Fee_Line__c(Name='test', Fee_Name__c = fee.Id, Supplier_Quote_Order__c=supquote.Id, Units__c=100);
        insert sup_quote_order_fee;
     }
     
     static testMethod void NEU_Update_Buy_Rate()
     {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id, Cost_Concept_1__c =10);
        insert fee;
        
     }
     
     static testMethod void NEU_Update_Flight_Number()
     {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        insert a;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
        insert ship_prog;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import',Flight_Number__c = '10', Truck_Number__c='10', Inbound_Consolidation_Program__c = ship_prog.Id, Only_Warehouse_Service__c = true);
        insert ship;
        ship.Flight_Number__c = '8';
        ship.Truck_Number__c = '8';
        update ship;
     }
     
     static testMethod void NEU_Update_Last_Shipment_IE()
     {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert shipconsodata;
     }
     
     static testMethod void NEU_Update_Shipment_Buy_Price()
     {
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
        insert shipfeeline;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2);
        insert ship_prog;
        Shipment_Program_Line__c  ship_prog_line = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog.Id, Units__c = 10);
        insert ship_prog_line;
        Ship_Service_Consol__c new_ship_service_consol = new Ship_Service_Consol__c(Name='test', Cost_Allocated__c = 10, Shipments_Program_Service_Line__c = ship_prog_line.Id, Shipment_Service_Line__c = shipfeeline.Id);
        insert new_ship_service_consol;
        update new_ship_service_consol;
     }
     
     static testMethod void NEU_OM_Update_Account_Authorized_Credit()
     {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        a.Authorized_Credit__c = true;
        update a;
     }
     
     static testMethod void NEU_OM_CalculateTotalFeesShipment() 
     {
            Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
            //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            Account a = b;
            insert a;
            Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
            insert ship;
            Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
            insert fee;
            Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
            insert shipfeeline;
            delete shipfeeline;
            Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
            insert fee2;
            Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee2.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
            insert shipfeeline2;
            shipfeeline2.Units__c =20;
            update shipfeeline2;
    }
    
     static testMethod void NEU_Fields_copy_production_plan ()
    {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id , E_Commerce__c = true);
        insert item;
        NEU_Factory__c factory = new NEU_Factory__c(Name='test factory', Account_Owner__c = a.Id);
        insert factory;
        Labor_Program__c labor_program = new Labor_Program__c (Factory_Line__c = factory.Id);
        insert labor_program;
        Production_Order__c  production_order = new Production_Order__c (Item__c = item.Id , Labor_Program__c = labor_program.Id);
        insert production_order;
    }
    
    static testMethod void NEU_Shipment_Assign_Service_Charges  ()
    {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id , E_Commerce__c = true);
        insert item;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Shipping_Weight_Kg__c = 100);
        insert shipline;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Buy_Rate__c = 10, Fee_Rate__c = 10, Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        
        Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Units__c=10 );
        insert shipfeeline2;
        
    }
    
    static testMethod void NEU_Shipment_Item_Line_copy  ()
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account supplier = list_accounts[1];
        insert supplier;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id , E_Commerce__c = true);
        insert item;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Quote_Item_Line__c =quote.Id, Import_Export_Quote__c =importexportquote.Id);
        insert shipline;   
         Supplier_Quote__c supplier_quote_test = new Supplier_Quote__c(Supplier__c = supplier.Id);
        insert supplier_quote_test;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supplier_quote_test.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000, Active__c  = true, Price__c =10);
        insert sup_quote_lines; 
        
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Supplier_Quote_Line__c = sup_quote_lines.Id, Supplier_Quote__c =supplier_quote_test.Id, Quote_Item_Line__c = quote.Id, Import_Export_Quote__c = importexportquote.Id);
        insert shipline2;
        Shipment_Line__c shipline3 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        insert shipline3;
        Shipment_Line__c shipline4 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Supplier_Quote_Line__c = sup_quote_lines.Id, Supplier_Quote__c =supplier_quote_test.Id);
        insert shipline4;
        
        update shipline2;
        update shipline3;
        update shipline4;
        
    }
    
    static testMethod void NEU_OM_Update_LastShipmentDate()
    {
        
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Import_Export_Quote__c = importexportquote.Id );
        insert shipline;
        test.startTest();
            ship.ETD_from_Point_of_Load__c=date.valueOf('2024-01-01');
            update ship;
        test.stopTest();
    }
    
      static testMethod void NEU_OM_CalculateTotalWeightItemImportExport() //ok
     {
            Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
            //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            Account a = acc;
            insert a;
            Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
            insert b;
            Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
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
            Import_Export_Fee_Line__c Import_Export_Fee_Line = new Import_Export_Fee_Line__c();
            Import_Export_Fee_Line = [select Id, Name, Sell_Amount__c from Import_Export_Fee_Line__c limit 1];
            Import_Export_Fee_Line__c iefl = new Import_Export_Fee_Line__c();
            test.startTest();
            delete quote;
            test.stopTest();
     }  
    
     static testMethod void NEU_OM_Update_ShoppingCart_Account_Status() 
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account buyer = list_accounts[0];
        insert buyer;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=buyer.Id);
        insert shop;
        Shopping_Cart_line__c shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = item.Id, Units__c=10, Offer_Price__c=10, List_Price__c=10);
        insert shoplines;
        shop.Status__c ='Open';
        update shop;
     }
     
     static testMethod void NEU_OM_Update_ShoppingCartLine_Account_Status() 
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account buyer = list_accounts[0];
        insert buyer;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=buyer.Id, Status__c ='Open');
        insert shop;
        Shopping_Cart_line__c shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = item.Id, Units__c=10, Offer_Price__c=10, List_Price__c=10);
        insert shoplines;
        
     }
     
      static testMethod void NEU_OM_UpdateFoAccount() //ok
     {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,');
        List<Account> lista_de_cuentas = new List<Account>();
        List<User> lista_usuarios = [select Id, AccountId from User limit 1];
        Account cuenta = list_accounts[0];
        insert cuenta;
         
        Account cuenta2 = list_accounts[1];
        
        Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        
          insert cuenta2;
       
        
     }
     
      static testMethod void NEU_OM_UpdateFoClaim() //ok
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account cuenta = list_accounts[0];
        insert cuenta;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
         Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        Claim__c claim = new Claim__c(Customer__c = cuenta.Id);
        
        
        
          
          insert claim;
     }
     
      static testMethod void NEU_OM_UpdateFoSCM_Contract() //ok
     {
        
          Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = b;
          insert a;
          SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
          insert scm_contract;
     }
     
     static testMethod void NEU_OM_UpdateFoAssociated_Document() //ok
     {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          a.Account_Executive_User__c = userinfo.getuserId();
          a.Account_External_Follower_User__c=userinfo.getuserId();
          insert a;
          Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto2;
          Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
          insert contacto;
          Account sup = list_accounts[1];
          insert sup;
          Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
          insert b;
          Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
          insert importexportquote;
          SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
          insert scm_contract;
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
          Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
          insert supplyproject;
          Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
          insert suprequest;
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
          insert supquote;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Claim__c claim = new Claim__c(Customer__c = a.Id);
          insert claim;
          Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
          insert shop;
          Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
          insert transporpack;
          Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id);
          insert shipconsodata;
          Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id);
          insert shipdis;
          Associated_Document__c new_associated_document = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
          Claim__c=claim.Id, Import_Export_Quote__c=importexportquote.Id, SCM_Contract__c=scm_contract.Id , Shipment__c=ship.Id , Shipment_Consolidation_Data__c=shipconsodata.Id, Shipment_Disbursement__c=shipdis.Id, 
          Shopping_Cart__c=shop.Id, Supplier_Quote__c=supquote.Id, Supplier_Request_RFP__c=suprequest.Id , Supply_Project__c=supplyproject.Id, Shipment_Packaging_Consolidation_Data__c=  transporpack.Id);
          insert new_associated_document;
     }
     
     static testMethod void NEU_OM_UpdateFoImportExportQuote() //ok
     {
        
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account cuenta = list_accounts[0];
        cuenta.ActiveSap__c = true;
        insert cuenta;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        Price_List__c pricelist = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = cuenta.Id);
        insert pricelist;
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = cuenta.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = pricelist.id, Account_for__c = cuenta.Id, Quotation_Status__c = 'Approved as Succesful');
        Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = cuenta.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = pricelist.id, Account_for__c = cuenta.Id, Quotation_Status__c = 'Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        
        Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Sercie Rate Test';
		service_rate.Fee_Category__c = 'Disbursement';
		service_rate.Rate_Type__c = 'Per Kg';
		service_rate.Account_for__c = cuenta.Id;
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
        
     }
     
     static testMethod void NEU_OM_UpdateFoShipment() //ok
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account cuenta = list_accounts[0];
        insert cuenta;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
     }
     
     static testMethod void NEU_OM_UpdateFoShoppingCart() //ok
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account cuenta = list_accounts[0];
        insert cuenta;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=cuenta.Id);
        insert shop;
     }
     
     static testMethod void NEU_OM_Update_Fee_Rate()
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
        Account supplier = list_accounts[0];
        insert supplier;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Fee_Rate__c=10, Account_for__c = supplier.Id);
        insert fee;
        Fee_Offer__c fee_offer = new Fee_Offer__c(Name = 'test fee offer', Supplier__c = supplier.Id, Fee_Name__c = fee.Id, Price__c=10, Valid__c=false );
        insert fee_offer;
        Fee_Offer__c fee_offer2 = new Fee_Offer__c(Name = 'test fee offer', Supplier__c = supplier.Id, Fee_Name__c = fee.Id, Price__c=10, Valid__c=true );
        insert fee_offer2;
        Fee_Offer__c fee_offer3 = new Fee_Offer__c(Name = 'test fee offer', Supplier__c = supplier.Id, Fee_Name__c = fee.Id, Price__c=10, Valid__c=true );
        insert fee_offer3;
      
     }
     
     static testMethod void NEU_OM_UpdateFoSupplierQuote() //ok
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
        insert supquote;
     }
     
     static testMethod void NEU_OM_UpdateFoSupplierRequests() //ok
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = sup.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
        insert suprequest;
     }
     
     static testMethod void NEU_OM_UpdateFoSupplyProject() //ok
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
     }
     
     static testMethod void NEU_MD_SCMR1() //ok
     {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account buyer = list_accounts[0];
        insert buyer;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=buyer.Id);
        insert shop;
        Shopping_Cart_line__c shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = item.Id, Units__c=10, Offer_Price__c=10, List_Price__c=10);
        insert shoplines;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = buyer.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = buyer.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Price_List__c cpl = new Customer_Price_List__c(Customer__c = buyer.id,Price_List__c = b.Id);
        insert cpl;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= item.Id);
        insert quote;
        
        SCM_Rule__c scm_rule = new SCM_Rule__c(Name='test scm rule', Category__c= 'Inventory Management', Enabled__c = true,Fee_Alarm_Text__c='test', Description__c='test', SCM_Rule_Code__c= 'SCMR1' );
        insert scm_rule;
        SCM_Activity__c scm_activity = new SCM_Activity__c(Name='test', Enabled__c = true, SCM_Rule__c =scm_rule.Id,Subject__c='test' );
        insert scm_activity;
        test.startTest();
            item.Item_Price__c=10;
            update item;
            
        test.stopTest();
        
     }
     
     static testMethod void NEU_Disable_Approved_Quotes() {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account buyer = list_accounts[0];
        buyer.ActiveSap__c = true;
        insert buyer;
        Account sup = list_accounts[1];
        insert sup;
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = buyer.Id, Consignee__c = buyer.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Approved as Succesful');
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = buyer.Id, Consignee__c = buyer.Id, Supplier_Account__c = sup.Id, Quotation_Status__c ='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        
        Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Sercie Rate Test';
		service_rate.Fee_Category__c = 'Disbursement';
		service_rate.Rate_Type__c = 'Per Kg';
		service_rate.Account_for__c = buyer.Id;
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
        
        importexportquote.Quotation_Status__c='Approved as Succesful';
        
        update importexportquote;
      }
     

      static testMethod void NEU_MD_SCMR2() {
        
        
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test pircelist',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Pricing_Executive__c = UserInfo.getUserId(), Catalog_Price_List__c = b.id, Account_for__c = a.Id, Quotation_Status__c='Sent awaiting response', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
         Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Fee_Rate__c=10, Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2; 
        SCM_Rule__c scm_rule = new SCM_Rule__c(Name='test rule', SCM_Rule_Code__c = 'SCMR2' , Enabled__c = true, Fee_Alarm_Text__c='test alarm');
        insert scm_rule;
        SCM_Activity__c scm_activity = new SCM_Activity__c(Name='test', Enabled__c = true, SCM_Rule__c =scm_rule.Id,Subject__c='test' );
        insert scm_activity;
        
        test.startTest();
            fee.Fee_Rate__c=100;
            update fee;
        test.stopTest();
     
      }
      
    static testMethod void  NEU_OM_SCMV1_SCMV2()
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route');
        insert route;
        SCM_Rule__c scm_rule2 = new SCM_Rule__c(Name='test rule', SCM_Rule_Code__c = 'SCMV2' , Enabled__c = true, Fee_Alarm_Text__c='test alarm');
        insert scm_rule2;
        SCM_Activity__c scm_activity2 = new SCM_Activity__c(Name='test', Enabled__c = true, SCM_Rule__c =scm_rule2.Id,Subject__c='test' );
        insert scm_activity2;
        SCM_Rule__c scm_rule = new SCM_Rule__c(Name='test rule', SCM_Rule_Code__c = 'SCMV1' , Enabled__c = true, Fee_Alarm_Text__c='test alarm');
        insert scm_rule;
        SCM_Activity__c scm_activity = new SCM_Activity__c(Name='test', Enabled__c = true, SCM_Rule__c =scm_rule.Id,Subject__c='test' );
        insert scm_activity;
        Vessel_Flight__c vessel_flight = new Vessel_Flight__c(Name='test', IMO__c='54648', Route__c =route.Id, Vessel_Flight_ETA_Point_of_Discharge__c=system.today(), Vessel_Flight_ETD_Point_of_Load__c= system.today());
        insert vessel_flight;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Route__c =route.Id, Service_Mode__c ='Import',
        Truck_Vessel_Flight__c=vessel_flight.Id, Only_Warehouse_Service__c = true);
        insert ship;
        ship.ETD__c=string.valueof(system.today().addDays(30));
        update ship; 
       
        ship.ETA_ATA__c = string.valueof(system.today().addDays(40));
        update ship;
        
    }
     
    static testMethod void NEU_MD_UploadRecordTypeSQO()
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Account account_test2 = list_accounts[1];
        insert account_test2;
        
        Supplier_Quote__c supplier_quote_test = new Supplier_Quote__c();
        supplier_quote_test.Supplier__c = account_test.Id;
        
        test.startTest();
        insert supplier_quote_test;
        test.stopTest();
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= account_test2.Id , E_Commerce__c = true);
        insert item;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supplier_quote_test.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000, Active__c  = true, Price__c =10);
        insert sup_quote_lines;
        supplier_quote_test.Supplier_Quote_Status__c = 'Approved';
        update supplier_quote_test;
    }
    
    static testMethod void NEU_OM_CalculateTotalFeesSuppQuoteOrder() 
     {
            
            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
            Account a = list_accounts[0];
            insert a;
            Account sup =list_accounts[1];
            insert sup;
            Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
            insert ship;
            Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
            insert fee;
            Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
            insert fee2;
            Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
            insert supplyproject;
            Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
            insert supquote;
            Supplier_Quote_Order_Fee_Line__c sup_quote_order_fee = new Supplier_Quote_Order_Fee_Line__c(Name='test', Fee_Name__c = fee.Id, Supplier_Quote_Order__c=supquote.Id, Units__c=100, Supplier_Quote_Order_Buy_Price__c = 10, Supplier_Quote_Order_Sell_Price__c = 10);
            insert sup_quote_order_fee;
            Supplier_Quote_Order_Fee_Line__c sup_quote_order_fee2 = new Supplier_Quote_Order_Fee_Line__c(Name='test', Fee_Name__c = fee.Id, Supplier_Quote_Order__c=supquote.Id, Units__c=100, Supplier_Quote_Order_Buy_Price__c = 10, Supplier_Quote_Order_Sell_Price__c = 10);
            insert sup_quote_order_fee2;
            delete sup_quote_order_fee2;
    }
    
    
	static testMethod void NEU_IE_Update_Conversions()
	{
		List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
          
        Customer_Quote__c importexportquote = new Customer_Quote__c();
       	importexportquote.Account_for__c = account_test.Id;
        importexportquote.Quotation_Status__c = 'Quote being prepared'; 
        importexportquote.Origin_Address__c = '';
        importexportquote.Destination_Address__c = '';
        importexportquote.Only_Warehouse_Service__c = true;
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'MXN');
		insert importexportquote;
        
        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
		Invoice__c new_invoice = new Invoice__c();
		new_invoice.Name = 'test';
		new_invoice.Import_Export_Quote_Order__c = importexportquote.Id;
		new_invoice.Shipment__c = ship.Id;
		new_invoice.Account__c = account_test.Id;
		new_invoice.Date_of_Invoice__c = system.today();
		NEU_CurrencyUtils.setCurrencyIsoCode(new_invoice, 'MXN');
		insert new_invoice;
          
		update importexportquote;
	}
    
	static testMethod void NEU_EUR_Conversion_Rate_Invoice_Date()
    {
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account account_test = list_accounts[0];
          account_test.Credit_Terms__c = '15 days';
          insert account_test;
          
          Customer_Quote__c importexportquote = new Customer_Quote__c();
          importexportquote.Account_for__c = account_test.Id;
          importexportquote.Quotation_Status__c = 'Quote being prepared'; 
          importexportquote.Origin_Address__c = '';
          importexportquote.Destination_Address__c = '';
          importexportquote.Only_Warehouse_Service__c = true;
          insert importexportquote;
          
          Shipment__c ship = new Shipment__c();
          ship.Account_for__c = account_test.Id;
          ship.Freight_Mode__c = 'Sea';
          ship.Service_Mode__c = 'Import';
          ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
          ship.Only_Warehouse_Service__c = true;
          insert ship;
          
          Invoice__c new_invoice = new Invoice__c();
          new_invoice.Name = 'test';
          new_invoice.Import_Export_Quote_Order__c = importexportquote.Id; 
          new_invoice.Shipment__c = ship.Id;
          new_invoice.Account__c = account_test.Id;
          new_invoice.Date_of_Invoice__c = system.today();
          insert new_invoice;
	}
     
   static testMethod void NEU_UpdateOutstandingBalanceAccount()
   {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        a.Credit_Limit__c = 100;
        insert a;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id,
        Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', 
        Destination_Address__c='test address');
        insert importexportquote;
        
        /*Customer_Quote__c importexportquote1 = new Customer_Quote__c( Account_for__c = a.Id,
        Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', 
        Destination_Address__c='test address');
        insert importexportquote1;*/
        
        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = a.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
        Invoice__c i_test = new Invoice__c();
        i_test.Import_Export_Quote_Order__c = importexportquote.Id;
        i_test.Shipment__c = ship.Id;
        i_test.Account__c = a.Id;
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
        
        /*Invoice__c i_test1 = new Invoice__c();
        i_test1.Import_Export_Quote_Order__c = importexportquote1.Id;
        i_test1.Account__c = a.Id;
        i_test1.Payable_Before__c = date1;
        i_test1.Date_of_Invoice__c = date2;
        insert i_test1;
        
        Invoice_Line__c il1 = new Invoice_Line__c();
        il1.Invoice__c = i_test.Id;
        il1.Units__c = 10; 
        il1.Unit_Price__c = 533.02;
        il1.Amount__c= 533.02;
        insert il1;*/
        
        //delete i_test1;
   }
	
	static testMethod void NEU_ActualizaFolioIE()
	{
		List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
		Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        insert quote_test;
        quote_test.Service_Mode__c = 'Export';
        update quote_test;
	}
	
	static testMethod void NEU_Air_Waybill_Line_Recalculate_CW()
	{
		Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test_1 = new Air_Waybill__c();
        air_waybill_test_1.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test_1.Serial_Number__c = 'Test';
        air_waybill_test_1.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test_1.Prepaid_Collect_Other__c = 'Prepaid';
        air_waybill_test_1.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test_1.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        insert air_waybill_test_1;
        
        Air_Waybill_Line__c air_waybill_line_test_1 = new Air_Waybill_Line__c();
        air_waybill_line_test_1.Name = '001';
        air_waybill_line_test_1.Air_Waybill__c = air_waybill_test_1.Id;
        air_waybill_line_test_1.Gross_Weight__c = 1;
        air_waybill_line_test_1.No_of_Pieces__c = 1;
        air_waybill_line_test_1.Height__c = 1;
        air_waybill_line_test_1.Length__c = 1;
        air_waybill_line_test_1.Width__c = 1;
        insert air_waybill_line_test_1;
        
        Air_Waybill__c air_waybill_test_2 = new Air_Waybill__c();
        air_waybill_test_2.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test_2.Serial_Number__c = 'Test';        
        air_waybill_test_2.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test_2.Prepaid_Collect_Other__c = 'Prepaid';
        air_waybill_test_2.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test_2.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        insert air_waybill_test_2;
        
        Air_Waybill_Line__c air_waybill_line_test_2 = new Air_Waybill_Line__c();
        air_waybill_line_test_2.Name = '001';
        air_waybill_line_test_2.Air_Waybill__c = air_waybill_test_2.Id;
        air_waybill_line_test_2.Gross_Weight__c = 0;
        air_waybill_line_test_2.No_of_Pieces__c = 1;
        air_waybill_line_test_2.Height__c = 1;
        air_waybill_line_test_2.Length__c = 1;
        air_waybill_line_test_2.Width__c = 1;
        insert air_waybill_line_test_2;
        
        test.startTest();
        update air_waybill_line_test_1;
        update air_waybill_line_test_2;
        test.stopTest();
	}
	
	static testMethod void NEU_ActualizaFolioWaybill()
	{
		Country__c country_test_1 = new Country__c();
		country_test_1.Name = 'Country Test';  
		country_test_1.ISO_Code__c = 'EUR';
        insert country_test_1;
        
        Location__c location_test_1 = new Location__c();
        location_test_1.Name = 'Location Test'; 
        location_test_1.City__c = 'City Test';
        location_test_1.Country__c = country_test_1.Id;
        location_test_1.Subdivision__c = 'Subdivision Test';
        location_test_1.UNLOCODE__c = 'ABC';
        insert location_test_1;
        
        Country__c country_test_2 = new Country__c();
		country_test_2.Name = 'Country Test';  
		country_test_2.ISO_Code__c = 'EUR';
        insert country_test_2;
        
        Location__c location_test_2 = new Location__c();
        location_test_2.Name = 'Location Test'; 
        location_test_2.City__c = 'City Test';
        location_test_2.Country__c = country_test_2.Id;
        location_test_2.Subdivision__c = 'Subdivision Test';
        location_test_2.UNLOCODE__c = 'ABC';
        insert location_test_2;
		
		Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';        
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        air_waybill_test.Country_of_Departure__c = country_test_1.Id;
        air_waybill_test.Airport_of_Departure__c = location_test_1.Id;
        insert air_waybill_test;
        
        test.startTest();
		air_waybill_test.Country_of_Departure__c = country_test_2.Id;
        air_waybill_test.Airport_of_Departure__c = location_test_2.Id;
        update air_waybill_test;
        test.stopTest();
	} 
	
	static testMethod void NEU_Waybill_Master()
	{
		Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        update waybill_master_test;
	}  
	
	static testMethod void NEU_Waybill_Other_Charge()
	{
		Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        insert air_waybill_test;

		Air_Waybill_Line__c air_waybill_line_test = new Air_Waybill_Line__c();
        air_waybill_line_test.Name = '001';
        air_waybill_line_test.Air_Waybill__c = air_waybill_test.Id;
        air_waybill_line_test.Gross_Weight__c = 1;
        air_waybill_line_test.No_of_Pieces__c = 1;
        air_waybill_line_test.Height__c = 1;
        air_waybill_line_test.Length__c = 1;
        air_waybill_line_test.Width__c = 1;
        insert air_waybill_line_test;

        Waybill_Other_Charge__c waybill_other_charge_test = new Waybill_Other_Charge__c();
        waybill_other_charge_test.Waybill__c = air_waybill_test.Id;
        waybill_other_charge_test.Other_Charge_Rate__c = 1;
        
        test.startTest();
        insert waybill_other_charge_test;
        test.stopTest();
	}
	
	static testMethod void NEU_TraxonTotalOtherCharges()
	{
		Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        insert air_waybill_test;

		Air_Waybill_Line__c air_waybill_line_test = new Air_Waybill_Line__c();
        air_waybill_line_test.Name = '001';
        air_waybill_line_test.Air_Waybill__c = air_waybill_test.Id;
        air_waybill_line_test.Gross_Weight__c = 1;
        air_waybill_line_test.No_of_Pieces__c = 1;
        air_waybill_line_test.Height__c = 1;
        air_waybill_line_test.Length__c = 1;
        air_waybill_line_test.Width__c = 1;
        insert air_waybill_line_test;

        Waybill_Other_Charge__c waybill_other_charge_test_1 = new Waybill_Other_Charge__c();
        waybill_other_charge_test_1.Waybill__c = air_waybill_test.Id;
        waybill_other_charge_test_1.Other_Charge_Rate__c = 1;
        waybill_other_charge_test_1.Recipient_of_Charge_Amount__c = 'A';
        
        Waybill_Other_Charge__c waybill_other_charge_test_2 = new Waybill_Other_Charge__c();
        waybill_other_charge_test_2.Waybill__c = air_waybill_test.Id;
        waybill_other_charge_test_2.Other_Charge_Rate__c = 1;
        waybill_other_charge_test_2.Recipient_of_Charge_Amount__c = 'A';
        
        test.startTest();
        insert waybill_other_charge_test_1;
        waybill_other_charge_test_1.Other_Charge_Rate__c = 2;
        update waybill_other_charge_test_1;
        delete waybill_other_charge_test_1;
        test.stopTest();
	}
}