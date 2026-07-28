@isTest
public class NEU_Shipment_Fee_LineTest {
//clase test para NEU_Shipment_Fee_Line_Principal_update
     static testMethod void NEU_Shipment_Fee_Line_Principal_update()
     {
          Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
          //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a = acc;
          a.Segment__c = 'Nuevo';
          insert a;
          Shipment__c ship = new Shipment__c(Name = 'SP-A-23-000027', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true, Operation_Executive__c = userInfo.getUserId(), Operation_Executive_2__c = userInfo.getUserId());
          insert ship;
          Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = '% of Charge', Account_for__c = a.Id,Carrier_Account__c = a.Id);
          insert fee;
          Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10);
          insert shipfeeline;
          Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10,   Shipment_Service_Line__c  = shipfeeline.Id);
          insert shipfeeline2;
          shipfeeline.Shipment_Sell_Price__c = 100;
          update shipfeeline;        

     }
    
}