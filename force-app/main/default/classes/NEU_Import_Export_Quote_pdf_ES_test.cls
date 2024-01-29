@isTest
public class NEU_Import_Export_Quote_pdf_ES_test {
	@TestSetup
    static void Setup(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Cotizador';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        insert account_test;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso');
        Catalogo_SAT__c producto = TestDataFactory.createCatalogoSat('Papel' , 'TCA127','Productos y Servicios cP');
        Catalogo_SAT__c tipodeRemolque = TestDataFactory.createCatalogoSat('Caja Seca' , 'CTR007','Tipo de Remolque');
        Catalogo_SAT__c embalaje = TestDataFactory.createCatalogoSat('Caja' , 'TCA128','Tipo de Embalaje');
        Catalogo_SAT__c palet = TestDataFactory.createCatalogoSat('Pallet' , 'TCA228','Unidad Peso');
        update catalogo;
        Country__c country = new Country__c(Name='Mxico');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='PruebaUnica', State__c=state.Id,Country__c=country.Id);
        insert location;
        Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        insert container;
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name='.';
        quote.Account_for__c = account_test.Id;
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
        quote.Country_ofLoad__c = location.Country__c;
        quote.State_of_Load__c = location.State__c;
        quote.Site_of_Load__c = location.Id;
        quote.Country_ofDischarge__c = location.Country__c;
        quote.State_of_Discharge__c = location.State__c;
        quote.Site_of_Discharge__c = location.Id;
        quote.ETD__c = Date.today();
        quote.ETA__c = Date.today();
        quote.Community_Status__c = 'CUSTOMER CREATED';
        quote.Pricing_Executive__c= userT.Id;
        quote.Operations_Exec__c = userT.Id;
        insert quote;
        String recordTypeFee = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c serviceRate = new Fee__c();
        serviceRate.RecordTypeId = recordTypeFee;
        serviceRate.Name = 'Flete Nacional'; //
        serviceRate.Route__c = quote.Route__c; 
        serviceRate.CurrencyIsoCode = 'MXN'; 
        serviceRate.Fee_Category__c = 'Road Freights'; 
        serviceRate.Group__c = 'SP-FN-FLETE NACIONAL'; 
        serviceRate.SAP_Service_Type__c = 'a1n4T000001XXYCQA4'; //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        serviceRate.Container_Type__c = container.id;
        serviceRate.TT_Days__c = '1';
        serviceRate.Rate_Type__c = 'Fixed';
        serviceRate.Account_for__c = account_test.Id;
        serviceRate.Active__c=true;
        serviceRate.Fee_Rate__c = 0;
        serviceRate.Buy_Rate__c = 0;
		insert serviceRate;
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = quote.id;
        serviceLine.Name = '003';
        serviceLine.Conversion_Rate_to_Currency_Header__c= integer.valueOf('1');
        serviceLine.Tarifario_ServRate__c = integer.valueOf('1');
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = serviceRate.Id;
        serviceLine.Quote_Sell_Price__c = 50;
        serviceLine.Quote_Buy_Price__c = 10;
        insert serviceLine;
    }
    @isTest
    static void NEU_Import_Export_Quote_pdf_ES_test(){
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c limit 1];
        Test.startTest();
        NEU_Import_Export_Quote_pdf_ES testPdf = new NEU_Import_Export_Quote_pdf_ES(new ApexPages.StandardController(quote));
        Test.stopTest();
    }
}