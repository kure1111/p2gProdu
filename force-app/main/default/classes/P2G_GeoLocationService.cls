public class P2G_GeoLocationService { 
    @AuraEnabled
    public static Map<String, String> getAddress(Decimal latitude, Decimal longitude, String name) {
        String apiKey = 'AIzaSyDkwLqNdoijG5TO8q9JgMdnXz9yHdEwfWc';
        String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
        String url = baseUrl + '?latlng=' + latitude + ',' + longitude + '&key=' + apiKey;
        
        // Inicializar variables para los datos de dirección
        Map<String, String> addressDetails = new Map<String, String>();
        
        try {
            // Realizar la solicitud HTTP GET
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> results = (List<Object>) jsonResponse.get('results');
                System.debug('JSON GOOGLE: '+response.getBody());
                if (!results.isEmpty()) {
                    Map<String, Object> result = (Map<String, Object>) results[0];
                    List<Object> addressComponents = (List<Object>) result.get('address_components');
                    
                    // Recorrer los componentes de dirección para obtener los detalles
                    for (Object component : addressComponents) {
                        Map<String, Object> comp = (Map<String, Object>) component;
                        List<Object> types = (List<Object>) comp.get('types');
                        
                        // Identificar el tipo de componente y asignarlo al map de resultados
                        String type = (String) types[0];
                        String value = (String) comp.get('long_name');
                        
                        if (types.contains('country')) {
                            addressDetails.put('pais', value);
                        } else if (types.contains('administrative_area_level_1')) {
                            addressDetails.put('estado', value);
                        } else if (types.contains('administrative_area_level_2')) {
                            addressDetails.put('municipio', value);
                        } else if (types.contains('locality')) {
                            addressDetails.put('localidad', value);
                        } else if (types.contains('sublocality')) {
                            addressDetails.put('colonia', value);
                        } else if (types.contains('route')) {
                            addressDetails.put('calle', value);
                        } else if (types.contains('street_number')) {
                            addressDetails.put('numero', value);
                        }else if (types.contains('postal_code')) {
                            addressDetails.put('codigo_postal', value);
                        }
                    }
                    
                    // Agregar la dirección completa al mapa
                    String formattedAddress = (String) result.get('formatted_address');
                    addressDetails.put('address', formattedAddress);
                    addressDetails.put('name', name);
                }
            } else {
                System.debug('Error en la solicitud HTTP: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Excepción: ' + e.getMessage());
        }
        
        return addressDetails;
    }
    
    @AuraEnabled
    public static Map<String, String> getAddressCp(String postalCode) {
        String apiKey = 'AIzaSyDkwLqNdoijG5TO8q9JgMdnXz9yHdEwfWc';
        String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
        String url = baseUrl + '?address=' + EncodingUtil.urlEncode(postalCode, 'UTF-8') + '&components=country:MX&key=' + apiKey;
        System.debug('postalCode '+postalCode);
        // Inicializar variables para los datos de dirección
        Map<String, String> addressDetails = new Map<String, String>();
        
        try {
            // Realizar la solicitud HTTP GET
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> results = (List<Object>) jsonResponse.get('results');
                System.debug('JSON GOOGLE: ' + response.getBody());
                if (!results.isEmpty()) {
                    Map<String, Object> result = (Map<String, Object>) results[0];
                    List<Object> addressComponents = (List<Object>) result.get('address_components');
                	Map<String, Object> geometry = (Map<String, Object>) result.get('geometry');
                    Map<String, Object> location = (Map<String, Object>) geometry.get('location');
                    String lat = String.valueOf(location.get('lat'));
                    String lng = String.valueOf(location.get('lng'));
                    
                    // Recorrer los componentes de dirección para obtener los detalles
                    for (Object component : addressComponents) {
                        Map<String, Object> comp = (Map<String, Object>) component;
                        List<Object> types = (List<Object>) comp.get('types');
                        
                        // Identificar el tipo de componente y asignarlo al map de resultados
                        String type = (String) types[0];
                        String value = (String) comp.get('long_name');
                        
                        if (types.contains('country')) {
                            addressDetails.put('pais', value);
                        } else if (types.contains('administrative_area_level_1')) {
                            addressDetails.put('estado', value);
                        } else if (types.contains('administrative_area_level_2')) {
                            addressDetails.put('municipio', value);
                        } else if (types.contains('locality')) {
                            addressDetails.put('localidad', value);
                        } else if (types.contains('sublocality')) {
                            addressDetails.put('colonia', value);
                        } else if (types.contains('route')) {
                            addressDetails.put('calle', value);
                        } else if (types.contains('street_number')) {
                            addressDetails.put('numero', value);
                        } else if (types.contains('postal_code')) {
                            addressDetails.put('codigo_postal', value);
                        }
                    }
                    
                    // Agregar la dirección completa al mapa
                    String formattedAddress = (String) result.get('formatted_address');
                    addressDetails.put('address', formattedAddress);
                    // Agregar las coordenadas al mapa de resultados
                    addressDetails.put('lat', lat);
                    addressDetails.put('lng', lng);
                }
            } else {
                System.debug('Error en la solicitud HTTP: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Excepción: ' + e.getMessage());
        }
        
        return addressDetails;
    }
}