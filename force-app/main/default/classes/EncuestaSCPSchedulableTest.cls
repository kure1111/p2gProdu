@isTest
public class EncuestaSCPSchedulableTest {
    
    @testSetup 
    static void CreateObjects() {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            Account account_test = list_accounts[0];
            insert account_test;
        
        Contact contacto = new Contact(AccountId = account_test.Id, LastName='test contact', email = 'nayleth.gonzalez@pak2go.com');
        insert contacto;
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Road';
        shipment_test.Service_Mode__c = 'NATIONAL';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Shipment_Status_Mon__c ='Finished_M';
        shipment_test.Date_time_FN_Finished__c =date.today();
        shipment_test.Name = 'SP-FN-21-003426';
        
        
        List<Account> list_accounts2 = NEU_Utils.getAccounts('Transporter,');
            Account account_test2 = list_accounts2[0];
            insert account_test2;

        shipment_test.Carrier__c =account_test2.Id;
        insert shipment_test;
        
        Shipment__c shi = [select id,name,Shipment_Status_Mon__c,Carrier__c,ACCOUNT_FOR__C,
               Date_time_FN_Finished__c,Shipment_Type__c From Shipment__c where id =: shipment_test.id limit 1];
            
            system.debug('shi ' + shi);
        
        system.debug('shipment_test ' + shipment_test);
	}
     @isTest 
  static void testVoid() {
     Test.StartTest();
     	EncuestaSCPSchedulable sh1 = new EncuestaSCPSchedulable();
			String sch = '0 0 23 * * ?';
			system.schedule('EncuestaSCPSchedulableCheck', sch, sh1);
	  Test.stopTest();

  }
}