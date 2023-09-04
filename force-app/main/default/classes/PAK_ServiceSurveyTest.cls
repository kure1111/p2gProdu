@isTest
public class PAK_ServiceSurveyTest {
    @isTest
    public static void Test(){
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Shipment__c ship = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        ApexPages.currentPage().getParameters().put('shipId', ship.Id);
        PAK_ServiceSurvey vf = new PAK_ServiceSurvey();
        vf.validate();
        
        vf.shipment.Rating__c = 'Good';
        vf.save();
        
        Test.stopTest();
    }
}