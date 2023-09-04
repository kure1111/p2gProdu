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
private class NEU_test_Associated_Documents 
{
    @testSetup
    static void SetUp(){
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);
        
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer');
        insert list_accounts;
        Account cuenta = list_accounts[0];

    }
    
	public static testMethod void testNEU_MD_Associated_Documents_old()
	{
    	NEU_StaticVariableHelper.setBoolean1(true);
    	    
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        Associated_Document__c ad=new Associated_Document__c(Shopping_Cart__c=shop.id,Account__c=a.id);
        insert ad;
        //Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        //insert ship;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', shop.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        uda.display_buttons1=uda.display_buttons1;
        uda.display_buttons2=uda.display_buttons2;
        uda.url_base=uda.url_base;
        uda.id_cabecera=uda.id_cabecera;
        
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        uda.Upload_Documents(); 
        uda.cancel_document(); 
  	}
  
  	public static testMethod void testNEU_MD_Associated_Documents12_old()
  	{
  		NEU_StaticVariableHelper.setBoolean1(true);
  		
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'Shipment 2',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Associated_Document__c ad=new Associated_Document__c(Shipment__c =ship.id,Account__c=a.id);
        insert ad;
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        ApexPages.currentPage().getParameters().put('id', ship.Id);
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        List< NEU_MD_Associated_Documents_old.others_document_s> new_list = new  list< NEU_MD_Associated_Documents_old.others_document_s>();
        boolean primero = true;
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
            if(primero == true)
            	new_list.add(od);
            primero = false;
        }
        uda.List_personal_documents = new_list;
        uda.estoy_en_site = true;
        uda.shipment_reference = ship;
        uda.Upload_Document();
  	}
  
    public static testMethod void testNEU_MD_Associated_Documents2_old()
    {
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', a.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        
        uda.cancel_document();
  	}
  	
    public static testMethod void testNEU_MD_Associated_Documents3_old()
    {
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Shipment__c ship = new Shipment__c(Name = 'Shipment 3', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        Claim__c claim = new Claim__c(Customer__c = a.Id, Shopping_Cart__c = shop.Id, Shipment__c =ship.Id, Supply_Project__c=supplyproject.Id);
        insert claim;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', claim.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

	public static testMethod void testNEU_MD_Associated_Documents4_old()
	{
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id,Customer__c=a.Id);
        insert supquote;
        Shipment__c ship = new Shipment__c(Name = 'Shipment 4', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Shopping_Cart__c= shop.Id, Supplier_Quote__c= supquote.Id);
        insert shipconsodata;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', shipconsodata.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'Acuse';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

    public static testMethod void testNEU_MD_Associated_Documents5_old()
    {
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'Shipment 5', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', transporpack.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        uda.estoy_en_site = true;
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

	public static testMethod void testNEU_MD_Associated_Documents6_old()
	{
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'Shipment 6', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', ship.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        uda.estoy_en_site = true;
        uda.shipment_reference = ship;
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

   	public static testMethod void testNEU_MD_Associated_Documents7_old()
   	{
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id,Customer__c=a.Id);
        insert supquote;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', supquote.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

  	public static testMethod void testNEU_MD_Associated_Documents9_old()
  	{
		NEU_StaticVariableHelper.setBoolean1(true);

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
        Shipment__c ship = new Shipment__c(Name='name4',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Claim__c claim = new Claim__c(Customer__c = a.Id);
        insert claim;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id);
        insert shipconsodata;

        ApexPages.currentPage().getParameters().put('test', 'test'); 
        ApexPages.currentPage().getParameters().put('id', supplyproject.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

   	public static testMethod void testNEU_MD_Associated_Documents10_old()
   	{
		NEU_StaticVariableHelper.setBoolean1(true);

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
        Shipment__c ship = new Shipment__c(Name='name3',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Price_List__c pricelist = new Price_List__c(Name = 'Test pircelist',Business_Area__c = 'Other Services', Items_Account_Owner__c = a.Id);
        insert pricelist;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = pricelist.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Shopping_Cart__c= shop.Id, Supplier_Quote__c= supquote.Id, Import_Export_Quote__c =importexportquote.Id);
        insert shipconsodata;
        Claim__c claim = new Claim__c(Customer__c = a.Id, Shopping_Cart__c = shop.Id, Shipment__c =ship.Id, Supply_Project__c=supplyproject.Id);
        insert claim;
        ApexPages.currentPage().getParameters().put('test', 'test'); 
        ApexPages.currentPage().getParameters().put('id', importexportquote.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

    public static testMethod void testNEU_MD_Associated_Documents11_old()
    {
		NEU_StaticVariableHelper.setBoolean1(true);

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
        Shipment__c ship = new Shipment__c(Name = 'Shipment 1',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Price_List__c pricelist = new Price_List__c(Name = 'Test pircelist',Business_Area__c = 'Other Services' , Items_Account_Owner__c = a.Id);
        insert pricelist;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = pricelist.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Shopping_Cart__c= shop.Id, Supplier_Quote__c= supquote.Id, Import_Export_Quote__c =importexportquote.Id);
        insert shipconsodata;
        Claim__c claim = new Claim__c(Customer__c = a.Id, Shopping_Cart__c = shop.Id, Shipment__c =ship.Id, Supply_Project__c=supplyproject.Id);
        insert claim;
        Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id);
        insert shipdis;
        ApexPages.currentPage().getParameters().put('test', 'test'); 
        ApexPages.currentPage().getParameters().put('id', shipdis.Id);
         NEU_MD_Associated_Documents_old uda = new  NEU_MD_Associated_Documents_old();
        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        uda.tipo_documento_id = 'test';
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for( NEU_MD_Associated_Documents_old.others_document_s od : uda.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        
        uda.Upload_Documents(); 
        uda.cancel_document();
  	}

   	public static testMethod void NEU_Associated_document_form_request()
   	{
   		NEU_StaticVariableHelper.setBoolean1(true);

      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
      Account a = list_accounts[0];
      insert a;
      Account sup = list_accounts[1];
      insert sup;
      Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Other Services', Items_Account_Owner__c = a.Id);
      insert b;
      User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
      Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
      Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true,Pricing_Executive__c= userT.Id,Operations_Exec__c = userT.Id);
      insert importexportquote;
      SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
      insert scm_contract;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
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
      Shipment__c ship = new Shipment__c(Name='name2',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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

      ApexPages.currentPage().getParameters().put('id', supquote.Id);
      NEU_Associated_document_form_request uda = new NEU_Associated_document_form_request();
      uda.Manual_Document_URL ='test';
      Blob b2 = Blob.valueOf('Test Data');
      uda.documento_asociadoName='Test document.test';
     // uda.documento_asociado.AuthorId = UserInfo.getUserId();
     // uda.documento_asociado.IsPublic=true;
      uda.documento_asociado = b2;
      uda.gettypes();
      uda.get_Document();
      uda.Upload_Documents();
   }

   public static testMethod void NEU_Associated_10Documents_Request()
   {
   	NEU_StaticVariableHelper.setBoolean1(true);
   	
      ApexPages.currentPage().getParameters().put('test', 'test');
      
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
      Account a = list_accounts[0];
      insert a;
      User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
      Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
      Account sup = list_accounts[1];
      insert sup;
      Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Other Services', Items_Account_Owner__c = a.Id);
      insert b;
      Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c  = true,Pricing_Executive__c= userT.Id,Operations_Exec__c = userT.Id);
      insert importexportquote;
      SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
      insert scm_contract;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
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
      Shipment__c ship = new Shipment__c(Name='holi',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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


      ApexPages.currentPage().getParameters().put('id', supquote.Id); 
      ApexPages.currentPage().getParameters().put('docu', '1');
      ApexPages.currentPage().getParameters().put('docu', '2');
      ApexPages.currentPage().getParameters().put('docu', '3');
      ApexPages.currentPage().getParameters().put('docu', '4');
      ApexPages.currentPage().getParameters().put('docu', '5');
      ApexPages.currentPage().getParameters().put('docu', '6');
      ApexPages.currentPage().getParameters().put('docu', '7');
      ApexPages.currentPage().getParameters().put('docu', '8');
      ApexPages.currentPage().getParameters().put('docu', '9');
      ApexPages.currentPage().getParameters().put('docu', '10');

      NEU_Associated_10Documents_Request uda = new NEU_Associated_10Documents_Request();
      Blob b2 = Blob.valueOf('Test Data');
      uda.documento_asociadoName='Test document.test';
      //uda.documento_asociado.AuthorId = UserInfo.getUserId();
      //uda.documento_asociado.IsPublic=true;
      uda.documento_asociado = b2;
      uda.gettype_document();
      uda.Upload_Documents();

   }

   public static testMethod void testNEU_OM_FollowersAssociatedDocuments2() {//ok
		NEU_StaticVariableHelper.setBoolean1(true);
		
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
      Account a = list_accounts[0];
      insert a;
      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto;
      Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto2;
      Account sup = list_accounts[1];
      insert sup;
      Contact contacto3 = new Contact(AccountId = sup.Id, LastName='test contact');
      insert contacto3;
      Contact contacto4 = new Contact(AccountId = sup.Id, LastName='test contact');
      insert contacto4;
      Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Other Services', Items_Account_Owner__c = a.Id);
      insert b;
      Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
      insert importexportquote;
      SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
      insert scm_contract;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
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
      Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-002', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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
      
      //EntitySubscription new_entitysubcription = new EntitySubscription(ParentId = new_associated_document.Id, SubscriberId = system.Userinfo.getUserId());
     // insert new_entitysubcription;
      
      NEU_OM_FollowersAssociatedDocuments uda = new NEU_OM_FollowersAssociatedDocuments(new ApexPages.StandardController( new_associated_document ));
        List<NEU_OM_FollowersAssociatedDocuments.follower_s> lista_de_followers = new List<NEU_OM_FollowersAssociatedDocuments.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersAssociatedDocuments.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersAssociatedDocuments.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersAssociatedDocuments.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersAssociatedDocuments.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersAssociatedDocuments.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
    }
    
   public static testMethod void testNEU_OM_FollowersAssociatedDocuments() {//ok
		NEU_StaticVariableHelper.setBoolean1(true);

      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
      Account a = list_accounts[0];
      insert a;
      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto;
      Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto2;
      Account sup = list_accounts[1];
      insert sup;
      
      Contact contacto3 = new Contact(AccountId = sup.Id, LastName='test contact');
      insert contacto3;
      Contact contacto4 = new Contact(AccountId = sup.Id, LastName='test contact');
      insert contacto4;
      Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Other Services', Items_Account_Owner__c = a.Id);
      insert b;
      Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
      insert importexportquote;
      SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
      insert scm_contract;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
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
      Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-001', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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
      
      //EntitySubscription new_entitysubcription = new EntitySubscription(ParentId = new_associated_document.Id, SubscriberId = system.Userinfo.getUserId());
     // insert new_entitysubcription;
      
      NEU_OM_FollowersAssociatedDocuments uda = new NEU_OM_FollowersAssociatedDocuments(new ApexPages.StandardController( new_associated_document ));
      uda.getfollower();
      uda.getfollowersin();
      uda.nuevalinea();
      uda.quitarlinea();
    }

    public static testMethod void testNEU_MD_Associated_Documents()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer');
        insert list_accounts;
        Account cuenta = list_accounts[0];

        List<Shopping_Cart__c> list_shopping = NEU_Data_Generator.getShopping(cuenta);
        insert list_shopping;
        Shopping_Cart__c shop = list_shopping[0];

        List<Associated_Document__c> list_documento_asociado = NEU_Data_Generator.getAssociatedDocument(cuenta, null);
        Associated_Document__c documentoasociado = list_documento_asociado[0];
        documentoasociado.Shopping_Cart__c=shop.id;
        insert list_documento_asociado;
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0010',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', shop.Id);

        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();
        ad.display_buttons1=ad.display_buttons1;
        ad.display_buttons2=ad.display_buttons2;
        ad.url_base=ad.url_base;
        ad.id_cabecera=ad.id_cabecera;

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.Upload_Documents();
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents12()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer');
        insert list_accounts;
        Account cuenta = list_accounts[0];
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0013',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        List<Associated_Document__c> list_documento_asociado = NEU_Data_Generator.getAssociatedDocument(cuenta, null);
        Associated_Document__c document = list_documento_asociado[0];
        document.Shipment__c = ship.Id;
        insert list_documento_asociado;


        ApexPages.currentPage().getParameters().put('id', ship.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;

        ad.tipo_documento_id = 'test';
        List<NEU_MD_Associated_Documents.others_document_s> new_list = new  list<NEU_MD_Associated_Documents.others_document_s>();
        boolean primero = true;

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
            if(primero == true)
                new_list.add(od);
            primero = false;
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.List_personal_documents = new_list;
        ad.estoy_en_site = true;
        ad.shipment_reference = ship;
        ad.Upload_Document();
    }

    public static testMethod void testNEU_MD_Associated_Documents2()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer');
        insert list_accounts;
        Account cuenta = list_accounts[0];

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', cuenta.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents3()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer');
        insert list_accounts;
        Account cuenta = list_accounts[0];

        List<Supply_Project__c> list_supplyproject = NEU_Data_Generator.getSupplyProject(cuenta);
        insert list_supplyproject;
        Supply_Project__c supplyproject = list_supplyproject[0];
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0014',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        List<Shopping_Cart__c> list_shopping = NEU_Data_Generator.getShopping(cuenta);
        insert list_shopping;
        Shopping_Cart__c shop = list_shopping[0];

        List<Claim__c> list_claim = NEU_Data_Generator.getClaim(cuenta);
        Claim__c claim = list_claim[0];
        claim.Shopping_Cart__c = shop.Id;
        claim.Shipment__c = ship.Id;
        claim.Supply_Project__c = supplyproject.Id;
        insert list_claim;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.Upload_Documents();
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents4()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        insert list_accounts;
        Account cuenta = list_accounts[0];
        Account sup = list_accounts[1];

        List<Supply_Project__c> list_supplyproject = NEU_Data_Generator.getSupplyProject(cuenta);
        insert list_supplyproject;
        Supply_Project__c supplyproject = list_supplyproject[0];

        List<Supplier_Quote__c> list_supquote = NEU_Data_Generator.getSupplierQuote(sup, supplyproject, null);
        Supplier_Quote__c supquote = list_supquote[0];
        supquote.Customer__c = cuenta.Id;
        insert list_supquote;
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0015',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        List<Shopping_Cart__c> list_shopping = NEU_Data_Generator.getShopping(cuenta);
        insert list_shopping;
        Shopping_Cart__c shop = list_shopping[0];

        List<Shipment_Consolidation_Data__c> list_shipmentconsolidation = NEU_Data_Generator.getShipmentConsolidation(ship, null);
        Shipment_Consolidation_Data__c shipconsodata = list_shipmentconsolidation[0];
        shipconsodata.Shopping_Cart__c= shop.Id;
        shipconsodata.Supplier_Quote__c= supquote.Id;
        insert list_shipmentconsolidation;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', shipconsodata.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.Upload_Documents();
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents5()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer');
        insert list_accounts;
        Account cuenta = list_accounts[0];
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0016',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        List<Transport_Packaging_Data__c> list_transport = NEU_Data_Generator.getTransport(ship);
        insert list_transport;
        Transport_Packaging_Data__c transporpack = list_transport[0];

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', transporpack.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.estoy_en_site = true;
        ad.Upload_Documents();
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents6()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer');
        insert list_accounts;
        Account cuenta = list_accounts[0];
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0017',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', ship.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.estoy_en_site = true;
        ad.shipment_reference = ship;
        ad.Upload_Documents();
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents7()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        insert list_accounts;
        Account cuenta = list_accounts[0];
        Account sup = list_accounts[1];

        List<Supply_Project__c> list_supplyproject = NEU_Data_Generator.getSupplyProject(cuenta);
        insert list_supplyproject;
        Supply_Project__c supplyproject = list_supplyproject[0];

        List<Supplier_Quote__c> list_supquote = NEU_Data_Generator.getSupplierQuote(sup, supplyproject, null);
        Supplier_Quote__c supquote = list_supquote[0];
        supquote.Customer__c = cuenta.Id;
        insert list_supquote;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', supquote.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.Upload_Documents();
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents9()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        insert list_accounts;
        Account cuenta = list_accounts[0];
        Account sup = list_accounts[1];

        List<Supply_Project__c> list_supplyproject = NEU_Data_Generator.getSupplyProject(cuenta);
        insert list_supplyproject;
        Supply_Project__c supplyproject = list_supplyproject[0];

        List<Supplier_Request_RFP__c> list_supplierrequest = NEU_Data_Generator.getSupplierRequestRFP(sup, supplyproject);
        insert list_supplierrequest;
        Supplier_Request_RFP__c supplierrequest = list_supplierrequest[0];

        List<Supplier_Quote__c> list_supquote = NEU_Data_Generator.getSupplierQuote(sup, supplyproject, supplierrequest);
        insert list_supquote;
        Supplier_Quote__c supquote = list_supquote[0];
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0018',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        List<Claim__c> list_claim = NEU_Data_Generator.getClaim(cuenta);
        insert list_claim;
        Claim__c claim = list_claim[0];

        List<Shopping_Cart__c> list_shopping = NEU_Data_Generator.getShopping(cuenta);
        insert list_shopping;
        Shopping_Cart__c shop = list_shopping[0];

        List<Transport_Packaging_Data__c> list_transport = NEU_Data_Generator.getTransport(ship);
        insert list_transport;
        Transport_Packaging_Data__c transporpack = list_transport[0];

        List<Shipment_Consolidation_Data__c> list_shipmentconsolidation = NEU_Data_Generator.getShipmentConsolidation(ship, null);
        insert list_shipmentconsolidation;
        Shipment_Consolidation_Data__c shipconsodata = list_shipmentconsolidation[0];

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', supplyproject.Id);
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.Upload_Documents();
        ad.cancel_document();
    }

    public static testMethod void testNEU_MD_Associated_Documents10()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        insert list_accounts;
        Account cuenta = list_accounts[0];
        Account sup = list_accounts[1];

        List<Supply_Project__c> list_supplyproject = NEU_Data_Generator.getSupplyProject(cuenta);
        insert list_supplyproject;
        Supply_Project__c supplyproject = list_supplyproject[0];

        List<Supplier_Request_RFP__c> list_supplierrequest = NEU_Data_Generator.getSupplierRequestRFP(sup, supplyproject);
        insert list_supplierrequest;
        Supplier_Request_RFP__c supplierrequest = list_supplierrequest[0];

        List<Supplier_Quote__c> list_supquote = NEU_Data_Generator.getSupplierQuote(sup, supplyproject, supplierrequest);
        insert list_supquote;
        Supplier_Quote__c supquote = list_supquote[0];
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0011',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        List<Shopping_Cart__c> list_shopping = NEU_Data_Generator.getShopping(cuenta);
        insert list_shopping;
        Shopping_Cart__c shop = list_shopping[0];

        List<Transport_Packaging_Data__c> list_transport = NEU_Data_Generator.getTransport(ship);
        insert list_transport;
        Transport_Packaging_Data__c transporpack = list_transport[0];

        List<Price_List__c> list_pricelist = NEU_Data_Generator.getPriceList(cuenta, null);
        insert list_pricelist;
        Price_List__c price = list_pricelist[0];

        List<Customer_Quote__c> list_importexport = NEU_Data_Generator.getImportExport(cuenta, 'Air', 1);
        Customer_Quote__c importexportquote = list_importexport[0];
        importexportquote.Catalog_Price_List__c = price.Id;
        insert list_importexport;

        List<Shipment_Consolidation_Data__c> list_shipmentconsolidation = NEU_Data_Generator.getShipmentConsolidation(ship, importexportquote);
        Shipment_Consolidation_Data__c shipconsodata = list_shipmentconsolidation[0];
        shipconsodata.Shopping_Cart__c= shop.Id;
        shipconsodata.Supplier_Quote__c= supquote.Id;
        insert list_shipmentconsolidation;

        List<Claim__c> list_claim = NEU_Data_Generator.getClaim(cuenta);
        Claim__c claim = list_claim[0];
        claim.Shopping_Cart__c = shop.Id;
        claim.Shipment__c = ship.Id;
        claim.Supply_Project__c = supplyproject.Id;
        insert list_claim;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', importexportquote.Id);
        if(!Test.isRunningTest()){
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.Upload_Documents();
        ad.cancel_document();
        }
    }

    public static testMethod void testNEU_MD_Associated_Documents11()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        insert list_accounts;
        Account cuenta = list_accounts[0];
        Account sup = list_accounts[1];

        List<Supply_Project__c> list_supplyproject = NEU_Data_Generator.getSupplyProject(cuenta);
        insert list_supplyproject;
        Supply_Project__c supplyproject = list_supplyproject[0];

        List<Supplier_Request_RFP__c> list_supplierrequest = NEU_Data_Generator.getSupplierRequestRFP(sup, supplyproject);
        insert list_supplierrequest;
        Supplier_Request_RFP__c supplierrequest = list_supplierrequest[0];

        List<Supplier_Quote__c> list_supquote = NEU_Data_Generator.getSupplierQuote(sup, supplyproject, supplierrequest);
        insert list_supquote;
        Supplier_Quote__c supquote = list_supquote[0];
/*
        List<Shipment__c> list_shipment = NEU_Data_Generator.getShipment(cuenta, 'Sea');
        insert list_shipment;
        Shipment__c ship = list_shipment[0];*/
        Shipment__c ship = new Shipment__c(Name = 'SP-FN-23-0012',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;

        List<Shopping_Cart__c> list_shopping = NEU_Data_Generator.getShopping(cuenta);
        insert list_shopping;
        Shopping_Cart__c shop = list_shopping[0];

        List<Transport_Packaging_Data__c> list_transport = NEU_Data_Generator.getTransport(ship);
        insert list_transport;
        Transport_Packaging_Data__c transporpack = list_transport[0];

        List<Price_List__c> list_pricelist = NEU_Data_Generator.getPriceList(cuenta, null);
        insert list_pricelist;
        Price_List__c price = list_pricelist[0];

        List<Customer_Quote__c> list_importexport = NEU_Data_Generator.getImportExport(cuenta, 'Air', 1);
        Customer_Quote__c importexportquote = list_importexport[0];
        importexportquote.Catalog_Price_List__c = price.id;
        insert list_importexport;

        List<Shipment_Consolidation_Data__c> list_shipmentconsolidation = NEU_Data_Generator.getShipmentConsolidation(ship, importexportquote);
        Shipment_Consolidation_Data__c shipconsodata = list_shipmentconsolidation[0];
        shipconsodata.Shopping_Cart__c = shop.Id;
        shipconsodata.Supplier_Quote__c = supquote.Id;
        insert list_shipmentconsolidation;

        List<Claim__c> list_claim = NEU_Data_Generator.getClaim(cuenta);
        Claim__c claim = list_claim[0];
        claim.Shopping_Cart__c = shop.Id;
        claim.Shipment__c =ship.Id;
        claim.Supply_Project__c=supplyproject.Id;
        insert list_claim;

        List<Shipment_Disbursement__c> list_shipdis = NEU_Data_Generator.getShipmentDisbursement(cuenta);
        Shipment_Disbursement__c shipdis = list_shipdis[0];
        shipdis.Shipment__c = ship.Id;
        insert list_shipdis;

        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', shipdis.Id);
        if(!Test.isRunningTest()){
        NEU_MD_Associated_Documents ad = new NEU_MD_Associated_Documents();

        Blob b = Blob.valueOf('Test Data');
        Document new_document = new Document();
        new_document.Name='Test document.test';
        new_document.AuthorId = UserInfo.getUserId();
        new_document.IsPublic=true;
        new_document.Body = b;
        ad.tipo_documento_id = 'test';

        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_personal_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        for(NEU_MD_Associated_Documents.others_document_s od : ad.getList_others_documents())
        {
            od.documento_asociado = b;
            od.documento_asociadoName ='Test document.test';
            od.Document_Type ='test';
        }
        ad.documentos_subir_name='{"test":"https://associateddocs.s3.amazonaws.com/Accounts/test_117201912216.txt"}';
        ad.Upload_Documents();
        ad.cancel_document();
        }
    }


    static testMethod void testNEU_Show_File()
    {
        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Supplier,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;

        ContentVersion cvFile = new ContentVersion();//Es el fichero en sí mismo
        cvFile.ContentLocation = 'S'; //S==SALESFORCE
        Blob blobtest = Blob.valueOf('Test Data');
        cvFile.VersionData = blobtest;
        cvFile.Title = 'Test document';
        cvFile.PathOnClient = 'Test document';
        insert cvFile;

        Id content_document_id = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cvFile.Id].ContentDocumentId;

        /*ContentDocumentLink cdLinkRelationship = new ContentDocumentLink();
       cdLinkRelationship.ContentDocumentId = content_document_id;
       cdLinkRelationship.LinkedEntityId = account_test.Id;
       cdLinkRelationship.ShareType = 'V';
       cdLinkRelationship.Visibility = 'AllUsers';
       insert cdLinkRelationship;*/

        ApexPages.currentPage().getParameters().put('id', cvFile.Id);
        ApexPages.currentPage().getParameters().put('contentType', 'application/pdf');
        NEU_Show_File test_controller = new NEU_Show_File();
        test_controller.getDocumentBase64();
    }
    
}