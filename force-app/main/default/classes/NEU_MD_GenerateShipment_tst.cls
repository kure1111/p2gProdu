@isTest
private class NEU_MD_GenerateShipment_tst {

    static testMethod void test_NEU_MD_GenerateShipment() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
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
       
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(CurrencyIsoCode ='MXN',Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(importexportquote);
        NEU_MD_GenerateShipment uda = new NEU_MD_GenerateShipment(sc);
        uda.generate_shipment(); 
        test.stopTest();
   
     }
}