@isTest
public class NEU_Test_Shipment_View_Route {
	@isTest(SeeAllData=true)
    static void NEU_Shipment_View_Route() 
    {

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-TS-00059';
        insert shipment_test;

       NEU_Shipment_View_Route sr=new NEU_Shipment_View_Route(new ApexPages.StandardController( shipment_test ));
    }
}