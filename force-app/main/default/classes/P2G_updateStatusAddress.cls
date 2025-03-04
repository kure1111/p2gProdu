@RestResource(urlMapping='/statusAddress/*')
global class P2G_updateStatusAddress {
    @HttpPost
    global static void main() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            String requestBody = req.requestBody.toString();
            System.debug('requestBody: ' + requestBody);
            
            // Deserializar el cuerpo de la solicitud a una lista de objetos de tipo wrapperRequest
            List<WrapperDispo> requestDataList = (List<WrapperDispo>) JSON.deserialize(requestBody, List<WrapperDispo>.class);
            
            // Validar los campos requeridos
            List<String> missingFields = new List<String>();
            for (WrapperDispo requestData : requestDataList) {
                if (String.isBlank(requestData.idSp)) missingFields.add('idSp');
                if (String.isBlank(requestData.routeExists)) missingFields.add('routeExists');
            }
            
            if (!missingFields.isEmpty()) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error": "Missing required fields: ' + String.join(missingFields, ', ') + '"}');
                return;
            }
            
            String message = createResponseRecord(requestDataList[0].idSp,requestDataList[0].routeExists);
            
            //datos del JSON de respuesta
            Map<String, String> responseMap = new Map<String, String>();
            if(message=='success'){
                responseMap.put('status', 'succes');
            }
            else responseMap.put('status',message);
            
            String jsonResponse = JSON.serialize(responseMap);
            
            // Establecer la respuesta
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonResponse);
            
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
    
    public class WrapperDispo {
        public String idSp {get; set;}
        public String routeExists {get; set;}
    }
    
    private static String createResponseRecord(String shipmentId,String routeExists) {
        String message = 'success';
        try {
            Response__c sapR = new Response__c();
            sapR.Shipment__c = shipmentId;
            if(routeExists == 'true'){
                sapR.Type__c = 'CONFIRM';
                sapR.Message__c = 'Ruta existe';
            }
            else{
                sapR.Type__c = 'ERROR';
                sapR.Message__c = 'No existe ruta';
            }
            
            insert sapR;
        } catch (Exception e) {
            message = 'Error '+e.getMessage();
        }
        return message;
    }
}