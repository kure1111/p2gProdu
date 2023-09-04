@isTest
public class NEU_ActualizaFolioIETest {

    //Test para el trigger NEU_ActualizaFolioIETest
    
    static testMethod void NEU_ActualizaFolioIE()
	{
		List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Segment__c = 'Nuevo';
        insert account_test;
        Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
        
        
		Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.Team__c = 'P2G';
        quote_test.Pricing_Executive__c = userInfo.getUserId();
        insert quote_test;
        quote_test.Service_Mode__c = 'Export';
        quote_test.Service_Type__c = 'FTL';
        update quote_test;
	}
}