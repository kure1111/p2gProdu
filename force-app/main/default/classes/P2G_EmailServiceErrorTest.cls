@isTest(SeeAllData=true)
public class P2G_EmailServiceErrorTest {
    @isTest
    static void testEnviarEmailPorError_ConDatosReales() {
        Response__c responseExistente = [
            SELECT Id, Invoice__c, Type__c, Message__c, CreatedById 
            FROM Response__c 
            WHERE Invoice__c != null 
            AND Type__c = 'ERROR'
            AND CreatedBy.Name LIKE '%Interfaces%'
            LIMIT 1
        ];
		
        Response__c nuevo = new Response__c();
        nuevo.Invoice__c = responseExistente.Invoice__c;
        nuevo.Type__c = responseExistente.Type__c;
        nuevo.Message__c = responseExistente.Message__c;
        Test.startTest();
        insert nuevo;
        //P2G_EmailServiceError.enviarEmailPorError(nuevo);
        Test.stopTest();
    }
}