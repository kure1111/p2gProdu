@isTest
public class P2G_NEU_OM_UpdateFoLaborProgramTest {

    @isTest
    static void NEU_OM_UpdateFoLaborProgramTest(){
        
        Test.startTest();
        Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Account_External_Follower_User__c=UserInfo.getUserId()/*,Business_Area__c = 'Sales'*/);
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = b;
        a.Account_Executive_User__c = userinfo.getUserId();
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        NEU_Factory__c line_factory = new NEU_Factory__c(Name='test factroy', Account_Owner__c = a.Id, Country__c=Country.Id, Location__c=localizacion.Id);
        insert line_factory;
        Labor_Program__c labor_program = new Labor_Program__c(Bank_Holidays__c = 10, External_Legal_days__c = 10, Factory_Line__c =line_factory.Id , Equipment_Process_Trial_Scheduled_Mo__c=10);
        insert labor_program;
        Test.stopTest();
    }
}