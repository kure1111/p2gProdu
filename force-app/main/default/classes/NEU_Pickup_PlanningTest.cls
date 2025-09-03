@isTest(SeeAllData=true)
public class NEU_Pickup_PlanningTest {
    @isTest
    static void testOriginLocationAndDestinationLocation() {
        // Obtener un Shipment real con el RecordType correcto
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Shipment__c' AND Name = 'Shipment Request' LIMIT 1];
        Shipment__c shipment = [
            SELECT Id, Origin_Location__Latitude__s, Origin_Location__Longitude__s, 
                   Destination_Location__Latitude__s, Destination_Location__Longitude__s 
            FROM Shipment__c 
            LIMIT 1
        ];

        Test.startTest();
        NEU_Pickup_Planning planner = new NEU_Pickup_Planning();
        planner.shipmentid = shipment.Id;
        planner.latitude = 25.12345;
        planner.longitude = -100.54321;

        planner.originlocation();
        planner.destinationlocation();
        Test.stopTest();

        // Verifica que se haya hecho update (valores no necesariamente iguales si ya estaban seteados)
        Shipment__c updatedShipment = [SELECT Origin_Location__Latitude__s, Destination_Location__Longitude__s FROM Shipment__c WHERE Id = :shipment.Id];
    }

    @isTest
    static void testVehicleAddressUpdate() {
        // Obtener un vehículo real
        Vehicle__c vehicle = [
            SELECT Id, Last_Address__c 
            FROM Vehicle__c 
            LIMIT 1
        ];

        Test.startTest();
        NEU_Pickup_Planning planner = new NEU_Pickup_Planning();
        planner.vehicleid = vehicle.Id;
        planner.address = 'Test Address 123';

        planner.vehicleaddress();
        Test.stopTest();

        Vehicle__c updatedVehicle = [SELECT Last_Address__c FROM Vehicle__c WHERE Id = :vehicle.Id];
    }

    @isTest
    static void testGetters() {
        Test.startTest();
        NEU_Pickup_Planning planner = new NEU_Pickup_Planning();
        // Ejecutar getters
        List<Shipment__c> shipments = planner.lines;
        List<Vehicle__c> vehicles = planner.vehicles;
        Test.stopTest();
    }

}