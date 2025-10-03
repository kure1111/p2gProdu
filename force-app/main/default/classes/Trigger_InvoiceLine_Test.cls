@isTest
public class Trigger_InvoiceLine_Test {
    @isTest(SeeAllData=true)
    public static void NEU_ActualizaINVLine(){
     	Invoice__c invoice = [SELECT Id, Import_Export_Quote_Order__c, Shipment__c  FROM Invoice__c LIMIT 1];
        
        Invoice_Line__c il = new Invoice_Line__c();
        il.Invoice__c = invoice.Id;
        il.Units__c = 10; 
        il.Unit_Price__c = 433.02;
        il.Amount__c= 433.02;
        insert il;
        
        il.Amount__c= 222;
        update il;
   }
}