@isTest
public class Trigger_InvoiceItemLine_Test {
	@isTest(SeeAllData=true)
    public static void NEU_Update_Shipment_Cargo_Invoice_Lines_Conversion_Rate(){
     	Invoice__c invoice = [SELECT Id, Import_Export_Quote_Order__c, Shipment__c FROM Invoice__c WHERE CurrencyIsoCode = 'MXN' AND Shipment__r.Account_Origin_Address__c = null AND Shipment__r.Account_Destination_Address__c = null LIMIT 1];
        
        Shipment_Line__c shipline = new Shipment_Line__c();
        shipline.Shipment__c = invoice.Shipment__c;
        shipline.Name = 'test ship line';
        shipline.CurrencyIsoCode = 'MXN';
        insert shipline;

     	Invoice_Item_Line__c invoice_item_line = new Invoice_Item_Line__c();
     	invoice_item_line.Amount__c = 10;
        invoice_item_line.CurrencyIsoCode = 'MXN';
     	invoice_item_line.Conversion_Rate_to_Cargo_Line_Currency__c = 1;
     	invoice_item_line.Invoice__c = invoice.Id;
     	invoice_item_line.Shipment_Item_Line__c = shipline.Id;
     	insert invoice_item_line;
	}
}