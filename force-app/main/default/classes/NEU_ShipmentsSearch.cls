public with sharing class NEU_ShipmentsSearch 
{
  public String shipment_status {get;set;}
  public String service_mode {get;set;}
  public Shipment__c record {get;set;}
  public Shipment_Program__c record_filter {get;set;}
  public List<shipment_s> shipments_requests {get;set;}
  public List<shipment_s> shipments_quotes {get;set;}
  public List<shipment_s> shipments_orders {get;set;}
  public string step_Instalacion {get;set;}
  public string step_order {get;set;}
  public string step_request {get;set;}
  public String sta_list {get;set;}
  public String serv_list {get;set;}
  public String id_record_type_requests {get;set;}
  public String id_record_type_quotes {get;set;}
  public String id_record_type_orders {get;set;}
  public String orden_ship_filtro_orders {get;set;}
  public String orden_ship_filtro_orders_modo {get;set;}
  public String orden_ship_filtro_quotes {get;set;}
  public String orden_ship_filtro_quotes_modo {get;set;}
  public String orden_ship_filtro_request {get;set;}
  public String orden_ship_filtro_request_modo {get;set;}
  public List<Integer> listado_paginas_Quotes {get;set;}
  public List<Integer> listado_paginas_Orders {get;set;}
  public List<Integer> listado_paginas_Request {get;set;}
  public integer n_records_per_page = 100;
  public Decimal total_quotes {get;set;}
  public Decimal total_orders {get;set;}
  public Decimal total_request {get;set;}
  public String url_tracking_externa{get;set;}
  public String params {get;set;}
  public String resultado {get;set;} 
  
  public class shipment_s
  {
    public Shipment__c shipment {get;set;}
    public List<Associated_Document__c> documents {get;set;}
    
      public shipment_s(Shipment__c shipment, List<Associated_Document__c> documents)
    {
      this.shipment = shipment;
      this.documents = documents;
    }
  }

  //OPERATOR ETD LIST
  public String ETD_operator_selected {get;set;}
  public List<SelectOption> getETD_operator_list() 
  {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('equal','equal'));
      options.add(new SelectOption('not equal to','not equal to'));
      options.add(new SelectOption('less than','less than'));
      options.add(new SelectOption('greater than','greater than'));
      options.add(new SelectOption('less or equal','less or equal'));
      options.add(new SelectOption('greater or equal','greater or equal'));
      return options;
  }
    
    //OPERATOR ETA LIST
  public String ETA_operator_selected {get;set;}
  public List<SelectOption> getETA_operator_list() 
  {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('equal','equal'));
      options.add(new SelectOption('not equal to','not equal to'));
      options.add(new SelectOption('less than','less than'));
      options.add(new SelectOption('greater than','greater than'));
      options.add(new SelectOption('less or equal','less or equal'));
      options.add(new SelectOption('greater or equal','greater or equal'));
      return options;
    }
  
/*  ApexPages.StandardController con;
            
    public NEU_ShipmentsSearch(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name from Shipment__c where Id =: con.getRecord().id]; 
        } catch( Exception ee) { 
            record = new Shipment__c();
        } 
        
        if(url_tracking_externa== null)
          url_tracking_externa= '';
          
          CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
            if(sr == null)
            {
              sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
              if(sr == null)
                  sr = CSH_Supplier_Request__c.getOrgDefaults();
            }
            
            String defaultUrl=null;
            Boolean useExternal=false;
            if(sr!=null)
            {
              defaultUrl=sr.Default_External_URL__c;
              useExternal=sr.Use_External_Url__c;
            }
            
            if(String.IsEmpty(defaultUrl)||(!useExternal))
            defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Trace';
          else
            defaultUrl+='/NEU_Trace';      
        url_tracking_externa+=' '+defaultUrl+'?id=';
    }*/
    
    public NEU_ShipmentsSearch() 
    {
        
        //record = new Shipment__c();
        
    }
  
     public void carga_filtros()
    {  
        record = new Shipment__c();
        record_filter = new Shipment_Program__c();
        
        //Created From Filter
        record.Storage_Date_From__c = system.today().addMonths(-1);
        //Created To Filter
        record.Storage_Date_To__c = system.today();
        
    //----
    //-----puede que se tengann que cambiar
        id_record_type_requests = '';
        id_record_type_quotes = '';
        id_record_type_orders = '';
        if(Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Request').getRecordTypeId() != null)
            id_record_type_requests = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Request').getRecordTypeId();
        if(Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Quote').getRecordTypeId() != null)
            id_record_type_quotes = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Quote').getRecordTypeId();
        if(Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Order').getRecordTypeId() != null)
            id_record_type_orders =  Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Order').getRecordTypeId();
  
        if(url_tracking_externa== null)
            url_tracking_externa= '';
      
        CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
        if(sr == null)
        {
          sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
          if(sr == null)
              sr = CSH_Supplier_Request__c.getOrgDefaults();
        }
        
        String defaultUrl=null;
        Boolean useExternal=false;
        if(sr!=null)
        {
          defaultUrl=sr.Default_External_URL__c;
          useExternal=sr.Use_External_Url__c;
        }
        
        if(String.IsEmpty(defaultUrl)||(!useExternal))
            defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Trace';
        else
            defaultUrl+='/NEU_Trace';      
        url_tracking_externa+=''+defaultUrl+'?id=';
        //------------------
        //FILTRO SHIPMENT STATUS
        shipment_status = '';
        Schema.DescribeFieldResult fieldResult1 = Shipment__c.Shipment_Status__c.getDescribe();
        List<Schema.PicklistEntry> sta = fieldResult1.getPicklistValues();
        for(Schema.PicklistEntry s : sta)
        {
            shipment_status += '<input type="button" value="'+s.getValue()+'" class="btn filter_button1 filter_button_sta" name="'+s.getValue()+'" onclick="$(this).filter_sta();"/>';
        }
        
        //FILTRO SERVICE MODE
        service_mode = '';
        Schema.DescribeFieldResult fieldResult2 = Shipment__c.Service_Mode__c.getDescribe();
        List<Schema.PicklistEntry> serv = fieldResult2.getPicklistValues();
        for(Schema.PicklistEntry s : serv)
        {
            service_mode += '<input type="button" value="'+s.getValue()+'" class="btn filter_button2 filter_button_serv" name="'+s.getValue()+'" onclick="$(this).filter_serv();"/>';
        }
        //---------------------------------------------------
        //------------------------------------------------------------
        orden_ship_filtro_orders = 'CreatedDate'; 
        orden_ship_filtro_orders_modo = 'desc';
        orden_ship_filtro_quotes = 'CreatedDate'; 
        orden_ship_filtro_quotes_modo = 'desc';
        orden_ship_filtro_request = 'CreatedDate'; 
        orden_ship_filtro_request_modo = 'desc';
        //ORDERS
        total_orders = 0;
        shipments_orders = new List<shipment_s>();
        //Paginacion 
        String[] ids_shipments = new String[]{};
        listado_paginas_Orders = new List<Integer>(); 
    	
    	datetime date_from;
    	datetime date_to;
    	string date_filter = '';
    	if(record.Storage_Date_From__c != null)
	    {
	    	date_from = record.Storage_Date_From__c;
	    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
			date_filter +=' AND CreatedDate >=: date_from';
	    }
	    if(record.Storage_Date_To__c != null)
	    {
	    	date_to = record.Storage_Date_To__c;
	    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
			date_filter +=' AND CreatedDate <=: date_to';
	    }
    	
		//for(AggregateResult result : [SELECT COUNT(Id)  FROM Shipment__c where (RecordType.DeveloperName =: 'Shipment_Order' or RecordTypeId =: null)]) total_orders += (Integer)result.get('expr0');
		string query_count = '';
		query_count += 'SELECT COUNT() FROM Shipment__c WHERE (RecordType.DeveloperName = \'Shipment_Order\' or RecordTypeId = null)';
		query_count += date_filter;        
        total_orders += Database.countQuery(query_count);
        
        step_order = '1';
        
        integer n_listas = (integer)total_orders/n_records_per_page;
        n_listas = n_listas + 2;
        List<Id> listado_ids_ie = new List<Id>();
        integer contador_ie = 0;
        List<Shipment__c> new_ies = new List<Shipment__c>();
        String query_orders = '';
        query_orders += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c,  Status_Observations__c, Account_for__c, Account_for__r.Name,';
        query_orders += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
        query_orders += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
        query_orders += ' Supplier_Account__r.Name,Flight_Number__c, MAWB_Number__c, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
        query_orders += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
        query_orders += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, '; 
        query_orders += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
        query_orders += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
        query_orders += ' FROM Shipment__c';
        query_orders += ' WHERE Name != \'\'';
        query_orders += ' and (RecordType.DeveloperName = \'Shipment_Order\' or RecordTypeId = null)';
        query_orders += date_filter;
        query_orders += ' order by CreatedDate desc limit '+ n_records_per_page;
        
        new_ies = Database.query(query_orders);
        for(Shipment__c c : new_ies)
        {
            shipments_orders.add(new shipment_s(c, null));
            ids_shipments.add(c.Id);
        }
        
        for(integer i= 1; i < n_listas; i++) 
        {
            listado_paginas_Orders.add(i);
            
        }
        //QUOTES
        //--------------------------------------------------------------
        //Paginacion 
        listado_paginas_Quotes = new List<Integer>();
        total_quotes = 0;
        shipments_quotes = new List<shipment_s>();
        
        //for (AggregateResult result : [  SELECT COUNT(Id)  FROM Shipment__c where RecordType.DeveloperName =: 'Shipment_Quote']) total_quotes += (Integer)result.get('expr0');
        query_count = '';
        query_count += 'SELECT COUNT() FROM Shipment__c WHERE (RecordType.DeveloperName = \'Shipment_Quote\' or RecordTypeId = null)';
		query_count += date_filter;
        total_orders += Database.countQuery(query_count);
        
        step_Instalacion = '1';
        
        n_listas = (integer)total_quotes/n_records_per_page;
        n_listas = n_listas + 2;
        
        listado_ids_ie = new List<Id>();
        contador_ie = 0;
        new_ies = new List<Shipment__c>();
        query_orders = '';
        query_orders += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
        query_orders += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
        query_orders += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
        query_orders += ' Supplier_Account__r.Name, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
        query_orders += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
        query_orders += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
        query_orders += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
        query_orders += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
        query_orders += ' FROM Shipment__c';
        query_orders += ' WHERE Name != \'\'';
        query_orders += ' and RecordType.DeveloperName = \'Shipment_Quote\'';
        query_orders += date_filter;
        query_orders += ' order by CreatedDate desc limit '+ n_records_per_page;
        
        new_ies = Database.query(query_orders);
        for(Shipment__c c : new_ies)
        {
            shipments_quotes.add(new shipment_s(c, null));
            ids_shipments.add(c.Id);
        }
        
        for(integer i= 1; i < n_listas; i++) 
        {
            listado_paginas_Quotes.add(i);   
        }
        //------------------------------------------------------------
        //REQUEST
        total_request  = 0;
        shipments_requests = new List<shipment_s>();
        //Paginacion 
        listado_paginas_Request = new List<Integer>();
    
        //for (AggregateResult result : [  SELECT COUNT(Id)  FROM Shipment__c where RecordType.DeveloperName =: 'Shipment_Request']) total_request += (Integer)result.get('expr0');
        query_count = '';
        query_count += 'SELECT COUNT() FROM Shipment__c WHERE (RecordType.DeveloperName = \'Shipment_Request\' or RecordTypeId = null)';
		query_count += date_filter;        
        total_orders += Database.countQuery(query_count);
        
        step_request = '1';
        
        n_listas = (integer)total_request/n_records_per_page;
        n_listas = n_listas + 2;
        new_ies = new List<Shipment__c>();
        query_orders = '';
        query_orders += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c,  Status_Observations__c, Account_for__c, Account_for__r.Name,';
        query_orders += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
        query_orders += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
        query_orders += ' Supplier_Account__r.Name,Flight_Number__c, MAWB_Number__c, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
        query_orders += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
        query_orders += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
        query_orders += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
        query_orders += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
        query_orders += ' FROM Shipment__c';
        query_orders += ' WHERE Name != \'\'';
        query_orders += ' and RecordType.DeveloperName = \'Shipment_Request\'';
        query_orders += date_filter;
        query_orders += ' order by CreatedDate desc limit '+ n_records_per_page;
        
        new_ies = Database.query(query_orders);
        for(Shipment__c c : new_ies)
        {
            shipments_requests.add(new shipment_s(c, null));
            ids_shipments.add(c.Id);
        }
        
        for(integer i= 1; i < n_listas; i++) 
        {
            listado_paginas_Request.add(i);
            
        }
       // shipments_requests = new List<shipment_s>();//-----------falta hacer este
        
        
        params = '';
        
        List<User> user = [select Id, Name, ContactId from User where Id =: UserInfo.getUserId()];
        if(user.size() > 0)
        {
              if(user[0].ContactId != null)
              {
                    List<Contact> contact = [select Id, Name, Account.Name from Contact where Id =: user[0].ContactId];
                    if(contact.size() > 0)
                    {
                      params = '&CF00N2400000Hnxwm='+contact[0].Account.Name+'&CF00N2400000HnyB6='+contact[0].Name;
                    }
              }
        }
        
        //search_shipments();
  }
  
  public void go_compare_ship_order()// se podrian hacer con el implements compare en lugar de hacer consulta de nuevo pero no se podrian ordenar por separado
  {
     //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

   
    String consulta = '';
    consulta += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c,  OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, Flight_Number__c, MAWB_Number__c, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    consulta += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    consulta += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    consulta += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    consulta += ' FROM Shipment__c';
    
    consulta += ' WHERE Name != \'\''; 
    consulta += ' and (RecordType.DeveloperName = \'Shipment_Order\' or RecordTypeId = null)';
    if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta +=' AND CreatedDate <=: date_to';
    }
	consulta += ' '+(sta != null && !sta.isEmpty() ? 'and Shipment_Status__c IN :sta' : '');
    	
    consulta += ' '+(record.Freight_Mode__c != null ? ' and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta += ' '+(record.Service_Type__c != null ? ' and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta += ' '+(record.Service_Mode__c != null ? ' and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
        
    if(record.Route__c != null)
    {
        consulta += ' and (Route__c = \''+record.Route__c+'\'';
        consulta += ' )';
    }
    consulta += ' '+(record.Carrier__c != null ? 'and Carrier__c = \''+record.Carrier__c+'\'' : '');
    consulta += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta += ' '+(record.Truck_Vessel_Flight__c != null ? 'and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    consulta += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? 'and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    consulta += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? 'and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    Date etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      consulta += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    Date eta=record.ETA_Point_of_Discharge__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
      String operator = '';
      if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!='; 
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
      consulta += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
   // consulta += ' and RecordTypeId = \''+ Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Order').getRecordTypeId()+'\'';
   
    consulta += ' order by '+String.escapeSingleQuotes(orden_ship_filtro_orders.replace('shipment.','')+ ' '+  orden_ship_filtro_orders_modo);
    consulta += ' limit '+n_records_per_page;
    system.debug('hola '+ consulta);
    
    
    integer n_listas = (integer)total_orders/n_records_per_page;
    n_listas = n_listas + 2;
    
   // integer n_query = (integer)total_orders/50000;
   // n_query = n_query +1;
    
    integer contador_ie = 0;
    
    step_order = '1';
    
    List<Shipment__c> all_shipments_orders = Database.query(consulta);
    shipments_orders = new List<shipment_s>();
    for(Shipment__c s : all_shipments_orders)
    {
         shipments_orders.add(new shipment_s(s, null));
    }
    
  }
  
  public void go_compare_ship_quote()
  {
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

   
    String consulta = '';
    consulta += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    consulta += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    consulta += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    consulta += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    consulta += ' FROM Shipment__c';
    consulta += ' WHERE Name != \'\'';
    consulta += ' and RecordType.DeveloperName = \'Shipment_Quote\'';
     
    consulta += ' '+(sta != null && !sta.isEmpty() ? 'and Shipment_Status__c IN :sta' : '');
   	if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta +=' AND CreatedDate <=: date_to';
    }
    consulta += ' '+(record.Freight_Mode__c != null ? ' and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta += ' '+(record.Service_Type__c != null ? ' and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta += ' '+(record.Service_Mode__c != null ? ' and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
        consulta += ' and (Route__c = \''+record.Route__c+'\'';
        consulta += ' )';
    }
    consulta += ' '+(record.Carrier__c != null ? 'and Carrier__c = \''+record.Carrier__c+'\'' : '');
    consulta += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta += ' '+(record.Truck_Vessel_Flight__c != null ? 'and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    consulta += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? 'and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    consulta += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? 'and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    Date etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      consulta += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    Date eta=record.ETA_Point_of_Discharge__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
      String operator = '';
      if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!='; 
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
      consulta += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    //consulta += ' and RecordTypeId = \''+ Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Quote').getRecordTypeId()+'\'';
    consulta += ' order by '+String.escapeSingleQuotes(orden_ship_filtro_quotes.replace('shipment.','')+ ' '+  orden_ship_filtro_quotes_modo);
    consulta += ' limit '+n_records_per_page;
    system.debug('hola '+ consulta);
    
     
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    
    integer n_query = (integer)total_quotes/50000;
    n_query = n_query +1;
    
    step_Instalacion = '1';
    
    List<Shipment__c> all_shipments_orders = Database.query(consulta);
    shipments_quotes = new List<shipment_s>();
    for(Shipment__c s : all_shipments_orders)
    {
         shipments_quotes.add(new shipment_s(s, null));
    }
  }
  
  public void go_compare_ship_request()
  {
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    String consulta = '';
    consulta += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    consulta += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    consulta += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    consulta += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    consulta += ' FROM Shipment__c';
    consulta += ' WHERE Name != \'\'';
    consulta += ' and RecordType.DeveloperName = \'Shipment_Request\'';
    
    consulta += ' '+(sta != null && !sta.isEmpty() ? 'and Shipment_Status__c IN :sta' : '');
    if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta +=' AND CreatedDate <=: date_to';
    }
    consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
        consulta += ' and (Route__c = \''+record.Route__c+'\'';
        consulta += ' )';
    }
    consulta += ' '+(record.Carrier__c != null ? 'and Carrier__c = \''+record.Carrier__c+'\'' : '');
    consulta += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta += ' '+(record.Truck_Vessel_Flight__c != null ? 'and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    consulta += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? 'and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    consulta += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? 'and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    Date etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      consulta += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    Date eta=record.ETD_from_Point_of_Load__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
      String operator = '';
      if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!='; 
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
      consulta += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    consulta += ' and RecordTypeId = \''+ Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Request').getRecordTypeId()+'\'';
    consulta += ' order by '+ String.escapeSingleQuotes(orden_ship_filtro_request.replace('shipment.','')+ ' '+  orden_ship_filtro_request_modo);
    consulta += ' limit '+n_records_per_page;
    system.debug('hola '+ consulta);
    
    integer n_listas = (integer)total_request/n_records_per_page;
    n_listas = n_listas + 2;
    
    step_request = '1';
    
    List<Shipment__c> all_shipments_orders = Database.query(consulta);
    shipments_requests = new List<shipment_s>();
    for(Shipment__c s : all_shipments_orders)
    {
         shipments_requests.add(new shipment_s(s, null));
    }
  }
  
  //-------------------------------------
  //-----------------------------------------
  public void anterior_siguiente_Instalacion()
  {
    shipments_quotes = null;
    integer n_pagina = 0;
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    
    String consulta_filtros ='';
    String consulta = '';
    consulta += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    consulta += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    consulta += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    consulta += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    consulta += ' FROM Shipment__c';
    consulta_filtros += ' WHERE Name != \'\'';
    consulta_filtros += ' and RecordType.DeveloperName = \'Shipment_Quote\'';
    
	consulta_filtros += ' '+(sta != null && !sta.isEmpty() ? 'and Shipment_Status__c IN :sta' : '');
	if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta_filtros +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta_filtros +=' AND CreatedDate <=: date_to';
    }
    consulta_filtros += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
      
    if(record.Route__c != null)
    {
        consulta_filtros += ' and (Route__c = \''+record.Route__c+'\'';
        consulta_filtros += ' )';
    }
    consulta_filtros += ' '+(record.Carrier__c != null ? ' and Carrier__c = \''+record.Carrier__c+'\'' : '');
    consulta_filtros += ' '+(record.Account_for__c != null ? ' and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta_filtros += ' '+(record.Supplier_Account__c != null ? ' and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta_filtros += ' '+(record.Consignee__c != null ? ' and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta_filtros += ' '+(record.Truck_Vessel_Flight__c != null ? ' and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    consulta_filtros += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? ' and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    consulta_filtros += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? ' and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    Date etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      consulta_filtros += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    Date eta=record.ETD_from_Point_of_Load__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
      String operator = '';
      if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!=';
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
      consulta_filtros += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    consulta += consulta_filtros;
    
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    
    //Subconsulta
    string sub_consulta = 'SELECT Id from Shipment__c ' +consulta_filtros;
    if(orden_ship_filtro_quotes != null && orden_ship_filtro_quotes != '')
    	sub_consulta += ' order by '+ String.escapeSingleQuotes(orden_ship_filtro_quotes.replace('shipment.','')+ ' '+  orden_ship_filtro_quotes_modo) +' nulls last ';
        
    integer numero_registros = integer.valueof(step_Instalacion)*n_records_per_page-n_records_per_page;
    sub_consulta += ' limit '+ numero_registros;
    
    shipments_quotes = new List<shipment_s>();
    
    List<Shipment__c> lista_quote_subquery = Database.query(sub_consulta);
    
    integer contador_ie = 0;
    List<Shipment__c> new_ies = null; 
    consulta +=' and id NOT IN :lista_quote_subquery ';
    if(orden_ship_filtro_quotes != null && orden_ship_filtro_quotes != '')
    	consulta += ' order by '+String.escapeSingleQuotes(orden_ship_filtro_quotes.replace('shipment.','')+ ' '+  orden_ship_filtro_quotes_modo) +' nulls last';
        
    new_ies = Database.query(consulta+ ' limit '+ n_records_per_page);
    
    for(Shipment__c c : new_ies)
    {
        shipments_quotes.add(new shipment_s(c, null));
    }
  }
  //--------------------------------------
  public void anterior_siguiente_order()
  {
    shipments_orders = null;
    integer n_pagina = 0;
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    
    String consulta_filtros ='';
    String consulta = '';
    consulta += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name,Flight_Number__c, MAWB_Number__c, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    consulta += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    consulta += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    consulta += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    consulta += ' FROM Shipment__c';
    consulta_filtros += ' WHERE Name != \'\'';
    consulta_filtros += ' and (RecordType.DeveloperName = \'Shipment_Order\' or RecordTypeId = null)';
    
    consulta_filtros += ' '+(sta != null && !sta.isEmpty() ? 'and Shipment_Status__c IN :sta' : '');
    if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta_filtros +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta_filtros +=' AND CreatedDate <=: date_to';
    }
    consulta_filtros += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
        consulta_filtros += ' and (Route__c = \''+record.Route__c+'\'';
        consulta_filtros += ' )';
    }
    consulta_filtros += ' '+(record.Carrier__c != null ? ' and Carrier__c = \''+record.Carrier__c+'\'' : '');
    consulta_filtros += ' '+(record.Account_for__c != null ? ' and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta_filtros += ' '+(record.Supplier_Account__c != null ? ' and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta_filtros += ' '+(record.Consignee__c != null ? ' and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta_filtros += ' '+(record.Truck_Vessel_Flight__c != null ? ' and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    consulta_filtros += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? ' and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    consulta_filtros += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? ' and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    Date etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      consulta_filtros += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    Date eta=record.ETD_from_Point_of_Load__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
        String operator = '';
        if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!=';
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
        consulta_filtros += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    consulta += consulta_filtros;
    
    integer n_listas = (integer)total_orders/n_records_per_page;
    n_listas = n_listas + 2;
    
    //subconsulta
    string sub_consulta = 'SELECT Id from Shipment__c ' +consulta_filtros;
    if(orden_ship_filtro_orders != null && orden_ship_filtro_orders != '')
    	sub_consulta += ' order by '+String.escapeSingleQuotes(orden_ship_filtro_orders.replace('shipment.','')+ ' '+  orden_ship_filtro_orders_modo)+ ' nulls last ';
        
    integer numero_registros = integer.valueof(step_order)*n_records_per_page-n_records_per_page;
    sub_consulta += ' limit '+ numero_registros;
    
    shipments_orders = new List<shipment_s>();
    
    List<Shipment__c> lista_quote_subquery = Database.query(sub_consulta);
    
    integer contador_ie = 0;
    List<Shipment__c> new_ies = null; 
    consulta +=' and id NOT IN :lista_quote_subquery ';
    if(orden_ship_filtro_orders != null && orden_ship_filtro_orders != '')
    	consulta += ' order by '+ String.escapeSingleQuotes(orden_ship_filtro_orders.replace('shipment.','')+ ' '+  orden_ship_filtro_orders_modo)+ ' nulls last';
        
    consulta += ' limit '+ n_records_per_page;
    system.debug('query anterior siguiente '+consulta);
    new_ies = Database.query(consulta);
    
    for(Shipment__c c : new_ies)
    {
        shipments_orders.add(new shipment_s(c, null));
    }
    system.debug('query anterior siguiente '+consulta);
    
  }
  //-----------------------------------------
  
  //--------------------------------------------
  public void anterior_siguiente_request()
  {
    shipments_requests = null;
    integer n_pagina = 0;
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

   
    String consulta_filtros ='';
    String consulta = '';
    consulta += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name,Flight_Number__c, MAWB_Number__c, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    consulta += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    consulta += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    consulta += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    consulta += ' FROM Shipment__c';
    consulta_filtros += ' WHERE Name != \'\'';
    consulta_filtros += ' and RecordType.DeveloperName = \'Shipment_Request\'';
    
	consulta_filtros += ' '+(sta != null && !sta.isEmpty() ? 'and Shipment_Status__c IN :sta' : '');
	if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta_filtros +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		consulta_filtros +=' AND CreatedDate <=: date_to';
    }
    consulta_filtros += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
        consulta_filtros += ' and (Route__c = \''+record.Route__c+'\'';
        consulta_filtros += ' )';
    }
    consulta_filtros += ' '+(record.Carrier__c != null ? ' and Carrier__c = \''+record.Carrier__c+'\'' : '');
    consulta_filtros += ' '+(record.Account_for__c != null ? ' and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta_filtros += ' '+(record.Supplier_Account__c != null ? ' and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta_filtros += ' '+(record.Consignee__c != null ? ' and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta_filtros += ' '+(record.Truck_Vessel_Flight__c != null ? ' and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    consulta_filtros += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? ' and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    consulta_filtros += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? ' and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    Date etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      consulta_filtros += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    Date eta=record.ETD_from_Point_of_Load__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
        String operator = '';
        if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!=';
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
        consulta_filtros += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    consulta += consulta_filtros;
    
    integer n_listas = (integer)total_request/n_records_per_page;
    n_listas = n_listas + 2;
    
    //subconsulta
    string sub_consulta = 'SELECT Id from Shipment__c ' +consulta_filtros;
    if(orden_ship_filtro_request  != null && orden_ship_filtro_request  != '')
    	sub_consulta += ' order by '+ String.escapeSingleQuotes(orden_ship_filtro_request.replace('shipment.','')+ ' '+  orden_ship_filtro_request_modo)+ ' nulls last ';
        
    integer numero_registros = integer.valueof(step_request)*n_records_per_page-n_records_per_page;
    sub_consulta += ' limit '+ numero_registros;
    
    shipments_requests = new List<shipment_s>();
    
    List<Shipment__c> lista_quote_subquery = Database.query(sub_consulta);
    
    integer contador_ie = 0;
    List<Shipment__c> new_ies = null; 
    consulta +=' and id NOT IN :lista_quote_subquery ';
    if(orden_ship_filtro_request != null && orden_ship_filtro_request != '')
    	consulta += ' order by ' +String.escapeSingleQuotes(orden_ship_filtro_request.replace('shipment.','')+ ' '+  orden_ship_filtro_request_modo)+'  nulls last';
        
    consulta += ' limit '+ n_records_per_page;
    new_ies = Database.query(consulta);
    
    for(Shipment__c c : new_ies)
    {
        shipments_requests.add(new shipment_s(c, null));
    }
    system.debug('query anterior siguiente '+consulta);
    
  }
  
  //---------------------------------------------------
  
  public void search_shipments()//--faltaria hacer una funcion con los filtros para no repetirlos pasandole parametros el record type
  {    
    //FILTROS
    String[] sta = (sta_list != null && sta_list != '[]' ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    //------------------------------------------------
     //------------------------------------------------------------
    total_orders = 0;
    shipments_orders = new List<shipment_s>();
    //Paginacion 
    
    listado_paginas_Orders = new List<Integer>(); 

    //for (AggregateResult result : [  SELECT COUNT(Id)  FROM Shipment__c where (RecordType.DeveloperName =: 'Shipment_Order' or RecordTypeId =: null)]) total_orders += (Integer)result.get('expr0');
    string consulta_count = 'SELECT COUNT() FROM Shipment__c';
    String query_orders = '';
    string query_orders_filters = '';
    
    query_orders += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    query_orders += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    query_orders += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    query_orders += ' Supplier_Account__r.Name, Flight_Number__c, MAWB_Number__c, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    query_orders += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    query_orders += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    query_orders += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    query_orders += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    query_orders += ' FROM Shipment__c';
    query_orders_filters += ' WHERE Name != \'\'';
    query_orders_filters += ' and (RecordType.DeveloperName = \'Shipment_Order\' or RecordTypeId = null)';
    
	query_orders_filters += ' '+(sta != null && !sta.isEmpty() && sta.size() > 0 ? 'and Shipment_Status__c IN :sta' : '');
    if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		query_orders_filters +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		query_orders_filters +=' AND CreatedDate <=: date_to';
    }
    query_orders_filters += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    query_orders_filters += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    query_orders_filters += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
        query_orders_filters += ' and (Route__c = \''+record.Route__c+'\'';
        query_orders_filters += ' )';
    }
    query_orders_filters += ' '+(record.Carrier__c != null ? 'and Carrier__c = \''+record.Carrier__c+'\'' : '');
    query_orders_filters += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    query_orders_filters += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    query_orders_filters += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    query_orders_filters += ' '+(record.Truck_Vessel_Flight__c != null ? 'and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    query_orders_filters += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? 'and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    query_orders_filters += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? 'and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    Date etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      query_orders_filters += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    Date eta=record.ETD_from_Point_of_Load__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
      String operator = '';
      if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!=';
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
      query_orders_filters += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    query_orders +=  query_orders_filters;
    //resultado = query_orders;
    consulta_count += query_orders_filters;
    step_order = '1';
    total_orders  = Database.countQuery(consulta_count);
    integer n_listas = (integer)total_orders/n_records_per_page;
    n_listas = n_listas + 2;
    List<Id> listado_ids_ie = new List<Id>();
    integer contador_ie = 0;
    List<Shipment__c> new_ies = new List<Shipment__c>();
    query_orders += ' order by CreatedDate desc limit '+ n_records_per_page;
    
    new_ies = Database.query(query_orders);
    for(Shipment__c c : new_ies)
    {
        shipments_orders.add(new shipment_s(c, null));
        
    }
    
    for(integer i= 1; i < n_listas; i++) 
    {
        listado_paginas_Orders.add(i);
        
    }
    
    
    //----------------------------------------------
    //--------------------------------------------------------------
    //QUOTES
    //Paginacion 
    listado_paginas_Quotes = new List<Integer>();
    total_quotes = 0;
    shipments_quotes = new List<shipment_s>();
    
    //for (AggregateResult result : [  SELECT COUNT(Id)  FROM Shipment__c where RecordType.DeveloperName =: 'Shipment_Quote']) total_quotes += (Integer)result.get('expr0');
    //step_Instalacion = '1';
    
    
    listado_ids_ie = new List<Id>();
    contador_ie = 0;
    new_ies = new List<Shipment__c>();
    consulta_count = 'SELECT COUNT() FROM Shipment__c';
    query_orders_filters = '';
    query_orders = '';
    query_orders += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    query_orders += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    query_orders += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    query_orders += ' Supplier_Account__r.Name, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    query_orders += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    query_orders += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    query_orders += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    query_orders += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    query_orders += ' FROM Shipment__c';
    query_orders_filters += ' WHERE Name != \'\'';
    query_orders_filters += ' and RecordType.DeveloperName = \'Shipment_Quote\'';
    
    query_orders_filters += ' '+(sta != null && !sta.isEmpty() && sta.size() > 0 ? 'and Shipment_Status__c IN :sta' : '');
    if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		query_orders_filters +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		query_orders_filters +=' AND CreatedDate <=: date_to';
    }
    query_orders_filters += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    query_orders_filters += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    query_orders_filters += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');  
    if(record.Route__c != null)
    {
        query_orders_filters += ' and (Route__c = \''+record.Route__c+'\'';
        query_orders_filters += ' )';
    }
    query_orders_filters += ' '+(record.Carrier__c != null ? 'and Carrier__c = \''+record.Carrier__c+'\'' : '');
    query_orders_filters += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    query_orders_filters += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    query_orders_filters += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    query_orders_filters += ' '+(record.Truck_Vessel_Flight__c != null ? 'and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    query_orders_filters += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? 'and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    query_orders_filters += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? 'and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      query_orders_filters += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    eta=record.ETD_from_Point_of_Load__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
      String operator = '';
      if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!=';
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
      query_orders_filters += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    query_orders +=  query_orders_filters;
    query_orders += ' order by CreatedDate desc limit '+ n_records_per_page;
    consulta_count += query_orders_filters;
    new_ies = Database.query(query_orders);
    for(Shipment__c c : new_ies)
    {
        shipments_quotes.add(new shipment_s(c, null));
        
    }
    
    total_quotes  = Database.countQuery(consulta_count);
    n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    for(integer i= 1; i < n_listas; i++) 
    {
        listado_paginas_Quotes.add(i);   
    }
    //------------------------------------------------------------

    //----------------------------------------
    listado_paginas_Request = new List<Integer>();
    total_request = 0;
    shipments_requests  = new List<shipment_s>();
    //REQUEST
    consulta_count = 'SELECT COUNT() FROM Shipment__c';
    query_orders_filters = '';
    String consulta = ''; 
    consulta += 'SELECT Id, Name, Account_Shipment_Reference__c, Shipment_Status__c, OI_Status__c, OI_Status_Code__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, N_Containers__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Units_Shipped__c, Total_Weight_Kg__c, Total_Volume_m3__c, Number__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, Origin_Address__c, Truck_Vessel_Flight__c , Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c, ETD_from_Point_of_Load__c,';
    consulta += ' Country_of_Discharge__c, Country_of_Discharge__r.Name, Country_of_Load__c, Country_of_Load__r.Name, ';
    consulta += ' State_of_Discharge__c, State_of_Discharge__r.Name, State_of_Load__c, State_of_Load__r.Name, ';
    consulta += ' ETA_Point_of_Discharge__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Site_of_Load__c, Site_of_Load__r.Name,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Profit__c';
    consulta += ' FROM Shipment__c';
    query_orders_filters += ' WHERE Name != \'\'';
    query_orders_filters += ' and RecordType.DeveloperName = \'Shipment_Request\'';
    
    query_orders_filters += ' '+(sta != null && !sta.isEmpty() && sta.size() > 0 ? 'and Shipment_Status__c IN :sta' : '');
    if(record.Storage_Date_From__c != null)
    {
    	datetime date_from = record.Storage_Date_From__c;
    	String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		query_orders_filters +=' AND CreatedDate >=: date_from';
    }
    if(record.Storage_Date_To__c != null)
    {
    	datetime date_to = record.Storage_Date_To__c;
    	String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		query_orders_filters +=' AND CreatedDate <=: date_to';
    }
    query_orders_filters += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    query_orders_filters += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    query_orders_filters += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
        query_orders_filters += ' and (Route__c = \''+record.Route__c+'\'';
        query_orders_filters += ' )';
    }
    query_orders_filters += ' '+(record.Carrier__c != null ? 'and Carrier__c = \''+record.Carrier__c+'\'' : '');
    query_orders_filters += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    query_orders_filters += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    query_orders_filters += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    query_orders_filters += ' '+(record.Truck_Vessel_Flight__c != null ? 'and Truck_Vessel_Flight__c = \''+record.Truck_Vessel_Flight__c+'\'' : '');
    query_orders_filters += ' '+(record_filter.User_Create_ShipmentSearch__c != null ? 'and CreatedById = \''+record_filter.User_Create_ShipmentSearch__c+'\'' : '');//--- ver esto
    query_orders_filters += ' '+(record_filter.User_Modify_ShipmentSearch__c != null ? 'and LastModifiedById = \''+record_filter.User_Modify_ShipmentSearch__c+'\'' : '');
    etd=record.ETD_from_Point_of_Load__c;
    if(record.ETD_from_Point_of_Load__c != null)
    {
      String operator = '';
      if(ETD_operator_selected == 'equal')operator = '=';
        if(ETD_operator_selected == 'not equal to')operator = '!=';
        if(ETD_operator_selected == 'less than')operator = '<';
        if(ETD_operator_selected == 'greater than')operator = '>';
        if(ETD_operator_selected == 'less or equal')operator = '<=';
        if(ETD_operator_selected == 'greater or equal')operator = '>=';
      query_orders_filters += ' and ETD_from_Point_of_Load__c '+operator+' :etd';
    }
    
    eta=record.ETD_from_Point_of_Load__c;
    if(record.ETA_Point_of_Discharge__c != null)
    {
      String operator = '';
      if(ETA_operator_selected == 'equal')operator = '=';
        if(ETA_operator_selected == 'not equal to')operator = '!=';
        if(ETA_operator_selected == 'less than')operator = '<';
        if(ETA_operator_selected == 'greater than')operator = '>';
        if(ETA_operator_selected == 'less or equal')operator = '<=';
        if(ETA_operator_selected == 'greater or equal')operator = '>=';
      query_orders_filters += ' and ETA_Point_of_Discharge__c '+operator+' :eta';
    }
    
    consulta +=  query_orders_filters;
    consulta_count += query_orders_filters;
    consulta += ' order by CreatedDate desc limit '+ n_records_per_page;
    
    List<Shipment__c> all_shipments = Database.query(consulta);
    total_request  = Database.countQuery(consulta_count);
    n_listas = (integer)total_request/n_records_per_page;
    n_listas = n_listas + 2;
    
     for(Shipment__c c : all_shipments)
    {
        shipments_requests.add(new shipment_s(c, null));
        
    }
    
    for(integer i= 1; i < n_listas; i++) 
    {
        listado_paginas_Request.add(i);   
    }
    
    step_order = '1';
    step_Instalacion = '1';
    step_request = '1';
    
    //shipments_requests = new List<shipment_s>();
   // shipments_quotes = new List<shipment_s>();
    //shipments_orders = new List<shipment_s>();
    
   /* String[] ids_shipments = new String[]{};
    for(Shipment__c s : all_shipments)
    {
      ids_shipments.add(s.Id);
    }
    
    List<Associated_Document__c> documentos = [select Id, Name, Shipment__c, Document_URL__c from Associated_Document__c where Shipment__c IN : ids_shipments];
    
    Integer cont_request = 0;
    //Integer cont_quote = 0;
    //Integer cont_order = 0;
    
    for(Shipment__c s : all_shipments)
    {
      if(s.RecordType.DeveloperName == 'Shipment_Request') 
        shipments_requests.add(new shipment_s(s, null));*/
      /*else if(s.RecordType.DeveloperName == 'Shipment_Quote')
        shipments_quotes.add(new shipment_s(s, null));
      else if(s.RecordType.DeveloperName == 'Shipment_Order')
        shipments_orders.add(new shipment_s(s, null));
      else
        shipments_orders.add(new shipment_s(s, null));*/
      
      /*List<Associated_Document__c> doc_ship = new List<Associated_Document__c>();
      
      for(Associated_Document__c d : documentos)
      {
        if(s.Id == d.Shipment__c)
          doc_ship.add(d);
      }
      
      if(s.RecordType.DeveloperName == 'Shipment_Request')
      {
        shipments_requests[cont_request].documents = doc_ship;
        cont_request++;
      }*/
      /*else if(s.RecordType.DeveloperName == 'Shipment_Quote')
      {
        shipments_quotes[cont_quote].documents = doc_ship;
        cont_quote++;
      }
      else if(s.RecordType.DeveloperName == 'Shipment_Order')
      {
        shipments_orders[cont_order].documents = doc_ship;
        cont_order++;
      }
      else
      {
        shipments_orders[cont_order].documents = doc_ship;
        cont_order++;
      }*/
    //}
  }
}