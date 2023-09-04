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
private class NEU_test_LaborProgram { 

    
    static testMethod void NEU_OM_FollowersLaborProgram ()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        NEU_Factory__c line_factory = new NEU_Factory__c(Name='test factroy', Account_Owner__c = a.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert line_factory;
        Labor_Program__c labor_program = new Labor_Program__c(Bank_Holidays__c = 10, External_Legal_days__c = 10, Factory_Line__c =line_factory.Id , Equipment_Process_Trial_Scheduled_Mo__c=10);
        insert labor_program;
        
        NEU_OM_FollowersLaborProgram uda = new NEU_OM_FollowersLaborProgram(new ApexPages.StandardController( labor_program ));
        uda.getfollower();
        uda.getfollowersin();
        uda.nuevalinea();
        uda.quitarlinea();
     }
     
         static testMethod void NEU_OM_FollowersLaborProgram2 ()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        NEU_Factory__c line_factory = new NEU_Factory__c(Name='test factroy', Account_Owner__c = a.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert line_factory;
        Labor_Program__c labor_program = new Labor_Program__c(Bank_Holidays__c = 10, External_Legal_days__c = 10, Factory_Line__c =line_factory.Id , Equipment_Process_Trial_Scheduled_Mo__c=10);
        insert labor_program;
        
        NEU_OM_FollowersLaborProgram uda = new NEU_OM_FollowersLaborProgram(new ApexPages.StandardController( labor_program ));
        List<NEU_OM_FollowersLaborProgram.follower_s> lista_de_followers = new List<NEU_OM_FollowersLaborProgram.follower_s>();
        List<User> listauser = [select id, Name, ProfileId from User where Id =: UserInfo.getUserId()];
        lista_de_followers.add(new NEU_OM_FollowersLaborProgram.follower_s(listauser[0],true,false,false));
        lista_de_followers.add(new NEU_OM_FollowersLaborProgram.follower_s(listauser[0],false,false,false));
        
        List<NEU_OM_FollowersLaborProgram.followersin_s> lista_de_followersin = new List<NEU_OM_FollowersLaborProgram.followersin_s>();
        lista_de_followersin.add(new NEU_OM_FollowersLaborProgram.followersin_s(listauser[0],true,false,false));
        uda.follower =lista_de_followers;
        uda.getfollowersin();
        uda.followersin =lista_de_followersin;
        uda.nuevalinea();
        uda.quitarlinea();
     }
}