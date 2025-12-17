@isTest
public class P2G_LatSAPResponseErrorTest {
	@isTest(SeeAllData=true)
    static void mainTestErrorInvoice(){
        Response__c res= [SELECT Id, Invoice__c FROM Response__c WHERE Invoice__c!=null and Type__c='ERROR' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Class.: line , column 1: Update failed. First exception on row 0 with id; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION';
        msg.Invoice=res.Invoice__c;
        P2G_LastSAPResponseError.main(msg);
    }
    
    @isTest(SeeAllData=true)
    static void mainTestConfirmInvoice(){
        Response__c res= [SELECT Id, Invoice__c FROM Response__c WHERE Invoice__c!=null and Type__c='CONFIRM' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Orden de Venta Actualizada: 00002';
        msg.Invoice=res.Invoice__c;
        P2G_LastSAPResponseError.main(msg);
    }
    @isTest(SeeAllData=true)
    static void mainTestErrorShipment(){
        Response__c res= [SELECT Id, Shipment__c FROM Response__c WHERE Shipment__c!=null and Type__c='ERROR' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Class.: line 66, column 1: Update failed. First exception on row 0 with id; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION';
        msg.Shipment=res.Shipment__c;
        P2G_LastSAPResponseError.main(msg);
    }
    
    @isTest(SeeAllData=true)
    static void mainTestConfirmShipment(){
        Response__c res= [SELECT Id, Shipment__c FROM Response__c WHERE Shipment__c!=null and Type__c='CONFIRM' LIMIT 1];
        PAK_WSMESSAGES.MESSAGE msg = new PAK_WSMESSAGES.MESSAGE();
        msg.Message='Orden de Venta Actualizada: 00002';
        msg.Shipment=res.Shipment__c;
        P2G_LastSAPResponseError.main(msg);
    }
}