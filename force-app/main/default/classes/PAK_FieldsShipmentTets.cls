@isTest
public class PAK_FieldsShipmentTets {
    @IsTest(SeeAllData=true)
    public static void test(){
        Shipment__c sp = [SELECT Id FROM Shipment__c WHERE id = 'a0JRL0000003Hif2AE' OR Shipment_Status_Plann__c='In Progress' limit 1];
		sp.Shipment_Status_Plann__c = 'In Progress';
        update sp; 
    }
    
}