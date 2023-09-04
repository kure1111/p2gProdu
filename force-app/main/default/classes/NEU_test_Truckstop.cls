@isTest
private class NEU_test_Truckstop {

	@testSetup
	static void setup(){
		NEU_StaticVariableHelper.setBoolean1(true);

		CSL_Credentials__c auth = new CSL_Credentials__c(
			External_Id__c = 'x',
			Password__c = 'x',
			Login__c = 'x'
		);
		insert auth;
		
		Country__c country = new Country__c(
			Name = 'Mexico',
			ISO_Code_2c__c = 'MX',
			ISO_Code__c = 'MEX'
		);
		insert country;
		
		State__c state = new State__c(
			Name = 'Sonora',
			ISO_Code_2c__c = 'SO',
			country__c = country.Id
		);
		insert state;
		
		Location__c location = new Location__c(
			Name = 'Hermosillo',
			state__c = state.Id,
			country__c = country.Id
		);
		insert location;
		
		
		Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(
			Country_of_Load__c = country.Id,
			Country_of_Discharge__c = country.Id,
			Port_Airport_of_Load__c = location.Id,
			Port_Airport_of_Discharge__c = location.Id,
			State_of_Load__c = state.Id,
			State_of_Discharge__c = state.Id
		);
		insert route;
		
		List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,Supplier');
		Account a = list_accounts[0];
		Account customer = list_accounts[0];
		Account carrier = list_accounts[1];
		Account supplier = list_accounts[2];
		List<Account> lst_account = new List<Account>{
			customer, carrier, supplier
		};
		insert lst_account;
		
		Contact contact = new Contact();
		contact.LastName = 'Driver';
		contact.Email = 'test@neurored.com.test';
		insert contact;
		
		Operadores__c operador = new Operadores__c();
		operador.Account__c = carrier.Id;
		operador.Truckstop_Email__c = 'test@neurored.com.test';
		insert operador;
		
		Shipment__c shipment = new Shipment__c(
			Account_for__c = customer.Id,
			Carrier__c = carrier.Id,
			National_Operator__c = operador.Id,
			Freight_Mode__c='Road',
			Service_Type__c ='FTL',
			Service_Mode__c ='Import',
			Country_of_Load__c = country.Id,
			State_of_Load__c = state.Id,
			Site_of_Load__c = location.Id,
			Country_of_Discharge__c = country.Id,
			State_of_Discharge__c = state.Id,
			Site_of_Discharge__c = location.Id,
			ETA_Point_of_Discharge__c = Date.newInstance(2300, 2, 17),
			ETA_Time_Point_of_Discharge__c = Time.newInstance(18, 30, 2, 20),
			ETD_from_Point_of_Load__c = Date.newInstance(2300, 2, 19),
			ETD_Time_from_Point_of_Load__c = Time.newInstance(18, 30, 2, 20)
		);
		insert shipment;
	}
	
	static testMethod void test_NEU_TS_WS_RateMate() {
		NEU_StaticVariableHelper.setBoolean1(true);

		Country__c country = [SELECT Id, Name, ISO_Code__c, ISO_Code_2c__c FROM Country__c];
		State__c state = [SELECT Id, Name, ISO_Code_2c__c FROM State__c WHERE Country__c =: country.Id];
		Location__c location = [SELECT Id, Name FROM Location__c WHERE Country__c =: country.Id AND State__c =: state.Id];
		
		NEU_TS_WS_RateMate ts_ws_ratemate = new NEU_TS_WS_RateMate();
		CSL_Credentials__c auth = new CSL_Credentials__c();
		auth.External_Id__c = 'x';
		auth.Password__c = 'x';
		auth.Login__c = 'x';
		ts_ws_ratemate.auth_ts_rateMate.add(auth);
		
		ts_ws_ratemate.filter = new NEU_TS_WS_RateMate.Filter();
		ts_ws_ratemate.filter.imp_exp = new Customer_Quote__c(); 
		
		ts_ws_ratemate.filter.imp_exp.Country_ofLoad__c = country.Id;
		ts_ws_ratemate.filter.imp_exp.State_of_Load__c = state.Id;
		ts_ws_ratemate.filter.imp_exp.Site_of_Load__c = location.Id;
		ts_ws_ratemate.filter.imp_exp.Country_ofDischarge__c = country.Id;
		ts_ws_ratemate.filter.imp_exp.State_of_Discharge__c = state.Id;
		ts_ws_ratemate.filter.imp_exp.Site_of_Discharge__c = location.Id;
		
		ts_ws_ratemate.NEU_TS_Call_FuelSurcharge();
		ts_ws_ratemate.search_rates();
		ts_ws_ratemate.search_with_filters();
		ts_ws_ratemate.call_rate_info();
		
		String xml = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
		xml += '<s:Body>';
		xml += '	 <GetNegotiationStrengthResponse xmlns="http://tempuri.org/">';
		xml += '		<GetNegotiationStrengthResult xmlns:a="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
		xml += '			<Errors xmlns="http://schemas.datacontract.org/2004/07/WebServices"/>';
		xml += '			<a:LoadsDroppingOff xmlns:b="http://schemas.datacontract.org/2004/07/WebServices.Objects">';
		xml += '				<b:Destination>0</b:Destination>';
		xml += '				<b:Origin>0</b:Origin>';
		xml += '			</a:LoadsDroppingOff>';
		xml += '			<a:LoadsPickingUp xmlns:b="http://schemas.datacontract.org/2004/07/WebServices.Objects">';
		xml += '				<b:Destination>0</b:Destination>';
		xml += '				<b:Origin>0</b:Origin>';
		xml += '			</a:LoadsPickingUp>';
		xml += '			<a:LookingForLoads xmlns:b="http://schemas.datacontract.org/2004/07/WebServices.Objects">';
		xml += '				<b:Destination>0</b:Destination>';
		xml += '				<b:Origin>0</b:Origin>';
		xml += '			</a:LookingForLoads>';
		xml += '			<a:NegotiationStrength xmlns:b="http://schemas.datacontract.org/2004/07/WebServices.Objects">';
		xml += '				<b:Destination>verygood</b:Destination>';
		xml += '				<b:Origin>verygood</b:Origin>';
		xml += '			</a:NegotiationStrength>';
		xml += '			<a:TrucksAvailable xmlns:b="http://schemas.datacontract.org/2004/07/WebServices.Objects">';
		xml += '				<b:Destination>0</b:Destination>';
		xml += '				<b:Origin>0</b:Origin>';
		xml += '			</a:TrucksAvailable>';
		xml += '		</GetNegotiationStrengthResult>';
		xml += '	</GetNegotiationStrengthResponse>';
		xml += '</s:Body>';
		xml += '</s:Envelope>';
		ts_ws_ratemate.proccess_response(xml);
		
		xml = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
		xml += '<s:Body>';
		xml += '	<GetHistoricalRatesResponse xmlns="http://tempuri.org/">';
		xml += '		<GetHistoricalRatesResult xmlns:a="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
		xml += '			<Errors xmlns="http://schemas.datacontract.org/2004/07/WebServices"/>';
		xml += '			<a:History>';
		xml += '				<a:HistoricalRate>';
		xml += '					<a:AverageFuelCostPerMile>0.48</a:AverageFuelCostPerMile>';
		xml += '					<a:AverageMiles>1557</a:AverageMiles>';
		xml += '					<a:AverageRateToShipper>2.07</a:AverageRateToShipper>';
		xml += '					<a:AverageRateToTrucker>2.07</a:AverageRateToTrucker>';
		xml += '					<a:AverageTotalRate>3227.2222</a:AverageTotalRate>';
		xml += '					<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '					<a:Month>9</a:Month>';
		xml += '					<a:Year>2017</a:Year>';
		xml += '				</a:HistoricalRate>';
		xml += '				<a:HistoricalRate>';
		xml += '					<a:AverageFuelCostPerMile>0.44</a:AverageFuelCostPerMile>';
		xml += '					<a:AverageMiles>1432</a:AverageMiles>';
		xml += '					<a:AverageRateToShipper>2.12</a:AverageRateToShipper>';
		xml += '					<a:AverageRateToTrucker>2.12</a:AverageRateToTrucker>';
		xml += '					<a:AverageTotalRate>3033.5461</a:AverageTotalRate>';
		xml += '					<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '					<a:Month>8</a:Month>';
		xml += '					<a:Year>2017</a:Year>';
		xml += '				</a:HistoricalRate>';
		xml += '			</a:History>';
		xml += '		</GetHistoricalRatesResult>';
		xml += '	</GetHistoricalRatesResponse>';
		xml += '</s:Body>';
		xml += '</s:Envelope>';
		ts_ws_ratemate.proccess_response(xml);
		
		xml = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
		xml += '	<s:Body>';
		xml += '		<GetRateIndexResponse xmlns="http://tempuri.org/">';
		xml += '			<GetRateIndexResult xmlns:a="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
		xml += '				<Errors xmlns="http://schemas.datacontract.org/2004/07/WebServices"/>';
		xml += '				<a:Paid>';
		xml += '					<a:Rates>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>1466</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>1.99</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>1.99</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>2911.1956</a:AverageTotalRate>';
		xml += '							<a:Days>30</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>46</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>1519</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>1.86</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>1.86</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>2828.7797</a:AverageTotalRate>';
		xml += '							<a:Days>90</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>134</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>1528</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>1.81</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>1.81</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>2765.4198</a:AverageTotalRate>';
		xml += '							<a:Days>365</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>528</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '					</a:Rates>';
		xml += '				</a:Paid>';
		xml += '				<a:PaidShipper i:nil="true"/>';
		xml += '				<a:Posted>';
		xml += '					<a:Rates>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>0</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>0</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>0</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>0</a:AverageTotalRate>';
		xml += '							<a:Days>7</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>0</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>0</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>0</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>0</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>0</a:AverageTotalRate>';
		xml += '							<a:Days>15</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>0</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>0</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>0</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>0</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>0</a:AverageTotalRate>';
		xml += '							<a:Days>30</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>0</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>0</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>0</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>0</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>0</a:AverageTotalRate>';
		xml += '							<a:Days>90</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>0</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '						<a:Rate>';
		xml += '							<a:AverageMiles>1391</a:AverageMiles>';
		xml += '							<a:AverageRateToShipper>2.01</a:AverageRateToShipper>';
		xml += '							<a:AverageRateToTrucker>2.01</a:AverageRateToTrucker>';
		xml += '							<a:AverageTotalRate>2792.6768</a:AverageTotalRate>';
		xml += '							<a:Days>365</a:Days>';
		xml += '							<a:DesiredMargin>0</a:DesiredMargin>';
		xml += '							<a:NumberOfReports>263</a:NumberOfReports>';
		xml += '						</a:Rate>';
		xml += '					</a:Rates>';
		xml += '				</a:Posted>';
		xml += '			</GetRateIndexResult>';
		xml += '		</GetRateIndexResponse>';
		xml += '	</s:Body>';
		xml += '</s:Envelope>';
		ts_ws_ratemate.proccess_response(xml);
		
		xml = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
		xml += '	<s:Body>';
		xml += '		<GetFuelSurchargeResponse xmlns="http://tempuri.org/">';
		xml += '			<GetFuelSurchargeResult xmlns:a="http://schemas.datacontract.org/2004/07/WebServices.Objects.RateMate" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
		xml += '				<Errors xmlns="http://schemas.datacontract.org/2004/07/WebServices"/>';
		xml += '				<a:BaseLineFuelPrice>1.15</a:BaseLineFuelPrice>';
		xml += '				<a:EstimatedFuelCost>814.57</a:EstimatedFuelCost>';
		xml += '				<a:EstimatedFuelCostPerMile>0.53</a:EstimatedFuelCostPerMile>';
		xml += '				<a:FuelPricePerGallon>2.629</a:FuelPricePerGallon>';
		xml += '				<a:MilesPerGallon>5.0</a:MilesPerGallon>';
		xml += '				<a:SurchargePerMile>0.2958</a:SurchargePerMile>';
		xml += '				<a:SurchargeTotal>458.25336</a:SurchargeTotal>';
		xml += '				<a:TotalMiles>1549.2</a:TotalMiles>';
		xml += '			</GetFuelSurchargeResult>';
		xml += '		</GetFuelSurchargeResponse>';
		xml += '	</s:Body>';
		xml += '</s:Envelope>';
		ts_ws_ratemate.proccess_response(xml);
	}
	
	static testMethod void test_NEU_TS_WS_Tracking() {
		Country__c country = [SELECT Id, Name, ISO_Code__c, ISO_Code_2c__c FROM Country__c];
		State__c state = [SELECT Id, Name, ISO_Code_2c__c FROM State__c WHERE Country__c =: country.Id];
		Location__c location = [SELECT Id, Name FROM Location__c WHERE Country__c =: country.Id AND State__c =: state.Id];
		
		Account customer = [SELECT Id, Name FROM Account WHERE RecordTypeId =: Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()];
		Account carrier = [SELECT Id, Name FROM Account WHERE RecordTypeId =: Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()];
		
		Contact contact = [SELECT Id, LastName, Email FROM Contact];
		
		Shipment__c shipment = [
			SELECT Id, Name, Account_for__c, Carrier__c, National_Operator__c, National_Operator__r.Truckstop_Email__c, Freight_Mode__c, Service_Type__c, 
				Service_Mode__c, Country_of_Load__c, State_of_Load__c, Site_of_Load__c, Country_of_Discharge__c, 
				State_of_Discharge__c, Site_of_Discharge__c, ETA_Point_of_Discharge__c, ETA_Time_Point_of_Discharge__c, 
				ETD_from_Point_of_Load__c, ETD_Time_from_Point_of_Load__c 
			FROM Shipment__c limit 1
		];
		
		ApexPages.StandardController controller = new ApexPages.StandardController(shipment);
		NEU_Shipment_View_Tracking shipment_view_tracking = new NEU_Shipment_View_Tracking(controller);
		
		List<SelectOption> lst_option = shipment_view_tracking.getFtypes();
		
		Shipment_Stop__c shipment_stop = new Shipment_Stop__c();
		shipment_stop.Name = 'Stop B';
		shipment_stop.Country__c = country.Id;
		shipment_stop.State__c = state.Id;
		shipment_stop.Location__c = location.Id;
		shipment_stop.Estimated_Time_of_Arrival__c = system.now();
		
		shipment_view_tracking.cleanStop();
		shipment_view_tracking.shipment_stop = shipment_stop;
		shipment_view_tracking.saveStop();
		shipment_view_tracking.editStop();
		shipment_view_tracking.deleteStop();
		
		shipment_view_tracking.createTracking();
		
		Shipment_Track__c shipment_track = shipment_view_tracking.shipment_track;
		if(shipment_track == null){
			shipment_track = new Shipment_Track__c();
		}
		shipment_track.Current_Status__c = 'Requested';
		shipment_track.Shipment__c = shipment.Id;
		shipment_track.Reference_Id__c = shipment.Name;
		shipment_track.Name = 'x';
		insert shipment_track;
		
		shipment_view_tracking.shipment_track = shipment_track;
		shipment_view_tracking.getTracking();
		NEU_TS_WS_Tracking.cancelTrack(shipment_track.Name, 'Test');
		NEU_TS_WS_Tracking.resubmitTrack(shipment_track.Name);
		
		Map<String, String> map_documento = new Map<String, String>{
			'type' => 'x',
			'name' => 'x',
			'body' => 'x'
		};
		
		NEU_TS_WS_Tracking.uploadDocumentTS(map_documento, shipment_track.Name);
		
		List<Shipment_Stop__c> lst_shipment_stop = new List<Shipment_Stop__c>();
		Shipment_Stop__c shipment_stop2 = new Shipment_Stop__c();
		shipment_stop2.Shipment__c = shipment.Id;
		shipment_stop2.Name = 'Stop B';
		shipment_stop2.Country__c = country.Id;
		shipment_stop2.State__c = state.Id;
		shipment_stop2.Location__c = location.Id;
		shipment_stop2.Estimated_Time_of_Arrival__c = system.now();
		lst_shipment_stop.add(shipment_stop2);
		insert lst_shipment_stop;
		
		NEU_TS_WS_Tracking.updateTrack(shipment, shipment_track, lst_shipment_stop);
		NEU_TS_WS_Tracking.requestNewDriver(shipment, shipment_track.Name);
		
		NEU_TS_WS_Tracking.TrackCreateDetail track_create_detail = new NEU_TS_WS_Tracking.TrackCreateDetail(System.JSON.createParser('{"data":{"sequenceNumber":0,"referenceId":"2017-02-15T13:03:42.9440000-07:00","trackingNumber":"5LXKE6G","loadId":"4354","ownerAccount":"1594","ownerCompany":"1000061","warningMessages": null,"errorMessage":null},"statusCode":0,"message":"OK."}'));
		NEU_TS_WS_Tracking.PositionDetail position_detail = new NEU_TS_WS_Tracking.PositionDetail(System.JSON.createParser('{"address":"1313 Disneyland Dr","city":"Anaheim","state":"CA","zip":"92802","country":"USA","deviceTimestamp": "2017-01-23T15:00:00Z","latitude":33.8153047,"longitude":-117.9262072,"receivedTimestamp": "2017-01-23T15:01:00Z","eventLocalDateTime": "2017-01-23T09:01:00"}'));
		NEU_TS_WS_Tracking.BrokerTrackSummary brocker_track_summary = new NEU_TS_WS_Tracking.BrokerTrackSummary(System.JSON.createParser('{"lastCompletedCheckCall": {"callId": "26","callType": "ArrivedAtShipper","displayName": "Arrived At Shipper","driver": "1234","recorded": "2017-01-23T15:00:00Z","eventLocalDateTime": "2017-01-23T09:00:00","location": {"address": "123 Main St.","city": "Boise","state": "ID","zip": "83713","country": "USA","latitude": 43.6187102,"longitude": -116.2146068,"timezone": "Mountain Standard Time"},"notes": [{"creatorAccountNumber": "1234","creatorName": "Joe Carrier","timestamp": "2017-01-23T15:00:12.218Z","eventLocalDateTime": "2017-01-23T09:00:12.218Z","value": "Test note message"}]},"destination": {"locationId": "43e07a4b622844e28b3f150e2d10554a","company":"Origin Integration Company","contact":"Integration Team","contactNumber":"2081234567","address": "1444 S Entertainment Ave","city": "Boise","state": "ID","zip": "83709","country": "USA","eventDateTime": "2017-03-23T13:43:19.976Z","eventToleranceHours": 0,"geofenceRadius": 1,"eventLocalDateTime": "2017-03-23T07:43:19.976","latitude": 43.5910896,"longitude": -116.2782056,"timezone": "Mountain Standard Time"},"distanceTotal": 19,"distanceFromOrigin": 0,"distanceFromDestination": 18.8,"lastUpdateDT": "2017-01-21T00:02:25.468Z","management": {"currentCompanyAccount": "1000061","currentUserAccount": "1594","owners": [{"userAccount": "1594","companyAccount": "1000061","companyDetail": {"accountNumber": "1234","name": "Joes Crab Shack","mainAddress": {"country": "USA","street": "123 Main St.","city": "Boise","state": "ID","zip": "83713","ZipExt": "1234"},"billingAddress": {"country": "USA","street": "123 Main St.","city": "Boise","state": "ID","zip": "83713","ZipExt": "1234"},"phones": [{"number": "208-555-1234"}]},"ownerDetail": {"accountNumber": "1234","email": "JoeDriver@email.com","name": "Joe Driver","receivers": [{"number": "208-555-1234"}]}}],"drivers": [{"accountNumber": "1234","driverDetail": {"accountNumber": "1234","email": "JoeDriver@email.com","name": "Joe Driver","receivers": [{"number": "208-555-1234"}]}}]},"origin": {"locationId": "43e07a4b622844e28b3f150e2d10554a","company":"Origin Integration Company","contact":"Integration Team","contactNumber":"2081234567","address": "1444 S Entertainment Ave","city": "Boise","state": "ID","zip": "83709","country": "USA","eventDateTime": "2017-03-21T13:43:19.976Z","eventToleranceHours": 0,"geofenceRadius": 1,"eventLocalDateTime": "2017-03-21T07:43:19.976","latitude": 43.5910896,"longitude": -116.2782056,"timezone": "Mountain Standard Time"},"referenceId": null,"sourceSystem": null,"currentStatus": {"userAccountNumber": "1594","when": "2017-01-21T00:02:25.796Z","state": "Requested"},"trackingNumber": "8EW765P","lastKnownLocation": {"address": "123 Main St.","city": "Kuna","state": "ID","zip": "83715","country": "USA","deviceTimestamp": "2017-01-23T15:00:00Z","latitude": 43.4918307,"longitude": -116.4201223,"receivedTimestamp": "2017-01-23T15:01:00Z","eventLocalDateTime": "2017-01-23T09:01:00"},"positionHistory": [{"accountNumber": "1710","address": "123 Main St.","city": "Kuna","state": "ID","zip": "83715","country": "USA","deviceTimestamp": "2017-01-23T15:00:00Z","latitude": 43.4918307,"longitude": -116.4201223,"receivedTimestamp": "Mountain Standard Time"}],"actualDeliveryDate": null,"actualPickupDate": null,"startTrackBeforePickupInHours": 6}'));
		//shipment_view_tracking.new_note = 'Prueba';
		//shipment_view_tracking.saveNote();
	}
	
	static testMethod void test_NEU_Shipment_View_Tracking() {
		Country__c country = [SELECT Id, Name, ISO_Code__c, ISO_Code_2c__c FROM Country__c];
		State__c state = [SELECT Id, Name, ISO_Code_2c__c FROM State__c WHERE Country__c =: country.Id];
		Location__c location = [SELECT Id, Name FROM Location__c WHERE Country__c =: country.Id AND State__c =: state.Id];
		
		Account customer = [SELECT Id, Name FROM Account WHERE RecordTypeId =: Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()];
		Account carrier = [SELECT Id, Name FROM Account WHERE RecordTypeId =: Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()];
		
		Contact contact = [SELECT Id, LastName, Email FROM Contact];
		
		Operadores__c operador = [SELECT Id, Account__c, Truckstop_Email__c FROM Operadores__c];
		
		Shipment__c shipment = new Shipment__c();
		shipment.Account_for__c = customer.Id;
		shipment.Carrier__c = carrier.Id;
		shipment.National_Operator__c = operador.Id;
		shipment.ETA_Point_of_Discharge__c = Date.newInstance(2300, 2, 17);
		shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(18, 30, 2, 20);
		shipment.ETD_from_Point_of_Load__c = Date.newInstance(2300, 2, 19);
		shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(18, 30, 2, 20);
		shipment.Freight_Mode__c='Road';
		shipment.Service_Type__c ='FTL';
		shipment.Service_Mode__c ='Import';
		insert shipment;
		
		ApexPages.StandardController controller = new ApexPages.StandardController(shipment);
		NEU_Shipment_View_Tracking shipment_view_tracking = new NEU_Shipment_View_Tracking(controller);
		
		List<SelectOption> lst_option = shipment_view_tracking.getFtypes();
		
		Shipment_Stop__c shipment_stop = new Shipment_Stop__c();
		shipment_stop.Name = 'Stop A';
		shipment_stop.Country__c = country.Id;
		shipment_stop.State__c = state.Id;
		shipment_stop.Location__c = location.Id;
		shipment_stop.Estimated_Time_of_Arrival__c = system.now();
		
		shipment_view_tracking.cleanStop();
		shipment_view_tracking.shipment_stop = shipment_stop;
		shipment_view_tracking.saveStop();
		shipment_view_tracking.editStop();
		shipment_view_tracking.deleteStop();
		
		shipment_view_tracking.createTracking();
		shipment_view_tracking.resubmitTracking();
		Shipment_Track__c shipment_track = shipment_view_tracking.shipment_track;
		if(shipment_track == null){
			shipment_track = new Shipment_Track__c();
		}
		shipment_track.Current_Status__c = 'Requested';
		shipment_track.Shipment__c = shipment.Id;
		shipment_track.Reference_Id__c = shipment.Name;
		shipment_track.Name = 'x';
		insert shipment_track;
		
		shipment_view_tracking.shipment_track = shipment_track;
		shipment_view_tracking.getTracking();
		shipment_view_tracking.saveNote();
		shipment_view_tracking.cancelTracking();
		shipment_view_tracking.resubmitTracking();
		
		Shipment_Stop__c shipment_stop_b = new Shipment_Stop__c();
		shipment_stop_b.Name = 'Stop B';
		shipment_stop_b.Country__c = country.Id;
		shipment_stop_b.State__c = state.Id;
		shipment_stop_b.Location__c = location.Id;
		shipment_stop_b.Estimated_Time_of_Arrival__c = system.now();
		shipment_stop_b.Shipment__c = shipment.Id;
		insert shipment_stop_b;
		shipment_view_tracking.validate_Address_Truckstop();
		
		shipment_view_tracking.new_document_body = Blob.valueof('x');
		shipment_view_tracking.new_document_name = 'x';
		shipment_view_tracking.new_document_type = 'x';
		shipment_view_tracking.uploadDocument();
		shipment_view_tracking.saveDocument();
		shipment_view_tracking.deleteDocument();
	}
}