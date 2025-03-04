@isTest
public class P2G_updateStatusAddressTest {
    
    @isTest
    static void testUpdateStatusAddressSuccess() {
        // Crear un objeto de prueba de la clase WrapperDispo
        P2G_updateStatusAddress.WrapperDispo testData = new P2G_updateStatusAddress.WrapperDispo();
        testData.idSp = 'a0B2v00000ABC123'; // Id de prueba
        testData.routeExists = 'true';
        
        // Convertir el objeto de prueba en JSON
        String jsonBody = JSON.serialize(new List<P2G_updateStatusAddress.WrapperDispo> { testData });
        
        // Simular la solicitud REST
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/statusAddress';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        // Ejecutar el método
        Test.startTest();
        P2G_updateStatusAddress.main();
        Test.stopTest();
        
        // Verificar la respuesta
        String responseBody = RestContext.response.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
    }
    
    @isTest
    static void testUpdateStatusAddressErrorNoRoute() {
        // Crear un objeto de prueba donde no existe la ruta
        P2G_updateStatusAddress.WrapperDispo testData = new P2G_updateStatusAddress.WrapperDispo();
        testData.idSp = 'a0B2v00000XYZ456'; // Id de prueba
        testData.routeExists = 'false';
        
        // Convertir el objeto de prueba en JSON
        String jsonBody = JSON.serialize(new List<P2G_updateStatusAddress.WrapperDispo> { testData });
        
        // Simular la solicitud REST
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/statusAddress';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        // Ejecutar el método
        Test.startTest();
        P2G_updateStatusAddress.main();
        Test.stopTest();
        String responseBody = RestContext.response.responseBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
    }
    
    @isTest
    static void testMissingRequiredFields() {
        // Crear un objeto con campos requeridos faltantes
        P2G_updateStatusAddress.WrapperDispo testData = new P2G_updateStatusAddress.WrapperDispo();
        testData.idSp = ''; // Campo faltante
        testData.routeExists = ''; // Campo faltante
        
        // Convertir el objeto de prueba en JSON
        String jsonBody = JSON.serialize(new List<P2G_updateStatusAddress.WrapperDispo> { testData });
        
        // Simular la solicitud REST
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/statusAddress';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        // Ejecutar el método
        Test.startTest();
        P2G_updateStatusAddress.main();
        Test.stopTest();
    }
    
}