@isTest
public class ImportExport_Service_Charges_test {
     @testSetup static void setup() {
       
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
         a.Active__c ='Yes';
         a.ActiveSap__c = true;
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(Pricing_Executive__c=userinfo.getUserId(),Quotation_Status__c ='Sent awaiting response', Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
       
        
         
         Traffic__c new_traffic = new Traffic__c();
          new_traffic.Name = 'New Traffic';
          new_traffic.Account__c = importexportquote.Account_for__c;
          new_traffic.Site_of_Load__c = importexportquote.Site_of_Load__c;
          new_traffic.State_of_Load__c = importexportquote.State_of_Load__c;
          new_traffic.Country_of_Load__c = importexportquote.Country_ofLoad__c;
          new_traffic.Country_of_Discharge__c = importexportquote.Country_ofDischarge__c;
          new_traffic.State_of_Discharge__c = importexportquote.State_of_Discharge__c;
          new_traffic.Site_of_Discharge__c = importexportquote.Site_of_Discharge__c;
          new_traffic.Freight_Mode__c = importexportquote.Freight_Mode__c;
          new_traffic.Service_Type__c = importexportquote.Service_Type__c;
          new_traffic.Container_Type__c = importexportquote.Container_Type__c;
          new_traffic.Service_Mode__c = importexportquote.Service_Mode__c;
          new_traffic.N_Import_Exports__c = 1;
         new_traffic.Service_Type__c ='PAQUETERIA';
         insert new_traffic;
         importexportquote.Traffic__c = new_traffic.id;
          insert importexportquote;
         Quote_Item_Line__c quote = new Quote_Item_Line__c(Units__c = 10,Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Total_Shipping_Weight_Kgs__c =100);
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
         //, Service_Rate_Name__c= fee.Id
       // insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items'
                                                                         , Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10
                                                                         , Quote_Sell_Price__c=10,Units__c=10 );
        insert quote2;
    }
    static testMethod void updateCustomerQuote() {
        
       Test.startTest();
        Customer_Quote__c importexportquote = [select id,Service_Charges_Kg__c from Customer_Quote__c];
        importexportquote.Destination_Address__c='Prueba2';
        importexportquote.Quotation_Status__c = 'Partially Shipped';
        importexportquote.Freight_Mode__c = 'Sea';
        update importexportquote;
        Test.stopTest();
    }
    static testMethod void updateCustomerQuote2() {
        
       Test.startTest();
         NEU_StaticVariableHelper.setBoolean1(true);
        Customer_Quote__c importexportquote = [select id,Service_Charges_Kg__c from Customer_Quote__c];
        importexportquote.Destination_Address__c='Prueba2';
        update importexportquote;
        Test.stopTest();
    }
     static testMethod void insertImportExport() {
        
       Test.startTest();
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
        Customer_Quote__c importexportquote = new Customer_Quote__c(Pricing_Executive__c=userinfo.getUserId(),Quotation_Status__c ='Sent awaiting response', Catalog_Price_List__c= b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Total_Shipping_Weight_Kgs__c =100);
        insert quote;
        Traffic__c new_traffic = new Traffic__c();
          new_traffic.Name = 'New Traffic';
          new_traffic.Account__c = importexportquote.Account_for__c;
          new_traffic.Site_of_Load__c = importexportquote.Site_of_Load__c;
          new_traffic.State_of_Load__c = importexportquote.State_of_Load__c;
          new_traffic.Country_of_Load__c = importexportquote.Country_ofLoad__c;
          new_traffic.Country_of_Discharge__c = importexportquote.Country_ofDischarge__c;
          new_traffic.State_of_Discharge__c = importexportquote.State_of_Discharge__c;
          new_traffic.Site_of_Discharge__c = importexportquote.Site_of_Discharge__c;
          new_traffic.Freight_Mode__c = importexportquote.Freight_Mode__c;
          new_traffic.Service_Type__c = importexportquote.Service_Type__c;
          new_traffic.Container_Type__c = importexportquote.Container_Type__c;
          new_traffic.Service_Mode__c = importexportquote.Service_Mode__c;
          new_traffic.N_Import_Exports__c = 1;
         new_traffic.Service_Type__c ='PAQUETERIA';
         insert new_traffic;
        Test.stopTest();
    }
    static testMethod void DeleteImportExport() {
        
       Test.startTest();
        Customer_Quote__c importexportquote = [select id,Service_Charges_Kg__c,Traffic__c from Customer_Quote__c];
        delete importexportquote;
        Test.stopTest();
    }


}