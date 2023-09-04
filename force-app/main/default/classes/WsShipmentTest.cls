@IsTest
public class WsShipmentTest {  
    @isTest(SeeAllData=true) static void testPUTShipmentSPFN() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FN-20-176712' LIMIT 1];
        
        WsShipment.UpdateShipment('Awaiting load_M',     shipment.Id, '', 'SP-FN', '', '2018-25-12 23:50:55');
        WsShipment.UpdateShipment('Awaiting load_M',     shipment.Id, '', 'SP-FN', '', '2018-25-12 23:50:55');
		WsShipment.UpdateShipment('Awaiting Unload_M',   shipment.Id, '', 'SP-FN', '', '2018-25-12 23:50:55');
		WsShipment.UpdateShipment('Loading_M',           shipment.Id, '', 'SP-FN', '', '2018-25-12 23:50:55');
		WsShipment.UpdateShipment('Delivery on Route_M', shipment.Id, '', 'SP-FN', '', '2018-25-12 23:50:55');
		WsShipment.UpdateShipment('Unloading_M',         shipment.Id, '', 'SP-FN', '', '2018-25-12 23:50:55');
		WsShipment.UpdateShipment('Finished_M',          shipment.Id, '', 'SP-FN', '', '2018-25-12 23:50:55');
    }
    
    @isTest(SeeAllData=true) static void testPUTShipmentSPFNSpecialNotes() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FN-20-176712' LIMIT 1];
        
        WsShipment.UpdateShipment('Confirm',           shipment.Id, 'Notas 1', 'SP-FN', '', '2018-25-12 23:50:55');
        WsShipment.UpdateShipment('Awaiting load_M',   shipment.Id, 'Notas 2', 'SP-FN', '', '2018-25-12 23:50:55');
		WsShipment.UpdateShipment('Awaiting Unload_M', shipment.Id, 'Notas 3', 'SP-FN', '', '2018-25-12 23:50:55');
    }
    
    @isTest(SeeAllData=true) static void testPUTShipmentSPFNCustomStatus() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FN-20-176712' LIMIT 1];
        
        WsShipment.UpdateShipment('Arrive Origin',      shipment.Id, 'Notas 1', 'SP-FN', '', '2018-25-12 23:50:55');
        WsShipment.UpdateShipment('Arrive Destination', shipment.Id, 'Notas 1', 'SP-FN', '', '2018-25-12 23:50:55');
    }
    
    @isTest(SeeAllData=true) static void testPUTShipmentSPA() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FN-20-176712' LIMIT 1];
        
        WsShipment.UpdateShipment('Confirm', shipment.Id, 'Notas 1', 'SP-A-', '', '2018-25-12 23:50:55');
    }

    @isTest(SeeAllData=true) static void testPUTShipmentSPM() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FN-20-176712' LIMIT 1];
        
        WsShipment.UpdateShipment('Confirm', shipment.Id, 'Notas 1', 'SP-M-', '', '2018-25-12 23:50:55');
    }
    
    @isTest(SeeAllData=true) static void testPUTShipmentError() {
      	WsShipment.UpdateShipment('loading' ,'a0J0n0004G', '', 'SP-A-', '', '');
      	WsShipment.UpdateShipment(''		,'a0J0n0004G', '', '',      '', '');
    }

}