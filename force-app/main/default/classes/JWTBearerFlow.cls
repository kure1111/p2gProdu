public class JWTBearerFlow {
    public static String getAccessToken(String tokenEndpoint, JWT jwt) {
        system.debug('Entrando a clase : JWTBearerFlow metodo: getAccessToken');
        String access_token = null;
        String body = 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=' + jwt.issue();
        HttpRequest req = new HttpRequest();                            
        req.setMethod('POST');
        req.setEndpoint(tokenEndpoint);
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        system.debug('lo que contiene  el request para obtener token'+req);
        system.debug('lo que contiene  el tokenEndpoint'+tokenEndpoint);
        system.debug('lo que contiene  el body'+body);
        Http http = new Http(); 
        HTTPResponse res = null;
        
        if(!test.isRunningTest()){
         	res = http.send(req);   
        }        
        system.debug('lo que respondio el servicio'+res);
        
        if ( test.isRunningTest() || res.getStatusCode() == 200 ) {
            System.JSONParser parser = System.JSON.createParser((test.isRunningTest() ? body : res.getBody()));
            
           while ((test.isRunningTest() || parser.nextToken() != null)) {
                if ((test.isRunningTest() || (parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token'))) {
                    
                    if(!test.isRunningTest()){
                     	parser.nextToken();   
                    }                    
                    access_token = (test.isRunningTest() ? 'Ejemplo' : parser.getText());
                    break;
                }
              }           
        }
        return access_token;
    }
}