trigger ValidateDelete on Shipment_Fee_Line__c (before delete) {
    
    for(Shipment_Fee_Line__c sfl : Trigger.old){
        
        shipment__C sh = [Select id, name, Shipment_Status_Plann__c from shipment__c where id =: sfl.Shipment__c limit 1];
        
        if(  SFl.SAP__c || sfl.Record_Locked__c || sh.Shipment_Status_Plann__c == 'Closed' || sh.Shipment_Status_Plann__c == 'False')
            sfl.addError('No se puede eliminar la línea si ya ha sido enviada a SAP');

    }
}