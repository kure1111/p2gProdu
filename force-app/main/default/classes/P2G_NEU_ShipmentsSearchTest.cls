@isTest
public class P2G_NEU_ShipmentsSearchTest {
    
    @isTest
    static void test_NEU_ShipmentsSearch()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00056', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', ETA_Point_of_Discharge__c =system.today(), ETD_from_Point_of_Load__c = system.today(), Only_Warehouse_Service__c = true);
        insert ship;
        NEU_ShipmentsSearch ss = new NEU_ShipmentsSearch();
        ss.orden_ship_filtro_orders = 'Name';
        ss.orden_ship_filtro_orders_modo = 'asc';
        ss.orden_ship_filtro_request = 'Name';
        ss.orden_ship_filtro_request_modo = 'asc';
        ss.orden_ship_filtro_quotes = 'Name';
        ss.orden_ship_filtro_quotes_modo = 'asc';
        ss.sta_list = '';
        ss.serv_list = '';
        ss.getETD_operator_list();
        ss.getETA_operator_list();
        ss.carga_filtros();
        ss.go_compare_ship_order();
        ss.go_compare_ship_request();
        ss.search_shipments();
        ss.go_compare_ship_quote();
        ss.anterior_siguiente_Instalacion();
        ss.anterior_siguiente_order();
        ss.anterior_siguiente_request();
        
    }
    
    @isTest(SeeAllData=true)
    static void NEU_ShipmentsSearch() 
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account account_test = list_accounts[0];
        //insert account_test;
        Account account_test= new Account();
        account_test.Name='Test';
        account_test.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        account_test.OwnerId=UserInfo.getUserId();
        insert account_test;
        
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.ETD_from_Point_of_Load__c=System.today();
        shipment_test.Route__c=route.Id;
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-TS-00058';
        insert shipment_test;
        
        NEU_ShipmentsSearch c = new NEU_ShipmentsSearch();
        c.shipment_status=c.shipment_status;
        c.shipments_requests=c.shipments_requests;
        c.shipments_quotes=c.shipments_quotes;
        c.shipments_orders=c.shipments_quotes;
        c.sta_list=c.sta_list;
        c.serv_list=c.serv_list;
        c.sta_list='[]';
        c.serv_list='[]';
        c.id_record_type_requests=c.id_record_type_requests;
        c.id_record_type_quotes=c.id_record_type_quotes;
        c.id_record_type_orders=c.id_record_type_orders;
        c.orden_ship_filtro_orders=c.orden_ship_filtro_orders;
        c.orden_ship_filtro_orders_modo=c.orden_ship_filtro_orders_modo;
        c.orden_ship_filtro_quotes=c.orden_ship_filtro_quotes;
        c.orden_ship_filtro_quotes_modo=c.orden_ship_filtro_quotes_modo;
        c.orden_ship_filtro_request=c.orden_ship_filtro_request;
        c.orden_ship_filtro_request_modo=c.orden_ship_filtro_request_modo;
        c.orden_ship_filtro_orders='Name';
        c.orden_ship_filtro_orders_modo='asc';
        c.orden_ship_filtro_quotes='Name';
        c.orden_ship_filtro_quotes_modo='asc';
        c.orden_ship_filtro_request='Name';
        c.orden_ship_filtro_request_modo='asc';
        c.url_tracking_externa=c.url_tracking_externa;
        c.params=c.params;
        c.ETD_operator_selected=c.ETD_operator_selected;
        c.getETD_operator_list();
        c.ETA_operator_selected=c.ETA_operator_selected;
        c.getETA_operator_list();
        c.carga_filtros();
        c.record.ETD_from_Point_of_Load__c=System.today();
        c.record.ETA_Point_of_Discharge__c=System.today();
        c.record.Route__c=route.Id;
        c.ETD_operator_selected='not equal to';
        c.ETA_operator_selected='not equal to';
        c.go_compare_ship_order();
        c.go_compare_ship_quote();
        c.go_compare_ship_request();
        c.search_shipments();
        
    }
}