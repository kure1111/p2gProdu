@IsTest
public class WsShipmentTest {  

    @isTest(SeeAllData=true)
    static void testPUTShipmentSPFN() {
        NEU_StaticVariableHelper.setBoolean1(true);
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        String shipmentId = shipment.Id;

        List<Map<String, Object>> testData = new List<Map<String, Object>>{
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Arrive Origin', 'otd' => 'Siniestro' },
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Arrive Destination', 'eventDatetime' => '2024-02-07 17:04:09.071', 'otd' => 'Siniestro' },
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Awaiting load_M', 'eventDatetime' => '2024-02-07 17:04:09.071', 'otd' => 'Siniestro' },
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Awaiting Unload_M', 'eventDatetime' => '2024-02-07 17:04:09.071', 'otd' => 'Siniestro' },
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Delivery on Route_M', 'eventDatetime' => '2024-02-07 17:04:09.071', 'otd' => 'Siniestro' },
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Finished_M', 'eventDatetime' => '2024-02-07 17:04:09.071', 'otd' => 'Siniestro' },
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Loading_M', 'eventDatetime' => '2024-02-07 17:04:09.071', 'otd' => 'Siniestro' },
            new Map<String, Object>{ 'idShipment' => shipmentId, 'status' => 'Unloading_M', 'eventDatetime' => '2024-02-07 17:04:09.071', 'otd' => 'Siniestro' }
        };

        for (Map<String, Object> data : testData) {
            RestContext.request = new RestRequest();
            RestContext.response = new RestResponse();
            RestContext.request.requestBody = Blob.valueOf(JSON.serialize(data));
            String result = WsShipment.UpdateShipment();
        }
    }
}