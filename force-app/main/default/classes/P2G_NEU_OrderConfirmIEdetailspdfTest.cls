@isTest
public class P2G_NEU_OrderConfirmIEdetailspdfTest {
    @isTest(SeeAllData=true)
    static void test_NEU_Order_Confirmation_IE_details_pdf() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('services_charges', 'true');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        //Account a =list_accounts[0];
        // a.Owner.SalesEmployer__c='002';
        //insert a;
        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
                     RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
                     AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
        //Account sup = list_accounts[1];
        //insert sup;
        Account sup = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
                       RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Transporter'
                       AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
        Customer_Quote__c importexportquote = new Customer_Quote__c(Pricing_Executive__c=UserInfo.getUserId(),  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Per Kg', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Concept_1_Sell_Price__c =10, Concept_2_Sell_Price__c = 10, Concept_3_Sell_Price__c =10, Concept_4_Sell_Price__c = 10, Concept_5_Sell_Price__c =10);
        insert quote_fee;
        Test.startTest();
        NEU_Order_Confirmation_IE_details_pdf  ocid = new NEU_Order_Confirmation_IE_details_pdf(new ApexPages.StandardController( importexportquote ));
        Test.stopTest();
    }
}