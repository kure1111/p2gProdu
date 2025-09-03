@isTest
public class P2G_NEU_Show_FileTest {
        
    @isTest
    static void testGetDocumentBase64_Success() {
        ContentVersion cvFile = new ContentVersion(
            ContentLocation = 'S',
            VersionData = Blob.valueOf('Test Data'),
            Title = 'Test document.pdf',
            PathOnClient = 'Test document.pdf'
        );
        insert cvFile;
        
        // Configurar parámetros de página
        ApexPages.currentPage().getParameters().put('id', cvFile.Id);
        ApexPages.currentPage().getParameters().put('contentType', 'application/pdf');
        
        // Ejecutar prueba
        Test.startTest();
        NEU_Show_File controller = new NEU_Show_File();
        PageReference result = controller.getDocumentBase64();
        Test.stopTest();
        
        
    }
        
    @isTest
    static void testGetDocumentBase64_InvalidId() {
        Account testAccount = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
            OwnerId = UserInfo.getUserId()
        );
        insert testAccount;
        ApexPages.currentPage().getParameters().put('id', testAccount.Id);
                
        Test.startTest();
        NEU_Show_File controller = new NEU_Show_File();
        PageReference result = controller.getDocumentBase64();
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetDocumentBase64_NoContentType() {
        
        ContentVersion cvFile = new ContentVersion(
            ContentLocation = 'S',
            VersionData = Blob.valueOf('Test Data'),
            Title = 'No type document',
            PathOnClient = 'No type document'
        );
        insert cvFile;
                
        ApexPages.currentPage().getParameters().put('id', cvFile.Id);
                
        Test.startTest();
        NEU_Show_File controller = new NEU_Show_File();
        PageReference result = controller.getDocumentBase64();
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetDocumentBase64_ExceptionHandling() {        
        ApexPages.currentPage().getParameters().put('id', '001000000000000'); // ID inválido
                
        Test.startTest();
        NEU_Show_File controller = new NEU_Show_File();
        PageReference result = controller.getDocumentBase64();
        Test.stopTest();                
    }
    
    @isTest(SeeAllData=true)
    static void testGetDocumentBase64_LargeFile() {               
        ContentVersion cvFile= [SELECT Id, ContentSize FROM ContentVersion limit 1];        
        
        ApexPages.currentPage().getParameters().put('id', cvFile.Id);
        ApexPages.currentPage().getParameters().put('contentType', 'application/pdf');
        
        // Ejecutar prueba
        Test.startTest();
        NEU_Show_File controller = new NEU_Show_File();
        PageReference result = controller.getDocumentBase64();
        controller.byPass();
        Test.stopTest();
        
    }
    
}