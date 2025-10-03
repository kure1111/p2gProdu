@isTest
public class P2G_NEU_Standard_Duty_Calcul_SPTest {
    
    @isTest
    static void test_NEU_Standard_Duty_Calculator_Shipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        //Account a = list_accounts[0];
        //insert a;
        //Account sup = list_accounts[1];
        //insert sup;
        
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();        	
        insert a;        
        
        Account sup= new Account();
        sup.Name='Test';
        sup.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();		
        sup.OwnerId=UserInfo.getUserId();        	
        insert sup;        
        
        Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales', Items_Account_Owner__c = sup.Id);
        insert b; 
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00035', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = g.Id, CurrencyIsoCode='MXN');
        insert shipline;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        
        Shipment__c ship2 = new Shipment__c(Name = 'SP-TS-00053', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id, Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment_Line__c shipline2 = new Shipment_Line__c(Shipment__c = ship2.Id, Name= 'test ship line',  Item_Name__c = g.Id,CurrencyIsoCode='MXN');
        insert shipline2;
        
        NEU_Standard_Duty_Calculator_Shipment ie = new NEU_Standard_Duty_Calculator_Shipment(new ApexPages.StandardController( ship ));
        ie.calcular_tasas();
        ie.refresh();
        ie.volver();
        NEU_Standard_Duty_Calculator_Shipment ie2 = new NEU_Standard_Duty_Calculator_Shipment(new ApexPages.StandardController( ship2 ));
        ie2.calcular_tasas();
    }
    
}