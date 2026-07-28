@isTest
public class P2G_ServiceRateDeactivationTest {
	@IsTest(SeeAllData=True)
    static void getActiveFee() {
        List<Fee__c> ServiceRateList = [
            SELECT Id, Active__c, Valid_Until__c, Route__c, SAP_Service_Type__c 
            FROM Fee__c 
            WHERE Valid_Until__c < TODAY AND Active__c = true AND Tarifario_Compras__c = true AND Route__c != null AND SAP_Service_Type__c != null LIMIT 10
        ];
        System.debug('Query de tarifarios' + ServiceRateList);
        Test.startTest();
    	P2G_ServiceRateDeactivation.deactivateFee(ServiceRateList);
    	Test.stopTest();
        
        
        }
}