@isTest
private class NEU_test_Generate_Waybill 
{
	public static testMethod void test_NEU_Generate_Waybill() 
	{
        NEU_StaticVariableHelper.setBoolean1(true);

        Account a = new Account(Name = 'Account Test', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales',Airline_Code_Number__c = '000');
		insert a;
		Account supply_chain_test = new Account();
        supply_chain_test.Name = 'Supply Chain Partner Test';
        supply_chain_test.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        supply_chain_test.Business_Area__c = 'Sales'; 
        supply_chain_test.Airline_Code_Number__c = '020';
        insert supply_chain_test;
		Country__c country = new Country__c(Name='test',  ISO_Code_2c__c='EU');
        insert country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',IATA_Code__c='XXX');
        insert location;
		Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo', Site_of_Load__c=location.Id, Site_of_Discharge__c=location.Id, CurrencyIsoCode='USD', Flight_Number__c='10', ETD_from_Point_of_Load__c=system.today(), Country_of_Load__c=country.Id, Country_of_Discharge__c=country.Id, Supplier_Account__c=a.Id, Consignee__c=a.Id, Destination_Agent__c=a.Id);
		insert ship;
        Product_Family__c family = new Product_Family__c(Name = 'Test Account', Business_Area__c = 'Auto-Parts');
        insert family;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'Test Subfamily');
        insert subfamily;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test Item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert item;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'Test Shipment Line', Item_Name__c = item.Id, Units_Shipped__c = 1, Shipping_Weight_Kg__c = 5, Shipping_Volume_m3__c = 10);
        insert shipline;
        Waybill_Master__c wm = new Waybill_Master__c(Airline__c = supply_chain_test.Id, Count__c=1, Starting_Number__c=1111110, Status__c='Open',Used_Numbers__c=0);
	    insert wm;		        
        	
		NEU_Generate_Waybill gwa = new NEU_Generate_Waybill(new ApexPages.StandardController(ship));
		gwa.generate_waybill();
		
		ship.Carrier__c =supply_chain_test.Id;
		update ship;
		
		NEU_Generate_Waybill gwa1 = new NEU_Generate_Waybill(new ApexPages.StandardController(ship));
		gwa1.generate_waybill();
	}
}