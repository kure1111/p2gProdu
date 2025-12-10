@isTest
public class Trigger_DisbursementLine_Test {
    //trigger afectados
    //NEU_ActualizaDISLine
    //NEU_Update_Total_Disbursement_Excl_VAT
    @isTest(SeeAllData=true)
    public static void DisbursementLineTest(){
        Shipment_Disbursement__c shipdis = [SELECT Id, Shipment__c, Import_Export_Quote_Order__c FROM Shipment_Disbursement__c Order By CreatedDate desc LIMIT 1];
        Disbursement_Line__c dl = new Disbursement_Line__c(Name='Test DL', Disbursement__c=shipdis.Id, Amount__c = 123, Import_Export_Quote_Order__c = shipdis.Import_Export_Quote_Order__c, Shipment__c = shipdis.Shipment__c);
        insert dl;
        dl.Amount__c = 234;
        Update dl;
    }
}