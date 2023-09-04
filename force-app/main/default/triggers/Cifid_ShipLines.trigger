trigger Cifid_ShipLines on Shipment_Fee_Line__c (after insert, after update, after delete) {
    /*if(NEU_StaticVariableHelper.getBoolean1())
    return;
    System.debug('Cifid_ShipLines ***');
    Map<Id, Id> mapShipLineShip = new Map<Id, Id>();
    Set<Id> shipmentIds = new Set<Id>();
    Set<Id> linesIds = new Set<Id>();
    
    for(Shipment_Fee_Line__c sl : Trigger.isDelete ? Trigger.Old : Trigger.New){
        if(!mapShipLineShip.containsKey(sl.Id)){
            mapShipLineShip.put(sl.Id, sl.Shipment__c);                
        }
    }
    System.debug('Cifid_ShipLines mapShipLineShip: ***' + mapShipLineShip);
    
    for(Customer_Quote__c quote : [SELECT Id, Last_Shipment__c FROM Customer_Quote__c WHERE Impak_Request__c = true AND Last_Shipment__c IN:mapShipLineShip.values()]){
        if(!shipmentIds.contains(quote.Last_Shipment__c)){
            shipmentIds.add(quote.Last_Shipment__c);
        }
    }
    System.debug('Cifid_ShipLines shipmentIds: ***' + shipmentIds);
    for(Id line : mapShipLineShip.keySet()){
        String ship = mapShipLineShip.get(line);
        for(Id s : shipmentIds){
            if(ship == s && !linesIds.contains(line)){
                linesIds.add(line);
            }
        }            
    }
    System.debug('Cifid_ShipLines linesIds: ***' + linesIds);
    
    if(Trigger.isInsert){
        if(linesIds.size()>0 && Cifid_SendShipLines.firstRun){  
            Cifid_SendShipLines.firstRun = false;
            Cifid_SendShipLines.send(linesIds, 1);
        }
    }    
    if(Trigger.isUpdate){
        if(linesIds.size()>0 && Cifid_SendShipLines.firstRun){  
            Cifid_SendShipLines.firstRun = false;
            Cifid_SendShipLines.send(linesIds, 2);
        }
    }    
    if(Trigger.isDelete){
        if(linesIds.size()>0 && Cifid_SendShipLines.firstRun){  
            Cifid_SendShipLines.firstRun = false;
            Cifid_SendShipLines.send(linesIds, 3);
        }
    }*/
}