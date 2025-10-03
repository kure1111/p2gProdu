@isTest
public class NEU_Test_ShipmentRequestSteps {
	@isTest(SeeAllData=true)
    public static void testNEU_ShipmentOrderSteps()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00050', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        NEU_ShipmentOrderSteps sos = new NEU_ShipmentOrderSteps(new ApexPages.StandardController( ship ));
        NEU_ShipmentQuoteSteps sqs = new NEU_ShipmentQuoteSteps(new ApexPages.StandardController( ship ));
        NEU_ShipmentRequestSteps srs = new NEU_ShipmentRequestSteps(new ApexPages.StandardController( ship ));
         
    }
}