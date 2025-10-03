trigger P2G_UpdateDatePricing on Customer_Quote__c (before insert, before update) {
    for (Customer_Quote__c cq : Trigger.new) {
        // Obtener el estado anterior para verificar cambios en un update
        Customer_Quote__c oldCq = Trigger.oldMap != null ? Trigger.oldMap.get(cq.Id) : null;

        // Regla 1: Actualizar Date_Pricing_Responded__c
        if (cq.Quotation_Status__c == 'Sent awaiting response' &&
            (cq.Freight_Mode__c == 'Sea' || cq.Freight_Mode__c == 'Multimodal')) {
            
            // Verificar si el registro antes no cumplía la condición
            if (Trigger.isInsert || (oldCq != null && 
                (oldCq.Quotation_Status__c != 'Sent awaiting response' || 
                (oldCq.Freight_Mode__c != 'Sea' && oldCq.Freight_Mode__c != 'Multimodal')))) {
                
                // Actualizar la fecha
                cq.Date_Pricing_Responded__c = System.now();
            }
        }

        // Regla 2: Actualizar Date_Send_Request__c
        if (cq.Quotation_Status__c == 'Awaiting costs suppliers' &&
            (cq.Freight_Mode__c == 'Sea' || cq.Freight_Mode__c == 'Multimodal')) {
            
            // Verificar si el registro antes no cumplía la condición
            if (Trigger.isInsert || (oldCq != null && 
                (oldCq.Quotation_Status__c != 'Awaiting costs suppliers' || 
                (oldCq.Freight_Mode__c != 'Sea' && oldCq.Freight_Mode__c != 'Multimodal')))) {
                
                // Actualizar la fecha
                cq.Date_Send_Request__c = System.now();
            }
        }
    }
}