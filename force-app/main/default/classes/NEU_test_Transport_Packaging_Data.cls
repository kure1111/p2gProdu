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
private class NEU_test_Transport_Packaging_Data {

      public static testMethod void NEU_OM_GenerateTDI_test() {
      	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        ApexPages.currentPage().getParameters().put('test', 'test');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        NEU_OM_GenerateTDI gpcc = new NEU_OM_GenerateTDI(new ApexPages.StandardController( transporpack ));
        system.debug( 'Prueba realizada' );
       
    }
    
      static testMethod void test_NEU_OM_Save_TDI() {
          NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a =list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        NEU_OM_Save_TDI gpcc = new NEU_OM_Save_TDI(new ApexPages.StandardController( transporpack ));
        system.debug( 'Prueba realizada' );
        Blob b = Blob.valueOf('Test Data');
        gpcc.documento_asociado.Name='Test document.test';
        gpcc.documento_asociado.AuthorId = UserInfo.getUserId();
        gpcc.documento_asociado.IsPublic=true;
        gpcc.documento_asociado.Body = b;
        gpcc.crear();
      
    }
    
    
    static testMethod void NEU_JE_FollowersTransport_Packaging_Data2()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline2;
        Transport_Packaging_Line__c transport_packaging_line = new Transport_Packaging_Line__c(Shipment_Item_Line__c = shipline2.Id, Transport_Packaging_Data__c = transporpack.Id);
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
        NEU_JE_FollowersTransport_Packaging_Data uda = new NEU_JE_FollowersTransport_Packaging_Data(new ApexPages.StandardController( transporpack ));
        List<NEU_JE_FollowersTransport_Packaging_Data.follower_s> lista_de_followers = new List<NEU_JE_FollowersTransport_Packaging_Data.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_JE_FollowersTransport_Packaging_Data.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_JE_FollowersTransport_Packaging_Data.follower_s(listauser[0],false,false,false));
        
        List<NEU_JE_FollowersTransport_Packaging_Data.followersin_s> lista_de_followersin = new List<NEU_JE_FollowersTransport_Packaging_Data.followersin_s>();
        lista_de_followersin.add(new NEU_JE_FollowersTransport_Packaging_Data.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
    }
    
    static testMethod void NEU_JE_FollowersTransport_Packaging_Data()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline2;
        Transport_Packaging_Line__c transport_packaging_line = new Transport_Packaging_Line__c(Shipment_Item_Line__c = shipline2.Id, Transport_Packaging_Data__c = transporpack.Id);
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
        NEU_JE_FollowersTransport_Packaging_Data uda = new NEU_JE_FollowersTransport_Packaging_Data(new ApexPages.StandardController( transporpack ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
    }
    
    public static testMethod void test_NEU_OM_Assign_Transport_Packaging_Data()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
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