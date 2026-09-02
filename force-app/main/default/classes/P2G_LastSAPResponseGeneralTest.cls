@isTest(seeAllData=true)
public class P2G_LastSAPResponseGeneralTest {
    
    @isTest
    static void testNoExistingRecords() {        
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
                
        Response__c resp = new Response__c(
            Object__c = 'Shipment',
            Shipment__c = ship.Id,
            Last_SAP_Response_General__c = false
        );
        
        Test.startTest();
        insert resp;
        Test.stopTest();
        
        Response__c inserted = [SELECT Id, Last_SAP_Response_General__c 
                                FROM Response__c WHERE Id = :resp.Id];        
    }
    
    @isTest
    static void testWithExistingRecord() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
                
        Response__c first = new Response__c(
            Object__c = 'Shipment',
            Shipment__c = ship.Id,
            Last_SAP_Response_General__c = false
        );
        insert first;
                
        Response__c firstCheck = [SELECT Last_SAP_Response_General__c 
                                  FROM Response__c WHERE Id = :first.Id];
                
        Response__c second = new Response__c(
            Object__c = 'Shipment',
            Shipment__c = ship.Id,
            Last_SAP_Response_General__c = false
        );
        
        Test.startTest();
        insert second;
        Test.stopTest();
                
        firstCheck = [SELECT Last_SAP_Response_General__c 
                      FROM Response__c WHERE Id = :first.Id];        
        Response__c secondCheck = [SELECT Last_SAP_Response_General__c 
                                   FROM Response__c WHERE Id = :second.Id];
        System.assertEquals(true, secondCheck.Last_SAP_Response_General__c,
                            'El segundo Response debe ser true');
    }
    
    @isTest
    static void testNonShipmentObject() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        
        Response__c resp = new Response__c(
            Object__c = 'Other',  // No es 'Shipment'
            Shipment__c = ship.Id,
            Last_SAP_Response_General__c = false
        );
        
        Test.startTest();
        insert resp;
        Test.stopTest();
        
        Response__c inserted = [SELECT Last_SAP_Response_General__c 
                                FROM Response__c WHERE Id = :resp.Id];
        System.assertEquals(false, inserted.Last_SAP_Response_General__c,
                            'No debe modificarse porque Object__c no es Shipment');
    }
    
    @isTest
    static void testNullShipment() {
        Response__c resp = new Response__c(
            Object__c = 'Shipment',
            Shipment__c = null,
            Last_SAP_Response_General__c = false
        );
        
        Test.startTest();
        insert resp;
        Test.stopTest();
        
        Response__c inserted = [SELECT Last_SAP_Response_General__c 
                                FROM Response__c WHERE Id = :resp.Id];
        System.assertEquals(false, inserted.Last_SAP_Response_General__c,
                            'No debe modificarse porque Shipment__c es nulo');
    }
}