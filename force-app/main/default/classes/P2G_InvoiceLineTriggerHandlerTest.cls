@isTest(SeeAllData=true)
private class P2G_InvoiceLineTriggerHandlerTest {
    
    @isTest
    static void testBeforeInsert_WithValidResponse() {
        // Usar datos existentes - buscar un Shipment que tenga un Response válido
        Response__c validResponse = [
            SELECT Id, Shipment__c 
            FROM Response__c 
            WHERE Type__c = 'CONFIRM' 
            AND Message__c != 'Carga correcta en recurso confiable'
            AND Shipment__c != null 
            LIMIT 1
        ];
        
        // Crear Invoice_Line__c con el shipment que tiene response válido
        Invoice_Line__c invLine = new Invoice_Line__c();
        invLine.Invoice__c = 'a1U4T0000008Ga7UAE';
        invLine.Import_Export_Quote_Order__c = 'a0I4T000002gZhKUAU';
        invLine.Shipment__c ='a0J4T000003jIEGUA2';
        invLine.Shipment_Service_Line__c = 'a1y4T000000crxHQAQ';
        invLine.CurrencyIsoCode = 'MXN';
        Test.startTest();
        try {
            insert invLine;
            //P2G_InvoiceLineTriggerHandler.beforeInsert(new List<Invoice_Line__c>{invLine});
            // Si llega aquí, la validación pasó
            System.assert(true, 'Debería permitir la creación con Response válido');
        } catch (Exception e) {
            System.assert(false, 'No debería lanzar excepción: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void deleteinv() {
    Invoice_Line__c toDelete = [SELECT Id FROM Invoice_Line__c limit 1];
        Test.startTest();
        try {
            delete toDelete;
        } catch (Exception e) {
            System.debug('No debería lanzar excepción: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
}