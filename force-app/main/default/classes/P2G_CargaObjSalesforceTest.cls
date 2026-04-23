@isTest
public class P2G_CargaObjSalesforceTest {

    @TestSetup
    public static void setupData() {
        User manager = createManager();
        User user = createUser(manager.Id);
        System.runAS(user) {
        	SAP_Service_Type__c servicioSAP = createservicioSAP();
          	Account acc = createAccount();
        	Account carrier = createCarrier();    
            Operadores__c operador = createOperador(carrier.Id);
            Opportunity opp = createOpportunity(acc.Id);
            Country__c country = createCountry();
            State__c state = createState(country.Id);
            Location__c location = createLocation(state.Id, country.Id);
            Container_Type__c container = createContainer();
            Account_Address__c address = createAddress(acc.Id);
            
        	}
        }
    
    static User createManager() {
        User manager = new User(
        FirstName = 'User',
        LastName = 'managerTest',
        Email = 'userManagerTest@test.com',
        Username = 'userManagerTest@test.com.userTest',
        Alias = 'usManT',
        TimeZoneSidKey = 'America/Mexico_City',
        LocaleSidKey = 'es_MX',
        EmailEncodingKey = 'UTF-8',
        ProfileId = [Select Id from Profile where Name = 'System Administrator' LIMIT 1].Id,
        LanguageLocaleKey = 'es_MX'
        );
    insert manager;
    return manager;
    }
    
    static User createUser(id managerId) {
        User user = new User(
            FirstName = 'User',
            LastName = 'userTest',
            Email = 'userTest@test.com',
            Username = 'userTest@test.com.userTest',
            Alias = 'usrTest',
            TimeZoneSidKey = 'America/Mexico_City',
            LocaleSidKey = 'es_MX',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            LanguageLocaleKey = 'es_MX',
            ManagerId = managerId,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'Asesor Comercial' LIMIT 1].Id
        );
        insert user;
        return user;
    }
    
    static SAP_Service_Type__c createservicioSAP(){
        SAP_Service_Type__c servicioSAP = new SAP_Service_Type__c (
        Name = 'FN - Flete Nacional',
        Group__c = 'SP-FN-FLETE NACIONAL',
        SST_Sociedad__c = 'PGL'
        );
        insert servicioSAP;
        return servicioSAP;
    }
    
    static Account createAccount() {
        Account acc = new Account(
        	Name = 'Cliente de Prueba',
            //Tipo_de_Servicio_TNA__c = servicioSAP.Id,
            Inerep_cta__c = true,
            Acta_Constitutiva_Poder_Rep_Legal__c = true,
            Evidencia_de_Visita_del_Vendedor__c = true,
            Phone = '1231234123',
            TAX_ID__c = 'CMTY12345678',
            Workplace__c = 'MTY',
            WCA_ID__c = '1234',
            Requiere_Evidencia__c = 'No',
            NEU_Email__c = 'emailprueba@test.com',
            Tipo_de_Servicio_Prospecto__c = 'FN - Flete Nacional',
            Requiere_Acuse_Sap__c = 'Si',
            Tipo_de_Acuse_Sap__c = 'Fisico',
            Grupo_SAP__c = 'Fletes P',
            Requiere_Orden_de_Compra__c = true,
            Credit_Terms__c = '30 Días',
            Monto_Credito_Solicitado__c = 1000.00,
            Credit_Limit__c = 100000.00,
            Tippag_cta__c = 'Credito',
            Forpag_cta__c = '99 - OTROS',
            Uso_CFDI__c = 'Por Definir',
            Bank_Name_Supplier_Form2__c = 'BancoTest',
            Bank_Account_Number__c = '123456789012345678',
            Uso_Portal__c = true,
            Periodo_de_Facturacion__c = 'Todo el mes',
            Fecha_Recepcion_Factura__c = Date.newInstance(2024, 2, 7),
            Payment_Method__c = 'PPD- PAGO EN PARCIALIDADES', 
            Venta_Sap__c = 'Credito',
            type = 'Customer',
            CurrencyIsoCode = 'MXN',
            RegFiscal_SAP__c = '601 - General de Ley Personas Morales',
            BillingCountry = 'MX',
            BillingState = 'Jalisco',
            BillingCity = 'Tlaquepaque',
            BillingStreet = 'SAN FRANCISCO 2700 Col. PARQUE',
            BillingPostalCode = '45615',
            ShippingStreet = 'Shipping Street Prueba',
            ShippingCity = 'Shipping City Prueba',
            ShippingPostalCode = '12341',
            ShippingState = 'Shipping State Prueba',
            ShippingCountry = 'Shipping Country PRueba',
            Nombre_Contacto_Comercial__c = 'Contacto de Prueba',
            Plaz_cta__c = 'Guadalajara',
            Requerimientos_Especiales__c = 'Sin servicio especial',
            Giro_Comercial__c = 'OTROS',
            Seguimiento_de_Pedido__c = 'Sólo monitoreo en carga y descarga',
            Cliente_internacional__c = false,
            Address_in_Sap__c = 'CALLE 16 DE SEPTIEMBRE #EXT.10',
            TipSocNeg_SAP__c = 'Privado',
            EjecCob_SAP__c = 'Test',
            //Obsycom_cta__c = 'a1',
            Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional',
            CPNumero_Registro_de_ID__c = '990019',
            Website = 'www.salesforce.com',
            //Usuario__c = 'testusuario123',
            Portal_de_Proveedores__c = 'www.salesforce.com',
            Contrasena__c = 'test123test'            
        );
		insert acc;
        return acc;
    }
    
        // Crear Carrier
        static Account createCarrier() {
            String recordCarrier = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        	Account carrierAcc = new Account(
                RecordTypeId = recordCarrier,
                Name = 'Carrier de Test',
                TAX_ID__c = 'NEW022026CCC',
                Credit_Limit__c = 1000000,
                Venta_Sap__c='Credito',
                Segment__c='Nuevo',
                Workplace__c=null,
                Customer_Id__c ='P005153'
            );
        insert carrierAcc;
    	return carrierAcc;
        }
    
        static Operadores__c createOperador(Id carrierId) {
        Operadores__c operador = new Operadores__c(
            Name = 'AGUSTIN AGUSTO AGUSTINO',
            RFC_Operador__c = 'AGAG910119858',
            Cel_ope__c = '1234567898',
            Medprev_ope__c = '906030',
            Numlicvig_ope__c = 'e DF001107364',
            Telfij_ope__c = '56 2655 6878',
            Account__c = carrierId,
            Id_Recurso_Confiable__c = '1164166',
            Validado__c = True,
            Proovedor_validado__c = True,
            Operador_Validado__c = True
            );
        insert operador;
        return operador;
        }
                
        // crear Rol_Margen__c
 /*     static Rol_Margen__c createMargenRol() {
            Rol_Margen__c margenRol = new Rol_Margen__c(
            margenRol.FN_Margen_Operativo__c = 2222;
            );
            insert margenRol;
            System.debug('Margen Operativo' + margenRol);
       }
               
        // Crear Catalogo SAT
        static Catalogo_SAT__c catalogoSAT (){
        catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso');
        producto = TestDataFactory.createCatalogoSat('Papel' , 'TCA127','Productos y Servicios cP');
        materialPeligro = TestDataFactory.createCatalogoSat('Aluminio' , 'TCA126','Material Peligroso');
        embalaje = TestDataFactory.createCatalogoSat('Caja' , 'TCA128','Tipo de Embalaje');
        pallet = TestDataFactory.createCatalogoSat('Pallet' , 'TCA228','Unidad Peso');	
        pais = new Catalogo_SAT__c(
            Name = 'Mexico',
            Clave_Pais__c = 'MEX',
            Material_PeligrosoCP__c = false,
            CurrencyIsoCode = 'MXN'
        );
        insert catalogo; // verificar como crear catalogo
        
        System.debug('catalogo sat: ' + catalogo);
        }
*/
        // Crear Country
    static Country__c createCountry() {
        Country__c country = new Country__c(
            Name='Mexico',
            ISO_Code__c = 'MEX',
            Region__c = 'North America',
            DHL_ExportZone__c = 'Zona 8',
            ISO_Code_2c__c = 'MX',
            CurrencyIsoCode = 'MXN'
        );
        insert country;
        return country;
        }
        // Crear State
    static State__c createState(Id countryId) {
        State__c state = new State__c(
            Name='Sonora',
            Country__c = countryId,
            Iso_Code__c = 'SON',
            ISO_Code_2c__c = 'SO',
            Active__c = true
        );
        insert state;
        return state;
        }
        
        // Crear Location
    static Location__c createLocation(Id stateId, Id countryId) {
        Location__c location = new Location__c(
            Name = 'Xalapa',
            Subdivision__c = 'Villagran',
            State__c = stateId,
            Country__c = countryId,
            CurrencyIsoCode = 'MXN'
        );
        insert location;
        return location;
        }
        
        // Crear Container type
    static Container_Type__c createContainer() {
    	Container_Type__c container = new Container_Type__c(
            Name = 'Super Tracto Camion',
            Type__c = 'Road',
            Cargo_Weight_Kg__c = 22222.00,
            Height_cm__c = 250.00,
            Length_cm__c = 150.00,
            Width_cm__c = 250.00,
            Teus__c = 123,
            //Configuracion_VehicularCat__c = 'Id',
            //Tipo_Remolquecat__c = 'Id',
            Cargo_Volume_m3__c = 108.0000
        );
        insert container;
        return container;
        }

   static Account_Address__c createAddress(Id accountId) {
        Account_Address__c address = new  Account_Address__c(
            Name ='Direccion test',
            Account__c = accountId,
            Type__c='Shipping Address',
            Calle_cat__c='AVENIDA ARBOLEDA',
            Address__c='Arbolada 57B, Conj U los Sauces V, 50200 San José Guadalupe, Méx., México',
            Address_Coordinates__Latitude__s =28.7276823,
            Address_Coordinates__Longitude__s=-106.123545
            );
        insert address;
        return address;
        }
    
        //crear oportunidad
    static Opportunity createOpportunity(Id accountId) {
        String typeOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standar Opportunity').getRecordTypeId();
    	Opportunity opp = new Opportunity(
            RecordTypeId = typeOpp,
            Name = 'Oportunidad test',
            AccountId = accountId,
            Service_Type__c = 'FN',
            Group__c = 'SP-FN-FLETE NACIONAL',
            StageName = 'Potencial',
            CloseDate = Date.Today().addDays(30)
        );
        insert opp;
        System.debug('oportunidad creada:' + opp);
        return opp;
        }
        /*
        // Crear IEQO
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        Customer_Quote__c quote = new Customer_Quote__c(
        	RecordTypeId = recordTypeId,
            Name = 'insertQuoteTest',
            Account_for__c = acc.Id,
            Team__c = 'P2G',
            Quotation_Status__c = 'Quote being prepared',
            Customer_Reference__c = 'Referencia',
            Comercio_exterior__c = 'No',
            Valid_From__c = Date.today(),
            Valid_Until__c = Date.today(),
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'Nacional',
            Service_Type__c = 'FTL',
            CurrencyIsoCode = 'MXN',
            Country_ofLoad__c = country.Id,
            State_of_Load__c = state.Id,
            Site_of_Load__c = location.Id,
            Country_ofDischarge__c = country.Id,
            State_of_Discharge__c = state.Id,
            Site_of_Discharge__c = location.Id,
            ETD__c = Date.Today(),
            ETA__c = Date.Today(),
            Pricing_Executive__c = user.Id,
            Operations_Exec__c = user.Id,
            User_Create_Import_ExportQuotesSearch__c = user.Id,
            Region_Country__c = 'North America',
            Suggested_ETD__c = Date.Today()
            //FolioResume__c = 'FN'
        );
        insert quote;
        System.debug('testQuote1: ' +  quote);

      
        // NEU_StaticVariableHelper.setBoolean1(true);
        // Customer_Quote__c quote= [SELECT Id, Route__c, Account_for__c FROM Customer_Quote__c WHERE Pricing_Executive__c!=null LIMIT 1];
        // Account accQuery= [SELECT Id FROM Account WHERE RecordType.Name='Customer' LIMIT 1];
        String recordTypefee = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c fee = new Fee__c();
        fee.RecordTypeId = recordTypefee;
        fee.Name = 'Flete Nacional';
        fee.Route__c = quote.Route__c;
        fee.CurrencyIsoCode = 'MXN';
        fee.Fee_Category__c = 'Road Freights';
        fee.Group__c = 'SP-FN-FLETE NACIONAL';
        fee.Account_for__c=quote.Account_for__c;
        
        insert fee;
        System.debug(fee);
        //Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        //insert container;
        
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.Import_Export_Quote__c=quote.Id;
        cargoLine.Name='cargo12';
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
        System.debug(cargoLine);
        
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c();
        quote_fee.Import_Export_Quote__c = quote.id;
        quote_fee.Name = 'lineas items';
        quote_fee.Service_Rate_Name__c= fee.Id;
        quote_fee.Concept_1_Sell_Price__c =10;
        quote_fee.Concept_2_Sell_Price__c = 10;
        quote_fee.Concept_3_Sell_Price__c =10;
        quote_fee.Concept_4_Sell_Price__c = 10;
        quote_fee.Concept_5_Sell_Price__c =10;
        insert quote_fee;
        System.debug(quote_fee);
*/
        	// Wrapper
        public class Data { 
            public User manager;
            public User user;
            public Account acc;
            public Account carrier;
            public Operadores__c operador;
            public SAP_Service_Type__c servicioSAP;
            public Country__c country;
            public State__c state;
            public Location__c location;
            public Container_Type__c container;
            public Account_Address__c address;
            public Opportunity opp;
        }
  			// Metodo para recuperar data
            public static Data getData() {
                Data data = new Data();
                data.manager = [SELECT Id FROM User WHERE username = 'userManagerTest@test.com.userTest' LIMIT 1];
                System.debug('imprime manager' + data.manager); 
                data.user = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
                System.debug('imprime user' + data.user); 
                data.acc = [SELECT Id FROM Account WHERE Name = 'Cliente de Prueba' LIMIT 1];
                System.debug('imprime Account' + data.acc); 
                data.carrier = [SELECT Id FROM Account WHERE Name = 'Carrier de Test' LIMIT 1];
                System.debug('imprime carrier' + data.carrier); 
                data.operador = [SELECT Id FROM Operadores__c WHERE Name = 'AGUSTIN AGUSTO AGUSTINO' LIMIT 1];
                System.debug('imprime operador' + data.operador); 
                data.servicioSAP = [SELECT Id FROM SAP_Service_Type__c WHERE Name = 'FN - Flete Nacional' LIMIT 1];
                System.debug('imprime servicioSAP' + data.servicioSAP); 
                data.country = [SELECT Id FROM Country__c WHERE Name = 'Mexico' LIMIT 1];
                System.debug('imprime country' + data.country); 
                data.state = [SELECT Id FROM State__c WHERE Name = 'Sonora' LIMIT 1];
                System.debug('imprime state' + data.state); 
                data.location = [SELECT Id FROM Location__c WHERE Name = 'Xalapa' LIMIT 1];
                System.debug('imprime location' + data.location); 
                data.container = [SELECT Id FROM Container_Type__c WHERE Name = 'Super Tracto Camion' LIMIT 1];
                System.debug('imprime container' + data.container); 
                data.address = [SELECT Id FROM Account_Address__c WHERE Name = 'Direccion test' LIMIT 1];
                System.debug('imprime address' + data.address); 
                data.opp = [SELECT Id FROM Opportunity WHERE Name = 'Oportunidad test' LIMIT 1];
                System.debug ('oportunidad creada de getdata()' + data.opp);
                return data;                
            }
    @isTest
    // Crear IEQO
        
    static void testCreateIEQO(){
        Data data = getData();
          
        //User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        //Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        
        // Crear IEQO
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        Customer_Quote__c quote = new Customer_Quote__c(
        	RecordTypeId = recordTypeId,
            Name = 'insertQuoteTest2',
            Account_for__c = data.acc.Id,
            Team__c = 'P2G',
            Quotation_Status__c = 'Quote being prepared',
            Customer_Reference__c = 'Referencia',
            Comercio_exterior__c = 'No',
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'Nacional',
            Service_Type__c = 'FTL',
            CurrencyIsoCode = 'MXN',
            Container_Type__c = data.container.Id,
            Country_ofLoad__c = data.country.Id,
            State_of_Load__c = data.state.Id,
            Site_of_Load__c = data.location.Id,
            Country_ofDischarge__c = data.country.Id,
            State_of_Discharge__c =  data.state.Id,
            Site_of_Discharge__c = data.location.Id,
            ETD__c = Date.Today(),
            ETA__c = Date.Today(),
            Pricing_Executive__c = data.user.Id,
            Operations_Exec__c = data.user.Id
            
            //User_Create_Import_ExportQuotesSearch__c = queryUser.Id
        );
        insert quote;

      
        // NEU_StaticVariableHelper.setBoolean1(true);
        // Customer_Quote__c quote= [SELECT Id, Route__c, Account_for__c FROM Customer_Quote__c WHERE Pricing_Executive__c!=null LIMIT 1];
        // Account accQuery= [SELECT Id FROM Account WHERE RecordType.Name='Customer' LIMIT 1];
        
        String recordTypefee = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c fee = new Fee__c();
        fee.RecordTypeId = recordTypefee;
        fee.Name = 'Flete Nacional';
        fee.Route__c = quote.Route__c;
        fee.CurrencyIsoCode = 'MXN';
        fee.Fee_Category__c = 'Road Freights';
        fee.Group__c = 'SP-FN-FLETE NACIONAL';
        fee.Account_for__c=quote.Account_for__c;
        
        insert fee;
        
        //Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        //insert container;
        
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.Import_Export_Quote__c=quote.Id;
        cargoLine.Name='cargo12';
        cargoLine.Container_Type__c = data.container.Id;
        //cargoLine.Clave_de_Servicio__c=producto.Id;
        cargoLine.Extension_Item_Name__c='Papel';
        cargoLine.CurrencyIsoCode='MXN';
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=1;
        cargoLine.Total_Shipping_Weight_Kgs__c=1;
        cargoLine.Peso_Neto__c=1;
        cargoLine.Total_Shipping_Volume_m3__c=1;
        insert cargoLine;
        
        
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c();
        quote_fee.Import_Export_Quote__c = quote.id;
        quote_fee.Name = 'lineas items';
        quote_fee.Service_Rate_Name__c= fee.Id;
        quote_fee.Concept_1_Sell_Price__c =10;
        quote_fee.Concept_2_Sell_Price__c = 10;
        quote_fee.Concept_3_Sell_Price__c =10;
        quote_fee.Concept_4_Sell_Price__c = 10;
        quote_fee.Concept_5_Sell_Price__c =10;
        insert quote_fee;
        
    }
    //Creacion del Shipment y Shipment Service Line
    /*
    @isTest
    
      public static void testCreateShipment(){
        SAP_Service_Type__c queryServType = [SELECT Id FROM SAP_Service_Type__c WHERE Name = 'FN - Flete Nacional' LIMIT 1];
        Account queryAcc = [SELECT Id FROM Account WHERE Name = 'Cliente de Prueba' LIMIT 1];
        System.debug('imprime queryAcc :' + queryAcc);
        //User queryUser = [SELECT Id FROM User WHERE username = 'userTest@test.com.userTest' LIMIT 1];
        //System.debug('imprime queryUser :' + queryUser);
        Country__c queryCountry = [SELECT Id FROM Country__c WHERE Name = 'Mexico' LIMIT 1];
        State__c queryState = [SELECT Id FROM State__c WHERE Name = 'Sonora' LIMIT 1];
        Location__c queryLocation = [SELECT Id FROM Location__c WHERE Name = 'Xalapa' LIMIT 1];
        Container_Type__c queryContainer = [SELECT Id FROM Container_Type__c WHERE Name = 'Super Tracto Camion' LIMIT 1];
        //UserRole queryRole = [SELECT Id FROM UserRole WHERE Name = 'Asesor Comercial' LIMIT 1];
        Account queryCarrier = [SELECT Id FROM Account WHERE Name = 'Carrier de Test' LIMIT 1];
		Rol_Margen__c queryRolMargen = [SELECT Id FROM Rol_Margen__c LIMIT 1];
        Catalogo_SAT__C queryCatalogo = [SELECT Id FROM Catalogo_SAT__C LIMIT 1];
        User queryUserManager = [SELECT Id FROM User WHERE username = 'userManagerTest@test.com.userTest' LIMIT 1];
        
        //p2g_creaciondefolios 
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        
        // Crear IEQO
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        Customer_Quote__c quote = new Customer_Quote__c(
        	RecordTypeId = recordTypeId,
            Name = 'insertQuoteTest2',
            Account_for__c = queryAcc.Id,
            Team__c = 'P2G',
            Quotation_Status__c = 'Quote being prepared',
            Customer_Reference__c = 'Referencia',
            Comercio_exterior__c = 'No',
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'Nacional',
            Service_Type__c = 'FTL',
            CurrencyIsoCode = 'MXN',
            Container_Type__c = queryContainer.Id,
            Country_ofLoad__c = queryCountry.Id,
            State_of_Load__c = queryState.Id,
            Site_of_Load__c = queryLocation.Id,
            Country_ofDischarge__c = queryCountry.Id,
            State_of_Discharge__c = queryState.Id,
            Site_of_Discharge__c = queryLocation.Id,
            ETD__c = Date.Today(),
            ETA__c = Date.Today(),
            Pricing_Executive__c = userT.Id,
            Operations_Exec__c = userT.Id
        );
        insert quote;

      
        // NEU_StaticVariableHelper.setBoolean1(true);
        // Customer_Quote__c quote= [SELECT Id, Route__c, Account_for__c FROM Customer_Quote__c WHERE Pricing_Executive__c!=null LIMIT 1];
        // Account accQuery= [SELECT Id FROM Account WHERE RecordType.Name='Customer' LIMIT 1];
        
        String recordTypefee = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c fee = new Fee__c();
        fee.RecordTypeId = recordTypefee;
        fee.Name = 'Flete Nacional';
        fee.Route__c = quote.Route__c;
        fee.CurrencyIsoCode = 'MXN';
        fee.Fee_Category__c = 'Road Freights';
        fee.Group__c = 'SP-FN-FLETE NACIONAL';
        fee.Account_for__c=quote.Account_for__c;
        
        insert fee;
        
        //Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        //insert container;
        
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.Import_Export_Quote__c=quote.Id;
        cargoLine.Name='cargo12';
        cargoLine.Container_Type__c = queryContainer.Id;
        //cargoLine.Clave_de_Servicio__c=producto.Id;
        cargoLine.Extension_Item_Name__c='Papel';
        cargoLine.CurrencyIsoCode='MXN';
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=1;
        cargoLine.Total_Shipping_Weight_Kgs__c=1;
        cargoLine.Peso_Neto__c=1;
        cargoLine.Total_Shipping_Volume_m3__c=1;
        insert cargoLine;
        
        
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c();
        quote_fee.Import_Export_Quote__c = quote.id;
        quote_fee.Name = 'lineas items';
        quote_fee.Service_Rate_Name__c= fee.Id;
        quote_fee.Concept_1_Sell_Price__c =10;
        quote_fee.Concept_2_Sell_Price__c = 10;
        quote_fee.Concept_3_Sell_Price__c =10;
        quote_fee.Concept_4_Sell_Price__c = 10;
        quote_fee.Concept_5_Sell_Price__c =10;
        insert quote_fee;
        
        NEU_StaticVariableHelper.setBoolean1(true);
        //Customer_Quote__c quote= [SELECT Id, Route__c, Account_for__c FROM Customer_Quote__c WHERE name = 'insertQuoteTest'  LIMIT 1];
        Country__c country= [SELECT Id FROM Country__c LIMIT 1];
        
        Country__c country2 = new Country__c(
            Name = 'Mexico',
        ISO_Code_2c__c = 'MX',
        ISO_Code__c = 'MEX'
            );
        insert country2;
        
        State__c state = new State__c(
            Name = 'Sonora',
        ISO_Code_2c__c = 'SO',
        country__c = country.Id
            );
        insert state;
        
        Location__c location = new Location__c(
		            Name = 'Hermosillo',
        state__c = state.Id,
        country__c = country.Id
            );
        insert location;
        
        Container_Type__c container = new Container_Type__c();
        container.Name = 'test';
        insert container;
        
        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FN-23-001999';
        new_shipment.Freight_Mode__c= 'Road';
        new_shipment.Service_Type__c= 'FTL';
        new_shipment.ETA_Point_of_Discharge__c = Date.valueOf('2023-05-2');
        new_shipment.ETD_from_Point_of_Load__c = Date.valueOf('2023-05-12');
        new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(08,0,0,0);
        new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(08,0,0,0);
        new_shipment.Route__c = quote.Route__c;
        new_shipment.Account_for__c= quote.account_for__c;
        new_shipment.Country_of_Discharge__c = country.Id;
        new_shipment.Country_of_Load__c = country.Id;
        new_shipment.State_of_Discharge__c = state.Id;
        new_shipment.State_of_Load__c = state.Id;
        new_shipment.Site_of_Discharge__c = location.Id;
        new_shipment.Site_of_Load__c = location.Id;
        new_shipment.Container_Type__c = container.Id;
        new_shipment.Service_Mode__c = 'NATIONAL';
        insert new_shipment;
        
        Shipment_Fee_Line__c feeFalse = new Shipment_Fee_Line__c();
        feeFalse.Name = 'Fee False';
        feeFalse.Campo_Control__c = false;
        feeFalse.Shipment__c=new_shipment.Id;
        
        Catalogo_SAT__c servicio = new Catalogo_SAT__c();
        servicio.Name = 'Papel Test';
        servicio.Clave_SAT__c = '15975361';
        servicio.Material_PeligrosoCP__c = true;
        servicio.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Productos y Servicios cP').getRecordTypeId();
        insert servicio;
        
        Catalogo_SAT__c cajasCon = new Catalogo_SAT__c();
        cajasCon.Name = 'cajas conexion Test';
        cajasCon.Clave_SAT__c = '01264588';
        cajasCon.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Fraccion Arancelaria').getRecordTypeId();
        insert cajasCon;
        
        Catalogo_SAT__c embalaje = new Catalogo_SAT__c();
        embalaje.Name = 'Envases y embalajes Test';
        embalaje.Clave_SAT__c = 'Envases y embalajes Test';
        embalaje.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Embalaje').getRecordTypeId();
        insert embalaje;
        
        Shipment_Line__c cl = new Shipment_Line__c();
        cl.Name = '001';
        cl.Shipment__c = new_shipment.Id;
        cl.Container_Type__c = container.Id;        
        cl.Clave_de_Servicio__c = servicio.Id;
        //cl.pedimento__c = 'Test pedimiento';
        //cl.Peso_Neto__c = 10;
        //cl.Units_Shipped__c = 2;
        //cl.Shipping_Weight_Kg__c = 2;
        //cl.CP_Fraccion_Arancelaria__c = cajasCon.Id;
        //cl.Embalaje__c = embalaje.Id;
        insert cl;
    }*/   
    
}