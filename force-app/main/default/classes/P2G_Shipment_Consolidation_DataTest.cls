@isTest
public class P2G_Shipment_Consolidation_DataTest {
	@isTest
    static void NEU_Update_Last_Shipment_IE(){
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        insert a;
        Shipment__c ship = new Shipment__c(Name='SP-FN-TEST0002',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        //insert importexportquote;
        
        
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name='.';
        quote.Account_for__c = a.Id;
        quote.Team__c = 'P2G';
        quote.Quotation_Status__c = 'Quote being prepared';
        quote.Customer_Reference__c = 'hola soy una prueba';
        quote.Valid_From__c = system.today();
        quote.Valid_Until__c = system.today();
        quote.Comercio_Exterior__c = 'No';
        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'NATIONAL';
        quote.Service_Type__c = 'FTL';
        quote.CurrencyIsoCode = 'MXN';
        quote.ETD__c = Date.today();
        quote.ETA__c = Date.today();
        quote.Community_Status__c = 'CUSTOMER CREATED';
        quote.Pricing_Executive__c= userT.Id;
        quote.Operations_Exec__c = userT.Id;
        insert quote;
        
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = ship.Id, Import_Export_Quote__c = quote.Id);
        insert shipconsodata;
    }
}