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
private class NEU_test_Source_DB {

    static testMethod void test_NEU_Upload_Source_DB() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,');
        Account sup = list_accounts[0];
        insert sup;
        Source_DB__c new_Source_DB = new Source_DB__c(Supplier_Account__c = sup.Id);
        insert new_Source_DB;
        NEU_Upload_Source_DB usd = new NEU_Upload_Source_DB(new ApexPages.StandardController( new_Source_DB ));
        usd.mydocumentname ='test_excel.xlsx';
        usd.backtoview();
        usd.upload();
    }
}