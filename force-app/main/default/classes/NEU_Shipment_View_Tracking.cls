global with sharing class NEU_Shipment_View_Tracking {
	
	/* Temporal */
	public String json_request{get;set;}
	public String json_response{get;set;}
	
	
	public Shipment__c shipment{get;set;}
	public NEU_TS_WS_Tracking.TrackResponse track_response{get;set;}
	public Shipment_Track__c shipment_track{
		get{ 
			if(shipment_track == null){
				shipment_track = new Shipment_Track__c();
			}
			return shipment_track;
		}
		set;
	}
	public Shipment_Stop__c shipment_stop{
		get{
			if(shipment_stop == null){
				shipment_stop = new Shipment_Stop__c();
			}
			return shipment_stop;
		}
		set;
	}

	public List<Shipment_Stop__c> lst_shipment_stop{get;set;}
	public List<Associated_Document__c> lst_associated_document{get;set;}
	
	public List<File> lst_documents{get{return(lst_documents == null ? new List<File>() : lst_documents);}set;}
	public Blob new_document_body{get;set;}
	public String new_document_name{get;set;}
	public String new_document_type{get;set;}
	
	public List<Note> lst_notes{get{return (lst_notes == null ? new List<Note>() : lst_notes);}set;}
	public String new_note{get;set;}
	
	public Boolean differences_route{get{return (differences_route == null ? false : differences_route);}set;}
	public Boolean differences_operator{get{return (differences_operator == null ? false : differences_operator);}set;}
	public Boolean complete_data{get{return (complete_data == null ? true : complete_data);}set;}
	
	public String searchOriginAddress{get;set;}
	public String searchDestinationAddress{get;set;}
	public String searchStopAddress{get;set;}
	
	public class Note implements Comparable{
		public String message{get;set;}
		public String category_note{get;set;}
		public String user{get;set;}
		public String check_calls{get;set;}
		public DateTime date_time{get;set;}
		public String format_date_time{get;set;}
		
		public Integer compareTo(Object compareTo) {
			Note compareToNote = (Note)compareTo;
			if(date_time == compareToNote.date_time) {return 0;}
			if(date_time > compareToNote.date_time) {return 1;}
			return -1;
		}
	}
	
	public class File implements Comparable{
		public String documentId{get;set;}
		public String fileName{get;set;}
		public String type_Z{get;set;}
		public String url{get;set;}
		public String check_calls{get;set;}
		public DateTime date_time{get;set;}
		public String format_date_time{get;set;}
		
		public Integer compareTo(Object compareTo) {
			File compareToFile = (File)compareTo;
			if(date_time == compareToFile.date_time) {return 0;}
			if(date_time > compareToFile.date_time) {return 1;}
			return -1;
		}
	}
	
	public List<SelectOption> getFtypes() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','Select document type'));
		options.add(new SelectOption('Proof of Delivery','Proof of Delivery'));
		options.add(new SelectOption('Accessorial Receipts','Accessorial Receipts'));
		options.add(new SelectOption('Bill Of Lading','Bill Of Lading'));
		options.add(new SelectOption('COD Check','COD Check'));
		options.add(new SelectOption('Damage','Damage'));
		options.add(new SelectOption('Delivery Receipt','Delivery Receipt'));
		options.add(new SelectOption('Detention Fee Receipt','Detention Fee Receipt'));
		options.add(new SelectOption('In Ticket','In Ticket'));
		options.add(new SelectOption('Invoice','Invoice'));
		options.add(new SelectOption('Loading Receipt','Loading Receipt'));
		options.add(new SelectOption('Lumper Receipt','Lumper Receipt'));
		options.add(new SelectOption('Other','Other'));
		options.add(new SelectOption('Out Ticket','Out Ticket'));
		options.add(new SelectOption('Packing List','Packing List'));
		options.add(new SelectOption('Pallet Receipt','Pallet Receipt'));
		options.add(new SelectOption('Purchase Order','Purchase Order'));
		options.add(new SelectOption('Rate Confirmation','Rate Confirmation'));
		options.add(new SelectOption('Seal','Seal'));
		options.add(new SelectOption('Temperature Control Receipt','Temperature Control Receipt'));
		options.add(new SelectOption('Unloading Receipt','Unloading Receipt'));
		options.add(new SelectOption('Weight Scale Ticket','Weight Scale Ticket'));
		return options;
	}
	
	public String share_with_email{get;set;}
	
	
	/* ----------------------------------------------------- CONSTRUCTOR ----------------------------------------------------- */
	
	public NEU_Shipment_View_Tracking(ApexPages.StandardController stdController){
		try{
			if(stdController.getRecord().Id != null){
				System.debug('id...' + stdController.getRecord().Id);
				shipment = findShipmentById(stdController.getRecord().Id);
			}
			
			if(shipment != null){
				shipment_track = findShipmentTrackByShipment();
				if(searchOriginAddress == null){
					if(shipment_track.Id != null){
						searchOriginAddress = shipment_track.Truckstop_Origin_Address__c;
					}else{
						searchOriginAddress = shipment.Origin_Address_Shipment__c;
					}
				}
				
				if(searchDestinationAddress == null){
					if(shipment_track.Id != null){
						searchDestinationAddress = shipment_track.Truckstop_Destination_Address__c;
					}else{
						searchDestinationAddress = shipment.Delivery_Address_Shipment__c;
					}
				}
				lst_associated_document = findAssociatedDocumentByShipmentTrack();
				lst_shipment_stop = findShipmentStopsByShipment();
			}
		}catch(Exception ee){
			system.debug('ERROR NEU_Shipment_View_Tracking : ' + ee.getTypeName() + ' - ' + ee.getMessage() + ' - ' + ee.getStackTraceString());
			shipment_track = null;
		}
	}
	
	/*public void sendTo(){
		List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(new String[]{share_with_email});
		mail.setSenderDisplayName('Truckstop Integration');
		mail.setSubject('Tracking ' + shipment_track.Name);
		mail.setBccSender(false); 
		mail.setUseSignature(false); 
		mail.setCharset('UTF-8');
		// TODO: mail.setHtmlBody(message);
		mail.setHtmlBody('<div>If you want to view the status of the tracking, please click <a href="https://loadtracking-int.truckstop.com/SharedTrack/' + shipment_track.Name + '" target="_blank">here</a></div>');
		
		theEmails.add(mail);
		
		List<Messaging.Email> allMails = new List<Messaging.Email>();
		for(Integer j = 0; j < theEmails.size(); j++){
			allMails.add(theEmails.get(j));
		}
		
		try{
			if (!Test.isRunningTest()){
				Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
			}
		}catch(Exception exc){
		
		}
	}*/
	
	/* -------------------------------------------------- VALIDATION ADDRESS --------------------------------------------------*/
	
	public static List<String> validate_address(String address, Map<String, ID> map_ids, String point){
		Map<String, Object> map_result = NEU_TS_WS_Tracking.validateAddress(address, map_ids, point);
		List<String> result = new List<String>{
			(map_result.get('error') != null ? 'error' : String.valueOf(map_result.get('data')))
		};
		return result;
	}
	
	webservice static List<String> getAddressTruckstop(String address, Id shipmentID, String point) {
		Map<String, ID> map_ids = new Map<String, ID>{
			'shipmentID' => (shipmentID != null? shipmentID : null)
		};
		return validate_address(address, map_ids, point);
	}
	
	webservice static List<String> getAddressStopTruckstop(String address, Id countryID, Id stateID, Id locationID, String point) {
		Map<String, ID> map_ids = new Map<String, ID>{
			'countryID' => (countryID != null? countryID : null),
			'stateID' => (stateID != null? stateID : null),
			'locationID' => (locationID != null? locationID : null)
		};
		return validate_address(address, map_ids, point);
	}
	
	
	
	
	/* ------------------------------------------------------- DML STOPS ------------------------------------------------------*/
	
	public void saveStop(){
		try{
			shipment_stop.Shipment__c = shipment.Id;
			if(shipment_stop.Truckstop_Address__c == null || shipment_stop.Truckstop_Address__c == ''){
				Map<String, ID> map_ids = new Map<String, ID>();
				if(shipment_stop.Country__c != null){
					map_ids.put('countryID', shipment_stop.Country__c);
				}
				if(shipment_stop.State__c != null){
					map_ids.put('stateID', shipment_stop.State__c);
				}
				if(shipment_stop.Location__c != null){
					map_ids.put('locationID', shipment_stop.Location__c);
				}
				
				Map<String, Object> map_result = NEU_TS_WS_Tracking.validateAddress(null, map_ids, 'Stop');
				NEU_TS_WS_Tracking.TrackLocationResponse trackLocationResponse = (NEU_TS_WS_Tracking.TrackLocationResponse)map_result.get('data_parsed');
				
				if(trackLocationResponse == null){
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error saving the stop.'));
				}else if(trackLocationResponse.location == null){
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error saving the stop.'));
				}else{
					shipment_stop.Truckstop_City__c = trackLocationResponse.location.city;
					shipment_stop.Truckstop_Postal_Code__c = trackLocationResponse.location.zip;
					shipment_stop.Truckstop_State_Code__c = trackLocationResponse.location.state;
					shipment_stop.Truckstop_Country_Code__c = trackLocationResponse.location.country;
					upsert shipment_stop;
					
					shipment_stop = null;
					searchStopAddress = null;
					lst_shipment_stop = findShipmentStopsByShipment();
				}
			}else{
				upsert shipment_stop;
					
				shipment_stop = null;
				searchStopAddress = null;
				lst_shipment_stop = findShipmentStopsByShipment();
			}
			
			check_differences_with_truckstop();
		}catch(Exception ee){
			system.debug('ERROR NEU_Shipment_View_Tracking : ' + ee.getTypeName() + ' - ' + ee.getMessage() + ' - ' + ee.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error saving the stop.'));
		}
	}
	
	public void cleanStop(){
		try{
			shipment_stop = null;
			check_differences_with_truckstop();
		}catch(Exception ee){
			system.debug('ERROR NEU_Shipment_View_Tracking : ' + ee.getTypeName() + ' - ' + ee.getMessage() + ' - ' + ee.getStackTraceString());
		}
	}
	
	public void editStop(){
		try{
			List<Shipment_Stop__c> lst_stop = [
				SELECT Id, Name, Address__c, Country__c, Estimated_Time_of_Arrival__c, Geolocation__c, Location__c, Shipment__c, State__c,
					Truckstop_Address__c, Truckstop_City__c, Truckstop_Country_Code__c, Truckstop_Postal_Code__c, Truckstop_State_Code__c 
				FROM Shipment_Stop__c
				WHERE Id =: shipment_stop.Id
			];
			
			shipment_stop = lst_stop[0];
			if(shipment_stop.Truckstop_Address__c != null){
				searchStopAddress = shipment_stop.Truckstop_Address__c;
			}else if(shipment_stop.Address__c != null){
				searchStopAddress = shipment_stop.Address__c;
			}else{
				searchStopAddress = null;
			}
			
			check_differences_with_truckstop();
		}catch(Exception ee){
			system.debug('ERROR NEU_Shipment_View_Tracking : ' + ee.getTypeName() + ' - ' + ee.getMessage() + ' - ' + ee.getStackTraceString());
		}
	}
	
	public void deleteStop(){
		try{
			List<Shipment_Stop__c> lst_stop = [
				SELECT Id, Name, Address__c, Country__c, Estimated_Time_of_Arrival__c, Geolocation__c, Location__c, Shipment__c, State__c,
					Truckstop_Address__c, Truckstop_City__c, Truckstop_Country_Code__c, Truckstop_Postal_Code__c, Truckstop_State_Code__c 
				FROM Shipment_Stop__c
				WHERE Id =: shipment_stop.Id
			];
			delete lst_stop[0];
			shipment_stop = null;
			
			lst_shipment_stop = findShipmentStopsByShipment();
			check_differences_with_truckstop();
		}catch(Exception ee){
			system.debug('ERROR NEU_Shipment_View_Tracking : ' + ee.getTypeName() + ' - ' + ee.getMessage() + ' - ' + ee.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error deleting the stop.'));
		}
	}
	
	
	
	
	/* -------------------------------------------------------- NOTES -------------------------------------------------------- */
	
	public void saveNote(){
		try{
			if(new_note != null){
				if(new_note != ''){
					Map<String, Object> map_result = NEU_TS_WS_Tracking.addNote(new_note, shipment_track.Name);
					mapping_data_from_truckstop(map_result);
				}
			}
		}catch(Exception ee){
			system.debug('ERROR NEU_Shipment_View_Tracking : ' + ee.getTypeName() + ' - ' + ee.getMessage() + ' - ' + ee.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error saving the note.'));
		}
	}
	
	
	
	
	/* ------------------------------------------------------ DOCUMENTS ------------------------------------------------------ */
	
	public PageReference uploadDocument(){
		PageReference redirectPage = new PageReference('/apex/NEU_Shipment_View_Tracking');
		redirectPage.getParameters().put('id',shipment.Id);
		redirectPage.setRedirect(true);
		
		try{
			List<Folder> directorio = new List<Folder>();
			directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
			
			Map<String, String> map_documento = new Map<String, String>{
				'name' =>new_document_name,
				'body' =>EncodingUtil.base64Encode(new_document_body),
				'type' =>new_document_type
			};
			Map<String, Object> map_result = NEU_TS_WS_Tracking.uploadDocumentTS(map_documento, shipment_track.Name);
			if(map_result.get('error') != null){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(map_result.get('error'))));
				return null;
			}else{
				NEU_TS_WS_Tracking.TrackDocumentResponse track_document_response = (NEU_TS_WS_Tracking.TrackDocumentResponse)map_result.get('data_document');
				Document new_document = new Document();
				new_document.Name = new_document_name;
				new_document.Body = new_document_body;
				new_document.AuthorId = UserInfo.getUserId();
				if(directorio.size()>0){
					new_document.FolderId = directorio[0].Id;
				}
				new_document.IsPublic = true;
				insert new_document;
					
				Associated_Document__c new_document_associated = new Associated_Document__c();
				new_document_associated.Account__c = shipment.Account_for__r.Id;
				new_document_associated.Name = map_documento.get('name');
				new_document_associated.Document_Type__c = map_documento.get('type');
				new_document_associated.Shipment_Track__c=shipment_track.Id;
				new_document_associated.Shipment__c=shipment.Id;
				new_document_associated.Truckstop_Document_Id__c=track_document_response.document.documentId;
				new_document_associated.Document_URL__c = '/servlet/servlet.ImageServer?id='+new_document.Id+'&oid=' + UserInfo.getOrganizationId(); 
				insert new_document_associated;
				
				
				lst_associated_document = findAssociatedDocumentByShipmentTrack();
			}
		}catch(Exception e){
			system.debug('ERROR : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error uploading the file.'));
			return null;
		}
		
		return redirectPage;
	}
	
	public PageReference deleteDocument(){
		try{
			String documentId = System.currentPageReference().getParameters().get('documentId');
			Map<String, Object> map_result = NEU_TS_WS_Tracking.deleteDocument(shipment_track.Name, documentId);
			if(map_result.get('error') != null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(map_result.get('error'))));
				return null;
			}else{
				List<Associated_Document__c> lst_associated_document = [
					SELECT Id, Name, Shipment_Track__c, Truckstop_Document_Id__c, Document_Type__c, Document_URL__c
					FROM Associated_Document__c
					WHERE Shipment_Track__c =: shipment_track.Id 
					AND Truckstop_Document_Id__c =: documentId
				];
				
				delete lst_associated_document;
			}
		}catch(Exception e){
			system.debug('ERROR : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error deleting the file.'));
			return null;
		}
		
		PageReference redirectPage = new PageReference('/apex/NEU_Shipment_View_Tracking');
		redirectPage.setRedirect(true);
		redirectPage.getParameters().put('id',shipment.Id);
		return redirectPage;
	}
	
	public PageReference saveDocument(){
		try{
			String documentId = System.currentPageReference().getParameters().get('documentId');
			String type_document = System.currentPageReference().getParameters().get('type_document');
			String filename = System.currentPageReference().getParameters().get('filename');
			Map<String, Object> map_result = NEU_TS_WS_Tracking.getDocument(shipment_track.Name, documentId);
			if(map_result.get('error') != null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(map_result.get('error'))));
				return null;
			}else{
				Blob body = (Blob)map_result.get('data');
				if(body != null){
					List<Folder> directorio = new List<Folder>();
					directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
					
					Document documento_asociado = new Document();
					documento_asociado.Body = body;
					documento_asociado.Name = filename;
					documento_asociado.AuthorId = UserInfo.getUserId();
					
					if(directorio.size()>0){
						documento_asociado.FolderId = directorio[0].Id;
					}
					documento_asociado.IsPublic = true;
					insert documento_asociado;
						
					Associated_Document__c new_document = new Associated_Document__c();
					new_document.Account__c = shipment.Account_for__r.Id;
					new_document.Name = filename;
					new_document.Shipment_Track__c=shipment_track.Id;
					new_document.Shipment__c=shipment.Id;
					new_document.Truckstop_Document_Id__c=documentId;
					new_document.Document_Type__c = type_document;
					new_document.Document_URL__c = '/servlet/servlet.ImageServer?id='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
					insert new_document;
				}
			}
		}catch(Exception e){
			system.debug('ERROR : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error saving the file.'));
			return null;
		}
		
		PageReference redirectPage = new PageReference('/apex/NEU_Shipment_View_Tracking');
		redirectPage.setRedirect(true);
		redirectPage.getParameters().put('id',shipment.Id);
		return redirectPage;
	}
	
	
	
	
	/* ------------------------------------------------------ DOCUMENTS ------------------------------------------------------ */
	
	public void getTracking(){
		try{
            String public_URL_Tracking = '';
			if(shipment_track != null){
				if(shipment_track.Name != null){
					Map<String, Object> map_result = NEU_TS_WS_Tracking.getTrack(shipment_track.Name);
					//json_request = (map_result.get('json_request') != null ? String.valueOf(map_result.get('json_request')) : null);
					//json_response = (map_result.get('json_response') != null ? String.valueOf(map_result.get('json_response')) : null);
					mapping_data_from_truckstop(map_result);
				}
			}
			check_differences_with_truckstop();
		}catch(Exception e){
			system.debug('ERROR : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error getting the Track.'));
		}
	}
	
	public void createTracking(){
		try{
			Boolean error = validate_Address_Truckstop();
			if(error == false){
				Map<String, Object> map_result = NEU_TS_WS_Tracking.createTrack(shipment, shipment_track, lst_shipment_stop);
				mapping_data_from_truckstop(map_result);
				
				check_differences_with_truckstop();
			}
		}catch(Exception e){
			system.debug('ERROR : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString());
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error creating the track in Truckstop.'));
		}
	}
	
	public void cancelTracking(){
		try{
			Map<String, Object> map_result = NEU_TS_WS_Tracking.cancelTrack(shipment_track.Name, 'Cancel.');
			mapping_data_from_truckstop(map_result);
			
			check_differences_with_truckstop();
		}catch(Exception e){
			system.debug('ERROR : ' + e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString());
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error canceling the track in Truckstop.'));
		}
	}
	
	public void resubmitTracking(){
		try{
			/*if(track_response.trackDetail.currentState == 'NoResponse'){
				Map<String, Object> map_result_1 = NEU_TS_WS_Tracking.resubmitTrack(shipment_track.Name);
				mapping_data_from_truckstop(map_result_1);
			}else{*/
				if(differences_route == true){
					Boolean error = false;
					error = validate_Address_Truckstop();
					if(error == false){
						if(differences_operator == true){
							if(track_response.trackDetail.currentState == 'Requested' || track_response.trackDetail.currentState == 'Declined' || track_response.trackDetail.currentState == 'Cancelled' || track_response.trackDetail.currentState == 'NoResponse'){
								Map<String, Object> map_result = NEU_TS_WS_Tracking.updateTrackAndNewDriver(shipment, shipment_track, lst_shipment_stop);
								mapping_data_from_truckstop(map_result);
							}
						}else{
							if(track_response.trackDetail.currentState == 'Requested' || track_response.trackDetail.currentState == 'Declined' || track_response.trackDetail.currentState == 'Cancelled' || track_response.trackDetail.currentState == 'NoResponse'){
								Map<String, Object> map_result = NEU_TS_WS_Tracking.updateTrack(shipment, shipment_track, lst_shipment_stop);
								mapping_data_from_truckstop(map_result);
							}
						}
					}
				}else if(differences_operator == true){
					if(track_response.trackDetail.currentState == 'Requested' || track_response.trackDetail.currentState == 'Declined' || track_response.trackDetail.currentState == 'Cancelled' || track_response.trackDetail.currentState == 'NoResponse'){
						Map<String, Object> map_result = NEU_TS_WS_Tracking.requestNewDriver(shipment, shipment_track.Name);
						mapping_data_from_truckstop(map_result);
					}
				}else{
					Boolean error = false;
					error = validate_Address_Truckstop();
					if(error == false){
						if(track_response.trackDetail.currentState == 'Declined' || track_response.trackDetail.currentState == 'Cancelled'){
							Map<String, Object> map_result = NEU_TS_WS_Tracking.updateTrack(shipment, shipment_track, lst_shipment_stop);
							mapping_data_from_truckstop(map_result);
						}
					}
				}
			/*}*/
		}catch(Exception ee){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error resubmiting the track in Truckstop.'));
		}
	}
	
	
	
	
	public void mapping_data_from_truckstop(Map<String, Object> map_result){
		if(map_result.get('error') != null){
			String error_truckstop = String.valueOf(map_result.get('error'));
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, error_truckstop));
		}else{
			if(map_result.get('data') != null){
				track_response=(NEU_TS_WS_Tracking.TrackResponse)map_result.get('data');
				check_differences_with_truckstop();
				if(track_response.trackDetail != null){
					shipment_track.Current_Status__c = track_response.trackDetail.currentState;
					if(track_response.trackDetail.notes != null){
						lst_notes = new List<Note>();
						for(NEU_TS_WS_Tracking.LoadNote note_response : track_response.trackDetail.notes){
							Note note = new Note();
							note.user = note_response.creatorName;
							note.date_time = Datetime.valueOf(note_response.timestamp.replace('T', ' ').substringBeforeLast('.'));
							note.format_date_time = note.date_time.format();
							if(note_response.category == 'LoadCreation'){
								note.message = 'Track Created';
								note.category_note = 'Status Change';
							}else if(note_response.category == 'StateChange'){
								note.message = 'Track ' + note_response.label + '. Motive: ' + note_response.value;
								note.category_note = 'Status Change';
							}else if(note_response.category == 'General'){
								note.message = note_response.value;
								note.category_note = 'Note Sent';
							}else{
								note.message = note_response.value;
								note.category_note = note_response.category;
							}
							lst_notes.add(note);
						}
						
						if(track_response.trackDetail.checkCalls != null){
							for(NEU_TS_WS_Tracking.CheckCall check_call : track_response.trackDetail.checkCalls){
								String check_call_name = check_call.displayName;
								for(NEU_TS_WS_Tracking.Note note_response : check_call.notes){
									Note note = new Note();
									note.category_note = 'Note Sent';
									note.message = note_response.value;
									note.check_calls = check_call_name;
									note.user = note_response.creatorName;
									note.date_time = Datetime.valueOf(note_response.timestamp.replace('T', ' ').substringBeforeLast('.'));
									note.format_date_time = note.date_time.format();
									lst_notes.add(note);
								}
							}
						}
						
						lst_notes.sort();
					}
					
					if(track_response.trackDetail.documents != null){
						lst_documents = new List<File>();
						for(NEU_TS_WS_Tracking.File truckstop_file : track_response.trackDetail.documents){
							File file = new File();
							file.documentId = truckstop_file.documentId;
							file.fileName = truckstop_file.fileName;
							file.type_Z = truckstop_file.type_Z;
							file.date_time = Datetime.valueOf(truckstop_file.saved.replace('T', ' ').substringBeforeLast('.'));
							file.format_date_time = file.date_time.format();
							for(Associated_Document__c associated_document: lst_associated_document){
								if(truckstop_file.documentId == associated_document.Truckstop_Document_Id__c){
									file.url = associated_document.Document_URL__c;
								}
							}
							lst_documents.add(file);
						}
						
						if(track_response.trackDetail.checkCalls != null){
							for(NEU_TS_WS_Tracking.CheckCall check_call : track_response.trackDetail.checkCalls){
								String check_call_name = check_call.displayName;
								
								for(NEU_TS_WS_Tracking.File truckstop_file : check_call.documents){
									File file = new File();
									file.documentId = truckstop_file.documentId;
									file.fileName = truckstop_file.fileName;
									file.type_Z = truckstop_file.type_Z;
									file.check_calls = check_call_name;
									file.date_time = Datetime.valueOf(truckstop_file.saved.replace('T', ' ').substringBeforeLast('.'));
									file.format_date_time = file.date_time.format();
									for(Associated_Document__c associated_document: lst_associated_document){
										if(truckstop_file.documentId == associated_document.Truckstop_Document_Id__c){
											file.url = associated_document.Document_URL__c;
										}
									}
									lst_documents.add(file);
								}
							}
						}
						
						lst_documents.sort();
					}
				}
				new_note = null;
			}
		}
	}
	
	
	
	
	
	public Boolean validate_Address_Truckstop(){
		Boolean error = false;
		
		Map<String, String> map_ids = new Map<String, String>();
		map_ids.put('shipmentID', shipment.Id);
		
		if(shipment_track.Truckstop_Origin_Address__c == null || shipment_track.Truckstop_Origin_Address__c == ''){
			Map<String, Object> map_result = NEU_TS_WS_Tracking.validateAddress(null, map_ids, 'Origin');
			if(map_result.get('error')!= null){
				error = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(map_result.get('error'))));
			}else{
				NEU_TS_WS_Tracking.TrackLocationResponse trackLocationResponse = (NEU_TS_WS_Tracking.TrackLocationResponse)map_result.get('data_parsed');
				shipment_track.Truckstop_Origin_City__c = trackLocationResponse.location.city;
				shipment_track.Truckstop_Origin_Postal_Code__c = trackLocationResponse.location.zip;
				shipment_track.Truckstop_Origin_State_Code__c = trackLocationResponse.location.state;
				shipment_track.Truckstop_Origin_Country_Code__c = trackLocationResponse.location.country;
			}
		}
		
		if(shipment_track.Truckstop_Destination_Address__c == null || shipment_track.Truckstop_Destination_Address__c == ''){
			Map<String, Object> map_result = NEU_TS_WS_Tracking.validateAddress(null, map_ids, 'Destination');
			if(map_result.get('error')!= null){
				error = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(map_result.get('error'))));
			}else{
				NEU_TS_WS_Tracking.TrackLocationResponse trackLocationResponse = (NEU_TS_WS_Tracking.TrackLocationResponse)map_result.get('data_parsed');
				shipment_track.Truckstop_Destination_City__c = trackLocationResponse.location.city;
				shipment_track.Truckstop_Destination_Postal_Code__c = trackLocationResponse.location.zip;
				shipment_track.Truckstop_Destination_State_Code__c = trackLocationResponse.location.state;
				shipment_track.Truckstop_Destination_Country_Code__c = trackLocationResponse.location.country;
			}
		}
		
		if(error == false){
			lst_shipment_stop = findShipmentStopsByShipment();
			if(lst_shipment_stop.size() > 0){
				for(Shipment_Stop__c s_stop : lst_shipment_stop){
					if(error == false){
						if(s_stop.Address__c == null && s_stop.Truckstop_Address__c == null){
							if (s_stop.Truckstop_City__c == null){
								Map<String, String> map_ids_stop = new Map<String, String>();
								map_ids_stop.put('country', s_stop.Country__r.Name);
								map_ids_stop.put('state', s_stop.State__r.Name);
								map_ids_stop.put('location', s_stop.Location__r.Name);
								
								Map<String, Object> map_result = NEU_TS_WS_Tracking.validateAddress(null, map_ids_stop, 'Stop');
								if(map_result.get('error')!= null){
									error = true;
									ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.valueOf(map_result.get('error'))));
								}else{
									NEU_TS_WS_Tracking.TrackLocationResponse trackLocationResponse = (NEU_TS_WS_Tracking.TrackLocationResponse)map_result.get('data_parsed');
									s_stop.Truckstop_City__c = trackLocationResponse.location.city;
									s_stop.Truckstop_Postal_Code__c = trackLocationResponse.location.zip;
									s_stop.Truckstop_State_Code__c = trackLocationResponse.location.state;
									s_stop.Truckstop_Country_Code__c = trackLocationResponse.location.country;
								}
							}
						}
					}
				}
			}
		}
		
		return error;
	}
	
	
	
	
	
	
	/* ------------------------------------------------------- FINDERS ------------------------------------------------------- */
	
	public Shipment__c findShipmentById(Id shipment_Id){
		String query='SELECT Id,Name';
		Map<String,Schema.SObjectField>objectFields=Shipment__c.getSobjectType().getDescribe().fields.getMap();
		for(String s:objectFields.keySet()){
			if((s!='Id')&&(s!='Name')){
				query+=','+s;
			}
		}
		query+=' , Account_for__r.Id ';
		query+=' , Country_of_Discharge__r.ISO_Code__c, Country_of_Load__r.ISO_Code__c ';
		query+=' , State_of_Discharge__r.ISO_Code_2c__c, State_of_Load__r.ISO_Code_2c__c ';
		query+=' , Site_of_Discharge__r.Name, Site_of_Load__r.Name ';
		query+=' , Delivery_Cartage__r.Name, Pickup_Cartage__r.Name ';
		query+=' , National_Operator__r.Truckstop_Phone__c, National_Operator__r.Truckstop_Email__c, National_Operator__r.Truckstop_Name__c ';
		query+=' FROM Shipment__c ';
		query+=' WHERE Id=\''+shipment_Id+'\'';
		List<Shipment__c> lst_shipment = database.query(query);
		
		if(lst_shipment.size() > 0){
			return lst_shipment[0];
		}else{
			return null;
		}
	}
	
	public Shipment_Track__c findShipmentTrackByShipment(){
		String query='SELECT Id,Name';
		Map<String,Schema.SObjectField>objectFields=Shipment_Track__c.getSobjectType().getDescribe().fields.getMap();
		for(String s:objectFields.keySet()){
			if((s!='Id')&&(s!='Name')){
				query+=','+s;
			}
		}
		query+=' FROM Shipment_Track__c ';
		query+=' WHERE Shipment__c=\''+shipment.Id+'\'';
		List<Shipment_Track__c> lst_shipment_tracks = database.query(query);
		if (lst_shipment_tracks != null && lst_shipment_tracks.size() > 0){
			return lst_shipment_tracks[0];
		}else{
			return null;
		}
	}
	
	public List<Shipment_Stop__c> findShipmentStopsByShipment(){
		String query='SELECT Id,Name';
		Map<String,Schema.SObjectField>objectFields=Shipment_Stop__c.getSobjectType().getDescribe().fields.getMap();
		for(String s:objectFields.keySet()){
			if((s!='Id')&&(s!='Name')){
				query+=','+s;
			}
		}
		query+=' , Country__r.Name, Country__r.ISO_Code__c, State__r.Name, State__r.ISO_Code_2c__c, Location__r.Name';
		query+=' FROM Shipment_Stop__c ';
		query+=' WHERE Shipment__c=\''+shipment.Id+'\'';
		return database.query(query);
	}
	
	public List<Associated_Document__c> findAssociatedDocumentByShipmentTrack(){
		if(shipment_track != null){
			if(shipment_track.Id != null){
				String query='SELECT Id,Name';
				Map<String,Schema.SObjectField>objectFields=Associated_Document__c.getSobjectType().getDescribe().fields.getMap();
				for(String s:objectFields.keySet()){
					if((s!='Id')&&(s!='Name')){
						query+=','+s;
					}
				}
				query+=' FROM Associated_Document__c ';
				query+=' WHERE Shipment_Track__c=\''+shipment_track.Id+'\'';
				return database.query(query);
			}else{
				return new List<Associated_Document__c>();
			}
		}else{
			return new List<Associated_Document__c>();
		}
	}
	
	
	
	/* ------------------------------------------------------- UTILS ------------------------------------------------------- */
	
	public void check_differences_with_truckstop(){
		if(track_response != null){
			if(track_response.trackDetail != null){
				shipment_track.Current_Status__c = track_response.trackDetail.currentState;
				if(shipment_track.Current_Status__c != 'Requested' && shipment_track.Current_Status__c != 'NoResponse' && shipment_track.Current_Status__c != 'Cancelled' && shipment_track.Current_Status__c != 'Declined'){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'The Track is active. You can not change the information.'));
				}else{
					differences_route = false;
					differences_operator = false;
					
					if(track_response.trackDetail.destination != null){
						check_differences_values(track_response.trackDetail.destination.country, shipment_track.Truckstop_Destination_Country_Code__c, 'Country of Discharge differences. ');
						check_differences_values(track_response.trackDetail.destination.state, shipment_track.Truckstop_Destination_State_Code__c, 'State of Discharge differences. ');
						check_differences_values(track_response.trackDetail.destination.city, shipment_track.Truckstop_Destination_City__c, 'Site of Discharge differences. ');
						check_differences_values(track_response.trackDetail.destination.zip, shipment_track.Truckstop_Destination_Postal_Code__c, 'Delivery Zone differences. ');
						check_differences_values(track_response.trackDetail.destination.address, shipment_track.Truckstop_Destination_Address__c, 'Delivery Address differences. ');
						if(shipment.ETA_Point_of_Discharge__c != null && shipment.ETA_Time_Point_of_Discharge__c != null){
							DateTime ETA = DateTime.newInstance(shipment.ETA_Point_of_Discharge__c.year(), shipment.ETA_Point_of_Discharge__c.month(), shipment.ETA_Point_of_Discharge__c.day(), shipment.ETA_Time_Point_of_Discharge__c.hour(), shipment.ETA_Time_Point_of_Discharge__c.minute(), 00);
							DateTime ETA2 = DateTime.valueOf(track_response.trackDetail.destination.eventDateTime.replace('T', ' ').replace('Z',''));
							ETA2 = ETA2.addHours(-6);
							check_differences_values(String.valueOf(ETA2), String.valueOf(ETA), 'ETA differences. ');
						}
					}
						
					if(track_response.trackDetail.origin != null){
						check_differences_values(track_response.trackDetail.origin.country, shipment_track.Truckstop_Origin_Country_Code__c, 'Country of Load differences. ');
						check_differences_values(track_response.trackDetail.origin.state, shipment_track.Truckstop_Origin_State_Code__c, 'State of Load differences. ');
						check_differences_values(track_response.trackDetail.origin.city, shipment_track.Truckstop_Origin_City__c, 'Site of Load differences. ');
						check_differences_values(track_response.trackDetail.origin.zip, shipment_track.Truckstop_Origin_Postal_Code__c, 'Pickup Zone differences. ');
						check_differences_values(track_response.trackDetail.origin.address, shipment_track.Truckstop_Origin_Address__c, 'Origin Address differences. ');
						
						if(shipment.ETD_from_Point_of_Load__c != null && shipment.ETD_Time_from_Point_of_Load__c != null){
							DateTime ETD = DateTime.newInstance(shipment.ETD_from_Point_of_Load__c.year(), shipment.ETD_from_Point_of_Load__c.month(), shipment.ETD_from_Point_of_Load__c.day(), shipment.ETD_Time_from_Point_of_Load__c.hour(), shipment.ETD_Time_from_Point_of_Load__c.minute(), 00);
							DateTime ETD2 = DateTime.valueOf(track_response.trackDetail.origin.eventDateTime.replace('T', ' ').replace('Z',''));
							ETD2 = ETD2.addHours(-6);
							check_differences_values(String.valueOf(ETD2), String.valueOf(ETD), 'ETD differences. ');
						}
						//check_differences_values(track_response.trackDetail.origin.eventLocalDateTime, String.valueOf(shipment.ETD_from_Point_of_Load__c) + 'T' + String.valueOf(shipment.ETD_Time_from_Point_of_Load__c) + '-05:00', 'ETD differences. ');
					}
					
					if(track_response.trackDetail.management != null){
						if(track_response.trackDetail.management.drivers != null){
							for(NEU_TS_WS_Tracking.LoadDriver driver : track_response.trackDetail.management.drivers){
								if(driver.state == 'Active'){
									if(driver.driverDetail != null){
										if(driver.driverDetail.email != null && driver.driverDetail.email != '' && driver.driverDetail.email != 'UNREGISTERED'){
											check_differences_values(driver.driverDetail.email, shipment.National_Operator__r.Truckstop_Email__c, 'Operator differences. ');
										}else{
											if(driver.driverDetail.receivers != null){
												check_differences_values(driver.driverDetail.receivers[0].number_Z, shipment.National_Operator__r.Truckstop_Phone__c, 'Operator differences. ');
											}
										}
									}
								}
							}
						}
					}
					
					if(track_response.trackDetail.additionalStops != null && lst_shipment_stop == null){
                        system.debug('DEBUG TRUCKSTOP DIFFERENCES: [truckstop_stops: +, pak2go_stops: 0].');
						differences_route = true;
					}else if(track_response.trackDetail.additionalStops == null && lst_shipment_stop != null){
                        system.debug('DEBUG TRUCKSTOP DIFFERENCES: [truckstop_stops: 0, pak2go_stops: +].');
						differences_route = true;
					}else if(track_response.trackDetail.additionalStops != null && lst_shipment_stop != null){
						if(track_response.trackDetail.additionalStops.size() != lst_shipment_stop.size()){
                            system.debug('DEBUG TRUCKSTOP DIFFERENCES: [truckstop_stops: +, pak2go_stops: +]. But different vallues.');
							differences_route = true;
						}else{
							Integer cont_coincidencias = 0;
							for(NEU_TS_WS_Tracking.LocationDetail additionaStop : track_response.trackDetail.additionalStops){
								for(Shipment_Stop__c shipment_stop : lst_shipment_stop){
									if(check_differences_stop_value(additionaStop, shipment_stop) == true){
										cont_coincidencias = cont_coincidencias + 1;
									}
								}
							}
							if(cont_coincidencias != lst_shipment_stop.size()){
								differences_route = true;
							}
						}
					}
					
					if(differences_route == true || differences_operator == true){
						String message = 'The information of the Shipment and the Track in Truckstop are different. Please resubmit the information before it is accepted by the Operator.';
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, message));
					}
				}
			}
		}
		check_data_complete();
	}
	
	public void check_differences_values(String value_truckstop, String value_pak2go, String prefix){
		if(value_truckstop == null){
			value_truckstop = '';
		}
		
		if(value_pak2go == null){
			value_pak2go = '';
		}
		
		if(value_truckstop != value_pak2go){
			system.debug('DEBUG TRUCKSTOP DIFFERENCES: [value_truckstop: ' + value_truckstop + ', value_pak2go: ' + value_pak2go + '].' + prefix);
			if(prefix == 'Operator differences. '){
				differences_operator = true;
			}else{
				differences_route = true;
			}
		}
	}
	
	public Boolean check_differences_stop_value(NEU_TS_WS_Tracking.LocationDetail stop_truckstop, Shipment_Stop__c shipment_stop){
		Boolean coincide = true;
		DateTime ETA_Stop = null;
		DateTime ETA_Stop_2 = null;
		if(shipment_stop.Estimated_Time_of_Arrival__c != null){
			ETA_Stop = DateTime.newInstance(shipment_stop.Estimated_Time_of_Arrival__c.year(), shipment_stop.Estimated_Time_of_Arrival__c.month(), shipment_stop.Estimated_Time_of_Arrival__c.day(), shipment_stop.Estimated_Time_of_Arrival__c.hour(), shipment_stop.Estimated_Time_of_Arrival__c.minute(), 00);
		}
		
		if(stop_truckstop.eventDateTime != null){
			ETA_Stop_2 = DateTime.valueOf(stop_truckstop.eventDateTime.replace('T', ' ').replace('Z',''));
			ETA_Stop_2 = ETA_Stop_2.addHours(-6);
		}
		
		
		Map<String, String> map_value_mapping = new Map<String, String>{
			'stop_truckstop_country' => (stop_truckstop.country == null ? '' : stop_truckstop.country),
			'stop_truckstop_state' => (stop_truckstop.state == null ? '' : stop_truckstop.state),
			'stop_truckstop_city' => (stop_truckstop.city == null ? '' : stop_truckstop.city),
			'stop_truckstop_address' => (stop_truckstop.address == null ? '' : stop_truckstop.address),
			'stop_truckstop_eta' => (ETA_Stop_2 == null ? '' : String.valueOf(ETA_Stop_2)),
			
			'stop_shipment_country' => (shipment_stop.Truckstop_Country_Code__c == null ? '' : shipment_stop.Truckstop_Country_Code__c),
			'stop_shipment_state' => (shipment_stop.Truckstop_State_Code__c == null ? '' : shipment_stop.Truckstop_State_Code__c),
			'stop_shipment_city' => (shipment_stop.Truckstop_City__c == null ? '' : shipment_stop.Truckstop_City__c),
			'stop_shipment_address' => (shipment_stop.Truckstop_Address__c == null ? '' : shipment_stop.Truckstop_Address__c),
			'stop_shipment_eta' => (ETA_Stop == null ? '' : String.valueOf(ETA_Stop))
		};
		
		if(coincide == true && map_value_mapping.get('stop_truckstop_country') != map_value_mapping.get('stop_shipment_country')){
            system.debug('DEBUG TRUCKSTOP DIFFERENCES: [stop_truckstop_country: ' + map_value_mapping.get('stop_truckstop_country') + ', stop_shipment_country: ' + map_value_mapping.get('stop_shipment_country') + ']');
			coincide = false;
		}
		if(coincide == true && map_value_mapping.get('stop_truckstop_state') != map_value_mapping.get('stop_shipment_state')){
            system.debug('DEBUG TRUCKSTOP DIFFERENCES: [stop_truckstop_state: ' + map_value_mapping.get('stop_truckstop_state') + ', stop_shipment_state: ' + map_value_mapping.get('stop_shipment_state') + ']');
			coincide = false;
		}
		if(coincide == true && map_value_mapping.get('stop_truckstop_city') != map_value_mapping.get('stop_shipment_city')){
            system.debug('DEBUG TRUCKSTOP DIFFERENCES: [stop_truckstop_city: ' + map_value_mapping.get('stop_truckstop_city') + ', stop_shipment_city: ' + map_value_mapping.get('stop_shipment_city') + ']');
			coincide = false;
		}
		if(coincide == true && map_value_mapping.get('stop_truckstop_address') != map_value_mapping.get('stop_shipment_address')){
            system.debug('DEBUG TRUCKSTOP DIFFERENCES: [stop_truckstop_address: ' + map_value_mapping.get('stop_truckstop_address') + ', stop_shipment_address: ' + map_value_mapping.get('stop_shipment_address') + ']');
			coincide = false;
		}
		if(coincide == true && map_value_mapping.get('stop_truckstop_eta') != map_value_mapping.get('stop_shipment_eta')){
            system.debug('DEBUG TRUCKSTOP DIFFERENCES: [stop_truckstop_eta: ' + map_value_mapping.get('stop_truckstop_eta') + ', stop_shipment_eta: ' + map_value_mapping.get('stop_shipment_eta') + ']');
			coincide = false;
		}
		
		return coincide;
	}
	
	public void check_data_complete(){
		complete_data = true;
		if(shipment != null){
			Boolean saltar_comprobaciones = false;
			if(shipment_track != null){
				if(shipment_track.Id != null){
					if(shipment_track.Current_Status__c == 'Active' || shipment_track.Current_Status__c == 'Accepted' || shipment_track.Current_Status__c == 'Incomplete' || shipment_track.Current_Status__c == 'Completed'){
						saltar_comprobaciones = true;
					}
				}
			}
			
			if(saltar_comprobaciones == false){
				if(shipment.Country_of_Load__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"Country of Load" is empty.'));
				}else if(shipment.Country_of_Load__r.ISO_Code__c == null){
					//complete_data = false;
					//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ISO Code" for "Country of Load" is empty.'));
				}
				
				if(shipment.Country_of_Discharge__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"Country of Discharge" is empty.'));
				}else if(shipment.Country_of_Discharge__r.ISO_Code__c == null){
					//complete_data = false;
					//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ISO Code" for "Country of Discharge" is empty.'));
				}
				
				if(shipment.State_of_Load__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"State of Load" is empty.'));
				}else if(shipment.State_of_Load__r.ISO_Code_2c__c == null){
					//complete_data = false;
					//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ISO Code 2c" for "State of Load" is empty.'));
				}
				
				if(shipment.State_of_Discharge__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"State of Discharge" is empty.'));
				}else if(shipment.State_of_Discharge__r.ISO_Code_2c__c == null){
					//complete_data = false;
					//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ISO Code 2c" for "State of Discharge" is empty.'));
				}
				
				if(shipment.Site_of_Load__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"Site of Load" is empty.'));
				}
				
				if(shipment.Site_of_Discharge__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"Site of Discharge" is empty.'));
				}
				
				if(shipment.ETD_from_Point_of_Load__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ETD" is empty.'));
				}
				
				if(shipment.ETD_Time_from_Point_of_Load__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ETD Time" is empty.'));
				}
				
				if(shipment.ETD_from_Point_of_Load__c != null && shipment.ETD_Time_from_Point_of_Load__c != null){
					DateTime ETD = DateTime.newInstance(shipment.ETD_from_Point_of_Load__c.year(), shipment.ETD_from_Point_of_Load__c.month(), shipment.ETD_from_Point_of_Load__c.day(), shipment.ETD_Time_from_Point_of_Load__c.hour(), shipment.ETD_Time_from_Point_of_Load__c.minute(), 00);
					DateTime now = system.today();
					system.debug('DateTime: '+ shipment.ETD_from_Point_of_Load__c+ ' < ' + now);
					if(ETD.getTime() < now.getTime()){
						complete_data = false;
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ETD" can not be earlier than today.'));
					}
				}
				
				if(shipment.ETA_Point_of_Discharge__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ETA" is empty.'));
				}
				
				if(shipment.ETA_Time_Point_of_Discharge__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ETA Time" is empty.'));
				}
				
				if(shipment.ETA_Point_of_Discharge__c != null && shipment.ETA_Time_Point_of_Discharge__c != null){
					if(shipment.ETD_from_Point_of_Load__c != null  && shipment.ETD_Time_from_Point_of_Load__c != null){
						
						DateTime ETD = DateTime.newInstance(shipment.ETD_from_Point_of_Load__c.year(), shipment.ETD_from_Point_of_Load__c.month(), shipment.ETD_from_Point_of_Load__c.day(), shipment.ETD_Time_from_Point_of_Load__c.hour(), shipment.ETD_Time_from_Point_of_Load__c.minute(), 00);
						DateTime ETA = DateTime.newInstance(shipment.ETA_Point_of_Discharge__c.year(), shipment.ETA_Point_of_Discharge__c.month(), shipment.ETA_Point_of_Discharge__c.day(), shipment.ETA_Time_Point_of_Discharge__c.hour(), shipment.ETA_Time_Point_of_Discharge__c.minute(), 00);
						
						if(ETA.getTime() < ETD.getTime()){
							complete_data = false;
							ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"ETA" can not be earlier than "ETD".'));
						}
					}
				}
				
				if(shipment.National_Operator__c == null){
					complete_data = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"Operator" is empty.'));
				}else{ 
					/*if(shipment.National_Operator__r.Truckstop_Name__c == null || shipment.National_Operator__r.Truckstop_Name__c == ''){
						complete_data = false;
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"Truckstop Name" for "Operator" is empty.'));
					}*/
					if(shipment.National_Operator__r.Truckstop_Email__c == null && shipment.National_Operator__r.Truckstop_Phone__c == null){
						complete_data = false;
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '"Truckstop Email" and "Truckstop Phone" for "Operator" is empty. Once is required.'));
					}
				}
				
				lst_shipment_stop = findShipmentStopsByShipment();
				for(Shipment_Stop__c stop : lst_shipment_stop){
					if(stop.Country__c == null){
						complete_data = false;
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "Country" is empty.'));
					}else if(stop.Country__r.ISO_Code__c == null){
						//complete_data = false;
						//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "ISO Code" for "Country" is empty.'));
					}
					
					if(stop.State__c == null){
						complete_data = false;
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "State" is empty.'));
					}else if(stop.State__r.ISO_Code_2c__c == null){
						//complete_data = false;
						//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "ISO Code 2c" for "State" is empty.'));
					}
					
					if(stop.Location__c == null){
						complete_data = false;
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "Location" is empty.'));
					}
					
					if(stop.Estimated_Time_of_Arrival__c == null){
						complete_data = false;
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "ETA" is empty.'));
					}else{
						if(shipment.ETD_from_Point_of_Load__c != null){
							DateTime ETD = DateTime.newInstance(shipment.ETD_from_Point_of_Load__c.year(), shipment.ETD_from_Point_of_Load__c.month(), shipment.ETD_from_Point_of_Load__c.day(), 00, 00, 00);
							
							if(stop.Estimated_Time_of_Arrival__c < ETD){
								complete_data = false;
								ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "ETA" can not be earlier than "ETD".'));
							}
						}
						
						if(shipment.ETA_Point_of_Discharge__c != null){
							DateTime ETA = DateTime.newInstance(shipment.ETA_Point_of_Discharge__c.year(), shipment.ETA_Point_of_Discharge__c.month(), shipment.ETA_Point_of_Discharge__c.day(), 11, 59, 59);
							if(stop.Estimated_Time_of_Arrival__c > ETA){
								complete_data = false;
								ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Stop(' + stop.Name + '). "ETA" can not be greater than "ETA" Shipment.'));
							}
						}
					}
					
					if(stop.Address__c != null && stop.Truckstop_Address__c == null){
						ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Stop(' + stop.Name + '). Please edit the stop and select a valid address.'));
					}
				}
			}
		}
		
		if(complete_data == false && shipment_track.Id == null){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Errors must be resolved before you can create the Track.'));
		}
		
		if(complete_data == false && (differences_route == true || differences_operator == true)){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Errors must be resolved before you can resubmit the Track.'));
		}
	}
}