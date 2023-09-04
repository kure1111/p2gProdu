@isTest
private class NEU_test_QR_Response {
  
    static testMethod void  NEU_getWareHousesExit()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
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
                
        Warehouse_Exit_Order__c testWEO = new Warehouse_Exit_Order__c();
        testWEO = NEU_QR_Response.getWareHousesExit(String.valueOf(warehouse_exit_order_test.Id));
        testWEO = NEU_QR_Response.getWareHousesExitByShipment(String.valueOf(warehouse_exit_order_test.Id), 'test pallet');

        List<Inventory_Exit__c> ielists = new List<Inventory_Exit__c>();
        ielists = NEU_QR_Response.getInventoryExits(String.valueOf(shipment_test.Id), 'test_pallet');
        ielists = NEU_QR_Response.getInventoryExitsByShipment(String.valueOf(shipment_test.Id), 'test_pallet');
        
        decimal totaluw = NEU_QR_Response.getTotalUnitsWarehouse(String.valueOf(warehouse_exit_order_test.Id));
        
    }
}