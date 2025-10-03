@isTest
public class P2G_NEU_MD_SCMR2Test {
    
    @isTest
    static void NEU_MD_SCMR2() {                
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test pircelist' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = a.Id);
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
        insert importexportquote;
        /*Customer_Quote__c importexportquote = new Customer_Quote__c(Pricing_Executive__c = UserInfo.getUserId(), Catalog_Price_List__c = b.id, Account_for__c = a.Id, Quotation_Status__c='Sent awaiting response', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;*/
        Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/);
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items');
        insert quote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Fee_Rate__c=10, Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2; 
        SCM_Rule__c scm_rule = new SCM_Rule__c(Name='test rule', SCM_Rule_Code__c = 'SCMR2' , Enabled__c = true, Fee_Alarm_Text__c='test alarm');
        insert scm_rule;
        SCM_Activity__c scm_activity = new SCM_Activity__c(Name='test', Enabled__c = true, SCM_Rule__c =scm_rule.Id,Subject__c='test' );
        insert scm_activity;
        
        test.startTest();
        fee.Fee_Rate__c=100;
        update fee;
        test.stopTest();
        
    }
}