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
private class NEU_test_Shipment_Not_PDF {
	
    static testMethod void test_NEU_Shipment_Notifications_PDF()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Name = 'Shipment Number A1',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       NEU_Shipment_Notifications_PDF ship_notification = new NEU_Shipment_Notifications_PDF(new ApexPages.StandardController( ship ));
       ship_notification.load_template();
       ship_notification.load_template_arrival_confirmation_english();
       ship_notification.load_template_arrival_confirmation_spanish();
       ship_notification.load_template_arrival_notification_english();
       ship_notification.load_template_arrival_notification_spanish();
       ship_notification.load_template_shipment_tracking_english();
       ship_notification.load_template_shipment_tracking_spanish();
       ship_notification.load_template_departure_confirmation_english();
       ship_notification.load_template_departure_confirmation_spanish();
       ship_notification.load_template_departure_confirmationFI_english();
       ship_notification.load_template_departure_confirmationFI_spanish();
       ship_notification.load_template_booking_confirmation_english();
       ship_notification.load_template_booking_confirmation_spanish();
       ship_notification.load_template_departure_timetable_english();
       ship_notification.load_template_departure_timetable_spanish();
        ship_notification.load_template_fn_estandar_english();
        ship_notification.load_template_fn_estandar_spanish();
        ship_notification.load_template_fn_manantiales_asuncion_english();
        ship_notification.load_template_fn_manantiales_asuncion_spanish();
        ship_notification.load_template_fn_cerveceria_modelo_english();
        ship_notification.load_template_fn_cerveceria_modelo_spanish();
        ship_notification.load_template_fn_owens_english();
        ship_notification.load_template_fn_owens_spanish();
        ship_notification.load_template_fn_kimberly_clark_english();
        ship_notification.load_template_fn_kimberly_clark_spanish();
        ship_notification.load_template_fn_bonafont_english();
        ship_notification.load_template_fn_bonafont_spanish();
        ship_notification.load_template_fn_barcel_english();
        ship_notification.load_template_fn_barcel_spanish();
        ship_notification.load_template_fn_sealy_english();
        ship_notification.load_template_fn_sealy_spanish();
        ship_notification.load_template_shipment_tracking_english_ata();
        ship_notification.load_template_shipment_tracking_spanish_ata();
        ship_notification.load_template_fn_estandar_customer_english();
        ship_notification.load_template_fn_estandar_customer_spanish();
        ship_notification.load_template_pto_estandar_english();
        ship_notification.load_template_pto_estandar_spanish();
        ship_notification.load_template_air_shipment_tracking_english();
        ship_notification.load_template_air_shipment_tracking_spanish();

    }
    
}