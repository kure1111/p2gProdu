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
private class NEU_test_Services_Rates {

     
    static testMethod void test_NEU_Followers_Services_Rates() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a =  list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Route__c = route.Id, Active__c= true, Account_for__c=a.Id);
        insert fee;
        NEU_Followers_Services_Rates uda = new NEU_Followers_Services_Rates(new ApexPages.StandardController( fee ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
    }
    
    public static testMethod void test_NEU_Upload_LOT_Service_Rate() {//ok
		NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a =  list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Route__c = route.Id, Active__c= true, Account_for__c=a.Id);
        insert fee;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_Upload_LOT_Service_Rate ulsr = new NEU_Upload_LOT_Service_Rate(new ApexPages.StandardController( fee ));
        ulsr.upload();
        system.debug( 'Prueba realizada' );
    }
    
}