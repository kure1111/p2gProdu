public class P2G_MonitoreoShipment {
    //@future(callout=true)
    public static void start(){
        getSearch();
    }
    public static void getSearch(){
        try{
        List<Shipment__c> shipment = [SELECT Id, Name, Shipment_Status_Plann__c, Shipment_Status_Mon__c FROM Shipment__c
            						  WHERE Shipment_Status_Plann__c =: 'Confirmed' AND (Shipment_Status_Mon__c =: 'Delivery on Route_M'
                                      OR Shipment_Status_Mon__c =: 'Loading_M') AND Name like: 'SP-FN-%'];
        P2G_MonitoreoShipmentBatchable batcha = new P2G_MonitoreoShipmentBatchable(shipment);
        String ship = Database.executeBatch(batcha, 20);
        
        }catch(Exception e){
            System.debug('Error en el Batchable P2G_MonitoreoShipment'+e.getLineNumber());
        }
    }
    public static String callWebService(String token,String body, String id_SP) {
        String ErrorType;
        String mensaje;
        String body2 = 'token=' + EncodingUtil.urlEncode(token, 'UTF-8') + '&parameters=' + EncodingUtil.urlEncode(body, 'UTF-8');
        String endpoint = 'https://www.rcontrol.com.mx/japi/get_full_travel_info';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setBody(body2);
        System.debug('body2 '+body2);
        	HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                System.debug('getBody'+response.getBody());
                if(response.getBody().contains('source')){
                    String getbody = response.getBody().removeStart('[');
                    String getbody2 = getbody.removeEnd(']');
                    String bodyModificado = getbody2.replace('date','dat');
                    System.debug('La mosific:) '+ bodyModificado);
                   P2G_WS_EmbarquesWrapper.respuestaSearch res = (P2G_WS_EmbarquesWrapper.respuestaSearch)JSON.deserialize(bodyModificado, P2G_WS_EmbarquesWrapper.respuestaSearch.class);
                    mensaje = res.destiny[0].semaphore;
                    if(mensaje == null){
						mensaje = 'Error indefinido en "semaphore"';
                    }
                }else if(response.getBody().contains('error')){
                   P2G_WS_EmbarquesWrapper.error res = (P2G_WS_EmbarquesWrapper.error)JSON.deserialize(response.getBody(), P2G_WS_EmbarquesWrapper.error.class);
                   System.debug('res es: '+ res.error.message);
                   mensaje = res.error.message;
                }else{
                    API_send_SP_to_PakControl.send(id_SP);
                	mensaje = 'El Shipment no tiene una carga asignada';
                }
                    return mensaje;
                    
            }else {
                System.debug('Error: '+response.getStatus());
                System.debug('Error: '+response.getStatusCode());
                System.debug('Error: '+response.getBody());
                ErrorType ='Error: '+ response.getStatusCode();
            }
            return ErrorType;
    }
    public static Response__c creaSAPResponse(String Id, String message){
        Response__c sapR = new Response__c();
        if(message == 'Con llegada a origen' || message == 'Con llegada a destino' || message == 'Cita planeada' || message == 'En tránsito'){
            sapR.Object__c = 'Shipment';
            sapR.Type__c = 'CONFIRM';
            sapR.Message__c = message;
            sapR.Shipment__c = Id;
        }else{
            sapR.Object__c = 'Shipment';
            sapR.Type__c = 'ERROR';
            sapR.Message__c = message;
            sapR.Shipment__c = Id;
        }
        return sapR;
    }
    public static Shipment__c updateShipment(String Id, String message){
        Shipment__c ship = new Shipment__c();
        System.debug('mensaje '+message);
            if(message == 'Con llegada a origen'){
                ship.Shipment_Status_Mon__c = 'Delivery on Route_M';
                ship.Id = Id;
            }else if(message == 'Con llegada a destino'){
                ship.Shipment_Status_Mon__c = 'Finished_M';
                ship.Id = Id;
            }else{
                ship = null;
            }
        return ship;
    }
}