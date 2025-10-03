@isTest
public class P2G_NEU_OM_Update_Fee_RateTest {
    @isTest
    static void NEU_OM_Update_Fee_Rate(){
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
        Account supplier = list_accounts[0];
        insert supplier;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Fee_Rate__c=10, Account_for__c = supplier.Id);
        insert fee;
        Fee_Offer__c fee_offer = new Fee_Offer__c(Name = 'test fee offer', Supplier__c = supplier.Id, Fee_Name__c = fee.Id, Price__c=10, Valid__c=false );
        insert fee_offer;
        Fee_Offer__c fee_offer2 = new Fee_Offer__c(Name = 'test fee offer', Supplier__c = supplier.Id, Fee_Name__c = fee.Id, Price__c=10, Valid__c=true );
        insert fee_offer2;
        Fee_Offer__c fee_offer3 = new Fee_Offer__c(Name = 'test fee offer', Supplier__c = supplier.Id, Fee_Name__c = fee.Id, Price__c=10, Valid__c=true );
        insert fee_offer3;
        Test.stopTest();
    }
}