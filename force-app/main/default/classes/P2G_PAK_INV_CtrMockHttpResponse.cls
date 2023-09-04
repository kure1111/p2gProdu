@isTest
global class P2G_PAK_INV_CtrMockHttpResponse implements HttpCalloutMock{
    Integer opc;
    global P2G_PAK_INV_CtrMockHttpResponse(Integer opcr){
        opc = opcr;
    }
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(opc == 1){  
            response.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', 'http://tempuri.org/CreateInvoice');
    		response.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="http://tempuri.org/"><CreateInvoiceResponse>Creada Factura:43467C01-F0B9-447A-937B-11F928C1A672<CreateInvoiceResult>Monto Facturado: 2376.00</CreateInvoiceResult> </CreateInvoiceResponse>Invoice Status BU: Send to Sap, Invoice Status AU: Facturado</login></Body></Envelope>');
    		response.setStatusCode(200);         
        }
        
        return response;
    }    
}