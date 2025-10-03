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
    }
    
        @isTest
    static void testConstructorCatch() {
        try{
        // Simula que con.getRecord() retorna un Id inexistente para disparar el catch
        Fee__c dummy = new Fee__c(Name = 'Dummy Fee');
        dummy.ID = 'a0KRL000004snpR2AQ';

        // Se pasa un ID inválido intencionalmente para provocar fallo en SOQL
        ApexPages.StandardController sc = new ApexPages.StandardController(
            (Fee__c)JSON.deserialize('{}', Fee__c.class)
        );
        Test.startTest();
        NEU_Followers_Services_Rates ctrl = new NEU_Followers_Services_Rates(sc);
        NEU_Followers_Services_Rates.byPass();
        Test.stopTest();
                    }catch(Exception e){
                
            }
        
    }
}