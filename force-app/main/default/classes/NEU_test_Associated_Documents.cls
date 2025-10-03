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
      User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
      Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
      Customer_Quote__c importexportquote = new Customer_Quote__c();
      String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
      importexportquote.RecordTypeId = recordTypeId;
      importexportquote.Name='.';
      importexportquote.Catalog_Price_List__c = b.id;
      importexportquote.Account_for__c = a.Id;
      importexportquote.Only_Warehouse_Service__c = true;
      importexportquote.Team__c = 'P2G';
      importexportquote.Quotation_Status__c = 'Quote being prepared';
      importexportquote.Customer_Reference__c = 'hola soy una prueba';
      importexportquote.Valid_From__c = system.today();
      importexportquote.Valid_Until__c = system.today();
      importexportquote.Comercio_Exterior__c = 'No';
      importexportquote.Freight_Mode__c = 'Road';
      importexportquote.Service_Mode__c = 'NATIONAL';
      importexportquote.Service_Type__c = 'FTL';
      importexportquote.CurrencyIsoCode = 'MXN';
      importexportquote.ETD__c = Date.today();
      importexportquote.ETA__c = Date.today();
      importexportquote.Community_Status__c = 'CUSTOMER CREATED';
      importexportquote.Pricing_Executive__c= userT.Id;
      importexportquote.Operations_Exec__c = userT.Id;
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

      User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
      Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
      Customer_Quote__c importexportquote = new Customer_Quote__c();
      String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
      importexportquote.RecordTypeId = recordTypeId;
      importexportquote.Name='.';
      importexportquote.Catalog_Price_List__c = b.id;
      importexportquote.Account_for__c = a.Id;
      importexportquote.Only_Warehouse_Service__c = true;
      importexportquote.Team__c = 'P2G';
      importexportquote.Quotation_Status__c = 'Quote being prepared';
      importexportquote.Customer_Reference__c = 'hola soy una prueba';
      importexportquote.Valid_From__c = system.today();
      importexportquote.Valid_Until__c = system.today();
      importexportquote.Comercio_Exterior__c = 'No';
      importexportquote.Freight_Mode__c = 'Road';
      importexportquote.Service_Mode__c = 'NATIONAL';
      importexportquote.Service_Type__c = 'FTL';
      importexportquote.CurrencyIsoCode = 'MXN';
      importexportquote.ETD__c = Date.today();
      importexportquote.ETA__c = Date.today();
      importexportquote.Community_Status__c = 'CUSTOMER CREATED';
      importexportquote.Pricing_Executive__c= userT.Id;
      importexportquote.Operations_Exec__c = userT.Id;
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

    
}