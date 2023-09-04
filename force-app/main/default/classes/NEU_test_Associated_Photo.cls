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
private class NEU_test_Associated_Photo {

    static testMethod void test_NEU_View_Associated_Photos() {
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10', Files_Account_Owner__c = a.Id);
        insert ship_prog;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Associated_Photo__c associated_photo = new Associated_Photo__c(Account__c =a.Id, Shipment__c=ship.Id,Shipments_Program__c=ship_prog.Id);
        insert associated_photo;
        ApexPages.currentPage().getParameters().put('id', ship_prog.Id);
        List<Associated_Photo__c> list_ids_ap = [select id, Name from Associated_Photo__c];
        NEU_View_Associated_Photos vap = new NEU_View_Associated_Photos(new ApexPages.StandardSetController( list_ids_ap ));
        vap.getlist_associated_photo();
        ApexPages.currentPage().getParameters().put('id', ship.Id);
        NEU_View_Associated_Photos vap2 = new NEU_View_Associated_Photos(new ApexPages.StandardSetController( list_ids_ap ));
        vap2.getlist_associated_photo();
    }
}