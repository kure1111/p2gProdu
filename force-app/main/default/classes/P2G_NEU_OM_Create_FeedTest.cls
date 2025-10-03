@isTest
public class P2G_NEU_OM_Create_FeedTest {
    
    @IsTest(SeeAllData=true)
    public static void NEU_OM_Create_Feed(){
        
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount', Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true, Pricing_Executive__c=UserInfo.getUserId());
        insert importexportquote;
        Chatter_Feed_Guest_User__c feeguest = new Chatter_Feed_Guest_User__c(Feed_Text__c='test', Record_Id__c= importexportquote.Id );
        test.startTest();
        insert feeguest;
        feeguest.Feed_Text__c='test2';
        feeguest.Record_Id__c=importexportquote.Id;
        update feeguest;
        test.stopTest();
    }
}