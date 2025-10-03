@isTest
public class Trigger_InvoiceServiceLine_Test {
	@isTest(SeeAllData=true)
	public static void NEU_Update_Invoice_Ship_Lines_Conversion_Rate(){
     	Invoice__c invoice = [SELECT Id, Import_Export_Quote_Order__c, Shipment__c, Account__c, Shipment__r.Account_Shipment_Reference__c  FROM Invoice__c WHERE Shipment__r.Shipment_Status_Plann__c != 'Closed' AND Shipment__r.Account_Origin_Address__c = null AND Shipment__r.Account_Destination_Address__c = null Order By CreatedDate desc LIMIT 1 ];
        Shipment_Fee_Line__c shipfeeline = [SELECT Id FROM Shipment_Fee_Line__c WHERE Shipment__c =: invoice.Shipment__c LIMIT 1];
        
     	Invoice_Service_Line__c invoice_service = new Invoice_Service_Line__c();
     	invoice_service.Amount__c = 10;
     	invoice_service.Conversion_Rate_to_Service_Line_Currency__c = 1;
     	invoice_service.Invoice__c = invoice.Id;
     	invoice_service.Shipment_Service_Line__c = shipfeeline.Id;
     	insert invoice_service;
     }

}