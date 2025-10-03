@isTest(seeAllData=true)
private class NEU_test_Disbursements {

    static testMethod void testRedirectWithImportExportId() {
        // Obtener un Customer Quote con cuenta de proveedor relacionada
        List<Customer_Quote__c> quotes = [
            SELECT Id, Name, Supplier_Account__c 
            FROM Customer_Quote__c 
            WHERE Supplier_Account__c != null 
            LIMIT 1
        ];

        Customer_Quote__c quote = quotes[0];

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('import_export_id', quote.Id);

        NEU_NewDisbursementButton ndb = new NEU_NewDisbursementButton();
        ndb.redirect();
    }

    static testMethod void testRedirectWithShipmentId() {
        // Obtener un Shipment y su Customer Quote relacionado
        List<Shipment__c> shipments = [
            SELECT Id, Name, Supplier_Account__c 
            FROM Shipment__c 
            WHERE Supplier_Account__c != null 
            LIMIT 1
        ];

        Shipment__c shipment = shipments[0];

        List<Customer_Quote__c> relatedQuotes = [
            SELECT Id, Name 
            FROM Customer_Quote__c 
            WHERE Last_Shipment__c = :shipment.Id 
            LIMIT 1
        ];
        if (relatedQuotes.isEmpty()) return;

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('shipment_id', shipment.Id);

        NEU_NewDisbursementButton ndb = new NEU_NewDisbursementButton();
        ndb.redirect();
    }
}