trigger NEU_Update_Flight_Number on Shipment__c (after insert, after update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}		
	
    Set<Id>ids=new Set<Id>();
    Map<Id, string> map_shipment_flight_number = new Map<Id, string>();
    Map<Id, string> map_shipment_truck_number = new Map<Id, string>();
    
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Update_Flight_Number')){
        RecursiveCheck.triggerMonitor.add('NEU_Update_Flight_Number');
        
        for(Shipment__c ship:trigger.new)
        {
            if(trigger.isUpdate)
            {
                Shipment__c oldship=trigger.oldMap.get(ship.Id);
                if(ship.Flight_Number__c != oldship.Flight_Number__c && ship.Flight_Number__c != null && ship.Inbound_Consolidation_Program__c != null)
                {
                    ids.add(ship.Inbound_Consolidation_Program__c);   
                    map_shipment_flight_number.put(ship.Inbound_Consolidation_Program__c, ship.Flight_Number__c);
                }
                
                if(ship.Truck_Number__c != oldship.Truck_Number__c && ship.Truck_Number__c != null && ship.Inbound_Consolidation_Program__c != null)
                {
                    ids.add(ship.Inbound_Consolidation_Program__c);  
                    map_shipment_truck_number.put(ship.Inbound_Consolidation_Program__c, ship.Truck_Number__c );
                }
            }
            else
            {
               if(ship.Flight_Number__c != null && ship.Inbound_Consolidation_Program__c != null)
               {
                   ids.add(ship.Inbound_Consolidation_Program__c);  
                   map_shipment_flight_number.put(ship.Inbound_Consolidation_Program__c, ship.Flight_Number__c);
               }
               
               if(ship.Truck_Number__c != null && ship.Inbound_Consolidation_Program__c != null)
               {
                   ids.add(ship.Inbound_Consolidation_Program__c);  
                   map_shipment_truck_number.put(ship.Inbound_Consolidation_Program__c, ship.Truck_Number__c);
               }
               
            }    
        }
        
        if(ids != null && ids.size()>0)
        {
            List<Shipment_Program__c>shipments_prog=[select Id, Truck_Number__c, Flight_Number__c from Shipment_Program__c where id IN:ids];
            if(shipments_prog.size()>0)
            {
                for(Shipment_Program__c s :shipments_prog)
                {
                    if(map_shipment_flight_number.containsKey(s.Id))
                        s.Flight_Number__c=map_shipment_flight_number.get(s.Id);
                        
                    if(map_shipment_truck_number.containsKey(s.Id))
                        s.Truck_Number__c=map_shipment_truck_number.get(s.Id);    
                        
                }
                update shipments_prog;
            }
        }
    }    
}