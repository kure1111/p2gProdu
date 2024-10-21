@isTest
public class P2G_altaProveedoresTest {
	@IsTest(SeeAllData=true)
    public static void pruebaTest(){
        Account acc = [SELECT id, Name FROM Account WHERE RecordTypeId = '0124T000000PTuSQAW' LIMIT 1];
        acc.Name = 'pruebatest';
        Update acc;
    }
}