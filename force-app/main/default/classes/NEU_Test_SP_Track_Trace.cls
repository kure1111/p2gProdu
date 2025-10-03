@isTest
public class NEU_Test_SP_Track_Trace {
	@isTest(SeeAllData=true)
    static void test_NEU_SP_Track_Trace()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;

        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
        RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
        AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];        
              
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00020', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_SP_Track_Trace sptt = new NEU_SP_Track_Trace(new ApexPages.StandardController( ship ));
       
    }
}