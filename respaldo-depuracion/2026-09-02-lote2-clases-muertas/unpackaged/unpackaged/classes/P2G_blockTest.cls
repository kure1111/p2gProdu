@isTest(SeeAllData=true)
private class P2G_blockTest {
    
    @isTest
    static void testValidateUpdateWithCartaPorte() {
        
        Carta_Porte__c cartaPorte = [SELECT Id, Shipment__c FROM Carta_Porte__c Limit 1];
        Shipment_Fee_Line__c linea = [SELECT Id,Shipment__c FROM Shipment_Fee_Line__c  WHERE Shipment__c =: cartaPorte.Shipment__c limit 1];
        // Test
        Test.startTest();
        try {
            List<Shipment_Fee_Line__c> lineas = new List<Shipment_Fee_Line__c>();
            lineas.add(linea);
            P2G_block.validateUpdate(lineas); // Esto debería fallar
            update linea;
        } catch (Exception e) {
            System.debug('error');
        }
        Test.stopTest();
    }
}