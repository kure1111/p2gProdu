@isTest(seeAllData=true)
public class P2G_NotificationTest {
    @isTest
    static void mainTest() {
        
        Invoice__c invoice = [SELECT Id, shipment__c FROM Invoice__c LIMIT 1];
        
        Response__c res= new Response__c();
        res.Invoice__c=invoice.Id;
        res.Object__c='Invoice';
        res.Type__c='ERROR';
        res.Message__c='Error';
        res.Shipment__c=invoice.Shipment__c;
        res.createdDate=Date.Today();
        insert res;                
        Test.startTest();
        P2G_Notification.getSapResponse(res.Shipment__c);
        Test.stopTest();	
    	}
    }