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
private class NEU_test_First_Steps {

    static testMethod void test_First_Steps() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        // TO DO: implement unit test
        NEU_First_Steps fs = new NEU_First_Steps();
        fs.insert_countries();
        fs.insert_states();
        fs.insert_locations();
        fs.update_transport_id();
    }
    @isTest
    public static void NEU_DrayagesFreight_test(){
        Test.startTest(); 
        NEU_DrayagesFreight NEU_DrayagesFreight = new NEU_DrayagesFreight();
        NEU_DrayagesFreight.id_carrier = 'Test';
        NEU_DrayagesFreight.buy_rate_filter = 2.3;
        NEU_DrayagesFreight.sell_rate_filter = 2.3;
        NEU_DrayagesFreight.order_by_mode = 'Test';
        Test.stopTest();
    }
}