public class P2G_creacionFolioWs{
    @Future(callout=true)
    public static Void callSerCon(String id) {
        //P2G_llamadoWebHelper.setWebServiceUpdate(true);
        List<Response__c> listaErrores = new List<Response__c>();
        String listaJson = P2G_CargaEmbarques.mapeoCargaEmbarque(id);
        String error;
        String body = listaJson;
        String tokenRC = P2G_globalVariable.getToken();
        if(body.contains('type_operation')){
            error = callWebService(tokenRC,body);//af6fd656-83d8-6f07-2ab4-c00f244a8139
        }else{
            error = body;
        }
        if(error!=null){           
            listaErrores.add(createSapResponse('ERROR',error,Id));
            updateStatus(id, 'error');           
        }else{
            listaErrores.add(createSapResponse('CONFIRM','Carga correcta en recurso confiable',Id));
            updateStatus(id, 'success');
        }
        insert listaErrores;
    }
    public static String callWebService(String token,String body) {
        if(Test.isRunningTest()){
            token='token';
            body='{"Error":"Error"}';       
        }
        String body2 = 'token=' + EncodingUtil.urlEncode(token, 'UTF-8') + '&parameters=' + EncodingUtil.urlEncode(body, 'UTF-8');
        String ErrorType;
        String endpoint = 'https://app.rcontrol.com.mx/Japi/load_appointments_rest_service';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setBody(body2);
        HttpResponse response = http.send(request);
        String responseBody;
        if (response.getStatusCode() == 200) {       
            responseBody = '{"details":'+ response.getBody()+'}';
            System.debug('response Body: '+responseBody);
            if(responseBody.contains('appointment_load_detail_id')){
                P2G_WS_EmbarquesWrapper.response aux = (P2G_WS_EmbarquesWrapper.response)JSON.deserialize(responseBody, P2G_WS_EmbarquesWrapper.response.class);
                if(aux.details[0].status!='SUCCESSFUL'){
                    System.debug('Errooooor: '+  response.getBody());
                    ErrorType = aux.details[0].error_message;
                }
            }
            else{
                ErrorType = 'Autentificación incorrecta (Usuario, Contraseña o Token)."';
            }
        } else {
            System.debug('Error: '+response.getBody());
            ErrorType ='Error: '+ response.getStatusCode();
        }
        return ErrorType;
    }
    
    /*public static void callUpdateShipmentService(String shipmentId, String token,String status) {
        String endpoint = 'https://pak2gologistics--uat.sandbox.my.salesforce.com/services/apexrest/updateShipmnet';
        String requestBody = '{"idShip":"' + shipmentId +'","status":"'+status +'"}';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setBody(requestBody);
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('Error calling Update Shipment Service: ' + response.getBody());
        }
    }*/
    public static void updateStatus(String idShip, String status){
        String message;
        try{
            Shipment__c ship = [SELECT Shipment_Status_Mon__c FROM Shipment__c WHERE id=:idShip];
            if(status=='success'){     
                ship.Shipment_Status_Mon__c= 'Loading_M';//  In Progress_M
            }
            else{
                ship.Shipment_Status_Plann__c='In Progress';
                ship.Shipment_Status_Mon__c= 'Error en Monitoreo_M';
            }
            //update ship; ya no cambiamos status lo hara Contrl room
        }
        catch(Exception e){
            message = e.getMessage()+ ' '+e.getLineNumber();
        }
    }
    public static Response__c createSapResponse(String msg,String error, String id){
        Response__c sapR = new Response__c();
            sapR.Object__c = 'Shipment';
            sapR.Type__c = msg;
            sapR.Message__c =error;
            sapR.Shipment__c = id;
            return sapR;
    }
}