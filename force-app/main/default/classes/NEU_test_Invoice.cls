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
private class NEU_test_Invoice {

    static testMethod void NEU_Invoice_Save_PDF() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a =  list_accounts[0];
        insert a;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = a.Id;
        importexportquote.Freight_Mode__c='Air';
        importexportquote.Service_Mode__c='Import';
        importexportquote.Service_Type__c='LCL Cargo';
        importexportquote.Move_Type__c='Door to Door';
        importexportquote.Origin_Address__c='tst adrress'; 
        insert importexportquote;
        
        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = a.Id;
        ship.Freight_Mode__c = 'Sea'; 
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
        Invoice__c i_test = new Invoice__c();
        i_test.Account__c = a.Id;
        i_test.Import_Export_Quote_Order__c = importexportquote.Id;
        i_test.Shipment__c = ship.Id;
        insert i_test;
        
        Invoice_Line__c il_test = new Invoice_Line__c();
        il_test.Invoice__c = i_test.Id;
        il_test.Amount__c = 10;
        il_test.Units__c = 10;
        il_test.Unit_Price__c = 10;
        il_test.Total_VAT__c = 10;
        insert il_test;
        
        NEU_Invoice_Save_PDF i_save_pdf = new NEU_Invoice_Save_PDF(new ApexPages.StandardController(i_test));
        i_save_pdf.crear();
        i_save_pdf.return_page();
        
    }
    
    static testMethod void NEU_Invoice_PDF() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a =  list_accounts[0];
        insert a;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = a.Id;
        importexportquote.Freight_Mode__c='Air';
        importexportquote.Service_Mode__c='Import';
        importexportquote.Service_Type__c='LCL Cargo';
        importexportquote.Move_Type__c='Door to Door';
        importexportquote.Origin_Address__c='tst adrress'; 
        insert importexportquote;
        
        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = a.Id;
        ship.Freight_Mode__c = 'Sea'; 
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
        Invoice__c i_test = new Invoice__c();
        i_test.Account__c = a.Id;
        i_test.Import_Export_Quote_Order__c = importexportquote.Id;
        i_test.Shipment__c = ship.Id;
        insert i_test;
        
        Invoice_Line__c il_test = new Invoice_Line__c();
        il_test.Invoice__c = i_test.Id;
        il_test.Amount__c = 10;
        il_test.Units__c = 10;
        il_test.Unit_Price__c = 10;
        il_test.Total_VAT__c = 10;
        insert il_test;
        
        NEU_Invoice_PDF i_pdf = new NEU_Invoice_PDF(new ApexPages.StandardController(i_test));
    }
    
    static testMethod void NEU_NewInvoiceButton() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id; 
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
        
        /*Customer_Quote__c import_export_test = new Customer_Quote__c();
        import_export_test.Account_for__c = account_test.Id;
        insert import_export_test;*/
    	
    	NEU_NewInvoiceButton nib = new NEU_NewInvoiceButton();
    	Test.setCurrentPageReference(new PageReference('Page.myPage')); 
		//System.currentPageReference().getParameters().put('import_export_id',import_export_test.Id);
    	System.currentPageReference().getParameters().put('shipment_id',shipment_test.Id);
    	nib.redirect();
    }
}