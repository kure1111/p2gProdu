public class P2G_InvoiceHandlerService {

    public Invoice__c getInvoice(String invoiceId) {
        if (String.isBlank(invoiceId)) return null;

        return [
            SELECT Id, Invoice_Status__c, Shipment__c, Timbrado_Factura_SAP__c 
            FROM Invoice__c 
            WHERE Id = :invoiceId
            LIMIT 1
        ];
    }

    public Set<String> getShipmentServiceLineByInvoiceId(String invoiceId) {
        Set<String> ids = new Set<String>();
        if (String.isBlank(invoiceId)) return ids;

        for (Invoice_Line__c line : [
            SELECT Shipment_Service_Line__c 
            FROM Invoice_Line__c 
            WHERE Invoice__c = :invoiceId
        ]) {
            if (line.Shipment_Service_Line__c != null) ids.add(line.Shipment_Service_Line__c);
        }
        return ids;
    }

    public Boolean updateInvoice(Invoice__c invoice, P2G_CancelacionInvoiceController.DataFactura datosFactura) {
        if(invoice != null){
            invoice.Invoice_Status__c = 'Cancel';
        	update invoice;
            return true;
        }
        /*if (invoice != null || (datosFactura.UUID == invoice.Timbrado_Factura_SAP__c)){
        	invoice.Invoice_Status__c = datosFactura.statusFactura;
        	update invoice;    
        } */        
        return false;
    }

    public void updateShipmentServiceLine(Set<String> ids) {
        if (ids == null || ids.isEmpty()) return;

        List<Shipment_Fee_Line__c> lines = [
            SELECT Id, Campo_Control__c 
            FROM Shipment_Fee_Line__c 
            WHERE Id IN :ids
        ];

        for (Shipment_Fee_Line__c line : lines) {
            line.Campo_Control__c = false;
        }
        update lines;
    }
}