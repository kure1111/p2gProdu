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
private class NEU_test_Claim {

     public static testMethod void testNEU_OM_FollowersClaim() {//ok
     	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
	    Claim__c claim = new Claim__c(Customer__c = a.Id);
	    insert claim;
	    NEU_OM_FollowersClaim uda = new NEU_OM_FollowersClaim(new ApexPages.StandardController( claim ));
    	uda.getfollower();
    	uda.getfollowersin();
    	uda.nuevalinea();
    	uda.quitarlinea();
  }
  
       public static testMethod void testNEU_OM_FollowersClaim2() {//ok
       	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
	    Claim__c claim = new Claim__c(Customer__c = a.Id);
	    insert claim;
	    NEU_OM_FollowersClaim uda = new NEU_OM_FollowersClaim(new ApexPages.StandardController( claim ));
    	List<NEU_OM_FollowersClaim.follower_s> lista_de_followers = new List<NEU_OM_FollowersClaim.follower_s>();
	    List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
	    lista_de_followers.add(new NEU_OM_FollowersClaim.follower_s(listauser[0],true,false,false));
	    lista_de_followers.add(new NEU_OM_FollowersClaim.follower_s(listauser[0],false,false,false));
	    
	    List<NEU_OM_FollowersClaim.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersClaim.followersin_s>();
	    lista_de_followersin.add(new NEU_OM_FollowersClaim.followersin_s(listauser[0],true,false,false));
	    uda.follower =lista_de_followers;
	    uda.getfollowersin();
	    uda.followersin =lista_de_followersin;
	    uda.nuevalinea();
	    uda.quitarlinea();
  }
}