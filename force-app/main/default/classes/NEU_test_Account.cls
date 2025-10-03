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
  
}