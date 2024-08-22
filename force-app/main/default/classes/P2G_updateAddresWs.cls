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
            }
            
            if (!missingFields.isEmpty()) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error": "Missing required fields: ' + String.join(missingFields, ', ') + '"}');
                return;
            }
            
            updateCoordinates(id,requestDataList[0].lat, requestDataList[0].lon, requestDataList[0].validado,requestDataList[0].url);

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
        public String extra {get; set;}
    }
    
    public class wrapperRequest {
        public String externalId {get; set;}
        public String outdoorNumber {get; set;}
        public String interiorNumber {get; set;}
        public String street {get; set;}
        public String postalCode {get; set;}
        public String suburb {get; set;}
        public String city {get; set;}
        //public String town {get; set;}
        public String state {get; set;}
        public String country {get; set;}
        public String name {get; set;}
        public Decimal lat {get; set;}
        public Decimal lng {get; set;}
        public String spotAddress {get; set;}
    }
    
    public static void send(string idAddress){
        // instancia una llamada de tipo HTTP
        Http http = new Http();
        // es un apartado que llenas en el que indicas a donde estas apuntando y envias los paramertros que requiere el servicio que quieres consumir 
        HttpRequest request = new HttpRequest();
        Organization org=[SELECT Id, IsSandbox FROM Organization LIMIT 1];
        Boolean isSandbox = org.IsSandbox;
        if(isSandbox){
            request.setEndpoint('https://api-staging-control-room.pak2go.digital/api/v1/sales-force/addresses');
        }else{
            // productivo
            request.setEndpoint('https://api-staging-control-room.pak2go.digital/api/v1/sales-force/addresses');
        }
        request.setHeader('Accept', 'application/json, text/plain, */*');
        request.setHeader('Authorization', 'KqyACw5uU2xlvTA2PeP+UkT3TlW44gSJ2mg4SDxOHOxG/f8tHtGpb8MSXyp+KnEkNqklRA==');
        request.setHeader('Content-Type','application/json; charset=utf-8');
        request.setMethod('POST');
        String body = bodyJson(idAddress);
        request.setBody(body);
        HttpResponse response = http.send(request);
        
        system.debug('lo que mandamos al servicio: '+request);
        system.debug('body que mandamos al servicio: '+body);
        system.debug('lo que responde el servicio'+response.getBody());
        
        // Manejar la respuesta del servicio
        if (response.getStatusCode() == 200) {
            Account_Address__c accAddress = new Account_Address__c();
            accAddress.Id = idAddress;
            accAddress.status__c = 'Pendiente';
            update accAddress;
            System.debug('Éxito: Respuesta del servicio 200 - ' + response.getBody());
        } else if (response.getStatusCode() == 400) {
            System.debug('Error: Respuesta del servicio 400 - ' + response.getBody());
        } else {
            System.debug('Respuesta no manejada: ' + response.getStatusCode() + ' - ' + response.getBody());
        }
    }
    
    public static String bodyJson(String idAddress){
        Account_Address__c altaAddress = [
            SELECT Id, Name, Calle_cat__c, Numero_Ext_cp__c, Numero_Int_cat__c, Codigo_Postal_CP__c,Codigo_Postal_CP__r.Name,
            Colonia_cp__c,Colonia_cp__r.Name, Pais_cat1__c, Estado_cat2__c, Municipio_Cat2__c, Localidad_Cat2__c,
            Address_Coordinates__Latitude__s,Address_Coordinates__Longitude__s,Address__c
            FROM Account_Address__c 
            WHERE Id = :idAddress
        ];
        
        wrapperRequest jsonRequest = new wrapperRequest();
        jsonRequest.externalId = altaAddress.Id;
        jsonRequest.outdoorNumber = altaAddress.Numero_Ext_cp__c;
        jsonRequest.interiorNumber = altaAddress.Numero_Int_cat__c;
        jsonRequest.street = altaAddress.Calle_cat__c;
        jsonRequest.postalCode = altaAddress.Codigo_Postal_CP__r.Name;
        jsonRequest.suburb = altaAddress.Colonia_cp__r.Name;
        jsonRequest.city = altaAddress.Localidad_Cat2__c;
        //jsonRequest.town = altaAddress.Municipio_Cat2__c;
        jsonRequest.state = altaAddress.Estado_cat2__c;
        jsonRequest.country = altaAddress.Pais_cat1__c;
        jsonRequest.name = altaAddress.Name;
        jsonRequest.lat = altaAddress.Address_Coordinates__Latitude__s;
        jsonRequest.lng = altaAddress.Address_Coordinates__Longitude__s;
        jsonRequest.spotAddress = altaAddress.Address__c;
        
        String body = JSON.serialize(jsonRequest);
        return body;
    }
    
    public static void updateCoordinates(String id, String lat, String lon, String validado, String url){
        Account_Address__c address = new Account_Address__c();
        address.id = id;
        address.Address_Coordinates__Latitude__s = Double.valueOf(lat);
        address.Address_Coordinates__Longitude__s = Double.valueOf(lon);
        address.url_rc__c = url;
        if(validado == 'true'){
            address.status__c = 'Validado';
        }
        if(!test.isRunningTest()){
            update address;   
        }     
    }

}