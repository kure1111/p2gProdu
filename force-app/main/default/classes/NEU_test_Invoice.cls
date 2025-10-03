@isTest(seeAllData=true)
private class NEU_test_Invoice {
    static testMethod void NEU_Invoice_PDF() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Invoice__c i_test = [
            SELECT Id, Account__c, Import_Export_Quote_Order__c, Shipment__c
            FROM Invoice__c
            WHERE Account__c != null
              AND Import_Export_Quote_Order__c != null
              AND Shipment__c != null
            LIMIT 1
        ];
        
        NEU_Invoice_PDF i_pdf = new NEU_Invoice_PDF(new ApexPages.StandardController(i_test));
    }

    @isTest(seeAllData=true)
    static void testRedirectWithImportExportId() {
        // Asume que ya existe al menos un Customer_Quote__c con Account
        Customer_Quote__c quote = [
            SELECT Id, Name, Account_for__c, Account_for__r.Name 
            FROM Customer_Quote__c 
            WHERE Account_for__c != null 
            LIMIT 1
        ];
        
        Test.setCurrentPage(new PageReference('PageReference'));
        ApexPages.currentPage().getParameters().put('import_export_id', quote.Id);

        NEU_NewInvoiceButton controller = new NEU_NewInvoiceButton();
        PageReference result = controller.redirect();

    }

    @isTest(seeAllData=true)
    static void testRedirectWithShipmentId() {

        Shipment__c shipment = [
            SELECT Id, Name, Account_for__c, Account_for__r.Name 
            FROM Shipment__c 
            LIMIT 1
        ];

        Test.setCurrentPage(new PageReference('PageReference'));
        ApexPages.currentPage().getParameters().put('shipment_id', shipment.Id);

        NEU_NewInvoiceButton controller = new NEU_NewInvoiceButton();
        PageReference result = controller.redirect();
    }
    
}