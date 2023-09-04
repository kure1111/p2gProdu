public class PAK_ShipmntEstMonWs {
    @future(callout=true)
    public static void estatusShipmentMon(Map<Id, String> mapShipUser){
        System.debug('PAK_ShipmntEstMonWs - ids: ' + mapShipUser);
        string body = '';
        List<Shipment__c> lstShipments = new List<Shipment__c>();
        try{
            lstShipments = [SELECT Id, Name, LastModifiedBy.name FROM Shipment__c WHERE Id IN :mapShipUser.keySet()];
            body ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<tem:insertarEstatusShipment>'+
                '<tem:lstEstatus>';
            for(Shipment__c s : lstShipments){
                body += '<tem:ShipmentEstatus>' +
                    '<tem:ShipmentId>' + s.Id + '</tem:ShipmentId>' +
                    '<tem:Shipment>' + s.Name + '</tem:Shipment>' +
                    '<tem:Estatus>Finished</tem:Estatus>' +
                    '<tem:Usuario>' + s.LastModifiedBy.name + '</tem:Usuario>' +
                    '</tem:ShipmentEstatus>';
            }
            body += '</tem:lstEstatus>' +
                '</tem:insertarEstatusShipment>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://35.169.18.187/pakws92/WsEstatusShipment.asmx');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', 'http://tempuri.org/insertarEstatusShipment');
            request.setBody(body);
            HttpResponse response = httpProtocol.send(request);
            System.debug('Response: '+response.getBody());
            System.debug('Request Body: '+body);
            if(response.getStatusCode() == 200){
                // OK - Enviar response si hay error en alguno
                System.debug('PAK_ShipmntEstMonWs: OK');
            }else{
                //Error
                System.debug('PAK_ShipmntEstMonWs: Ocurrio un error porfavor de comunicarse con el administrador del sistema');
            } 
        }catch(Exception e){
            System.debug('PAK_ShipmntEstMonWs: Error: ' + e.getLineNumber()+'------------'+e.getMessage() + '------' + e.getStackTraceString());
        }
    }
}