@isTest
public class P2G_CreacionFoliosTest {
    @testSetup
    static void SetUp(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Bimbo';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        insert account_test;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso');
        Catalogo_SAT__c producto = TestDataFactory.createCatalogoSat('Papel' , 'TCA127','Productos y Servicios cP');
        Catalogo_SAT__c materialPeligro = TestDataFactory.createCatalogoSat('Aluminio' , 'TCA126','Material Peligroso');
        Catalogo_SAT__c embalaje = TestDataFactory.createCatalogoSat('Caja' , 'TCA128','Tipo de Embalaje');
        Catalogo_SAT__c palet = TestDataFactory.createCatalogoSat('Pallet' , 'TCA228','Unidad Peso');
        catalogo.Material_PeligrosoCP__c=true;
        update catalogo;
        Country__c country = new Country__c(Name='Mxico');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='xalapa', State__c=state.Id,Country__c=country.Id);
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
        quote.Customer_Reference__c = 'holi';
        //quote.Customer_Reference_Form__c = fleteNacional.idReferenceForm;
        quote.Valid_From__c = system.today();
        quote.Valid_Until__c = system.today();
        //inicio FN-FLET_NACIONAL_IC
        quote.Comercio_Exterior__c = 'No';
        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'NATIONAL';
        quote.Service_Type__c = 'FTL';
        quote.CurrencyIsoCode = 'MXN';
        //termino FN-FLET_NACIONAL_IC
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
    }
    
    @isTest
    static void callsendToSaptest(){
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name='xalapa'];
        Account acc = [SELECT Id, Name FROM Account WHERE Segment__c='Nuevo' Limit 1];
        Customer_Quote__c quote = [SELECT Id, Name,Account_for__c FROM Customer_Quote__c WHERE Customer_Reference__c='holi' LIMIT 1];
        Container_Type__c container= [SELECT Id FROM Container_Type__c WHERE Name = 'Super tracto Camion'];
        Catalogo_SAT__c claveSap= [SELECT Id FROM Catalogo_SAT__c WHERE Name = 'Papel'];
        Test.startTest(); 
        P2G_CreacionFoliosWrapper.folio fleteNacional = P2G_CreacionFolios.getwrapper();
        fleteNacional.numFoliosCrear = 1;
        fleteNacional.comercioExterior = 'No';
        fleteNacional.freighMode = 'Road';
        fleteNacional.serviceMode = 'NATIONAL';
        fleteNacional.servicetype = 'FTL';
        fleteNacional.rurrencyIsoCode = 'MXN';
        fleteNacional.etd = '2023-03-10';
        fleteNacional.eta = '2023-03-10';
        fleteNacional.team = 'P2G';
        fleteNacional.quotationStatus = 'Quote being prepared';
        fleteNacional.CommunityStatus = 'CUSTOMER CREATED';
        fleteNacional.idSideLoad = location.Id;
        fleteNacional.idSideDischarged = location.Id;
        fleteNacional.idAccount = acc.Id;
        fleteNacional.Awaitingloadtime = '08:00:00.000';
        fleteNacional.Awaitingunloadtime = '18:00:00.000';
        P2G_CreacionFoliosWrapper.cargoLine cargo = P2G_CreacionFolios.getCargoline();
        cargo.idQuote='';
        cargo.idConteinerType=container.Id;
        cargo.idClaveSat=claveSap.Id;
        cargo.idItemSuplienerOwner='0010R000019aZF8QAM';
        cargo.extencionItemName='papel petalooo';
        cargo.description='sd';
        cargo.currencyIsoCode='MXN';
        cargo.units='1';
        cargo.pesoBruto='1';
        cargo.pesoNeto='1';
        cargo.itemPrice='1';
        cargo.totalShipping='1';
        List<Customer_Quote__c> listQuote = P2G_CreacionFolios.creaFolios(fleteNacional,cargo);
        list<Customer_Quote__c> Listfolios = P2G_CreacionFolios.getIdFolio(listQuote,'MXN',container.Id,acc.Id,'a1n4T000001XXYCQA4');//uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        //List<Quote_Item_Line__c> ListCargo = P2G_CreacionFolios.creaCargoLine(listQuote,cargo);
        System.debug('1.Número de consultas utilizadas en este código ápice hasta el momento: ' + Limits.getQueries());
        Test.stopTest();
    }
}