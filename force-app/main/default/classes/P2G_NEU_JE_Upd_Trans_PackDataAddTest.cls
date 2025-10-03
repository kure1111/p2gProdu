@isTest
public class P2G_NEU_JE_Upd_Trans_PackDataAddTest {
    @isTest
    static void NEU_JE_Update_Transport_Packaging_Data_Addresses()
     {
         test.startTest();
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                                  ShippingStreet = 'Prueba',
            ShippingCity = 'Prueba',
            ShippingState = 'Prueba',
            ShippingPostalCode = '0',
            ShippingCountry = 'MEXICO'
                                  /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        Price_List__c b = new Price_List__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = a.Id);
        insert b;
        
        Pricebook2 pb = new Pricebook2(Name = 'Paqueteria', IsActive = true);
        insert pb;
        
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];

        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional

        Customer_Quote__c importexportquote = new Customer_Quote__c();

        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();

        importexportquote.RecordTypeId = recordTypeId;

        importexportquote.Name='.';

        importexportquote.Account_for__c = a.Id;
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

        /*
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        */
        
        Shipment__c ship = new Shipment__c(Name='SP-FN-TEST00',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id, Ship_from_Door_Account__c = a.Id, Ship_from_Door_Address__c ='', Ship_to_Door_Address__c = '', Ship_to_Door_Account__c = a.Id);
        insert transporpack;
         test.stopTest();
        
     }

}