@isTest
public class P2G_NEU_Standard_Duty_CalculatorTest {
    
    @isTest(SeeAllData=true)
       static void test_NEU_Standard_Duty_Calculator() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
       
        ApexPages.currentPage().getParameters().put('test', 'test');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        //Account a = list_accounts[0];
        //a.Owner.SalesEmployer__c='002';
        //insert a;
        Account a= new Account();
			a.Name='Test';
			a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        	a.OwnerId=UserInfo.getUserId();  
           a.CurrencyIsoCode='MXN';
        insert a;        
           Account sup= new Account();
			sup.Name='Test';
			sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        	sup.OwnerId=UserInfo.getUserId();  
           sup.CurrencyIsoCode='MXN';
        insert sup;
        //Account sup = list_accounts[1];
        //insert sup;
        /*
         * Account sup = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
            RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Transporter'
            AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
		*/
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489', CurrencyIsoCode='MXN');
        insert g;
        Customer_Quote__c importexportquote = [SELECT Id, Route__c, Name FROM Customer_Quote__c WHERE Margen_Operativo__c!=null AND Pricing_Executive__c!=null LIMIT 1];
        /*
        new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true, CurrencyIsoCode='MXN');
        insert importexportquote;
        */
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000,CurrencyIsoCode='MXN');
        insert quote;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Route__c=route.Id, Only_Warehouse_Service__c = true, CurrencyIsoCode='MXN');
        insert importexportquote2;
        Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000,CurrencyIsoCode='MXN');
        insert quote2;
        NEU_Standard_Duty_Calculator ie = new NEU_Standard_Duty_Calculator(new ApexPages.StandardController( importexportquote ));
        ie.calcular_tasas();
        ie.refresh();
        ie.volver();
        NEU_Standard_Duty_Calculator ie2 = new NEU_Standard_Duty_Calculator(new ApexPages.StandardController( importexportquote2 ));
        ie2.calcular_tasas();
       }
    /*
    @isTest(SeeAllData=true)
    static void testConstructor() {
        Customer_Quote__c testQuote = [SELECT Id, CreatedDate, Route__c FROM Customer_Quote__c WHERE Name like '%CE%' AND CE_Tipodeservicio_IMPAK__c!=null ORDER BY CreatedDate LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        NEU_Standard_Duty_Calculator controller = new NEU_Standard_Duty_Calculator(sc);
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void testCalcularTasas() {
        Customer_Quote__c testQuote = [SELECT Id, CreatedDate, Route__c FROM Customer_Quote__c WHERE Name like '%CE%' AND CE_Tipodeservicio_IMPAK__c!=null ORDER BY CreatedDate LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        NEU_Standard_Duty_Calculator controller = new NEU_Standard_Duty_Calculator(sc);
        
        Test.setMock(HttpCalloutMock.class, new DutyCalculatorMock());
        
        PageReference result = controller.calcular_tasas();
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void testCalcularTasasConError() {
        Customer_Quote__c testQuote = [SELECT Id, CreatedDate, Route__c FROM Customer_Quote__c WHERE Name like '%CE%' AND CE_Tipodeservicio_IMPAK__c!=null ORDER BY CreatedDate LIMIT 1];        
        testQuote.Route__c = null;
        update testQuote;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        NEU_Standard_Duty_Calculator controller = new NEU_Standard_Duty_Calculator(sc);
        
        PageReference result = controller.calcular_tasas();
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void testRefresh() {
        Customer_Quote__c testQuote = [SELECT Id, CreatedDate, Route__c FROM Customer_Quote__c WHERE Name like '%CE%' AND CE_Tipodeservicio_IMPAK__c!=null ORDER BY CreatedDate LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        NEU_Standard_Duty_Calculator controller = new NEU_Standard_Duty_Calculator(sc);
        controller.indice = 5;
        controller.errores = 'Test error';
        
        PageReference result = controller.refresh();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testVolver() {
        Customer_Quote__c testQuote = [SELECT Id, CreatedDate, Route__c FROM Customer_Quote__c WHERE Name like '%CE%' AND CE_Tipodeservicio_IMPAK__c!=null ORDER BY CreatedDate LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        NEU_Standard_Duty_Calculator controller = new NEU_Standard_Duty_Calculator(sc);
        
        PageReference result = controller.volver();
        Test.stopTest();
    }
    
    /*
@isTest(SeeAllData=true)
static void test_NEU_Standard_Duty_Calculator() {

NEU_StaticVariableHelper.setBoolean1(true);

ApexPages.currentPage().getParameters().put('test', 'test');
//List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
//Account a = list_accounts[0];
//a.Owner.SalesEmployer__c='002';
//insert a;
Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
//Account sup = list_accounts[1];
//insert sup;
Account sup = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Transporter'
AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
insert b;
Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
insert c;
Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
insert d;
Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
insert g;
*/
    
    /*new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true);
insert importexportquote;*/
    //Quote_Item_Line__c quote =[SELECT Id, Import_Export_Quote__c FROM Quote_Item_Line__c WHERE Import_Export_Quote__r.Route__c!=null  LIMIT 1 ];
    
    
    //Customer_Quote__c importexportquote = [SELECT Id FROM Customer_Quote__c WHERE Id=:quote.Import_Export_Quote__c LIMIT 1];
    /* new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000,CurrencyIsoCode='MXN');
insert quote;*/
    /*    
Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
insert Country;
Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
insert localizacion;
Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
insert route;
Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Route__c=route.Id, Only_Warehouse_Service__c = true);
insert importexportquote2;
Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000,CurrencyIsoCode='MXN');
insert quote2;
NEU_Standard_Duty_Calculator ie = new NEU_Standard_Duty_Calculator(new ApexPages.StandardController( importexportquote ));
ie.calcular_tasas();
ie.refresh();
ie.volver();
NEU_Standard_Duty_Calculator ie2 = new NEU_Standard_Duty_Calculator(new ApexPages.StandardController( importexportquote2 ));
ie2.calcular_tasas();
}
*/
    @isTest
    static void NEU_Standard_Duty_Calculator_Suppl_Quote() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        
        Supplier_Quote__c supquote = new Supplier_Quote__c( Customer__c = a.Id, Supplier__c = sup.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines =new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000,CurrencyIsoCode='MXN');
        insert sup_quote_lines;
        
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        
        Supplier_Quote__c supquote2 = new Supplier_Quote__c(Supplier__c=sup.Id, Customer__c = a.Id, Supplier_Quote_Status__c='Consolidated', Route__c=route.Id);
        insert supquote2;
        Supplier_Quote_Line__c sup_quote_lines2 = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote2.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=1000, CurrencyIsoCode='MXN');
        insert sup_quote_lines2;
        
        NEU_Standard_Duty_Calculator_Suppl_Quote ie = new NEU_Standard_Duty_Calculator_Suppl_Quote(new ApexPages.StandardController( supquote ));
        ie.calcular_tasas();
        ie.refresh();
        ie.volver();
        NEU_Standard_Duty_Calculator_Suppl_Quote ie2 = new NEU_Standard_Duty_Calculator_Suppl_Quote(new ApexPages.StandardController( supquote2 ));
        ie2.calcular_tasas();
        
    }
    
    
    
    private class DutyCalculatorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setStatusCode(200);
            
            String body = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"><soap:Header></soap:Header>';
            body += '<soap:Body>';
            body += '<duty-calculation id="190484994">';
            body += '<item id="3752" hs-code="84295299" reference="3752" quality-score="validated">';
            body += '<customs-value name="CIF">';
            body += '<amount currency="EUR">200000</amount>';
            body += '</customs-value>';
            body += '<duty>';
            body += '<amount currency="EUR">0</amount>';
            body += '</duty>';
            body += '<sales-tax name="VAT">';
            body += '<amount currency="EUR">32256</amount>';
            body += '</sales-tax>';
            body += '<additional-import-taxes>';
            body += '<tax name="DTA">';
            body += '<amount currency="EUR">1600</amount>';
            body += '</tax>';
            body += '<tax name="Pro-rated order-level charges">';
            body += '<amount currency="EUR">1600</amount>';
            body += '</tax>';
            body += '</additional-import-taxes>';
            body += '<total>';
            body += '<amount currency="EUR">33856</amount>';
            body += '</total>';
            body += '</item>';
            body += '<total-charges>';
            body += '<customs-value name="CIF">';
            body += '<amount currency="EUR">200000</amount>';
            body += '</customs-value>';
            body += '<duty>';
            body += '<amount currency="EUR">0</amount>';
            body += '</duty>';
            body += '<sales-tax name="VAT">';
            body += '<amount currency="EUR">32256</amount>';
            body += '</sales-tax>';
            body += '<additional-import-taxes>';
            body += '<tax name="DTA">';
            body += '<amount currency="EUR">1600</amount>';
            body += '</tax>';
            body += '</additional-import-taxes>';
            body += '<total>';
            body += '<amount currency="EUR">33856</amount>';
            body += '</total>';
            body += '</total-charges>';
            body += '</duty-calculation>';
            body += '</soap:Body></soap:Envelope>';
            
            res.setBody(body);
            return res;
        }
    }
}