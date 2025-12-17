@isTest
public class P2G_ValidateStatusInvoiceTest {

    @testSetup
    static void setup(){
       Account account_test = new Account();
        String recordCustomer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        account_test.Name = 'Bimbo';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c='MTY';
        account_test.RecordTypeId = recordCustomer;
        
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
        carrier_test.ActiveSap__c = TRUE;
        insert carrier_test;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
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
        insert new_shipment;
        INV_Counter__c contador = new INV_Counter__c(
    		Name = 'Contador Principal', 
    		Contador__c = 0
		);
		insert contador;
    }
    
    @isTest
    static void testValidateInvoiceCreation_NoExistingInvoices() {        
        List<Shipment__c> testShipments = [SELECT Id,Shipment__c.Account_for__c FROM Shipment__c LIMIT 1];
        
        Test.startTest();        
        
        List<Invoice__c> newInvoices = new List<Invoice__c>{
            new Invoice__c(                
                Account__c = testShipments[0].Account_for__c, 
                Shipment__c = testShipments[0].Id,
                Name = 'Test Invoice 1'
            )
        };
                
        P2G_ValidateStatusInvoice.validateInvoiceCreation(newInvoices);
        Test.stopTest();                
    }
    
    @isTest
    static void testValidateInvoiceCreation_WithExistingInvoiceControlFalse() {
        // Obtener Shipments de prueba
        List<Shipment__c> testShipments = [SELECT Id,Account_for__c FROM Shipment__c LIMIT 1];
        List<Customer_Quote__c> testIEQO=[SELECT Id FROM Customer_Quote__c LIMIT 1];
        NEU_StaticVariableHelper.setBoolean1(true);
        // Crear una Invoice existente con Campo_Control__c = false
        Invoice__c existingInvoice = new Invoice__c(
            Shipment__c = testShipments[0].Id,
            Name = 'Existing Invoice',
            Campo_Control__c = false,
            Account__c = testShipments[0].Account_for__c, 
            Import_Export_Quote_Order__c=testIEQO[0].Id
        );
        insert existingInvoice;
        
        Test.startTest();
        // Intentar crear nueva Invoice para el mismo Shipment
        List<Invoice__c> newInvoices = new List<Invoice__c>{
            new Invoice__c(
                Shipment__c = testShipments[0].Id,
				Name = 'Test Invoice 2',
                Account__c = testShipments[0].Account_for__c, 
                Import_Export_Quote_Order__c=testIEQO[0].Id
            )
        };
        
        // Ejecutar validación - debería agregar error
        P2G_ValidateStatusInvoice.validateInvoiceCreation(newInvoices);
        NEU_StaticVariableHelper.setBoolean1(false);
        Test.stopTest();        
    }
    
    @isTest
    static void testValidateInvoiceCreation_WithExistingInvoiceControlTrue() {        
        List<Shipment__c> testShipments = [SELECT Id,Account_for__c FROM Shipment__c LIMIT 1];  
        List<Customer_Quote__c> testIEQO=[SELECT Id FROM Customer_Quote__c LIMIT 1];
        NEU_StaticVariableHelper.setBoolean1(true);
        Invoice__c existingInvoice = new Invoice__c(
            Shipment__c = testShipments[0].Id,
            Name = 'Existing Invoice',
            Campo_Control__c = true,
            Account__c = testShipments[0].Account_for__c, 
            Import_Export_Quote_Order__c=testIEQO[0].Id
        );
        insert existingInvoice;
        
        Test.startTest();        
        List<Invoice__c> newInvoices = new List<Invoice__c>{
            new Invoice__c(
                Shipment__c = testShipments[0].Id,
                Name = 'Test Invoice 3',
                Account__c = testShipments[0].Account_for__c, 
                Import_Export_Quote_Order__c=testIEQO[0].Id
            )
        };
                
        P2G_ValidateStatusInvoice.validateInvoiceCreation(newInvoices);
        
        NEU_StaticVariableHelper.setBoolean1(false);
        Test.stopTest();
                
    }
            
    @isTest
    static void testValidateInvoiceCreation_EmptyList() {
        Test.startTest();
        
        List<Invoice__c> emptyInvoices = new List<Invoice__c>();                
        P2G_ValidateStatusInvoice.validateInvoiceCreation(emptyInvoices);
        Test.stopTest();

    }
}