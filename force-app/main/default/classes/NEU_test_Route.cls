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
private class NEU_test_Route {

    
    static testMethod void NEU_Freight_Rates_Management_Route()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
        new_route.Name = 'Route Test';
        insert new_route;
        NEU_Freight_Rates_Management_Route frmr= new NEU_Freight_Rates_Management_Route(new ApexPages.StandardController(new_route));
        frmr.ordenar_tabla_fees();
    }
    
    static testMethod void NEU_Routes_Rates() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account a2 =list_accounts[1];
        insert a2;
        Fee__c f=new Fee__c(Route__c=route.id,Account_for__c=a.id,Fee_Category__c='test',Carrier_Account__c=a2.id,Valid_Until__c=system.today());
        insert f;       

        NEU_Routes_Rates r= new NEU_Routes_Rates();
        r.new_filter_route=new Carrier_Line_Load_Point__c();
        r.new_filter_route.Country_of_Load__c=Country.id;
        r.new_filter_route.Port_Airport_of_Load__c=localizacion.id;
        r.new_filter_route.Country_of_Discharge__c=Country.id;
        r.new_filter_route.Port_Airport_of_Discharge__c=localizacion.id;
        r.new_filter_fee=new Fee__c();
        r.new_filter_fee.Carrier_Account__c=a2.id;
        r.new_filter_fee.Account_for__c=a.id;
        r.new_filter_fee.Valid_Until__c=f.Valid_Until__c;
        r.Valid_Until_selected='equal';
        r.new_fee_active=r.new_fee_active;
        r.new_fee_desactive=r.new_fee_desactive;
        r.rate_category_list='[test]';
        r.rate_category_buttons=r.rate_category_buttons;
        r.orden_route=r.orden_route;
        r.modo_orden_route=r.modo_orden_route;
        r.Valid_Until_selected=r.Valid_Until_selected;
        r.getValid_Until_list();
        r.search_routes();
        r.go_compare();
        r.getlist_route();
    }
    
}