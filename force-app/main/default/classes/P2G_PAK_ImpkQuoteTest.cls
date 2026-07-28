@isTest
public class P2G_PAK_ImpkQuoteTest {    
    
    @isTest(seeAllData=true)
    static void testUpdateQuoteExistente() {
        // Buscar una cotización existente en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        
        if(!existingQuotes.isEmpty()) {
            Customer_Quote__c testQuote = existingQuotes[0];
            
            // Crear objeto Quote con los datos a actualizar
            PAK_ImpkQuote.Quote quoteData = new PAK_ImpkQuote.Quote();
            quoteData.quoteName = testQuote.Name;
            quoteData.pricing = '1000.00';
            quoteData.datePricingResponse = Datetime.now();
            quoteData.FinalClient = 'Cliente Final Test';
            quoteData.stage = 'Aprobada';
            
            Test.startTest();
            PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(quoteData);
            Test.stopTest();
            
            System.debug('Resultado testUpdateQuoteExistente: ' + result);
        } else {
            System.debug('No se encontraron Customer_Quote__c en la organización');
        }
    }
    
    @isTest(seeAllData=true)
    static void testUpdateQuoteNoExistente() {
        // Usar un nombre de cotización que probablemente no existe
        String quoteNameNoExistente = 'QUOTE-NO-EXISTE-' + System.currentTimeMillis();
        
        // Crear objeto Quote con el nombre no existente
        PAK_ImpkQuote.Quote quoteData = new PAK_ImpkQuote.Quote();
        quoteData.quoteName = quoteNameNoExistente;
        quoteData.pricing = '2000.00';
        quoteData.datePricingResponse = Datetime.now();
        quoteData.FinalClient = 'Cliente No Existente';
        quoteData.stage = 'Rechazada';
        
        Test.startTest();
        PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(quoteData);
        Test.stopTest();
        
        System.debug('Resultado testUpdateQuoteNoExistente: ' + result);
    }
    
    @isTest(seeAllData=true)
    static void testUpdateQuoteConCamposNulos() {
        // Buscar una cotización existente en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        
        if(!existingQuotes.isEmpty()) {
            Customer_Quote__c testQuote = existingQuotes[0];
            
            // Crear objeto Quote con campos nulos
            PAK_ImpkQuote.Quote quoteData = new PAK_ImpkQuote.Quote();
            quoteData.quoteName = testQuote.Name;
            quoteData.pricing = null;
            quoteData.datePricingResponse = null;
            quoteData.FinalClient = null;
            quoteData.stage = null;
            
            Test.startTest();
            PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(quoteData);
            Test.stopTest();
            
            System.debug('Resultado testUpdateQuoteConCamposNulos: ' + result);
        } else {
            System.debug('No se encontraron Customer_Quote__c en la organización');
        }
    }
    
    @isTest(seeAllData=true)
    static void testUpdateQuoteConNombreVacio() {
        // Crear objeto Quote con nombre vacío
        PAK_ImpkQuote.Quote quoteData = new PAK_ImpkQuote.Quote();
        quoteData.quoteName = '';
        quoteData.pricing = '1500.00';
        quoteData.datePricingResponse = Datetime.now();
        quoteData.FinalClient = 'Cliente Test';
        quoteData.stage = 'En Proceso';
        
        Test.startTest();
        PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(quoteData);
        Test.stopTest();
        
        System.debug('Resultado testUpdateQuoteConNombreVacio: ' + result);
    }
    
    @isTest(seeAllData=true)
    static void testUpdateQuoteConNombreNull() {
        // Crear objeto Quote con nombre null
        PAK_ImpkQuote.Quote quoteData = new PAK_ImpkQuote.Quote();
        quoteData.quoteName = null;
        quoteData.pricing = '1500.00';
        quoteData.datePricingResponse = Datetime.now();
        quoteData.FinalClient = 'Cliente Test';
        quoteData.stage = 'En Proceso';
        
        Test.startTest();
        PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(quoteData);
        Test.stopTest();
        
        System.debug('Resultado testUpdateQuoteConNombreNull: ' + result);
    }
    @isTest(seeAllData=true)
    static void testUpdateQuoteConCaracteresEspeciales() {
        // Buscar una cotización existente en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        
        if(!existingQuotes.isEmpty()) {
            Customer_Quote__c testQuote = existingQuotes[0];
            
            // Crear objeto Quote con caracteres especiales
            PAK_ImpkQuote.Quote quoteData = new PAK_ImpkQuote.Quote();
            quoteData.quoteName = testQuote.Name;
            quoteData.pricing = '$1,500.00'; // Formato con símbolo y coma
            quoteData.datePricingResponse = Datetime.now();
            quoteData.FinalClient = 'Cliente Final Test - ñ & áéíóú'; // Caracteres especiales
            quoteData.stage = 'Etapa #1 - (Aprobada)'; // Caracteres especiales
            
            Test.startTest();
            PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(quoteData);
            Test.stopTest();
            
            System.debug('Resultado testUpdateQuoteConCaracteresEspeciales: ' + result);
        } else {
            System.debug('No se encontraron Customer_Quote__c en la organización');
        }
    }
   
    @isTest(seeAllData=true)
    static void testUpdateQuoteConPricingLargo() {
        // Buscar una cotización existente en la org
        List<Customer_Quote__c> existingQuotes = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        
        if(!existingQuotes.isEmpty()) {
            Customer_Quote__c testQuote = existingQuotes[0];
            
            // Crear objeto Quote con pricing muy largo
            String pricingLargo = '';
            for(Integer i = 0; i < 100; i++) {
                pricingLargo += '9';
            }
            
            PAK_ImpkQuote.Quote quoteData = new PAK_ImpkQuote.Quote();
            quoteData.quoteName = testQuote.Name;
            quoteData.pricing = pricingLargo; // String muy largo
            quoteData.datePricingResponse = Datetime.now();
            quoteData.FinalClient = 'Cliente Pricing Largo';
            quoteData.stage = 'Test';
            
            Test.startTest();
            PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(quoteData);
            Test.stopTest();
            
            System.debug('Resultado testUpdateQuoteConPricingLargo: ' + result);
        } else {
            System.debug('No se encontraron Customer_Quote__c en la organización');
        }
    }
    
    @isTest(seeAllData=true)
    static void testUpdateQuoteObjetoNull() {
        // Probar pasando null como parámetro
        try {
            Test.startTest();
            PAK_ImpkQuote.estatus result = PAK_ImpkQuote.updateQuote(null);
            Test.stopTest();
            
            System.debug('Resultado testUpdateQuoteObjetoNull: ' + result);
        } catch (Exception e) {
            System.debug('Excepción capturada en testUpdateQuoteObjetoNull: ' + e.getMessage());
        }
    }


}