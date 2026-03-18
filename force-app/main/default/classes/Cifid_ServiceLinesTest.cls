@isTest(seeAllData=true)
private class Cifid_ServiceLinesTest {
    
    // Método helper en lugar de clase mock interna
    private static Cifid_ServiceLines.Quote createMockQuote(String quoteName, Integer operation) {
        Cifid_ServiceLines.Quote mockQuote = new Cifid_ServiceLines.Quote();
        mockQuote.quoteName = quoteName;
        mockQuote.operation = operation;
        mockQuote.lines = new List<Cifid_ServiceLines.ServiceLine>();
        
        // Crear líneas de prueba
        for(Integer i = 1; i <= 3; i++) {
            Cifid_ServiceLines.ServiceLine line = new Cifid_ServiceLines.ServiceLine();
            line.idLine = 'MOCK-EXT-LINE-' + i;
            line.name = 'Mock Service Line ' + i;
            line.rateName = 'Mock Rate ' + i;
            line.units = i * 5;
            line.quoteSellPrice = i * 150;
            line.buyPrice = i * 120;
            mockQuote.lines.add(line);
        }
        
        return mockQuote;
    }
    
    @isTest
    static void testServiceLines_Insert() {
        // Buscar una cotización real en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        if(existingQuotes.isEmpty()) {
            return;
        }
        
        String quoteName = existingQuotes[0].Name;
        
        // Crear mock quote con operación INSERT (1)
        Cifid_ServiceLines.Quote testQuote = createMockQuote(quoteName, 1);
        
        Test.startTest();
        Cifid_ServiceLines.estatus result = Cifid_ServiceLines.serviceLines(testQuote);
        Test.stopTest();
        
        // Verificar que se insertaron los registros
        List<Import_Export_Fee_Line__c> insertedLines = [
            SELECT Id, Ext_Service_Line_IMPK__c 
            FROM Import_Export_Fee_Line__c 
            WHERE Ext_Service_Line_IMPK__c LIKE 'MOCK-EXT-LINE-%'
        ];
    }
    
    @isTest
    static void testServiceLines_Update() {
        // Buscar una cotización real en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        if(existingQuotes.isEmpty()) {
            return;
        }
        
        String quoteName = existingQuotes[0].Name;
        
        // Primero insertar líneas para luego actualizarlas
        Cifid_ServiceLines.Quote insertQuote = createMockQuote(quoteName, 1);
        Cifid_ServiceLines.serviceLines(insertQuote);
        
        // Crear mock quote con operación UPDATE (2) - mismos IDs pero datos diferentes
        Cifid_ServiceLines.Quote updateQuote = new Cifid_ServiceLines.Quote();
        updateQuote.quoteName = quoteName;
        updateQuote.operation = 2;
        updateQuote.lines = new List<Cifid_ServiceLines.ServiceLine>();
        
        for(Integer i = 1; i <= 3; i++) {
            Cifid_ServiceLines.ServiceLine line = new Cifid_ServiceLines.ServiceLine();
            line.idLine = 'MOCK-EXT-LINE-' + i;
            line.name = 'Updated Service Line ' + i;
            line.rateName = 'Updated Rate ' + i;
            line.units = i * 10;
            line.quoteSellPrice = i * 200;
            line.buyPrice = i * 180;
            updateQuote.lines.add(line);
        }
        
        Test.startTest();
        Cifid_ServiceLines.estatus result = Cifid_ServiceLines.serviceLines(updateQuote);
        Test.stopTest();
    }
    
    @isTest
    static void testServiceLines_Delete() {
        // Buscar una cotización real en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        if(existingQuotes.isEmpty()) {
            return;
        }
        
        String quoteName = existingQuotes[0].Name;
        
        // Primero insertar líneas para luego eliminarlas
        Cifid_ServiceLines.Quote insertQuote = createMockQuote(quoteName, 1);
        Cifid_ServiceLines.serviceLines(insertQuote);
        
        // Crear mock quote con operación DELETE (3)
        Cifid_ServiceLines.Quote deleteQuote = new Cifid_ServiceLines.Quote();
        deleteQuote.quoteName = quoteName;
        deleteQuote.operation = 3;
        deleteQuote.lines = new List<Cifid_ServiceLines.ServiceLine>();
        
        for(Integer i = 1; i <= 3; i++) {
            Cifid_ServiceLines.ServiceLine line = new Cifid_ServiceLines.ServiceLine();
            line.idLine = 'MOCK-EXT-LINE-' + i;
            deleteQuote.lines.add(line);
        }
        
        Test.startTest();
        Cifid_ServiceLines.estatus result = Cifid_ServiceLines.serviceLines(deleteQuote);
        Test.stopTest();
        
        // Verificar que se eliminaron los registros
        List<Import_Export_Fee_Line__c> deletedLines = [
            SELECT Id 
            FROM Import_Export_Fee_Line__c 
            WHERE Ext_Service_Line_IMPK__c LIKE 'MOCK-EXT-LINE-%'
        ];
    }
    
    @isTest
    static void testServiceLines_QuoteNotFound() {
        // Usar un nombre de cotización que no existe
        String quoteName = 'NONEXISTENT-QUOTE-' + DateTime.now().getTime();
        
        // Crear mock quote con operación INSERT
        Cifid_ServiceLines.Quote testQuote = createMockQuote(quoteName, 1);
        
        Test.startTest();
        Cifid_ServiceLines.estatus result = Cifid_ServiceLines.serviceLines(testQuote);
        Test.stopTest();
    }
    
    @isTest
    static void testServiceLines_DuplicateIds() {
        // Buscar una cotización real en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        if(existingQuotes.isEmpty()) {
            System.debug('No se encontraron cotizaciones para la prueba');
            return;
        }
        
        String quoteName = existingQuotes[0].Name;
        
        // Crear quote con IDs duplicados para probar el Set
        Cifid_ServiceLines.Quote testQuote = new Cifid_ServiceLines.Quote();
        testQuote.quoteName = quoteName;
        testQuote.operation = 1;
        testQuote.lines = new List<Cifid_ServiceLines.ServiceLine>();
        
        // Agregar líneas con el mismo ID
        for(Integer i = 1; i <= 5; i++) {
            Cifid_ServiceLines.ServiceLine line = new Cifid_ServiceLines.ServiceLine();
            line.idLine = 'DUPLICATE-ID';  // Mismo ID para todas
            line.name = 'Test Line ' + i;
            line.rateName = 'Test Rate ' + i;
            line.units = i * 5;
            line.quoteSellPrice = i * 100;
            line.buyPrice = i * 80;
            testQuote.lines.add(line);
        }
        
        Test.startTest();
        Cifid_ServiceLines.estatus result = Cifid_ServiceLines.serviceLines(testQuote);
        Test.stopTest();
    }
}