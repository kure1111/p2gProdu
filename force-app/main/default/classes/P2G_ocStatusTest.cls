@isTest
public class P2G_ocStatusTest {
    @testSetup
    static void Setup(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Arrastre De puerto';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        account_test.Requiere_Acuse_Sap__c = 'Si';
        insert account_test;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Country__c country = new Country__c(Name='Mxico', ISO_Code__c='MEX');
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
        quote.Container_Type__c = container.Id;
        quote.Community_Status__c = 'CUSTOMER CREATED';
        quote.Pricing_Executive__c= userT.Id;
        quote.Operations_Exec__c = userT.Id;
        quote.Purchase_Incoterm__c = 'CFR';
        quote.Sales_Incoterm__c = 'CFR';
        insert quote;
        SAP_Service_Type__c sap = new SAP_Service_Type__c();
        sap.Name = 'INTERNACIONAL AEREO (IC) (A)';
        sap.Code__c = 'A-INT_AEREO_(IC)';
        sap.Group__c = 'SP-FN-FLETE NACIONAL';
        sap.Activo__c = true;
        insert sap;
        String recordTypeI = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c serviceRate = new Fee__c();
        serviceRate.RecordTypeId = recordTypeI;
        serviceRate.Name = 'Flete Nacional'; //
        serviceRate.Route__c = quote.Route__c; 
        serviceRate.CurrencyIsoCode = 'MXN'; 
        serviceRate.Fee_Category__c = 'Road Freights'; 
        serviceRate.Group__c = 'SP-FN-FLETE NACIONAL'; 
        serviceRate.SAP_Service_Type__c = sap.Id; //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        serviceRate.Container_Type__c = container.Id;
        serviceRate.TT_Days__c = '1';
        serviceRate.Rate_Type__c = 'Fixed';
        serviceRate.Account_for__c = account_test.Id;
        serviceRate.Active__c=true;
        serviceRate.Fee_Rate__c = 0;
        serviceRate.Buy_Rate__c = 0;
        serviceRate.Valid_From__c = Date.valueOf('2023-06-12');
        serviceRate.Valid_Until__c = Date.valueOf('2023-06-13');
        insert serviceRate;
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
		serviceLine.Import_Export_Quote__c = quote.Id;
        serviceLine.Name = '003';
        serviceLine.Conversion_Rate_to_Currency_Header__c= integer.valueOf('1');
        serviceLine.Tarifario_ServRate__c = integer.valueOf('1');
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = serviceRate.Id;
        serviceLine.Quote_Sell_Price__c = 0;
        serviceLine.Quote_Buy_Price__c = 0;
        serviceLine.Quote_Buy_Price_Number__c = 12;
        serviceLine.Conversion_Rate_to_Currency_Header__c = 21;
        insert serviceLine;
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
        new_shipment.Traslado_Ingreso__c = 'Ingreso';
        insert new_shipment;
    }
    @isTest
    static void creacionFolioWs(){
        Shipment__c shipment = [SELECT Id FROM Shipment__c limit 1];
        Import_Export_Fee_Line__c serviceLine = [SELECT Id FROM Import_Export_Fee_Line__c limit 1];
        String message = 'OC Creada 0000000 | Estatus: Abierta | '+serviceLine.Id;
        Response__c sapResponse = new Response__c(Shipment__c = shipment.Id,Object__c='Shipment',Type__c='CONFIRM',Message__c=message);
        insert sapResponse;   
    }
        @isTest
    static void altaSap(){
        Shipment__c shipment = [SELECT Id FROM Shipment__c limit 1];
        String message = 'Lead Creado No. : CMTY6892';
        Response__c sapResponse = new Response__c(Shipment__c = shipment.Id,Object__c='Shipment',Type__c='CONFIRM',Message__c=message);
        insert sapResponse;   
    }

}