@isTest
public class P2G_NEU_MD_UploadRecordTypeSQOTest {
    /*
@isTest
static void NEU_MD_UploadRecordTypeSQO(){
List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
Account account_test = list_accounts[0];
insert account_test;

Account account_test2 = list_accounts[1];
insert account_test2;

Supplier_Quote__c supplier_quote_test = new Supplier_Quote__c();
supplier_quote_test.Supplier__c = account_test.Id;

test.startTest();
insert supplier_quote_test;
test.stopTest();
Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*//*);
insert c;
Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
insert d;
Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= account_test2.Id , E_Commerce__c = true);
insert item;
Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supplier_quote_test.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000, Active__c  = true, Price__c =10);
insert sup_quote_lines;
supplier_quote_test.Supplier_Quote_Status__c = 'Approved';
update supplier_quote_test;
}
*/
    
    @testSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Supplier Test', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId()),
                new Account(Name = 'Customer Test', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId())
                };
                    insert accounts;
        
        Product_Family__c family = new Product_Family__c(Name = 'Test Family');
        insert family;
        
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'Test Subfamily');
        insert subfamily;
        
        Sourcing_Item__c item = new Sourcing_Item__c(
            Name = 'Test Item',
            Subfamily__c = subfamily.Id, 
            Sourcing_Family__c = family.Id,
            Account_Owner__c = accounts[1].Id,
            E_Commerce__c = true
        );
        insert item;
    }
    
    @isTest
    static void testApprovedQuoteChangesToOrderRecordType() {
        Account supplier = [SELECT Id FROM Account WHERE Name = 'Supplier Test' LIMIT 1];
        Sourcing_Item__c item = [SELECT Id FROM Sourcing_Item__c LIMIT 1];
        
        Supplier_Quote__c sq = new Supplier_Quote__c(
            Supplier__c = supplier.Id,
            Supplier_Quote_Status__c = 'Draft',
            RecordTypeId = Schema.SObjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Quote').getRecordTypeId()
        );
        insert sq;
        
        Supplier_Quote_Line__c sql = new Supplier_Quote_Line__c(
            Supplier_Quote__c = sq.Id,
            Name = 'Test Quote Line',
            Item__c = item.Id,
            Quantity__c = 1000,
            Active__c = true,
            Price__c = 10,
            RecordTypeId = Schema.SObjectType.Supplier_Quote_Line__c.getRecordTypeInfosByName().get('Supplier Quote/Order Line').getRecordTypeId()
        );
        insert sql;
        
        Test.startTest();
        NEU_StaticVariableHelper.setBoolean1(false);
        sq.Supplier_Quote_Status__c = 'Approved';
        update sq;
        Test.stopTest();
    }
    
    @isTest
    static void testRecordTypeChangeUpdatesLines() {
        Account supplier = [SELECT Id FROM Account WHERE Name = 'Supplier Test' LIMIT 1];
        Sourcing_Item__c item = [SELECT Id FROM Sourcing_Item__c LIMIT 1];
        
        Supplier_Quote__c sq = new Supplier_Quote__c(
            Supplier__c = supplier.Id,
            Supplier_Quote_Status__c = 'Draft',
            RecordTypeId = Schema.SObjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Quote').getRecordTypeId()
        );
        insert sq;
        
        Supplier_Quote_Line__c sql = new Supplier_Quote_Line__c(
            Supplier_Quote__c = sq.Id,
            Name = 'Test Quote Line',
            Item__c = item.Id,
            Quantity__c = 1000,
            Active__c = true,
            Price__c = 10,
            RecordTypeId = Schema.SObjectType.Supplier_Quote_Line__c.getRecordTypeInfosByName().get('Supplier Quote/Order Line').getRecordTypeId()
        );
        insert sql;
        
        Test.startTest();
        NEU_StaticVariableHelper.setBoolean1(false);
        sq.RecordTypeId = Schema.SObjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Order').getRecordTypeId();
        update sq;
        Test.stopTest();
    }
    
    @isTest
    static void testRecordTypeChangeToHiddenUpdatesLines() {
        Account supplier = [SELECT Id FROM Account WHERE Name = 'Supplier Test' LIMIT 1];
        Sourcing_Item__c item = [SELECT Id FROM Sourcing_Item__c LIMIT 1];
        
        Supplier_Quote__c sq = new Supplier_Quote__c(
            Supplier__c = supplier.Id,
            Supplier_Quote_Status__c = 'Draft',
            RecordTypeId = Schema.SObjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Quote').getRecordTypeId()
        );
        insert sq;
        
        Supplier_Quote_Line__c sql = new Supplier_Quote_Line__c(
            Supplier_Quote__c = sq.Id,
            Name = 'Test Quote Line',
            Item__c = item.Id,
            Quantity__c = 1000,
            Active__c = true,
            Price__c = 10,
            RecordTypeId = Schema.SObjectType.Supplier_Quote_Line__c.getRecordTypeInfosByName().get('Supplier Quote/Order Line').getRecordTypeId()
        );
        insert sql;
        
        Test.startTest();
        NEU_StaticVariableHelper.setBoolean1(false);
        Id otherRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Supplier_Quote__c' AND DeveloperName NOT IN ('Supplier_Quote', 'Supplier_Order') LIMIT 1].Id;
        sq.RecordTypeId = otherRecordTypeId;
        update sq;
        Test.stopTest();
    }
    
    @isTest
    static void testTriggerBypassWithStaticVariable() {
        Account supplier = [SELECT Id FROM Account WHERE Name = 'Supplier Test' LIMIT 1];
        
        Supplier_Quote__c sq = new Supplier_Quote__c(
            Supplier__c = supplier.Id,
            Supplier_Quote_Status__c = 'Draft',
            RecordTypeId = Schema.SObjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Quote').getRecordTypeId()
        );
        insert sq;
        
        Test.startTest();
        NEU_StaticVariableHelper.setBoolean1(true);
        sq.Supplier_Quote_Status__c = 'Approved';
        update sq;
        Test.stopTest();
    }
    
}