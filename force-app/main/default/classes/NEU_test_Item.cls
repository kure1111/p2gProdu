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
private class NEU_test_Item {

    public static testMethod void test_NEU_OM_CreateBOMExplosionRelations() {//ok
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Subfamily__c d2= new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert item;
         Sourcing_Item__c item2 = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert item2;
        BOM_Relation__c bom = new BOM_Relation__c(Input_Item__c= item.Id, Output_Item__c= item.Id,Uds_Input_Ud_Output__c=10);
        insert bom;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_CreateBOMExplosionRelations uda = new NEU_OM_CreateBOMExplosionRelations(new ApexPages.StandardController( item ));
        uda.getbom_relation();
        uda.getItem_List();
        uda.getsubfamily_field();
        string value =' test subfamily';
        uda.setsubfamily_field(value);
        uda.crearrelationbom();
        system.debug( 'Prueba realizada' );
    }
    
    public static testMethod void test_NEU_OM_UploadImageItem() {//ok
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert item;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_UploadImageItem uis = new NEU_OM_UploadImageItem(new ApexPages.StandardController( item ));
        uis.upload();
        system.debug( 'Prueba realizada' );
    }
    
    static testMethod void NEU_OM_FollowersItem() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto2;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert item;
        
        NEU_OM_FollowersItem uda = new NEU_OM_FollowersItem(new ApexPages.StandardController( item ));
        uda.getfollowersin();
        uda.getfollower();
        uda.nuevalinea();
        uda.quitarlinea();
    }
    
       static testMethod void NEU_OM_FollowersItem2() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account b = list_accounts[0];
        insert b;
        Contact contacto = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = b.Id, LastName='test contact');
        insert contacto2;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = b.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id);
        insert item;
        
        NEU_OM_FollowersItem uda = new NEU_OM_FollowersItem(new ApexPages.StandardController( item ));
        List<NEU_OM_FollowersItem.follower_s> lista_de_followers = new List<NEU_OM_FollowersItem.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersItem.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersItem.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersItem.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersItem.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersItem.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();      
    }
    
    public static testMethod void NEU_MD_StockGraphic() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account = list_accounts[0];
        insert account;
        
        Sourcing_Item__c item = new Sourcing_Item__c();
        item.Name = 'Item Test';
        item.Account_Owner__c = account.Id;
        insert item;
        
        Item_Historical_Data__c ihd = new Item_Historical_Data__c();
        ihd.Name='Historical Data Test';
        ihd.Item_Name__c = item.Id;
        ihd.Use_for_Statistics__c = true;
        insert ihd;
        
        NEU_MD_StockGraphic sg = new NEU_MD_StockGraphic(new ApexPages.StandardController( item ));
        NEU_MD_StockGraphic.Data datos;
        List<NEU_MD_StockGraphic.Data> lista_datos = new List<NEU_MD_StockGraphic.Data>();
        lista_datos.add(new NEU_MD_StockGraphic.Data('',1,1,1,1,1,1,1));
    }
    
    

}