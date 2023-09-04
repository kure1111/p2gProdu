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
private class NEU_test_SendDocuments {

    public static testMethod void test_NEU_Generic_SendDocuments_1() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id, Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
          
        ApexPages.currentPage().getParameters().put('object_select', 'shopping_cart');
        ApexPages.currentPage().getParameters().put('object_id', shop.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }

    public static testMethod void test_NEU_Generic_SendDocuments_2() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
          
        ApexPages.currentPage().getParameters().put('object_select', 'account');
        ApexPages.currentPage().getParameters().put('object_id', a.Id);
          
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }
  
    public static testMethod void test_NEU_Generic_SendDocuments_3() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', claim.Id);
          
        ApexPages.currentPage().getParameters().put('object_select', 'claim');
        ApexPages.currentPage().getParameters().put('object_id', claim.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }
  
    public static testMethod void test_NEU_Generic_SendDocuments_4() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', shipconsodata.Id);
          
        ApexPages.currentPage().getParameters().put('object_select', 'shipment_consolidation_data');
        ApexPages.currentPage().getParameters().put('object_id', shipconsodata.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }
  
    public static testMethod void test_NEU_Generic_SendDocuments_5() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
            
        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', transporpack.Id);
        
        ApexPages.currentPage().getParameters().put('object_select', 'transport_packaging_data');
        ApexPages.currentPage().getParameters().put('object_id', transporpack.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }
  
    public static testMethod void test_NEU_Generic_SendDocuments_6() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', supquote.Id);
          
        ApexPages.currentPage().getParameters().put('object_select', 'supplier_quote');
        ApexPages.currentPage().getParameters().put('object_id', supquote.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }

    public static testMethod void test_NEU_Generic_SendDocuments_7() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
            
        ApexPages.currentPage().getParameters().put('test', 'test');
        ApexPages.currentPage().getParameters().put('id', suprequest.Id);
          
        ApexPages.currentPage().getParameters().put('object_select', 'supplier_request_rfp');
        ApexPages.currentPage().getParameters().put('object_id', suprequest.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        Blob b = Blob.valueOf('Test Data');
        List<Folder> folder_document = [select Id from Folder where Name=: 'Associated Documents'];
        document documento = new Document ();
        if(folder_document.size()>0)
        {
            documento.Name='test.test';
            documento.Body=b;
            documento.FolderId=folder_document[0].Id;
            documento.DeveloperName ='test_test_test';
        }
        else
        {
            documento.Name='test.test';
            documento.Body=b;
            documento.DeveloperName ='test_test_test';
        }
        insert documento;
        List<NEU_Generic_SendDocuments.documents_s> atpd = new List<NEU_Generic_SendDocuments.documents_s>();
        atpd.add(new NEU_Generic_SendDocuments.documents_s(true, 'name', 'type document', 'document refere', 'docu description', 'url', documento.id, 10, '10%'));
        uda.associated_documents = atpd;
        for(NEU_Generic_SendDocuments.documents_s lo :  uda.associated_documents)
        {
            lo.selected = true;
            lo.id_doc = documento.Id;
        }   
        uda.send_email();
    }
  
    public static testMethod void test_NEU_Generic_SendDocuments_8() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        
        ApexPages.currentPage().getParameters().put('test', 'test'); 
        ApexPages.currentPage().getParameters().put('id', supplyproject.Id);
        
        ApexPages.currentPage().getParameters().put('object_select', 'supply_project');
        ApexPages.currentPage().getParameters().put('object_id', supplyproject.Id);
              
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        Blob b = Blob.valueOf('Test Data');
        Document documento = new Document();
        documento.Name='Test document.test';
        documento.AuthorId = UserInfo.getUserId();
        documento.IsPublic=true;
        documento.Body = b;
        documento.FolderId = UserInfo.getUserId();
        documento.DeveloperName ='test';
        insert documento;
        Associated_Document__c documento_asociado2 = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c=documento.Url, Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c=documento.Url, SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado2;
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }
 
    public static testMethod void test_NEU_Generic_SendDocuments_9() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
          
        ApexPages.currentPage().getParameters().put('test', 'test'); 
        ApexPages.currentPage().getParameters().put('id', shipdis.Id);
          
        ApexPages.currentPage().getParameters().put('object_select', 'shipment_disbursement');
        ApexPages.currentPage().getParameters().put('object_id', shipdis.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
    }
  
  
    public static testMethod void test_NEU_Generic_SendDocuments_10() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email ='test@test.com');
        insert contacto;
        Contact supcontacto = new Contact(AccountId = sup.Id, LastName='test contact2', Email ='test2@test.com');
        insert supcontacto;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
        insert scm_contract;
        Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
        insert documento_asociado;
              
        ApexPages.currentPage().getParameters().put('test', 'test'); 
        ApexPages.currentPage().getParameters().put('id', shipdis.Id);
              
        ApexPages.currentPage().getParameters().put('object_select', 'shipment_disbursement');
        ApexPages.currentPage().getParameters().put('object_id', shipdis.Id);
        
        NEU_Generic_SendDocuments uda = new NEU_Generic_SendDocuments();
        
        uda.to='test@tst.com;';
        uda.cc='test@tst.com;';
        uda.load_documents();
        uda.send_email();
        uda.return_shipment();
        List<NEU_Generic_SendDocuments.documents_s> lines4=new List<NEU_Generic_SendDocuments.documents_s>();
        lines4.add(new NEU_Generic_SendDocuments.documents_s(true,'test name','type','ref', 'document descripcion', 'url',documento_asociado.Id, 100, '10'));
        for(NEU_Generic_SendDocuments.documents_s documents : uda.associated_documents)
            documents.selected = true;
    }
    
    public static testMethod void testNEU_MD_SendDocuments() 
    {
          NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;

          Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email='oscar@neurored.com');
          insert contacto;

          Contact contacto2 = new Contact(AccountId = sup.Id, LastName='test contact2', Email='oscar2@neurored.com');
          insert contacto2;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	     
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id, Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'shopping_cart');
	      ApexPages.currentPage().getParameters().put('object_id', shop.Id);
	      
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
          uda.create_task = true;

          List<NEU_MD_SendDocuments.contacto_s> clientes_contactos_new = new List<NEU_MD_SendDocuments.contacto_s>();
          clientes_contactos_new.add(new NEU_MD_SendDocuments.contacto_s(contacto, true, 'oscar@neurored.com'));

          List<NEU_MD_SendDocuments.cuenta_s> clientes_seleccionados_new = new List<NEU_MD_SendDocuments.cuenta_s>();
          clientes_seleccionados_new.add(new NEU_MD_SendDocuments.cuenta_s(a, clientes_contactos_new,'Customer'));
          uda.clientes_seleccionados = clientes_seleccionados_new;
          uda.send_email();


  }
  
  
    public static testMethod void testNEU_MD_SendDocuments2() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
      	  List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'account');
	      ApexPages.currentPage().getParameters().put('object_id', a.Id);
	      
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
          uda.create_task = true;
	      uda.send_email();
  	}
  
     public static testMethod void testNEU_MD_SendDocuments3() 
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	    
	      ApexPages.currentPage().getParameters().put('test', 'test');
	      ApexPages.currentPage().getParameters().put('id', claim.Id);
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'claim');
	      ApexPages.currentPage().getParameters().put('object_id', claim.Id);
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();

  	}
  
     public static testMethod void testNEU_MD_SendDocuments4() 
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	     
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	    
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	    
	      ApexPages.currentPage().getParameters().put('test', 'test');
	      ApexPages.currentPage().getParameters().put('id', shipconsodata.Id);
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'shipment_consolidation_data');
	      ApexPages.currentPage().getParameters().put('object_id', shipconsodata.Id);
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();

  	}
  
    public static testMethod void testNEU_MD_SendDocuments5() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
	      
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
	      
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	    
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	    
	      ApexPages.currentPage().getParameters().put('test', 'test');
	      ApexPages.currentPage().getParameters().put('id', transporpack.Id);
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'transport_packaging_data');
	      ApexPages.currentPage().getParameters().put('object_id', transporpack.Id);
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();
  	}
  
    public static testMethod void testNEU_MD_SendDocuments6() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	      
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	    
	      ApexPages.currentPage().getParameters().put('test', 'test');
	      ApexPages.currentPage().getParameters().put('id', ship.Id);
	      ApexPages.currentPage().getParameters().put('object_select', 'shipment');
	      ApexPages.currentPage().getParameters().put('object_id', ship.Id);
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments(new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();
  	}
  
   public static testMethod void testNEU_MD_SendDocuments7() 
   {
   	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	     
	     
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	 
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	    
	      ApexPages.currentPage().getParameters().put('test', 'test');
	      ApexPages.currentPage().getParameters().put('id', supquote.Id);
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'supplier_quote');
	      ApexPages.currentPage().getParameters().put('object_id', supquote.Id);
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();
  	}
   
   
   public static testMethod void testNEU_MD_SendDocuments8() 
   {
   	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
          Account a = list_accounts[0];
          insert a;
          Account sup = list_accounts[1];
          insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
	      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte', Only_Warehouse_Service__c = true);
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
	    
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	      
	      Invoice__c i_test = new Invoice__c();
		  i_test.Import_Export_Quote_Order__c = importexportquote.Id;
		  i_test.Shipment__c = ship.Id;
		  i_test.Account__c = a.Id;
		  i_test.Type__c = 'Debit Note';
		  insert i_test;
	     
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	    
		  ApexPages.currentPage().getParameters().put('test', 'test');
		  ApexPages.currentPage().getParameters().put('id', suprequest.Id);
	    
		   ApexPages.currentPage().getParameters().put('object_select', 'supplier_request_rfp');
		   ApexPages.currentPage().getParameters().put('object_id', suprequest.Id);
		   NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
		   uda.to='test@tst.com;';
		   uda.cc='test@tst.com;';
		   Blob b = Blob.valueOf('Test Data');
		   List<Folder> folder_document = [select Id from Folder where Name=: 'Associated Documents'];
		   Document documento = new Document ();
		   if(folder_document.size()>0)
		   {
		   	 documento.Name='test.test';
		   	 documento.Body=b;
		   	 documento.FolderId=folder_document[0].Id;
		   	 documento.DeveloperName ='test_test_test';
		   }
		   else
		   {
		   	 documento.Name='test.test';
		   	 documento.Body=b;
		   	 documento.DeveloperName ='test_test_test';
		   }
		   insert documento;

           Associated_Document__c ad = new Associated_Document__c(Name ='test document.pdf', Account__c=a.Id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id,File_Content_Version_Id__c = 'test');
           insert ad;

           ContentVersion cvFile = new ContentVersion();//Es el fichero en sí mismo
           cvFile.ContentLocation = 'S'; //S==SALESFORCE
           Blob blobtest = Blob.valueOf('Test Data.pdf');
           cvFile.VersionData = blobtest;
           cvFile.Title = 'Test document';
           cvFile.PathOnClient = 'Test document';
           insert cvFile;

		   List<NEU_MD_SendDocuments.documents_s> atpd = new List<NEU_MD_SendDocuments.documents_s>();
		   atpd.add(new NEU_MD_SendDocuments.documents_s(true, ad.Name, ad.Document_Type__c, ad.Document_Reference__c, ad.Document_Description__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), ad.Id, cvFile.Id,0,'0'));
		   uda.associated_documents = atpd;
		   for(NEU_MD_SendDocuments.documents_s lo :  uda.associated_documents)
		   {
		     	lo.selected = true;
		     	lo.id_doc = documento.Id;
		   }
		   uda.send_email();
  }
  
  public static testMethod void testNEU_MD_SendDocuments9() 
  {
  	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
	      Account a = list_accounts[0];
	      insert a;
	      Account sup = list_accounts[1];
	      insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	  
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	     
	      ApexPages.currentPage().getParameters().put('test', 'test'); 
	      ApexPages.currentPage().getParameters().put('id', supplyproject.Id);
	    
	      ApexPages.currentPage().getParameters().put('object_select', 'supply_project');
	      ApexPages.currentPage().getParameters().put('object_id', supplyproject.Id);
	      
    	  NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      Blob b = Blob.valueOf('Test Data');
	      Document documento = new Document();
	      documento.Name='Test document.test';
	      documento.AuthorId = UserInfo.getUserId();
	      documento.IsPublic=true;
	      documento.Body = b;
	      documento.FolderId = UserInfo.getUserId();
	      documento.DeveloperName ='test';
	      insert documento;
	      Associated_Document__c documento_asociado2 = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c=documento.Url, Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c=documento.Url, SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado2;
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();
  }
 
   public static testMethod void testNEU_MD_SendDocuments10() 
   {
   	NEU_StaticVariableHelper.setBoolean1(true);
	 	  List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
		  Account a = list_accounts[0];
		  insert a;
		  Account sup = list_accounts[1];
		  insert sup;
		  Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
		      
		  Account dac = new Account(Name = 'Test acount 1', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Auto-Parts');
		  insert dac;
		  Contact contact1 = new Contact(AccountId = dac.Id, LastName='test contact1', Email='test1@test.com', MobilePhone = '111222333', Phone = '85111222333', Fax = '574552222');
		  insert contact1;
		  Contact contact2 = new Contact(AccountId = dac.Id, LastName='test contact2', Email='test2@test.com', MobilePhone = '111222333', Phone = '85111222333', Fax = '574552222');
		  insert contact2;
		  Contact contact3 = new Contact(AccountId = dac.Id, LastName='test contact3', Email='test3@test.com', MobilePhone = '111222333', Phone = '85111222333', Fax = '574552222');
		  insert contact3;
		        
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, DO_Release_to_Company__c = dac.Id, DO_Contact_1_Release_to_Company__c = contact1.Id, DO_Release_Valid_To__c = system.today().adddays(3), Valid_Until__c = system.today(), Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	      
	      
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	    
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	      
	      ApexPages.currentPage().getParameters().put('test', 'test'); 
	      ApexPages.currentPage().getParameters().put('id', importexportquote.Id);
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'import_export_quote');
	      ApexPages.currentPage().getParameters().put('object_id', importexportquote.Id);
	      
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments(new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();
  	}
  
    public static testMethod void testNEU_MD_SendDocuments11() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
		  Account a = list_accounts[0];
		  insert a;
		  Account sup = list_accounts[1];
		  insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
	      insert contacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
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
	   
	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	      
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	      
	      ApexPages.currentPage().getParameters().put('test', 'test'); 
	      ApexPages.currentPage().getParameters().put('id', shipdis.Id);
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'shipment_disbursement');
	      ApexPages.currentPage().getParameters().put('object_id', shipdis.Id);
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';
	      uda.send_email();
  	}
  
  
  public static testMethod void testNEU_MD_SendDocuments12() 
  {
  	NEU_StaticVariableHelper.setBoolean1(true);
	      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
		  Account a = list_accounts[0];
		  insert a;
		  Account sup = list_accounts[1];
		  insert sup;
	      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email ='test@test.com');
	      insert contacto;
	      Contact supcontacto = new Contact(AccountId = sup.Id, LastName='test contact', Email ='test2@test.com');
	      insert supcontacto;
	      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
	      insert supplyproject;
	      Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
	      insert suprequest;
	      Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
	      insert supquote;
	      Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Only_Warehouse_Service__c = true);
	      insert importexportquote;
	      Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte', Only_Warehouse_Service__c = true);
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

	      SCM_Contract__c scm_contract = new SCM_Contract__c(Name='test', Account_for__c=a.Id, Account_for_Signed_By__c=contacto.Id);
	      insert scm_contract;
	      
	      Invoice__c i_test = new Invoice__c();
		  i_test.Import_Export_Quote_Order__c = importexportquote.Id;
		  i_test.Shipment__c = ship.Id;
		  i_test.Account__c = a.Id;
		  i_test.Type__c = 'Debit Note';
		  insert i_test;
	
	      Associated_Document__c documento_asociado = new Associated_Document__c(Name =' test document', Account__c=a.Id,Claim__c=claim.id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id, Shipment__c=ship.id, Shipment_Consolidation_Data__c=shipconsodata.Id,Shipment_Disbursement__c=shipdis.Id,Shopping_Cart__c=shop.Id,Supplier_Quote__c=supquote.Id,Supplier_Request_RFP__c=suprequest.Id,Supply_Project__c=supplyproject.Id);
	      insert documento_asociado;
	      
	      ApexPages.currentPage().getParameters().put('test', 'test'); 
	      ApexPages.currentPage().getParameters().put('id', shipdis.Id);
	      
	      ApexPages.currentPage().getParameters().put('object_select', 'shipment_disbursement');
	      ApexPages.currentPage().getParameters().put('object_id', shipdis.Id);
	      NEU_MD_SendDocuments uda = new NEU_MD_SendDocuments( new ApexPages.StandardController(importexportquote));
	      uda.optionTemplate = 1;
	      uda.to='test@tst.com;';
	      uda.cc='test@tst.com;';

          Associated_Document__c ad = new Associated_Document__c(Name ='test document.pdf', Account__c=a.Id, Document_Description__c='test descripcion', Document_Reference__c='test referencia', Document_Type__c='Bill of Landing', Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', Import_Export_Quote__c=importexportquote.Id, Manual_Document_URL__c='https://c.eu0.content.force.com/servlet/servlet.FileDownload?file=01520000002DWP2', SCM_Contract__c=scm_contract.Id,File_Content_Version_Id__c = 'test');
          insert ad;

          ContentVersion cvFile = new ContentVersion();//Es el fichero en sí mismo
          cvFile.ContentLocation = 'S'; //S==SALESFORCE
          Blob blobtest = Blob.valueOf('Test Data.pdf');
          cvFile.VersionData = blobtest;
          cvFile.Title = 'Test document';
          cvFile.PathOnClient = 'Test document';
          insert cvFile;

	      uda.send_email();
	      uda.return_shipment();
	      List<NEU_MD_SendDocuments.documents_s> lines4=new List<NEU_MD_SendDocuments.documents_s>();
	      lines4.add(new NEU_MD_SendDocuments.documents_s(true, ad.Name, ad.Document_Type__c, ad.Document_Reference__c, ad.Document_Description__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), ad.Id, cvFile.Id,0,'0'));

          for(NEU_MD_SendDocuments.documents_s documents : uda.associated_documents)
	          documents.selected = true;
  }
}