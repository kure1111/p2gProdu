@isTest
private class NEU_MD_GenerateShipment_tst {
    @isTest(SeeAllData=true)
    static void NEU_MD_GenerateShipment_tst() {
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c Order By CreatedDate desc LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(quote);
        NEU_MD_GenerateShipment controller = new NEU_MD_GenerateShipment(sc);
        PageReference result = controller.generate_shipment();
        NEU_MD_GenerateShipment.test();
        Test.stopTest();
    }
}