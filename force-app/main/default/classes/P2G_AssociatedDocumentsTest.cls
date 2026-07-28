@isTest(SeeAllData=true)
public class P2G_AssociatedDocumentsTest {
    
    @isTest
    static void testDebitNoteUpdate_WithExistingShipment() {        
        Shipment__c existingShipment = [SELECT Id, Debit_Note_Uploaded__c, Account_for__c FROM Shipment__c 
                                        WHERE Debit_Note_Uploaded__c = false 
                                        AND Account_for__c!=null 
                                        AND Traslado_Ingreso__c!=null LIMIT 1];
        
        if (existingShipment != null) {            
            Associated_Document__c doc = new Associated_Document__c(
                Document_Type__c = 'Other',
                Document_Description__c = 'This document contains DN',
                Shipment__c = existingShipment.Id,
                Account__c= existingShipment.Account_for__c
            );
            
            Test.startTest();
            insert doc;
            Test.stopTest();                        
        }
    }
    
    @isTest
    static void testDebitNoteUpdate_NoDNInDescription() {
        Shipment__c existingShipment = [SELECT Id, Debit_Note_Uploaded__c, Account_for__c FROM Shipment__c 
                                        WHERE Account_for__c!=null AND Traslado_Ingreso__c!=null LIMIT 1];
        
        if (existingShipment != null) {
            Associated_Document__c doc = new Associated_Document__c(
                Document_Type__c = 'Other',
                Document_Description__c = 'Otro',
                Shipment__c = existingShipment.Id,
                Account__c= existingShipment.Account_for__c
            );
            
            Test.startTest();
            insert doc;
            Test.stopTest();
        }
    }
    
    @isTest
    static void testDebitNoteUpdate_DifferentDocumentType() {
        Shipment__c existingShipment = [SELECT Id, Debit_Note_Uploaded__c, Account_for__c FROM Shipment__c 
                                        WHERE Account_for__c!=null AND Traslado_Ingreso__c!=null LIMIT 1];
        
        if (existingShipment != null) {
            Associated_Document__c doc = new Associated_Document__c(
                Document_Type__c = 'Acuse',
                Document_Description__c = 'Acuse',
                Shipment__c = existingShipment.Id,
                Account__c= existingShipment.Account_for__c
            );
            
            Test.startTest();
            insert doc;
            Test.stopTest();
        }
    }
        
}