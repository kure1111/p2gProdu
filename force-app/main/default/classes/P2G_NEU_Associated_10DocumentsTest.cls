@isTest
public class P2G_NEU_Associated_10DocumentsTest {
	@isTest(SeeAllData=true)
    static void testGetTypeDocument() {
        Account sup= new Account();
		sup.Name='Test';
		sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();
        insert sup;

        Account acc= new Account();
		acc.Name='Test';
		acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;

        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;        
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Warehouse__c almacen = new Warehouse__c(Name='test', Account_Owner__c=acc.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert almacen;
        Delivery_Zone__c delivery_zone = new Delivery_Zone__c(Name= 'test', Port_Airport__c=localizacion.Id, Warehouse__c=almacen.Id);
        insert delivery_zone;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = acc.Id);
        insert supplyproject;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Delivery_Zone__c = delivery_zone.Id, Supplier_Quote_Status__c = 'Approved', Route__c=route.Id);
        insert supquote;
        
        PageReference pageRef = Page.NEU_Associated_10Documents_Request;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', supquote.Id);
        ApexPages.currentPage().getParameters().put('docu', '1');
        
        Test.startTest();
        NEU_Associated_10Documents_Request controller = new NEU_Associated_10Documents_Request();
        String docType = controller.gettype_document();
        Test.stopTest();
        
        
    }
    
    @isTest(SeeAllData=true)
    static void testUploadDocumentsWithSpecificFolder() {        
        Account sup= new Account();
		sup.Name='Test';
		sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();
        insert sup;

        Account acc= new Account();
		acc.Name='Test';
		acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;

        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;        
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Warehouse__c almacen = new Warehouse__c(Name='test', Account_Owner__c=acc.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert almacen;
        Delivery_Zone__c delivery_zone = new Delivery_Zone__c(Name= 'test', Port_Airport__c=localizacion.Id, Warehouse__c=almacen.Id);
        insert delivery_zone;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = acc.Id);
        insert supplyproject;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Delivery_Zone__c = delivery_zone.Id, Supplier_Quote_Status__c = 'Approved', Route__c=route.Id);
        insert supquote;
        Folder existingFolder = [SELECT Id, Name FROM Folder WHERE Type = 'Document' LIMIT 1];
        
        PageReference pageRef = Page.NEU_Associated_10Documents_Request;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', supquote.Id);
        ApexPages.currentPage().getParameters().put('docu', '1');
        
        NEU_Associated_10Documents_Request controller = new NEU_Associated_10Documents_Request();
        controller.gettype_document();
        controller.Document_Description = 'Test Description';
        controller.documento_asociado = Blob.valueOf('Test file content');
        controller.documento_asociadoName = 'testfile.txt';
                
        controller.Document_type = existingFolder.Name;
        
        Test.startTest();
        PageReference result = controller.Upload_Documents();
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void testUploadDocumentsWithDefaultFolder() {        
        Folder defaultFolder;
        try {
            defaultFolder = [SELECT Id, Name FROM Folder WHERE Name = 'Associated Documents' AND Type = 'Document' LIMIT 1];
        } catch(Exception e) {            
            defaultFolder = [SELECT Id, Name FROM Folder WHERE Type = 'Document' LIMIT 1];
        }
        
        Account sup= new Account();
		sup.Name='Test';
		sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();
        insert sup;

        Account acc= new Account();
		acc.Name='Test';
		acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;

        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;        
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Warehouse__c almacen = new Warehouse__c(Name='test', Account_Owner__c=acc.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert almacen;
        Delivery_Zone__c delivery_zone = new Delivery_Zone__c(Name= 'test', Port_Airport__c=localizacion.Id, Warehouse__c=almacen.Id);
        insert delivery_zone;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = acc.Id);
        insert supplyproject;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Delivery_Zone__c = delivery_zone.Id, Supplier_Quote_Status__c = 'Approved', Route__c=route.Id);
        insert supquote;
        
        PageReference pageRef = Page.NEU_Associated_10Documents_Request;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', supquote.Id);
        ApexPages.currentPage().getParameters().put('docu', '2');
        
        NEU_Associated_10Documents_Request controller = new NEU_Associated_10Documents_Request();
        controller.gettype_document();
        controller.Document_Description = 'Test Description';
        controller.documento_asociado = Blob.valueOf('Test file content');
        controller.documento_asociadoName = 'testfile.txt';
        
        Test.startTest();
        PageReference result = controller.Upload_Documents();
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void testUploadDocumentsWithError() {
        Account sup= new Account();
		sup.Name='Test';
		sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();
        insert sup;

        Account acc= new Account();
		acc.Name='Test';
		acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;

        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;        
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Warehouse__c almacen = new Warehouse__c(Name='test', Account_Owner__c=acc.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert almacen;
        Delivery_Zone__c delivery_zone = new Delivery_Zone__c(Name= 'test', Port_Airport__c=localizacion.Id, Warehouse__c=almacen.Id);
        insert delivery_zone;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = acc.Id);
        insert supplyproject;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c = supplyproject.Id, Supplier__c = sup.Id, Delivery_Zone__c = delivery_zone.Id, Supplier_Quote_Status__c = 'Approved', Route__c=route.Id);
        insert supquote;

        Folder existingFolder = [SELECT Id, Name FROM Folder WHERE Type = 'Document' LIMIT 1];
        
        PageReference pageRef = Page.NEU_Associated_10Documents_Request;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', supquote.Id);
        ApexPages.currentPage().getParameters().put('docu', '1');
        
        NEU_Associated_10Documents_Request controller = new NEU_Associated_10Documents_Request();
        controller.gettype_document();
        controller.Document_Description = 'Test Description';
        controller.documento_asociado = Blob.valueOf('Test file content');
        controller.documento_asociadoName = 'testfile.txt';
        controller.Document_type = existingFolder.Name;
                
        controller.documento_asociadoName = null;
        
        Test.startTest();
        PageReference result = controller.Upload_Documents();
        Test.stopTest();
        
        
    }
}