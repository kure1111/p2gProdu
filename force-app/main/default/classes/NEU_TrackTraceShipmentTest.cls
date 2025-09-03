@isTest(SeeAllData=true)
public class NEU_TrackTraceShipmentTest {
    
    @isTest
    static void test_getShipment() {
        // Obtiene un Shipment__c real de la org
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        Test.startTest();
        Shipment__c result = NEU_TrackTraceShipment.getShipment(shipment.Id);
        System.assertNotEquals(null, result, 'El Shipment no debe ser null');
        Test.stopTest();
    }

    @isTest
    static void test_getShipmentTrack() {
        // Obtiene un Shipment__c real de la org con un Shipment_Track__c asociado (si existe)
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        Test.startTest();
        Shipment_Track__c result = NEU_TrackTraceShipment.getShipmentTrack(shipment.Id);
        Test.stopTest();
    }

    @isTest
    static void test_getRoadData() {
        // Obtiene un Shipment__c real de la org con paradas
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        List<Shipment_Stop__c> stops = [SELECT Id FROM Shipment_Stop__c WHERE Shipment__c = :shipment.Id LIMIT 1];
        
        Test.startTest();
        List<Shipment_Stop__c> result = NEU_TrackTraceShipment.getRoadData(shipment.Id);
        Test.stopTest();
    }

    @isTest
    static void test_getRoutePoints() {
        // Obtiene un Shipment__c real de la org con relaciones necesarias
        Shipment__c shipment = [SELECT Id, 
            Country_of_Load__r.Name, 
            State_of_Load__r.Name, 
            Site_of_Load__r.Name, 
            Country_of_Discharge__r.Name, 
            State_of_Discharge__r.Name, 
            Site_of_Discharge__r.Name 
            FROM Shipment__c 
            WHERE Country_of_Load__r.Name != null AND 
                  State_of_Load__r.Name != null AND 
                  Site_of_Load__r.Name != null AND 
                  Country_of_Discharge__r.Name != null AND 
                  State_of_Discharge__r.Name != null AND 
                  Site_of_Discharge__r.Name != null
            LIMIT 1];
        
        Test.startTest();
        List<NEU_TrackTraceShipment.Route_Point_s> points = NEU_TrackTraceShipment.getRoutePoints(shipment);
    }
}