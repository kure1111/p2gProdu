@isTest(seeAllData=true)
private class NEU_UpdateTrafficsTest {

    static testMethod void testUpdateTraffics() {
        // Buscar tráficos que tengan al menos un Customer_Quote__c relacionado
        List<Traffic__c> trafficsWithQuotes = [
            SELECT Id, Name FROM Traffic__c
            WHERE Id IN (SELECT Traffic__c FROM Customer_Quote__c WHERE Traffic__c != null)
            LIMIT 1
        ];
        // Limpiar temporalmente el campo N_Import_Exports__c para simular el caso inicial
        List<Traffic__c> trafficsToUpdate = new List<Traffic__c>();
        for (Traffic__c t : trafficsWithQuotes) {
            t.N_Import_Exports__c = null;
            trafficsToUpdate.add(t);
        }
        update trafficsToUpdate;

        Test.startTest();
        NEU_UpdateTraffics controller = new NEU_UpdateTraffics();
        PageReference resultPage = controller.update_traffics();
        Test.stopTest();
    }
}