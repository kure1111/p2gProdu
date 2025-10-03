@isTest
public class Trigger_Invoice_Test {
    //triggers afectados
    //NEU_ActualizaFolioINV
    //NEU_CheckInvoiceLinesCurrency
    //NEU_Conversion_Rate_Invoice_Date
    //NEU_Update_Payable_Before
    //NEU_UpdateOutstandingBalanceAccount
	@isTest(SeeAllData=true)
    public static void Invoice_Test(){
        Customer_Quote__c quote =[SELECT Id, Last_Shipment__r.Account_for__c, Last_Shipment__c FROM Customer_Quote__c WHERE Last_Shipment__r.Account_for__r.Tippag_cta__c = 'Credito' AND Pricing_Executive__c != null Order By CreatedDate desc LIMIT 1];
        Invoice__c new_invoice = new Invoice__c();
        new_invoice.Name = 'test';
        new_invoice.Import_Export_Quote_Order__c = quote.Id; 
        new_invoice.Shipment__c = quote.Last_Shipment__c;
        new_invoice.Account__c = quote.Last_Shipment__r.Account_for__c;
        new_invoice.Date_of_Invoice__c = system.today();
        insert new_invoice;
        new_invoice.Comments__c = 'test';
        new_invoice.Name = 'test';
        update new_invoice;
    }
}