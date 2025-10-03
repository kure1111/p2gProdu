@isTest
public class P2G_NEU_OM_Update_Acc_Auth_CreditTest {
    @isTest(SeeAllData=true)
    static void NEU_OM_Update_Account_Authorized_Credit(){
        Account acc= [SELECT Id, Authorized_Credit__c,Owner.SalesEmployer__c 
                      FROM Account WHERE Authorized_Credit__c=false AND Owner.SalesEmployer__c!=null LIMIT 1];
        acc.Authorized_Credit__c=true;
        update acc;
        /*
            new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();        	
        insert acc;
        
        acc.Authorized_Credit__c=true;
        update acc;
        */
    }
}