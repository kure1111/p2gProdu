@Istest
public class P2G_creacionFolioWsTest {
    @testSetup
    static void Setup(){
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
        update catalogo;
        Country__c country = new Country__c(Name='Mxico');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='xalapa', State__c=state.Id,Country__c=country.Id);
        insert location;
        Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        insert container;
        Account_Address__c address1 = new  Account_Address__c();
        address1.Name ='Direccion test';
        address1.Account__c=account_test.Id;
        address1.Type__c='Shipping Address';
        address1.Calle_cat__c='AVENIDA ARBOLEDA';
        address1.Address__c='Arbolada 57B, Conj U los Sauces V, 50200 San José Guadalupe, Méx., México';
        address1.Address_Coordinates__Latitude__s =28.7276823;
        address1.Address_Coordinates__Longitude__s=-106.123545;
        insert address1;
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name='.';
        quote.Account_for__c = account_test.Id;
        quote.Team__c = 'P2G';
        quote.Quotation_Status__c = 'Quote being prepared';
        quote.Customer_Reference__c = 'holi';
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
        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FN-23-000783';
        new_shipment.Freight_Mode__c= 'Road';
        new_shipment.Service_Type__c= 'FTL';
        new_shipment.ETA_Point_of_Discharge__c = Date.valueOf('2023-05-2');
        new_shipment.ETD_from_Point_of_Load__c = Date.valueOf('2023-05-12');
        new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(08,0,0,0);
        new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(08,0,0,0);
        new_shipment.Route__c = quote.Route__c;
        new_shipment.Account_for__c= account_test.Id;
        new_shipment.Country_of_Discharge__c = country.Id;
        new_shipment.Country_of_Load__c = country.Id;
        new_shipment.State_of_Discharge__c = state.Id;
        new_shipment.State_of_Load__c = state.Id;
        new_shipment.Site_of_Discharge__c = location.Id;
        new_shipment.Site_of_Load__c = location.Id;
        new_shipment.Container_Type__c = container.Id;
        new_shipment.Service_Mode__c = 'NATIONAL';
        new_shipment.Origin_Address__c = address1.Address__c;
        new_shipment.Account_Origin_Address__c = address1.id;
        new_shipment.Account_Destination_Address__c = address1.Id;
        new_shipment.Destination_Address__c = address1.Address__c;
        new_shipment.Origin_Location__Latitude__s = address1.Address_Coordinates__Latitude__s;
        new_shipment.Origin_Location__Longitude__s = address1.Address_Coordinates__Longitude__s;
        new_shipment.Destination_Location__Latitude__s = address1.Address_Coordinates__Latitude__s;
        new_shipment.Destination_Location__Longitude__s = address1.Address_Coordinates__Longitude__s;
        new_shipment.Kms__c = 23;
        new_shipment.Traslado_Ingreso__c = 'Traslado';
        new_shipment.Shipment_Status_Plann__c = 'Confirmed';
        insert new_shipment;
        P2G_token__c token = new P2G_token__c();
        token.Name = 'tokenRC';
        token.token__c ='tokenInicial';
        insert token;
    }
    @isTest
    static void creacionFolioWs(){
        Shipment__c ship = [SELECT Id FROM Shipment__c Limit :1];  
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(1));
        P2G_creacionFolioWs.callSerCon(ship.Id);
        P2G_creacionFolioWs.callWebService('token test','body test');
        Test.stopTest();
    }
    
}