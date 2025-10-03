@isTest
public class Trigger_ImportExportItemLineInvoice_Test {
    @isTest(SeeAllData=true)
    public static void NEU_Update_IE_Cargo_Invoice_Lines_Conversion_Rate(){
        Invoice__c invoice = [SELECT Id, Import_Export_Quote_Order__c FROM Invoice__c LIMIT 1];
        Quote_Item_Line__c quote_item = new Quote_Item_Line__c();
        quote_item.Import_Export_Quote__c = invoice.Import_Export_Quote_Order__c;
        quote_item.Name = 'lineas items';
        insert quote_item;
    	Import_Export_Item_Line_Invoice__c ie_item_line_invoice = new Import_Export_Item_Line_Invoice__c();
     	ie_item_line_invoice.Amount_Allocated__c = 10;
     	ie_item_line_invoice.Conversion_Rate_to_Cargo_Line_Currency__c = 1; 
     	ie_item_line_invoice.Import_Export_Item_Line__c = quote_item.id;
     	ie_item_line_invoice.Invoice__c = invoice.Id;
     	insert ie_item_line_invoice;
    }
}