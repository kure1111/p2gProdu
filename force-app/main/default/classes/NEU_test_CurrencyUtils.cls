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
private class NEU_test_CurrencyUtils {

   public static testMethod void test_NEU_CurrencyUtils()
   {
   	NEU_StaticVariableHelper.setBoolean1(true);
         List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
         Account a = list_accounts[0];
         insert a;
         Account b = list_accounts[1];
         insert b;
         Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
         insert supplyproject;
         Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id);
         insert supquote;
         Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Auto-Parts');
         insert c;
         Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
         insert subfamily;
         Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Master_Box_Length_cm__c=1000, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c=10 );
         insert item;
         Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000);
         insert sup_quote_lines;
        // sobject so = Schema.getGlobalDescribe().get('Supply Project').newSObject();
         NEU_CurrencyUtils.getCurrencyIsoCodeList();
         NEU_CurrencyUtils.getCurrencyIsoCode(supplyproject);

         NEU_CurrencyUtils.setCurrencyIsoCode(supplyproject,'USD');
      //   NEU_CurrencyUtils.getCurrency(supplyproject,'Calculated_Starting_Bid__c','EUR');
         //NEU_CurrencyUtils.setCurrency(supplyproject,'Calculated_Starting_Bid__c',10,'EUR');
         NEU_CurrencyUtils currencys = new NEU_CurrencyUtils();
         currencys.changeCurrency(10, 'MXN', 'USD');
         NEU_CurrencyUtils.getCurrencyIsoCodeList();
         NEU_CurrencyUtils.CurrencyIsoCode('MXN');
         NEU_CurrencyUtils.CurrencyIsoCode();
         SObject nuevo_sobject;
         nuevo_sobject = supquote;
         NEU_CurrencyUtils currencys3 = new NEU_CurrencyUtils(nuevo_sobject);
         list<SObject> lista_cuentas = new List<SObject>();
         lista_cuentas.add(b);
         list<SObject> lista_cuentas2 = new List<SObject>();
         lista_cuentas2.add(supquote );
         list<SObject> lista_cuentas3 = new List<SObject>();
         lista_cuentas3.add(sup_quote_lines );
         NEU_CurrencyUtils currencys2 = new NEU_CurrencyUtils(lista_cuentas2);
         currencys.updateConversionRate(b,b);
         Map<Id,SObject> lista_maps = new  Map<Id,SObject>();
         NEU_CurrencyUtils.setCurrencyIsoCode(nuevo_sobject,'MXN');
         update nuevo_sobject;
         lista_maps.put(supquote.Id, nuevo_sobject);
         NEU_CurrencyUtils.setCurrencyIsoCode(supquote,'MXN');
         update supquote;
         NEU_CurrencyUtils.lineBeforeUpdate('Supplier_Quote__c', 'Supplier_Quote__c', lista_cuentas2 , lista_maps);

         NEU_CurrencyUtils.lineBeforeInsert('Supplier_Quote__c', 'Supplier_Quote__c', lista_cuentas3 );
         NEU_CurrencyUtils.headerAfterUpdate(null,null,lista_cuentas2 ,lista_maps,lista_maps);

         NEU_CurrencyUtils.CurrencyIsoCode('Supplier_Quote__c');
         NEU_CurrencyUtils.CurrencyIsoCode();
         NEU_CurrencyUtils.getCurrencyIsoCodeList();
         NEU_CurrencyUtils.getCurrencyIsoCodeOptions();

    }
}