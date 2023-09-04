public with sharing class NEU_Allocate_Costs_to_Ship_Service_Lines 
{
    public Shipment_Program__c record=null;
    public Shipment_Program__c totales{get;set;}
    public Boolean chekeados{get;set;}
    public Boolean chekeados2{get;set;}
    private List<Shipment_Program_Line_s> shipfeeLines =null;
    private List<Shipment_Program_Line_s> shipfeeLines_all_categories =null;
   // private List<Shipment_Fee_Line__c> shipfeeLines_all =null;
    public  List<Ship_fee_lines_import_export_s> List_Fee_Shipment_Import_Export = null; 
    public Shipment__c shipment_filter = null;
    public String id_oi {get;set;}
    public String id_ship_fee_line {get;set;}
    public  List<Ship_Prog_Fee_Line_s> Fee_List_Price = null;
    public  List<Ship_Prog_Fee_Line_s> Fee_List_Price2 = null;
    public Map<Id,Id> listado_ids_ruta {get;set;}
    public String orden_fees_filtro_modo {get;set;}
    public String orden_fees_filtro {get;set;}
    public String orden_fees_filtro_modo_insertados {get;set;}
    public String orden_fees_filtro_insertados {get;set;}
    public String orden_fees_filtro_modo_insertados_all {get;set;}
    public String orden_fees_filtro_insertados_all {get;set;}
    public string listado_ids_carrier {get;set;}
    public string url_sailing_schedule {get;set;}
    public string error_ruta {get;set;}
    private List<SelectOption> newcategories=null;
    public string total_cost_category {get;set;}
    public decimal total_cost_category_decimal {get;set;}
    public string total_cost_category_m3 {get;set;}
    public string total_cost_category_kg {get;set;}
    
     //new service rate
    public Fee__c fee_record {get;set;}
    public Boolean show_all_categories{get;set;}  
    public Boolean show_all_categories_all_lines{get;set;}  
    public String fee_currency {get;set;}
    public List<SelectOption> currencies {get;set;}
    
    public totales_s totals_custom{get;set;}
    public class totales_s
    {
        public Shipment_Program__c ship_prog {get;set;}
        public Boolean convert {get;set;}
        public string CurrencyMoney {get;set;}
        public string CurrencyMoney_ship_prog  {get;set;}
        public string total_Services_Std_Buy_Amount_s_currency {get;set;}
        public string total_Services_Std_Buy_Amount_s_convert{get;set;}
        public string total_Services_Sell_Amount_s_currency {get;set;}
        public string total_Services_Sell_Amount_s_convert{get;set;}
        
        public string total_Services_charges_m3_s_currency {get;set;}
        public string total_Services_charges_m3_s_convert{get;set;}
        public string total_Services_charges_kg_s_currency {get;set;}
        public string total_Services_charges_kg_s_convert{get;set;}
        
        public totales_s(Shipment_Program__c ship_prog)
        {
            this.ship_prog = ship_prog;
            convert = false;
            total_Services_Std_Buy_Amount_s_currency = '';
            total_Services_Sell_Amount_s_currency = '';
            total_Services_charges_m3_s_currency = '';
            total_Services_charges_kg_s_currency = '';
            total_Services_Std_Buy_Amount_s_convert = '';
            total_Services_Sell_Amount_s_convert = '';
            total_Services_charges_m3_s_convert = '';
            total_Services_charges_kg_s_convert = '';
            CurrencyMoney = '';
            if (!Test.isRunningTest())
                CurrencyMoney_ship_prog = NEU_CurrencyUtils.getCurrencyIsoCode(ship_prog);
            
            decimal buy_amount_currency = ship_prog.NUM_Total_Services_Std_Buy_Amount__c;
            if(buy_amount_currency != null)
                total_Services_Std_Buy_Amount_s_currency = buy_amount_currency.setScale(2).format();
            
            decimal sell_amount_currency = ship_prog.NUM_Total_Services_Sell_Amount__c;
            if(sell_amount_currency != null)
                total_Services_Sell_Amount_s_currency = sell_amount_currency.setScale(2).format();
                
            decimal charges_m3_currency = ship_prog.Service_Charges_m3__c;
            if(charges_m3_currency != null)
                total_Services_charges_m3_s_currency = charges_m3_currency.setScale(2).format(); 
                
            decimal charges_kg_currency = ship_prog.Service_Charges_Kg__c;
            if(charges_kg_currency != null)
                total_Services_charges_kg_s_currency = charges_kg_currency.setScale(2).format();  
                       
            if(UserInfo.isMultiCurrencyOrganization()== true)   
            {   
                string currency_default = userInfo.getDefaultCurrency();
                if(NEU_CurrencyUtils.getCurrencyIsoCode(ship_prog) != currency_default && (string.isNotEmpty(total_Services_Std_Buy_Amount_s_currency) || string.isNotEmpty(total_Services_Sell_Amount_s_currency)|| string.isNotEmpty(total_Services_charges_m3_s_currency) || string.isNotEmpty(total_Services_charges_kg_s_currency)))
                { 
                    CurrencyMoney = currency_default;  
                    List<SObject>conversion=null;
                    DateTime dtIsoCode = ship_prog.Conversion_Rate_Date__c;
                    String query_currency = '';
                    query_currency += 'select ConversionRate,IsoCode,startDate,nextstartdate ';
                    query_currency += ' FROM DatedConversionRate';
                    query_currency += ' WHERE Id != null';
                    query_currency += ' AND IsoCode = \''+NEU_CurrencyUtils.getCurrencyIsoCode(ship_prog)+'\'';
                    query_currency += ' AND startDate <= '+dtIsoCode.format('yyyy-MM-dd')+' AND nextstartdate > '+dtIsoCode.format('yyyy-MM-dd');
                    query_currency += ' LIMIT 1';
                    conversion = Database.query(query_currency);
                    decimal factor = (Decimal)conversion[0].get('ConversionRate');
                    convert = true;
                    
                    if(buy_amount_currency != null && factor != null)
                    {
                        decimal buy_Amount_convert = (buy_amount_currency / factor);
                        total_Services_Std_Buy_Amount_s_convert = buy_Amount_convert.setScale(2).format();
                    }
                    if(sell_amount_currency != null && factor != null)
                    {
                        decimal sell_Amount_convert = (sell_amount_currency / factor);
                        total_Services_Sell_Amount_s_convert = sell_Amount_convert.setScale(2).format();
                    }
                    
                    if(charges_m3_currency != null && factor != null)
                    {
                        decimal charges_m3_convert = (charges_m3_currency / factor);
                        total_Services_charges_m3_s_convert = charges_m3_convert.setScale(2).format();
                    }
                    if(charges_kg_currency != null && factor != null)
                    {
                        decimal charges_kg_convert = (charges_kg_currency / factor);
                        total_Services_charges_kg_s_convert = charges_kg_convert.setScale(2).format();
                    }
                        
                }
            }
        }
    }
    
    public  List<SelectOption> getnewcategories()
    {
        if(newcategories==null)
        {
            mynewcategory=null;
            newcategories=new List<SelectOption>();
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Fee__c.Fee_Category__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                newcategories.add(new SelectOption(f.getValue(),f.getValue()));
                if(String.IsEmpty(mynewcategory)&&Apexpages.currentPage().getParameters().get('pes') ==null)
                {
                    mynewcategory=f.getValue();
                    fee_record.Fee_Category__c = mynewcategory;
                }
                else
                    if(Apexpages.currentPage().getParameters().get('pes') !=null)
                        if(f.getValue() == Apexpages.currentPage().getParameters().get('pes'))
                        {
                             mynewcategory=f.getValue();
                             fee_record.Fee_Category__c = mynewcategory;
                        }
            }
        }
        return newcategories;
    }
    private String recordtype=null;
    public String getrecordtype()
    {
      if(recordtype==null)
      {
        List<Shipment_Program_Line_s> fees=getshipfeeLines();
        if(fees.size()>0)
          if(fees[0].ship_prog_line.Service_Rate_Name__r.RecordTypeId!=null)
            recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].ship_prog_line.Service_Rate_Name__r.RecordTypeId).getName();
      }
      if(recordtype==null)
      {
        List<Ship_Prog_Fee_Line_s> fees=getFee_List_Price();
        if(fees.size()>0)
          if(fees[0].line.RecordTypeId!=null)
            recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].line.RecordTypeId).getName();
      }
      return recordtype;
    }
    public void setrecordtype(String val){}
    private String mynewcategory=null;
    public String getnewcategory()
    {
        if(mynewcategory==null)
            getnewcategories();
        return mynewcategory;
    }
    public void setnewcategory(String value)
    {
        if(mynewcategory!=value)
        {
            error_ruta = '';
            mynewcategory=value;
            
            fee_record = null;
            fee_record = new Fee__c();
            
           // fee_record.Account_for__c = record.Account_for__c;
                if(value != 'Drayages' && value != 'Other Service Charges')
                    fee_record.Route__c = record.Route__c;
                    
            if(value == 'Sea Freights' || value == 'Road Freights' || value == 'Railway Freights' || value == 'Multimodal Freights' || value == 'POL Charges' || value == 'POD Charges' || value == 'Warehouse')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            else if(value == 'Air Freights')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            else if(value == 'Drayages')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            else
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }   
            fee_record.Fee_Category__c = value;
                
            system.debug('new rate'+ fee_record.Fee_Category__c);
        
            Fee_List_Price = null;
            Fee_List_Price2 = null;
            List_Fee_Shipment_Import_Export =null;
            categories();
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
   public Shipment__c getshipment_filter()
   {
      
      return shipment_filter;
   }
    
    public void setshipment_filter(Shipment__c value)
    {
        if(shipment_filter!=value && value != null)
        {
            shipment_filter=value;
        }
    }
    
    public NEU_Allocate_Costs_to_Ship_Service_Lines(ApexPages.StandardController stdController) {
            if (!Test.isRunningTest())
            stdController.AddFields(new String[]  {'Id', 'Name', 'Total_Gross_Weight_Kg__c', 'Total_Gross_Volume_m3__c', 'Route__c', 'Total_Services_Std_Buy_Amount__c', 'Total_Services_Sell_Amount__c', 'Route_Site_of_Load__c', 'Route__r.Port_Airport_of_Load__c', 'Route__r.Port_Airport_of_Discharge__c', 'Route__r.Country_of_Discharge__c', 'Route__r.Country_of_Load__c', 'Route__r.Port_Airport_of_Load__r.Name', 'Route__r.Port_Airport_of_Discharge__r.Name', 'Route__r.Country_of_Discharge__r.Name', 'Route__r.Country_of_Load__r.Name', 'NUM_Total_Services_Std_Buy_Amount__c', 'NUM_Total_Services_Sell_Amount__c', 'Service_Charges_Kg__c', 'Service_Charges_m3__c', 'Pallet_Container_Type__c', 'Pallet_Container_Type__r.Container_Type__c', 'Route_Site_of_Discharge__c', 'Route__r.State_of_Load__c', 'Route__r.State_of_Load__r.Name', 'Route__r.State_of_Discharge__c', 'Route__r.State_of_Discharge__r.Name', 'Number_of_Containers__c',  (UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Number__c') });
           
            record=(Shipment_Program__c)stdController.getRecord();
            
            totales = record;
            
            orden_fees_filtro = 'Name';
            orden_fees_filtro_modo = 'asc';
            orden_fees_filtro_insertados = 'Name';
            orden_fees_filtro_modo_insertados = 'asc';
            orden_fees_filtro_insertados_all = 'Name';
            orden_fees_filtro_modo_insertados_all = 'asc'; 
            totals_custom = new totales_s(totales);
            
            fee_record = new Fee__c();
            //fee_record.Account_for__c = record.Account_for__c;
            fee_record.Route__c = record.Route__c;
            currencies = new List<SelectOption>();
            if(UserInfo.isMultiCurrencyOrganization()== true)
            {
                for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                {
                    if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                    {
                        currencies.add(new SelectOption(lu,lu));
                        fee_currency = NEU_CurrencyUtils.getCurrencyIsoCode(record);
                        break;
                    }
                }
                     
                for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                {
                    if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                    {
                        currencies.add(new SelectOption(lu,lu));
                    }
                }
            }
            else
              currencies.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
             
        
            if(shipment_filter == null)
            {
              shipment_filter = new Shipment__c();
              shipment_filter.Route__c = record.Route__c; 
              //shipment_filter.Account_for__c = '001b000003M4Drd';
             // shipment_filter.Purchase_Incoterm__c = record.Purchase_Incoterm__c;
             // shipment_filter.Sales_Incoterm__c = record.Sales_Incoterm__c;
             // shipment_filter.Pickup_Cartage__c = record.Pickup_Cartage__c;
            //  shipment_filter.Delivery_Cartage__c = record.Delivery_Cartage__c;
            //  shipment_filter.Carrier__c = record.Carrier__c;
              if(record.Pallet_Container_Type__c != null)
                shipment_filter.Container_Type__c= record.Pallet_Container_Type__r.Container_Type__c;
              listado_ids_ruta = new Map<Id,Id>();
              
              
              //para filtrar rutas  
              set<Id> listado_country_load = new set<Id>();
              set<Id> listado_state_load = new set<Id>();
              set<Id> listado_site_load = new set<Id>();
              set<Id> listado_country_discharge = new set<Id>();
              set<Id> listado_state_discharge = new set<Id>();
              set<Id> listado_site_discharge = new set<Id>();
              
              if(record.Route__c != null)
              {
                listado_ids_ruta.put(record.Route__c, record.Route__c);
                
                if(record.Route__r.Country_of_Load__c != null)
                     listado_country_load.add(record.Route__r.Country_of_Load__c);
                if(record.Route__r.Country_of_Discharge__c != null)
                     listado_country_discharge.add(record.Route__r.Country_of_Discharge__c);
                if(record.Route__r.State_of_Load__c != null)
                     listado_state_load.add(record.Route__r.State_of_Load__c);
                if(record.Route__r.State_of_Discharge__c != null)
                     listado_state_discharge.add(record.Route__r.State_of_Discharge__c);
                if(record.Route__r.Port_Airport_of_Discharge__c != null)
                     listado_site_discharge.add(record.Route__r.Port_Airport_of_Discharge__c);
                if(record.Route__r.Port_Airport_of_Load__c != null)
                     listado_site_load.add(record.Route__r.Port_Airport_of_Load__c);        
                     
              }
              
              
               
              //añadir todas las rutas de los shipment relacionados
              List<Shipment__c> query_shipments_routes = [select Id, Name,
              Route__c, Country_of_Discharge__c,
              Country_of_Load__c, Site_of_Discharge__c, Site_of_Load__c, Route__r.Country_of_Load__c,
              Route__r.Country_of_Discharge__c, Route__r.Port_Airport_of_Discharge__c, 
              Route__r.Port_Airport_of_Load__c, State_of_Discharge__c, Route__r.State_of_Discharge__c, State_of_Load__c, Route__r.State_of_Load__c
              from Shipment__c where Inbound_Consolidation_Program__c =: record.Id];
              for(Shipment__c ship: query_shipments_routes)
              {
                    if(ship.Route__c != null)
                        listado_ids_ruta.put(ship.Route__c, ship.Route__c);

                    if(ship.Country_of_Load__c != null)
                        listado_country_load.add(ship.Country_of_Load__c);
                    if(ship.Country_of_Discharge__c != null)
                        listado_country_discharge.add(ship.Country_of_Discharge__c);
                    if(ship.State_of_Load__c != null)
                        listado_state_load.add(ship.State_of_Load__c);
                    if(ship.State_of_Discharge__c != null)
                        listado_state_discharge.add(ship.State_of_Discharge__c);
                    if(ship.Site_of_Load__c != null)
                        listado_site_load.add(ship.Site_of_Load__c);    
                    if(ship.Site_of_Discharge__c != null)
                        listado_site_discharge.add(ship.Site_of_Discharge__c);
              }
              
              //incluir rutas que coinciden con una parte  
              List<Carrier_Line_Load_Point__c> query_extra_routes = [select id, Name, Country_of_Load__c, Country_of_Discharge__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c,
              State_of_Load__c, State_of_Discharge__c 
              from Carrier_Line_Load_Point__c where
              (Country_of_Load__c IN : listado_country_load or Country_of_Load__c =: null or (Country_of_Load__c IN : listado_country_discharge and Country_of_Discharge__c =: null))
              and (State_of_Load__c IN : listado_state_load or State_of_Load__c =: null or (State_of_Load__c IN : listado_state_discharge and State_of_Discharge__c =: null))
              and (Port_Airport_of_Load__c IN: listado_site_load or Port_Airport_of_Load__c =: null or (Port_Airport_of_Load__c IN: listado_site_discharge and Port_Airport_of_Discharge__c =: null))
              and (Country_of_Discharge__c IN: listado_country_discharge or Country_of_Discharge__c =: null or( Country_of_Discharge__c IN: listado_country_load and Country_of_Load__c =: null))
              and (State_of_Discharge__c IN: listado_state_discharge or State_of_Discharge__c =: null or (State_of_Discharge__c IN : listado_state_load and State_of_Load__c =: null))
              and (Port_Airport_of_Discharge__c IN: listado_site_discharge or Port_Airport_of_Discharge__c=: null or ( Port_Airport_of_Discharge__c IN: listado_site_load and Port_Airport_of_Load__c =: null))];
              
              system.debug('hola2 '+ query_extra_routes);
              if(query_extra_routes != null && query_extra_routes.size()>0)
              {
                  for(Shipment__c ship: query_shipments_routes)
                  {
                      for(Carrier_Line_Load_Point__c route: query_extra_routes)
                      {
                      	if(route.Country_of_Load__c == ship.Country_of_Load__c && route.Port_Airport_of_Load__c == ship.Site_of_Load__c && route.State_of_Load__c == ship.State_of_Load__c
                        && route.Country_of_Discharge__c == null && route.Port_Airport_of_Discharge__c == null && route.State_of_Discharge__c == null)
                       		listado_ids_ruta.put(route.Id, route.Id);
                        
                        if(route.Country_of_Discharge__c == ship.Country_of_Discharge__c && route.Port_Airport_of_Discharge__c == ship.Site_of_Discharge__c && route.State_of_Discharge__c == ship.State_of_Discharge__c
                        && route.Country_of_Load__c == null && route.Port_Airport_of_Load__c == null && route.State_of_Load__c == null)
                          	listado_ids_ruta.put(route.Id, route.Id);
                          
                        if(route.Country_of_Load__c == record.Route__r.Country_of_Load__c && route.Port_Airport_of_Load__c == record.Route__r.Port_Airport_of_Load__c && route.State_of_Load__c == record.Route__r.State_of_Load__c
                        && route.Country_of_Discharge__c == null && route.Port_Airport_of_Discharge__c == null && route.State_of_Discharge__c == null)
                          	listado_ids_ruta.put(route.Id, route.Id);  
                          
                        if(route.Country_of_Discharge__c == record.Route__r.Country_of_Discharge__c && route.Port_Airport_of_Discharge__c == record.Route__r.Port_Airport_of_Discharge__c && route.State_of_Discharge__c == record.Route__r.State_of_Discharge__c
                        && route.Country_of_Load__c == null && route.Port_Airport_of_Load__c == null && route.State_of_Load__c == null)
                          	listado_ids_ruta.put(route.Id, route.Id);  
                          
                        if(route.Country_of_Load__c == ship.Country_of_Discharge__c && route.Port_Airport_of_Load__c == ship.Site_of_Discharge__c && route.State_of_Load__c == ship.State_of_Discharge__c
                        && route.Country_of_Discharge__c == null && route.Port_Airport_of_Discharge__c == null && route.State_of_Discharge__c == null)
                          listado_ids_ruta.put(route.Id, route.Id);
                          
                        if(route.Country_of_Discharge__c == ship.Country_of_Load__c && route.Port_Airport_of_Discharge__c == ship.Site_of_Load__c && route.State_of_Discharge__c == ship.State_of_Load__c
                        && route.Country_of_Load__c == null && route.Port_Airport_of_Load__c == null && route.State_of_Load__c == null)
                          listado_ids_ruta.put(route.Id, route.Id); 
                     
                      }
                  }
              }
            }
            
            if(record.Route__c != null)//, , , 
            {
                Date pdate = system.today(); 
                url_sailing_schedule = 'http://www.joc.com/sailings/Sailings-SearchResults?ORIGIN='+record.Route__r.Port_Airport_of_Load__r.Name+',%20'+record.Route__r.Country_of_Load__r.Name+'&direction=&destination='+record.Route__r.Port_Airport_of_Discharge__r.Name+',%20'+record.Route__r.Country_of_Discharge__r.Name+'&carrier=&vesselTypes=&days=30&date='+(pdate.Month())+'/'+pdate.day()+'/'+ pdate.Year(); 
            }
            system.debug('hola '+ listado_ids_ruta);
            error_ruta = '';
        }
        
        
        public void categories()
        {
            recordtype=null;
            shipfeeLines=null;
            shipfeeLines_all_categories = null;
        }
        
        public void all_accounts_filter()
        {
            recordtype=null;
            shipfeeLines=null;
            shipfeeLines_all_categories = null;
            Fee_List_Price = null;
            Fee_List_Price2 = null;
            List_Fee_Shipment_Import_Export = null;
            if(shipment_filter != null)
              shipment_filter.Account_for__c = null;
        }
        
         public void all_carriers_filter()
        {
            recordtype=null;
            shipfeeLines=null;
            Fee_List_Price = null;  
            Fee_List_Price2 = null;
            if(shipment_filter != null)
              shipment_filter.Carrier__c = null;
            orden_fees_filtro = 'total_sell';
            orden_fees_filtro_modo = 'desc';
        }
        
        public void update_check_show_all_categories()
        {
            show_all_categories_all_lines = true;
        }
        
        public void update_check_hidden_all_categories()
        {
            show_all_categories_all_lines = false;
            show_all_categories = false;
        }
        
        public void filter_new_carrier()
        {
            recordtype=null;
            shipfeeLines=null;
            shipfeeLines_all_categories = null;
            Fee_List_Price = null;
            Fee_List_Price2 = null;
            orden_fees_filtro = 'total_sell';
            orden_fees_filtro_modo = 'desc';
        }
        
         public void all_containers_filter()
        {
            recordtype=null;
            shipfeeLines=null;
            shipfeeLines_all_categories = null;
            Fee_List_Price = null; 
            Fee_List_Price2 = null;
            List_Fee_Shipment_Import_Export = null;
            if(shipment_filter != null)
              shipment_filter.Container_Type__c = null;
        }
        
            //Consultar las lineas insertadas
        public List<Shipment_Program_Line_s> getshipfeeLines()
        {
            if(shipfeeLines == null)
            {
                shipfeeLines = new List<Shipment_Program_Line_s>();
                List<Shipment_Program_Line__c> query_ship_prog_lines;
                String cat = getnewcategory(); 
                Id idRecord = record.Id;
                if(String.isNotEmpty(getnewcategory()))
                  query_ship_prog_lines =  Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Service_Rate_Name__r.Container_Type__c, Std_Buy_Amount_header_currency__c, Inbound_Shipment__c, Inbound_Shipment__r.Name, Inbound_Shipment__r.Total_Weight_Kg__c, Inbound_Shipment__r.Total_Volume_m3__c, Inbound_Shipment__r.Storage_Date_From__c, Inbound_Shipment__r.Storage_Date_To__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Concept_1__c, Service_Rate_Name__r.Concept_2__c, Service_Rate_Name__r.Concept_3__c, Service_Rate_Name__r.Concept_4__c, Service_Rate_Name__r.Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Buy_Amount__c, Sell_Amount__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Ship_Prog_Sell_Price__c, Discount_Charge__c, Ship_Prog_Sell_Net_Price__c, Ship_Prog_Buy_Price__c, Shipments_Program__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c  from Shipment_Program_Line__c where Shipments_Program__c =:idRecord and Service_Rate_Name__r.Fee_Category__c =:cat');
                else
                  query_ship_prog_lines =  Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Service_Rate_Name__r.Container_Type__c, Std_Buy_Amount_header_currency__c, Inbound_Shipment__c, Inbound_Shipment__r.Name, Inbound_Shipment__r.Total_Weight_Kg__c, Inbound_Shipment__r.Total_Volume_m3__c, Inbound_Shipment__r.Storage_Date_From__c, Inbound_Shipment__r.Storage_Date_To__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Concept_1__c, Service_Rate_Name__r.Concept_2__c, Service_Rate_Name__r.Concept_3__c, Service_Rate_Name__r.Concept_4__c, Service_Rate_Name__r.Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Buy_Amount__c, Sell_Amount__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Ship_Prog_Sell_Price__c, Discount_Charge__c, Ship_Prog_Sell_Net_Price__c, Ship_Prog_Buy_Price__c,  Shipments_Program__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Shipment_Program_Line__c where Shipments_Program__c =:idRecord');
                
                total_cost_category_decimal = 0;
                
                for(Shipment_Program_Line__c spl:query_ship_prog_lines)
                {
                  shipfeeLines.add(new Shipment_Program_Line_s(spl,(spl.Inbound_Shipment__c != null ? spl.Inbound_Shipment__r : null),this));
                  
                  total_cost_category_decimal += neu_utils.safedecimal(spl.Std_Buy_Amount_header_currency__c);
                }
                total_cost_category =NEU_CurrencyUtils.getCurrencyIsoCode(record) + ' '+(total_cost_category_decimal).format();
                
                decimal total_x_m = 0;
                if(record.Total_Gross_Volume_m3__c != null && total_cost_category_decimal > 0)
                  total_x_m = (total_cost_category_decimal/record.Total_Gross_Volume_m3__c).setScale(2);
                total_cost_category_m3 = NEU_CurrencyUtils.getCurrencyIsoCode(record)+' '+(total_x_m).format();
                
                decimal total_x_kg = 0;
                if(record.Total_Gross_Weight_Kg__c != null && total_cost_category_decimal > 0)
                  total_x_kg = (total_cost_category_decimal/record.Total_Gross_Weight_Kg__c).setScale(2);
                total_cost_category_kg  = NEU_CurrencyUtils.getCurrencyIsoCode(record)+' '+(total_x_kg).format();
                
            }
            return shipfeeLines; 
        }
        
        
         //Consultar las lineas insertadas sin filtro de categoria
        public List<Shipment_Program_Line_s> getshipfeeLines_all_categories()
        {
          if(shipfeeLines_all_categories == null)
          {
            shipfeeLines_all_categories = new List<Shipment_Program_Line_s>();
            List<Shipment_Program_Line__c> query_ship_prog_lines;
            query_ship_prog_lines =  Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode , Shipments_Program__r.CurrencyIsoCode,' : '')+'  Service_Rate_Name__r.Container_Type__c, Shipments_Program__r.Name, Std_Buy_Amount_header_currency__c, Service_Rate_Name__r.Carrier_Account__r.Name, Inbound_Shipment__c, Inbound_Shipment__r.Name, Inbound_Shipment__r.Total_Weight_Kg__c, Inbound_Shipment__r.Total_Volume_m3__c, Inbound_Shipment__r.Storage_Date_From__c, Inbound_Shipment__r.Storage_Date_To__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Concept_1__c, Service_Rate_Name__r.Concept_2__c, Service_Rate_Name__r.Concept_3__c, Service_Rate_Name__r.Concept_4__c, Service_Rate_Name__r.Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Buy_Amount__c, Sell_Amount__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Ship_Prog_Sell_Price__c, Discount_Charge__c, Ship_Prog_Sell_Net_Price__c, Ship_Prog_Buy_Price__c,  Shipments_Program__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Comments_Service_Line__c from Shipment_Program_Line__c where Shipments_Program__c = \''+ record.Id+'\'');
            for(Shipment_Program_Line__c spl:query_ship_prog_lines)
              shipfeeLines_all_categories.add(new Shipment_Program_Line_s(spl,(spl.Inbound_Shipment__c != null ? spl.Inbound_Shipment__r : null),this));
          }
            return shipfeeLines_all_categories; 
        }
        
        //funciones de comparacion
        public void go_compare_fees_filtro()
        {   
            Fee_List_Price.sort();
        }
        
        public void go_compare_fees_filtro2()
        {   
            Fee_List_Price2.sort();
        }
        
        public void go_compare_fees_filtro_insertados()
        {   
            if(shipfeeLines != null)
                shipfeeLines.sort();
            if(shipfeeLines_all_categories != null)
                shipfeeLines_all_categories.sort();
        }
        
        public void all_routes_filter()
        {
            recordtype=null;
            shipfeeLines=null;
            shipfeeLines_all_categories = null;
            Fee_List_Price = null;
            Fee_List_Price2 = null;
            List_Fee_Shipment_Import_Export = null;
            listado_ids_ruta = new Map<Id,Id>();
            if(record.Route__c != null)
                listado_ids_ruta.put(record.Route__c, record.Route__c);
            //añadir todas las rutas de los shipment relacionados
            List<Shipment__c> query_shipments_routes = [select Id, Name, Route__c  from Shipment__c where Inbound_Consolidation_Program__c =: record.Id];
            for(Shipment__c ship: query_shipments_routes)
            {
                if(ship.Route__c != null)
                    listado_ids_ruta.put(ship.Route__c, ship.Route__c);
            }
        }
        
        public void go_compare_all_service_rate_ie()
        {
            if(List_Fee_Shipment_Import_Export != null && List_Fee_Shipment_Import_Export.size()>0)
            {
                for(Ship_fee_lines_import_export_s lie:List_Fee_Shipment_Import_Export)
                {
                    if(lie.list_fees != null && lie.list_fees.size()>0)
                    {
                        lie.list_fees.sort();
                    }
                }
            }
        }
        
        public List<Ship_Prog_Fee_Line_s> getFee_List_Price2()
        {
            
            if(Fee_List_Price2 == null)
            {
                List<SelectOption> options = new List<SelectOption>(); 
                string moneda_usuario ='';
           
                if(UserInfo.isMultiCurrencyOrganization()== true)
                {
                     for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                     {
                         if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                        {
                            options.add(new SelectOption(lu,lu));
                            break;
                        }
                     }
                     
                     for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                     {
                        if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                            options.add(new SelectOption(lu,lu));
                     }
                }
                else
                    options.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
                     
                 
                Fee_List_Price2=new List<Ship_Prog_Fee_Line_s>();
                List<Fee__c> lista_fee =new List<Fee__c>();
            	
            	String cat = getnewcategory();
            
                if(String.IsNotEmpty(cat))
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Container_Type__c, Max_Kgs__c, Max_M3__c, Route__r.Name, Volumetric_Factor__c, Min__c, Concept_1__c, Cost_Concept_1__c ,Cost_Concept_2__c , Cost_Concept_3__c , Carrier_Account__r.Name, Cost_Concept_4__c, Cost_Concept_5__c,   Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c,  Fee_Description__c, Container_Type__r.Cargo_Volume_m3__c, Valid_Until__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c, Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Port_Airport__r.Name, Account_for__c, Account_for__r.Name,Carrier_Account__c, TT_Days__c,Delivery_Zone__c, RecordTypeId, Route__c, Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c,  Fee_Rate__c  from Fee__c where Fee_Category__c =:cat  and Active__c = true order by Rate_Type__c, Buy_Rate__c asc');
                else
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Container_Type__c, Max_Kgs__c, Max_M3__c, Route__r.Name, Volumetric_Factor__c, Min__c, Concept_1__c, Cost_Concept_1__c ,Cost_Concept_2__c , Cost_Concept_3__c , Carrier_Account__r.Name, Cost_Concept_4__c, Cost_Concept_5__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Fee_Description__c, Container_Type__r.Cargo_Volume_m3__c, Valid_Until__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c, Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Port_Airport__r.Name, Account_for__c, Account_for__r.Name,Carrier_Account__c, TT_Days__c, Delivery_Zone__c, RecordTypeId, Route__c, Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c, Fee_Rate__c  from Fee__c where Active__c = true order by Rate_Type__c, Buy_Rate__c asc');
                         
            
                boolean insertar = true;
                decimal unidades_calculadas = 1; 
                decimal weight_vol_factor = 0;
                decimal unidades_calculadas2 = 1;
                if(getnewcategory() == 'Warehouse')
                {
                        //recojoj las import-export que intervienen en este shipment program
                         List<Shipment_Consolidation_Data__c> query_ship_consodata =[select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipments_Program__c =: record.Id and Import_Export_Quote__c !=: null];
                         Set<Id> listado_import_export_utilizadas = new Set<Id>(); 
                         List<Shipment__c> listado_last_shipment_almacenes = new List<Shipment__c>();
                         for(Shipment_Consolidation_Data__c scd: query_ship_consodata)//--se puede me
                         {
                            listado_import_export_utilizadas.add(scd.Import_Export_Quote__c);
                         }
                         Map<Id,Customer_Quote__c> map_shipment_imp_exp = new Map<Id,Customer_Quote__c>();
                         if(listado_import_export_utilizadas != null && listado_import_export_utilizadas.size()>0)
                         {
                            //busco el shipment anterior de estas import-export
                            query_ship_consodata = [select id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name, Shipment__c, Shipment__r.Name, Shipment__r.Storage_days__c, Shipment__r.Total_Volume_m3__c, Shipment__r.Total_Weight_Kg__c, Shipment__r.Storage_Date_From__c, Shipment__r.Storage_Date_To__c  from Shipment_Consolidation_Data__c where Import_Export_Quote__c IN: listado_import_export_utilizadas and Import_Export_Quote__c !=: null and Shipments_Program__c !=: record.Id order by CreatedDate desc];
                            string contenedor_import_export = '';
                            for(Shipment_Consolidation_Data__c scd : query_ship_consodata)
                            {
                                if(contenedor_import_export == '' || contenedor_import_export.contains(scd.Import_Export_Quote__c) == false)
                                {
                                    listado_last_shipment_almacenes.add(scd.Shipment__r);
                                    map_shipment_imp_exp.put(scd.Shipment__c, scd.Import_Export_Quote__r);
                                }
                                contenedor_import_export += scd.Import_Export_Quote__c;
                            }
                            
                                
                         }
                         //consulta para saber si este fee ya esta insertado en cada shipment
                         List<Shipment_Fee_Line__c> query_shipment_service_line = [select Id, Name, Shipment__c, Service_Rate_Name__c, Units__c, Shipment_Sell_Price__c , Discount_Charge__c , Shipment_Buy_Price__c, Shipment_Sell_Net_Price__c, Std_Buy_Amount__c, Sell_Gross_Amount__c, Sell_Amount__c from Shipment_Fee_Line__c where Shipment__c IN: listado_last_shipment_almacenes order by Shipment__c];
                         Map<String, Shipment_Fee_Line__c> map_ship_fee = new Map<String, Shipment_Fee_Line__c>();
                         for(Shipment_Fee_Line__c sfl: query_shipment_service_line)
                         {
                            map_ship_fee.put(sfl.Shipment__c+'_'+sfl.Service_Rate_Name__c, sfl); 
                         }
                         //si hay shipments anteriores lo saco si no no
                         if(listado_last_shipment_almacenes != null && listado_last_shipment_almacenes.size()>0)
                         {
                             for(Shipment__c s: listado_last_shipment_almacenes)
                             {
                                 for(Fee__c lp: lista_fee)
                                 {
                                    if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                                    {
                                        if(shipment_filter.Route__c == null || lp.Route__c== null || shipment_filter.Route__c == lp.Route__c ||(listado_ids_ruta != null && listado_ids_ruta.size()>0 && listado_ids_ruta.containsKey(lp.Route__c)== true))
                                        {
                                          if(shipment_filter.Account_for__c == lp.Account_for__c || shipment_filter.Account_for__c == null)
                                          {
                                            /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                                if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                                   continue;
                                      
                                            if(lp.Applicable_to_Sales_Incoterms__c != null)
                                                  if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                                       continue;*/
                                            
                                            if(shipment_filter.Container_Type__c != null)
                                                if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                                        continue;
                                            
                                            /*if(record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                              if(record.Total_Gross_Volume_m3__c > lp.Max_M3__c)
                                                  continue;
                                                  
                                            if(record.Total_Gross_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                              if(record.Total_Gross_Weight_Kg__c > lp.Max_Kgs__c)
                                                  continue; */
                                                  
                                                  
                                            if(lp.Rate_Type__c == 'Per Kg')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c : 1);
                                                weight_vol_factor = (record.Total_Gross_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                                if(weight_vol_factor > unidades_calculadas)
                                                    unidades_calculadas = weight_vol_factor; 
                                            }
                                            if(lp.Rate_Type__c == 'Per TON')
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/1000 : 1);
                                            if(lp.Rate_Type__c == 'Per M3')
                                            {
                                                 unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c : 1);
                                                 weight_vol_factor = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                                 if(weight_vol_factor > unidades_calculadas)
                                                     unidades_calculadas = weight_vol_factor; 
                                            }
                                            if(lp.Rate_Type__c == 'Per Container')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                                unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                               if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                               
                                            }
                                            if(lp.Rate_Type__c == 'Per W/M')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                                weight_vol_factor = unidades_calculadas;
                                                unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 ? record.Total_Gross_Volume_m3__c : 0);
                                                if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                            } 
                                            if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))    
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Max_Kgs__c != null ? record.Total_Gross_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                                unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null ? record.Total_Gross_Volume_m3__c/lp.Max_M3__c  : 0);
                                                if(unidades_calculadas2 > unidades_calculadas)
                                                     unidades_calculadas = unidades_calculadas2; 
                                            }          
                                            if(lp.Rate_Type__c == 'Per Pallet')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                                unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                               if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                               
                                            }
                                            if(lp.Rate_Type__c == 'Per Day')
                                            {
                                                if(s.Storage_days__c != null)
                                                    unidades_calculadas = s.Storage_days__c;
                                            }      
                                            
                                            
                                             unidades_calculadas = unidades_calculadas.setScale(2);
                                             Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                             Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);
                                             Shipment_Program_Line__c ship_fee_line = new Shipment_Program_Line__c();
                                             ship_fee_line.Units__c = (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.Number_of_Containers__c : unidades_calculadas);
                                             ship_fee_line.Ship_Prog_Sell_Price__c = sellrate;
                                             ship_fee_line.Discount_Charge__c  = 0;
                                             ship_fee_line.Ship_Prog_Buy_Price__c = buyrate;
                                             Fee_List_Price2.add(new Ship_Prog_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.Number_of_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor, s, (map_shipment_imp_exp.containsKey(s.Id) ? map_shipment_imp_exp.get(s.Id) : null), (map_ship_fee.containsKey( s.Id+'_'+lp.Id) ? true : false), (map_ship_fee.containsKey( s.Id+'_'+lp.Id) ? map_ship_fee.get(s.Id+'_'+lp.Id) : null)));//options,lp.CurrencyIsoCode)      
                                                   
                                          }
                                        }
                                    }
                                    unidades_calculadas = 1;
                                    weight_vol_factor = 0;
                                    unidades_calculadas2 = 1;
                                 }
                             }
                         }
                    }
                }
                 
                return Fee_List_Price2;
        }
    
        public List<Ship_Prog_Fee_Line_s> getFee_List_Price()
        {
            if(Fee_List_Price == null)
            {
                List<SelectOption> options = new List<SelectOption>(); 
                string moneda_usuario ='';
           
                if(UserInfo.isMultiCurrencyOrganization()== true)
                {
                     for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                     {
                         if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                        {
                            options.add(new SelectOption(lu,lu));
                            break;
                        }
                     }
                     
                     for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                     {
                        if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                            options.add(new SelectOption(lu,lu));
                     }
                }
                else
                    options.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
                     
                 
                Fee_List_Price=new List<Ship_Prog_Fee_Line_s>();
                List<Fee__c> lista_fee =new List<Fee__c>();
            	
            	String cat = getnewcategory();
                if(String.IsNotEmpty(cat))
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Container_Type__c, Max_Kgs__c, Max_M3__c, Route__r.Name, Volumetric_Factor__c, Min__c, Concept_1__c, Cost_Concept_1__c ,Cost_Concept_2__c , Cost_Concept_3__c , Carrier_Account__r.Name, Cost_Concept_4__c, Cost_Concept_5__c,   Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c,  Fee_Description__c, Container_Type__r.Cargo_Volume_m3__c, Valid_Until__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c, Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Port_Airport__r.Name, Account_for__c, Account_for__r.Name,Carrier_Account__c, TT_Days__c,Delivery_Zone__c, RecordTypeId, Route__c, Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c,  Fee_Rate__c  from Fee__c where Fee_Category__c =:cat and Active__c = true order by Rate_Type__c, Buy_Rate__c asc');
                else
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Container_Type__c, Max_Kgs__c, Max_M3__c, Route__r.Name, Volumetric_Factor__c, Min__c, Concept_1__c, Cost_Concept_1__c ,Cost_Concept_2__c , Cost_Concept_3__c , Carrier_Account__r.Name, Cost_Concept_4__c, Cost_Concept_5__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Fee_Description__c, Container_Type__r.Cargo_Volume_m3__c, Valid_Until__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c, Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Port_Airport__r.Name, Account_for__c, Account_for__r.Name,Carrier_Account__c, TT_Days__c, Delivery_Zone__c, RecordTypeId, Route__c, Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c, Fee_Rate__c  from Fee__c where Active__c = true order by Rate_Type__c, Buy_Rate__c asc');
                         
            
                boolean insertar = true;
                decimal unidades_calculadas = 1; 
                decimal weight_vol_factor = 0;
                decimal unidades_calculadas2 = 1;
                if(getnewcategory() != 'Warehouse')
                {
                    for(Fee__c lp: lista_fee)
                    {
                        if(insertar|| ApexPages.currentPage().getParameters().get('test') != null)
                        {
                            if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId())
                            {
                             
                                   if((string.isnotEmpty(record.Route_Site_of_Load__c) || string.isnotEmpty(record.Route_Site_of_Discharge__c))
                                    && (lp.Port_Airport__c != null && record.Route_Site_of_Load__c != lp.Port_Airport__r.Name && record.Route_Site_of_Discharge__c != lp.Port_Airport__r.Name))  
                                        continue;
                                    
                                    if((shipment_filter.Pickup_Cartage__c != null || shipment_filter.Delivery_Cartage__c != null) && shipment_filter.Pickup_Cartage__c != lp.Delivery_Zone__c && shipment_filter.Delivery_Cartage__c != lp.Delivery_Zone__c  && lp.Delivery_Zone__c != null)
                                        continue;
                                    
                                    /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                      if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                           continue;
                                  
                                    if(lp.Applicable_to_Sales_Incoterms__c != null)
                                       if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                           continue;*/
                                    if(shipment_filter.Account_for__c != null)
                                        if(shipment_filter.Account_for__c != lp.Account_for__c && shipment_filter.Account_for__c != null)
                                            continue; 
                                    
                                    if(shipment_filter.Container_Type__c != null)
                                      if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                        continue;
                                        
                                    if(lp.Carrier_Account__c != null && shipment_filter != null)
                                      if(shipment_filter.Carrier__c != null && lp.Carrier_Account__c != shipment_filter.Carrier__c)
                                        continue;          
                                    /*if(record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                      if(record.Total_Gross_Volume_m3__c > lp.Max_M3__c)
                                          continue;
                                          
                                    if(record.Total_Gross_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                      if(record.Total_Gross_Weight_Kg__c > lp.Max_Kgs__c)
                                          continue;      */         
                            
                                    if(lp.Rate_Type__c == 'Per Kg')
                                    {
                                        unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c : 1);
                                        weight_vol_factor = (record.Total_Gross_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                        if(weight_vol_factor > unidades_calculadas)
                                            unidades_calculadas = weight_vol_factor;
                                    }
                                    if(lp.Rate_Type__c == 'Per TON')
                                        unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/1000 : 1);
                                    if(lp.Rate_Type__c == 'Per M3')
                                    {
                                         unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c : 1); 
                                         weight_vol_factor = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                         if(weight_vol_factor > unidades_calculadas)
                                             unidades_calculadas = weight_vol_factor;
                                    }
                                    if(lp.Rate_Type__c == 'Per Container')
                                    {
                                        unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                        unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                       if(unidades_calculadas2 > unidades_calculadas)
                                           unidades_calculadas = unidades_calculadas2; 
                                       
                                    }
                                    if(lp.Rate_Type__c == 'Per W/M')
                                    {
                                        unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                        weight_vol_factor = unidades_calculadas;
                                        unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 ? record.Total_Gross_Volume_m3__c : 0);
                                        if(unidades_calculadas2 > unidades_calculadas)
                                           unidades_calculadas = unidades_calculadas2; 
                                    } 
                                    if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))    
                                    {
                                        unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Max_Kgs__c != null ? record.Total_Gross_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                        unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null ? record.Total_Gross_Volume_m3__c/lp.Max_M3__c  : 0);
                                        if(unidades_calculadas2 > unidades_calculadas)
                                             unidades_calculadas = unidades_calculadas2; 
                                    }            
                                    if(lp.Rate_Type__c == 'Per Pallet')
                                    {
                                        unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                        unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                       if(unidades_calculadas2 > unidades_calculadas)
                                           unidades_calculadas = unidades_calculadas2; 
                                       
                                    }
                                    
                                    if(String.IsNotEmpty(getnewcategory()))
                                        if(getnewcategory() == 'Drayages' && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null )) 
                                              unidades_calculadas = 0;
                                              
                               //     unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                                    unidades_calculadas = unidades_calculadas.setScale(2);
                                    Decimal buyrate=(lp.Buy_rate__c == null ? 0 : lp.Buy_rate__c);
                                    Decimal sellrate=(lp.Fee_Rate__c == null ? 0 : lp.Fee_Rate__c);  
                                        
                                    Shipment_Program_Line__c ship_fee_line = new Shipment_Program_Line__c();
                                    ship_fee_line.Units__c = (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.Number_of_Containers__c : unidades_calculadas);
                                    ship_fee_line.Ship_Prog_Sell_Price__c = sellrate;
                                    ship_fee_line.Discount_Charge__c  = 0;
                                    ship_fee_line.Ship_Prog_Buy_Price__c = buyrate;
                                    /*ship_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                    ship_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;  
                                    ship_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                    ship_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;*/                             
                                    Fee_List_Price.add(new Ship_Prog_Fee_Line_s(lp ,
                                    ship_fee_line, 
                                    false, 
                                    (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.Number_of_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor,null,null, false, null));
                                
                            }
                            else
                            {
                                if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                                {
                                    if(shipment_filter.Route__c == null || lp.Route__c== null || shipment_filter.Route__c == lp.Route__c ||(listado_ids_ruta != null && listado_ids_ruta.size()>0 && listado_ids_ruta.containsKey(lp.Route__c)== true))
                                    {
                                      if(shipment_filter.Account_for__c == lp.Account_for__c || shipment_filter.Account_for__c == null)
                                      {
                                        /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                            if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                               continue;
                                  
                                        if(lp.Applicable_to_Sales_Incoterms__c != null)
                                              if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                                   continue;*/
                                        
                                        if(shipment_filter.Container_Type__c != null)
                                            if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                                    continue;
                                                    
                                        if(lp.Carrier_Account__c != null && shipment_filter != null)
                                            if(shipment_filter.Carrier__c != null && lp.Carrier_Account__c != shipment_filter.Carrier__c)
                                                continue;  
                                                
                                        if(shipment_filter.Account_for__c != null)
                                            if(shipment_filter.Account_for__c != lp.Account_for__c && shipment_filter.Account_for__c != null)
                                                continue;     
                                        
                                        /*if(record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                          if(record.Total_Gross_Volume_m3__c > lp.Max_M3__c)
                                              continue;
                                              
                                        if(record.Total_Gross_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                          if(record.Total_Gross_Weight_Kg__c > lp.Max_Kgs__c)
                                              continue;   */
                                           
                                        if(lp.Rate_Type__c == 'Per Kg')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c : 1);
                                            weight_vol_factor = (record.Total_Gross_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                            if(weight_vol_factor > unidades_calculadas)
                                                unidades_calculadas = weight_vol_factor;
                                        }
                                        if(lp.Rate_Type__c == 'Per TON')
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/1000 : 1);
                                        if(lp.Rate_Type__c == 'Per M3')
                                        {
                                             unidades_calculadas = (record.Total_Gross_Volume_m3__c>0 ? record.Total_Gross_Volume_m3__c : 1);
                                             weight_vol_factor = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                             if(weight_vol_factor > unidades_calculadas)
                                                 unidades_calculadas = weight_vol_factor; 
                                        }
                                        if(lp.Rate_Type__c == 'Per Container')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Volume_m3__c>0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                            unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                           if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                           
                                        } 
                                        if(lp.Rate_Type__c == 'Per W/M')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                            weight_vol_factor = unidades_calculadas;
                                            unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 ? record.Total_Gross_Volume_m3__c : 0);
                                            if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                        } 
                                        if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))    
                                        {
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Max_Kgs__c != null ? record.Total_Gross_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                            unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null ? record.Total_Gross_Volume_m3__c/lp.Max_M3__c  : 0);
                                            if(unidades_calculadas2 > unidades_calculadas)
                                                 unidades_calculadas = unidades_calculadas2; 
                                        }         
                                        if(lp.Rate_Type__c == 'Per Pallet')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Volume_m3__c>0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                            unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                           if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                           
                                        }
                                         
                                        if(String.IsNotEmpty(getnewcategory()))
                                            if(getnewcategory() == 'Drayages' && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null )) 
                                                  unidades_calculadas = 0;     
                                      //  unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                                        unidades_calculadas = unidades_calculadas.setScale(2);
                                        Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                        Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);
                                        Shipment_Program_Line__c ship_fee_line = new Shipment_Program_Line__c();
                                        ship_fee_line.Units__c = (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.Number_of_Containers__c : unidades_calculadas);
                                        ship_fee_line.Ship_Prog_Sell_Price__c = sellrate;
                                        ship_fee_line.Discount_Charge__c  = 0;
                                        ship_fee_line.Ship_Prog_Buy_Price__c = buyrate;
                                        /*ship_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                        ship_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;  
                                        ship_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                        ship_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;  */ 
                                        Fee_List_Price.add(new Ship_Prog_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.Number_of_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor, null,null, false, null));//options,lp.CurrencyIsoCode)
                                      }
                                    }
                                }
                                 else
                                 {
                                     if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId())
                                     {
                                        if(shipment_filter.Account_for__c == lp.Account_for__c || shipment_filter.Account_for__c == null)
                                        { 
                                            
                                            /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                                if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                                   continue;
                                      
                                            if(lp.Applicable_to_Sales_Incoterms__c != null)
                                                if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                                   continue;*/
                                                   
                                            if(shipment_filter.Container_Type__c != null)
                                                if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                                   continue; 
                                             
                                            if(shipment_filter.Account_for__c != null)
                                                if(shipment_filter.Account_for__c != lp.Account_for__c && shipment_filter.Account_for__c != null)
                                                    continue; 
                                            
                                            /*if(record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                              if(record.Total_Gross_Volume_m3__c > lp.Max_M3__c)
                                                  continue;
                                                  
                                            if(record.Total_Gross_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                              if(record.Total_Gross_Weight_Kg__c > lp.Max_Kgs__c)
                                                  continue;  */      
                                                       
                                            if(lp.Rate_Type__c == 'Per Kg')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c : 1);
                                                weight_vol_factor = (record.Total_Gross_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                                if(weight_vol_factor > unidades_calculadas)
                                                    unidades_calculadas = weight_vol_factor; 
                                            }
                                            if(lp.Rate_Type__c == 'Per TON')
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/1000 : 1);
                                            if(lp.Rate_Type__c == 'Per M3')
                                            {
                                                 unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c : 1);
                                                 weight_vol_factor = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                                 if(weight_vol_factor > unidades_calculadas)
                                                     unidades_calculadas = weight_vol_factor; 
                                            }
                                            if(lp.Rate_Type__c == 'Per Container')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                                unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                               if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                               
                                            }
                                            if(lp.Rate_Type__c == 'Per W/M')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                                weight_vol_factor = unidades_calculadas;
                                                unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 ? record.Total_Gross_Volume_m3__c : 0);
                                                if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                            } 
                                            if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))    
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Max_Kgs__c != null ? record.Total_Gross_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                                unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null ? record.Total_Gross_Volume_m3__c/lp.Max_M3__c  : 0);
                                                if(unidades_calculadas2 > unidades_calculadas)
                                                     unidades_calculadas = unidades_calculadas2; 
                                            }          
                                            if(lp.Rate_Type__c == 'Per Pallet')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                                unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                               if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                               
                                            }
                                            
                                            if(String.IsNotEmpty(getnewcategory()))
                                                if(getnewcategory() == 'Drayages' && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))   
                                                      unidades_calculadas = 0;       
                                          //  unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                                            unidades_calculadas = unidades_calculadas.setScale(2);
                                            Decimal buyrate=(lp.Buy_rate__c==null ? 0: lp.Buy_rate__c);
                                            Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);
                                            Shipment_Program_Line__c ship_fee_line = new Shipment_Program_Line__c();
                                            ship_fee_line.Units__c = (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.Number_of_Containers__c : unidades_calculadas);
                                            ship_fee_line.Ship_Prog_Sell_Price__c = sellrate;
                                            ship_fee_line.Discount_Charge__c  = 0;
                                            ship_fee_line.Ship_Prog_Buy_Price__c = buyrate;
                                            /*ship_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                            ship_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;  
                                            ship_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                            ship_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;*/   
                                            Fee_List_Price.add(new Ship_Prog_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.Number_of_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor, null,null, false, null));//options, lp.CurrencyIsoCode)
                                         
                                        }
                                     }
                                 }
                            }
                        
                            unidades_calculadas = 1;
                            weight_vol_factor = 0;
                            unidades_calculadas2 = 1;
                        }
                        insertar = true;
                         
                        }
                    }
                    else//esto es lo del warehouse
                    {
                        //recojoj las import-export que intervienen en este shipment program
                         List<Shipment_Consolidation_Data__c> query_ship_consodata =[select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipments_Program__c =: record.Id and Import_Export_Quote__c !=: null];
                         Set<Id> listado_import_export_utilizadas = new Set<Id>(); 
                         List<Shipment__c> listado_last_shipment_almacenes = new List<Shipment__c>();
                         for(Shipment_Consolidation_Data__c scd: query_ship_consodata)//--se puede me
                         {
                            listado_import_export_utilizadas.add(scd.Import_Export_Quote__c);
                         }
                         
                         if(listado_import_export_utilizadas != null && listado_import_export_utilizadas.size()>0)
                         {
                            //busco el shipment anterior de estas import-export
                            query_ship_consodata = [select id, Name, Import_Export_Quote__c, Shipment__c, Shipment__r.Name, Shipment__r.Storage_days__c, Shipment__r.Total_Volume_m3__c, Shipment__r.Total_Weight_Kg__c, Shipment__r.Storage_Date_From__c, Shipment__r.Storage_Date_To__c  from Shipment_Consolidation_Data__c where Import_Export_Quote__c IN: listado_import_export_utilizadas and Import_Export_Quote__c !=: null and Shipments_Program__c !=: record.Id order by CreatedDate desc];
                            string contenedor_import_export = '';
                            for(Shipment_Consolidation_Data__c scd : query_ship_consodata)
                            {
                                if(contenedor_import_export == '' || contenedor_import_export.contains(scd.Import_Export_Quote__c) == false)
                                    listado_last_shipment_almacenes.add(scd.Shipment__r);
                                contenedor_import_export += scd.Import_Export_Quote__c;
                            }
                            
                                
                         }
                         if(listado_last_shipment_almacenes != null && listado_last_shipment_almacenes.size()>0)
                         {
                             for(Shipment__c s: listado_last_shipment_almacenes)
                             {
                                 for(Fee__c lp: lista_fee)
                                 {
                                    if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                                    {
                                        if(shipment_filter.Route__c == null || lp.Route__c== null || shipment_filter.Route__c == lp.Route__c ||(listado_ids_ruta != null && listado_ids_ruta.size()>0 && listado_ids_ruta.containsKey(lp.Route__c)== true))
                                        {
                                          if(shipment_filter.Account_for__c == lp.Account_for__c || shipment_filter.Account_for__c == null)
                                          {
                                            /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                                if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                                   continue;
                                      
                                            if(lp.Applicable_to_Sales_Incoterms__c != null)
                                                  if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                                       continue;*/
                                            
                                            if(shipment_filter.Container_Type__c != null)
                                                if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                                        continue;
                                                        
                                             if(lp.Carrier_Account__c != null && shipment_filter != null)
                                                  if(shipment_filter.Carrier__c != null && lp.Carrier_Account__c != shipment_filter.Carrier__c)
                                                    continue;     
                                             
                                             if(shipment_filter.Account_for__c != null)
                                                if(shipment_filter.Account_for__c != lp.Account_for__c && shipment_filter.Account_for__c != null)
                                                    continue;  
                            
                                           /* if(record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                              if(record.Total_Gross_Volume_m3__c > lp.Max_M3__c)
                                                  continue;
                                                  
                                            if(record.Total_Gross_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                              if(record.Total_Gross_Weight_Kg__c > lp.Max_Kgs__c)
                                                  continue; */
                                                  
                                                  
                                            if(lp.Rate_Type__c == 'Per Kg')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c : 1);
                                                weight_vol_factor = (record.Total_Gross_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                                if(weight_vol_factor > unidades_calculadas)
                                                    unidades_calculadas = weight_vol_factor; 
                                            }
                                            if(lp.Rate_Type__c == 'Per TON')
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/1000 : 1);
                                            if(lp.Rate_Type__c == 'Per M3')
                                            {
                                                 unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c : 1);
                                                 weight_vol_factor = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                                 if(weight_vol_factor > unidades_calculadas)
                                                     unidades_calculadas = weight_vol_factor; 
                                            }
                                            if(lp.Rate_Type__c == 'Per Container')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                                unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                               if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                               
                                            }
                                            if(lp.Rate_Type__c == 'Per W/M')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                                weight_vol_factor = unidades_calculadas;
                                                unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 ? record.Total_Gross_Volume_m3__c : 0);
                                                if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                            } 
                                            if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))    
                                            {
                                                unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Max_Kgs__c != null ? record.Total_Gross_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                                unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null ? record.Total_Gross_Volume_m3__c/lp.Max_M3__c  : 0);
                                                if(unidades_calculadas2 > unidades_calculadas)
                                                     unidades_calculadas = unidades_calculadas2; 
                                            }          
                                            if(lp.Rate_Type__c == 'Per Pallet')
                                            {
                                                unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                                unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                               if(unidades_calculadas2 > unidades_calculadas)
                                                   unidades_calculadas = unidades_calculadas2; 
                                               
                                            }
                                            if(lp.Rate_Type__c == 'Per Day')
                                            {
                                                if(s.Storage_days__c != null)
                                                    unidades_calculadas = s.Storage_days__c;
                                            }      
                                            
                                            
                                             unidades_calculadas = unidades_calculadas.setScale(2);
                                             Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                             Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);
                                             Shipment_Program_Line__c ship_fee_line = new Shipment_Program_Line__c();
                                             ship_fee_line.Units__c = (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.Number_of_Containers__c : unidades_calculadas);
                                             ship_fee_line.Ship_Prog_Sell_Price__c = sellrate;
                                             ship_fee_line.Discount_Charge__c  = 0;
                                             ship_fee_line.Ship_Prog_Buy_Price__c = buyrate;
                                             Fee_List_Price.add(new Ship_Prog_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.Number_of_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor, s,null, false, null));//options,lp.CurrencyIsoCode)      
                                                  
                                          }
                                        }
                                    }
                                    unidades_calculadas = 1;
                                    weight_vol_factor = 0;
                                    unidades_calculadas2 = 1;
                                 }
                             }
                         }
                         else//si no hay shipments anteriores sacar los fees normal
                         {
                            for(Fee__c lp: lista_fee)
                            {
                                if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                                {
                                    if(shipment_filter.Route__c == null || lp.Route__c== null || shipment_filter.Route__c == lp.Route__c ||(listado_ids_ruta != null && listado_ids_ruta.size()>0 && listado_ids_ruta.containsKey(lp.Route__c)== true))
                                    {
                                      if(shipment_filter.Account_for__c == lp.Account_for__c || shipment_filter.Account_for__c == null)
                                      {
                                        /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                            if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                               continue;
                                  
                                        if(lp.Applicable_to_Sales_Incoterms__c != null)
                                              if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                                   continue;*/
                                        
                                        if(shipment_filter.Container_Type__c != null)
                                            if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                                    continue;
                                                    
                                        if(lp.Carrier_Account__c != null && shipment_filter != null)
                                           if(shipment_filter.Carrier__c != null && lp.Carrier_Account__c != shipment_filter.Carrier__c)
                                                continue;  
                                                
                                        if(shipment_filter.Account_for__c != null)
                                            if(shipment_filter.Account_for__c != lp.Account_for__c && shipment_filter.Account_for__c != null)
                                                continue;      
                                        
                                        /*if(record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                          if(record.Total_Gross_Volume_m3__c > lp.Max_M3__c)
                                              continue;
                                              
                                        if(record.Total_Gross_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                          if(record.Total_Gross_Weight_Kg__c > lp.Max_Kgs__c)
                                              continue; */
                                        
                                         if(lp.Rate_Type__c == 'Per Kg')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c : 1);
                                            weight_vol_factor = (record.Total_Gross_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                            if(weight_vol_factor > unidades_calculadas)
                                                unidades_calculadas = weight_vol_factor; 
                                        }
                                        if(lp.Rate_Type__c == 'Per TON')
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/1000 : 1);
                                        if(lp.Rate_Type__c == 'Per M3')
                                        {
                                             unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c : 1);
                                             weight_vol_factor = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                             if(weight_vol_factor > unidades_calculadas)
                                                 unidades_calculadas = weight_vol_factor; 
                                        }
                                        if(lp.Rate_Type__c == 'Per Container')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                            unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                           if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                           
                                        }
                                        if(lp.Rate_Type__c == 'Per W/M')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Gross_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                            weight_vol_factor = unidades_calculadas;
                                            unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 ? record.Total_Gross_Volume_m3__c : 0);
                                            if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                        } 
                                        if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))    
                                        {
                                            unidades_calculadas = (record.Total_Gross_Weight_Kg__c > 0 && lp.Max_Kgs__c != null ? record.Total_Gross_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                            unidades_calculadas2 = (record.Total_Gross_Volume_m3__c > 0 && lp.Max_M3__c != null ? record.Total_Gross_Volume_m3__c/lp.Max_M3__c  : 0);
                                            if(unidades_calculadas2 > unidades_calculadas)
                                                 unidades_calculadas = unidades_calculadas2; 
                                        }          
                                        if(lp.Rate_Type__c == 'Per Pallet')
                                        {
                                            unidades_calculadas = (record.Total_Gross_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Gross_Volume_m3__c /lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                            unidades_calculadas2 = (record.Total_Gross_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Gross_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                           if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                           
                                        }
                                        
                                         unidades_calculadas = unidades_calculadas.setScale(2);
                                         Decimal buyrate=(lp.Buy_rate__c == null ? 0 : lp.Buy_rate__c);
                                         Decimal sellrate=(lp.Fee_Rate__c == null ? 0 : lp.Fee_Rate__c); 
                                         Shipment_Program_Line__c ship_fee_line = new Shipment_Program_Line__c();
                                         ship_fee_line.Units__c = (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.Number_of_Containers__c : unidades_calculadas);
                                         ship_fee_line.Ship_Prog_Sell_Price__c = sellrate;
                                         ship_fee_line.Discount_Charge__c  = 0;
                                         ship_fee_line.Ship_Prog_Buy_Price__c = buyrate;
                                         Fee_List_Price.add(new Ship_Prog_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.Number_of_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.Number_of_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor, null,null, false, null));//options,lp.CurrencyIsoCode)      
                                              
                                      }
                                    }
                                }
                                unidades_calculadas = 1;
                                weight_vol_factor = 0;
                                unidades_calculadas2 = 1;
                             }
                         }
                    }
                }
                return Fee_List_Price;
    
        }
        
        //clase nuevo objeto
        public class Ship_Prog_Fee_Line_s implements Comparable
        {
            public Fee__c line {get; set;}
            public Shipment_Program_Line__c ship_fee_line {get; set;}
            public Shipment_Fee_Line__c ship_line {get; set;}
            public boolean selected {get; set;}
            public String extensionfeename {get; set;}
            public String units {get; set;}
            public String sellprice {get; set;}
            public String discount {get; set;}
            public String buyprice {get; set;}
            public List<SelectOption> currencys {get; set;}
            public String currency_user {get; set;}
            public String total_sell{get; set;}
            public String total_buy{get; set;}
            private NEU_Allocate_Costs_to_Ship_Service_Lines  parent;
            public string weight_factor{get; set;}
            public Shipment__c ship {get; set;}
            public boolean existe{get; set;}
            public Customer_Quote__c import_export {get; set;}
            
            public Ship_Prog_Fee_Line_s(Fee__c line, Shipment_Program_Line__c ship_fee_line, boolean selected, String extensionfeename, String units, String sellprice, String discount, String buyprice, List<SelectOption> currencys, String currency_user, NEU_Allocate_Costs_to_Ship_Service_Lines  parent, Decimal weight_factor, Shipment__c ship, Customer_Quote__c import_export, boolean existe, Shipment_Fee_Line__c ship_line)
            {
                this.line=line;
                this.ship_fee_line=ship_fee_line;
                this.selected=selected;
                this.extensionfeename=extensionfeename;
                this.units=units;
                this.sellprice=sellprice;
                this.discount=discount;
                this.buyprice=buyprice;
                this.currencys = currencys;
                this.currency_user = currency_user;
                this.ship = ship;
                this.import_export = import_export;
                this.parent = parent;
                this.ship_line = ship_line;
                this.existe = existe;
                this.weight_factor=((weight_factor+0.001)).format();
                this.weight_factor = this.weight_factor.substring(0,this.weight_factor.length()-1);
                //this.weight_factor = weight_factor.format();
            }
            
            public Integer compareTo(Object compareTo) 
            {
                Ship_Prog_Fee_Line_s compareToEmp = (Ship_Prog_Fee_Line_s)compareTo;
                
                if(parent.orden_fees_filtro  == 'line.Name')
                {
                    if (line.Name  == compareToEmp.line.Name) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Name < compareToEmp.line.Name) return 1;
                    }
                    else
                    {
                        if (line.Name > compareToEmp.line.Name) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Valid_Until__c')
                {
                    if (line.Valid_Until__c  == compareToEmp.line.Valid_Until__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Valid_Until__c < compareToEmp.line.Valid_Until__c) return 1;
                    }
                    else
                    {
                        if (line.Valid_Until__c > compareToEmp.line.Valid_Until__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'import_export.Name')
                {
                    if (import_export.Name  == compareToEmp.import_export.Name) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (import_export.Name < compareToEmp.import_export.Name) return 1;
                    }
                    else
                    {
                        if (import_export.Name > compareToEmp.import_export.Name) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Route__r.Name')
                {
                    if (line.Route__r.Name  == compareToEmp.line.Route__r.Name) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Route__r.Name < compareToEmp.line.Route__r.Name) return 1;
                    }
                    else
                    {
                        if (line.Route__r.Name > compareToEmp.line.Route__r.Name) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'ship.Name')
                {
                    if (ship.Name  == compareToEmp.ship.Name) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship.Name < compareToEmp.ship.Name) return 1;
                    }
                    else
                    {
                        if (ship.Name > compareToEmp.ship.Name) return 1;
                    }
                }
                
                 else if(parent.orden_fees_filtro  == 'ship.Total_Weight_Kg__c')
                {
                    if (ship.Total_Weight_Kg__c  == compareToEmp.ship.Total_Weight_Kg__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship.Total_Weight_Kg__c < compareToEmp.ship.Total_Weight_Kg__c) return 1;
                    }
                    else
                    {
                        if (ship.Total_Weight_Kg__c > compareToEmp.ship.Total_Weight_Kg__c) return 1;
                    }
                }
                
                 else if(parent.orden_fees_filtro  == 'ship.Total_Volume_m3__c')
                {
                    if (ship.Total_Volume_m3__c  == compareToEmp.ship.Total_Volume_m3__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship.Total_Volume_m3__c < compareToEmp.ship.Total_Volume_m3__c) return 1;
                    }
                    else
                    {
                        if (ship.Total_Volume_m3__c > compareToEmp.ship.Total_Volume_m3__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'ship.Storage_Date_From__c')
                {
                    if (ship.Storage_Date_From__c  == compareToEmp.ship.Storage_Date_From__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship.Storage_Date_From__c < compareToEmp.ship.Storage_Date_From__c) return 1;
                    }
                    else
                    {
                        if (ship.Storage_Date_From__c > compareToEmp.ship.Storage_Date_From__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'ship.Storage_Date_To__c')
                {
                    if (ship.Storage_Date_To__c  == compareToEmp.ship.Storage_Date_To__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship.Storage_Date_To__c < compareToEmp.ship.Storage_Date_To__c) return 1;
                    }
                    else
                    {
                        if (ship.Storage_Date_To__c > compareToEmp.ship.Storage_Date_To__c) return 1;
                    }
                }
                
                 else if(parent.orden_fees_filtro  == 'weight_factor')
                {
                    if (weight_factor  == compareToEmp.weight_factor) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (weight_factor < compareToEmp.weight_factor) return 1;
                    }
                    else
                    {
                        if (weight_factor > compareToEmp.weight_factor) return 1;
                    }
                }
                
                 else if(parent.orden_fees_filtro  == 'total_sell')
                {
                    if (total_sell  == compareToEmp.total_sell) return 0;
                    if(total_sell == null || total_sell == '') return 1;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (NEU_Utils.toDecimal(total_sell) < NEU_Utils.toDecimal(compareToEmp.total_sell)) return 1;
                    }
                    else
                    {
                        if (NEU_Utils.toDecimal(total_sell) > NEU_Utils.toDecimal(compareToEmp.total_sell)) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'total_buy')
                {
                    if (total_buy  == compareToEmp.total_buy) return 0;
                    if(total_buy == null || total_buy == '') return 1;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (NEU_Utils.toDecimal(total_buy) < NEU_Utils.toDecimal(compareToEmp.total_buy)) return 1;
                    }
                    else
                    {
                        if (NEU_Utils.toDecimal(total_buy) > NEU_Utils.toDecimal(compareToEmp.total_buy)) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Account_for__c')
                {
                    if (line.Account_for__c == compareToEmp.line.Account_for__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Account_for__c < compareToEmp.line.Account_for__c) return 1;
                    }
                    else
                    {
                        if (line.Account_for__c > compareToEmp.line.Account_for__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Carrier_Account__c')
                {
                    if (line.Carrier_Account__c == compareToEmp.line.Carrier_Account__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Carrier_Account__c < compareToEmp.line.Carrier_Account__c) return 1;
                    }
                    else
                    {
                        if (line.Carrier_Account__c > compareToEmp.line.Carrier_Account__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Delivery_Zone__c')
                {
                    if (line.Delivery_Zone__c == compareToEmp.line.Delivery_Zone__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Delivery_Zone__c < compareToEmp.line.Delivery_Zone__c) return 1;
                    }
                    else
                    {
                        if (line.Delivery_Zone__c > compareToEmp.line.Delivery_Zone__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Port_Airport__c')
                {
                    if (line.Port_Airport__c == compareToEmp.line.Port_Airport__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Port_Airport__c < compareToEmp.line.Port_Airport__c) return 1;
                    }
                    else
                    {
                        if (line.Port_Airport__c > compareToEmp.line.Port_Airport__c) return 1;
                    }
                }
                    
                else if(parent.orden_fees_filtro  == 'line.TT_Days__c')
                {
                    if (line.TT_Days__c == compareToEmp.line.TT_Days__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.TT_Days__c < compareToEmp.line.TT_Days__c) return 1;
                    }
                    else
                    {
                        if (line.TT_Days__c > compareToEmp.line.TT_Days__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Rate_Type__c')
                {
                    if (line.Rate_Type__c == compareToEmp.line.Rate_Type__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Rate_Type__c < compareToEmp.line.Rate_Type__c) return 1;
                    }
                    else
                    {
                        if (line.Rate_Type__c > compareToEmp.line.Rate_Type__c) return 1;
                    }

                }
                
                else if(parent.orden_fees_filtro  == 'line.Fee_Rate__c')
                {
                    if (line.Fee_Rate__c== compareToEmp.line.Fee_Rate__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Fee_Rate__c < compareToEmp.line.Fee_Rate__c) return 1;
                        if(line.Fee_Rate__c == null) return 1;
                    }
                    else
                    {
                        if (line.Fee_Rate__c > compareToEmp.line.Fee_Rate__c) return 1;
                        if(line.Fee_Rate__c == null) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Container_Type__c')
                {
                    if (line.Container_Type__c == compareToEmp.line.Container_Type__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Container_Type__c < compareToEmp.line.Container_Type__c) return 1;
                    }
                    else
                    {
                        if (line.Container_Type__c > compareToEmp.line.Container_Type__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Pallet_Type__c')
                {
                    if (line.Pallet_Type__c == compareToEmp.line.Pallet_Type__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Pallet_Type__c < compareToEmp.line.Pallet_Type__c) return 1;
                    }
                    else
                    {
                        if (line.Pallet_Type__c > compareToEmp.line.Pallet_Type__c) return 1;
                    }
                }
                
                 else if(parent.orden_fees_filtro  == 'line.Min__c')
                {
                    if (line.Min__c == compareToEmp.line.Min__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Min__c < compareToEmp.line.Min__c) return 1;
                    }
                    else
                    {
                        if (line.Min__c > compareToEmp.line.Min__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Max_M3__c')
                {
                    if (line.Max_M3__c == compareToEmp.line.Max_M3__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Max_M3__c < compareToEmp.line.Max_M3__c) return 1;
                    }
                    else
                    {
                        if (line.Max_M3__c > compareToEmp.line.Max_M3__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Max_Kgs__c')
                {
                    if (line.Max_Kgs__c == compareToEmp.line.Max_Kgs__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Max_Kgs__c < compareToEmp.line.Max_Kgs__c) return 1;
                    }
                    else
                    {
                        if (line.Max_Kgs__c > compareToEmp.line.Max_Kgs__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Buy_Rate__c')
                {
                    if (line.Buy_Rate__c == compareToEmp.line.Buy_Rate__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Buy_Rate__c < compareToEmp.line.Buy_Rate__c) return 1;
                    }
                    else
                    {
                        if (line.Buy_Rate__c > compareToEmp.line.Buy_Rate__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'line.Volumetric_Factor__c')
                {
                    if (line.Volumetric_Factor__c == compareToEmp.line.Volumetric_Factor__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (line.Volumetric_Factor__c < compareToEmp.line.Volumetric_Factor__c) return 1;
                    }
                    else
                    {
                        if (line.Volumetric_Factor__c > compareToEmp.line.Volumetric_Factor__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'ship_fee_line.Units__c')
                {
                    if (ship_fee_line.Units__c == compareToEmp.ship_fee_line.Units__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship_fee_line.Units__c < compareToEmp.ship_fee_line.Units__c) return 1;
                    }
                    else
                    {
                        if (ship_fee_line.Units__c > compareToEmp.ship_fee_line.Units__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'ship_fee_line.Ship_Prog_Sell_Price__c')
                {
                    if (ship_fee_line.Ship_Prog_Sell_Price__c == compareToEmp.ship_fee_line.Ship_Prog_Sell_Price__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship_fee_line.Ship_Prog_Sell_Price__c < compareToEmp.ship_fee_line.Ship_Prog_Sell_Price__c) return 1;
                    }
                    else
                    {
                        if (ship_fee_line.Ship_Prog_Sell_Price__c > compareToEmp.ship_fee_line.Ship_Prog_Sell_Price__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'ship_fee_line.Discount_Charge__c')
                {
                    if (ship_fee_line.Discount_Charge__c == compareToEmp.ship_fee_line.Discount_Charge__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship_fee_line.Discount_Charge__c < compareToEmp.ship_fee_line.Discount_Charge__c) return 1;
                    }
                    else
                    {
                        if (ship_fee_line.Discount_Charge__c > compareToEmp.ship_fee_line.Discount_Charge__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro  == 'ship_fee_line.Ship_Prog_Buy_Price__c')
                {
                    if (ship_fee_line.Ship_Prog_Buy_Price__c == compareToEmp.ship_fee_line.Ship_Prog_Buy_Price__c) return 0;
                    if(parent.orden_fees_filtro_modo == 'asc')
                    {
                        if (ship_fee_line.Ship_Prog_Buy_Price__c < compareToEmp.ship_fee_line.Ship_Prog_Buy_Price__c) return 1;
                    }
                    else
                    {
                        if (ship_fee_line.Ship_Prog_Buy_Price__c > compareToEmp.ship_fee_line.Ship_Prog_Buy_Price__c) return 1;
                    }
                }
                
                return -1;  
            }
            
        }   
        
        //clase nuevo objeto
        public class Ship_fee_lines_import_export_s 
        {
            public Location__c site_of_load{get; set;}
            public Location__c site_of_discharge{get; set;}
            public List<Lineas_fees_s> list_fees {get; set;}
            
            public Ship_fee_lines_import_export_s(Location__c site_of_load, Location__c site_of_discharge, List<Lineas_fees_s> list_fees)
            {
                this.site_of_load=site_of_load;
                this.site_of_discharge=site_of_discharge;
                this.list_fees=list_fees;
            }
        }
        
        //clase nuevo objeto
        public class Shipment_Program_Line_s implements Comparable
        {
            public Shipment_Program_Line__c ship_prog_line{get; set;}
            public Shipment__c ship{get; set;}
            private NEU_Allocate_Costs_to_Ship_Service_Lines parent;
            public Shipment_Program_Line_s(Shipment_Program_Line__c ship_prog_line, Shipment__c ship, NEU_Allocate_Costs_to_Ship_Service_Lines parent)
            {
                this.ship_prog_line=ship_prog_line;
                this.ship=ship;
                this.parent=parent;

            }
            
            public string getBuy_amount_convert()
              {
                string Buy_amount_convert = '';
                if(ship_prog_line != null)
                {
                    if(neu_currencyutils.getCurrencyIsoCode(ship_prog_line.Shipments_Program__r) != neu_currencyutils.getCurrencyIsoCode(ship_prog_line))
                    {
                      Buy_amount_convert = neu_currencyutils.getCurrencyIsoCode(ship_prog_line)+' '+ship_prog_line.Buy_Amount__c.format()+' ('+ neu_currencyutils.getCurrencyIsoCode(ship_prog_line.Shipments_Program__r)+' '+neu_utils.safedecimal(ship_prog_line.Std_Buy_Amount_header_currency__c).format()+')';
                    }
                    else
                      Buy_amount_convert = neu_currencyutils.getCurrencyIsoCode(ship_prog_line.Shipments_Program__r)+' '+neu_utils.safedecimal(ship_prog_line.Buy_Amount__c).format();
                }
                  return Buy_amount_convert;
              }
              
            
            public Integer compareTo(Object compareTo) 
            {
                Shipment_Program_Line_s compareToEmp = (Shipment_Program_Line_s)compareTo;
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Name')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Name   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Name   < compareToEmp.ship_prog_line.Service_Rate_Name__r.Name ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Name   > compareToEmp.ship_prog_line.Service_Rate_Name__r.Name ) return 1;
                    }
                }
                
                 if(parent.orden_fees_filtro_insertados  == 'ship.Name')
                {
                    if (ship.Name   == compareToEmp.ship.Name ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship.Name  < compareToEmp.ship.Name ) return 1;
                    }
                    else
                    {
                        if (ship.Name   > compareToEmp.ship.Name ) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship.Total_Weight_Kg__c')
                {
                    if (ship.Total_Weight_Kg__c   == compareToEmp.ship.Total_Weight_Kg__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship.Total_Weight_Kg__c  < compareToEmp.ship.Total_Weight_Kg__c ) return 1;
                    }
                    else
                    {
                        if (ship.Total_Weight_Kg__c   > compareToEmp.ship.Total_Weight_Kg__c ) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship.Storage_Date_From__c')
                {
                    if (ship.Storage_Date_From__c   == compareToEmp.ship.Storage_Date_From__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship.Storage_Date_From__c  < compareToEmp.ship.Storage_Date_From__c ) return 1;
                    }
                    else
                    {
                        if (ship.Storage_Date_From__c   > compareToEmp.ship.Storage_Date_From__c ) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship.Storage_Date_To__c')
                {
                    if (ship.Storage_Date_To__c   == compareToEmp.ship.Storage_Date_To__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship.Storage_Date_To__c  < compareToEmp.ship.Storage_Date_To__c ) return 1;
                    }
                    else
                    {
                        if (ship.Storage_Date_To__c   > compareToEmp.ship.Storage_Date_To__c ) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship.Total_Volume_m3__c')
                {
                    if (ship.Total_Volume_m3__c   == compareToEmp.ship.Total_Volume_m3__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship.Total_Volume_m3__c  < compareToEmp.ship.Total_Volume_m3__c ) return 1;
                    }
                    else
                    {
                        if (ship.Total_Volume_m3__c   > compareToEmp.ship.Total_Volume_m3__c ) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Route__r.Name')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Route__r.Name   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Route__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Route__r.Name   < compareToEmp.ship_prog_line.Service_Rate_Name__r.Route__r.Name ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Route__r.Name   > compareToEmp.ship_prog_line.Service_Rate_Name__r.Route__r.Name) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Valid_Until__c')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Valid_Until__c   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Valid_Until__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Valid_Until__c   < compareToEmp.ship_prog_line.Service_Rate_Name__r.Valid_Until__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Valid_Until__c   > compareToEmp.ship_prog_line.Service_Rate_Name__r.Valid_Until__c) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Account_for__r.Name')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Account_for__r.Name   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Account_for__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Account_for__r.Name  < compareToEmp.ship_prog_line.Service_Rate_Name__r.Account_for__r.Name ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Account_for__r.Name  > compareToEmp.ship_prog_line.Service_Rate_Name__r.Account_for__r.Name) return 1;
                    }
                }
                
                 if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Carrier_Account__r.Name')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Carrier_Account__r.Name   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Carrier_Account__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Carrier_Account__r.Name  < compareToEmp.ship_prog_line.Service_Rate_Name__r.Carrier_Account__r.Name ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Carrier_Account__r.Name  > compareToEmp.ship_prog_line.Service_Rate_Name__r.Carrier_Account__r.Name) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Delivery_Zone__c')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Delivery_Zone__c   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Delivery_Zone__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Delivery_Zone__c  < compareToEmp.ship_prog_line.Service_Rate_Name__r.Delivery_Zone__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Delivery_Zone__c  > compareToEmp.ship_prog_line.Service_Rate_Name__r.Delivery_Zone__c) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.TT_Days__c')
                {
                    if (ship_prog_line.Service_Rate_Name__r.TT_Days__c   == compareToEmp.ship_prog_line.Service_Rate_Name__r.TT_Days__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.TT_Days__c  < compareToEmp.ship_prog_line.Service_Rate_Name__r.TT_Days__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.TT_Days__c  > compareToEmp.ship_prog_line.Service_Rate_Name__r.TT_Days__c) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Rate_Type__c')
                {
                    if (ship_prog_line.Rate_Type__c  == compareToEmp.ship_prog_line.Rate_Type__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Rate_Type__c  < compareToEmp.ship_prog_line.Rate_Type__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Rate_Type__c  > compareToEmp.ship_prog_line.Rate_Type__c) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Fee__c')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Fee__c   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Fee__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Fee__c  < compareToEmp.ship_prog_line.Service_Rate_Name__r.Fee__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Fee__c  > compareToEmp.ship_prog_line.Service_Rate_Name__r.Fee__c) return 1;
                    }
                }
                
                 if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Service_Rate_Name__r.Container_Type__c')
                {
                    if (ship_prog_line.Service_Rate_Name__r.Container_Type__c   == compareToEmp.ship_prog_line.Service_Rate_Name__r.Container_Type__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Container_Type__c  < compareToEmp.ship_prog_line.Service_Rate_Name__r.Container_Type__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Service_Rate_Name__r.Container_Type__c  > compareToEmp.ship_prog_line.Service_Rate_Name__r.Container_Type__c) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Units__c')
                {
                    if (ship_prog_line.Units__c  == compareToEmp.ship_prog_line.Units__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Units__c < compareToEmp.ship_prog_line.Units__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Units__c > compareToEmp.ship_prog_line.Units__c) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Ship_Prog_Sell_Price__c')
                {
                    if (ship_prog_line.Ship_Prog_Sell_Price__c  == compareToEmp.ship_prog_line.Ship_Prog_Sell_Price__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Ship_Prog_Sell_Price__c < compareToEmp.ship_prog_line.Ship_Prog_Sell_Price__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Ship_Prog_Sell_Price__c > compareToEmp.ship_prog_line.Ship_Prog_Sell_Price__c) return 1;
                    }
                }
                
                 if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Discount_Charge__c')
                {
                    if (ship_prog_line.Discount_Charge__c  == compareToEmp.ship_prog_line.Discount_Charge__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Discount_Charge__c < compareToEmp.ship_prog_line.Discount_Charge__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Discount_Charge__c > compareToEmp.ship_prog_line.Discount_Charge__c) return 1;
                    }
                }
                
                if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Sell_Amount__c')
                {
                    if (ship_prog_line.Sell_Amount__c  == compareToEmp.ship_prog_line.Sell_Amount__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Sell_Amount__c < compareToEmp.ship_prog_line.Sell_Amount__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Sell_Amount__c > compareToEmp.ship_prog_line.Sell_Amount__c) return 1;
                    }
                }
                
                 if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Ship_Prog_Buy_Price__c')
                {
                    if (ship_prog_line.Ship_Prog_Buy_Price__c  == compareToEmp.ship_prog_line.Ship_Prog_Buy_Price__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Ship_Prog_Buy_Price__c < compareToEmp.ship_prog_line.Ship_Prog_Buy_Price__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Ship_Prog_Buy_Price__c > compareToEmp.ship_prog_line.Ship_Prog_Buy_Price__c) return 1;
                    }
                }
                
                 if(parent.orden_fees_filtro_insertados  == 'ship_prog_line.Buy_Amount__c')
                {
                    if (ship_prog_line.Buy_Amount__c  == compareToEmp.ship_prog_line.Buy_Amount__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados == 'asc')
                    {
                        if (ship_prog_line.Buy_Amount__c < compareToEmp.ship_prog_line.Buy_Amount__c ) return 1;
                    }
                    else
                    {
                        if (ship_prog_line.Buy_Amount__c > compareToEmp.ship_prog_line.Buy_Amount__c) return 1;
                    }
                }
                
                
                
                return -1;
            }
                
            
        }
         
         //clase nuevo objeto
        public class Lineas_fees_s implements Comparable
        {
            public Shipment__c shipment{get; set;}
            public Import_Export_Fee_Line__c IE_fee_line{get; set;}
            public boolean selected{get; set;}
            public string buy_amount{get; set;}
            public String selected_shipment_program_line {get; set;}
            public List<SelectOption> shipment_program_lines {get; set;}
            public boolean ya_creado {get; set;}
            public string nombre_linea_relacionada {get; set;}
            public string id_shipment_program{get; set;}
            private NEU_Allocate_Costs_to_Ship_Service_Lines parent;
            public Lineas_fees_s(NEU_Allocate_Costs_to_Ship_Service_Lines parent, Shipment__c shipment, Import_Export_Fee_Line__c IE_fee_line, boolean selected, decimal buy_amount, String selected_shipment_program_line, List<SelectOption> shipment_program_lines, boolean ya_creado, string nombre_linea_relacionada, string id_shipment_program)
            {
                this.shipment=shipment;
                this.IE_fee_line=IE_fee_line;
                this.selected=selected;
                this.buy_amount= ((buy_amount+0.001)).format();
                this.buy_amount = this.buy_amount.substring(0,this.buy_amount.length()-1);
                this.selected_shipment_program_line=selected_shipment_program_line;
                this.shipment_program_lines=shipment_program_lines;
                this.ya_creado=ya_creado;
                this.nombre_linea_relacionada=nombre_linea_relacionada;
                this.id_shipment_program=id_shipment_program;
                this.parent=parent;
            }
            
            public Integer compareTo(Object compareTo) 
            {
                Lineas_fees_s compareToEmp = (Lineas_fees_s)compareTo;
                
                if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Units__c')
                {
                    if (IE_fee_line.Units__c   == compareToEmp.IE_fee_line.Units__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Units__c   < compareToEmp.IE_fee_line.Units__c ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Units__c   > compareToEmp.IE_fee_line.Units__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Quote_Sell_Price__c')
                {
                    
                    if (IE_fee_line.Quote_Sell_Price__c   == compareToEmp.IE_fee_line.Quote_Sell_Price__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Quote_Sell_Price__c   < compareToEmp.IE_fee_line.Quote_Sell_Price__c ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Quote_Sell_Price__c   > compareToEmp.IE_fee_line.Quote_Sell_Price__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Import_Export_Quote__r.Name')
                {
                    
                    if (IE_fee_line.Import_Export_Quote__r.Name   == compareToEmp.IE_fee_line.Import_Export_Quote__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Name   < compareToEmp.IE_fee_line.Import_Export_Quote__r.Name ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Name   > compareToEmp.IE_fee_line.Import_Export_Quote__r.Name ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Import_Export_Quote__r.Account_for__r.Name')
                {
                    
                    if (IE_fee_line.Import_Export_Quote__r.Account_for__r.Name   == compareToEmp.IE_fee_line.Import_Export_Quote__r.Account_for__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Account_for__r.Name   < compareToEmp.IE_fee_line.Import_Export_Quote__r.Account_for__r.Name ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Account_for__r.Name   > compareToEmp.IE_fee_line.Import_Export_Quote__r.Account_for__r.Name ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name')
                {
                    
                    if (IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name   == compareToEmp.IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name   < compareToEmp.IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name   > compareToEmp.IE_fee_line.Import_Export_Quote__r.Supplier_Account__r.Name ) return 1;
                    }
                }
                
                 else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Import_Export_Quote__r.Consignee__r.Name')
                {
                    
                    if (IE_fee_line.Import_Export_Quote__r.Consignee__r.Name   == compareToEmp.IE_fee_line.Import_Export_Quote__r.Consignee__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Consignee__r.Name   < compareToEmp.IE_fee_line.Import_Export_Quote__r.Consignee__r.Name ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Import_Export_Quote__r.Consignee__r.Name   > compareToEmp.IE_fee_line.Import_Export_Quote__r.Consignee__r.Name ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Route__r.Name')
                {
                    
                    if (IE_fee_line.Service_Rate_Name__r.Route__r.Name   == compareToEmp.IE_fee_line.Service_Rate_Name__r.Route__r.Name  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Route__r.Name   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Route__r.Name ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Route__r.Name   > compareToEmp.IE_fee_line.Service_Rate_Name__r.Route__r.Name ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Discount__c')
                {   
                    if (IE_fee_line.Discount__c   == compareToEmp.IE_fee_line.Discount__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Discount__c   < compareToEmp.IE_fee_line.Discount__c ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Discount__c   > compareToEmp.IE_fee_line.Discount__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Sell_Amount__c')
                {
                        
                    if (IE_fee_line.Sell_Amount__c   == compareToEmp.IE_fee_line.Sell_Amount__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Sell_Amount__c   < compareToEmp.IE_fee_line.Sell_Amount__c ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Sell_Amount__c   > compareToEmp.IE_fee_line.Sell_Amount__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Quote_Buy_Price__c')
                {   
                    if (IE_fee_line.Quote_Buy_Price__c   == compareToEmp.IE_fee_line.Quote_Buy_Price__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Quote_Buy_Price__c   < compareToEmp.IE_fee_line.Quote_Buy_Price__c ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Quote_Buy_Price__c   > compareToEmp.IE_fee_line.Quote_Buy_Price__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'buy_amount')
                {   
                    if (buy_amount   == compareToEmp.buy_amount  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (buy_amount   < compareToEmp.buy_amount ) return 1;
                    }
                    else
                    {
                        if (buy_amount   > compareToEmp.buy_amount ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Container_Type__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Container_Type__c   == compareToEmp.IE_fee_line.Service_Rate_Name__r.Container_Type__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Container_Type__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Container_Type__c ) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Container_Type__c   > compareToEmp.IE_fee_line.Service_Rate_Name__r.Container_Type__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'shipment.Total_Weight_Kg__c')
                {   
                    if (shipment.Total_Weight_Kg__c   == compareToEmp.shipment.Total_Weight_Kg__c  ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (shipment.Total_Weight_Kg__c   < compareToEmp.shipment.Total_Weight_Kg__c ) return 1;
                    }
                    else
                    {
                        if (shipment.Total_Weight_Kg__c   > compareToEmp.shipment.Total_Weight_Kg__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'shipment.Total_Volume_m3__c')
                {   
                    if (shipment.Total_Volume_m3__c   == compareToEmp.shipment.Total_Volume_m3__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (shipment.Total_Volume_m3__c   < compareToEmp.shipment.Total_Volume_m3__c) return 1;
                    }
                    else
                    {
                        if (shipment.Total_Volume_m3__c   > compareToEmp.shipment.Total_Volume_m3__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Fee__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Fee__c  == compareToEmp.IE_fee_line.Service_Rate_Name__r.Fee__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Fee__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Fee__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Fee__c   > compareToEmp.IE_fee_line.Service_Rate_Name__r.Fee__c ) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Sell_Rate__c')
                {   
                    if (IE_fee_line.Sell_Rate__c  == compareToEmp.IE_fee_line.Sell_Rate__c ) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Sell_Rate__c   < compareToEmp.IE_fee_line.Sell_Rate__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Sell_Rate__c   > compareToEmp.IE_fee_line.Sell_Rate__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Rate_Type__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Rate_Type__c  == compareToEmp.IE_fee_line.Service_Rate_Name__r.Rate_Type__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Rate_Type__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Rate_Type__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Rate_Type__c   > compareToEmp.IE_fee_line.Service_Rate_Name__r.Rate_Type__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.TT_Days__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.TT_Days__c  == compareToEmp.IE_fee_line.Service_Rate_Name__r.TT_Days__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.TT_Days__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.TT_Days__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.TT_Days__c   > compareToEmp.IE_fee_line.Service_Rate_Name__r.TT_Days__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Carrier_Account__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Carrier_Account__c  == compareToEmp.IE_fee_line.Service_Rate_Name__r.Carrier_Account__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Carrier_Account__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Carrier_Account__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Carrier_Account__c > compareToEmp.IE_fee_line.Service_Rate_Name__r.Carrier_Account__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Port_Airport__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Port_Airport__c == compareToEmp.IE_fee_line.Service_Rate_Name__r.Port_Airport__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Port_Airport__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Port_Airport__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Port_Airport__c > compareToEmp.IE_fee_line.Service_Rate_Name__r.Port_Airport__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c == compareToEmp.IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c > compareToEmp.IE_fee_line.Service_Rate_Name__r.Delivery_Zone__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Carrier_Account__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Carrier_Account__c == compareToEmp.IE_fee_line.Service_Rate_Name__r.Carrier_Account__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Carrier_Account__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Carrier_Account__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Carrier_Account__c > compareToEmp.IE_fee_line.Service_Rate_Name__r.Carrier_Account__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__c == compareToEmp.IE_fee_line.Service_Rate_Name__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__c   < compareToEmp.IE_fee_line.Service_Rate_Name__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__c > compareToEmp.IE_fee_line.Service_Rate_Name__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'IE_fee_line.Service_Rate_Name__r.Fee_Category__c')
                {   
                    if (IE_fee_line.Service_Rate_Name__r.Fee_Category__c == compareToEmp.IE_fee_line.Service_Rate_Name__r.Fee_Category__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Fee_Category__c   < compareToEmp.IE_fee_line.Service_Rate_Name__r.Fee_Category__c) return 1;
                    }
                    else
                    {
                        if (IE_fee_line.Service_Rate_Name__r.Fee_Category__c > compareToEmp.IE_fee_line.Service_Rate_Name__r.Fee_Category__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'shipment.Account_for__c')
                {   
                    if (shipment.Account_for__c == compareToEmp.shipment.Account_for__c) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (shipment.Account_for__c   < compareToEmp.shipment.Account_for__c) return 1;
                    }
                    else
                    {
                        if (shipment.Account_for__c > compareToEmp.shipment.Account_for__c) return 1;
                    }
                }
                
                else if(parent.orden_fees_filtro_insertados_all  == 'shipment.Name')
                {   
                    if (shipment.Name == compareToEmp.shipment.Name) return 0;
                    if(parent.orden_fees_filtro_modo_insertados_all == 'asc')
                    {
                        if (shipment.Name < compareToEmp.shipment.Name) return 1;
                    }
                    else
                    {
                        if (shipment.Name > compareToEmp.shipment.Name) return 1;
                    }
                }
                
                return -1;
            }
        }
        
        public List<Ship_fee_lines_import_export_s> getList_Fee_Shipment_Import_Export()
        {
            if(List_Fee_Shipment_Import_Export == null)
            {
                if(getnewcategory() != 'Warehouse')
                {
                    List_Fee_Shipment_Import_Export = new List<Ship_fee_lines_import_export_s>();
                    
                    //rellenar las lineas de shipment program disponibles
                    List<SelectOption> shipment_program_lines = new List<SelectOption>(); 
                    shipment_program_lines.add(new SelectOption('',''));
                    List<Shipment_Program_Line__c> listado_lineas_insertadas = null;
                    if(String.isNotEmpty(getnewcategory()))
                    {
                        listado_lineas_insertadas = [select Id, Name, Service_Rate_Name__c, Service_Rate_Name__r.Name from Shipment_Program_Line__c where Shipments_Program__c =: record.Id and Service_Rate_Name__r.Fee_Category__c =:  getnewcategory()];
                    }
                    else
                    {
                        listado_lineas_insertadas = [select Id, Name, Service_Rate_Name__c, Service_Rate_Name__r.Name from Shipment_Program_Line__c where Shipments_Program__c =: record.Id];
                    }
                    if(listado_lineas_insertadas.size()>0)
                        shipment_program_lines.add(new SelectOption('All','All '+  getnewcategory() +''));
                    
                    /*for(Shipment_Program_Line__c spl : listado_lineas_insertadas)
                    {
                        shipment_program_lines.add(new SelectOption(spl.Id,spl.Service_Rate_Name__r.Name));
                    }*/
                    
                    
                    
                    List<Shipment_Consolidation_Data__c> query_Shipment_Consolidation_Data = [select id, Name, Shipment__c, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Import_Export_Quote__c !=: null order by Shipment__c];
                    
                    //conseguir las import export relacionadas con cada shipment
                    Map<Id,Set<id>> import_export_associated =new Map<Id,Set<Id>>();
                    Set<id> listado_import_export_ids = new Set<Id>();
                    for(Shipment_Consolidation_Data__c ship: query_Shipment_Consolidation_Data)
                    {
                        if(import_export_associated.containsKey(ship.Shipment__c))
                        {
                          import_export_associated.get(ship.Shipment__c).add(ship.Import_Export_Quote__c);
                        }
                        else
                        {
                            import_export_associated.put(ship.Shipment__c, new Set<Id>{ship.Import_Export_Quote__c});
                        } 
                        
                        listado_import_export_ids.add(ship.Import_Export_Quote__c); 
                    }
                    
                    //conseguir las lineas relacionadas con cada import-export
                    Map<Id,List<Import_Export_Fee_Line__c>> import_export_service_lines_associated =new Map<Id,List<Import_Export_Fee_Line__c>>();
                    List<Import_Export_Fee_Line__c> query_import_export_service_lines = null;
                    /*if(String.isNotEmpty(getnewcategory()))
                    {
                        query_import_export_service_lines = [select id, Name, Import_Export_Quote__c, Service_Rate_Name__r.Carrier_Account__c,
                        Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Name, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Carrier_Account__r.Name, Extension_Service_Name__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Rate_Type__c,
                        Sell_Rate__c, Service_Rate_Name__r.Fee__c, Service_Rate_Name__r.Concept_1__c, Service_Rate_Name__r.Concept_2__c, Service_Rate_Name__r.Concept_3__c, Service_Rate_Name__r.Concept_4__c, Service_Rate_Name__r.Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c,
                        Quote_Buy_Price__c, Buy_Amount__c from Import_Export_Fee_Line__c where Import_Export_Quote__c IN: listado_import_export_ids and Service_Rate_Name__r.Fee_Category__c =:  getnewcategory()];
                    }
                    else 
                    {*/
                        query_import_export_service_lines = [select id, Name, Import_Export_Quote__c, Service_Rate_Name__r.Carrier_Account__c, 
                        Import_Export_Quote__r.Name, Import_Export_Quote__r.Account_for__c,  Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Supplier_Account__r.Name, Import_Export_Quote__r.Consignee__c, Import_Export_Quote__r.Consignee__r.Name,
                        Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Name, Service_Rate_Name__r.Container_Type__c,Service_Rate_Name__r.Carrier_Account__r.Name, Extension_Service_Name__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Rate_Type__c,
                        Sell_Rate__c, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Service_Rate_Name__r.Concept_1__c, Service_Rate_Name__r.Concept_2__c, Service_Rate_Name__r.Concept_3__c, Service_Rate_Name__r.Concept_4__c, Service_Rate_Name__r.Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c,
                        Quote_Buy_Price__c, Buy_Amount__c from Import_Export_Fee_Line__c where Import_Export_Quote__c IN: listado_import_export_ids];  
                    //}
                    
                    for(Import_Export_Fee_Line__c iefl : query_import_export_service_lines)
                    {
                        if(import_export_service_lines_associated.containsKey(iefl.Import_Export_Quote__c))
                        {
                            /*if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per Kg')
                            {
                                if(record.Service_Charges_Kg__c != null)
                                    iefl.Quote_Buy_Price__c =record.Service_Charges_Kg__c;
                            }
                            if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per TON')
                            {
                                if(record.Service_Charges_Kg__c != null)
                                    iefl.Quote_Buy_Price__c =record.Service_Charges_Kg__c*1000;
                            }
                            if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per M3')
                            {
                                if(record.Service_Charges_m3__c != null)
                                    iefl.Quote_Buy_Price__c =record.Service_Charges_m3__c;
                            }*/
                            
                            import_export_service_lines_associated.get(iefl.Import_Export_Quote__c).add(iefl);
                        }
                        else
                        {
                            /*if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per Kg')
                            {
                                if(record.Service_Charges_Kg__c != null)
                                    iefl.Quote_Buy_Price__c =0;
                            }
                            if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per TON')
                            {
                                if(record.Service_Charges_Kg__c != null)
                                    iefl.Quote_Buy_Price__c =0;
                            }
                            if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per M3')
                            {
                                if(record.Service_Charges_m3__c != null)
                                    iefl.Quote_Buy_Price__c =0;
                            }*/
                            
                            import_export_service_lines_associated.put(iefl.Import_Export_Quote__c, new List<Import_Export_Fee_Line__c>{iefl});
                        } 
                    }
                    
                    //consulta todos los shipments relacionados con este shipment program 
                    List<Shipment__c> query_shipment = [select Id, Name, Route__c, Route__r.Port_Airport_of_Load__c,
                    Route__r.Port_Airport_of_Load__r.Name, Supplier_Account__c , Supplier_Account__r.Name, Consignee__c, Consignee__r.Name, Account_for__r.Name, Route__r.Port_Airport_of_Discharge__c, Account_for__c , Total_Volume_m3__c,
                    Route__r.Port_Airport_of_Discharge__r.Name, Total_Weight_Kg__c, Site_of_Load__c, Site_of_Load__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name
                    from Shipment__c where Inbound_Consolidation_Program__c =: record.Id order by Route__c];
                    
                    //consulta de lineas shipment para saber cual ya se ha metido
                    Map<Id,List<string>> lineas_shipment_service_lines_includes = new Map<Id,List<string>>();
                    
                    /*List<Shipment_Fee_Line__c> query_lineas_shipment_fee_line = [select Id, Name, Import_Export_Service_Line__c, Shipment__c ,
                    Shipments_Program_Line__c from Shipment_Fee_Line__c where  Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Import_Export_Service_Line__c !=: null];
                    
                    string contenedor_de_shipments = '';
                    for(Shipment_Fee_Line__c sfl: query_lineas_shipment_fee_line)
                    {
                        if(lineas_shipment_service_lines_includes.containsKey(sfl.Import_Export_Service_Line__c))
                        {
                            contenedor_de_shipments = lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c)[lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c).size()-1];
                            contenedor_de_shipments += sfl.Shipment__c;
                            lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c).add(contenedor_de_shipments);
                        }
                        else
                        {
                            contenedor_de_shipments = '';
                            contenedor_de_shipments += sfl.Shipment__c;
                            lineas_shipment_service_lines_includes.put(sfl.Import_Export_Service_Line__c, new List<string>{contenedor_de_shipments});
                        }
                    }*/ 
                    //------------------------------------
                    List<Ship_Service_Consol__c> query_ship_service_consol = [select Id, Name, Shipments_Program_Service_Line__c, 
                    Shipment_Service_Line__r.Shipment__c, Shipments_Program_Service_Line__r.Service_Rate_Name__r.Name, Shipment_Service_Line__r.Import_Export_Service_Line__c from Ship_Service_Consol__c where Shipment_Service_Line__r.Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Shipment_Service_Line__r.Import_Export_Service_Line__c !=: null and Shipments_Program_Service_Line__r.Service_Rate_Name__r.Fee_Category__c =: getnewcategory()];
                    
                    string contenedor_de_shipments = '';
                    Set<id> listado_imp_fee_lines_insertadas = new Set<Id>();
                    for(Ship_Service_Consol__c sfl: query_ship_service_consol)
                    {
                        if(lineas_shipment_service_lines_includes.containsKey(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c))
                        {
                            contenedor_de_shipments = lineas_shipment_service_lines_includes.get(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c)[lineas_shipment_service_lines_includes.get(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c).size()-1];
                            contenedor_de_shipments += sfl.Shipment_Service_Line__r.Shipment__c;
                            lineas_shipment_service_lines_includes.get(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c).add(contenedor_de_shipments);
                        }
                        else
                        {
                            contenedor_de_shipments = '';
                            contenedor_de_shipments += sfl.Shipment_Service_Line__r.Shipment__c;
                            lineas_shipment_service_lines_includes.put(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c , new List<string>{contenedor_de_shipments});
                        }
                        
                        listado_imp_fee_lines_insertadas.add(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c);
                    }
                    //------------------------------------------
                    //bloquear los que se han pasado directamente
                    contenedor_de_shipments = '';
                    //consulta lineas existentes
                    List<Shipment_Fee_Line__c> query_lineas_shipment_fee_line = [select Id, Name, Import_Export_Service_Line__c, 
                    Shipment__c from Shipment_Fee_Line__c where  Shipment__r.Inbound_Consolidation_Program__c =: record.Id 
                    and Import_Export_Service_Line__c !=: null and Import_Export_Service_Line__c not IN: listado_imp_fee_lines_insertadas];
                    //consulta los objetos de fusion para saber que linea tiene y cual no
                    List<Ship_Service_Consol__c> query_ship_service_consol2 = [select Id, Name, Shipments_Program_Service_Line__c, 
                    Shipment_Service_Line__r.Shipment__c, Shipments_Program_Service_Line__r.Service_Rate_Name__r.Name, Shipment_Service_Line__r.Import_Export_Service_Line__c from Ship_Service_Consol__c where Shipment_Service_Line__r.Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Shipment_Service_Line__r.Import_Export_Service_Line__c !=: null order by Shipment_Service_Line__c];
                    
                    Map<Id,boolean> ids_lineas_shipment_x_ship_service_consol = new Map<Id,boolean>();
                    
                    for(Ship_Service_Consol__c sfl:query_ship_service_consol2)
                    {
                         if(ids_lineas_shipment_x_ship_service_consol.containsKey(sfl.Shipment_Service_Line__c) == false)
                        {
                            ids_lineas_shipment_x_ship_service_consol.put(sfl.Shipment_Service_Line__c , true);
                        }
                        else
                        {
                            ids_lineas_shipment_x_ship_service_consol.put(sfl.Shipment_Service_Line__c , true);
                        }
                            
                    }
                        
                    boolean encontrado = false;
                    for(Shipment_Fee_Line__c sfl :query_lineas_shipment_fee_line)
                    {
    
                        if(ids_lineas_shipment_x_ship_service_consol != null)
                            if(ids_lineas_shipment_x_ship_service_consol.containsKey(sfl.Id) == true)
                                encontrado = true;
    
                        
                        if(encontrado == false)
                        {
                            if(lineas_shipment_service_lines_includes.containsKey(sfl.Import_Export_Service_Line__c))
                            {
                                contenedor_de_shipments = lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c)[lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c).size()-1];
                                contenedor_de_shipments += sfl.Shipment__c;
                                lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c).add(contenedor_de_shipments);
                            }
                            else
                            {
                                contenedor_de_shipments = '';
                                contenedor_de_shipments += sfl.Shipment__c;
                                lineas_shipment_service_lines_includes.put(sfl.Import_Export_Service_Line__c, new List<string>{contenedor_de_shipments});
                            }
                        }
                        
                        encontrado = false;
                    }
                    
                    //-------------------------------
                    //--------------------------------
                    boolean shipments_whitout_route = false;
                    List<Shipment__c> listado_shipments_sin_route = new List<Shipment__c>();
                    string contenedor_de_ruta = '';
                    List<Lineas_fees_s> list_fees = new List<Lineas_fees_s>();
                    for(Shipment__c ship: query_shipment)
                    {
                        if(ship.Route__c != null)
                        {
                            if(contenedor_de_ruta == '' || contenedor_de_ruta.contains(ship.Route__c) == false)
                            {
                                if(List_Fee_Shipment_Import_Export != null && List_Fee_Shipment_Import_Export.size()>0)
                                    List_Fee_Shipment_Import_Export[List_Fee_Shipment_Import_Export.size()-1].list_fees = list_fees;
                                list_fees = new List<Lineas_fees_s>();
                                List_Fee_Shipment_Import_Export.add(new Ship_fee_lines_import_export_s(ship.Route__r.Port_Airport_of_Load__r, ship.Route__r.Port_Airport_of_Discharge__r, list_fees));
                            }
                        }
                        else
                        {
                            error_ruta +='The Shipment '+ship.Name+' has no route \n';
                            listado_shipments_sin_route.add(ship);
                            /*if(List_Fee_Shipment_Import_Export != null && List_Fee_Shipment_Import_Export.size()>0)
                               List_Fee_Shipment_Import_Export[List_Fee_Shipment_Import_Export.size()-1].list_fees = list_fees;
                            list_fees = new List<Lineas_fees_s>();*/
                            shipments_whitout_route = true;
                                
                        }
                        
                        string nombre_de_la_linea = '';
                        string id_shipment_program_line = '';
                        //si tengo import export de este shipment
                        if(ship.Route__c != null)
                        if(import_export_associated.containsKey(ship.Id))
                        {
                            for(Id i: import_export_associated.get(ship.Id))// de esta forma solo se recorren las que me hacen falta no todas(import export de este shipment)
                            {
                                //si de la import export relacionada tengo lineas
                                if(import_export_service_lines_associated.containsKey(i))
                                {
                                    for(Import_Export_Fee_Line__c iefl : import_export_service_lines_associated.get(i))//recorrer las lineas de cada import export
                                    {
                                        boolean ya_creado = false;
                                        nombre_de_la_linea = '';
                                        id_shipment_program_line = '';
                                        if(lineas_shipment_service_lines_includes != null)//comprobar si ya existe
                                        {
                                            if(lineas_shipment_service_lines_includes.containsKey(iefl.Id))//comprobar que coincide las import service lines con el shipment
                                            {
                                                string contenedor_shipment = lineas_shipment_service_lines_includes.get(iefl.Id)[lineas_shipment_service_lines_includes.get(iefl.Id).size()-1];
                                                if(contenedor_shipment != null && contenedor_shipment.contains(ship.Id) == true)
                                                {
                                                    ya_creado = true;
                                                    
                                                    for(Ship_Service_Consol__c sfl2 : query_ship_service_consol)
                                                    {
                                                        if(sfl2.Shipment_Service_Line__r.Import_Export_Service_Line__c == iefl.Id)
                                                        {
                                                            nombre_de_la_linea += sfl2.Shipments_Program_Service_Line__r.Service_Rate_Name__r.Name+', ';
                                                            id_shipment_program_line += sfl2.Shipments_Program_Service_Line__c+'_&_';
                                                            //break;
                                                        }
                                                    }
                                                }   
                                            }
                                        }
                                        
                                        list_fees.add(new Lineas_fees_s(this, ship, iefl , false, /*(iefl.Quote_Buy_Price__c != null && (ship.Total_Volume_m3__c != null || ship.Total_Weight_Kg__c != null) ? 
                                       /* (iefl.Service_Rate_Name__r.Rate_Type__c == 'Per M3' &&  ship.Total_Volume_m3__c != null  ? iefl.Quote_Buy_Price__c * ship.Total_Volume_m3__c : 
                                        (iefl.Service_Rate_Name__r.Rate_Type__c =='Per Kg' && ship.Total_Weight_Kg__c != null ? iefl.Quote_Buy_Price__c * ship.Total_Weight_Kg__c:
                                        (iefl.Service_Rate_Name__r.Rate_Type__c =='Per TON' && ship.Total_Weight_Kg__c != null ? iefl.Quote_Buy_Price__c * (ship.Total_Weight_Kg__c /1000):
                                        iefl.Quote_Buy_Price__c*iefl.Units__c )))
                                        : 0)*/
                                        
                                        (iefl.Quote_Buy_Price__c != null &&  iefl.Units__c != null ? iefl.Quote_Buy_Price__c*iefl.Units__c : 0)
                                        
                                        , '', shipment_program_lines, ya_creado, nombre_de_la_linea, id_shipment_program_line));
                                    }
                                }
                            }
                        }
            
                        contenedor_de_ruta += ship.Route__c;
                    }
                    
                    if(List_Fee_Shipment_Import_Export != null && List_Fee_Shipment_Import_Export.size()>0)
                        List_Fee_Shipment_Import_Export[List_Fee_Shipment_Import_Export.size()-1].list_fees = list_fees;
                     
                    //---se puede unificar con el de arriba pero mej mantener serparados los con ruta de los sin    
                    //si hay shipmenst sin ruta creo secciones para cada uno 
                    if(shipments_whitout_route == true)
                    {
                        Map<string, List<Lineas_fees_s>>  map_shipments_sin_route = new Map<string, List<Lineas_fees_s>>();
                        Map<string, List<Location__c>>  map_shipments_sin_route_locations = new Map<string, List<Location__c>>();
                        for(Shipment__c ship: listado_shipments_sin_route)
                        {
                            List<Lineas_fees_s> listado_nuevas_lineas_de_esta_ruta = new List<Lineas_fees_s>();
                            string nombre_de_la_linea = '';
                            string id_shipment_program_line = '';
                            if(import_export_associated.containsKey(ship.Id))
                            {
                                for(Id i: import_export_associated.get(ship.Id))// de esta forma solo se recorren las que me hacen falta no todas(import export de este shipment)
                                {
                                    system.debug('hola1 '+i);
                                    //si de la import export relacionada tengo lineas
                                    if(import_export_service_lines_associated.containsKey(i))
                                    {
                                        for(Import_Export_Fee_Line__c iefl : import_export_service_lines_associated.get(i))//recorrer las lineas de cada import export
                                        {
                                            system.debug('hola2 '+iefl);
                                            boolean ya_creado = false;
                                            nombre_de_la_linea = '';
                                            id_shipment_program_line = '';
                                            if(lineas_shipment_service_lines_includes != null)//comprobar si ya existe
                                            {
                                                if(lineas_shipment_service_lines_includes.containsKey(iefl.Id))//comprobar que coincide las import service lines con el shipment
                                                {
                                                    string contenedor_shipment = lineas_shipment_service_lines_includes.get(iefl.Id)[lineas_shipment_service_lines_includes.get(iefl.Id).size()-1];
                                                    if(contenedor_shipment != null && contenedor_shipment.contains(ship.Id) == true)
                                                    {
                                                        ya_creado = true;
                                                        
                                                        for(Ship_Service_Consol__c sfl2 : query_ship_service_consol)
                                                        {
                                                            if(sfl2.Shipment_Service_Line__r.Import_Export_Service_Line__c == iefl.Id)
                                                            {
                                                                nombre_de_la_linea += sfl2.Shipments_Program_Service_Line__r.Service_Rate_Name__r.Name+', ';
                                                                id_shipment_program_line += sfl2.Shipments_Program_Service_Line__c+'_&_';
                                                                //break;
                                                            }
                                                        }
                                                    }   
                                                }
                                            }
                                            
                                            listado_nuevas_lineas_de_esta_ruta.add(new Lineas_fees_s(this, ship, iefl , false, 
                                            (iefl.Quote_Buy_Price__c != null &&  iefl.Units__c != null ? iefl.Quote_Buy_Price__c*iefl.Units__c : 0)
                                            , '', shipment_program_lines, ya_creado, nombre_de_la_linea, id_shipment_program_line));
                                        }
                                    }
                                }
                            }

                            if(map_shipments_sin_route.containsKey(ship.Site_of_Load__c+'_&_'+ship.Site_of_Discharge__c))
                            {
                                for(Lineas_fees_s lf: listado_nuevas_lineas_de_esta_ruta)
                                    map_shipments_sin_route.get(ship.Site_of_Load__c+'_&_'+ship.Site_of_Discharge__c).add(lf);
                            }
                            else
                            {
                                map_shipments_sin_route.put(ship.Site_of_Load__c+'_&_'+ship.Site_of_Discharge__c, listado_nuevas_lineas_de_esta_ruta);
                                List<Location__c> locations_list = new List<Location__c>();
                                locations_list.add(ship.Site_of_Load__r);
                                locations_list.add(ship.Site_of_Discharge__r);
                                map_shipments_sin_route_locations.put(ship.Site_of_Load__c+'_&_'+ship.Site_of_Discharge__c,locations_list);
                            }
                            
                        }
                        
                        //recorro para ir creado secciones
                        for (String entry : map_shipments_sin_route.keySet())
                        {
                            List<String> listado_nombres_rutas = entry.split('_&_');
                            List_Fee_Shipment_Import_Export.add(new Ship_fee_lines_import_export_s( map_shipments_sin_route_locations.get(entry)[0],  map_shipments_sin_route_locations.get(entry)[1], map_shipments_sin_route.get(entry)));
                        }
                        
                    }    
                } 
                else
                {
                    
                    List_Fee_Shipment_Import_Export = new List<Ship_fee_lines_import_export_s>();
                    
                    //rellenar las lineas de shipment program disponibles 
                    List<SelectOption> shipment_program_lines = new List<SelectOption>(); 
                    shipment_program_lines.add(new SelectOption('',''));
                    List<Shipment_Program_Line__c> listado_lineas_insertadas = null;
                    if(String.isNotEmpty(getnewcategory()))
                        listado_lineas_insertadas = [select Id, Name, Service_Rate_Name__c, Service_Rate_Name__r.Name from Shipment_Program_Line__c where Shipments_Program__c =: record.Id and Service_Rate_Name__r.Fee_Category__c =:  getnewcategory()];
                    
                    if(listado_lineas_insertadas.size()>0)
                        shipment_program_lines.add(new SelectOption('All','All '+  getnewcategory() +''));
                    
                   // List<Shipment_Consolidation_Data__c> query_Shipment_Consolidation_Data = [select id, Name, Shipment__c, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Import_Export_Quote__c !=: null order by Shipment__c];
                    
                    //---------------------------------- parte nueva
                    
                    //recojoj las import-export que intervienen en este shipment program
                    List<Shipment_Consolidation_Data__c> query_ship_consodata =[select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipments_Program__c =: record.Id and Import_Export_Quote__c !=: null];
                    Set<Id> listado_import_export_utilizadas = new Set<Id>(); 
                    List<Shipment__c> listado_last_shipment_almacenes = new List<Shipment__c>();
                    for(Shipment_Consolidation_Data__c scd: query_ship_consodata)//--se puede me
                    {
                         listado_import_export_utilizadas.add(scd.Import_Export_Quote__c);
                    }
                    
                    
                    Set<id> listado_import_export_ids = new Set<Id>();
                    Map<Id,Set<id>> import_export_associated =new Map<Id,Set<Id>>();
                    Set<Id> listado_ids_shipments = new Set<Id>();
                  //  Map<Id,Customer_Quote__c> map_shipment_imp_exp = new Map<Id,Customer_Quote__c>();
                    if(listado_import_export_utilizadas != null && listado_import_export_utilizadas.size()>0)
                    {
                         //busco el shipment anterior de estas import-export
                         query_ship_consodata = [select id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name, Shipment__c, Shipment__r.Name, Shipment__r.Storage_days__c, Shipment__r.Total_Volume_m3__c, Shipment__r.Total_Weight_Kg__c, Shipment__r.Storage_Date_From__c, Shipment__r.Storage_Date_To__c  from Shipment_Consolidation_Data__c where Import_Export_Quote__c IN: listado_import_export_utilizadas and Import_Export_Quote__c !=: null and Shipments_Program__c !=: record.Id order by CreatedDate desc];
                         string contenedor_import_export = '';
                        
                         for(Shipment_Consolidation_Data__c scd : query_ship_consodata)
                         {
                               if(contenedor_import_export == '' || contenedor_import_export.contains(scd.Import_Export_Quote__c) == false)
                               {
                                     listado_last_shipment_almacenes.add(scd.Shipment__r);
                                    // map_shipment_imp_exp.put(scd.Shipment__c, scd.Import_Export_Quote__r);
                                    listado_ids_shipments.add(scd.Shipment__c);
                                    //conseguir las import export relacionadas con cada shipment
                                    if(import_export_associated.containsKey(scd.Shipment__c))
                                      import_export_associated.get(scd.Shipment__c).add(scd.Import_Export_Quote__c);
                                    else
                                        import_export_associated.put(scd.Shipment__c, new Set<Id>{scd.Import_Export_Quote__c});
                               }
                               contenedor_import_export += scd.Import_Export_Quote__c;
                               listado_import_export_ids.add(scd.Import_Export_Quote__c); 
                         }
                    }
                    
                    //conseguir las lineas relacionadas con cada import-export
                    Map<Id,List<Import_Export_Fee_Line__c>> import_export_service_lines_associated =new Map<Id,List<Import_Export_Fee_Line__c>>();
                    List<Import_Export_Fee_Line__c> query_import_export_service_lines = null;
                    query_import_export_service_lines = [select id, Name, Import_Export_Quote__c, Service_Rate_Name__r.Carrier_Account__c, 
                    Import_Export_Quote__r.Name, Import_Export_Quote__r.Account_for__c,  Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Supplier_Account__r.Name, Import_Export_Quote__r.Consignee__c, Import_Export_Quote__r.Consignee__r.Name,
                    Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Name, Service_Rate_Name__r.Container_Type__c,Service_Rate_Name__r.Carrier_Account__r.Name, Extension_Service_Name__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Rate_Type__c,
                    Sell_Rate__c, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Service_Rate_Name__r.Concept_1__c, Service_Rate_Name__r.Concept_2__c, Service_Rate_Name__r.Concept_3__c, Service_Rate_Name__r.Concept_4__c, Service_Rate_Name__r.Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c,
                    Quote_Buy_Price__c, Buy_Amount__c from Import_Export_Fee_Line__c where Import_Export_Quote__c IN: listado_import_export_ids];  
                    
                    for(Import_Export_Fee_Line__c iefl : query_import_export_service_lines)
                    {
                        if(import_export_service_lines_associated.containsKey(iefl.Import_Export_Quote__c))
                            import_export_service_lines_associated.get(iefl.Import_Export_Quote__c).add(iefl);
                        else
                            import_export_service_lines_associated.put(iefl.Import_Export_Quote__c, new List<Import_Export_Fee_Line__c>{iefl});
                    }
                    
                    //consulta todos los shipments anteriores a este
                    List<Shipment__c> query_shipment = [select Id, Name, Route__c, Route__r.Port_Airport_of_Load__c,
                    Route__r.Port_Airport_of_Load__r.Name, Supplier_Account__c , Supplier_Account__r.Name, Consignee__c, Consignee__r.Name, Account_for__r.Name, Route__r.Port_Airport_of_Discharge__c, Account_for__c , Total_Volume_m3__c,
                    Route__r.Port_Airport_of_Discharge__r.Name, Total_Weight_Kg__c
                    from Shipment__c where id IN:listado_ids_shipments];
                    
                    //consulta de lineas shipment para saber cual ya se ha metido
                    Map<Id,List<string>> lineas_shipment_service_lines_includes = new Map<Id,List<string>>();

                    //------------------------------------
                    List<Ship_Service_Consol__c> query_ship_service_consol = [select Id, Name, Shipments_Program_Service_Line__c, 
                    Shipment_Service_Line__r.Shipment__c, Shipments_Program_Service_Line__r.Service_Rate_Name__r.Name, Shipment_Service_Line__r.Import_Export_Service_Line__c from Ship_Service_Consol__c where Shipment_Service_Line__r.Shipment__c IN: listado_ids_shipments  and Shipment_Service_Line__r.Import_Export_Service_Line__c !=: null and Shipments_Program_Service_Line__r.Service_Rate_Name__r.Fee_Category__c =: getnewcategory()];
                    
                    string contenedor_de_shipments = '';
                    Set<id> listado_imp_fee_lines_insertadas = new Set<Id>();
                    //---ver como hacer esto luego
                    for(Ship_Service_Consol__c sfl: query_ship_service_consol)
                    {
                        if(lineas_shipment_service_lines_includes.containsKey(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c))
                        {
                            contenedor_de_shipments = lineas_shipment_service_lines_includes.get(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c)[lineas_shipment_service_lines_includes.get(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c).size()-1];
                            contenedor_de_shipments += sfl.Shipment_Service_Line__r.Shipment__c;
                            lineas_shipment_service_lines_includes.get(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c).add(contenedor_de_shipments);
                        }
                        else
                        {
                            contenedor_de_shipments = '';
                            contenedor_de_shipments += sfl.Shipment_Service_Line__r.Shipment__c;
                            lineas_shipment_service_lines_includes.put(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c , new List<string>{contenedor_de_shipments});
                        }
                        
                        listado_imp_fee_lines_insertadas.add(sfl.Shipment_Service_Line__r.Import_Export_Service_Line__c);
                    }
                    
                    //------------------------------------------
                    //bloquear los que se han pasado directamente
                    contenedor_de_shipments = '';
                    //consulta lineas existentes
                    List<Shipment_Fee_Line__c> query_lineas_shipment_fee_line = [select Id, Name, Import_Export_Service_Line__c, 
                    Shipment__c from Shipment_Fee_Line__c where  Shipment__c IN: listado_ids_shipments
                    and Import_Export_Service_Line__c !=: null and Import_Export_Service_Line__c not IN: listado_imp_fee_lines_insertadas];
                    //consulta los objetos de fusion para saber que linea tiene y cual no
                    List<Ship_Service_Consol__c> query_ship_service_consol2 = [select Id, Name, Shipments_Program_Service_Line__c, 
                    Shipment_Service_Line__r.Shipment__c, Shipments_Program_Service_Line__r.Service_Rate_Name__r.Name, Shipment_Service_Line__r.Import_Export_Service_Line__c from Ship_Service_Consol__c where Shipment_Service_Line__r.Shipment__c IN: listado_ids_shipments and Shipment_Service_Line__r.Import_Export_Service_Line__c !=: null order by Shipment_Service_Line__c];
                    
                    Map<Id,boolean> ids_lineas_shipment_x_ship_service_consol = new Map<Id,boolean>();
                    //----------ver como hacer esto luego
                    for(Ship_Service_Consol__c sfl:query_ship_service_consol2)
                    {
                         if(ids_lineas_shipment_x_ship_service_consol.containsKey(sfl.Shipment_Service_Line__c) == false)
                        {
                            ids_lineas_shipment_x_ship_service_consol.put(sfl.Shipment_Service_Line__c , true);
                        }
                        else
                        {
                            ids_lineas_shipment_x_ship_service_consol.put(sfl.Shipment_Service_Line__c , true);
                        }
                            
                    }
                        
                    boolean encontrado = false;
                    for(Shipment_Fee_Line__c sfl :query_lineas_shipment_fee_line)
                    {
    
                        if(ids_lineas_shipment_x_ship_service_consol != null)
                            if(ids_lineas_shipment_x_ship_service_consol.containsKey(sfl.Id) == true)
                                encontrado = true;
    
                        
                        if(encontrado == false)
                        {
                            if(lineas_shipment_service_lines_includes.containsKey(sfl.Import_Export_Service_Line__c))
                            {
                                contenedor_de_shipments = lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c)[lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c).size()-1];
                                contenedor_de_shipments += sfl.Shipment__c;
                                lineas_shipment_service_lines_includes.get(sfl.Import_Export_Service_Line__c).add(contenedor_de_shipments);
                            }
                            else
                            {
                                contenedor_de_shipments = '';
                                contenedor_de_shipments += sfl.Shipment__c;
                                lineas_shipment_service_lines_includes.put(sfl.Import_Export_Service_Line__c, new List<string>{contenedor_de_shipments});
                            }
                        }
                        
                        encontrado = false;
                    }
                    
                    string contenedor_de_ruta = '';
                    List<Lineas_fees_s> list_fees = new List<Lineas_fees_s>();
                    for(Shipment__c ship: query_shipment)
                    {
                        if(contenedor_de_ruta == '' || (ship.Route__c != null && contenedor_de_ruta.contains(ship.Route__c) == false))
                        {
                            if(List_Fee_Shipment_Import_Export != null && List_Fee_Shipment_Import_Export.size()>0)
                                List_Fee_Shipment_Import_Export[List_Fee_Shipment_Import_Export.size()-1].list_fees = list_fees;
                            list_fees = new List<Lineas_fees_s>();
                            List_Fee_Shipment_Import_Export.add(new Ship_fee_lines_import_export_s(ship.Route__r.Port_Airport_of_Load__r, ship.Route__r.Port_Airport_of_Discharge__r, list_fees));
                        }
                        string nombre_de_la_linea = '';
                        string id_shipment_program_line = '';
                        //si tengo import export de este shipment
                        if(import_export_associated.containsKey(ship.Id))
                        {
                            for(Id i: import_export_associated.get(ship.Id))// de esta forma solo se recorren las que me hacen falta no todas(import export de este shipment)
                            {
                                //si de la import export relacionada tengo lineas
                                if(import_export_service_lines_associated.containsKey(i))
                                {
                                    for(Import_Export_Fee_Line__c iefl : import_export_service_lines_associated.get(i))//recorrer las lineas de cada import export
                                    {
                                        boolean ya_creado = false;
                                        nombre_de_la_linea = '';
                                        id_shipment_program_line = '';
                                        if(lineas_shipment_service_lines_includes != null)//comprobar si ya existe
                                        {
                                            if(lineas_shipment_service_lines_includes.containsKey(iefl.Id))//comprobar que coincide las import service lines con el shipment
                                            {
                                                string contenedor_shipment = lineas_shipment_service_lines_includes.get(iefl.Id)[lineas_shipment_service_lines_includes.get(iefl.Id).size()-1];
                                                if(contenedor_shipment != null && contenedor_shipment.contains(ship.Id) == true)
                                                {
                                                    ya_creado = true;
                                                    
                                                    for(Ship_Service_Consol__c sfl2 : query_ship_service_consol)
                                                    {
                                                        if(sfl2.Shipment_Service_Line__r.Import_Export_Service_Line__c == iefl.Id)
                                                        {
                                                            nombre_de_la_linea += sfl2.Shipments_Program_Service_Line__r.Service_Rate_Name__r.Name+', ';
                                                            id_shipment_program_line += sfl2.Shipments_Program_Service_Line__c+'_&_';
                                                            //break;
                                                        }
                                                    }
                                                }   
                                            }
                                        }
                                        
                                        list_fees.add(new Lineas_fees_s(this, ship, iefl , false,
                                        (iefl.Quote_Buy_Price__c != null &&  iefl.Units__c != null ? iefl.Quote_Buy_Price__c*iefl.Units__c : 0)
                                        , '', shipment_program_lines, ya_creado, nombre_de_la_linea, id_shipment_program_line));
                                    }
                                }
                            }
                        }
            
                        contenedor_de_ruta += ship.Route__c;
                    }
                    
                    if(List_Fee_Shipment_Import_Export != null && List_Fee_Shipment_Import_Export.size()>0)
                        List_Fee_Shipment_Import_Export[List_Fee_Shipment_Import_Export.size()-1].list_fees = list_fees;

                } //fin del else si es por almace
                   
            }
            
            return List_Fee_Shipment_Import_Export;
        }
        
        //insertar las linea en el inbound shipments del almac
        public void crear_inbound_shipment_service_lines()
        {
            if(Fee_List_Price2 != null && Fee_List_Price2.size() > 0)
            {
                integer contador_lineas = 1;
                List<Shipment_Fee_Line__c> listado_shipment_service_lines = new List<Shipment_Fee_Line__c>();
                for(Ship_Prog_Fee_Line_s spfl: Fee_List_Price2)
                {
                    if(spfl.selected  == true && spfl.ship != null)
                    {
                        Shipment_Fee_Line__c new_ship_fee_line = new Shipment_Fee_Line__c();
                        new_ship_fee_line.Name ='00'+contador_lineas;
                        //new_ship_fee_line.Create_Disbursement__c = false;
                        new_ship_fee_line.Discount_Charge__c = spfl.ship_fee_line.Discount_Charge__c;
                        if(spfl.import_export != null)
                            new_ship_fee_line.Import_Export_Quote__c = spfl.import_export.Id;
                        new_ship_fee_line.Service_Rate_Name__c = spfl.line.Id;
                        new_ship_fee_line.Shipment__c = spfl.ship.Id;
                        new_ship_fee_line.Shipment_Buy_Price__c = spfl.ship_fee_line.Ship_Prog_Buy_Price__c;
                        new_ship_fee_line.Shipment_Sell_Price__c = spfl.ship_fee_line.Ship_Prog_Sell_Price__c;
                        new_ship_fee_line.Units__c = spfl.ship_fee_line.Units__c;
                        new_ship_fee_line.Add_to_Quote__c = true;
                        NEU_CurrencyUtils.setCurrencyIsoCode(new_ship_fee_line,spfl.currency_user);
                        listado_shipment_service_lines.add(new_ship_fee_line);
                        contador_lineas ++;
                    }
                }
                
                if(listado_shipment_service_lines != null && listado_shipment_service_lines.size()>0)
                {
                    insert listado_shipment_service_lines;
                }
                Fee_List_Price2 = null;
            }
        }
        
        //insertar lineas shipment service lines
        public void crear_shipment_service_lines()
        {
            if(List_Fee_Shipment_Import_Export != null && List_Fee_Shipment_Import_Export.size()>0)
            {
                List<Shipment_Fee_Line__c> Listado_shipment_fee_insert = new List<Shipment_Fee_Line__c>();

                List<Ship_Service_Consol__c> listado_service_consol = new List<Ship_Service_Consol__c>();
                
                Map<Id,List<decimal>> contador_lineas_por_shipment =new Map<Id,List<decimal>>();
                
                //consulta si ya existe esta shipment fee line 
                //------------------------------
                //recorrer para conseguir los shipments que intervienen
                Set<id> listado_ids_shipment = new Set<Id>();
                Map<String,List<Shipment_Fee_Line__c>>ship_fee_lines_existentes=new Map<String,List<Shipment_Fee_Line__c>>();
                
                for(Ship_fee_lines_import_export_s ship_fee : List_Fee_Shipment_Import_Export)
                {
                    if(ship_fee.list_fees != null && ship_fee.list_fees.size()>0)
                    {
                        for(Lineas_fees_s lf: ship_fee.list_fees)
                        {
                            if(lf.selected == true)
                            {
                                listado_ids_shipment.add(lf.shipment.id);
                            }
                        }
                    }
                }
                
                //recorrer los shipment fee lines ya creados y rellena la lista para ver si crear o no la shipment service line
                List<Shipment_Fee_Line__c> query_shipment_fee_line = [select Id, Name, Shipment__c, Units__c, Shipment_Buy_Price__c, Import_Export_Service_Line__c from Shipment_Fee_Line__c where Shipment__c IN: listado_ids_shipment and Import_Export_Service_Line__c !=: null order by Shipment__c];//----------seguir por aqui
                for(Shipment_Fee_Line__c sfl : query_shipment_fee_line)
                {
                    if(ship_fee_lines_existentes.containsKey(sfl.Shipment__c+'_'+sfl.Import_Export_Service_Line__c))
                        ship_fee_lines_existentes.get(sfl.Shipment__c+'_'+sfl.Import_Export_Service_Line__c).add(sfl);
                    else
                        ship_fee_lines_existentes.put(sfl.Shipment__c+'_'+sfl.Import_Export_Service_Line__c, new List<Shipment_Fee_Line__c>{sfl});
                }
                
                List<Shipment_Fee_Line__c> listado_shipment_fee_lines_to_update = new List<Shipment_Fee_Line__c>();
                
                //----------------------------------
                
                for(Ship_fee_lines_import_export_s ship_fee : List_Fee_Shipment_Import_Export)
                {
                    if(ship_fee.list_fees != null && ship_fee.list_fees.size()>0)
                    {
                        for(Lineas_fees_s lf: ship_fee.list_fees)
                        {
                            if(lf.selected == true)
                            {
                                chekeados2=true;
                                
                                if(contador_lineas_por_shipment.containsKey(lf.shipment.id))
                                {
                                  contador_lineas_por_shipment.get(lf.shipment.id).add(1);
                                }
                                else
                                {
                                    contador_lineas_por_shipment.put(lf.shipment.id, new List<decimal>{1});
                                } 
                                
                                //comprobar si crear o no un nuevo shipment fee line
                                Shipment_Fee_Line__c new_shipment_fee_line = new Shipment_Fee_Line__c();
                                if(ship_fee_lines_existentes != null && ship_fee_lines_existentes.containsKey(lf.shipment.id+'_'+lf.IE_fee_line.Id))
                                {
                                    //si existe recalcular el buy price
                                    Decimal allocate_cost_calculated = 0;
                                    if(lf.selected_shipment_program_line != 'All')
                                    {
                                        list<Shipment_Program_Line__c> query_shipment_program_line =[select Id , Name, Buy_Amount__c from Shipment_Program_Line__c where id=:lf.selected_shipment_program_line]; //---mej esto
                                        if(query_shipment_program_line != null && query_shipment_program_line.size()>0)
                                        {
                                            if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per Kg')
                                                allocate_cost_calculated = (query_shipment_program_line[0].Buy_Amount__c/record.Total_Gross_Weight_Kg__c)*lf.shipment.Total_Weight_Kg__c;
                                            if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per M3' || lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per W/M')
                                                allocate_cost_calculated = (query_shipment_program_line[0].Buy_Amount__c/record.Total_Gross_Volume_m3__c)*lf.shipment.Total_Volume_m3__c;
                                            if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per TON')
                                                allocate_cost_calculated = (query_shipment_program_line[0].Buy_Amount__c/(record.Total_Gross_Weight_Kg__c*1000))*lf.shipment.Total_Weight_Kg__c;
                                        }
                                    }
                                    else
                                    {
                                        list<Shipment_Program_Line__c> query_shipment_program_line =[select Id , Name, Buy_Amount__c from Shipment_Program_Line__c where Shipments_Program__c =: record.Id and Service_Rate_Category__c =: getnewcategory()];
                                        for(Shipment_Program_Line__c spl: query_shipment_program_line)
                                        {
                                            if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per Kg')
                                                allocate_cost_calculated += (spl.Buy_Amount__c/record.Total_Gross_Weight_Kg__c)*lf.shipment.Total_Weight_Kg__c;
                                            if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per M3' || lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per W/M')
                                                allocate_cost_calculated += (spl.Buy_Amount__c/record.Total_Gross_Volume_m3__c)*lf.shipment.Total_Volume_m3__c;
                                            if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per TON')
                                                allocate_cost_calculated += (spl.Buy_Amount__c/(record.Total_Gross_Weight_Kg__c*1000))*lf.shipment.Total_Weight_Kg__c;
                                        }
                                    }   
                                   // ship_fee_lines_existentes.get(lf.shipment.id+'_'+lf.IE_fee_line.Id)[0].Shipment_Buy_Price__c = ship_fee_lines_existentes.get(lf.shipment.id+'_'+lf.IE_fee_line.Id)[0].Shipment_Buy_Price__c +(allocate_cost_calculated/ship_fee_lines_existentes.get(lf.shipment.id+'_'+lf.IE_fee_line.Id)[0].Units__c);
                                    new_shipment_fee_line = ship_fee_lines_existentes.get(lf.shipment.id+'_'+lf.IE_fee_line.Id)[0];
                                   // listado_shipment_fee_lines_to_update.add(ship_fee_lines_existentes.get(lf.shipment.id+'_'+lf.IE_fee_line.Id)[0]);
                                } 
                                else
                                {
                                    if(lf.selected_shipment_program_line != 'All')
                                    {
                                        new_shipment_fee_line = new Shipment_Fee_Line__c();
                                        if(Schema.sObjectType.Shipment_Fee_Line__c.fields.Name.isCreateable()) 
                                        	new_shipment_fee_line.Name = string.valueof(contador_lineas_por_shipment.get(lf.shipment.id).size());
                                        	
                                        if(Schema.sObjectType.Shipment_Fee_Line__c.fields.Discount_Charge__c.isCreateable())
                                        	new_shipment_fee_line.Discount_Charge__c = lf.IE_fee_line.Discount__c;
                                        	
                                        new_shipment_fee_line.Extension_Service_Name__c = lf.IE_fee_line.Extension_Service_Name__c;
                                        new_shipment_fee_line.Service_Rate_Name__c = lf.IE_fee_line.Service_Rate_Name__c;
                                        new_shipment_fee_line.Shipment__c = lf.shipment.id;
                                        new_shipment_fee_line.Shipment_Buy_Price__c = lf.IE_fee_line.Quote_Buy_Price__c;
                                        new_shipment_fee_line.Shipment_Sell_Price__c = lf.IE_fee_line.Quote_Sell_Price__c;
                                        new_shipment_fee_line.Units__c = lf.IE_fee_line.Units__c;
                                        new_shipment_fee_line.Import_Export_Service_Line__c = lf.IE_fee_line.Id;
                                        new_shipment_fee_line.Import_Export_Quote__c = lf.IE_fee_line.Import_Export_Quote__c;
                                        //new_shipment_fee_line.Create_Disbursement__c = false;
                                        Listado_shipment_fee_insert.add(new_shipment_fee_line);
 
                                    }
                                    else
                                    {
                                        new_shipment_fee_line = new Shipment_Fee_Line__c();
                                        new_shipment_fee_line.Name = string.valueof(contador_lineas_por_shipment.get(lf.shipment.id).size());
                                        new_shipment_fee_line.Discount_Charge__c = lf.IE_fee_line.Discount__c;
                                        new_shipment_fee_line.Extension_Service_Name__c = lf.IE_fee_line.Extension_Service_Name__c;
                                        new_shipment_fee_line.Service_Rate_Name__c = lf.IE_fee_line.Service_Rate_Name__c;
                                        new_shipment_fee_line.Shipment__c = lf.shipment.id;
                                        //new_shipment_fee_line.Shipment_Buy_Price__c = lf.IE_fee_line.Quote_Buy_Price__c;
                                        new_shipment_fee_line.Shipment_Sell_Price__c = lf.IE_fee_line.Quote_Sell_Price__c;
                                        new_shipment_fee_line.Units__c = lf.IE_fee_line.Units__c;
                                        new_shipment_fee_line.Import_Export_Service_Line__c = lf.IE_fee_line.Id;
                                        new_shipment_fee_line.Import_Export_Quote__c = lf.IE_fee_line.Import_Export_Quote__c;
                                        //new_shipment_fee_line.Create_Disbursement__c = false;
                                        Listado_shipment_fee_insert.add(new_shipment_fee_line);
                                    }
                                }
                                
                                if(lf.selected_shipment_program_line != 'All' && lf.selected_shipment_program_line != '' && lf.selected_shipment_program_line != null)
                                {
                                    Ship_Service_Consol__c new_listado_service_consol = new Ship_Service_Consol__c();
                                    new_listado_service_consol.Name = string.valueof(contador_lineas_por_shipment.get(lf.shipment.id).size());
                                    new_listado_service_consol.Shipments_Program_Service_Line__c = lf.selected_shipment_program_line;
                                    list<Shipment_Program_Line__c> query_shipment_program_line =[select Id , Name, Buy_Amount__c from Shipment_Program_Line__c where id=:lf.selected_shipment_program_line]; //---mej esto
                                    if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per Kg')
                                        new_listado_service_consol.Cost_Allocated__c = (query_shipment_program_line[0].Buy_Amount__c/record.Total_Gross_Weight_Kg__c)*lf.shipment.Total_Weight_Kg__c;
                                    if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per M3' || lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per W/M')
                                        new_listado_service_consol.Cost_Allocated__c = (query_shipment_program_line[0].Buy_Amount__c/record.Total_Gross_Volume_m3__c)*lf.shipment.Total_Volume_m3__c;
                                    if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per TON')
                                        new_listado_service_consol.Cost_Allocated__c = (query_shipment_program_line[0].Buy_Amount__c/(record.Total_Gross_Weight_Kg__c*1000))*lf.shipment.Total_Weight_Kg__c;
                                    //----------falta el per container y el fixed
                                    
                                    new_listado_service_consol.Shipment_Service_Line__r = new_shipment_fee_line;
                                    listado_service_consol.add(new_listado_service_consol);
                                }
                                else if(lf.selected_shipment_program_line == 'All')
                                {
                                    list<Shipment_Program_Line__c> query_shipment_program_line =[select Id , Name, Buy_Amount__c from Shipment_Program_Line__c where Shipments_Program__c =: record.Id and Service_Rate_Category__c =: getnewcategory()];
                                    integer num_lineas = 1;
                                    for(Shipment_Program_Line__c spl: query_shipment_program_line)
                                    {
                                        Ship_Service_Consol__c new_listado_service_consol = new Ship_Service_Consol__c();
                                        new_listado_service_consol.Name = string.valueof(num_lineas);
                                        new_listado_service_consol.Shipments_Program_Service_Line__c = spl.Id;
                                        if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per Kg')
                                            new_listado_service_consol.Cost_Allocated__c = (spl.Buy_Amount__c/record.Total_Gross_Weight_Kg__c)*lf.shipment.Total_Weight_Kg__c;
                                        if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per M3' || lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per W/M')
                                            new_listado_service_consol.Cost_Allocated__c = (spl.Buy_Amount__c/record.Total_Gross_Volume_m3__c)*lf.shipment.Total_Volume_m3__c;
                                        if(lf.IE_fee_line.Service_Rate_Name__r.Rate_Type__c == 'Per TON')
                                        {
                                            //new_listado_service_consol.Cost_Allocated__c = (spl.Buy_Amount__c/(record.Total_Gross_Weight_Kg__c*1000))*lf.shipment.Total_Weight_Kg__c;
                                            new_listado_service_consol.Cost_Allocated__c = (spl.Buy_Amount__c/(record.Total_Gross_Weight_Kg__c))*lf.shipment.Total_Weight_Kg__c;
                                            new_listado_service_consol.Cost_Allocated__c = new_listado_service_consol.Cost_Allocated__c *1000;
                                        }
                                        //----------falta el per container y el fixed
                                        
                                        new_listado_service_consol.Shipment_Service_Line__r = new_shipment_fee_line;
                                        listado_service_consol.add(new_listado_service_consol);
                                        num_lineas ++;
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(Listado_shipment_fee_insert != null && Listado_shipment_fee_insert.size()>0 )
                {
                    insert Listado_shipment_fee_insert;
                }
                if(listado_service_consol != null && listado_service_consol.size()>0)
                {
                    for(Ship_Service_Consol__c ssc: listado_service_consol)
                    {
                        ssc.Shipment_Service_Line__c = ssc.Shipment_Service_Line__r.Id;
                    }
                    insert listado_service_consol;
                }
                
                if(listado_shipment_fee_lines_to_update != null && listado_shipment_fee_lines_to_update.size()>0)
                {
                    update listado_shipment_fee_lines_to_update;
                }   
                List_Fee_Shipment_Import_Export = null;
                
            }
            List_Fee_Shipment_Import_Export = null;
        }
        
        
        public void create_new_service_rate()
        {
            if(fee_record != null)
            {
                Fee__c new_fee = new Fee__c();
                new_fee.Name = fee_record.Name;
                //new_fee.Name = fee_record.Rate_Names_List__c;
                if(getnewcategory() != 'Drayages' && getnewcategory() != 'Other Service Charges')
                    new_fee.Route__c = fee_record.Route__c;
                else if(getnewcategory() == 'Drayages')
                {
                    new_fee.Port_Airport__c = fee_record.Port_Airport__c;
                    new_fee.Delivery_Zone__c = fee_record.Delivery_Zone__c;
                }
                new_fee.Valid_Until__c = fee_record.Valid_Until__c;
                new_fee.Account_for__c = fee_record.Account_for__c;
                new_fee.Carrier_Account__c = fee_record.Carrier_Account__c;
                new_fee.TT_Days__c = fee_record.TT_Days__c;
                NEU_CurrencyUtils.setCurrencyIsoCode(new_fee,fee_currency);
                new_fee.Rate_Type__c = fee_record.Rate_Type__c;
                new_fee.Container_Type__c = fee_record.Container_Type__c;
                new_fee.Fee_Rate__c = fee_record.Fee_Rate__c;
                new_fee.Buy_Rate__c = fee_record.Buy_Rate__c;
                new_fee.Max_Kgs__c = fee_record.Max_Kgs__c;
                new_fee.Max_M3__c = fee_record.Max_M3__c;
                new_fee.Volumetric_Factor__c = fee_record.Volumetric_Factor__c;
                new_fee.Min__c = fee_record.Min__c;
                new_fee.Active__c = true;
                new_fee.Fee_Category__c = getnewcategory();
                if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
                    new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                else if(getnewcategory() == 'Air Freights')
                    new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                else if(getnewcategory() == 'Drayages')
                    new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
                else
                {
                    new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
                    new_fee.Route__c = null;
                }
                new_fee.Rate_Names_List__c = fee_record.Rate_Names_List__c;
                
                try
                {
                    insert new_fee;
                    fee_record = new Fee__c();
                    //fee_record.Account_for__c = record.Account_for__c;
                    if(getnewcategory() != 'Drayages' && getnewcategory() != 'Other Service Charges')
                        fee_record.Route__c = record.Route__c;
                    Fee_List_Price = null;
                    
                    if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
                    {
                        fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                        RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                        fee_record.RecordType = rt;
                    }
                    else if(getnewcategory() == 'Air Freights')
                    {
                        fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
                        RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                        fee_record.RecordType = rt;
                    }
                    else if(getnewcategory() == 'Drayages')
                    {
                        fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
                        RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                        fee_record.RecordType = rt;
                    }
                    else
                    {
                        fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
                        RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                        fee_record.RecordType = rt;
                    }   
                    fee_record.Fee_Category__c = getnewcategory();
                    
                }
                catch(Exception ex)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
                }
            }
        }  
    
        //Consultar las insertadas nuevo objet    
        public void crearlineashipprog()
        {   
            if(Fee_List_Price!=null)
            {
                List<Shipment_Program_Line__c>  Ship_fee = [select Id, Name, Shipments_Program__c from Shipment_Program_Line__c where Shipments_Program__c =: record.Id  order by Name];
                    
                integer contadordelineas = 0;
                contadordelineas =Ship_fee.size();
                List<Shipment_Disbursement__c> listado_insert_disbursemen = new List<Shipment_Disbursement__c>();
                for (Ship_Prog_Fee_Line_s lines:Fee_List_Price)
                {
                    if(lines.selected)
                    {
                        chekeados=true;
                        contadordelineas ++;
                        Shipment_Program_Line__c myLine= new Shipment_Program_Line__c();
                        myline.Shipments_Program__c=record.Id;
                        myline.Name = string.valueof(contadordelineas);
                       // if(lines.line.Fee_Category__c == 'Sea Freights' && lines.line.Carrier_Account__c != null && shipment_filter != null)
                         //   shipment_filter.Carrier__c = lines.line.Carrier_Account__c;  
                        myline.Service_Rate_Name__c = lines.line.Id;
                        if(lines.ship_fee_line != null)
                            myline.Units__c = lines.ship_fee_line.Units__c;
                        if(lines.ship_fee_line != null)    
                            myline.Ship_Prog_Sell_Price__c = lines.ship_fee_line.Ship_Prog_Sell_Price__c;
                        if(lines.ship_fee_line != null)
                            myline.Discount_Charge__c = lines.ship_fee_line.Discount_Charge__c;
                        if(lines.ship_fee_line != null)
                        {
                            myline.Ship_Prog_Buy_Price__c = lines.ship_fee_line.Ship_Prog_Buy_Price__c;
                        }
                        if(lines.ship != null)
                        {
                            myline.Inbound_Shipment__c = lines.ship.Id; 
                        }  
                        myline.Min_Amount__c = lines.line.Min__c;
                        
                        NEU_CurrencyUtils.setCurrencyIsoCode(myLine,lines.currency_user);
                        
                        try
                        {
                            insert myLine;
                            if(lines.line.Carrier_Account__c != null)
                            {
                                Shipment_Disbursement__c new_Disbursement = new Shipment_Disbursement__c();
                                new_Disbursement.Shipments_Program__c = record.Id;
                                new_Disbursement.Disbursment_Concept__c = lines.line.Name;
                                //new_Disbursement.Shipments_Program_Service_Line__c = myLine.Id;
                                new_Disbursement.Account__c = lines.line.Carrier_Account__c;
                                listado_insert_disbursemen.add(new_Disbursement);
                            }
                        }
                        catch(Exception e){ ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+e));}
                    }
                }
                
                if(chekeados)
                {
                    //if(listado_insert_disbursemen != null && listado_insert_disbursemen.size()>0)
                       // insert listado_insert_disbursemen;
                    Fee_List_Price=null;
                    List_Fee_Shipment_Import_Export = null;
                    try
                    {
                          boolean tiene_modificacion = false;
                      if(record.Route__c == null && shipment_filter.Route__c != null)
                      {
                        record.Route__c = shipment_filter.Route__c;
                        tiene_modificacion = true; 
                      }
                      
                      
                          
                      system.debug('update_route_service2'+tiene_modificacion);
                      
                      if(tiene_modificacion == true)
                        update record;
                    }
                    catch(Exception ex)
                    {
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex));
                    }
                }
                string id_record = record.Id;
                totales = database.query('select id, Total_Services_Sell_Amount__c'+NEU_CurrencyUtils.CurrencyISOCode()+', NUM_Total_Services_Std_Buy_Amount__c, NUM_Total_Services_Sell_Amount__c,  Total_Services_Std_Buy_Amount__c, Service_Charges_Kg__c, Service_Charges_m3__c from Shipment_Program__c where id =: id_record ');
                totals_custom = new totales_s(totales);
               // Fee_List_Price = null; 
               //shipfeeLines_all_categories = null;
            }
            
        }
        
  public void delete_fee_select() 
  {
  		if (!Schema.sObjectType.Shipment_Program_Line__c.isDeletable()) 
      	{
	   		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access to delete status'));
    		return;
		}
  	
      List<Shipment_Program_Line__c> lines_del = null;
      lines_del=[select Id,Name, Service_Rate_Name__c from Shipment_Program_Line__c where  Id =:id_oi];
      try
      {
        delete lines_del;
        shipfeeLines = null; 
        shipfeeLines_all_categories = null;
        List_Fee_Shipment_Import_Export =null;
        string id_record = record.Id;
        totales = database.query('select id, Total_Services_Sell_Amount__c '+NEU_CurrencyUtils.CurrencyISOCode()+', NUM_Total_Services_Std_Buy_Amount__c, NUM_Total_Services_Sell_Amount__c,  Total_Services_Std_Buy_Amount__c, Service_Charges_Kg__c, Service_Charges_m3__c from Shipment_Program__c where id =: id_record ');
        totals_custom = new totales_s(totales);
      } 
     catch(Exception ex){}
  }
  
  public void delete_ship_fee_line_select() 
  {
  	  if(!Schema.sObjectType.Shipment_Fee_Line__c.isDeletable()) 
      {
   		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access to delete status'));
		return;
	  }
  	
      List<Shipment_Fee_Line__c> lines_del = null;
      lines_del=[select Id,Name from Shipment_Fee_Line__c where  Id =:id_ship_fee_line];
      try
      {
        delete lines_del;
        Fee_List_Price2 = null;
        List_Fee_Shipment_Import_Export =null;
        string id_record = record.Id;
        totales = database.query('select id, Total_Services_Sell_Amount__c'+NEU_CurrencyUtils.CurrencyISOCode()+', NUM_Total_Services_Std_Buy_Amount__c, NUM_Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Service_Charges_Kg__c, Service_Charges_m3__c from Shipment_Program__c where id =: id_record ');
        totals_custom = new totales_s(totales);
      } 
     catch(Exception ex){}
  }
    
     public PageReference return_shipment()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
        
    public void update_route()
    {
    
            try
            {
              boolean tiene_modificacion = false;
              if(record.Route__c == null && shipment_filter.Route__c != null)
              {
                record.Route__c = shipment_filter.Route__c;
                tiene_modificacion = true;
              }

              system.debug('update_route_service'+tiene_modificacion);
              if(tiene_modificacion == true)
                update record;
            }
            catch(Exception ex) { }
        
        
        /*String returnUrl = '/apex/NEU_OM_ShipFeeLinesPriceListYDiscount'; 
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.getParameters().put('id', record.Id);
        pgReturnPage.getParameters().put('pes', getnewcategory());
        pgReturnPage.setRedirect(true);
        return pgReturnPage;*/
 
    }
}