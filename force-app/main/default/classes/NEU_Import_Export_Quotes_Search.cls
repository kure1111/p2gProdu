public with sharing class NEU_Import_Export_Quotes_Search {
    
  public String ie_status {get;set;}
  public String service_mode {get;set;}
  public Customer_Quote__c record {get;set;}
  public List<Import_Export_Quotes_s> ie_quotes {get;set;}
  public List<Import_Export_Quotes_s> ie_orders {get;set;}
  public String sta_list {get;set;}
  public String serv_list {get;set;}
  public boolean click_search {get;set;}
  public String id_record_type_quote {get;set;}
  public String id_record_type_order {get;set;}
  public String orden_filtro_quotes {get;set;}
  public String orden_filtro_quotes_modo {get;set;}
  public String orden_filtro_order {get;set;}
  public String orden_filtro_order_modo {get;set;}
  
  public String id_quote {get;set;}
  public String params {get;set;}
  
  public Decimal total_quotes {get;set;}
  public Decimal total_orders {get;set;}
  public List<Integer> listado_paginas_Quotes {get;set;}
  public List<Integer> listado_paginas_Orders {get;set;}
  public string step_Instalacion {get;set;}
  public string step_order {get;set;}
  public Customer_Quote__c filter_status_order {get;set;}
  public Customer_Quote__c filter_status_quote {get;set;}
  public string ids_ie_orders {get;set;}
  public string ids_ie_quotes {get;set;}
  public integer n_records_per_page = 100;
  
  
  
  public class Import_Export_Quotes_s
  {
    public Customer_Quote__c import_export {get;set;}
    public List<Associated_Document__c> documents {get;set;}
    
    public Import_Export_Quotes_s(Customer_Quote__c import_export, List<Associated_Document__c> documents)
    {
      this.import_export = import_export;
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

    public NEU_Import_Export_Quotes_Search() 
    {
        
        
    }
  
  public void carga_filtros()
  {  
    record = new Customer_Quote__c();
    record.Created_From__c = system.today().addMonths(-1);
    record.Created_To__c = system.today();
    id_record_type_quote = '';
    id_record_type_order = '';
    if(Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId() != null)
        id_record_type_quote = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
    if(Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId() != null)
        id_record_type_order = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId();
            
    //FILTRO IMPORT_EXPORT STATUS
    ie_status = '';
    Schema.DescribeFieldResult fieldResult1 = Customer_Quote__c.Quotation_Status__c.getDescribe();
    List<Schema.PicklistEntry> sta = fieldResult1.getPicklistValues();
    for(Schema.PicklistEntry s : sta)
    {
        
        ie_status += '<input type="button" value="'+s.getValue()+'" class="btn filter_button1 filter_button_sta" name="'+s.getValue()+'" onclick="$(this).filter_sta();"/>';
    }
    
    ie_status += '<input type="button" value="No Status" class="btn filter_button1 filter_button_sta" name="No Status" onclick="$(this).filter_sta();"/>';
    
    //FILTRO SERVICE MODE
    service_mode = '';
    Schema.DescribeFieldResult fieldResult2 = Customer_Quote__c.Service_Mode__c.getDescribe();
    List<Schema.PicklistEntry> serv = fieldResult2.getPicklistValues();
    for(Schema.PicklistEntry s : serv)
    {
        service_mode += '<input type="button" value="'+s.getValue()+'" class="btn filter_button2 filter_button_serv" name="'+s.getValue()+'" onclick="$(this).filter_serv();"/>';
    }
    
    ie_quotes = new List<Import_Export_Quotes_s>();
    ie_orders = new List<Import_Export_Quotes_s>();
    
    orden_filtro_quotes = 'CreatedDate';
    orden_filtro_quotes_modo = 'desc';
    orden_filtro_order = 'CreatedDate';
    orden_filtro_order_modo = 'desc';
    
    filter_status_order = new Customer_Quote__c();
    filter_status_order.RecordTypeId = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId();
    
    filter_status_quote = new Customer_Quote__c();
    filter_status_quote.RecordTypeId = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
    
    //ids_actualizar_status
    ids_ie_quotes = '';
    ids_ie_orders = '';
    //Paginacion 
    listado_paginas_Quotes = new List<Integer>();
    listado_paginas_Orders = new List<Integer>();
    
    total_quotes = 0;
    if(record.Created_From__c != null && record.Created_To__c != null)
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName =: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted' and CreatedDate >=: record.Created_From__c and CreatedDate <=: record.Created_To__c.addDays(1)]) total_quotes += (Integer)result.get('expr0');
    else if(record.Created_From__c != null && record.Created_To__c == null)
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName =: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted' and CreatedDate >=: record.Created_From__c]) total_quotes += (Integer)result.get('expr0');
    else if(record.Created_From__c == null && record.Created_To__c != null)
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName =: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted' and CreatedDate <=: record.Created_To__c.addDays(1) ]) total_quotes += (Integer)result.get('expr0');
    else
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName =: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted' ]) total_quotes += (Integer)result.get('expr0');
    step_Instalacion = '1';
    //coger todas y pintar la lista
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    
    List<Id> listado_ids_ie = new List<Id>();
    
    integer contador_ie = 0;
    
    List<Customer_Quote__c> new_ies = null; 
    
        new_ies = new List<Customer_Quote__c>();
        
            string query_quotes = 'select Id, Name,  Quotation_Status__c, Status_Observations__c, Account_for__c,'; 
            query_quotes +='Account_for__r.Name, Contact__c, Contact__r.Name, Container_Type__c, Container_Count__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
            query_quotes +='Total_Items_Units__c, Total_Weight_Kg2__c, SUM_Sell_Origin_Amount__c, Site_of_Load__c , Site_of_Discharge__c, Total_Volume_m3_2__c, Supplier_Account__c, Container_Type__r.Name, RecordType.Name, RecordType.DeveloperName,';
            query_quotes +='Supplier_Account__r.Name, Origin_Address__c, LastModifiedBy.Name, CreatedBy.Name, Consignee__c, Vessel_Flight__c , Vessel_Flight__r.Name, Vessel_Flight__r.IMO__c , Consignee__r.Name, Destination_Address__c,';
            query_quotes +='Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Services_Profit__c from Customer_Quote__c where RecordType.DeveloperName = \'Import_Export_Quote\' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\' ';
            if(record.Created_From__c != null)
            {
                system.debug(' fecha from '+record.Created_From__c);
                datetime date_from =record.Created_From__c;
                String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                
                //query_quotes +=' and CreatedDate >= '+d_from;
                query_quotes +=' and CreatedDate >=: date_from';
            }
            if(record.Created_To__c != null)
            {
                system.debug(' fecha to'+record.Created_To__c );
                datetime date_to =record.Created_To__c.addDays(1);
                String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                //query_quotes +=' and CreatedDate <= '+d_to;
                query_quotes +=' and CreatedDate <=: date_to';
            }
            query_quotes +=' order by CreatedDate desc limit '+ n_records_per_page;
        system.debug('hola query dates'+ query_quotes);
        new_ies = Database.query(query_quotes);
        for(Customer_Quote__c c : new_ies)
        {
            ie_quotes.add(new Import_Export_Quotes_s(c, null));
        }
        
    //array pintar botones
    for(integer i= 1; i < n_listas; i++)
    {
        listado_paginas_Quotes.add(i);
    }
    
    total_orders = 0;
    if(record.Created_From__c != null && record.Created_To__c != null)
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName !=: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted' and CreatedDate >=: record.Created_From__c and CreatedDate <=: record.Created_To__c.addDays(1)]) total_orders += (Integer)result.get('expr0');
    else if(record.Created_From__c != null && record.Created_To__c == null)
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName !=: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted' and CreatedDate >=: record.Created_From__c ]) total_orders += (Integer)result.get('expr0');
    else if(record.Created_From__c == null && record.Created_To__c != null)
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName !=: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted' and CreatedDate <=: record.Created_To__c.addDays(1)]) total_orders += (Integer)result.get('expr0');
    else
        for (AggregateResult result : [  SELECT COUNT(Id)  FROM Customer_Quote__c where RecordType.DeveloperName !=: 'Import_Export_Quote' and Quotation_Status__c !='Quote Declined' and Quotation_Status__c !='Delivered' and Quotation_Status__c !='Closed' and Quotation_Status__c !='Order Deleted']) total_orders += (Integer)result.get('expr0');
    step_order = '1';
    
    n_listas = (integer)total_orders/n_records_per_page;
    n_listas = n_listas + 2;
    
    listado_ids_ie = new List<Id>();
    
    contador_ie = 0;
    
    new_ies = null; 
    
        new_ies = new List<Customer_Quote__c>();
        
            string query_orders = 'select Id, Name,  Quotation_Status__c, Status_Observations__c, Account_for__c, ';
            query_orders += 'Account_for__r.Name, Contact__c, Contact__r.Name, Container_Type__c, Container_Count__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
            query_orders += 'Total_Items_Units__c, Total_Weight_Kg2__c, SUM_Sell_Origin_Amount__c, Site_of_Load__c , Site_of_Discharge__c, Total_Volume_m3_2__c, Supplier_Account__c, Container_Type__r.Name, RecordType.Name, RecordType.DeveloperName, ';
            query_orders += 'Supplier_Account__r.Name, Origin_Address__c, LastModifiedBy.Name, CreatedBy.Name, Consignee__c, Vessel_Flight__c , Vessel_Flight__r.Name, Vessel_Flight__r.IMO__c , Consignee__r.Name, Destination_Address__c,';
            query_orders += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Services_Profit__c from Customer_Quote__c where RecordType.DeveloperName != \'Import_Export_Quote\' and Quotation_Status__c != \'Quote Declined\' and Quotation_Status__c != \'Delivered\' and Quotation_Status__c != \'Closed\' and Quotation_Status__c != \'Order Deleted\'';
            if(record.Created_From__c != null)
            {
                datetime date_from =record.Created_From__c;
                String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                
                //query_orders +=' and CreatedDate >= '+d_from;
                query_orders +=' and CreatedDate >=: date_from ';
            }
            if(record.Created_To__c != null)
            {
                datetime date_to =record.Created_To__c.addDays(1);
                String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                //query_quotes +=' and CreatedDate <= '+d_to;
                query_quotes +=' and CreatedDate <=: date_to';
            }
            query_orders += ' order by CreatedDate desc limit '+n_records_per_page;
        
        new_ies = Database.query(query_orders);
        for(Customer_Quote__c c : new_ies)
        {
            ie_orders.add(new Import_Export_Quotes_s(c, null));
            
        }
    
    for(integer i= 1; i < n_listas; i++) 
    {
        listado_paginas_Orders.add(i);
        
    }
    
    
    //-----------------------------
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
    click_search = false;
  }
  
   public void anterior_siguiente_Instalacion()
  {
    ie_quotes = null;
    integer n_pagina = 0;
    
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    String sta_values = '';
    for(String s : sta)
    {
      sta_values += '\''+s+'\''+',';
    }
    
    string consulta_filtros = '';
    String consulta = '';
    consulta += 'SELECT Id, Name,  Quotation_Status__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, Container_Count__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Items_Units__c, Total_Weight_Kg2__c, SUM_Sell_Origin_Amount__c, Site_of_Load__c , Site_of_Discharge__c, Total_Volume_m3_2__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, LastModifiedBy.Name, CreatedBy.Name, Origin_Address__c, Vessel_Flight__c , Vessel_Flight__r.Name, Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Services_Profit__c';
    consulta += ' FROM Customer_Quote__c';
    consulta_filtros += ' WHERE Name != \'\'';
    
    if(sta != null && !sta.isEmpty())
    {
        String filter_quotation_status_s = '';
        if(sta_list != '[]')
            sta_values.subString(0,sta_values.length()-1);
        if(sta_values.contains('No Status'))
        {
            consulta_filtros += ' '+(sta_list != '[]' ? 'and (Quotation_Status__c IN :sta or Quotation_Status__c = null)' : '');
            system.debug('hola no status'+consulta);
        }
        else
        {
            consulta_filtros += ' '+(sta_list != '[]' ? 'and Quotation_Status__c IN :sta' : '');
        }
    }
    else
    {
        consulta_filtros += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    }   
    
    
    consulta_filtros += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    
    
   // consulta_filtros += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
      consulta_filtros += ' and (Route__c = \''+record.Route__c+'\'';
      consulta_filtros += ' )';
    }
    
    if(record.Created_From__c != null)
    {
        datetime date_from =record.Created_From__c;
        String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        //consulta_filtros +=' and CreatedDate >= '+d_from;
        consulta_filtros +=' and CreatedDate >=: date_from ';
    }
    if(record.Created_To__c != null)
    {
        datetime date_to =record.Created_To__c.addDays(1);
        String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //consulta_filtros +=' and CreatedDate <= '+d_to;
        consulta_filtros +=' and CreatedDate <=: date_to ';
    }
    
    consulta_filtros += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta_filtros += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta_filtros += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta_filtros += ' '+(record.Vessel_Flight__c != null ? 'and Vessel_Flight__c = \''+record.Vessel_Flight__c+'\'' : ''); 
    consulta_filtros += ' '+(record.User_Create_Import_ExportQuotesSearch__c != null ? 'and CreatedById = \''+record.User_Create_Import_ExportQuotesSearch__c +'\'' : '');//--- ver esto
    consulta_filtros += ' '+(record.User_Modify_Import_ExportQuotesSearch__c != null ? 'and LastModifiedById = \''+record.User_Modify_Import_ExportQuotesSearch__c+'\'' : '');
    if(click_search == false)
      consulta_filtros += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    consulta_filtros += ' and RecordTypeId = \''+ Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId()+'\'';
    
    consulta +=consulta_filtros;
    
    ie_quotes = new List<Import_Export_Quotes_s>();
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;

    integer contador_ie = 0;
    List<Import_Export_Quotes_s> hijo_array_ie = new List<Import_Export_Quotes_s>();
    List<Customer_Quote__c> new_ies = null; 
    //subcontulta
    string sub_consulta = 'SELECT Id from Customer_Quote__c ' +consulta_filtros;
    if(orden_filtro_quotes != null && orden_filtro_quotes != '' && orden_filtro_quotes_modo != null && orden_filtro_quotes_modo != '')
        sub_consulta += ' order by ' + String.escapeSingleQuotes(orden_filtro_quotes.replace('import_export.','')+ ' '+  orden_filtro_quotes_modo) + ' nulls last';
         
    integer numero_registros = integer.valueof(step_Instalacion)*n_records_per_page-n_records_per_page;
    sub_consulta += ' limit '+ numero_registros;
    
    List<Customer_Quote__c> lista_quote_subquery = Database.query(sub_consulta);
    consulta +=' and id NOT IN :lista_quote_subquery ';
    
    if(orden_filtro_quotes != null && orden_filtro_quotes != '' && orden_filtro_quotes_modo != null && orden_filtro_quotes_modo != '')
        consulta += ' order by ' + String.escapeSingleQuotes(orden_filtro_quotes.replace('import_export.','')+ ' '+  orden_filtro_quotes_modo) + '  nulls last';
        
    new_ies = Database.query(consulta + ' limit '+n_records_per_page);
        
    for(Customer_Quote__c c : new_ies)
    {
        ie_quotes.add(new Import_Export_Quotes_s(c, null));
    }
  }
  
  public List<SelectOption> getservices_type()
  {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       Customer_Quote__c.Service_Type__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       options.add(new SelectOption('', '--None--'));     
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
  }
  
  public void update_status_order()
  {
     if(ids_ie_orders != null && ids_ie_orders != '' && filter_status_order != null && filter_status_order.Quotation_Status__c != null)
     {
        String[] ids_status = (ids_ie_orders != null ? ids_ie_orders.split(',',0) : new String[]{});
        String ids = '';
        for(String s : ids_status)
        {
            ids += '\''+s+'\''+',';
        }
        
        if(ids != null && ids != '')
        {
            String list_id_query = ids.subString(0,ids.length()-1);
            String consulta2 = '';
            consulta2 += 'SELECT Id, Name,  Quotation_Status__c from Customer_Quote__c';
            consulta2 += ' where id IN ('+ids.subString(0,ids.length()-1)+')';
            
            List<Customer_Quote__c> all_ies = Database.query(consulta2);
            for(Customer_Quote__c cq : all_ies)
            {
                cq.Quotation_Status__c = filter_status_order.Quotation_Status__c;
            }
            
            if(all_ies != null && all_ies.size()>0)
            {
                update all_ies; 
                
                go_compare_orders();
            }
        }
     }
  }
  
  public void update_status_quote()
  {
        if(ids_ie_quotes != null && ids_ie_quotes != '' && filter_status_quote != null && filter_status_quote.Quotation_Status__c != null)
        {
            String[] ids_status = (ids_ie_quotes != null ? ids_ie_quotes.split(',',0) : new String[]{});
            String ids = '';
            for(String s : ids_status)
            {
                ids += '\''+s+'\''+',';
            }
            
            if(ids != null && ids != '')
            {
                String list_id_query = ids.subString(0,ids.length()-1);
                
                String consulta = '';
                consulta += 'SELECT Id, Name,  Quotation_Status__c from Customer_Quote__c';
                consulta += ' where id IN ('+ids.subString(0,ids.length()-1)+')';
                List<Customer_Quote__c> all_ies = Database.query(consulta);
                for(Customer_Quote__c cq : all_ies)
                {
                    cq.Quotation_Status__c = filter_status_quote.Quotation_Status__c;
                }
                
                if(all_ies != null && all_ies.size()>0)
                {
                    update all_ies;
                    ie_quotes = new List<Import_Export_Quotes_s>();
                    go_compare_quote();
                }
            }
        }
  }
  
  public void anterior_siguiente_order()
  {
    ie_orders = null;
    integer n_pagina = 0;
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    String sta_values = '';
    for(String s : sta)
    {
      sta_values += '\''+s+'\''+',';
    }
    
    
    String consulta_filtros ='';
    String consulta = '';
    consulta += 'SELECT Id, Name,  Quotation_Status__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, Container_Count__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Items_Units__c, Total_Weight_Kg2__c, SUM_Sell_Origin_Amount__c, Site_of_Load__c , Site_of_Discharge__c, Total_Volume_m3_2__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, LastModifiedBy.Name, CreatedBy.Name, Origin_Address__c, Vessel_Flight__c , Vessel_Flight__r.Name, Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Services_Profit__c';
    consulta += ' FROM Customer_Quote__c';
    consulta_filtros += ' WHERE Name != \'\'';
    
    if(sta != null && !sta.isEmpty())
    {
        if(sta_values.contains('No Status'))
        {
            consulta_filtros += ' '+(sta_list != '[]' ? 'and (Quotation_Status__c IN :sta or Quotation_Status__c = null)' : '');
            system.debug('hola no status'+consulta);
        }
        else
        {
            consulta_filtros += ' '+(sta_list != '[]' && sta_list != '' ? 'and Quotation_Status__c IN :sta' : '');
        }
    }
    else
    {
        consulta_filtros += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    } 
    
   
    consulta_filtros += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta_filtros += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    

    //consulta_filtros += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
      consulta_filtros += ' and (Route__c = \''+record.Route__c+'\'';
      consulta_filtros += ' )';
    }
    if(record.Created_From__c != null)
    {
        datetime date_from =record.Created_From__c;
        String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        //consulta_filtros +=' and CreatedDate >= '+d_from;
        consulta_filtros +=' and CreatedDate >=: date_from ';
    }
    if(record.Created_To__c != null)
    {
        datetime date_to =record.Created_To__c.addDays(1);
        String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //consulta_filtros +=' and CreatedDate <= '+d_to;
        consulta_filtros +=' and CreatedDate <=: date_to ';
    }
    //consulta_filtros += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    //consulta_filtros += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
   // consulta_filtros += ' '+(record.Final_Delivery_Account__c != null ? 'and Final_Delivery_Account__c = \''+record.Final_Delivery_Account__c+'\'' : '');
   // consulta_filtros += ' '+(record.Origin_Agent_Account__c != null ? 'and Origin_Agent_Account__c = \''+record.Origin_Agent_Account__c+'\'' : '');
    consulta_filtros += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta_filtros += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta_filtros += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta_filtros += ' '+(record.Vessel_Flight__c != null ? 'and Vessel_Flight__c = \''+record.Vessel_Flight__c+'\'' : ''); 
    consulta_filtros += ' '+(record.User_Create_Import_ExportQuotesSearch__c != null ? 'and CreatedById = \''+record.User_Create_Import_ExportQuotesSearch__c +'\'' : '');//--- ver esto
    consulta_filtros += ' '+(record.User_Modify_Import_ExportQuotesSearch__c != null ? 'and LastModifiedById = \''+record.User_Modify_Import_ExportQuotesSearch__c+'\'' : '');
    if(click_search == false)
      consulta_filtros += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    consulta_filtros += ' and RecordTypeId != \''+ Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId()+'\'';
    consulta += consulta_filtros;

    ie_orders = new List<Import_Export_Quotes_s>();
    
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    
    //Subconsulta
    string sub_consulta = 'SELECT Id from Customer_Quote__c ' +consulta_filtros;
    if(orden_filtro_order != null && orden_filtro_order != '')
        sub_consulta += ' order by '+ String.escapeSingleQuotes(orden_filtro_order.replace('import_export.','')+ ' '+  orden_filtro_order_modo) +' nulls last';
        
    integer numero_registros = integer.valueof(step_order)*n_records_per_page-n_records_per_page;
    sub_consulta += ' limit '+numero_registros;
    
    List<Customer_Quote__c> lista_quote_subquery = Database.query(sub_consulta);
    
    
    integer contador_ie = 0;
    List<Customer_Quote__c> new_ies = null; 
    consulta +=' and id NOT IN :lista_quote_subquery ';
    if(orden_filtro_order != null && orden_filtro_order != '')
        consulta += ' order by '+ String.escapeSingleQuotes(orden_filtro_order.replace('import_export.','')+ ' '+  orden_filtro_order_modo) + ' nulls last';
        
    new_ies = Database.query(consulta+ ' limit '+n_records_per_page);
    
    for(Customer_Quote__c c : new_ies)
    {
        ie_orders.add(new Import_Export_Quotes_s(c, null));
    }
    
  }
  
  public void update_quote_now()
  {
    List<Customer_Quote__c> query_import_export = [select Id, name, Quotation_Status__c from Customer_Quote__c where id=: id_quote];
    if(query_import_export != null && query_import_export.size()>0)
    {
        query_import_export[0].Quotation_Status__c = 'Approved as Succesful';
        update query_import_export;
    }
  }
  
  public void update_quote_now2()
  {
    List<Customer_Quote__c> query_import_export = [select Id, name, Quotation_Status__c from Customer_Quote__c where id=: id_quote];
    if(query_import_export != null && query_import_export.size()>0)
    {
        query_import_export[0].Quotation_Status__c = 'Quote Declined';
        update query_import_export;
    }
  }
  
  //funciones para ordenar
  public void go_compare_quote()// se podrian hacer con el implements compare en lugar de hacer consulta de nuevo pero no se podrian ordenar por separado
  {
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    String sta_values = '';
    for(String s : sta)
    {
      sta_values += '\''+s+'\''+',';
    }
    
    String consulta = '';
    consulta += 'SELECT Id, Name,  Quotation_Status__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, Container_Count__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Items_Units__c, Total_Weight_Kg2__c, SUM_Sell_Origin_Amount__c, Site_of_Load__c, Site_of_Discharge__c, Total_Volume_m3_2__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, LastModifiedBy.Name, CreatedBy.Name, Origin_Address__c, Vessel_Flight__c , Vessel_Flight__r.Name, Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Services_Profit__c';
    consulta += ' FROM Customer_Quote__c';
    consulta += ' WHERE Name != \'\'';
    
    if(sta != null && !sta.isEmpty())
    {
        if(sta_values.contains('No Status'))
        {
            
            consulta += ' '+(sta_list != '[]' ? 'and (Quotation_Status__c IN :sta or Quotation_Status__c = null)' : '');
            system.debug('hola no status'+consulta);
        }
        else
        {
            consulta += ' '+(sta_list != '[]' ? 'and Quotation_Status__c IN :sta' : '');
        }
    }
    else
    {
        consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    }   
    
   
    consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    
    //consulta += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
      consulta += ' and (Route__c = \''+record.Route__c+'\'';
      consulta += ' )';
    }
    if(record.Created_From__c != null)
    {
        datetime date_from =record.Created_From__c;
        String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        //consulta +=' and CreatedDate >= '+d_from;
        consulta +=' and CreatedDate >=: date_from ';
    }
    if(record.Created_To__c != null)
    {
        datetime date_to =record.Created_To__c.addDays(1);
        String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //consulta +=' and CreatedDate <= '+d_to;
        consulta +=' and CreatedDate <=: date_to ';
    }
    //consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    //consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    //consulta += ' '+(record.Final_Delivery_Account__c != null ? 'and Final_Delivery_Account__c = \''+record.Final_Delivery_Account__c+'\'' : '');
    //consulta += ' '+(record.Origin_Agent_Account__c != null ? 'and Origin_Agent_Account__c = \''+record.Origin_Agent_Account__c+'\'' : '');
    consulta += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta += ' '+(record.Vessel_Flight__c != null ? 'and Vessel_Flight__c = \''+record.Vessel_Flight__c+'\'' : ''); 
    consulta += ' '+(record.User_Create_Import_ExportQuotesSearch__c != null ? 'and CreatedById = \''+record.User_Create_Import_ExportQuotesSearch__c +'\'' : '');//--- ver esto
    consulta += ' '+(record.User_Modify_Import_ExportQuotesSearch__c != null ? 'and LastModifiedById = \''+record.User_Modify_Import_ExportQuotesSearch__c+'\'' : '');
    if(click_search == false)
      consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    consulta += ' and RecordTypeId = \''+ Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId()+'\'';
    
    if(orden_filtro_quotes != null && orden_filtro_quotes != '' && orden_filtro_quotes_modo != null && orden_filtro_quotes_modo != '')
        consulta += ' order by '+ String.escapeSingleQuotes(orden_filtro_quotes.replace('import_export.','')+ ' '+  orden_filtro_quotes_modo) +' nulls last';
        
        
    ie_quotes = new List<Import_Export_Quotes_s>();
    
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    
    integer contador_ie = 0;
    List<Import_Export_Quotes_s> hijo_array_ie = new List<Import_Export_Quotes_s>();
    List<Customer_Quote__c> new_ies = null; 

    new_ies = Database.query(consulta+ ' limit '+n_records_per_page);
        
    for(Customer_Quote__c c : new_ies)
    {
        ie_quotes.add(new Import_Export_Quotes_s(c, null));
    }
        
  }
  
  public void go_compare_orders()
  {
    
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    String sta_values = '';
    for(String s : sta)
    {
      sta_values += '\''+s+'\''+',';
    }
   

    String consulta = '';
    consulta += 'SELECT Id, Name,  Quotation_Status__c, Status_Observations__c, Account_for__c, Account_for__r.Name,';
    consulta += ' Contact__c, Contact__r.Name, Container_Type__c, Container_Count__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    consulta += ' Total_Items_Units__c, Total_Weight_Kg2__c, SUM_Sell_Origin_Amount__c, Site_of_Load__c, Site_of_Discharge__c, Total_Volume_m3_2__c, Supplier_Account__c, Container_Type__r.Name,  RecordType.Name, RecordType.DeveloperName,';
    consulta += ' Supplier_Account__r.Name, LastModifiedBy.Name, CreatedBy.Name, Origin_Address__c, Vessel_Flight__c , Vessel_Flight__r.Name, Vessel_Flight__r.IMO__c, Consignee__c, Consignee__r.Name, Destination_Address__c,';
    consulta += ' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Services_Profit__c';
    consulta += ' FROM Customer_Quote__c';
    consulta += ' WHERE Name != \'\'';
    
    if(sta != null && !sta.isEmpty())
    {
        if(sta_values.contains('No Status'))
        {
            consulta += ' '+(sta_list != '[]' ? 'and (Quotation_Status__c IN :sta or Quotation_Status__c = null)' : '');
            system.debug('hola no status'+consulta);
        }
        else
        {
            consulta += ' '+(sta_list != '[]' && sta_list != '' ? 'and Quotation_Status__c IN :sta' : '');
        }
    }
    else
    {
        consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    }   
    
    consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
      consulta += ' and (Route__c = \''+record.Route__c+'\'';
      consulta += ' )';
    }
    if(record.Created_From__c != null)
    {
        datetime date_from =record.Created_From__c;
        String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        //consulta +=' and CreatedDate >= '+d_from;
        consulta +=' and CreatedDate >=: date_from ';
    }
    if(record.Created_To__c != null)
    {
        datetime date_to =record.Created_To__c.addDays(1);
        String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //consulta +=' and CreatedDate <= '+d_to;
        consulta +=' and CreatedDate <=: date_to ';
    }
    //consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    //consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    //consulta += ' '+(record.Final_Delivery_Account__c != null ? 'and Final_Delivery_Account__c = \''+record.Final_Delivery_Account__c+'\'' : '');
    //consulta += ' '+(record.Origin_Agent_Account__c != null ? 'and Origin_Agent_Account__c = \''+record.Origin_Agent_Account__c+'\'' : '');
    consulta += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta += ' '+(record.Vessel_Flight__c != null ? 'and Vessel_Flight__c = \''+record.Vessel_Flight__c+'\'' : ''); 
    consulta += ' '+(record.User_Create_Import_ExportQuotesSearch__c != null ? 'and CreatedById = \''+record.User_Create_Import_ExportQuotesSearch__c +'\'' : '');//--- ver esto
    consulta += ' '+(record.User_Modify_Import_ExportQuotesSearch__c != null ? 'and LastModifiedById = \''+record.User_Modify_Import_ExportQuotesSearch__c+'\'' : '');
    if(click_search == false)
      consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    consulta += ' and RecordTypeId != \''+ Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId()+'\'';
    
    if(orden_filtro_order != null && orden_filtro_order != '')
        consulta += ' order by ' + String.escapeSingleQuotes(orden_filtro_order.replace('import_export.','')+ ' '+  orden_filtro_order_modo) + ' nulls last';
        
    ie_orders = new List<Import_Export_Quotes_s>();
    
    system.debug(' hola query'+ consulta);
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    
    integer n_query = (integer)total_quotes/50000;
    n_query = n_query +1;
    
    integer contador_ie = 0;
    
    List<Customer_Quote__c> new_ies = null; 

        new_ies = Database.query(consulta+ ' limit '+n_records_per_page);
        
        for(Customer_Quote__c c : new_ies)
        {
            ie_orders.add(new Import_Export_Quotes_s(c, null));
        }
  }
  
  public void search_import_export_quote_order()
  {    
    //FILTROS
    String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});

    String sta_values = '';
    for(String s : sta)
    {
      sta_values += '\''+s+'\''+',';
    }
    
    //contador de quotes
    total_quotes = 0;
    string consulta = 'SELECT COUNT() FROM Customer_Quote__c';
    consulta += ' WHERE Name != \'\'';
    if(sta != null && !sta.isEmpty())
    {
        if(sta_values.contains('No Status'))
        {
            consulta += ' '+(sta_list != '[]' ? 'and (Quotation_Status__c IN :sta or Quotation_Status__c = null)' : ''); system.debug('hola no status'+consulta);
        }
        else
        {
            consulta += ' '+(sta_list != '[]' ? 'and Quotation_Status__c IN :sta' : '');
        }
    } 
    else
    {
        consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    }
    if(sta_list == '[]')
        consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';   
    
    
    consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
      consulta += ' and (Route__c = \''+record.Route__c+'\'';
      consulta += ' )';
    }
    if(record.Created_From__c != null)
    {
        datetime date_from =record.Created_From__c;
        String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        //consulta +=' and CreatedDate >= '+d_from;
        consulta +=' and CreatedDate >=: date_from ';
    }
    if(record.Created_To__c != null)
    {
        datetime date_to =record.Created_To__c.addDays(1);
        String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //consulta +=' and CreatedDate <= '+d_to;
        consulta +=' and CreatedDate <=: date_to ';
    }
   // consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
   // consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
   // consulta += ' '+(record.Final_Delivery_Account__c != null ? 'and Final_Delivery_Account__c = \''+record.Final_Delivery_Account__c+'\'' : '');
   // consulta += ' '+(record.Origin_Agent_Account__c != null ? 'and Origin_Agent_Account__c = \''+record.Origin_Agent_Account__c+'\'' : '');
    
    
    consulta += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta += ' '+(record.Vessel_Flight__c != null ? 'and Vessel_Flight__c = \''+record.Vessel_Flight__c+'\'' : ''); 
    consulta += ' '+(record.User_Create_Import_ExportQuotesSearch__c != null ? 'and CreatedById = \''+record.User_Create_Import_ExportQuotesSearch__c +'\'' : '');
    consulta += ' '+(record.User_Modify_Import_ExportQuotesSearch__c != null ? 'and LastModifiedById = \''+record.User_Modify_Import_ExportQuotesSearch__c+'\'' : '');
    consulta += ' and  RecordType.DeveloperName = \'Import_Export_Quote\'';
    total_quotes  = Database.countQuery(consulta);
    
    step_Instalacion = '1';
    
    
    //contador de orders
    total_orders = 0;
    consulta = 'SELECT COUNT() FROM Customer_Quote__c';
    consulta += ' WHERE Name != \'\'';
    if(sta != null && !sta.isEmpty())
    {
        String quotation_status_filter = sta_values.subString(0,sta_values.length()-1);
        if(sta_values.contains('No Status'))
        {
            consulta += ' '+(sta_list != '[]' ? 'and (Quotation_Status__c IN :sta or Quotation_Status__c = null)' : '');
            system.debug('hola no status'+consulta);
        }
        else
        {
            consulta += ' '+(sta_list != '[]' ? 'and Quotation_Status__c IN :sta' : '');
        }
        
    } 
    else
    {
        consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    }
    if(sta_list == '[]')
        consulta += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';   
    
    
    consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    consulta += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    //consulta += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
      consulta += ' and (Route__c = \''+record.Route__c+'\'';
      consulta += ' )';
    }
    if(record.Created_From__c != null)
    {
        datetime date_from =record.Created_From__c;
        String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        //consulta +=' and CreatedDate >= '+d_from;
        consulta +=' and CreatedDate >=: date_from ';
    }
    if(record.Created_To__c != null)
    {
        datetime date_to =record.Created_To__c.addDays(1);
        String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //consulta +=' and CreatedDate <= '+d_to;
        consulta +=' and CreatedDate <=: date_to ';
    }
    //consulta += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    //consulta += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    //consulta += ' '+(record.Final_Delivery_Account__c != null ? 'and Final_Delivery_Account__c = \''+record.Final_Delivery_Account__c+'\'' : '');
    //consulta += ' '+(record.Origin_Agent_Account__c != null ? 'and Origin_Agent_Account__c = \''+record.Origin_Agent_Account__c+'\'' : '');
    
    consulta += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    consulta += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    consulta += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    consulta += ' '+(record.Vessel_Flight__c != null ? 'and Vessel_Flight__c = \''+record.Vessel_Flight__c+'\'' : ''); 
    consulta += ' '+(record.User_Create_Import_ExportQuotesSearch__c != null ? 'and CreatedById = \''+record.User_Create_Import_ExportQuotesSearch__c +'\'' : '');
    consulta += ' '+(record.User_Modify_Import_ExportQuotesSearch__c != null ? 'and LastModifiedById = \''+record.User_Modify_Import_ExportQuotesSearch__c+'\'' : '');
    consulta += ' and  RecordType.DeveloperName != \'Import_Export_Quote\'';
    total_orders  = Database.countQuery(consulta);
    
    step_order = '1';
    
    //coger todas y pintar la lista
    integer n_listas = (integer)total_quotes/n_records_per_page;
    n_listas = n_listas + 2;
    
    integer n_listas_order = (integer)total_orders/n_records_per_page;
    n_listas_order = n_listas_order + 2;
    
    List<Id> listado_ids_ie = new List<Id>();
    
    integer contador_ie = 0; 
    integer contador_ie_order = 0; 
    List<Customer_Quote__c> new_ies = null;
    List<Customer_Quote__c> new_ies_order = null;
    
    //consulta incluyendo los dos tipos
    string query_ie_string = '';
    query_ie_string += 'SELECT Id, Name,  Quotation_Status__c, Status_Observations__c, Account_for__c, ';
    query_ie_string += 'Account_for__r.Name, Contact__c, Contact__r.Name, Container_Type__c, Container_Count__c, Freight_Mode__c, Service_Mode__c, Nature_Merchandise__c,';
    query_ie_string += 'Total_Items_Units__c, Total_Weight_Kg2__c, SUM_Sell_Origin_Amount__c,  Site_of_Load__c , Site_of_Discharge__c, Total_Volume_m3_2__c, Supplier_Account__c, Container_Type__r.Name, RecordType.Name, RecordType.DeveloperName,';
    query_ie_string += 'Supplier_Account__r.Name, Origin_Address__c, LastModifiedBy.Name, CreatedBy.Name, Consignee__c, Vessel_Flight__c , Vessel_Flight__r.Name, Vessel_Flight__r.IMO__c , Consignee__r.Name, Destination_Address__c,';
    query_ie_string += 'Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Services_Profit__c from Customer_Quote__c';
    query_ie_string += ' WHERE Name != \'\'';
    
    if(sta != null && !sta.isEmpty())
    {
        String quotation_status_filter = sta_values.subString(0,sta_values.length()-1);
        if(sta_values.contains('No Status'))
        {
            query_ie_string += ' '+(sta_list != '[]' ? 'and (Quotation_Status__c IN :sta or Quotation_Status__c = null)' : '');
        }
        else
        {
            query_ie_string += ' '+(sta_list != '[]' ? 'and Quotation_Status__c IN :sta' : '');
        }
        
    } 
    else
    {
        query_ie_string += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';
    }
    if(sta_list == '[]')
        query_ie_string += ' and Quotation_Status__c !=\'Quote Declined\' and Quotation_Status__c !=\'Delivered\' and Quotation_Status__c !=\'Closed\' and Quotation_Status__c !=\'Order Deleted\'';    
    
    
    query_ie_string += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
    query_ie_string += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
    query_ie_string += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    //query_ie_string += ' '+(record.Service_Mode__c != null ? 'and Service_Mode__c = \''+record.Service_Mode__c+'\'' : '');
    if(record.Route__c != null)
    {
      query_ie_string += ' and (Route__c = \''+record.Route__c+'\'';
      query_ie_string += ' )';
    }
    if(record.Created_From__c != null)
    {
        datetime date_from =record.Created_From__c;
        String d_from = date_from.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        //query_ie_string +=' and CreatedDate >= '+d_from;
        query_ie_string +=' and CreatedDate >=: date_from ';
    }
    if(record.Created_To__c != null)
    {
        datetime date_to =record.Created_To__c.addDays(1);
        String d_to = date_to.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //query_ie_string +=' and CreatedDate <= '+d_to;
        query_ie_string +=' and CreatedDate <=: date_to ';
    }
   // query_ie_string += ' '+(record.Freight_Mode__c != null ? 'and Freight_Mode__c = \''+record.Freight_Mode__c+'\'' : '');
   // query_ie_string += ' '+(record.Service_Type__c != null ? 'and Service_Type__c = \''+record.Service_Type__c+'\'' : '');
   // query_ie_string += ' '+(record.Final_Delivery_Account__c != null ? 'and Final_Delivery_Account__c = \''+record.Final_Delivery_Account__c+'\'' : '');
   // query_ie_string += ' '+(record.Origin_Agent_Account__c != null ? 'and Origin_Agent_Account__c = \''+record.Origin_Agent_Account__c+'\'' : '');
    query_ie_string += ' '+(record.Account_for__c != null ? 'and Account_for__c = \''+record.Account_for__c+'\'' : '');
    query_ie_string += ' '+(record.Supplier_Account__c != null ? 'and Supplier_Account__c = \''+record.Supplier_Account__c+'\'' : '');
    query_ie_string += ' '+(record.Consignee__c != null ? 'and Consignee__c = \''+record.Consignee__c+'\'' : '');
    query_ie_string += ' '+(record.Vessel_Flight__c != null ? 'and Vessel_Flight__c = \''+record.Vessel_Flight__c+'\'' : ''); 
    query_ie_string += ' '+(record.User_Create_Import_ExportQuotesSearch__c != null ? 'and CreatedById = \''+record.User_Create_Import_ExportQuotesSearch__c +'\'' : '');
    query_ie_string += ' '+(record.User_Modify_Import_ExportQuotesSearch__c != null ? 'and LastModifiedById = \''+record.User_Modify_Import_ExportQuotesSearch__c+'\'' : '');
    
    string query_ie_quote = query_ie_string;
    query_ie_quote +=  ' and  RecordType.DeveloperName = \'Import_Export_Quote\'';
    
        new_ies = new List<Customer_Quote__c>();
        new_ies = Database.query(query_ie_quote +' order by CreatedDate desc limit '+n_records_per_page);  
        ie_quotes = null;
        ie_quotes = new List<Import_Export_Quotes_s>();
        for(Customer_Quote__c c : new_ies)
        {
            ie_quotes.add(new Import_Export_Quotes_s(c, null));
        }
        
        string query_ie_order = query_ie_string;
        query_ie_order +=  ' and  RecordType.DeveloperName != \'Import_Export_Quote\'';
        new_ies_order = Database.query(query_ie_order +' order by CreatedDate desc limit '+n_records_per_page); 
        ie_orders = null;
        ie_orders = new List<Import_Export_Quotes_s>();
        for(Customer_Quote__c c : new_ies_order)
        {
            ie_orders.add(new Import_Export_Quotes_s(c, null));
        }
    
    //array pintar botones
    listado_paginas_Quotes = new List<Integer>();
    for(integer i= 1; i < n_listas; i++)
    {
        listado_paginas_Quotes.add(i);
    }
    
    listado_paginas_Orders = new List<Integer>();
    
    for(integer i= 1; i < n_listas_order; i++)
    {
        
        listado_paginas_Orders.add(i);
    }
    
    click_search = true;
  }
}