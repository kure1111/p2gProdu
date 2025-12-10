@isTest
public class P2G_NEU_OM_FollowersShipmentTest {
    /*
    @isTest
    static void testNEU_OM_FollowersShipment(){
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        
        Account a=new Account();
        a.Name='TEST';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert a;        
        
        
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00012', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_OM_FollowersShipment uda = new NEU_OM_FollowersShipment(new ApexPages.StandardController( ship ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
    }
	*/
    
    /*
    @testSetup
    static void setupTestData() {
        // Configuración inicial común para todos los tests
        Account a = new Account(
            Name = 'TEST ACCOUNT',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
            OwnerId=UserInfo.getUserId()
        );
        insert a;
                
        
        User standardUser = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        
        a.Account_External_Follower_User__c = standardUser.Id;
        a.Account_Executive_User__c = standardUser.Id;
        update a;
        
        Contact contacto = new Contact(
            AccountId = a.Id, 
            LastName = 'test contact',
            Email = 'testcontact@example.com'
        );
        insert contacto;
        
        Shipment__c ship = new Shipment__c(
            Name = 'SP-TS-00012', 
            Account_for__c = a.Id, 
            Freight_Mode__c = 'Sea', 
            Service_Mode__c = 'Import', 
            Only_Warehouse_Service__c = true
        );
        insert ship;
    }
    */
    @isTest(SeeAllData=true)
    static void testConstructorAndInitialization() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        
        Test.startTest();
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(new ApexPages.StandardController(ship));
        Test.stopTest();
        
        System.assertNotEquals(null, controller.record, 'El registro de Shipment no debería ser nulo');
    }
    
    @isTest(SeeAllData=true)
    static void testGetFollowers() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(new ApexPages.StandardController(ship));
        
        Test.startTest();
        List<NEU_OM_FollowersShipment.follower_s> followers = controller.getfollower();
        Test.stopTest();
        
        System.assertNotEquals(null, followers, 'La lista de followers no debería ser nula');
    }
    
    @isTest(SeeAllData=true)
    static void testGetFollowersIn() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(new ApexPages.StandardController(ship));
        
        Test.startTest();
        List<NEU_OM_FollowersShipment.followersin_s> followersIn = controller.getfollowersin();
        Test.stopTest();
        
        System.assertNotEquals(null, followersIn, 'La lista de followersIn no debería ser nula');
    }
    
    @isTest(SeeAllData=true)
    static void testNuevaLinea() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(new ApexPages.StandardController(ship));
        controller.idlinea = testUser.Id;
        
        Test.startTest();
        controller.nuevalinea();
        Test.stopTest();
        
        List<EntitySubscription> subscriptions = [SELECT Id FROM EntitySubscription WHERE ParentId = :ship.Id AND SubscriberId = :testUser.Id];
        System.assertEquals(1, subscriptions.size(), 'Debería haber una suscripción creada');
    }
        
    
    @isTest(SeeAllData=true)
    static void testMaxSubscriptionsScenario() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        User testUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
                
        List<EntitySubscription> subsToInsert = new List<EntitySubscription>();
        for(Integer i = 0; i < 500; i++) {
            subsToInsert.add(new EntitySubscription(
                SubscriberId = testUser.Id,
                ParentId = '00T7F0000036MkTUAU'
            ));
        }        
        insert new EntitySubscription(
            SubscriberId = testUser.Id,
            ParentId = ship.Id
        );
        
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(new ApexPages.StandardController(ship));
        controller.idlinea = testUser.Id;
        
        Test.startTest();
        controller.nuevalinea();
        Test.stopTest();                        
    }
    
    @isTest(SeeAllData=true)
    static void testCommunityUserScenario() {
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        User communityUser = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(new ApexPages.StandardController(ship));
        controller.idlinea = communityUser.Id;
        
        Test.startTest();
        controller.nuevalinea();
        Test.stopTest();                        
    }
    
    @isTest(SeeAllData=true)
    static void testErrorHandling() {        
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(new ApexPages.StandardController(ship));
        
        
        controller.idlinea = '001xx000001Invalid';
        
        Test.startTest();
        controller.nuevalinea();
        controller.quitarlinea();
        Test.stopTest();
    }  
    
    @isTest(SeeAllData=true)
    static void testConstructorWithExistingRecord() {                
        
        Shipment__c testShipment =[SELECT Id FROM Shipment__c LIMIT 1];
                
        ApexPages.StandardController stdController = new ApexPages.StandardController(testShipment);
        
        Test.startTest();
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(stdController);
        Test.stopTest();
    }
    @isTest
    static void testConstructorWithNonExistentRecord() {        
        Shipment__c fakeShipment = new Shipment__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(fakeShipment);
        
        Test.startTest();
        NEU_OM_FollowersShipment controller = new NEU_OM_FollowersShipment(stdController);
        Test.stopTest();
    }
}