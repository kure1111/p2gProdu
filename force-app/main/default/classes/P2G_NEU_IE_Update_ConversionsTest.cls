@isTest
public class P2G_NEU_IE_Update_ConversionsTest {
    
    @testSetup
    static void setup(){
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
        
        Shipment__c ship = new Shipment__c();
        ship.Name='SP-FN-Test000';
        ship.Account_for__c = account_test.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';        
        ship.Only_Warehouse_Service__c = true;
        insert ship;
    }
    
    @isTest
    static void NEU_IE_Update_Conversions(){
        Account account_test=[SELECT Id FROM Account LIMIT 1];
        
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name='.';
        importexportquote.Account_for__c = account_test.Id;
        importexportquote.Team__c = 'P2G';
        importexportquote.Quotation_Status__c = 'Quote being prepared';
        importexportquote.Customer_Reference__c = 'hola soy una prueba';
        importexportquote.Valid_From__c = system.today();
        importexportquote.Valid_Until__c = system.today();
        importexportquote.Comercio_Exterior__c = 'No';
        importexportquote.Freight_Mode__c = 'Road';
        importexportquote.Service_Mode__c = 'NATIONAL';
        importexportquote.Service_Type__c = 'FTL';
        importexportquote.CurrencyIsoCode = 'USD';
        importexportquote.ETD__c = Date.today();
        importexportquote.ETA__c = Date.today();
        importexportquote.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote.Pricing_Executive__c= userT.Id;
        importexportquote.Operations_Exec__c = userT.Id;
        insert importexportquote;                        
        NEU_IE_Update_ConversionsInsertInvoice(importexportquote, account_test);
        
    }
    
    static void NEU_IE_Update_ConversionsInsertInvoice(Customer_Quote__c quote, Account account_test){
        //NEU_StaticVariableHelper.setBoolean1(true);
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];        
        Invoice__c new_invoice = new Invoice__c();
        new_invoice.Name = 'test';
        new_invoice.Import_Export_Quote_Order__c = quote.Id;
        new_invoice.Shipment__c = ship.Id;
        new_invoice.Account__c = account_test.Id;
        new_invoice.Date_of_Invoice__c = system.today();
        NEU_StaticVariableHelper.setBoolean1(true);
        NEU_CurrencyUtils.setCurrencyIsoCode(new_invoice, 'MXN');
        
        insert new_invoice;
        
        NEU_IE_Update_ConversionsUpdateQuote(quote);
        
    }
    static void NEU_IE_Update_ConversionsUpdateQuote(Customer_Quote__c quote){
        quote.Customer_Reference__c = 'hola soy una prueba2';        
        update quote;
    }
}