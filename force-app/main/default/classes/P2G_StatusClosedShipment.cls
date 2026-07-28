public class P2G_StatusClosedShipment {
    public static void closeShipment(List<Shipment_Fee_Line__c> newServiceLines, Map<Id, Shipment_Fee_Line__c> oldMap) {
        Set<Id> shipmentIds = getShipmentsToValidate(newServiceLines, oldMap);
        
        if (shipmentIds.isEmpty()) {
            return;
        }
        
        Map<Id, List<Shipment_Fee_Line__c>> serviceLinesMap = getServiceLinesMap(shipmentIds);
        
        List<Shipment__c> shipmentsToUpdate = new List<Shipment__c>();
        
        for (Shipment__c shipment : [SELECT Id, Shipment_Status_Plann__c, Equipment__c FROM Shipment__c WHERE Id IN :shipmentIds]) {
        	if (shipment.Shipment_Status_Plann__c != 'Closed' && (String.isBlank(shipment.Equipment__c) || !shipment.Equipment__c.contains('Closed by BL')) && areAllCampoControlActive(serviceLinesMap.get(shipment.Id))) {
                shipment.Shipment_Status_Plann__c = 'Closed';
                shipment.Equipment__c = String.isBlank(shipment.Equipment__c) ? 'Closed by BL' : shipment.Equipment__c + ' | Closed by BL';
                shipmentsToUpdate.add(shipment);
        	}
    	}
		if (!shipmentsToUpdate.isEmpty()) {
            update shipmentsToUpdate;
    	}
    }
    
    
    private static Set<Id> getShipmentsToValidate(List<Shipment_Fee_Line__c> newServiceLines, Map<Id, Shipment_Fee_Line__c> oldMap) {
        Set<Id> shipmentIds = new Set<Id>();
        
		for (Shipment_Fee_Line__c serviceLine : newServiceLines) {
        	Shipment_Fee_Line__c oldServiceLine = oldMap.get(serviceLine.Id);
            
            Boolean campoControlActivated = oldServiceLine !=null && 
                !oldServiceLine.Campo_Control__c &&
                serviceLine.Campo_Control__c;
            if (serviceLine.Shipment__c != null && campoControlActivated) {
                shipmentIds.add(serviceLine.Shipment__c);
        	}
    	}
        return shipmentIds;
    }
    
    private static Map<Id, List<Shipment_Fee_Line__c>> getServiceLinesMap(Set<Id> shipmentIds) {
        Map<Id, List<Shipment_Fee_Line__c>> serviceLinesMap = new Map<Id, List<Shipment_Fee_Line__c>>();
        
        for (Shipment_Fee_Line__c serviceLine : [SELECT Id, Shipment__c, Campo_Control__c FROM Shipment_Fee_Line__c WHERE Shipment__c IN :shipmentIds]) {
			if (!serviceLinesMap.containsKey(serviceLine.Shipment__c)) {
				serviceLinesMap.put(serviceLine.Shipment__c, new List<Shipment_Fee_Line__c>());
            }
            serviceLinesMap.get(serviceLine.Shipment__c).add(serviceLine);
        }
        return serviceLinesMap;
    }
    
    private static Boolean areAllCampoControlActive(List<Shipment_Fee_Line__c> serviceLines) {
        if (serviceLines == null || serviceLines.isEmpty()) {
            return false;
        }
        for (Shipment_Fee_Line__c serviceLine : serviceLines) {
            if (!serviceLine.Campo_Control__c) {
                return false;
            }
        }
        return true;
    }
}