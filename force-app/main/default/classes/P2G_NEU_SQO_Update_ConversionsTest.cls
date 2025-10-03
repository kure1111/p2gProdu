@isTest
public class P2G_NEU_SQO_Update_ConversionsTest {    
    @isTest
    static void P2G_NEU_SQO_Update_Conversions(){
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
        Account a = list_accounts[0];
        insert a;  
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
        insert supquote;
        
        supquote.Account_Executive_User__c=UserInfo.getUserId();
        update supquote;
        Test.stopTest();
    }
}