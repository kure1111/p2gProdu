public with sharing class NEU_Disbursement_View 
{
    public List<shipments_Disbursements_s> shipments_Disbursements {get;set;}
    public String orden_disburment {get;set;}
    public String modo_orden_disburment {get;set;}
    public String shipment_status {get;set;}
    public String ie_status {get;set;}
    public String service_mode {get;set;}
    public String freight_mode {get;set;}
    public String sta_list {get;set;}
    public String serv_list {get;set;}
    public String freight_list {get;set;}
    public String total_registros_string {get;set;}
    public List<Integer> listado_paginas_Instalacion {get;set;}
    public string step_Instalacion {get;set;}
    public Shipment_Disbursement__c new_filter_disbursement {get;set;}
    
    public NEU_Disbursement_View() 
    {
      orden_disburment = 'CreatedDate';
      modo_orden_disburment = 'desc';
      
      new_filter_disbursement = new Shipment_Disbursement__c();
      
       //FILTRO SHIPMENT STATUS
      shipment_status = '';
      ie_status = '';
      /*Schema.DescribeFieldResult fieldResult1 = Shipment__c.Shipment_Status__c.getDescribe();
      List<Schema.PicklistEntry> sta = fieldResult1.getPicklistValues();
      for(Schema.PicklistEntry s : sta)
      {
            shipment_status += '<input type="button" value="'+s.getValue()+'" class="btn filter_button1 filter_button_sta" name="'+s.getValue()+'" onclick="$(this).filter_sta();"/>';
      }*/
      
      Schema.DescribeFieldResult fieldResult4 = Customer_Quote__c.Quotation_Status__c.getDescribe();
      List<Schema.PicklistEntry> sta_ie = fieldResult4.getPicklistValues();
      for(Schema.PicklistEntry s : sta_ie )
      {
            ie_status += '<input type="button" value="'+s.getValue()+'" class="btn filter_button1 filter_button_sta" name="'+s.getValue()+'" onclick="$(this).filter_sta();"/>';
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
      
      //FILTRO FREIGHT MODE
      freight_mode = '';
      Schema.DescribeFieldResult fieldResult3 = Shipment__c.Freight_Mode__c.getDescribe();
      List<Schema.PicklistEntry> freight = fieldResult3.getPicklistValues();
      for(Schema.PicklistEntry s : freight)
      {
        freight_mode += '<input type="button" value="'+s.getValue()+'" class="btn filter_button3 filter_button_freight" name="'+s.getValue()+'" onclick="$(this).filter_freight();"/>';
      }
    
      shipments_Disbursements = new List<shipments_Disbursements_s>();
      List<Shipment_Disbursement__c> query_Shipment_Disbursement = [select Id, Name, CreatedDate,  Shipment_Number__c, Shipment_Status__c, Mode__c, Nature_Merchandise__c, 
      Containers__c, Planned_ETD__c, Planned_ETA__c, Shipment__c, Disbursment_Concept__c, Shipments_Program_Number__c, Account__r.Name, Payment_Type__c, VAT__c , Invoice_Date__c, 
      Sub_Allocation__c, Invoice_Ref__c, Invoice_Amount_Exc__c, Import_Export_Order_Number__c, Invoice_Amount_Inc__c, Payment_Ref__c, Payment_Amount__c, Payment_Date__c from Shipment_Disbursement__c order by CreatedDate desc limit 200];
      
      Integer total_registros = 0;
      string query_count_disbursements = '';
      query_count_disbursements += 'SELECT COUNT() FROM Shipment_Disbursement__c';
      total_registros = Database.countQuery(query_count_disbursements);
      total_registros_string = total_registros.format();
      
      listado_paginas_Instalacion = new List<Integer>();
      if(total_registros != null && total_registros != 0)
      {
          //conseguir el numero de paginas
          decimal n_pag = (total_registros/200);
          integer decimales_div =  math.mod(total_registros, 200); 
          if(decimales_div != 0)
            n_pag = n_pag.setscale(0)+2;
          else
            n_pag = n_pag.setscale(0)+1;
          for(integer i = 1; i<n_pag; i++)
          {
                 listado_paginas_Instalacion.add(i);
          }
      }
          
      List<Associated_Document__c> query_documents = [select Id, Name, Document_URL__c, Document_Type__c, Shipment_Disbursement__c from Associated_Document__c where Shipment_Disbursement__c != null order by Shipment_Disbursement__c];
      
      Map<Id,List<Associated_Document__c>> listado_documentos_disbursement = new Map<Id,List<Associated_Document__c>>();
      
      for(Associated_Document__c ad : query_documents)
      {
          if(listado_documentos_disbursement.containsKey(ad.Shipment_Disbursement__c))
          {
          
            listado_documentos_disbursement.get(ad.Shipment_Disbursement__c).add(ad);
          }
          else
          {

              listado_documentos_disbursement.put(ad.Shipment_Disbursement__c, new List<Associated_Document__c>{ad});
          }
      }
      
      for(Shipment_Disbursement__c ship_disb : query_Shipment_Disbursement)
      {
          shipments_Disbursements.add(new shipments_Disbursements_s(ship_disb, (listado_documentos_disbursement.containsKey(ship_disb.Id) == true ?  listado_documentos_disbursement.get(ship_disb.Id) : null), this));
          
      }
      
      
    }
    
    public void anterior_siguiente()
    {
        shipments_Disbursements = null;
        search_Disbursements2();
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
    
    public class shipments_Disbursements_s implements Comparable
    {
        public Shipment_Disbursement__c Shipment_Disbursement {get;set;}
        public List<Associated_Document__c> associated_document {get;set;}
        private NEU_Disbursement_View  parent;
        
        public shipments_Disbursements_s(Shipment_Disbursement__c Shipment_Disbursement, List<Associated_Document__c> associated_document, NEU_Disbursement_View  parent)
        {
          this.Shipment_Disbursement = Shipment_Disbursement;
          this.associated_document = associated_document; 
          this.parent = parent;
        }
        
        public Integer compareTo(Object compareTo) 
        {   
            shipments_Disbursements_s compareToEmp = (shipments_Disbursements_s)compareTo;
            
            if(parent.orden_disburment  != null)
            {
              if(parent.orden_disburment.contains('Shipment_Disbursement.') == true)
                parent.orden_disburment = parent.orden_disburment.replace('Shipment_Disbursement.','');
                
              if (Shipment_Disbursement.get(''+parent.orden_disburment)  == compareToEmp.Shipment_Disbursement.get(''+parent.orden_disburment)) return 0; 
              if(Shipment_Disbursement.get(''+parent.orden_disburment) == null || Shipment_Disbursement.get(''+parent.orden_disburment)  == '' ) return 1;
              
              if(string.valueof(Schema.SObjectType.Shipment_Disbursement__c.fields.getMap().get(''+parent.orden_disburment).getDescribe().getType()) == 'STRING')
              {
                  if(parent.modo_orden_disburment == 'desc')
                  {
                    if (string.valueof(Shipment_Disbursement.get(''+parent.orden_disburment)) > string.valueof(compareToEmp.Shipment_Disbursement.get(''+parent.orden_disburment))) return 1;/*(parent.modo_orden_disburment == 'desc' ? 1 : -1)*/
                  }
                  else
                  {
                    if (string.valueof(Shipment_Disbursement.get(''+parent.orden_disburment)) < string.valueof(compareToEmp.Shipment_Disbursement.get(''+parent.orden_disburment))) return 1;
                  }
              }
              else if(string.valueof(Schema.SObjectType.Shipment_Disbursement__c.fields.getMap().get(''+parent.orden_disburment).getDescribe().getType()) == 'DATE')
              {
                  if(parent.modo_orden_disburment == 'desc')
                  {
                    if (date.valueof(Shipment_Disbursement.get(''+parent.orden_disburment)) > date.valueof(compareToEmp.Shipment_Disbursement.get(''+parent.orden_disburment))) return 1;/*(parent.modo_orden_disburment == 'desc' ? 1 : -1)*/
                  }
                  else
                  {
                    if (date.valueof(Shipment_Disbursement.get(''+parent.orden_disburment)) < date.valueof(compareToEmp.Shipment_Disbursement.get(''+parent.orden_disburment))) return 1;
                  }
              }
              else
              {
                  if(parent.modo_orden_disburment == 'desc')
                  {
                    if (double.valueof(Shipment_Disbursement.get(''+parent.orden_disburment)) > double.valueof(compareToEmp.Shipment_Disbursement.get(''+parent.orden_disburment))) return 1;/*(parent.modo_orden_disburment == 'desc' ? 1 : -1)*/
                  }
                  else
                  {
                    if (double.valueof(Shipment_Disbursement.get(''+parent.orden_disburment)) < double.valueof(compareToEmp.Shipment_Disbursement.get(''+parent.orden_disburment))) return 1;
                  }
              }
            }
          
            return -1;       
        }
    } 
    
    public void search_Disbursements()
    {
        step_Instalacion = '1';
        orden_disburment = 'CreatedDate';
        modo_orden_disburment = 'desc';
        search_Disbursements2();
    }
    
    public void search_ordenacion()
    {
        step_Instalacion = '1'; 
        search_Disbursements2();
    }
    
    public void search_Disbursements2()
    {
        //FILTROS
        String[] sta = (sta_list != null ? sta_list.replace('[','').replace(']','').split(',',0) : new String[]{});
        String[] serv = (serv_list != null ? serv_list.replace('[','').replace(']','').split(',',0) : new String[]{});
        String[] freig = (freight_list != null ? freight_list.replace('[','').replace(']','').split(',',0) : new String[]{});
    
        shipments_Disbursements = null;
        
        
        shipments_Disbursements = new List<shipments_Disbursements_s>();
        
        //no consultar los que ya tengo de paginas anteriores
        List<Shipment_Disbursement__c> listado_paginas_anteriores = new List<Shipment_Disbursement__c>();
        string consulta_paginas_anteriores = '';
        decimal total_registros_anteriores = 0;
        //step_Instalacion
        if(step_Instalacion != '1' && step_Instalacion != null && step_Instalacion != '')
        {
            total_registros_anteriores = (decimal.valueof(step_Instalacion)-1)*200;
            
            consulta_paginas_anteriores +=' select Id, Name, CreatedDate,  Shipment_Number__c, Shipment_Status__c, Mode__c, Nature_Merchandise__c, ';
            consulta_paginas_anteriores +=' Containers__c, Planned_ETD__c, Shipments_Program_Number__c, Import_Export_Order_Number__c, Planned_ETA__c, Shipment__c, Disbursment_Concept__c, Account__r.Name, Payment_Type__c, VAT__c , Invoice_Date__c, ';
            consulta_paginas_anteriores +=' Sub_Allocation__c, Invoice_Ref__c, Invoice_Amount_Exc__c, Invoice_Amount_Inc__c, Payment_Ref__c, Payment_Amount__c,';
            consulta_paginas_anteriores +='Payment_Date__c from Shipment_Disbursement__c';
            consulta_paginas_anteriores += ' WHERE Name != \'\'';
            consulta_paginas_anteriores += ' '+(sta_list != '[]' && sta_list != ''  ? 'and Shipment_Status__c IN :sta' : '');
            consulta_paginas_anteriores += ' '+(serv_list != '[]' && serv_list != '' ? 'and Service_Mode__c IN :serv' : '');
            consulta_paginas_anteriores += ' '+(freight_list != '[]' && freight_list != '' ? 'and Freight_Mode__c IN :freig' : '');
            
            if(new_filter_disbursement != null && new_filter_disbursement.Account__c != null)
            {
            	Id Id_account = new_filter_disbursement.Account__c;
            	consulta_paginas_anteriores += ' and Account__c =: Id_account';
            }
           	
            
            if(new_filter_disbursement != null)
            {
                if(new_filter_disbursement.Planned_ETD_filter__c != null)
                {
                    String etd = String.valueof(new_filter_disbursement.Planned_ETD_filter__c).replace(' ','T');
                    String operator = '';
                    if(ETD_operator_selected == 'equal')operator = '=';
                    if(ETD_operator_selected == 'not equal to')operator = '!=';
                    if(ETD_operator_selected == 'less than')operator = '<';
                    if(ETD_operator_selected == 'greater than')operator = '>';
                    if(ETD_operator_selected == 'less or equal')operator = '<=';
                    if(ETD_operator_selected == 'greater or equal')operator = '>=';
                    consulta_paginas_anteriores += ' and Planned_ETD_filter_formula__c '+operator+' '+etd;
                }
                
                if(new_filter_disbursement.Planned_ETA_filter__c != null)
                {
                    String eta = String.valueof(new_filter_disbursement.Planned_ETA_filter__c).replace(' ','T');
                    String operator = '';
                    if(ETA_operator_selected == 'equal')operator = '=';
                    if(ETA_operator_selected == 'not equal to')operator = '!=';
                    if(ETA_operator_selected == 'less than')operator = '<';
                    if(ETA_operator_selected == 'greater than')operator = '>';
                    if(ETA_operator_selected == 'less or equal')operator = '<=';
                    if(ETA_operator_selected == 'greater or equal')operator = '>=';
                    consulta_paginas_anteriores += ' and Planned_ETA_filter_formula__c '+operator+' '+eta;
                }
            }
            //Protect SOSL Injection
            consulta_paginas_anteriores +=' order by ' + String.escapeSingleQuotes(orden_disburment+' '+modo_orden_disburment) + ' nulls last limit '+total_registros_anteriores; 
            System.debug('QUERY: '+consulta_paginas_anteriores); 
            listado_paginas_anteriores = Database.query(consulta_paginas_anteriores);
        }
        
        String consulta = '';
        
        consulta +=' select Id, Name, CreatedDate,  Shipment_Number__c, Shipment_Status__c, Mode__c, Nature_Merchandise__c, ';
        consulta +=' Containers__c, Planned_ETD__c, Planned_ETA__c, Shipments_Program_Number__c, Import_Export_Order_Number__c, Shipment__c, Disbursment_Concept__c, Account__r.Name, Payment_Type__c, VAT__c , Invoice_Date__c, ';
        consulta +=' Sub_Allocation__c, Invoice_Ref__c, Invoice_Amount_Exc__c, Invoice_Amount_Inc__c, Payment_Ref__c, Payment_Amount__c,';
        consulta +=' Payment_Date__c from Shipment_Disbursement__c';
        consulta += ' WHERE Name != \'\'';
        consulta += ' '+(sta_list != '[]' && sta_list != ''  ? 'and Shipment_Status__c IN :sta' : '');
        consulta += ' '+(serv_list != '[]' && serv_list != '' ? 'and Service_Mode__c IN :serv' : '');
        consulta += ' '+(freight_list != '[]' && freight_list != '' ? 'and Freight_Mode__c IN :freig' : '');
        
        if(new_filter_disbursement != null && new_filter_disbursement.Account__c != null)
        {
        	Id Id_account = new_filter_disbursement.Account__c;
        	consulta_paginas_anteriores += ' and Account__c =: Id_account';
        }
        
        if(new_filter_disbursement != null)
        {
            if(new_filter_disbursement.Planned_ETD_filter__c != null)
            {
                String etd = String.valueof(new_filter_disbursement.Planned_ETD_filter__c).replace(' ','T');
                String operator = '';
                if(ETD_operator_selected == 'equal')operator = '=';
                if(ETD_operator_selected == 'not equal to')operator = '!=';
                if(ETD_operator_selected == 'less than')operator = '<';
                if(ETD_operator_selected == 'greater than')operator = '>';
                if(ETD_operator_selected == 'less or equal')operator = '<=';
                if(ETD_operator_selected == 'greater or equal')operator = '>=';
                consulta += ' and Planned_ETD_filter_formula__c '+operator+' '+etd;
            }
            
            if(new_filter_disbursement.Planned_ETA_filter__c != null)
            {
                String eta = String.valueof(new_filter_disbursement.Planned_ETA_filter__c).replace(' ','T');
                String operator = '';
                if(ETA_operator_selected == 'equal')operator = '=';
                if(ETA_operator_selected == 'not equal to')operator = '!=';
                if(ETA_operator_selected == 'less than')operator = '<';
                if(ETA_operator_selected == 'greater than')operator = '>';
                if(ETA_operator_selected == 'less or equal')operator = '<=';
                if(ETA_operator_selected == 'greater or equal')operator = '>=';
                consulta += ' and Planned_ETA_filter_formula__c '+operator+' '+eta;
            }
        }
        
        if(listado_paginas_anteriores != null && listado_paginas_anteriores.size()>0)
        {
            //Protect SOSL Injection
            Set<Id> listado_ids_ya_visitadors = new Set<Id>();
            for(Shipment_Disbursement__c sd: listado_paginas_anteriores)
              listado_ids_ya_visitadors.add(sd.Id);
              
            consulta += ' and Id not IN :listado_ids_ya_visitadors';
        }
    
    	//Protect SOSL Injection
    	consulta +=' order by '+ String.escapeSingleQuotes(orden_disburment+' '+modo_orden_disburment) +' nulls last limit 200';
        system.debug('QUERY '+ consulta); 
          
          
        List<Shipment_Disbursement__c> query_Shipment_Disbursement = Database.query(consulta);
        
        //se calcula el total ademas de los que se muestran y el numero de paginas
        Integer total_registros = 0;
        string query_count_disbursements = '';
        query_count_disbursements += 'SELECT COUNT() FROM Shipment_Disbursement__c';
        query_count_disbursements += ' WHERE Name != \'\'';
        consulta_paginas_anteriores += ' '+(sta_list != '[]' && sta_list != '' ? 'and Shipment_Status__c IN :sta' : '');
        consulta_paginas_anteriores += ' '+(serv_list != '[]' && serv_list != '' ? 'and Service_Mode__c IN :serv' : '');
        consulta_paginas_anteriores += ' '+(freight_list != '[]' && freight_list != '' ? 'and Freight_Mode__c IN :freig' : '');
        if(new_filter_disbursement != null && new_filter_disbursement.Account__c != null)
        {
        	Id Id_account = new_filter_disbursement.Account__c;
        	consulta_paginas_anteriores += ' and Account__c =: Id_account';
        }
        if(new_filter_disbursement != null)
        {
            if(new_filter_disbursement.Planned_ETD_filter__c != null)
            {
                String etd = String.valueof(new_filter_disbursement.Planned_ETD_filter__c).replace(' ','T');
                String operator = '';
                if(ETD_operator_selected == 'equal')operator = '=';
                if(ETD_operator_selected == 'not equal to')operator = '!=';
                if(ETD_operator_selected == 'less than')operator = '<';
                if(ETD_operator_selected == 'greater than')operator = '>';
                if(ETD_operator_selected == 'less or equal')operator = '<=';
                if(ETD_operator_selected == 'greater or equal')operator = '>=';
                query_count_disbursements += ' and Planned_ETD_filter_formula__c '+operator+' '+etd;
            }
            
            if(new_filter_disbursement.Planned_ETA_filter__c != null)
            {
                String eta = String.valueof(new_filter_disbursement.Planned_ETA_filter__c).replace(' ','T');
                String operator = '';
                if(ETA_operator_selected == 'equal')operator = '=';
                if(ETA_operator_selected == 'not equal to')operator = '!=';
                if(ETA_operator_selected == 'less than')operator = '<';
                if(ETA_operator_selected == 'greater than')operator = '>';
                if(ETA_operator_selected == 'less or equal')operator = '<=';
                if(ETA_operator_selected == 'greater or equal')operator = '>=';
                query_count_disbursements += ' and Planned_ETA_filter_formula__c '+operator+' '+eta;
            }
        }
        system.debug('QUERY: '+ query_count_disbursements);
        total_registros = Database.countQuery(query_count_disbursements);
        total_registros_string = total_registros.format();
        listado_paginas_Instalacion = new List<Integer>();
        if(total_registros != null && total_registros != 0)
        {
              //conseguir el numero de paginas
              decimal n_pag = (total_registros/200); 
              integer decimales_div =  math.mod(total_registros, 200); 
              if(decimales_div != 0)
                n_pag = n_pag.setscale(0)+2;//+1 no pintar la 0 +1 por la coma (la ultima pagina no entera)
              else
                n_pag = n_pag.setscale(0)+1;
              for(integer i = 1; i < n_pag; i++)
              {
                     listado_paginas_Instalacion.add(i);
              }
        }
        
        List<Associated_Document__c> query_documents = [select Id, Name, Document_URL__c, Document_Type__c, Shipment_Disbursement__c from Associated_Document__c where Shipment_Disbursement__c !=: null and Shipment_Disbursement__c IN:query_Shipment_Disbursement order by Shipment_Disbursement__c];
          
        Map<Id,List<Associated_Document__c>> listado_documentos_disbursement = new Map<Id,List<Associated_Document__c>>();
          
        for(Associated_Document__c ad : query_documents)
        {
            if(listado_documentos_disbursement.containsKey(ad.Shipment_Disbursement__c))
            {
             
              listado_documentos_disbursement.get(ad.Shipment_Disbursement__c).add(ad);
            }
            else
            {
    
                listado_documentos_disbursement.put(ad.Shipment_Disbursement__c, new List<Associated_Document__c>{ad});
            }
        }
          
        for(Shipment_Disbursement__c ship_disb : query_Shipment_Disbursement)
        {
            shipments_Disbursements.add(new shipments_Disbursements_s(ship_disb, (listado_documentos_disbursement.containsKey(ship_disb.Id) == true ?  listado_documentos_disbursement.get(ship_disb.Id) : null), this));
              
        }
        
    } 
    
    public void save_changes()
    {
        if(shipments_Disbursements != null && shipments_Disbursements.size()>0)
        {
            List<Shipment_Disbursement__c> list_to_update = new List<Shipment_Disbursement__c>();
            for(shipments_Disbursements_s sds: shipments_Disbursements)
            {
                list_to_update.add(sds.Shipment_Disbursement);
            }
            
            if(list_to_update != null && list_to_update.size()>0)
            {
                update list_to_update;
            }
        }
    }

    public void go_compare_disbursement()
    {
        shipments_Disbursements = null;
        search_ordenacion(); 
        step_Instalacion = '1';
    }
}