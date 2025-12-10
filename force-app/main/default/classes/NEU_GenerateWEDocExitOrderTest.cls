@isTest
public class NEU_GenerateWEDocExitOrderTest {
	@isTest(SeeAllData=true)
    static void NEU_CreateInventoryExits()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	//List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account account_test = list_accounts[0];
        //insert account_test;
        Account account_test=[SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
        RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
        AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
    	
    	Country__c country_test = new Country__c();
    	country_test.Name = 'Country Test';
    	country_test.ISO_Code__c = 'EUR';
        insert country_test;
        
        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test'; 
        location_test.Country__c = country_test.Id; 
        location_test.Subdivision__c = 'Subdivision'; 
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;
    	
    	Warehouse__c warehouse_test = new Warehouse__c();
    	warehouse_test.Name = 'Warehouse Test';
    	warehouse_test.Total_Space_m2__c = 100;
    	insert warehouse_test;
    	
    	Warehouse_Storage_Bin__c warehouse_sb_test = new Warehouse_Storage_Bin__c();
    	warehouse_sb_test.Name = 'WSB';
    	warehouse_sb_test.Warehouse__c = warehouse_test.Id;
    	insert warehouse_sb_test;
    	
    	Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Road';
        shipment_test.Service_Mode__c = 'NATIONAL';
        shipment_test.Service_Type__c = 'FTL';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        shipment_test.Warehouse__c = warehouse_test.Id;
        shipment_test.Warehouse_Movement_Type__c = 'Entries (In)';
        shipment_test.Name = 'SP-TS-00004';
        insert shipment_test;
        
        Sourcing_Item__c item_test = new Sourcing_Item__c();
        item_test.Name = 'Item Test';
        item_test.Account_Owner__c = account_test.Id;
        insert item_test;

        Shipment_Line__c shipment_line_test = new Shipment_Line__c();
        shipment_line_test.Name = '001';
        shipment_line_test.Item_Name__c = item_test.Id;
        shipment_line_test.Shipment__c = shipment_test.Id;
        shipment_line_test.Units_Shipped__c = 100;
        insert shipment_line_test;

        Shipment_Line__c shipment_line_test2 = new Shipment_Line__c();
        shipment_line_test2.Name = '002';
        shipment_line_test2.Item_Name__c = item_test.Id;
        shipment_line_test2.Shipment__c = shipment_test.Id;
        shipment_line_test2.Units_Shipped__c = 100;
        insert shipment_line_test2;
    	
    	Warehouse_Exit_Order__c warehouse_exit_order_test = new Warehouse_Exit_Order__c();
    	warehouse_exit_order_test.Account_for_Customer__c = account_test.Id;
    	warehouse_exit_order_test.Warehouse__c = warehouse_test.Id;
    	insert warehouse_exit_order_test;
    	
    	Inventory_Entry__c inventory_entry_test = new Inventory_Entry__c();
    	inventory_entry_test.Warehouse__c = warehouse_test.Id;
    	inventory_entry_test.Warehouse_Storage_Bin__c = warehouse_sb_test.Id;
    	inventory_entry_test.Item__c = item_test.Id;
    	inventory_entry_test.Shipment__c = shipment_test.Id;
    	inventory_entry_test.Shipment_Item_Line__c = shipment_line_test.Id;
    	inventory_entry_test.Units_Entry__c = 100;
    	insert inventory_entry_test;
    	
    	Inventory_Exit__c inventory_exit_test = new Inventory_Exit__c();
    	inventory_exit_test.Inventory_Entry__c = inventory_entry_test.Id;
    	inventory_exit_test.Warehouse__c = warehouse_test.Id;
    	inventory_exit_test.Warehouse_Storage_Bin__c = warehouse_sb_test.Id;
    	inventory_exit_test.Item__c = item_test.Id;
    	inventory_exit_test.Shipment__c = shipment_test.Id;
    	inventory_exit_test.Shipment_Item_Line__c = shipment_line_test.Id;
    	inventory_exit_test.Units_Picked__c = 10;
    	inventory_exit_test.Warehouse_Exit_Order__c = warehouse_exit_order_test.Id;
    	insert inventory_exit_test;

    	NEU_CreateInventoryExits cie = new NEU_CreateInventoryExits(new ApexPages.StandardController( warehouse_test));
    	cie.search_entries();
    	cie.create_exits();
    	cie.return_warehouse();

        //Añadimos varios pallet en la clase
        Pallet_warehouse__c pallet_wa = new pallet_warehouse__c();
        pallet_wa.Height_cm__c = 20;
        pallet_wa.lenght_cm__c = 20;
        insert pallet_wa;
        Pallet_warehouse__c pallet_wa2 = new pallet_warehouse__c();
        pallet_wa2.Height_cm__c = 40;
        pallet_wa2.lenght_cm__c = 40;
        insert pallet_wa2;

        shipment_line_test.pallet_warehouse__c = pallet_wa.Id;
        shipment_line_test2.pallet_warehouse__c = pallet_wa2.Id;
        update shipment_line_test;
        update shipment_line_test2;
        //Creamos una clase con un pallet asignado
        NEU_CreateInventoryExits cie2 = new NEU_CreateInventoryExits(new ApexPages.StandardController( warehouse_test));
        cie2.search_entries();
        cie2.create_exits();
        cie2.return_warehouse();

        //Forzamos el error para pasar por el catch
        NEU_CreateInventoryExits cieError = new NEU_CreateInventoryExits(null);


        NEU_GenerateWEDocExitOrder gwedeo = new NEU_GenerateWEDocExitOrder(new ApexPages.StandardController(warehouse_exit_order_test));
    	
    	NEU_GenerateWEDocExitOrderSave gwedeos = new NEU_GenerateWEDocExitOrderSave(new ApexPages.StandardController(warehouse_exit_order_test));
    	gwedeos.crear();
    }
}