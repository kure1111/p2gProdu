@isTest
public class p2g_CotizadorTest {
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
        Account carrier_test = new Account();
        String recordCarrier = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier_test.RecordTypeId = recordCarrier;
        carrier_test.Name = 'Carrier de Test';
        carrier_test.TAX_ID__c = 'FLD120217NW5';
        carrier_test.Credit_Limit__c = 1000000;
        carrier_test.Venta_Sap__c='Credito';
        carrier_test.Segment__c='Nuevo';
        carrier_test.Workplace__c=null;
        carrier_test.Customer_Id__c ='P005153';
        insert carrier_test;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso');
        Catalogo_SAT__c producto = TestDataFactory.createCatalogoSat('Papel' , 'TCA127','Productos y Servicios cP');
        Catalogo_SAT__c tipodeRemolque = TestDataFactory.createCatalogoSat('Caja Seca' , 'CTR007','Tipo de Remolque');
        Catalogo_SAT__c embalaje = TestDataFactory.createCatalogoSat('Caja' , 'TCA128','Tipo de Embalaje');
        Catalogo_SAT__c palet = TestDataFactory.createCatalogoSat('Pallet' , 'TCA228','Unidad Peso');
        update catalogo;
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '9808282';
        cp.Clave_SAT__c = '9808282';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;
        Catalogo_SAT__c colonia = new Catalogo_SAT__c();        
        colonia.Name  = 'Pruebacolonia';
        colonia.Clave_SAT__c = 'Pruebacolonia';
        colonia.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Colonia').getRecordTypeId();        
        insert colonia; 
        Country__c country = new Country__c(Name='Mxico');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='PruebaUnica', State__c=state.Id,Country__c=country.Id);
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
    }
    
    @isTest
    static void testCrearLead() {
        
        p2g_Cotizador.wrapperCotizador cotizador = new p2g_Cotizador.wrapperCotizador();
        cotizador.nameCliente = 'Nombre Cliente de Prueba';
        cotizador.telefonoCliente = '1234567890';
        cotizador.emailCliente = 'cliente@ejemplo.com';
        cotizador.tipoServicio='SP-FN-FLETE NACIONAL';
        cotizador.sapServiceTypeName = 'Servicio de Prueba';
        cotizador.siteLoadName = 'Carga en Sitio de Prueba';
        cotizador.siteDischargeName = 'Descarga en Sitio de Prueba';
        cotizador.containerTypeName = 'Tipo de Contenedor de Prueba';
        cotizador.costo = '100.00';
        cotizador.cuentaId = '001XXXXXXXXXXXXXXX';
        cotizador.interiorOrigen = 'Int 123';
        cotizador.exteriorOrigen = 'Ext 456';
        cotizador.cPOrigenId = '987654';
        cotizador.coloniaOrigen = 'Colonia Origen de Prueba';
        cotizador.coloniaOrigenId = '654321';
        cotizador.calleDestino = 'Calle Destino de Prueba';
        cotizador.interiorDestino = 'Int 789';
        cotizador.exteriorDestino = 'Ext 012';
        cotizador.cPDestino = '543210';
        cotizador.cPDestinoId = '789012';
        cotizador.coloniaDestino = 'Colonia Destino de Prueba';
        cotizador.coloniaDestinoId = '210987';
        cotizador.etd = '2023-09-15';
        cotizador.eta = '2023-09-20';
        cotizador.buyRate = 536.6;
        cotizador.calleFiscal ='calle fiscal';
        cotizador.interiorFiscal ='34';
        cotizador.exteriorFiscal ='342';
        cotizador.cPFiscal ='cp fiscal';
        cotizador.cPFiscalId ='42334';
        cotizador.coloniaFiscal ='colonia fiscal';
        cotizador.coloniaFiscalId ='34234';

        Test.startTest(); 
        p2g_Cotizador.wrapperCotizador cotizador2 = p2g_Cotizador.Cotizador(cotizador,1);
        p2g_Cotizador.wrapperCotizador wrapper = new p2g_Cotizador.wrapperCotizador();
        p2g_Cotizador.wrapperCotizador wrf = p2g_Cotizador.getWrapper();
        
        p2g_Cotizador.wrapperCotizador coti = new p2g_Cotizador.wrapperCotizador();
        cotizador.cPOrigen = '12345';
        cotizador.razonSocial = 'Nombre de Prueba';
        cotizador.telefonoCliente = '1234567890';
        cotizador.emailCliente = 'test@test.com';
        cotizador.rfc = 'RFC12345';
        cotizador.banco = 'Banco de Prueba';
        cotizador.numeroCuenta = '1234567890';
        cotizador.calleOrigen = 'Calle de Prueba';
        Cotizador.tipoServicio ='SP-FN-FLETE NACIONAL';
        Account result = p2g_Cotizador.creaAccount(coti);
        
        List<Catalogo_SAT__c> codigoPostal = p2g_Cotizador.codigoPostal('adada',2,'Colonia');
		list<SAP_Service_Type__c> lista = p2g_Cotizador.getSapServiceType('asas','asasas');
        Map<String, Decimal> coordenadas = new Map<String, Decimal>();
        coordenadas.put('latitude', 37.7749);
        coordenadas.put('longitude', -122.4194);
        Catalogo_SAT__c colonia = [select Id FROM Catalogo_SAT__c where name = 'Pruebacolonia'];
        Account_Address__c direccion = p2g_Cotizador.creAccountAddres(
            'MiDireccionDePrueba',
            result.Id,
            'Name',
            '123 Calle Ejemplo',
            '456',
            'Apto 789',
            colonia.Id,
            'Colonia Ejemplo',
            coordenadas
        );
        p2g_Cotizador.updateQuote(cotizador2.quoteId,2,'','', '','','');
        p2g_Cotizador.updateQuote(cotizador2.quoteId,3,result.Id,'2023-09-15', '2023-09-15',direccion.Id, direccion.Id);
        Test.stopTest();
    }

}