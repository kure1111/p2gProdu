@isTest
public class P2G_NEU_Ship_Line_Update_MarginTest {
	@isTest(SeeAllData=true)
    static void NEU_Shipment_Line_Update_Margin(){
        Shipment__c sp= [SELECT Id FROM Shipment__c WHERE Operador_Validado__c!=null AND ( Vehicle__c!=null OR Vehicle__r.Vehiculo_Validado__c !=TRUE) ORDER BY CreatedDate DESC LIMIT 1];
        Shipment_Line__c spLine= new Shipment_Line__c();
        spLine.Name='';
        spLine.Shipment__c=sp.Id;
        insert spLine;        
    }
}