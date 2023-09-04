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
private class NEU_test_Account 
{
	static testMethod void test_NEU_OM_Allocate_Offers_Account()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account cuenta = list_accounts[0];
        insert cuenta;
        
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= cuenta.Id , E_Commerce__c = true);
        insert item;
        E_Commerce_Offer__c eoffer = new E_Commerce_Offer__c(Name='test eoffer',Item_Name__c = item.Id);
        insert eoffer;
        E_Commerce_Offer__c eoffer2 = new E_Commerce_Offer__c(Name='test eoffer',Item_Name__c = item.Id);
        insert eoffer2;
        Account_E_Commerce_Offer__c offerta = new Account_E_Commerce_Offer__c(Name='testoffer', Account__c = cuenta.Id,E_Commerce_Offer__c = eoffer.Id);
        insert offerta;

        NEU_OM_Allocate_Offers_Account aoa = new NEU_OM_Allocate_Offers_Account(new ApexPages.StandardController( cuenta ));
        aoa.asignar_oferta();
    }

    static testMethod void NEU_MD_Select_Families_Supplied() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
        Account new_account = list_accounts[0];
        insert new_account;

        Product_Family__c new_family = new Product_Family__c();
        new_family.Name = 'Family Test';
        new_family.Business_Area__c = 'Other Services';
        insert new_family;

        Family_Supplied__c new_family_supplied = new Family_Supplied__c();
        new_family_supplied.Family__c = new_family.Id;
        new_family_supplied.Supplier_Account__c = new_account.Id;
        insert new_family_supplied;

        NEU_MD_Select_Families_Supplied sfs = new NEU_MD_Select_Families_Supplied(new ApexPages.StandardController( new_account ));
        NEU_MD_Select_Families_Supplied.families_s family;
        List<NEU_MD_Select_Families_Supplied.families_s> lista_families = new List<NEU_MD_Select_Families_Supplied.families_s>();
        lista_families.add(new NEU_MD_Select_Families_Supplied.families_s('','','','','',true,true));

        sfs.allocate_families();
        sfs.id_family = new_family.Id;
        sfs.remove_family();
        sfs.return_account();
    }

    public static testMethod void test_NEU_OM_Allocate_Account_PriceList()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c e = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert e;
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Business_Area__c = 'Other Services',Subfamily__c = d.Id,Items_Account_Owner__c= b.Id, Family__c =c.id );
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
        NEU_OM_Allocate_Account_PriceList aapl = new NEU_OM_Allocate_Account_PriceList(new ApexPages.StandardController( b ));
        aapl.setnewcategory('Sales');
        aapl.getnewcategories();
        aapl.getnewcategory();
        aapl.getlistado_pricelist();
        aapl.asignar_price_list();
        aapl.delete_supplier_select();
        aapl.return_project();
    }

    public static testMethod void test_NEU_OM_Allocate_Account_PriceList2()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c e = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert e;
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Business_Area__c = 'Other Services',Subfamily__c = d.Id,Items_Account_Owner__c= b.Id, Family__c =c.id );
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
        Customer_Price_List__c cpl = new Customer_Price_List__c(Customer__c = b.id,Price_List__c = a.Id);
        insert cpl;
        NEU_OM_Allocate_Account_PriceList aapl = new NEU_OM_Allocate_Account_PriceList(new ApexPages.StandardController( b ));
        aapl.setnewcategory('Sales');
        aapl.getnewcategories();
        aapl.getnewcategory();
        aapl.getlistado_pricelist();
        aapl.asignar_price_list();
        aapl.delete_supplier_select();
        aapl.return_project();
    }
  
    public static testMethod void test_NEU_OM_UploadSupplierLogo() 
    {
		NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
        Account cuenta = list_accounts[0];
        insert cuenta;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_UploadSupplierLogo uda = new NEU_OM_UploadSupplierLogo(new ApexPages.StandardController( cuenta ));
        uda.upload();
        Blob b = Blob.valueOf('Test Data');
        uda.logo = b;
        uda.logoName='Test document.test';
        /*uda.logo.AuthorId = UserInfo.getUserId();
        uda.logo.IsPublic=true;
        uda.logo.Body = b;*/
		uda.upload();
	}

	public static testMethod void test_NEU_OM_UploadDocumentsAccount() 
    {//ok
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account cuenta = list_accounts[0];
        insert cuenta;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_UploadDocumentsAccount uda = new NEU_OM_UploadDocumentsAccount(new ApexPages.StandardController( cuenta ));
        uda.upload();
        system.debug( 'Prueba realizada' );
    }
    
    public static testMethod void testNEU_OM_FollowersAccount2() 
    {//ok
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
  	 	ApexPages.currentPage().getParameters().put('test', 'test');

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
	    NEU_OM_FollowersAccount uda = new NEU_OM_FollowersAccount(new ApexPages.StandardController( a ));
	    List<NEU_OM_FollowersAccount.follower_s> lista_de_followers = new List<NEU_OM_FollowersAccount.follower_s>();
	    List<User> listauser = [select id, Name from User where Id =: UserInfo.getUserId()];
	    lista_de_followers.add(new NEU_OM_FollowersAccount.follower_s(listauser[0],true,false,false));
	    lista_de_followers.add(new NEU_OM_FollowersAccount.follower_s(listauser[0],false,false,false));
	    
	    List<NEU_OM_FollowersAccount.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersAccount.followersin_s>();
	    lista_de_followersin.add(new NEU_OM_FollowersAccount.followersin_s(listauser[0],true,false,false));
	    uda.follower =lista_de_followers; 
	    uda.getfollowersin();
	    uda.followersin =lista_de_followersin;
	    uda.nuevalinea();
	    uda.quitarlinea();
  	}

	public static testMethod void testNEU_OM_FollowersAccount() 
    {//ok
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
  	 	ApexPages.currentPage().getParameters().put('test', 'test');

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
	    NEU_OM_FollowersAccount uda = new NEU_OM_FollowersAccount(new ApexPages.StandardController( a ));
    	uda.getfollower();
    	uda.getfollowersin();
    	uda.nuevalinea();
    	uda.quitarlinea();
  	}
  
  	public static testMethod void testNEU_Allocate_Account_Items()
  	{
		NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Supplier,');
        Account sup = list_accounts[0];
        insert sup;
        Account sup2 = list_accounts[1];
        insert sup2;
        Product_Family__c f = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Other Services');
        insert f;
        Product_Family__c f2 = new Product_Family__c(Name = 'Family with a long name. Family with a long name. Family with a long name. ',Business_Area__c = 'Other Services');
        insert f2;
        Subfamily__c sf = new Subfamily__c(Product_Family__c = f.Id, Name = 'test subfamily');
        insert sf;
        Subfamily__c sf2 = new Subfamily__c(Product_Family__c = f.Id, Name = 'Subfamily with a long name. Subfamily with a long name.');
        insert sf2;
        Sourcing_Item__c i = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = sf.Id, Sourcing_Family__c =f.id, Account_Owner__c= sup.Id);
        insert i;
        
        NEU_Allocate_Account_Items uda = new NEU_Allocate_Account_Items(new ApexPages.StandardController( sup2 ));
        List<SelectOption>sof=uda.families;
        List<String>lsf=uda.subfamily;
        List<String>lf=uda.family;
        uda.subfamily=null;
        lsf=uda.subfamily;
        
        uda = new NEU_Allocate_Account_Items(new ApexPages.StandardController( sup ));
        sof=uda.families;
        lsf=uda.subfamily;
        lf=uda.family;
        lf.add(String.valueOf(f.Id));
        uda.family=lf;
        uda.allocatefamily();
        uda.allocatefamily();
        lsf=uda.subfamily;
        lsf.add(String.valueOf(sf.Id));
        uda.subfamily=lsf;
        uda.allocatesubfamily();
		uda.family=new List<String>();        
        lsf=uda.subfamily;
        lsf.add(String.valueOf(sf.Id));
        uda.subfamily=null;
        uda.allocatesubfamily();
        uda = new NEU_Allocate_Account_Items(new ApexPages.StandardController( sup ));
		uda.family=new List<String>();        
        lsf=uda.subfamily;
        uda.allocatefamily();
        
        List<NEU_Allocate_Account_Items.Item_s>li=uda.items;
        uda.allocateitem();
        NEU_Allocate_Account_Items.Item_s is=new NEU_Allocate_Account_Items.Item_s();
        is.item=i;
        is.selected=true;
        li.add(is);
        uda.items=li;
        uda.allocateitem();
        uda.items=null;
        uda.allocateitem();
        uda.allocateitem();

        uda = new NEU_Allocate_Account_Items(new ApexPages.StandardController( sup ));    
  	}
  
	public static testMethod void test_NEU_Account_Warnings() 
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
        shipline.Name= 'test ship line'; 
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
        
        
        NEU_Account_Warnings uda = new NEU_Account_Warnings(new ApexPages.StandardController( account_test ));
        system.debug('Test Ok Warnings Account');
    }
    
    public static testMethod void test_NEU_Account_Warnings_1() 
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
        NEU_Account_Warnings uda = new NEU_Account_Warnings(new ApexPages.StandardController( account_test ));
        system.debug('Test_1 Ok Warnings Account');
    }
}