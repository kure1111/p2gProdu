@isTest(seeAllData=true)
private class NEU_test_Return_Import_Export_Quote {

    @isTest
    static void testReturnIE() {

        Shipment__c existingShipment = [
            SELECT Id FROM Shipment__c 
            WHERE Id IN (SELECT Shipment__c FROM Shipment_Consolidation_Data__c)
            LIMIT 1
        ];

        // Crear el StandardController con el Shipment existente
        ApexPages.StandardController sc = new ApexPages.StandardController(existingShipment);

        // Instanciar la clase a probar
        NEU_Return_Import_Export_Quote controller = new NEU_Return_Import_Export_Quote(sc);

        // Llamar el método a probar
        PageReference result = controller.return_ie();
    }

    @isTest
    static void testReturnIENoResults() {
        // Obtener un Shipment__c que no tenga relación con Shipment_Consolidation_Data__c
        Shipment__c noConsoShipment = [
            SELECT Id FROM Shipment__c 
            WHERE Id NOT IN (SELECT Shipment__c FROM Shipment_Consolidation_Data__c)
            LIMIT 1
        ];

        ApexPages.StandardController sc = new ApexPages.StandardController(noConsoShipment);

        NEU_Return_Import_Export_Quote controller = new NEU_Return_Import_Export_Quote(sc);

        PageReference result = controller.return_ie();
    }
}