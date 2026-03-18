@isTest(seeAllData=true)
private class PAK_AlinearCreditoSAPTest {
    
    @isTest
    static void testSFCREDITO_Success() {
        List<Account> accounts = [SELECT Id, Customer_Id__c FROM Account WHERE Customer_Id__c != null LIMIT 1];
        if(accounts.isEmpty()) return;
        
        PAK_AlinearCreditoSAP.CREDITODISPONIBLE cred = new PAK_AlinearCreditoSAP.CREDITODISPONIBLE();
        cred.CustomerID = accounts[0].Customer_Id__c;
        cred.Credito = '10000.50';
        cred.OVAbiertas = '5000.25';
        cred.currencyIsoCode = 'MXN';
        
        List<PAK_AlinearCreditoSAP.CREDITODISPONIBLE> credits = new List<PAK_AlinearCreditoSAP.CREDITODISPONIBLE>{cred};
        
        Test.startTest();
        List<PAK_AlinearCreditoSAP.status> results = PAK_AlinearCreditoSAP.SFCREDITO(credits);
        Test.stopTest();
    }
    
    @isTest
    static void testSFCREDITO_Error() {
        PAK_AlinearCreditoSAP.CREDITODISPONIBLE cred = new PAK_AlinearCreditoSAP.CREDITODISPONIBLE();
        cred.CustomerID = 'ID_INEXISTENTE';
        cred.Credito = '10000';
        cred.OVAbiertas = '5000';
        
        List<PAK_AlinearCreditoSAP.CREDITODISPONIBLE> credits = new List<PAK_AlinearCreditoSAP.CREDITODISPONIBLE>{cred};
        
        Test.startTest();
        List<PAK_AlinearCreditoSAP.status> results = PAK_AlinearCreditoSAP.SFCREDITO(credits);
        Test.stopTest();
    }
}