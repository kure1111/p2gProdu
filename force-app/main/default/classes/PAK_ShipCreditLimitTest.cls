@isTest
public class PAK_ShipCreditLimitTest {
    @isTest(SeeAllData=true) 
    static void testUpdateWithinCreditLimit() {
        Shipment_Fee_Line__c servL = [SELECT Id,Shipment_Sell_Price__c FROM Shipment_Fee_Line__c WHERE Id ='a1yRQ000005t5ozYAA'];
        servL.Shipment_Sell_Price__c = 20;
        NEU_StaticVariableHelper.setBoolean1(true);
        Test.startTest();
        update servL;
        Test.stopTest();
    }

}