@isTest
public class P2G_updateShipmentInCustomerQuoteTest {
	@isTest(SeeAllData=true)
    public static void updateShipmentInCustomerQuoteTest(){
        Customer_Quote__c quote = new Customer_Quote__c();
        Test.startTest();
        quote.id = 'a0IRQ000000aifF2AQ';
        quote.ETA__c = System.today();
        update quote;
        Test.stopTest();
    }
}