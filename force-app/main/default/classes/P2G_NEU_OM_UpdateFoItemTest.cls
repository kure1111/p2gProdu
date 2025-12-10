@isTest
public class P2G_NEU_OM_UpdateFoItemTest {

    @IsTest(SeeAllData=true)
    static void testSubscriptionCreationForAllUsers() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        User currentUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUserName()];
        
        Test.startTest();
        Sourcing_Item__c sourcingItem = new Sourcing_Item__c(
            Name = 'Test Item',
            Account_Owner__c = testAccount.Id            
        );
        insert sourcingItem;
        Test.stopTest();        
    }

    @IsTest(SeeAllData=true)
    static void testNoDuplicateSubscriptions() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        User currentUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUserName()];
        
        Sourcing_Item__c sourcingItem = new Sourcing_Item__c(
            Name = 'Test Item',
            Account_Owner__c = testAccount.Id,
            CreatedById = currentUser.Id
        );
        insert sourcingItem;

        Test.startTest();
        sourcingItem.Name = 'Updated Item';
        update sourcingItem;
        Test.stopTest();
        
    }

    @IsTest(SeeAllData=true)
    static void testWithCommunityNetwork() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        User currentUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUserName()];
        
        User userWithAccount = new User(
            FirstName = 'With',
            LastName = 'Account',
            Email = 'wa@test.com',
            Username = 'wa@test.com',
            Alias = 'wa',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User'].Id            
        );
        insert userWithAccount;

        Test.startTest();
        Sourcing_Item__c sourcingItem = new Sourcing_Item__c(
            Name = 'Test Community Item',
            Account_Owner__c = testAccount.Id,
            CreatedById = currentUser.Id
        );
        insert sourcingItem;
        Test.stopTest();
        
    }

    @IsTest(SeeAllData=true)
    static void testExceptionHandling() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        try {
            Sourcing_Item__c sourcingItem = new Sourcing_Item__c(Name = 'Test Error Item');
            insert sourcingItem;
        } catch(Exception e) {}
        Test.stopTest();
    }
    
}