@istest
public class Test_Pak100 {
	
    static testMethod void CreateQoute()
    {   
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Active__c ='Yes';  
        a.ActiveSap__c = true;
        insert a;
       
        Fee__c fee = new Fee__c(Name = 'PAK 100', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Fixed', Account_for__c = a.Id, Fee_Rate__c=100, Active__c =true);
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
        importexportquote.Service_Mode__c ='NATIONAL';
        importexportquote.Service_Type__c = 'TARIMAS';
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'MXN');
        Insert importexportquote;
        importexportquote.PDF_Notes__c = null;
        importexportquote.PDF_Notes_EN__c = null;
        
        update importexportquote;
        test.stopTest();
    }
}