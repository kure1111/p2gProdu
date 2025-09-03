@isTest
public class P2G_NEU_ControlTowerTest {
	@isTest(SeeAllData=true)
    static void getShipmentsPlannedTest(){     
        Test.startTest();        
        List<Shipment__c> result = NEU_ControlTower.getShipmentsPlanned();        
        Test.stopTest();               
    }		
    @isTest(SeeAllData=true)
    static void getIntransitShipmentsTest(){
        Test.startTest();
        List<Shipment__C> result=NEU_ControlTower.getIntransitShipments();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void getDeliveredShipmentsTest(){        
        Test.startTest();
        List<Shipment__C> result=NEU_ControlTower.getDeliveredShipments();
        Test.stopTest();
    }
    
    @isTest
    static void getRoadShipmentsTest(){
        Test.startTest();
        List<Shipment__C> result=NEU_ControlTower.getRoadShipments();
        Test.stopTest();
        
    }
    
    
    @isTest(SeeAllData=true)
    static void getAirShipmentsTest(){
        Test.startTest();
        List<Shipment__C> result=NEU_ControlTower.getAirShipments();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void getShipmentTrackTest(){
        Shipment__c sp=[SELECT Id FROM Shipment__c LIMIT 1];
        Test.startTest();
        Shipment_Track__c result=NEU_ControlTower.getShipmentTrack(sp);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void getRoadDataTest(){
        Shipment__c sp=[SELECT Id FROM Shipment__c LIMIT 1];
        Test.startTest();
        List<Shipment_Stop__c> result=NEU_ControlTower.getRoadData(sp);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void getShipmentTest(){
        Shipment__c sp=[SELECT Id FROM Shipment__c LIMIT 1];
        Test.startTest();
        Shipment__c result=NEU_ControlTower.getShipment(sp.Id);
        Test.stopTest();
    }
    
    
    
}