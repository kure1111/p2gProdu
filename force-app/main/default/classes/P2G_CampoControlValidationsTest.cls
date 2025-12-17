@isTest
public class P2G_CampoControlValidationsTest {

    @testSetup
    static void Setup() {
        
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
        address.Active__c = true;
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
        address2.Active__c = true; 
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
    }
    
    @isTest
    static void PAK_INV_CtrTest() {
        Invoice__c invo = [SELECT Id, Shipment__c, Shipment__r.Account_for__c FROM Invoice__c WHERE Type__c = 'Debit Note' LIMIT 1];
        SAP_Service_Type__c sap = [SELECT Id FROM SAP_Service_Type__c WHERE Name = 'SERVICIOS LOGISTICOS FN (IC) (FN)' LIMIT 1];
        Associated_Document__c doc = [SELECT Id FROM Associated_Document__c WHERE Name = 'Test Documento' LIMIT 1];
        PageReference pageRef = Page.PAK_INV_Send_SAP;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(invo);
        PAK_INV_Ctr testPak = new PAK_INV_Ctr(sc);
    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_PAK_INV_CtrMockHttpResponse(1));
        testPak.Cancelar();
        testPak.SendShipment();
        PAK_INV_Ctr.SendInvoiceToSAPFromTrigger(invo.Id);
        testPak.SendSPtoSAPFromTrigger(invo.Id);
        PAK_INV_Ctr.validacion(invo.Id);
    
        // === Escenarios para trigger NEU_ActualizaINVLine ===
        Invoice_Line__c lineInsert = new Invoice_Line__c(
            Shipment__c = invo.Shipment__c,
            Invoice__c = invo.Id,
            SAP_Service_Type__c = sap.Id,
            Units__c = 5
        );
        insert lineInsert; // Cubre before insert
    
        lineInsert.Units__c = 10;
        update lineInsert; // Cubre before update con Campo_Control__c = false
    
        // Update con Campo_Control__c = true
        Shipment_Fee_Line__c feeTrue = [SELECT Id FROM Shipment_Fee_Line__c WHERE Campo_Control__c = true LIMIT 1];
        Invoice_Line__c lineError = new Invoice_Line__c(Shipment__c = invo.Shipment__c, Invoice__c = invo.Id, SAP_Service_Type__c = sap.Id, Shipment_Service_Line__c = feeTrue.Id);
        insert lineError;
        try {
            lineError.Units__c = 50;
            update lineError; // Debe activar addError
        } catch (Exception e) {}
    
        // Bypass con variable estática
        NEU_StaticVariableHelper.setBoolean1(true);
        Invoice_Line__c lineBypass = new Invoice_Line__c(Shipment__c = invo.Shipment__c, Invoice__c = invo.Id);
        insert lineBypass;
        NEU_StaticVariableHelper.setBoolean1(false);
    
        // === Fin escenarios del trigger ===
    
        Account account = new Account(Id = invo.Shipment__r.Account_for__c, Requiere_Acuse_Sap__c = 'NO');
        update account;
        PAK_INV_Ctr.validacion(invo.Id);
    
        Shipment__c ship = new Shipment__c(Id = invo.Shipment__c, Traslado_Ingreso__c = 'Ingreso');
        update ship;
    
        SAP_Service_Type__c sapType = new SAP_Service_Type__c(Id = sap.Id, Code__c = 'FN-FLET_NACIONAL_IC');
        update sapType;
        PAK_INV_Ctr.validacion(invo.Id);
    
        Associated_Document__c docu = new Associated_Document__c(Id = doc.Id, Document_Type__c = 'Contract');
        update docu;
        PAK_INV_Ctr.validacion(invo.Id);
        Test.stopTest();
    }
    

	@isTest 
    static void testTriggerBeforeInsert() { 
        Test.startTest();
        Account acc = [SELECT Id FROM Account WHERE Name='Bimbo' LIMIT 1];
        Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        //Invoice__c inv=[SELECT Id, Campo_Control__c FROM Invoice__c LIMIT 1];
        //inv.Campo_Control__c=true;
        //update inv;         
        Invoice__c newInv = new Invoice__c( Name = 'Invoice Insert', Type__c = 'Debit Note', 
        Account__c = acc.Id, 
        Import_Export_Quote_Order__c=quote.Id,
        Shipment__c = shipment.Id ); 
        insert newInv; 
        Test.stopTest(); 
    } 
    @isTest
    static void testTriggerBeforeUpdateWithCampoControlTrue() {
        Invoice__c inv = [SELECT Id, Name FROM Invoice__c LIMIT 1];
        Test.startTest(); 
        try { 
            inv.Invoice_Concept__c = 'Intento de cambio'; 
             update inv;
        } catch (Exception e) {
            
        } 
        Test.stopTest(); 
    } 
    /*
    @isTest
    static void testTriggerBeforeUpdateWithoutCampoControl() {        
        NEU_StaticVariableHelper.setBoolean1(true);

        Customer_Quote__c quote=[SELECT Id FROM Customer_Quote__c LIMIT 1];
        Shipment_Fee_Line__c sfl = [SELECT Id, Campo_Control__c FROM Shipment_Fee_Line__c LIMIT 1];
        sfl.Campo_Control__c = false;
        update sfl;
    
        Invoice__c inv = [SELECT Id, Name FROM Invoice__c WHERE NAME='Test invoice' LIMIT 1];
    
        Test.startTest();
        inv.Name = '';        
        
        update inv;
        Test.stopTest();
    
        NEU_StaticVariableHelper.setBoolean1(false); 
    }    
	*/
}