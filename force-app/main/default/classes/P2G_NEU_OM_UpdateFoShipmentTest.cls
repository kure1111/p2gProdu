@isTest
public class P2G_NEU_OM_UpdateFoShipmentTest {
    @isTest
    static void NEU_OM_UpdateFoShipment() //ok
    {
        Test.startTest();
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account cuenta= new Account();
        cuenta.Name='Test';
        cuenta.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        cuenta.OwnerId=UserInfo.getUserId(); 
        cuenta.Account_Executive_User__c=UserInfo.getUserId();
        cuenta.Account_External_Follower_User__c=UserInfo.getUserId();
        insert cuenta;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Name='SP-FN-24-TEST',Account_for__c = cuenta.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Test.stopTest();
    }    
}