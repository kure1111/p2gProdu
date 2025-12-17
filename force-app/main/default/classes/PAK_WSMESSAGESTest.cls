@isTest(SeeAllData=true)
public class PAK_WSMESSAGESTest {
    @isTest(SeeAllData=true)
    static void testSFMESSAGES_EntregaCreada() {
        Order ord = [SELECT Id FROM Order LIMIT 1];
        
        Account acc= new Account();
        	acc.Name='Test';
        	acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        	acc.OwnerId=UserInfo.getUserId();
        	insert acc; 
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
        quote.Account_for__c = acc.Id;
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
        
        if (ord == null) {
            ord = new Order(Name='OrderTest2');
            insert ord;
        }

        Shipment__c sp = new Shipment__c();
        sp.Account_for__c = acc.Id;
        sp.Freight_Mode__c = 'Sea';
        sp.Service_Mode__c = 'Import';
        sp.Only_Warehouse_Service__c = true;
        sp.Name = 'SP-FN-Test000';
        insert sp;
        
        if (sp == null) {
            sp.Name = 'SP-FN-21-280888';                      
        	sp.Freight_Mode__c = 'Road';
        	sp.Account_for__c=acc.Id;             
        	sp.Service_Mode__c = 'NATIONAL';
        	sp.Service_Type__c =  'LTL';        
        	sp.Only_Warehouse_Service__c = false;                    
        	sp.Operation_Executive__c = userinfo.getUserId();                 
        	sp.Warehouse_Movement_Type__c = 'Entries (In)';
            insert sp;
        }

        Invoice__c inv = new Invoice__c(Name='InvoiceTest2', Shipment__c=sp.Id,Import_Export_Quote_Order__c=quote.id, Account__c=acc.id);
        insert inv;

        inv.Name='002';
        update inv;
        
        
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Invoice = inv.Id;
        msg.Shipment = sp.Id;
        msg.Message = 'Entrega Creada No. : 9999';

        Test.startTest();
        PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    static void testSFMESSAGES_PagoEfectuado() {
        Account acc= new Account();
        	acc.Name='Test';
        	acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        	acc.OwnerId=UserInfo.getUserId();
        	insert acc; 
        
        Shipment_Disbursement__c disb = new Shipment_Disbursement__c(
            Name='DisbTest3', Account__c=acc.id            
        );
        insert disb;

        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Disbursement = disb.Id;
        msg.Message = 'Pago efectuado Monto de: 300.00';

        Test.startTest();
        PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    static void testSFMESSAGES_PagoRecibido() {
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();
        insert acc;
        Shipment__c sp = new Shipment__c ();
        sp.Name = 'SP-FN-21-280888';                      
        sp.Freight_Mode__c = 'Road';
        sp.Account_for__c=acc.Id;             
        sp.Service_Mode__c = 'NATIONAL';
        sp.Service_Type__c =  'LTL';        
        sp.Only_Warehouse_Service__c = false;                    
        sp.Operation_Executive__c = userinfo.getUserId();                 
        sp.Warehouse_Movement_Type__c = 'Entries (In)';
        insert sp;
        
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
        quote.Account_for__c = acc.Id;
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

        Invoice__c inv = new Invoice__c(
            Name='InvoicePagoRec',
            Shipment__c=sp.Id,
            Import_Export_Quote_Order__c=quote.id, Account__c=acc.id
        );
        insert inv;

        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Invoice = inv.Id;
        msg.Message = 'Pago recibido Monto de: 1000.00';

        Test.startTest();
        PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    static void testSFMESSAGES_ProveedorCreado() {
        Account acc = new Account(Name='ProveedorTest');
        insert acc;

        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Account = acc.Id;
        msg.Message = 'Proveedor creado en SAP CardCode:PRV001';

        Test.startTest();
        PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();
    }

    @isTest
    static void testFolioEntrega_Simple() {
        String msg = 'Entrega Creada No. : 12345';
        PAK_WSMESSAGES.folioEntrega(msg);
    }

    @isTest
    static void testFolioEntrega_WithIdLines() {
        String msg = 'Entrega Creada No. : 54321 IdLines: 999';
        PAK_WSMESSAGES.folioEntrega(msg);
    }

    @isTest(SeeAllData=true)
    static void testSFMESSAGES_WithException() {
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message = 'Mensaje con error simulado';
        msg.Order = 'InvalidId';

        Test.startTest();
        PAK_WSMESSAGES.SFMESSAGES(new List<PAK_WSMESSAGES.MESSAGE>{msg});
        Test.stopTest();
    }
}