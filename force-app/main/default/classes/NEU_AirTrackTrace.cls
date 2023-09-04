public with sharing class NEU_AirTrackTrace 
{
    public Shipment__c record;
    public string direccion_origen {get;set;}
    public string direccion_destino {get;set;}
    public string direcciones_recogidas {get;set;}
    public string truck_last_position {get;set;}
    
    ApexPages.StandardController con;
     
    public NEU_AirTrackTrace(ApexPages.StandardController stdController) 
    {
        con = stdController;
              
        try 
        { 
            record = [select Id, Name, Site_of_Load__c, Site_of_Load__r.Name, Country_of_Load__c, Country_of_Load__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name,
            Country_of_Discharge__c, Country_of_Discharge__r.Name, Direccion_Monitoreo__c
            from Shipment__c where Id =: con.getRecord().id];
        } 
        catch(Exception ee){record = new Shipment__c();}
        
        List<Shipment_Stop__c> shipment_stops = [SELECT Id, Name, Country__c, State__c, Location__c, Address__c, Country__r.Name, State__r.Name, Location__r.Name
       	FROM Shipment_Stop__c WHERE Shipment__c =: record.Id limit 7];
       	
       	List<Truck_Position__c> truck_positions = [SELECT Id, Name, Country__c, State__c, Location__c, Address__c, Country__r.Name, State__r.Name, Location__r.Name
       	FROM Truck_Position__c WHERE Shipment__c =: record.Id ORDER BY Date_Time_Reported__c DESC limit 1];
       	
       	Integer TIMEOUT = 50000;

       	//DIRECCIONES
        direccion_origen = '';
        direccion_destino = '';
        direcciones_recogidas = '';
        truck_last_position = '';
        
        direccion_origen = (record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+', '+(record.Country_of_Load__c != null ? record.Country_of_Load__r.Name : '');
        direccion_destino = (record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+', '+(record.Country_of_Discharge__c != null ? record.Country_of_Discharge__r.Name : '');
            
        //ORIGIN
        if(direccion_origen != '')
        {
	        direcciones_recogidas += (record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+', '+(record.Country_of_Load__c != null ? record.Country_of_Load__r.Name : '')+'|';
	        direcciones_recogidas += '/sfsites/c/resource/origin_icon|';
	        
	        //COORDINATES
			Http h = new Http(); 
			HttpRequest req = new HttpRequest();
			req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+direccion_origen.replace(' ','+')+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig'); 
			req.setMethod('GET');
			req.setTimeout(TIMEOUT);
			HttpResponse res;
			if (!Test.isRunningTest())
				res = h.send(req); 
			
			if(res != null && res.getBody() != null)
        	{
        		JSONParser parser = JSON.createParser(res.getBody());
        		
        		while(parser.nextToken() != null)
        		{
        			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) 
		        	{
		                parser.nextToken();
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LATITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0)+'|';
			            
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LONGITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0)+';';
			            
			            break;
		            }
        		}
        	}
        }
		
        //DESTINATION
        if(direccion_destino != '')
        {
	       	direcciones_recogidas += (record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+', '+(record.Country_of_Discharge__c != null ? record.Country_of_Discharge__r.Name : '')+'|';
	        direcciones_recogidas += '/sfsites/c/resource/destination_icon|';
	        
	        //COORDINATES
    		Http h = new Http(); 
			HttpRequest req = new HttpRequest();
			req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+direccion_destino.replace(' ','+')+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig'); 
			req.setMethod('GET');
			req.setTimeout(TIMEOUT);
			HttpResponse res;
			if (!Test.isRunningTest())
				res = h.send(req); 
			
			if(res != null && res.getBody() != null)
        	{
        		JSONParser parser = JSON.createParser(res.getBody());
        		
        		while(parser.nextToken() != null)
        		{
        			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) 
		        	{
		                parser.nextToken();
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LATITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0)+'|';
			            
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LONGITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0);
			            
			            break;
		            }
        		}
        	}
        }
    }
}