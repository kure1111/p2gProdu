@isTest(seeAllData=true)
private class PAK_CUSTOMERIDTest {
    
    @isTest
    static void testSFCUSTOMER_Success() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        PAK_CUSTOMERID.CUSTOMER cust = new PAK_CUSTOMERID.CUSTOMER();
        cust.IDSFCLIENTE = acc.Id;
        cust.CUSTOMER_ID = 'TEST-CID-' + DateTime.now().getTime();
        
        List<PAK_CUSTOMERID.CUSTOMER> customers = new List<PAK_CUSTOMERID.CUSTOMER>{cust};
        
        Test.startTest();
        List<PAK_CUSTOMERID.status> results = PAK_CUSTOMERID.SFCUSTOMER(customers);
        Test.stopTest();
    }
    
    @isTest
    static void testSFCUSTOMER_Error() {
        PAK_CUSTOMERID.CUSTOMER cust = new PAK_CUSTOMERID.CUSTOMER();
        cust.IDSFCLIENTE = '001000000000000';
        cust.CUSTOMER_ID = 'TEST-CID-123';
        
        List<PAK_CUSTOMERID.CUSTOMER> customers = new List<PAK_CUSTOMERID.CUSTOMER>{cust};
        
        Test.startTest();
        List<PAK_CUSTOMERID.status> results = PAK_CUSTOMERID.SFCUSTOMER(customers);
        Test.stopTest();
    }
}