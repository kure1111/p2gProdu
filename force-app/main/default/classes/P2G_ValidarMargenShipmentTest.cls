@isTest(SeeAllData=true)
public class P2G_ValidarMargenShipmentTest {
	@isTest
    public static void test(){
        Shipment__c shipFn = [SELECT Id, Name, Account_for__c, Total_Services_Sell_Amount__c, Pago_Contado_SAP__c, Shipment_Type__c,
                              Operation_Executive__c, Total_Services_Std_Buy_Amount_number__c, Total_Services_Sell_Amount_number__c, 
                              SPMargen_Operativo__c, Account_for__r.Name FROM Shipment__c
                              WHERE id = 'a0JRQ000000WEr32AG' ORDER BY LastModifiedDate DESC Limit 1];
        Test.startTest();
        List<String> listaEmails = P2G_ValidarMargenShipment.listaEmails();
        String bodyEmail = P2G_ValidarMargenShipment.bodyEmail(shipFn);
        shipFn.Shipment_Status_Plann__c = 'Confirmed';
        shipFn.Pago_Contado_SAP__c = 1250;
        update shipFn;
        Test.stopTest();
    }
}