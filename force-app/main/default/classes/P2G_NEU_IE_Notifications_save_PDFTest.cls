@isTest
public class P2G_NEU_IE_Notifications_save_PDFTest {
	@isTest(SeeAllData=true)
    static void testConstructorWithValidData() {
        // Get test quote
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        
        // Create standard controller and extension
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        NEU_IE_Notifications_save_PDF controller = new NEU_IE_Notifications_save_PDF(stdController);
      
    }
       
    @isTest(SeeAllData=true)
    static void testReturnPageMethod() {
        // Get test quote
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        
        // Create standard controller and extension
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        NEU_IE_Notifications_save_PDF controller = new NEU_IE_Notifications_save_PDF(stdController);
        
        Test.startTest();
        PageReference result = controller.return_page();
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void testCrearMethodSuccess() {
        // Get test data
        Customer_Quote__c quote = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        
        // Set mock for PDF generation
        Test.setCurrentPage(Page.NEU_IE_Notifications_PDF);
        ApexPages.currentPage().getParameters().put('id', quote.Id);
        
        // Create standard controller and extension
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        NEU_IE_Notifications_save_PDF controller = new NEU_IE_Notifications_save_PDF(stdController);
        
        Test.startTest();
        PageReference result = controller.crear();
        Test.stopTest();
    }
}