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
private class NEU_test_Shipment_Entry {

   
  /*public static testMethod void NEU_Shipment_Entry()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Transporter,');
                
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = list_accounts[1];
        insert sup;        
        Account tr = list_accounts[2];
        insert tr;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Items_Account_Owner__c = a.Id);
        insert b;
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = a.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = b.id, Account_for__c = a.Id, Authorized_Credit__c =true, Quotation_Status__c ='Approved as Succesful');
        Customer_Quote__c importexportquote = new Customer_Quote__c(Consignee__c = a.Id, Supplier_Account__c = tr.Id, Catalog_Price_List__c = b.id, Account_for__c = a.Id, Authorized_Credit__c =true, Quotation_Status__c ='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '');
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Auto-Parts');
        insert c;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        Sourcing_Item__c g2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,RecordTypeId = Schema.SobjectType.Sourcing_Item__c.getRecordTypeInfosByName().get('Service').getRecordTypeId());
        insert g2;
        Item_List_Price__c f = new Item_List_Price__c(Item_Name__c = g.Id, Price_List__c=b.Id,List_Price__c=10 );
        insert f;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=a.Id, Authorized_Credit__c = true, Status__c='Close' );
        insert shop;
        Subfamily__c d2= new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily', E_Commerce__c = true);
        insert d2;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'test item', Account_Owner__c = a.Id, Sourcing_Family__c =c.id,Subfamily__c=d2.Id , E_Commerce__c= true, Weight_Kgs__c =10 );
        insert item;
        Shopping_Cart_line__c shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = item.Id, Units__c=10,Supplier__c=sup.Id);
        insert shoplines;
        Supplier_Quote__c sup_quote = new Supplier_Quote__c(Supplier__c = sup.Id, Supplier_Quote_Status__c = 'Approved');
        insert sup_quote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=sup_quote.Id, Name=' test quote line', Quantity__c=10);
        insert sup_quote_lines;
        Container_Type__c container = new Container_Type__c(Name='container', Cargo_Volume_m3__c = 10, Cargo_Weight_Kg__c=10 );
        insert container;
        Pallet_Type__c pallet = new Pallet_Type__c(Name='pallet', Pallet_Weight_Kg__c = 10, Pallet_Volume_m3__c = 10);
        insert pallet;
        Pallet_Container_Type__c pallet_container = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container;
        Pallet_Container_Type__c pallet_container2 = new Pallet_Container_Type__c(Name='pallet container', Container_Type__c=container.Id, Pallet_Type__c=pallet.Id, Number_of_Pallets__c= 10);
        insert pallet_container2;
        Item_Pallet_Type__c item_pallet = new Item_Pallet_Type__c(Name='item pallet', Item_Name__c=item.Id, Packages_Pallet__c=10, Pallet_Type__c=pallet.Id);
        insert item_pallet;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c = item.Id, Units__c=10);
        insert quote;
        
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
        
        //Customer_Quote__c importexportquote2 = new Customer_Quote__c(Consignee__c = a.Id, Supplier_Account__c = sup.Id, Catalog_Price_List__c = b.id, Account_for__c = a.Id, Authorized_Credit__c =true, Quotation_Status__c ='Approved as Succesful');
        Customer_Quote__c importexportquote2 = new Customer_Quote__c(Consignee__c = a.Id, Supplier_Account__c = tr.Id, Catalog_Price_List__c = b.id, Account_for__c = a.Id, Authorized_Credit__c =true, Quotation_Status__c ='Quote being prepared');
        insert importexportquote2;
        Quote_Item_Line__c quote2 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote2.id,Name = 'lineas items', Item_Name__c = item.Id, Item_Supplier_Owner__c=sup.Id, Units__c=10);
        insert quote2;

		Import_Export_Fee_Line__c ie_service_line2 = new Import_Export_Fee_Line__c();
		ie_service_line2.Import_Export_Quote__c = importexportquote2.Id;
		ie_service_line2.Name = '001'; 
		ie_service_line2.Service_Rate_Name__c = service_rate.Id; 
		ie_service_line2.Extension_Service_Name__c = 'Test Name'; 
		ie_service_line2.Discount__c = 10; 
		ie_service_line2.Quote_Buy_Price__c = 10; 
		ie_service_line2.Quote_Sell_Price__c = 10;
		ie_service_line2.Units__c = 10;
        insert ie_service_line2;
        
        importexportquote2.Quotation_Status__c ='Approved as Succesful';
        update importexportquote2;
        
        Warehouse__c ware = new Warehouse__c(Name='test warehause', Account_Owner__c = a.Id);
        insert ware;
        Warehouse_Storage_Bin__c ware_storage = new Warehouse_Storage_Bin__c(Name='test warehause', Warehouse__c = ware.Id);
        insert ware_storage;
        Inventory_Entry__c sentry = new Inventory_Entry__c(Item__c = item.Id, Units_Entry__c=10,Warehouse_Storage_Bin__c= ware_storage.Id);
        insert sentry;

        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import');
        insert ship;
        
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Item_Name__c=g.id,Supplier_Quote_Line__c=sup_quote_lines.id,Supplier_Quote__c=sup_quote.id, Shipping_Weight_Kg__c =100, Shipping_Volume_m3__c = 100,Expense_Amount__c =10,Units_Shipped__c=100 );
        insert shipline;
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line', Item_Name__c=g2.id,Quote_Item_Line__c=quote.id,Import_Export_Quote__c=importexportquote.id, Shipping_Weight_Kg__c =200, Shipping_Volume_m3__c = 100,Expense_Amount__c =10);
        insert shipline2;
        
        
        ApexPages.StandardController controller = new ApexPages.StandardController(ship);
        NEU_Shipment_Entry uda = new NEU_Shipment_Entry(controller);
        ApexPages.currentPage().getParameters().put('test', 'test');
        uda.totalunits=uda.totalunits;
        uda.pendingunits=uda.pendingunits;
        uda.nombreitem=uda.nombreitem;
        uda.decimalSep=uda.decimalSep;
        uda.thousandSep=uda.thousandSep;
        
        List<string> accountid = new List<string>();
        accountid.add(a.id);
        sObject s =  Database.query('SELECT Id, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Name FROM Shipment_Line__c limit 1');
        NEU_Shipment_Entry.getcurrencyIsoCode(s);
        
        uda.getLines();

        NEU_Shipment_Entry.Warehouse_Storage_Bin_s lines5 = new NEU_Shipment_Entry.Warehouse_Storage_Bin_s(ware_storage);
        lines5.units =100;
        lines5.getWharehouse_Id();
        lines5.getWharehouse_Name();
        lines5.getid();
        lines5.unitsSep=lines5.unitsSep;
        lines5.newUnitsSep=lines5.newUnitsSep;
        NEU_Shipment_Entry.Warehouse_Storage_Bin_s lines6 = new NEU_Shipment_Entry.Warehouse_Storage_Bin_s(ware_storage);
        lines6.units =100;
        lines6.getWharehouse_Id();
        lines6.getWharehouse_Name();
        lines6.getid();
        lines6.getStorage_Bin();
        lines6.getName();
        NEU_Shipment_Entry.Line_s lines = new NEU_Shipment_Entry.Line_s(shipline,true,'extension',10,lines5,shipline.Id);
        NEU_Shipment_Entry.Line_s lines3 = new NEU_Shipment_Entry.Line_s(shipline,true,'extension',10,lines5,shipline.Id);
        
        lines.unitsSep=lines.unitsSep;
        lines.getFinalUnits();
        lines.getFinalStock();
        lines.getId();
        lines.getHeaderId();
        lines.getItemId();
        lines.getItemType();
        lines.getItemName();
        lines.getFamilyName();
        
        lines3.getFinalUnits();
        lines3.getFinalStock();
        lines3.getId();
        lines3.getHeaderId();
        lines3.getItemId();
        lines3.getItemType();
        lines3.getItemName();
        lines3.getFamilyName(); 

        uda.applyLines();
        
        uda.newItemSelected();
        uda.idline=uda.getLines()[0].getId();
        uda.newItemSelected();
        uda.applyLines();
        uda.idLineItem=g.Id;
        uda.getStockEntries();
        for(NEU_Shipment_Entry.Line_s  li : uda.getLines())
        {
            li.selected =true;
            li.units =1;
            li.nounits =1;
            uda.idline=li.getId();
            uda.newItemSelected();
            uda.updidLineItem=li.getId();
            uda.updateStockEntries();
            uda.idItem=li.getItemId();
            li.units = 200;
        }
        uda.applyLines();
        uda.cancelLines();
     }*/
}