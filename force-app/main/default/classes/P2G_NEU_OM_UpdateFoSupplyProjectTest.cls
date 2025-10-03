@isTest
public class P2G_NEU_OM_UpdateFoSupplyProjectTest {
    @isTest
    static void NEU_OM_UpdateFoSupplyProject() //ok
    {
        
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
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = cuenta.Id);
        insert supplyproject;
    }
}