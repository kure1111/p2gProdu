@isTest
public class P2G_NEU_ActualizaFolioIETest {

    @testSetup
    static void setup() {                        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Bimbo';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c = 'Credito';
        
        account_test.Segment__c = 'Nuevo';
        account_test.Workplace__c = null;
        account_test.Requiere_Acuse_Sap__c = 'Si';
        account_test.Credit_Terms__c='15 Días';
        account_test.OwnerId=UserInfo.getUserId();
        insert account_test;
        
        Account b = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales');
        insert b;
    
        User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name);
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test', 'TCA125', 'Unidad Peso');
        Catalogo_SAT__c producto = TestDataFactory.createCatalogoSat('Papel', 'TCA127', 'Productos y Servicios cP');
        Catalogo_SAT__c materialPeligro = TestDataFactory.createCatalogoSat('Aluminio', 'TCA126', 'Material Peligroso');
        Catalogo_SAT__c embalaje = TestDataFactory.createCatalogoSat('Caja', 'TCA128', 'Tipo de Embalaje');
        Catalogo_SAT__c palet = TestDataFactory.createCatalogoSat('Pallet', 'TCA228', 'Unidad Peso');
        update catalogo;
    
        Country__c country = new Country__c(Name = 'México');
        insert country;
    
        State__c state = new State__c(
            Name = 'Sonora',
            Country__c = country.Id,
            Iso_Code__c = 'SON',
            ISO_Code_2c__c = 'SO',
            Zone_Planner_email__c = 'kuresa@gmaidl.com',
            Active__c = true
        );
        insert state;
    
        Location__c location = new Location__c(Name = 'Xalapa', State__c = state.Id, Country__c = country.Id);
        insert location;
    
        Container_Type__c container = new Container_Type__c(Name = 'Super tracto Camion', Type__c = 'Road', Cargo_Weight_Kg__c = 22222);
        insert container;
        
        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';
        //direccion.Clave_Relacion_SAT__c = 'Tlaxcala';
        direccion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();
        //direccion.Municipio_Ref_CP__c = 'Nopalucan Tlax.';Codigo Postal        
        //direccion.Pais_RefCP__c = 'Mexico';
        insert direccion;
    
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = account_test.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Codigo_Postal_CP__c = direccion.Id;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';        
        address.status__c = 'Validado';
        //address.Active__c = true;
        insert address;
        
        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = account_test.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=19.6248115;
        address2.Address_Coordinates__Longitude__s=-99.18076289999999;
        address2.Codigo_Postal_CP__c = direccion.Id;
        address2.referencia__c = 'Referencias test';
        address2.Type__c = 'Shipping Address';
        
        address2.status__c = 'Validado'; 
        //address2.Active__c = true; 
        insert address2;
    	NEU_StaticVariableHelper.setBoolean1(true);
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name = '.';
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
        quote.Pricing_Executive__c = userT.Id;
        quote.Operations_Exec__c = userT.Id;
        insert quote;
    	
        NEU_StaticVariableHelper.setBoolean1(false);
        /*
        Shipment__c new_shipment = new Shipment__c(
            Name = 'SP-FN-23-000783',
            Freight_Mode__c = 'Road',
            Service_Type__c = 'FTL',
            ETA_Point_of_Discharge__c = Date.valueOf('2023-05-02'),
            ETD_from_Point_of_Load__c = Date.valueOf('2023-05-12'),
            ETA_Time_Point_of_Discharge__c = Time.newInstance(8, 0, 0, 0),
            ETD_Time_from_Point_of_Load__c = Time.newInstance(8, 0, 0, 0),
            Account_for__c = account_test.Id,
            Country_of_Discharge__c = country.Id,
            Country_of_Load__c = country.Id,
            State_of_Discharge__c = state.Id,
            State_of_Load__c = state.Id,
            Site_of_Discharge__c = location.Id,
            Site_of_Load__c = location.Id,            
            Container_Type__c = container.Id,
            Service_Mode__c = 'NATIONAL',
            Origin_Address__c = address.Address__c,
            Account_Origin_Address__c = address.Id,
            Account_Destination_Address__c = address2.Id,
            Destination_Address__c = address2.Address__c,
            Origin_Location__Latitude__s = address.Address_Coordinates__Latitude__s,
            Origin_Location__Longitude__s = address.Address_Coordinates__Longitude__s,
            Destination_Location__Latitude__s = address2.Address_Coordinates__Latitude__s,
            Destination_Location__Longitude__s = address2.Address_Coordinates__Longitude__s,
            Traslado_Ingreso__c = 'Traslado'
            
        );
        insert new_shipment;
                
        Account accCotizador = new Account(Name = 'Cotizador');
        insert accCotizador;
        
        Account accProveedor = new Account(Name = 'Proveedor Maestro');
        insert accProveedor;
                
        Fee__c rate = new Fee__c(
            Name = 'RateTest',
            Account_For__c = accCotizador.Id,
            Carrier_Account__c = accProveedor.Id
        );
        insert rate;
    	NEU_StaticVariableHelper.setBoolean1(true);
        Invoice__c invo = new Invoice__c();
        String recordType = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Invoice').getRecordTypeId();
        invo.RecordTypeId = recordType;
        invo.Name = 'Test invoice';
        invo.Type__c = 'Debit Note';
        invo.Date_Invoice_SAP__c = Date.valueOf('2023-06-02');
        invo.Payable_Before__c = Date.valueOf('2023-06-20');
        invo.Account__c = account_test.Id;
        invo.Import_Export_Quote_Order__c = quote.Id;
        invo.Shipment__c = new_shipment.Id;
        invo.Campo_Control__c=true;
        insert invo;
    
        SAP_Service_Type__c sap = new SAP_Service_Type__c(Name = 'SERVICIOS LOGISTICOS FN (IC) (FN)', Code__c = 'FN-SERV_LOGISTICO_IC');
        insert sap;
    
        INVLine_Counter__c contador = new INVLine_Counter__c(Contador__c = 0);
        insert contador;
    
        Shipment_Fee_Line__c feeFalse = new Shipment_Fee_Line__c(Name = 'Fee False', Campo_Control__c = false, Shipment__c=new_shipment.Id);
        Shipment_Fee_Line__c feeTrue = new Shipment_Fee_Line__c(Name = 'Fee True', Campo_Control__c = true, Shipment__c=new_shipment.Id);
        insert new List<Shipment_Fee_Line__c>{feeFalse, feeTrue};
    
        Invoice_Line__c invoLine = new Invoice_Line__c(
            Name = 'Test Invoice Line',
            Units__c = 23,
            Shipment__c = new_shipment.Id,
            Invoice__c = invo.Id,
            SAP_Service_Type__c = sap.Id,
            Shipment_Service_Line__c = feeFalse.Id
        );
        insert invoLine;
    
        Associated_Document__c docu = new Associated_Document__c(Name = 'Test Documento', Document_Type__c = 'Acuse', Shipment__c = new_shipment.Id, Account__c = account_test.Id);
        insert docu;
        
        INV_Counter__c counter = new INV_Counter__c(Contador__c = 0); insert counter;
        */
    }

    private static String getPicklistValue(SObjectType objType, String fieldName) {
        Schema.DescribeFieldResult fieldDescribe = objType.getDescribe().fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
        for (Schema.PicklistEntry entry : picklistEntries) {
            if (entry.isActive()) {
                return entry.getValue();
            }
        }
        return null;
    }

    @isTest
    static void testInsertP2G_Sea() {
        Account account_test= [SELECT Id FROM Account LIMIT 1];
        Location__c location=[SELECT Id,State__c,Country__c FROM Location__c LIMIT 1];
        User userT=[SELECT Id FROM User LIMIT 1];
        NEU_StaticVariableHelper.setBoolean1(true);
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name = '.';
        quote.Account_for__c = account_test.Id;
        quote.Team__c = 'P2G';
        quote.Quotation_Status__c = 'Quote being prepared';
        quote.Customer_Reference__c = 'holi';
        quote.Valid_From__c = system.today();
        quote.Valid_Until__c = system.today();
        quote.Comercio_Exterior__c = 'No';
        quote.Freight_Mode__c = 'Sea';
        quote.Service_Mode__c = 'IMPORT';
        quote.Service_Type__c = 'FCL';
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
        quote.Pricing_Executive__c = userT.Id;
        quote.Operations_Exec__c = userT.Id;        
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertP2G_Road_Import_FTL() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        String borderValue = getPicklistValue(Customer_Quote__c.SObjectType, 'Border__c');
        String customsValue = getPicklistValue(Customer_Quote__c.SObjectType, 'Customs__c');
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'IMPORT',
            Service_Type__c = 'FTL',
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Border__c = borderValue,
            Customs__c = customsValue,
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertP2G_Road_National_FP() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'NATIONAL',
            Service_Type__c = 'FP',
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertP2G_Air_Import_PAQUETERIA() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Air',
            Service_Mode__c = 'IMPORT',
            Service_Type__c = 'PAQUETERIA',
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertP2G_Air_Import_CARGA() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Air',
            Service_Mode__c = 'IMPORT',
            Service_Type__c = 'CARGA',
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertP2G_Port() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Service_Mode__c = 'PORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertP2G_Refrigerado_National() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'NATIONAL',
            Service_Type__c = 'FTL',
            Refrigerado__c = true,
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertP2G_Refrigerado_International() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'INTERNATIONAL',
            Service_Type__c = 'FTL',
            Refrigerado__c = true,
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }
	/*
    @isTest
    static void testInsertP2G_OnlyWarehouse() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Only_Warehouse_Service__c = true,
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }
	*/
    @isTest
    static void testInsertP2G_ComercioExterior() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        String borderValue = getPicklistValue(Customer_Quote__c.SObjectType, 'Border__c');
        String customsValue = getPicklistValue(Customer_Quote__c.SObjectType, 'Customs__c');
        String tipoServicio = getPicklistValue(Customer_Quote__c.SObjectType, 'CE_Tipodeservicio_IMPAK__c');
        String impak = getPicklistValue(Customer_Quote__c.SObjectType, 'IMPAK__c');
        String incoterm = getPicklistValue(Customer_Quote__c.SObjectType, 'Sales_Incoterm__c');

        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Comercio_Exterior__c = 'Si',
            Account_for__c = accountId,
            Service_Mode__c = 'IMPORT',
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Border__c = borderValue,
            Customs__c = customsValue,
            CE_Tipodeservicio_IMPAK__c = tipoServicio,
            IMPAK__c = impak,
            Sales_Incoterm__c = incoterm,
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertWCA_Sea_Import() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'WCA',
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'IMPORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertWCA_Sea_Export() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'WCA',
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'EXPORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    @isTest
    static void testInsertWCA_Air_Export() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'WCA',
            Freight_Mode__c = 'Air',
            Service_Mode__c = 'EXPORT',
            Service_Type__c = 'CARGA',
            Account_for__c = accountId,
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }

    /*
    @isTest
    static void testInsertNullTeam_FallbackP2G() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        User p2gUser = [SELECT Id FROM User WHERE Team__c = 'P2G' AND IsActive = true LIMIT 1];
        System.runAs(p2gUser) {
            Customer_Quote__c quote = new Customer_Quote__c(
                Team__c = null,
                Freight_Mode__c = 'Sea',
                Service_Mode__c = 'IMPORT',
                Account_for__c = accountId,
                Service_Type__c = 'FTL',
                Motivo__c = 'Cliente no requiere',
                Pricing_Executive__c = UserInfo.getUserId(),
                Operations_Exec__c=UserInfo.getUserId()
            );
            Test.startTest();
            insert quote;
            Test.stopTest();
        }
    }
/*
    @isTest
    static void testInsertNullTeam_FallbackWCA() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        User wcaUser = [SELECT Id FROM User WHERE Team__c = 'WCA' AND IsActive = true LIMIT 1];
        System.runAs(wcaUser) {
            Customer_Quote__c quote = new Customer_Quote__c(
                Team__c = null,
                Freight_Mode__c = 'Sea',
                Service_Mode__c = 'IMPORT',
                Account_for__c = accountId,
                Service_Type__c = 'FTL',
                Motivo__c = 'Cliente no requiere',
                Pricing_Executive__c = UserInfo.getUserId()
            );
            Test.startTest();
            insert quote;
            Test.stopTest();
        }
    }
*/
    @isTest
    static void testUpdateRecalculo() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'IMPORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        insert quote;

        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'IMPORT';
        quote.Service_Type__c = 'FTL';

        String borderValue = getPicklistValue(Customer_Quote__c.SObjectType, 'Border__c');
        String customsValue = getPicklistValue(Customer_Quote__c.SObjectType, 'Customs__c');
        quote.Border__c = borderValue;
        quote.Customs__c = customsValue;

        Test.startTest();
        update quote;
        Test.stopTest();
    }

    @isTest
    static void testUpdateNoRecalculo() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'IMPORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        insert quote;

        Test.startTest();
        update quote;
        Test.stopTest();
    }

    @isTest
    static void testRecursivePrevention() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c q1 = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'IMPORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Customer_Quote__c q2 = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'IMPORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert new List<Customer_Quote__c>{ q1, q2 };
        Test.stopTest();
    }

    @isTest
    static void testDiciembreBranch() {
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Customer_Quote__c quote = new Customer_Quote__c(
            Team__c = 'P2G',
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'IMPORT',
            Account_for__c = accountId,
            Service_Type__c = 'FTL',
            Motivo__c = 'Cliente no requiere',
            Pricing_Executive__c = UserInfo.getUserId(),
            Operations_Exec__c=UserInfo.getUserId()
        );
        Test.startTest();
        insert quote;
        Test.stopTest();
    }
}