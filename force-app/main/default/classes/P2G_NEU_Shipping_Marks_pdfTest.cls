@isTest
public class P2G_NEU_Shipping_Marks_pdfTest {

    @isTest(SeeAllData=true)
    static void testConstructorWithValidShipment() {
        
        Shipment__c testShipment = [SELECT Id FROM Shipment__c LIMIT 1];
                
        ApexPages.StandardController sc = new ApexPages.StandardController(testShipment);
        
        Test.startTest();
        NEU_Shipping_Marks_pdf controller = new NEU_Shipping_Marks_pdf(sc);
        Test.stopTest();
    }
}