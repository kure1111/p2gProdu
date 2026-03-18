@isTest(seeAllData=true)
private class PAK_AcuseAttachTest {
    
    // Método helper para crear AttachmentAcuse de prueba
    private static PAK_AcuseAttach.AttachmentAcuse createMockAttachment(String customerId, String nameDocumento, String documento) {
        PAK_AcuseAttach.AttachmentAcuse mock = new PAK_AcuseAttach.AttachmentAcuse();
        mock.CustomerID = customerId;
        mock.NameDocumento = nameDocumento;
        mock.Documento = documento;
        return mock;
    }
    
    // Método helper para crear documento base64 de prueba
    private static String createMockBase64Document() {
        Blob mockBlob = Blob.valueOf('Test document content for PDF');
        return EncodingUtil.base64Encode(mockBlob);
    }
    
    @isTest
    static void testAcuseDocumento_InsertSuccess() {
        // Buscar una cuenta existente con Customer_Id__c
        List<Account> existingAccounts = [SELECT Id, Customer_Id__c FROM Account WHERE Customer_Id__c != null LIMIT 1];
        if(existingAccounts.isEmpty()) {
            System.debug('No se encontraron cuentas con Customer_Id__c para la prueba');
            return;
        }
        
        String customerId = existingAccounts[0].Customer_Id__c;
        String uniqueDocName = 'test-document-' + DateTime.now().getTime() + '.pdf';
        String base64Doc = createMockBase64Document();
        
        // Crear lista de AttachmentAcuse
        List<PAK_AcuseAttach.AttachmentAcuse> attachments = new List<PAK_AcuseAttach.AttachmentAcuse>();
        PAK_AcuseAttach.AttachmentAcuse mockAttach = createMockAttachment(customerId, uniqueDocName, base64Doc);
        attachments.add(mockAttach);
        
        Test.startTest();
        List<PAK_AcuseAttach.status> results = PAK_AcuseAttach.AcuseDocumento(attachments);
        Test.stopTest();
        
        System.debug('Resultado Insert Success - Code: ' + results[0].code + ', Message: ' + results[0].message);
        
        // Verificar que se creó el documento
        List<Associated_Document__c> createdDocs = [
            SELECT Id, Name, Account__c, Document_Type__c, Document_URL__c 
            FROM Associated_Document__c 
            WHERE Name = :uniqueDocName
        ];
        System.debug('Documento creado: ' + (createdDocs.isEmpty() ? 'No' : 'Sí - ID: ' + createdDocs[0].Id));
        
        // Verificar que se creó el attachment
        if(!createdDocs.isEmpty()) {
            List<Attachment> createdAttachments = [
                SELECT Id, Name, ContentType 
                FROM Attachment 
                WHERE ParentId = :createdDocs[0].Id
            ];
            System.debug('Attachment creado: ' + (createdAttachments.isEmpty() ? 'No' : 'Sí - Tipo: ' + createdAttachments[0].ContentType));
        }
        
        // Verificar que se creó la respuesta
        List<Response__c> responses = [
            SELECT Id, Type__c, Message__c, Account__c 
            FROM Response__c 
            WHERE Account__c = :existingAccounts[0].Id 
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];
        System.debug('Response creada: ' + (responses.isEmpty() ? 'No' : 'Sí - Tipo: ' + responses[0].Type__c));
    }
    
    @isTest
    static void testAcuseDocumento_DocumentExists() {
        // Buscar una cuenta existente con Customer_Id__c
        List<Account> existingAccounts = [SELECT Id, Customer_Id__c FROM Account WHERE Customer_Id__c != null LIMIT 1];
        if(existingAccounts.isEmpty()) {
            System.debug('No se encontraron cuentas con Customer_Id__c para la prueba');
            return;
        }
        
        String customerId = existingAccounts[0].Customer_Id__c;
        String existingDocName = 'existing-test-doc.pdf';
        String base64Doc = createMockBase64Document();
        
        // Crear un documento existente primero
        Associated_Document__c existingDoc = new Associated_Document__c();
        existingDoc.Name = existingDocName;
        existingDoc.Account__c = existingAccounts[0].Id;
        existingDoc.Document_Type__c = 'Other';
        existingDoc.Type__c = 'Document';
        insert existingDoc;
        
        // Crear lista de AttachmentAcuse con el mismo nombre
        List<PAK_AcuseAttach.AttachmentAcuse> attachments = new List<PAK_AcuseAttach.AttachmentAcuse>();
        PAK_AcuseAttach.AttachmentAcuse mockAttach = createMockAttachment(customerId, existingDocName, base64Doc);
        attachments.add(mockAttach);
        
        Test.startTest();
        List<PAK_AcuseAttach.status> results = PAK_AcuseAttach.AcuseDocumento(attachments);
        Test.stopTest();
        
        System.debug('Resultado Document Exists - Code: ' + results[0].code + ', Message: ' + results[0].message);
    }
    

    @isTest
    static void testAcuseDocumento_AccountNotFound() {
        // Usar CustomerID que no existe
        String nonExistentCustomerId = 'NONEXISTENT-' + DateTime.now().getTime();
        String uniqueDocName = 'test-doc-noaccount-' + DateTime.now().getTime() + '.pdf';
        String base64Doc = createMockBase64Document();
        
        // Crear lista de AttachmentAcuse
        List<PAK_AcuseAttach.AttachmentAcuse> attachments = new List<PAK_AcuseAttach.AttachmentAcuse>();
        PAK_AcuseAttach.AttachmentAcuse mockAttach = createMockAttachment(nonExistentCustomerId, uniqueDocName, base64Doc);
        attachments.add(mockAttach);
        
        Test.startTest();
        List<PAK_AcuseAttach.status> results = PAK_AcuseAttach.AcuseDocumento(attachments);
        Test.stopTest();
        
        System.debug('Resultado Account Not Found - Code: ' + results[0].code + ', Message: ' + results[0].message);
    }
    
    @isTest
    static void testAcuseDocumento_InvalidBase64() {
        // Buscar una cuenta existente con Customer_Id__c
        List<Account> existingAccounts = [SELECT Id, Customer_Id__c FROM Account WHERE Customer_Id__c != null LIMIT 1];
        if(existingAccounts.isEmpty()) {
            System.debug('No se encontraron cuentas con Customer_Id__c para la prueba');
            return;
        }
        
        String customerId = existingAccounts[0].Customer_Id__c;
        String uniqueDocName = 'test-invalid-' + DateTime.now().getTime() + '.pdf';
        
        // Crear AttachmentAcuse con base64 inválido
        List<PAK_AcuseAttach.AttachmentAcuse> attachments = new List<PAK_AcuseAttach.AttachmentAcuse>();
        PAK_AcuseAttach.AttachmentAcuse mockAttach = createMockAttachment(customerId, uniqueDocName, 'INVALID-BASE64-!!!');
        attachments.add(mockAttach);
        
        Test.startTest();
        List<PAK_AcuseAttach.status> results = PAK_AcuseAttach.AcuseDocumento(attachments);
        Test.stopTest();
        
        System.debug('Resultado Invalid Base64 - Code: ' + results[0].code + ', Message: ' + results[0].message);
        
        // Verificar que se creó un Response de error
        List<Response__c> errorResponses = [
            SELECT Id, Type__c, Message__c 
            FROM Response__c 
            WHERE Type__c = 'ERROR' 
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];
        System.debug('Response de error creada: ' + (errorResponses.isEmpty() ? 'No' : 'Sí - Mensaje: ' + errorResponses[0].Message__c));
    }
}