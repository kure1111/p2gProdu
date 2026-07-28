@IsTest(seeAllData=true)
public class P2G_LockSellPriceTest {
    @IsTest
    static void mainTest(){
        Shipment_Fee_Line__c serviceLine = [SELECT Id, Shipment__c, Shipment__r.Account_for__c, Shipment__r.Account_for__r.Bloqueo_Tarifario__c,  Service_Rate_Name__r.CustomRate__c, Sap_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type__r.name   
                                            FROM Shipment_Fee_Line__c WHERE Shipment__r.Account_for__r.Name 
                                            LIKE '%CLIENTE EJEMPLO%' ORDER BY createddate DESC LIMIT 1
                                           ];
        NEU_StaticVariableHelper.setBoolean1(true);
        Test.startTest();
        serviceLine.Shipment__r.Account_for__r.Bloqueo_Tarifario__c = true;
        serviceLine.Shipment_Sell_Price__c = 2222;
        update serviceLine;
        Test.stopTest();
    }
}