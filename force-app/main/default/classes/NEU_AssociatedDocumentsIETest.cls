@isTest(SeeAllData=true)
public class NEU_AssociatedDocumentsIETest {

    @isTest
    static void testMethods() {
        
        // Primero buscar un Customer_Quote__c existente
        List<Customer_Quote__c> quotes = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        if (quotes.isEmpty()) {
            return; // No hay registros, se termina el test
        }
        Id quoteId = quotes[0].Id;
        
        // Probar getImportExport
        Customer_Quote__c quote = NEU_AssociatedDocumentsIE.getImportExport(quoteId);
        
        // Probar getDocuments
        List<Associated_Document__c> documentos1 = NEU_AssociatedDocumentsIE.getDocuments(quoteId);
        
        // Probar createAssociatedDocuments
        List<String> archivos = new List<String>();
        archivos.add('https://prueba.com/archivo.pdf|ArchivoDePrueba.pdf');
        List<Associated_Document__c> documentos2 = NEU_AssociatedDocumentsIE.createAssociatedDocuments(quoteId, archivos);
        
        // Crear un Associated_Document__c de prueba para borrar
        List<Associated_Document__c> docs = [SELECT Id FROM Associated_Document__c WHERE Import_Export_Quote__c = :quoteId LIMIT 1];
        if (!docs.isEmpty()) {
            NEU_AssociatedDocumentsIE.deleteDocument(quoteId, docs[0].Id);
        }
    }
}