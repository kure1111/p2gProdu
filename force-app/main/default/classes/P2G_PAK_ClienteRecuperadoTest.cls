@isTest
public class P2G_PAK_ClienteRecuperadoTest {
    @isTest
    static void PAK_ClienteRecuperado(){      
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();        	
        insert acc;
        
    }
}