@isTest(SeeAllData=true)
private class P2G_CloneLineOCTest {
    
    @isTest
    static void testCloneShipmentLine() {
        // Obtener un registro existente de la base de datos real
        List<Shipment_Fee_Line__c> existingRecords = [SELECT Id FROM Shipment_Fee_Line__c ORDER BY CreatedDate DESC limit 1];
        
        // Solo ejecutar la prueba si hay registros existentes
        if (!existingRecords.isEmpty()) {
            Shipment_Fee_Line__c originalRecord = existingRecords[0];
            
            Test.startTest();
            String result = P2G_CloneLineOC.cloneShipmentLine(originalRecord.Id);
            Test.stopTest();
        }
    }
    
    @isTest
    static void testCloneShipmentLineEmptyId() {
        Test.startTest();
        String result = P2G_CloneLineOC.cloneShipmentLine('');
        Test.stopTest();
    }
}