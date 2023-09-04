public with sharing class NEU_Freight_Rates_Management_Route 
{
  public Carrier_Line_Load_Point__c record;
  public List<Fee__c> service_rates {get;set;}
  public boolean display_only_active_rates {get;set;}
  public Fee__c record_filter{get;set;}
  public String orden_fees_filtro_modo {get;set;}
  public String orden_fees_filtro {get;set;}
  public Boolean es_del_community {get;set;}
  
  
  ApexPages.StandardController con;
            
    public NEU_Freight_Rates_Management_Route(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name from Carrier_Line_Load_Point__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Carrier_Line_Load_Point__c();
        }
        
        orden_fees_filtro = 'Name';
        orden_fees_filtro_modo = 'asc';
        
        display_only_active_rates = true;
        record_filter = new Fee__c();
        
        es_del_community = false;
        List<User> this_user = [select Id, contactid from User where Id =: userinfo.getUserId()];
        if(this_user[0].contactid != null)
        	es_del_community = true;
        
        service_rates = [select Id, Name, Fee_Category__c, Carrier_Account__c, Carrier_Account__r.Name, TT_Days__c, Pallet_Type__c, Pallet_Type__r.Name, Rate_Type__c, Container_Type__c, Account_for__c, Account_for__r.Name,
        Container_Type__r.Name, Buy_Rate__c, Fee_Rate__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Valid_Until__c, Active__c
        from Fee__c where Route__c =: record.Id and Active__c=: true and Route__c != null order by Buy_Rate__c asc];
    }
    
    public void ordenar_tabla_fees()
    {
    	Id id_record = record.Id;
        string query_fees = 'select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Fee_Category__c, Pallet_Type__c, Pallet_Type__r.Name, Carrier_Account__c, Carrier_Account__r.Name, TT_Days__c, Rate_Type__c, Container_Type__c, Account_for__c, Account_for__r.Name,';
        query_fees  +=' Container_Type__r.Name, Buy_Rate__c, Fee_Rate__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Valid_Until__c, Active__c';
        query_fees  +=' from Fee__c where (Route__c =: id_record';
        query_fees  +=' ) and Route__c != null';
        if(record_filter != null && record_filter.Carrier_Account__c != null)
           query_fees  +=' and Carrier_Account__c = \'' + record_filter.Carrier_Account__c + '\'';
        if(display_only_active_rates == true)
           query_fees  +='  and Active__c = true';
           
        //SOSL Injection   
        query_fees  +=' order by ' + String.escapeSingleQuotes(orden_fees_filtro+' '+orden_fees_filtro_modo) + ' nulls last';
        
        service_rates = Database.query(query_fees );
    }
}