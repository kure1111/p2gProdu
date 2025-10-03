@isTest
public class P2G_NEU_Aditional_DiscountsTest {

    @isTest(SeeAllData=true)
    static void testConstructorAndProperties() {
        
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        
        Discount_Rule__c rule = new Discount_Rule__c(
            Name = 'Test Discount',
            Discount__c = 10,
            Valid_From__c = Date.today().addDays(-10),
            Valid_To__c = Date.today().addDays(10),
            Enabled__c = true
        );
        insert rule;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        
        Test.startTest();
        NEU_Aditional_Discounts controller = new NEU_Aditional_Discounts(stdController); 
        System.assert(!controller.lines.isEmpty(), 'Debería haber líneas de descuento');
        NEU_Aditional_Discounts.Import_Export_Discount_Line_s lineWrapper = controller.lines[0];
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testApplyLinesWithSelection() {
        
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        
        List<Discount_Rule__c> discountRules = new List<Discount_Rule__c>();
        discountRules.add(new Discount_Rule__c(
            Name = 'Discount 1',
            Discount__c = 5,
            Valid_From__c = Date.today().addDays(-10),
            Valid_To__c = Date.today().addDays(10),
            Enabled__c = true
        ));
        discountRules.add(new Discount_Rule__c(
            Name = 'Discount 2',
            Discount__c = 10,
            Valid_From__c = Date.today().addDays(-5),
            Valid_To__c = Date.today().addDays(5),
            Enabled__c = true
        ));
        discountRules.add(new Discount_Rule__c(
            Name = 'Disabled Discount',
            Discount__c = 15,
            Valid_From__c = Date.today().addDays(-5),
            Valid_To__c = Date.today().addDays(5),
            Enabled__c = false
        ));
        insert discountRules;
        
        List<Discount_Rule__c> enabledRules = [SELECT Id FROM Discount_Rule__c WHERE Enabled__c = true];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        NEU_Aditional_Discounts controller = new NEU_Aditional_Discounts(stdController);
        
        controller.lines[0].selected = true;
        
        Test.startTest();
        controller.apply_lines();
        Test.stopTest();
              
    }
    
    @isTest(SeeAllData=true)
    static void testApplyLinesWithoutSelection() {
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
        NEU_Aditional_Discounts controller = new NEU_Aditional_Discounts(stdController);
        
        Test.startTest();
        controller.apply_lines();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testDecimalSepProperty() {        
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c LIMIT 1];        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        NEU_Aditional_Discounts controller = new NEU_Aditional_Discounts(stdController);
        
        Test.startTest();
                
        String expectedDecimalSep = NEU_Utils.getDecimalSep();
        System.assertEquals(expectedDecimalSep, controller.decimalSep, 'El separador decimal debería ser el mismo que devuelve NEU_Utils');
                
        String customDecimalSep = ',';
        controller.decimalSep = customDecimalSep;
        System.assertEquals(customDecimalSep, controller.decimalSep, 'El separador decimal debería ser el valor establecido manualmente');
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testThousandSepProperty() {
        
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c LIMIT 1];        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        NEU_Aditional_Discounts controller = new NEU_Aditional_Discounts(stdController);
        
        Test.startTest();
        
        
        String expectedThousandSep = NEU_Utils.getThousandSep();
        System.assertEquals(expectedThousandSep, controller.thousandSep, 'El separador de miles debería ser el mismo que devuelve NEU_Utils');
        
        
        String customThousandSep = '.';
        controller.thousandSep = customThousandSep;
        System.assertEquals(customThousandSep, controller.thousandSep, 'El separador de miles debería ser el valor establecido manualmente');
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testBothPropertiesTogether() {        
        Customer_Quote__c testQuote =[SELECT Id FROM Customer_Quote__c LIMIT 1];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        NEU_Aditional_Discounts controller = new NEU_Aditional_Discounts(stdController);
        
        Test.startTest();
        
        
        String testDecimal = controller.decimalSep;
        String testThousand = controller.thousandSep;
        
        System.assertNotEquals(null, testDecimal, 'El separador decimal no debería ser null');
        System.assertNotEquals(null, testThousand, 'El separador de miles no debería ser null');
        
        
        System.assertNotEquals(testDecimal, testThousand, 
            'Los separadores decimal y de miles normalmente deberían ser diferentes');
        
        Test.stopTest();
    }
    
}