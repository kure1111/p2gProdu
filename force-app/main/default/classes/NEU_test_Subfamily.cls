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
private class NEU_test_Subfamily {

 	
	public static testMethod void test_NEU_OM_UploadImageSubfamily() {//ok
     	NEU_StaticVariableHelper.setBoolean1(true);
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
	    insert c;
	    Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
	    insert subfamily;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_UploadImageSubfamily uis = new NEU_OM_UploadImageSubfamily(new ApexPages.StandardController( subfamily ));
        uis.upload();
        system.debug( 'Prueba realizada' );
    }
}