@isTest
public class P2G_TriggersDisabledTest {
    
    @testSetup
    static void setup(){
        NEU_StaticVariableHelper.setBoolean1(true);
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();        	
        insert acc;
        
        Account sup= new Account();
        sup.Name='Test';
        sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();        	
        insert sup;
        
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name='.';
        importexportquote.Account_for__c = acc.Id;
        importexportquote.Team__c = 'P2G';
        importexportquote.Quotation_Status__c = 'Quote being prepared';
        importexportquote.Customer_Reference__c = 'hola soy una prueba';
        importexportquote.Valid_From__c = system.today();
        importexportquote.Valid_Until__c = system.today();
        importexportquote.Comercio_Exterior__c = 'No';
        importexportquote.Freight_Mode__c = 'Road';
        importexportquote.Service_Mode__c = 'NATIONAL';
        importexportquote.Service_Type__c = 'FTL';
        importexportquote.CurrencyIsoCode = 'MXN';
        importexportquote.ETD__c = Date.today();
        importexportquote.ETA__c = Date.today();
        importexportquote.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote.Pricing_Executive__c= userT.Id;
        importexportquote.Operations_Exec__c = userT.Id;
        insert importexportquote;
        
        Shipment__c ship = new Shipment__c(Name='SP-FN-Test',Account_for__c = acc.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        
        Fee__c fee = new Fee__c();
        fee.Name = 'test fees';
        fee.Fee_Category__c = 'Disbursement'; 
        fee.Rate_Type__c = '% of Charge';
        fee.Account_for__c = acc.Id;
        insert fee;
        
        Import_Export_Fee_Line__c quote1 = new Import_Export_Fee_Line__c();
        quote1.Import_Export_Quote__c = importexportquote.Id;
        quote1.Name = 'lineas items';
        quote1.Service_Rate_Name__c = fee.Id;
        insert quote1;
    }
    @isTest
    static void generalTestTrigger(){
        Account acc= [SELECT Id FROM Account WHERE RecordType.Name='Customer' LIMIT 1];
        
        Account sup=[SELECT Id FROM Account WHERE RecordType.Name='Supplier' LIMIT 1];                
        
        Country__c Country = [SELECT Id FROM Country__c LIMIT 1];
        Location__c localizacion =[SELECT Id FROM Location__c LIMIT 1];
        
        Customer_Quote__c importexportquote=[SELECT Id FROM Customer_Quote__c LIMIT 1];                                      
        
        Import_Export_Fee_Line__c quote1 = [SELECT Id FROM Import_Export_Fee_Line__c LIMIT 1];
        
        Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_Other__c = 'Prepaid';
        air_waybill_test.Name = 'Test AWB';
        air_waybill_test.Accounting_Information__c = 'Test Accounting Info';
        air_waybill_test.Serial_Number__c = '12345';
        air_waybill_test.Weight_Charge_House__c = 4;
        air_waybill_test.Valuation_Charge_House__c = 4; 
        air_waybill_test.Tax_House__c = 4; 
        air_waybill_test.Total_Other_Charges_Due_Agent_House__c = 4;
        air_waybill_test.Total_Other_Charges_Due_House__c = 4;
        air_waybill_test.Weight_Charge_Master__c = 4;
        air_waybill_test.Valuation_Charge_Master__c = 4; 
        air_waybill_test.Tax_Master__c = 4; 
        air_waybill_test.Total_Other_Charges_Due_Agent_Master__c = 4; 
        air_waybill_test.Total_Other_Charges_Due_Master__c = 4;
        insert air_waybill_test;
        
        Waybill_Consolidation__c consolidation = new Waybill_Consolidation__c();
        consolidation.Name = 'Test Consolidation';
        consolidation.Waybill__c = air_waybill_test.Id;
        insert consolidation;
        
        Air_Waybill_Line__c awbLine = new Air_Waybill_Line__c();
        awbLine.Name = 'Test Line';
        awbLine.No_of_Pieces__c = 4;
        awbLine.Air_Waybill__c = air_waybill_test.Id;
        awbLine.House_Reference__c = consolidation.Id;
        insert awbLine;   
        
        Event eventTest = new Event(DurationInMinutes = 1,ActivityDateTime= Datetime.now(), Subject = 'Test', OwnerId = UserInfo.getUserId());
        insert eventTest;                
        
        
        
    }
    @isTest
    static void generalTriggers2(){
        Customer_Quote__c importexportquote=[SELECT Id FROM Customer_Quote__c LIMIT 1];
        Shipment__c ship =[SELECT Id, Name FROM Shipment__c LIMIT 1];
        Account acc= [SELECT Id FROM Account WHERE RecordType.Name='Customer' LIMIT 1];
        
        Account sup=[SELECT Id FROM Account WHERE RecordType.Name='Supplier' LIMIT 1];
        Country__c Country = [SELECT Id FROM Country__c LIMIT 1];
        Location__c localizacion =[SELECT Id FROM Location__c LIMIT 1];
        
        Fee__c fee =[SELECT Id FROM Fee__c LIMIT 1];
        
        Import_Export_Fee_Line__c quote1 = [SELECT Id FROM Import_Export_Fee_Line__c LIMIT 1];
        
        Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id);
        insert shipdis;   
        
        /*                            
Quote_Item_Line__c quote_item = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
insert quote_item;
Import_Export_Cargo_Line_Disbursement__c ie_line_disbursement = new Import_Export_Cargo_Line_Disbursement__c(Disbursement__c = shipdis.Id,Import_Export_Cargo_Line__c = quote_item.Id);
insert ie_line_disbursement;
*/
        /*
Discount_Rule__c dr = new Discount_Rule__c (Name='test discount' );
insert dr;
Import_Export_Discount_Line__c  iedl = new Import_Export_Discount_Line__c  (Discount_Rule__c = dr.Id, Import_Export_Quote_Order__c = importexportquote.Id , Amount_copy__c =10 , Discount__c = 10 );
insert iedl ;        
*/
        NEU_Factory__c line_factory = new NEU_Factory__c(Name='test factroy', Account_Owner__c = aCC.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert line_factory;
        Import_Export_Service_Line_Disbursement__c ie_service_line_disburser = new Import_Export_Service_Line_Disbursement__c(Disbursement__c = shipdis.Id, Import_Export_Service_Line__c = quote1.Id);
        insert ie_service_line_disburser;
        
        Labor_Program__c labor_program = new Labor_Program__c(Bank_Holidays__c = 10, External_Legal_days__c = 10, Factory_Line__c =line_factory.Id , Equipment_Process_Trial_Scheduled_Mo__c=10);
        insert labor_program;
        
        Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
        insert ship_fee_line;
        Carrier_Line_Load_Point__c route2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route2;
        Shipment_Program__c ship_prog3 = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10', Route__c =route2.Id);
        insert ship_prog3;
        Shipment_Program_Line__c sl=new Shipment_Program_Line__c(Shipments_Program__c=ship_prog3.id);
        insert sl;
        Ship_Service_Consol__c new_ship_service_consol3 = new Ship_Service_Consol__c(Shipment_Service_Line__c = ship_fee_line.Id, Shipments_Program_Service_Line__c = sl.Id);
        insert new_ship_service_consol3;
    }
    
    @isTest
    static void generalTriggers3(){
        NEU_StaticVariableHelper.setBoolean1(true);
        Account carrierAccount = new Account(
            Name = 'Test Carrier',
            Airline_Prefix__c = '123',
            BillingStreet = 'Test Street',
            BillingCity = 'Test City',
            BillingState = 'Test State',
            BillingCountry = 'Test Country'
        );
        insert carrierAccount;
        
        Account shipperAccount = new Account(
            Name = 'Test Shipper',
            BillingStreet = 'Test Street',
            BillingCity = 'Test City',
            BillingState = 'Test State',
            BillingCountry = 'Test Country'
        );
        insert shipperAccount;
        
        Account consigneeAccount = new Account(
            Name = 'Test Consignee',
            BillingStreet = 'Test Street',
            BillingCity = 'Test City',
            BillingState = 'Test State',
            BillingCountry = 'Test Country'
        );
        insert consigneeAccount;
        
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        
        
        Country__c country = new Country__c(Name='test country', ISO_Code__c='EUR');
        insert country;
        
        State__c state = new State__c(Name = 'test state', ISO_Code_2c__c = 'te', country__c = country.Id);
        insert state;
        
        Location__c localizacion = new Location__c(
            Name='test localizacion', 
            City__c='test city', 
            Country__c=country.Id, 
            Subdivision__c='test subdivision', 
            UNLOCODE__c='ABC',
            state__c=state.Id
        );
        insert localizacion;
        
        
        Account supply_chain_test = new Account();
        supply_chain_test.Name = 'Supply Chain Partner Test';
        supply_chain_test.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();        
        supply_chain_test.Airline_Code_Number__c = '020';
        insert supply_chain_test; 
        
        Waybill_Master__c wm = new Waybill_Master__c();
        wm.Starting_Number__c=10;
        wm.Count__c=1;
        wm.Status__c='Open';
        wm.OwnerId=UserInfo.getUserId();
        wm.CurrencyIsoCode='MXN';
        wm.Count__c=1;
        wm.Airline__c=supply_chain_test.Id;
        insert wm;
        
        Air_Waybill__c awb = new Air_Waybill__c(
            Name = 'TEST123456',            
            Serial_Number__c = '456789',
            Airport_of_Departure__c = localizacion.Id,
            Country_of_Departure__c = country.Id,
            Site_of_Destination__c = localizacion.Id,
            Carrier_Account__c = supply_chain_test.Id,
            Shipper_Account__c = shipperAccount.Id,
            Consignee_Account__c = consigneeAccount.Id,             
            Valuation_Charge__c = 50,
            Tax__c = 10,
            Total_Other_Charges_Due_Agent__c = 20,
            Total_Other_Charges_Due__c = 30,            
            Prepaid_Collect_WT_VAL__c = 'Prepaid',
            Prepaid_Collect_Other__c = 'Prepaid',
            Currency__c = 'USD',
            Flight_Number__c = 'FL123',
            Date_of_Flight__c = Date.today(),
            Executed_on_date__c = Date.today(),
            at_place__c = 'Test City',
            Direct_Shipment__c = true,
            Waybill_Master__c=wm.Id                        
        );
        insert awb;
        
        Waybill_Other_Charge__c otherCharge = new Waybill_Other_Charge__c(
            Waybill__c = awb.Id,
            Charge_Amount__c = 20,
            Other_Charges__c = 'SA',
            Recipient_of_Charge_Amount__c = 'A'
        );
        insert otherCharge;
                                        
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=5);
        insert sup_quote_lines;
        
    }
    
}