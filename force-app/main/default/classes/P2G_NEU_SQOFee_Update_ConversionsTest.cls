@isTest
public class P2G_NEU_SQOFee_Update_ConversionsTest {

    @isTest
    static void NEU_SQOFee_Update_ConversionsTest(){
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id);
        insert supquote;
        Supplier_Quote_Order_Fee_Line__c sup_quote_order_fee = new Supplier_Quote_Order_Fee_Line__c(Name='test', Fee_Name__c = fee.Id, Supplier_Quote_Order__c=supquote.Id, Units__c=100);
        insert sup_quote_order_fee;        
        Test.stopTest();
    }
}