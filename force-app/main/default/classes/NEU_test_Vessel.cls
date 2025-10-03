@isTest(SeeAllData=true)
private class NEU_test_Vessel {

    @isTest
    static void testConstructorAndFeedMethod() {
        // Buscar un Shipment__c real para pruebas (porque SeeAllData=true)
        Shipment__c shipment = [
            SELECT Id, Name, Route__c, Equipment__c, CurrencyIsoCode 
            FROM Shipment__c 
            WHERE Route__c != null 
            LIMIT 1
        ];

        // Crear el StandardController con el registro real
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(shipment);

        // Ejecutar el constructor
        Test.startTest();
        NEU_Updated_Position_of_Ship controller = new NEU_Updated_Position_of_Ship(stdCtrl);
        Test.stopTest();

        // Llamar a create_feed() (aunque el cuerpo se omite durante test por isRunningTest)
        controller.create_feed();
    }
}