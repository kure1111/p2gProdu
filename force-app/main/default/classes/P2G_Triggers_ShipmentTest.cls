@isTest
public class P2G_Triggers_ShipmentTest {
    
    @testSetup
    static void setup(){
        NEU_StaticVariableHelper.setBoolean1(true);
        
        Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        insert a;
        
        Account b = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales');
        insert b;
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-FN-Test000';
        insert shipment_test;
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC', IATA_Code__c='IAC');
        insert localizacion;
        /*
Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id,
Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress',
Country_ofLoad__c= Country.Id, Site_of_Load__c =localizacion.Id,Country_ofDischarge__c= Country.Id,
Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');
*/
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name='.';
        quote.Account_for__c = a.Id;
        quote.Team__c = 'P2G';
        quote.Quotation_Status__c = 'Quote being prepared';
        quote.Customer_Reference__c = 'hola soy una prueba';
        quote.Valid_From__c = system.today();
        quote.Valid_Until__c = system.today();
        quote.Comercio_Exterior__c = 'No';
        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'NATIONAL';
        quote.Service_Type__c = 'FTL';
        quote.CurrencyIsoCode = 'MXN';
        quote.ETD__c = Date.today();
        quote.ETA__c = Date.today();
        quote.Community_Status__c = 'CUSTOMER CREATED';
        quote.Pricing_Executive__c= userT.Id;
        quote.Operations_Exec__c = userT.Id;        
        quote.Country_ofLoad__c= Country.Id;
        quote.Site_of_Load__c =localizacion.Id;
        quote.Country_ofDischarge__c= Country.Id;
        quote.Site_of_Discharge__c= localizacion.Id;
        insert quote;
        
        Discount_Rule__c dr = new Discount_Rule__c (Name='test discount' );
          insert dr;

          Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = shipment_test.Id, Name= 'test ship line');
        insert shipline;
                        
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= shipment_test.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
    }
    
    @isTest
    static void NEU_Update_Disbursement_Shipment_Cargo_Lines_Conversion_Rate(){
        Account a=[SELECT Id FROM Account LIMIT 1];
        Account b=[SELECT Id FROM Account LIMIT 1];
        Country__c Country =[SELECT Id FROM Country__c LIMIT 1];
        Location__c localizacion =[SELECT Id FROM Location__c LIMIT 1];
        Shipment__c shipment_test= [SELECT Id FROM Shipment__c LIMIT 1];        
        Fee__c fee =[SELECT Id FROM Fee__c LIMIT 1];
        Customer_Quote__c importexportquote=[SELECT Id FROM Customer_Quote__c LIMIT 1];
                
        Shipment_Line__c shipline =[SELECT Id FROM Shipment_Line__c LIMIT 1];
                        
        Shipment_Fee_Line__c shipfeeline = [SELECT Id FROM Shipment_Fee_Line__c LIMIT 1];
                                      
        //CIFID_UpdateIEQ
        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;
        
        Discount_Rule__c dr=[SELECT Id FROM Discount_Rule__c LIMIT 1];
        
        //NEU_Update_Amount
        Import_Export_Discount_Line__c  iedl = new Import_Export_Discount_Line__c  (Discount_Rule__c = dr.Id, Import_Export_Quote_Order__c = importexportquote.Id , Amount_copy__c =10 , Discount__c = 10 );
        insert iedl ;
        
        Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=shipment_test.Id, Account__c=b.Id, Conversion_Rate_to_Imp_Exp_Currency__c = 1, Import_Export_Quote_Order__c = importexportquote.id);
        insert shipdis;
        
        Disbursement_Line__c dl = new Disbursement_Line__c(Name='Test DL', Disbursement__c=shipdis.Id);
        insert dl;
        
        //NEU_Update_Disbursement_Ship_Lines_Conversion_Rate
        Shipment_Service_Line_Disbursement__c shipDisLine = new Shipment_Service_Line_Disbursement__c(Shipment_Disbursement__c = shipdis.Id, Shipment_Service_Line__c = shipfeeline.Id);
        insert shipDisLine;                
        
        //NEU_Update_Disbursement_Shipment_Cargo_Lines_Conversion_Rate
        Shipment_Item_Line_Disbursement__c shipItemLine = new Shipment_Item_Line_Disbursement__c(Shipment_Disbursement__c = shipdis.Id, Shipment_Item_Line__c = shipline.Id);
        insert shipItemLine;
    }
    
}