@isTest
public class NEU_Import_Export_Quotes_SearchTest {
    @isTest
    static void testConstructorAndCargaFiltros() {
        Test.startTest();
        NEU_Import_Export_Quotes_Search controller = new NEU_Import_Export_Quotes_Search();
        controller.carga_filtros();
        controller.search_import_export_quote_order();
        controller.step_Instalacion = '2';
        controller.anterior_siguiente_Instalacion();
        controller.step_order = '2';
        controller.anterior_siguiente_order();
        List<SelectOption> etdOptions = controller.getETD_operator_list();
        List<SelectOption> etaOptions = controller.getETA_operator_list();
        List<SelectOption> serviceTypeOptions = controller.getservices_type();
        Test.stopTest();
    }
    @isTest(SeeAllData=true)
    static void testUpdateStatusQuote() {
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c WHERE RecordType.DeveloperName = 'Import_Export_Order' AND Pricing_Executive__c != null AND Quotation_Status__c = 'Approved as Succesful' LIMIT 1];
        
        NEU_Import_Export_Quotes_Search controller = new NEU_Import_Export_Quotes_Search();
        controller.carga_filtros();
        controller.ids_ie_quotes = testQuote.Id;
        controller.filter_status_quote = new Customer_Quote__c(Quotation_Status__c = 'Approved as Succesful');
        
        Test.startTest();
        controller.update_status_quote();
        Test.stopTest();
        
    }
    @isTest(SeeAllData=true)
    static void testGoCompareMethods() {
        NEU_Import_Export_Quotes_Search controller = new NEU_Import_Export_Quotes_Search();
        controller.carga_filtros();
        
        Test.startTest();
        controller.go_compare_quote();
        controller.go_compare_orders();
        Test.stopTest();
        
        System.assertNotEquals(0, controller.ie_quotes.size(), 'Should have quotes after compare');
        System.assertNotEquals(0, controller.ie_orders.size(), 'Should have orders after compare');
    }
}