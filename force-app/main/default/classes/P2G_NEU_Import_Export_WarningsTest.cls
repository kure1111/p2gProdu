@isTest
public class P2G_NEU_Import_Export_WarningsTest {

    @isTest(SeeAllData=true)
    static void testConstructorWithCreditLimitExceeded() {        
        Account testAccount = new Account(
            Name = 'Test Account',
            Credit_Limit__c = 10000,            
            Late_Outstanding_Payments__c = 0,
            Total_Collection_Outstanding_Balance__c =15000,
            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),	
            OwnerId=UserInfo.getUserId()
        );
        insert testAccount;
        
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c 
        WHERE Margen_Operativo__c!=null AND Pricing_Executive__c!=null LIMIT 1];
        /*
        new Customer_Quote__c(
            Name = 'Test Quote',
            Account_for__c = testAccount.Id,
            Service_Mode__c='NATIONAL',
            Service_Type__c='FTL',
            CurrencyIsoCode='MXN',
            Pricing_Executive__c=UserInfo.getUserId()
        );
        insert testQuote;
        */      
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
                
        Test.startTest();
        NEU_Import_Export_Warnings controller = new NEU_Import_Export_Warnings(stdController);
        Test.stopTest();                
    }
    
    @isTest(SeeAllData=true)
    static void testConstructorWithLatePayments() {        
        Account testAccount = new Account(
            Name = 'Test Account',
            Credit_Limit__c = 10000,            
            Late_Outstanding_Payments__c = 2,
            Total_Collection_Outstanding_Balance__c =15000,
            OwnerId=UserInfo.getUserId()
        );
        insert testAccount;
        
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c 
        WHERE Margen_Operativo__c!=null AND Pricing_Executive__c!=null LIMIT 1];
        /*
        new Customer_Quote__c(
            Name = 'Test Quote',
            Account_for__c = testAccount.Id,
            Service_Mode__c='NATIONAL',
            Service_Type__c='FTL',
            CurrencyIsoCode='MXN',
            Pricing_Executive__c=UserInfo.getUserId()
        );
        insert testQuote;
        */
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
                
        Test.startTest();
        NEU_Import_Export_Warnings controller = new NEU_Import_Export_Warnings(stdController);
        Test.stopTest();                
    }
    
    @isTest(SeeAllData=true)
    static void testConstructorWithNoWarnings() {        
        Account testAccount = new Account(
            Name = 'Test Account',
            Credit_Limit__c = 10000,
            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
            Total_Collection_Outstanding_Balance__c =15000,
            Late_Outstanding_Payments__c = 0,
            OwnerId=UserInfo.getUserId()
        );
        insert testAccount;
        
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c 
        WHERE Margen_Operativo__c!=null AND Pricing_Executive__c!=null LIMIT 1];
        /*
        new Customer_Quote__c(
            Name = 'Test Quote',
            Account_for__c = testAccount.Id,
            Service_Mode__c='NATIONAL',
            Service_Type__c='FTL',
            CurrencyIsoCode='MXN',
            Pricing_Executive__c=UserInfo.getUserId()
        );
        insert testQuote;
        */
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
                
        Test.startTest();
        NEU_Import_Export_Warnings controller = new NEU_Import_Export_Warnings(stdController);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testConstructorWithNullCreditLimit() {
        Account testAccount = new Account(
            Name = 'Test Account',
            Credit_Limit__c = null,
            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),	
            Total_Collection_Outstanding_Balance__c =15000,
            Late_Outstanding_Payments__c = 0,
            OwnerId=UserInfo.getUserId()
        );
        insert testAccount;
        
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c 
        WHERE Margen_Operativo__c!=null AND Pricing_Executive__c!=null LIMIT 1];
        /*
        new Customer_Quote__c(
            Name = 'Test Quote',
            Account_for__c = testAccount.Id,
            Service_Mode__c='NATIONAL',
            Service_Type__c='FTL',
            CurrencyIsoCode='MXN',
            Pricing_Executive__c=UserInfo.getUserId()
        );
        insert testQuote;
        */
                
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
                
        Test.startTest();
        NEU_Import_Export_Warnings controller = new NEU_Import_Export_Warnings(stdController);
        Test.stopTest();                
    }
    
    @isTest
    static void testConstructorWithException() {        
        ApexPages.StandardController stdController = new ApexPages.StandardController(new Customer_Quote__c());
                
        Test.startTest();
        NEU_Import_Export_Warnings controller = new NEU_Import_Export_Warnings(stdController);
        Test.stopTest();                        
    }
}