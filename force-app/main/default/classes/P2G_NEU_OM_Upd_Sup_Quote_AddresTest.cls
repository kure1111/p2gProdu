@isTest
public class P2G_NEU_OM_Upd_Sup_Quote_AddresTest {
    @isTest
    static void NEU_OM_Update_Suppliers_Quotes_Addresses()
    {
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Supplier');
        Account a = list_accounts[0];
        a.ShippingStreet='Test';
        a.ShippingCity='Test';
        a.ShippingState='Test';
        a.ShippingPostalCode='Test';
        a.ShippingCountry='Test';
        insert a;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Account sup = list_accounts[1];
        sup.ShippingStreet='Test';
        sup.ShippingCity='Test';
        sup.ShippingState='Test';
        sup.ShippingPostalCode='Test';
        sup.ShippingCountry='Test';
        insert sup;
        Account sup2 = list_accounts[2];
        sup2.ShippingStreet='Test';
        sup2.ShippingCity='Test';
        sup2.ShippingState='Test';
        sup2.ShippingPostalCode='Test';
        sup2.ShippingCountry='Test';
        insert sup2;
        Price_List__c b = new Price_List__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = a.Id);
        insert b;
        
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
        importexportquote.Catalog_Price_List__c = b.id;
        insert importexportquote;

        /*Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;*/

        SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = a.Id);
        insert scm_contract;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/);
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = a.Id);
        insert supplyproject;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=sup.Id );
        insert suprequest;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=sup.Id, Delivery_Account__c = sup.Id, DeliveryAddress__c='', Receipt_Address__c ='', Customer__c = a.Id);
        insert supquote;
        supquote.Delivery_Account__c = sup2.Id;
        update supquote;
        Test.stopTest();
    }
}