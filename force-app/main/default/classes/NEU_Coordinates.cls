public with sharing class NEU_Coordinates 
{
    /* 
	NEU_UpdateCoordinates sched = new NEU_UpdateCoordinates();
	String minuto = String.valueof(system.now().minute()+1);
	String hora = String.valueof(system.now().hour());
	String dia = String.valueof(system.today().day());
	String mes = String.valueof(system.today().month());
	String anio = String.valueof(system.today().year());
	Id job_id = System.schedule('NEU_UpdateCoordinates', '0 '+minuto+' '+hora+' '+dia+' '+mes+' ? '+anio, sched);
	*/ 
	
	@future(callout=true)
	public static void update_data() 
	{
		HttpResponse res;
		Integer TIMEOUT = 50000;  
		List<Customer_Quote__c> query_ie = null;
		//Import-Export
		try
		{
			query_ie = [select id, Name, Origin_Address__c, Destination_Address__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Country_ofDischarge__c, Country_ofDischarge__r.name, 
			Site_of_Load__c, Site_of_Load__r.name, Country_ofLoad__c, Country_ofLoad__r.Name, Initial_Origin_Address_Latitude__c, Initial_Origin_Address_Longitude__c, 
			Final_Destination_Address_Latitude__c, Final_Destination_Address_Longitude__c, State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name 
			from Customer_Quote__c 
			where (Initial_Origin_Address_Latitude__c = null or Initial_Origin_Address_Longitude__c = null or Final_Destination_Address_Latitude__c = null 
			or Final_Destination_Address_Longitude__c = null) limit 40];
			for(Customer_Quote__c ie : query_ie)
			{
				if(ie.Origin_Address__c != null || ie.Site_of_Load__c != null)
				{
					//COORDINATES ORIGIN IE
		    		Http h = new Http(); 
					HttpRequest req = new HttpRequest();
					if(ie.Origin_Address__c != null){
						req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+ie.Origin_Address__c.replace(' ','+').replace('\n','+').replace('\r','+')+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig');
					}else if(ie.Site_of_Load__c != null){
						String address = ie.Site_of_Load__r.Name.replace(' ','+').replace('\n','+').replace('\r','+');
						if(ie.State_of_Load__c != null){
							address = ie.State_of_Load__r.Name.replace(' ','+').replace(',','+').replace('\n','+').replace('\r','+') + '+' + address;
						}
						if(ie.Country_ofLoad__c != null){
							address = ie.Country_ofLoad__r.Name.replace(' ','+').replace(',','+').replace('\n','+').replace('\r','+') + '+' + address;
						}
						req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig');
					}
						 
																																																   
					req.setMethod('GET');
					req.setTimeout(TIMEOUT);
					if (!Test.isRunningTest())
						res = h.send(req); 
					
					if(res.getBody() != null)
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
					            ie.Initial_Origin_Address_Latitude__c = (parser.getText() != null ? parser.getText() : '');
					            
					            parser.nextToken();
					            parser.nextToken();
					            
					            //LONGITUDE
					            ie.Initial_Origin_Address_Longitude__c = (parser.getText() != null ? parser.getText() : '');
				            }
		        		}
		        	}
				}
				
				
				
				if(ie.Destination_Address__c != null || ie.Site_of_Discharge__c != null)
				{
					//COORDINATES DESTINATION IE
		    		Http h = new Http(); 
					HttpRequest req = new HttpRequest();
					if(ie.Destination_Address__c != null){
						req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+ie.Destination_Address__c.replace(' ','+').replace('\n','+').replace('\r','+')+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig');
					}else if(ie.Site_of_Discharge__c != null){
						String address = ie.Site_of_Discharge__r.Name.replace(' ','+').replace('\n','+').replace('\r','+');
						if(ie.State_of_Discharge__c != null){
							address = ie.State_of_Discharge__r.Name.replace(' ','+').replace(',','+').replace('\n','+').replace('\r','+') + '+' + address;
						}
						if(ie.Country_ofDischarge__c != null){
							address = ie.Country_ofDischarge__r.Name.replace(' ','+').replace(',','+').replace('\n','+').replace('\r','+') + '+' + address;
						}
						req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig');
					}
																																																   
					req.setMethod('GET');
					req.setTimeout(TIMEOUT);
					if (!Test.isRunningTest())
						res = h.send(req); 
					
					if(res.getBody() != null)
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
					            ie.Final_Destination_Address_Latitude__c = (parser.getText() != null ? parser.getText() : '');
					            
					            parser.nextToken();
					            parser.nextToken();
					            
					            //LONGITUDE
					            ie.Final_Destination_Address_Longitude__c = (parser.getText() != null ? parser.getText() : '');
				            }
		        		}
		        	}
				}
			}
			
			
		}
		catch(Exception ex){enviarNotificacion('Actualización Coordenadas', 'Error: '+ex+' ('+ex.getLineNumber()+')'+res.getBody());}  
		
		//Shipments
		try
		{
			List<Shipment__c> query_ship = [select id, Name, Site_of_Discharge__c, Destination_Address__c, Site_of_Discharge__r.Name, Country_of_Discharge__c, Country_of_Discharge__r.Name, 
			Site_of_Load__c, Site_of_Load__r.name, Final_Delivery_Address_Latitude__c, Final_Delivery_Address_Longitude__c, State_of_Discharge__c, State_of_Discharge__r.Name,
			State_of_Load__c, State_of_Load__r.Name 
			from Shipment__c 
			where (Final_Delivery_Address_Latitude__c = null or Final_Delivery_Address_Longitude__c = null) limit 20];
			for(Shipment__c ie : query_ship)
			{
				if(ie.Destination_Address__c != null || ie.Site_of_Discharge__c != null)
				{
					//COORDINATES DESTINATION IE
		    		Http h = new Http(); 
					HttpRequest req = new HttpRequest();
					if(ie.Destination_Address__c != null){
						req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+ie.Destination_Address__c.replace(' ','+').replace(',','+').replace('\n','+').replace('\r','+')+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig');
					}else if(ie.Site_of_Discharge__r != null){
						String address = ie.Site_of_Discharge__r.Name.replace(' ','+').replace('\n','+').replace('\r','+');
						if(ie.State_of_Discharge__r != null){
							address = ie.State_of_Discharge__r.Name.replace(' ','+').replace(',','+').replace('\n','+').replace('\r','+') + '+' + address;
						}
						if(ie.Country_of_Discharge__r != null){
							address = ie.Country_of_Discharge__r.Name.replace(' ','+').replace(',','+').replace('\n','+').replace('\r','+') + '+' + address;
						}
						
						req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig');
					} 
																																																   
					req.setMethod('GET');
					req.setTimeout(TIMEOUT);
					if (!Test.isRunningTest())
						res = h.send(req); 
					
					if(res.getBody() != null)
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
					            ie.Final_Delivery_Address_Latitude__c = (parser.getText() != null ? parser.getText(): '');
					            
					            parser.nextToken();
					            parser.nextToken();
					            
					            //LONGITUDE
					            ie.Final_Delivery_Address_Longitude__c = (parser.getText() != null ? parser.getText() : '');
				            }
		        		}
		        	}
				}
			}
			
			try
			{
				if(query_ie != null && query_ie.size()>0)
					update query_ie;
			}
			catch(Exception ex){enviarNotificacion('Actualización IE', 'Error: '+ex+' ('+ex.getLineNumber()+')');}	
			
			try
			{
				update query_ship;
			}
			catch(Exception ex){enviarNotificacion('Actualización Ship', 'Error: '+ex+' ('+ex.getLineNumber()+')');}	
			
		}
		catch(Exception ex){enviarNotificacion('Actualización Coordenadas', 'Error: '+ex+' ('+ex.getLineNumber()+')'+res.getBody());}  	
	}
	
	public static void enviarNotificacion(string asunto, string cuerpo)
	{
		List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    mail.setToAddresses(new String[]{'mario@neurored.com'});
		mail.setSenderDisplayName('Pak2Go Coordinates');
		mail.setSubject(asunto);
		mail.setBccSender(false); 
		mail.setUseSignature(false); 
		mail.setCharset('UTF-8');
		mail.setPlainTextBody(cuerpo);
		
		theEmails.add(mail);
		
		List<Messaging.Email> allMails = new List<Messaging.Email>();
		for(Integer j = 0; j < theEmails.size(); j++)
		{
			allMails.add(theEmails.get(j));
		}
		
		try
		{
			if (!Test.isRunningTest())
				Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
		}
		catch(Exception exc){}		
	}
}