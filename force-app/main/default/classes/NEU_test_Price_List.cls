@isTest
private class NEU_test_Price_List {

       
    public static testMethod void test_NEU_OM_Allocate_Account_toPriceList()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c e = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert e;
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Business_Area__c = 'Sales',Subfamily__c = d.Id,Items_Account_Owner__c= b.Id, Family__c =c.id );
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
         Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
        NEU_OM_Allocate_Account_toPriceList aapl = new NEU_OM_Allocate_Account_toPriceList(new ApexPages.StandardController( a ));
        aapl.setnewcategory('Sales');
        aapl.getnewcategory();
        aapl.getnewcategories();
        aapl.getlistado_cuentas();
        aapl.asignar_price_list();
        aapl.delete_supplier_select();
        aapl.return_project();
        aapl.byPass();
        system.debug( 'Prueba realizada' );
    }
    
     public static testMethod void test_NEU_OM_Allocate_Account_toPriceList2()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c e = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert e;
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Business_Area__c = 'Sales',Subfamily__c = d.Id,Items_Account_Owner__c= b.Id, Family__c =c.id );
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
         Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
         Customer_Price_List__c cpl = new Customer_Price_List__c(Customer__c = b.id,Price_List__c = a.Id);
        insert cpl;
        NEU_OM_Allocate_Account_toPriceList aapl = new NEU_OM_Allocate_Account_toPriceList(new ApexPages.StandardController( a ));
        aapl.setnewcategory('Sales');
        aapl.getnewcategory();
        aapl.getnewcategories();
        aapl.getlistado_cuentas();
        aapl.asignar_price_list();
        aapl.delete_supplier_select();
        aapl.return_project();
        system.debug( 'Prueba realizada' );
    }
       
}