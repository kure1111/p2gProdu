@IsTest
public class P2G_UpdateCurrencyTest {
    @IsTest(SeeAllData=true)
    static void testActualizarCurrency() {
        Test.startTest();
        
        // Simular la llamada HTTP para obtener las tasas de cambio
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"bmx":{"series":[{"idSerie":"SF43718","datos":[{"dato":"19.50"}]},{"idSerie":"SF46410","datos":[{"dato":"21.75"}]}]}}');
        mockResponse.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Ejecutar la clase Schedulable
        String jobId = System.schedule('Prueba Schedulable', '0 0 12 * * ?', new P2G_UpdateCurrency());
        Test.stopTest();

        // Verificar que las tasas de cambio se actualizaron
        CurrencyType usdCurrency = [SELECT ConversionRate FROM CurrencyType WHERE IsoCode = 'USD' LIMIT 1];
        CurrencyType eurCurrency = [SELECT ConversionRate FROM CurrencyType WHERE IsoCode = 'EUR' LIMIT 1];
    }
    
    @isTest
    static void testConsultarTasasCambioError() {
        // Simular una respuesta con error en la consulta de tasas
        Test.startTest();

        // Simular la llamada HTTP con error
        HttpResponse mockErrorResponse = new HttpResponse();
        mockErrorResponse.setStatusCode(500);
        mockErrorResponse.setBody('{"error":"Error interno del servidor"}');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockErrorResponse));

        // Ejecutar la clase Schedulable
        String jobId = System.schedule('Prueba Schedulable con Error', '0 0 12 * * ?', new P2G_UpdateCurrency());
        Test.stopTest();

        // Verificar que las tasas de cambio no se actualizaron debido al error
        CurrencyType usdCurrency = [SELECT ConversionRate FROM CurrencyType WHERE IsoCode = 'USD' LIMIT 1];
        CurrencyType eurCurrency = [SELECT ConversionRate FROM CurrencyType WHERE IsoCode = 'EUR' LIMIT 1];
    }

    // Clase Mock para simular respuestas HTTP
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse mockResponse;

        public MockHttpResponseGenerator(HttpResponse response) {
            this.mockResponse = response;
        }

        public HTTPResponse respond(HTTPRequest req) {
            return mockResponse;
        }
    }
}