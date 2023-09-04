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
private class NEU_test_Search_Supplier_Quote_Hidden {
     static testMethod void NEU_Search_Supplier_Quote_Hidden()
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id, Date_Limit__c = date.newInstance(2001, 3, 21));
         insert supplyproject;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c;
         Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
         insert c2;
         Price_List__c price_list2= new Price_List__c(Name = 'Test lista', Items_Account_Owner__c = a.Id);
         insert price_list2;
         Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = price_list2.Id);
         insert d;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id, Customer__c = b.Id, Supplier_Quote_Status__c='Consolidated', RecordTypeId = Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Hidden Quote').getRecordTypeId());
         insert supquote;
         
        NEU_Search_Supplier_Quote_Hidden ssqh = new NEU_Search_Supplier_Quote_Hidden();
        
        Id job_id = System.schedule('test', '0 0 0 30 12 ? 2099', ssqh);
        System.assertNotEquals(null, job_id);
        //ssqh.execute(job_id);
     }
     
     
}