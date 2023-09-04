public with sharing class NEU_FreightSourcingQuote_IE
{
  public Customer_Quote__c record;
  public List<Fee__c> service_rates {get;set;}
  public boolean display_only_active_rates {get;set;}
  public Fee__c record_filter{get;set;}
  public String orden_fees_filtro_modo {get;set;}
  public String orden_fees_filtro {get;set;}
  public Set<Id> listado_rutas_posibles = null;
  public boolean es_del_community {get;set;}
  
  ApexPages.StandardController con;
            
    public NEU_FreightSourcingQuote_IE(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Route__c, Country_ofLoad__c, Country_ofDischarge__c, State_of_Load__c, State_of_Discharge__c, Site_of_Discharge__c, Site_of_Load__c  from Customer_Quote__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Customer_Quote__c();
        }
        
        orden_fees_filtro = 'Name';
        orden_fees_filtro_modo = 'asc';
        
        display_only_active_rates = true;
        record_filter = new Fee__c();
        
        es_del_community = false;
        List<User> this_user = [select Id, contactid from User where Id =: userinfo.getUserId()];
        if(this_user[0].contactid != null)
        	es_del_community = true;
        
        listado_rutas_posibles = new Set<Id>();
        if(record.Route__c != null)
        	listado_rutas_posibles.add(record.Route__c);
       
        //consulta para obtener todas las rutas posibles
        string query_routes_string = '';
        query_routes_string += 'select Id, Name from Carrier_Line_Load_Point__c ';  
        query_routes_string += 'where (Country_of_Discharge__c = '+(record.Country_ofDischarge__c != null ? '\''+record.Country_ofDischarge__c+'\'': null )+' or Country_of_Discharge__c = null or (Country_of_Discharge__c = '+(record.Country_ofLoad__c != null ? '\''+record.Country_ofLoad__c+'\'': null )+' and Country_of_Load__c = null))';
        query_routes_string += ' and (Country_of_Load__c =  '+(record.Country_ofLoad__c != null ? '\''+record.Country_ofLoad__c+'\'': null )+' or Country_of_Load__c = null or (Country_of_Load__c = '+(record.Country_ofDischarge__c != null ? '\''+record.Country_ofDischarge__c+'\'': null )+' and Country_of_Discharge__c = null))';
        if(record.State_of_Discharge__c != null)
        	query_routes_string += ' and (State_of_Discharge__c = '+(record.State_of_Discharge__c != null ? '\''+record.State_of_Discharge__c+'\'': null )+' or State_of_Discharge__c = null or (State_of_Discharge__c = '+(record.State_of_Load__c != null ? '\''+record.State_of_Load__c+'\'': null )+' and State_of_Load__c = null))';
        if(record.State_of_Load__c != null)
        	query_routes_string += ' and (State_of_Load__c = '+(record.State_of_Load__c != null ? '\''+record.State_of_Load__c+'\'': null )+' or State_of_Load__c = null or (State_of_Load__c = '+(record.State_of_Discharge__c != null ? '\''+record.State_of_Discharge__c+'\'': null )+' and State_of_Discharge__c = null))';
        if(record.Site_of_Discharge__c != null)
        	query_routes_string += ' and (Port_Airport_of_Discharge__c = '+(record.Site_of_Discharge__c != null ? '\''+record.Site_of_Discharge__c+'\'': null )+' or Port_Airport_of_Discharge__c = null or (Port_Airport_of_Discharge__c = '+(record.Site_of_Load__c != null ? '\''+record.Site_of_Load__c+'\'': null )+' and Port_Airport_of_Load__c = null))';
        if(record.Site_of_Load__c != null)
        	query_routes_string += ' and (Port_Airport_of_Load__c = '+(record.Site_of_Load__c != null ? '\''+record.Site_of_Load__c+'\'': null )+' or Port_Airport_of_Load__c = null or (Port_Airport_of_Load__c = '+(record.Site_of_Discharge__c != null ? '\''+record.Site_of_Discharge__c+'\'': null )+' and Port_Airport_of_Discharge__c = null))';
        
        List<Carrier_Line_Load_Point__c> query_routes = Database.query(query_routes_string);
        
        for(Carrier_Line_Load_Point__c rou : query_routes)
        {
        	listado_rutas_posibles.add(rou.Id);
        }         
        
        service_rates = [select Id, Name, Fee_Category__c, Account_for__c, Account_for__r.Name,Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Pallet_Type__c, Pallet_Type__r.Name,
        Cost_Concept_1__c, Cost_Concept_2__c,Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Carrier_Account__c, Carrier_Account__r.Name, TT_Days__c, Rate_Type__c, Container_Type__c,
        Container_Type__r.Name, Buy_Rate__c, Fee_Rate__c, Valid_Until__c, Active__c
        from Fee__c where Route__c IN:listado_rutas_posibles  and Active__c=: true and Route__c != null];
        
        
    }
    
    public void ordenar_tabla_fees()
    {
    	String route_values = '';
    	if(listado_rutas_posibles != null)
    	{
	        for(Id i : listado_rutas_posibles)
	        {
	            route_values += '\''+i+'\''+',';
	        }
    	}
    	system.debug('holaa '+route_values.subString(0,route_values.length()-1));
        string query_fees = 'select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Fee_Category__c, Pallet_Type__c, Pallet_Type__r.Name, Carrier_Account__c, Carrier_Account__r.Name, TT_Days__c, Rate_Type__c, Container_Type__c, Account_for__c, Account_for__r.Name,';
        query_fees  +=' Container_Type__r.Name, Buy_Rate__c, Fee_Rate__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Valid_Until__c, Active__c';
        query_fees  +=' from Fee__c';
        if(route_values != '')
        	query_fees  +=' where Route__c IN ('+route_values.subString(0,route_values.length()-1)+')'; 
       
        if(record_filter != null && record_filter.Carrier_Account__c != null)
           query_fees  +=' and Carrier_Account__c = \'' + record_filter.Carrier_Account__c + '\'';
        if(display_only_active_rates == true)
           query_fees  +='  and Active__c = true';
        
        query_fees  +=' order by ' + String.escapeSingleQuotes(orden_fees_filtro+' '+orden_fees_filtro_modo) + ' nulls last';
        
        service_rates = Database.query(query_fees );
    }
}