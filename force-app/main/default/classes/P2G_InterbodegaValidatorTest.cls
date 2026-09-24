@IsTest
public class P2G_InterbodegaValidatorTest {
   @TestSetup
    static void Setup(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Bimbo';
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
        Caja_Remolque__c remolque = new Caja_Remolque__c();
        remolque.Name = '001RHR';
        remolque.Tipo_Remolque__c = tipodeRemolque.Id;
        remolque.Num_Placa_Caja__c = '001RHR';
        insert remolque;
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'Vehiculo Prueba K-T';
        vehicle.Caja_Remolque__c = remolque.Id;
        vehicle.Num_Placa_Tracto__c = '111CEM';
        vehicle.Vehiculo_Validado__c = true;
        insert vehicle;
        Operadores__c operador = new Operadores__c();
        operador.Name = 'AGUSTIN VALDEZ SARABIA';
        operador.RFC_Operador__c = 'VASA910119858';
        operador.Cel_ope__c = '1234567898';
        operador.Medprev_ope__c = '906030';
        operador.Numlicvig_ope__c = 'e DF001107364';
        operador.Telfij_ope__c = '56 2655 6878';
        operador.Account__c = carrier_test.id;
        operador.Id_Recurso_Confiable__c = '1164166';
        operador.Validado__c = True;
        operador.Proovedor_validado__c = True;
        operador.Operador_Validado__c = True;
        insert operador;
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
        // el lookup filter de Account_Destination_Address__c en Produ exige direccion Validada y activa
        // (el campo activo se llama IsActive__c en UAT y Active__c en Produ)
        address1.status__c = 'Validado';
        Map<String, Schema.SObjectField> camposDir = Schema.SObjectType.Account_Address__c.fields.getMap();
        address1.put(camposDir.containsKey('isactive__c') ? 'IsActive__c' : 'Active__c', true);
        insert address1;
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        //quote.Name='Quote-Test';
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
    // Arma el shipment estandar del setup (mismos datos que usaba el test original)
    private static Shipment__c armaShipment(String nombre) {
        Account account_test = [SELECT id, name FROM Account WHERE Name = 'Bimbo'];
        Account carrier_test = [SELECT Id, Name FROM Account WHERE Name = 'Carrier de Test'];
        User userT = [select id from user where id =: UserInfo.getUserId() limit 1];
        Vehicle__c vehicle = [SELECT Id FROM Vehicle__c WHERE name = 'Vehiculo Prueba K-T'];
        Operadores__c operador = [SELECT Id FROM Operadores__c WHERE Name = 'AGUSTIN VALDEZ SARABIA'];
        Country__c country = [SELECT Id FROM Country__c WHERE Name='Mxico'];
        State__c state = [SELECT id FROM State__c WHERE Name = 'Sonora'];
        Location__c location = [SELECT Id FROM Location__c WHERE Name = 'xalapa'];
        Container_Type__c container = [SELECT Id FROM Container_Type__c WHERE Name = 'Super tracto Camion'];
        Account_Address__c address1 = [SELECT Id, Address__c FROM Account_Address__c WHERE Name = 'Direccion test'];
        Customer_Quote__c quote = [SELECT Id, Route__c, Customer_Reference__c FROM Customer_Quote__c WHERE Customer_Reference__c = 'hola soy una prueba'];

        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = nombre;
        new_shipment.Freight_Mode__c= 'Road';
        new_shipment.Service_Type__c= 'FTL';
        new_shipment.ETA_Point_of_Discharge__c = Date.valueOf('2023-05-2');
        new_shipment.ETD_from_Point_of_Load__c = Date.valueOf('2023-05-12');
        new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(08,0,0,0);
        new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(08,0,0,0);
        new_shipment.Carrier__c = carrier_test.Id;
        new_shipment.National_Operator__c = operador.Id;
        new_shipment.Vehicle__c = vehicle.Id;
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
        new_shipment.Account_Shipment_Reference__c = quote.Customer_Reference__c;
        new_shipment.Operation_Executive__c = userT.Id;
        new_shipment.Kms__c = 23;
        new_shipment.Traslado_Ingreso__c = 'Traslado';
        new_shipment.Shipment_Status_Plann__c = 'Confirmed';
        return new_shipment;
    }

    @IsTest
    public static void testRutaExactaMarca(){
        Account account_test = [SELECT id FROM Account WHERE Name = 'Bimbo'];
        Account_Address__c address1 = [SELECT Id FROM Account_Address__c WHERE Name = 'Direccion test'];
        insert new Interbodega_Ruta__c(Cuenta__c = account_test.Id, Origen__c = address1.Id, Destino__c = address1.Id);

        Shipment__c sp = armaShipment('SP-FN-23-000783');
        Test.startTest();
        insert sp;
        Test.stopTest();

        Shipment__c leido = [SELECT Interbodegas__c FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals(true, leido.Interbodegas__c, 'La ruta del catalogo debe marcar el viaje');
    }

    @IsTest
    public static void testTodaLaCuentaMarca(){
        Account account_test = [SELECT id FROM Account WHERE Name = 'Bimbo'];
        insert new Interbodega_Ruta__c(Cuenta__c = account_test.Id, Toda_La_Cuenta__c = true);

        Shipment__c sp = armaShipment('SP-FN-23-000784');
        Test.startTest();
        insert sp;
        Test.stopTest();

        Shipment__c leido = [SELECT Interbodegas__c FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals(true, leido.Interbodegas__c, 'Regla de toda la cuenta debe marcar cualquier viaje de la cuenta');
    }

    @IsTest
    public static void testSinReglaNoMarca(){
        // Renglon inactivo: presente pero apagado, no debe marcar
        Account account_test = [SELECT id FROM Account WHERE Name = 'Bimbo'];
        Account_Address__c address1 = [SELECT Id FROM Account_Address__c WHERE Name = 'Direccion test'];
        insert new Interbodega_Ruta__c(Cuenta__c = account_test.Id, Origen__c = address1.Id, Destino__c = address1.Id, Activa__c = false);

        Shipment__c sp = armaShipment('SP-FN-23-000785');
        Test.startTest();
        insert sp;
        Test.stopTest();

        Shipment__c leido = [SELECT Interbodegas__c FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals(false, leido.Interbodegas__c, 'Sin regla activa el viaje no se marca');
    }

    @IsTest
    public static void testValidacionRenglonAMedias(){
        Account account_test = [SELECT id FROM Account WHERE Name = 'Bimbo'];
        try {
            insert new Interbodega_Ruta__c(Cuenta__c = account_test.Id);
            System.assert(false, 'Un renglon sin direcciones y sin Toda la cuenta debe rechazarse');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Toda la cuenta'), 'Mensaje: ' + e.getMessage());
        }
    }

    @IsTest
    public static void test(){
        Account account_test = [SELECT id, name FROM Account WHERE Name = 'Bimbo'];
        Account carrier_test = [SELECT Id, Name FROM Account WHERE Name = 'Carrier de Test'];
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);
       	Catalogo_SAT__c catalogo = [SELECT Id, Name FROM Catalogo_SAT__c WHERE Name = 'Caja de acero test'];
        //Caja_Remolque__c remolque = [SELECT Id, Name FROM Caja_Remolque__c WHERE Name = 'Caja de acero test'];
		Vehicle__c vehicle = [SELECT Id, NAme FROM Vehicle__c WHERE name = 'Vehiculo Prueba K-T'];
        Operadores__c operador = [SELECT Id,Name FROM Operadores__c WHERE Name = 'AGUSTIN VALDEZ SARABIA'];
        Country__c country = [SELECT Id, Name FROM Country__c WHERE Name='Mxico'];
        State__c state = [SELECT id, Name FROM State__c WHERE Name = 'Sonora'];
        Location__c location = [SELECT Id, Name, State__c, Country__c FROM Location__c WHERE Name = 'xalapa'];
        Container_Type__c container = [SELECT Id, Name FROM Container_Type__c WHERE Name = 'Super tracto Camion'];
        Account_Address__c address1 = [SELECT Id, Name, Address__c FROM Account_Address__c WHERE Name = 'Direccion test'];
        Customer_Quote__c quote = [SELECT Id, Name, Route__c, Customer_Reference__c  FROM Customer_Quote__c WHERE Customer_Reference__c = 'hola soy una prueba'];
            
	//Insertar sp y queries
        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FN-23-000783';
        new_shipment.Freight_Mode__c= 'Road';
        new_shipment.Service_Type__c= 'FTL';
        new_shipment.ETA_Point_of_Discharge__c = Date.valueOf('2023-05-2');
        new_shipment.ETD_from_Point_of_Load__c = Date.valueOf('2023-05-12');
        new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(08,0,0,0);
        new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(08,0,0,0);
        new_shipment.Carrier__c = carrier_test.Id;
        new_shipment.National_Operator__c = operador.Id;
        new_shipment.Vehicle__c = vehicle.Id;
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
        new_shipment.Account_Shipment_Reference__c = quote.Customer_Reference__c;
        new_shipment.Operation_Executive__c = userT.Id;
        new_shipment.Kms__c = 23;
        new_shipment.Traslado_Ingreso__c = 'Traslado';
        new_shipment.Shipment_Status_Plann__c = 'Confirmed';
        insert new_shipment;
    }
}