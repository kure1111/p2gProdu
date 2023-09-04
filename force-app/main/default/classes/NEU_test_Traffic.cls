/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_Traffic {

    public static testMethod void test_NEU_TrafficSummary() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Traffic__c traffic = new Traffic__c(Account__c = a.Id, Country_of_Discharge__c = Country.Id, Country_of_Load__c = Country.Id, Profit_Proyection__c = 10, Revenue_Proyection__c = 10, Shipments_Proyection__c = 10, Site_of_Discharge__c = localizacion.Id, Site_of_Load__c = localizacion.Id);
        insert traffic;
        
        /*Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__C = sup.Id, Freight_Mode__c='Sea',Service_Mode__c='Import', Service_Type__c='LCL Cargo',
        Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,
        Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address',
        RecordTypeId = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId(), Traffic__c  = traffic.Id, Quotation_Status__c ='Approved as Succesful',
        Order_in_Progress_Date__c=system.today());*/
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__C = sup.Id, Freight_Mode__c='Sea',Service_Mode__c='Import', Service_Type__c='LCL Cargo',
        Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,
        Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address',
        RecordTypeId = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId(), Traffic__c  = traffic.Id, Quotation_Status__c ='Quote being prepared',
        Order_in_Progress_Date__c=system.today());
        insert importexportquote;
        Quote_Item_Line__c quote_item = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id, Name = 'lineas items',Units__c=10);
        insert quote_item;
        
        Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Sercie Rate Test';
		service_rate.Fee_Category__c = 'Disbursement';
		service_rate.Rate_Type__c = 'Per Kg';
		service_rate.Account_for__c = a.Id;
        insert service_rate;
		
		Import_Export_Fee_Line__c ie_service_line = new Import_Export_Fee_Line__c();
		ie_service_line.Import_Export_Quote__c = importexportquote.Id;
		ie_service_line.Name = '001'; 
		ie_service_line.Service_Rate_Name__c = service_rate.Id; 
		ie_service_line.Extension_Service_Name__c = 'Test Name'; 
		ie_service_line.Discount__c = 10; 
		ie_service_line.Quote_Buy_Price__c = 10; 
		ie_service_line.Quote_Sell_Price__c = 10;
		ie_service_line.Units__c = 10;
        insert ie_service_line;
        
        importexportquote.Quotation_Status__c ='Approved as Succesful';
        update importexportquote;
        
    	NEU_TrafficSummary ts = new NEU_TrafficSummary(new ApexPages.StandardController( traffic ));
    	ts.current_year();
    	ts.last_year();
    	
    }
}