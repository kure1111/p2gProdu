@isTest
public with sharing class NEU_EmailAlertsShipment_Test {
    @testSetup static void createObjects(){

        //user        
        User userT = new User();
        userT.FirstName = 'leo';
        userT.LastName = 'test';
        userT.Email = 'leoTest@test.com';
        userT.Username = 'leoTest@test.com.leoTest';
        userT.Alias = 'TestL';
        userT.TimeZoneSidKey = 'America/Mexico_City';
        userT.LocaleSidKey = 'es_MX';
        userT.EmailEncodingKey = 'UTF-8';
        userT.ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id;
        userT.LanguageLocaleKey = 'es_MX';
        insert userT;

        //Account         
        Account accountT = new Account();
        accountT.name = 'account test';
        accountT.Customer_Id__c = '58SQL1256';
        accountT.OwnerId = userT.Id;
        accountT.Venta_Sap__c = 'Contado';        
        insert accountT;

        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FN-test0001';        
        new_shipment.Freight_Mode__c = 'Road';
        new_shipment.Account_for__c=accountT.Id;            
        new_shipment.Service_Mode__c = 'NATIONAL';
        new_shipment.Service_Type__c =  'LTL';
        new_shipment.Move_Type__c = 'Door to Door';        
        new_shipment.Only_Warehouse_Service__c = false;                    
        new_shipment.Operation_Executive__c = userT.Id;
		new_shipment.RecordTypeId = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Request').getRecordTypeId();        
        insert new_shipment;

    }
}