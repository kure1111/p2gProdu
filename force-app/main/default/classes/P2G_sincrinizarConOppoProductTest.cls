@IsTest
public class P2G_sincrinizarConOppoProductTest {
    @IsTest(SeeAllData=true)
    static void testUpdateQuoteLine() {
        // Obtener datos de prueba
        Quote testQuote = [SELECT Id, OpportunityId FROM Quote LIMIT 1];
                // Realizar las consultas para obtener las listas
        List<QuoteLineItem> qlis = [SELECT Id, OpportunityLineItemId, Quantity, Sales_Price_Converted__c, UnitPrice,SubProducto__c 
                                    FROM QuoteLineItem 
                                    WHERE OpportunityLineItemId != null 
                                    LIMIT 2];
                                    
        List<OpportunityLineItem> todosOlis = [SELECT Id, Status__c, Quantity,Product2Id,PricebookEntryId,Sales_Price_Converted__c, UnitPrice 
                                               FROM OpportunityLineItem 
                                               WHERE Status__c IN ('Cotizada', 'Aceptada', 'Negociación con cliente') 
                                               LIMIT 2];
        
        List<SubProducto__c> subproduct = [SELECT Id, Status__c, SubProduct_Buy_Price_Converted__c, SubProduct_Sell_Price__c,
                                           SubProduct_Opportunity_Product__c 
                                           FROM SubProducto__c 
                                           WHERE Id =: 'a3CRQ000009iKib2AE' OR Status__c IN ('Cotizada', 'Aceptada', 'Negociación con cliente') 
                                           LIMIT 10];
        
        List<Quote> quotes = new List<Quote>{testQuote};

        Test.startTest();
        P2G_sincrinizarConOppoProduct.updateQuoteLine(quotes);
        P2G_sincrinizarConOppoProduct.modificarQuoteLine(qlis,todosOlis);
        P2G_sincrinizarConOppoProduct.insertarQuoteLine(qlis,todosOlis,testQuote.Id);
        P2G_sincrinizarConOppoProduct.eliminarQuoteLine(qlis,todosOlis);
        P2G_sincrinizarConOppoProduct.insertarQuoteLineSub(qlis,subproduct,testQuote.Id,todosOlis);
        P2G_sincrinizarConOppoProduct.modificarQuoteLineSub(qlis, subproduct);
        P2G_sincrinizarConOppoProduct.eliminarQuoteLineSub(qlis, subproduct);
        P2G_sincrinizarConOppoProduct.insertarSubProducto(subproduct[0],testQuote.Id,todosOlis[0]);
        P2G_sincrinizarConOppoProduct.pase();
        Test.stopTest();
        
    }
    
    
  
}