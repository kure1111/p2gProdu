@isTest
public class OpportunityNameTest {
    @isTest
    public static void test(){
        Account a = new Account();
        a.Name = 'test';
        insert a;
        
        Opportunity op = new Opportunity();
        op.AccountId = a.Id;
        op.Name = 'Test OP';
        op.Service_Type__c = 'FN';
        op.StageName = 'Prospecting';
        op.CloseDate = date.today() + 3;
        insert op;
    }
}