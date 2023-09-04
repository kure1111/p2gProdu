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
private class NEU_test_Disbursements {

    static testMethod void NEU_Disbursement_View()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
            // TO DO: implement unit test
            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
            Account a = list_accounts[0];
            insert a;
            Account sup = list_accounts[1];
        	insert sup;
            Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
            insert ship;
            Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Only_Warehouse_Service__c = true);
            insert importexportquote;
            Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=ship.Id, Account__c=sup.Id, Import_Export_Quote_Order__c = importexportquote.Id);
            insert shipdis;
            Associated_Document__c documento_asociado = new Associated_Document__c ( Name = ship.Name +'%', Shipment__c = ship.Id, Account__c = a.Id, Shipment_Disbursement__c = shipdis.Id);
            insert documento_asociado;
            NEU_Disbursement_View dv = new NEU_Disbursement_View();
            dv.sta_list ='';
            dv.step_Instalacion = '2';
            dv.serv_list = '';
            dv.freight_list = '';
             // dv.new_filter_disbursement.Planned_ETD_filter__c = system.today();
            //dv.new_filter_disbursement.Planned_ETA_filter__c = system.today();
            dv.anterior_siguiente();
            dv.getETA_operator_list();
            dv.sta_list ='';
            dv.serv_list = '';
            dv.freight_list = '';
            dv.search_Disbursements();

            dv.search_ordenacion();
            dv.ETA_operator_selected = 'less or equal';
            dv.ETD_operator_selected = 'less or equal';
            dv.new_filter_disbursement.Planned_ETD_filter__c = system.today();
            dv.new_filter_disbursement.Planned_ETA_filter__c = system.today();
            dv.search_Disbursements2();
            dv.save_changes();
            dv.go_compare_disbursement();
            dv.getETD_operator_list();
    }
    
    static testMethod void NEU_NewDisbursementButton()
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
        
        Customer_Quote__c import_export_test = new Customer_Quote__c();
        import_export_test.Account_for__c = account_test.Id;
        import_export_test.Only_Warehouse_Service__c = true;
        insert import_export_test;
    	
    	NEU_NewDisbursementButton ndb = new NEU_NewDisbursementButton();
    	Test.setCurrentPageReference(new PageReference('Page.myPage')); 
		System.currentPageReference().getParameters().put('import_export_id',import_export_test.Id);
    	System.currentPageReference().getParameters().put('shipment_id',shipment_test.Id);
    	ndb.redirect();
    }
}