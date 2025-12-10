@isTest
public class P2G_NEU_Proforma_Invoice_pdfTest {
    
    @isTest(SeeAllData=true)
    static void test_NEU_Proforma_Invoice_pdf()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('services_charges', 'true');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00031', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Product_Family__c fam = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert fam;
        Subfamily__c subfam = new Subfamily__c(Product_Family__c = fam.Id, Name = 'test subfamily');
        insert subfam;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfam.Id, Sourcing_Family__c =fam.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert item;
        List<Shipment_Line__c> listado_lineas_ship = new List<Shipment_Line__c>();
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline);
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline2);
        Shipment_Line__c shipline3 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline3);
        Shipment_Line__c shipline4 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline4);
        Shipment_Line__c shipline5 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline5);
        Shipment_Line__c shipline6 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline6);
        Shipment_Line__c shipline7 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline7);
        Shipment_Line__c shipline8 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline8);
        Shipment_Line__c shipline9 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline9);
        Shipment_Line__c shipline10 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline10);
        Shipment_Line__c shipline11 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id);
        listado_lineas_ship.add(shipline11);
        Shipment_Line__c shipline12 = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Expense_Amount__c=100);
        listado_lineas_ship.add(shipline12);
        insert listado_lineas_ship;
        NEU_Proforma_Invoice_pdf uda = new NEU_Proforma_Invoice_pdf(new ApexPages.StandardController( ship ));
        
    }
}