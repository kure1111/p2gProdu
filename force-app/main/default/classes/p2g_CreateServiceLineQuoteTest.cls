@isTest()
public class p2g_CreateServiceLineQuoteTest {
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
        SAP_Service_Type__c sap = new SAP_Service_Type__c();
        sap.Name = 'SERVICIOS LOGISTICOS FN (IC) (FN)';
        sap.Code__c = 'FN-SERV_LOGISTICO_IC';
        sap.Activo__c = TRUE;
        sap.Group__c = 'SP-FN-FLETE NACIONAL';
        insert sap;
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
        serviceRate.Active__c= True;
        serviceRate.Valid_Until__c = system.today();
        serviceRate.CustomRate__c = True;
        serviceRate.Fee_Rate__c = 5000;
        serviceRate.Buy_Rate__c = 4000;
        insert serviceRate;
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = quote.id;
        serviceLine.Name = '001';
        serviceLine.Conversion_Rate_to_Currency_Header__c= integer.valueOf('1');
        serviceLine.Tarifario_ServRate__c = integer.valueOf('1');
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = serviceRate.Id;
        serviceLine.Quote_Sell_Price__c = 0;
        serviceLine.Quote_Buy_Price__c = 0;
        insert serviceLine;
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.Import_Export_Quote__c = quote.id;
        cargoLine.Name='002';
        //cargoLine.Item_Name__c=cargo.idItem;
        cargoLine.Container_Type__c= container.id;
        //cargoLine.Clave_de_Servicio__c=cargo.idClaveSat;
        //cargoLine.Extension_Item_Name__c=cargo.extencionItemName;
        cargoLine.CurrencyIsoCode='MXN';
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=1;
       	insert cargoLine;
    }
    
    @isTest
    static void createServiceLineQuoteTest() {
        String json = '{"0":{"Account":"HENKEL","ContainerType":"53-FT Tractor Trailer","Id":"a1yDV000001LGZPYA4","Name":"2","SapServiceType":"FLETE NACIONAL (IC) (FN)","seModifica":true,"ServiceRateId":"a0KDV000005VK7c2AG","ServiceRateName":"Flete Nacional","ShipmentBuyPrice":"5600","ShipmentId":"a0JDV000003sbGc2AI","ShipmentName":"SP-FN-23-000783","ShipmentRouteName":"ZM de Chihuahua - Centro","ShipmentSellPrice":"20","Tarifario":false,"TotalVolumen":"80.01999999999999999999999999999996","TotalWeight":"22132.300000000000000000000000000011","AccountId":"0010R000019aZF8QAM","CarrierId":"0014T00000BHiFVQA1"},"1":{"Account":"HENKEL","ContainerType":"53-FT Tractor Trailer","Id":"a1yDV000001LH4OYAW","Name":"3","SapServiceType":"FLETE NACIONAL (IC) (FN)","seModifica":true,"ServiceRateId":"a0KDV000005VK7c2AG","ServiceRateName":"Flete Nacional","ShipmentBuyPrice":"5400","ShipmentId":"a0JDV000003sbGc2AI","ShipmentName":"SP-FN-23-000783","ShipmentRouteName":"ZM de Chihuahua - Centro","ShipmentSellPrice":"42","Tarifario":false,"TotalVolumen":"80.01999999999999999999999999999996","TotalWeight":"22132.300000000000000000000000000011","AccountId":"0010R000019aZF8QAM","CarrierId":"0014T00000BHiFVQA1"},"2":{"Account":"HENKEL","CarrierName":"ALEJANDRO MARTINEZ RAMIREZ","ContainerType":"Caja 53 FT","Id":"a1yDV000001aKTVYA2","Name":"003","SapServiceType":"SERVICIOS LOGISTICOS FN (IC) (FN)","seModifica":true,"ServiceRateId":"a0KDV000005VMo92AG","ServiceRateName":"Flete Nacional","ShipmentBuyPrice":"6000.0000","ShipmentId":"a0JDV000003sbGc2AI","ShipmentName":"SP-FN-23-000783","ShipmentRouteName":"ZM de Chihuahua - Centro","ShipmentSellPrice":"12345.00","Tarifario":true,"TotalVolumen":"80.01999999999999999999999999999996","TotalWeight":"22132.300000000000000000000000000011"}}';
        Customer_Quote__c quote = [SELECT Id, name, Route__c,Account_for__c, FolioResume__c,Total_Volume_m3_2__c,Total_Weight_Kg2__c FROM Customer_Quote__c limit 1];

        List<Fee__c> feeList = [SELECT Id, Name, Route__r.Name, CustomRate__c, Container_Type__r.Name,CurrencyIsoCode,Fee_Category__c,Group__c,
                                       Account_for__r.Name, SAP_Service_Type__r.Name, Fee_Rate__c, Carrier_Account__r.Name,
                                       SAP_Service_Type_Buy__r.Name, Buy_Rate__c, Valid_Until__c, Active__c FROM Fee__c];
        Test.startTest();
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> tarifario = p2g_CreateServiceLineQuote.getRateTarifario(quote.id);
 		P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper rateTarifario = p2g_CreateServiceLineQuote.llenadoTarifario(feeList[0], quote);
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> lines = p2g_CreateServiceLineQuote.getCreaLine(quote.Id);
        List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> lineQuote = p2g_CreateServiceLineQuote.getLineQuote(quote.Id);
        Integer linea = p2g_CreateServiceLineQuote.CalculoNombreLine(quote.Id);
        p2g_CreateServiceLineQuote.quoteFeeLineWrapper quoteFeeLineWrapper = p2g_CreateServiceLineQuote.Create(lines[0]);
        p2g_CreateServiceLineQuote.quoteFeeLineWrapper quoteFeeLineWrapper2 = p2g_CreateServiceLineQuote.rellenaSeccion(lines[0]);
        Fee__c rate = p2g_CreateServiceLineQuote.CreateServiceRate(lines[0]);
        p2g_CreateServiceLineQuote.getSapServiceTypeQuote('SERVICIOS', quote.Id);
        //p2g_CreateServiceLineQuote.quoteFeeLineWrapper response = p2g_CreateServiceLineQuote.CrearLineTarifario(json, 0);
       	Test.stopTest();
    }
}