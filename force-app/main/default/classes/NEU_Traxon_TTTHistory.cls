public with sharing class NEU_Traxon_TTTHistory 
{
	ApexPages.StandardController con;
	Shipment__c record;
	String URLhistory;
	String URLplus;
	String URLplace;
	String URLlocation;
	Double latitude;
	Double longitude; 
	public String sdate;
	public CSL_Credentials__c credentials;
	public JSON2Apex respuestaHistory;
	public JSON2Apex respuestaPlus;
	public JSON2ApexPlace respuestaPlace;
	public JSON2ApexLocation respuestaLocation;
	public List<Event__c>listevents{get;set;}
	
	public static String[]usedFields=new String[]
	{
		'Id'
		,'MAWB_Number__c'
		,'Flight_Number__c'
		,'Air_Latitude__c'
		,'Air_Longitude__c'
	};
		
	public NEU_Traxon_TTTHistory(ApexPages.StandardController stdController) 
	{
		if (!Test.isRunningTest()) {stdController.AddFields(usedFields);}
		con = stdController;
		record=(Shipment__c)con.getRecord();
		sandbox();
	}
	
	public void sandbox()
	{
		List<Organization>org=[SELECT Id, IsSandbox FROM Organization LIMIT 1];
		Boolean isSandbox=false;
		if(org.size()>0)
			if(org[0].IsSandbox)
				isSandbox=true;
		if(isSandbox)
		{
			URLplus='https://community.champ.aero:8443/api/tracking/TTTPlus/';//https://community.champ.aero:8444/api/tracking/TTTPlus/
			URLhistory='https://community.champ.aero:8443/api/tracking/TTTHistory/';//https://community.champ.aero:8443/api/tracking/TTTHistory/
		}
		else
		{
			URLplus='https://community.champ.aero:8443/api/tracking/TTTPlus/';
			URLhistory='https://community.champ.aero:8443/api/tracking/TTTHistory/';
		}
	}
	
	//Traxon
	public class JSON2Apex 
	{
		public FlightHistory flightHistory {get;set;} 
		public LastFlightStatus lastFlightStatus {get;set;} 
		public String responseCode {get;set;} 
	
		public JSON2Apex(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'flightHistory') 
							flightHistory = new FlightHistory(parser);
						else if (text == 'lastFlightStatus')
							lastFlightStatus = new LastFlightStatus(parser);
						else if (text == 'responseCode')
							responseCode = parser.getText();
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class LastFlightStatus
	{
		public String airWaybillNumber {get;set;} 
		public OriginAndDestination originAndDestination {get;set;} 
		public Quantity quantity {get;set;} 
		public Integer totalNumberOfPieces {get;set;} 
		public List<Events> events {get;set;} 

		public LastFlightStatus(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'airWaybillNumber')
							airWaybillNumber = parser.getText();
						else if (text == 'originAndDestination')
							originAndDestination = new OriginAndDestination(parser);
						else if (text == 'quantity')
							quantity = new Quantity(parser);
						else if (text == 'totalNumberOfPieces')
							totalNumberOfPieces = parser.getIntegerValue();
						else if (text == 'events')
							events = arrayOfEvents(parser);
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class FlightHistory 
	{
		public String airWaybillNumber {get;set;} 
		public List<Consignments> consignments {get;set;} 
	
		public FlightHistory(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'airWaybillNumber')
							airWaybillNumber = parser.getText();
						else if (text == 'consignments')
							consignments = arrayOfConsignments(parser);
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Consignments 
	{
		public OriginAndDestination originAndDestination {get;set;} 
		public Quantity quantity {get;set;} 
		public Integer totalNumberOfPieces {get;set;} 
		public List<Events> events {get;set;} 
		
		public Consignments(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'originAndDestination')
							originAndDestination = new OriginAndDestination(parser);
						else if (text == 'quantity')
							quantity = new Quantity(parser);
						else if (text == 'totalNumberOfPieces')
							totalNumberOfPieces = parser.getIntegerValue();
						else if (text == 'events')
							events = arrayOfEvents(parser);
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Events 
	{
		public String type_Z {get;set;} // in json: type
		public Integer numberOfPieces {get;set;} 
		public Weight weight {get;set;} 
		public String timeOfEvent {get;set;} 
		public String timeOfEventTimePartQuality {get;set;} 
		public String airportOfReceipt {get;set;} 
		public String airportOfNotification {get;set;} 
		public String airportOfDelivery {get;set;}
		public String receivedFromName {get;set;} 
		public String flight {get;set;} 
		public String dateOfScheduledDeparture {get;set;} 
		public String origin {get;set;} 
		public String destination {get;set;} 
		public String timeOfScheduledArrival {get;set;} 
		public String dateOfScheduledArrival {get;set;} 
		public String timeOfScheduledDeparture {get;set;}  
		public String notificationToName {get;set;} 
		public Double ecefLongitude {get;set;} 
		public Double ecefLatitude {get;set;} 
	
		public Events(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'type')
							type_Z = parser.getText();
						else if (text == 'numberOfPieces')
							numberOfPieces = parser.getIntegerValue();
						else if (text == 'weight')
							weight = new Weight(parser);
						else if (text == 'timeOfEvent')
							timeOfEvent = parser.getText();
						else if (text == 'timeOfEventTimePartQuality')
							timeOfEventTimePartQuality = parser.getText();
						else if (text == 'airportOfReceipt')
							airportOfReceipt = parser.getText();
						else if (text == 'airportOfNotification')
							airportOfNotification = parser.getText();
						else if (text == 'airportOfDelivery')
							airportOfDelivery = parser.getText();
						else if (text == 'receivedFromName')
							receivedFromName = parser.getText();
						else if (text == 'flight')
							flight = parser.getText();
						else if (text == 'dateOfScheduledDeparture')
							dateOfScheduledDeparture = parser.getText();
						else if (text == 'origin')
							origin = parser.getText();
						else if (text == 'destination')
							destination = parser.getText();
						else if (text == 'timeOfScheduledArrival')
							timeOfScheduledArrival = parser.getText();
						else if (text == 'dateOfScheduledArrival')
							dateOfScheduledArrival = parser.getText();
						else if (text == 'timeOfScheduledDeparture')
							timeOfScheduledDeparture = parser.getText();
						else if (text == 'notificationToName')
							notificationToName = parser.getText();
						else if (text == 'ecefLongitude')
							ecefLongitude = parser.getDoubleValue();
						else if (text == 'ecefLatitude')
							ecefLatitude = parser.getDoubleValue();
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class OriginAndDestination 
	{
		public String origin {get;set;} 
		public String destination {get;set;} 
		
		public OriginAndDestination(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'origin')
							origin = parser.getText();
						else if (text == 'destination')
							destination = parser.getText();
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
		
	public class Quantity 
	{
		public String shipmentDescriptionCode {get;set;} 
		public Integer numberOfPieces {get;set;} 
		public Weight weight {get;set;} 
	
		public Quantity(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'shipmentDescriptionCode')
							shipmentDescriptionCode = parser.getText();
						else if (text == 'numberOfPieces')
							numberOfPieces = parser.getIntegerValue();
						else if (text == 'weight')
							weight = new Weight(parser);
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
		
	public class Weight 
	{
		public decimal amount {get;set;} 
		public String unit {get;set;} 
	
		public Weight(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'amount')
							amount = parser.getDecimalValue();
						else if (text == 'unit')
							unit = parser.getText();
						else
							consumeObject(parser);
					}
				}
			}
		}
	}

	public static JSON2Apex parse(String json) 
	{
		return new JSON2Apex(System.JSON.createParser(json));
	}
		
	public static void consumeObject(System.JSONParser parser) 
	{
		Integer depth = 0;
		do 
		{
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || curr == System.JSONToken.START_ARRAY)
				depth++;
			else if (curr == System.JSONToken.END_OBJECT || curr == System.JSONToken.END_ARRAY)
				depth--;
		} 
		while (depth > 0 && parser.nextToken() != null);
	}
		
	private static List<Events> arrayOfEvents(System.JSONParser p) 
	{
		List<Events> res = new List<Events>();
		if (p.getCurrentToken() == null) 
			p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY)
			res.add(new Events(p));
		return res;
	}

	private static List<Consignments> arrayOfConsignments(System.JSONParser p) 
	{
		List<Consignments> res = new List<Consignments>();
		if (p.getCurrentToken() == null) 
			p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY)
			res.add(new Consignments(p));
		return res;
	}
	//Fin Traxon
	
	//Place
	public class JSON2ApexPlace
	{
		public List<Predictions> predictions {get;set;} 
		public String status {get;set;}
		
		public JSON2ApexPlace(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'predictions') 
							predictions = arrayOfPredictions(parser);
						else if (text == 'status')
							status = parser.getText();
						else 
							consumeObject(parser);
					}
				}
			}
		}
	}

	public class Predictions 
	{
		public String place_id {get;set;} 
		
		public Predictions(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'place_id')
							place_id = parser.getText();
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	private static List<Predictions> arrayOfPredictions(System.JSONParser p) 
	{
		List<Predictions> res = new List<Predictions>();
		if (p.getCurrentToken() == null) 
			p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) 
			res.add(new Predictions(p));
		return res;
	}
	
	public static JSON2ApexPlace parsePlace(String json) 
	{
		return new JSON2ApexPlace(System.JSON.createParser(json));
	}
	//Fin Place
	
	//Location
	public class JSON2ApexLocation
	{
		public Result result {get;set;} 
		public String status {get;set;}
	
		public JSON2ApexLocation(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'result')
							result = new Result(parser);
						else if (text == 'status')
							status = parser.getText();
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Result {
		public Geometry geometry {get;set;} 

		public Result(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'geometry')
							geometry = new Geometry(parser);
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Geometry 
	{
		public Location location {get;set;} 

		public Geometry(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'location')
							location = new Location(parser);
						else 
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Location 
	{
		public Double lat {get;set;} 
		public Double lng {get;set;} 

		public Location(JSONParser parser) 
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME)
				 {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'lat')
							lat = parser.getDoubleValue();
						else if (text == 'lng')
							lng = parser.getDoubleValue();
						else
							consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static JSON2ApexLocation parseLocation(String json) 
	{
		return new JSON2ApexLocation(System.JSON.createParser(json));
	}
	//Fin Location
	
	public PageReference cancel()
	{
		return con.view();
	}

	public PageReference sendToTraxon()
	{
		Http httpProtocol = new Http();
		HttpRequest req_generate = new HttpRequest();
		Boolean errors=false;
		Boolean reg;
		try
		{
			if(String.isEmpty(record.MAWB_Number__c))
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Shipment__c.fields.MAWB_Number__c.getDescribe().getLabel()+' not found'));
				errors=true;
				reg = true;
			}
			else 
			{
				if (!Test.isRunningTest())
					reg = Pattern.matches('^[0-9]{3}-[0-9]{8}', record.MAWB_Number__c);
				else
					reg = true;
			}
			if(!reg)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Shipment__c.fields.MAWB_Number__c.getDescribe().getLabel()+' incorrect format'));
				errors=true;
			}
			if(errors)
				return null;
				
			credentials = [SELECT Id, Login__c, Password__c, Site__c FROM CSL_Credentials__c Where Name = 'Traxon'];
			URLhistory+=record.MAWB_Number__c;
			
			req_generate.setEndPoint(URLhistory);
			req_generate.setMethod('GET');
			req_generate.setHeader('user', credentials.Login__c);
			req_generate.setHeader('password', credentials.Password__c);
			//req_generate.setTimeout(90000);
			HttpResponse res_generate = httpProtocol.send(req_generate);
			
			if(res_generate.getStatusCode() == 401)
			{
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Server Error'));
				return null;
			}
			else if(res_generate.getStatusCode() == 200)
			{
				respuestaHistory = parse(res_generate.getBody());
			}
			else
			{
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error ' + res_generate.getBody()));
				return null;
			}
			
			Http httpProtocol_plus = new Http();
			HttpRequest req_generate_plus = new HttpRequest();
			URLplus+=record.MAWB_Number__c;
			
			req_generate_plus.setEndPoint(URLplus);
			req_generate_plus.setMethod('GET');
			req_generate_plus.setHeader('user', credentials.Login__c);
			req_generate_plus.setHeader('password', credentials.Password__c);
			//req_generate_plus.setTimeout(90000);
			HttpResponse res_generate_plus = httpProtocol_plus.send(req_generate_plus);
			
			if(res_generate_plus.getStatusCode() == 401)
			{
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Server Error'));
				return null;
			}
			else if(res_generate_plus.getStatusCode() == 200)
			{
				respuestaPlus = parse(res_generate_plus.getBody());
			}
			else
			{
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error ' + res_generate.getBody()));
				return null;
			}

			listevents=new List<Event__c>();
			Id lastId=null;
			//if(respuestaHistory.flightHistory.consignments[0].events.size() > 0)
			if(respuestaHistory.flightHistory.consignments.size() > 0)
			{
				//getEvents(0);
				
				/*if(respuestaHistory.flightHistory.consignments.size() > 1)
				{*/
					for(integer j=0;j<respuestaHistory.flightHistory.consignments.size();j++)
					{
						if(respuestaHistory.flightHistory.consignments[j].events.size() > 0)
							getEvents(j);
					}
				//}
				
				if(respuestaPlus.lastFlightStatus.events.size() > 0)
				{
					Boolean entra=false;
					String place='';
					String iata='';
					for (Events a:respuestaPlus.lastFlightStatus.events)
					{
						iata='';
						if(a.destination != null)
							iata=a.destination.toUpperCase();
						else if(a.airportOfNotification != null)
							iata=a.airportOfNotification.toUpperCase();
						else if(a.airportOfDelivery != null)
							iata=a.airportOfDelivery.toUpperCase();
						else if(a.airportOfReceipt != null)
							iata=a.airportOfReceipt.toUpperCase();
						else if(a.origin != null)
							iata=a.origin;
						else
							iata='';
							
						if(a.type_Z == 'in flight')
						{
							record.Air_Latitude__c=a.ecefLatitude;
							record.Air_Longitude__c=a.ecefLongitude;
							entra=true;
						}
					}
					if(!entra)
					{
						List<Location__c> location = [select Id, Name From Location__c Where IATA_Code__c=:iata];
						Http httpProtocol_place = new Http();
						HttpRequest req_generate_place = new HttpRequest();
						
						if(location.size() > 0)
						{
							String namelocation = location[0].Name.replace(' ','%20');
							URLplace='https://maps.googleapis.com/maps/api/place/autocomplete/json?input='+namelocation;
							URLplace+='&language=en&key=AIzaSyDXXKDGlVqDKf7ewYUxICPXs7gPLRKK9No';
						}
						else
						{
							URLplace='https://maps.googleapis.com/maps/api/place/autocomplete/json?input='+iata;
							URLplace+='&language=en&key=AIzaSyDXXKDGlVqDKf7ewYUxICPXs7gPLRKK9No';
						}
						
						req_generate_place.setEndPoint(URLplace);
						req_generate_place.setMethod('GET');
						//req_generate_place.setTimeout(90000);
						HttpResponse res_generate_place = httpProtocol_place.send(req_generate_place);
						respuestaPlace = parsePlace(res_generate_place.getBody());

						if(respuestaPlace.status == 'OK')
						{
							if(respuestaPlace.predictions.size() > 0)
								place=respuestaPlace.predictions[0].place_id;
							
							Http httpProtocol_location = new Http();
							HttpRequest req_generate_location = new HttpRequest();
							URLlocation='https://maps.googleapis.com/maps/api/place/details/json?placeid='+place;
							URLlocation+='&key=AIzaSyDXXKDGlVqDKf7ewYUxICPXs7gPLRKK9No';
							
							req_generate_location.setEndPoint(URLlocation);
							req_generate_location.setMethod('GET');
							//req_generate_location.setTimeout(90000);
							HttpResponse res_generate_location = httpProtocol_location.send(req_generate_location);
							respuestaLocation = parseLocation(res_generate_location.getBody());
							
							if(respuestaLocation.status == 'OK')
							{
								if(respuestaLocation.result.geometry != null)
								{
									record.Air_Latitude__c=respuestaLocation.result.geometry.location.lat;
									record.Air_Longitude__c=respuestaLocation.result.geometry.location.lng;
								}
							}
						}
					}
					update record;
				}
					
				List<Event__c>oldevents = new List<Event__c>();
				oldevents = [select Id from Event__c where Shipment__c =: con.getRecord().Id];
				if(oldevents.size() > 0)
					delete oldevents;
				
				if(listevents.size() > 0)
					insert listevents;
				
				List<Event__c>updateevents = new List<Event__c>();
				for(Event__c e:listevents)
				{
					if(lastId!=null)
						e.Previous_Event_Code__c=lastId;
					lastId=e.Id;
					updateevents.add(e);
				}
				if(updateevents.size()>0)
					update updateevents;
			}

			PageReference pgReturnPage;
			String returnUrl = '/' + record.Id;
			pgReturnPage = new PageReference(returnUrl);
			pgReturnPage.setRedirect(true);
			return pgReturnPage;
		}
		catch (Exception ex)
		{
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
			system.debug('\n\n\n\n RORRE' + ex.getLineNumber() + ' ' + ex.getMessage() + '\n\n\n\n');
			return null;
		}
	}
	
	public List<Event__c> getEvents(integer i)
	{
		for (Events a:respuestaHistory.flightHistory.consignments[i].events)
		{
			if(a.timeOfEventTimePartQuality == 'SUPPLIED')
			{
				Event__c e=new Event__c();
				e.Shipment__c=con.getRecord().Id;
				e.Number_of_Pieces__c=a.numberOfPieces;
				e.Weight_kg__c=a.weight.amount;
				
				sdate = a.timeOfEvent.replace('T', ' ');
				e.Notified_Date_Time__c=Datetime.valueOf(sdate);
				
				if(a.flight != null)
				{
					e.Flight_Number__c=a.flight;
					if(a.flight.length() < 7)
						record.Flight_Number__c=a.flight;
				}
				
				if(a.destination != null)
					e.Arrival_IATA_Code__c=a.destination;
				else if(a.airportOfNotification != null)
					e.Arrival_IATA_Code__c=a.airportOfNotification;
				else if(a.airportOfDelivery != null)
					e.Arrival_IATA_Code__c=a.airportOfDelivery;
				else
					e.Arrival_IATA_Code__c='';
		
				if(a.airportOfReceipt != null)
					e.Departure_IATA_Code__c=a.airportOfReceipt;
				else if(a.origin != null)
					e.Departure_IATA_Code__c=a.origin;
				else
					e.Departure_IATA_Code__c='';
					
				if(a.receivedFromName != null)
					e.Additional_Information__c=a.receivedFromName;
				else if(a.notificationToName != null)
					e.Additional_Information__c=a.notificationToName;
				else
					e.Additional_Information__c='';
					
				if(a.type_Z == 'received from shipper')
				{
					e.Name='RCS';
					e.Event__c='The consignment has been physically received from the shipper or the shipper’s agent and is considered by the carrier as ready for carriage on this date at this location';
				}
				else if(a.type_Z == '')
				{
					e.Name='RCT';
					e.Event__c='The consignment has been physically received from this carrier on this date at this location';
				}
				else if(a.type_Z == 'received from flight')
				{
					e.Name='RCF';
					e.Event__c='The consignment has been physically received from a given flight or surface transport of the given airline';
				}
				else if(a.type_Z == 'booked' || a.type_Z == 'freight on hand')
				{
					e.Name='BKD';
					e.Event__c='The consignment has been booked for transport between these locations on this scheduled date and this flight';
				}
				else if(a.type_Z == 'manifested')
				{
					e.Name='MAN';
					e.Event__c='The consignment has been manifested for this flight on this scheduled date for transport between these location';
				}
				else if(a.type_Z == 'departed')
				{
					e.Name='DEP';
					e.Event__c='The consignment has physically departed this location on this scheduled date and flight for transport to the arrival location';
				}
				else if(a.type_Z == '')
				{
					e.Name='PRE';
					e.Event__c='The consignment has been prepared for loading on this flight for transport between these locations on this scheduled date';
				}
				else if(a.type_Z == '')
				{
					e.Name='TFD';
					e.Event__c='The consignment has been physically transferred to this carrier on this date at this location';
				}
				else if(a.type_Z == 'consignee notified')
				{
					e.Name='NFD';
					e.Event__c='The consignee or the consignee’s agent has been notified, on this date at this location, of the arrival of the consignment';
				}
				else if(a.type_Z == 'arrival documentation delivered')
				{
					e.Name='AWD';
					e.Event__c='The arrival documentation has been physically delivered to the consignee or the consignee’s agent on this date at this location';
				}
				else if(a.type_Z == '')
				{
					e.Name='CCD';
					e.Event__c='The consignment has been cleared by the Customs authorities on this date at this location';
				}
				else if(a.type_Z == 'delivered')
				{
					e.Name='DLV';
					e.Event__c='The consignment has been physically delivered to the consignee or the Consignee’s agent on this date at this location';
				}
				else if(a.type_Z == '')
				{
					e.Name='DIS';
					e.Event__c='An apparent error has occurred, on this date at this location, with the handling of the consignment or its documentation, which is further clarified by the accompanying discrepancy code';
				}
				else if(a.type_Z == '')
				{
					e.Name='CRC';
					e.Event__c='The consignment has been reported to the Customs authorities on this date at this location';
				}
				else if(a.type_Z == '')
				{
					e.Name='DDL';
					e.Event__c='The consignment has been physically delivered to the consignee’s door on this date at this location';
				}
				else if(a.type_Z == '')
				{
					e.Name='TGC';
					e.Event__c='The consignment has been transferred to Customs/Government control';
				}
				else if(a.type_Z == 'arrived')
				{
					e.Name='ARR';
					e.Event__c='The consignment has arrived on a scheduled flight at this location';
				}
				else if(a.type_Z == '')
				{
					e.Name='FOH';
					e.Event__c='The consignment is on hand on this date at this location pending “ready for carriage” determination';
				}
				else if(a.type_Z == 'arrival documentation received')
				{
					e.Name='AWR';
					e.Event__c='The arrival documentation has been physically received from a scheduled flight at this location';
				}
				listevents.add(e);
			}
		}
		return listevents;
	}
}