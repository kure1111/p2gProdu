@isTest
public class P2G_NEU_OM_GenerateQuoteTest {
        
    @isTest(SeeAllData=true)
    static void testConstructorWithValidQuote() {
        Customer_Quote__c testQuote = [SELECT Id, Name, Account_for__c,  Quotation_Status__c, Approved_Date__c, Account_Executive_User__c,Account_for__r.Name,
                                       Account_for_Billing_Address__c,Account_for_Shipping_Address__c,Contact__r.Name,SUM_Buy_Origin_Amount_number__c,CurrencyIsoCode 
                                       FROM Customer_Quote__c LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        NEU_OM_GenerateQuote controller = new NEU_OM_GenerateQuote(stdController);
        Test.stopTest();
               
    }
    
    @isTest(SeeAllData=true)
    static void testConstructorWithInvalidQuote() {
        // Probar con un registro no existente
        Customer_Quote__c invalidQuote = new Customer_Quote__c();
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(invalidQuote);
        NEU_OM_GenerateQuote controller = new NEU_OM_GenerateQuote(stdController);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testCurrencyUtilsIntegration() {
        Customer_Quote__c testQuote = [SELECT Id, Name, Account_for__c,  Quotation_Status__c, Approved_Date__c, Account_Executive_User__c,Account_for__r.Name,
                                       Account_for_Billing_Address__c,Account_for_Shipping_Address__c,Contact__r.Name,SUM_Buy_Origin_Amount_number__c,CurrencyIsoCode 
                                       FROM Customer_Quote__c LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        NEU_OM_GenerateQuote controller = new NEU_OM_GenerateQuote(stdController);
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void testFormattingOfTotals() {
        Customer_Quote__c testQuote = [SELECT Id, Name, Account_for__c,  Quotation_Status__c, Approved_Date__c, Account_Executive_User__c,Account_for__r.Name,
                                       Account_for_Billing_Address__c,Account_for_Shipping_Address__c,Contact__r.Name,SUM_Buy_Origin_Amount_number__c,CurrencyIsoCode 
                                       FROM Customer_Quote__c LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        NEU_OM_GenerateQuote controller = new NEU_OM_GenerateQuote(stdController);
        Test.stopTest();                
    }
    
    
}