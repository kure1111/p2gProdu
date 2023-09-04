@isTest
public class Test_Pak50 {
    
     static testMethod void CreateQoute()
    {   
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Active__c ='Yes';  
        a.ActiveSap__c = true;
        insert a;
       
        Fee__c fee = new Fee__c(Name = 'PAK 50', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Fixed', Account_for__c = a.Id, Fee_Rate__c=50, Active__c =true, Currency_Buy_Price__c= 'USD' );
        insert fee;
        system.debug('Create FEE '+ fee); 
        test.startTest();
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = a.id;
        importexportquote.Quotation_Status__c = 'Quote being prepared'; 
        importexportquote.Origin_Address__c = '';
        importexportquote.Destination_Address__c = '';  
        importexportquote.Only_Warehouse_Service__c = true;
        importexportquote.Comercio_Exterior__c = 'Si';
        importexportquote.Freight_Mode__c = 'Road';
        importexportquote.Service_Mode__c ='IMPORT';
       	importexportquote.Service_Type__c = 'FTL';
        
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'USD');
        Insert importexportquote;
        importexportquote.PDF_Notes__c = null;
        importexportquote.PDF_Notes_EN__c = null;
        
        update importexportquote;
        test.stopTest();
    }

}