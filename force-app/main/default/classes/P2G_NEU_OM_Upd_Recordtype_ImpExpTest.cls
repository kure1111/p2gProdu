@isTest
public class P2G_NEU_OM_Upd_Recordtype_ImpExpTest {
    
    @testSetup
    static void testSetup(){
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();        	
        insert acc;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC', IATA_Code__c='IAC');
        insert localizacion;
    }
            
    @isTest
    static void testRecursiveCheck() {
        Test.startTest();
        Account acc= [SELECT Id FROM Account LIMIT 1];
        
        Country__c Country = [SELECT Id FROM Country__c LIMIT 1];
        
        Location__c localizacion = [SELECT Id FROM Location__c LIMIT 1];
        
        /*
        Customer_Quote__c cq = new Customer_Quote__c(Account_for__c = acc.Id,

        Freight_Mode__c='Air',
        Service_Mode__c='Import',
         Service_Type__c='LCL Cargo',
         Move_Type__c='Door to Door',
         Origin_Address__c='tst adrress',
        Country_ofLoad__c= Country.Id,
         Site_of_Load__c =localizacion.Id,
         Country_ofDischarge__c= Country.Id,
        Site_of_Discharge__c= localizacion.Id,
         Destination_Address__c='test address',
         Quotation_Status__c = 'Shipped');        	
        
        insert cq;
        */

        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c cq = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        cq.RecordTypeId = recordTypeId;
        cq.Name='.';
        cq.Account_for__c = acc.Id;        
        cq.Team__c = 'P2G';
        cq.Quotation_Status__c = 'Quote being prepared';
        cq.Customer_Reference__c = 'hola soy una prueba';
        cq.Valid_From__c = system.today();
        cq.Valid_Until__c = system.today();
        cq.Comercio_Exterior__c = 'No';
        cq.Freight_Mode__c = 'Road';
        cq.Service_Mode__c = 'NATIONAL';
        cq.Service_Type__c = 'FTL';
        cq.CurrencyIsoCode = 'MXN';
        cq.ETD__c = Date.today();
        cq.ETA__c = Date.today();
        cq.Community_Status__c = 'CUSTOMER CREATED';
        cq.Pricing_Executive__c= userT.Id;
        cq.Operations_Exec__c = userT.Id;
        cq.Country_ofLoad__c= Country.Id;
        cq.Site_of_Load__c =localizacion.Id;
        cq.Country_ofDischarge__c= Country.Id;
        cq.Site_of_Discharge__c= localizacion.Id;
        insert cq;        
        
        
        RecursiveCheck.triggerMonitor.add('NEU_OM_Update_Recordtype_ImportExport');        
        Test.stopTest();        
    }
}