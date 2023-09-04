@isTest
public class NEU_AssignCreateRouteFromTraffic_Test {

    
    
    @isTest
    public static void runTest(){
        
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Rol_Margen__c rm = TestDataFactory.createRolMargen('Director Comercial');
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Traffic__c traffic = new Traffic__c(Account__c = a.Id, Country_of_Discharge__c = Country.Id, Country_of_Load__c = Country.Id, Profit_Proyection__c = 10, Revenue_Proyection__c = 10, Shipments_Proyection__c = 10, Site_of_Discharge__c = localizacion.Id, Site_of_Load__c = localizacion.Id);
        insert traffic;
        Test.stopTest();
    }
}