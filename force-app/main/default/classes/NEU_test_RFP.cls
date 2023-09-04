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
private class NEU_test_RFP {

    static testMethod void test_NEU_JE_RFP()
    {//stdController.AddFields(new String[]
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Incoterm__c='FOB');
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
        insert supplierequest;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id);
        insert supplierequestline;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=a.Id, Valid_for_Auction__c = true, Valid_Until__c=system.today() , Supplier_Request_RFP__c = supplierequest.Id);
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Technical_Evaluation__c tectsupquoteline = new Technical_Evaluation__c(Evaluation_Criteria__c=ecriteria.Id, Option_Selected__c='test', Score__c=2, Supplier_Quote_Line__c=supquoteline.Id );
        insert tectsupquoteline;
        
        ApexPages.StandardController controller = new APexPages.StandardController(supplierequest);
        NEU_JE_RFP extension = new NEU_JE_RFP(controller);
        extension.getcloseauction();
        extension.getcloseauctiontext();
        extension.getdynamicstateauction();
        extension.getdynamicstateauctiontext();
        extension.getendtimetext();
        extension.getitemstosuplay();
        extension.getquote();
        extension.getquoted();
        extension.getranking();
        extension.getshowdocuments();
        extension.getstartauction();
        extension.getstartauctiontext();
        extension.getstarttimetext();
        extension.quote();
        extension.refreshauction();
        extension.setcloseauction(2);
        extension.setdynamicstateauction(1);
        extension.setdynamicstateauctiontext('test');
        extension.setranking('test');
        extension.setstartauction(1);
        extension.setvisited();
        extension.getrequest();
        extension.getquoteid();
        extension.setquoteid('');
        extension.publicar_total_amount = true;
        List<SelectOption> new_list_options = new List<SelectOption>();
        new_list_options.add(new SelectOption('test','test'));
        extension.setfamilies(new_list_options);
        extension.getcurrentfamily();
        extension.setcurrentfamily(c.Id);
        
         //-----------------------
    }
    
    
    static testMethod void test_NEU_JE_RFP100()
    {//stdController.AddFields(new String[]
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Incoterm__c='FOB');
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
        insert supplierequest;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id, Quantity__c=10);
        insert supplierequestline;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=a.Id, Valid_for_Auction__c = true, Valid_Until__c=system.today() , Supplier_Request_RFP__c = supplierequest.Id, Supplier_Quote_Status__c = 'Draft');
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Technical_Evaluation__c tectsupquoteline = new Technical_Evaluation__c(Evaluation_Criteria__c=ecriteria.Id, Option_Selected__c='test', Score__c=2, Supplier_Quote_Line__c=supquoteline.Id );
        insert tectsupquoteline;
        
        ApexPages.StandardController controller = new APexPages.StandardController(supplierequest);
        NEU_JE_RFP extension = new NEU_JE_RFP(controller);
        extension.getitemstosuplay();
        extension.quote();
    
    }
    
    static testMethod void test_NEU_JE_RFP101()
    {//stdController.AddFields(new String[]
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b =list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Incoterm__c='FOB');
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
        insert supplierequest;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id);
        insert supplierequestline;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Supplier_Quote__c supquote = new Supplier_Quote__c( Supplier__c=a.Id, Valid_for_Auction__c = true, Valid_Until__c=system.today() , Supplier_Request_RFP__c = supplierequest.Id, Supplier_Quote_Status__c = 'Draft');
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Technical_Evaluation__c tectsupquoteline = new Technical_Evaluation__c(Evaluation_Criteria__c=ecriteria.Id, Option_Selected__c='test', Score__c=2, Supplier_Quote_Line__c=supquoteline.Id );
        insert tectsupquoteline;
        
        ApexPages.StandardController controller = new APexPages.StandardController(supplierequest);
        NEU_JE_RFP extension = new NEU_JE_RFP(controller);
        extension.getitemstosuplay();
        extension.quote();
    
    }
    
    static testMethod void test_NEU_JE_RFP102()
    {//stdController.AddFields(new String[]
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Incoterm__c='FOB', Auction_Manual_Status__c ='Started',Starting_Time__c=system.today().adddays(-1));
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
        insert supplierequest;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id, Quantity__c=100);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id);
        insert supplierequestline;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Supplier_Quote__c supquote = new Supplier_Quote__c( Supplier__c=a.Id, Valid_for_Auction__c = true, Valid_Until__c=system.today() , Supplier_Request_RFP__c = supplierequest.Id, Supplier_Quote_Status__c = 'Draft');
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 100, Quantity__c=100);
        insert supquoteline;
        Technical_Evaluation__c tectsupquoteline = new Technical_Evaluation__c(Evaluation_Criteria__c=ecriteria.Id, Option_Selected__c='test', Score__c=2, Supplier_Quote_Line__c=supquoteline.Id );
        insert tectsupquoteline;
        
        ApexPages.StandardController controller = new APexPages.StandardController(supplierequest);
        NEU_JE_RFP extension = new NEU_JE_RFP(controller);
        extension.getitemstosuplay();
        extension.quote();
    
    }
    
    static testMethod void test_NEU_JE_RFP3()
    {//stdController.AddFields(new String[]
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Incoterm__c='FOB');
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
        insert supplierequest;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id);
        insert supplierequestline;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=a.Id, Valid_for_Auction__c = true, RecordTypeId = Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Hidden Quote').getRecordTypeId() , Valid_Until__c=system.today());
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Technical_Evaluation__c tectsupquoteline = new Technical_Evaluation__c(Evaluation_Criteria__c=ecriteria.Id, Option_Selected__c='test', Score__c=2, Supplier_Quote_Line__c=supquoteline.Id );
        insert tectsupquoteline;
        Associated_Document__c asociated_document = new Associated_Document__c(Name='test', Account__c=a.id,Manual_Document_URL__c='wwwgadghfg', Supplier_Request_RFP__c=supplierequest.Id, Document_Reference__c='Document 1Document 2Document 3Document 4Document');
        insert asociated_document;
        Associated_Document__c asociated_document2 = new Associated_Document__c(Name='test', Account__c=a.id,Manual_Document_URL__c='wwwgadghfg', Supplier_Request_RFP__c=supplierequest.Id, Document_Reference__c='5Document 6Document 7');
        insert asociated_document2;
        Associated_Document__c asociated_document3 = new Associated_Document__c(Name='test', Account__c=a.id,Manual_Document_URL__c='wwwgadghfg', Supplier_Request_RFP__c=supplierequest.Id, Document_Reference__c='Document 8Document 9Document 10');
        insert asociated_document3;
        ApexPages.StandardController controller = new APexPages.StandardController(supplierequest);
        NEU_JE_RFP extension = new NEU_JE_RFP(controller);
        extension.getcloseauction();
        extension.getcloseauctiontext();
        extension.getdynamicstateauction();
        extension.getdynamicstateauctiontext();
        extension.getendtimetext();
        extension.getitemstosuplay();
        extension.getquote();
        extension.getquoted();
        extension.getranking();
        extension.getshowdocuments();
        extension.getstartauction();
        extension.getstartauctiontext();
        extension.getstarttimetext();
        
        extension.quote();
        extension.refreshauction();
        extension.setcloseauction(2);
        extension.setdynamicstateauction(1);
        extension.setdynamicstateauctiontext('test');
        extension.setranking('test');
        extension.setstartauction(1);
        extension.setvisited();
        extension.getrequest();
        extension.getquoteid();
        extension.setquoteid('');
        
        extension.read_document();
        extension.getIsHidden();
        extension.getshow_associated_documents();
        
        extension.getcanmakequestions();
        extension.makequestions();
         //-----------------------
    }
    
    static testMethod void test_NEU_JE_RFP4()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
         ApexPages.currentPage().getParameters().put('test', 'test');
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
         insert contacto;
         Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
         insert contacto2;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Incoterm__c='FOB', 
         Document_1_Required__c= true,Document_2_Required__c= true,Document_3_Required__c= true,Document_4_Required__c= true,
         Document_5_Required__c= true,Document_6_Required__c= true,Document_7_Required__c= true, Document_8_Required__c= true,
         Document_9_Required__c= true,Document_10_Required__c= true, Document_1_Type__c ='Proforma Invoice', Document_2_Type__c ='Proforma Invoice'
         , Document_3_Type__c ='Proforma Invoice', Document_4_Type__c ='Proforma Invoice', Document_5_Type__c ='Proforma Invoice', Document_6_Type__c ='Proforma Invoice'
         , Document_7_Type__c ='Proforma Invoice', Document_8_Type__c ='Proforma Invoice', Document_9_Type__c ='Proforma Invoice', Document_10_Type__c ='Proforma Invoice');
         insert supplyproject;
         
         Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
         insert supplierequest;
         Associated_Document__c asociated_document = new Associated_Document__c(Name='test', Account__c=a.id, Document_Type__c='Proforma Invoice', Manual_Document_URL__c='wwwgadghfg', Supplier_Request_RFP__c=supplierequest.Id, Document_Reference__c='Document 1Document 2Document 3Document 4Document');
         insert asociated_document;
         Associated_Document__c asociated_document2 = new Associated_Document__c(Name='test', Account__c=a.id,Document_Type__c='Proforma Invoice',Manual_Document_URL__c='wwwgadghfg', Supplier_Request_RFP__c=supplierequest.Id, Document_Reference__c='5Document 6Document 7');
         insert asociated_document2;
         Associated_Document__c asociated_document3 = new Associated_Document__c(Name='test', Account__c=a.id,Document_Type__c='Proforma Invoice',Manual_Document_URL__c='wwwgadghfg', Supplier_Request_RFP__c=supplierequest.Id, Document_Reference__c='Document 8Document 9Document 10');
         insert asociated_document3;
         
         ApexPages.StandardController controller = new APexPages.StandardController(supplierequest);
         NEU_JE_RFP extension = new NEU_JE_RFP(controller);
         extension.read_document();
         extension.getIsHidden();
         extension.getshow_associated_documents();
    }
    
     public static testMethod void test_NEU_JE_RFP_ext() {
     	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        supplyproject.Starting_Time__c=Datetime.newInstance(99999999999L+DateTime.now().getTime());
        supplyproject.Reverse_Option__c=true;
        supplyproject.Auction_Manual_Status__c='Not Started';
        supplyproject.Durational_Closure_min__c=9999;
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= sup.Id , E_Commerce__c = true);
        insert item;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id,Quantity__c=1);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c( Account__c= sup.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c( Account__c= sup.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id);
        insert suprequest;        
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= suprequest.Id);
        insert supplierequestline;
        
                    

        ApexPages.currentPage().getParameters().put('rfp', suprequest.Id);
        ApexPages.currentPage().getParameters().put('email', 'email@domain.com');
        ApexPages.currentPage().getParameters().put('secret', '0000');
        NEU_JE_RFP_ext uda=new NEU_JE_RFP_ext(); 
        uda.setcloseauction(10);
        uda.getcloseauction();
        uda.getcloseauctiontext();
        uda.setstartauction(10);
        uda.getstartauction();
        uda.getstartauctiontext();
        uda.getendtimetext();
        uda.getstarttimetext();
        uda.setdynamicstateauctiontext('test');
        uda.getdynamicstateauctiontext();
        uda.setdynamicstateauction(10);
        uda.getdynamicstateauction();
        uda.setranking('10');
        uda.getranking();
        uda.getshowdocuments();
        uda.setvisited();
        uda.getquoteid();
        uda.setquoteid('');
        uda.refreshauction();
        uda.getshow_associated_documents();
        uda.getshow_document_extra();
        uda.getassociated_documents_extra();
        uda.getcanmakequestions();
        uda.makequestions();
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Price__c=10;
            for(NEU_JE_RFP_ext.Evaluation_Criteria_s cr:l.evaluationcriterias)
                cr.selected='1';
        }
        uda.quote();
        uda.getitemstosuplay();
        uda=new NEU_JE_RFP_ext();
        uda.setcloseauction(10);
        uda.getcloseauction();
        uda.getcloseauctiontext();
        uda.setstartauction(10);
        uda.getstartauction();
        uda.getstartauctiontext();
        uda.getendtimetext();
        uda.getstarttimetext();
        uda.setdynamicstateauctiontext('test');
        uda.getdynamicstateauctiontext();
        uda.setdynamicstateauction(10);
        uda.getdynamicstateauction();
        uda.setranking('10');
        uda.getranking();
        uda.getshowdocuments();
        uda.setvisited();
        uda.quote();

        supplyproject.Starting_Time__c=Datetime.newInstance(DateTime.now().getTime()-5000);
        update supplyproject;
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Price__c=1;
            for(NEU_JE_RFP_ext.Evaluation_Criteria_s cr:l.evaluationcriterias)
                cr.selected='2';
        }
        uda.quote();
        uda.getranking();
        uda.getquote();
    }
    
    
    public static testMethod void test_NEU_JE_RFP_ext1() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Contact contacto = new Contact(AccountId = sup.Id, LastName='test contact');
        insert contacto;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id ,Contact_Sent__c=contacto.id);
        insert suprequest;
        Associated_Document__c new_associated_document = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 1');
        insert new_associated_document;
        Associated_Document__c new_associated_document2 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 2');
        insert new_associated_document2;
        Associated_Document__c new_associated_document3 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 3');
        insert new_associated_document3;
        Associated_Document__c new_associated_document4 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 4');
        insert new_associated_document4;
        Associated_Document__c new_associated_document5 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 5');
        insert new_associated_document5;
        Associated_Document__c new_associated_document6 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 6');
        insert new_associated_document6;
        Associated_Document__c new_associated_document7 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 7');
        insert new_associated_document7;
        Associated_Document__c new_associated_document8 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 8');
        insert new_associated_document8;
        Associated_Document__c new_associated_document9 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 9');
        insert new_associated_document9;
        Associated_Document__c new_associated_document10 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 10');
        insert new_associated_document10;
        NEU_JE_RFP_ext uda=new NEU_JE_RFP_ext();
        uda.myid = suprequest.Id;
        uda.read_document();
    }
    
    public static testMethod void test_NEU_JE_RFP_ext2() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id,Document_1_Required__c=true,
        Document_2_Required__c=true, Document_3_Required__c=true, Document_4_Required__c=true, Document_5_Required__c=true, Document_6_Required__c=true,
        Document_7_Required__c=true, Document_8_Required__c=true, Document_9_Required__c=true, Document_10_Required__c=true);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Contact contacto = new Contact(AccountId = sup.Id, LastName='test contact');
        insert contacto;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id ,Contact_Sent__c=contacto.id);
        
        insert suprequest;
        Associated_Document__c new_associated_document = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 1');
        insert new_associated_document;
        Associated_Document__c new_associated_document2 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 2');
        insert new_associated_document2;
        Associated_Document__c new_associated_document3 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 3');
        insert new_associated_document3;
        Associated_Document__c new_associated_document4 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 4');
        insert new_associated_document4;
        Associated_Document__c new_associated_document5 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 5');
        insert new_associated_document5;
        Associated_Document__c new_associated_document6 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 6');
        insert new_associated_document6;
        Associated_Document__c new_associated_document7 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 7');
        insert new_associated_document7;
        Associated_Document__c new_associated_document8 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 8');
        insert new_associated_document8;
        Associated_Document__c new_associated_document9 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 9');
        insert new_associated_document9;
        Associated_Document__c new_associated_document10 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 10');
        insert new_associated_document10;
        NEU_JE_RFP_ext uda=new NEU_JE_RFP_ext();
        uda.myid = suprequest.Id;
        uda.read_document();
    }
    
       public static testMethod void test_NEU_JE_RFP_ext3() {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id,Document_1_Required__c=true,
        Document_2_Required__c=true, Document_3_Required__c=true, Document_4_Required__c=true, Document_5_Required__c=true, Document_6_Required__c=true,
        Document_7_Required__c=true, Document_8_Required__c=true, Document_9_Required__c=true, Document_10_Required__c=true);
        insert supplyproject;
        Contact contacto = new Contact(AccountId = sup.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= sup.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id,Quantity__c=100);
        insert items_supply;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id ,Contact_Sent__c=contacto.id);
        insert suprequest;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= suprequest.Id);
        insert supplierequestline;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id, Valid_Until__c=system.today(), Supplier_Request_RFP__c=suprequest.Id, Supplier_Quote_Status__c='Draft');
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10, Supplier_Request_RFP__c=suprequest.Id, Supplier_Request_Line__c=supplierequestline.Id);
        insert supquoteline;
        ApexPages.currentPage().getParameters().put('rfp', suprequest.Id);
        ApexPages.currentPage().getParameters().put('email', 'email@domain.com');
        ApexPages.currentPage().getParameters().put('secret', '0000');
        NEU_JE_RFP_ext uda=new NEU_JE_RFP_ext();
        //uda.newitems = null;
        uda.request = suprequest;
        uda.getitemstosuplay();
        uda.quote();
       }
       
       
       public static testMethod void test_NEU_JE_RFP_ext4() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id,Document_1_Required__c=true,
        Document_2_Required__c=true, Document_3_Required__c=true, Document_4_Required__c=true, Document_5_Required__c=true, Document_6_Required__c=true,
        Document_7_Required__c=true, Document_8_Required__c=true, Document_9_Required__c=true, Document_10_Required__c=true, Starting_Time__c=system.today().adddays(-1), Durational_Closure_min__c = 8000);
        insert supplyproject;
        Contact contacto = new Contact(AccountId = sup.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= sup.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id,Quantity__c=100, Target_Price__c=100);
        insert items_supply;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id ,Contact_Sent__c=contacto.id);
        insert suprequest;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= suprequest.Id, Unit_of_measure_RFP__c='ton', Conversion_Factor__c=1);
        insert supplierequestline;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id, Valid_Until__c=system.today(), Supplier_Request_RFP__c=suprequest.Id, Supplier_Quote_Status__c='Draft', Valid_for_Auction__c = true);
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10, Supplier_Request_RFP__c=suprequest.Id, Supplier_Request_Line__c=supplierequestline.Id, Production_Time_Days__c=10);
        insert supquoteline;
        Supplier_Quote_Line__c supquoteline2 = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10, Supplier_Request_RFP__c=suprequest.Id, Supplier_Request_Line__c=supplierequestline.Id, Item_to_Supply__c=items_supply.Id, Production_Time_Days__c=10);
        insert supquoteline2;
        ApexPages.currentPage().getParameters().put('rfp', suprequest.Id);
        ApexPages.currentPage().getParameters().put('email', 'email@domain.com');
        ApexPages.currentPage().getParameters().put('secret', '0000');
        NEU_JE_RFP_ext uda=new NEU_JE_RFP_ext();
        //uda.newitems = null;
        uda.request = suprequest;
        uda.getitemstosuplay();
        uda.quote();
       }
    
    public static testMethod void test_NEU_JE_RFP_guest(){
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Contact contacto = new Contact(AccountId = sup.Id, LastName='test contact', Other_Email__c='test@test.com', Email ='test@test.com');
        insert contacto;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id ,Contact_Sent__c=contacto.id);
        insert suprequest;
        Supplier_Request_RFP__c suprequest2 = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id);
        insert suprequest2;
        NEU_JE_RFP_guest uda=new NEU_JE_RFP_guest();
        ApexPages.currentPage().getParameters().put('rfp', suprequest.Id);
        uda=new NEU_JE_RFP_guest();
        uda.validate();
        uda.email='email@domain.com';
        uda.validate();
        uda.secret='0001';
        uda.validate();
        uda.secret='0000';
        uda.validate();
        uda.email='';
        uda.sendpin();
        uda.email='email@domain.com';
        uda.sendpin();
        uda.checkredirect();
        
        ApexPages.currentPage().getParameters().put('rfp', suprequest2.Id);
        uda=new NEU_JE_RFP_guest();
        uda.email = 'email@domain.com';
        uda.sendpin();
        uda.validate();
     }
     
      
     
     
     public static testMethod void test_NEU_JE_RFP2() {
     	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        supplyproject.Starting_Time__c=Datetime.newInstance(99999999999L+DateTime.now().getTime());
        supplyproject.Reverse_Option__c=true;
        supplyproject.Auction_Manual_Status__c='Not Started';
        supplyproject.Durational_Closure_min__c=9999;
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= sup.Id , E_Commerce__c = true);
        insert item;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id,Quantity__c=1);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c( Account__c= sup.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c( Account__c= sup.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id);
        insert suprequest;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= suprequest.Id);
        insert supplierequestline;
        
                    

        ApexPages.currentPage().getParameters().put('rfp', suprequest.Id);
        ApexPages.currentPage().getParameters().put('email', 'email@domain.com');
        ApexPages.currentPage().getParameters().put('secret', '0000');
        
        ApexPages.StandardController stdLead = new ApexPages.StandardController(suprequest);
        
        NEU_JE_RFP uda=new NEU_JE_RFP(stdLead);
        uda.setcloseauction(10);
        uda.getcloseauction();
        uda.getcloseauctiontext();
        uda.setstartauction(10);
        uda.getstartauction();
        uda.getstartauctiontext();
        uda.getendtimetext();
        uda.getstarttimetext();
        uda.setdynamicstateauctiontext('test');
        uda.getdynamicstateauctiontext();
        uda.setdynamicstateauction(10);
        uda.getdynamicstateauction();
        uda.setranking('10');
        uda.getranking();
        uda.getshowdocuments();
        uda.setvisited();
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Price__c=10;
            for(NEU_JE_RFP.Evaluation_Criteria_s cr:l.evaluationcriterias)
                cr.selected='1';
        }
        uda.quote();
        uda.getitemstosuplay();
        uda=new NEU_JE_RFP(stdLead);
        uda.setcloseauction(10);
        uda.getcloseauction();
        uda.getcloseauctiontext();
        uda.setstartauction(10);
        uda.getstartauction();
        uda.getstartauctiontext();
        uda.getendtimetext();
        uda.getstarttimetext();
        uda.setdynamicstateauctiontext('test');
        uda.getdynamicstateauctiontext();
        uda.setdynamicstateauction(10);
        uda.getdynamicstateauction();
        uda.setranking('10');
        uda.getranking();
        uda.getshowdocuments();
        uda.setvisited();
        uda.quote();

        supplyproject.Starting_Time__c=Datetime.newInstance(DateTime.now().getTime()-5000);
        update supplyproject;
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Price__c=1;
            for(NEU_JE_RFP.Evaluation_Criteria_s cr:l.evaluationcriterias)
                cr.selected='2';
        }
        uda.quote();
        uda.getranking();
        uda.getquote();
    }
    
    public static testMethod void testNEU_JE_RFP_quote_ranking() {//ok
        
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account sup = list_accounts[0];
        insert sup;
        Account buyer = list_accounts[1];
        insert buyer;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Sourcing_Item__c item2 = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item2',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item2;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Items_to_Supply__c items_supply2 = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item2.Id);
        insert items_supply2;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id, Valid_for_Auction__c = true );
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        //insert supquoteline;
        NEU_JE_RFP_quote_ranking.insertQuoteLine(supquoteline);
        //uda.getRanking(supquote.Id, supplyproject.Id);
        NEU_JE_RFP_quote_ranking.getSecret(3,'0123456789');
        NEU_JE_RFP_quote_ranking.newPassword(true);
        NEU_JE_RFP_quote_ranking.newPassword(false,null);
        
      }
     
      public static testMethod void testNEU_JE_RFP_quote_ranking2() {//ok
        
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account sup = list_accounts[0];
        insert sup;
        Account buyer = list_accounts[1];
        insert buyer;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Sourcing_Item__c item2 = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item2',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item2;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Items_to_Supply__c items_supply2 = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item2.Id);
        insert items_supply2;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id, Valid_for_Auction__c = true );
        insert supquote;
        Supplier_Quote__c supquote2 = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id, Valid_for_Auction__c = true );
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Supplier_Quote_Line__c supquoteline2 = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        NEU_JE_RFP_quote_ranking uda = new NEU_JE_RFP_quote_ranking();
        NEU_JE_RFP_quote_ranking.getRanking(supquote.Id, supplyproject.Id);
        NEU_JE_RFP_quote_ranking.insertQuote(supquote2);
        List<Supplier_Quote_Line__c> lista_supplier_quote_lines = new List<Supplier_Quote_Line__c>();
        lista_supplier_quote_lines.add(supquoteline2);
        NEU_JE_RFP_quote_ranking.insertQuoteLines(lista_supplier_quote_lines);
        NEU_JE_RFP_quote_ranking.updateLastBid(supplyproject.Id);
        NEU_JE_RFP_quote_ranking.updateStartingBid(supplyproject.Id, 100);
      //    uda.getRanking('',supplyproject.Id);
      }
      
      public static testMethod void testNEU_JE_RFP_quote_ranking3() {//ok
        
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account sup = list_accounts[0];
        insert sup;
        Account buyer = list_accounts[1];
        insert buyer;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Sourcing_Item__c item2 = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item2',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item2;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Items_to_Supply__c items_supply2 = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item2.Id);
        insert items_supply2;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id, Valid_for_Auction__c = true );
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        insert supquoteline;
        NEU_JE_RFP_quote_ranking uda = new NEU_JE_RFP_quote_ranking();
        //uda.getRanking(null,supplyproject.Id);
      }
      
      public static testMethod void testNEU_OM_FollowersSupplierRequestsRFP() {//ok
      	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=a.Id );
        insert suprequest;
        NEU_OM_FollowersSupplierRequestsRFP uda = new NEU_OM_FollowersSupplierRequestsRFP(new ApexPages.StandardController( suprequest ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
  }
  
  public static testMethod void testNEU_OM_FollowersSupplierRequestsRFP2() {//ok
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
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=a.Id );
        insert suprequest; 
        NEU_OM_FollowersSupplierRequestsRFP uda = new NEU_OM_FollowersSupplierRequestsRFP(new ApexPages.StandardController( suprequest ));
        List<EntitySubscription> entitysubcription = [select Id, SubscriberId from EntitySubscription where SubscriberId =: UserInfo.getUserId() limit 10];
        List<NEU_OM_FollowersSupplierRequestsRFP.follower_s> lista_de_followers = new List<NEU_OM_FollowersSupplierRequestsRFP.follower_s>();
        List<User> listauser = [select id, Name from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersSupplierRequestsRFP.follower_s(listauser[0],true, false, false));
        lista_de_followers.add(new NEU_OM_FollowersSupplierRequestsRFP.follower_s(listauser[0],false,false, false));
        
        List<NEU_OM_FollowersSupplierRequestsRFP.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersSupplierRequestsRFP.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersSupplierRequestsRFP.followersin_s(listauser[0],true, false, false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
  }
    static testMethod void test_NEU_JE_RFP_new()
    {//stdController.AddFields(new String[]
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Incoterm__c='FOB');
        insert supplyproject;
        Supplier_Request_RFP__c supplierequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c = a.Id, Contact_Sent__c = contacto2.Id );
        insert supplierequest;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id , E_Commerce__c = true);
        insert item;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c(Responsible_for_the_Project__c= contacto2.Id, Account__c= a.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= supplierequest.Id);
        insert supplierequestline;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=a.Id, Valid_for_Auction__c = true, Valid_Until__c=system.today() , Supplier_Request_RFP__c = supplierequest.Id,Supplier_Quote_Status__c='Draft');
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',  Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Technical_Evaluation__c tectsupquoteline = new Technical_Evaluation__c(Evaluation_Criteria__c=ecriteria.Id, Option_Selected__c='test', Score__c=2, Supplier_Quote_Line__c=supquoteline.Id );
        insert tectsupquoteline;
        
        ApexPages.StandardController controller = new APexPages.StandardController(supplierequest);
        NEU_JE_RFP uda = new NEU_JE_RFP(controller);
        uda.getquote().Valid_Until__c=system.today();
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Quantity__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Quantity__c=1;
            l.line.Price__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Production_Time_Days__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Length_cm__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Item_Units_x_Packaging__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Width_cm__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Height_cm__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Weight_kg__c=1;
        }
        for(NEU_JE_RFP.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Supplier_Item_Weight_kg__c=1;
        }
    }
    public static testMethod void test_NEU_JE_RFP_ext_new() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        supplyproject.Starting_Time__c=Datetime.newInstance(99999999999L+DateTime.now().getTime());
        supplyproject.Reverse_Option__c=true;
        supplyproject.Auction_Manual_Status__c='Not Started';
        supplyproject.Durational_Closure_min__c=9999;
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(HS_Code_Text__c='HS',Weight_Kgs__c=1,Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= sup.Id , E_Commerce__c = true);
        insert item;
        Evaluation_Criteria__c ecriteria = new Evaluation_Criteria__c(Name='test evaluation', Item__c= item.Id, Evaluation_Description__c='tset', Option_1__c='1',Option_2__c='1',Option_3__c='1',Option_4__c='1',Option_5__c='1',Score_Option_1__c=1,Score_Option_2__c=1,Score_Option_3__c=1,Score_Option_4__c=1,Score_Option_5__c=1);
        insert ecriteria;
        Items_to_Supply__c items_supply = new Items_to_Supply__c(Supply_Project__c = supplyproject.Id, Name ='test items to supply', Sourcing_Item__c= item.Id,Quantity__c=1);
        insert items_supply;
        Supplier_to_Invite__c supin = new Supplier_to_Invite__c( Account__c= sup.id,Supply_Project__c=supplyproject.Id);
        insert supin;
        Supplier_to_Invite__c supin2 = new Supplier_to_Invite__c( Account__c= sup.id,Supply_Project__c=supplyproject.Id);
        insert supin2;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id);
        insert suprequest;        
        Supplier_Request_Line__c supplierequestline = new Supplier_Request_Line__c(Name='test request line', Item_to_Supply__c=items_supply.Id,Supplier_Request_RFP__c= suprequest.Id);
        insert supplierequestline;
        
                    

        ApexPages.currentPage().getParameters().put('rfp', suprequest.Id);
        ApexPages.currentPage().getParameters().put('email', 'email@domain.com');
        ApexPages.currentPage().getParameters().put('secret', '0000');
        NEU_JE_RFP_ext uda=new NEU_JE_RFP_ext(); 
        uda.getquote().Valid_Until__c=system.today();
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Quantity__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Quantity__c=1;
            l.line.Price__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Production_Time_Days__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Length_cm__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Item_Units_x_Packaging__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Width_cm__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Height_cm__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Packaging_Weight_kg__c=1;
        }
        for(NEU_JE_RFP_ext.Supplier_Quote_Line_s l:uda.getitemstosuplay())
        {
            l.line.Supplier_Item_Weight_kg__c=1;
        }
        
    }
    
    public static testMethod void test_NEU_JE_RFP2_new() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id,Document_1_Required__c=true,
        Document_2_Required__c=true, Document_3_Required__c=true, Document_4_Required__c=true, Document_5_Required__c=true, Document_6_Required__c=true,
        Document_7_Required__c=true, Document_8_Required__c=true, Document_9_Required__c=true, Document_10_Required__c=true);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Contact contacto = new Contact(AccountId = sup.Id, LastName='test contact');
        insert contacto;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id ,Contact_Sent__c=contacto.id);
        
        insert suprequest;
        Associated_Document__c new_associated_document = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 1');
        insert new_associated_document;
        Associated_Document__c new_associated_document2 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 2');
        insert new_associated_document2;
        Associated_Document__c new_associated_document3 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 3');
        insert new_associated_document3;
        Associated_Document__c new_associated_document4 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 4');
        insert new_associated_document4;
        Associated_Document__c new_associated_document5 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 5');
        insert new_associated_document5;
        Associated_Document__c new_associated_document6 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 6');
        insert new_associated_document6;
        Associated_Document__c new_associated_document7 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 7');
        insert new_associated_document7;
        Associated_Document__c new_associated_document8 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 8');
        insert new_associated_document8;
        Associated_Document__c new_associated_document9 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 9');
        insert new_associated_document9;
        Associated_Document__c new_associated_document10 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 10');
        insert new_associated_document10;
        Supplier_Request_RFP__c rfp=[select Id, State_of_Load__c, Document_1_Required__c,Supplier__c,Document_2_Required__c,Document_3_Required__c,Document_4_Required__c,Document_5_Required__c,Document_6_Required__c,Document_7_Required__c,Document_8_Required__c,Document_9_Required__c,Document_10_Required__c,Document_1_Type__c,Document_2_Type__c,Document_3_Type__c,Document_4_Type__c,Document_5_Type__c,Document_6_Type__c,Document_7_Type__c,Document_8_Type__c,Document_9_Type__c,Document_10_Type__c,Supply_Project__c,Port_Airport_of_Load__c,Country_of_Load__c,Customer__c,Incoterm_Request__c,Incoterm_Place__c,Max_Shipment__c,Contract_Duration__c,Supply_Project__r.Sealed__c from Supplier_Request_RFP__c where id=:suprequest.id];
        ApexPages.StandardController controller = new APexPages.StandardController(rfp);
        NEU_JE_RFP uda = new NEU_JE_RFP(controller);
        uda.read_document();
    }
    public static testMethod void test_NEU_JE_RFP_1_new() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Line__c supquoteline = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id,Name='test supplier line',Price__c = 10, Quantity__c=10);
        insert supquoteline;
        Contact contacto = new Contact(AccountId = sup.Id, LastName='test contact');
        insert contacto;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id ,Contact_Sent__c=contacto.id);
        insert suprequest;
        Associated_Document__c new_associated_document = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 1');
        insert new_associated_document;
        Associated_Document__c new_associated_document2 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 2');
        insert new_associated_document2;
        Associated_Document__c new_associated_document3 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 3');
        insert new_associated_document3;
        Associated_Document__c new_associated_document4 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 4');
        insert new_associated_document4;
        Associated_Document__c new_associated_document5 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 5');
        insert new_associated_document5;
        Associated_Document__c new_associated_document6 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 6');
        insert new_associated_document6;
        Associated_Document__c new_associated_document7 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 7');
        insert new_associated_document7;
        Associated_Document__c new_associated_document8 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 8');
        insert new_associated_document8;
        Associated_Document__c new_associated_document9 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 9');
        insert new_associated_document9;
        Associated_Document__c new_associated_document10 = new Associated_Document__c(Name='test associated document', Account__c=a.Id, 
        Supplier_Request_RFP__c=suprequest.Id , Document_Reference__c ='Document 10');
        insert new_associated_document10;
        ApexPages.StandardController controller = new APexPages.StandardController(suprequest);
        NEU_JE_RFP uda=new NEU_JE_RFP(controller);
        uda.read_document();
    }
}