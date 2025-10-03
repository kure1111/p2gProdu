@isTest
public class P2G_NEU_GenerateWEDocTest {
        
    @isTest
    static void NEU_CreateEntriesExitsFromShipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account account_test = list_accounts[0];
        //insert account_test;
        Account account_test= new Account();
			account_test.Name='Test';
			account_test.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        	account_test.OwnerId=UserInfo.getUserId();        	
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
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-TS-00003';
        insert shipment_test;
        
        Sourcing_Item__c item_test = new Sourcing_Item__c();
        item_test.Name = 'Item Test';
        item_test.Account_Owner__c = account_test.Id;
        insert item_test;
        
        Sourcing_Item__c item_test2 = new Sourcing_Item__c();
        item_test2.Name = 'Item Test2';
        item_test2.Account_Owner__c = account_test.Id;
        insert item_test2;
        
        Shipment_Line__c shipment_line_test = new Shipment_Line__c();
        shipment_line_test.Name = '001';
        shipment_line_test.Item_Name__c = item_test.Id;
        shipment_line_test.Shipment__c = shipment_test.Id;
        shipment_line_test.Units_Shipped__c = 100;
        shipment_line_test.CurrencyIsoCode='MXN';
        insert shipment_line_test;
        
        Shipment_Line__c shipment_line_test2 = new Shipment_Line__c();
        shipment_line_test2.Name = '001';
        shipment_line_test2.Item_Name__c = item_test2.Id;
        shipment_line_test2.Shipment__c = shipment_test.Id;
        shipment_line_test2.Units_Shipped__c = 200;
        shipment_line_test2.CurrencyIsoCode='MXN';
        insert shipment_line_test2;
        
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
        insert inventory_exit_test;
        
        NEU_CreateEntriesExitsFromShipment ceefs = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
        ceefs.create_entries();
        ceefs.return_shipment();
        
        shipment_test.Warehouse_Movement_Type__c = 'Deliveries (Out)';
        update shipment_test;
        
        NEU_CreateEntriesExitsFromShipment ceefs2 = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
        ceefs2.create_exits();
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
        NEU_CreateEntriesExitsFromShipment ceefsWA = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
        //Creacion de NEU_CreateEntriesExitsFromShipment con selected a true
        NEU_CreateEntriesExitsFromShipment ceefsbucle = new NEU_CreateEntriesExitsFromShipment(new ApexPages.StandardController(shipment_test));
        for(NEU_CreateEntriesExitsFromShipment.exit_lines_pallets_s pl : ceefsbucle.palletLinesExits){
            for(NEU_CreateEntriesExitsFromShipment.exit_s e : pl.ex){
                e.selected=true;
            }
        }
        ceefsbucle.create_entries();
        //Forzamos el caso de error en caso de shipment incorrecto
        NEU_CreateEntriesExitsFromShipment ceefsError = new NEU_CreateEntriesExitsFromShipment(null);
        
        
        NEU_GenerateWEDoc gwed = new NEU_GenerateWEDoc(new ApexPages.StandardController(shipment_test));
        
        
        
        NEU_GenerateWEDocSave gweds = new NEU_GenerateWEDocSave(new ApexPages.StandardController(shipment_test));
        gweds.crear();
    }
}