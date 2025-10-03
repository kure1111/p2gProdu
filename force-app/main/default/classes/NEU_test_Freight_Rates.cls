@isTest
private class NEU_test_Freight_Rates {

	static testMethod void NEU_SeaRatesSearch() {
		NEU_StaticVariableHelper.setBoolean1(true);
		//create record test necessaries
		Account account=new Account();
		account.Name='TEST';
		account.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
		insert account;
		
		Country__c country = new Country__c(Name='United States',  ISO_Code__c='EUR');
		insert country;
		
		State__c state = new State__c();
		state.Name='Texas';
		state.Country__c=country.Id;
		insert state;
		
		Location__c location = new Location__c();
		location.Name='San Antonio';
		location.Country__c=country.Id;
		location.State__c=state.Id;
		insert location;
		
		Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c();
		route.Name='San Antonio - Barcelona';
		route.State_of_Discharge__c=state.Id;
		route.State_of_Load__c=state.Id;
		route.Country_of_Discharge__c=country.Id;
		route.Country_of_Load__c=country.Id;
		route.Port_Airport_of_Discharge__c=location.Id;
		route.Port_Airport_of_Load__c=location.Id;
		insert route;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'Sea Freights';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		service_rate.Route__c=route.Id;
		
		insert service_rate;
		
		NEU_SeaFreight neu_sea_freight=new NEU_SeaFreight();
		List<SelectOption> lst_categories = neu_sea_freight.getCategory();
		
		neu_sea_freight.filter = service_rate;
		neu_sea_freight.filter.route__r = route;
		
		neu_sea_freight.page = '1';
		neu_sea_freight.fill_new_service_rate();
		
		neu_sea_freight.save();
		String margin = neu_sea_freight.service_rate_new.margin;
		
		neu_sea_freight.search_with_filters();
		neu_sea_freight.id_service = service_rate.Id;
		neu_sea_freight.get_historical_prices();
	}
	
}