public with sharing class NEU_FreightRates_ShipmentsPrograms {


  public Shipment_Program__c record;
  public List<Fee__c> service_rates {get;set;}
  public boolean display_only_active_rates {get;set;}
  public Fee__c record_filter{get;set;}
  public String orden_fees_filtro_modo {get;set;}
  public String orden_fees_filtro {get;set;}
  public Set<Id> listado_rutas_posibles = null;
  
  ApexPages.StandardController con;
            
    public NEU_FreightRates_ShipmentsPrograms(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Route__c, Route__r.Country_of_Discharge__c,
        Route__r.Country_of_Load__c,
        Route__r.State_of_Load__c, Route__r.Port_Airport_of_Discharge__c,
        Route__r.Port_Airport_of_Load__c
        from Shipment_Program__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment_Program__c();
        }
        
        orden_fees_filtro = 'Name';
        orden_fees_filtro_modo = 'asc';
        
        display_only_active_rates = true;
        record_filter = new Fee__c();
        
        listado_rutas_posibles = new Set<Id>();
        if(record.Route__c != null)
          listado_rutas_posibles.add(record.Route__c);
          
        //consulta para obtener todas las rutas posibles
        
        List<Carrier_Line_Load_Point__c> query_routes = [
        select Id, Name, Port_Airport_of_Load__c, Port_Airport_of_Discharge__c 
        from Carrier_Line_Load_Point__c  
        where (Country_of_Discharge__c =: record.Route__r.Country_of_Discharge__c or Country_of_Discharge__c =: null or (Country_of_Discharge__c =: record.Route__r.Country_of_Load__c and Country_of_Load__c =: null))
        and (Country_of_Load__c =: record.Route__r.Country_of_Load__c or Country_of_Load__c =: null or (Country_of_Load__c =: record.Route__r.Country_of_Discharge__c and Country_of_Discharge__c =: null))
        and (State_of_Discharge__c =: record.Route__r.State_of_Discharge__c or State_of_Discharge__c =: null or (State_of_Discharge__c =: record.Route__r.State_of_Load__c and State_of_Load__c =: null))
        and (State_of_Load__c =: record.Route__r.State_of_Load__c or State_of_Load__c =: null or (State_of_Load__c =: record.Route__r.State_of_Discharge__c and State_of_Discharge__c =: null))
        and (Port_Airport_of_Discharge__c =: record.Route__r.Port_Airport_of_Discharge__c or Port_Airport_of_Discharge__c =: null or (Port_Airport_of_Discharge__c =: record.Route__r.Port_Airport_of_Load__c and Port_Airport_of_Load__c =: null))
        and (Port_Airport_of_Load__c =: record.Route__r.Port_Airport_of_Load__c or Port_Airport_of_Load__c =: null or (Port_Airport_of_Load__c =: record.Route__r.Port_Airport_of_Discharge__c and Port_Airport_of_Discharge__c =: null))];
        
        for(Carrier_Line_Load_Point__c rou : query_routes)
        {
            listado_rutas_posibles.add(rou.Id);
        }           
          
        
        service_rates = [select Id, Name, Fee_Category__c, Carrier_Account__c, Carrier_Account__r.Name, TT_Days__c, Rate_Type__c, Container_Type__c, Account_for__c, Account_for__r.Name, Pallet_Type__c, Pallet_Type__r.Name, 
        Container_Type__r.Name, Buy_Rate__c, Fee_Rate__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Valid_Until__c, Active__c
        from Fee__c where Route__c IN:listado_rutas_posibles and Active__c=: true and Route__c != null order by Name asc];
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
      
        string query_fees = 'select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Fee_Category__c, Pallet_Type__c, Pallet_Type__r.Name,  Carrier_Account__c, Carrier_Account__r.Name, TT_Days__c, Rate_Type__c, Container_Type__c, Account_for__c, Account_for__r.Name,';
        query_fees  +=' Container_Type__r.Name, Buy_Rate__c, Fee_Rate__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Valid_Until__c, Active__c';
          query_fees  +=' from Fee__c where Name != null ';
        if(route_values != '')
          query_fees  +=' and Route__c IN ('+route_values.subString(0,route_values.length()-1)+') and Route__c != null'; 
        if(record_filter != null && record_filter.Carrier_Account__c != null)
           query_fees  +=' and Carrier_Account__c = \'' + record_filter.Carrier_Account__c + '\'';
        if(display_only_active_rates == true)
           query_fees  +='  and Active__c = true';
           
        query_fees  +=' order by '+ String.escapeSingleQuotes(orden_fees_filtro+' '+orden_fees_filtro_modo) +' nulls last';
        system.debug('NEU_FreightRates_ShipmentsPrograms ordenar_tabla_fees'+ query_fees  );
        service_rates = Database.query(query_fees);
    }
}