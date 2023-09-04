@isTest
public class NEU_OM_Update_LastShipmentDate_Test {

    
    @isTest
    public static void runTest(){
        test.startTest();
        Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = acc;
        insert a;
        User usT = TestDataFactory.createUserAdmin();
        Rol_Margen__c rm = TestDataFactory.createRolMargen('Director Comercial');
        
        Price_List__c b = new Price_List__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = a.Id);
        insert b;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;
        Shipment__c ship = new Shipment__c(Name = 'SP-CE-22-141610',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true,ETD_from_Point_of_Load__c = System.today());
        insert ship;
        Shipment_Line__c sl = new Shipment_Line__c(Name = '001Test',Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
        insert sl;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =ship.Id);
        insert transporpack;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Import_Export_Quote__c = importexportquote.Id );
        insert shipline;
        
        ship.ETD_from_Point_of_Load__c=date.valueOf('2024-01-01');
        update ship;
        test.stopTest();
    }
}