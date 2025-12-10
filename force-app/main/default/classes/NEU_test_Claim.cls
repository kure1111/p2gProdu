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
		uda.byPass();
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