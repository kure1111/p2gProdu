public with sharing class NEU_New_Service_Rate_Internal {
  
  public Fee__c record{get;set;}
  public Fee__c record2{get;set;}
  public Fee__c record_filter{get;set;}
  public Integer result{get;set;}
  public String myid{get;set;}
  public String secret{get;set;}
  public String email{get;set;}
  public Shipment__c shipment_obj{get;set;}
  public List<Shipment__c> shipment_selected = null; 
  public List<Customer_Quote__c> import_export_selected = null;
  public List<Shipment_Program__c> ship_prog_selected = null;
  public List<Carrier_Line_Load_Point__c> route_selected = null;
  public String ya_existe{get;set;}
  public String dia_de_hoy{get;set;}
  public String currency_selected{get;set;}
  public String numero_contenedores{get;set;}
  public String shipment_move_type{get;set;}
  public String shipment_service_type{get;set;}
  public List<SelectOption> currencys {get; set;}
  public String import_export{get;set;}
  public String shipment{get;set;}
  public String Route{get;set;}
  public String ship_program{get;set;}
  public Id id_oi {get;set;}
  public Id id_fee_selected {get;set;}
  public String carrier_id= null;
  public String carrier_Name {get;set;}
  public String ruta_id {get;set;}
  public String rate_type_mod {get;set;}
  private List<SelectOption> listado_rate_type=null;
  public List<SelectOption> routes {get; set;}
  public boolean tiene_costes_adicionales {get;set;}
  public String route_selected_id {get;set;}
  public String name_fee_selected {get;set;}
  public String route_selected_Name {get;set;}
  public Decimal valor_buy_rate {get;set;}
  public boolean acabo_de_guardar {get;set;}
  public String route_selected_id2 {get;set;}
  public String route_selected_Name2 {get;set;}
  public boolean es_fee_modificado {get;set;}
  public String orden_fees_filtro_modo {get;set;}
  public String orden_fees_filtro {get;set;}
  public boolean display_only_active_rates {get;set;}
  private List<Fee__c> listado_fees_carrier=null;
  
    public  List<SelectOption> getlistado_rate_type()
    {
        if(listado_rate_type==null)
        {
            listado_rate_type=null;
            listado_rate_type=new List<SelectOption>();
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Fee__c.Rate_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            boolean ya_existe = false;
            listado_rate_type.add(new SelectOption('',''));
            
            for( Schema.PicklistEntry f : ple)
            {
                if(ya_existe == false)
                {
                    listado_rate_type.add(new SelectOption(f.getValue(),f.getValue()));//------ puede que cambiar esto
                     if(shipment_selected != null && shipment_selected.size()>0 && record != null && record.Rate_Type__c == null && rate_type_mod == null)
                        record.Rate_Type__c=shipment_selected[0].Rate_Type__c;
                    else
                       if(import_export_selected != null && import_export_selected.size()>0 && record != null && record.Rate_Type__c == null && rate_type_mod == null)
                            record.Rate_Type__c=import_export_selected[0].Rate_Type__c;
                }
                ya_existe = false;
            }
            
            if(listado_rate_type != null && rate_type_mod != null)
            {
                record.Rate_Type__c = rate_type_mod;
            }
            
            rate_type_mod = null;
        }
        return listado_rate_type;
    }
  
  public List<Fee__c> getlistado_fees_carrier()
  {
    if(listado_fees_carrier == null) 
    {
            if((shipment_selected != null && shipment_selected.size()>0) || (import_export_selected != null && import_export_selected.size()>0) || (route_selected != null && route_selected.size()>0) || (ship_prog_selected != null && ship_prog_selected.size()>0))// ------esto con uno valdria se repiten
            {
                if(route_selected_id != null)
                {
                	Id id_route = Id.valueOf(route_selected_id);
                    if(record_filter != null && record_filter.Carrier_Account__c != null)
                    {
                        if(display_only_active_rates == true)
                            listado_fees_carrier = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c,Comments__c,Buy_Rate__c , Pallet_Type__c, Rate_Names_List__c, Fee_Rate__c ,Valid_Until__c, Cost_Concept_1__c , Cost_Concept_2__c ,Cost_Concept_3__c ,Cost_Concept_4__c ,Cost_Concept_5__c , Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Active__c, RecordTypeId, Rate_Type__c ,Account_for__r.Name,TT_Days__c,Carrier_Account__c, Delivery_Zone__c, Port_Airport__c, Fee__c, Master_Allocation__c,Route__c, Sub_Allocation__c,Fee_Category__c  from Fee__c where Carrier_Account__c =\''+ record_filter.Carrier_Account__c+'\' and Route__c =:id_route and Active__c = true order by '+String.escapeSingleQuotes(orden_fees_filtro+' '+orden_fees_filtro_modo) +' ');//, CurrencyIsoCode
                        else
                            listado_fees_carrier = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c,Comments__c,Buy_Rate__c , Pallet_Type__c, Rate_Names_List__c, Fee_Rate__c ,Valid_Until__c, Cost_Concept_1__c , Cost_Concept_2__c ,Cost_Concept_3__c ,Cost_Concept_4__c ,Cost_Concept_5__c , Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Active__c, RecordTypeId, Rate_Type__c ,Account_for__r.Name,TT_Days__c,Carrier_Account__c, Delivery_Zone__c, Port_Airport__c, Fee__c, Master_Allocation__c,Route__c, Sub_Allocation__c,Fee_Category__c  from Fee__c where Carrier_Account__c =\''+ record_filter.Carrier_Account__c+'\' and Route__c =:id_route order by '+String.escapeSingleQuotes(orden_fees_filtro+' '+orden_fees_filtro_modo) +' ');//, CurrencyIsoCode
                    }
                    else
                    {
                        if(display_only_active_rates == true)
                            listado_fees_carrier = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c,Comments__c,Buy_Rate__c , Pallet_Type__c, Rate_Names_List__c, Fee_Rate__c ,Valid_Until__c, Cost_Concept_1__c , Cost_Concept_2__c ,Cost_Concept_3__c ,Cost_Concept_4__c ,Cost_Concept_5__c , Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Active__c, RecordTypeId, Rate_Type__c ,Account_for__r.Name,TT_Days__c,Carrier_Account__c, Delivery_Zone__c, Port_Airport__c, Fee__c, Master_Allocation__c,Route__c, Sub_Allocation__c,Fee_Category__c  from Fee__c where Route__c =:id_route and Active__c = true order by '+String.escapeSingleQuotes(orden_fees_filtro+' '+orden_fees_filtro_modo) +' ');//, CurrencyIsoCode
                        else
                            listado_fees_carrier = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c,Comments__c,Buy_Rate__c , Pallet_Type__c, Rate_Names_List__c, Fee_Rate__c ,Valid_Until__c, Cost_Concept_1__c , Cost_Concept_2__c ,Cost_Concept_3__c ,Cost_Concept_4__c ,Cost_Concept_5__c , Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Active__c, RecordTypeId, Rate_Type__c ,Account_for__r.Name,TT_Days__c,Carrier_Account__c, Delivery_Zone__c, Port_Airport__c, Fee__c, Master_Allocation__c,Route__c, Sub_Allocation__c,Fee_Category__c  from Fee__c where Route__c =:id_route order by '+String.escapeSingleQuotes(orden_fees_filtro+' '+orden_fees_filtro_modo) +' ');//, CurrencyIsoCode
                    }
                }
                
            }
            
     }
     return listado_fees_carrier;
  }
  
     //funciones de comparacion
    public void go_compare_fees_filtro()
    {
         listado_fees_carrier = null;
    }
  
    public String getcarrier_id()
    {
        return carrier_id;
    }
    public void setcarrier_id(String value)
    {
        if(carrier_id!=value)
        {
            carrier_id=value;
            listado_fees_carrier = null;
        }
    }
    public String decimalSep
    {
           get
           {
             if(decimalSep==null)
               decimalSep=NEU_Utils.getDecimalSep();
             return decimalSep;
           }
           set
           {
             decimalSep=value;
           }
    }
    public String thousandSep
    {
           get
           {
             if(thousandSep==null)
               thousandSep=NEU_Utils.getThousandSep();
             return thousandSep;
           }
           set
           {
             thousandSep=value;
           }
    }
        
   public NEU_New_Service_Rate_Internal(ApexPages.StandardController stdController) {    
         
        record = new Fee__c();
        myid = '';
        ya_existe = '0';
        dia_de_hoy = system.today().format();
        es_fee_modificado = false;
        display_only_active_rates = true; 
        secret = Apexpages.currentPage().getParameters().get('secret');
        email = Apexpages.currentPage().getParameters().get('email');
        if(Apexpages.currentPage().getParameters().get('email') != null && Apexpages.currentPage().getParameters().get('secret') != null)
        {
          List<Contact> listado_contactos = [select Id, Name, AccountId from Contact where Email =: Apexpages.currentPage().getParameters().get('email') and Secret__c =: Apexpages.currentPage().getParameters().get('secret')];
          if(listado_contactos.size()>0)
            myid =listado_contactos[0].AccountId;
        }
        numero_contenedores = '';
        shipment_move_type = '';
        shipment_service_type = '';
        shipment=Apexpages.currentPage().getParameters().get('shipment');
        Route=Apexpages.currentPage().getParameters().get('route');
        if(Apexpages.currentPage().getParameters().get('shipment') != null && Apexpages.currentPage().getParameters().get('shipment') !='')
        {
          List<Shipment__c> listado_shipments = [select Id, Name from Shipment__c where id =: Apexpages.currentPage().getParameters().get('shipment')];
          if(listado_shipments.size()>0)
            shipment_obj = listado_shipments[0];
        }
        import_export=Apexpages.currentPage().getParameters().get('import_export');
        ship_program =Apexpages.currentPage().getParameters().get('ships_program');
        orden_fees_filtro = 'Name';
        orden_fees_filtro_modo = 'asc';
        shipment_selected = null;
        import_export_selected = null;  
        ship_prog_selected = null;
        route_selected = null;
        tiene_costes_adicionales = false;
        record_filter = new Fee__c();
        if(shipment != null  && shipment != '')
        {
          shipment_selected = [select Id, Name, Freight_Mode__c, Nature_Merchandise__c, Country_of_Discharge__c, Country_of_Load__c, Site_of_Discharge__c, Site_of_Load__c, Total_Weight_Kg__c,Route__r.Port_Airport_of_Discharge__r.Name,Route__r.Port_Airport_of_Load__r.Name,Container_Type__r.Name,Route__r.Port_Airport_of_Load__c,Route__r.Port_Airport_of_Discharge__c, N_Containers__c,Move_Type__c,Service_Type__c,  Total_Volume_m3__c, Route__r.Name, Route__c, Route__r.Active_Rates__c, Route__r.Min_Rate__c, Container_Type__c, Account_for__c, Rate_Type__c, State_of_Discharge__c, State_of_Load__c from Shipment__c where id =: shipment];
          if(shipment_selected != null && shipment_selected.size()>0) 
          {
              if(shipment_selected[0].Freight_Mode__c == 'Air')
                record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
              else
                record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
              
              record.Route__c =shipment_selected[0].Route__c;
              route_selected_id = shipment_selected[0].Route__c;
            
              route_selected_Name = record.Route__r.Name;
              route_selected_id2 = shipment_selected[0].Route__c;
              route_selected_Name2 = record.Route__r.Name;
              record.Route__c =route_selected_id2;
              List<id> contenedor_rutas_ids = new List<Id>();
              routes = new List<SelectOption>();
              string contenedor_rutas_string = '';
              if(shipment_selected[0].Route__c != null)
              {
                    routes.add(new SelectOption(shipment_selected[0].Route__c,shipment_selected[0].Route__r.Name));
                    contenedor_rutas_ids.add(shipment_selected[0].Route__c);
                    contenedor_rutas_string += '\''+shipment_selected[0].Route__c+'\''+',';
              }
              
              //consulta para obtener todas las rutas posibles
              string query_routes_string = ''; 
              query_routes_string += 'select Id, Name, Country_of_Discharge__c, Country_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c,';

              query_routes_string += '  State_of_Discharge__c, State_of_Load__c';
              query_routes_string += '  from Carrier_Line_Load_Point__c ';
              query_routes_string += 'where (Country_of_Discharge__c = '+(shipment_selected[0].Country_of_Discharge__c != null ? '\''+shipment_selected[0].Country_of_Discharge__c+'\'': null )+' or Country_of_Discharge__c = null or (Country_of_Discharge__c = '+(shipment_selected[0].Country_of_Load__c != null ? '\''+shipment_selected[0].Country_of_Load__c+'\'': null )+' and Country_of_Load__c = null))';
              query_routes_string += ' and (Country_of_Load__c =  '+(shipment_selected[0].Country_of_Load__c != null ? '\''+shipment_selected[0].Country_of_Load__c+'\'': null )+' or Country_of_Load__c = null or (Country_of_Load__c = '+(shipment_selected[0].Country_of_Discharge__c != null ? '\''+shipment_selected[0].Country_of_Discharge__c+'\'': null )+' and Country_of_Discharge__c = null))';
              if(shipment_selected[0].State_of_Load__c != null)              
              	query_routes_string += ' and (State_of_Load__c =  '+(shipment_selected[0].State_of_Load__c != null ? '\''+shipment_selected[0].State_of_Load__c+'\'': null )+' or State_of_Load__c = null or (State_of_Load__c = '+(shipment_selected[0].State_of_Discharge__c != null ? '\''+shipment_selected[0].State_of_Discharge__c+'\'': null )+' and State_of_Discharge__c = null))';
              if(shipment_selected[0].State_of_Discharge__c != null)
              	query_routes_string += ' and (State_of_Discharge__c =  '+(shipment_selected[0].State_of_Discharge__c != null ? '\''+shipment_selected[0].State_of_Discharge__c+'\'': null )+' or State_of_Discharge__c = null or (State_of_Discharge__c = '+(shipment_selected[0].State_of_Load__c != null ? '\''+shipment_selected[0].State_of_Load__c+'\'': null )+' and State_of_Load__c = null))';
              if(shipment_selected[0].Site_of_Discharge__c != null)
                query_routes_string += ' and (Port_Airport_of_Discharge__c = '+(shipment_selected[0].Site_of_Discharge__c != null ? '\''+shipment_selected[0].Site_of_Discharge__c+'\'': null )+' or Port_Airport_of_Discharge__c = null or (Port_Airport_of_Discharge__c = '+(shipment_selected[0].Site_of_Load__c != null ? '\''+shipment_selected[0].Site_of_Load__c+'\'': null )+' and Port_Airport_of_Load__c = null))';
              if(shipment_selected[0].Site_of_Load__c != null)
                query_routes_string += ' and (Port_Airport_of_Load__c = '+(shipment_selected[0].Site_of_Load__c != null ? '\''+shipment_selected[0].Site_of_Load__c+'\'': null )+' or Port_Airport_of_Load__c = null or (Port_Airport_of_Load__c = '+(shipment_selected[0].Site_of_Discharge__c != null ? '\''+shipment_selected[0].Site_of_Discharge__c+'\'': null )+' and Port_Airport_of_Discharge__c = null))';
              if(contenedor_rutas_string != '' && contenedor_rutas_string != null)
                query_routes_string  +=' and Id not IN ('+contenedor_rutas_string.subString(0,contenedor_rutas_string.length()-1)+')'; 
              List<Carrier_Line_Load_Point__c> listado_routes = Database.query(query_routes_string);
              
              for(Carrier_Line_Load_Point__c cllp : listado_routes)
              {
                if(route_selected_id == null || route_selected_id == '')
                    route_selected_id = cllp.Id;
                routes.add(new SelectOption(cllp.Id,cllp.Name));
              }         
              
              if(shipment_selected[0].N_Containers__c != null)
                  numero_contenedores =string.valueof(shipment_selected[0].N_Containers__c);
              if(shipment_selected[0].Move_Type__c != null)
                  shipment_move_type =string.valueof(shipment_selected[0].Move_Type__c);    
              if(shipment_selected[0].Service_Type__c!= null)
                  shipment_service_type =string.valueof(shipment_selected[0].Service_Type__c);  
              if(shipment_selected[0].Freight_Mode__c == 'Air')
                record.Fee_Category__c = 'Air Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Sea')
                record.Fee_Category__c = 'Sea Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Road')
                record.Fee_Category__c = 'Road Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Rail')
                record.Fee_Category__c = 'Railway Freights';
              record.Name = '';
              /*string nombre_new_fee = shipment_selected[0].Route__r.Port_Airport_of_Load__r.Name +'-'+ shipment_selected[0].Route__r.Port_Airport_of_Discharge__r.Name +(shipment_selected[0].Container_Type__c != null ? ' - ' + shipment_selected[0].Container_Type__r.Name : '');
              if(nombre_new_fee != '' && nombre_new_fee != null && nombre_new_fee.length() > 79)
                record.Name = nombre_new_fee.substring(0,79);
              else
                record.Name = nombre_new_fee;*/
              
              record.Fee_Description__c ='Quote for '+(shipment_selected[0].Nature_Merchandise__c != null ? shipment_selected[0].Nature_Merchandise__c : shipment_selected[0].Name)+' Total Weight (Kg) '+ shipment_selected[0].Total_Weight_Kg__c.setScale(2) +' Total Volume (m3) '+shipment_selected[0].Total_Volume_m3__c.setScale(2);
              record.Account_for__c =shipment_selected[0].Account_for__c;
              if(myid != '' && myid != null)
                record.Carrier_Account__c =myid;
              record.Container_Type__c = shipment_selected[0].Container_Type__c;
              record.Active__c = true;
              record.Shipment_Quoted_Marketplace__c = shipment;
              if(shipment_selected[0].Rate_Type__c == null && record.Rate_Type__c != null)
                shipment_selected[0].Rate_Type__c = record.Rate_Type__c; 
              record.Rate_Type__c = shipment_selected[0].Rate_Type__c;
              ruta_id = shipment_selected[0].Route__c;
              record2 = record;
          }
        }
        else if(import_export != null && import_export != '')
        {
            import_export_selected = [select Id, Name, Freight_Mode__c, Nature_Merchandise__c, Country_ofDischarge__c, Country_ofLoad__c, Site_of_Discharge__c, Site_of_Load__c, Total_Weight_Kg2__c,Route__r.Port_Airport_of_Discharge__r.Name,Route__r.Port_Airport_of_Load__r.Name,Route__r.Port_Airport_of_Load__c,Route__r.Port_Airport_of_Discharge__c, Container_Type__r.Name, Move_Type__c,Service_Type__c,Container_Count__c, Container_Type__c , Total_Volume_m3_2__c, Route__r.Name, Route__c, Account_for__c, Rate_Type__c, State_of_Discharge__c, State_of_Load__c from Customer_Quote__c where id =: import_export];
            if(import_export_selected != null && import_export_selected.size()>0)
              {
                  if(import_export_selected[0].Freight_Mode__c == 'Air')
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                  else
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                  
                  record.Route__c =import_export_selected[0].Route__c;
                  route_selected_id = import_export_selected[0].Route__c;
                  route_selected_Name = import_export_selected[0].Route__r.Name;
                  route_selected_id2 = import_export_selected[0].Route__c;
                 
                    
                  route_selected_Name2 = import_export_selected[0].Route__r.Name;
                  record.Route__c = route_selected_id2;  
                  List<id> contenedor_rutas_ids = new List<Id>();
                  routes = new List<SelectOption>();
                  String contenedor_rutas_string = '';
                  if(import_export_selected[0].Route__c != null)
                  {
                        routes.add(new SelectOption(import_export_selected[0].Route__c,import_export_selected[0].Route__r.Name));
                        contenedor_rutas_ids.add(import_export_selected[0].Route__c);
                        contenedor_rutas_string += '\''+import_export_selected[0].Route__c+'\''+',';
                  }
                  
                  //consulta para obtener todas las rutas posibles
                  string query_routes_string = ''; 
                  query_routes_string += 'select Id, Name, Country_of_Discharge__c, Country_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c,';

                  query_routes_string += '  State_of_Load__c, State_of_Discharge__c';
                  query_routes_string += '  from Carrier_Line_Load_Point__c ';
                  query_routes_string += 'where (Country_of_Discharge__c = '+(import_export_selected[0].Country_ofDischarge__c != null ? '\''+import_export_selected[0].Country_ofDischarge__c+'\'': null )+' or Country_of_Discharge__c = null or (Country_of_Discharge__c = '+(import_export_selected[0].Country_ofLoad__c != null ? '\''+import_export_selected[0].Country_ofLoad__c+'\'': null )+' and Country_of_Load__c = null))';
                  query_routes_string += ' and (Country_of_Load__c =  '+(import_export_selected[0].Country_ofLoad__c != null ? '\''+import_export_selected[0].Country_ofLoad__c+'\'': null )+' or Country_of_Load__c = null or (Country_of_Load__c = '+(import_export_selected[0].Country_ofDischarge__c != null ? '\''+import_export_selected[0].Country_ofDischarge__c+'\'': null )+' and Country_of_Discharge__c = null))';
                  if(import_export_selected[0].State_of_Load__c != null)
                  	query_routes_string += ' and (State_of_Load__c =  '+(import_export_selected[0].State_of_Load__c != null ? '\''+import_export_selected[0].State_of_Load__c+'\'': null )+' or State_of_Load__c = null or (State_of_Load__c = '+(import_export_selected[0].State_of_Discharge__c != null ? '\''+import_export_selected[0].State_of_Discharge__c+'\'': null )+' and State_of_Discharge__c = null))';
                  if(import_export_selected[0].State_of_Discharge__c != null)
                  	query_routes_string += ' and (State_of_Discharge__c =  '+(import_export_selected[0].State_of_Discharge__c != null ? '\''+import_export_selected[0].State_of_Discharge__c+'\'': null )+' or State_of_Discharge__c = null or (State_of_Discharge__c = '+(import_export_selected[0].State_of_Load__c != null ? '\''+import_export_selected[0].State_of_Discharge__c+'\'': null )+' and State_of_Discharge__c = null))';
                  if(import_export_selected[0].Site_of_Discharge__c != null)
                    query_routes_string += ' and (Port_Airport_of_Discharge__c = '+(import_export_selected[0].Site_of_Discharge__c != null ? '\''+import_export_selected[0].Site_of_Discharge__c+'\'': null )+' or Port_Airport_of_Discharge__c = null or (Port_Airport_of_Discharge__c = '+(import_export_selected[0].Site_of_Load__c != null ? '\''+import_export_selected[0].Site_of_Load__c+'\'': null )+' and Port_Airport_of_Load__c = null))';
                  if(import_export_selected[0].Site_of_Load__c != null)
                    query_routes_string += ' and (Port_Airport_of_Load__c = '+(import_export_selected[0].Site_of_Load__c != null ? '\''+import_export_selected[0].Site_of_Load__c+'\'': null )+' or Port_Airport_of_Load__c = null or (Port_Airport_of_Load__c = '+(import_export_selected[0].Site_of_Discharge__c != null ? '\''+import_export_selected[0].Site_of_Discharge__c+'\'': null )+' and Port_Airport_of_Discharge__c = null))';
                  if(contenedor_rutas_string != '' && contenedor_rutas_string != null)
                    query_routes_string  +=' and Id not IN ('+contenedor_rutas_string.subString(0,contenedor_rutas_string.length()-1)+')'; 
                  
                  List<Carrier_Line_Load_Point__c> listado_routes = Database.query(query_routes_string);
              
                  for(Carrier_Line_Load_Point__c cllp : listado_routes)
                  {
                    if(route_selected_id == null || route_selected_id == '')
                        route_selected_id = cllp.Id;
                    routes.add(new SelectOption(cllp.Id,cllp.Name));
                  }
                  
                  if(import_export_selected[0].Container_Count__c != null)
                      numero_contenedores =string.valueof(import_export_selected[0].Container_Count__c);
                  if(import_export_selected[0].Move_Type__c != null)
                      shipment_move_type =string.valueof(import_export_selected[0].Move_Type__c);    
                  if(import_export_selected[0].Service_Type__c!= null)
                      shipment_service_type =string.valueof(import_export_selected[0].Service_Type__c);  
                  if(import_export_selected[0].Freight_Mode__c == 'Air')
                    record.Fee_Category__c = 'Air Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Sea')
                    record.Fee_Category__c = 'Sea Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Road')
                    record.Fee_Category__c = 'Road Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Rail')
                    record.Fee_Category__c = 'Railway Freights';
                  record.Name = '';
                  /*string nombre_new_fee = import_export_selected[0].Route__r.Port_Airport_of_Load__r.Name +'-'+ import_export_selected[0].Route__r.Port_Airport_of_Discharge__r.Name +(import_export_selected[0].Container_Type__c != null ? ' - ' + import_export_selected[0].Container_Type__r.Name : '');
                  if(nombre_new_fee != '' && nombre_new_fee != null && nombre_new_fee.length() > 79)
                    record.Name = nombre_new_fee.substring(0,79);
                  else
                    record.Name = nombre_new_fee;*/
                  record.Fee_Description__c ='Quote for '+(import_export_selected[0].Nature_Merchandise__c != null ? import_export_selected[0].Nature_Merchandise__c : import_export_selected[0].Name)+' Total Weight (Kg) '+ import_export_selected[0].Total_Weight_Kg2__c +' Total Volume (m3) '+import_export_selected[0].Total_Volume_m3_2__c;
                  record.Account_for__c =import_export_selected[0].Account_for__c;
                  if(myid != '' && myid != null)
                    record.Carrier_Account__c =myid;
                  record.Container_Type__c = import_export_selected[0].Container_Type__c;
                  record.Active__c = true;
                  record.Import_Export_Quoted_Marketplace__c = import_export; 
                  if(import_export_selected[0].Rate_Type__c == null && record.Rate_Type__c != null)
                    import_export_selected[0].Rate_Type__c = record.Rate_Type__c;
                  record.Rate_Type__c = import_export_selected[0].Rate_Type__c;
                  ruta_id = import_export_selected[0].Route__c;
                  record2 = record;
              }
        }
        else if(ship_program != null && ship_program != '')
        {
            ship_prog_selected = [select Id, Name, Freight_Mode__c, Type__c, Route__c, Route__r.Name, Route__r.State_of_Load__c, Route__r.State_of_Discharge__c,
            Route__r.Port_Airport_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Country_of_Discharge__c,
            Number_of_Containers__c, Route__r.Port_Airport_of_Load__c,
            Route__r.Port_Airport_of_Load__r.Name, Route__r.Port_Airport_of_Discharge__r.Name, Total_Gross_Volume_m3__c, Total_Gross_Weight_Kg__c, Pallet_Container_Type__r.Container_Type__c, Pallet_Container_Type__r.Container_Type__r.Name
            from Shipment_Program__c where id =: ship_program];
            
            if(ship_prog_selected != null && ship_prog_selected.size()>0)
            {
                if(ship_prog_selected[0].Freight_Mode__c == 'Air')
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                else
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                    
                record.Route__c =ship_prog_selected[0].Route__c;
                route_selected_id = ship_prog_selected[0].Route__c;
                  
                route_selected_Name = ship_prog_selected[0].Route__r.Name;
                
                route_selected_id2 = ship_prog_selected[0].Route__c;   
                  
                 route_selected_Name2 = ship_prog_selected[0].Route__r.Name;
                 record.Route__c = route_selected_id2;  
                 
                 List<id> contenedor_rutas_ids = new List<Id>();
                 routes = new List<SelectOption>();
                 if(ship_prog_selected[0].Route__c != null)
                 {
                      routes.add(new SelectOption(ship_prog_selected[0].Route__c,ship_prog_selected[0].Route__r.Name));
                      contenedor_rutas_ids.add(ship_prog_selected[0].Route__c);
                 }
                  
                  if(ship_prog_selected[0].Route__c != null)
                  {
                      List<Carrier_Line_Load_Point__c> listado_routes = [select Id, Name, Country_of_Discharge__c, Country_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c,
                      State_of_Discharge__c, State_of_Load__c
                      from Carrier_Line_Load_Point__c where (Country_of_Discharge__c =: ship_prog_selected[0].Route__r.Country_of_Discharge__c or Country_of_Discharge__c =: null)
                      and (Country_of_Load__c =: ship_prog_selected[0].Route__r.Country_of_Load__c or Country_of_Load__c =:null)
                      and (State_of_Load__c =: ship_prog_selected[0].Route__r.State_of_Load__c or State_of_Load__c =:null)
                      and (State_of_Discharge__c =: ship_prog_selected[0].Route__r.State_of_Discharge__c or State_of_Discharge__c =:null)
                      and (Port_Airport_of_Discharge__c =: ship_prog_selected[0].Route__r.Port_Airport_of_Discharge__c or Port_Airport_of_Discharge__c =:null)
                      and (Port_Airport_of_Load__c =: ship_prog_selected[0].Route__r.Port_Airport_of_Load__c or Port_Airport_of_Load__c =: null)
                      and Id not IN: contenedor_rutas_ids];
                      for(Carrier_Line_Load_Point__c cllp : listado_routes)
                      { 
                        routes.add(new SelectOption(cllp.Id,cllp.Name));
                      } 
                      
                       record.Name = '';  
                  }
                      
                if(ship_prog_selected[0].Number_of_Containers__c != null)
                      numero_contenedores =string.valueof(ship_prog_selected[0].Number_of_Containers__c);
                  if(ship_prog_selected[0].Type__c != null) 
                      shipment_move_type =string.valueof(ship_prog_selected[0].Type__c);    
                      
                  if(ship_prog_selected[0].Freight_Mode__c == 'Air')
                    record.Fee_Category__c = 'Air Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Sea')
                    record.Fee_Category__c = 'Sea Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Road')
                    record.Fee_Category__c = 'Road Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Rail')
                    record.Fee_Category__c = 'Railway Freights';
                 
                  
                  record.Fee_Description__c ='Quote for '+ship_prog_selected[0].Name+' Total Weight (Kg) '+ ship_prog_selected[0].Total_Gross_Weight_Kg__c +' Total Volume (m3) '+ship_prog_selected[0].Total_Gross_Volume_m3__c;
                 // record.Account_for__c =ship_prog_selected[0].Account_for__c;//--- no hay cuenta
                  if(myid != '' && myid != null)
                    record.Carrier_Account__c =myid;
                  if(ship_prog_selected[0].Pallet_Container_Type__c != null)
                    record.Container_Type__c = ship_prog_selected[0].Pallet_Container_Type__r.Container_Type__c; 
                  record.Active__c = true;
                 // if(import_export_selected[0].Rate_Type__c == null && record.Rate_Type__c != null)
                   // import_export_selected[0].Rate_Type__c = record.Rate_Type__c;//---mo hay
                  //record.Rate_Type__c = import_export_selected[0].Rate_Type__c;// no hay
                  ruta_id = ship_prog_selected[0].Route__c;
                  record2 = record;
              }       
        }
        else if(Route != null && Route != '')
        {
          route_selected = [select Id, Name, Port_Airport_of_Load__r.Name, Port_Airport_of_Discharge__r.Name,  Active_Rates__c, Min_Rate__c  from Carrier_Line_Load_Point__c where id =: Route];
          if(route_selected != null && route_selected.size()>0) 
          {
              
              record.Route__c =route_selected[0].Id;

              route_selected_id = route_selected[0].Id;
              route_selected_Name = record.Route__r.Name;
              route_selected_id2 = route_selected[0].Id;
              record.Route__c = route_selected_id2;     
              route_selected_Name2 = record.Route__r.Name;
              routes = new List<SelectOption>();
              if(route_selected[0].Id != null)
              {
                    routes.add(new SelectOption(route_selected[0].Id,route_selected[0].Name));
              }

              record.Name = '';
            
              
              record.Fee_Description__c ='Quote for '+route_selected[0].Name+' ';
              if(myid != '' && myid != null)
                record.Carrier_Account__c =myid;
              record.Active__c = true;
              ruta_id = route_selected[0].Id;
              record2 = record;
          }
        }
        else
        {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The shipment is not correct. Please try again'));
        }
        
        currency_selected = '';
        currencys = new List<SelectOption>(); 
        if(UserInfo.isMultiCurrencyOrganization()== true)
        {
           for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
             {
                  currencys.add(new SelectOption(lu,lu));  
             }
        }
        else
          currencys.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
        currency_selected = UserInfo.getDefaultCurrency();   
    }
    
    public void setranking(String value){}
    public String getranking()
    {
        Integer r = update_Ranking();
        result=-1;
        if(r>9)
            return 'YOUR RANKING '+String.valueOf(r);
        if(r>0)
            return 'YOUR RANKING 0'+String.valueOf(r);
        return 'YOUR RANKING --';
    }
    
    public void create_new_fee()
    {
        record = new Fee__c();
        myid = '';
        ya_existe = '0';
        dia_de_hoy = system.today().format();
        id_fee_selected = null;
        valor_buy_rate = null;
        es_fee_modificado = false;
        secret = Apexpages.currentPage().getParameters().get('secret');
        email = Apexpages.currentPage().getParameters().get('email');
        if(Apexpages.currentPage().getParameters().get('email') != null && Apexpages.currentPage().getParameters().get('secret') != null)
        {
          List<Contact> listado_contactos = [select Id, Name, AccountId from Contact where Email =: Apexpages.currentPage().getParameters().get('email') and Secret__c =: Apexpages.currentPage().getParameters().get('secret')];
          if(listado_contactos.size()>0)
            myid =listado_contactos[0].AccountId;
        }
        numero_contenedores = '';
        shipment_move_type = '';
        shipment_service_type = '';
        shipment=Apexpages.currentPage().getParameters().get('shipment');
        Route=Apexpages.currentPage().getParameters().get('route');
        if(Apexpages.currentPage().getParameters().get('shipment') != null && Apexpages.currentPage().getParameters().get('shipment') !='')
        {
          List<Shipment__c> listado_shipments = [select Id, Name from Shipment__c where id =: Apexpages.currentPage().getParameters().get('shipment')];
          if(listado_shipments.size()>0)
            shipment_obj = listado_shipments[0];
        }
        import_export=Apexpages.currentPage().getParameters().get('import_export');
        ship_program =Apexpages.currentPage().getParameters().get('ships_program');
        
        shipment_selected = null;
        import_export_selected = null; 
        route_selected = null;
        tiene_costes_adicionales = false;
        record_filter = new Fee__c();
        if(shipment != null  && shipment != '')
        {
          shipment_selected = [select Id, Name, Freight_Mode__c,Total_Weight_Kg__c,Route__r.Port_Airport_of_Discharge__r.Name,Site_of_Load__c, Nature_Merchandise__c, Site_of_Discharge__c,Country_of_Load__c, Country_of_Discharge__c, Route__r.Port_Airport_of_Load__r.Name,Container_Type__r.Name,Route__r.Port_Airport_of_Load__c,Route__r.Port_Airport_of_Discharge__c, N_Containers__c,Move_Type__c,Service_Type__c,  Total_Volume_m3__c, Route__r.Name, Route__c, Route__r.Active_Rates__c, Route__r.Min_Rate__c, Container_Type__c, Account_for__c, Rate_Type__c, State_of_Load__c, State_of_Discharge__c from Shipment__c where id =: shipment];
          if(shipment_selected != null && shipment_selected.size()>0) 
          {
              if(shipment_selected[0].Freight_Mode__c == 'Air')
                record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
              else
                record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
              record.Route__c =shipment_selected[0].Route__c;
              
              route_selected_Name = record.Route__r.Name;
              route_selected_Name2 = record.Route__r.Name;
              List<id> contenedor_rutas_ids = new List<Id>();
              routes = new List<SelectOption>();
              string contenedor_rutas_string = '';
              if(shipment_selected[0].Route__c != null)
              {
                    routes.add(new SelectOption(shipment_selected[0].Route__c,shipment_selected[0].Route__r.Name));
                    contenedor_rutas_ids.add(shipment_selected[0].Route__c);
                    contenedor_rutas_string += '\''+shipment_selected[0].Route__c+'\''+',';
              }
              
              string query_routes_string = ''; 
              query_routes_string += 'select Id, Name, Country_of_Discharge__c, Country_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c,';
              query_routes_string += '  State_of_Discharge__c, State_of_Load__c';
              query_routes_string += '  from Carrier_Line_Load_Point__c ';
              query_routes_string += 'where (Country_of_Discharge__c = '+(shipment_selected[0].Country_of_Discharge__c != null ? '\''+shipment_selected[0].Country_of_Discharge__c+'\'': null )+' or Country_of_Discharge__c = null or (Country_of_Discharge__c = '+(shipment_selected[0].Country_of_Load__c != null ? '\''+shipment_selected[0].Country_of_Load__c+'\'': null )+' and Country_of_Load__c = null))';
              query_routes_string += ' and (Country_of_Load__c =  '+(shipment_selected[0].Country_of_Load__c != null ? '\''+shipment_selected[0].Country_of_Load__c+'\'': null )+' or Country_of_Load__c = null or (Country_of_Load__c = '+(shipment_selected[0].Country_of_Discharge__c != null ? '\''+shipment_selected[0].Country_of_Discharge__c+'\'': null )+' and Country_of_Discharge__c = null))';
              query_routes_string += ' and (State_of_Load__c =  '+(shipment_selected[0].State_of_Load__c != null ? '\''+shipment_selected[0].State_of_Load__c+'\'': null )+' or State_of_Load__c = null or (State_of_Load__c = '+(shipment_selected[0].State_of_Discharge__c != null ? '\''+shipment_selected[0].State_of_Discharge__c+'\'': null )+' and State_of_Discharge__c = null))';
              query_routes_string += ' and (State_of_Discharge__c =  '+(shipment_selected[0].State_of_Discharge__c != null ? '\''+shipment_selected[0].State_of_Discharge__c+'\'': null )+' or State_of_Discharge__c = null or (State_of_Discharge__c = '+(shipment_selected[0].State_of_Load__c != null ? '\''+shipment_selected[0].State_of_Load__c+'\'': null )+' and State_of_Load__c = null))';
              if(shipment_selected[0].Site_of_Discharge__c != null)
                query_routes_string += ' and (Port_Airport_of_Discharge__c = '+(shipment_selected[0].Site_of_Discharge__c != null ? '\''+shipment_selected[0].Site_of_Discharge__c+'\'': null )+' or Port_Airport_of_Discharge__c = null or (Port_Airport_of_Discharge__c = '+(shipment_selected[0].Site_of_Load__c != null ? '\''+shipment_selected[0].Site_of_Load__c+'\'': null )+' and Port_Airport_of_Load__c = null))';
              if(shipment_selected[0].Site_of_Load__c != null)
                query_routes_string += ' and (Port_Airport_of_Load__c = '+(shipment_selected[0].Site_of_Load__c != null ? '\''+shipment_selected[0].Site_of_Load__c+'\'': null )+' or Port_Airport_of_Load__c = null or (Port_Airport_of_Load__c = '+(shipment_selected[0].Site_of_Discharge__c != null ? '\''+shipment_selected[0].Site_of_Discharge__c+'\'': null )+' and Port_Airport_of_Discharge__c = null))';
              if(contenedor_rutas_string != '' && contenedor_rutas_string != null)
                query_routes_string  +=' and Id not IN ('+contenedor_rutas_string.subString(0,contenedor_rutas_string.length()-1)+')'; 
              List<Carrier_Line_Load_Point__c> listado_routes = Database.query(query_routes_string);
              
              for(Carrier_Line_Load_Point__c cllp : listado_routes)
              {
                routes.add(new SelectOption(cllp.Id,cllp.Name));
              }
              
              if(shipment_selected[0].N_Containers__c != null)
                  numero_contenedores =string.valueof(shipment_selected[0].N_Containers__c);
              if(shipment_selected[0].Move_Type__c != null)
                  shipment_move_type =string.valueof(shipment_selected[0].Move_Type__c);    
              if(shipment_selected[0].Service_Type__c!= null)
                  shipment_service_type =string.valueof(shipment_selected[0].Service_Type__c);  
              if(shipment_selected[0].Freight_Mode__c == 'Air')
                record.Fee_Category__c = 'Air Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Sea')
                record.Fee_Category__c = 'Sea Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Road')
                record.Fee_Category__c = 'Road Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Rail')
                record.Fee_Category__c = 'Railway Freights';
              record.Name = '';
              /*string nombre_new_fee = shipment_selected[0].Route__r.Port_Airport_of_Load__r.Name +'-'+ shipment_selected[0].Route__r.Port_Airport_of_Discharge__r.Name +(shipment_selected[0].Container_Type__c != null ? ' - ' + shipment_selected[0].Container_Type__r.Name : '');
              if(nombre_new_fee != '' && nombre_new_fee != null && nombre_new_fee.length() > 79)
                record.Name = nombre_new_fee.substring(0,79);
              else
                record.Name = nombre_new_fee;*/
              record.Fee_Description__c ='Quote for '+( shipment_selected[0].Nature_Merchandise__c != null ? shipment_selected[0].Nature_Merchandise__c : shipment_selected[0].Name)+' Total Weight (Kg) '+ shipment_selected[0].Total_Weight_Kg__c.setScale(2) +' Total Volume (m3) '+shipment_selected[0].Total_Volume_m3__c.setScale(2);
              record.Account_for__c =shipment_selected[0].Account_for__c;
              if(myid != '' && myid != null)
                record.Carrier_Account__c =myid;
              record.Container_Type__c = shipment_selected[0].Container_Type__c;
              record.Active__c = true;
              record.Shipment_Quoted_Marketplace__c = shipment;
              if(shipment_selected[0].Rate_Type__c == null && record.Rate_Type__c != null)
                shipment_selected[0].Rate_Type__c = record.Rate_Type__c;
              record.Rate_Type__c = shipment_selected[0].Rate_Type__c;
              ruta_id = shipment_selected[0].Route__c;
              record2 = record;
          }
        }
        else if(import_export != null && import_export != '')
        {
            import_export_selected = [select Id, Name, Freight_Mode__c,Total_Weight_Kg2__c,Country_ofDischarge__c,Nature_Merchandise__c, Country_ofLoad__c, Site_of_Discharge__c, Site_of_Load__c,Route__r.Port_Airport_of_Discharge__r.Name,Route__r.Port_Airport_of_Load__r.Name,Route__r.Port_Airport_of_Load__c,Route__r.Port_Airport_of_Discharge__c, Container_Type__r.Name, Move_Type__c,Service_Type__c,Container_Count__c, Container_Type__c , Total_Volume_m3_2__c, Route__r.Name, Route__c, Account_for__c, Rate_Type__c, State_of_Discharge__c, State_of_Load__c from Customer_Quote__c where id =: import_export];
            if(import_export_selected != null && import_export_selected.size()>0)
              {
                  if(import_export_selected[0].Freight_Mode__c == 'Air')
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                  else
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(); 
                  record.Route__c =import_export_selected[0].Route__c;
                //  route_selected_id = import_export_selected[0].Route__c;
                
                  route_selected_Name = import_export_selected[0].Route__r.Name;
                 // route_selected_id2 = import_export_selected[0].Route__c;
                  //record.Route__c = route_selected_id2;     
                  route_selected_Name2 = import_export_selected[0].Route__r.Name;
                  List<id> contenedor_rutas_ids = new List<Id>();
                  routes = new List<SelectOption>();
                  String contenedor_rutas_string = '';
                  if(import_export_selected[0].Route__c != null)
                  {
                        routes.add(new SelectOption(import_export_selected[0].Route__c,import_export_selected[0].Route__r.Name));
                        contenedor_rutas_ids.add(import_export_selected[0].Route__c);
                        contenedor_rutas_string += '\''+import_export_selected[0].Route__c+'\''+',';
                  }
                  
                  //consulta para obtener todas las rutas posibles
                  string query_routes_string = ''; 
                  query_routes_string += 'select Id, Name, Country_of_Discharge__c, Country_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c,';
                  query_routes_string += '  State_of_Load__c, State_of_Discharge__c';
                  query_routes_string += '  from Carrier_Line_Load_Point__c ';
                  query_routes_string += 'where (Country_of_Discharge__c = '+(import_export_selected[0].Country_ofDischarge__c != null ? '\''+import_export_selected[0].Country_ofDischarge__c+'\'': null )+' or Country_of_Discharge__c = null or (Country_of_Discharge__c = '+(import_export_selected[0].Country_ofLoad__c != null ? '\''+import_export_selected[0].Country_ofLoad__c+'\'': null )+' and Country_of_Load__c = null))';
                  query_routes_string += ' and (Country_of_Load__c =  '+(import_export_selected[0].Country_ofLoad__c != null ? '\''+import_export_selected[0].Country_ofLoad__c+'\'': null )+' or Country_of_Load__c = null or (Country_of_Load__c = '+(import_export_selected[0].Country_ofDischarge__c != null ? '\''+import_export_selected[0].Country_ofDischarge__c+'\'': null )+' and Country_of_Discharge__c = null))';
                  query_routes_string += ' and (State_of_Load__c =  '+(import_export_selected[0].State_of_Load__c != null ? '\''+import_export_selected[0].State_of_Load__c+'\'': null )+' or State_of_Load__c = null or (State_of_Load__c = '+(import_export_selected[0].State_of_Discharge__c != null ? '\''+import_export_selected[0].State_of_Discharge__c+'\'': null )+' and State_of_Discharge__c = null))';
                  query_routes_string += ' and (State_of_Discharge__c =  '+(import_export_selected[0].State_of_Discharge__c != null ? '\''+import_export_selected[0].State_of_Discharge__c+'\'': null )+' or State_of_Discharge__c = null or (State_of_Discharge__c = '+(import_export_selected[0].State_of_Load__c != null ? '\''+import_export_selected[0].State_of_Load__c+'\'': null )+' and State_of_Load__c = null))';
                  if(import_export_selected[0].Site_of_Discharge__c != null)
                    query_routes_string += ' and (Port_Airport_of_Discharge__c = '+(import_export_selected[0].Site_of_Discharge__c != null ? '\''+import_export_selected[0].Site_of_Discharge__c+'\'': null )+' or Port_Airport_of_Discharge__c = null or (Port_Airport_of_Discharge__c = '+(import_export_selected[0].Site_of_Load__c != null ? '\''+import_export_selected[0].Site_of_Load__c+'\'': null )+' and Port_Airport_of_Load__c = null))';
                  if(import_export_selected[0].Site_of_Load__c != null)
                    query_routes_string += ' and (Port_Airport_of_Load__c = '+(import_export_selected[0].Site_of_Load__c != null ? '\''+import_export_selected[0].Site_of_Load__c+'\'': null )+' or Port_Airport_of_Load__c = null or (Port_Airport_of_Load__c = '+(import_export_selected[0].Site_of_Discharge__c != null ? '\''+import_export_selected[0].Site_of_Discharge__c+'\'': null )+' and Port_Airport_of_Discharge__c = null))';
                  if(contenedor_rutas_string != '' && contenedor_rutas_string != null)
                    query_routes_string  +=' and Id not IN ('+contenedor_rutas_string.subString(0,contenedor_rutas_string.length()-1)+')'; 
                
                  List<Carrier_Line_Load_Point__c> listado_routes = Database.query(query_routes_string);
                  
                  for(Carrier_Line_Load_Point__c cllp : listado_routes)
                  {
                    routes.add(new SelectOption(cllp.Id,cllp.Name));
                  }
                     
                  if(import_export_selected[0].Container_Count__c != null)
                      numero_contenedores =string.valueof(import_export_selected[0].Container_Count__c);
                  if(import_export_selected[0].Move_Type__c != null)
                      shipment_move_type =string.valueof(import_export_selected[0].Move_Type__c);    
                  if(import_export_selected[0].Service_Type__c!= null)
                      shipment_service_type =string.valueof(import_export_selected[0].Service_Type__c);  
                  if(import_export_selected[0].Freight_Mode__c == 'Air')
                    record.Fee_Category__c = 'Air Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Sea')
                    record.Fee_Category__c = 'Sea Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Road')
                    record.Fee_Category__c = 'Road Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Rail')
                    record.Fee_Category__c = 'Railway Freights';
                  record.Name = '';
                 
                  record.Fee_Description__c ='Quote for '+(import_export_selected[0].Nature_Merchandise__c != null ? import_export_selected[0].Nature_Merchandise__c : import_export_selected[0].Name)+' Total Weight (Kg) '+ import_export_selected[0].Total_Weight_Kg2__c +' Total Volume (m3) '+import_export_selected[0].Total_Volume_m3_2__c;
                  record.Account_for__c =import_export_selected[0].Account_for__c;
                  if(myid != '' && myid != null)
                    record.Carrier_Account__c =myid;
                  record.Container_Type__c = import_export_selected[0].Container_Type__c;
                  record.Active__c = true;
                  record.Import_Export_Quoted_Marketplace__c = import_export; 
                  if(import_export_selected[0].Rate_Type__c == null && record.Rate_Type__c != null)
                    import_export_selected[0].Rate_Type__c = record.Rate_Type__c;
                  record.Rate_Type__c = import_export_selected[0].Rate_Type__c;
                  ruta_id = import_export_selected[0].Route__c;
                  record2 = record;
              }
        }
        else if(ship_program != null && ship_program != '')
        {
              ship_prog_selected = [select Id, Name, Freight_Mode__c, Type__c, Route__c, Route__r.Name, 
              Route__r.Port_Airport_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Country_of_Discharge__c,
              Number_of_Containers__c, Route__r.Port_Airport_of_Load__c,
              Total_Gross_Weight_Kg__c, Total_Gross_Volume_m3__c, Route__r.Port_Airport_of_Load__r.Name, Route__r.Port_Airport_of_Discharge__r.Name, Pallet_Container_Type__r.Container_Type__c, Pallet_Container_Type__r.Container_Type__r.Name,
              Route__r.State_of_Load__c, Route__r.State_of_Discharge__c
              from Shipment_Program__c where id =: ship_program];
            
               
              if(ship_prog_selected != null && ship_prog_selected.size()>0)
              {
                if(ship_prog_selected[0].Freight_Mode__c == 'Air')
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                else
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                    
                record.Route__c =ship_prog_selected[0].Route__c;
                route_selected_id = ship_prog_selected[0].Route__c;
                  
                route_selected_Name = ship_prog_selected[0].Route__r.Name;
                
                route_selected_id2 = ship_prog_selected[0].Route__c;   
                  
                 route_selected_Name2 = ship_prog_selected[0].Route__r.Name;
                 record.Route__c = route_selected_id2;  
                 
                 List<id> contenedor_rutas_ids = new List<Id>();
                 routes = new List<SelectOption>();
                 if(ship_prog_selected[0].Route__c != null)
                 {
                      routes.add(new SelectOption(ship_prog_selected[0].Route__c,ship_prog_selected[0].Route__r.Name));
                      contenedor_rutas_ids.add(ship_prog_selected[0].Route__c);
                 }
                  
                  List<Carrier_Line_Load_Point__c> listado_routes = [select Id, Name, Country_of_Discharge__c, Country_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c,
                  State_of_Discharge__c, State_of_Load__c
                  from Carrier_Line_Load_Point__c where (Country_of_Discharge__c =: ship_prog_selected[0].Route__r.Country_of_Discharge__c or Country_of_Discharge__c =: null)
                  and (Country_of_Load__c =: ship_prog_selected[0].Route__r.Country_of_Load__c or Country_of_Load__c =:null)
                  and (State_of_Load__c =: ship_prog_selected[0].Route__r.State_of_Load__c or State_of_Load__c =:null)
                  and (State_of_Discharge__c =: ship_prog_selected[0].Route__r.State_of_Discharge__c or State_of_Discharge__c =:null)
                  and (Port_Airport_of_Discharge__c =: ship_prog_selected[0].Route__r.Port_Airport_of_Discharge__c or Port_Airport_of_Discharge__c =:null)
                  and (Port_Airport_of_Load__c =: ship_prog_selected[0].Route__r.Port_Airport_of_Load__c or Port_Airport_of_Load__c =: null)
                  and Id not IN: contenedor_rutas_ids];
                  for(Carrier_Line_Load_Point__c cllp : listado_routes)
                  { 
                    routes.add(new SelectOption(cllp.Id,cllp.Name));
                  } 
                      
                  if(ship_prog_selected[0].Number_of_Containers__c != null)
                      numero_contenedores =string.valueof(ship_prog_selected[0].Number_of_Containers__c);
                  if(ship_prog_selected[0].Type__c != null) 
                      shipment_move_type =string.valueof(ship_prog_selected[0].Type__c);    
                      
                  if(ship_prog_selected[0].Freight_Mode__c == 'Air')
                    record.Fee_Category__c = 'Air Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Sea')
                    record.Fee_Category__c = 'Sea Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Road')
                    record.Fee_Category__c = 'Road Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Rail')
                    record.Fee_Category__c = 'Railway Freights';
                  record.Name = '';  
                  
                    
                  record.Fee_Description__c ='Quote for '+ship_prog_selected[0].Name+' Total Weight (Kg) '+ ship_prog_selected[0].Total_Gross_Weight_Kg__c  +' Total Volume (m3) '+ship_prog_selected[0].Total_Gross_Volume_m3__c;
                  if(myid != '' && myid != null)
                    record.Carrier_Account__c =myid;
                  record.Container_Type__c = ship_prog_selected[0].Pallet_Container_Type__r.Container_Type__c; 
                  record.Active__c = true;
                
                  ruta_id = ship_prog_selected[0].Route__c;
                  record2 = record;
             }
        } 
        else if(Route != null && Route != '')
        {
          route_selected = [select Id, Name, Port_Airport_of_Load__r.Name, Port_Airport_of_Discharge__r.Name,  Active_Rates__c, Min_Rate__c  from Carrier_Line_Load_Point__c where id =: Route];
          if(route_selected != null && route_selected.size()>0) 
          {
            
              record.Route__c =route_selected[0].Id;
              
              route_selected_id = route_selected[0].Id;
                
              route_selected_Name = record.Route__r.Name;
              route_selected_id2 = route_selected[0].Id;
              route_selected_Name2 = record.Route__r.Name;
              record.Route__c = route_selected_id2; 
              routes = new List<SelectOption>();
              if(route_selected[0].Id != null)
              {
                    routes.add(new SelectOption(route_selected[0].Id,route_selected[0].Name));
              }
              
              record.Name = '';
             
              record.Fee_Description__c ='Quote for '+route_selected[0].Name+' ';
              if(myid != '' && myid != null)
                record.Carrier_Account__c =myid;
              record.Active__c = true;
              ruta_id = route_selected[0].Id;
              record2 = record;
          }
        }
        else
        {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The shipment is not correct. Please try again'));
        }
        
        currency_selected = '';
        currencys = new List<SelectOption>(); 
        if(UserInfo.isMultiCurrencyOrganization()== true)
        {
           for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
             {
                  currencys.add(new SelectOption(lu,lu)); 
             }
        }
        else
          currencys.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
        currency_selected = UserInfo.getDefaultCurrency();
    }
    
    public void check_fee()
    {
        carrier_id = '';
        carrier_Name = '';
     // if(record.Carrier_Account__c != null)
     // {
        list<Account> query_accounts = [select Id, Name from Account where id=: record.Carrier_Account__c];
        if(query_accounts.size()>0)
        {
            carrier_Name = query_accounts[0].Name;
            
        }
        id_fee_selected = null;
        name_fee_selected = null;
        listado_fees_carrier = null; 
        carrier_id = record.Carrier_Account__c;
        record.Buy_Rate__c = null;
        record.Fee_Rate__c = null;
        record.TT_Days__c = null;
        record.Cost_Concept_1__c = null;
        record.Concept_1__c = null;
        record.Concept_2__c = null;
        record.Concept_3__c = null;
        record.Concept_4__c = null;
        record.Concept_5__c = null; 
        record.Cost_Concept_2__c = null;
        record.Cost_Concept_3__c = null;
        record.Cost_Concept_4__c = null;
        tiene_costes_adicionales = false;
        record.Cost_Concept_5__c = null;
        record.Valid_Until__c = null;
        es_fee_modificado = false;
        listado_rate_type = null;
        //List<Fee__c> listado_de_fees_shipment = [select Id, Name, Carrier_Account__c, Shipment_Quoted_Marketplace__r.N_Containers__c, Shipment_Quoted_Marketplace__r.Service_Type__c, Shipment_Quoted_Marketplace__r.Move_Type__c, Fee_Rate__c, Rate_Type__c, Valid_Until__c ,TT_Days__c , Buy_Rate__c , Shipment_Quoted_Marketplace__c,Active__c, Container_Type__c, Account_for__c, Fee_Description__c, Fee_Category__c, Route__c, RecordTypeId  from Fee__c where Shipment_Quoted_Marketplace__c =:record.Shipment_Quoted_Marketplace__c and Active__c = true and (Valid_Until__c > TODAY or Valid_Until__c =: null) and Route__c =: record.Route__c and Rate_Type__c =: record.Rate_Type__c and Carrier_Account__c =: record.Carrier_Account__c];
        /*List<Fee__c> listado_de_fees_shipment = [select Id, Name, Carrier_Account__c, Route__r.Name, Shipment_Quoted_Marketplace__r.N_Containers__c, Shipment_Quoted_Marketplace__r.Service_Type__c, Shipment_Quoted_Marketplace__r.Move_Type__c, Fee_Rate__c, Rate_Type__c, Valid_Until__c ,TT_Days__c , Buy_Rate__c , Shipment_Quoted_Marketplace__c,Active__c, Container_Type__c, Account_for__c, Fee_Description__c, Fee_Category__c, Route__c, RecordTypeId  from Fee__c where Active__c = true and Route__c =: record.Route__c  and Carrier_Account__c =: record.Carrier_Account__c];//and (Valid_Until__c > TODAY or Valid_Until__c =: null)  and Shipment_Quoted_Marketplace__c =:record.Shipment_Quoted_Marketplace__c and  and Rate_Type__c =: record.Rate_Type__c
        
        if(listado_de_fees_shipment != null && listado_de_fees_shipment.size()>0)
        {
            //----------------------- 
            //----------------------------
            record = new Fee__c();
            record.Route__c =
            record.Carrier_Account__c =
            record.Account_for__c =
            record.Fee_Category__c =
            currency_selected = NEU_CurrencyUtils.getCurrencyIsoCode(listado_de_fees_shipment[0]);
          if(listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__c != null && listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__r.N_Containers__c != null)
                  numero_contenedores =string.valueof(listado_de_fees_shipment[0].Shipment_Quoted_Marketplace__r.N_Containers__c);
          
            if(listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__r.Move_Type__c != null && listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__c != null )
                  shipment_move_type =string.valueof(listado_de_fees_shipment[0].Shipment_Quoted_Marketplace__r.Move_Type__c);  
            
            if(listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__r.Service_Type__c != null && listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__c != null )
                  shipment_service_type =string.valueof(listado_de_fees_shipment[0].Shipment_Quoted_Marketplace__r.Service_Type__c);*/
            //-----------------------------
            //--------------------------------
            
          /*if(listado_de_fees_shipment[0].Rate_Type__c == null && record.Rate_Type__c != null)
            listado_de_fees_shipment[0].Rate_Type__c = record.Rate_Type__c;
          record = listado_de_fees_shipment[0];
          record2 = record;
          currency_selected = NEU_CurrencyUtils.getCurrencyIsoCode(listado_de_fees_shipment[0]);
          if(listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__c != null && listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__r.N_Containers__c != null)
                  numero_contenedores =string.valueof(listado_de_fees_shipment[0].Shipment_Quoted_Marketplace__r.N_Containers__c);
          
            if(listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__r.Move_Type__c != null && listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__c != null )
                  shipment_move_type =string.valueof(listado_de_fees_shipment[0].Shipment_Quoted_Marketplace__r.Move_Type__c);  
            
            if(listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__r.Service_Type__c != null && listado_de_fees_shipment [0].Shipment_Quoted_Marketplace__c != null )
                  shipment_service_type =string.valueof(listado_de_fees_shipment[0].Shipment_Quoted_Marketplace__r.Service_Type__c);       */
       // }
       // else
       // {
           
          if(shipment_selected != null && shipment_selected.size()>0)
            {
              if(shipment_selected[0].Freight_Mode__c == 'Air')
                record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
              else
                record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
              
               record.Route__c =route_selected_id;
               
              
               List<Carrier_Line_Load_Point__c> route = [select Id, Name, Active_Rates__c, Min_Rate__c, Port_Airport_of_Load__c,Port_Airport_of_Load__r.Name, Port_Airport_of_Discharge__r.Name, Port_Airport_of_Discharge__c from Carrier_Line_Load_Point__c where Id =: route_selected_id];
               if(route.size() > 0)
               {
                route_selected_Name = route[0].Name;
                route_selected_id2 = route[0].Id;
                route_selected_Name2 = route[0].Name;
               }
               
               if(shipment_selected[0].N_Containers__c != null)
                  numero_contenedores =string.valueof(shipment_selected[0].N_Containers__c);
               if(shipment_selected[0].Move_Type__c != null)
                  shipment_move_type =string.valueof(shipment_selected[0].Move_Type__c);  
               if(shipment_selected[0].Service_Type__c!= null)
                  shipment_service_type =string.valueof(shipment_selected[0].Service_Type__c);  
              if(shipment_selected[0].Freight_Mode__c == 'Air')
                record.Fee_Category__c = 'Air Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Sea')
                record.Fee_Category__c = 'Sea Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Road')
                record.Fee_Category__c = 'Road Freights';
              else if(shipment_selected[0].Freight_Mode__c == 'Rail')
                record.Fee_Category__c = 'Railway Freights';
              record.Name = '';
              string nombre_new_fee = '';
              if(route != null && route.size()>0)
                nombre_new_fee = route[0].Port_Airport_of_Load__r.Name +'-'+ route[0].Port_Airport_of_Discharge__r.Name +(shipment_selected[0].Container_Type__c != null ? ' - ' + shipment_selected[0].Container_Type__r.Name : '');
              else
                nombre_new_fee = shipment_selected[0].Route__r.Port_Airport_of_Load__r.Name +'-'+ shipment_selected[0].Route__r.Port_Airport_of_Discharge__r.Name +(shipment_selected[0].Container_Type__c != null ? ' - ' + shipment_selected[0].Container_Type__r.Name : '');
             
              record.Fee_Description__c ='Quote for '+(shipment_selected[0].Nature_Merchandise__c != null ? shipment_selected[0].Nature_Merchandise__c : shipment_selected[0].Name)+' Total Weight (Kg) '+ shipment_selected[0].Total_Weight_Kg__c.setScale(2) +' Total Volume (m3) '+shipment_selected[0].Total_Volume_m3__c.setScale(2);
              record.Account_for__c =shipment_selected[0].Account_for__c;
              if(myid != '' && myid != null)
                record.Carrier_Account__c =myid; 
              record.Container_Type__c = shipment_selected[0].Container_Type__c;
              record.Active__c = true;
              record.Shipment_Quoted_Marketplace__c = shipment;
              if(shipment_selected[0].Rate_Type__c == null && record.Rate_Type__c != null)
                shipment_selected[0].Rate_Type__c = record.Rate_Type__c;
              record.Rate_Type__c = shipment_selected[0].Rate_Type__c;
              record2 = record;
            }
            else if(import_export_selected != null && import_export_selected.size()>0)
            {
                  if(import_export_selected[0].Freight_Mode__c == 'Air')
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                  else
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                  
                  record.Route__c =route_selected_id;
                  
                  List<Carrier_Line_Load_Point__c> route = [select Id, Name, Active_Rates__c,Port_Airport_of_Load__c,Port_Airport_of_Load__r.Name,Port_Airport_of_Discharge__c, Port_Airport_of_Discharge__r.Name, Min_Rate__c from Carrier_Line_Load_Point__c where Id =: route_selected_id];
                  if(route.size() > 0)
                  {
                    route_selected_id2 = route[0].Id;
                    route_selected_Name2 = route[0].Name; 
                  }
                  if(import_export_selected[0].Container_Count__c != null)
                      numero_contenedores =string.valueof(import_export_selected[0].Container_Count__c);
                  if(import_export_selected[0].Move_Type__c != null)
                      shipment_move_type =string.valueof(import_export_selected[0].Move_Type__c);    
                  if(import_export_selected[0].Service_Type__c!= null)
                      shipment_service_type =string.valueof(import_export_selected[0].Service_Type__c);  
                  if(import_export_selected[0].Freight_Mode__c == 'Air')
                    record.Fee_Category__c = 'Air Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Sea')
                    record.Fee_Category__c = 'Sea Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Road')
                    record.Fee_Category__c = 'Road Freights';
                  else if(import_export_selected[0].Freight_Mode__c == 'Rail')
                    record.Fee_Category__c = 'Railway Freights';
                  record.Name = '';
                  string nombre_new_fee = '';
                  if(route != null && route.size()>0)
                    nombre_new_fee = (route[0].Port_Airport_of_Load__c != null ? route[0].Port_Airport_of_Load__r.Name : '') +'-'+ (route[0].Port_Airport_of_Discharge__c != null ? route[0].Port_Airport_of_Discharge__r.Name : '') +(import_export_selected[0].Container_Type__c != null ? ' - ' + import_export_selected[0].Container_Type__r.Name : '');
                  else
                    nombre_new_fee = import_export_selected[0].Route__r.Port_Airport_of_Load__r.Name +'-'+ import_export_selected[0].Route__r.Port_Airport_of_Discharge__r.Name +(import_export_selected[0].Container_Type__c != null ? ' - ' + import_export_selected[0].Container_Type__r.Name : '');
                
                  
                  record.Fee_Description__c ='Quote for '+(import_export_selected[0].Nature_Merchandise__c != null ? import_export_selected[0].Nature_Merchandise__c : import_export_selected[0].Name) +' Total Weight (Kg) '+ import_export_selected[0].Total_Weight_Kg2__c +' Total Volume (m3) '+import_export_selected[0].Total_Volume_m3_2__c;
                  record.Account_for__c =import_export_selected[0].Account_for__c;
                  if(myid != '' && myid != null)
                    record.Carrier_Account__c =myid;
                  record.Container_Type__c = import_export_selected[0].Container_Type__c;
                  record.Active__c = true;
                  record.Import_Export_Quoted_Marketplace__c = import_export; 
                  if(import_export_selected[0].Rate_Type__c == null && record.Rate_Type__c != null)
                    import_export_selected[0].Rate_Type__c = record.Rate_Type__c;
                  record.Rate_Type__c = import_export_selected[0].Rate_Type__c;
                  record2 = record;
              }
              else if(ship_prog_selected != null && ship_prog_selected.size()>0)
              {
                if(ship_prog_selected[0].Freight_Mode__c == 'Air')
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                  else
                    record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                  
                  record.Route__c =route_selected_id;
                  
               
                  List<Carrier_Line_Load_Point__c> route = [select Id, Name, Active_Rates__c,Port_Airport_of_Load__c,Port_Airport_of_Load__r.Name,Port_Airport_of_Discharge__c,
                  Port_Airport_of_Discharge__r.Name, Min_Rate__c from Carrier_Line_Load_Point__c where Id =: route_selected_id];
                  if(route.size() > 0)
                  {
                    route_selected_id2 = route[0].Id;
                    route_selected_Name2 = route[0].Name; 
                  }
                  if(ship_prog_selected[0].Number_of_Containers__c != null)
                      numero_contenedores =string.valueof(ship_prog_selected[0].Number_of_Containers__c);
               
                  if(ship_prog_selected[0].Freight_Mode__c == 'Air')
                    record.Fee_Category__c = 'Air Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Sea')
                    record.Fee_Category__c = 'Sea Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Road')
                    record.Fee_Category__c = 'Road Freights';
                  else if(ship_prog_selected[0].Freight_Mode__c == 'Rail')
                    record.Fee_Category__c = 'Railway Freights';
                  record.Name = '';
                  string nombre_new_fee = '';
                  
                  if(route != null && route.size()>0)
                    nombre_new_fee = (route[0].Port_Airport_of_Load__c != null ? route[0].Port_Airport_of_Load__r.Name : '') +'-'+ (route[0].Port_Airport_of_Discharge__c != null ? route[0].Port_Airport_of_Discharge__r.Name : '') +(ship_prog_selected[0].Pallet_Container_Type__c != null && ship_prog_selected[0].Pallet_Container_Type__r.Container_Type__c != null ? ' - ' + ship_prog_selected[0].Pallet_Container_Type__r.Container_Type__r.Name : '');
                  else
                    nombre_new_fee = ( ship_prog_selected[0].Route__c != null && ship_prog_selected[0].Route__r.Port_Airport_of_Load__c != null ?  ship_prog_selected[0].Route__r.Port_Airport_of_Load__r.Name :'') +'-'+ (ship_prog_selected[0].Route__c != null && ship_prog_selected[0].Route__r.Port_Airport_of_Discharge__c != null ? ship_prog_selected[0].Route__r.Port_Airport_of_Discharge__r.Name : '') +(ship_prog_selected[0].Pallet_Container_Type__c != null && ship_prog_selected[0].Pallet_Container_Type__r.Container_Type__c != null ? ' - ' + ship_prog_selected[0].Pallet_Container_Type__r.Container_Type__r.Name : '');
                 
                  
                  record.Fee_Description__c ='Quote for '+ship_prog_selected[0].Name+' Total Weight (Kg) '+ ship_prog_selected[0].Total_Gross_Weight_Kg__c  +' Total Volume (m3) '+ship_prog_selected[0].Total_Gross_Volume_m3__c;
                  if(myid != '' && myid != null)
                    record.Carrier_Account__c =myid;
                  if(ship_prog_selected[0].Pallet_Container_Type__c != null)  
                  record.Container_Type__c = ship_prog_selected[0].Pallet_Container_Type__r.Container_Type__c; 
                  record.Active__c = true;
                  record2 = record;
              }
              else if(Route != null && Route != '')
              {
                  record.Route__c =route_selected_id;
                  route_selected_Name = route_selected[0].Name;
                  route_selected_id2 = route_selected_id;
               	  route_selected_Name2 = route_selected[0].Name;
                  record.Name = ''; 
                  string nombre_new_fee = '';  
                  nombre_new_fee = route_selected[0].Port_Airport_of_Load__r.Name +'-'+ route_selected[0].Port_Airport_of_Discharge__r.Name;
                  record.Fee_Description__c ='Quote for '+route_selected[0].Name+' ';
                  
                  if(myid != '' && myid != null)
                    record.Carrier_Account__c =myid; 
                    
                  record.Active__c = true;
                  record2 = record;
                
              }
              record.Rate_Type__c = null;
    }
    
  public void load_fee_select()
  {
      List<Fee__c> listado_de_fees_shipment =Database.query('select Id, Name,'+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Carrier_Account__c,Comments__c,LOT__c,Concept_1__c, Valid_From__c, Rate_Names_List__c, Cost_Concept_1__c,Concept_2__c, Cost_Concept_2__c,Concept_3__c, Cost_Concept_3__c,Concept_4__c, Cost_Concept_4__c,Concept_5__c, Cost_Concept_5__c, Max_Kgs__c , Max_M3__c, Min__c, Volumetric_Factor__c , Route__r.Name, Shipment_Quoted_Marketplace__r.N_Containers__c, Shipment_Quoted_Marketplace__r.Service_Type__c, Shipment_Quoted_Marketplace__r.Move_Type__c, Fee_Rate__c, Rate_Type__c, Valid_Until__c ,TT_Days__c , Buy_Rate__c , Shipment_Quoted_Marketplace__c,Active__c, Container_Type__c, Account_for__c, Fee_Description__c, Fee_Category__c, Route__c,  RecordTypeId  from Fee__c where Id = :id_oi');//Active__c = true and
      
      if(listado_de_fees_shipment.size()>0)
      {
        system.Debug('holaa'+listado_de_fees_shipment[0]);
        if(listado_de_fees_shipment[0].Cost_Concept_1__c != null || listado_de_fees_shipment[0].Cost_Concept_2__c != null || listado_de_fees_shipment[0].Cost_Concept_3__c != null || listado_de_fees_shipment[0].Cost_Concept_4__c != null || listado_de_fees_shipment[0].Cost_Concept_5__c != null)
        {
            listado_de_fees_shipment[0].Buy_Rate__c = null;
            tiene_costes_adicionales = true;
        }

        record = listado_de_fees_shipment[0];
        listado_rate_type = null;
     
            currency_selected =NEU_CurrencyUtils.getCurrencyIsoCode(listado_de_fees_shipment[0]);
        rate_type_mod = listado_de_fees_shipment[0].Rate_Type__c;
        id_fee_selected = id_oi;
        es_fee_modificado = true;
        name_fee_selected = listado_de_fees_shipment[0].Name;
        if(listado_de_fees_shipment[0].Route__c != null)
            route_selected_Name2 = listado_de_fees_shipment[0].Route__r.Name;
        route_selected_id2 = listado_de_fees_shipment[0].Route__c;
        
      }
  }
  
    public Integer update_Ranking()
    {
      integer resultado_carrier_actual = 0;//---- se pueden juntar todos en uno 
        if(record.id != null && shipment != null  && shipment != '' && shipment_selected != null && shipment_selected.size()>0)
        {
          Integer Res=1;
          resultado_carrier_actual = 1;

          //List<Fee__c> listado_de_fees_shipment = [select Id, Name,Fee_Rate__c, Carrier_Account__c from Fee__c where Shipment_Quoted_Marketplace__c =:shipment and Active__c = true and (Valid_Until__c > TODAY or Valid_Until__c =: null) and Route__c =: shipment_selected[0].Route__c and Rate_Type__c =: shipment_selected[0].Rate_Type__c order by Buy_Rate__c asc nulls last];
          List<Fee__c> listado_de_fees_shipment = [select Id, Name,Fee_Rate__c, Carrier_Account__c from Fee__c where Active__c = true  and Route__c =: route_selected_id2 and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];//and (Valid_Until__c > TODAY or Valid_Until__c =: null)
       
          for(Fee__c fee: listado_de_fees_shipment)
          {
            if(record.Id != null)
              if(fee.Id==record.Id)
              {
                      resultado_carrier_actual =Res;
                      break;
              }
          
            
                Res++;
          }
        }
        else if(record.id != null && import_export != null  && import_export != '' && import_export_selected != null && import_export_selected.size()>0)
        {
          Integer Res=1;
          resultado_carrier_actual = 1;

          //List<Fee__c> listado_de_fees_shipment = [select Id, Name,Fee_Rate__c, Carrier_Account__c from Fee__c where Shipment_Quoted_Marketplace__c =:shipment and Active__c = true and (Valid_Until__c > TODAY or Valid_Until__c =: null) and Route__c =: shipment_selected[0].Route__c and Rate_Type__c =: shipment_selected[0].Rate_Type__c order by Buy_Rate__c asc nulls last];
          List<Fee__c> listado_de_fees_shipment = [select Id, Name,Fee_Rate__c, Carrier_Account__c from Fee__c where Active__c = true and Route__c =: route_selected_id2 and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];//and (Valid_Until__c > TODAY or Valid_Until__c =: null)
       
          for(Fee__c fee: listado_de_fees_shipment)
          {
            system.debug('holaaa'+fee.Name+'carrker'+fee.Carrier_Account__c);
            if(record.Id != null)
              if(fee.Id==record.Id)
              {
                    system.debug('holaaaeste'+fee.Name+'carrker'+fee.Carrier_Account__c);
                      resultado_carrier_actual =Res;
                      break;
              }
          
            
                Res++;
          }
        }
        else if(record.id != null && ship_program != null  && ship_program != '' && ship_prog_selected  != null && ship_prog_selected.size()>0)
        {
          Integer Res=1;
          resultado_carrier_actual = 1;

          List<Fee__c> listado_de_fees_shipment = [select Id, Name,
          Fee_Rate__c, Carrier_Account__c from Fee__c where Active__c = true and Route__c =: route_selected_id2 
          and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];
       
          for(Fee__c fee: listado_de_fees_shipment)
          {
            if(record.Id != null)
              if(fee.Id==record.Id)
              {
                      resultado_carrier_actual =Res;
                      break;
              }
          
            
                Res++;
          }
        }
        else if(record.id != null && Route != null  && Route != '' && route_selected != null && route_selected.size()>0)
        {
          Integer Res=1;
          resultado_carrier_actual = 1;

          //List<Fee__c> listado_de_fees_shipment = [select Id, Name,Fee_Rate__c, Carrier_Account__c from Fee__c where Shipment_Quoted_Marketplace__c =:shipment and Active__c = true and (Valid_Until__c > TODAY or Valid_Until__c =: null) and Route__c =: shipment_selected[0].Route__c and Rate_Type__c =: shipment_selected[0].Rate_Type__c order by Buy_Rate__c asc nulls last];
          List<Fee__c> listado_de_fees_shipment = [select Id, Name,Fee_Rate__c, Carrier_Account__c from Fee__c where Active__c = true  and Route__c =: route_selected_id2 and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];//and (Valid_Until__c > TODAY or Valid_Until__c =: null)
          
          for(Fee__c fee: listado_de_fees_shipment)
          {
            if(record.Id != null)
              if(fee.Id==record.Id)
              {
                      resultado_carrier_actual =Res;
                      break;
              }
            
                Res++;
          }
        }
        return resultado_carrier_actual;
        //return 0;
    }
    
    //------------------------
    public void update_ranking_send_email()
    {
        if(record.id != null && ((shipment != null  && shipment != '' && shipment_selected != null && shipment_selected.size()>0) || (import_export != null  && import_export != '' && import_export_selected != null && import_export_selected.size()>0) ||(Route != null  && Route != '' && route_selected != null && route_selected.size()>0) || (ship_program != null  && ship_program != '' && ship_prog_selected  != null && ship_prog_selected.size()>0)))
        {
          Integer Res=1;
          set<Id> ids_to_send_email = new set<Id>();
          List<Fee__c> listado_de_fees_shipment = null;
          //---------pueden que sobren todso estos if
          if(shipment != null  && shipment != '' && shipment_selected != null && shipment_selected.size()>0)
            listado_de_fees_shipment = [select Id, Name, Carrier_Account__c,Fee_Rate__c, Marketplace_Ranking__c from Fee__c where Active__c = true  and Route__c =: route_selected_id2 and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];//and (Valid_Until__c > TODAY or Valid_Until__c =: null) Shipment_Quoted_Marketplace__c =:shipment and
          else if (import_export != null  && import_export != '' && import_export_selected != null && import_export_selected.size()>0)
            listado_de_fees_shipment = [select Id, Name, Carrier_Account__c,Fee_Rate__c, Marketplace_Ranking__c from Fee__c where Active__c = true  and Route__c =: route_selected_id2 and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];//and (Valid_Until__c > TODAY or Valid_Until__c =: null) Import_Export_Quoted_Marketplace__c =:import_export_selected and 
          else if(ship_program != null && ship_program != '' && ship_prog_selected != null && ship_prog_selected.size()>0)
            listado_de_fees_shipment = [select Id, Name, Carrier_Account__c,Fee_Rate__c, Marketplace_Ranking__c from Fee__c where Active__c = true  and Route__c =: route_selected_id2 and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];//and (Valid_Until__c > TODAY or Valid_Until__c =: null) Import_Export_Quoted_Marketplace__c =:import_export_selected and
          else if(Route != null  && Route != '' && route_selected != null && route_selected.size()>0)
            listado_de_fees_shipment = [select Id, Name, Carrier_Account__c,Fee_Rate__c, Marketplace_Ranking__c from Fee__c where Active__c = true  and Route__c =: route_selected_id2 and Rate_Type__c =: record.Rate_Type__c and Fee_Category__c =: record.Fee_Category__c order by Buy_Rate__c asc nulls last];//and (Valid_Until__c > TODAY or Valid_Until__c =: null) Shipment_Quoted_Marketplace__c =:shipment and
          
          for(Fee__c fee: listado_de_fees_shipment) 
          {
            if(fee.Id==record.Id)
            {
                    fee.Marketplace_Ranking__c = Res;
                    if(fee.Carrier_Account__c != null)
                        ids_to_send_email.add(fee.Carrier_Account__c);
            }
            if(Res != fee.Marketplace_Ranking__c)
            {
              fee.Marketplace_Ranking__c = Res;
              if(fee.Carrier_Account__c != null)
                ids_to_send_email.add(fee.Carrier_Account__c);
            }
            
                Res++;
          }
          
          if(listado_de_fees_shipment != null && listado_de_fees_shipment.size()>0)
            update listado_de_fees_shipment;
          
          //envio de emails
          if(ids_to_send_email != null && ids_to_send_email.size()>0)
          {
            //----------------
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
              defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Guest_Carrier';
            else
              defaultUrl+='/NEU_Guest_Carrier';
            
            
            //---------------------------
            string url_externa = (shipment_selected != null && shipment_selected.size()> 0 ? defaultUrl+'?shipment='+shipment: (import_export_selected != null && import_export_selected.size()> 0 ? defaultUrl+'?import_export='+import_export :  (route_selected != null && route_selected.size()> 0 ? defaultUrl+'?route='+Route : defaultUrl) )); 
            string url_formulario = '';
              url_formulario = '<br/>Please click on the link below if you want to give us a better Freight Rate : <a href="'+url_externa+'" target="_blank">'+url_externa+'</a>';
            string emailbody = 'This e-mail is to inform you, we just get a better freight rate for our ';//----mod esto
            
            List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
            List<Contact> listado_contactos_envio_email = [select Id, Name, AccountId, Email, Other_Email__c , Secret__c, Other_Secret__c from Contact where AccountId IN:ids_to_send_email and (Email !=: null or Other_Email__c !=:null) and (Secret__c !=: null or Other_Secret__c !=:null)];
            
            if(shipment_selected != null && shipment_selected.size()> 0)
                emailbody += ' Shipments in Route '+(shipment_selected.size()> 0 ? shipment_selected[0].Route__r.Name : '');
            else if(import_export_selected != null && import_export_selected.size()> 0)
                emailbody += ' Shipments in Route '+(import_export_selected.size()> 0 ? import_export_selected[0].Route__r.Name : '');
            else if(route_selected != null && route_selected.size()> 0)
                emailbody += ' Shipments in Route '+(route_selected.size()> 0 ? route_selected[0].Name : '');
                
            
            emailbody += ' <br /> Thanks for your interest in our business.';   
            for(Contact con: listado_contactos_envio_email)
            {
                    //ENVÍO EMAIL A CADA CARRIER POR SEPARADO
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{};
                    toAddresses.add(con.Email);
                    if(String.IsNotEmpty(con.Other_Email__c))
                        toAddresses.add(con.Other_Email__c);
                      mail.setToAddresses(toAddresses);
                      if(shipment_selected != null && shipment_selected.size()> 0)
                      {
                        mail.setSubject('Update about the Freight Rate you give us for Route '+(shipment_selected.size()> 0 ? shipment_selected[0].Route__r.Name : ''));//---mod subject
                        
                      } 
                      else if(ship_prog_selected != null && ship_prog_selected.size()>0)
                      {
                        mail.setSubject('Update about the Freight Rate you give us for Route '+(ship_prog_selected.size()> 0 ? ship_prog_selected[0].Route__r.Name : '')); 
                      }
                      else if(route_selected != null && route_selected.size()> 0)
                      {
                        mail.setSubject('Update about the Freight Rate you give us for Route '+(route_selected.size()> 0 ? route_selected[0].Name : ''));//---mod subject
                      }
                      else
                      {
                        mail.setSubject('Update about the Freight Rate you give us for Route '+(import_export_selected.size()> 0 ? import_export_selected[0].Route__r.Name : ''));

                      }//------------si esta activado el site externo descomentar url form
                      mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head></head><body style="font-family:Arial; font-size:14px;">'+emailbody.replace('\n','<br/>') +'<br/>' +url_formulario +'</body></html>');// url_formulario +
                      mail.setCharset('UTF-8');
                      theEmails.add(mail);
            } 
          //---de momento no envia correos activar luego
          /*  try 
              {
                  List<Messaging.Email> allMails = new List<Messaging.Email>();
                  for(Integer j = 0; j < theEmails.size(); j++)
                  {
                      allMails.add(theEmails.get(j));
                  }
                   Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(allMails);
                   if(resultMail.size()>0)
                      if(resultMail[0].isSuccess())
                      {    
                          //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Email sent successfully.'));
                      }
                      else 
                      {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending email.'));
                       // return null;
                      }
              }
              catch(System.EmailException ex)
              {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending email.'));
               //   return null;
              }*/
          } 
          
          
        }
    }
    //------------------------------
    public void send_form2()
    {
       result=0;
       try
       {
          NEU_CurrencyUtils.setCurrencyIsoCode(record,currency_selected);
          if(record.Id != null)
          {
            Fee__c my_new_fee = record.clone(false,true);
            insert my_new_fee;
            record = my_new_fee;
            id_fee_selected = record.Id;
            name_fee_selected = record.Name;
            valor_buy_rate = record.Buy_Rate__c;
          }
         es_fee_modificado = true;
         acabo_de_guardar = true;
         if(record.Active__c == true && record.Buy_Rate__c != null && record.Buy_Rate__c != 0)
         {
            getranking();
            update_ranking_send_email();
         }
         List<Carrier_Line_Load_Point__c> route = [select Id, Name, Active_Rates__c, Min_Rate__c from Carrier_Line_Load_Point__c where Id =: route_selected_id2];
         if(route.size() > 0) 
         {
            route_selected_Name = route[0].Name;
            route_selected_id2 = route[0].Id;
            route_selected_Name2 = route[0].Name; 
         }
         listado_fees_carrier = null;
         //listado_rate_type = null;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your Service Rate is registered in our system.'));
         id_oi = record.Id;
       }
       catch(Exception ex)
       {
         result=0;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex.getMessage()));
          return;
       }
   }
    //-----------------------------------
    //------------------------------
    public void send_form()
    {
       result=0;
       try
       {
          NEU_CurrencyUtils.setCurrencyIsoCode(record,currency_selected);
         if(record.Id != null)
         {
            /*if(record2.Rate_Type__c != record.Rate_Type__c)//----nuevo
            {
                 Fee__c newrecord=record.clone(false,true);
                 newrecord.Rate_Type__c = record.Rate_Type__c;//------ revisar esto
                 insert newrecord;
                 record = newrecord;
            }   
            else*/
           // record.Name = record.Rate_Names_List__c;
            id_fee_selected = record.Id;
            name_fee_selected = record.Name;
            valor_buy_rate = record.Buy_Rate__c;
             List<Fee__c> listado_de_fees_shipment = [select Id, Name, LOT__c, Comments__c, Buy_Rate__c, Rate_Type__c  from Fee__c where Id =:record.Id];
            if(listado_de_fees_shipment.size()>0 && record.Rate_Type__c == listado_de_fees_shipment[0].Rate_Type__c)
                update record;
            else
            {
                if(listado_de_fees_shipment.size()>0 && record.Rate_Type__c != listado_de_fees_shipment[0].Rate_Type__c)
                {
                    Fee__c newrecord=record.clone(false,true);
                    newrecord.Rate_Type__c = record.Rate_Type__c;
                    string nombre_introducido =  record.Name;
                    insert newrecord;
                    
                    if(nombre_introducido != null && nombre_introducido != '')
                    {
                        record.Name = nombre_introducido;
                        record.Rate_Type__c = listado_de_fees_shipment[0].Rate_Type__c;
                        record.Buy_Rate__c = listado_de_fees_shipment[0].Buy_Rate__c;
                        update record;
                    }
                    id_fee_selected = newrecord.Id;
                    name_fee_selected = newrecord.Name;
                    record = newrecord;
                }
            }
         }
         else
         {
           //record.Name = record.Rate_Names_List__c; 
           string nombre_introducido =  record.Name;
           valor_buy_rate = record.Buy_Rate__c;
           if(route_selected_id2 != null && route_selected_id2 != '')
            record.Route__c = route_selected_id2;
           if(((Route != null && Route != '')|| (ship_program != null && ship_program != '')) && record.Account_for__c == null)
            record.Account_for__c = record.Account_for_API__c;
           insert record;
           if(nombre_introducido != null && nombre_introducido != '')
           {
                record.Name = nombre_introducido;
                update record;
           }
           id_fee_selected = record.Id;
           name_fee_selected = record.Name;
         }
         es_fee_modificado = true;
         acabo_de_guardar = true;
         if(record.Active__c == true && record.Buy_Rate__c != null && record.Buy_Rate__c != 0)
         {
            getranking();
            update_ranking_send_email();
         }
         List<Carrier_Line_Load_Point__c> route = [select Id, Name, Active_Rates__c, Min_Rate__c from Carrier_Line_Load_Point__c where Id =: route_selected_id2];
         if(route.size() > 0) 
         {
            route_selected_Name = route[0].Name;
            route_selected_id2 = route[0].Id;
            route_selected_Name2 = route[0].Name; 
         }
         listado_fees_carrier = null;
         //listado_rate_type = null;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your Service Rate is registered in our system.'));
         id_oi = record.Id;
       }
       catch(Exception ex)
       {
         result=0;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex.getMessage()));
          return;
       }
   }
}