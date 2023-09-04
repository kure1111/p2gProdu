@isTest
public class P2G_wsUpdateShipmentTest {
    @isTest
    static void testUpdateShipment() {
        String requestBody = '{"idShip":"a0K3h000000abcde","success":"success"}';
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        String response = P2G_wsUpdateShipment.updateShipmnet();
        //System.assertEquals('devuelve llamdo:c', response);
    }
}