@isTest(SeeAllData=true)
public class ShipmentTriggerHandler_test {
    
    private static Shipment__c getShipment() {
        return [SELECT Id, Name, Account_for__c, Account_for__r.Venta_Sap__c,
                       Shipment_Status__c, Ocean_Shipment_Status__c, Air_Shipment_Status__c,
                       Shipment_Status_Plann__c, Shipment_Status_Mon__c, Routing_Operation_Status__c,
                       Service_Mode__c, Freight_Mode__c, Order__c, Status_Shipment__c
                FROM Shipment__c 
                WHERE Account_for__c != null AND Traslado_Ingreso__c != null
                LIMIT 1];
    }
    
    @isTest
    static void testTrigger() {
        Shipment__c ship = getShipment();
        
        Test.startTest();
        ShipmentTriggerHandler.byPass();
        Test.stopTest();
    }
}