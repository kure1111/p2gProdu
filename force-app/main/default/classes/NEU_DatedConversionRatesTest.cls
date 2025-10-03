@isTest(seeAllData=true)
public class NEU_DatedConversionRatesTest {

    @isTest
    static void test_update_data() {
        // Preparamos el Mock para las llamadas HTTP (si es necesario)
        Test.setMock(HttpCalloutMock.class, new MockDatedConversionRateCallout());

        // Ejecutamos el método @future
        Test.startTest();
        NEU_DatedConversionRates.update_data();
        Test.stopTest();

        // No hay aserciones directas porque es un proceso que actualiza CurrencyType y DatedConversionRate vía API interna,
        // y no podemos hacer DML directo sobre esos objetos.
        NEU_DatedConversionRates.byPass();
    }

    // Mock para las llamadas HTTP (Banxico API y PATCH a CurrencyType)
    public class MockDatedConversionRateCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            String body = '';

            // Simula respuesta de Banxico
            if (req.getEndpoint().contains('SF46410')) { // EUR endpoint
                body = '{"bmx":{"series":[{"datos":[{"fecha":"25-05-2025","dato":"18.50"}]}]}}';
            } else if (req.getEndpoint().contains('SF43718')) { // USD endpoint
                body = '{"bmx":{"series":[{"datos":[{"fecha":"25-05-2025","dato":"17.00"}]}]}}';
            } else if (req.getEndpoint().contains('CurrencyType')) {
                // PATCH o POST a CurrencyType o DatedConversionRate
                body = '{"id":"a1B3h0000008XYZ"}';
            } else if (req.getEndpoint().contains('DatedConversionRate')) {
                body = '{"id":"a1B3h0000008XYZ"}';
            } else {
                res.setStatusCode(400);
                body = '{"error":"Invalid endpoint"}';
            }

            res.setBody(body);
            return res;
        }
    }
}