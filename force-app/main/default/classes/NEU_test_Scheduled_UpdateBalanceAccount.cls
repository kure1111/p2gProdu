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
private class NEU_test_Scheduled_UpdateBalanceAccount 
{
     static testMethod void NEU_Schedule_UpdateBalanceAccount()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         NEU_Schedule_UpdateBalanceAccount ssqh = new NEU_Schedule_UpdateBalanceAccount ();
         
         Id job_id = System.schedule('test', '0 0 0 30 12 ? 2099', ssqh);
         System.assertNotEquals(null, job_id);
     }
     
     static testMethod void NEU_UpdateBalanceAccount()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,');
        Account a = list_accounts[0];
        insert a;
        
        Account b = list_accounts[1];
        insert b;
        
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id,
        Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', 
        Destination_Address__c='test address');
        insert importexportquote;
        
        Shipment__c ship = new Shipment__c();
        ship.Account_for__c = a.Id;
        ship.Freight_Mode__c = 'Sea'; 
        ship.Service_Mode__c = 'Import';
        ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        ship.Only_Warehouse_Service__c = true;
        insert ship;
        
        Invoice__c i_test = new Invoice__c();
        i_test.Import_Export_Quote_Order__c = importexportquote.Id;
        i_test.Shipment__c = ship.Id;
        i_test.Account__c = a.Id;
        //i_test.Type__c = 'Credit Note';
        Date date1 = System.today().addDays(-2);
        Date date2 = System.today();
        i_test.Payable_Before__c = date1;
        i_test.Date_of_Invoice__c = date2;
        //i_test.EUR_Conversion_Rate_Invoice_Date__c = 1.1;
        insert i_test;
        
        Invoice_Line__c il = new Invoice_Line__c();
        il.Invoice__c = i_test.Id;
        il.Units__c = 10; 
        il.Unit_Price__c = 433.02;
        il.Amount__c= 433.02;
        insert il;
        
        /*Invoice__c i_test1 = new Invoice__c();
        i_test1.Import_Export_Quote_Order__c = importexportquote1.Id;
        i_test1.Account__c = b.Id;
        //i_test1.Type__c = 'Credit Note';
        i_test1.Payable_Before__c = date1;
        i_test1.Date_of_Invoice__c = date2;
        //i_test1.EUR_Conversion_Rate_Invoice_Date__c = 1.1;
        insert i_test1;*/
        
        Invoice_Line__c il1 = new Invoice_Line__c();
        il1.Invoice__c = i_test.Id;
        il1.Units__c = 10; 
        il1.Unit_Price__c = 533.02;
        il1.Amount__c= 533.02;
        insert il1;
        
        string exc = 'Thats Error Ok';
        NEU_UpdateBalanceAccount.update_data();
        NEU_UpdateBalanceAccount.sendMail(exc);
        system.debug('Test Ok Scheduled Account');
     }
}