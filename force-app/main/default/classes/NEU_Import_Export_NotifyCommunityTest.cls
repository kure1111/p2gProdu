@isTest
public class NEU_Import_Export_NotifyCommunityTest {
    @isTest(SeeAllData=true)
    static void testConstructorWithValidId() {
        // Obtener datos de prueba
        Customer_Quote__c testQuote = [SELECT Id, Contact__c, Contact__r.Email FROM Customer_Quote__c LIMIT 1];
        
        // Configurar contexto de prueba
        Test.setCurrentPage(Page.NEU_Import_Export_NotifyCommunity);
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        NEU_Import_Export_NotifyCommunity controller = new NEU_Import_Export_NotifyCommunity(sc);
            PageReference result = controller.notificar();
        Test.stopTest();
    }
}