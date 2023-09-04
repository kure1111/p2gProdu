@isTest
public class P2G_CreacionCargoLinesTest {
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
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.Import_Export_Quote__c=quote.Id;
        cargoLine.Name='cargo12';
        //cargoLine.Item_Name__c=cargo.idItem;
        cargoLine.Container_Type__c=container.Id;
        cargoLine.Clave_de_Servicio__c=producto.Id;
        cargoLine.Extension_Item_Name__c='Papel';
        cargoLine.CurrencyIsoCode='MXN';
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=1;
        cargoLine.Total_Shipping_Weight_Kgs__c=1;
        cargoLine.Peso_Neto__c=1;
        cargoLine.Total_Shipping_Volume_m3__c=1;
        insert cargoLine;
        
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = quote.Id;
        serviceLine.Name = '003';
        serviceLine.Conversion_Rate_to_Currency_Header__c= 1;
        serviceLine.Tarifario_ServRate__c = 1;
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Quote_Sell_Price__c = 1;
        insert serviceLine;
        SAP_Service_Type__c sst = new SAP_Service_Type__c(Name='FLETE NACIONAL (IC) (FN)',Group__c='SP-FN-FLETE NACIONAL',Activo__c=true);
        insert sst;
        
    }
    
    @isTest
    static void getTest(){
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name='xalapa'];
        Account acc = [SELECT Id, Name FROM Account WHERE Segment__c='Nuevo' Limit 1];
        List <Customer_Quote__c> listQuote = [SELECT Id, Name,Account_for__c FROM Customer_Quote__c WHERE Customer_Reference__c='holi' LIMIT 1];
        Test.startTest(); 
        list<Catalogo_SAT__c> listCatalogoSat = P2G_CreacionCargoLines.getClaveSAT('Papel','1');
        list<Catalogo_SAT__c> listCatalogoSat2 = P2G_CreacionCargoLines.getClaveSAT('Aluminio','2');
        list<Catalogo_SAT__c> listCatalogoSat3 = P2G_CreacionCargoLines.getClaveSAT('Caja','3');
        list<Container_Type__c> Container = P2G_CreacionCargoLines.getContainerType('Super');
        list<Account> listAcc = P2G_CreacionCargoLines.getAccount('Bimbo');
        list<Location__c> listLocations = P2G_CreacionCargoLines.getSideCountry('xala');
        list<Customer_Quote__c> listCustomer = P2G_CreacionCargoLines.getCustomerQuote(listQuote[0].Name,acc.Id);
        P2G_CreacionCargoLines.updatePrice(listQuote,'12','FLETE NACIONAL (IC) (FN)');
        P2G_CreacionCargoLines.updatePriceList(listQuote,'12','FLETE NACIONAL (IC) (FN)');
        Import_Export_Fee_Line__c cargoLine = P2G_CreacionCargoLines.getServiceLine(listQuote[0].Id);
        list<SAP_Service_Type__c> lsst = P2G_CreacionCargoLines.getSapServiceType('FLETE NACIONAL (IC) (FN)');
        list<Quote_Item_Line__c> aux = P2G_CreacionCargoLines.getCargoLine(listQuote);
        System.debug('1.Número de consultas utilizadas en este código ápice hasta el momento: ' + Limits.getQueries());
        Test.stopTest();
    }
}