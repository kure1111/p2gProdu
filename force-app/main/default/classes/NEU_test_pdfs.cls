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
private class NEU_test_pdfs {

    static testMethod void NEU_NotesQuotationPDF()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

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

    static testMethod void test_NEU_Shipping_Marks_pdf() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a =  list_accounts[0];
      insert a;  
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
      insert ship;
      Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
      insert family;
      Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
      insert subfamily;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
      insert item;
      Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
      insert shipline;
      NEU_Shipping_Marks_pdf uda = new NEU_Shipping_Marks_pdf(new ApexPages.StandardController( ship ));
    }
    
    static testMethod void test_NEU_Shipping_Marks_save_pdf() {
    	NEU_StaticVariableHelper.setBoolean1(true);
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a =  list_accounts[0];
      insert a;  
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
      insert ship;
      NEU_Shipping_Marks_save_pdf uda = new NEU_Shipping_Marks_save_pdf(new ApexPages.StandardController( ship ));
      Blob b = Blob.valueOf('Test Data');
      uda.documento_asociado.Name='Test document.test';
      uda.documento_asociado.AuthorId = UserInfo.getUserId();
      uda.documento_asociado.IsPublic=true;
      uda.documento_asociado.Body = b;
      uda.crear();
      
        
    }
    
     static testMethod void test_NEU_DeliveryNote_pdf() {
     	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;  
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
      insert ship;
      Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
      insert family;
      Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
      insert subfamily;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
      insert item;
      Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
      insert shipline;
      NEU_DeliveryNote_pdf uda = new NEU_DeliveryNote_pdf(new ApexPages.StandardController( ship ));
    }
    
       
    static testMethod void test_NEU_DeliveryNote_save_pdf() {
    	NEU_StaticVariableHelper.setBoolean1(true);
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;  
      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
      insert ship;
      NEU_DeliveryNote_save_pdf uda = new NEU_DeliveryNote_save_pdf(new ApexPages.StandardController( ship ));
      Blob b = Blob.valueOf('Test Data');
      uda.documento_asociado.Name='Test document.test';
      uda.documento_asociado.AuthorId = UserInfo.getUserId();
      uda.documento_asociado.IsPublic=true;
      uda.documento_asociado.Body = b;
      uda.crear();
      
        
    }
    
    static testMethod void test_NEU_Customer_Order_Confirmation_pdf() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;  
      Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address'); 
      insert importexportquote;
      Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
      insert family;
      Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
      insert subfamily;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
      insert item;
      Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c = item.Id);
      insert quote;
      NEU_Customer_Order_Confirmation_pdf uda = new NEU_Customer_Order_Confirmation_pdf(new ApexPages.StandardController( importexportquote ));
    }
    
     static testMethod void test_NEU_Customer_Order_Confirmation_save_pdf() {
     	NEU_StaticVariableHelper.setBoolean1(true);
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;  
      Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address'); 
      insert importexportquote;
      NEU_Customer_Order_Confirmation_save_pdf uda = new NEU_Customer_Order_Confirmation_save_pdf(new ApexPages.StandardController( importexportquote ));
      Blob b = Blob.valueOf('Test Data');
      uda.documento_asociado.Name='Test document.test';
      uda.documento_asociado.AuthorId = UserInfo.getUserId();
      uda.documento_asociado.IsPublic=true;
      uda.documento_asociado.Body = b;
      uda.crear();
     }
     
    static testMethod void test_NEU_Import_Export_Quote_pdf() {
      	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;  
      Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address'); 
      insert importexportquote;
      Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
      insert family;
      Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
      insert subfamily;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
      insert item;
      Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
      insert fee;
      Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
      insert quote;
      NEU_Import_Export_Quote_pdf uda = new NEU_Import_Export_Quote_pdf(new ApexPages.StandardController( importexportquote ));

        /*
        *     	string consulta_fee_lines = '';
    	consulta_fee_lines += 'SELECT Id, Name, Service_Rate_Name__r.Name, Sell_Amount__c, Units__c, Service_Rate_Category__c, Quote_Sell_Price__c';
    	if(UserInfo.isMultiCurrencyOrganization()== true)
        	consulta_fee_lines += ',CurrencyIsoCode';
	    consulta_fee_lines += ' FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c = \''+record.Id+'\' ORDER BY Name ASC';
        * */
    }

    static testMethod void test_NEU_Import_Export_Quote_pdf_ES() {
        NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');
        insert importexportquote;
        Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
        insert family;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert item;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;
        NEU_Import_Export_Quote_pdf_ES uda = new NEU_Import_Export_Quote_pdf_ES(new ApexPages.StandardController( importexportquote ));
    }
    
    static testMethod void test_NEU_Import_Export_Quote_save_pdf() {
    	NEU_StaticVariableHelper.setBoolean1(true);
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;  
      Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address'); 
      insert importexportquote;
      NEU_Import_Export_Quote_save_pdf uda = new NEU_Import_Export_Quote_save_pdf(new ApexPages.StandardController( importexportquote ));
      Blob b = Blob.valueOf('Test Data');
      uda.documento_asociado.Name='Test document.test';
      uda.documento_asociado.AuthorId = UserInfo.getUserId();
      uda.documento_asociado.IsPublic=true;
      uda.documento_asociado.Body = b;
      uda.crear();
    } 
     
    static testMethod void test_NEU_Purchase_Order_pdf() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
      List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
      Account a = list_accounts[0];
      insert a;  
      Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
      insert supquote;
      Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
      insert family;
      Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
      insert subfamily;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
      insert item;
      Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000);
      insert sup_quote_lines;
      
      NEU_Purchase_Order_pdf uda = new NEU_Purchase_Order_pdf(new ApexPages.StandardController( supquote ));
      
       }
       
     static testMethod void test_NEU_Inspecion_Booking_Email() {
     	NEU_StaticVariableHelper.setBoolean1(true);
     // TO DO: implement unit test
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = list_accounts[0];
          insert a;  
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
          insert family;
          Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
          insert subfamily;
          Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
          insert item;
          Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
          insert shipline;
          NEU_Inspecion_Booking_Email uda = new NEU_Inspecion_Booking_Email(new ApexPages.StandardController( ship ));
          uda.send_email();
          uda.return_shipment();
         
        }
        
        static testMethod void test_NEU_Shipping_Order_Email() {
        	NEU_StaticVariableHelper.setBoolean1(true);
         // TO DO: implement unit test
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;  
          Account sup = list_accounts[1];
          insert sup;
          Contact contacto2 = new Contact(AccountId = sup.Id, LastName='test contact', Email='oscar@neurored.com');
          insert contacto2;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Supplier_Account__c = sup.Id, Only_Warehouse_Service__c = true);
          insert ship;
          Associated_Document__c documentos_asociados = new Associated_Document__c(Name='test associated document', Account__c=a.Id, Shipment__c=ship.Id);
          insert documentos_asociados;
          Product_Family__c family = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
          insert family;
          Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
          insert subfamily;
          Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
          insert item;
          Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
          insert shipline;
          NEU_Shipping_Order_Email uda = new NEU_Shipping_Order_Email(new ApexPages.StandardController( ship ));
          List<NEU_Shipping_Order_Email.documents_s> associated_documents_new = new List<NEU_Shipping_Order_Email.documents_s>();
          associated_documents_new.add(new NEU_Shipping_Order_Email.documents_s(true, 'pdf.pdf','pdf', 'reference', 'description', '', documentos_asociados.Id, 0,'10'));
          uda.associated_documents = associated_documents_new;
          
          
          List<NEU_Shipping_Order_Email.contacto_s> clientes_contacntos_new = new List<NEU_Shipping_Order_Email.contacto_s>();
          clientes_contacntos_new.add(new NEU_Shipping_Order_Email.contacto_s(contacto2, true));
        
          List<NEU_Shipping_Order_Email.cuenta_s> clientes_seleccionados_new = new List<NEU_Shipping_Order_Email.cuenta_s>();
          clientes_seleccionados_new.add(new NEU_Shipping_Order_Email.cuenta_s(a, clientes_contacntos_new,'Customer'));
          uda.clientes_seleccionados = clientes_seleccionados_new;
        
          uda.send_email();
          uda.return_shipment();
         
        }
        
        static testMethod void test_NEU_Shipping_Order_Email2() {
        	NEU_StaticVariableHelper.setBoolean1(true);
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = list_accounts[0];
          insert a; 
          Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country;
          Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion;
          Delivery_Zone__c nueva_delivery_zone = new Delivery_Zone__c(Name='test zona',Port_Airport__c=localizacion.Id);
          insert nueva_delivery_zone;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Road', Service_Mode__c ='Import', Delivery_Cartage__c =nueva_delivery_zone.Id, Only_Warehouse_Service__c = true);
          insert ship; 
          NEU_Shipping_Order_Email uda = new NEU_Shipping_Order_Email(new ApexPages.StandardController( ship ));
        }
        
        static testMethod void test_NEU_Shipping_Order_Email3() {
        	NEU_StaticVariableHelper.setBoolean1(true);
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = list_accounts[0];
          insert a; 
          Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
          insert Country;
          Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
          insert localizacion;
          Delivery_Zone__c nueva_delivery_zone = new Delivery_Zone__c(Name='test zona',Port_Airport__c=localizacion.Id);
          insert nueva_delivery_zone;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Air', Service_Mode__c ='Import', Delivery_Cartage__c  = nueva_delivery_zone.Id, Only_Warehouse_Service__c = true);
          insert ship; 
          NEU_Shipping_Order_Email uda = new NEU_Shipping_Order_Email(new ApexPages.StandardController( ship ));
        }
       
     static testMethod void test_NEU_Purchase_Order_save_pdf() {
     	NEU_StaticVariableHelper.setBoolean1(true);
          List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
          Account a = list_accounts[0];
          insert a;  
          Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
          insert supquote;
          NEU_Purchase_Order_save_pdf uda = new NEU_Purchase_Order_save_pdf(new ApexPages.StandardController( supquote ));
          Blob b = Blob.valueOf('Test Data');
          uda.documento_asociado.Name='Test document.test';
          uda.documento_asociado.AuthorId = UserInfo.getUserId();
          uda.documento_asociado.IsPublic=true;
          uda.documento_asociado.Body = b;
          uda.crear();
     }

    static testMethod void test_NEU_BL_save_PDF() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        NEU_BL_save_pdf hbl_pdf = new NEU_BL_save_pdf(new ApexPages.StandardController( ship ));
        Blob b = Blob.valueOf('Test Data');
        hbl_pdf.documento_asociado.Name='Test document.test';
        hbl_pdf.documento_asociado.AuthorId = UserInfo.getUserId();
        hbl_pdf.documento_asociado.IsPublic=true;
        hbl_pdf.documento_asociado.Body = b;
        hbl_pdf.crear();
        hbl_pdf.refresh_data();
        hbl_pdf.getnewcategories();
    }


    static testMethod void test_NEU_BL_pdf()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_BL_pdf hbl_pdf = new NEU_BL_pdf(new ApexPages.StandardController( ship ));
    }
  	
  	static testMethod void test_NEU_Import_Export_Comparison_save_pdf()
  	{
  		NEU_StaticVariableHelper.setBoolean1(true);
	    List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a; 
	
	    NEU_Import_Export_Comparison_save_pdf iecsp = new NEU_Import_Export_Comparison_save_pdf(new ApexPages.StandardController(a));
	    List<SelectOption> lista = iecsp.getnewcategories();
	    Document d = iecsp.documento_asociado;
	    String l = iecsp.language;
	    String querystring = iecsp.querystring;
	    iecsp.crear();
	    iecsp.add_quote();
	    iecsp.remove_quote();
    }

    static testMethod void test_NEU_Air_Waybills_PDF_Master()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(), Business_Area__c = 'Sales');
        insert a;
        Waybill_Master__c wm = new Waybill_Master__c();
        insert wm;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c = 'Air', Service_Mode__c = 'Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c sl = new Shipment_Line__c(Shipment__c = ship.id, Name = 'lineas items');
        insert sl;
        Air_Waybill__c aw = new Air_Waybill__c();
        aw.Waybill_Master__c = wm.Id;
        aw.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		aw.Prepaid_Collect_Other__c = 'Prepaid';
        insert aw;
        List<Air_Waybill_Line__c> lineas = new List<Air_Waybill_Line__c>();

        Air_Waybill_Line__c line = new Air_Waybill_Line__c();
        line.Air_Waybill__c = aw.Id;
        line.Shipment__c = ship.Id;
        line.Shipment_Cargo_Line__c = sl.Id;
        line.Gross_Weight__c = 15;
        line.RCP__c = 'AEF';
        line.Kg_Lb__c = 'K';
        line.Rate_Class__c = 'M — minimum charge ';
        //line.Commodity_Item_No__c = '582';
        line.No_of_Pieces__c = 45;
        line.Chargeable_Weight__c = 12;
        line.Description__c = '';
        line.Rate_Charge__c = 1;
        //line.Total_Service_Charge__c = 250;
        line.Nature_and_Quantity_of_Goods__c = '';

        lineas.add(line);
        insert lineas;

        // Master AWB
        PageReference pageRef = Page.NEU_Air_Waybills_PDF;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(aw);
        ApexPages.currentPage().getParameters().put('type', 'master');
        NEU_Air_Waybills_PDF awbpdf = new NEU_Air_Waybills_PDF(sc);
        String string_pdf = awbpdf.string_awb;
    }

    static testMethod void test_NEU_Air_Waybills_save_PDF()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Waybill_Master__c wm = new Waybill_Master__c();
        insert wm;
        Air_Waybill__c aw = new Air_Waybill__c();
        aw.Waybill_Master__c = wm.Id;
        aw.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		aw.Prepaid_Collect_Other__c = 'Prepaid';
        insert aw;

        NEU_Air_Waybills_save_PDF naw = new NEU_Air_Waybills_save_PDF(new ApexPages.StandardController(aw));
        Document d = naw.documento_asociado;
        String l = naw.language;
        naw.return_page();
        naw.crear();
    }
	
	static testMethod void NEU_Manifest_PDF() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        Account account_test = new Account();
        account_test.Name = 'Account Test';
        account_test.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        account_test.Business_Area__c = 'Sales';
        insert account_test;
        
        Product_Family__c product_family_test = new Product_Family__c();
        product_family_test.Name = 'Product Family Test';
        product_family_test.Business_Area__c = 'Auto-Parts';
        insert product_family_test;
        
        Subfamily__c subfamily_test = new Subfamily__c();
        subfamily_test.Product_Family__c = product_family_test.Id;
        subfamily_test.Name = 'Subfamily Test';
        insert subfamily_test;
        
        Sourcing_Item__c item_test = new Sourcing_Item__c();
        item_test.Name = 'Item Test';
        item_test.Subfamily__c = subfamily_test.Id; 
        item_test.Sourcing_Family__c = product_family_test.id; 
        item_test.Account_Owner__c = account_test.Id;
        item_test.HS_Code_Text__c = '56489';
        insert item_test;
        
        Waybill_Master__c wm = new Waybill_Master__c();
        insert wm;
        
        Shipment__c ship = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo');
        insert ship;
        
        Shipment_Line__c sl = new Shipment_Line__c(Shipment__c = ship.id, Name = 'lineas items');
        insert sl;
        
        Air_Waybill__c aw = new Air_Waybill__c();
        aw.Waybill_Master__c = wm.Id;
        aw.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		aw.Prepaid_Collect_Other__c = 'Prepaid';
        insert aw;
        
        Waybill_Consolidation__c conso = new Waybill_Consolidation__c(Name = 'EUR', Waybill__c = aw.Id);
        insert conso;
        
        List<Air_Waybill_Line__c> lineas = new List<Air_Waybill_Line__c>();
        
        Air_Waybill_Line__c line = new Air_Waybill_Line__c();
        line.Air_Waybill__c = aw.Id;
        line.Shipment__c = ship.Id;
        line.Shipment_Cargo_Line__c = sl.Id;
        line.Gross_Weight__c = 15;
        line.RCP__c = 'AEF';
        line.Kg_Lb__c = 'K';
        line.Rate_Class__c = 'M — minimum charge ';
        line.Commodity_Item_No__c = 5823;
        line.No_of_Pieces__c = 45;
        line.Description__c = 'test';
        line.Rate_Charge__c = 1;
        line.Nature_and_Quantity_of_Goods__c = 'test';
        line.Comments__c = 'test';
        line.House_Reference__c=conso.Id;
        
        lineas.add(line);
        insert lineas;

        NEU_Manifest_Save_PDF mspdf = new NEU_Manifest_Save_PDF(new ApexPages.StandardController(aw));
        Blob b = Blob.valueOf('Test Data');
        mspdf.documento_asociado.Name='Test document.test';
        mspdf.documento_asociado.AuthorId = UserInfo.getUserId();
        mspdf.documento_asociado.IsPublic=true;
        mspdf.documento_asociado.Body = b;
        mspdf.crear();
        mspdf.return_page();
        
        NEU_Manifest_PDF mpdf = new NEU_Manifest_PDF(new ApexPages.StandardController(aw));
        mpdf.cont = 6;
    }
    
    static testMethod void test_NEU_AWB_Label_House_Save_PDF()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';
        insert air_waybill_test;
        
        NEU_AWB_Label_House_Save_PDF pdf = new NEU_AWB_Label_House_Save_PDF(new ApexPages.StandardController(air_waybill_test));
        pdf.crear();
        //List<SelectOption> lista_test = pdf.lista;
        pdf.updateFilters();
        String test = pdf.querystring;
    }
    
    static testMethod void test_NEU_AWB_Label_House_PDF()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);

    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';
        insert air_waybill_test;
        
        NEU_AWB_Label_House_PDF pdf = new NEU_AWB_Label_House_PDF(new ApexPages.StandardController(air_waybill_test));
    }
    
    static testMethod void test_NEU_AWB_Label_PDF()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);

    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';
        insert air_waybill_test;
        
        NEU_AWB_Label_PDF pdf = new NEU_AWB_Label_PDF(new ApexPages.StandardController(air_waybill_test));
        pdf.crear();
        pdf.refrescar_pdf();
        pdf.return_page();
    }
    
    static testMethod void test_NEU_AWB_Label_iframe()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);

    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';
        insert air_waybill_test;
        
        NEU_AWB_Label_PDF_iframe pdf = new NEU_AWB_Label_PDF_iframe(new ApexPages.StandardController(air_waybill_test));
    }
}