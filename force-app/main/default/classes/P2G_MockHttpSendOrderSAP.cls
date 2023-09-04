@isTest
global class P2G_MockHttpSendOrderSAP implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request){
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'text/xml');
        String x = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Header/><soapenv:Body><tem:CreateInvoice><tem:datos><tem:Invoice><tem:currency>MXN</tem:currency><tem:WPAccOwner>GDL-Road-NATIONAL</tem:WPAccOwner><tem:CfdiNumber></tem:CfdiNumber><tem:DateReceiveSap>2023-02-14 18:06:31</tem:DateReceiveSap><tem:Fecha>14/02/2023</tem:Fecha><tem:IdInvoice>a1UDV0000028FN52AM</tem:IdInvoice><tem:CardCode>null</tem:CardCode><tem:Monto>0.00</tem:Monto><tem:InvoiceNumber>INV-23-000011</tem:InvoiceNumber><tem:Shipment>SP-FN-22-000149</tem:Shipment><tem:Enviado></tem:Enviado><tem:Respuesta></tem:Respuesta><tem:DetalleInvoice></tem:DetalleInvoice><tem:FolioFacturar>null</tem:FolioFacturar><tem:MBLNumber>null</tem:MBLNumber><tem:MAWBNumber>null</tem:MAWBNumber><tem:Json></tem:Json></tem:Invoice></tem:datos><tem:nombreUsuario>Alberto García</tem:nombreUsuario></tem:CreateInvoice></soapenv:Body></soapenv:Envelope>';
        response.setBody(x);
        response.setStatusCode(200);
        return response;  
    }

}