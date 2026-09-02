trigger NEU_Update_Track_and_Trace_Status_Shipment on Shipment__c (before update) 
{
    /*if(NEU_StaticVariableHelper.getBoolean1())
        return; 
    
    Map<String, String> mapStatusShipment = new Map<String, String>();
    mapStatusShipment.put('waiting for pickup','Planned for delivery - Not yet on route');
    mapStatusShipment.put('land transport to POL','Delivery On route');
    mapStatusShipment.put('in POL terminal','Delivery On route');
    mapStatusShipment.put('waiting for departure from POL','Delivery On route');
    mapStatusShipment.put('ocean transport from POL','Delivery On route');
    mapStatusShipment.put('in transshipment','Delivery On route'); 
    mapStatusShipment.put('ocean transport to POD','Delivery On route');
    mapStatusShipment.put('waiting for discharge at POD','Delivery On route');
    mapStatusShipment.put('in POD terminal','Delivery On route');//Delivery On route
    mapStatusShipment.put('land transport to Place of Delivery','Delivery On route');
    mapStatusShipment.put('delivered; returning container','Delivered');
    mapStatusShipment.put('completed','Delivered'); 
    mapStatusShipment.put('initializing','Planned for delivery - Not yet on route');
        
    for(Shipment__c s : trigger.new)
    {
        Shipment__c old_shipment = Trigger.oldMap.get(s.ID);
        //Oceans Insides Description Status
        if(s.OI_Status__c  != old_shipment.OI_Status__c)
        {
            //Cambio de estado automático del Shipment con la Información de Oceans Insides
            if(s.Shipment_Status__c == null || s.Shipment_Status__c.equals('Pending - Missing Documents/Instructions') || s.Shipment_Status__c.equals('Pending but Pre-Captured') || s.Shipment_Status__c.equals('Captured but not yet sent EDI')
                || s.Shipment_Status__c.equals('Submitted to Customs') || s.Shipment_Status__c.equals('Cleared but Awaiting Vessel')  || s.Shipment_Status__c.equals('Cleared but Stopped') || s.Shipment_Status__c.equals('Planned for delivery - Not yet on route')
                || s.Shipment_Status__c.equals('Delivery On route') || s.Shipment_Status__c.equals('Delivered'))
            
            {
                if(mapStatusShipment.containsKey(s.OI_Status__c))
                    s.Shipment_Status__c =  mapStatusShipment.get(s.OI_Status__c);
            }
        }
    }*/ 
}