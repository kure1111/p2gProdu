public with sharing class NEU_Send_Request_for_Quotation {
    
    private List<Supplier_s> lista_suppliers = null;
    public String orden_quotes {get;set;}
    private List<SelectOption> newcategories=null;
    public String id_oi {get;set;}
    public String[] ordenacion_quotes;
    public String comprobante_familias {get;set;}
    public boolean cuentas_sin_email {get;set;} 
    public string Service_Rate {get;set;}  
    public string Service_Rate_Name {get;set;}  
    public string Subject_email {get;set;}  
    public string text_observations_default {get;set;}
    public string supplier_filter_name{get;set;}  
    public boolean enviado_correctamente {get;set;}  

    public String subfamily{get;
        set
        {
          if(subfamily!=value)
          {
            subfamily=value;
            lista_suppliers = null;
            items=null;
            item=null;
          }
        }
    }
  
    public List<SelectOption> subfamilies
    {
        get
        {
            if((subfamilies==null)&&(String.IsNotEmpty(getnewcategory())))
            {
                subfamilies=new List<SelectOption>();
                subfamilies.add(new SelectOption('','All Subfamilies'));
                for(Subfamily__c f:[select Id,Name from Subfamily__c where Product_Family__c=:getnewcategory() order by Name])
                if(f.Name.length()>40)
                    subfamilies.add(new SelectOption(f.Id,f.Name.Substring(40)));
                else
                    subfamilies.add(new SelectOption(f.Id,f.Name));
            }
            return subfamilies;
        }
        set;
    }
    
    public string item{get;
        set
        {
          if(item!=value)
          {
            item=value;
            lista_suppliers = null;
          }
        }
    }
    
    public List<SelectOption> items
    {
        get
        {
            if((items==null)&&(String.IsNotEmpty(getnewcategory())))
            {
                items=new List<SelectOption>();
                items.add(new SelectOption('','All Items'));
                List<Sourcing_Item__c>is;
                if(String.IsEmpty(subfamily))
                  is=[select Id,Name from Sourcing_Item__c where Sourcing_Family__c=:getnewcategory() order by Name];
                else
                  is=[select Id,Name from Sourcing_Item__c where Subfamily__c=:subfamily order by Name];
                for(Sourcing_Item__c f:is)
                  if(f.Name.length()>40)
                      items.add(new SelectOption(f.Id,f.Name.Substring(40)));
                  else
                      items.add(new SelectOption(f.Id,f.Name));
            }
            return items;
        }
        set;
    }
    
    ApexPages.StandardController con;
    
    public  List<SelectOption> getnewcategories()
    {
      if(newcategories==null)
      {
        mynewcategory=null;
        newcategories=new List<SelectOption>();
        /*List<SelectOption> options = new List<SelectOption>();
        List<Family_Supplied__c> familiesup = new List<Family_Supplied__c>();
        familiesup = [select Id, Name, Family__c, Family__r.Name, Supplier_Account__c, Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c, Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c, Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, Supplier_Account__r.RecordTypeId from Family_Supplied__c where  Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId() order by Family__r.Name];
          
        comprobante_familias = '';
        for(Family_Supplied__c fs : familiesup)
        {
            if(comprobante_familias.contains(fs.Family__c) == false)
            {
                newcategories.add(new SelectOption(fs.Family__c,fs.Family__r.Name));
                if(String.IsEmpty(mynewcategory))
                    mynewcategory=fs.Family__c;
                    
                comprobante_familias +=fs.Family__c;
            }
        }*/
        
        newcategories.add(new SelectOption('All','All'));
        
      }
      return newcategories;
    }
    
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
            mynewcategory=value;
            subfamilies=null;
            subfamily=null;
            items=null;
            item=null; 
            lista_suppliers = null;
      }
    }


    public class Supplier_s implements Comparable
    {
        public Account line {get; set;}
        public boolean selected {get; set;}
        public List<SelectOption> contact {get; set;}
        public string contact_select {get; set;}
        public string observation {get; set;}
        public string campo_compare  {get; set;}
        public string orden_de_comparacion{get;set;}
        public Supplier_s(Account line, boolean selected, List<SelectOption> contact, string contact_select, string observation )
        {
                this.line=line;
                this.selected=selected;
                this.contact=contact;
                this.contact_select = contact_select;
                this.observation = observation;
        }

        public Integer compareTo(Object compareTo) 
        {
            
              system.debug('upload suppliers to invite'+compareTo);
              Supplier_s compareToEmp = (Supplier_s)compareTo;
              
              if(campo_compare  == 'line.Name')
              {
                if(line.Name == compareToEmp.line.Name) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Name > compareToEmp.line.Name) return 1;
                }
                else
                    if (line.Name < compareToEmp.line.Name) return 1;
              
              }
              
              if(campo_compare  == 'line.Description')
              {
                if(line.Description== compareToEmp.line.Description) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Description> compareToEmp.line.Description) return 1;
                }
                else
                    if (line.Description< compareToEmp.line.Description) return 1;
              
              }
              
              if(campo_compare  == 'contact_select')
              {
                if(contact_select == compareToEmp.contact_select) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (contact_select > compareToEmp.contact_select) return 1;
                }
                else
                    if (contact_select < compareToEmp.contact_select) return 1;
              
              }
              
              if(campo_compare  == 'line.Quality_Products_Score__c')
              {
                if(line.Quality_Products_Score__c == compareToEmp.line.Quality_Products_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Quality_Products_Score__c > compareToEmp.line.Quality_Products_Score__c) return 1;
                }
                else
                    if (line.Quality_Products_Score__c < compareToEmp.line.Quality_Products_Score__c) return 1;
              
              }
              
              if(campo_compare  == 'line.Prices_Score__c')
              {
                if(line.Prices_Score__c == compareToEmp.line.Prices_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Prices_Score__c > compareToEmp.line.Prices_Score__c) return 1;
                }
                else
                    if (line.Prices_Score__c < compareToEmp.line.Prices_Score__c) return 1;
              
              }
              
               if(campo_compare  == 'line.Type')
              {
                if(line.Type == compareToEmp.line.Type) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Type > compareToEmp.line.Type) return 1;
                }
                else
                    if (line.Type < compareToEmp.line.Type) return 1;
              
              }
              

              
               if(campo_compare  == 'line.Colaboration_Score__c')
              {
                if(line.Colaboration_Score__c == compareToEmp.line.Colaboration_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Colaboration_Score__c > compareToEmp.line.Colaboration_Score__c) return 1;
                }
                else
                    if (line.Colaboration_Score__c < compareToEmp.line.Colaboration_Score__c) return 1;
              
              }
              
              if(campo_compare  == 'line.Delivery_Times_Score__c')
              {
                if(line.Delivery_Times_Score__c == compareToEmp.line.Delivery_Times_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Delivery_Times_Score__c > compareToEmp.line.Delivery_Times_Score__c ) return 1;
                }
                else
                    if (line.Delivery_Times_Score__c < compareToEmp.line.Delivery_Times_Score__c) return 1;
              
              }
              
                if(campo_compare  == 'line.Efficiency_Level_Score__c')
              {
                if(line.Efficiency_Level_Score__c == compareToEmp.line.Efficiency_Level_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Efficiency_Level_Score__c > compareToEmp.line.Efficiency_Level_Score__c) return 1;
                }
                else
                    if (line.Efficiency_Level_Score__c < compareToEmp.line.Efficiency_Level_Score__c) return 1;
              
              }
              
               return -1;
           }
              
    } 
    
    public void go_compare()
    {
      
        ordenacion_quotes = new String[]{};
        if(orden_quotes != null)
        {
            ordenacion_quotes = orden_quotes.split('-'); 
            for(Supplier_s li: getlista_suppliers())
            {
              li.campo_compare = ordenacion_quotes[0];
              li.orden_de_comparacion = ordenacion_quotes[1];
            }  
        lista_suppliers.sort();
        }
          
    }
    
    public void search_name_filter()
    {
        lista_suppliers = null;
    }
        
    public List<Supplier_s> getlista_suppliers()
    {
        if(lista_suppliers == null)
        {
          lista_suppliers=new List<Supplier_s>();
          

          /*List<Family_Supplied__c> familiesup = null;
          if(getnewcategory() != null && getnewcategory() != '' && getnewcategory() != 'All')
          {
            familiesup = [select Id, Name,  Family__r.id,Subfamily__c,Item__c, Supplier_Account__c,
            Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c,
            Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c,
            Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, 
            Supplier_Account__r.RecordTypeId from Family_Supplied__c where  Supplier_Account__r.RecordTypeId =: Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId() and Family__c =: getnewcategory() order by Supplier_Account__c];
          }
          else
          {
            familiesup = [select Id, Name,  Family__r.id,Subfamily__c,Item__c, Supplier_Account__c,
            Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c,
            Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c,
            Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, 
            Supplier_Account__r.RecordTypeId from Family_Supplied__c where  Supplier_Account__r.RecordTypeId =: Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId() order by Supplier_Account__c];
         
          }*/
          string contenedor_de_cuentas = '';
          Set<ID> listado_ids_carriers = new Set<Id>();
          /*for(Family_Supplied__c fs : familiesup)
          {
            listado_ids_carriers.add(fs.Supplier_Account__c);
          }*/
          List<Account> query_account = null;
          if(string.isnotempty(supplier_filter_name))
              query_account = Database.query('select Id, Name, Status_Account__c, Activity_Sector__c, Type, Brand_Name__c, Description, Quality_Products_Score__c, Prices_Score__c, Colaboration_Score__c, Delivery_Times_Score__c, Efficiency_Level_Score__c from Account where RecordTypeId =\''+ Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()+'\' and Name like \'%'+supplier_filter_name+'%\' order by Name');
          else
              query_account = Database.query('select Id, Name, Status_Account__c, Activity_Sector__c, Type, Brand_Name__c, Description, Quality_Products_Score__c, Prices_Score__c, Colaboration_Score__c, Delivery_Times_Score__c, Efficiency_Level_Score__c from Account where RecordTypeId =\''+ Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()+'\' order by Name');
          for(Account ac: query_account)
          {
            listado_ids_carriers.add(ac.Id);
          }
          
          List<Contact> contacts = [select Id, Name, AccountId, Email from Contact where Email != null and Account.RecordTypeId =: Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId() and AccountId IN: listado_ids_carriers order by AccountId];
          
          Map<Id, List<SelectOption>> listado_de_contact_x_supplier= new Map<Id, List<SelectOption>>();
          for(Contact con: contacts)
          {
            if(listado_de_contact_x_supplier.containsKey(con.AccountId))
            {
            
              listado_de_contact_x_supplier.get(con.AccountId).add(new SelectOption(con.Id, con.Name));
            }
            else
            {
  
                listado_de_contact_x_supplier.put(con.AccountId, new List<SelectOption>{new SelectOption(con.Id, con.Name)});
            }
          }
          
          for(Account ac : query_account)
          {
                if(contenedor_de_cuentas == '' || contenedor_de_cuentas.contains(ac.Id) == false)
                {
                    
                    lista_suppliers.add(new Supplier_s(ac,false,listado_de_contact_x_supplier.get(ac.Id), '',text_observations_default));
                }
                contenedor_de_cuentas += ac.Id;
          }
        }
        return lista_suppliers;
        
  } 
   
  public NEU_Send_Request_for_Quotation() 
  {
        Service_Rate = apexpages.currentpage().getparameters().get('Service_Rate');
        
        Subject_email = 'Request for Quotation from '+UserInfo.getOrganizationName();
        
        if(Service_Rate != '' && Service_Rate != null)
        {
            List<Fee__c> query_fee = [select Id, Name from Fee__c where Id =: Service_Rate];
            if(query_fee != null && query_fee.size()>0)
                Service_Rate_Name = query_fee[0].Name; 
            else
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'"Service Rate" You haven´t selected any Service Rate'));
        }
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'"Service Rate" You haven´t selected any Service Rate'));
        
        text_observations_default = ''; 
        if(apexpages.currentpage().getparameters().get('imp_exp') != null)
        {
            List<Customer_Quote__c> imp_exp_selected = [select Id, Name, Nature_Merchandise__c, Total_Weight_Kg2__c, Total_Volume_m3_2__c from Customer_Quote__c where id =: apexpages.currentpage().getparameters().get('imp_exp')];
            text_observations_default +='Please, Quote for '+(imp_exp_selected[0].Nature_Merchandise__c != null ? imp_exp_selected[0].Nature_Merchandise__c : imp_exp_selected[0].Name)+' Total Weight (Kg) '+ imp_exp_selected[0].Total_Weight_Kg2__c.setScale(2) +' Total Volume (m3) '+imp_exp_selected[0].Total_Volume_m3_2__c.setScale(2);
        }
        if(apexpages.currentpage().getparameters().get('ship') != null)
        {
            List<Shipment__c> shipment_selected = [select Id, Name, Nature_Merchandise__c, Total_Weight_Kg__c, Total_Volume_m3__c from Shipment__c where id =: apexpages.currentpage().getparameters().get('ship')];
            text_observations_default +='Please, Quote for '+(shipment_selected[0].Nature_Merchandise__c != null ? shipment_selected[0].Nature_Merchandise__c : shipment_selected[0].Name)+' Total Weight (Kg) '+ shipment_selected[0].Total_Weight_Kg__c.setScale(2) +' Total Volume (m3) '+shipment_selected[0].Total_Volume_m3__c.setScale(2);
        }
        if(apexpages.currentpage().getparameters().get('ship_prog') != null) 
        {
            List<Shipment_Program__c> shipment_prog_selected = [select Id, Name, Total_Gross_Weight_Kg__c, Total_Gross_Volume_m3__c from Shipment_Program__c where id =: apexpages.currentpage().getparameters().get('ship_prog')];
            text_observations_default +='Please, Quote for '+(shipment_prog_selected[0].Name != null ? shipment_prog_selected[0].Name : shipment_prog_selected[0].Name)+' Total Weight (Kg) '+ shipment_prog_selected[0].Total_Gross_Weight_Kg__c.setScale(2) +' Total Volume (m3) '+shipment_prog_selected[0].Total_Gross_Volume_m3__c.setScale(2);
        }   
        supplier_filter_name = '';
  }
  
  
  public void create_service_rate_send_email()
  {
      if(string.isnotempty(Service_Rate))
      {
          List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
         
          string moneda_elegida = '';
            
          CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
          if(sr == null)
          {
              sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
              if(sr == null)
                  sr = CSH_Supplier_Request__c.getOrgDefaults();
          }
           
          String defaultUrl=null;
          Boolean useExternal=false;
          String communityUrl=null;
          if(sr!=null)
          {
              defaultUrl=sr.Default_External_URL__c;
              communityUrl=sr.Default_Community_URL__c;
              useExternal=sr.Use_External_Url__c;
          }  
          
          List<Fee__c> query_fee_clone = [select id, Name, Account_for__c, Fee__c, Active__c,
          Applicable_to_Purchase_Incoterms__c, Applicable_to_Sales_Incoterms__c,
          Buy_Rate__c, Carrier_Account__c, Container_Type__c, Container_Type__r.Name, Country_of_Discharge__c, Country_of_Load__c,
          Fuel__c, Fuel_Over__c, Import_Export_Quoted_Marketplace__c, Import_Export_Quoted_Marketplace__r.Name, Marketplace_Ranking__c,
          Master_Allocation__c, Max_Kgs__c, Max_M3__c, Min__c, Normal__c, Pallet_Type__c, Pallet_Type__r.Name, Delivery_Zone__c, Delivery_Zone__r.Name,
          Port_Airport__c, Port_Airport__r.Name, Fee_Category__c, Fee_Description__c, Rate_Type__c, Risk__c, Risk_Over__c, Route__c, Route__r.Name,
          Fee_Rate__c, Shipment_Quoted_Marketplace__c, Shipment_Quoted_Marketplace__r.Name, Shipments_Program_Quoted_Marketplace__c, Shipments_Program_Quoted_Marketplace__r.Name,
          Port_Airport_of_Discharge__c, Port_Airport_of_Load__c, LOT__c, LOT_Url__c, Standard_Rate__c, Sub_Allocation__c, Taxable_Item__c,
          TT_Days__c, Valid_From__c, Valid_Until__c, VAT_Column__c, Via__c, Volumetric_Factor__c from Fee__c where id=: Service_Rate];
          //creacion de fees
           enviado_correctamente = true;
          List<Fee__c> listado_fees_to_insert = new List<Fee__c>();
          map<Id, Fee__c> liestado_fees_supplier = new map<Id, Fee__c>();
          for(Supplier_s lines:getlista_suppliers())
          {
              if(lines.selected == true)
              {
                    Fee__c new_fee=query_fee_clone[0].clone(false,true);
                    new_fee.Carrier_Account__c = lines.line.Id;
                    if(apexpages.currentpage().getparameters().get('imp_exp') != null)
                        new_fee.Import_Export_Quoted_Marketplace__c = apexpages.currentpage().getparameters().get('imp_exp');
                    if(apexpages.currentpage().getparameters().get('ship') != null)
                        new_fee.Shipment_Quoted_Marketplace__c = apexpages.currentpage().getparameters().get('ship');
                    if(apexpages.currentpage().getparameters().get('ship_prog') != null)
                        new_fee.Shipments_Program_Quoted_Marketplace__c = apexpages.currentpage().getparameters().get('ship_prog');
                    new_fee.Buy_Rate__c = null; 
                    new_fee.Fee_Rate__c = null;
                    listado_fees_to_insert.add(new_fee);
                    liestado_fees_supplier.put(lines.line.Id, new_fee);
              }
          }
          
          if(listado_fees_to_insert != null && listado_fees_to_insert.size()>0)
            insert listado_fees_to_insert;
          
          List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo']; 
          CSH_Supplier_Request__c sr2 = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
          if(sr2 == null)
          {
              sr2 = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
              if(sr2 == null)
                  sr2 = CSH_Supplier_Request__c.getOrgDefaults();
          }
          string defaultUrl2 = '';
          if(sr2!=null)
          {
              defaultUrl2=sr2.Default_External_URL__c;
          }
        
          string cabecera_correo = '';
          cabecera_correo +='<div id="top" >';
          cabecera_correo +='<img style="width:50%" src="'+defaultUrl2+'/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo"   style="margin-top: 40px;" />';
          cabecera_correo +='</div>';
          List<Task> listado_tareas = new List<Task>();
          List<String> listado_contactos = new List<String>(); 
          List<SObject> relaciones_con_task = new List<SObject>();
          //envio de correos        
          for (Supplier_s lines:getlista_suppliers())
          {
              if(lines.selected)
              {
                 string emailbody = '';
                 string body_tarea = '';
                 emailbody +=''+cabecera_correo; 
                 emailbody += '<div>';
                 cuentas_sin_email = true;  
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 String[] toAddresses = new String[]{};
                 
                 string url_formulario = '';
                 string id_fee = '';
                 string id_contacto = '';
                 
                 if(String.IsNotEmpty(lines.contact_select))
                 {
                    List<Contact> query_contact = [select Id, Name, Other_Email__c, Email, Accountid from Contact where Id =: lines.contact_select];//----arreglar esto
                    if(query_contact != null && query_contact.size()>0)
                    {
                        emailbody +='<br>';
                        emailbody +='<br>';
                        emailbody +='Dear  '+query_contact[0].Name+', \n';
                        emailbody +=userinfo.getOrganizationName()+' invites you to quote for a new shipment.  \n';
                        emailbody +='Please use our Transport Management System to submit your offer online. It is user friendly and safe!  \n';
                        emailbody +='User Instructions are attached to this email if you need them.  \n';
                        emailbody +='Thank you! \n \n';
                        emailbody +='Service Rate Description : '+lines.observation+'\n \n';
                        
                        
                        body_tarea +='Dear  '+query_contact[0].Name+', \n';
                        body_tarea +=userinfo.getOrganizationName()+' invites you to quote for a new shipment. \n';
                        body_tarea +='Please use our Transport Management System to submit your offer online. It is user friendly and safe!  \n';
                        body_tarea +='User Instructions are attached to this email if you need them. \n';
                        body_tarea +='Thank you! \n \n';
                        body_tarea +='Service Rate Description : '+lines.observation+'\n \n';
                        
                        toAddresses.add(query_contact[0].Email);
                        if(String.IsNotEmpty(query_contact[0].Other_Email__c))
                            toAddresses.add(query_contact[0].Other_Email__c);
                        
                        //----arreglar esto
                        
                        for(Fee__c fee: listado_fees_to_insert)
                        {
                            if(fee.Carrier_Account__c == lines.line.Id)
                            {
                                id_fee = fee.Id;
                                break;
                            }
                        }
                         
                        url_formulario +=    defaultUrl;
                        if(string.isnotempty(id_fee) == true && id_fee.length() <=30)
                        {
                            system.debug('hola'+id_fee);
                            while(id_fee.length()<=30)
                                id_fee +='#';
                                
     
                        }
                        string id_carrier = lines.line.Id;
                        if(string.isnotempty(id_carrier) == true && id_carrier.length() <=30)
                        {
                            while(id_carrier.length()<=30)
                                id_carrier +='#';
                     
                        }
                        
                        if(string.isnotempty(lines.contact_select) == true && lines.contact_select.length() <=30)
                        {
                            while(lines.contact_select.length()<=30)
                                lines.contact_select +='#';
                      
                        }
                        
                        blob blod_cod =Blob.valueOf(id_fee+id_carrier+lines.contact_select);
                        string conc_id = EncodingUtil.base64Encode(blod_cod);
                            
                        url_formulario += '/NEU_Form_Quotation?id='+conc_id; 
                        
                        
                        id_contacto = query_contact[0].Id;
                    }
                    else
                        continue;
               
                 emailbody += '</div>';
                 emailbody +='<div style="text-align:center">';
                 emailbody +='  <br>';
                 emailbody +='  <a style="color:#616db8; text-decoration:underline;font-size:2em" href="'+url_formulario+'" target="_blank">Quote Here</a>';
                 emailbody +='  <br>or copy / paste this url in your browser<br><a href="'+url_formulario+'" target="_blank">'+url_formulario+'</a>';
                 emailbody +='</div>';
                 system.debug('holaa'+emailbody);
                 body_tarea +='\n \n';
                 body_tarea +=url_formulario;
                 /*else
                 { 
                    if(String.IsNotEmpty(lines.line.NEU_Email__c))
                      toAddresses.add(lines.line.NEU_Email__c);
                    else
                        cuentas_sin_email = false;
                 }*/
                 
                 
                     if(cuentas_sin_email == true)
                     {
                          mail.setToAddresses(toAddresses);
                          mail.setSubject(Subject_email);
                          mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head></head><body style="font-family:Arial; font-size:14px;">'+emailbody.replace('\n','<br/>')+' <br/>Thanks<br/>'+UserInfo.getOrganizationName()+' team </body></html>');
                          mail.setCharset('UTF-8');
                          theEmails.add(mail);
                          
                          //TAREA CUENTA
                          Task new_task_account = new Task();
                          new_task_account.ActivityDate = system.today();
                          new_task_account.Subject =Subject_email;
                          new_task_account.Status = 'Completed';
                          new_task_account.Type = 'Email';
                          new_task_account.OwnerId = UserInfo.getUserId();
                          new_task_account.WhatId = liestado_fees_supplier.get(lines.line.Id).Id;
                          if(!NEU_TaskUtils.withTaskRelation())
                              new_task_account.WhoId = id_contacto;
                         // new_task_account.Send_Emails__c = true;
                          new_task_account.Priority = 'Normal';
                          new_task_account.Description = body_tarea;
                          
                          listado_tareas.add(new_task_account);
                          listado_contactos.add(id_contacto);
                          
                          if(apexpages.currentpage().getparameters().get('imp_exp') != null)
                          {
                              Task new_task_account2 = new Task();
                              new_task_account2.ActivityDate = system.today();
                              new_task_account2.Subject =Subject_email;
                              new_task_account2.Status = 'Waiting for the Supplier Quote';
                              if(string.isnotempty(id_fee) == true)
                                  new_task_account2.Service_Rate__c = id_fee.replace('#','');
                              new_task_account2.Type = 'Email';
                              new_task_account2.OwnerId = UserInfo.getUserId();
                              new_task_account2.WhatId = apexpages.currentpage().getparameters().get('imp_exp');
                              if(!NEU_TaskUtils.withTaskRelation())
                                  new_task_account2.WhoId = id_contacto;
                              new_task_account2.Send_Emails__c = true;
                              new_task_account2.Priority = 'Normal';
                              new_task_account2.Description = body_tarea;
                              
                              listado_tareas.add(new_task_account2);
                              listado_contactos.add(id_contacto);
                          }
                          
                          if(apexpages.currentpage().getparameters().get('ship') != null)
                          {
                              Task new_task_account2 = new Task();
                              new_task_account2.ActivityDate = system.today();
                              new_task_account2.Subject =Subject_email;
                              new_task_account2.Status = 'Completed';
                              new_task_account2.Type = 'Email';
                              new_task_account2.OwnerId = UserInfo.getUserId();
                              new_task_account2.WhatId = apexpages.currentpage().getparameters().get('ship');
                              if(!NEU_TaskUtils.withTaskRelation())
                                  new_task_account2.WhoId = id_contacto;
                              new_task_account2.Send_Emails__c = true;
                              new_task_account2.Priority = 'Normal';
                              new_task_account2.Description = body_tarea;
                              
                              listado_tareas.add(new_task_account2);
                              listado_contactos.add(id_contacto);
                          }
                          
                          if(apexpages.currentpage().getparameters().get('ship_prog') != null)
                          {
                              Task new_task_account2 = new Task();
                              new_task_account2.ActivityDate = system.today();
                              new_task_account2.Subject =Subject_email;
                              new_task_account2.Status = 'Completed';
                              new_task_account2.Type = 'Email';
                              new_task_account2.OwnerId = UserInfo.getUserId();
                              new_task_account2.WhatId = apexpages.currentpage().getparameters().get('ship_prog');
                              if(!NEU_TaskUtils.withTaskRelation())
                                  new_task_account2.WhoId = id_contacto;
                              new_task_account2.Send_Emails__c = true;
                              new_task_account2.Priority = 'Normal';
                              new_task_account2.Description = body_tarea;
                              
                              listado_tareas.add(new_task_account2);
                              listado_contactos.add(id_contacto);
                          }
                          
                     }
                     id_contacto = '';  
                 } 
              }
          }
          Messaging.SendEmailResult[] resultMail = null;
          try       
          {
              resultMail = Messaging.sendEmail(theEmails);
          /*}
          catch(System.EmailException ex)
          {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in send Email.'));
                enviado_correctamente = false;
                return;
          }
          try 
          {*/
             if(resultMail.size()>0)
                if(resultMail[0].isSuccess())
                {    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Email sent successfully.'));
                    insert listado_tareas;
                    integer indice = 0;
                    for(Task t: listado_tareas)
                    {
                        SObject new_task_relation=NEU_TaskUtils.newTaskRelation(t.Id, false, listado_contactos[indice]);
                        if(new_task_relation!=null)
                            relaciones_con_task.add(new_task_relation);
                            
                        indice ++;
                        
                    }
                    
                    try
                    {
                        if(relaciones_con_task != null && relaciones_con_task.size()>0)
                            insert relaciones_con_task;
                    }
                    catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}
                    
                    //actualizar el status de la IE si ha ido bien
                    if(apexpages.currentpage().getparameters().get('imp_exp') != null)
                    {
                        List<Customer_Quote__c> query_ie_to_update = [select Id, Name, Quotation_Status__c from Customer_Quote__c where Id=: apexpages.currentpage().getparameters().get('imp_exp')];
                        if(query_ie_to_update != null && query_ie_to_update.size()>0)
                        {
                            query_ie_to_update[0].Quotation_Status__c = 'Awaiting costs suppliers';
                            update query_ie_to_update;
                        }
                    }
                   
                }
                else 
                {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending email.'));
                  enviado_correctamente = false;
                  
                }
                
          }
          catch(System.EmailException ex)
          {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending email.'));
                enviado_correctamente = false;
                delete listado_fees_to_insert;  
          }
                
          lista_suppliers = null;
      }
      
  }
}