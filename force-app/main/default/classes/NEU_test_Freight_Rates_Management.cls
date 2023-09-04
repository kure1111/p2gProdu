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
private class NEU_test_Freight_Rates_Management 
{
    
    public static testMethod void test_NEU_Form_Quotation () 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Account carrier = list_accounts[1];
        insert carrier;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id ,Marketplace_Auction__c = true, Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, Shipment_Quoted_Marketplace__c =ship.Id, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Carrier_Account__c = carrier.Id, Account_for__c = a.Id);
        insert fee;
        string id_url = fee.Id+''+contacto.Id+''+carrier.Id+'';
        ApexPages.currentPage().getParameters().put('id', id_url);
        NEU_Form_Quotation  fq = new NEU_Form_Quotation();
        fq.getlistado_rate_type();
        string decimales = fq.decimalSep;
        string miles = fq.thousandSep;
        fq.send_form();
        
        
    }
    
    public static testMethod void test_NEU_New_Service_Rate_Internal() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account carrier = list_accounts[1];
        insert carrier;
        Contact contacto = new Contact(AccountId = carrier.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Route__c = route.Id ,Marketplace_Auction__c = true, Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, Shipment_Quoted_Marketplace__c =ship.Id, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Carrier_Account__c = carrier.Id, Account_for__c = a.Id);
        insert fee;
        ApexPages.currentPage().getParameters().put('secret', '10');
        ApexPages.currentPage().getParameters().put('email', 'oscar@neurored.com');
        ApexPages.currentPage().getParameters().put('shipment', ship.Id);
        NEU_New_Service_Rate_Internal nsri = new NEU_New_Service_Rate_Internal(new ApexPages.StandardController( fee ));
        nsri.check_fee();
        List<Shipment__c> listado_shipment_selected = new List<Shipment__c>();
        listado_shipment_selected.add(ship);
        nsri.shipment_selected = listado_shipment_selected;
        nsri.update_Ranking();
        nsri.update_ranking_send_email();
        nsri.send_form();
    }
    
     public static testMethod void test_NEU_Send_Request_for_Quotation() 
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> accs = new List<Account>();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter');
        Account a = list_accounts[0];
        accs.add(a);
        Account carrier =  list_accounts[1];
        accs.add(carrier);
        insert accs;
        Contact contacto = new Contact(AccountId = carrier.Id, LastName='test contact', Email='oscar@neurored.com', Secret__c='10');
        insert contacto;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Standard_Rate__c = true, Carrier_Account__c = carrier.Id, Account_for__c = a.Id);
        insert fee;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
        insert ship_prog;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog.Id, Only_Warehouse_Service__c = true);
        insert ship;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
        insert importexportquote;
        ApexPages.currentPage().getParameters().put('Service_Rate', fee.Id);
        NEU_Send_Request_for_Quotation srfq = new NEU_Send_Request_for_Quotation();
        srfq.getnewcategories();
        srfq.getnewcategory();
        srfq.setnewcategory('Disbursement');
        srfq.subfamily=srfq.subfamily;
        srfq.subfamilies=srfq.subfamilies;
        srfq.item=srfq.item;
        srfq.items=srfq.items;
        srfq.orden_quotes = 'line.Name-asc';
        srfq.go_compare();
        srfq.getlista_suppliers();
        for (NEU_Send_Request_for_Quotation.Supplier_s lines:srfq.getlista_suppliers())
        {
            lines.selected = true;
            lines.contact_select = contacto.id;
        }
        ApexPages.currentPage().getParameters().put('imp_exp', importexportquote.Id);
        ApexPages.currentPage().getParameters().put('ship', ship.Id);
        ApexPages.currentPage().getParameters().put('ship_prog', ship_prog.Id);
    }
    
}