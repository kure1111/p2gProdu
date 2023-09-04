@isTest
public class NEU_RecalculateTraffic_Test {
	    
    
    @testSetup static void createObjects(){
        
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Status_Account__c = 'Active';
        a.ActiveSap__c = true;
        insert a;
        
        User usr = TestDataFactory.createUserAdmin();
		Rol_Margen__c rm = TestDataFactory.createRolMargen('Director Comercial');        
        
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
               
        Customer_Quote__c folioT = new Customer_Quote__c(Pricing_Executive__c=userinfo.getUserId(),
                                                         Quotation_Status__c ='Quote being prepared',
                                                         Catalog_Price_List__c= b.id, Account_for__c = a.Id,
                                                         Contact__c = contacto.Id, Freight_Mode__c='Air',
                                                         Service_Mode__c='Import', Service_Type__c='LCL Cargo',
                                                         Move_Type__c='Door to Door',Origin_Address__c='tst adrress',
                                                         Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,
                                                         Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id,
                                                         Destination_Address__c='test address');                
        
       Traffic__c new_traffic = new Traffic__c();
        new_traffic.Name = 'New Traffic Test';
        new_traffic.Account__c = folioT.Account_for__c;
        new_traffic.Site_of_Load__c = folioT.Site_of_Load__c;
        new_traffic.State_of_Load__c = folioT.State_of_Load__c;
        new_traffic.Country_of_Load__c = folioT.Country_ofLoad__c;
        new_traffic.Country_of_Discharge__c = folioT.Country_ofDischarge__c;
        new_traffic.State_of_Discharge__c = folioT.State_of_Discharge__c;
        new_traffic.Site_of_Discharge__c = folioT.Site_of_Discharge__c;
        new_traffic.Freight_Mode__c = folioT.Freight_Mode__c;
        new_traffic.Service_Type__c = folioT.Service_Type__c;
        new_traffic.Container_Type__c = folioT.Container_Type__c;
        new_traffic.Service_Mode__c = folioT.Service_Mode__c;
        new_traffic.N_Import_Exports__c = 1;
        new_traffic.Service_Type__c ='PAQUETERIA';
        insert new_traffic;               
        folioT.Traffic__c = new_traffic.id;
        insert folioT;        
        
    }
    
    
    
    
    static testMethod void updateImportExport()
    {
       
      list<Customer_Quote__c> folioF = [select Id, Pricing_Executive__c, Quotation_Status__c, Catalog_Price_List__c,
                                        Contact__c, Service_Mode__c, Move_Type__c, Country_ofLoad__c, 
                                        Country_ofDischarge__c, Destination_Address__c, Traffic__c,Order_in_Progress_Date__c,Order_Closed_Date__c from Customer_Quote__c where Destination_Address__c='test address' limit 1];
                           
        
      Customer_Quote__c found = folioF[0];       
        
      Test.startTest();      
      found.Destination_Address__c='Prueba2';
      found.Quotation_Status__c = 'Partially Shipped';
      found.Freight_Mode__c = 'Sea';      
      update found;       
      Test.stopTest();
           
    }
    
    static testMethod void deleteImportExport() {
        
       Test.startTest();
        list<Customer_Quote__c> folioF = [select Id, Pricing_Executive__c, Quotation_Status__c, Catalog_Price_List__c,
                                        Contact__c, Service_Mode__c, Move_Type__c, Country_ofLoad__c, 
                                        Country_ofDischarge__c, Destination_Address__c,Traffic__c from Customer_Quote__c where Destination_Address__c='test address' limit 1];
        delete folioF;
        Test.stopTest();
    }
    
}