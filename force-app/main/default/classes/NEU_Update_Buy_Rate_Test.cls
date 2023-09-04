@isTest
public class NEU_Update_Buy_Rate_Test {

    
     static testMethod void NEU_Update_Buy_Rate()
     {
        Account acc = new Account(Name = 'Test client', Segment__c = 'Nuevo',RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        a.Segment__c = 'Nuevo'; 
        insert a;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id, Cost_Concept_1__c =10);
        insert fee;
        
     }
    
}