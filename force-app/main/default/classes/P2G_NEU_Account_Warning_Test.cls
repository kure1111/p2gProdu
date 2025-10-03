@isTest
public class P2G_NEU_Account_Warning_Test {
    
    @isTest
    public static void test_LimitExceeded() {
        // Consultamos el campo sin intentar modificarlo
        Account acc=new Account();
		acc.Name='TEST';
		acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
		insert acc;
        // Simulación de controlador
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        
        Test.startTest();
        NEU_Account_Warnings controller = new NEU_Account_Warnings(stdController);
        Test.stopTest();

       
    }
}