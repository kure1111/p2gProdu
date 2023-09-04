public with sharing class NEU_TS_WS_Tracking{
	
	/* ----------------------------------------------------- CONSTRUCTOR ----------------------------------------------------- */
	
	public NEU_TS_WS_Tracking(){}
	
	
	
	/* ----------------------------------- --------------- ADDRESS CALLS ----------------------------------------------------- */
	
	public static Map<String, Object> validateAddress(String address, Map<String, String> map_ids, String point){
		system.debug('TRUCKSTOP INTEGRATION : VALIDATE ADDRESS');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			Map<String, String> map_body = new Map<String, String>();
			if(address != null){
				if(address != ''){
					map_body.put('Address', address);
				}
			}
			if(point == 'Stop'){ 
				if(map_ids.get('countryID') != null){
					List<Country__c> lst_country = [
						SELECT Id, Name, ISO_Code__c
						FROM Country__c
						WHERE Id =: map_ids.get('countryID')
					];
					map_body.put('Country', lst_country[0].Name);
				}else{
					map_body.put('Country', map_ids.get('country'));
				}
				
				if(map_ids.get('stateID') != null){
					List<State__c> lst_state = [
						SELECT Id, Name, ISO_Code_2c__c
						FROM State__c
						WHERE Id =: map_ids.get('stateID')
					];
					map_body.put('State', lst_state[0].Name);
				}else{
					map_body.put('State', map_ids.get('state'));
				}
				
				if(map_ids.get('locationID') != null){
					List<Location__c> lst_location = [
						SELECT Id, Name
						FROM Location__c
						WHERE Id =: map_ids.get('locationID')
					];
					map_body.put('City', lst_location[0].Name);
				}else{
					map_body.put('City', map_ids.get('location'));
				}
			}
			
			if(point == 'Origin' || point == 'Destination'){
				if(map_ids.get('countryID') != null){
					List<Country__c> lst_country = [
						SELECT Id, Name, ISO_Code__c
						FROM Country__c
						WHERE Id =: map_ids.get('countryID')
					];
					map_body.put('Country', lst_country[0].Name);
				}else{
					map_body.put('Country', map_ids.get('country'));
				}
				
				if(map_ids.get('stateID') != null){
					List<State__c> lst_state = [
						SELECT Id, Name, ISO_Code_2c__c
						FROM State__c
						WHERE Id =: map_ids.get('stateID')
					];
					map_body.put('State', lst_state[0].Name);
				}else{
					map_body.put('State', map_ids.get('state'));
				}
				
				if(map_ids.get('locationID') != null){
					List<Location__c> lst_location = [
						SELECT Id, Name
						FROM Location__c
						WHERE Id =: map_ids.get('locationID')
					];
					map_body.put('City', lst_location[0].Name);
				}else{
					map_body.put('City', map_ids.get('location'));
				}
				
				if(map_ids.get('shipmentID') != null){
					List<Shipment__c> lst_shipment = [
						SELECT Id, Name, 
							Site_of_Load__c, Site_of_Load__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name, 
							State_of_Load__c, State_of_Load__r.Name, State_of_Load__r.ISO_Code_2c__c, 
							State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Discharge__r.ISO_Code_2c__c, 
							Country_of_Load__c, Country_of_Load__r.Name, Country_of_Load__r.ISO_Code__c, 
							Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Discharge__r.ISO_Code__c
						FROM Shipment__c
						WHERE Id =: map_ids.get('shipmentID')
					];
					
					if(point == 'Origin'){
						map_body.put('City', lst_shipment[0].Site_of_Load__r.Name);
						map_body.put('State', lst_shipment[0].State_of_Load__r.Name);
						map_body.put('Country', lst_shipment[0].Country_of_Load__r.Name);
					}else if(point == 'Destination'){
						map_body.put('City', lst_shipment[0].Site_of_Discharge__r.Name);
						map_body.put('State', lst_shipment[0].State_of_Discharge__r.Name);
						map_body.put('Country', lst_shipment[0].Country_of_Discharge__r.Name);
					}
				}
			}
			
			
			
			
			
			
			String json_request_body = JSON.serialize(map_body);
			map_result.put('json_request', json_request_body);
			system.debug('TRUCKSTOP INTEGRATION : VALIDATE ADDRESS (Request Body : ' + json_request_body + ')');
			
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint('callout:Truckstop_Tracking/domaindata/location/');
				req.setHeader('Content-Type', 'application/json');
				req.setBody(json_request_body);
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackLocationResponse trackLocationResponse = parse_track_location_response(res.getBody());
					if(trackLocationResponse.statusCode != 0){
						map_result.put('error', 'There was an error obtaining the information from Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : VALIDATE ADDRESS(Response Body : ' + res.getBody() + ').');
					}else{
						system.debug('TRUCKSTOP INTEGRATION : VALIDATE ADDRESS(Response Body : ' + res.getBody() + ').');
						map_result.put('data', res.getBody());
						map_result.put('data_parsed', trackLocationResponse);
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error obtaining the information from Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : VALIDATE ADDRESS(Response Body : ' + res.getBody() + ').');
				}
			}else{
				String json_response = '{"data":{"address":"1313 Disneyland Dr","city":"Anaheim","state":"CA","zip":"92802","country":"USA","latitude":33.8153047,"longitude":-117.9262072,"timezone":"Pacific Daylight Time"},"statusCode":0,"message":"OK"}';
				TrackLocationResponse trackLocationResponse = parse_track_location_response(json_response);
				map_result.put('data', json_response);
				map_result.put('data_parsed', trackLocationResponse);
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error obtaining the information from Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : VALIDATE ADDRESS(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	
	
	/* ----------------------------------- ----------------- DATA CALLS ------------------------------------------------------ */
	
	public static Map<String, Object> getTrack(String tracking_number){
		//system.debug('TRUCKSTOP INTEGRATION : GET TRACK(Tracking Number' + tracking_number + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('GET');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number);
				req.setHeader('Content-Type', 'application/json');
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackResponse trackResponse = parse_track_response(res.getBody());
					if(trackResponse.statusCode != 0){
						map_result.put('error', 'There was an error obtaining the information from Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : GET TRACK(Response Body : ' + res.getBody() + ').');
					}else{
						system.debug('TRUCKSTOP INTEGRATION : GET TRACK(Response Body : ' + res.getBody() + ').');
						map_result.put('data', trackResponse);
					}
				}else if(res.getStatusCode() != 200){
					if(res.getStatusCode() == 401){
						map_result.put('error', 'Unauthorized request.');
						system.debug('TRUCKSTOP INTEGRATION : GET TRACK(Response Body : ' + res.getBody() + ').');
					}else{
						map_result.put('error', 'There was an error obtaining the information from Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : GET TRACK(Response Body : ' + res.getBody() + ').');
					}
				}
			}else{
				String json_reponse = getTrackResponseExample();
				TrackResponse trackResponse = parse_track_response(json_reponse);
				map_result.put('data', trackResponse);
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error obtaining the information from Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : GET TRACK(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> getLinkTrack(String tracking_number){
		//system.debug('TRUCKSTOP INTEGRATION : GET TRACK(Tracking Number' + tracking_number + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('GET');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/link');
				req.setHeader('Content-Type', 'application/json');
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackLinkResponseHTTP trackLinkResponse = parse_track_link_response(res.getBody());
					if(trackLinkResponse.statusCode != 0){
						map_result.put('error', 'There was an error obtaining the information from Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : GET LINK(Response Body : ' + res.getBody() + ').');
					}else{
						system.debug('TRUCKSTOP INTEGRATION : GET LINK(Response Body : ' + res.getBody() + ').');
						map_result.put('data', trackLinkResponse);
					}
				}else if(res.getStatusCode() != 200){
					if(res.getStatusCode() == 401){
						map_result.put('error', 'Unauthorized request.');
						system.debug('TRUCKSTOP INTEGRATION : GET LINK(Response Body : ' + res.getBody() + ').');
					}else{
						map_result.put('error', 'There was an error obtaining the information from Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : GET LINK(Response Body : ' + res.getBody() + ').');
					}
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error obtaining the information from Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : GET LINK(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> createTrack(Shipment__c shipment, Shipment_Track__c shipment_track, List<Shipment_Stop__c> lst_shipment_stop){
		system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(Reference Id:' + shipment.Name + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			String json_request_body = serialize_for_create(shipment, shipment_track, lst_shipment_stop);
			map_result.put('json_request', json_request_body);
			system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(Request Body : ' + json_request_body + ').');
			
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint('callout:Truckstop_Tracking/track/');
				req.setHeader('Content-Type', 'application/json');
				req.setBody(json_request_body);
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackCreateResponse trackCreateResponse = parse_track_create_response(res.getBody());
					if(trackCreateResponse.statusCode != 0){
						map_result.put('error', 'There was an error creating the track in Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(Response Body : ' + res.getBody() + ').');
					}else{
						map_result = getTrack(trackCreateResponse.trackCreateDetail.trackingNumber);
						
                        Map<String, Object> map_resul_link = getLinkTrack(trackCreateResponse.trackCreateDetail.trackingNumber);
                        TrackLinkResponseHTTP track_link = (TrackLinkResponseHTTP) map_resul_link.get('data');
                        
						shipment_track.Current_Status__c = 'Requested';
						shipment_track.Shipment__c = shipment.Id;
						shipment_track.Reference_Id__c = trackCreateResponse.trackCreateDetail.referenceId;
						shipment_track.Name = trackCreateResponse.trackCreateDetail.trackingNumber;
                        shipment_track.Public_Sharing_URL__c = track_link.trackLink.link;
						
						insert shipment_track;
						if(lst_shipment_stop != null){
							update lst_shipment_stop;
						}
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error creating the track in Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(Response Body : ' + res.getBody() + ').');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error creating the track in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		return map_result;
	}
	
	public static Map<String, Object> resubmitTrack(String tracking_number){
		system.debug('TRUCKSTOP INTEGRATION : RESUBMIT TRACK(Tracking Number:' + tracking_number + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/resubmit');
				req.setHeader('Content-Type', 'application/json');
				//req.setHeader('Content-Length', '0');
				req.setBody('');
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackCreateResponse trackCreateResponse = parse_track_create_response(res.getBody());
					if(trackCreateResponse.statusCode != 0){
						map_result = getTrack(tracking_number);
						map_result.put('json_response', res.getBody());
						map_result.put('error', 'There was an error resubmiting the track in Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : RESUBMIT TRACK(Response Body : ' + res.getBody() + ').');
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error resubmiting the track in Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : RESUBMIT TRACK(Response Body : ' + res.getBody() + ').');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error resubmiting the track in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : RESUBMIT TRACK(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> cancelTrack(String tracking_number, String message){
		system.debug('TRUCKSTOP INTEGRATION : CANCEL TRACK(Tracking Number:' + tracking_number + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/cancel');
				req.setHeader('Content-Type', 'application/json');
				req.setBody('{"Message":"' + message + '"}');
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				
				if(res.getStatusCode() == 200){
					TrackResponse trackResponse = parse_track_response(res.getBody());
					if(trackResponse.statusCode != 0){
						map_result.put('error', 'There was an error canceling the track in Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : CANCEL TRACK(Response Body : ' + res.getBody() + ').');
					}else{
						map_result.put('data', trackResponse);
						system.debug('TRUCKSTOP INTEGRATION : CANCEL TRACK(Response Body : ' + res.getBody() + ').');
						List<Shipment_Track__c> lst_shipment_track = [Select Id, Name, Current_Status__c FROM Shipment_Track__c where Name =: tracking_number];
						if(lst_shipment_track.size() > 0){
							lst_shipment_track[0].Current_Status__c = 'Cancelled';
							update lst_shipment_track;
						}
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error canceling the track in Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : CANCEL TRACK(Response Body : ' + res.getBody() + ').');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error canceling the track in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : CANCEL TRACK(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> getDocument(String tracking_number, String documentId){
		system.debug('TRUCKSTOP INTEGRATION : GET DOCUMENT(Tracking Number:' + tracking_number + ' - Document Id: ' + documentId + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('GET');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/document/' + documentId);
				req.setHeader('Content-Type','application/x-www-form-urlencoded');
				
				Http http = new Http();
				HttpResponse res = http.send(req);
				
				if(res.getStatusCode() == 200){
					//TrackResponse trackResponse = parse_track_response(res.getBody());
					//if(trackResponse.statusCode != 0){
					//	map_result.put('error', 'There was an error getting the document in Truckstop.');
					//}else{
						map_result.put('data', res.getBodyAsBlob());
					//}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error getting the document in Truckstop.');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error getting the document in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : GET DOCUMENT(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> deleteDocument(String tracking_number, String documentId){
		system.debug('TRUCKSTOP INTEGRATION : DELETE DOCUMENT(Tracking Number:' + tracking_number + ' - Document Id: ' + documentId + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('DELETE');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/document/' + documentId);
				req.setHeader('Content-Type','application/x-www-form-urlencoded');
				
				Http http = new Http();
				HttpResponse res = http.send(req);
				String json_response = res.getBody();
				system.debug('TRUCKSTOP INTEGRATION : DELETE DOCUMENT(Response Body:' + res.getBody() + ').');
				if(res.getStatusCode() == 200){
					Map<String, String> map_response = new Map<String, String>();
					JSONParser parser = System.JSON.createParser(json_response);
					while (parser.nextToken() != JSONToken.END_OBJECT) {
						if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
							String text = parser.getText();
							if (parser.nextToken() != JSONToken.VALUE_NULL) {
								if (text == 'data') {
									map_response.put('data', parser.getText());
								} else if (text == 'statusCode') {
									map_response.put('statusCode', parser.getText());
								} else if (text == 'message') {
									map_response.put('message', parser.getText());
								} else {
									System.debug(LoggingLevel.WARN, 'TrackResponse consuming unrecognized property: '+text);
									consumeObject(parser);
								}
							}
						}
					}
					if(map_response.get('statusCode') != '0'){
						map_result.put('error', 'There was an error deleting the document in Truckstop.');
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error deleting the document in Truckstop.');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error deleting the document in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : DELETE DOCUMENT(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> uploadDocumentTS(Map<String, String> map_documento, String tracking_number){
		system.debug('TRUCKSTOP INTEGRATION : UPLOAD DOCUMENT(Tracking Number:' + tracking_number + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			Map<String, String> params = new Map<String, String> {
				'DocumentType' => map_documento.get('type'),
				'SendNotification'=>'false'
			};
			
			String boundary ='__boundary__xxx';
			String footer = '\r\n--'+boundary+'--';
			String header = '';
			for(String key: params.keySet()) {
				header += '--' + boundary + '\r\n' + 'Content-Disposition: form-data; name="' + key + '"'+ '\r\n' + '\r\n' + params.get(key) + '\r\n';
			}
			header += '--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="'+ map_documento.get('name') +'"\r\nContent-Type: application/octet-stream'; // added '\r's removed ';' see Tim Smith's comment
			while(EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n')).endsWith('=')){
				header+=' ';
			}
			
			String bodyEncoded =  map_documento.get('body') ;
			String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
			String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));

			Blob bodyBlob = null;
			String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
			if(last4Bytes.endsWith('=')){
				Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
				HttpRequest tmp = new HttpRequest();
				tmp.setBodyAsBlob(decoded4Bytes);
				String last4BytesFooter = tmp.getBody()+footer;
				bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded.substring(0,bodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
			}else{
				bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
			}
			
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/document');
				req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
				req.setBodyAsBlob(bodyBlob);
				
				
				Http http = new Http();
				HttpResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				
				if(res.getStatusCode() == 200){
					TrackDocumentResponse trackDocumentResponse = parse_track_document_response(res.getBody());
					if(trackDocumentResponse.statusCode != 0){
						map_result.put('error', 'There was an error uploading the document in Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : UPLOAD DOCUMENT(Response Body : ' + res.getBody() + ').');
					}else{
						map_result.put('json_response', res.getBody());
						map_result.put('data_document', trackDocumentResponse);
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error uploading the document in Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : UPLOAD DOCUMENT(Response Body : ' + res.getBody() + ').');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error uploading the document in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : UPLOAD DOCUMENT(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> addNote(String note, String tracking_number){
		system.debug('TRUCKSTOP INTEGRATION : ADD NOTE(Tracking Number:' + tracking_number + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/note');
				req.setHeader('Content-Type', 'application/json');
				req.setBody('{"Message":"' + note + '"}');
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackResponse trackResponse = parse_track_response(res.getBody());
					if(trackResponse.statusCode != 0){
						map_result.put('error', 'There was an error adding note in Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : ADD NOTE(Response Body : ' + res.getBody() + ').');
					}else{
						map_result.put('data', trackResponse);
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error adding note in Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : ADD NOTE(Response Body : ' + res.getBody() + ').');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error adding note in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : ADD NOTE(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> requestNewDriver(Shipment__c shipment, String tracking_number){
		system.debug('TRUCKSTOP INTEGRATION : ADD NOTE(Tracking Number:' + tracking_number + ').');
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		String json_request_body = serialize_for_request_new_driver(shipment);
		map_result.put('json_request', json_request_body);
		system.debug('TRUCKSTOP INTEGRATION : REQUEST NEW DRIVER(Request Body : ' + json_request_body + ').');
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+tracking_number+'/driver');
				req.setHeader('Content-Type', 'application/json');
				req.setBody(json_request_body);
				
	
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackResponse trackResponse = parse_track_response(res.getBody());
					if(trackResponse.statusCode != 0){
						map_result.put('error', 'There was an error requesting the new driver for track in Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : REQUEST NEW DRIVER(Response Body : ' + res.getBody() + ').');
					}else{
						map_result.put('data', trackResponse);
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error requesting the new driver for track in Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : REQUEST NEW DRIVER(Response Body : ' + res.getBody() + ').');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error requesting the new driver for track in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : REQUEST NEW DRIVER(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> updateTrack(Shipment__c shipment, Shipment_Track__c shipment_track, List<Shipment_Stop__c> lst_shipment_stop){
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		
		String json_request_body = serialize_for_update(shipment, shipment_track, lst_shipment_stop);
		map_result.put('json_request', json_request_body);
		system.debug('TRUCKSTOP INTEGRATION : UPDATE TRACKING(Request Body : ' + json_request_body + ').');
		
		try{
			if(!Test.isRunningTest()){
				HttpRequest req = new HttpRequest();
				req.setMethod('PUT');
				req.setEndpoint('callout:Truckstop_Tracking/track/'+shipment_track.Name);
				req.setHeader('Content-Type', 'application/json');
				req.setBody(json_request_body);
				
				Http http = new Http();
				HTTPResponse res = http.send(req);
				map_result.put('json_response', res.getBody());
				if(res.getStatusCode() == 200){
					TrackResponse trackResponse = parse_track_response(res.getBody());
					if(trackResponse.statusCode != 0){
						map_result.put('error', 'Error updating track in Truckstop.');
						system.debug('TRUCKSTOP INTEGRATION : UPDATE TRACKING(Response Body : ' + res.getBody() + ').');
					}else{
						map_result.put('data', trackResponse);
						update shipment_track;
						if(lst_shipment_stop != null){
							update lst_shipment_stop;
						}
					}
				}else if(res.getStatusCode() != 200){
					map_result.put('error', 'There was an error updating the track in Truckstop.');
					system.debug('TRUCKSTOP INTEGRATION : UPDATE TRACKING(Response Body : ' + res.getBody() + ').');
				}
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error updating the track in Truckstop.');
			system.debug('TRUCKSTOP INTEGRATION : UPDATE TRACKING(ERROR : ' +  + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString() + ').');
		}
		
		return map_result;
	}
	
	public static Map<String, Object> updateTrackAndNewDriver(Shipment__c shipment, Shipment_Track__c shipment_track, List<Shipment_Stop__c> lst_shipment_stop){
		Map<String, Object> map_result = new Map<String, Object>{'error' => null};
		try{
			map_result = requestNewDriver(shipment, shipment_track.Name);
			if(map_result.get('error') == null){
				map_result = updateTrack(shipment, shipment_track, lst_shipment_stop);
			}
		}catch(Exception e){
			map_result.put('error', 'There was an error updating the track in Truckstop.');
		}
		
		return map_result;
	}
	
	
	
	/* ------------------------------------------ SERIALIZE MAPS TO JSON FOR CALLS ------------------------------------------- */
	
	public static String serialize_for_request_new_driver(Shipment__c shipment){
		Boolean data_completed = true;
		Map<String, String> map_info = new Map<String, String>();
		
		// Comprobamos que los parametros obligatorios para crear el Track en Truckstop estan rellenos.
		if(shipment.National_Operator__c == null){
			data_completed = false;
		}else{
			List<Operadores__c> operador = [
				SELECT Id, Name, Truckstop_Name__c, Truckstop_Email__c, Truckstop_Phone__c
				FROM Operadores__c
				WHERE Id =: shipment.National_Operator__c
			];
			
			if(operador.size() > 0){
				if(operador[0].Truckstop_Email__c != null || operador[0].Truckstop_Phone__c != null){
					if(operador[0].Truckstop_Name__c != null){
						map_info.put('operador_name', operador[0].Truckstop_Name__c);
					}
					map_info.put('operador_email', operador[0].Truckstop_Email__c);
					map_info.put('operador_phone', operador[0].Truckstop_Phone__c);
				}else{
					data_completed = false;
				}
			}
		}
		
		if(data_completed == false){
			system.debug('TRUCKSTOP INTEGRATION : REQUEST NEW DRIVER(No cumplimos los requisitos para pedir el nuevo conductor).');
		}else{
			system.debug('TRUCKSTOP INTEGRATION : REQUEST NEW DRIVER(Cumplimos los requisitos para pedir el nuevo conductor).');
			
			Map<String, Object> map_data = new Map<String, Object>();
			
			Map<String, Object> map_data_driver = new Map<String, Object>();
			if(map_info.get('operador_name') != null){
				map_data_driver.put('Name', map_info.get('operador_name'));
			}
			if(map_info.get('operador_phone') != null || map_info.get('operador_email') != null){
				if(map_info.get('operador_phone') != null){
					map_data_driver.put('PhoneOrEmail', map_info.get('operador_phone'));
				}else{
					map_data_driver.put('PhoneOrEmail', map_info.get('operador_email'));
				}
			}
			map_data.put('Driver', map_data_driver);
			
			String json_request_body = JSON.serialize(map_data);
			return json_request_body;
		}
		return null;
	}
	
	public static String serialize_for_create(Shipment__c shipment, Shipment_Track__c shipment_track, List<Shipment_Stop__c> lst_shipment_stop){
		Boolean data_completed = true;
		Map<String, String> map_info = new Map<String, String>();
		// Comprobamos que los parametros obligatorios para crear el Track en Truckstop estan rellenos.
				
		if(shipment.National_Operator__c == null){
			data_completed = false;
		}else{
			List<Operadores__c> operador = [
				SELECT Id, Name, Truckstop_Name__c, Truckstop_Email__c, Truckstop_Phone__c
				FROM Operadores__c
				WHERE Id =: shipment.National_Operator__c
			];
			
			if(operador.size() > 0){
				if(operador[0].Truckstop_Email__c != null || operador[0].Truckstop_Phone__c != null){
					if(operador[0].Truckstop_Name__c != null){
						map_info.put('operador_name', operador[0].Truckstop_Name__c);
					}
					map_info.put('operador_email', operador[0].Truckstop_Email__c);
					map_info.put('operador_phone', operador[0].Truckstop_Phone__c);
				}else{
					data_completed = false;
				}
			}
		}
		
		if(shipment.ETA_Point_of_Discharge__c == null){
			data_completed = false;
		}else if(shipment.ETD_from_Point_of_Load__c == null){
			data_completed = false;
		}
		
		if(data_completed == false){
			system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(No cumplimos los requisitos para crear el Track).');
		}else{
			system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(Cumplimos los requisitos para crear el Track).');
			
			// Construimos el json que ira en el body de nuestro http request
			DateTime ETD = DateTime.newInstance(shipment.ETD_from_Point_of_Load__c.year(), shipment.ETD_from_Point_of_Load__c.month(), shipment.ETD_from_Point_of_Load__c.day(), shipment.ETD_Time_from_Point_of_Load__c.hour(), shipment.ETD_Time_from_Point_of_Load__c.minute(), 00);
			DateTime ETA = DateTime.newInstance(shipment.ETA_Point_of_Discharge__c.year(), shipment.ETA_Point_of_Discharge__c.month(), shipment.ETA_Point_of_Discharge__c.day(), shipment.ETA_Time_Point_of_Discharge__c.hour(), shipment.ETA_Time_Point_of_Discharge__c.minute(), 00);
			Map<String, Object> map_data = new Map<String, Object>();
			
			Map<String, Object> map_data_driver = new Map<String, Object>();
			if(map_info.get('operador_name') != null){
				map_data_driver.put('Name', map_info.get('operador_name'));
			}
			if(map_info.get('operador_phone') != null || map_info.get('operador_email') != null){
				if(map_info.get('operador_phone') != null){
					map_data_driver.put('PhoneOrEmail', map_info.get('operador_phone'));
				}else{
					map_data_driver.put('PhoneOrEmail', map_info.get('operador_email'));
				}
			}
			map_data.put('Driver', map_data_driver);
			
			Map<String, Object> map_data_origin = new Map<String, Object>();
			map_data_origin.put('country', shipment_track.Truckstop_Origin_Country_Code__c);
			map_data_origin.put('state', shipment_track.Truckstop_Origin_State_Code__c);
			map_data_origin.put('city', shipment_track.Truckstop_Origin_City__c);
			if(shipment_track.Truckstop_Origin_Postal_Code__c != null){
				if(shipment_track.Truckstop_Origin_Postal_Code__c != ''){
					map_data_origin.put('zip', shipment_track.Truckstop_Origin_Postal_Code__c);
				}
			}
			map_data_origin.put('address', (shipment_track.Truckstop_Origin_Address__c != null ? shipment_track.Truckstop_Origin_Address__c : ''));
			map_data_origin.put('eventDateTime', String.valueOf(ETD).replace(' ', 'T') + '-06:00');
			//map_data_origin.put('timezone', 'Central Standard Time');
			map_data.put('Origin', map_data_origin);
			
			Map<String, Object> map_data_destination = new Map<String, Object>();
			map_data_destination.put('country', shipment_track.Truckstop_Destination_Country_Code__c);
			map_data_destination.put('state', shipment_track.Truckstop_Destination_State_Code__c);
			map_data_destination.put('city', shipment_track.Truckstop_Destination_City__c);
			if(shipment_track.Truckstop_Destination_Postal_Code__c != null){
				if(shipment_track.Truckstop_Destination_Postal_Code__c != ''){
					map_data_destination.put('zip', shipment_track.Truckstop_Destination_Postal_Code__c);
				}
			}
			map_data_destination.put('address', (shipment_track.Truckstop_Destination_Address__c != null ? shipment_track.Truckstop_Destination_Address__c : ''));
			map_data_destination.put('eventDateTime', String.valueOf(ETA).replace(' ', 'T') + '-06:00');
			//map_data_destination.put('timezone', 'Central Standard Time');
			map_data.put('Destination', map_data_destination);
			
			if(lst_shipment_stop != null){
				if(lst_shipment_stop.size() > 0){
					List<Map<String, Object>> lst_map_additional_stops = new List<Map<String, Object>>();
					for(Shipment_Stop__c shipment_stop : lst_shipment_stop){
						Map<String, Object> map_additional_stop = new Map<String, Object>();
						map_additional_stop.put('country', shipment_stop.Truckstop_Country_Code__c);
						map_additional_stop.put('state', shipment_stop.Truckstop_State_Code__c);
						map_additional_stop.put('city', shipment_stop.Truckstop_City__c);
						if(shipment_stop.Truckstop_Postal_Code__c != null){
							if(shipment_stop.Truckstop_Postal_Code__c != ''){
								map_additional_stop.put('zip', shipment_stop.Truckstop_Postal_Code__c);
							}
						}
						map_additional_stop.put('address', (shipment_stop.Truckstop_Address__c != null ? shipment_stop.Truckstop_Address__c : ''));
						map_additional_stop.put('eventDateTime', String.valueOf(shipment_stop.Estimated_Time_of_Arrival__c).replace(' ', 'T') + '-06:00');
						map_additional_stop.put('timezone', 'Central Standard Time');
						lst_map_additional_stops.add(map_additional_stop);
					}
					if(lst_map_additional_stops.size() > 0){
						map_data.put('AdditionalStops',lst_map_additional_stops);
					}
				}
			}
			map_data.put('Note','Auto Generated TrackRequest');
			map_data.put('ReferenceId', shipment.Name);
			map_data.put('ValidateAddress', true);
			String json_request_body = JSON.serialize(map_data); 
			system.debug('TRUCKSTOP INTEGRATION : CREATE TRACK(Request Body : ' + json_request_body + ').');
			return json_request_body;
		}
		
		return null;
	}
	
	public static String serialize_for_update(Shipment__c shipment, Shipment_Track__c shipment_track, List<Shipment_Stop__c> lst_shipment_stop){
		Boolean data_completed = true;
		
		if(shipment.ETA_Point_of_Discharge__c == null){
			data_completed = false;
		}else if(shipment.ETD_from_Point_of_Load__c == null){
			data_completed = false;
		}
		
		if(data_completed == false){
			system.debug('TRUCKSTOP INTEGRATION : UPDATE TRACKING(No cumplimos los requisitos para actualizar el Track).');
		}else{
			system.debug('TRUCKSTOP INTEGRATION : UPDATE TRACKING(Cumplimos los requisitos para actualizar el Track).');

			// Construimos el json que ira en el body de nuestro http request
			DateTime ETD = DateTime.newInstance(shipment.ETD_from_Point_of_Load__c.year(), shipment.ETD_from_Point_of_Load__c.month(), shipment.ETD_from_Point_of_Load__c.day(), shipment.ETD_Time_from_Point_of_Load__c.hour(), shipment.ETD_Time_from_Point_of_Load__c.minute(), 00);
			DateTime ETA = DateTime.newInstance(shipment.ETA_Point_of_Discharge__c.year(), shipment.ETA_Point_of_Discharge__c.month(), shipment.ETA_Point_of_Discharge__c.day(), shipment.ETA_Time_Point_of_Discharge__c.hour(), shipment.ETA_Time_Point_of_Discharge__c.minute(), 00);
			Map<String, Object> map_data = new Map<String, Object>();
			map_data.put('ValidateAddresses', true);
			
			List<Map<String, Object>> lst_map_additional_stops = new List<Map<String, Object>>();
			
			Map<String, Object> map_data_origin = new Map<String, Object>();
			map_data_origin.put('country', shipment_track.Truckstop_Origin_Country_Code__c);
			map_data_origin.put('state', shipment_track.Truckstop_Origin_State_Code__c);
			map_data_origin.put('city', shipment_track.Truckstop_Origin_City__c);
			if(shipment_track.Truckstop_Origin_Postal_Code__c != null){
				if(shipment_track.Truckstop_Origin_Postal_Code__c != ''){
					map_data_origin.put('zip', shipment_track.Truckstop_Origin_Postal_Code__c);
				}
			}
			if(shipment_track.Truckstop_Origin_Address__c != null){
				if(shipment_track.Truckstop_Origin_Address__c != ''){
					map_data_origin.put('address', shipment_track.Truckstop_Origin_Address__c);
				}
			}
			map_data_origin.put('eventDateTime', String.valueOf(ETD).replace(' ', 'T') + '-06:00');
			//map_data_origin.put('timezone', 'Central Standard Time');
			lst_map_additional_stops.add(map_data_origin);
			
			if(lst_shipment_stop != null){
				if(lst_shipment_stop.size() > 0){
					for(Shipment_Stop__c shipment_stop : lst_shipment_stop){
						Map<String, Object> map_additional_stop = new Map<String, Object>();
						map_additional_stop.put('country', shipment_stop.Truckstop_Country_Code__c);
						map_additional_stop.put('state', shipment_stop.Truckstop_State_Code__c);
						map_additional_stop.put('city', shipment_stop.Truckstop_City__c);
						if(shipment_stop.Truckstop_Postal_Code__c != null){
							if(shipment_stop.Truckstop_Postal_Code__c != ''){
								map_additional_stop.put('zip', shipment_stop.Truckstop_Postal_Code__c);
							}
						}
						if(shipment_stop.Truckstop_Address__c != null){
							if(shipment_stop.Truckstop_Address__c != ''){
								map_additional_stop.put('address', shipment_stop.Truckstop_Address__c);
							}
						}
						map_additional_stop.put('eventDateTime', String.valueOf(shipment_stop.Estimated_Time_of_Arrival__c).replace(' ', 'T') + '-06:00');
						//map_additional_stop.put('timezone', 'Central Standard Time');
						lst_map_additional_stops.add(map_additional_stop);
					}
				}
			}
			
			Map<String, Object> map_data_destination = new Map<String, Object>();
			map_data_destination.put('country', shipment_track.Truckstop_Destination_Country_Code__c);
			map_data_destination.put('state', shipment_track.Truckstop_Destination_State_Code__c);
			map_data_destination.put('city', shipment_track.Truckstop_Destination_City__c);
			if(shipment_track.Truckstop_Destination_Postal_Code__c != null){
				if(shipment_track.Truckstop_Destination_Postal_Code__c != ''){
					map_data_destination.put('zip', shipment_track.Truckstop_Destination_Postal_Code__c);
				}
			}
			if(shipment_track.Truckstop_Destination_Address__c != null){
				if(shipment_track.Truckstop_Destination_Address__c != ''){
					map_data_destination.put('address', shipment_track.Truckstop_Destination_Address__c);
				}
			}
			map_data_destination.put('eventDateTime', String.valueOf(ETA).replace(' ', 'T') + '-06:00');
			//map_data_destination.put('timezone', 'Central Standard Time');
			lst_map_additional_stops.add(map_data_destination);
			
			map_data.put('Stops', lst_map_additional_stops);
			String json_request_body = JSON.serialize(map_data);
			system.debug('REQUEST BODY: ' + json_request_body);
			return json_request_body;
		}
		
		return null;
	}
	
	
	
	
	
	
	
	
	
	
	/* --------------------------------------------- AUTH OBJECTS FROM TRUCKSTOP --------------------------------------------- */
	
	/*public class Auth {
		public String access_token {get;set;} 
		public String token_type {get;set;} 
		public Integer expires_in {get;set;} 
		public String refresh_token {get;set;} 
		public String claims {get;set;} 

		public Auth(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'access_token') {
							access_token = parser.getText();
						} else if (text == 'token_type') {
							token_type = parser.getText();
						} else if (text == 'expires_in') {
							expires_in = parser.getIntegerValue();
						} else if (text == 'refresh_token') {
							refresh_token = parser.getText();
						} else if (text == 'claims') {
							claims = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Auth consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static Auth parse_token(String json) {
		return new Auth(System.JSON.createParser(json));
	}*/
	
	
	
	/* --------------------------------------------- TRACK OBJECTS RESPONSE FROM TRUCKSTOP --------------------------------------------- */
	
	public class TrackCreateResponse {
		public TrackCreateDetail trackCreateDetail {get;set;}
		public Integer statusCode {get;set;} 
		public String message {get;set;} 

		public TrackCreateResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'data') {
							trackCreateDetail = new TrackCreateDetail(parser);
						} else if (text == 'statusCode') {
							statusCode = parser.getIntegerValue();
						} else if (text == 'message') {
							message = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackCreateResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static TrackCreateResponse parse_track_create_response(String json) {
		return new TrackCreateResponse(System.JSON.createParser(json));
	}
	
	
	
	
	public class TrackLinkResponseHTTP {
		public TrackLinkResponse trackLink {get;set;}
		public Integer statusCode {get;set;} 
		public String message {get;set;} 

		public TrackLinkResponseHTTP(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'data') {
							trackLink = new TrackLinkResponse(parser);
						} else if (text == 'statusCode') {
							statusCode = parser.getIntegerValue();
						} else if (text == 'message') {
							message = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackLinkResponseHTTP consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TrackLinkResponse {
		public String trackingNumber {get;set;}
		public String link {get;set;} 
		
		public TrackLinkResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'trackingNumber') {
							trackingNumber = parser.getText();
						} else if (text == 'link') {
							link = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackLinkResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static TrackLinkResponseHTTP parse_track_link_response(String json) {
		return new TrackLinkResponseHTTP(System.JSON.createParser(json));
	}
	
	
	
	
	public class TrackResponse {
		public TrackDetail trackDetail {get;set;}
		public Integer statusCode {get;set;} 
		public String message {get;set;} 

		public TrackResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'data') {
							trackDetail = new TrackDetail(parser);
						} else if (text == 'statusCode') {
							statusCode = parser.getIntegerValue();
						} else if (text == 'message') {
							message = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static TrackResponse parse_track_response(String json) {
		return new TrackResponse(System.JSON.createParser(json));
	}
	
	
	
	
	public class TrackDocumentResponse {
		public File document {get;set;} 
		public Integer statusCode {get;set;} 
		public String message {get;set;} 

		public TrackDocumentResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'data') {
							document = new File(parser);
						} else if (text == 'statusCode') {
							statusCode = parser.getIntegerValue();
						} else if (text == 'message') {
							message = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackDocumentResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static TrackDocumentResponse parse_track_document_response(String json) {
		return new TrackDocumentResponse(System.JSON.createParser(json));
	}
	
	
	
	
	public class TrackLocationResponse {
		public Location location {get;set;} 
		public Integer statusCode {get;set;} 
		public String message {get;set;} 

		public TrackLocationResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'data') {
							location = new Location(parser);
						} else if (text == 'statusCode') {
							statusCode = parser.getIntegerValue();
						} else if (text == 'message') {
							message = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackLocationResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static TrackLocationResponse parse_track_location_response(String json) {
		return new TrackLocationResponse(System.JSON.createParser(json));
	}
	
	
	/* --------------------------------------------- TRACK OBJECTS MAPPING FROM TRUCKSTOP --------------------------------------------- */
	
	public class TrackCreateDetail {
		public Integer sequenceNumber {get;set;} 
		public String referenceId {get;set;} 
		public String trackingNumber {get;set;} 
		public String loadId {get;set;} 
		public String ownerAccount {get;set;} 
		public String ownerCompany {get;set;} 
		public Object warningMessages {get;set;} 
		public Object errorMessage {get;set;} 

		public TrackCreateDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'sequenceNumber') {
							sequenceNumber = parser.getIntegerValue();
						} else if (text == 'referenceId') {
							referenceId = parser.getText();
						} else if (text == 'trackingNumber') {
							trackingNumber = parser.getText();
						} else if (text == 'loadId') {
							loadId = parser.getText();
						} else if (text == 'ownerAccount') {
							ownerAccount = parser.getText();
						} else if (text == 'ownerCompany') {
							ownerCompany = parser.getText();
						} else if (text == 'warningMessages') {
							warningMessages = parser.getText();
						} else if (text == 'errorMessage') {
							errorMessage = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackCreateDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TrackDetail {
		public List<CheckCall> checkCalls {get;set;} 
		public CheckCallTemplate checkCallTemplate {get;set;} 
		public List<String> checkCallsDue {get;set;} 
		public List<LocationDetail> additionalStops {get;set;} 
		public LocationDetail destination {get;set;} 
		public Integer distanceTotal {get;set;} 
		public Integer distanceFromOrigin {get;set;} 
		public Integer distanceFromDestination {get;set;} 
		public Boolean destinationReached {get;set;} 
		public List<File> documents {get;set;} 
		public String deliveryDate {get;set;} 
		public PositionDetail lastKnownLocation {get;set;} 
		public List<UserPosition> positionHistory {get;set;} 
		public String createdDt {get;set;} 
		public String lastUpdateDt {get;set;} 
		public String loadId {get;set;} 
		public LoadManagement management {get;set;} 
		public List<LoadNote> notes {get;set;} 
		public LocationDetail origin {get;set;} 
		public Boolean originReached {get;set;} 
		public String pickupDate {get;set;} 
		public String referenceId {get;set;} 
		public String sourceSystem {get;set;} 
		public String currentState {get;set;} 
		public List<StateChange> stateChanges {get;set;} 
		public String trackingNumber {get;set;} 
		public String actualPickupDate {get;set;} 
		public String actualDropoffDate {get;set;} 
		public Integer startTrackBeforePickupInHours {get;set;} 

		public TrackDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'checkCalls') {
							checkCalls = new List<CheckCall>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								checkCalls.add(new CheckCall(parser));
							}
						} else if (text == 'checkCallTemplate') {
							checkCallTemplate = new CheckCallTemplate(parser);
						} else if (text == 'checkCallsDue') {
							checkCallsDue = new List<String>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								checkCallsDue.add(parser.getText());
							}
						} else if (text == 'additionalStops') {
							additionalStops = new List<LocationDetail>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								additionalStops.add(new LocationDetail(parser));
							}
						} else if (text == 'destination') {
							destination = new LocationDetail(parser);
						} else if (text == 'distanceTotal') {
							distanceTotal = parser.getIntegerValue();
						} else if (text == 'distanceFromOrigin') {
							distanceFromOrigin = parser.getIntegerValue();
						} else if (text == 'distanceFromDestination') {
							distanceFromDestination = parser.getIntegerValue();
						} else if (text == 'destinationReached') {
							destinationReached = parser.getBooleanValue();
						} else if (text == 'documents') {
							documents = new List<File>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								documents.add(new File(parser));
							}
						} else if (text == 'deliveryDate') {
							deliveryDate = parser.getText();
						} else if (text == 'lastKnownLocation') {
							lastKnownLocation = new PositionDetail(parser);
						} else if (text == 'positionHistory') {
							positionHistory = new List<UserPosition>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								positionHistory.add(new UserPosition(parser));
							}
						} else if (text == 'createdDt') {
							createdDt = parser.getText();
						} else if (text == 'lastUpdateDt') {
							lastUpdateDt = parser.getText();
						} else if (text == 'loadId') {
							loadId = parser.getText();
						} else if (text == 'management') {
							management = new LoadManagement(parser);
						} else if (text == 'notes') {
							notes = new List<LoadNote>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								notes.add(new LoadNote(parser));
							}
						} else if (text == 'origin') {
							origin = new LocationDetail(parser);
						} else if (text == 'originReached') {
							originReached = parser.getBooleanValue();
						} else if (text == 'pickupDate') {
							pickupDate = parser.getText();
						} else if (text == 'referenceId') {
							referenceId = parser.getText();
						} else if (text == 'sourceSystem') {
							sourceSystem = parser.getText();
						} else if (text == 'currentState') {
							currentState = parser.getText();
						} else if (text == 'stateChanges') {
							stateChanges = new List<StateChange>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								stateChanges.add(new StateChange(parser));
							}
						} else if (text == 'trackingNumber') {
							trackingNumber = parser.getText();
						} else if (text == 'actualPickupDate') {
							actualPickupDate = parser.getText();
						} else if (text == 'actualDropoffDate') {
							actualDropoffDate = parser.getText();
						} else if (text == 'startTrackBeforePickupInHours') {
							startTrackBeforePickupInHours = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'TrackDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Note {
		public String creatorAccountNumber {get;set;} 
		public String creatorName {get;set;} 
		public String timestamp {get;set;} 
		public String eventLocalDateTime {get;set;} 
		public String value {get;set;} 

		public Note(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'creatorAccountNumber') {
							creatorAccountNumber = parser.getText();
						} else if (text == 'creatorName') {
							creatorName = parser.getText();
						} else if (text == 'timestamp') {
							timestamp = parser.getText();
						} else if (text == 'eventLocalDateTime') {
							eventLocalDateTime = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Note consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CheckCall {
		public String callId {get;set;} 
		public String callType {get;set;} 
		public String displayName {get;set;} 
		public List<Edit> edits {get;set;} 
		public User driver {get;set;} 
		public String receivedTimestamp {get;set;} 
		public String eventLocalDateTime {get;set;} 
		public String recorded {get;set;} 
		public String locationId {get;set;} 
		public Location location {get;set;} 
		public List<Note> notes {get;set;} 
		public List<File> documents {get;set;} 

		public CheckCall(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'callId') {
							callId = parser.getText();
						} else if (text == 'callType') {
							callType = parser.getText();
						} else if (text == 'displayName') {
							displayName = parser.getText();
						} else if (text == 'edits') {
							edits = new List<Edit>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								edits.add(new Edit(parser));
							}
						} else if (text == 'driver') {
							driver = new User(parser);
						} else if (text == 'receivedTimestamp') {
							receivedTimestamp = parser.getText();
						} else if (text == 'eventLocalDateTime') {
							eventLocalDateTime = parser.getText();
						} else if (text == 'recorded') {
							recorded = parser.getText();
						} else if (text == 'locationId') {
							locationId = parser.getText();
						} else if (text == 'location') {
							location = new Location(parser);
						} else if (text == 'notes') {
							notes = new List<Note>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								notes.add(new Note(parser));
							}
						} else if (text == 'documents') {
							documents = new List<File>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								documents.add(new File(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Edit {
		public String action {get;set;} 
		public String userAccountNumber {get;set;} 
		public String when_Z {get;set;} // in json: when

		public Edit(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'action') {
							action = parser.getText();
						} else if (text == 'userAccountNumber') {
							userAccountNumber = parser.getText();
						} else if (text == 'when') {
							when_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Edit consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class File {
		public String documentId {get;set;} 
		public String fileName {get;set;} 
		public String type_Z {get;set;} // in json: type
		public String checkCallId {get;set;} 
		public String saved {get;set;} 
		public String eventLocalDateTime {get;set;} 

		public File(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'documentId') {
							documentId = parser.getText();
						} else if (text == 'fileName') {
							fileName = parser.getText();
						} else if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'checkCallId') {
							checkCallId = parser.getText();
						} else if (text == 'saved') {
							saved = parser.getText();
						} else if (text == 'eventLocalDateTime') {
							eventLocalDateTime = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Document consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CheckCallTemplate {
		public String name {get;set;} 
		public String description {get;set;} 
		public String start {get;set;} 
		public String companyName {get;set;} 
		public String companyAccount {get;set;} 
		public List<CheckCallNode> checkCallNodes {get;set;} 

		public CheckCallTemplate(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'start') {
							start = parser.getText();
						} else if (text == 'companyName') {
							companyName = parser.getText();
						} else if (text == 'companyAccount') {
							companyAccount = parser.getText();
						} else if (text == 'checkCallNodes') {
							checkCallNodes = new List<CheckCallNode>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								checkCallNodes.add(new CheckCallNode(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'CheckCallTemplate consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CheckCallNode {
		public String name {get;set;} 
		public String displayName {get;set;} 
		public Boolean isRequired {get;set;} 
		public Integer sequenceNumber {get;set;} 
		public Boolean isDocumentationRequired {get;set;} 
		public String locationId {get;set;} 
		public Location location {get;set;} 
		public Boolean isArrivingCall {get;set;} 

		public CheckCallNode(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'displayName') {
							displayName = parser.getText();
						} else if (text == 'isRequired') {
							isRequired = parser.getBooleanValue();
						} else if (text == 'sequenceNumber') {
							sequenceNumber = parser.getIntegerValue();
						} else if (text == 'isDocumentationRequired') {
							isDocumentationRequired = parser.getBooleanValue();
						} else if (text == 'locationId') {
							locationId = parser.getText();
						} else if (text == 'location') {
							location = new Location(parser);
						} else if (text == 'isArrivingCall') {
							isArrivingCall = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CheckCallNode consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Location {
		public String address {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public String zip {get;set;} 
		public String country {get;set;} 
		public Double latitude {get;set;} 
		public Double longitude {get;set;} 
		public String timezone {get;set;} 

		public Location(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'address') {
							address = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getDoubleValue();
						} else if (text == 'longitude') {
							longitude = parser.getDoubleValue();
						} else if (text == 'timezone') {
							timezone = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LocationDetail {
		public String locationId {get;set;} 
		public String company {get;set;} 
		public String contact {get;set;} 
		public String contactNumber {get;set;} 
		public String address {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public String zip {get;set;} 
		public String country {get;set;} 
		public String eventDateTime {get;set;} 
		public Integer eventToleranceHours {get;set;} 
		public Integer geofenceRadius {get;set;} 
		public String eventLocalDateTime {get;set;} 
		public Double latitude {get;set;} 
		public Double longitude {get;set;} 
		public String timezone {get;set;} 

		public LocationDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'locationId') {
							locationId = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'contact') {
							contact = parser.getText();
						} else if (text == 'contactNumber') {
							contactNumber = parser.getText();
						} else if (text == 'address') {
							address = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'eventDateTime') {
							eventDateTime = parser.getText();
						} else if (text == 'eventToleranceHours') {
							eventToleranceHours = parser.getIntegerValue();
						} else if (text == 'geofenceRadius') {
							geofenceRadius = parser.getIntegerValue();
						} else if (text == 'eventLocalDateTime') {
							eventLocalDateTime = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getDoubleValue();
						} else if (text == 'longitude') {
							longitude = parser.getDoubleValue();
						} else if (text == 'timezone') {
							timezone = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LocationDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PositionDetail {
		public String address {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public String zip {get;set;} 
		public String country {get;set;} 
		public String deviceTimestamp {get;set;} 
		public Double latitude {get;set;} 
		public Double longitude {get;set;} 
		public String receivedTimestamp {get;set;} 
		public String eventLocalDateTime {get;set;} 

		public PositionDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'address') {
							address = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'deviceTimestamp') {
							deviceTimestamp = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getDoubleValue();
						} else if (text == 'longitude') {
							longitude = parser.getDoubleValue();
						} else if (text == 'receivedTimestamp') {
							receivedTimestamp = parser.getText();
						} else if (text == 'eventLocalDateTime') {
							eventLocalDateTime = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PositionDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UserPosition {
		public String accountNumber {get;set;} 
		public String address {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public String zip {get;set;} 
		public String country {get;set;} 
		public String deviceTimestamp {get;set;} 
		public Double latitude {get;set;} 
		public Double longitude {get;set;} 
		public String receivedTimestamp {get;set;} 

		public UserPosition(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'accountNumber') {
							accountNumber = parser.getText();
						} else if (text == 'address') {
							address = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'deviceTimestamp') {
							deviceTimestamp = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getDoubleValue();
						} else if (text == 'longitude') {
							longitude = parser.getDoubleValue();
						} else if (text == 'receivedTimestamp') {
							receivedTimestamp = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'UserPosition consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LoadManagement {
		public String currentCompanyAccount {get;set;} 
		public String currentCompanyName {get;set;} 
		public List<LoadOwner> owners {get;set;} 
		public List<LoadDriver> drivers {get;set;} 

		public LoadManagement(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'currentCompanyAccount') {
							currentCompanyAccount = parser.getText();
						} else if (text == 'currentCompanyName') {
							currentCompanyName = parser.getText();
						} else if (text == 'owners') {
							owners = new List<LoadOwner>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								owners.add(new LoadOwner(parser));
							}
						} else if (text == 'drivers') {
							drivers = new List<LoadDriver>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								drivers.add(new LoadDriver(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LoadDriver {
		public String addedTimestamp {get;set;} 
		public String state {get;set;} 
		public List<StateChange> stateChanges {get;set;} 
		public User driverDetail {get;set;} 

		public LoadDriver(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'addedTimestamp') {
							addedTimestamp = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'stateChanges') {
							stateChanges = new List<StateChange>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								stateChanges.add(new StateChange(parser));
							}
						} else if (text == 'driverDetail') {
							driverDetail = new User(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'LoadDriver consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LoadOwner {
		public ClientCompanyDetail companyDetail {get;set;} 
		public User ownerDetail {get;set;} 

		public LoadOwner(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'companyDetail') {
							companyDetail = new ClientCompanyDetail(parser);
						} else if (text == 'ownerDetail') {
							ownerDetail = new User(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'LoadOwner consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class User {
		public String accountNumber {get;set;} 
		public String email {get;set;} 
		public String name {get;set;} 
		public List<Receiver> receivers {get;set;} 

		public User(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'accountNumber') {
							accountNumber = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'receivers') {
							receivers = new List<Receiver>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								receivers.add(new Receiver(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'User consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class StateChange {
		public String when_Z {get;set;} // in json: when
		public String state {get;set;} 

		public StateChange(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'when') {
							when_Z = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'StateChange consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Receiver {
		public String number_Z {get;set;} // in json: number

		public Receiver(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'number') {
							number_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Receiver consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClientCompanyDetail {
		public String accountNumber {get;set;} 
		public String name {get;set;} 
		public PostalAddress mainAddress {get;set;} 
		public PostalAddress billingAddress {get;set;} 
		public List<Receiver> phones {get;set;} 

		public ClientCompanyDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'accountNumber') {
							accountNumber = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'mainAddress') {
							mainAddress = new PostalAddress(parser);
						} else if (text == 'billingAddress') {
							billingAddress = new PostalAddress(parser);
						} else if (text == 'phones') {
							phones = new List<Receiver>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								phones.add(new Receiver(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'ClientCompanyDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PostalAddress {
		public String country {get;set;} 
		public String street {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public String zip {get;set;} 
		public String ZipExt {get;set;} 

		public PostalAddress(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'country') {
							country = parser.getText();
						} else if (text == 'street') {
							street = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'ZipExt') {
							ZipExt = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PostalAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LoadStateChange {
		public String userAccountNumber {get;set;} 
		public String when_Z {get;set;} // in json: when
		public String state {get;set;} 

		public LoadStateChange(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'userAccountNumber') {
							userAccountNumber = parser.getText();
						} else if (text == 'when') {
							when_Z = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LoadStateChange consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LoadNote {
		public String category {get;set;} 
		public String label {get;set;} 
		public String creatorAccountNumber {get;set;} 
		public String creatorName {get;set;} 
		public String timestamp {get;set;} 
		public String eventLocalDateTime {get;set;} 
		public String value {get;set;} 

		public LoadNote(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'category') {
							category = parser.getText();
						} else if (text == 'label') {
							label = parser.getText();
						} else if (text == 'creatorAccountNumber') {
							creatorAccountNumber = parser.getText();
						} else if (text == 'creatorName') {
							creatorName = parser.getText();
						} else if (text == 'timestamp') {
							timestamp = parser.getText();
						} else if (text == 'eventLocalDateTime') {
							eventLocalDateTime = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LoadNote consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClientUserDetail {
		public String accountNumber {get;set;} 
		public String email {get;set;} 
		public String name {get;set;} 
		public List<Receiver> receivers {get;set;} 

		public ClientUserDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'accountNumber') {
							accountNumber = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'receivers') {
							receivers = new List<Receiver>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								receivers.add(new Receiver(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'ClientUserDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClientLoadOwnerDetail {
		public String userAccount {get;set;} 
		public String companyAccount {get;set;} 
		public ClientCompanyDetail companyDetail {get;set;} 
		public ClientUserDetail ownerDetail {get;set;} 

		public ClientLoadOwnerDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'userAccount') {
							userAccount = parser.getText();
						} else if (text == 'companyAccount') {
							companyAccount = parser.getText();
						} else if (text == 'companyDetail') {
							companyDetail = new ClientCompanyDetail(parser);
						} else if (text == 'ownerDetail') {
							ownerDetail = new ClientUserDetail(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ClientLoadOwnerDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClientLoadManagementDetail {
		public String currentCompanyAccount {get;set;} 
		public String currentUserAccount {get;set;} 
		public List<ClientLoadOwnerDetail> owners {get;set;} 
		public List<ClientLoadOwnerDetail> drivers {get;set;} 

		public ClientLoadManagementDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'currentCompanyAccount') {
							currentCompanyAccount = parser.getText();
						} else if (text == 'currentUserAccount') {
							currentUserAccount = parser.getText();
						} else if (text == 'owners') {
							owners = new List<ClientLoadOwnerDetail>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								owners.add(new ClientLoadOwnerDetail(parser));
							}
						} else if (text == 'drivers') {
							drivers = new List<ClientLoadOwnerDetail>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								drivers.add(new ClientLoadOwnerDetail(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'ClientLoadManagementDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClientLoadDriverDetail {
		public String accountNumber {get;set;} 
		public ClientUserDetail driverDetail {get;set;} 

		public ClientLoadDriverDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'accountNumber') {
							accountNumber = parser.getText();
						} else if (text == 'driverDetail') {
							driverDetail = new ClientUserDetail(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ClientLoadDriverDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClientCheckCallDetail {
		public String callId {get;set;} 
		public String callType {get;set;} 
		public String displayName {get;set;} 
		public String driver {get;set;} 
		public String recorded {get;set;} 
		public String eventLocalDateTime {get;set;} 
		public Location location {get;set;} 
		public List<Note> notes {get;set;} 

		public ClientCheckCallDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'callId') {
							callId = parser.getText();
						} else if (text == 'callType') {
							callType = parser.getText();
						} else if (text == 'displayName') {
							displayName = parser.getText();
						} else if (text == 'driver') {
							driver = parser.getText();
						} else if (text == 'recorded') {
							recorded = parser.getText();
						} else if (text == 'eventLocalDateTime') {
							eventLocalDateTime = parser.getText();
						} else if (text == 'location') {
							location = new Location(parser);
						} else if (text == 'notes') {
							notes = new List<Note>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								notes.add(new Note(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'ClientCheckCallDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BrokerTrackSummary {
		public ClientCheckCallDetail lastCompletedCheckCall {get;set;} 
		public LocationDetail destination {get;set;} 
		public Integer distanceTotal {get;set;} 
		public Integer distanceFromOrigin {get;set;} 
		public Double distanceFromDestination {get;set;} 
		public String lastUpdateDT {get;set;} 
		public ClientLoadManagementDetail management {get;set;} 
		public LocationDetail origin {get;set;} 
		public String referenceId {get;set;} 
		public String sourceSystem {get;set;} 
		public LoadStateChange currentStatus {get;set;} 
		public String trackingNumber {get;set;} 
		public PositionDetail lastKnownLocation {get;set;} 
		public List<UserPosition> positionHistory {get;set;} 
		public String actualDeliveryDate {get;set;} 
		public String actualPickupDate {get;set;} 
		public Integer startTrackBeforePickupInHours {get;set;} 

		public BrokerTrackSummary(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'lastCompletedCheckCall') {
							lastCompletedCheckCall = new ClientCheckCallDetail(parser);
						} else if (text == 'destination') {
							destination = new LocationDetail(parser);
						} else if (text == 'distanceTotal') {
							distanceTotal = parser.getIntegerValue();
						} else if (text == 'distanceFromOrigin') {
							distanceFromOrigin = parser.getIntegerValue();
						} else if (text == 'distanceFromDestination') {
							distanceFromDestination = parser.getDoubleValue();
						} else if (text == 'lastUpdateDT') {
							lastUpdateDT = parser.getText();
						} else if (text == 'management') {
							management = new ClientLoadManagementDetail(parser);
						} else if (text == 'origin') {
							origin = new LocationDetail(parser);
						} else if (text == 'referenceId') {
							referenceId = parser.getText();
						} else if (text == 'sourceSystem') {
							sourceSystem = parser.getText();
						} else if (text == 'currentStatus') {
							currentStatus = new LoadStateChange(parser);
						} else if (text == 'trackingNumber') {
							trackingNumber = parser.getText();
						} else if (text == 'lastKnownLocation') {
							lastKnownLocation = new PositionDetail(parser);
						} else if (text == 'positionHistory') {
							positionHistory = new List<UserPosition>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								positionHistory.add(new UserPosition(parser));
							}
						} else if (text == 'actualDeliveryDate') {
							actualDeliveryDate = parser.getText();
						} else if (text == 'actualPickupDate') {
							actualPickupDate = parser.getText();
						} else if (text == 'startTrackBeforePickupInHours') {
							startTrackBeforePickupInHours = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'BrokerTrackSummary consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
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
	
	public static String getTrackResponseExample(){
		String json_response = '{';
		json_response += '	"data": {';
		json_response += '		"checkCalls": [';
		json_response += '			{';
		json_response += '				"callId": 1,';
		json_response += '				"callType": "ArrivedAtShipper",';
		json_response += '				"displayName": "Arrived At Shipper",';
		json_response += '				"edits": [';
		json_response += '					{';
		json_response += '						"action": "AddedDocument",';
		json_response += '						"userAccountNumber": "1234",';
		json_response += '						"when": "2017-01-23T13:00:00Z"';
		json_response += '					}';
		json_response += '				],';
		json_response += '				"driver": null,';
		json_response += '				"receivedTimestamp": "2017-01-23T00:00:11.138",';
		json_response += '				"eventLocalDateTime": "2017-01-23T09:00:12.218",';
		json_response += '				"recorded": "2017-01-23T15:00:12.218Z",';
		json_response += '				"locationId": "ca2e18bb726f4459b0fedb4b431e8fad",';
		json_response += '				"location": {';
		json_response += '					"address": "123 Main St.",';
		json_response += '					"city": "Boise",';
		json_response += '					"state": "ID",';
		json_response += '					"zip": "83713",';
		json_response += '					"country": "USA",';
		json_response += '					"latitude": 43.6187102,';
		json_response += '					"longitude": -116.2146068,';
		json_response += '					"timezone": "Mountain Standard Time"';
		json_response += '				},';
		json_response += '				"notes": [';
		json_response += '					{';
		json_response += '						"creatorAccountNumber": "1234",';
		json_response += '						"creatorName": "Joe Carrier",';
		json_response += '						"timestamp": "2017-01-23T15:00:12.218Z",';
		json_response += '						"eventLocalDateTime": "2017-01-23T09:00:12.218Z",';
		json_response += '						"value": "Test note message"';
		json_response += '					}';
		json_response += '				],';
		json_response += '				"documents": [';
		json_response += '					{';
		json_response += '						"documentId": "25",';
		json_response += '						"fileName": "test.pdf",';
		json_response += '						"type": "invoice",';
		json_response += '						"checkCallId": "2423",';
		json_response += '						"saved": "2017-01-23T13:00:00Z",';
		json_response += '						"eventLocalDateTime": "2017-01-23T07:00:00"';
		json_response += '					}';
		json_response += '				]';
		json_response += '			}';
		json_response += '		],';
		json_response += '		"checkCallTemplate": {';
		json_response += '			"name": null,';
		json_response += '			"description": null,';
		json_response += '			"start": "ArrivedAtShipper",';
		json_response += '			"companyName": null,';
		json_response += '			"companyAccount": null,';
		json_response += '			"checkCallNodes": [';
		json_response += '				{';
		json_response += '					"name": "ArrivedAtShipper",';
		json_response += '					"displayName": "Arrived At Shipper",';
		json_response += '					"isRequired": true,';
		json_response += '					"sequenceNumber": 1,';
		json_response += '					"isDocumentationRequired": false,';
		json_response += '					"locationId": "20e522beb4524101a327c2c8185bb62d",';
		json_response += '					"location": {';
		json_response += '						"address": "123 Main St.",';
		json_response += '						"city": "Boise",';
		json_response += '						"state": "ID",';
		json_response += '						"zip": "83713",';
		json_response += '						"country": "USA",';
		json_response += '						"latitude": 43.6187102,';
		json_response += '						"longitude": -116.2146068,';
		json_response += '						"timezone": "Mountain Standard Time"';
		json_response += '					},';
		json_response += '					"isArrivingCall": true';
		json_response += '				}';
		json_response += '			]';
		json_response += '		},';
		json_response += '		"checkCallsDue": ["ArrivedAtShipper"],';
		json_response += '		"additionalStops": [';
		json_response += '			{';
		json_response += '				"locationId": "43e07a4b622844e28b3f150e2d10554a",';
		json_response += '				"company":"Origin Integration Company",';
		json_response += '				"contact":"Integration Team",';
		json_response += '				"contactNumber":"2081234567",';
		json_response += '				"address": "1444 S Entertainment Ave",';
		json_response += '				"city": "Boise",';
		json_response += '				"state": "ID",';
		json_response += '				"zip": "83709",';
		json_response += '				"country": "USA",';
		json_response += '				"eventDateTime": "2017-03-21T13:43:19.976Z",';
		json_response += '				"eventToleranceHours": 0,';
		json_response += '				"geofenceRadius": 1,';
		json_response += '				"eventLocalDateTime": "2017-03-21T07:43:19.976",';
		json_response += '				"latitude": 43.5910896,';
		json_response += '				"longitude": -116.2782056,';
		json_response += '				"timezone": "Mountain Standard Time"';
		json_response += '			}';
		json_response += '		],';
		json_response += '		"destination": {';
		json_response += '			"locationId": "43e07a4b622844e28b3f150e2d10554a",';
		json_response += '			"company":"Origin Integration Company",';
		json_response += '			"contact":"Integration Team",';
		json_response += '			"contactNumber":"2081234567",';
		json_response += '			"address": "1444 S Entertainment Ave",';
		json_response += '			"city": "Boise",';
		json_response += '			"state": "ID",';
		json_response += '			"zip": "83709",';
		json_response += '			"country": "USA",';
		json_response += '			"eventDateTime": "2017-03-21T13:43:19.976Z",';
		json_response += '			"eventToleranceHours": 0,';
		json_response += '			"geofenceRadius": 1,';
		json_response += '			"eventLocalDateTime": "2017-03-21T07:43:19.976",';
		json_response += '			"latitude": 43.5910896,';
		json_response += '			"longitude": -116.2782056,';
		json_response += '			"timezone": "Mountain Standard Time"';
		json_response += '		},';
		json_response += '		"distanceTotal": 46,';
		json_response += '		"distanceFromOrigin": 0,';
		json_response += '		"distanceFromDestination": 46,';
		json_response += '		"destinationReached": false,';
		json_response += '		"documents": [';
		json_response += '			{';
		json_response += '				"documentId": "25",';
		json_response += '				"fileName": "test.pdf",';
		json_response += '				"type": "invoice",';
		json_response += '				"checkCallId": "2423",';
		json_response += '				"saved": "2017-01-23T13:00:00Z",';
		json_response += '				"eventLocalDateTime": "2017-01-23T07:00:00"';
		json_response += '			}';
		json_response += '		],';
		json_response += '		"deliveryDate": "2017-02-25T17:19:46.7Z",';
		json_response += '		"lastKnownLocation": null,';
		json_response += '		"positionHistory": [';
		json_response += '			{';
		json_response += '				"accountNumber": "1620",';
		json_response += '				"address": "123 Main St.",';
		json_response += '				"city": "Kuna",';
		json_response += '				"state": "ID",';
		json_response += '				"zip": "83715",';
		json_response += '				"country": "USA",';
		json_response += '				"deviceTimestamp": "2017-01-23T15:00:00Z",';
		json_response += '				"latitude": 43.4918307,';
		json_response += '				"longitude": -116.4201223,';
		json_response += '				"receivedTimestamp": "2017-01-23T15:01:00Z",';
		json_response += '				"eventLocalDateTime": "2017-01-23T09:01:00"';
		json_response += '			}';
		json_response += '		],';
		json_response += '		"createdDt": "2017-02-21T17:19:48.071Z",';
		json_response += '		"lastUpdateDt": "2017-02-21T17:19:48.071Z",';
		json_response += '		"loadId": "10005188",';
		json_response += '		"management": {';
		json_response += '			"currentCompanyAccount": "1000061",';
		json_response += '			"currentCompanyName": "Truckstop.com",';
		json_response += '			"owners": [';
		json_response += '				{';
		json_response += '					"companyDetail": {';
		json_response += '						"accountNumber": "1234",';
		json_response += '						"name": "Joes Crab Shack",';
		json_response += '						"mainAddress": {';
		json_response += '							"country": "USA",';
		json_response += '							"street": "123 Main St.",';
		json_response += '							"city": "Boise",';
		json_response += '							"state": "ID",';
		json_response += '							"zip": "83713",';
		json_response += '							"ZipExt": "1234"';
		json_response += '						},';
		json_response += '						"billingAddress": {';
		json_response += '							"country": "USA",';
		json_response += '							"street": "123 Main St.",';
		json_response += '							"city": "Boise",';
		json_response += '							"state": "ID",';
		json_response += '							"zip": "83713",';
		json_response += '							"ZipExt": "1234"';
		json_response += '						},';
		json_response += '						"phones": [';
		json_response += '							{';
		json_response += '								"number": "208-555-1234"';
		json_response += '							}';
		json_response += '						]';
		json_response += '					},';
		json_response += '					"ownerDetail": {';
		json_response += '						"accountNumber": "1234",';
		json_response += '						"email": "JoeDriver@email.com",';
		json_response += '						"name": "Joe Driver",';
		json_response += '						"receivers": [';
		json_response += '							{';
		json_response += '								"number": "208-555-1234"';
		json_response += '							}';
		json_response += '						]';
		json_response += '					}';
		json_response += '				}';
		json_response += '			],';
		json_response += '			"drivers": [';
		json_response += '				{';
		json_response += '					"addedTimestamp": "2017-04-28T20:07:48.183Z",';
		json_response += '					"state": "Active",';
		json_response += '					"stateChanges": [';
		json_response += '						{';
		json_response += '							"when": "2017-04-28T20:07:48.183Z",';
		json_response += '							"state": "Requested"';
		json_response += '						}';
		json_response += '					],';
		json_response += '					"driverDetail": {';
		json_response += '						"accountNumber": "1234",';
		json_response += '						"email": "JoeDriver@email.com",';
		json_response += '						"name": "Joe Driver",';
		json_response += '						"receivers": [';
		json_response += '							{';
		json_response += '								"number": "208-555-1234"';
		json_response += '							}';
		json_response += '						]';
		json_response += '					}';
		json_response += '				}';
		json_response += '			]';
		json_response += '		},';
		json_response += '		"notes": [';
		json_response += '			{';
		json_response += '				"category": "StateChange",';
		json_response += '				"label": "NoResponse",';
		json_response += '				"creatorAccountNumber": null,';
		json_response += '				"creatorName": "Joe Carrier",';
		json_response += '				"timestamp": "2017-01-23T15:00:12.218Z",';
		json_response += '				"eventLocalDateTime": "2017-01-23T09:00:12.218Z",';
		json_response += '				"value": "The load 8EW765P is automatically changed to NoResponse"';
		json_response += '			}';
		json_response += '		],';
		json_response += '		"origin": {';
		json_response += '			"locationId": "43e07a4b622844e28b3f150e2d10554a",';
		json_response += '			"company":"Origin Integration Company",';
		json_response += '			"contact":"Integration Team",';
		json_response += '			"contactNumber":"2081234567",';
		json_response += '			"address": "1444 S Entertainment Ave",';
		json_response += '			"city": "Boise",';
		json_response += '			"state": "ID",';
		json_response += '			"zip": "83709",';
		json_response += '			"country": "USA",';
		json_response += '			"eventDateTime": "2017-03-21T13:43:19.976Z",';
		json_response += '			"eventToleranceHours": 0,';
		json_response += '			"geofenceRadius": 1,';
		json_response += '			"eventLocalDateTime": "2017-03-21T07:43:19.976",';
		json_response += '			"latitude": 43.5910896,';
		json_response += '			"longitude": -116.2782056,';
		json_response += '			"timezone": "Mountain Standard Time"';
		json_response += '		},';
		json_response += '		"originReached": false,';
		json_response += '		"pickupDate": "2017-02-22T17:19:46.7Z",';
		json_response += '		"referenceId": "2017-02-22T10:19:46.7000000-07:00",';
		json_response += '		"sourceSystem": "CLIENT_ID",';
		json_response += '		"currentState": "Requested",';
		json_response += '		"stateChanges": [';
		json_response += '			{';
		json_response += '				"userAccountNumber": "1594",';
		json_response += '				"when": "2017-04-28T20:07:53.442Z",';
		json_response += '				"state": "Active"';
		json_response += '			}';
		json_response += '		],';
		json_response += '		"trackingNumber": "YZ4YMQG",';
		json_response += '		"actualPickupDate": null,';
		json_response += '		"actualDropoffDate": null,';
		json_response += '		"startTrackBeforePickupInHours": 12';
		json_response += '	},';
		json_response += '	"statusCode": 0,';
		json_response += '	"message": "OK."';
		json_response += '}';
		
		return json_response;
	}
}