@isTest
public class NEU_Commercial_Info_IETest {
    @isTest
    static void testConstructor() {
            NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        insert list_accounts;
        Account account =  list_accounts[0];
        Account sup = list_accounts[1];

    User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

    Customer_Quote__c importexportquote = new Customer_Quote__c();
    String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
    importexportquote.RecordTypeId = recordTypeId;
    importexportquote.Name = '.';
    importexportquote.Account_for__c = account.Id;
    importexportquote.Team__c = 'P2G';
    importexportquote.Quotation_Status__c = 'Quote being prepared';
    importexportquote.Customer_Reference__c = 'hola soy una prueba';
    importexportquote.Valid_From__c = System.today();
    importexportquote.Valid_Until__c = System.today();
    importexportquote.Comercio_Exterior__c = 'No';
    importexportquote.Freight_Mode__c = 'Road';
    importexportquote.Service_Mode__c = 'NATIONAL';
    importexportquote.Service_Type__c = 'FTL';
    importexportquote.CurrencyIsoCode = 'MXN';
    importexportquote.ETD__c = Date.today();
    importexportquote.ETA__c = Date.today();
    importexportquote.Community_Status__c = 'CUSTOMER CREATED';
    importexportquote.Pricing_Executive__c = userT.Id;
    importexportquote.Operations_Exec__c = userT.Id;
    insert importexportquote;

        // Simular un controlador estándar
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(importexportquote);
        NEU_Commercial_Info_IE controller = new NEU_Commercial_Info_IE(sc);
        controller.byPass();
        Test.stopTest();
    }

}