@isTest
public class NEU_Update_Buy_Rate_Test {
    
    @IsTest(SeeAllData=true)
    public static void NEU_insert_Buy_Rate()
    {     
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = '0014T00000BIrxlQAD', Cost_Concept_1__c =10);
        insert fee;
        RecursiveCheck.triggerMonitor.remove('NEU_Update_Buy_Rate');
        fee.Buy_Rate__c = 12;
        update fee;
        Log_Aprobacion__c log = new Log_Aprobacion__c();
        log.Status__c= 'Cambio Precio';
        log.Shipment__c = 'a0JRQ0000001YfZ2AU';
        insert log;
        P2G_updateLog.cambiaStatus('a0JRQ0000001YfZ2AU');
        Shipment_Fee_Line__c spl = [SELECT Id,Shipment_Buy_Price__c, Name FROM Shipment_Fee_Line__c WHERE Shipment__c = 'a0JRQ0000001YfZ2AU' limit 1];
        spl.Shipment_Buy_Price__c = 500000;
        update spl;
    }
    
}