/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
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
	
	static testMethod void NEU_RoadRatesSearch() {
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
		service_rate.Fee_Category__c = 'Road Freights';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		service_rate.Route__c=route.Id;
		
		insert service_rate;
		
		NEU_RoadFreight neu_road_freight=new NEU_RoadFreight();
		List<SelectOption> lst_categories = neu_road_freight.getCategory();
		
		neu_road_freight.filter = service_rate;
		neu_road_freight.filter.route__r = route;
		
		neu_road_freight.page = '1';
		neu_road_freight.fill_new_service_rate();
		
		neu_road_freight.service_rate_new.fee1.Fee_Rate__c = 23;
		neu_road_freight.service_rate_new.fee2.Fee_Rate__c = 23;
		
		neu_road_freight.save();
		String margin1 = neu_road_freight.service_rate_new.margin1;
		String margin2 = neu_road_freight.service_rate_new.margin2;
		
		neu_road_freight.search_with_filters();
		neu_road_freight.id_service = service_rate.Id;
		neu_road_freight.get_historical_prices();
	}
	
	static testMethod void NEU_AirRatesSearch() {
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
		location.IATA_Code__c= '12345';
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
		service_rate.Fee_Category__c = 'Road Freights';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		service_rate.Route__c=route.Id;
		
		insert service_rate;
		
		NEU_AirFreight neu_air_freight=new NEU_AirFreight();
		List<SelectOption> lst_categories = neu_air_freight.getCategory();
		
		neu_air_freight.filter = service_rate;
		neu_air_freight.filter.route__r = route;
		
		neu_air_freight.page = '1';
		neu_air_freight.fill_new_service_rate();
		
		neu_air_freight.save();
		String margin = neu_air_freight.service_rate_new.margin;
		
		neu_air_freight.search_with_filters();
		neu_air_freight.id_service = service_rate.Id;
		neu_air_freight.get_historical_prices();
	}
	
	static testMethod void NEU_POLRatesSearch() {
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
		location.IATA_Code__c= '12345';
		insert location;
		
		Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c();
		route.Name='San Antonio';
		route.State_of_Load__c=state.Id;
		route.Country_of_Load__c=country.Id;
		route.Port_Airport_of_Load__c=location.Id;
		insert route;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio--TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'POL Charges';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		service_rate.Route__c=route.Id;
				
		insert service_rate;
		
		NEU_POLFreight neu_pol_freight=new NEU_POLFreight();
		List<SelectOption> lst_categories = neu_pol_freight.getCategory();
		
		neu_pol_freight.filter = service_rate;
		neu_pol_freight.filter.route__r = route;
		
		neu_pol_freight.page = '1';
		neu_pol_freight.fill_new_service_rate();
		
		neu_pol_freight.save();
		String margin = neu_pol_freight.service_rate_new.margin;
		
		neu_pol_freight.search_with_filters();
		neu_pol_freight.id_service = service_rate.Id;
		neu_pol_freight.get_historical_prices();
	}
	
	static testMethod void NEU_PODRatesSearch() {
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
		location.IATA_Code__c= '12345';
		insert location;
		
		Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c();
		route.Name=' - San Antonio';
		route.State_of_Discharge__c=state.Id;
		route.Country_of_Discharge__c=country.Id;
		route.Port_Airport_of_Discharge__c=location.Id;
		insert route;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'POD Charges';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		service_rate.Route__c=route.Id;
				
		insert service_rate;
		
		NEU_POLFreight neu_pod_freight=new NEU_POLFreight();
		List<SelectOption> lst_categories = neu_pod_freight.getCategory();
		
		neu_pod_freight.filter = service_rate;
		neu_pod_freight.filter.route__r = route;
		
		neu_pod_freight.page = '1';
		neu_pod_freight.fill_new_service_rate();
		
		neu_pod_freight.save();
		String margin = neu_pod_freight.service_rate_new.margin;
		
		neu_pod_freight.search_with_filters();
		neu_pod_freight.id_service = service_rate.Id;
		neu_pod_freight.get_historical_prices();
	}
	
	static testMethod void NEU_OtherRatesSearch() {
		NEU_StaticVariableHelper.setBoolean1(true);
		//create record test necessaries
		Account account=new Account();
		account.Name='TEST';
		account.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
		insert account;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'Road Freights';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		
		insert service_rate;
		
		NEU_OtherFreight neu_other_freight=new NEU_OtherFreight();
		List<SelectOption> lst_categories = neu_other_freight.getCategory();
		
		neu_other_freight.filter = service_rate;
		
		neu_other_freight.page = '1';
		neu_other_freight.fill_new_service_rate();
		
		neu_other_freight.save();
		String margin = neu_other_freight.service_rate_new.margin;
		
		neu_other_freight.search_with_filters();
		neu_other_freight.id_service = service_rate.Id;
		neu_other_freight.get_historical_prices();
	}
	
	static testMethod void NEU_DrayagesRatesSearch() {
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
		location.IATA_Code__c= '12345';
		insert location;
		
		Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c();
		route.Name='San Antonio - Barcelona';
		route.State_of_Load__c=state.Id;
		route.Country_of_Load__c=country.Id;
		route.Port_Airport_of_Load__c=location.Id;
		insert route;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'Drayages';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		service_rate.Route__c=route.Id;
		service_rate.Port_Airport__c = location.Id;
		
		insert service_rate;
		
		NEU_DrayagesFreight neu_drayages_freight=new NEU_DrayagesFreight();
		List<SelectOption> lst_categories = neu_drayages_freight.getCategory();
		
		neu_drayages_freight.filter = service_rate;
		neu_drayages_freight.filter.route__r = route;
		
		neu_drayages_freight.page = '1';
		neu_drayages_freight.fill_new_service_rate();
		
		neu_drayages_freight.save();
		String margin = neu_drayages_freight.service_rate_new.margin;
		
		
		neu_drayages_freight.search_with_filters();
		neu_drayages_freight.id_service = service_rate.Id;
		neu_drayages_freight.get_historical_prices();
	}
	
	static testMethod void NEU_TarimasRatesSearch() {
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
		location.IATA_Code__c= '12345';
		insert location;
		
		Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c();
		route.Name='San Antonio - Barcelona';
		route.State_of_Load__c=state.Id;
		route.State_of_Discharge__c=state.Id;
		route.Country_of_Load__c=country.Id;
		route.Country_of_Discharge__c=country.Id;
		route.Port_Airport_of_Load__c=location.Id;
		route.Port_Airport_of_Discharge__c=location.Id;
		insert route;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'Tarimas';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		service_rate.Route__c=route.Id;
		
		insert service_rate;
		
		NEU_TarimasFreight neu_tarimas_freight=new NEU_TarimasFreight();
		List<SelectOption> lst_categories = neu_tarimas_freight.getCategory();
		
		neu_tarimas_freight.filter = service_rate;
		neu_tarimas_freight.filter.route__r = route;
		
		neu_tarimas_freight.page = '1';
		neu_tarimas_freight.fill_new_service_rate();
		
		neu_tarimas_freight.save();
		String margin = neu_tarimas_freight.service_rate_new.margin;
		
		neu_tarimas_freight.search_with_filters();
		neu_tarimas_freight.id_service = service_rate.Id;
		neu_tarimas_freight.get_historical_prices();
	}
	
	static testMethod void NEU_PaqueteriaRatesSearch() {
		NEU_StaticVariableHelper.setBoolean1(true);
		//create record test necessaries
		Account account=new Account();
		account.Name='TEST';
		account.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
		insert account;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'Mayoreo';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		
		insert service_rate;
		
		NEU_PaqueteriaFreight neu_paqueteria_freight=new NEU_PaqueteriaFreight();
		List<SelectOption> lst_categories = neu_paqueteria_freight.getCategory();
		
		neu_paqueteria_freight.filter = service_rate;
		
		neu_paqueteria_freight.page = '1';
		neu_paqueteria_freight.fill_new_service_rate();
		
		neu_paqueteria_freight.save();
		String margin = neu_paqueteria_freight.service_rate_new.margin;
		
		neu_paqueteria_freight.search_with_filters();
		neu_paqueteria_freight.id_service = service_rate.Id;
		neu_paqueteria_freight.get_historical_prices();
	}
	
	static testMethod void NEU_PaqueteriaExpressRatesSearch() {
		NEU_StaticVariableHelper.setBoolean1(true);
		//create record test necessaries
		Account account=new Account();
		account.Name='TEST';
		account.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
		insert account;
		
		Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST';
		NEU_CurrencyUtils.setCurrencyISOCode(service_rate,UserInfo.getDefaultCurrency());
		service_rate.Fee_Category__c = 'Mayoreo';
		service_rate.Rate_Type__c = 'Per Container';
		service_rate.Account_for__c=account.Id;
		service_rate.Carrier_Account__c=account.Id;
		service_rate.Valid_Until__c=Date.newInstance(2017,11,11);
		service_rate.Valid_from__c=Date.newInstance(2017,10,10);
		service_rate.Buy_Rate__c=12;
		service_rate.Fee_Rate__c=23;
		
		insert service_rate;
		
		NEU_PaqueteriaExpressFreight neu_paqueteria_freight=new NEU_PaqueteriaExpressFreight();
		List<SelectOption> lst_categories = neu_paqueteria_freight.getCategory();
		
		neu_paqueteria_freight.filter = service_rate;
		
		neu_paqueteria_freight.page = '1';
		neu_paqueteria_freight.fill_new_service_rate();
		
		neu_paqueteria_freight.save();
		String margin = neu_paqueteria_freight.service_rate_new.margin;
		
		neu_paqueteria_freight.search_with_filters();
		neu_paqueteria_freight.id_service = service_rate.Id;
		neu_paqueteria_freight.get_historical_prices();
	}
}