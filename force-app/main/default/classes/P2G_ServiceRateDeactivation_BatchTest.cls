@IsTest
public class P2G_ServiceRateDeactivation_BatchTest {

    @isTest(seeAllData=true)
        static void testConstructor() {
        Test.startTest();
        P2G_ServiceRateDeactivation_Batch batch = new P2G_ServiceRateDeactivation_Batch();
        Test.stopTest();
        
        System.debug('Constructor ejecutado, consultaSOQL: ' + batch.ServiceRateQuery);
    }
    // Test Service rate = active and valid until today
    @IsTest(seeAllData=true)
    static void testValidFees() {
        List <Fee__c> testServiceRate = [SELECT Id, Active__c, Valid_Until__c, Route__c, SAP_Service_Type__c FROM Fee__c WHERE Valid_Until__c < TODAY AND Active__c = true AND Tarifario_Compras__c =true AND Route__c != null AND SAP_Service_Type__c != null LIMIT 10];
        System.debug('Lista Service Rate activos: ' + testServiceRate);
        if (testServiceRate.isEmpty()) {
            System.debug('No se encontraron Tarifarios para desactivar');
            return;
        }
        
        Test.startTest();
        Database.executeBatch(new P2G_ServiceRateDeactivation_Batch(), 10);
        Test.stopTest();
        
    }
}