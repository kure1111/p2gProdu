@IsTest(SeeAllData=true)
public class P2G_AcuseRecibidoEmailTest {
	@IsTest
    public static void mainTest(){
        Shipment__c shipment = [SELECT Id, Name, Status_Acuse_SAP__c, Date_Acuse_SAP__c, carrier__r.NEU_Email__c, carrier__r.ActiveSap__c FROM Shipment__c WHERE Status_Acuse_SAP__c != 'ACUSE RECIBIDO' LIMIT 1];
        Shipment_Fee_Line__c serviceLines = [SELECT Id, Name, Orden_Compra__c FROM Shipment_Fee_Line__c WHERE Shipment__r.Id =: shipment.Id LIMIT 1];
		Account carrier = [SELECT Id, Name, NEU_Email__c FROM Account WHERE Record_Type_Name__c = 'Supply Chain Partner' AND Name LIKE '%Prueba%' LIMIT 1];
        shipment.Carrier__c = carrier.Id;
        shipment.Traslado_Ingreso__c = 'Traslado';
        update shipment;
        shipment.Status_Acuse_SAP__c = 'ACUSE RECIBIDO';
        shipment.Date_Acuse_SAP__c = Date.today();
        shipment.Date_Verify_Acuse_SAPTxt__c = Date.today(); 
        carrier.NEU_Email__c = 'javier.peinado@2gologistics.com';
        carrier.ActiveSap__c = true;
        Test.StartTest();
        update carrier;
        update shipment;
        Test.StopTest();
    }
}