@isTest
public class P2G_NEU_JE_UpdateFoTranspPackDataTest {
@testSetup
    static void setupTestData() {
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId(); 
        insert a;
        
        Account sup= new Account();
        sup.Name='Test';
        sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();
        insert sup; 
        Account transporter= new Account();
        transporter.Name='Test';
        transporter.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();		
        transporter.OwnerId=UserInfo.getUserId();         
        insert transporter;
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-0001TEST', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', IMO_Number__c ='10', Only_Warehouse_Service__c = true);
        insert ship;
                    
    }
    
    @isTest
    static void testTriggerWithValidData() {
        Shipment__c testShipment = [SELECT Id, Account_for__c FROM Shipment__c LIMIT 1];
        
        Test.startTest();
        Transport_Packaging_Data__c newData = new Transport_Packaging_Data__c(
            Shipment__c = testShipment.Id
        );
        insert newData;
        Test.stopTest();
        
        List<EntitySubscription> subscriptions = [
            SELECT Id, ParentId, SubscriberId 
            FROM EntitySubscription 
            WHERE ParentId = :newData.Id
        ];
            
    }
    
    @isTest
    static void testTriggerWithStaticVariableTrue() {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        Shipment__c testShipment = [SELECT Id, Account_for__c FROM Shipment__c LIMIT 1];
        
        Test.startTest();
        Transport_Packaging_Data__c newData = new Transport_Packaging_Data__c(
            Shipment__c = testShipment.Id
        );
        insert newData;
        Test.stopTest();
        
        List<EntitySubscription> subscriptions = [
            SELECT Id 
            FROM EntitySubscription 
            WHERE ParentId = :newData.Id
        ];
                
    }
    
}