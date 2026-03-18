@isTest
public class P2G_PAK_ShipmntEstMonWsTest {
	@isTest(SeeAllData=true)
    static void mainTest(){
        List<Shipment__c> listShipments=[SELECT Id, Name, LastModifiedBy.name, CreatedDate FROM Shipment__c ORDER BY CreatedDate DESC LIMIT 5]; 
        Map<Id,String> mapTestSP= new Map<Id,String>();
        for(Shipment__c sps: listShipments){
            mapTestSP.put(sps.Id,sps.Name);
        }
        PAK_ShipmntEstMonWs.estatusShipmentMon(mapTestSP);
    }
}