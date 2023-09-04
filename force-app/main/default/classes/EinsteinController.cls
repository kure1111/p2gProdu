public class EinsteinController {
    public String getAccessToken() {
        
        try{         
            
            system.debug('Ingresando a la Clase: EinsteinController Metodo: getAccessToken ');
            ContentVersion base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform' OR  Title='predictive_services' ORDER BY Title LIMIT 1];
            system.debug('lo que contiene base64Content: '+base64Content);
            String keyContents = base64Content.VersionData.tostring();
            system.debug('lo que contiene keyContents: '+keyContents);
            keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
            keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
            keyContents = keyContents.replace('\n', '');
            
            JWT jwt = new JWT('RS256');
            jwt.pkcs8 = keyContents; 
            jwt.iss = 'developer.force.com';
            jwt.sub = 'leonardo.nocelo@pak2go.com'; // Change this with your email which is used for einstein api setup
            jwt.aud = 'https://api.einstein.ai/v2/oauth2/token';
            jwt.exp = '3600';
            system.debug('lo que contiene keyContents: '+keyContents);
            system.debug('lo que contiene jwt: '+jwt);
            String access_token = JWTBearerFlow.getAccessToken('https://api.einstein.ai/v2/oauth2/token', jwt);
            system.debug('lo que contiene access_token: '+access_token);
            return access_token;             
            
        }catch(Exception e){
            
            system.debug('Error EinsteinController: ' + e.getCause() + ' -  ' + e.getMessage() + ' linea: ' + e.getLineNumber());
            return null;
        }                   
    }
}