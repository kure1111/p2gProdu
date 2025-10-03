@isTest
public class Trigger_IEServiceLineInvoice_Test {
    @isTest(SeeAllData=true)
    public static void NEU_Update_Invoice_Lines_Conversion_Rate(){
        Invoice__c invoice = [SELECT Id, Import_Export_Quote_Order__c, Account__c  FROM Invoice__c LIMIT 1];
        
        Fee__c fee = new Fee__c();
        fee.Name = 'test fees';
        fee.Fee_Category__c = 'Disbursement'; 
        fee.Rate_Type__c = '% of Charge';
        fee.Account_for__c = invoice.Account__c;
        insert fee;
        
        Import_Export_Fee_Line__c quote1 = new Import_Export_Fee_Line__c();
        quote1.Import_Export_Quote__c = invoice.Import_Export_Quote_Order__c;
        quote1.Name = 'lineas items';
        quote1.Service_Rate_Name__c = fee.Id;
        insert quote1;
        
     	Import_Export_Service_Line_Invoice__c ie_service_line_invoice = new Import_Export_Service_Line_Invoice__c();
     	ie_service_line_invoice.Amount_Allocated__c = 10;
     	ie_service_line_invoice.Conversion_Rate_to_Service_Line_Currency__c = 1; 
     	ie_service_line_invoice.Import_Export_Service_Line__c = quote1.Id;
     	ie_service_line_invoice.Invoice__c = invoice.Id;
     	insert ie_service_line_invoice;
	}
}