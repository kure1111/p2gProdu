@isTest
public class NEU_Import_export_Update_Route_Test {
    /*
@isTest
static void NEU_Import_export_Update_Route2()
{
Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
User us = TestDataFactory.createUserAdmin();
List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,');
Account a = list_accounts[0];
a.Segment__c = 'Nuevo';
a.ActiveSap__c = true;
insert a;
Account sup = list_accounts[1];
sup.Segment__c = 'Nuevo';
sup.ActiveSap__c = true;
insert sup;
Country__c Country = new Country__c(Name='test country1',  ISO_Code__c='EUR');
insert Country;
Country__c Country2 = new Country__c(Name='test country2',  ISO_Code__c='EUR');
insert Country2;
Country__c Country3 = new Country__c(Name='test country3',  ISO_Code__c='EUR');
insert Country3;
Country__c Country4 = new Country__c(Name='test country4',  ISO_Code__c='EUR');
insert Country4;
Location__c localizacion = new Location__c(Name='test localizacion1', City__c='test city1', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
insert localizacion;
Location__c localizacion2 = new Location__c(Name='test localizacion2', City__c='test city2', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
insert localizacion2;
Location__c localizacion3 = new Location__c(Name='test localizacion3', City__c='test city3', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
insert localizacion3;
Location__c localizacion4 = new Location__c(Name='test localizacion3', City__c='test city4', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
insert localizacion4;
Location__c localizacion5 = new Location__c(Name='test localizacion4', City__c='test city5', Country__c= country3.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
insert localizacion5;
Location__c localizacion6 = new Location__c(Name='test localizacion5', City__c='test city6', Country__c= country4.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
insert localizacion6;
Carrier_Line_Load_Point__c route_leg1 = new Carrier_Line_Load_Point__c(Name='test1',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country2.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion2.Id );
insert route_leg1;
Carrier_Line_Load_Point__c route_leg2 = new Carrier_Line_Load_Point__c(Name='test2',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion3.Id, Port_Airport_of_Load__c=localizacion3.Id);
insert route_leg2;
Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test31',  Country_of_Discharge__c=Country3.Id, Country_of_Load__c=Country3.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id);
insert route;

//Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
insert importexportquote;
Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
insert quote;

Fee__c service_rate = new Fee__c();
service_rate.Name = 'Sercie Rate Test';
service_rate.Fee_Category__c = 'Disbursement';
service_rate.Rate_Type__c = 'Per Kg';
service_rate.Account_for__c = a.Id;
insert service_rate;

Import_Export_Fee_Line__c ie_service_line = new Import_Export_Fee_Line__c();
ie_service_line.Import_Export_Quote__c = importexportquote.Id;
ie_service_line.Name = '001';
ie_service_line.Service_Rate_Name__c = service_rate.Id;
ie_service_line.Extension_Service_Name__c = 'Test Name';
ie_service_line.Discount__c = 10;
ie_service_line.Quote_Buy_Price__c = 10;
ie_service_line.Quote_Sell_Price__c = 10;
ie_service_line.Units__c = 10;
insert ie_service_line;

importexportquote.Quotation_Status__c ='Approved as Succesful';
importexportquote.Site_of_Discharge__c = null;
update importexportquote;

//Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
insert importexportquote2;
Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items',Units__c=10);
insert quote2;

Import_Export_Fee_Line__c ie_service_line2 = new Import_Export_Fee_Line__c();
ie_service_line2.Import_Export_Quote__c = importexportquote2.Id;
ie_service_line2.Name = '001';
ie_service_line2.Service_Rate_Name__c = service_rate.Id;
ie_service_line2.Extension_Service_Name__c = 'Test Name';
ie_service_line2.Discount__c = 10;
ie_service_line2.Quote_Buy_Price__c = 10;
ie_service_line2.Quote_Sell_Price__c = 10;
ie_service_line2.Units__c = 10;
insert ie_service_line2;

importexportquote2.Quotation_Status__c ='Approved as Succesful';
update importexportquote2;


}
*/
    
    @testSetup    
    static void setup(){
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        
        Shipment__c ship = new Shipment__c();
        ship.Name='SP-FN-Test000';
        ship.Account_for__c = a.Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';        
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
        Country__c country = new Country__c(Name='Mexico');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='xalapa', State__c=state.Id,Country__c=country.Id);
        insert location;
        Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country2;
        Country__c Country3 = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country3;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Location__c localizacion2 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion2;
        Location__c localizacion3 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion3;
        Location__c localizacion4 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion4;
        Location__c localizacion5 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country3.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion5;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='testName',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        
        Fee__c service_rate = new Fee__c();
        service_rate.Name = 'Sercie Rate Test';
        service_rate.Fee_Category__c = 'Disbursement';
        service_rate.Rate_Type__c = 'Per Kg';
        service_rate.Account_for__c = a.Id;
        insert service_rate;
    }
    @isTest
    static void NEU_Import_export_Update_Route(){
        Account a=[SELECT Id FROM Account WHERE RecordType.DeveloperName='Customer' LIMIT 1];
        Account sup=[SELECT Id FROM Account WHERE RecordType.DeveloperName='Transporter' LIMIT 1];
        Location__c location=[SELECT Id, State__c, Country__c FROM Location__c LIMIT 1];
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Route__c = route.Id, Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Quote being prepared', Route__c = route.Id, Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        //insert importexportquote;
        
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        
        Customer_Quote__c importexportquote = new Customer_Quote__c();        
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();        
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name='.';
        importexportquote.Account_for__c = a.Id;
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
        importexportquote.Country_ofLoad__c = location.Country__c;
        importexportquote.State_of_Load__c = location.State__c;
        importexportquote.Site_of_Load__c = location.Id;
        importexportquote.Country_ofDischarge__c = location.Country__c;
        importexportquote.State_of_Discharge__c = location.State__c;
        importexportquote.Site_of_Discharge__c = location.Id;
        insert importexportquote;
        
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        
        Fee__c service_rate = new Fee__c();
        service_rate.Name = 'Sercie Rate Test';
        service_rate.Fee_Category__c = 'Disbursement';
        service_rate.Rate_Type__c = 'Per Kg';
        service_rate.Account_for__c = a.Id;
        insert service_rate;
        
        Import_Export_Fee_Line__c ie_service_line = new Import_Export_Fee_Line__c();
        ie_service_line.Import_Export_Quote__c = importexportquote.Id;
        ie_service_line.Name = '001';
        ie_service_line.Service_Rate_Name__c = service_rate.Id;
        ie_service_line.Extension_Service_Name__c = 'Test Name';
        ie_service_line.Discount__c = 10;
        ie_service_line.Quote_Buy_Price__c = 10;
        ie_service_line.Quote_Sell_Price__c = 10;
        ie_service_line.Units__c = 10;
        insert ie_service_line;                
        
    }
    
    
    
    /*@isTest
    static void NEU_Import_export_Update_Route2()
    {
        Account a=[SELECT Id FROM Account WHERE RecordType.DeveloperName='Customer' LIMIT 1];
        Account sup=[SELECT Id FROM Account WHERE RecordType.DeveloperName='Transporter' LIMIT 1];
        Country__c country=[SELECT Id FROM Country__c LIMIT 1];
        Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country2;
        List<Location__c> localizacion=[SELECT Id, State__c, Country__c FROM Location__c LIMIT 2];
        Carrier_Line_Load_Point__c route_leg1 = new Carrier_Line_Load_Point__c(Name='tes45t',  Country_of_Discharge__c=country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion[0].Id, Port_Airport_of_Load__c=localizacion[0].Id );
        insert route_leg1;
        Carrier_Line_Load_Point__c route_leg2 = new Carrier_Line_Load_Point__c(Name='test09u',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion[1].Id, Port_Airport_of_Load__c=localizacion[0].Id);
        insert route_leg2;
        
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        
        Customer_Quote__c importexportquote = new Customer_Quote__c();        
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();        
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name='.';
        importexportquote.Account_for__c = a.Id;
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
        importexportquote.Country_ofLoad__c = localizacion[0].Country__c;
        importexportquote.State_of_Load__c = localizacion[0].State__c;
        importexportquote.Site_of_Load__c = localizacion[0].Id;
        importexportquote.Country_ofDischarge__c = localizacion[0].Country__c;
        importexportquote.State_of_Discharge__c = localizacion[0].State__c;
        importexportquote.Site_of_Discharge__c = localizacion[0].Id;
        insert importexportquote;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        
        Fee__c service_rate = new Fee__c();
        service_rate.Name = 'Sercie Rate Test';
        service_rate.Fee_Category__c = 'Disbursement';
        service_rate.Rate_Type__c = 'Per Kg';
        service_rate.Account_for__c = a.Id;
        insert service_rate;
        
        Import_Export_Fee_Line__c ie_service_line = new Import_Export_Fee_Line__c();
        ie_service_line.Import_Export_Quote__c = importexportquote.Id;
        ie_service_line.Name = '001';
        ie_service_line.Service_Rate_Name__c = service_rate.Id;
        ie_service_line.Extension_Service_Name__c = 'Test Name';
        ie_service_line.Discount__c = 10;
        ie_service_line.Quote_Buy_Price__c = 10;
        ie_service_line.Quote_Sell_Price__c = 10;
        ie_service_line.Units__c = 10;
        insert ie_service_line;
        
        importexportquote.Quotation_Status__c ='Approved as Succesful';
        importexportquote.Site_of_Discharge__c = null;
        update importexportquote;
        
        /*
//Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id);
Customer_Quote__c importexportquote2 = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c='Quote being prepared', Site_of_Load__c = localizacion.Id, Site_of_Discharge__c = localizacion3.Id , Country_ofLoad__c= Country.Id , Country_ofDischarge__c = Country2.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
insert importexportquote2;
Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items',Units__c=10);
insert quote2;

Import_Export_Fee_Line__c ie_service_line2 = new Import_Export_Fee_Line__c();
ie_service_line2.Import_Export_Quote__c = importexportquote2.Id;
ie_service_line2.Name = '001';
ie_service_line2.Service_Rate_Name__c = service_rate.Id;
ie_service_line2.Extension_Service_Name__c = 'Test Name';
ie_service_line2.Discount__c = 10;
ie_service_line2.Quote_Buy_Price__c = 10;
ie_service_line2.Quote_Sell_Price__c = 10;
ie_service_line2.Units__c = 10;
insert ie_service_line2;

importexportquote2.Quotation_Status__c ='Approved as Succesful';
update importexportquote2;

        
    }    
*/
}