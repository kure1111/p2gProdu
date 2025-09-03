@isTest
public class P2G_NoEliminarLineaEnSAPTest {
    //tambien finciona para el trigger ValidateDelete
	@IsTest(SeeAllData=true)
    public static void P2G_NoEliminarLineaEnSAPTest(){
        Response__c response = [SELECT Id, Shipment__c FROM Response__c WHERE Type__c = 'CONFIRM' 
                                	  AND Message__c != 'Carga correcta en recurso confiable'
                                      AND Shipment__c != NULL Order By CreatedDate desc LIMIT 1];
        Shipment_Fee_Line__c feeLine = [SELECT Id, Name FROM Shipment_Fee_Line__c 
                                        WHERE Shipment__c =: response.Shipment__c LIMIT 1];
        delete feeLine;
    }
}