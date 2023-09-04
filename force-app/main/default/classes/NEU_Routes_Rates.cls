public with sharing class NEU_Routes_Rates {
    
    public Carrier_Line_Load_Point__c new_filter_route {get;set;}
    public Fee__c new_filter_fee{get;set;}
    public Fee__c new_fee_active{get;set;}
    public Fee__c new_fee_desactive{get;set;}
    public List<Carrier_Line_Load_Point_s> list_route = null;
    public String rate_category_list {get;set;}
    public String rate_category_buttons {get;set;}
    public String orden_route {get;set;}
    public String modo_orden_route {get;set;}
    
    public NEU_Routes_Rates() 
    {
        new_filter_route = new Carrier_Line_Load_Point__c();
        new_filter_fee = new Fee__c(); 
        rate_category_list = '';
        rate_category_buttons = '';
        
        new_fee_active = new Fee__c();
        new_fee_active.Active__c = true;
        new_fee_desactive = new Fee__c();
        new_fee_desactive.Active__c = false;
        
        orden_route = 'CreatedDate';
        modo_orden_route = 'desc';
        
        //FILTRO CATEGORY FEE
        Schema.DescribeFieldResult fieldResult1 = Fee__c.Fee_Category__c.getDescribe();
        List<Schema.PicklistEntry> sta = fieldResult1.getPicklistValues();
        for(Schema.PicklistEntry s : sta)
        {
              rate_category_buttons += '<input type="button" value="'+s.getValue()+'" class="btn filter_button1 filter_button_category" name="'+s.getValue()+'" onclick="$(this).filter_category();"/>';
        }
        
    }
    
    //OPERATOR Valid_Until list
    public String Valid_Until_selected {get;set;}
    public List<SelectOption> getValid_Until_list() 
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
    
    public void search_routes()
    {
        list_route = null;
    }
    
    public void go_compare()
    {
        list_route = null;
    }
    
    public class valores_ids_s
    {
        public string Id{get; set;}
        public string Name{get; set;}
        public boolean el_ultimo{get; set;}
        public Date fecha_mas_antigua{get; set;}
        public valores_ids_s(string Id, string Name, boolean el_ultimo, Date fecha_mas_antigua)
        {
            this.Id = Id;
            this.Name = Name;
            this.el_ultimo = el_ultimo; 
            this.fecha_mas_antigua = fecha_mas_antigua;
        }
    }
    
    public class Carrier_Line_Load_Point_s
    {
         public Carrier_Line_Load_Point__c ruta {get; set;}
         public List<string> all_rate_category{get; set;}
         public List<valores_ids_s> Listado_carriers{get; set;}
         public List<valores_ids_s> Listado_account_for{get; set;}
         public decimal numero_tramos{get; set;}
         public Carrier_Line_Load_Point_s(Carrier_Line_Load_Point__c ruta, List<string> all_rate_category, List<valores_ids_s> Listado_carriers, List<valores_ids_s> Listado_account_for)
         {
             this.ruta = ruta;
             this.all_rate_category = all_rate_category;
             this.Listado_carriers = Listado_carriers;
             this.Listado_account_for = Listado_account_for;
         }
    }
    
    public List<Carrier_Line_Load_Point_s> getlist_route()
    {
        if(list_route == null)
        {
            list_route = new list<Carrier_Line_Load_Point_s>();
            
            //FILTROS
             String[] cat = (rate_category_list != null ? rate_category_list.replace('[','').replace(']','').split(',',0) : new String[]{});
             String cat_values = '';
             for(String s : cat)
             {
                 cat_values += '\''+s+'\''+',';
             }
             
            //QUERY ROUTES 
            string query_routes = '';
            query_routes +='select Id, Name, Country_of_Load__c, Country_of_Load__r.Name, State_of_Load__c, State_of_Load__r.Name, Port_Airport_of_Load__c, Port_Airport_of_Load__r.Name,';
            query_routes +=' Country_of_Discharge__c, Country_of_Discharge__r.Name, State_of_Discharge__c, State_of_Discharge__r.Name, Port_Airport_of_Discharge__c, Port_Airport_of_Discharge__r.Name from Carrier_Line_Load_Point__c where Name != null ';
            
            if(new_filter_route != null)
            {
                if(new_filter_route.Country_of_Load__c != null)
                {
                    query_routes +=' and Country_of_Load__c =\''+ new_filter_route.Country_of_Load__c +'\' ';
                }
                
                if(new_filter_route.State_of_Load__c != null)
                {
                    query_routes +=' and State_of_Load__c =\''+ new_filter_route.State_of_Load__c +'\' ';
                }
                
                if(new_filter_route.Port_Airport_of_Load__c != null)
                {
                    query_routes +=' and Port_Airport_of_Load__c =\''+ new_filter_route.Port_Airport_of_Load__c +'\' ';
                }
                
                if(new_filter_route.Country_of_Discharge__c != null)
                {
                    query_routes +=' and Country_of_Discharge__c =\''+ new_filter_route.Country_of_Discharge__c +'\' ';
                }
                
                if(new_filter_route.State_of_Discharge__c != null)
                {
                    query_routes +=' and State_of_Discharge__c =\''+ new_filter_route.State_of_Discharge__c +'\' ';
                }
                
                if(new_filter_route.Port_Airport_of_Discharge__c != null)
                {
                    query_routes +=' and Port_Airport_of_Discharge__c =\''+ new_filter_route.Port_Airport_of_Discharge__c +'\' ';
                }   
            }
            
            string orden_route_query = '';
            if(orden_route != null && orden_route != '')
                orden_route_query = orden_route.replace('ruta.', '');
            query_routes += ' order by '+orden_route_query +' '+ modo_orden_route;
            
            query_routes += ' limit 100';
            List<Carrier_Line_Load_Point__c> query_route =  Database.query(query_routes);
            
            //conseguir los valores de cada ruta
            string query_fees = '';
            query_fees +='select Id, Name, Carrier_Account__c, Valid_Until__c, Carrier_Account__r.Name, Account_for__c, Account_for__r.Name, ';
            query_fees +=' Fee_Category__c, Route__c from Fee__c where Route__c != null ';
            
            if(new_filter_route != null)
            {
                if(new_filter_route.Country_of_Load__c != null)
                {
                    query_fees +=' and Route__r.Country_of_Load__c =\''+ new_filter_route.Country_of_Load__c +'\' ';
                }
                
                if(new_filter_route.State_of_Load__c != null)
                {
                    query_fees +=' and Route__r.State_of_Load__c =\''+ new_filter_route.State_of_Load__c +'\' ';
                }
                
                if(new_filter_route.Port_Airport_of_Load__c != null)
                {
                    query_fees +=' and Route__r.Port_Airport_of_Load__c =\''+ new_filter_route.Port_Airport_of_Load__c +'\' ';
                }
                
                if(new_filter_route.Country_of_Discharge__c != null)
                {
                    query_fees +=' and Route__r.Country_of_Discharge__c =\''+ new_filter_route.Country_of_Discharge__c +'\' ';
                }
                
                if(new_filter_route.State_of_Discharge__c != null)
                {
                    query_fees +=' and Route__r.State_of_Discharge__c =\''+ new_filter_route.State_of_Discharge__c +'\' ';
                }
                
                if(new_filter_route.Port_Airport_of_Discharge__c != null)
                {
                    query_fees +=' and Route__r.Port_Airport_of_Discharge__c =\''+ new_filter_route.Port_Airport_of_Discharge__c +'\' ';
                }   
            }
            
            if(cat_values != null && cat_values != '' && cat_values.subString(0,cat_values.length()-1) != '\'\'')
                query_fees += ' '+(rate_category_list != '[]' ? 'and Fee_Category__c IN ('+cat_values.subString(0,cat_values.length()-1)+')' : '');
      
            
            if(new_filter_fee != null)
            {
                if(new_filter_fee.Carrier_Account__c != null)
                {
                    query_fees +=' and Carrier_Account__c =\''+ new_filter_fee.Carrier_Account__c +'\' ';
                }
                
                if(new_filter_fee.Account_for__c != null)
                {
                    query_fees +=' and Account_for__c =\''+ new_filter_fee.Account_for__c +'\' ';
                }
                
                if(new_filter_fee.Valid_Until__c != null)
                {
                    String valid_until = String.valueof(new_filter_fee.Valid_Until__c).replace(' ','T');// + 'Z';
                    
                     String operator = '';
                     if(Valid_Until_selected == 'equal')operator = '=';
                     if(Valid_Until_selected == 'not equal to')operator = '!=';
                     if(Valid_Until_selected == 'less than')operator = '<';
                     if(Valid_Until_selected == 'greater than')operator = '>';
                     if(Valid_Until_selected == 'less or equal')operator = '<=';
                     if(Valid_Until_selected == 'greater or equal')operator = '>=';
                     query_fees += ' and Valid_Until__c '+operator+' '+valid_until;
                }
            }
            
             
            query_fees +=' and Route__c IN :query_route ';
                
            string orden_fee_query = 'CreatedDate desc';
            if(orden_route != null && orden_route != '')
                orden_fee_query = orden_route.replace('ruta.', 'Route__r.') +' '+modo_orden_route ;
                
            query_fees +=' order by Route__c';
            List<Fee__c> listado_fees = Database.query(query_fees);
            Map<Id,List<valores_ids_s>> todos_los_carriers = new Map<Id,List<valores_ids_s>>();
            Map<Id,List<valores_ids_s>> todos_los_account_for = new Map<Id,List<valores_ids_s>>();
            Map<Id,List<string>> todos_las_categorias = new Map<Id,List<string>>();
            string contenedor_categorias = '';
            string contenedor_carriers = '';
            string contenedor_account_for = '';
            
            string ultima_ruta = '';
            Date fecha_ultima = null; 
            for(Fee__c f : listado_fees)
            {
                if(todos_los_carriers.containsKey(f.Route__c))
                {
                  if(f.Valid_Until__c != null)
                  {
                    if(fecha_ultima != null)
                    {
                        if(fecha_ultima < f.Valid_Until__c)
                            fecha_ultima = f.Valid_Until__c;//guardar la fecha mas nueva para sacar en la ruote
                    }
                    else
                        fecha_ultima = f.Valid_Until__c;
                  }
                    
                  if(f.Carrier_Account__c != null)
                    if(contenedor_carriers.contains(f.Carrier_Account__c) == false)
                        todos_los_carriers.get(f.Route__c).add(new valores_ids_s(f.Carrier_Account__c, f.Carrier_Account__r.Name, false, fecha_ultima));
                        
                  if(f.Account_for__c != null)
                    if(contenedor_account_for.contains(f.Account_for__c) == false)      
                        todos_los_account_for.get(f.Route__c).add(new valores_ids_s(f.Account_for__c, f.Account_for__r.Name, false, fecha_ultima));
                  
                  if(f.Fee_Category__c != null)
                    if(contenedor_categorias.contains(f.Fee_Category__c) == false)
                        todos_las_categorias.get(f.Route__c).add(f.Fee_Category__c);
                }
                else
                {
                    contenedor_categorias = '';
                    contenedor_carriers = '';
                    contenedor_account_for = '';
                    fecha_ultima = null;
                    if(ultima_ruta != '')
                    {
                        if(todos_los_carriers.get(ultima_ruta).size()>0)
                            todos_los_carriers.get(ultima_ruta)[todos_los_carriers.get(ultima_ruta).size()-1].el_ultimo = true;
                        
                        if(todos_los_account_for.get(ultima_ruta).size()>0)
                            todos_los_account_for.get(ultima_ruta)[todos_los_account_for.get(ultima_ruta).size()-1].el_ultimo = true;   
                    } 
                    
                    todos_los_carriers.put(f.Route__c, new List<valores_ids_s>{new valores_ids_s(f.Carrier_Account__c, f.Carrier_Account__r.Name, false, f.Valid_Until__c)});
                    todos_los_account_for.put(f.Route__c, new List<valores_ids_s>{new valores_ids_s(f.Account_for__c, f.Account_for__r.Name, false, f.Valid_Until__c)});
                    todos_las_categorias.put(f.Route__c, new List<string>{f.Fee_Category__c});

                    ultima_ruta = f.Route__c;
                    fecha_ultima = f.Valid_Until__c;
                }
                
                contenedor_categorias +=f.Fee_Category__c;
                contenedor_carriers +=f.Carrier_Account__c;
                contenedor_account_for +=f.Account_for__c;
            }
            
            
            
            for(Carrier_Line_Load_Point__c cllp: query_route)
            {
                if(new_filter_fee.Carrier_Account__c != null || new_filter_fee.Account_for__c != null || (rate_category_list != '[]' && rate_category_list  != null && rate_category_list != '') || new_filter_fee.Valid_Until__c != null)
                {

                    if(new_filter_fee.Carrier_Account__c != null)
                        if(todos_los_carriers.containsKey(cllp.Id) == false)
                            continue;
                    
                    if(new_filter_fee.Account_for__c != null)
                        if(todos_los_account_for.containsKey(cllp.Id) == false)
                            continue;
                    
                    if(rate_category_list != '[]')
                        if(todos_las_categorias.containsKey(cllp.Id) == false)
                            continue;   

                    if(new_filter_fee.Valid_Until__c != null)
                    {
                        if(todos_los_account_for.containsKey(cllp.Id))
                        {
                            if(todos_los_account_for.get(cllp.Id)[integer.valueof(todos_los_account_for.get(cllp.Id).size()-1)].fecha_mas_antigua != null)
                            {
                                if(Valid_Until_selected == 'equal')
                                    if(todos_los_account_for.get(cllp.Id)[integer.valueof(todos_los_account_for.get(cllp.Id).size()-1)].fecha_mas_antigua  != new_filter_fee.Valid_Until__c)
                                        continue;
                    
                                if(Valid_Until_selected == 'not equal to')
                                    if(todos_los_account_for.get(cllp.Id)[integer.valueof(todos_los_account_for.get(cllp.Id).size()-1)].fecha_mas_antigua  == new_filter_fee.Valid_Until__c)
                                        continue;   
                                if(Valid_Until_selected == 'less than' || Valid_Until_selected == 'less or equal')
                                    if(todos_los_account_for.get(cllp.Id)[integer.valueof(todos_los_account_for.get(cllp.Id).size()-1)].fecha_mas_antigua  > new_filter_fee.Valid_Until__c)
                                        continue;   
                                if(Valid_Until_selected == 'greater than' || Valid_Until_selected == 'greater or equal')
                                    if(todos_los_account_for.get(cllp.Id)[integer.valueof(todos_los_account_for.get(cllp.Id).size()-1)].fecha_mas_antigua  < new_filter_fee.Valid_Until__c)
                                        continue;
                            }
                            else
                                continue;
                        }//si relleno el filtro los vacios no salen
                        else 
                            continue;       
                    }   
                
                     list_route.add(new Carrier_Line_Load_Point_s(cllp,//ruta
                     (todos_las_categorias.containsKey(cllp.Id) ? todos_las_categorias.get(cllp.Id) : null),//categorias
                     (todos_los_carriers.containsKey(cllp.Id) ? todos_los_carriers.get(cllp.Id) : null), //carriers
                     (todos_los_account_for.containsKey(cllp.Id) ? todos_los_account_for.get(cllp.Id) : null)//account for
                     ));//numero de tramos
                
                }
                else
                {
                    list_route.add(new Carrier_Line_Load_Point_s(cllp,//ruta
                    (todos_las_categorias.containsKey(cllp.Id) ? todos_las_categorias.get(cllp.Id) : null),//categorias
                    (todos_los_carriers.containsKey(cllp.Id) ? todos_los_carriers.get(cllp.Id) : null), //carriers
                    (todos_los_account_for.containsKey(cllp.Id) ? todos_los_account_for.get(cllp.Id) : null)//account for
                    ));//numero de tramos
                }
                
            }
        }
        return list_route;
    }
}