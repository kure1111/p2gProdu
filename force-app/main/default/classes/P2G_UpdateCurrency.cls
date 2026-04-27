public class P2G_UpdateCurrency implements Schedulable {
    //trabajo para que se ejecute todos los días a las 12:05 AM
    //String jobId = System.schedule('Schedulable update currency ws', '0 5 0 * * ?', new P2G_UpdateCurrency());
    //metodo para probar manualmente
    //P2G_UpdateCurrency.actualizarCurrency();
    public void execute(SchedulableContext context) {
        actualizarCurrency();
    }
    
    @future(callout=true)
    public static void actualizarCurrency() {
        Map<String, Decimal> tasasDeCambio = consultarTasasCambio();
        if (!tasasDeCambio.containsKey('SF43718') || !tasasDeCambio.containsKey('SF46410')) {
            System.debug('No se pudieron obtener las tasas de cambio del servicio.');
            return;
        }
        
        Decimal nuevaTasaUSD = tasasDeCambio.get('SF43718');
        Decimal nuevaTasaEUR = tasasDeCambio.get('SF46410');
        
        // Obtener el Token de acceso
        String accessToken = UserInfo.getSessionId();
        Http http = new Http();
        
        // Obtener el ID de CurrencyType para USD y EUR
        CurrencyType usdCurrency = [SELECT Id FROM CurrencyType WHERE IsoCode = 'USD' LIMIT 1];
        CurrencyType eurCurrency = [SELECT Id FROM CurrencyType WHERE IsoCode = 'EUR' LIMIT 1];
        
        // Actualizar ambas tasas de cambio en una sola llamada
        actualizarTasasCambio(http, usdCurrency.Id, eurCurrency.Id, (1 / nuevaTasaUSD), (1 / nuevaTasaEUR), accessToken);
        
        // Actualizar tasas fechadas
        Date startDate = Date.today();

        String accessToken2 = UserInfo.getSessionId();
        createDatedConversionRate('EUR', (1 / nuevaTasaEUR), startDate, accessToken2);
        createDatedConversionRate('USD', (1 / nuevaTasaUSD), startDate, accessToken2);
    }
    
    private static void actualizarTasasCambio(Http http, Id usdCurrencyId, Id eurCurrencyId, Decimal usdRate, Decimal eurRate, String accessToken) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v52.0/composite/sobjects');
        req.setMethod('PATCH');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        
        // Crear el cuerpo JSON para ambas actualizaciones, asegurando que el ID está correctamente incluido
        String jsonBody = '{"allOrNone": true, "records":[';
        jsonBody += '{"attributes": {"type": "CurrencyType", "referenceId": "USD"}, "Id": "' + usdCurrencyId + '", "ConversionRate": ' + usdRate + ', "DecimalPlaces": 6},';
        jsonBody += '{"attributes": {"type": "CurrencyType", "referenceId": "EUR"}, "Id": "' + eurCurrencyId + '", "ConversionRate": ' + eurRate + ', "DecimalPlaces": 6}';
        jsonBody += ']}';
        
        req.setBody(jsonBody);
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200 || res.getStatusCode() == 204) {
            System.debug('Tasas de cambio generales actualizadas correctamente');
        } else {
            System.debug('Error al actualizar tasas de cambio: ' + res.getBody());
        }
    }
    
    public static Map<String, Decimal> consultarTasasCambio() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.banxico.org.mx/SieAPIRest/service/v1/series/SF43718,SF46410/datos/oportuno');
        req.setMethod('GET');
        req.setHeader('Bmx-Token', 'e7d4ea23d131e9b6c5ec25061e91fa4b0ee3699dd16c7f0f588d967a124f260f');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Mapa para almacenar las tasas de cambio por idSerie
        Map<String, Decimal> tasasDeCambio = new Map<String, Decimal>();
        
        if (res.getStatusCode() == 200) {
            // Procesar la respuesta
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> seriesList = (List<Object>)((Map<String, Object>)responseMap.get('bmx')).get('series');
            
            for (Object serieObj : seriesList) {
                Map<String, Object> serie = (Map<String, Object>)serieObj;
                String idSerie = (String)serie.get('idSerie');
                List<Object> datosList = (List<Object>)serie.get('datos');
                Map<String, Object> dato = (Map<String, Object>)datosList.get(0);
                Decimal tasa = Decimal.valueOf((String)dato.get('dato'));
                tasasDeCambio.put(idSerie, tasa);
            }
        } else {
            System.debug('Error en la solicitud: ' + res.getBody());
        }
        System.debug('tasasDeCambio: ' + tasasDeCambio);
        return tasasDeCambio;
    }

    public static void createDatedConversionRate(String isoCode, Decimal rate, Date startDate, String accessToken) {
        // Formatear las fechas al formato ISO (yyyy-MM-dd) manualmente
        String startDateStr = String.valueOf(startDate.year()) + '-' + 
            (startDate.month() < 10 ? '0' + String.valueOf(startDate.month()) : String.valueOf(startDate.month())) + '-' +
            (startDate.day() < 10 ? '0' + String.valueOf(startDate.day()) : String.valueOf(startDate.day()));
        
        // Crear la solicitud HTTP
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String endpoint = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v52.0/sobjects/DatedConversionRate';
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        
        // Crear el cuerpo JSON con los datos fijos
        Map<String, Object> requestBody = new Map<String, Object>{
            'IsoCode' => isoCode,
            'ConversionRate' => rate,
            'StartDate' => startDateStr
        };
        req.setBody(JSON.serialize(requestBody));
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            System.debug('Tasas de cambio fechada creada correctamente para ' + isoCode + ': ' + res.getBody());
        } else {
            System.debug('Error al crear DatedConversionRate para ' + isoCode + ': ' + res.getBody());
        }
    }
}