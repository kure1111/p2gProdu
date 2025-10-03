@isTest
public class P2G_Trigger_Shipment_Fee_LineTest {    
    
    public static Boolean isUAT=false;       
    
    static Boolean isUAT() {
        isUAT=[SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        return isUAT;
    }
    
    @testSetup
    static void setup(){
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
        //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        
        //UAT
        //serviceRate.SAP_Service_Type__c = 'a1n0R000001lZceQAE';    
        
        //PROD
        serviceRate.SAP_Service_Type__c = 'a1n4T000001XXYCQA4';    
        
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
        
        
        Fee__c serviceRate2 = new Fee__c();        
        serviceRate2.RecordTypeId = recordTypefee;
        serviceRate2.Name = 'Flete Nacional';
        serviceRate2.Route__c = quote.Route__c; 
        serviceRate2.CurrencyIsoCode = 'MXN'; 
        serviceRate2.Fee_Category__c = 'Road Freights'; 
        serviceRate2.Group__c = 'SP-FN-FLETE NACIONAL'; 
        //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
        
        //UAT
        //serviceRate2.SAP_Service_Type__c = 'a1n0R000001lZceQAE';    
        
        //PROD
        serviceRate2.SAP_Service_Type__c = 'a1n4T000001XXYCQA4';            
        serviceRate2.Container_Type__c = container.Id;
        serviceRate2.TT_Days__c = '1';
        serviceRate2.Rate_Type__c = 'Fixed';
        serviceRate2.Account_for__c = account_test.Id;
        serviceRate2.Active__c= True;
        serviceRate2.Valid_Until__c = system.today();
        serviceRate2.CustomRate__c = True;
        serviceRate2.Fee_Rate__c = 5000;
        serviceRate2.Buy_Rate__c = 4000;
        serviceRate2.Rate_Type__c='% of Charge';
        insert serviceRate2;
        
        
        Fee__c serviceRateFixed = new Fee__c();        
        serviceRateFixed.RecordTypeId = recordTypefee;
        serviceRateFixed.Name = 'Flete Nacional - Fijo';
        serviceRateFixed.Route__c = quote.Route__c; 
        serviceRateFixed.CurrencyIsoCode = 'MXN'; 
        serviceRateFixed.Fee_Category__c = 'Road Freights'; 
        serviceRateFixed.Group__c = 'SP-FN-FLETE NACIONAL'; 
        //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4        
        //UAT
        //serviceRateFixed.SAP_Service_Type__c = 'a1n0R000001lZceQAE';    
        
        //PROD
        serviceRateFixed.SAP_Service_Type__c = 'a1n4T000001XXYCQA4';           
        serviceRateFixed.Container_Type__c = container.Id;
        serviceRateFixed.TT_Days__c = '1';
        serviceRateFixed.Rate_Type__c = 'Fixed';
        serviceRateFixed.Account_for__c = account_test.Id;
        serviceRateFixed.Active__c= True;
        serviceRateFixed.Valid_Until__c = system.today();
        serviceRateFixed.CustomRate__c = True;
        serviceRateFixed.Fee_Rate__c = 5000;
        serviceRateFixed.Buy_Rate__c = 4000;
        insert serviceRateFixed;
        
        Fee__c serviceRatePercentage = new Fee__c();        
        serviceRatePercentage.RecordTypeId = recordTypefee;
        serviceRatePercentage.Name = 'Flete Nacional - Porcentual';
        serviceRatePercentage.Route__c = quote.Route__c; 
        serviceRatePercentage.CurrencyIsoCode = 'MXN'; 
        serviceRatePercentage.Fee_Category__c = 'Road Freights'; 
        serviceRatePercentage.Group__c = 'SP-FN-FLETE NACIONAL';         
        //UAT
        //serviceRatePercentage.SAP_Service_Type__c = 'a1n0R000001lZceQAE';    
        
        //PROD
        serviceRatePercentage.SAP_Service_Type__c = 'a1n4T000001XXYCQA4';    
        
        serviceRatePercentage.Container_Type__c = container.Id;
        serviceRatePercentage.TT_Days__c = '1';
        serviceRatePercentage.Rate_Type__c = '% of Charge';
        serviceRatePercentage.Account_for__c = account_test.Id;
        serviceRatePercentage.Active__c= True;
        serviceRatePercentage.Valid_Until__c = system.today();
        serviceRatePercentage.CustomRate__c = True;
        serviceRatePercentage.Fee_Rate__c = 10; // 10%
        serviceRatePercentage.Buy_Rate__c = 5;  // 5%
        insert serviceRatePercentage;
    }
    
    
    
    @isTest
    static void Cifid_ShipLines(){
        isUAT();
        Customer_Quote__c quote= [SELECT Id FROM Customer_Quote__c LIMIT 1];
        Shipment__c new_shipment=[SELECT Id FROM Shipment__c LIMIT 1];
        Fee__c serviceRate = [SELECT Id FROM Fee__c WHERE Rate_Type__c!='% of Charge' LIMIT 1];
        
        Shipment_Fee_Line__c serviceLine = new Shipment_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = quote.Id;
        serviceLine.Name = '003';
        serviceLine.Shipment__c = new_shipment.Id;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = serviceRate.Id;
        serviceLine.Shipment_Sell_Price__c = 2000;
        serviceLine.Shipment_Buy_Price__c = 3000;
        insert serviceLine;
        
        serviceLine.Shipment_Buy_Price__c = 200;
        update serviceLine;
        
    }
    
    @isTest
    static void NEU_Shipment_Fee_Line_Principal_delete(){
        isUAT();
        Customer_Quote__c quote= [SELECT Id FROM Customer_Quote__c LIMIT 1];
        Shipment__c new_shipment=[SELECT Id FROM Shipment__c LIMIT 1];
        Fee__c serviceRate = [SELECT Id FROM Fee__c WHERE Rate_Type__c='% of Charge' LIMIT 1];
        
        Shipment_Fee_Line__c serviceLineDelete = new Shipment_Fee_Line__c();
        serviceLineDelete.Import_Export_Quote__c = quote.Id;
        serviceLineDelete.Name = '003';
        serviceLineDelete.Shipment__c = new_shipment.Id;
        serviceLineDelete.CurrencyIsoCode	= 'MXN';
        serviceLineDelete.Service_Rate_Name__c = serviceRate.Id;
        serviceLineDelete.Shipment_Sell_Price__c = 2000;
        serviceLineDelete.Shipment_Buy_Price__c = 3000;        
        insert serviceLineDelete;
        
        
        
        delete serviceLineDelete;
    }
    /*
@isTest
static void NEU_Shipment_Fee_Line_Principal_update(){
Customer_Quote__c quote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
Shipment__c new_shipment = [SELECT Id FROM Shipment__c LIMIT 1];
Fee__c serviceRateFixed = [SELECT Id FROM Fee__c WHERE Rate_Type__c = 'Fixed' LIMIT 1];

// Crear línea de servicio principal
Shipment_Fee_Line__c serviceLine = new Shipment_Fee_Line__c(
Import_Export_Quote__c = quote.Id,
Name = 'Principal',
Shipment__c = new_shipment.Id,
CurrencyIsoCode = 'MXN',
Service_Rate_Name__c = serviceRateFixed.Id,
Sell_Amount__c = 2000,
Std_Buy_Amount__c = 1500,
Shipment_Sell_Price__c = 2000,
Shipment_Buy_Price__c = 1500
);
insert serviceLine;

// Crear línea de cargo porcentual relacionada
Fee__c serviceRatePercentage = [SELECT Id FROM Fee__c WHERE Rate_Type__c = '% of Charge' LIMIT 1];
Shipment_Fee_Line__c percentageLine = new Shipment_Fee_Line__c(
Import_Export_Quote__c = quote.Id,
Name = 'Porcentual',
Shipment__c = new_shipment.Id,
CurrencyIsoCode = 'MXN',
Service_Rate_Name__c = serviceRatePercentage.Id,
Service_Rate__c = 10, // 10%
Shipment_Service_Line__c = serviceLine.Id,
Rate_Type__c = '% of Charge'
);
insert percentageLine;

Test.startTest();
// Actualizar la línea principal para disparar el trigger
serviceLine.Sell_Amount__c = 3000;
serviceLine.Std_Buy_Amount__c = 2000;
serviceLine.Shipment_Buy_Price__c = 1800; // Cambiar también este valor para cubrir esa condición
update serviceLine;
Test.stopTest();
}
*/
}