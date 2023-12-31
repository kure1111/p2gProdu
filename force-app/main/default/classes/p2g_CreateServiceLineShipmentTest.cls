@isTest
public class p2g_CreateServiceLineShipmentTest {
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
        /*Shipment_Line__c cargo = new Shipment_Line__c();
        cargo.Shipment__c = new_shipment.id;
        cargo.Name='002';
        cargo.Container_Type__c= container.id;
        cargo.CurrencyIsoCode='MXN';
        cargo.Units_Shipped__c=1;
       	insert cargo;*/
    }
    @isTest
    static void prueba(){
        String json = '{"0":{"Account":"HENKEL","AccountId":"0010R000019aZF8QAM","Activo":true,"BuyRate":"10355.00","CarrierId":"0014T00000EI8xsQAD","CarrierName":"FLETES LUEDAN DEL DESIERTO SA DE CV","ContainerType":"Caja 53 FT","ContainerTypeId":"a0F4T000000R9qxUAC","FeeCategory":"Road Freights","Grou":"SP-FN-FLETE NACIONAL","Id":"a0KDV000005NiGQ2A0","IdQuote":"a0JDV000003wqrh2AA","Moneda":"MXN","SapServiceType":"SERVICIOS LOGISTICOS FN (IC) (FN)","SapServiceTypeBuy":"FLETE NACIONAL (IC) (FN)","SapServiceTypeBuyId":"a1n0R000001lZceQAE","SapServiceTypeId":"a1n0R000001lZckQAE","SellRate":"0.00","seModifica":true,"ServiceRateName":"Flete Nacional","ShipmentId":"2.00","ShipmentName":"2.0000","ShipmentRouteId":"a0EDV0000049aX72AI","ShipmentRouteName":"ZM de Acapulco - ZM de Acayucan","Tarifario":true,"ValidUntil":"2023-12-31"}}';
        Customer_Quote__c quote =[SELECT Id FROM Customer_Quote__c limit 1];
        Shipment_Fee_Line__c serviceLine =[SELECT Id, Shipment__c FROM Shipment_Fee_Line__c limit 1]; 
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
        wrapper.IdQuote=quote.Id;
        wrapper.Moneda='MXN';
        wrapper.ServiceRateId='a0K0R000004R6aAUAS';
        wrapper.SellRate='12';
        wrapper.BuyRate='12';
        Test.startTest();
        Fee__c aux = p2g_CreateServiceLineShipment.updateRate(wrapper); 
        Shipment_Fee_Line__c shipmentserviceLine = new Shipment_Fee_Line__c();
        shipmentserviceLine.Name = '00';
        shipmentserviceLine.Units__c = 1;
        shipmentserviceLine.CurrencyIsoCode	= 'MXN';
        shipmentserviceLine.Shipment_Sell_Price__c = 12.5;
        shipmentserviceLine.Shipment_Buy_Price__c = 12.4;
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper complementoWrapperLine = p2g_CreateServiceLineShipment.completeFieldsShowLine(wrapper,shipmentserviceLine,aux);
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper line = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
        quote.Last_Shipment__c = serviceLine.Shipment__c;
        quote.Id = quote.Id;
        Update quote;
        Shipment_Fee_Line__c serviceLinee = p2g_CreateServiceLineShipment.CreateServiceLine(5,wrapper);
        Integer inte = p2g_CreateServiceLineShipment.CalculoNombreLine(quote.Id);
        List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> quoteFeeLines = p2g_CreateServiceLineShipment.getLineShip(serviceLine.Shipment__c);
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> lsit = p2g_CreateServiceLineShipment.getRateTarifario(serviceLine.Shipment__c);
        Fee__c fee = new Fee__c();
            fee.Name = 'x';
            fee.Route__c='a0E0R000003e3hIUAQ';
            fee.CustomRate__c= true;
            fee.Container_Type__c='a0F4T000000R9qQUAS';
            fee.Account_for__c='a0E0R000003e3hIUAQ';
            fee.SAP_Service_Type__c='a1n0R000001lZceQAE';
            fee.Fee_Rate__c=12.4;
            fee.Carrier_Account__c='0010R000019aZF8QAM';
            fee.SAP_Service_Type_Buy__c='a1n0R000001lZceQAE';
            fee.Buy_Rate__c=12.4;
            fee.Active__c=true;
            fee.CurrencyIsoCode='MXN';
            fee.Fee_Category__c='Road';
        Customer_Quote__c ship = new Customer_Quote__c();
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrappeFee = p2g_CreateServiceLineShipment.rellenaFee(fee,ship);
        Import_Export_Fee_Line__c serviceLineQuote = new Import_Export_Fee_Line__c();
        serviceLineQuote.Quote_Sell_Price__c=12.5;
        serviceLineQuote.Quote_Buy_Price__c=13.5;
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wraper2 = p2g_CreateServiceLineShipment.rellena2(serviceLineQuote,'232d3');
        p2g_CreateServiceLineShipment.getLineQuote(serviceLine.Shipment__c);
        Shipment_Line__c shipmentLine = new Shipment_Line__c();
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wraper4 = p2g_CreateServiceLineShipment.rellena4(shipmentLine,2,'Idsasa');
        //List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper>getCreaLine = p2g_CreateServiceLineShipment.getCreaLine(serviceLine.Shipment__c);
        List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> CrearLineTarifario = p2g_CreateServiceLineShipment.CrearLineTarifario(json,0);
        Test.stopTest();
    }
}