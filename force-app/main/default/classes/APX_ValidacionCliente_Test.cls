@isTest
public class APX_ValidacionCliente_Test {

    @isTest
    public static void runTest(){
        
		Test.startTest();        
            Account acc = TestDataFactory.createAccounts('Acc customer', 'Customer');                		
            List<String> ids = new List<String>();
            ids.add(acc.Id);
        	APX_ValidacionCliente.senToSap(ids);
        	APX_ValidacionCliente.senToSap(ids);
        	ids.clear();
        	ids.add('idFalso');
        	APX_ValidacionCliente.senToSap(ids);
        Test.stopTest();
    }
       
}