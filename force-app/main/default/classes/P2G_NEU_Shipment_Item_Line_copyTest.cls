@isTest
public class P2G_NEU_Shipment_Item_Line_copyTest {
    
    @testSetup
    static void setup(){
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account supplier = list_accounts[1];
        insert supplier;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/);
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id , E_Commerce__c = true);
        insert item;
        Shipment__c ship = new Shipment__c(Name='SP-FN-24-TEST',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name='.';
        quote.Account_for__c = a.Id;
        quote.Team__c = 'P2G';
        quote.Quotation_Status__c = 'Quote being prepared';
        quote.Customer_Reference__c = 'hola soy una prueba';
        quote.Valid_From__c = system.today();
        quote.Valid_Until__c = system.today();
        quote.Comercio_Exterior__c = 'No';
        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'NATIONAL';
        quote.Service_Type__c = 'FTL';
        quote.CurrencyIsoCode = 'MXN';
        quote.ETD__c = Date.today();
        quote.ETA__c = Date.today();
        quote.Community_Status__c = 'CUSTOMER CREATED';
        quote.Pricing_Executive__c= userT.Id;
        quote.Operations_Exec__c = userT.Id;
        insert quote;
        
        Quote_Item_Line__c quoteItem = new Quote_Item_Line__c(Import_Export_Quote__c = quote.id,Name = 'lineas items');
        insert quoteItem;
        
        
    }
    
    @isTest
    static void NEU_Shipment_Item_Line_copy(){
                
        Account a =[SELECT Id FROM Account  WHERE RecordType.Name='Customer' LIMIT 1];
        Account supplier =[SELECT Id FROM Account  WHERE RecordType.Name='Supplier' LIMIT 1];        
        Product_Family__c c = [SELECT Id FROM Product_Family__c LIMIT 1];
        Subfamily__c d = [SELECT Id FROM Subfamily__c LIMIT 1];
        Sourcing_Item__c item = [SELECT Id FROM Sourcing_Item__c LIMIT 1];
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        
        Customer_Quote__c importexportquote=[SELECT Id FROM Customer_Quote__c LIMIT 1];
        /*
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        */
        Quote_Item_Line__c quote = [SELECT Id FROM Quote_Item_Line__c LIMIT 1];
        Container_Type__c container= new Container_Type__c();
        container.Name='40 HC';
        insert container;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  
                                                         Item_Name__c = item.Id, Quote_Item_Line__c =quote.Id, Import_Export_Quote__c =importexportquote.Id,
                                                        Container_Type__c= container.Id
                                                        );
        insert shipline;   
        Supplier_Quote__c supplier_quote_test = new Supplier_Quote__c(Supplier__c = supplier.Id);
        insert supplier_quote_test;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supplier_quote_test.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000, Active__c  = true, Price__c =10);
        insert sup_quote_lines; 
        
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Supplier_Quote_Line__c = sup_quote_lines.Id, Supplier_Quote__c =supplier_quote_test.Id, Quote_Item_Line__c = quote.Id, Import_Export_Quote__c = importexportquote.Id);
        insert shipline2;
        Shipment_Line__c shipline3 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        insert shipline3;
        Shipment_Line__c shipline4 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Supplier_Quote_Line__c = sup_quote_lines.Id, Supplier_Quote__c =supplier_quote_test.Id);
        insert shipline4;
        
        update shipline2;
        //update shipline3;
        //update shipline4;
        NEU_StaticVariableHelper.setBoolean1(true);
    }
    
}