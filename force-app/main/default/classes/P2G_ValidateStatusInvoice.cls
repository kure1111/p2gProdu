public class P2G_ValidateStatusInvoice {
    
    public static void validateInvoiceCreation(List<Invoice__c> newInvoices) {        
        Set<Id> shipmentIds = new Set<Id>();
        
        for(Invoice__c inv : newInvoices) {
            if(inv.Shipment__c != null) {
                shipmentIds.add(inv.Shipment__c);
            }
        }
        
        if(!shipmentIds.isEmpty()) {
           
            Map<Id, Shipment__c> shipmentsWithInvoices = new Map<Id, Shipment__c>([
                SELECT Id, Name, 
                       (SELECT Id, Campo_Control__c FROM Invoices__r WHERE Campo_Control__c = false) 
                FROM Shipment__c 
                WHERE Id IN :shipmentIds
            ]);
                        
            for(Invoice__c inv : newInvoices) {
                if(inv.Shipment__c != null) {
                    Shipment__c relatedShipment = shipmentsWithInvoices.get(inv.Shipment__c);
                    
                    if(relatedShipment != null && !relatedShipment.Invoices__r.isEmpty()) {                        
                        inv.addError('No se puede crear la Invoice. El Shipment ' + 
                                   relatedShipment.Name + 
                                   ' ya tiene una Invoice Activa.');
                    }
                }
            }
        }
    }
}