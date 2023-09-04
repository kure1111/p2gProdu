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
private class NEU_test_Return_Import_Export_Quote {
    
     static testMethod void test_NEU_Return_Import_Export_Quote() 
     {
     		NEU_StaticVariableHelper.setBoolean1(true);
          List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
          Account a =  list_accounts[0];
          insert a;
          Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
          insert ship;
          Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address'); 
          insert importexportquote;
          Shipment_Consolidation_Data__c scd = new Shipment_Consolidation_Data__c(Shipment__c = ship.Id, Import_Export_Quote__c = importexportquote.Id);
          insert scd;
          NEU_Return_Import_Export_Quote uda = new NEU_Return_Import_Export_Quote(new ApexPages.StandardController( ship ));
          uda.return_ie();
     }  
}