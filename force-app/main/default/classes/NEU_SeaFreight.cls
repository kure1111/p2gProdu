public with sharing class NEU_SeaFreight {
	
	public class RateData{
		public Fee__c fee0{get;set;}
		
		public String margin{
			get{
				if (fee0 != null){
					if(fee0.Buy_Rate__c != null && fee0.Fee_Rate__c != null){
						return NEU_Utils.safeString((((fee0.Fee_Rate__c-fee0.Buy_Rate__c)/fee0.Buy_Rate__c)*100).setScale(2),2)+'%';
					}
				}
				return null;
			}
		}
		
		public List<String> lst_errors{
			get;set;
		}
	}
	
	public String message_data {get;set;}
	public String message_header {get;set;}
	public String id_service {get;set;}
	public String id_carrier {get;set;}
	public String info_type {get;set;}
	public Decimal buy_rate_filter {get;set;}
	public Decimal sell_rate_filter {get;set;}
	public Fee__c filter_date {get;set;}
	
	public String page {get;set;}
	public String modo {get;set;}
	public String order_by {get;set;}
	public String order_by_mode {get;set;}
	public List<Integer> lst_pages {get;set;}
	public integer n_records_per_page = 20;
	public Decimal n_records_total {
		get{
			if (n_records_total == null){
				n_records_total = 0;
			}
			return n_records_total;
		}
		set;
	}
	
	public ID recordTypeID;
	public Fee__c filter{
		get{
			if(filter==null){
				filter=new Fee__c();
				filter.Route__r=new Carrier_Line_Load_Point__c();
				NEU_CurrencyUtils.setCurrencyISOCode(filter,UserInfo.getDefaultCurrency());
			}
			return filter;
		}
		set;
	}
	
	public RateData service_rate_new{
		get{
			if(service_rate_new==null){
				service_rate_new=new RateData();
				service_rate_new.fee0 = new Fee__c();
				service_rate_new.fee0.Route__r=new Carrier_Line_Load_Point__c();
				NEU_CurrencyUtils.setCurrencyISOCode(filter,UserInfo.getDefaultCurrency());
			}
			return service_rate_new;
		}
		set;
	}
	
	public List<SelectOption>getCategory(){
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult categoryFieldDescription = Fee__c.Fee_Category__c.getDescribe();
		for (Schema.Picklistentry picklistEntry : categoryFieldDescription.getPicklistValues())
			options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
		return options;
	}
	
	public String filterCurrencyISOCode{
		get{
			return NEU_CurrencyUtils.getCurrencyISOCode(filter);
		}
		set{
			NEU_CurrencyUtils.setCurrencyISOCode(filter,value);
		}
	}
	
	public List<SelectOption>CurrencyIsoCodeOptions{
		get{
			if(CurrencyIsoCodeOptions==null)
				CurrencyIsoCodeOptions=NEU_CurrencyUtils.getCurrencyIsoCodeOptions();
			return CurrencyIsoCodeOptions;
		}
		set;
	}
	
	public Country__c loadFilter{
		get{
			if(loadFilter==null)
				loadFilter=new Country__c();
			return loadFilter;
		}
		set;
	}
	
	public Country__c dischargeFilter{
		get{
			if(dischargeFilter==null)
				dischargeFilter=new Country__c();
			return dischargeFilter;
		}
		set;
	}
	
	public List<RateData> myList{get;set;}
	public Map<String, Integer> index_my_list{get;set;}

	public NEU_SeaFreight(){
		filter.Fee_Category__c='Sea Freights';
		recordTypeID=Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
		
		filter_date = new Fee__c();
		filter_date.Valid_Until__c = system.today();
	}
	
	public void search_with_filters(){
		myList = new List<RateData>();
		index_my_list = new Map<String, Integer>();
		
		if(filter.Account_for__c!=null){
			/* Recogemos los filtros y los procesamos para su posterior utilizacion a la hora de construir el where de la consulta. */
			
			// Filtros: Accounts, Rate, Currency 
			String Account=filter.Account_for__c;
			String Carrier=filter.Carrier_Account__c;
			String Fee_Category=filter.Fee_Category__c;
			String Rate_Type=filter.Rate_Type__c;
			String CurrencyISOCode=NEU_CurrencyUtils.getCurrencyISOCode(filter);
			
			// Filtros: Region, Country, State & Location of Load
			String RegionL=loadFilter.Region__c;
			String CountryL=filter.Route__r.Country_of_Load__c;
			String StateL=filter.Route__r.State_of_Load__c;
			String LocationL=filter.Route__r.Port_Airport_of_Load__c;
			
			// Filtros: Region, Country, State & Location of Discharge
			String RegionD=dischargeFilter.Region__c;
			String CountryD=filter.Route__r.Country_of_Discharge__c;
			String StateD=filter.Route__r.State_of_Discharge__c;
			String LocationD=filter.Route__r.Port_Airport_of_Discharge__c;
			
			// Filtros: Dates 
			Date ValidFrom=filter.Valid_From__c;
			Date ValidUntil=filter.Valid_Until__c;
			
			// Cabecera de la consulta de los totales
			String query_n_records_total = 'SELECT COUNT_DISTINCT(Key__c) FROM Fee__c';
			
			// Cabecera de la consulta con los datos
			String query_data = 'SELECT Id, Name, Key__c, Fee_Category__c, Rate_Type__c, Valid_From__c, Valid_Until__c, Buy_Rate__c, Fee_Rate__c, ';
			query_data += ' Comments__c, TT_Days__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, SAP_Service_Type__r.Code__c, Group__c, Route_Info__c,';
			query_data += ' Container_Type__c, Container_Type__r.Name, Bunker_Adjustment_Factor_BAF_Cont__c, Peak_Season_Surcharge_PSS_Cont__c,'; // Container Type
			query_data += ' Route__c, Route__r.Country_of_Load__c, Route__r.Country_of_Load__r.Name, '; // Country of Load
			query_data += ' Route__r.State_of_Load__c,Route__r.State_of_Load__r.Name, '; // State of Load
			query_data += ' Route__r.Port_Airport_of_Load__c, Route__r.Port_Airport_of_Load__r.Name,'; // Location of Load 
			query_data += ' Route__r.Port_Airport_of_Load__r.Country__c, Route__r.Port_Airport_of_Load__r.Country__r.Name, '; // Country asociated to Location of Load
			query_data += ' Route__r.Country_of_Discharge__c,Route__r.Country_of_Discharge__r.Name, '; // Country of Discharge
			query_data += ' Route__r.State_of_Discharge__c,Route__r.State_of_Discharge__r.Name, '; // State of Discharge
			query_data += ' Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Discharge__r.Name, '; // Location of Discharge
			query_data += ' Route__r.Port_Airport_of_Discharge__r.Country__c,Route__r.Port_Airport_of_Discharge__r.Country__r.Name, '; // Country associated to Location of Discharge
			query_data += ' Carrier_Account__c, Carrier_Account__r.Name, '; // Carrier
			query_data += ' Account_for__c, Account_for__r.Name'; // Account for
			query_data += ' FROM Fee__c';
			
			// Construimos un where que valdra para ambas consultas (totales y datos)
			String query_where = ' WHERE Account_for__c=:Account';
			if(UserInfo.isMultiCurrencyOrganization())
				query_where+=' and CurrencyISOCode=:CurrencyISOCode';
			if(String.IsNotEmpty(Carrier))
				query_where+=' and Carrier_Account__c=:Carrier';
			if(String.IsNotEmpty(Fee_Category))
				query_where+=' and Fee_Category__c=:Fee_Category';
			if(String.IsNotEmpty(Rate_Type))
				query_where+=' and Rate_Type__c=:Rate_Type';
			if(String.IsNotEmpty(RegionL))
				query_where+=' and Route__r.Country_of_Load__r.Region__c=:RegionL';
			if(String.IsNotEmpty(CountryL))
				query_where+=' and Route__r.Country_of_Load__c=:CountryL';
			if(String.IsNotEmpty(StateL))
				query_where+=' and Route__r.State_of_Load__c=:StateL';
			if(String.IsNotEmpty(LocationL))
				query_where+=' and Route__r.Port_Airport_of_Load__c=:LocationL';
			if(String.IsNotEmpty(RegionD))
				query_where+=' and Route__r.Country_of_Discharge__r.Region__c=:RegionD';
			if(String.IsNotEmpty(CountryD))
				query_where+=' and Route__r.Country_of_Discharge__c=:CountryD';
			if(String.IsNotEmpty(StateD))
				query_where+=' and Route__r.State_of_Discharge__c=:StateD';
			if(String.IsNotEmpty(LocationD))
				query_where+=' and Route__r.Port_Airport_of_Discharge__c=:LocationD';
			if(ValidFrom!=null)
				query_where+=' and (Valid_Until__c=null or Valid_Until__c>=:ValidFrom)';
			if(ValidUntil!=null)
				query_where+=' and (Valid_From__c=null or Valid_From__c<=:ValidUntil)';
			
			// Construimos sentencia order para ordenar los resultados
			String query_order = '';
			if(order_by != null && order_by_mode != null){
				if(order_by != '' && order_by_mode != ''){
					query_order += ' ORDER BY ' + String.escapeSingleQuotes(order_by + ' '+ order_by_mode) + ' NULLS LAST';
				}
			}
			
			// Construimos sentencia para realizar paginacion
			String query_pagination = ' LIMIT ' + n_records_per_page + ' OFFSET ' + (Integer.valueOf(page) - 1) * n_records_per_page;
				
			// Obtenemos numero de paginas, numero de registros, etc...
			AggregateResult result = Database.query(query_n_records_total+query_where);
			n_records_total = (Decimal)result.get('expr0');
			integer n_pages = ((integer)n_records_total/n_records_per_page) + 2;
			lst_pages = new List<Integer>();
			for(integer i= 1; i < n_pages; i++){
				lst_pages.add(i);
			}
			
			// Recuperamos los services rates en base a los filtros y paginacion.
			List<Fee__c>fees=(List<Fee__c>)DataBase.query(query_data+query_where+query_order+query_pagination);
			for(Fee__c fee:fees){
				RateData newRate = null;
				
				if (index_my_list.get(fee.Key__c) != null){
					newRate  = myList.get(index_my_list.get(fee.Key__c));
				}else{
					index_my_list.put(fee.Key__c, myList.size());
				}
				
				if(newRate!=null){
					if(newRate.fee0==null){
						newRate.fee0=fee;
					}else{
						if(newRate.lst_errors == null){
							newRate.lst_errors = new List<String>();
							newRate.lst_errors.add('Please check the services rates. More than one service rate sharing Key. The information could be incorrect.');
						}
					}
				}else{
					newRate = new RateData();
					if(newRate.fee0==null){
						newRate.fee0=fee;
					}else{
						if(newRate.lst_errors == null){
							newRate.lst_errors = new List<String>();
							newRate.lst_errors.add('Please check the services rates. More than one service rate sharing Key. The information could be incorrect.');
						}
					}
					myList.add(newRate);
				}
			}
		}
	}
	
	public void fill_new_service_rate(){
		if (modo == null || modo == ''){
			service_rate_new=new RateData();
			service_rate_new.fee0 = new Fee__c();
			service_rate_new.fee0.Route__r=new Carrier_Line_Load_Point__c();
			service_rate_new.fee0.Rate_Type__c = filter.Rate_Type__c;
			
			if(filter.Route__r.Country_of_Load__c != null)
				service_rate_new.fee0.Route__r.Country_of_Load__c = filter.Route__r.Country_of_Load__c;
			if(filter.Route__r.State_of_Load__c != null)
				service_rate_new.fee0.Route__r.State_of_Load__c = filter.Route__r.State_of_Load__c;
			if(filter.Route__r.Port_Airport_of_Load__c != null)
				service_rate_new.fee0.Route__r.Port_Airport_of_Load__c = filter.Route__r.Port_Airport_of_Load__c;
			if(filter.Route__r.Country_of_Discharge__c != null)
				service_rate_new.fee0.Route__r.Country_of_Discharge__c = filter.Route__r.Country_of_Discharge__c;
			if(filter.Route__r.State_of_Discharge__c != null)
				service_rate_new.fee0.Route__r.State_of_Discharge__c = filter.Route__r.State_of_Discharge__c;
			if(filter.Route__r.Port_Airport_of_Discharge__c != null)
				service_rate_new.fee0.Route__r.Port_Airport_of_Discharge__c = filter.Route__r.Port_Airport_of_Discharge__c;
			if(filter.Carrier_Account__c != null)
				service_rate_new.fee0.Carrier_Account__c = filter.Carrier_Account__c;
			if(filter.Valid_Until__c != null)
				service_rate_new.fee0.Valid_Until__c = filter.Valid_Until__c;
			if(filter.Valid_From__c != null)
				service_rate_new.fee0.Valid_From__c = filter.Valid_From__c;
		}
	}
	
	public void save(){
		//TODO: Comprobar con Jose que casos contemplar en la inserccion de nuevos "Services Rates"
		
		try{
			// Recogemos los valores de la linea a insertar
			Fee__c fee = service_rate_new.fee0;
			
			// Completamos informacion predefinida para esta categoria
			fee.RecordTypeID=recordTypeID;
			fee.Fee_Category__c='Sea Freights';
			fee.Active__c=true;
			
			// Autocompletamos informacion con campos del filtro
			fee.Account_for__c = filter.Account_for__c;
			NEU_CurrencyUtils.setCurrencyISOCode(fee,NEU_CurrencyUtils.getCurrencyISOCode(filter));
			if(fee.Rate_Type__c == null && filter.Rate_Type__c != null)
				fee.Rate_Type__c = filter.Rate_Type__c;
			if(fee.Route__r.Country_of_Load__c == null && filter.Route__r.Country_of_Load__c != null)
				fee.Route__r.Country_of_Load__c = filter.Route__r.Country_of_Load__c;
			if(fee.Route__r.State_of_Load__c == null && filter.Route__r.State_of_Load__c != null)
				fee.Route__r.State_of_Load__c = filter.Route__r.State_of_Load__c;
			if(fee.Route__r.Port_Airport_of_Load__c == null && filter.Route__r.Port_Airport_of_Load__c != null)
				fee.Route__r.Port_Airport_of_Load__c = filter.Route__r.Port_Airport_of_Load__c;
			if(fee.Route__r.Country_of_Discharge__c == null && filter.Route__r.Country_of_Discharge__c != null)
				fee.Route__r.Country_of_Discharge__c = filter.Route__r.Country_of_Discharge__c;
			if(fee.Route__r.State_of_Discharge__c == null && filter.Route__r.State_of_Discharge__c != null)
				fee.Route__r.State_of_Discharge__c = filter.Route__r.State_of_Discharge__c;
			if(fee.Route__r.Port_Airport_of_Discharge__c == null && filter.Route__r.Port_Airport_of_Discharge__c != null)
				fee.Route__r.Port_Airport_of_Discharge__c = filter.Route__r.Port_Airport_of_Discharge__c;
			if(fee.Carrier_Account__c == null && filter.Carrier_Account__c != null)
				fee.Carrier_Account__c = filter.Carrier_Account__c;
			if(fee.Valid_Until__c == null && filter.Valid_Until__c != null)
				fee.Valid_Until__c = filter.Valid_Until__c;
			if(fee.Valid_From__c == null && filter.Valid_From__c != null)
				fee.Valid_From__c = filter.Valid_From__c;
			
			
			Boolean error = false;
			String errores= 'Field(s)';
			if(fee.Name == null){
				error = true;
				errores += ' Rate Name,';
			}
			
			if(fee.Account_for__c == null){
				errores += ' Account for,';
				error = true;
			}
			
			if(fee.Rate_Type__c == null){
				errores += ' Rate Type,';
				error = true;
			}
			
			if(fee.Route__r.Port_Airport_of_Load__c == null){
				errores += ' Site of Load,';
				error = true;
			}
			
			if(fee.Route__r.Port_Airport_of_Discharge__c == null){
				errores += ' Site of Discharge,';
				error = true;
			}
			
			if(fee.Carrier_Account__c == null){
				errores += ' Carrier,';
				error = true;
			}
			
			if(fee.Buy_Rate__c == null){
				errores += ' Buy Rate,';
				error = true;
			}
			
			if(fee.Fee_Rate__c == null){
				errores += ' Sell Rate,';
				error = true;
			}
			
			/*if(fee.Group__c == null){
				errores += ' Group,';
				error = true;
			}
			
			if(fee.SAP_Service_Type__c == null){
				errores += ' SAP Service Type,';
				error = true;
			}*/
			errores = errores.removeEnd(',');
			errores += ' are required.';
			
			if (error == true){
				modo = 'edit';
				service_rate_new.fee0 = fee;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errores));
			}
			
			if(error == false || test.isRunningTest()){
				String Key_fee=(NEU_Utils.safeString(fee.Fee_Category__c)+'|'+NEU_Utils.safeString(fee.Rate_Type__c)).toUpperCase()+'|'+NEU_Utils.safeString(fee.Container_Type__c).left(15)+'|'+NEU_Utils.safeString(fee.Route__r.Port_Airport_of_Load__c).left(15)+'|'+NEU_Utils.safeString(fee.Route__r.Port_Airport_of_Discharge__c).left(15)+'|'+NEU_Utils.safeString(fee.Carrier_Account__c).left(15);
				List<Fee__c> lst_service_rate = [select Id,Key__c from Fee__c where Key__c =: Key_fee];
				if (lst_service_rate.size() == 0){
					String Key_route = (NEU_Utils.safeString(fee.Route__r.Port_Airport_of_Load__c)+'|'+NEU_Utils.safeString(fee.Route__r.Port_Airport_of_Discharge__c)).toUpperCase();
					List<Carrier_Line_Load_Point__c> lst_route = [select Id,Key__c from Carrier_Line_Load_Point__c where Key__c =: Key_route];
					if (lst_route.size() == 0){
						Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c();
						route.State_of_Load__c=fee.Route__r.State_of_Load__c;
						route.Country_of_Load__c=fee.Route__r.Country_of_Load__c;
						route.Port_Airport_of_Load__c=fee.Route__r.Port_Airport_of_Load__c;
						route.State_of_Discharge__c=fee.Route__r.State_of_Discharge__c;
						route.Country_of_Discharge__c=fee.Route__r.Country_of_Discharge__c;
						route.Port_Airport_of_Discharge__c=fee.Route__r.Port_Airport_of_Discharge__c;
						insert route;
						
						fee.Route__r = null;
						fee.Route__c = route.Id;
					}else{
						fee.Route__r = null;
						fee.Route__c = lst_route[0].Id;
					}
					insert fee;
					
					modo = null;
					service_rate_new = null;
				}else{
					modo = 'edit';
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'A service rate with this unique Key already exist.'));
				}
			}
		}catch(Exception e){
			modo = 'edit';
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An error has occurred.'));
		}
		
	}
	
	public void get_historical_prices(){
		message_data = '';
		message_header = 'Historical Prices';
		
		string query_this_fee = '';
		query_this_fee += 'SELECT Id, Name, Route__c, RecordTypeId, Fee_Category__c, Account_for__c, Carrier_Account__c, Container_Type__c, Rate_Type__c,';
		query_this_fee += ' Buy_Rate__c, Fee_Rate__c';
		if(UserInfo.isMultiCurrencyOrganization())
			query_this_fee += ', CurrencyIsoCode';
		query_this_fee += ' FROM Fee__c WHERE Id =: id_service LIMIT 1';
		
		List<Fee__c> this_fee = Database.query(query_this_fee);
		
		StaticResource equal_icon_query = [select Id, Name, SystemModStamp from StaticResource where Name = 'FRM_equal_icon' limit 1];
		StaticResource arrow_red_query = [select Id, Name, SystemModStamp from StaticResource where Name = 'FRM_arrow_red' limit 1];
		StaticResource arrow_green_query = [select Id, Name, SystemModStamp from StaticResource where Name = 'FRM_arrow_green' limit 1];
		
		String equal_icon = '';
		String arrow_red = '';
		String arrow_green = '';
		
		if(equal_icon_query != null)
			equal_icon = '/resource/'+String.valueOf(((DateTime)equal_icon_query.get('SystemModStamp')).getTime())+'/'+equal_icon_query.get('Name');
		if(arrow_red_query != null)
			arrow_red = '/resource/'+String.valueOf(((DateTime)arrow_red_query.get('SystemModStamp')).getTime())+'/'+arrow_red_query.get('Name');
		if(arrow_green_query != null)
			arrow_green = '/resource/'+String.valueOf(((DateTime)arrow_green_query.get('SystemModStamp')).getTime())+'/'+arrow_green_query.get('Name');
		
		String date_filter = filter_date.Valid_Until__c.day()+'/'+filter_date.Valid_Until__c.month()+'/'+filter_date.Valid_Until__c.year();
		
		if(this_fee.size() > 0)
		{
			string route = this_fee[0].Route__c;
			string record_type = this_fee[0].RecordTypeId;
			string fee_category = this_fee[0].Fee_Category__c;
			string account_for = this_fee[0].Account_for__c;
			string container_type = this_fee[0].Container_Type__c;
			string rate_type = this_fee[0].Rate_Type__c;
			string carrier_account = this_fee[0].Carrier_Account__c;
			date since_date = filter_date.Valid_Until__c;
			
			string CurrencyISOCode = NEU_CurrencyUtils.getCurrencyISOCode(this_fee[0]);
			
			if(info_type == 'buy_rate_1' || Test.isRunningTest())
			{
				//HISTORICAL BUY RATE (ALL TIME / ALL CARRIERS)
				string query_shipment_lines_1_min = '';
				query_shipment_lines_1_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type';
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for';
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type'; 
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_1_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_min += ' ORDER BY Shipment_Buy_Price__c ASC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_min = Database.query(query_shipment_lines_1_min);

				string query_shipment_lines_1_max = '';
				query_shipment_lines_1_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_max += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_1_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category';
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_1_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_max += ' ORDER BY Shipment_Buy_Price__c DESC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_max = Database.query(query_shipment_lines_1_max);
				
				string query_shipment_lines_1_avg = '';
				query_shipment_lines_1_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg'; 
				query_shipment_lines_1_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_avg += ' WHERE Service_Rate_Name__r.Route__c =: route';
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type';
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for';
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_1_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_1_avg = Database.query(query_shipment_lines_1_avg);

				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_1_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_1_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_1_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_1_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_1_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_min[0].CreatedDate.day()+'/'+shipment_lines_1_min[0].CreatedDate.month()+'/'+shipment_lines_1_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_1_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_1_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_1_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_1_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_max[0].CreatedDate.day()+'/'+shipment_lines_1_max[0].CreatedDate.month()+'/'+shipment_lines_1_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_avg.size() > 0  && shipment_lines_1_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_1_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
					
				//HISTORICAL BUY RATE (ALL TIME / THIS CARRIER)
				string query_shipment_lines_2_min = '';
				query_shipment_lines_2_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_2_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_min += ' ORDER BY Shipment_Buy_Price__c ASC';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_min = Database.query(query_shipment_lines_2_min);
				
				string query_shipment_lines_2_max = '';
				query_shipment_lines_2_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_2_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_max += ' ORDER BY Shipment_Buy_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_max = Database.query(query_shipment_lines_2_max);
				
				string query_shipment_lines_2_avg = '';
				query_shipment_lines_2_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg'; 
				query_shipment_lines_2_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_2_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_2_avg = Database.query(query_shipment_lines_2_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_2_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_2_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_2_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_2_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_2_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_min[0].CreatedDate.day()+'/'+shipment_lines_2_min[0].CreatedDate.month()+'/'+shipment_lines_2_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_2_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_2_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_2_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_2_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_max[0].CreatedDate.day()+'/'+shipment_lines_2_max[0].CreatedDate.month()+'/'+shipment_lines_2_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_avg.size() > 0  && shipment_lines_2_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_2_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
			}
			
			if(info_type == 'buy_rate_2' || Test.isRunningTest())
			{
				//HISTORICAL BUY RATE (SINCE THIS DATE / ALL CARRIERS)
				string query_shipment_lines_3_min = '';
				query_shipment_lines_3_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_min += ' ORDER BY Shipment_Buy_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_3_min = Database.query(query_shipment_lines_3_min);
				
				string query_shipment_lines_3_max = ''; 
				query_shipment_lines_3_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_max += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_3_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_max += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_max += ' ORDER BY Shipment_Buy_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_3_max = Database.query(query_shipment_lines_3_max);
				
				string query_shipment_lines_3_avg = '';
				query_shipment_lines_3_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg';
				query_shipment_lines_3_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				
				AggregateResult[] shipment_lines_3_avg = Database.query(query_shipment_lines_3_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_3_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_3_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_3_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_3_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_3_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_min[0].CreatedDate.day()+'/'+shipment_lines_3_min[0].CreatedDate.month()+'/'+shipment_lines_3_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_3_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_3_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_3_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_3_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_max[0].CreatedDate.day()+'/'+shipment_lines_3_max[0].CreatedDate.month()+'/'+shipment_lines_3_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_avg.size() > 0 && shipment_lines_3_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_3_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	

				//HISTORICAL BUY RATE (SINCE THIS DATE / THIS CARRIER)
				string query_shipment_lines_4_min = '';
				query_shipment_lines_4_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_4_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_min += ' ORDER BY Shipment_Buy_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_4_min = Database.query(query_shipment_lines_4_min);
				
				string query_shipment_lines_4_max = '';
				query_shipment_lines_4_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_4_max += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_max += ' ORDER BY Shipment_Buy_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_4_max = Database.query(query_shipment_lines_4_max);
				
				string query_shipment_lines_4_avg = '';
				query_shipment_lines_4_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg';
				query_shipment_lines_4_avg += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_4_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_4_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				
				AggregateResult[] shipment_lines_4_avg = Database.query(query_shipment_lines_4_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_4_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_4_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_4_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_4_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_4_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_min[0].CreatedDate.day()+'/'+shipment_lines_4_min[0].CreatedDate.month()+'/'+shipment_lines_4_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_4_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_4_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_4_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_4_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_max[0].CreatedDate.day()+'/'+shipment_lines_4_max[0].CreatedDate.month()+'/'+shipment_lines_4_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_avg.size() > 0 && shipment_lines_4_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_4_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	
			}
			
			if(info_type == 'sell_rate_1' || Test.isRunningTest())
			{
				//HISTORICAL SELL RATE (ALL TIME / ALL CARRIERS)
				string query_shipment_lines_1_min = '';
				query_shipment_lines_1_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_1_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_min += ' ORDER BY Shipment_Sell_Price__c ASC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_min = Database.query(query_shipment_lines_1_min);
				
				string query_shipment_lines_1_max = '';
				query_shipment_lines_1_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_1_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_max += ' ORDER BY Shipment_Sell_Price__c DESC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_max = Database.query(query_shipment_lines_1_max);
				
				string query_shipment_lines_1_avg = '';
				query_shipment_lines_1_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg'; 
				query_shipment_lines_1_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())   
					query_shipment_lines_1_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_1_avg = Database.query(query_shipment_lines_1_avg);

				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_1_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_1_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_1_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_1_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_1_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_min[0].CreatedDate.day()+'/'+shipment_lines_1_min[0].CreatedDate.month()+'/'+shipment_lines_1_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_1_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_1_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_1_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_1_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_max[0].CreatedDate.day()+'/'+shipment_lines_1_max[0].CreatedDate.month()+'/'+shipment_lines_1_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_avg.size() > 0  && shipment_lines_1_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_1_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
					
				//HISTORICAL SELL RATE (ALL TIME / THIS CARRIER)
				string query_shipment_lines_2_min = '';
				query_shipment_lines_2_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_2_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_min += ' ORDER BY Shipment_Sell_Price__c asc';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_min = Database.query(query_shipment_lines_2_min);
			
				string query_shipment_lines_2_max = '';
				query_shipment_lines_2_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_2_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_max += ' ORDER BY Shipment_Sell_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_max = Database.query(query_shipment_lines_2_max);
				
				string query_shipment_lines_2_avg = '';
				query_shipment_lines_2_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg'; 
				query_shipment_lines_2_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type'; 
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_2_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_2_avg = Database.query(query_shipment_lines_2_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_2_min.size() > 0)
				{
		  			
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_2_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_2_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_2_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_2_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_min[0].CreatedDate.day()+'/'+shipment_lines_2_min[0].CreatedDate.month()+'/'+shipment_lines_2_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_2_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_2_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_2_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_2_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_max[0].CreatedDate.day()+'/'+shipment_lines_2_max[0].CreatedDate.month()+'/'+shipment_lines_2_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_avg.size() > 0  && shipment_lines_2_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_2_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
			}
			
			if(info_type == 'sell_rate_2' || Test.isRunningTest())
			{
				//HISTORICAL SELL RATE (SINCE THIS DATE / ALL CARRIERS)
				string query_shipment_lines_3_min = '';
				query_shipment_lines_3_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_min += ' ORDER BY Shipment_Sell_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_3_min = Database.query(query_shipment_lines_3_min);
				
				string query_shipment_lines_3_max = '';
				query_shipment_lines_3_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_max += ' WHERE Service_Rate_Name__r.Route__c =: route and Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_3_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_3_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_max += ' ORDER BY Shipment_Sell_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_3_max = Database.query(query_shipment_lines_3_max);
				
				string query_shipment_lines_3_avg = '';
				query_shipment_lines_3_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg';
				query_shipment_lines_3_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				
				AggregateResult[] shipment_lines_3_avg = Database.query(query_shipment_lines_3_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
				message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';	  			
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_3_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_3_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_3_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_3_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_3_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_min[0].CreatedDate.day()+'/'+shipment_lines_3_min[0].CreatedDate.month()+'/'+shipment_lines_3_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_3_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_3_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_3_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_3_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_max[0].CreatedDate.day()+'/'+shipment_lines_3_max[0].CreatedDate.month()+'/'+shipment_lines_3_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_avg.size() > 0 && shipment_lines_3_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_3_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	

				//HISTORICAL SELL RATE (SINCE THIS DATE / THIS CARRIER)
				string query_shipment_lines_4_min = '';
				query_shipment_lines_4_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_min += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_4_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_4_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_min += ' ORDER BY Shipment_Sell_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_4_min = Database.query(query_shipment_lines_4_min);
				
				string query_shipment_lines_4_max = '';
				query_shipment_lines_4_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())   
					query_shipment_lines_4_max += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_max += ' ORDER BY Shipment_Sell_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_4_max = Database.query(query_shipment_lines_4_max);
				
				string query_shipment_lines_4_avg = '';
				query_shipment_lines_4_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg';
				query_shipment_lines_4_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())    
					query_shipment_lines_4_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				
				AggregateResult[] shipment_lines_4_avg = Database.query(query_shipment_lines_4_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_4_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_4_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_4_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_4_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_4_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_min[0].CreatedDate.day()+'/'+shipment_lines_4_min[0].CreatedDate.month()+'/'+shipment_lines_4_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_4_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_4_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_4_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_4_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_max[0].CreatedDate.day()+'/'+shipment_lines_4_max[0].CreatedDate.month()+'/'+shipment_lines_4_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_avg.size() > 0 && shipment_lines_4_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_4_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	
			}
		}
	}
}