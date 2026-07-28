@isTest(SeeAllData=true)
public class P2G_EmailServiceErrorTest {
    @isTest
    static void testEnviarEmailPorError_ConDatosReales() {
        Response__c responseExistente = [
            SELECT Id, Name, Invoice__c, Type__c, Message__c, CreatedById 
            FROM Response__c 
            WHERE Invoice__c != null 
            AND Type__c = 'ERROR'
            //AND CreatedById = '0050R000007Xof5QAC' //ID para Probar en UAT
            AND CreatedById = '0054T000000cUdmQAE' //ID para Probar en Prod
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