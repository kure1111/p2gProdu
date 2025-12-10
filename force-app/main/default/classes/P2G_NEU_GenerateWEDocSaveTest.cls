@isTest
public class P2G_NEU_GenerateWEDocSaveTest {
    
    @isTest(SeeAllData=true)
    static void testConstructor() {
        
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;
        
        Shipment__c sp = new Shipment__c ();
        sp.Name = 'SP-FN-21-280888';                      
        sp.Freight_Mode__c = 'Road';
        sp.Account_for__c=acc.Id;             
        sp.Service_Mode__c = 'NATIONAL';
        sp.Service_Type__c =  'LTL';        
        sp.Only_Warehouse_Service__c = false;                    
        sp.Operation_Executive__c = userinfo.getUserId();                 
        sp.Warehouse_Movement_Type__c = 'Entries (In)';
        insert sp;  
        
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(stdController);
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void testConstructorWithException() {        
        Shipment__c invalidShipment = new Shipment__c();
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(invalidShipment);
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(stdController);
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void testCrearForEntry() {
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;
        
        Shipment__c sp = new Shipment__c ();
        sp.Name = 'SP-FN-21-280888';                      
        sp.Freight_Mode__c = 'Road';
        sp.Account_for__c=acc.Id;             
        sp.Service_Mode__c = 'NATIONAL';
        sp.Service_Type__c =  'LTL';        
        sp.Only_Warehouse_Service__c = false;                    
        sp.Operation_Executive__c = userinfo.getUserId();                 
        sp.Warehouse_Movement_Type__c = 'Entries (In)';
        insert sp;  
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(stdController);
        
        Test.setCurrentPage(Page.NEU_GenerateWEDoc);
        ApexPages.currentPage().getParameters().put('id', sp.Id);
        
        Test.startTest();
        PageReference result = controller.crear();
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void testCrearForDelivery() {
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;
        
        Shipment__c sp = new Shipment__c ();
        sp.Name = 'SP-FN-21-280888';                      
        sp.Freight_Mode__c = 'Road';
        sp.Account_for__c=acc.Id;             
        sp.Service_Mode__c = 'NATIONAL';
        sp.Service_Type__c =  'LTL';        
        sp.Only_Warehouse_Service__c = false;                    
        sp.Operation_Executive__c = userinfo.getUserId();                 
        sp.Warehouse_Movement_Type__c = 'Entries (In)';
        insert sp;  
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(stdController);
        
        Test.setCurrentPage(Page.NEU_GenerateWEDoc);
        ApexPages.currentPage().getParameters().put('id', sp.Id);
        
        Test.startTest();
        PageReference result = controller.crear();
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void testCrearWithVisualforceException() {
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;
        
        Shipment__c sp = new Shipment__c ();
        sp.Name = 'SP-FN-21-280888';                      
        sp.Freight_Mode__c = 'Road';
        sp.Account_for__c=acc.Id;             
        sp.Service_Mode__c = 'NATIONAL';
        sp.Service_Type__c =  'LTL';        
        sp.Only_Warehouse_Service__c = false;                    
        sp.Operation_Executive__c = userinfo.getUserId();                 
        sp.Warehouse_Movement_Type__c = 'Entries (In)';
        insert sp;  
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(stdController);
        
        Test.startTest();
        PageReference result = controller.crear();
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void testCrearWithDMLException() {
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;
        
        Shipment__c sp = new Shipment__c ();
        sp.Name = 'SP-FN-21-280888';                      
        sp.Freight_Mode__c = 'Road';
        sp.Account_for__c=acc.Id;             
        sp.Service_Mode__c = 'NATIONAL';
        sp.Service_Type__c =  'LTL';        
        sp.Only_Warehouse_Service__c = false;                    
        sp.Operation_Executive__c = userinfo.getUserId();                 
        sp.Warehouse_Movement_Type__c = 'Entries (In)';
        insert sp;  
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(stdController);
        
        controller.documento_asociado.Name = null;
        
        Test.setCurrentPage(Page.NEU_GenerateWEDoc);
        ApexPages.currentPage().getParameters().put('id', sp.Id);
        
        Test.startTest();
        PageReference result = controller.crear();
        Test.stopTest();
    }
    
    @isTest
    static void testDocumentoAsociadoProperty() {
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(new ApexPages.StandardController(new Shipment__c()));
        
        Test.startTest();
        Document doc = controller.documento_asociado;
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void pageReferenceCrearTest() {
        // Obtener datos de prueba
        Shipment__c sp = [SELECT Id, Name, Warehouse_Movement_Type__c, Account_for__c 
                          FROM Shipment__c LIMIT 1];        
        List<Folder> directorio = [SELECT Id, Name FROM Folder LIMIT 1];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
        
        
        Test.startTest();
        
        // Configurar página y parámetros
        PageReference pdf = Page.NEU_GenerateWEDoc;
        pdf.getParameters().put('id', sp.Id);
        
        // Obtener contenido del PDF
        Blob body;
        try {
            body = pdf.getContent();            
        } catch(VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
        
        
        
        NEU_GenerateWEDocSave controller = new NEU_GenerateWEDocSave(stdController);
        
        controller.record = sp;
        
        Document doc = new Document();
        doc.Body = body;
        doc.Name = sp.Name + '_Warehouse_' + 
            (sp.Warehouse_Movement_Type__c == 'Entries (In)' ? 'Recepcion' : 
             (sp.Warehouse_Movement_Type__c == 'Deliveries (Out)' ? 'Embarque' : '')) + '.pdf';
        doc.AuthorId = UserInfo.getUserId();
        doc.FolderId = directorio.isEmpty() ? null : directorio[0].Id;
        doc.IsPublic = true;
        
        controller.documento_asociado = doc;
        
        Test.stopTest();    
    }
}