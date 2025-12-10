@isTest
public class NEU_Test_Shipment_Warnings {
	@isTest(SeeAllData=true)
    static void NEU_Shipment_Warnings()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
    	
    	Country__c country_test = new Country__c();
    	country_test.Name = 'Country Test';
    	country_test.ISO_Code__c = 'EUR';
        insert country_test;
        
        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test'; 
        location_test.Country__c = country_test.Id; 
        location_test.Subdivision__c = 'Sbudivision'; 
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;
    	
    	Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        shipment_test.Direccion_Monitoreo__c = 'Test';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-TS-00061';
        insert shipment_test;
        
        NEU_Shipment_Warnings rtt = new NEU_Shipment_Warnings(new ApexPages.StandardController(shipment_test));
        
        NEU_WarningsRecords wr = new NEU_WarningsRecords();
    	wr.setobject_selected('Shipment__c');
    	wr.getobject_selected();
    	wr.setid_record_selected(shipment_test.Id);
    	wr.getid_record_selected();
    	wr.load_warnings();
    }
}