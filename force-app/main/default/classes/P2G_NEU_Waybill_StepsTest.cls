@isTest
public class P2G_NEU_Waybill_StepsTest {
	/*
    @isTest(SeeAllData=true)
    static void testConstructorWithValidId() {
        
        Air_Waybill__c testWaybill = [SELECT Id FROM Air_Waybill__c LIMIT 1];
                
        ApexPages.StandardController sc = new ApexPages.StandardController(testWaybill);        
        Test.startTest();
        NEU_Waybill_Steps controller = new NEU_Waybill_Steps(sc);
        Test.stopTest();        
    }
    
    @isTest(SeeAllData=true)
    static void testConstructorWithInvalidId() {        
        Air_Waybill__c emptyWaybill = new Air_Waybill__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(emptyWaybill);
        
        Test.startTest();
        NEU_Waybill_Steps controller = new NEU_Waybill_Steps(sc);
        Test.stopTest();        
    }
*/
    @isTest
    static void NEU_Waybill_Steps()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        insert air_waybill_test;
        
        NEU_Waybill_Steps tws = new NEU_Waybill_Steps(new ApexPages.StandardController(air_waybill_test));
        
        Associated_Document__c associated_document_test_1 = new Associated_Document__c();
        associated_document_test_1.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_1.Account__c = account_test.Id;
        associated_document_test_1.Name = 'Master Waybill';
        insert associated_document_test_1;
        
        Associated_Document__c associated_document_test_2 = new Associated_Document__c();
        associated_document_test_2.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_2.Account__c = account_test.Id;
        associated_document_test_2.Name = 'House Waybill';
        insert associated_document_test_2;
        
        Associated_Document__c associated_document_test_3 = new Associated_Document__c();
        associated_document_test_3.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_3.Account__c = account_test.Id;
        associated_document_test_3.Name = 'Manifest';
        insert associated_document_test_3;
        
        Associated_Document__c associated_document_test_4 = new Associated_Document__c();
        associated_document_test_4.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_4.Account__c = account_test.Id;
        associated_document_test_4.Name = 'Master Label';
        insert associated_document_test_4;
        
        Associated_Document__c associated_document_test_5 = new Associated_Document__c();
        associated_document_test_5.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_5.Account__c = account_test.Id;
        associated_document_test_5.Name = 'House Label';
        insert associated_document_test_5;
        
        Log__c mail_log_test_1 = new Log__c();
        mail_log_test_1.Subject__c = 'FWB:';
        mail_log_test_1.Body__c = '-Test';
        insert mail_log_test_1;
        
        Log__c mail_log_test_2 = new Log__c();
        mail_log_test_2.Subject__c = 'FHL:';
        mail_log_test_2.Body__c = '-Test';
        insert mail_log_test_2;
        
        NEU_Waybill_Steps ws = new NEU_Waybill_Steps(new ApexPages.StandardController(air_waybill_test));
    }
    
    @isTest
    public static void NEU_AWB_Report()
	{
		NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Transporter,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Carrier_Account__c = account_test.Id;
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
     	air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        
        insert air_waybill_test;
        
        NEU_Waybill_Steps tws = new NEU_Waybill_Steps(new ApexPages.StandardController(air_waybill_test));
        
        Log__c mail_log_test_1 = new Log__c();
        mail_log_test_1.Subject__c = 'FWB:';
        mail_log_test_1.Body__c = '\n+CIMFWB:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_1;
        
        Log__c mail_log_test_2 = new Log__c();
        mail_log_test_2.Subject__c = 'FWB:';
        mail_log_test_2.Body__c = '\n+CIMFMA:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_2;
        
        Log__c mail_log_test_3 = new Log__c();
        mail_log_test_3.Subject__c = 'FWB:';
        mail_log_test_3.Body__c = '\n+CIMFNA:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_3;
        
        Log__c mail_log_test_4 = new Log__c();
        mail_log_test_4.Subject__c = 'FWB:';
        mail_log_test_4.Body__c = '\n+CIMFSR:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_4;
        
        Log__c mail_log_test_5 = new Log__c();
        mail_log_test_5.Subject__c = 'FWB:';
        mail_log_test_5.Body__c = '\n+CIMFSA:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_5;
        
        Log__c mail_log_test_6 = new Log__c();
        mail_log_test_6.Subject__c = 'FWB:';
        mail_log_test_6.Body__c = '\n+CIMFSU:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_6;
        
        Log__c mail_log_test_7 = new Log__c();
        mail_log_test_7.Subject__c = 'FWB:';
        mail_log_test_7.Body__c = '\n+CIMFHL:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_7;

		NEU_AWB_Report awbr = new NEU_AWB_Report();
		awbr.month = system.today().month();
		awbr.year = system.today().year();
		awbr.filter = air_waybill_test;
		awbr.search_AWB();
		
		NEU_AWB_Requests_Report awbrr = new NEU_AWB_Requests_Report();
		awbrr.month = system.today().month();
		awbrr.year = system.today().year();
		awbrr.search_AWB();
	} 
}