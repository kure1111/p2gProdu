public class PAK_AttachmentSHIP {
    public ApexPages.StandardController C {get;set;}
    public Shipment__c SHIP {get;set;}
    
    public PAK_AttachmentSHIP(ApexPages.StandardController controller){
            C = controller;
            SHIP =(Shipment__c) controller.getRecord(); 
    }
    
    public PageReference SendWS(){
        try{
            Boolean hasFiles = false;
            for(Associated_Document__c ad : [Select Id, Name, Document_URL__c, Document_Type__c, Shipment__r.Name FROM Associated_Document__c WHERE Shipment__c =:SHIP.Id AND Document_Type__c = 'Acuse' AND Document_URL__c LIKE '%https://associateddocs.s3.amazonaws.com%']){
                hasFiles = true;
                String attachName = ad.Name;
                System.debug('ShipId: ' + SHIP.Id);
                System.debug('AttachName: ' + attachName);
                System.debug('URL: ' + ad.Document_URL__c);
                System.debug('TypeDocument: ' + ad.Document_Type__c);
                String Body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                                       '<soapenv:Header/>'+
                                       '<soapenv:Body>'+
                                          '<tem:GuardarDocAWS>'+
                                             '<tem:doc_aws>'+
                                                //'<tem:customerId>'+ACC.Id+'</tem:customerId>'+
                                                '<tem:attachmentName>'+attachName+'</tem:attachmentName>'+
                    							'<tem:url>'+ad.Document_URL__c+'</tem:url>'+
                    							'<tem:TypeDocument>'+ad.Document_Type__c+'</tem:TypeDocument>'+
                                                //'<tem:attachment>'+documentoImagenBase64+'</tem:attachment>'+
                        						'<tem:shipmentId>'+SHIP.Id+'</tem:shipmentId>'+
                        						'<tem:shipmentNumber>'+ ad.Shipment__r.Name +'</tem:shipmentNumber>'+
                                             '</tem:doc_aws>'+
                        					 '<tem:nombreUsuario>'+UserInfo.getName()+'</tem:nombreUsuario>'+
                                          '</tem:GuardarDocAWS>'+
                                       '</soapenv:Body>'+
                                    '</soapenv:Envelope>';
                    
                    Http httpProtocol = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint('http://35.169.18.187/pakws92/WSDocsAWS.asmx');
                    request.setMethod('POST');
                    request.setTimeout(60000); 
                    request.setHeader('Content-Type', 'text/xml;charset=utf-8');
                    request.setHeader('SOAPAction', 'http://tempuri.org/GuardarDocAWS');
                    request.setBody(Body);
                    HttpResponse response = httpProtocol.send(request);

                    System.debug('-----------'+response.getBody());
                    System.debug('-------------------'+Body);
                    if(response.getStatusCode() == 200){
                        System.debug('Exito----- se envio correctamente'); 
                    }else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,response.getBody());
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
            }
            if(hasFiles){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Se envió correctamente. Verificar respuesta de SAP en el área de Responses.');
            	ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No se encontraron documentos para enviar');
                ApexPages.addMessage(myMsg);
            }
            //ServiceLogger.log('PAK_AttachmentSHIP');           
            return null;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);            
            return null;
        }
    }

}