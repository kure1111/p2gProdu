@isTest
public class P2G_NEU_OM_UpdateFoImpExpQuoteTest {
    
    @isTest
    static void NEU_OM_UpdateFoImportExportQuote(){ //ok                
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account cuenta = list_accounts[0];
        cuenta.ActiveSap__c = true;
        cuenta.Account_Executive_User__c=UserInfo.getUserId();
        cuenta.Account_External_Follower_User__c=UserInfo.getUserId();
        insert cuenta;
        Account sup = list_accounts[1];
        insert sup;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        Price_List__c pricelist = new Price_List__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = cuenta.Id);
        insert pricelist;
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = cuenta.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = pricelist.id, Account_for__c = cuenta.Id, Quotation_Status__c = 'Approved as Succesful');
        /*
        Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = cuenta.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = pricelist.id, Account_for__c = cuenta.Id, Quotation_Status__c = 'Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        */

        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];

        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional

        Customer_Quote__c importexportquote = new Customer_Quote__c();

        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();

        importexportquote.RecordTypeId = recordTypeId;

        importexportquote.Name='.';

        importexportquote.Account_for__c = cuenta.Id;
        importexportquote.Consignee__c=cuenta.Id;
        importexportquote.Supplier_Account__c = sup.Id;

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

        insert importexportquote;
 

        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        
        Fee__c service_rate = new Fee__c();
        service_rate.Name = 'Sercie Rate Test';
        service_rate.Fee_Category__c = 'Disbursement';
        service_rate.Rate_Type__c = 'Per Kg';
        service_rate.Account_for__c = cuenta.Id;
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
        
        //importexportquote.Quotation_Status__c ='Approved as Succesful';
        //update importexportquote;
        
    }
}