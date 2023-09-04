public without sharing class P2G_getToken {
    @future(callout=true)
    public static void callout() {
        try{
            String nuevotoken = getTokenRecursoC();
            P2G_globalVariable.setToken(nuevotoken);   
        }catch(Exception e){
            System.debug('Error en P2G_getToken: '+e.getLineNumber());
        }
    }
    public static String getTokenSF() {
        Credential__mdt credentials = [SELECT passworld__c,token__c,usuario__c,clientId__c,clientSecret__c FROM credential__mdt WHERE DeveloperName =:'usuarioSF' limit 1];
        String username = credentials.usuario__c;
        String password = credentials.passworld__c;
        String securityToken = credentials.token__c;
        String clientId = credentials.clientId__c;
        String clientSecret =credentials.clientSecret__c;
        String passwordWithToken = password + securityToken;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        request.setMethod('POST');
        String requestBody = 'grant_type=password&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') 
            + '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') 
            + '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') 
            + '&password=' + EncodingUtil.urlEncode(passwordWithToken, 'UTF-8');
        request.setBody(requestBody);
        HttpResponse response = http.send(request);
        String responseBody = response.getBody();
        Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        String accessToken = (String) parsedResponse.get('access_token');
        System.debug('Body: '+response.getBody());
        return accessToken;
    }
    
    public static String getTokenRecursoC() {
        Credential__mdt credentials = [SELECT passworld__c,token__c,usuario__c,clientId__c,clientSecret__c FROM credential__mdt WHERE DeveloperName =:'usuarioRC' limit 1];
        String token;
        String usuario = credentials.usuario__c;
        String contrasena=credentials.passworld__c;
        String endpoint = 'https://app.rcontrol.com.mx/rcSuite/GetUserToken';
        String body = 'arg00=' + EncodingUtil.urlEncode(usuario, 'UTF-8') + '&arg01=' + EncodingUtil.urlEncode(contrasena, 'UTF-8');  
        Http https = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setBody(body);
        HttpResponse response = https.send(request);
        if (response.getStatusCode() == 200) {
            String requestBody = response.getBody();
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
            token = (String)jsonMap.get('token');
        } else {
            System.debug('Error: '+response.getStatusCode());
            System.debug('Error: '+response.getBody());
        }
        return token;
    }
}