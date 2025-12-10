@isTest
public class P2G_NEU_Fields_copy_production_planTest {

    @isTest
    static void NEU_Fields_copy_production_plan ()
    {
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/);
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id , E_Commerce__c = true);
        insert item;
        NEU_Factory__c factory = new NEU_Factory__c(Name='test factory', Account_Owner__c = a.Id);
        insert factory;
        Labor_Program__c labor_program = new Labor_Program__c (Factory_Line__c = factory.Id);
        insert labor_program;
        Production_Order__c  production_order = new Production_Order__c (Item__c = item.Id , Labor_Program__c = labor_program.Id);
        insert production_order;
    }
}