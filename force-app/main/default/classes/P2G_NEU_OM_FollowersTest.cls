@isTest
public class P2G_NEU_OM_FollowersTest {
    
    @isTest
    static void testNEU_OM_Followers()
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
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        NEU_OM_Followers uda = new NEU_OM_Followers(new ApexPages.StandardController( shop ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
    }
    @isTest
    static void testNEU_OM_Followers2()
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
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id);
        insert shop;
        NEU_OM_Followers uda = new NEU_OM_Followers(new ApexPages.StandardController( shop ));
        List<NEU_OM_Followers.follower_s> lista_de_followers = new List<NEU_OM_Followers.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_Followers.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_Followers.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_Followers.followersin_s> lista_de_followersin = new List<NEU_OM_Followers.followersin_s>();
        lista_de_followersin.add(new NEU_OM_Followers.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
    }
    static void testNEU_OM_FollowersException(){
        NEU_StaticVariableHelper.setBoolean1(true);
        Shopping_Cart__c spCart= new Shopping_Cart__c(); 
        NEU_OM_Followers uda = new NEU_OM_Followers(new ApexPages.StandardController( spCart ));
    }
}