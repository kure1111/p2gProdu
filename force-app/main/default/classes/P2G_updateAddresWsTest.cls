@IsTest
public class P2G_updateAddresWsTest {
    @IsTest(SeeAllData=true)
    public static void test(){
            Account_Address__c altaAddress = [
            SELECT Id, Name, Calle_cat__c, Numero_Ext_cp__c, Numero_Int_cat__c, Codigo_Postal_CP__c,Codigo_Postal_CP__r.Name,
            Colonia_cp__c,Colonia_cp__r.Name, Pais_cat1__c, Estado_cat2__c, Municipio_Cat2__c, Localidad_Cat2__c
            FROM Account_Address__c LIMIT 1];
        // Preparar la solicitud HTTP
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/address/' + altaAddress.Id;
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('[{"lat": "25.6866", "lon": "-100.3161", "url": "http://maps.google.com/?q=25.6866,-100.3161", "validado": "true", "extra": "campo extra"}]');
        RestContext.request = req;
        RestContext.response = res;

        // Llamar al método
        P2G_updateAddresWs.main();
        
        // Simular una respuesta de callout con HttpCalloutMock
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        P2G_updateAddresWs.send(altaAddress.Id);
        
        Test.stopTest();
        
    }
    
    //Mock para simular respuestas HTTP
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Crear una respuesta simulada
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }

}