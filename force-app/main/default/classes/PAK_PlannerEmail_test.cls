@isTest
public class PAK_PlannerEmail_test {
 
    static testMethod void quote() {
        
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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address',Pricing_Executive__c = UserInfo.getUserId());//Quote_Agent__c= ,Quote_Export_Company__c=, 
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
    
     static testMethod void feeTest() {
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
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address',Pricing_Executive__c = UserInfo.getUserId());//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        //Quote_Item_Line__c quote = TestDataFactory.createCargoLine('lineas items', importexportquote);//new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        //insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        
        Test.startTest();
    	insert fee;
     	test.stopTest();
        
    }   
        
}