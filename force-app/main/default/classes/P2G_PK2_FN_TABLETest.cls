@isTest
public class P2G_PK2_FN_TABLETest {
	@isTest(SeeAllData=true)
    static void testGetThousandBlocks() {
        PK2_FN_TABLE controller = new PK2_FN_TABLE();
        
        Test.startTest();
        List<PK2_FN_TABLE.limitWrapper> blocks = controller.getthousandBlocks();
        Test.stopTest();
        

    }
    
    @isTest(SeeAllData=true)
    static void testLimitWrapperClass() {
        List<Customer_Quote__c> testQuotes = [SELECT Id FROM Customer_Quote__c LIMIT 10];
        
        PK2_FN_TABLE.limitWrapper wrapper = new PK2_FN_TABLE.limitWrapper(testQuotes, 1);
        
    }
    
    
}