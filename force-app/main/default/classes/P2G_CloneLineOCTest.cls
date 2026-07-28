@isTest(SeeAllData=true)
private class P2G_CloneLineOCTest {
    
    @isTest
    static void testCloneShipmentLine() {
        // Obtener un registro existente de la base de datos real    
        List<Shipment_Fee_Line__c> existingRecords = [SELECT Id, Shipment__r.Shipment_Status_Plann__c FROM Shipment_Fee_Line__c 
        WHERE Shipment__r.Shipment_Status_Plann__c!='Closed' AND Shipment__r.Shipment_Status_Plann__c!='Cancel' ORDER BY CreatedDate DESC LIMIT 1];
        
        // Solo ejecutar la prueba si hay registros existentes
        if (!existingRecords.isEmpty()) {
            Shipment_Fee_Line__c originalRecord = existingRecords[0];
            
            Test.startTest();
            String result = P2G_CloneLineOC.cloneShipmentLine(originalRecord.Id);
            Test.stopTest();
            
            // Verificar que no retorna error
            System.assert(!result.startsWith('ERROR'), 'No debería retornar error: ' + result);
            // Verificar que retorna un ID
            System.assert(result.length() > 0, 'Debe retornar un ID');
        }
    }
    
    @isTest
    static void testCloneShipmentLineEmptyId() {
        Test.startTest();
        String result = P2G_CloneLineOC.cloneShipmentLine('');
        Test.stopTest();
        
        System.assert(result.startsWith('ERROR'), 'Debe retornar error para ID vacío');
    }
}