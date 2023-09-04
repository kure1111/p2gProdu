public with sharing class NEU_Import_Export_Warnings 
{
    
    public Customer_Quote__c record;
    public String disp_1 {get;set;}
    public String disp_2 {get;set;}
    
    ApexPages.StandardController con;
    
    public NEU_Import_Export_Warnings(ApexPages.StandardController stdController) 
    {
        con = stdController;

        try 
        { 
            record = [select Id, Name, Account_for__c, Account_for__r.Credit_Limit__c, Account_for__r.Limit_Exceeded__c, Account_for__r.Late_Outstanding_Payments__c from Customer_Quote__c where id = :con.getRecord().id];
        } 
        catch(Exception ee){record = new Customer_Quote__c();}
        
        
        //PLEASE, CHECK LIMIT OF CREDIT ALREADY EXCEEDED ON ACCOUNT
        if(record.Account_for__r.Credit_Limit__c  != null && record.Account_for__r.Credit_Limit__c > 0 && record.Account_for__r.Limit_Exceeded__c > 0)
            disp_1 = 'display:block;';
        else
            disp_1 = 'display:none;';
        
        //PLEASE, CHECK OUTSTANDING PAYMENTS ALREADY DUE ON ACCOUNT
        if(record.Account_for__r.Late_Outstanding_Payments__c > 0)
            disp_2 = 'display:block;';
        else
            disp_2 = 'display:none;';
        
    }
}