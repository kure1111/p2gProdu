@isTest
public class P2G_NEU_DOTest {
    
    @isTest(SeeAllData=true)
    static void testConstructorWithValidData() {        
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        Account releaseCompany = [SELECT Id FROM Account LIMIT 1];
        Contact releaseContact = [SELECT Id FROM Contact LIMIT 1]; 	        
        PageReference pageRef = Page.NEU_DO_pdf; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', quote.Id);
        ApexPages.currentPage().getParameters().put('id_rc', releaseCompany.Id);
        ApexPages.currentPage().getParameters().put('id_rc_c1', releaseContact.Id);
        ApexPages.currentPage().getParameters().put('remarks', 'Test Remarks');
        ApexPages.currentPage().getParameters().put('release_date', '2023-01-01');
        ApexPages.currentPage().getParameters().put('release_valid', '2023-12-31');
        ApexPages.currentPage().getParameters().put('shipment_pick_up', 'Test Pickup Contact');
                
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        NEU_DO_pdf controller = new NEU_DO_pdf(stdController);       
    }
        
    @isTest(SeeAllData=true)
    static void testPDFContentWithAllFields() {
        
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        Account releaseCompany = [SELECT Id FROM Account LIMIT 1];
        Contact releaseContact = [SELECT Id FROM Contact LIMIT 1];        
        
        PageReference pageRef = Page.NEU_DO_pdf;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', quote.Id);
        ApexPages.currentPage().getParameters().put('id_rc', releaseCompany.Id);
        ApexPages.currentPage().getParameters().put('id_rc_c1', releaseContact.Id);
        ApexPages.currentPage().getParameters().put('remarks', 'Test Remarks');
        ApexPages.currentPage().getParameters().put('release_date', '2023-01-01');
        ApexPages.currentPage().getParameters().put('release_valid', '2023-12-31');
        ApexPages.currentPage().getParameters().put('shipment_pick_up', 'Test Pickup Contact');
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        NEU_DO_pdf controller = new NEU_DO_pdf(stdController);
        
    }
}