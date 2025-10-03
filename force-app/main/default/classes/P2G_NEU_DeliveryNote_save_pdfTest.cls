@isTest
public class P2G_NEU_DeliveryNote_save_pdfTest {

    @isTest(SeeAllData=true)
    static void testConstructorWithValidData() {
        // Get test shipment
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(shipment);
        NEU_DeliveryNote_save_pdf controller = new NEU_DeliveryNote_save_pdf(stdController);
        
        
    }
       
    @isTest(SeeAllData=true)
    static void testCrearMethodSuccess() {
        
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        Shipment_Line__c shipmentLine = [SELECT Id FROM Shipment_Line__c LIMIT 1];
        
        
        Test.setCurrentPage(Page.NEU_DeliveryNote_pdf);
        ApexPages.currentPage().getParameters().put('id', shipment.Id);
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(shipment);
        NEU_DeliveryNote_save_pdf controller = new NEU_DeliveryNote_save_pdf(stdController);
        
        Test.startTest();
        PageReference result = controller.crear();
        Test.stopTest();
	}
}