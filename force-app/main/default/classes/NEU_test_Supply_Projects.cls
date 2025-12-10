@isTest
private class NEU_test_Supply_Projects {
    
    
     @isTest
        static void testNEU_OM_FollowersSupplyProject() {//ok
            NEU_StaticVariableHelper.setBoolean1(true);
            ApexPages.currentPage().getParameters().put('test', 'test');
            
            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            //Account a = list_accounts[0];
            //a.Owner.SalesEmployer__c='000';
            //insert a;
            Account a =new Account();
            a.Name='TESTACC';
            a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            a.OwnerId=UserInfo.getUserId();
            insert a;
            Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
            insert contacto;
            Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
            insert contacto2;
            Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
            insert supplyproject;
            
            NEU_OM_FollowersSupplyProject uda = new NEU_OM_FollowersSupplyProject(new ApexPages.StandardController( supplyproject ));
            
            uda.getfollower();
            uda.getfollowersin();
            uda.nuevalinea();
            uda.quitarlinea();
        }
    
    @isTest(SeeAllData=true)
        static void testNEU_OM_FollowersSupplyProject2() {//ok
            NEU_StaticVariableHelper.setBoolean1(true);
            ApexPages.currentPage().getParameters().put('test', 'test');
            
            //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            //Account a = list_accounts[0];
            //insert a;
            Account a =new Account();
            a.Name='TESTACC';
            a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            a.OwnerId=UserInfo.getUserId();
            insert a;      
            Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
            insert contacto;
            Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
            insert supplyproject;
            NEU_OM_FollowersSupplyProject uda = new NEU_OM_FollowersSupplyProject(new ApexPages.StandardController( supplyproject ));
            List<NEU_OM_FollowersSupplyProject.follower_s> lista_de_followers = new List<NEU_OM_FollowersSupplyProject.follower_s>();
            List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
            lista_de_followers.add(new NEU_OM_FollowersSupplyProject.follower_s(listauser[0],true,false,false));
            lista_de_followers.add(new NEU_OM_FollowersSupplyProject.follower_s(listauser[0],false,false,false));
            
            List<NEU_OM_FollowersSupplyProject.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersSupplyProject.followersin_s>();
            lista_de_followersin.add(new NEU_OM_FollowersSupplyProject.followersin_s(listauser[0],true,false,false));
            uda.follower =lista_de_followers;
            uda.getfollowersin();
            uda.followersin =lista_de_followersin;
            uda.nuevalinea();
            uda.quitarlinea();
        }
    @isTest(SeeAllData=true)
    static void test_NEU_OM_ProjectSteps() {
        NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        //Account a = list_accounts[0];
        //a.Owner.SalesEmployer__c='000';
        //insert a;
        //Account sup = list_accounts[1];
        //sup.Owner.SalesEmployer__c='001';
        //insert sup;
        User user = [SELECT Id FROM User WHERE Name =: 'Maria Vargas'];
        Account sup =new Account();
        sup.Name='TESTACCSUP';
        sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        sup.OwnerId= user.Id;
        insert sup;
        Account a =new Account();
        a.Name='TESTACC';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        a.OwnerId= user.Id;
        insert a;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        NEU_OM_ProjectSteps proy = new NEU_OM_ProjectSteps(new ApexPages.StandardController( supplyproject ));
        system.debug( 'Prueba realizada' );
    }
}