@isTest
public class P2G_LastSAPResponseErrorTest {
	
    @isTest(SeeAllData=true)
    static void mainTestErrorTrigger(){
        Invoice__c invoice= [SELECT Id FROM Invoice__c LIMIT 1];
        
        Response__c res= new Response__c();
        res.Invoice__c=invoice.Id;
        res.Object__c='Invoice';
        res.Type__c='ERROR';
        res.Message__c='Error';
        insert res;                
        Test.startTest();
        P2G_LastSAPResponseError.mainTrigger(res);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void mainTestConfirmTrigger(){
        Invoice__c invoice= [SELECT Id FROM Invoice__c LIMIT 1];        
        Response__c res= new Response__c();
        res.Invoice__c=invoice.Id;
        res.Object__c='Invoice';
        res.Type__c='CONFIRM';
        res.Message__c='Confirm';
        insert res;                        
        Test.startTest();
        P2G_LastSAPResponseError.mainTrigger(res);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void mainTestErrorInvoice(){
        Response__c res= [SELECT Id, Invoice__c FROM Response__c WHERE Invoice__c!=null and Type__c='ERROR' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Class.: line , column 1: Update failed. First exception on row 0 with id; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION';
        msg.Invoice=res.Invoice__c;
        Test.startTest();
       	P2G_LastSAPResponseError.main(msg);
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void mainTestConfirmInvoice(){
        Response__c res= [SELECT Id, Invoice__c FROM Response__c WHERE Invoice__c!=null and Type__c='CONFIRM' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Orden de Venta Actualizada: 00002';
        msg.Invoice=res.Invoice__c;
        Test.startTest();
       	P2G_LastSAPResponseError.main(msg);
        Test.stopTest();
    }
    @isTest(SeeAllData=true)
    static void mainTestErrorShipment(){
        Response__c res= [SELECT Id, Shipment__c FROM Response__c WHERE Shipment__c!=null and Type__c='ERROR' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Class.: line 66, column 1: Update failed. First exception on row 0 with id; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION';
        msg.Shipment=res.Shipment__c;
        Test.startTest();
       	P2G_LastSAPResponseError.main(msg);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void mainTestConfirmShipment(){
        Response__c res= [SELECT Id, Shipment__c FROM Response__c WHERE Shipment__c!=null and Type__c='CONFIRM' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Orden de Venta Actualizada: 00002';
        msg.Shipment=res.Shipment__c;
        Test.startTest();
       	P2G_LastSAPResponseError.main(msg);
        Test.stopTest();
    }
}