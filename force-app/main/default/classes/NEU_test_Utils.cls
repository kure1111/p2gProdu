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
private class NEU_test_Utils {

    static testMethod void test_NEU_Utils() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        NEU_Utils c=new NEU_Utils();
        c.toDecimalR(null);
        c.toDecimalR('00');
        c.toDecimalR('a');
        c.toDecimalR('3.3,3');
        c=new NEU_Utils();
        c.getDecimalSepR();
        c.getThousandSepR();
        
        NEU_Utils.toDecimal(null);
        NEU_Utils.toDecimal('00');
        NEU_Utils.toDecimal('a');
        NEU_Utils.toDecimal('3.3,3');
        NEU_Utils.getDecimalSep();
        
        NEU_Utils.safeDecimal((Integer)null);
        NEU_Utils.safeDecimal((Decimal)null);
        NEU_Utils.safeDecimal((String)null);
        NEU_Utils.safeDecimal(0.0);
        
        decimal valor = null;
        NEU_Utils.safeInteger(valor);
        NEU_Utils.safeInteger(0.1);
        Integer valor_int = null;
        NEU_Utils.safeInteger(valor_int);
        NEU_Utils.safeInteger(0);
        NEU_Utils.safeInteger('a');
        NEU_Utils.safeInteger('0');

        NEU_Utils.safeString(null);
        NEU_Utils.safeString(0.0);
        NEU_Utils.safeString(system.today());
        NEU_Utils.safeString(system.now());
        NEU_Utils.safeString('test');
        NEU_Utils.safeString(0,2);
        NEU_Utils.safeString(0.1,2);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        NEU_Utils.populateClone(a);
        NEU_Utils.populate(new String[]{'Id'},'Contact',a.Id);
        NEU_Utils.getStringPopulate(a);
    }
    static testMethod void test_formatAddress() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        NEU_Utils.formatAddress('1','2','3','4','5');
        NEU_Utils.formatAddress(null,'2','3','4','5');
        NEU_Utils.formatAddress('1',null,'3','4','5');
        NEU_Utils.formatAddress(null,null,'3','4','5');
        NEU_Utils.formatAddress('1',null,null,'4','5');
        NEU_Utils.formatAddress(null,'2',null,'4','5');
        NEU_Utils.formatAddress(null,null,null,'4','5');
        NEU_Utils.formatAddress(null,null,null,null,'5');
        
        NEU_Utils.getCarrierAgentIATA('MTY','MTY');
        NEU_Utils.getCarrierAgentIATA('GDL','GDL');
        NEU_Utils.getCarrierAgentIATA('MID','MID');
        NEU_Utils.getCarrierAgentIATA('test','test');
        NEU_Utils.getPIMA('MTY','MTY');
        NEU_Utils.getPIMA('GDL','GDL');
        NEU_Utils.getPIMA('MID','MID');
        NEU_Utils.getPIMA('test','test');
        NEU_Utils.removeAccents('test');
    }
}