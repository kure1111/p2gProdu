@isTest
public class P2G_NEU_OM_UpdateFoSCM_ContractTest {
    
    @isTest
    static void NEU_OM_UpdateFoSCM_Contract() //ok
    {
        
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/, Account_Executive_User__c=UserInfo.getUserId(),Account_External_Follower_User__c=UserInfo.getUserId());
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        insert a;
        SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
        insert scm_contract;
    }
}