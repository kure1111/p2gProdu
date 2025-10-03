@isTest
public class P2G_NEU_NewImportExportButtonTest {
	@isTest(SeeAllData=true)
    static void getAccountTestSuccess(){
        List<User> user = [select Id, ContactId from User where Id =: UserInfo.getUserId()];
        Test.startTest();
        NEU_NewImportExportButton.getAccount();
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void getAccountTestError(){
        List<User> user = [select Id, ContactId from User where Id ='a0E0R0000033d6cUAA'];
        Test.startTest();
        NEU_NewImportExportButton.getAccount();
        Test.stopTest();
    }
}