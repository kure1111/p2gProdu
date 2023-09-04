public with sharing class NEU_OM_Send_Requests 
{
    public Supply_Project__c record;
    private List<Items_s> lista_items = null;
    private List<Supplier_s> lista_suppliers = null;
    public String message {get;set;}
    public String subject {get;set;}
    
    
    public String id_item_selected {get;set;}
    public String name_item_selected {get;set;} 
    private string Info_item = null;
    
    public decimal total_peso_ficheros {get;set;}
    public decimal bytesocupados  {get;set;}
    public string porc_ocupacion {get;set;}
    public string all_country_load {get;set;}
    public string all_port_load {get;set;}
    private List<documents_s> associated_documents =null;
    public boolean cuentas_sin_email {get;set;} 
     
    public List<documents_s> getassociated_documents() 
    {
        if(associated_documents == null)
        {
          associated_documents=new List<documents_s>();
          List<Associated_Document__c> documents = new List<Associated_Document__c>();
          documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Supply_Project__c, Account__c
          from Associated_Document__c where Supply_Project__c =: record.Id];
          
          String id_doc = '';
          for(Associated_Document__c  ad:documents)
          { 
            id_doc = '';
            if(ad.Document_URL__c != null && ad.Document_URL__c != '')
            {
                id_doc = (ad.Document_URL__c.contains('?file=') ? ad.Document_URL__c.substringBetween('?file=','&oid=') : ad.Document_URL__c.substringBetween('?id=','&oid='));
                associated_documents.add(new documents_s(false, ad.Name, ad.Document_Description__c, ad.Document_Reference__c, ad.Document_Type__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), id_doc,0,'0'));
            }  
          }
          
          
           for(documents_s ad : associated_documents)
            {
                if(ad.id_doc != null)
                {
                    List<Document> doc = [select Id, Name, Body from Document where Id =: ad.id_doc];
                 
                    if(doc.size()>0)
                    { 
                      Blob b = doc[0].Body;
                      ad.espacio = b.size();
                      if(b.size()> 5242880)
                          ad.porespacio = '100';
                      else
                         ad.porespacio = string.valueof(b.size()*100/5242880);  
                    }
                
                }
            }
          
        } 
          return associated_documents;
    } 
     
       public class documents_s
      {
        public Boolean selected {get;set;}
        public String name {get;set;}
        public String document_type {get;set;}
        public String document_reference {get;set;}
        public String document_description {get;set;}
        public String document_url {get;set;}
        public String id_doc {get;set;}
        public decimal espacio{get;set;}
        public String porespacio{get;set;}
     
        
        public documents_s(Boolean selected, String name, String document_type, String document_reference, String document_description, 
        String document_url, String id_doc, decimal espacio, string porespacio)
        {
          this.selected = selected;
          this.name = name;
          this.document_type = document_type;
          this.document_reference = document_reference;
          this.document_description = document_description;
          this.document_url = document_url;
          this.id_doc = id_doc;
          this.espacio= espacio;
          this.porespacio= porespacio;
          
        }
      }
     
    public string getInfo_item()
    {
        Info_item = '';
        for(Items_s  item : getlista_items())
        {
            if(item.selected == true)
            {
                Info_item +='Item: '+ item.line.Sourcing_Item__r.Name+'</br>';
                Info_item +='Technical Description:'+ (item.line.Technical_description__c != null ? item.line.Technical_description__c : '') +'</br>';
                Info_item +='Packaging System:'+ (item.line.Sourcing_Item__r.Packaging_System__c != null ? item.line.Sourcing_Item__r.Packaging_System__c :'') +'</br>';
                Info_item +='Quantity:'+ item.line.Quantity__c+'</br>';
                Info_item +='Unit of Measure:'+ item.line.Unit_of_measure__c+'</br>'+'</br>';
            }
        }
        
        if(Info_item == '' && id_item_selected != null)
        {
            for(Items_s  item : getlista_items())
            {
                if(item.line.Sourcing_Item__c == id_item_selected)
                {
                    Info_item +='Item: '+ item.line.Sourcing_Item__r.Name+'</br>';
                    Info_item +='Technical Description:'+ (item.line.Technical_description__c != null ? item.line.Technical_description__c : '') +'</br>';
                    Info_item +='Packaging System:'+ (item.line.Sourcing_Item__r.Packaging_System__c != null ? item.line.Sourcing_Item__r.Packaging_System__c :'') +'</br>';
                    Info_item +='Quantity:'+ item.line.Quantity__c+'</br>';
                    Info_item +='Unit of Measure:'+ item.line.Unit_of_measure__c+'</br>'+'</br>';
                    break;
                }
            }
        }
        Info_item += ' Please, copy this url and paste in your browser to review the request and send your offer: </br> http://neuebuscm-developer-edition.eu2.force.com/apex/NEU_JE_New_Supplier?pr='+record.Id;
        
        
          return Info_item;
    }
    
    ApexPages.StandardController con;
    public NEU_OM_Send_Requests(ApexPages.StandardController stdController) {
        
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        	ID recordid=con.getRecord().id;
        record = database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Subfamily__c, Contract_Duration__c, Port_Airport_of_Load__c, State_of_Load__c, Country_of_Load__c, Description_Supply_Project__c, Date_Limit__c, Max_Shipment__c,  Sourcing_Family__c, Incoterm__c, Sourcing_Family__r.Name, Subfamily__r.Name, Business_Area__c, Estimated_Delivery_Date__c, Customer__c, Customer__r.OwnerId  from Supply_Project__c where id = :recordid');
        } catch( Exception ee) { 
          record = new Supply_Project__c();
        }
        
        subject =  record.Name;
        
        
    }
    
    
    public class Supplier_s
    {
        public Supplier_to_Invite__c line {get; set;}
        public Supplier_Request_RFP__c rfp {get; set;}
        public boolean selected {get; set;}
        public string observation {get; set;}
        public string fecha {get; set;}
        public boolean creado {get; set;}
        
        public List<SelectOption> currencys {get; set;}
        public string currency_select {get; set;}
        public List<SelectOption> incoterm {get; set;}
        public string incoterm_selected {get; set;}
        public List<SelectOption> incoterm_place {get; set;}
        public string incoterm_place_selected {get; set;}
        public string max_shipment {get; set;}
        public string contract_duration {get; set;}
        
        
        public Supplier_s(Supplier_to_Invite__c line, Supplier_Request_RFP__c rfp,boolean selected, string observation, string fecha, boolean creado,
         List<SelectOption> currencys, string currency_select, List<SelectOption> incoterm, string incoterm_selected, 
         List<SelectOption> incoterm_place, string incoterm_place_selected, string max_shipment, string contract_duration  )
        {
                this.line=line;
                this.rfp = rfp;
               /* this.rfp = new Supplier_Request_RFP__c();
                if(record.Country_of_Load__c != null)
                {
                    this.rfp.Country_of_Load__c = record.Country_of_Load__c;
                    if(record.Port_Airport_of_Load__c != null)
                        this.rfp.Port_Airport_of_Load__c = record.Port_Airport_of_Load__c;
                }*/
                this.selected=selected;
                this.observation=observation;
                this.fecha=fecha;
                this.creado=creado;
                this.currencys=currencys;
                this.currency_select=currency_select;
                this.incoterm=incoterm;
                this.incoterm_selected=incoterm_selected;
                this.incoterm_place=incoterm_place;
                this.incoterm_place_selected=incoterm_place_selected;
                this.max_shipment=max_shipment;
                this.contract_duration=contract_duration;

        }
    }
     
    public List<Supplier_s> getlista_suppliers()
    {
        
          lista_suppliers=new List<Supplier_s>();
          
            //lista monedas
          List<SelectOption> options = new List<SelectOption>(); 
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
          //lista incoterm
          List<SelectOption> options_incoterm = new List<SelectOption>(); 
          Schema.DescribeFieldResult fieldResult2 = Supply_Project__c.Incoterm__c.getDescribe();
          List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
          for( Schema.PicklistEntry f : ple2)
          {
                    options_incoterm.add(new SelectOption(f.getValue(),f.getValue()));
          }
          
         
       
        
          
          List<Supplier_to_Invite__c> lines_insertadas = null;
          ID recordid=record.id;
          lines_insertadas=database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+' '+NEU_CurrencyUtils.CurrencyIsoCode('Account__r')+', Name, Supply_Project__c, CreatedDate, Account__c, Responsible_for_the_Project__r.Email, Account__r.NEU_Email__c, Account__r.Country_of_Load__c, Account__r.State_of_Load_Discharge__c, Account__r.Port_Airport_of_Load__c, Account__r.Incoterm__c , Responsible_for_the_Project__r.Name, Account__r.Status_Account__c, Account__r.Name, Account__r.Brand_Name__c, Account__r.Activity_Sector__c, Account__r.Description, Account__r.Quality_Products_Score__c, Account__r.Delivery_Times_Score__c, Account__r.Colaboration_Score__c, Account__r.Prices_Score__c, Account__r.Efficiency_Level_Score__c, Rol__c, Responsible_for_the_Project__c from Supplier_to_Invite__c where Supply_Project__c =: recordId');
          List<Supplier_Request_RFP__c> lineas_insertadas_request = new List<Supplier_Request_RFP__c>();
          lineas_insertadas_request =database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name,CreatedDate, Supply_Project__c, Supplier__c from  Supplier_Request_RFP__c where Supply_Project__c =: recordId');
          boolean insertado = false;
          for(Supplier_to_Invite__c l:lines_insertadas)
          {
            
             Supplier_Request_RFP__c sup_reques = new Supplier_Request_RFP__c();
             if(l.Account__r.Country_of_Load__c !=null)
             {
                sup_reques.Country_of_Load__c = l.Account__r.Country_of_Load__c;
                
                if(l.Account__r.State_of_Load_Discharge__c != null){
                	sup_reques.State_of_Load__c = l.Account__r.State_of_Load_Discharge__c;
                	
                	if(l.Account__r.Port_Airport_of_Load__c != null ){
                		sup_reques.Port_Airport_of_Load__c = l.Account__r.Port_Airport_of_Load__c;
                	}else if(record.Port_Airport_of_Load__c != null){
                		sup_reques.Port_Airport_of_Load__c = record.Port_Airport_of_Load__c;
                	}
                }else if(record.State_of_Load__c != null){
                	sup_reques.State_of_Load__c = record.State_of_Load__c;
                	
                	if(record.Port_Airport_of_Load__c != null){
                    	sup_reques.Port_Airport_of_Load__c = record.Port_Airport_of_Load__c;
                	}
                }
                
                
                
             }
             else if(record.Country_of_Load__c != null)
             {
                sup_reques.Country_of_Load__c = record.Country_of_Load__c;
                if(record.State_of_Load__c != null){
                	sup_reques.State_of_Load__c = record.State_of_Load__c;
                	
                	if(record.Port_Airport_of_Load__c != null){
                    	sup_reques.Port_Airport_of_Load__c = record.Port_Airport_of_Load__c;
                	}
                }
             }
            
            
                
            for(Supplier_Request_RFP__c li: lineas_insertadas_request)
            {
                if(l.Account__c == li.Supplier__c)
                {    
                                                                                                       //moneda aqui options[0].getValue()
                    lista_suppliers.add(new Supplier_s(l,sup_reques,false,'',string.valueOf(li.CreatedDate), true, options, NEU_CurrencyUtils.getCurrencyIsoCode(l.Account__r),
                    options_incoterm, (l.Account__r.Incoterm__c != null ? l.Account__r.Incoterm__c :(record.Incoterm__c != null ? record.Incoterm__c : options_incoterm[0].getValue())),null,'',
                    string.valueOf(record.Max_Shipment__c), string.valueOf(record.Contract_Duration__c)));   
                    insertado = true;  
                    break;
                }
            }
            if(insertado == false )                                             //moneda aqui options[0].getValue()
                lista_suppliers.add(new Supplier_s(l,sup_reques,false,'','', false,options, NEU_CurrencyUtils.getCurrencyIsoCode(l.Account__r), options_incoterm,
                (l.Account__r.Incoterm__c != null ? l.Account__r.Incoterm__c :(record.Incoterm__c != null ? record.Incoterm__c : options_incoterm[0].getValue())),null,'',
                string.valueof(record.Max_Shipment__c), string.valueof(record.Contract_Duration__c)));   
            insertado= false;
          } 
          return lista_suppliers;
    } 
    
    public class Items_s
    {
        public Items_to_Supply__c line {get; set;}
        public boolean selected {get; set;}
        public String quantity {get; set;}
        public String target_price {get; set;}
        public boolean show_target_price {get; set;}
        public string id_items_to_supply {get; set;}
        public boolean partial_quote {get; set;}
        
        public String conversion_factor {get; set;}
        public List<SelectOption> lista_uom {get; set;}
        public string select_uom {get; set;}
        public boolean hide_quantity {get; set;}
        
        public List<SelectOption> currencys {get; set;}
        public string currency_selected {get; set;}
         
        public Items_s(Items_to_Supply__c line, boolean selected, decimal quantity, decimal target_price, boolean show_target_price, string id_items_to_supply, boolean partial_quote, decimal conversion_factor, List<SelectOption> lista_uom, string select_uom, boolean hide_quantity,
        List<SelectOption> currencys, string currency_selected)
        {
                this.line=line;
                this.selected=selected;
                this.quantity=NEU_Utils.safeDecimal(quantity).format();
                this.target_price=NEU_Utils.safeDecimal(target_price).format();
                this.show_target_price=show_target_price;
                this.id_items_to_supply=id_items_to_supply;
                this.partial_quote=partial_quote;
                this.conversion_factor = NEU_Utils.safeDecimal(conversion_factor).format();
                this.lista_uom = lista_uom;
                this.select_uom = select_uom;
                this.hide_quantity = hide_quantity;
                this.currencys = currencys;
                this.currency_selected = currency_selected;
        }
    }
     
    public List<Items_s> getlista_items()
    {
        if(lista_items == null)
        {
          lista_items=new List<Items_s>();
          List<Items_to_Supply__c> items = new List<Items_to_Supply__c>();
          ID recordid=record.id;
          items = database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Quantity__c, Show_Target_Price__c, Sourcing_Item__r.Unit_of_measure__c, Unit_of_measure__c, Sourcing_Item__r.Description_of_Fitting__c, Target_Price__c, Sourcing_Item__c, Sourcing_Item__r.Name, Sourcing_Item__r.Packaging_System__c, Technical_description__c, Supply_Project__c from Items_to_Supply__c where Supply_Project__c =: recordId');
          
             List<SelectOption> options = new List<SelectOption>(); 
            options.add(new SelectOption('--None--','--None--'));
              Schema.DescribeFieldResult fieldResult2 = Sourcing_Item__c.Unit_of_measure__c.getDescribe();
              List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
              for( Schema.PicklistEntry f : ple2)
              {
                    options.add(new SelectOption(f.getValue(),f.getValue()));
              }
              
           List<SelectOption> options_currency = new List<SelectOption>(); 
       
            if(UserInfo.isMultiCurrencyOrganization()== true)
            {
               for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
               {
                    if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                    {
                      options_currency.add(new SelectOption(lu,lu));
                      break;
                    }
               }
               
               for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
               {
                    if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                      options_currency.add(new SelectOption(lu,lu));
               }
            }
            else
              options_currency.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
              
            
         
          for(Items_to_Supply__c  l:items)
          {
              lista_items.add(new Items_s(l,false,l.Quantity__c,l.Target_Price__c,l.Show_Target_Price__c, l.Id, false, 1,options, l.Sourcing_Item__r.Unit_of_measure__c,false,
              options_currency, NEU_CurrencyUtils.getCurrencyIsoCode(l)));     
          }
        } 
          return lista_items;
    } 
    
    
    public Pagereference send_request()
    {
        List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
        
        string emailbody = ''+message+'\n';
        string url_formulario = '';
        string moneda_elegida = '';
        
        CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
        if(sr == null)
        {
          sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
          if(sr == null)
              sr = CSH_Supplier_Request__c.getOrgDefaults();
        }
        
        String defaultUrl=null;
        String communityUrl=null;
        Boolean useExternal=false;
        if(sr!=null)
        {
          defaultUrl=sr.Default_External_URL__c;
          communityUrl=sr.Default_Community_URL__c;
          useExternal=sr.Use_External_Url__c;
        }
        
        if(String.IsEmpty(defaultUrl)||(!useExternal))
          defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/';
        else
          defaultUrl+='/NEU_JE_RFP_guest?rfp=';

        if(String.IsEmpty(communityUrl)||(!useExternal))
          communityUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/';
        else
          communityUrl+='/';
        
        boolean hay_items_sleccionados = false;
        List<Items_to_Supply__c> items_to_offer = new List<Items_to_Supply__c>();
        Id recordid=record.id;
        items_to_offer = database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Quantity__c, Show_Target_Price__c, Sourcing_Item__r.Description_of_Fitting__c, Unit_of_measure__c, Target_Price__c, Sourcing_Item__c, Sourcing_Item__r.Packaging_System__c, Sourcing_Item__r.Name, Technical_description__c, Supply_Project__c, Sourcing_Item__r.Sourcing_Item_Code__c from Items_to_Supply__c where Supply_Project__c =: recordId');
        
        
        List<Supplier_Request_Line__c> items=new List<Supplier_Request_Line__c>();
        List<Supplier_Request_Line__c> new_request_line_to_insert = new List<Supplier_Request_Line__c>();
        
          //RECORRER LOS ITEMS CON EL CHECK Y COMPROBAR SI SE ENVIA EL PRECIO
         for(Items_to_Supply__c ito : items_to_offer)
         {
            for(Items_s it:lista_items)
            {         
                if(it.line.Sourcing_Item__c == ito.Sourcing_Item__c && it.selected == true && it.id_items_to_supply == ito.Id)
                {

                   if(it.quantity==null)
                   {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'"Quantity" cannot be converted to Number'));
                        return null;
                   }
                   if(it.target_price ==null)
                   {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'"Target Price" cannot be converted to Number'));
                        return null;
                   }
                  
                  hay_items_sleccionados = true;
                  
                  Supplier_Request_Line__c newItem=new Supplier_Request_Line__c();
                  newItem.Item_to_Supply__c=ito.Id;
                  newItem.Partial_Quote__c = it.partial_quote;
                  newItem.Hide_Quantity__c= it.hide_quantity;
                  if(it.line != null && it.line.Target_Price__c != null)
                  	newItem.Target_Price__c = it.line.Target_Price__c;
                  newItem.Show_Target_Price__c = it.show_target_price;
                  newItem.Name=String.valueOf(items.size()+1);
                 // newItem.Quantity__c = NEU_Utils.toDecimal(it.quantity);
                  if(it.line != null && it.line.Quantity__c != null)
                  	newItem.Quantity__c = it.line.Quantity__c;
                  NEU_CurrencyUtils.setCurrencyIsoCode(newItem,it.currency_selected);
                  while(newItem.Name.length()<3)
                    newItem.Name='0'+newItem.Name;
                    
                  if(it.select_uom != '--None--') 
                    newItem.Unit_of_measure_RFP__c = it.select_uom;
                   newItem.Conversion_Factor__c = NEU_Utils.toDecimal(it.conversion_factor);
                   if(newItem.Conversion_Factor__c==null)
                   {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'"Conversion Factor" cannot be converted to Number'));
                        return null;
                   }
                   
                    
                  items.add(newItem);
                  
                }
             }
          }
          
        // datos para guardar y enviar a los suppliers del project
        string datos_project = '';
        if(record.Date_Limit__c != null)
            datos_project += 'Date Limit : '+ record.Date_Limit__c+'\n';
        if(record.Estimated_Delivery_Date__c != null)
            datos_project += 'Estimated Delivery Date : '+ record.Estimated_Delivery_Date__c+'\n';
        if(record.Description_Supply_Project__c != null)
            datos_project += 'Description Supply Project : '+ record.Description_Supply_Project__c+'\n';
        if(record.Business_Area__c != null)
            datos_project += 'Business Area : '+ record.Business_Area__c+'\n';
        if(record.Sourcing_Family__c != null)
            datos_project += 'Family : '+ record.Sourcing_Family__r.Name+'\n';
        if(record.Subfamily__c != null)
            datos_project += 'Subfamily : '+ record.Subfamily__r.Name+'\n'; 
        
        String max_deliverys = '';
        String cotract_duration = '';
        //para luego guardar los associated document
        List<String> listado_ids_suplier = new List<String>();
        
        List<Supplier_to_Invite__c> actors_project = null;
        actors_project = [select Id, Name, Account__c, Account__r.NEU_Email__c, Responsible_for_the_Project__r.Other_Email__c, Account__r.Name, Rol__c, Responsible_for_the_Project__r.Name, Responsible_for_the_Project__r.Email from Supplier_to_Invite__c where Supply_Project__c =: record.Id];
        //envio de emails por separado
        for(Supplier_to_Invite__c a : actors_project)
        {
            for(Supplier_s it:lista_suppliers)
            {  
                if(a.Account__c == it.line.Account__c && it.selected == true)
                {
                    
                  Supplier_Request_RFP__c new_supplier_request = new Supplier_Request_RFP__c();
                  new_supplier_request.Supply_Project__c = record.Id;
                  new_supplier_request.Supplier__c = a.Account__c;
                  if(it.incoterm_selected != null && it.incoterm_selected != '')
                    new_supplier_request.Incoterm_Request__c = it.incoterm_selected;
                    
               
                  if(it.max_shipment != null && it.max_shipment != '')
                  {
                    new_supplier_request.Max_Shipment__c = decimal.valueof(it.max_shipment);
                    max_deliverys = 'Max Deliveries : '+ it.max_shipment+'\n';
                  }
         
                  if(it.contract_duration != null && it.contract_duration != '')
                  {
                    new_supplier_request.Contract_Duration__c = decimal.valueof(it.contract_duration);
                    cotract_duration = 'Contract Duration (months) : '+ it.contract_duration+'\n';
                  }
                   
                   
                  if(it.observation != null && it.observation != '')
                    new_supplier_request.Observations__c = it.observation;
                    
                  if(it.currency_select != null && it.currency_select != '')
                  {
                    
                    NEU_CurrencyUtils.setCurrencyIsoCode(new_supplier_request,it.currency_select);
                    moneda_elegida = it.currency_select;
                    
                  }
                  String finalUrl=defaultUrl;
                  if(a.Responsible_for_the_Project__c != null)
                  {
                    new_supplier_request.Contact_Sent__c = a.Responsible_for_the_Project__c;
                    List<User> u=[select Id from User where ContactId=:new_supplier_request.Contact_Sent__c];
                    if(u.size()>0)
                        finalUrl=CommunityUrl;
                  } 
                  new_supplier_request.Subject__c = subject;
                  
                  new_supplier_request.Country_of_Load__c = it.rfp.Country_of_Load__c;
                  new_supplier_request.State_of_Load__c = it.rfp.State_of_Load__c;
                  new_supplier_request.Port_Airport_of_Load__c = it.rfp.Port_Airport_of_Load__c;
                  
                  try
                  {
                        insert new_supplier_request;
                        listado_ids_suplier.add(new_supplier_request.Id);
                        //URL FORMULARIO PARA CADA SUPPLIER
                        url_formulario = '<br/>Please, copy this url and paste in your browser to review the request and send your offer: <a href="'+finalUrl+new_supplier_request.Id+'" target="_blank">'+finalUrl+new_supplier_request.Id+'</a>';
                        String text_url_formulario = '\nPlease, copy this url and paste in your browser to review the request and send your offer: '+finalUrl+new_supplier_request.Id;
                        if(it.observation != null)
                          emailbody=''+message+'\n' + datos_project +''+ max_deliverys+''+cotract_duration +'Observations:\n' + it.observation + '\n';
                          
                         
                        new_supplier_request.Email_Body__c =  emailbody + text_url_formulario;
                        update new_supplier_request;
                        
                        
                        for(Supplier_Request_Line__c ito:items)
                        {
                          Supplier_Request_Line__c newItem=new Supplier_Request_Line__c();
                          newItem.Name=ito.Name;
                          newItem.Item_to_Supply__c=ito.Item_to_Supply__c;
                          newItem.Supplier_Request_RFP__c=new_supplier_request.Id;
                          newItem.Partial_Quote__c = ito.Partial_Quote__c;
                          newItem.Hide_Quantity__c = ito.Hide_Quantity__c;
                          newItem.Show_Target_Price__c = ito.Show_Target_Price__c;
                          newItem.Quantity__c = ito.Quantity__c;
                          newItem.Target_Price__c = ito.Target_Price__c;
                          //if(moneda_elegida != null && moneda_elegida != '')
                           // NEU_CurrencyUtils.setCurrencyIsoCode(newItem,moneda_elegida);
                          NEU_CurrencyUtils.setCurrencyIsoCode(newItem,NEU_CurrencyUtils.getCurrencyIsoCode(ito));
                          newItem.Unit_of_measure_RFP__c = ito.Unit_of_measure_RFP__c;
                          newItem.Conversion_Factor__c = ito.Conversion_Factor__c; 
                           
                         
                          new_request_line_to_insert.add(newItem);
                        }
                   }
                   catch(Exception ex)
                   {
                   }
                  cuentas_sin_email = true;
                  //ENVÍO EMAIL A CADA SUPPLIER POR SEPARADO
                  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  String[] toAddresses = new String[]{};
                  if(String.IsNotEmpty(a.Responsible_for_the_Project__r.Email))
                  {
                        toAddresses.add(a.Responsible_for_the_Project__r.Email);
                        if(String.IsNotEmpty(a.Responsible_for_the_Project__r.Other_Email__c))
                            toAddresses.add(a.Responsible_for_the_Project__r.Other_Email__c);
                  } 
                  else
                  {
                    if(String.IsNotEmpty(a.Account__r.NEU_Email__c))
                      toAddresses.add(a.Account__r.NEU_Email__c);
                    else
                        cuentas_sin_email = false;
                  }
                  if(cuentas_sin_email == true)
                  {
                      mail.setToAddresses(toAddresses);
                      mail.setSubject(subject);
                      mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head></head><body style="font-family:Arial; font-size:14px;">'+emailbody.replace('\n','<br/>') + url_formulario +'</body></html>');
                      mail.setCharset('UTF-8');
                      theEmails.add(mail);
                  }
                  
                  moneda_elegida = '';
                  max_deliverys = ''; 
                  cotract_duration = '';
                }
            }
        }
        
        try
        {
            insert new_request_line_to_insert;
        }
        catch(Exception ex){}
        
        //donde hay que crear documentos associados
        List<Supplier_Request_RFP__c> listado_supplier_documentos = [select Id, Name, Supplier__c from Supplier_Request_RFP__c where Supply_Project__c =: record.Id and Id IN: listado_ids_suplier];
        List<Associated_Document__c> listado_de_documentos_associado = new List<Associated_Document__c>();
        
        //adjuntar ficheros seleccionados
         List<Messaging.EmailFileAttachment> documentos_adjuntos = new List<Messaging.EmailFileAttachment>();
         decimal total_peso_ficheros =0;
         for(documents_s ad : associated_documents)
        {
          if(ad.selected)
          {
             List<Document> doc = [select Id, Name, Body, Type, DeveloperName from Document where Id =: ad.id_doc];
            
            if(doc.size()>0)
            {
              Blob b = doc[0].Body;
              Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                
             if(ad.Name.contains('.') == true)
                 efa.setFileName(ad.name);
             else
             {
                efa.setContentType('application/'+doc[0].Type);
                efa.setFileName(ad.name+'.'+doc[0].Type);
                 
             }  
              efa.setBody(b);
              total_peso_ficheros += b.size();
              documentos_adjuntos.add(efa);
            }
            
            for(Supplier_Request_RFP__c su_re_rfp : listado_supplier_documentos)
            {
                Associated_Document__c nuevo_documento_associate = new Associated_Document__c();
                nuevo_documento_associate.Name = ad.Name;
                nuevo_documento_associate.Supplier_Request_RFP__c = su_re_rfp.Id;
                nuevo_documento_associate.Document_URL__c = ad.document_url;
                nuevo_documento_associate.Account__c = su_re_rfp.Supplier__c;
                if(string.isempty(ad.document_type) == false)
                    nuevo_documento_associate.Document_Type__c = ad.document_type ;
                listado_de_documentos_associado.add(nuevo_documento_associate);
            }
            
          }
        }
        
        try
        {
            insert listado_de_documentos_associado;
        }
        catch(Exception ex){}
        
        
             
        
        //Envío de Emails
        if(total_peso_ficheros <= 10485760)
        {
            try 
            {
                List<Messaging.Email> allMails = new List<Messaging.Email>();
                for(Integer j = 0; j < theEmails.size(); j++)
                {
                    if(documentos_adjuntos.size()>0)
                        theEmails.get(j).setFileAttachments(documentos_adjuntos);
                    allMails.add(theEmails.get(j));
                }
            
                
                 Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(allMails);
                 if(resultMail.size()>0)
                    if(resultMail[0].isSuccess())
                    {    
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Email sent successfully.'));
                    }
                    else 
                    {
                      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending email.'));
                      return null;
                    }
            }
            catch(System.EmailException ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending email.'));
                return null;
            }
        
            
                
                PageReference pgReturnPage;
                String returnUrl = '/' + record.Id;
                pgReturnPage = new PageReference(returnUrl);
                pgReturnPage.setRedirect(true);
                return pgReturnPage;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error exceeded the maximum attachments'));
            return null;
        }
      }
      
    public PageReference return_project()
   {
     PageReference pgReturnPage;
     String returnUrl = '/' + record.Id;
     pgReturnPage = new PageReference(returnUrl);
     pgReturnPage.setRedirect(true);
     return pgReturnPage;
  }     
  
}