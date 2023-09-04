/**
 * Created by jamarin on 30/05/2019.
 */
@isTest
public with sharing class NEU_test_CommunityShipments
{
    static testMethod void NEU_CommunityShipmentsMonitoring()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;

        Country__c country_test = new Country__c();
        country_test.Name = 'Country Test';
        country_test.ISO_Code__c = 'EUR';
        insert country_test;

        Location__c location_test = new Location__c();
        location_test.Name = 'Location Test';
        location_test.Country__c = country_test.Id;
        location_test.Subdivision__c = 'Subdivision';
        location_test.UNLOCODE__c = 'ABC';
        insert location_test;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Road';
        shipment_test.Service_Mode__c = 'NATIONAL';
        shipment_test.Service_Type__c = 'FTL';
        shipment_test.Country_of_Load__c = country_test.Id;
        shipment_test.Site_of_Load__c = location_test.Id;
        shipment_test.Country_of_Discharge__c = country_test.Id;
        shipment_test.Site_of_Discharge__c = location_test.Id;
        shipment_test.Shipment_Status_Mon__c = 'Delivery on Route';
        shipment_test.Shipment_Status_Plann__c = 'Confirmed';
        insert shipment_test;

        Shipment__c ship = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Marketplace_Auction__c = true, Only_Warehouse_Service__c = true, Shipment_Status_Plann__c = 'Confirmed', Shipment_Status__c = 'Delivery On route', MBL_Number__c = 'Test', AMS__c = 'Test');
        insert ship;
        Shipment__c ship2 = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Marketplace_Auction__c = true, Only_Warehouse_Service__c = true, Shipment_Status_Plann__c = 'Confirmed', Ocean_Shipment_Status__c = 'Telex Confirmation', MBL_Number__c = 'Test', AMS__c = 'Test');
        insert ship2;

        List<NEU_CommunityShipmentsMonitoring.shipment_s> shipments = NEU_CommunityShipmentsMonitoring.getShipments();
        List<NEU_CommunityShipmentsMonitoring.shipment_s> shipmentsSea = NEU_CommunityShipmentsMonitoring.getShipmentsSeaImpo();
        List<NEU_CommunityShipmentsMonitoring.shipment_s> shipmentsSea2 = NEU_CommunityShipmentsMonitoring.getShipmentsSeaExpo();

    }

    static testMethod void NEU_ControlTower()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;

        Shipment_Stop__c new_shipment_stop = new Shipment_Stop__c();
        new_shipment_stop.Shipment__c = shipment_test.Id;
        insert new_shipment_stop;

        List<Event__c> newevents = new List<Event__c>();
        Event__c new_event = new Event__c();
        newevents.add(new_event);

        List<Shipment__c> list_shipment = new List<Shipment__c>();
        Shipment_Track__c shipment_track = new Shipment_Track__c();
        List<Shipment_Stop__c> list_stops = new List<Shipment_Stop__c>();
        List<NEU_ControlTower.Route_Point_s> list_route_points = new List<NEU_ControlTower.Route_Point_s>();
        Shipment__c shipment = new Shipment__c();
        Event__c event = new Event__c();

        list_shipment = NEU_ControlTower.getShipmentsPlanned();
        list_shipment = NEU_ControlTower.getIntransitShipments();
        list_shipment = NEU_ControlTower.getDeliveredShipments();
        list_shipment = NEU_ControlTower.getRoadShipments();
        list_shipment = NEU_ControlTower.getAirShipments();
        shipment_track = NEU_ControlTower.getShipmentTrack(shipment_test);
        list_stops = NEU_ControlTower.getRoadData(shipment_test);
        list_route_points = NEU_ControlTower.getRoutePoints(shipment_test);
        shipment = NEU_ControlTower.getShipment(shipment_test.Id);
    }

}