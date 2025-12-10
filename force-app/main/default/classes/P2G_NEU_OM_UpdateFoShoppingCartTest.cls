@isTest
public class P2G_NEU_OM_UpdateFoShoppingCartTest {
    
    @isTest
    static void NEU_OM_UpdateFoShoppingCart() //ok
    {
        Test.startTest();
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        
        Account cuenta= new Account();
        cuenta.Name='Test';
        cuenta.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        cuenta.OwnerId=UserInfo.getUserId(); 
        cuenta.Account_Executive_User__c=UserInfo.getUserId();
        cuenta.Account_External_Follower_User__c=UserInfo.getUserId();
        insert cuenta;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=cuenta.Id);
        insert shop;
        Test.stopTest();
    }    
}