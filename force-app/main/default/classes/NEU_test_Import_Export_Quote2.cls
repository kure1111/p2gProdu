@isTest
private class NEU_test_Import_Export_Quote2 {


    public static testMethod void test_NEU_FreightSourcingQuote_IE() {//ok

        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Account a = list_accounts[0];
        insert a;User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

Customer_Quote__c importexportquote = new Customer_Quote__c();
String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
importexportquote.RecordTypeId = recordTypeId;
importexportquote.Name = '.';
importexportquote.Route__c=route.Id;
importexportquote.Account_for__c = a.Id;
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
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Route__c = route.Id, Active__c= true, Account_for__c = a.Id);
        insert fee;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_FreightSourcingQuote_IE fsq = new NEU_FreightSourcingQuote_IE(new ApexPages.StandardController( importexportquote ));
        fsq.ordenar_tabla_fees();
        system.debug( 'Prueba realizada' );
    }


}