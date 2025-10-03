@isTest
public class P2G_NEU_IE_Fee_Line_Principal_deleteTest {

    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;   
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name='.';
        importexportquote.Account_for__c = a.Id;
        importexportquote.Team__c = 'P2G';
        importexportquote.Quotation_Status__c = 'Quote being prepared';
        importexportquote.Customer_Reference__c = 'hola soy una prueba';
        importexportquote.Valid_From__c = system.today();
        importexportquote.Valid_Until__c = system.today();
        importexportquote.Comercio_Exterior__c = 'No';
        importexportquote.Freight_Mode__c = 'Road';
        importexportquote.Service_Mode__c = 'NATIONAL';
        importexportquote.Service_Type__c = 'FTL';
        importexportquote.CurrencyIsoCode = 'MXN';
        importexportquote.ETD__c = Date.today();
        importexportquote.ETA__c = Date.today();
        importexportquote.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote.Pricing_Executive__c= userT.Id;
        importexportquote.Operations_Exec__c = userT.Id;
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id);
        insert fee;             
    }
    @isTest
    static void NEU_IE_Fee_Line_Principal_delete(){      
        Customer_Quote__c importexportquote= [SELECT Id FROM Customer_Quote__c LIMIT 1];
        Fee__c fee=[SELECT Id FROM Fee__c LIMIT 1];        
        
        Import_Export_Fee_Line__c quote1 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote1;
        // Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Import_Export_Service_Line__c = quote1.Id);
        // insert quote2;
        delete quote1;     
    }
    
}