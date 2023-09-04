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
private class NEU_test_Catalog_Price_List {

    static testMethod void Test_NEU_Capture_Catalog_Price_List () 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        // TO DO: implement unit test
        Account a = list_accounts[0];
        insert a;
        Price_List__c new_pl = new Price_List__c(Items_Account_Owner__c = a.Id);
        insert new_pl;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Other Services');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Sourcing_Item__c g2 = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g2;
        Item_List_Price__c new_ilp = new Item_List_Price__c (Item_Name__c = g.Id, Price_List__c = new_pl.Id);
        insert new_ilp;
        NEU_Capture_Catalog_Price_List ccpl = new NEU_Capture_Catalog_Price_List(new ApexPages.StandardController(new_pl));
        ccpl.cancel();
        ccpl.resetData();
        ccpl.saveData();
        List<NEU_Capture_Catalog_Price_List.Item_List_Price_s> ilp = ccpl.myList;
        ccpl.sortList(0);
        ccpl.numLines = 2;
        ccpl.addLines();
        ccpl.addLine();
        ccpl.idLines = g2.Name+'_\\|_'+g.Name;
        ccpl.firstLine = 0;
        ccpl.orderLines();
         
    }
}