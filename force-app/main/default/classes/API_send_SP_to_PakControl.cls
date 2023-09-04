public with sharing class API_send_SP_to_PakControl {
    @Future(callout=true)
    public static void send_SP(string id_SP){
        send(id_SP);      
    }
    public static void send(string id_SP){
        // instancia una llamada de tipo HTTP
        Http http = new Http();
        // es un apartado que llenas en el que indicas a donde estas apuntando y envias los paramertros que requiere el servicio que quieres consumir 
        HttpRequest request = new HttpRequest();
        Organization org=[SELECT Id, IsSandbox FROM Organization LIMIT 1];
        Boolean isSandbox=org.IsSandbox;
        system.debug('lo que contiene isSandbox: '+isSandbox);
        if(isSandbox || test.isRunningTest()){/* pruebas */request.setEndpoint('https://api-staging-control-room.pak2go.digital/api/v1/sales-force/shipments');request.setHeader('Authorization', 'KqyACw5uU2xlvTA2PeP+UkT3TlW44gSJ2mg4SDxOHOxG/f8tHtGpb8MSXyp+KnEkNqklRA=='); }else{/* productivo*/request.setEndpoint('https://api-control-room.pak2go.digital/api/v1/sales-force/shipments');request.setHeader('Authorization', 'g9xjH2MfoUWsANZ9lS5HpQ/wE4MeQjWXVK/LxGazJbuzHJJxHLLiklnHdyU8Ju9sL34L4Q=='); }
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setMethod('POST');
        string body ='{"shipmentId":"'+id_SP+'"}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // /*
        system.debug('lo que mandamos al servicio: '+request);
        system.debug('lo que mandamos al servicio en el header[Authorization : '+request.getheader('Authorization')+']');
        system.debug('lo que mandamos al servicio en el body: '+request.getBody());
        system.debug('lo que responde el servicio'+response);
        system.debug('lo que responde el servicio'+response.getBody());     
        // */   
    }
    
}