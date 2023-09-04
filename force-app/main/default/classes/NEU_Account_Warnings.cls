public with sharing class NEU_Account_Warnings 
{
    public Account record;
    public String disp_1 {get;set;}
    public String disp_2 {get;set;}
    public String disp_Inactive {get; set;}
    
    ApexPages.StandardController con;
    
    public NEU_Account_Warnings(ApexPages.StandardController stdController) 
    {
        con = stdController;

        try 
        { 
            record = [select Id, Name, Credit_Limit__c, Limit_Exceeded__c, Late_Outstanding_Payments__c, Status_Account__c  from Account where id = :con.getRecord().id];
        } 
        catch(Exception ee){record = new Account();}
        
        
        //PLEASE, CHECK LIMIT OF CREDIT ALREADY EXCEEDED ON ACCOUNT
        if(record.Credit_Limit__c  != null && record.Credit_Limit__c > 0 && record.Limit_Exceeded__c > 0)
            disp_1 = 'display:block;';
        else
            disp_1 = 'display:none;';
        
        //PLEASE, CHECK OUTSTANDING PAYMENTS ALREADY DUE ON ACCOUNT
        if(record.Late_Outstanding_Payments__c > 0)
            disp_2 = 'display:block;';
        else
            disp_2 = 'display:none;';

        //Customer is Inactive, please contact Administration Team if you think it's an error

        if(record.Status_Account__c == 'Inactive')
        {
            disp_Inactive = 'display:block;';
        }
        else
        {
            disp_Inactive = 'display:none;';
        }
        
    }
}