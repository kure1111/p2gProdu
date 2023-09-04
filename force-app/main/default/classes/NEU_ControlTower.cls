public with sharing class NEU_ControlTower 
{
    public static List<Route_Point_s> route_points;
    
    @AuraEnabled
    public static List<Shipment__c> getShipmentsPlanned()
    {
        date fecha_mas_treinta = system.today().adddays(30);
        date fecha_de_hoy = system.today();
        date fecha_menos_treinta = system.today().adddays(-30);
        
        string query = '';
        query += 'SELECT Id, Name, Truck_Vessel_Latitude__c, Mode_Lightning__c,';
        query += 'Truck_Vessel_Longitude__c,Vessel_Speed__c, Vessel_Course__c,  Vessel_Activities__c,  Account_for__c,';
        query += 'Account_for__r.Name, TrackOptions_Value__c, Carriers_value_OI__c, Track_Option__c,';
        query += 'Carriers_OI__c, Last_Activity__c, Date__c,  ETA_ATA__c, ATAPOD__c, ETD__c, Location__c, Location_Code__c,';
        query += 'Carrier_OI__c, Vessel_Name__c, Imo_Number__c, Voyage_Number__c,';
        query += 'Origin__c, Origin_Code__c, MMSI__c, Port_Of_Loading__c, Port_Of_Loading_Code__c, Port_Of_Discharging__c, Port_Of_Discharging_Code__c, Final_Discharge__c,';
        query += 'Vessel_Information_Vessel__c, Truck_Vessel_Flight__r.MMSI__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Latitude__c, Truck_Vessel_Flight__r.Vessel_Longitude__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Speed__c, Truck_Vessel_Flight__r.Last_Update__c, Vessel_Information__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Information__c, Truck_Vessel_Flight__r.Vessel_Course__c,';
        query += 'Last_Update_Vessel__c, Final_Discharge_Code__c, Inbound_Consolidation_Program__c,';
        query += 'External_Reference_OI__c, Port_of_Transshipment_1__c, Port_of_Transshipment_Code_1__c, Port_of_Transshipment_2__c,';
        query += 'Port_of_Transshipment_Code_2__c, Port_of_Transshipment_3__c, Port_of_Transshipment_Code_3__c, Vessel_1__c, Vessel_Imo_1__c, Vessel_2__c,';
        query += 'Vessel_Imo_2__c, Vessel_3__c, Vessel_Imo_3__c, Vessel_4__c, Vessel_Imo_4__c, Truck_Number__c, Country_of_Load__r.Name,';
        query += 'Country_of_Discharge__r.Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, OI_Status__c,';
        query += 'OI_Status_Code__c, Number__c, Freight_Mode__c , Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.IMO__c, Truck_Vessel_Flight__r.Name, MAWB_Number__c, Flight_Number__c,';
        query += 'ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Shipment_Status__c'; 
        query += ' FROM Shipment__c'; 
        query += ' WHERE (Shipment_Status__c = \'Planned for delivery - Not yet on route\' OR Ocean_Shipment_Status__c =\'Booking Confirmation\') ';
        query += ' AND External_Reference_OI__c != null and ETD_from_Point_of_Load__c >=: fecha_de_hoy and ETD_from_Point_of_Load__c <=: fecha_mas_treinta';
        
        List<Shipment__c> list_planned_shipments = database.query(query);

        return list_planned_shipments;
    }
    
    @AuraEnabled
    public static List<Shipment__c> getIntransitShipments()
    {
        date fecha_mas_treinta = system.today().adddays(30);
        date fecha_de_hoy = system.today();
        date fecha_menos_treinta = system.today().adddays(-30);
        
        string query = '';
        query += 'SELECT Id, Name, Truck_Vessel_Latitude__c,';
        query += 'Truck_Vessel_Longitude__c,Vessel_Speed__c, Vessel_Course__c,  Vessel_Activities__c,  Account_for__c,';
        query += 'Account_for__r.Name, TrackOptions_Value__c, Carriers_value_OI__c, Track_Option__c,';
        query += 'Carriers_OI__c,  Last_Activity__c, Date__c,  ETA_ATA__c, ATAPOD__c, ETD__c, Location__c, Location_Code__c,';
        query += 'Carrier_OI__c, Vessel_Name__c, Imo_Number__c, Voyage_Number__c,';
        query += 'Origin__c, Origin_Code__c, MMSI__c, Port_Of_Loading__c, Port_Of_Loading_Code__c, Port_Of_Discharging__c, Port_Of_Discharging_Code__c, Final_Discharge__c,';
        query += 'Vessel_Information_Vessel__c, Truck_Vessel_Flight__r.MMSI__c,'; 
        query += 'Truck_Vessel_Flight__r.Vessel_Latitude__c, Truck_Vessel_Flight__r.Vessel_Longitude__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Speed__c, Truck_Vessel_Flight__r.Last_Update__c, Vessel_Information__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Information__c, Truck_Vessel_Flight__r.Vessel_Course__c,';
        query += 'Last_Update_Vessel__c, Final_Discharge_Code__c, Inbound_Consolidation_Program__c,';
        query += 'External_Reference_OI__c, Port_of_Transshipment_1__c, Port_of_Transshipment_Code_1__c, Port_of_Transshipment_2__c,';
        query += 'Port_of_Transshipment_Code_2__c, Port_of_Transshipment_3__c, Port_of_Transshipment_Code_3__c, Vessel_1__c, Vessel_Imo_1__c, Vessel_2__c,';
        query += 'Vessel_Imo_2__c, Vessel_3__c, Vessel_Imo_3__c, Vessel_4__c, Vessel_Imo_4__c, Truck_Number__c, Country_of_Load__r.Name,';
        query += 'Country_of_Discharge__r.Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, OI_Status__c,';
        query += 'OI_Status_Code__c,  Number__c, Freight_Mode__c , Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.IMO__c, Truck_Vessel_Flight__r.Name, MAWB_Number__c,'; 
        query += 'Flight_Number__c, ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Shipment_Status__c, Ocean_Shipment_Status__c';
        query += ' FROM Shipment__c'; 
        query += ' WHERE ((Shipment_Status__c != null AND Shipment_Status__c != \'Cancel\' AND Shipment_Status__c != \'Finished\') OR (Ocean_Shipment_Status__c != null AND Ocean_Shipment_Status__c != \'Cancel\' AND Ocean_Shipment_Status__c != \'Finished\')) AND External_Reference_OI__c != null';
        
        List<Shipment__c> list_transit_shipments = database.query(query);
        
        return list_transit_shipments;
    }
    
    @AuraEnabled
    public static List<Shipment__c> getDeliveredShipments()
    {
        date fecha_mas_treinta = system.today().adddays(30);
        date fecha_de_hoy = system.today();
        date fecha_menos_treinta = system.today().adddays(-30);
        
        string query = '';
        query += 'SELECT Id, Name, Truck_Vessel_Latitude__c,';
        query += 'Truck_Vessel_Longitude__c,Vessel_Speed__c, Vessel_Course__c,  Vessel_Activities__c,  Account_for__c,';
        query += 'Account_for__r.Name, TrackOptions_Value__c, Carriers_value_OI__c, Track_Option__c,';
        query += 'Carriers_OI__c, Last_Activity__c, Date__c,  ETA_ATA__c, ATAPOD__c, ETD__c, Location__c, Location_Code__c,';
        query += 'Carrier_OI__c, Vessel_Name__c, Imo_Number__c, Voyage_Number__c,';
        query += 'Origin__c, Origin_Code__c, MMSI__c, Port_Of_Loading__c, Port_Of_Loading_Code__c, Port_Of_Discharging__c, Port_Of_Discharging_Code__c, Final_Discharge__c,';
        query += 'Vessel_Information_Vessel__c, Truck_Vessel_Flight__r.MMSI__c, ';
        query += 'Truck_Vessel_Flight__r.Vessel_Latitude__c, Truck_Vessel_Flight__r.Vessel_Longitude__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Speed__c, Truck_Vessel_Flight__r.Last_Update__c, Vessel_Information__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Information__c, Truck_Vessel_Flight__r.Vessel_Course__c,';
        query += 'Last_Update_Vessel__c, Final_Discharge_Code__c, Inbound_Consolidation_Program__c,';
        query += 'External_Reference_OI__c, Port_of_Transshipment_1__c, Port_of_Transshipment_Code_1__c, Port_of_Transshipment_2__c,';
        query += 'Port_of_Transshipment_Code_2__c, Port_of_Transshipment_3__c, Port_of_Transshipment_Code_3__c, Vessel_1__c, Vessel_Imo_1__c, Vessel_2__c,';
        query += 'Vessel_Imo_2__c, Vessel_3__c, Vessel_Imo_3__c, Vessel_4__c, Vessel_Imo_4__c, Truck_Number__c, Country_of_Load__r.Name,';
        query += 'Country_of_Discharge__r.Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, OI_Status__c,';
        query += 'OI_Status_Code__c,  Number__c, Freight_Mode__c , Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.IMO__c, Truck_Vessel_Flight__r.Name, MAWB_Number__c, ';
        query += 'Flight_Number__c, ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Shipment_Status__c, Ocean_Shipment_Status__c';
        query += ' FROM Shipment__c';
        query += ' WHERE Freight_Mode__c = \'Sea\' AND ((Shipment_Status__c != null AND Shipment_Status__c != \'Cancel\' AND Shipment_Status__c != \'Finished\') OR (Ocean_Shipment_Status__c != null AND Ocean_Shipment_Status__c != \'Cancel\' AND Ocean_Shipment_Status__c != \'Finished\'))';
        query += ' AND External_Reference_OI__c != null AND ETA_Point_of_Discharge__c >=: fecha_de_hoy';
        query += ' AND ETA_Point_of_Discharge__c <=: fecha_mas_treinta';
        /*
        query += ' WHERE (Shipment_Status__c = \'Delivered\' OR Shipment_Status__c = \'Delivered to Depot\'';
        query += ' OR Shipment_Status__c = \'Agent Notified\' OR Shipment_Status__c = \'Closed\' OR Shipment_Status__c = \'Closed with Errors\'';
        query += ' OR Shipment_Status__c  = \'Customs Clearance Processed\') AND External_Reference_OI__c != null AND ETA_Point_of_Discharge__c >=: fecha_de_hoy';
        query += ' AND ETA_Point_of_Discharge__c <=: fecha_mas_treinta';
        */

        List<Shipment__c> list_delievered_shipments = database.query(query);
        
        return list_delievered_shipments;
    }
    
    @AuraEnabled
    public static List<Shipment__c> getRoadShipments()
    {
        string query = '';
        query += 'SELECT Id, Name, Truck_Vessel_Latitude__c,';
        query += 'Truck_Vessel_Longitude__c,Vessel_Speed__c, Vessel_Course__c,  Vessel_Activities__c,  Account_for__c,';
        query += 'Account_for__r.Name, TrackOptions_Value__c, Carriers_value_OI__c, Track_Option__c,';
        query += 'Carriers_OI__c, Last_Activity__c, Date__c,  ETA_ATA__c, ATAPOD__c, ETD__c, Location__c, Location_Code__c,';
        query += 'Carrier_OI__c, Vessel_Name__c, Imo_Number__c, Voyage_Number__c,';
        query += 'Origin__c, Origin_Code__c, MMSI__c, Port_Of_Loading__c, Port_Of_Loading_Code__c, Port_Of_Discharging__c, Port_Of_Discharging_Code__c, Final_Discharge__c,';
        query += 'Vessel_Information_Vessel__c, Truck_Vessel_Flight__r.MMSI__c, ';
        query += 'Truck_Vessel_Flight__r.Vessel_Latitude__c, Truck_Vessel_Flight__r.Vessel_Longitude__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Speed__c, Truck_Vessel_Flight__r.Last_Update__c, Vessel_Information__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Information__c, Truck_Vessel_Flight__r.Vessel_Course__c,';
        query += 'Last_Update_Vessel__c, Final_Discharge_Code__c, Inbound_Consolidation_Program__c,';
        query += 'External_Reference_OI__c, Port_of_Transshipment_1__c, Port_of_Transshipment_Code_1__c, Port_of_Transshipment_2__c,';
        query += 'Port_of_Transshipment_Code_2__c, Port_of_Transshipment_3__c, Port_of_Transshipment_Code_3__c, Vessel_1__c, Vessel_Imo_1__c, Vessel_2__c,';
        query += 'Vessel_Imo_2__c, Vessel_3__c, Vessel_Imo_3__c, Vessel_4__c, Vessel_Imo_4__c, Truck_Number__c, Country_of_Load__r.Name,';
        query += 'Country_of_Discharge__r.Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, OI_Status__c,';
        query += 'OI_Status_Code__c,  Number__c, Freight_Mode__c , Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.IMO__c, Truck_Vessel_Flight__r.Name, MAWB_Number__c, ';
        query += 'Flight_Number__c, ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Shipment_Status__c, Shipment_Status_Mon__c';
        query += ' FROM Shipment__c'; 
        //query += ' WHERE Freight_Mode__c = \'Road\' AND Shipment_Status__c = \'Delivery On route\'';
        query += ' WHERE Freight_Mode__c = \'Road\' AND (Shipment_Status_Mon__c != \'Finished_M\' AND Shipment_Status_Mon__c != \'Failure_M\' AND Shipment_Status_Mon__c != \'Cancel_M\'';
        query += ' AND Shipment_Status_Mon__c != \'In Warehouse_M\' AND Shipment_Status_Mon__c != \'False_M\' AND Shipment_Status_Mon__c != \'Operative Failure_M\' AND Shipment_Status_Mon__c != null)';

        List<Shipment__c> list_road_shipments = database.query(query);
        
        return list_road_shipments;
    }
    
    @AuraEnabled
    public static List<Shipment__c> getAirShipments()
    {
        string query = '';
        query += 'SELECT Id, Name, Truck_Vessel_Latitude__c,';
        query += 'Truck_Vessel_Longitude__c,Vessel_Speed__c, Vessel_Course__c,  Vessel_Activities__c,  Account_for__c,';
        query += 'Account_for__r.Name, TrackOptions_Value__c, Carriers_value_OI__c, Track_Option__c,';
        query += 'Carriers_OI__c, Last_Activity__c, Date__c,  ETA_ATA__c, ATAPOD__c, ETD__c, Location__c, Location_Code__c,';
        query += 'Carrier_OI__c, Vessel_Name__c, Imo_Number__c, Voyage_Number__c,';
        query += 'Origin__c, Origin_Code__c, MMSI__c, Port_Of_Loading__c, Port_Of_Loading_Code__c, Port_Of_Discharging__c, Port_Of_Discharging_Code__c, Final_Discharge__c,';
        query += 'Vessel_Information_Vessel__c, Truck_Vessel_Flight__r.MMSI__c, ';
        query += 'Truck_Vessel_Flight__r.Vessel_Latitude__c, Truck_Vessel_Flight__r.Vessel_Longitude__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Speed__c, Truck_Vessel_Flight__r.Last_Update__c, Vessel_Information__c,';
        query += 'Truck_Vessel_Flight__r.Vessel_Information__c, Truck_Vessel_Flight__r.Vessel_Course__c,';
        query += 'Last_Update_Vessel__c, Final_Discharge_Code__c, Inbound_Consolidation_Program__c,';
        query += 'External_Reference_OI__c, Port_of_Transshipment_1__c, Port_of_Transshipment_Code_1__c, Port_of_Transshipment_2__c,';
        query += 'Port_of_Transshipment_Code_2__c, Port_of_Transshipment_3__c, Port_of_Transshipment_Code_3__c, Vessel_1__c, Vessel_Imo_1__c, Vessel_2__c,';
        query += 'Vessel_Imo_2__c, Vessel_3__c, Vessel_Imo_3__c, Vessel_4__c, Vessel_Imo_4__c, Truck_Number__c, Country_of_Load__r.Name,';
        query += 'Country_of_Discharge__r.Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, OI_Status__c,';
        query += 'OI_Status_Code__c,  Number__c, Freight_Mode__c , Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.IMO__c, Truck_Vessel_Flight__r.Name, MAWB_Number__c, ';
        query += 'Flight_Number__c, ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Shipment_Status__c, Air_Shipment_Status__c';
        query += ' FROM Shipment__c'; 
        //query += ' WHERE Freight_Mode__c = \'Air\' AND Shipment_Status__c = \'Delivery On route\'';
        query += ' WHERE Freight_Mode__c = \'Air\' AND Air_Shipment_Status__c != \'Finish\' AND Air_Shipment_Status__c != \'Cancel\'';

        List<Shipment__c> list_road_shipments = database.query(query);
        
        return list_road_shipments;
    }
    
    @AuraEnabled
    public static Shipment_Track__c getShipmentTrack(Shipment__c shipment_selected)
    {
        List<Shipment_Track__c> shipment_track = [SELECT Id, Name, Public_Sharing_URL__c
        FROM Shipment_Track__c WHERE Shipment__c =: shipment_selected.Id limit 1];
        
        if(shipment_track.size() > 0)
            return shipment_track[0];
        else
            return null;
    }
    
    @AuraEnabled
    public static List<Shipment_Stop__c> getRoadData(Shipment__c shipment_selected)
    {
        return [SELECT Id, Name, Country__c, State__c, Location__c, Address__c, Country__r.Name, State__r.Name, Location__r.Name
        FROM Shipment_Stop__c WHERE Shipment__c =: shipment_selected.Id];
    }
    
    public class Route_Point_s
    {
        @AuraEnabled
        public String Image {get;set;}
        @AuraEnabled
        public String Country {get;set;}
        @AuraEnabled
        public String State {get;set;}
        @AuraEnabled
        public String Location {get;set;}
        @AuraEnabled
        public String Address {get;set;}
    }
    
    @AuraEnabled
    public static List<Route_Point_s> getRoutePoints(Shipment__c shipment_selected)
    {
        route_points = new List<Route_Point_s>();
        
        Route_Point_s new_point_origin = new Route_Point_s();
        new_point_origin.Image = 'origin_icon';
        new_point_origin.Country = shipment_selected.Country_of_Load__r.Name;
        new_point_origin.State = shipment_selected.State_of_Load__r.Name;
        new_point_origin.Location = shipment_selected.Site_of_Load__r.Name;
        new_point_origin.Address = '';
        route_points.add(new_point_origin);
        
        List<Shipment_Stop__c> stops = [SELECT Id, Name, Country__c, State__c, Location__c, Address__c, Country__r.Name, State__r.Name, Location__r.Name
        FROM Shipment_Stop__c WHERE Shipment__c =: shipment_selected.Id];
        
        for(Shipment_Stop__c s : stops)
        {
            Route_Point_s new_point_stop = new Route_Point_s();
            new_point_stop.Image = 'stop_icon';
            new_point_stop.Country = s.Country__r.Name;
            new_point_stop.State = s.State__r.Name;
            new_point_stop.Location = s.Location__r.Name;
            new_point_stop.Address = s.Address__c;
            route_points.add(new_point_stop);
        }
        
        Route_Point_s new_point_destination = new Route_Point_s();
        new_point_destination.Image = 'destination_icon';
        new_point_destination.Country = shipment_selected.Country_of_Discharge__r.Name;
        new_point_destination.State = shipment_selected.State_of_Discharge__r.Name;
        new_point_destination.Location = shipment_selected.Site_of_Discharge__r.Name;
        new_point_destination.Address = '';
        route_points.add(new_point_destination);
        
        return route_points;
    }
    
    @AuraEnabled
    public static Shipment__c getShipment(string shipment_id) 
    {
        return [SELECT Id, Name, Truck_Vessel_Latitude__c, Mode_Lightning__c,
        Truck_Vessel_Longitude__c,Vessel_Speed__c, Vessel_Course__c,  Vessel_Activities__c,  Account_for__c,
        Account_for__r.Name, TrackOptions_Value__c, Carriers_value_OI__c, Track_Option__c,
        Carriers_OI__c, Last_Activity__c, Date__c,  ETA_ATA__c, ATAPOD__c, ETD__c, Location__c, Location_Code__c,
        Carrier_OI__c, Vessel_Name__c, Imo_Number__c, Voyage_Number__c,
        Origin__c, Origin_Code__c, MMSI__c, Port_Of_Loading__c, Port_Of_Loading_Code__c, Port_Of_Discharging__c, Port_Of_Discharging_Code__c, Final_Discharge__c,
        Vessel_Information_Vessel__c, Truck_Vessel_Flight__r.MMSI__c,
        Truck_Vessel_Flight__r.Vessel_Latitude__c, Truck_Vessel_Flight__r.Vessel_Longitude__c,
        Truck_Vessel_Flight__r.Vessel_Speed__c, Truck_Vessel_Flight__r.Last_Update__c, Vessel_Information__c,
        Truck_Vessel_Flight__r.Vessel_Information__c, Truck_Vessel_Flight__r.Vessel_Course__c,
        Last_Update_Vessel__c, Final_Discharge_Code__c, Inbound_Consolidation_Program__c,
        External_Reference_OI__c, Port_of_Transshipment_1__c, Port_of_Transshipment_Code_1__c, Port_of_Transshipment_2__c,
        Port_of_Transshipment_Code_2__c, Port_of_Transshipment_3__c, Port_of_Transshipment_Code_3__c, Vessel_1__c, Vessel_Imo_1__c, Vessel_2__c,
        Vessel_Imo_2__c, Vessel_3__c, Vessel_Imo_3__c, Vessel_4__c, Vessel_Imo_4__c, Truck_Number__c, Country_of_Load__r.Name,
        Country_of_Discharge__r.Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, OI_Status__c,
        OI_Status_Code__c, Number__c, Freight_Mode__c , Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.IMO__c, Truck_Vessel_Flight__r.Name, MAWB_Number__c, Flight_Number__c,
        ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Shipment_Status__c, Direccion_Monitoreo__c
        FROM Shipment__c WHERE Id =: shipment_id limit 1]; 
    }
}