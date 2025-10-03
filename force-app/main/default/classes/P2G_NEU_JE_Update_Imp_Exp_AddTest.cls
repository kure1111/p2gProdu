@isTest
public class P2G_NEU_JE_Update_Imp_Exp_AddTest {
    
    @isTest
    static void NEU_JE_Update_Import_Export_Addresses (){
		//NEU_StaticVariableHelper.setBoolean1(true);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,Transporter,Transporter,');
        //Account a = list_accounts[0];
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();        	
        a.ShippingStreet='prueba';
		a.ShippingCity='prueba';
		a.ShippingState='prueba';
		a.ShippingPostalCode='prueba';
        a.ShippingCountry='prueba';
        insert a;
        
        Account a2 = new Account();
        a2.Name='Test02';
        a2.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a2.OwnerId=UserInfo.getUserId();        	
        a2.ShippingStreet='prueba';
		a2.ShippingCity='prueba';
		a2.ShippingState='prueba';
		a2.ShippingPostalCode='prueba';
        a2.ShippingCountry='prueba';
        insert a2;
        Account a3 = new Account();
        a3.Name='Test03';
        a3.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();		
        a3.OwnerId=UserInfo.getUserId();
        a3.ShippingStreet='prueba';
		a3.ShippingCity='prueba';
		a3.ShippingState='prueba';
		a3.ShippingPostalCode='prueba';
        a3.ShippingCountry='prueba';
        insert a3;
        Account a4 = new Account();
        a4.Name='Test03';
        a4.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();		
        a4.OwnerId=UserInfo.getUserId();
        a4.ShippingStreet='prueba';
		a4.ShippingCity='prueba';
		a4.ShippingState='prueba';
		a4.ShippingPostalCode='prueba';
        a4.ShippingCountry='prueba';
        insert a4;
        Price_List__c b = new Price_List__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = a.Id);
        insert b;
        Account_Address__c ad=new Account_Address__c(Account__c=a.id,Address__c='test',Type__c='Shipping Address');
        ad.Address_Coordinates__Latitude__s = 19.4326;
        ad.Address_Coordinates__Longitude__s = -99.1332;
        insert ad;

        Pricebook2 pb = new Pricebook2(Name = 'Paqueteria', IsActive = true);
        insert pb;        

        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];

        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional

        Customer_Quote__c importexportquote = new Customer_Quote__c();

        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        importexportquote.RecordTypeId = recordTypeId;
        importexportquote.Name='.';
        importexportquote.Account_for__c = a.Id;
        importexportquote.Supplier_Account__c= a3.Id;
        importexportquote.Consignee__c=a.Id;        
        importexportquote.Team__c = 'P2G';
        importexportquote.Quotation_Status__c = 'Quote being prepared';
        importexportquote.Customer_Reference__c = 'hola soy una prueba';
        importexportquote.Valid_From__c = system.today();
        importexportquote.Valid_Until__c = system.today();
        importexportquote.Comercio_Exterior__c = 'No';
        importexportquote.Freight_Mode__c = 'Road';
        importexportquote.Service_Mode__c = 'NATIONAL';
        importexportquote.Service_Type__c = 'FTL';
        importexportquote.CurrencyIsoCode = 'MXN';
        importexportquote.ETD__c = Date.today();
        importexportquote.ETA__c = Date.today();
        importexportquote.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote.Pricing_Executive__c= userT.Id;
        importexportquote.Operations_Exec__c = userT.Id;
        importexportquote.Catalog_Price_List__c = b.id;
        insert importexportquote;

        NEU_StaticVariableHelper.setBoolean1(true);
        Customer_Quote__c importexportquote2 = new Customer_Quote__c();        
        importexportquote2.RecordTypeId = recordTypeId;
        importexportquote2.Name='.';
        importexportquote2.Account_for__c = a.Id;
        importexportquote2.Supplier_Account__c= a3.Id;
        importexportquote2.Consignee__c=a.Id;        
        importexportquote2.Team__c = 'P2G';
        importexportquote2.Quotation_Status__c = 'Quote being prepared';
        importexportquote2.Customer_Reference__c = 'hola soy una prueba';
        importexportquote2.Valid_From__c = system.today();
        importexportquote2.Valid_Until__c = system.today();
        importexportquote2.Comercio_Exterior__c = 'No';
        importexportquote2.Freight_Mode__c = 'Road';
        importexportquote2.Service_Mode__c = 'NATIONAL';
        importexportquote2.Service_Type__c = 'FTL';
        importexportquote2.CurrencyIsoCode = 'MXN';
        importexportquote2.ETD__c = Date.today();
        importexportquote2.ETA__c = Date.today();
        importexportquote2.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote2.Pricing_Executive__c= userT.Id;
        importexportquote2.Operations_Exec__c = userT.Id;
        importexportquote2.Catalog_Price_List__c = b.id;
        insert importexportquote2;


        Customer_Quote__c importexportquote3 = new Customer_Quote__c();
        
        importexportquote3.RecordTypeId = recordTypeId;
        importexportquote3.Name='.';
        importexportquote3.Account_for__c = a.Id;
        importexportquote3.Supplier_Account__c= a3.Id;
        importexportquote3.Consignee__c=a.Id;        
        importexportquote3.Team__c = 'P2G';
        importexportquote3.Quotation_Status__c = 'Quote being prepared';
        importexportquote3.Customer_Reference__c = 'hola soy una prueba';
        importexportquote3.Valid_From__c = system.today();
        importexportquote3.Valid_Until__c = system.today();
        importexportquote3.Comercio_Exterior__c = 'No';
        importexportquote3.Freight_Mode__c = 'Road';
        importexportquote3.Service_Mode__c = 'NATIONAL';
        importexportquote3.Service_Type__c = 'FTL';
        importexportquote3.CurrencyIsoCode = 'MXN';
        importexportquote3.ETD__c = Date.today();
        importexportquote3.ETA__c = Date.today();
        importexportquote3.Community_Status__c = 'CUSTOMER CREATED';
        importexportquote3.Pricing_Executive__c= userT.Id;
        importexportquote3.Operations_Exec__c = userT.Id;
        importexportquote3.Catalog_Price_List__c = b.id;
        insert importexportquote3;

        /*
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Supplier_Account__c= a3.Id,Destination_Address__c='test' ,Origin_Address__c='',Account_Origin_Address__c=ad.id,Consignee__c=a.id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Supplier_Account__c= a3.Id,Origin_Address__c='',Consignee__c=a.id,Account_Destination_Address__c=ad.id, Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote2;
        Customer_Quote__c importexportquote3 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Supplier_Account__c= a3.Id,Origin_Address__c='',Consignee__c=a.id, Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote3;
        */
        
        importexportquote.Supplier_Account__c= a4.Id;
        update importexportquote;
        importexportquote2.Supplier_Account__c= a4.Id;
        importexportquote2.Destination_Address__c = null;
        update importexportquote2;
        importexportquote3.Supplier_Account__c= a4.Id;
        importexportquote3.Destination_Address__c = null;
        update importexportquote3;
    }    
    
}