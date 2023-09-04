trigger NEU_Shipment_Program_copy on Shipment_Program__c (after update)
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    Set<Id>ids=new Set<Id>();
    Map<Id, String> map_ship = new Map<Id, String>();
    boolean change_ETD = false;
    for(Shipment_Program__c sp:trigger.new)
    {
        Shipment_Program__c oldsp=trigger.oldMap.get(sp.Id);
        if(sp.Vessel__c!=oldsp.Vessel__c)
            ids.add(sp.Id);
        if(sp.Flight_Number__c != oldsp.Flight_Number__c)
            ids.add(sp.Id);  
        if(sp.Truck_Number__c != oldsp.Truck_Number__c)
            ids.add(sp.Id);   
        if(sp.Planned_ETD__c != oldsp.Planned_ETD__c)
        {
            ids.add(sp.Id); 
            change_ETD = true; 
        }
        if(sp.Planned_ETA__c != oldsp.Planned_ETA__c)
            ids.add(sp.Id);
        if(sp.Shipments_Program_Status__c != oldsp.Shipments_Program_Status__c)
            ids.add(sp.Id);     
        if(sp.Route__c != oldsp.Route__c)
            ids.add(sp.Id); 
            
            
            
        if(sp.Air_Booking_Number__c != oldsp.Air_Booking_Number__c)
            ids.add(sp.Id); 
        if(sp.Sea_Container_Number__c != oldsp.Sea_Container_Number__c)
            ids.add(sp.Id); 
        if(sp.MBL_Number__c != oldsp.MBL_Number__c)
            ids.add(sp.Id); 
        if(sp.MAWB_Number__c != oldsp.MAWB_Number__c)
            ids.add(sp.Id); 
        if(sp.Sea_Booking_Number__c != oldsp.Sea_Booking_Number__c)
            ids.add(sp.Id); 
        if(sp.Voyage_Number_sp__c != oldsp.Voyage_Number_sp__c)
            ids.add(sp.Id); 
        if(sp.Trailer_Number__c != oldsp.Trailer_Number__c)
            ids.add(sp.Id); 
        if(sp.Rail_Container_Number__c != oldsp.Rail_Container_Number__c)
            ids.add(sp.Id); 
        if(sp.SMGS__c != oldsp.SMGS__c)
            ids.add(sp.Id); 
        if(sp.CIM_Number__c != oldsp.CIM_Number__c)
            ids.add(sp.Id); 
            
           
            
    }
    if(ids != null && ids.size()>0)
    {
        List<Shipment__c>shipments=[select Id,Truck_Vessel_Flight__c,Shipment_Status__c,Inbound_Consolidation_Program__r.Shipments_Program_Status__c,Inbound_Consolidation_Program__r.Air_Booking_Number__c, Inbound_Consolidation_Program__r.Sea_Container_Number__c, Inbound_Consolidation_Program__r.MBL_Number__c, Inbound_Consolidation_Program__r.MAWB_Number__c,
        Inbound_Consolidation_Program__r.Sea_Booking_Number__c, Inbound_Consolidation_Program__r.Voyage_Number_sp__c, Inbound_Consolidation_Program__r.Trailer_Number__c, Inbound_Consolidation_Program__r.Rail_Container_Number__c,
        Inbound_Consolidation_Program__r.SMGS__c,Inbound_Consolidation_Program__r.CIM_Number__c,ETD_from_Point_of_Load__c,Inbound_Consolidation_Program__r.Planned_ETD__c,ETA_Point_of_Discharge__c,Inbound_Consolidation_Program__r.Planned_ETA__c,Route__c, Inbound_Consolidation_Program__r.Route__c ,
        Air_Booking_Number__c,  Sea_Container_Number__c, MBL_Number__c, MAWB_Number__c, Sea_Booking_Number__c, Voyage_Number_s__c, Trailer_Number__c, Rail_Container_Number__c, SMGS__c, CIM_Number__c,
        Inbound_Consolidation_Program__r.Route__r.Port_Airport_of_Load__c, Inbound_Consolidation_Program__r.Route__r.Port_Airport_of_Discharge__c, 
        Inbound_Consolidation_Program__r.Route__r.Country_of_Discharge__c, Inbound_Consolidation_Program__r.Route__r.Country_of_Load__c,
        Inbound_Consolidation_Program__r.Route__r.State_of_Discharge__c, Inbound_Consolidation_Program__r.Route__r.State_of_Load__c,
        Site_of_Load__c, Site_of_Discharge__c,
        Country_of_Discharge__c, Country_of_Load__c, State_of_Discharge__c, State_of_Load__c, 
        Flight_Number__c,Inbound_Consolidation_Program__r.Flight_Number__c,
        Inbound_Consolidation_Program__r.Truck_Number__c,Inbound_Consolidation_Program__r.Vessel__c 
        from Shipment__c where Inbound_Consolidation_Program__c IN:ids];
        
        if(shipments.size()>0)
        {
            for(Shipment__c s:shipments)
            {
                s.Truck_Vessel_Flight__c=s.Inbound_Consolidation_Program__r.Vessel__c;
                s.Flight_Number__c=s.Inbound_Consolidation_Program__r.Flight_Number__c;
                s.Truck_Number__c = s.Inbound_Consolidation_Program__r.Truck_Number__c;
                s.ETD_from_Point_of_Load__c = s.Inbound_Consolidation_Program__r.Planned_ETD__c;
                s.ETA_Point_of_Discharge__c = s.Inbound_Consolidation_Program__r.Planned_ETA__c;
                s.Shipment_Status__c = s.Inbound_Consolidation_Program__r.Shipments_Program_Status__c;
                s.Route__c = s.Inbound_Consolidation_Program__r.Route__c;
                
                s.Air_Booking_Number__c = s.Inbound_Consolidation_Program__r.Air_Booking_Number__c;
                s.Sea_Container_Number__c = s.Inbound_Consolidation_Program__r.Sea_Container_Number__c;
                s.MBL_Number__c = s.Inbound_Consolidation_Program__r.MBL_Number__c;
                s.MAWB_Number__c = s.Inbound_Consolidation_Program__r.MAWB_Number__c;
                s.Sea_Booking_Number__c = s.Inbound_Consolidation_Program__r.Sea_Booking_Number__c;
                s.Voyage_Number_s__c = s.Inbound_Consolidation_Program__r.Voyage_Number_sp__c;
                s.Trailer_Number__c = s.Inbound_Consolidation_Program__r.Trailer_Number__c;
                s.Rail_Container_Number__c = s.Inbound_Consolidation_Program__r.Rail_Container_Number__c;
                s.SMGS__c = s.Inbound_Consolidation_Program__r.SMGS__c;
                s.CIM_Number__c = s.Inbound_Consolidation_Program__r.CIM_Number__c;
                
                s.Site_of_Load__c = s.Inbound_Consolidation_Program__r.Route__r.Port_Airport_of_Load__c; 
                s.Site_of_Discharge__c = s.Inbound_Consolidation_Program__r.Route__r.Port_Airport_of_Discharge__c;
                s.Country_of_Discharge__c = s.Inbound_Consolidation_Program__r.Route__r.Country_of_Discharge__c;
                s.Country_of_Load__c = s.Inbound_Consolidation_Program__r.Route__r.Country_of_Load__c;
                s.State_of_Discharge__c = s.Inbound_Consolidation_Program__r.Route__r.State_of_Discharge__c;
                s.State_of_Load__c = s.Inbound_Consolidation_Program__r.Route__r.State_of_Load__c;
            }
            update shipments;
        }
        
        //si cambia el planned etd actualizo el shipment anterior
        if(change_ETD == true)
        {
        	List<Shipment_Consolidation_Data__c> query_shipment_conso_data = [select Id, Name, Import_Export_Quote__c, Planned_ETD__c from Shipment_Consolidation_Data__c where Shipments_Program__c IN: ids and Import_Export_Quote__c !=: null];
        	Set<Id> list_import_export = new Set<Id>();
        	
        	Map<Id, date> new_map_import_export = new Map<Id, date>();
        	for(Shipment_Consolidation_Data__c scd: query_shipment_conso_data)
        	{
        		list_import_export.add(scd.Import_Export_Quote__c);
        		new_map_import_export.put(scd.Import_Export_Quote__c, scd.Planned_ETD__c);
        	}
        	
        	if(list_import_export != null && list_import_export.size()>0)
        	{
        		query_shipment_conso_data = [select Id, Name, Shipment__c, Import_Export_Quote__c, Shipment__r.Storage_Date_To__c from Shipment_Consolidation_Data__c where Import_Export_Quote__c IN: list_import_export and Import_Export_Quote__c !=: null and Shipments_Program__c not IN: ids order by CreatedDate desc];
        		Map<Id, Shipment__c> shipments_to_update = new Map<Id, Shipment__c>();
        		for(Shipment_Consolidation_Data__c scd: query_shipment_conso_data )
        		{
        			if(shipments_to_update.containsKey(scd.Import_Export_Quote__c) == false)
        			{
        				if(new_map_import_export.containsKey(scd.Import_Export_Quote__c) == true)
        				{
        					scd.Shipment__r.Storage_Date_To__c = new_map_import_export.get(scd.Import_Export_Quote__c);
        					shipments_to_update.put(scd.Import_Export_Quote__c, scd.Shipment__r);
        				}
        			}
        		}
        		
        		if(shipments_to_update != null && shipments_to_update.size()>0)
        		{
        			update shipments_to_update.values();
        		}
        	}
        }
    }
}