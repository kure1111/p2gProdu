@isTest
public class NEU_Test_OM_GenerateQuote_Shipment {
	@isTest(SeeAllData=true)
    static void test_NEU_OM_GenerateQuote_Shipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;

        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
        RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
        AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];        
              
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00027', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        NEU_OM_GenerateQuote_Shipment gpcc = new NEU_OM_GenerateQuote_Shipment(new ApexPages.StandardController( ship ));
        
    }
}