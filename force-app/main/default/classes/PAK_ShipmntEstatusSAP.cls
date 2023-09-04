public class PAK_ShipmntEstatusSAP {
 @future(callout=true)
    public static void sendEstatusShipment(Map<Id, String> mapShipUser){
        System.debug('PAK_ShipmntEstatusSAP - ids: ' + mapShipUser);
       
        string body = '';
         string body2 = '';
         string body3 = '';
        List<Shipment__c> lstShipments = new List<Shipment__c>();
        try{
            lstShipments = [SELECT Id, Name,Shipment_Status_Plann__c,LastModifiedDate, LastModifiedBy.name FROM Shipment__c WHERE Id IN :mapShipUser.keySet()];
            body ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<tem:insertarEstatusShipmentSF>'+
                '<tem:lstEstatus>';
            for(Shipment__c s : lstShipments){
                body += '<tem:ShipmentEstatusSF>' +
                    '<tem:ShipmentId>' + s.Id + '</tem:ShipmentId>' +
                    '<tem:Shipment>' + s.Name + '</tem:Shipment>' +
                    '<tem:Estatus>' +mapShipUser.get(s.Id)  + '</tem:Estatus>' +
                    '<tem:Fecha>' +s.LastModifiedDate.format('yyyy-MM-dd') + '</tem:Fecha>' +
                    '<tem:Usuario>' + s.LastModifiedBy.name + '</tem:Usuario>' +
                    '<tem:Enviado>0</tem:Enviado>' +
                    '<tem:Respuesta>prueba</tem:Respuesta>' +
                    '</tem:ShipmentEstatusSF>';
                
                
                
            }
            body += '</tem:lstEstatus>' +
                '</tem:insertarEstatusShipmentSF>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
            
            for (Integer i = 0; i < body.length(); i=i+250)
            {
                Integer iEffectiveEnd = (i+250) > body.length() ? body.length()-1 : (i+250);
                    System.debug('LINEA ' +  i + ' - ' + iEffectiveEnd + ' ->' + body.substring(i,iEffectiveEnd));
            }

            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            //http://35.169.18.187/pakws92/WsEstatusShipment.asmx?op=insertarEstatusShipmentSF
            
            if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox)
                request.setEndpoint('http://35.169.18.187/pakws/WsEstatusShipment.asmx'); 
            else
                request.setEndpoint('http://35.169.18.187/pakws92/WsEstatusShipment.asmx');  
            
       
         
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', 'http://tempuri.org/insertarEstatusShipmentSF');
            request.setBody(body);
            HttpResponse response = httpProtocol.send(request);
            
            System.debug('Response: sap ');
            for (Integer i = 0; i < response.getBody().length(); i=i+250)
            {
                Integer iEffectiveEnd = (i+250) > response.getBody().length() ? response.getBody().length()-1 : (i+250);
                    System.debug('LINEA ' +  i + ' - ' + iEffectiveEnd + ' ->' + response.getBody().substring(i,iEffectiveEnd));
            }
            
            
            if(response.getStatusCode() == 200){
                // OK - Enviar response si hay error en alguno
                System.debug('PAK_ShipmntEstatusSAP: OK ' + response.getStatusCode());
            }else{
                //Error
                System.debug('error: sap ');  
                System.debug(response.getStatusCode() + 'PAK_ShipmntEstatusSAP: Ocurrio un error porfavor de comunicarse con el administrador del sistema');
            } 
        }catch(Exception e){
            System.debug('PAK_ShipmntEstatusSAP: Error: ' + e.getLineNumber()+'------------'+e.getMessage() + '------' + e.getStackTraceString());
        }
    }
    
   @future(callout=true)
    public static void sendEstatusShipmentEstatusOp(Map<Id, String> mapShipUser){
        System.debug('PAK_ShipmntEstatusSAP - ids: ' + mapShipUser);
       
        string body = '';
         string body2 = '';
         string body3 = '';
        List<Shipment__c> lstShipments = new List<Shipment__c>();
        try{
            lstShipments = [SELECT Id, Name,Estatus_de_operacion__c,LastModifiedDate, LastModifiedBy.name FROM Shipment__c WHERE Id IN :mapShipUser.keySet()];
            body ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<tem:insertarShipmentEstatusFalla>'+
                '<tem:lstEstatus>';
            for(Shipment__c s : lstShipments){
                body += '<tem:ShipmentEstatusFalla>' +
                    '<tem:ShipmentId>' + s.Id + '</tem:ShipmentId>' +
                    '<tem:Shipment>' + s.Name + '</tem:Shipment>' +
                    '<tem:Estatus>' +mapShipUser.get(s.Id)  + '</tem:Estatus>' +
                    '<tem:Fecha>' +s.LastModifiedDate.format('yyyy-MM-dd') + '</tem:Fecha>' +
                    '<tem:Usuario>' +  s.LastModifiedBy.name + '</tem:Usuario>' +
                    '<tem:Enviado>0</tem:Enviado>' +
                    '<tem:Respuesta>prueba</tem:Respuesta>' +
                    '</tem:ShipmentEstatusFalla>';
                
                
                
            }
            body += '</tem:lstEstatus>' +
                '</tem:insertarShipmentEstatusFalla>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
            
            for (Integer i = 0; i < body.length(); i=i+250)
            {
                Integer iEffectiveEnd = (i+250) > body.length() ? body.length()-1 : (i+250);
                    System.debug('LINEA ' +  i + ' - ' + iEffectiveEnd + ' ->' + body.substring(i,iEffectiveEnd));
            }

            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            //http://35.169.18.187/pakws92/WsEstatusShipment.asmx?op=insertarEstatusShipmentSF
           
            if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox)
                request.setEndpoint('http://35.169.18.187/pakws/WsEstatusShipment.asmx'); 
            else
                request.setEndpoint('http://35.169.18.187/pakws92/WsEstatusShipment.asmx');  
            
       
         
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', 'http://tempuri.org/insertarShipmentEstatusFalla');
            request.setBody(body);
            HttpResponse response = httpProtocol.send(request);
            
            System.debug('Response: sap ');
            for (Integer i = 0; i < response.getBody().length(); i=i+250)
            {
                Integer iEffectiveEnd = (i+250) > response.getBody().length() ? response.getBody().length()-1 : (i+250);
                    System.debug('LINEA ' +  i + ' - ' + iEffectiveEnd + ' ->' + response.getBody().substring(i,iEffectiveEnd));
            }
            
            
            if(response.getStatusCode() == 200){
                // OK - Enviar response si hay error en alguno
                System.debug('PAK_ShipmntEstatusFALLA: OK ' + response.getStatusCode());
            }else{
                //Error
                System.debug('error: sap ');  
                System.debug(response.getStatusCode() + 'PAK_ShipmntEstatusFALLA: Ocurrio un error porfavor de comunicarse con el administrador del sistema');
            } 
        }catch(Exception e){
            System.debug('PAK_ShipmntEstatusFALLA: Error: ' + e.getLineNumber()+'------------'+e.getMessage() + '------' + e.getStackTraceString());
        }
    }
}