@isTest
public class P2G_NEU_MD_SCMR1Test {
    
    @isTest
    static void NEU_MD_SCMR1() //ok
    {
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account buyer = list_accounts[0];
        insert buyer;
        Pricebook2 pb = new Pricebook2(Name = 'Paqueteria', IsActive = true);
        insert pb;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/);
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=buyer.Id);
        insert shop;
        Shopping_Cart_line__c shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = item.Id, Units__c=10, Offer_Price__c=10, List_Price__c=10);
        insert shoplines;
        Price_List__c b = new Price_List__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = buyer.Id);
        insert b;

        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name='.';
        importexportquote.Account_for__c = buyer.Id;
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

        /*
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = buyer.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        */
        Customer_Price_List__c cpl = new Customer_Price_List__c(Customer__c = buyer.id,Price_List__c = b.Id);
        insert cpl;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= item.Id);
        insert quote;
        
        SCM_Rule__c scm_rule = new SCM_Rule__c(Name='test scm rule', Category__c= 'Inventory Management', Enabled__c = true,Fee_Alarm_Text__c='test', Description__c='test', SCM_Rule_Code__c= 'SCMR1' );
        insert scm_rule;
        SCM_Activity__c scm_activity = new SCM_Activity__c(Name='test', Enabled__c = true, SCM_Rule__c =scm_rule.Id,Subject__c='test' );
        insert scm_activity;
        test.startTest();
        item.Item_Price__c=10;
        update item;
        
        test.stopTest();
        
    }
    
}