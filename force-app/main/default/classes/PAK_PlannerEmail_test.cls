@isTest
public class PAK_PlannerEmail_test {
    
    @isTest
    static void quote() {
        
        //NEU_StaticVariableHelper.setBoolean1(true);
        User user = TestDataFactory.createUserAdmin();              
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        a.Segment__c = 'Nuevo';
        insert a;
        Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        
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
        importexportquote.Freight_Mode__c = 'Air';
        importexportquote.Service_Mode__c = 'Import';
        importexportquote.Service_Type__c = 'LCL Cargo';
        importexportquote.CurrencyIsoCode = 'MXN';
        importexportquote.Move_Type__c='Door to Door';
        importexportquote.ETD__c = Date.today();
        importexportquote.ETA__c = Date.today();
        importexportquote.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote.Pricing_Executive__c= userT.Id;
        importexportquote.Operations_Exec__c = userT.Id;
        importexportquote.Origin_Address__c='tst adrress';
        importexportquote.Country_ofLoad__c= Country.Id;
        importexportquote.Site_of_Load__c=localizacion.Id;
        importexportquote.Country_ofDischarge__c= Country.Id;
        
        //Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, 
        //Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',
        //Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,
        //Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address',Pricing_Executive__c = UserInfo.getUserId());//Quote_Agent__c= ,Quote_Export_Company__c=, 
        Test.startTest();
        
        insert importexportquote;
        //Quote_Item_Line__c quote = TestDataFactory.createCargoLine('lineas items', importexportquote);//new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        //insert quote;
        importexportquote.Declined_for2__c = 'TARIFA ALTA';
        importexportquote.Quotation_Status__c = 'Quote Declined';     
        importexportquote.Folio_Declinado__c = true;
        importexportquote.Que_tarifa_esperaba_el_cliente__c = 1500;        
        update importexportquote;
        test.stopTest();             	
        
    }
    
    @isTest
    static void feeTest() {
        User user = TestDataFactory.createUserAdmin(); 
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        a.Segment__c = 'Nuevo';
        insert a;
        Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
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
        importexportquote.Freight_Mode__c = 'Air';
        importexportquote.Service_Mode__c = 'Import';
        importexportquote.Service_Type__c = 'LCL Cargo';
        importexportquote.CurrencyIsoCode = 'MXN';
        importexportquote.Move_Type__c='Door to Door';
        importexportquote.ETD__c = Date.today();
        importexportquote.ETA__c = Date.today();
        importexportquote.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote.Pricing_Executive__c= userT.Id;
        importexportquote.Operations_Exec__c = userT.Id;
        importexportquote.Origin_Address__c='tst adrress';
        importexportquote.Country_ofLoad__c= Country.Id;
        importexportquote.Site_of_Load__c=localizacion.Id;
        importexportquote.Country_ofDischarge__c= Country.Id;
        //Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address',Pricing_Executive__c = UserInfo.getUserId());//Quote_Agent__c= ,Quote_Export_Company__c=, 
        //insert importexportquote;
        //Quote_Item_Line__c quote = TestDataFactory.createCargoLine('lineas items', importexportquote);//new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        //insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        
        Test.startTest();
        insert fee;
        test.stopTest();
        
    }   
    
}