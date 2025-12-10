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
			Name='asda',
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
	
}