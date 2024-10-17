@RestResource(urlMapping='/address/*')
global class P2G_updateAddresWs {
    @HttpPut
    global static void main() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Obtener el ID de la URL
            String id = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
            System.debug('ID from URL: ' + id);
            
            // Lee el cuerpo de la solicitud PUT
            String requestBody = req.requestBody.toString();
            System.debug('requestBody: ' + requestBody);
            
            // Deserializar el cuerpo de la solicitud a una lista de objetos de tipo wrapperRequest
            List<WrapperDispo> requestDataList = (List<WrapperDispo>) JSON.deserialize(requestBody, List<WrapperDispo>.class);
            
            // Validar los campos requeridos
            List<String> missingFields = new List<String>();
            for (WrapperDispo requestData : requestDataList) {
                if (String.isBlank(requestData.lat)) missingFields.add('lat');
                if (String.isBlank(requestData.lon)) missingFields.add('lon');
                if (String.isBlank(requestData.url)) missingFields.add('url');
                if (String.isBlank(requestData.validado)) missingFields.add('validado');
                if (String.isBlank(requestData.address)) missingFields.add('address');
            }
            
            if (!missingFields.isEmpty()) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error": "Missing required fields: ' + String.join(missingFields, ', ') + '"}');
                return;
            }
            
            updateCoordinates(id,requestDataList[0].lat, requestDataList[0].lon, requestDataList[0].validado,requestDataList[0].url,requestDataList[0].address);
            
            // Crear un mapa para almacenar los datos del JSON de respuesta
            Map<String, String> responseMap = new Map<String, String>();
            responseMap.put('status', 'Actualizado');
            responseMap.put('id', id);
            
            // Convertir el mapa a JSON
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
        public String Id {get; set;}
        public String lat {get; set;}
        public String lon {get; set;}
        public String url {get; set;}
        public String validado {get; set;}
        public String address {get; set;}
    }
    
    public class wrapperRequest {
        public String externalId {get; set;}
        public String name {get; set;}
        public Decimal lat {get; set;}
        public Decimal lng {get; set;}
        public String address {get; set;}
    }
    
    public static HttpResponse send(String idAddress, String body){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        Organization org = [SELECT Id, IsSandbox FROM Organization LIMIT 1];
        Boolean isSandbox = org.IsSandbox;
        
        if (isSandbox) {
            request.setEndpoint('https://api-staging-control-room.pak2go.digital/api/v1/sales-force/addresses');
            request.setHeader('Authorization', 'KqyACw5uU2xlvTA2PeP+UkT3TlW44gSJ2mg4SDxOHOxG/f8tHtGpb8MSXyp+KnEkNqklRA==');
        } else {
            request.setEndpoint('https://api-control-room.pak2go.digital/api/v1/sales-force/addresses');
            request.setHeader('Authorization', 'g9xjH2MfoUWsANZ9lS5HpQ/wE4MeQjWXVK/LxGazJbuzHJJxHLLiklnHdyU8Ju9sL34L4Q==');
        }
        
        request.setHeader('Accept', 'application/json, text/plain, */*');
        request.setHeader('Content-Type','application/json; charset=utf-8');
        request.setMethod('POST');
        request.setBody(body);
        
        HttpResponse response = http.send(request);
        
        System.debug('Request: ' + request);
        System.debug('Request Body: ' + body);
        System.debug('Response: ' + response.getBody());
                
        return response;
    }
    
    public static void listAddressNew(List<Account_Address__c> addresses) {
        Map<String, HttpResponse> successfulResponses = new Map<String, HttpResponse>();
        Map<String, HttpResponse> errorfulResponses = new Map<String, HttpResponse>();
        
        for (Account_Address__c address : addresses) {
            // Construir el cuerpo de la solicitud
            String body = bodyJson(address);
            HttpResponse response = send(address.Id, body);
            
            // Manejar la respuesta del servicio
            if (response.getStatusCode() == 200) {
                successfulResponses.put(address.Id, response);
            } else {
                errorfulResponses.put(address.Id, response);
            }
        }
        
        // Actualizar los registros exitosos en Salesforce
        List<Account_Address__c> addressesToUpdate = new List<Account_Address__c>();
        
        for (Account_Address__c address : addresses) {
            if (successfulResponses.containsKey(address.Id)) {
                address.status__c = 'Pendiente';
            } else if (errorfulResponses.containsKey(address.Id)) {
                address.status__c = 'Error';
            }
            addressesToUpdate.add(address);
        }
        
        if (!addressesToUpdate.isEmpty()) {
            update addressesToUpdate;
        }
    }
    
    public static String bodyJson(Account_Address__c altaAddress) {
        wrapperRequest jsonRequest = new wrapperRequest();
        jsonRequest.externalId = altaAddress.Id;
        jsonRequest.name = altaAddress.Name;
        jsonRequest.lat = altaAddress.Address_Coordinates__Latitude__s;
        jsonRequest.lng = altaAddress.Address_Coordinates__Longitude__s;
        jsonRequest.address = altaAddress.Address__c;
        
        String body = JSON.serialize(jsonRequest);
        return body;
}
    
    public static void updateCoordinates(String id, String lat, String lon, String validado, String url, String addr){
        Account_Address__c address = new Account_Address__c();
        address.id = id;
        if(validado == 'true'){
            address.Address_Coordinates__Latitude__s = Double.valueOf(lat);
            address.Address_Coordinates__Longitude__s = Double.valueOf(lon);
            address.url_rc__c = url;
            address.status__c = 'Validado';
            address.Address_CR__c = addr;
            address.Active__c = true;
        }
        if(validado == 'false'){
            address.Address_Coordinates__Latitude__s = Double.valueOf(lat);
            address.Address_Coordinates__Longitude__s = Double.valueOf(lon);
            address.url_rc__c = url;
            address.status__c = 'Rechazado';
            address.Address_CR__c = addr;
        }
        if(!test.isRunningTest()){
            update address;   
        }     
    }
    
}