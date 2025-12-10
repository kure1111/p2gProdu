@isTest
private class NEU_test_Transport_Packaging_Data {

    
    public static testMethod void test_NEU_OM_Assign_Transport_Packaging_Data()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Name='ada',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline2;
        Transport_Packaging_Line__c transport_packaging_line = new Transport_Packaging_Line__c(Shipment_Item_Line__c = shipline2.id, Transport_Packaging_Data__c = transporpack.Id);
        insert transport_packaging_line;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Pallet_Container_Type__c pallet_container2 = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container2;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales', Ecommerce__c= true);
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily', E_Commerce__c = true);
        insert d;
        Subfamily__c d2= new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily', E_Commerce__c = true);
        insert d2;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = a.Id, Sourcing_Family__c =c.id,Subfamily__c=d.Id , E_Commerce__c= true);
        insert item;
        Item_Pallet_Type__c item_pallet = new Item_Pallet_Type__c(Name='item pallet', Item_Name__c=item.Id, Packages_Pallet__c=10, Pallet_Type__c=pallet.Id);
        insert item_pallet;
        
        NEU_OM_Assign_Transport_Packaging_Data uda = new NEU_OM_Assign_Transport_Packaging_Data(new ApexPages.StandardController( transporpack ));
        NEU_OM_Assign_Transport_Packaging_Data.Shipment_lines_s lines;
        List<NEU_OM_Assign_Transport_Packaging_Data.Shipment_lines_s> atpd = new List<NEU_OM_Assign_Transport_Packaging_Data.Shipment_lines_s>();
        atpd.add(new NEU_OM_Assign_Transport_Packaging_Data.Shipment_lines_s(shipline,true,true));
        atpd.add(new NEU_OM_Assign_Transport_Packaging_Data.Shipment_lines_s(shipline,false,true));
        
        uda.getShipment_lines();
        uda.getShowShipmentItemsLines();
        uda.getcontainer_selected();
        uda.setcontainer_selected(pallet_container.Id);
        uda.getcontainers();
        uda.calcular();
        uda.crearelacion();
    }
}