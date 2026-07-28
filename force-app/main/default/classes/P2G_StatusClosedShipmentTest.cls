@isTest
public class P2G_StatusClosedShipmentTest {
	@testSetup
    static void objects() {
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Bimbo';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        insert account_test;
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
        
        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';
        direccion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();
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
        new_shipment.Account_Origin_Address__c = address.Id;
        new_shipment.Account_Destination_Address__c = address2.Id; 
        insert new_shipment;
        Fee__c serviceRate = new Fee__c();
        String recordTypefee = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        serviceRate.RecordTypeId = recordTypefee;
        serviceRate.Name = 'Flete Nacional';
        serviceRate.Route__c = quote.Route__c; 
        serviceRate.CurrencyIsoCode = 'MXN'; 
        serviceRate.Fee_Category__c = 'Road Freights'; 
        serviceRate.Group__c = 'SP-FN-FLETE NACIONAL'; 
        //serviceRate.SAP_Service_Type__c = 'a1n4T000001XXYCQA4'; //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        serviceRate.Container_Type__c = container.Id;
        serviceRate.TT_Days__c = '1';
        serviceRate.Rate_Type__c = 'Fixed';
        serviceRate.Account_for__c = account_test.Id;
        serviceRate.Active__c= True;
        serviceRate.Valid_Until__c = system.today();
        serviceRate.CustomRate__c = True;
        //serviceRate.Fee_Rate__c = 5000;
        //serviceRate.Buy_Rate__c = 4000;
        insert serviceRate;
        Shipment_Fee_Line__c serviceLine = new Shipment_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = quote.Id;
        serviceLine.Name = '003';
        serviceLine.Shipment__c = new_shipment.Id;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = serviceRate.Id;
        serviceLine.Shipment_Sell_Price__c = 2000;
        serviceLine.Shipment_Buy_Price__c = 3000;
        serviceLine.Campo_Control__c = false;
        insert serviceLine;
        
        Shipment_Fee_Line__c secondServiceLine = new Shipment_Fee_Line__c();
        secondServiceLine.Import_Export_Quote__c = quote.Id;
        secondServiceLine.Name = '004';
        secondServiceLine.Shipment__c = new_shipment.Id;
        secondServiceLine.CurrencyIsoCode	= 'MXN';
        secondServiceLine.Service_Rate_Name__c = serviceRate.Id;
        secondServiceLine.Shipment_Sell_Price__c = 2000;
        secondServiceLine.Shipment_Buy_Price__c = 3000;
        secondServiceLine.Campo_Control__c = false;
        insert secondServiceLine;
    }
        @isTest
    static void test(){
        NEU_StaticVariableHelper.setBoolean1(true);
        Shipment_Fee_Line__c serviceLine =[SELECT Id, Shipment__c, Campo_Control__c  FROM Shipment_Fee_Line__c WHERE Name LIKE '003' limit 1];
        serviceLine.Campo_Control__c = false;
        update serviceLine;
        //Shipment_Fee_Line__c secondServiceLine =[SELECT Id, Shipment__c, Campo_Control__c  FROM Shipment_Fee_Line__c WHERE Name LIKE '004' limit 1];

        Shipment_Fee_Line__c oldLine = serviceLine.clone(true,true,false,false);
        //Shipment_Fee_Line__c secondOldLine = secondServiceLine;
        
        serviceLine.Campo_Control__c = true;
        update serviceLine;
        
        Map<Id, Shipment_Fee_Line__c> oldMap = new Map<Id, Shipment_Fee_Line__c>{serviceLine.Id => oldLine};
               
        Test.startTest();
        P2G_StatusClosedShipment.closeShipment(new List<Shipment_Fee_Line__c> {serviceLine}, oldMap);
        Test.stopTest();
        
    }
}