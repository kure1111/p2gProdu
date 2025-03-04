@isTest(SeeAllData=true)
public class P2G_ValidarMargenShipmentTest {
	@isTest
    public static void test(){
        Shipment_Fee_Line__c serviceLine =[SELECT Id, Shipment__c FROM Shipment_Fee_Line__c
                              WHERE Carrier__c != Null AND Carrier__c != '' AND Shipment__r.Shipment_Status_Plann__c != 'Confirmed' AND Shipment__r.SPMargen_Operativo__c > 8 AND Shipment__r.Account_for__r.Owner.SalesEmployer__c != Null
                            AND Shipment__r.Account_for__r.Venta_Sap__c = 'Contado' ORDER BY LastModifiedDate DESC Limit 1];
       	Shipment__c shipFn = [SELECT Id, Name, Account_for__c, Total_Services_Sell_Amount__c, Pago_Contado_SAP__c, Shipment_Type__c,
                              Operation_Executive__c, Total_Services_Std_Buy_Amount_number__c, Total_Services_Sell_Amount_number__c, 
                              SPMargen_Operativo__c, Total_Services_Std_Profit__c, Profit__c FROM Shipment__c
                              WHERE id = 'a0JRQ000000WEr32AG' ORDER BY LastModifiedDate DESC Limit 1];
        Test.startTest();
        List<String> listaEmails = P2G_ValidarMargenShipment.listaEmails();
        Shipment__c getShipment = P2G_ValidarMargenShipment.getShipment(shipFn.Id);
        String bodyEmail = P2G_ValidarMargenShipment.bodyEmail(getShipment);
        String validarMargen = P2G_ValidarMargenShipment.validarMargen(getShipment, '');
        String MargenEs = P2G_ValidarMargenShipment.MargenEs(getShipment);
        String margenMenor = P2G_ValidarMargenShipment.margenMenor(5, 8);
        P2G_ValidarMargenShipment.envioEmail(getShipment.Name, bodyEmail, listaEmails);
        Log_Aprobacion__c creaLogAprobacion = P2G_ValidarMargenShipment.creaLogAprobacion(getShipment.Id,34000);
        List<P2G_Advertencia.csvLine> getShipmentFeeLines = P2G_ValidarMargenShipment.getShipmentFeeLines(getShipment.Id);
        shipFn.Shipment_Status_Plann__c = 'Confirmed';
        shipFn.Pago_Contado_SAP__c = 1250;
        shipFN.Traslado_Ingreso__c = 'Traslado';
        update shipFn;
        Test.stopTest();
    }
}