@isTest
public class P2G_NEU_Standard_Fee_Cal_Imp_ExpTest {
    @isTest(SeeAllData=true)
    static void NEU_Standard_Fee_Calculation_Imp_Exp(){
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();        	
        insert a;        
        Account sup= new Account();
        sup.Name='Test';
        sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();        	
        insert sup;               
        
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion =new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test11',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Customer_Quote__c importexportquote = [SELECT Id,Name,Site_of_Load__c, Pickup_Cartage__c,Delivery_Cartage__c,Total_Volume_m3_2__c,Total_Weight_Kg2__c,Route__c
        FROM Customer_Quote__c 
        WHERE Margen_Operativo__c!=null AND Pricing_Executive__c!=null AND Site_of_Load__c!=null LIMIT 1];
        /*
        new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Route__c=route.Id, Only_Warehouse_Service__c = true, Pricing_Executive__c=Userinfo.getUserId());
        insert importexportquote;
        */
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000,CurrencyIsoCode='MXN');
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote_fee;
        Fee__c fee1 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee1;
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee2;
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee3;
        
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee4; 
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee5; 
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee6; 
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee7; 
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee8; 
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee9; 
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee10; 
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee11; 
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        insert fee12; 
        Fee__c fee13 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1, Account_for__c = a.Id);
        insert fee13; 
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1, Account_for__c = a.Id);
        insert fee14; 
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1, Account_for__c = a.Id);
        insert fee15;  
        NEU_Standard_Fee_Calculation_Imp_Exp ie = new NEU_Standard_Fee_Calculation_Imp_Exp(new ApexPages.StandardController( importexportquote ));
        ie.crear_fee_estandar();
        ie.cancel();
        
    }
    
    @isTest(SeeAllData=true)
    static void test_CalculateFeeLines(){
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();        	
        insert acc;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion =new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test22',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = acc.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= acc.Id ,  
                                                  HS_Code_Text__c='56489');
        insert g;
    }
    
    @isTest(SeeAllData=true)
    static void testCancelMethod() {        
        Customer_Quote__c testQuote = [SELECT Id FROM Customer_Quote__c LIMIT 1];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        NEU_Standard_Fee_Calculation_Imp_Exp controller = new NEU_Standard_Fee_Calculation_Imp_Exp(stdController);
        
        PageReference result = controller.cancel();                
    }
    
    @isTest(SeeAllData=true)
    static void testSuccess(){
        NEU_StaticVariableHelper.setBoolean1(true);
        
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();        	
        insert a;        
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Account sup= new Account();
        sup.Name='Test';
        sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();        	
        insert sup; 
        
        Price_List__c b = new Price_List__c(Name = 'Test account', Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;    
        
        Product_Family__c c = new Product_Family__c(Name = 'Test product family', Business_Area__c = 'Auto-Parts');
        insert c;    
        
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item', Subfamily__c = d.Id, 
                                                  Sourcing_Family__c = c.id, Account_Owner__c = a.Id, HS_Code_Text__c = '56489');
        insert g;
        
        Country__c Country = new Country__c(Name = 'test country1', ISO_Code__c = 'EUR');
        insert Country;
        
        Location__c localizacion =new Location__c(Name='test localizacion1', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route =[SELECT Id FROM Carrier_Line_Load_Point__c LIMIT 1];
        
        /*        
Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name = 'test001', 
Country_of_Discharge__c = Country.Id, 
Country_of_Load__c = Country.Id, 
Port_Airport_of_Discharge__c = localizacion.Id, 
Port_Airport_of_Load__c = localizacion.Id);
insert route;
*/
        Delivery_Zone__c zone = new Delivery_Zone__c(Kms__c=10,Miles__c=20,Port_Airport__c=localizacion.Id,Test_upload__c=true);
        insert zone;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c(Pricing_Executive__c=userinfo.getUserId(),
                                                                    Quotation_Status__c ='Sent awaiting response', Catalog_Price_List__c= b.id, 
                                                                    Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');
        insert importexportquote;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(
            Import_Export_Quote__c = importexportquote.id,
            Name = 'lineas items', 
            Item_Name__c = g.Id, 
            Customs_Value__c = 1000,
            CurrencyIsoCode = 'MXN',
            Total_Shipping_Volume_m3__c=100,
            Total_Shipping_Weight_Kgs__c=100
            
        );
        insert quote;
        
        Fee__c fee = new Fee__c(
            Name = 'test fees', 
            Fee_Category__c = 'Disbursement', 
            Rate_Type__c = 'Fixed', 
            Account_for__c = a.Id,
            Standard_Rate__c = true,
            Active__c = true
        );
        insert fee;
        
        Fee__c fee1 = new Fee__c(
            Name = 'Local Transport Per Container', 
            Fee_Category__c = 'Disbursement',  
            Active__c = true, 
            RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), 
            Rate_Type__c = 'Fixed', 
            Standard_Rate__c = true, 
            Account_for__c = a.Id,
            Port_Airport__c = localizacion.Id,            
            Applicable_to_Purchase_Incoterms__c = 'FOB;EXW',
            Applicable_to_Sales_Incoterms__c = 'CIF;CIP',
            Fee_Rate__c = 100
        );
        insert fee1;
        
        Fee__c fee2 = new Fee__c(
            Name = 'Sea Freight Per Container', 
            Fee_Category__c = 'Disbursement',  
            Active__c = true, 
            RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), 
            Rate_Type__c = 'Per Container', 
            Standard_Rate__c = true, 
            Account_for__c = a.Id,
            Route__c = route.Id,
            Fee_Rate__c = 200
        );
        insert fee2;
        
        Fee__c fee3 = new Fee__c(
            Name = 'Other Charges Per Container', 
            Fee_Category__c = 'Disbursement',  
            Active__c = true, 
            RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), 
            Rate_Type__c = 'Per Container', 
            Standard_Rate__c = true, 
            Account_for__c = a.Id,
            Fee_Rate__c = 300
        );
        insert fee3;
        
        List<String> rateTypes = new List<String>{'Per Kg', 'Per TON', 'Per M3', 'Per Pallet'};
            List<Fee__c> additionalFees = new List<Fee__c>();
        
        for(String rt : rateTypes) {            
            additionalFees.add(new Fee__c(
                Name = 'Local Transport ' + rt,
                Fee_Category__c = 'Disbursement',
                Active__c = true,
                RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(),
                Rate_Type__c = rt,
                Standard_Rate__c = true,
                Account_for__c = a.Id,
                Port_Airport__c = localizacion.Id,                
                Fee_Rate__c = 50
            ));
            
            additionalFees.add(new Fee__c(
                Name = 'Sea Freight ' + rt,
                Fee_Category__c = 'Disbursement',
                Active__c = true,
                RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(),
                Rate_Type__c = rt,
                Standard_Rate__c = true,
                Account_for__c = a.Id,
                Route__c = route.Id,
                Fee_Rate__c = 75
            ));
            
            additionalFees.add(new Fee__c(
                Name = 'Other Charges ' + rt,
                Fee_Category__c = 'Disbursement',
                Active__c = true,
                RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(),
                Rate_Type__c = rt,
                Standard_Rate__c = true,
                Account_for__c = a.Id,
                Fee_Rate__c = 100
            ));
        }
        
        Container_Type__c containerType = new Container_Type__c(
            Name = '20ft Container',
            Cargo_Weight_Kg__c = 28000,
            Cargo_Volume_m3__c = 33
        );
        insert containerType;
        
        Pallet_Type__c palletType = new Pallet_Type__c(
            Name = 'Standard Pallet',
            Cargo_Weight_Kg__c = 1000,
            Cargo_Volume_m3__c = 1.2
        );
        insert palletType;
        
        for(Fee__c f : additionalFees) {
            if(f.Rate_Type__c == 'Per Container') {
                f.Container_Type__c = containerType.Id;
            } else if(f.Rate_Type__c == 'Per Pallet') {
                f.Pallet_Type__c = palletType.Id;
            }
        }
        insert additionalFees;
        
        Fee__c airFee1 = new Fee__c(
            Name = 'Air Freight Per Kg',
            Fee_Category__c = 'Disbursement',
            Active__c = true,
            RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(),
            Rate_Type__c = 'Per Kg',
            Standard_Rate__c = true,
            Fuel__c = 100,
            Risk__c = 100,
            Normal__c = 10,
            Volumetric_Factor__c = 1,
            Account_for__c = a.Id,
            Fee_Rate__c = 5
        );
        
        Fee__c airFee2 = new Fee__c(
            Name = 'Air Freight Per TON',
            Fee_Category__c = 'Disbursement',
            Active__c = true,
            RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(),
            Rate_Type__c = 'Per TON',
            Standard_Rate__c = true,
            Fuel__c = 100,
            Risk__c = 100,
            Normal__c = 10,
            Volumetric_Factor__c = 1,
            Account_for__c = a.Id,
            Fee_Rate__c = 5000
        );
        
        Fee__c airFee3 = new Fee__c(
            Name = 'Air Freight Per M3',
            Fee_Category__c = 'Disbursement',
            Active__c = true,
            RecordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId(),
            Rate_Type__c = 'Fixed',
            Standard_Rate__c = true,
            Fuel__c = 100,
            Risk__c = 100,
            Normal__c = 10,
            Volumetric_Factor__c = 1,
            Account_for__c = a.Id,
            Fee_Rate__c = 200
        );
        
        insert new List<Fee__c>{airFee1, airFee2, airFee3};                    
            Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c(
                Import_Export_Quote__c = importexportquote.id,
                Name = 'existing fee line', 
                Service_Rate_Name__c = fee.Id
            );
        insert quote_fee;
        
        Test.startTest();
        NEU_Standard_Fee_Calculation_Imp_Exp ie = new NEU_Standard_Fee_Calculation_Imp_Exp(new ApexPages.StandardController(importexportquote));
        PageReference result = ie.crear_fee_estandar();
        ie.cancel();
        Test.stopTest();
        
    }
}