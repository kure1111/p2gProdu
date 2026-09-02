trigger Cifid_Shipment on Shipment__c (after insert, after update) {
    /*if(NEU_StaticVariableHelper.getBoolean1())
    return;
    System.debug('CIFID_TRIGGER Shipment ***');
    Set<Id> idsShipment;
    List<Customer_Quote__c> lstQuotes;
    Set<Id> idsQuotes;
    if(Trigger.isInsert){         
        System.debug('CIFID_TRIGGER Shipment *** INSERT');
        idsShipment = new Set<Id>();
        for(Shipment__c s : Trigger.New){
            if(!idsShipment.contains(s.Id)){
                idsShipment.add(s.Id);
            }            
        }
        lstQuotes = [SELECT Id FROM Customer_Quote__c WHERE Impak_Request__c = true AND Last_Shipment__c IN:idsShipment];        
        
        System.debug('CIFID_TRIGGER Shipment ids **** ' + lstQuotes);
        if(lstQuotes.size()>0 && Cifid_SendUpdateShipment.firstRun){  
            idsQuotes = (new Map<Id, Customer_Quote__c>(lstQuotes)).keySet();
            Cifid_SendUpdateShipment.firstRun = false;
            Cifid_SendUpdateShipment.send(idsQuotes);
        }
    }
    if(Trigger.isUpdate){
        System.debug('CIFID_TRIGGER Shipment *** UPDATE');
        idsShipment = new Set<Id>();
        for(Shipment__c s : Trigger.New){
            if(!idsShipment.contains(s.Id) &&
               (Trigger.oldMap.get(s.Id).Shipment_Status_Plann__c != s.Shipment_Status_Plann__c || Trigger.oldMap.get(s.Id).Shipment_Status_Mon__c != s.Shipment_Status_Mon__c ||
               Trigger.oldMap.get(s.Id).Shipment_Status__c != s.Shipment_Status__c || Trigger.oldMap.get(s.Id).Ocean_Shipment_Status__c != s.Ocean_Shipment_Status__c ||
               Trigger.oldMap.get(s.Id).Air_Shipment_Status__c != s.Air_Shipment_Status__c || Trigger.oldMap.get(s.Id).Shipment_Currency__c != s.Shipment_Currency__c ||
               Trigger.oldMap.get(s.Id).Operation_Executive__c != s.Operation_Executive__c || Trigger.oldMap.get(s.Id).Carrier__c != s.Carrier__c ||
               Trigger.oldMap.get(s.Id).ATD__c != s.ATD__c || Trigger.oldMap.get(s.Id).ATA__c != s.ATA__c || Trigger.oldMap.get(s.Id).MAWB_Number__c != s.MAWB_Number__c || 
               Trigger.oldMap.get(s.Id).Air_Booking_Number__c != s.Air_Booking_Number__c || Trigger.oldMap.get(s.Id).Flight_Number__c != s.Flight_Number__c ||
               Trigger.oldMap.get(s.Id).Total_Services_Std_Buy_Amount_number__c != s.Total_Services_Std_Buy_Amount_number__c || Trigger.oldMap.get(s.Id).Sea_Container_Number__c != s.Sea_Container_Number__c ||
               Trigger.oldMap.get(s.Id).HBL_Number__c != s.HBL_Number__c || Trigger.oldMap.get(s.Id).Sea_Booking_Number__c != s.Sea_Booking_Number__c ||
               Trigger.oldMap.get(s.Id).Free_Days__c != s.Free_Days__c || Trigger.oldMap.get(s.Id).Booking_Confirmation__c != s.Booking_Confirmation__c ||
               Trigger.oldMap.get(s.Id).Truck_Vessel_Flight__c != s.Truck_Vessel_Flight__c || Trigger.oldMap.get(s.Id).Vessel_Latitude_Vessel__c != s.Vessel_Latitude_Vessel__c ||
               Trigger.oldMap.get(s.Id).Vessel_Longitude_Vessel__c != s.Vessel_Longitude_Vessel__c || Trigger.oldMap.get(s.Id).Last_Update_Vessel__c != s.Last_Update_Vessel__c)){
                   idsShipment.add(s.Id);
               }            
        }
        lstQuotes = [SELECT Id FROM Customer_Quote__c WHERE Impak_Request__c = true AND Last_Shipment__c IN:idsShipment];  
        
        System.debug('CIFID_TRIGGER Shipment ids **** ' + lstQuotes);
        if(lstQuotes.size()>0 && Cifid_SendUpdateShipment.firstRun){  
            idsQuotes = (new Map<Id, Customer_Quote__c>(lstQuotes)).keySet();
            Cifid_SendUpdateShipment.firstRun = false;
            Cifid_SendUpdateShipment.send(idsQuotes);
        }
    }*/
}