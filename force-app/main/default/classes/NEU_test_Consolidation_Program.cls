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
private class NEU_test_Consolidation_Program {

    static testMethod void test_NEU_Save_All_Delivery_Note() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment_Program__c shipment_program = new Shipment_Program__c(Type__c ='Cross-Docking Outbound', Origin_Address__c='Oklahoma City' ,Destination_Address__c='Dallas');
        insert shipment_program;
        Shipment_Program_Line__c sl=new Shipment_Program_Line__c(Shipments_Program__c=shipment_program.id);
        insert sl;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c  = shipment_program.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Shipment__c ship2 = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Outbound_Consolidation_Program__c  = shipment_program.Id, Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship2.Id, Name= 'test ship line');
        insert shipline;
        NEU_Save_All_Delivery_Note uda = new NEU_Save_All_Delivery_Note(new ApexPages.StandardController( shipment_program ));
        uda.generar_todos();
        
        
    }
}