@isTest
public class Trigger_ShipmentDisbursement_Test {
	//triggers afectados
 	@isTest(SeeAllData=true)
    public static void ShipmentDisbursement_Test(){
        Customer_Quote__c quote = [SELECT Id, Account_for__c, Last_Shipment__c FROM Customer_Quote__c WHERE Last_Shipment__c != null Order By CreatedDate desc LIMIT 1];
        Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=quote.Last_Shipment__c, Account__c=quote.Account_for__c, Invoice_Date__c= system.today(),Import_Export_Quote_Order__c =quote.Id);
        insert shipdis;
        shipdis.Comments__c = 'Test';
        update shipdis;
    }
}