@IsTest
public class P2G_GeoLocationServiceTest {
    
    // Simulación de la respuesta de Google Maps para las pruebas
    private class MockHttpResponseGeolocation implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{' +
                        '"results": [{' +
                            '"formatted_address": "123 Test Street, Test City",' +
                            '"address_components": [' +
                                '{ "long_name": "Mexico", "types": ["country"] },' +
                                '{ "long_name": "Nuevo León", "types": ["administrative_area_level_1"] },' +
                                '{ "long_name": "Monterrey", "types": ["locality"] },' +
                                '{ "long_name": "Colonia Test", "types": ["sublocality"] },' +
                                '{ "long_name": "Test Street", "types": ["route"] },' +
                                '{ "long_name": "123", "types": ["street_number"] },' +
                                '{ "long_name": "64000", "types": ["postal_code"] }' +
                            '],' +
                            '"geometry": {' +
                                '"location": { "lat": 25.6866142, "lng": -100.3161126 }' +
                            '}' +
                        '}],' +
                        '"status": "OK"' +
                    '}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @IsTest
    static void testGetAddress() {
        // Establecer simulación para la llamada HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeolocation());
        
        // Ejecutar el método con latitud y longitud de ejemplo
        Decimal latitude = 25.6866142;
        Decimal longitude = -100.3161126;
        String name = 'Test Name';
        
        Map<String, String> result = P2G_GeoLocationService.getAddress(latitude, longitude, name);
        

    }
    
    @IsTest
    static void testGetAddressCp() {
        // Establecer simulación para la llamada HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeolocation());
        
        // Ejecutar el método con un código postal de ejemplo
        String postalCode = '64000';
        
        Map<String, String> result = P2G_GeoLocationService.getAddressCp(postalCode);
        
        
    }
}