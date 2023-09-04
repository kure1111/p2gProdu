global class ServiceGoogle {
    
    private static final String urlGoogleDist = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    
    private static String googleMapsDistanceEndPoint(decimal latOrigin, decimal longOrigin, decimal latDetination,decimal longDestination){
        String result = null;
        system.debug('entramos 2 latOrigin ' + latOrigin); 
        system.debug('entramos 2 longOrigin ' + longOrigin); 
        system.debug('entramos 2 latDetination ' + latDetination); 
        system.debug('entramos 2 longDestination ' + longDestination);
        //if(latOrigin > 14 && longOrigin <-85 && latDetination >14 &&  longDestination < -85)
       // {
            return urlGoogleDist + '?origins='+latOrigin+','+longOrigin+'&destinations='+latDetination+','+longDestination+'&mode=driving&language=es-ES&key=AIzaSyDXXKDGlVqDKf7ewYUxICPXs7gPLRKK9No';
       // }
       // return null;
    }
    
    private integer getDistance(String endpoint){
        System.debug('endpoint: ' + endpoint);
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        JSONParser parser = null;
        
        if(!Test.isRunningTest())
        {
        	HttpResponse response = httpProtocol.send(request);
            parser =  JSON.createParser(response.getBody());
        }
        else
        parser = JSON.createParser('{ "destination_addresses": [ "Calle Segunda Sur 88, Independencia, 54915 Buenavista, Méx., México" ], "origin_addresses": [ "San Francisco De Los Romo - Aguascalientes 212, Las Ánimas, Ags., México" ], "rows": [ { "elements": [ { "distance": { "text": "480 km", "value": 480399 }, "duration": { "text": "5h 23 min", "value": 19384 }, "status": "OK" } ] } ], "status": "OK" }');
        
        integer result = 0;
        system.debug('parser ' + parser);
        while (parser.nextToken() != null){
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'distance')) {
                parser.nextToken();
                parser.nextValue();
                parser.nextToken();
                parser.nextValue();
               
                result += parser.getIntegerValue();
                system.debug('parser result' +  result);
            }
        }
        return result;
    }
    
    public integer googleMapsDistanceKM(decimal latOrigin, decimal longOrigin, decimal latDetination,decimal longDestination)
    {
        system.debug('entramos latOrigin ' + latOrigin); 
        system.debug('entramos longOrigin ' + longOrigin); 
        system.debug('entramos latDetination ' + latDetination); 
        system.debug('entramos longDestination ' + longDestination); 
        
        String endpoint = googleMapsDistanceEndPoint(latOrigin, longOrigin, latDetination,longDestination);
        system.debug('entramos endpoint ' + endpoint); 
        
        if(endpoint != null){
            integer res = getDistance(endpoint);
            system.debug('terminamos res mts ' + res); 
            
            integer result=0;
            
           if(res > 0 && res<1000)
                result= 1;
            else if( res > 0 && res > 1000)
                result= (integer)((res/1000));
            
              system.debug('terminamos result kms ' + result);
            
            return result;
        }
        
        
        return 0;
        
    }
    
    public integer googleMapsDistanceMI(decimal latOrigin, decimal longOrigin, decimal latDetination,decimal longDestination){
        
        String endpoint = googleMapsDistanceEndPoint(latOrigin, longOrigin, latDetination,longDestination);
        if(endpoint != null)
        { 
            integer res = getDistance(endpoint + '&units=imperial');
            system.debug('terminamos res ' + res); 
           return res;
        }
        
        return 0;
        
    }   
    
}