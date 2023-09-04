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
private class NEU_test_SCMContract {

    /*public static testMethod void testNEU_OM_FollowersSCMContract() {//ok
      
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;
      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto;
      Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto2;
      Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
      insert b;
      Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id);
      insert importexportquote;
      SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
      insert scm_contract;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
      insert c;
      Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
      insert d;
      Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
      insert quote;
      Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
      insert fee;
      Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
      insert quote2;
     // EntitySubscription new_entitysubcription = new EntitySubscription(ParentId = scm_contract.Id, SubscriberId = system.Userinfo.getUserId());
      //insert new_entitysubcription;
      NEU_OM_FollowersSCMContract uda = new NEU_OM_FollowersSCMContract(new ApexPages.StandardController( scm_contract ));
      uda.getfollower();
      uda.getfollowersin();
      uda.nuevalinea();
      uda.quitarlinea();
    }
    
     public static testMethod void testNEU_OM_FollowersSCMContract2() {//ok
      
      ApexPages.currentPage().getParameters().put('test', 'test');
      List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
      Account a = list_accounts[0];
      insert a;
      Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto;
      Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
      insert contacto2;
      Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
      insert b;
      Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id);
      insert importexportquote;
      SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
      insert scm_contract;
      Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
      insert c;
      Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
      insert d;
      Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
      insert quote;
      Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
      insert fee;
      Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
      insert quote2;
     // EntitySubscription new_entitysubcription = new EntitySubscription(ParentId = scm_contract.Id, SubscriberId = system.Userinfo.getUserId());
      //insert new_entitysubcription;
      NEU_OM_FollowersSCMContract uda = new NEU_OM_FollowersSCMContract(new ApexPages.StandardController( scm_contract ));
      List<NEU_OM_FollowersSCMContract.follower_s> lista_de_followers = new List<NEU_OM_FollowersSCMContract.follower_s>();
      List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
      lista_de_followers.add(new NEU_OM_FollowersSCMContract.follower_s(listauser[0],true,false,false));
      lista_de_followers.add(new NEU_OM_FollowersSCMContract.follower_s(listauser[0],false,false,false));
       
      List<NEU_OM_FollowersSCMContract.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersSCMContract.followersin_s>();
      lista_de_followersin.add(new NEU_OM_FollowersSCMContract.followersin_s(listauser[0],true,false,false));
      uda.follower =lista_de_followers;
      uda.getfollowersin();
      uda.followersin =lista_de_followersin;
      uda.nuevalinea();
      uda.quitarlinea();
    }*/
}