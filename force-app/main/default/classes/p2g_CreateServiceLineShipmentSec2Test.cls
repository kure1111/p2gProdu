@isTest
public class p2g_CreateServiceLineShipmentSec2Test {
	@testSetup
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
        Fee__c serviceRate = new Fee__c();
        String recordTypefee = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        serviceRate.RecordTypeId = recordTypefee;
        serviceRate.Name = 'Flete Nacional';
        serviceRate.Route__c = quote.Route__c; 
        serviceRate.CurrencyIsoCode = 'MXN'; 
        serviceRate.Fee_Category__c = 'Road Freights'; 
        serviceRate.Group__c = 'SP-FN-FLETE NACIONAL'; 
        serviceRate.SAP_Service_Type__c = 'a1n4T000001XXYCQA4'; //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        serviceRate.Container_Type__c = container.Id;
        serviceRate.TT_Days__c = '1';
        serviceRate.Rate_Type__c = 'Fixed';
        serviceRate.Account_for__c = account_test.Id;
        serviceRate.Active__c=true;
        serviceRate.Fee_Rate__c = 5000;
        serviceRate.Buy_Rate__c = 4000;
        insert serviceRate;
        Shipment_Fee_Line__c serviceLine = new Shipment_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = quote.Id;
        serviceLine.Name = '003';
        serviceLine.Shipment__c = new_shipment.Id;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = serviceRate.Id;
        serviceLine.Shipment_Sell_Price__c = 2000;
        serviceLine.Shipment_Buy_Price__c = 3000;
        insert serviceLine;
    }
    @isTest
    static void prueba(){
        Shipment_Fee_Line__c Line = [
            SELECT Id, Name, Service_Rate_Name__c, Service_Rate_Name__r.Name,Service_Rate_Name__r.Account_for__c,Import_Export_Quote__c,
            Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.Container_Type__r.Name,Shipment__c,Service_Rate_Name__r.SAP_Service_Type__c
            FROM Shipment_Fee_Line__c WHERE Shipment__r.Name =: 'SP-FN-23-000783' limit 1];
        String json = '{"0":{"Account":"'+line.Service_Rate_Name__r.Account_for__r.Name+'","AccountId":"'+line.Service_Rate_Name__r.Account_for__c+'","Activo":false,"BuyRate":"0.00","'+
            'ContainerType":"'+line.Service_Rate_Name__r.Container_Type__r.Name+'","FeeCategory":"Road Freights","Id":"'+line.Id+'","'+
            'IdQuote":"'+line.Import_Export_Quote__c+'","ShipmentId":"'+line.Shipment__c+'","Moneda":"MXN","Name":"003","SapServiceType":"FLETE NACIONAL (IC) (FN)","'+
            'SapServiceTypeId":"'+line.Service_Rate_Name__r.SAP_Service_Type__c+'","SellRate":"10000.00","seModifica":true,"ServiceRateId":"'+line.Service_Rate_Name__c+'","ServiceRateName":"Flete Nacional","TotalVolume":"1.00","TotalWeight":"1.0000","ShipmentRouteName":"ZM de Monterrey - ZM de Mexicali","ShipmentSellPrice":"1.00","ValidUntil":"2023-07-11"}}';
        String json2 = '{"0":{"Account":"HENKEL","AccountId":"0010R000019aZF8QAM","Activo":true,"BuyRate":"10355.00","CarrierId":"0014T00000EI8xsQAD","CarrierName":"FLETES LUEDAN DEL DESIERTO SA DE CV","ContainerType":"Caja 53 FT","ContainerTypeId":"a0F4T000000R9qxUAC","FeeCategory":"Road Freights","Grou":"SP-FN-FLETE NACIONAL","Id":"a0KDV000005NiGQ2A0","IdQuote":"a0JDV000003wqrh2AA","Moneda":"MXN","SapServiceType":"SERVICIOS LOGISTICOS FN (IC) (FN)","SapServiceTypeBuy":"FLETE NACIONAL (IC) (FN)","SapServiceTypeBuyId":"a1n0R000001lZceQAE","SapServiceTypeId":"a1n0R000001lZckQAE","SellRate":"0.00","seModifica":true,"ServiceRateName":"Flete Nacional","ShipmentId":"2.00","ShipmentName":"2.0000","ShipmentRouteId":"a0EDV0000049aX72AI","ShipmentRouteName":"ZM de Acapulco - ZM de Acayucan","Tarifario":true,"ValidUntil":"2023-12-31"}}';
        Test.startTest();
        List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> creaelinea = p2g_CreateServiceLineShipmentSec2.CrearLineQuote(json, 0);
        List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> creaelinea2 = p2g_CreateServiceLineShipmentSec2.CrearLineQuote(json2, 0);
        Test.stopTest();
    }
}