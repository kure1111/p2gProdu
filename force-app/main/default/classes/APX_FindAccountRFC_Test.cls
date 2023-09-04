@isTest
public class APX_FindAccountRFC_Test {

    
    @isTest
    public static void runTest(){
                        
        Account acc = TestDataFactory.createAccounts('User Prospect','Prospect');
        Account acc2 = TestDataFactory.createAccounts('User Prospect','Prospect');
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(acc2);
        APX_FindAccountRFC.findRFC(accList);
    }
    
}