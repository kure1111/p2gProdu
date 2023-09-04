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
private class NEU_test_Price_List {

     static testMethod void NEU_OM_Allocated_Items() {
          NEU_StaticVariableHelper.setBoolean1(true);
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account cuenta = list_accounts[0];
      insert cuenta;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
      insert c;
      Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
      insert d;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= cuenta.Id , E_Commerce__c = true);
      insert item;
      Sourcing_Item__c item2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= cuenta.Id , E_Commerce__c = true);
      insert item2;
      Price_List__c b = new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = cuenta.Id);
      insert b;
      Item_List_Price__c itemlis = new Item_List_Price__c(Item_Name__c = item.Id, Price_List__c = b.Id);
      insert itemlis;
      NEU_OM_Allocated_Items uda = new NEU_OM_Allocated_Items(new ApexPages.StandardController( b ));
      uda.setnewcategory(c.Id);
      uda.getnewcategories();
      uda.getnewcategory();
      uda.getlistado_pricelist();
      for(NEU_OM_Allocated_Items.pricelists_s li : uda.getlistado_pricelist())
      {
          li.selected = true;
      }
      uda.delete_item_pricelist_select();
      uda.return_pricelist();
      uda.asignar_price_list();
    }
    
    static testMethod void test_NEU_SendDocuments_Catalog_Price_List() {
    	NEU_StaticVariableHelper.setBoolean1(true);
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account cuenta = list_accounts[0];
      insert cuenta;
      Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact', Email ='oscar@neurored.com');
      insert contacto;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
      insert c;
      Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
      insert d;
      Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= cuenta.Id , E_Commerce__c = true);
      insert item;
      Sourcing_Item__c item2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= cuenta.Id , E_Commerce__c = true);
      insert item2;
      Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = cuenta.Id);
      insert supplyproject;
      Price_List__c b = new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = cuenta.Id, Supply_Project__c = supplyproject.Id);
      insert b;
      Item_List_Price__c itemlis = new Item_List_Price__c(Item_Name__c = item.Id, Price_List__c = b.Id);
      insert itemlis;
      Associated_Document__c new_associated_document = new Associated_Document__c(Name='test associated document', Account__c=cuenta.Id, Supply_Project__c=supplyproject.Id);
      insert new_associated_document;
      NEU_SendDocuments_Catalog_Price_List uda = new NEU_SendDocuments_Catalog_Price_List(new ApexPages.StandardController( b ));
      uda.add_link_to_body();
      uda.create_task = true;
      for(NEU_SendDocuments_Catalog_Price_List.cuenta_s cu : uda.clientes_seleccionados)
      {
         if(cu.contactos != null)
         {
            for(NEU_SendDocuments_Catalog_Price_List.contacto_s con : cu.contactos)
            {
                con.selected = true;
            }
         }   
      }
      uda.send_email();
      uda.return_catalog_price_list();
      NEU_SendDocuments_Catalog_Price_List.contacto_s new_contact = new NEU_SendDocuments_Catalog_Price_List.contacto_s(contacto, true, 'oscar@neurored.com');
      NEU_SendDocuments_Catalog_Price_List.documents_s new_document = new NEU_SendDocuments_Catalog_Price_List.documents_s(true, 'test','test', '94','test description', 'tset url', 'id_doc', 10, '10' );
    }
    
    
    public static testMethod void test_NEU_OM_Allocated_Items1()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount2',Business_Area__c = 'Sales');
        insert c2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c e = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert e;
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Business_Area__c = 'Sales',Subfamily__c = d.Id,Items_Account_Owner__c= b.Id, Family__c =c.id );
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
         Sourcing_Item__c g2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g2;
         Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
        NEU_OM_Allocated_Items ai = new NEU_OM_Allocated_Items(new ApexPages.StandardController( a ));
        ai.getnewcategories();
        ai.getnewcategory();
        ai.setnewcategory(c.Id);
        ai.getlistado_pricelist();
        ai.asignar_price_list();
        ai.delete_item_pricelist_select();
        ai.decimalSep = ai.decimalSep;
        ai.thousandSep = ai.thousandSep;
        ai.getdiscount();
        ai.setdiscount('10');
        ai.setsearch_filter('test');
        ai.updatelines();
    }
    
     public static testMethod void test_NEU_OM_Allocated_Items2()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount2',Business_Area__c = 'Sales');
        insert c2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c e = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert e;
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Business_Area__c = 'Sales',Items_Account_Owner__c= b.Id, Family__c =c.id );
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
         Sourcing_Item__c g2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g2;
         Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
        NEU_OM_Allocated_Items ai = new NEU_OM_Allocated_Items(new ApexPages.StandardController( a ));
        ai.getnewcategories();
        ai.getnewcategory();
        ai.setnewcategory(c.Id);
        ai.getlistado_pricelist();
        ai.asignar_price_list();
        ai.delete_item_pricelist_select();
    }
    
    public static testMethod void test_NEU_OM_Allocated_Items3()//ok
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount2',Business_Area__c = 'Sales');
        insert c2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c e = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert e;
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Business_Area__c = 'Sales',Items_Account_Owner__c= b.Id );
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
        Sourcing_Item__c g2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g2;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
        NEU_OM_Allocated_Items ai = new NEU_OM_Allocated_Items(new ApexPages.StandardController( a ));
        ai.getnewcategories();
        ai.getnewcategory();
        ai.setnewcategory(c.Id);
        ai.getlistado_pricelist();
        ai.asignar_price_list();
        ai.delete_item_pricelist_select();
    }
    
    
   public static testMethod void NEU_Catalog_Price_List_Steps()
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
        NEU_Catalog_Price_List_Steps aapl = new NEU_Catalog_Price_List_Steps(new ApexPages.StandardController( a ));
   }
   
      public static testMethod void NEU_Catalog_Price_List_Steps2()
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
        
        NEU_Catalog_Price_List_Steps aapl = new NEU_Catalog_Price_List_Steps(new ApexPages.StandardController( a ));
   }
   
      public static testMethod void NEU_Catalog_Price_List_Steps3()
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
        Catalog_Family__c cf = new Catalog_Family__c(Name='test catalog family', Family__c = c.id, Catalog_Price_List__c = a.Id);
        insert cf;
        
        NEU_Catalog_Price_List_Steps aapl = new NEU_Catalog_Price_List_Steps(new ApexPages.StandardController( a ));
   }
   
    public static testMethod void NEU_Catalog_Price_List_Steps4()
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
        
        
        NEU_Catalog_Price_List_Steps aapl = new NEU_Catalog_Price_List_Steps(new ApexPages.StandardController( a ));
   }
       
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
    
    
     public static testMethod void test_NEU_Allocate_Families_Catalog()//ok
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
        Catalog_Family__c cf = new Catalog_Family__c(Name='test catalog family', Family__c = c.id, Catalog_Price_List__c = a.Id);
        insert cf;
        NEU_Allocate_Families_Catalog aapl = new NEU_Allocate_Families_Catalog(new ApexPages.StandardController( a ));
        aapl.setnewcategory('Sales');
        aapl.getnewcategory();
        aapl.getnewcategories();
        aapl.getlistado_pricelist();
        aapl.asignar_price_list();
        aapl.delete_item_pricelist_select();
        aapl.return_pricelist();
        system.debug( 'Prueba realizada' );
    }
    
    public static testMethod void test_NEU_Allocate_Families_Catalog2()//ok
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
        Price_List__c a = new Price_List__c(Name = 'Test Account ', Items_Account_Owner__c = b.Id);
        insert a;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= b.Id );
        insert g;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=a.Id );
        insert f;
        Customer_Price_List__c cpl = new Customer_Price_List__c(Customer__c = b.id,Price_List__c = a.Id);
        insert cpl;
        Catalog_Family__c cf = new Catalog_Family__c(Name='test catalog family', Family__c = c.id, Catalog_Price_List__c = a.Id);
        insert cf;
        NEU_Allocate_Families_Catalog aapl = new NEU_Allocate_Families_Catalog(new ApexPages.StandardController( a ));
        aapl.setnewcategory('Sales');
        aapl.getnewcategory();
        aapl.getnewcategories();
        aapl.search_filter= 'T';
        aapl.getlistado_pricelist();
        aapl.asignar_price_list();
        aapl.delete_item_pricelist_select();
        aapl.return_pricelist();
        system.debug( 'Prueba realizada' );
    }
    
}