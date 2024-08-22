@IsTest
public class WsShipmentTest {  
    @isTest(SeeAllData=true) static void testPUTShipmentSPFN() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FN-20-176712' LIMIT 1];
        
        WsShipment.UpdateShipment('Arrive Origin', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
        WsShipment.UpdateShipment('Arrive Destination', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
        WsShipment.UpdateShipment('Awaiting load_M', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
        WsShipment.UpdateShipment('Awaiting Unload_M', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
        WsShipment.UpdateShipment('Delivery on Route_M', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
        WsShipment.UpdateShipment('Finished_M', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
        WsShipment.UpdateShipment('Loading_M', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
		WsShipment.UpdateShipment('Unloading_M', shipment.Id, 'SP-FN', '2024-02-07 17:04:09.071', '', 'EXPORT','Siniestro');
    }

}