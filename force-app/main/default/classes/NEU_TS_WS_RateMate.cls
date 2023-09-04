global with sharing class NEU_TS_WS_RateMate {
	public String country_origin{get;set;}
	public String state_origin{get;set;}
	public String location_origin{get;set;}
	public String location_origin_truckstop{get;set;}
	
	public String country_destination{get;set;}
	public String state_destination{get;set;}
	public String location_destination{get;set;}
	public String location_destination_truckstop{get;set;}
	
	public String margin{get;set;}
	public String radius{
		get{
			if(radius == null) {
				radius = 'Within100Miles';
			}
			return radius;
		}
		set;
	}
	
	public String label_radius{
		get{
			if(radius == null){
				label_radius = ' based on a 100 miles radius';
			}else if(radius == 'StateToState'){
				label_radius = ' based on state to state';
			}else if(radius == 'Within100Miles'){
				label_radius = ' based on a 100 miles radius';
			}else if(radius == 'Within150Miles'){
				label_radius = ' based on a 150 miles radius';
			}
			return label_radius;
		}
		set;
	}
	
	public List<CSL_Credentials__c> auth_ts_rateMate{get;set;}
	/*public List<CSL_Credentials__c> auth_ts_geography{get;set;}*/
	
	public String type_imp_exp{get;set;}
	
	public HistoricalRateResult historical_rate_result{get;set;}
	public FuelSurchargeResult fuel_surcharge_result{get;set;}
	public RateIndexResult rate_index_result{get;set;}
	public NegotiationStrengthResult negotiation_strength_result{get;set;}
	
	public String response{get;set;}
	
	public List<SelectOption> lst_location_origin{get;set;}
	public List<SelectOption> lst_location_destination{get;set;}
	
	public Integer month{
		get{
			if(month == null){
				month = Integer.valueOf(system.now().format('M'));
			}
			return month;
		}
		set;
	}
	
	public Integer year{
		get{
			if(year == null){
				year = Integer.valueOf(system.now().format('Y'));
			}
			return year;
		}
		set;
	}
	
	public class Filter{
		public Customer_Quote__c imp_exp {get;set;}
		public String Site_of_Discharge{get;set;}
		public String Site_of_Load{get;set;}
	}
	
	public Filter filter{get;set;}
	
	public String destination_city = 'Houston';
	public String destination_state = 'TX';
	public String destination_country = 'USA';
	public String origin_city = 'Los Angeles';
	public String origin_state = 'CA';
	public String origin_country = 'USA';
	
	public void NEU_TS_Call_HistoricalRates(){
		String body_request = '';
		body_request += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'; 
		body_request += ' xmlns:tem="http://tempuri.org/"';
		body_request += ' xmlns:web="http://schemas.datacontract.org/2004/07/WebServices"';
		body_request += ' xmlns:web1="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate">';
		body_request += '	<soapenv:Header/>';
		body_request += '	<soapenv:Body>';
		body_request += '		<tem:GetHistoricalRates>';
		body_request += '			<tem:request>';
		body_request += '				<web:IntegrationId>' + auth_ts_rateMate[0].External_Id__c + '</web:IntegrationId>';
		body_request += '				<web:Password>' + auth_ts_rateMate[0].Password__c + '</web:Password>';
		body_request += '				<web:UserName>' + auth_ts_rateMate[0].Login__c + '</web:UserName>';
		body_request += '				<web1:Criteria>';
		body_request += '					<web1:Destination>';
		body_request += '						<web1:City>'+filter.Site_of_Discharge+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofDischarge__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Discharge__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Destination>';
		body_request += '					<web1:Origin>';
		body_request += '						<web1:City>'+filter.Site_of_Load+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofLoad__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Load__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Origin>';
		body_request += '				</web1:Criteria>';
		body_request += '				<web1:RateCriteria>';
		body_request += '					<web1:DesiredMargin>'+margin+'</web1:DesiredMargin>';
		body_request += '					<web1:Radius>'+radius+'</web1:Radius>';
		body_request += '				</web1:RateCriteria>';
		body_request += '				<web1:RateCriteria>';
		body_request += '				</web1:RateCriteria>';
		body_request += '			</tem:request>';
		body_request += '		</tem:GetHistoricalRates>';
		body_request += '	</soapenv:Body>';
		body_request += '</soapenv:Envelope>';
		try{
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(auth_ts_rateMate[0].Site__c);
			req.setHeader('SOAPAction', 'http://tempuri.org/IRateMate/GetHistoricalRates');
			req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
			system.debug('INTEGRATION RATEMATE : Request Body - ' + body_request);
			req.setBody(body_request);
			
			if(!Test.isRunningTest()){
				Http http = new Http();
				HTTPResponse res = http.send(req);
				String response_body = res.getBody();
				system.debug('INTEGRATION RATEMATE : Response Body - ' + response_body);
				
				response = response + ' -------- GETHISTORICALRATES : '+ response_body;
				proccess_response(response_body);
			}
		}catch(Exception e){
			system.debug('TRUCKSTOP INTEGRATION : HISTORICAL RATES(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
	}
	
	public void NEU_TS_Call_RatesIndex(){
		String body_request = '';
		body_request += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'; 
		body_request += ' xmlns:tem="http://tempuri.org/"';
		body_request += ' xmlns:web="http://schemas.datacontract.org/2004/07/WebServices"';
		body_request += ' xmlns:web1="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate">';
		body_request += '	<soapenv:Header/>';
		body_request += '	<soapenv:Body>';
		body_request += '		<tem:GetRateIndex>';
		body_request += '			<tem:request>';
		body_request += '				<web:IntegrationId>' + auth_ts_rateMate[0].External_Id__c + '</web:IntegrationId>';
		body_request += '				<web:Password>' + auth_ts_rateMate[0].Password__c + '</web:Password>';
		body_request += '				<web:UserName>' + auth_ts_rateMate[0].Login__c + '</web:UserName>';
		body_request += '				<web1:Criteria>';
		body_request += '					<web1:Destination>';
		body_request += '						<web1:City>'+filter.Site_of_Discharge+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofDischarge__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Discharge__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Destination>';
		body_request += '					<web1:Origin>';
		body_request += '						<web1:City>'+filter.Site_of_Load+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofLoad__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Load__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Origin>';
		body_request += '				</web1:Criteria>';
		body_request += '				<web1:RateCriteria>';
		body_request += '					<web1:DesiredMargin>'+margin+'</web1:DesiredMargin>';
		body_request += '					<web1:Radius>'+radius+'</web1:Radius>';
		body_request += '				</web1:RateCriteria>';
		body_request += '			</tem:request>';
		body_request += '		</tem:GetRateIndex>';
		body_request += '	</soapenv:Body>';
		body_request += '</soapenv:Envelope>';
		
		try{
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(auth_ts_rateMate[0].Site__c);
			req.setHeader('SOAPAction', 'http://tempuri.org/IRateMate/GetRateIndex');
			req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
			system.debug('INTEGRATION RATEMATE : Request Body - ' + body_request);
			req.setBody(body_request);
			
			if(!Test.isRunningTest()){
				Http http = new Http();
				HTTPResponse res = http.send(req);
				String response_body = res.getBody();
				
				response = response + ' -------- GETRATEINDEX : '+ response_body;
				system.debug('INTEGRATION RATEMATE : Response Body - ' + response_body);
				
				proccess_response(response_body);
			}
		}catch(Exception e){
			system.debug('TRUCKSTOP INTEGRATION : HISTORICAL RATES(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
	}
	
	public void NEU_TS_Call_NegotiationStrength(){
		String body_request = '';
		body_request += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'; 
		body_request += ' xmlns:tem="http://tempuri.org/"';
		body_request += ' xmlns:web="http://schemas.datacontract.org/2004/07/WebServices"';
		body_request += ' xmlns:web1="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate">';
		body_request += '	<soapenv:Header/>';
		body_request += '	<soapenv:Body>';
		body_request += '		<tem:GetNegotiationStrength>';
		body_request += '			<tem:request>';
		body_request += '				<web:IntegrationId>' + auth_ts_rateMate[0].External_Id__c + '</web:IntegrationId>';
		body_request += '				<web:Password>' + auth_ts_rateMate[0].Password__c + '</web:Password>';
		body_request += '				<web:UserName>' + auth_ts_rateMate[0].Login__c + '</web:UserName>';
		body_request += '				<web1:Criteria>';
		body_request += '					<web1:Destination>';
		body_request += '						<web1:City>'+filter.Site_of_Discharge+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofDischarge__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Discharge__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Destination>';
		body_request += '					<web1:Origin>';
		body_request += '						<web1:City>'+filter.Site_of_Load+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofLoad__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Load__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Origin>';
		body_request += '				</web1:Criteria>';
		body_request += '			</tem:request>';
		body_request += '		</tem:GetNegotiationStrength>';
		body_request += '	</soapenv:Body>';
		body_request += '</soapenv:Envelope>';
		
		try{
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(auth_ts_rateMate[0].Site__c);
			req.setHeader('SOAPAction', 'http://tempuri.org/IRateMate/GetNegotiationStrength');
			req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
			system.debug('INTEGRATION RATEMATE : Request Body - ' + body_request);
			req.setBody(body_request);
			
			if(!Test.isRunningTest()){
				Http http = new Http();
				HTTPResponse res = http.send(req);
				String response_body = res.getBody();
				
				response = response + ' -------- GETNEGOTIATIONSTRENGTH : '+ response_body;
				system.debug('INTEGRATION RATEMATE : Response Body - ' + response_body);
				
				proccess_response(response_body);
			}
		}catch(Exception e){
			system.debug('TRUCKSTOP INTEGRATION : HISTORICAL RATES(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
	}
	
	public void NEU_TS_Call_FuelSurcharge(){
		String body_request = '';
		body_request += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'; 
		body_request += ' xmlns:tem="http://tempuri.org/"';
		body_request += ' xmlns:web="http://schemas.datacontract.org/2004/07/WebServices"';
		body_request += ' xmlns:web1="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate">';
		body_request += '	<soapenv:Header/>';
		body_request += '	<soapenv:Body>';
		body_request += '		<tem:GetFuelSurcharge>';
		body_request += '			<tem:request>';
		body_request += '				<web:IntegrationId>' + auth_ts_rateMate[0].External_Id__c + '</web:IntegrationId>';
		body_request += '				<web:Password>' + auth_ts_rateMate[0].Password__c + '</web:Password>';
		body_request += '				<web:UserName>' + auth_ts_rateMate[0].Login__c + '</web:UserName>';
		body_request += '				<web1:Criteria>';
		body_request += '					<web1:Destination>';
		body_request += '						<web1:City>'+filter.Site_of_Discharge+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofDischarge__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Discharge__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Destination>';
		body_request += '					<web1:Origin>';
		body_request += '						<web1:City>'+filter.Site_of_Load+'</web1:City>';
		body_request += '						<web1:Country>'+filter.imp_exp.Country_ofLoad__r.ISO_Code__c+'</web1:Country>';
		body_request += '						<web1:State>'+filter.imp_exp.State_of_Load__r.ISO_Code_2c__c+'</web1:State>';
		body_request += '					</web1:Origin>';
		body_request += '				</web1:Criteria>';
		body_request += '			</tem:request>';
		body_request += '		</tem:GetFuelSurcharge>';
		body_request += '	</soapenv:Body>';
		body_request += '</soapenv:Envelope>';
		
		try{
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(auth_ts_rateMate[0].Site__c);
			req.setHeader('SOAPAction', 'http://tempuri.org/IRateMate/GetFuelSurcharge');
			req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
			system.debug('INTEGRATION RATEMATE : Request Body - ' + body_request);
			req.setBody(body_request);
			
			if(!Test.isRunningTest()){
				Http http = new Http();
				HTTPResponse res = http.send(req);
				String response_body = res.getBody();
				system.debug('INTEGRATION RATEMATE : Response Body - ' + response_body);
				
				proccess_response(response_body);
			}
		}catch(Exception e){
			system.debug('TRUCKSTOP INTEGRATION : HISTORICAL RATES(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
	}
	
	
	public void searchCityOriginTruckstop() {
		load_filters();
		
		Map<String, String> map_body = new Map<String, String>();
		map_body.put('Country', filter.imp_exp.Country_ofLoad__r.ISO_Code__c);
		map_body.put('State', filter.imp_exp.State_of_Load__r.ISO_Code_2c__c);
		map_body.put('City', filter.imp_exp.Site_of_Load__r.Name);

		Map<String, Object> map_result = searchCities(map_body);
		
		List<SelectOption> options = new List<SelectOption>();
		if(map_result.get('error') != null){
		}else if(map_result.get('data_parsed') != null){
			SearchCityResult search_city_result = (SearchCityResult)map_result.get('data_parsed');
			if(search_city_result != null){
				if(search_city_result.data != null){
					for(CityStates city_state : search_city_result.data.cityStates){
						if(city_state.country == map_body.get('Country')){
							if(city_state.state == map_body.get('State')){
								options.add(new SelectOption(city_state.city, city_state.city));
								system.debug(city_state.city);
							}
						}
					}
				}
			}
		}
		lst_location_origin = options;
	}
	
	public void searchCityDestinationTruckstop() {
		load_filters();
		
		Map<String, String> map_body = new Map<String, String>();
		map_body.put('Country', filter.imp_exp.Country_ofDischarge__r.ISO_Code__c);
		map_body.put('State', filter.imp_exp.State_of_Discharge__r.ISO_Code_2c__c);
		map_body.put('City', filter.imp_exp.Site_of_Discharge__r.Name);

		Map<String, Object> map_result = searchCities(map_body);
		
		List<SelectOption> options = new List<SelectOption>();
		if(map_result.get('error') != null){
		}else if(map_result.get('data_parsed') != null){
			SearchCityResult search_city_result = (SearchCityResult)map_result.get('data_parsed');
			if(search_city_result != null){
				if(search_city_result.data != null){
					for(CityStates city_state : search_city_result.data.cityStates){
						if(city_state.country == map_body.get('Country')){
							if(city_state.state == map_body.get('State')){
								options.add(new SelectOption(city_state.city, city_state.city));
								system.debug(city_state.city);
							}
						}
					}
				}
			}
		}
		lst_location_destination = options;
	}
	
	
	public Map<String, Object> request_Token_Geography(){
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint('callout:Truckstop_Geography/auth/token');
			req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
			req.setBody('grant_type=client_credentials');
			
			if(!Test.isRunningTest()){
				Http http = new Http();
				HTTPResponse res = http.send(req);
				system.debug('INTEGRATION GEOGRAPHY : Response Body - ' + res.getBody());
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					JSONParser parser = System.JSON.createParser(res.getBody());
					while (parser.nextToken() != JSONToken.END_OBJECT) {
						if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
							String text = parser.getText();
							if (parser.nextToken() != JSONToken.VALUE_NULL) {
								if (text == 'access_token') {
									map_result.put('access_token', parser.getText());
								} else {
									consumeObject(parser);
								}
							}
						}
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error obtaining the information from Truckstop.');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error obtaining the information from Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : SEARCH CITY(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	
	public Map<String, Object> searchCities(Map<String, String> map_body){
		system.debug('TRUCKSTOP INTEGRATION : GEOGRAPHY');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			Map<String, Object> map_token = request_Token_Geography();
			
			if(map_token.get('error') == null){
				String json_request_body = JSON.serialize(map_body);
				map_result.put('json_request', json_request_body);
				system.debug('TRUCKSTOP INTEGRATION : GEOGRAPHY(Request Body : ' + json_request_body + ')');
				
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				
				req.setEndpoint('https://' + ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox ? 'api-int.truckstop.com' : 'api.truckstop.com') + '/geography/v1/cities/search');
				req.setHeader('Content-Type', 'application/json');
				req.setHeader('Authorization', 'Bearer ' + String.valueOf(map_token.get('access_token')));
				req.setBody(json_request_body);
				
				if(!Test.isRunningTest()){	
					Http http = new Http();
					HTTPResponse res = http.send(req);
					map_result.put('json_response', res.getBody());
					if(res.getStatusCode() == 200){
						SearchCityResult search_city_result = parse(res.getBody());
						if(search_city_result.statusCode != 0){
							map_result.put('error', 'There was an error obtaining the information from Truckstop.');
							system.debug('TRUCKSTOP INTEGRATION : GEOGRAPHY(Response Body : ' + res.getBody() + ').');
						}else{
							system.debug('TRUCKSTOP INTEGRATION : GEOGRAPHY(Response Body : ' + res.getBody() + ').');
							map_result.put('data', res.getBody());
							map_result.put('data_parsed', search_city_result);
						}
					}else if(res.getStatusCode() != 200){
						map_result.put('error', 'There was an error obtaining the information from Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : GEOGRAPHY(Response Body : ' + res.getBody() + ').');
					}
				}else{
					String json_response = '{';
					json_response += '			"data":';
					json_response += '				{';
					json_response += '					"cityStates":[';
					json_response += '						{';
					json_response += '							"city":"Los Angeles",';
					json_response += '							"state":"CA",';
					json_response += '							"postalCode":"90001",';
					json_response += '							"country":"USA",';
					json_response += '							"latitude":34.06336,';
					json_response += '							"longitude":-118.0';
					json_response += '						}';
					json_response += '					],';
					json_response += '					"exactMatch":true';
					json_response += '				},';
					json_response += '			"statusCode":0,';
					json_response += '			"message":"OK"';
					json_response += '		}';
					SearchCityResult search_city_result = parse(json_response);
					map_result.put('data', json_response);
					map_result.put('data_parsed', search_city_result);
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error obtaining the information from Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : GEOGRAPHY(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public void call_rate_info(){
		searchCityDestinationTruckstop();
		searchCityOriginTruckstop();
		load_filters();
		
		//NEU_TS_Call_NegotiationStrength();
		//NEU_TS_Call_HistoricalRates();
		//NEU_TS_Call_RatesIndex();
	}
	
	public void search_with_filters(){
		load_filters();
		
		NEU_TS_Call_NegotiationStrength();
	}
	
	public void search_rates(){
		load_filters();
		
		margin = '0';
		
		NEU_TS_Call_NegotiationStrength();
		NEU_TS_Call_HistoricalRates();
		NEU_TS_Call_RatesIndex();
	}
	
	public NEU_TS_WS_RateMate(){
		auth_ts_rateMate = [
			SELECT Id, Name, External_Id__c, Login__c, Password__c, Site__c
			FROM CSL_Credentials__c
			WHERE Name =: 'Truckstop RateMate' 
		];
		
		/*auth_ts_geography = [
			SELECT Id, Name, External_Id__c, Login__c, Password__c 
			FROM CSL_Credentials__c
			WHERE Name =: 'Truckstop Geography' 
		];*/
		
		response = '';
		historical_rate_result = new HistoricalRateResult();
		fuel_surcharge_result = new FuelSurchargeResult();
		rate_index_result = new RateIndexResult();
		negotiation_strength_result = new NegotiationStrengthResult();
	}
	
	public void load_filters(){
		Customer_Quote__c imp_exp;
		if (filter == null){
			filter = new Filter();
			imp_exp = new Customer_Quote__c();
		}else{
			imp_exp = new Customer_Quote__c();
			
			location_destination_truckstop = filter.Site_of_Discharge;
			location_origin_truckstop = filter.Site_of_Load;
			
			location_destination = filter.imp_exp.Site_of_Discharge__c;
			location_origin = filter.imp_exp.Site_of_Load__c;
			
			country_origin = filter.imp_exp.Country_ofLoad__c;
			country_destination = filter.imp_exp.Country_ofDischarge__c;
			
			state_origin = filter.imp_exp.State_of_Load__c;
			state_destination = filter.imp_exp.State_of_Discharge__c;
		}
		
		
		
		
		List<Country__c> country_of_load = [Select Id, Name, ISO_Code__c FROM Country__c WHERE Id =: country_origin];
		if(country_of_load.size() > 0){
			imp_exp.Country_ofLoad__c = country_of_load[0].Id;
			imp_exp.Country_ofLoad__r = country_of_load[0];
			
			List<State__c> state_of_load = [Select Id, Name, ISO_Code_2c__c FROM State__c WHERE Id =: state_origin];
			if(state_of_load.size() > 0){
				imp_exp.State_of_Load__c = state_of_load[0].Id;
				imp_exp.State_of_Load__r = state_of_load[0];
				
				List<Location__c> site_of_load = [Select Id, Name FROM Location__c WHERE Id =: location_origin];
				if(site_of_load.size() > 0){
					imp_exp.Site_of_Load__c = site_of_load[0].Id;
					imp_exp.Site_of_Load__r = site_of_load[0];
				}
			}
		}
		List<Country__c> country_of_discharge = [Select Id, Name, ISO_Code__c FROM Country__c WHERE Id =: country_destination];
		if(country_of_discharge.size() > 0){
			imp_exp.Country_ofDischarge__c = country_of_discharge[0].Id;
			imp_exp.Country_ofDischarge__r = country_of_discharge[0];
			
			List<State__c> state_of_discharge = [Select Id, Name, ISO_Code_2c__c FROM State__c WHERE Id =: state_destination];
			if(state_of_discharge.size() > 0){
				imp_exp.State_of_Discharge__c = state_of_discharge[0].Id;
				imp_exp.State_of_Discharge__r = state_of_discharge[0];
				
				List<Location__c> site_of_discharge = [Select Id, Name FROM Location__c WHERE Id =: location_destination];
				if(site_of_discharge.size() > 0){
					imp_exp.Site_of_Discharge__c = site_of_discharge[0].Id;
					imp_exp.Site_of_Discharge__r = site_of_discharge[0];
				}
			}
		}
		
		filter.imp_exp = imp_exp;
		filter.Site_of_Discharge = location_destination_truckstop;
		filter.Site_of_Load = location_origin_truckstop;
	}
	
	public void proccess_response(String xml){
		HistoricalRateResult historical_rate_result_xml = new HistoricalRateResult();
		FuelSurchargeResult fuel_surcharge_result_xml = new FuelSurchargeResult();
		RateIndexResult rate_index_result_xml = new RateIndexResult();
		NegotiationStrengthResult negotiation_strength_result_xml = new NegotiationStrengthResult();
		List<Error> lst_error_xml = new List<Error>();
		
		Map<String, String> map_props_negotiation_strength = new Map<String, String>{
			'LoadsDroppingOff' => 'Loads Dropping Off',
			'LoadsPickingUp' => 'Loads Picking Up',
			'LookingForLoads' => 'Looking For Loads',
			'NegotiationStrength' => 'Negotiation Strength',
			'TrucksAvailable' => 'Trucks Available'
		};
		
		Dom.Document doc = new Dom.Document();
		doc.load(xml);
		Dom.XMLNode node_envelope = doc.getRootElement();
		
		for(Dom.XMLNode node_body : node_envelope.getChildElements()){
			for(Dom.XMLNode node_response : node_body.getChildElements()){
				String node_response_name = (node_response.getName().contains(':') ? node_response.getName().substringAfter(':') : node_response.getName());
				if(node_response_name == 'Fault'){
					Error error_xml = new Error();
					error_xml.message = 'An error occurred while making the request, please contact the system administrator.';
					lst_error_xml.add(error_xml);
					if(historical_rate_result.lst_error == null || historical_rate_result.lst_error.size() <= 0){
						historical_rate_result.lst_error = lst_error_xml;
					}
				}else{
					for(Dom.XMLNode node_result : node_response.getChildElements()){
						if(node_result.getName() == 'GetNegotiationStrengthResult'){
							List<OriginDestinationPair> lst_origin_destination_pair_xml = new List<OriginDestinationPair>();
							
							for(Dom.XMLNode child_node_result : node_result.getChildElements()){
								String child_node_result_name = (child_node_result.getName().contains(':') ? child_node_result.getName().substringAfter(':') : child_node_result.getName());
								if(child_node_result_name == 'Errors'){
									for(Dom.XMLNode child_node_error : child_node_result.getChildElements()){
										if(lst_error_xml.size() <= 0){
											Error error_xml = new Error();
											for(Dom.XMLNode property_error : child_node_error.getChildElements()){
												String property_error_name = (property_error.getName().contains(':') ? property_error.getName().substringAfter(':') : property_error.getName());
												if(property_error_name == 'ErrorMessage'){
													error_xml.message = 'No results were found, with those filters. Please check that the name of the city is correct.';
												}
											}
											lst_error_xml.add(error_xml);
										}
									}
									
									if(historical_rate_result.lst_error == null || historical_rate_result.lst_error.size() <= 0){
										historical_rate_result.lst_error = lst_error_xml;
									}
								}
								
								if(child_node_result_name == 'LoadsDroppingOff' || child_node_result_name == 'LoadsPickingUp' || child_node_result_name == 'LookingForLoads' || child_node_result_name == 'NegotiationStrength' || child_node_result_name == 'TrucksAvailable'){
									OriginDestinationPair origin_destination_pair = new OriginDestinationPair();
									for(Dom.XMLNode property_negotiation_strength : child_node_result.getChildElements()){
										String property_negotiation_strength_name = (property_negotiation_strength.getName().contains(':') ? property_negotiation_strength.getName().substringAfter(':') : property_negotiation_strength.getName());
									
										if(property_negotiation_strength_name == 'Destination'){
											origin_destination_pair.Destination = property_negotiation_strength.getText();
										}
										if(property_negotiation_strength_name == 'Origin'){
											origin_destination_pair.Origin = property_negotiation_strength.getText();
										}
									}
									
									origin_destination_pair.Info = map_props_negotiation_strength.get(child_node_result_name);
									lst_origin_destination_pair_xml.add(origin_destination_pair);
								}
							}
							
							Boolean result_light_origin = true;
							Boolean result_light_destination = true;
							for(OriginDestinationPair origin_destination_pair : lst_origin_destination_pair_xml){
								if(origin_destination_pair.Info != 'Negotiation Strength'){
									if(origin_destination_pair.Origin != '0'){
										result_light_origin = false;
									}
									
									if(origin_destination_pair.Destination != '0'){
										result_light_destination = false;
									}
								}else{
									if(origin_destination_pair.Origin.toLowerCase().contains('bad')){
										margin = '20';
									}else{
										margin = '15';
									}
								}
							}
							
							for(OriginDestinationPair origin_destination_pair : lst_origin_destination_pair_xml){
								if(origin_destination_pair.Info == 'Negotiation Strength'){
									if(result_light_origin == true){
										origin_destination_pair.Origin = 'bad';
										margin = '20';
									}
									
									if(result_light_destination == true){
										origin_destination_pair.Destination = 'bad';
									}
								}
							}
							negotiation_strength_result_xml.lst_origin_destination_pair = lst_origin_destination_pair_xml;
							
							negotiation_strength_result = negotiation_strength_result_xml;
						}
						
						if(node_result.getName() == 'GetRateIndexResult'){
							List<Rate> lst_paid_rate_xml = new List<Rate>();
							List<Rate> lst_paid_shipper_rate_xml = new List<Rate>();
							List<Rate> lst_posted_rate_xml = new List<Rate>();
							
							for(Dom.XMLNode child_node_result : node_result.getChildElements()){
								String child_node_result_name = (child_node_result.getName().contains(':') ? child_node_result.getName().substringAfter(':') : child_node_result.getName());
								if(child_node_result_name == 'Errors'){
									for(Dom.XMLNode child_node_error : child_node_result.getChildElements()){
										if(lst_error_xml.size() <= 0){
											Error error_xml = new Error();
											for(Dom.XMLNode property_error : child_node_error.getChildElements()){
												String property_error_name = (property_error.getName().contains(':') ? property_error.getName().substringAfter(':') : property_error.getName());
												if(property_error_name == 'ErrorMessage'){
													error_xml.message = 'No results were found, with those filters. Please check that the name of the city is correct.';
												}
											}
											lst_error_xml.add(error_xml);
										}
									}
									
									if(historical_rate_result.lst_error == null || historical_rate_result.lst_error.size() <= 0){
										historical_rate_result.lst_error = lst_error_xml;
									}
								}
								
								if(child_node_result_name == 'Paid' || child_node_result_name == 'PaidShipper' || child_node_result_name == 'Posted'){
									for(Dom.XMLNode child_node_rates : child_node_result.getChildElements()){
										for(Dom.XMLNode child_node_rate : child_node_rates.getChildElements()){
											Rate rate = new Rate();
											for(Dom.XMLNode property_rate : child_node_rate.getChildElements()){
												String property_rate_name = (property_rate.getName().contains(':') ? property_rate.getName().substringAfter(':') : property_rate.getName());
											
												if(property_rate_name == 'AverageMiles'){
													rate.AverageMiles = Integer.valueOf(property_rate.getText());
												}
												if(property_rate_name == 'AverageRateToShipper'){
													rate.AverageRateToShipper = Double.valueOf(property_rate.getText());
												}
												if(property_rate_name == 'AverageRateToTrucker'){
													rate.AverageRateToTrucker = Double.valueOf(property_rate.getText());
												}
												if(property_rate_name == 'AverageTotalRate'){
													rate.AverageTotalRate = Double.valueOf(property_rate.getText());
												}
												if(property_rate_name == 'DesiredMargin'){
													rate.DesiredMargin = Double.valueOf(property_rate.getText());
												}
												if(property_rate_name == 'Days'){
													rate.Days = Integer.valueOf(property_rate.getText());
												}
												if(property_rate_name == 'NumberOfReports'){
													rate.NumberOfReports = Integer.valueOf(property_rate.getText());
												}
											}
											
											if(child_node_result_name == 'Paid'){
												lst_paid_rate_xml.add(rate);
											}
											
											if(child_node_result_name == 'PaidShipper'){
												lst_paid_shipper_rate_xml.add(rate);
											}
											
											if(child_node_result_name == 'Posted'){
												lst_posted_rate_xml.add(rate);
											}
										}
									}
								}
							}
							rate_index_result_xml.lst_paid_rate = lst_paid_rate_xml;
							rate_index_result_xml.lst_paid_shipper_rate = lst_paid_shipper_rate_xml;
							rate_index_result_xml.lst_posted_rate = lst_posted_rate_xml;
							
							rate_index_result = rate_index_result_xml;
						}
						
						if(node_result.getName() == 'GetHistoricalRatesResult'){
							for(Dom.XMLNode child_node_result : node_result.getChildElements()){
								
								String child_node_result_name = (child_node_result.getName().contains(':') ? child_node_result.getName().substringAfter(':') : child_node_result.getName());
								if(child_node_result_name == 'Errors'){
									for(Dom.XMLNode child_node_error : child_node_result.getChildElements()){
										if(lst_error_xml.size() <= 0){
											Error error_xml = new Error();
											for(Dom.XMLNode property_error : child_node_error.getChildElements()){
												String property_error_name = (property_error.getName().contains(':') ? property_error.getName().substringAfter(':') : property_error.getName());
												if(property_error_name == 'ErrorMessage'){
													error_xml.message = 'No results were found, with those filters. Please check that the name of the city is correct.';
												}
											}
											lst_error_xml.add(error_xml);
										}
									}
									
									if(historical_rate_result.lst_error == null || historical_rate_result.lst_error.size() <= 0){
										historical_rate_result.lst_error = lst_error_xml;
									}
								}
								
								if(child_node_result_name == 'History'){
									List<HistoricalRate> lst_historical_rate_xml = new List<HistoricalRate>();
									for(Dom.XMLNode child_node_historical_rate : child_node_result.getChildElements()){
										HistoricalRate historicalRate = new HistoricalRate();
										for(Dom.XMLNode property_historical_rate : child_node_historical_rate.getChildElements()){
											String property_historical_rate_name = (property_historical_rate.getName().contains(':') ? property_historical_rate.getName().substringAfter(':') : property_historical_rate.getName());
											
											if(property_historical_rate_name == 'AverageFuelCostPerMile'){
												historicalRate.AverageFuelCostPerMile = Double.valueOf(property_historical_rate.getText());
											}
											if(property_historical_rate_name == 'AverageMiles'){
												historicalRate.AverageMiles = Integer.valueOf(property_historical_rate.getText());
											}
											if(property_historical_rate_name == 'AverageRateToShipper'){
												historicalRate.AverageRateToShipper = Double.valueOf(property_historical_rate.getText());
											}
											if(property_historical_rate_name == 'AverageRateToTrucker'){
												historicalRate.AverageRateToTrucker = Double.valueOf(property_historical_rate.getText());
											}
											if(property_historical_rate_name == 'AverageTotalRate'){
												historicalRate.AverageTotalRate = Double.valueOf(property_historical_rate.getText());
											}
											if(property_historical_rate_name == 'DesiredMargin'){
												historicalRate.DesiredMargin = Double.valueOf(property_historical_rate.getText());
											}
											if(property_historical_rate_name == 'Month'){
												historicalRate.Month = Integer.valueOf(property_historical_rate.getText());
											}
											if(property_historical_rate_name == 'Year'){
												historicalRate.Year = Integer.valueOf(property_historical_rate.getText());
											}
										}
										
										if(historicalRate.Year == year){
											lst_historical_rate_xml.add(historicalRate);
										}else{
											if(historicalRate.Year == (year -1) && historicalRate.Month > month){
												lst_historical_rate_xml.add(historicalRate);
											}
										}
									}
									historical_rate_result_xml.lst_historical_rate = lst_historical_rate_xml;
								}
							}
							historical_rate_result = historical_rate_result_xml;
						}
						
						if(node_result.getName() == 'GetFuelSurchargeResult'){
							List<FuelSurcharge> lst_fuel_surcharge_xml = new List<FuelSurcharge>();
							FuelSurcharge fuel_surcharge_xml = new FuelSurcharge();
							for(Dom.XMLNode child_node_result : node_result.getChildElements()){
								
								String child_node_result_name = (child_node_result.getName().contains(':') ? child_node_result.getName().substringAfter(':') : child_node_result.getName());
								if(child_node_result_name == 'Errors'){
									for(Dom.XMLNode child_node_error : child_node_result.getChildElements()){
										if(lst_error_xml.size() <= 0){
											Error error_xml = new Error();
											for(Dom.XMLNode property_error : child_node_error.getChildElements()){
												String property_error_name = (property_error.getName().contains(':') ? property_error.getName().substringAfter(':') : property_error.getName());
												if(property_error_name == 'ErrorMessage'){
													error_xml.message = 'No results were found, with those filters. Please check that the name of the city is correct.';
												}
											}
											lst_error_xml.add(error_xml);
										}
									}
									
									if(historical_rate_result.lst_error == null || historical_rate_result.lst_error.size() <= 0){
										historical_rate_result.lst_error = lst_error_xml;
									}
								}
								
								if(child_node_result_name == 'BaseLineFuelPrice'){
									fuel_surcharge_xml.BaseLineFuelPrice = Decimal.valueOf(child_node_result.getText());
								}
								
								if(child_node_result_name == 'EstimatedFuelCost'){
									fuel_surcharge_xml.EstimatedFuelCost = Decimal.valueOf(child_node_result.getText());
								}
								
								if(child_node_result_name == 'EstimatedFuelCostPerMile'){
									fuel_surcharge_xml.EstimatedFuelCostPerMile = Decimal.valueOf(child_node_result.getText());
								}
								
								if(child_node_result_name == 'FuelPricePerGallon'){
									fuel_surcharge_xml.FuelPricePerGallon = Decimal.valueOf(child_node_result.getText());
								}
								
								if(child_node_result_name == 'MilesPerGallon'){
									fuel_surcharge_xml.MilesPerGallon = Decimal.valueOf(child_node_result.getText());
								}
								
								if(child_node_result_name == 'SurchargePerMile'){
									fuel_surcharge_xml.SurchargePerMile = Decimal.valueOf(child_node_result.getText());
								}
								
								if(child_node_result_name == 'SurchargeTotal'){
									fuel_surcharge_xml.SurchargeTotal = Decimal.valueOf(child_node_result.getText());
								}
								
								if(child_node_result_name == 'TotalMiles'){
									fuel_surcharge_xml.TotalMiles = Decimal.valueOf(child_node_result.getText());
								}
							}
							lst_fuel_surcharge_xml.add(fuel_surcharge_xml);
							fuel_surcharge_result_xml.lst_fuel_surcharge = lst_fuel_surcharge_xml;
							fuel_surcharge_result = fuel_surcharge_result_xml;
						}
					}
				}
			}
		}
	}
	
	public List<Error> process_errors(Dom.XmlNode child_node_result){
		List<Error> lst_error_xml = new List<Error>();
		
		return lst_error_xml;
	}
	
	public class FuelSurchargeResult {
		public List<FuelSurcharge> lst_fuel_surcharge{
			get{
				if(lst_fuel_surcharge == null){
					lst_fuel_surcharge = new List<FuelSurcharge>();
				}
				return lst_fuel_surcharge;
			}
			set;
		}
		public List<Error> lst_error{
			get{
				if(lst_error == null){
					lst_error = new List<Error>();
				}
				return lst_error;
			}
			set;
		}
	}
	
	public class HistoricalRateResult{
		public List<HistoricalRate> lst_historical_rate{
			get{
				if(lst_historical_rate == null){
					lst_historical_rate = new List<HistoricalRate>();
				}
				return lst_historical_rate;
			}
			set;
		}
		public List<Error> lst_error{
			get{
				if(lst_error == null){
					lst_error = new List<Error>();
				}
				return lst_error;
			}
			set;
		}
	}
	
	public class RateIndexResult{
		public List<Error> lst_error{
			get{
				if(lst_error == null){
					lst_error = new List<Error>();
				}
				return lst_error;
			}
			set;
		}
		public List<Rate> lst_paid_rate{
			get{
				if(lst_paid_rate == null){
					lst_paid_rate = new List<Rate>();
				}
				return lst_paid_rate;
			}
			set;
		}
		public List<Rate> lst_paid_shipper_rate{
			get{
				if(lst_paid_shipper_rate == null){
					lst_paid_shipper_rate = new List<Rate>();
				}
				return lst_paid_shipper_rate;
			}
			set;
		}
		public List<Rate> lst_posted_rate{
			get{
				if(lst_posted_rate == null){
					lst_posted_rate = new List<Rate>();
				}
				return lst_posted_rate;
			}
			set;
		}
	}
	
	public class NegotiationStrengthResult{
		public List<Error> lst_error{
			get{
				if(lst_error == null){
					lst_error = new List<Error>();
				}
				return lst_error;
			}
			set;
		}
		public List<OriginDestinationPair> lst_origin_destination_pair{
			get{
				if(lst_origin_destination_pair == null){
					lst_origin_destination_pair = new List<OriginDestinationPair>();
				}
				return lst_origin_destination_pair;
			}
			set;
		}
	}
	
	public class OriginDestinationPair{
		public String Info{get;set;}
		public String Destination{get;set;}
		public String Origin{get;set;}
	}
	
	public class Rate {
		public Integer AverageMiles{get;set;}
		public Double AverageRateToShipper{get;set;}
		public Double AverageRateToTrucker{get;set;}
		public Double AverageTotalRate{get;set;}
		public Integer Days{get;set;}
		public Double DesiredMargin{get;set;}
		public Integer NumberOfReports{get;set;}
		
		public Double AverageTotalRateMargin{
			get{
				AverageTotalRateMargin = AverageTotalRate * (1 + (DesiredMargin/100));
				return AverageTotalRateMargin;
			}
			set;
		}
	}
	
	public class HistoricalRate {
		public Double AverageFuelCostPerMile{get;set;}
		public Integer AverageMiles{get;set;}
		public Double AverageRateToShipper{get;set;}
		public Double AverageRateToTrucker{get;set;}
		public Double AverageTotalRate{get;set;}
		public Double DesiredMargin{get;set;}
		public Integer Month{get;set;}
		public Integer Year{get;set;}
		
		public Double AverageTotalRateMargin{
			get{
				AverageTotalRateMargin = AverageTotalRate * (1 + (DesiredMargin/100));
				return AverageTotalRateMargin;
			}
			set;
		}
	}
	
	public class FuelSurcharge {
		public Decimal BaseLineFuelPrice{get;set;}
		public Decimal EstimatedFuelCost{get;set;}
		public Decimal EstimatedFuelCostPerMile{get;set;}
		public Decimal FuelPricePerGallon{get;set;}
		public Decimal MilesPerGallon{get;set;}
		public Decimal SurchargePerMile{get;set;}
		public Decimal SurchargeTotal{get;set;}
		public Decimal TotalMiles{get;set;}
	}
	
	
	public class Error {
		public String message{get;set;}
		public List<String> lst_suggestions{get;set;}
	}



	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class SearchCityResult {
		public SearchCityResultDetail data {get;set;} 
		public Integer statusCode {get;set;} 
		public String message {get;set;} 

		public SearchCityResult(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'data') {
							data = new SearchCityResultDetail(parser);
						} else if (text == 'statusCode') {
							statusCode = parser.getIntegerValue();
						} else if (text == 'message') {
							message = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CityStates {
		public String city {get;set;} 
		public String state {get;set;} 
		public String postalCode {get;set;} 
		public String country {get;set;} 
		public Double latitude {get;set;} 
		public Double longitude {get;set;} 

		public CityStates(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'postalCode') {
							postalCode = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getDoubleValue();
						} else if (text == 'longitude') {
							longitude = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CityStates consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SearchCityResultDetail {
		public List<CityStates> cityStates {get;set;} 
		public Boolean exactMatch {get;set;} 

		public SearchCityResultDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'cityStates') {
							cityStates = new List<CityStates>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								cityStates.add(new CityStates(parser));
							}
						} else if (text == 'exactMatch') {
							exactMatch = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SearchCityResult parse(String json) {
		return new SearchCityResult(System.JSON.createParser(json));
	}



}