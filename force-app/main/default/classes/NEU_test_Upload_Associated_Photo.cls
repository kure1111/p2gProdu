@isTest(seeAllData=true)
private class NEU_test_Upload_Associated_Photo {

    @isTest
    static void testForShipment() {
        // Obtener un shipment real de la base de datos
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Freight_Mode__c != null LIMIT 1];

        // Simular parámetros de página
        Test.setCurrentPage(Page.NEU_Upload_Associated_Photos);
        ApexPages.currentPage().getParameters().put('id', shipment.Id);

        Test.startTest();
        NEU_Upload_Associated_Photos controller = new NEU_Upload_Associated_Photos();

        controller.documents_names = 'foto1.jpg_&_foto2.jpg_&_';
        controller.documents_names_dates = 'folder/foto1.jpg_&_folder/foto2.jpg_&_';

        controller.save_associated_photo();
        Test.stopTest();
    }

    @isTest(seeAllData=true)
    static void testReturnToObject() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];

        Test.setCurrentPage(Page.NEU_Upload_Associated_Photos);
        ApexPages.currentPage().getParameters().put('id', shipment.Id);

        NEU_Upload_Associated_Photos controller = new NEU_Upload_Associated_Photos();
        PageReference ref = controller.return_to_object();
    }
}