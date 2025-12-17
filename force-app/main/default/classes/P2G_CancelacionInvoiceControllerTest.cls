@isTest(seeAllData=true)
public class P2G_CancelacionInvoiceControllerTest {
    
    @isTest
    static void testCancelInvoiceSuccess() {
        List<Invoice_Line__c> existingInvoiceLines = [
        SELECT Id, Invoice__c, Shipment_Service_Line__c 
        FROM Invoice_Line__c 
        WHERE Invoice__c != null AND Shipment_Service_Line__c != null        
        LIMIT 1
    ];
        
        if (!existingInvoiceLines.isEmpty()) {
            String invoiceId = existingInvoiceLines[0].Invoice__c;
            
            String requestBody = '{' +
                '"invoiceId": "' + invoiceId + '",' +
                '"datosFactura": {' +
                '"statusFactura": "Cancel",' +
                '"UUID": "test-uuid-123"' +
                '}' +
                '}';
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestBody = Blob.valueOf(requestBody);
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            
            Test.startTest();
            String result = P2G_CancelacionInvoiceController.cancelInvoice();
            Test.stopTest();
        }
    }
    
    @isTest
    static void testCancelInvoiceWithInvoiceOnly() {
        List<Invoice__c> existingInvoices = [
        SELECT Id, Timbrado_Factura_SAP__c
        FROM Invoice__c 
        WHERE Timbrado_Factura_SAP__c != null 
        AND Account__r.Credit_Terms__c!=NULL
        LIMIT 1
    ];
        
        if (!existingInvoices.isEmpty()) {
            String requestBody = '{' +
                '"invoiceId": "' + existingInvoices[0].Id + '",' +
                '"datosFactura": {' +
                '"statusFactura": "Cancel",' +
                '"UUID": "' + existingInvoices[0].Timbrado_Factura_SAP__c + '"' +
                '}' +
                '}';
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestBody = Blob.valueOf(requestBody);
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            
            Test.startTest();
            String result = P2G_CancelacionInvoiceController.cancelInvoice();
            Test.stopTest();
        }
    }
    
    @isTest
    static void testCancelInvoiceWithLinesOnly() {
        List<Invoice_Line__c> existingInvoiceLines = [
        SELECT Id, Shipment_Service_Line__c 
        FROM Invoice_Line__c 
        WHERE Shipment_Service_Line__c != null 
        LIMIT 2
    ];
        
        if (!existingInvoiceLines.isEmpty()) {
            List<String> lineIds = new List<String>();
            for(Invoice_Line__c line : existingInvoiceLines) {
                lineIds.add(line.Shipment_Service_Line__c);
            }
            
            String requestBody = '{' +
                '"lineasIds": ' + JSON.serialize(lineIds) +
                '}';
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestBody = Blob.valueOf(requestBody);
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            
            Test.startTest();
            String result = P2G_CancelacionInvoiceController.cancelInvoice();
            Test.stopTest();
        }
    }
    
    @isTest
    static void testCancelInvoiceEmptyJSON() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('');
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String result = P2G_CancelacionInvoiceController.cancelInvoice();
        Test.stopTest();
    }
    
    @isTest
    static void testCancelInvoiceMissingFields() {
        String requestBody = '{' +
            '"invoiceId": "",' +
            '"lineasIds": []' +
            '}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(requestBody);
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String result = P2G_CancelacionInvoiceController.cancelInvoice();
        Test.stopTest();
    }
    
    @isTest
    static void testCancelInvoiceException() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{invalid json}');
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        String result = P2G_CancelacionInvoiceController.cancelInvoice();
        Test.stopTest();
    }
    
    @isTest
    static void testServiceMethods() {
        List<Invoice_Line__c> existingInvoiceLine= [SELECT Id, Invoice__c,Shipment__c FROM Invoice_Line__c 
        WHERE Invoice__c !=NULL AND Shipment__c !=NULL 
        AND Invoice__r.Account__r.Credit_Terms__c!=NULL LIMIT 1];
        List<Invoice__c> existingInvoices = [SELECT Id FROM Invoice__c WHERE Id=: existingInvoiceLine[0].Invoice__c LIMIT 1];
        
        List<Shipment_Fee_Line__c> existingShipmentLines = [SELECT Id, Shipment__c FROM Shipment_Fee_Line__c WHERE Shipment__c=:existingInvoiceLine[0].Shipment__c LIMIT 1];
        
        if (!existingInvoices.isEmpty() && !existingShipmentLines.isEmpty()) {
            P2G_InvoiceHandlerService service = new P2G_InvoiceHandlerService();
            
            Test.startTest();
            Invoice__c invoice = service.getInvoice(existingInvoices[0].Id);
            
            Set<String> shipmentServiceLineIds = service.getShipmentServiceLineByInvoiceId(existingInvoices[0].Id);
            
            P2G_CancelacionInvoiceController.DataFactura datosFactura = new P2G_CancelacionInvoiceController.DataFactura();
            datosFactura.statusFactura = 'Cancel';
            datosFactura.UUID = 'test-uuid';
            
            service.updateInvoice(invoice, datosFactura);
            //service.updateShipmentServiceLine(shipmentServiceLineIds);
            Test.stopTest();
        }
    }
    
    @isTest
    static void testUpdateInvoiceWithMatchingUUID() {
        List<Invoice__c> existingInvoices = [
        SELECT Id, Timbrado_Factura_SAP__c 
        FROM Invoice__c 
        WHERE Timbrado_Factura_SAP__c != null
        AND Account__r.Credit_Terms__c!=NULL
        LIMIT 1
    ];
        
        if (!existingInvoices.isEmpty()) {
            P2G_InvoiceHandlerService service = new P2G_InvoiceHandlerService();
            
            P2G_CancelacionInvoiceController.DataFactura datosFactura = new P2G_CancelacionInvoiceController.DataFactura();
            datosFactura.statusFactura = 'Cancelada';
            datosFactura.UUID = existingInvoices[0].Timbrado_Factura_SAP__c;
            
            Test.startTest();
            Boolean result = service.updateInvoice(existingInvoices[0], datosFactura);
            Test.stopTest();
        }
    }
    
    @isTest
    static void testUpdateInvoiceWithNonMatchingUUID() {
        List<Invoice_Line__c> existingInvoiceLine= [SELECT Id, Invoice__c,Shipment__c FROM Invoice_Line__c 
        WHERE Invoice__c !=NULL AND Shipment__c !=NULL 
        AND Invoice__r.Account__r.Credit_Terms__c!=NULL LIMIT 1];
        List<Invoice__c> existingInvoices = [SELECT Id FROM Invoice__c 
        WHERE Id=: existingInvoiceLine[0].Invoice__c LIMIT 1];
        
        if (!existingInvoices.isEmpty()) {
            P2G_InvoiceHandlerService service = new P2G_InvoiceHandlerService();
            
            P2G_CancelacionInvoiceController.DataFactura datosFactura = new P2G_CancelacionInvoiceController.DataFactura();
            datosFactura.statusFactura = 'Cancel';
            datosFactura.UUID = 'non-matching-uuid';
            
            Test.startTest();
            Boolean result = service.updateInvoice(existingInvoices[0], datosFactura);
            Test.stopTest();
        }
    }
    
    
}