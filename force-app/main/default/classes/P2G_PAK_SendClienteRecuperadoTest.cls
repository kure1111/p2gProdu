@isTest
public class P2G_PAK_SendClienteRecuperadoTest {

    @isTest(SeeAllData=true)
    public static void mainTest(){
        List<Account> accList=[SELECT Id, Customer_Id__c, RecordTypeId, OwnerId FROM Account LIMIT 1];
        Set<Id> setIdsAcc= new Set<Id>();
        setIdsAcc.add(accList[0].Id);
        Test.startTest();
        PAK_SendClienteRecuperado.send(setIdsAcc);
        Test.stopTest();
    }
}