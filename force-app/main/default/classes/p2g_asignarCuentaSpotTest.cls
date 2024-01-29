@isTest
public class p2g_asignarCuentaSpotTest {
	@TestSetup
    static void Setup(){
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Country__c country = new Country__c(Name='Mxico');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='PruebaUnica', State__c=state.Id,Country__c=country.Id);
        insert location;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Cotizador';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        account_test.TAX_ID__c='RFCdeTest';
        insert account_test;
        Account_Address__c address1 = new  Account_Address__c();
        address1.Name ='Direccion test';
        address1.Account__c=account_test.Id;
        address1.Type__c='Shipping Address';
        address1.Calle_cat__c='AVENIDA ARBOLEDA';
        address1.Address__c='Arbolada 57B, Conj U los Sauces V, 50200 San José Guadalupe, Méx., México';
        address1.Address_Coordinates__Latitude__s =28.7276823;
        address1.Address_Coordinates__Longitude__s=-106.123545;
        insert address1;
        account_test.Direccion_Principal__c = address1.Id;
        update account_test;
        Lead lead = new Lead();
        lead.Mkt_Executive__c = 'Comercial';//hacer spot
        lead.LeadSource='MKT - SPOT'; //hacer uno Spot
        lead.LastName = 'Lead';
        lead.Company ='p2g';
        lead.Medio_de_Contacto__c='Spot';//agregar Spot
        lead.Tipo_de_Servicio_Prospecto__c ='FN';//Fn por ahora
        lead.Description ='Spot';
        lead.Mercancia__c='Viable';
        lead.Status='Open';
        lead.Customs_Broker_Required__c='No';
        lead.Rating='A';
        lead.Industry='Other';
        lead.FirstName = 'de test';
        lead.Phone = '243436';
        lead.Email = 'correo@test.com';
        lead.Status = 'Qualified';
        insert lead;
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
        quote.Final_Client_Pak__c = lead.Id;
        quote.clave_de_lead__c = 'SPOT Cotizador';
        insert quote;
    }
    @isTest
    static void guardarCoordenadasTest(){
        	Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(3));
        	p2g_Cotizador.wrapperCotizador wrapper1 = new p2g_Cotizador.wrapperCotizador();
        	wrapper1.cPFiscal ='69006';
        	wrapper1.coloniaFiscal ='LosPinos';
        	wrapper1.cPOrigen ='69000';
        	wrapper1.coloniaOrigen ='LosPinos';
        	wrapper1.cPDestino ='69000';
        	wrapper1.coloniaDestino ='LosPinos';
        	wrapper1.tarifario = true;
        	Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(4));
        	p2g_asignarCuentaSpot.guardarDatos(wrapper1);
        	Test.stopTest();
        	wrapper1.tarifario = false;
        	p2g_asignarCuentaSpot.guardarDatos(wrapper1);
    }
    @isTest
    static void p2g_asignarCuentaSpotTest(){
        Map<String, Decimal> cordenadas = new Map<String, Decimal>();
        Customer_Quote__c quote = [SELECT Id, Account_for__c,Final_Client_Pak__c FROM Customer_Quote__c limit 1];
        String rfc = 'RFCdeTest';
        String correo = 'correo@test.com';
        Test.startTest();
        	p2g_Cotizador.wrapperCotizador wrapper1 = p2g_asignarCuentaSpot.validacionRfc(rfc,correo, quote.Id);
        	p2g_asignarCuentaSpot.convertLead(quote.Final_Client_Pak__c, quote.Account_for__c);
        	p2g_Cotizador.wrapperCotizador wrapper2 = p2g_asignarCuentaSpot.datosQuote(quote.Id);
        	p2g_asignarCuentaSpot.actualizacionCuenta(wrapper1, cordenadas);
        	Response__c response = new Response__c();
        		response.Account__c = quote.Account_for__c;
        		response.Message__c = 'LeadCreadoNo.: CUSTUMID1';
        		response.Type__c = 'CONFIRM';
        	Insert response;
        Map<String, Decimal> cordenadasOrigen = new Map<String, Decimal>();
        cordenadasOrigen.put('Latitud', 37.7749);
		cordenadasOrigen.put('Longitud', -122.4194);
        
        p2g_asignarCuentaSpot.crearAccount(wrapper1,cordenadasOrigen,cordenadasOrigen);
        p2g_asignarCuentaSpot.accountSincronized(quote.Id);
        Test.stopTest();
    }
    
}