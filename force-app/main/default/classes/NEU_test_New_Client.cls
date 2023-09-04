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
private class NEU_test_New_Client {

    
    static testMethod void test_NEU_New_Client() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c family1 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
        insert family1;
        Product_Family__c family2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
        insert family2;
        NEU_New_Client uda = new NEU_New_Client(new ApexPages.StandardController(a));
        uda.record = a;
        uda.customercontact = contacto;
        uda.currency_selected = null;
        Blob b = Blob.valueOf('Test Data');
        uda.logo.Name='Test document.test';
        uda.logo.AuthorId = UserInfo.getUserId();
        uda.logo.IsPublic=true;
        uda.logo.Body = b;
        uda.getfamilies();
        
        for(NEU_New_Client.families_s nsf : uda.getfamilies() )
        {
            nsf.selected = true;
        }
        uda.send_form();    
        
    }
    
}