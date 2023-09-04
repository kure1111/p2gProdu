public class NEU_SendDocuments_Catalog_Price_List {//with sharing

    public Price_List__c record;
    public List<User> usuarios {get;set;}
    public String user_list {get;set;}
    public List<documents_s> associated_documents {get;set;}
    public List<cuenta_s> clientes_seleccionados {get;set;}
    public string asunto {get;set;}
    public decimal total_peso_ficheros {get;set;}
    public decimal bytesocupados  {get;set;}
    public string porc_ocupacion {get;set;}
    public string texto_email {get;set;}
    public string resultado {get;set;}
    public string OwnerId_task{get;set;}
    public string Status_task{get;set;}
    public Shipment__c Due_Date_task{get;set;}
    public boolean create_task{get;set;}
    public List<SelectOption> select_status_task{get; set;}
    public string priority_task{get;set;}
    public string tabla_referencias{get;set;}
    public string subject_task{get;set;}
    public List<SelectOption> select_users{get; set;}
    
    public class contacto_s
    {
      public Contact contact {get;set;}
      public Boolean selected {get;set;}
      public string direccion_correo {get;set;}
      public contacto_s(Contact contact, Boolean selected, string direccion_correo )
      {
        this.contact = contact;
        this.selected = selected;
        this.direccion_correo = direccion_correo;
      }
    }
    
    public class cuenta_s
    {
      public Account cuenta {get;set;}
      public List<contacto_s> contactos {get;set;}
      public String typo_cuenta {get;set;}
      
      public cuenta_s(Account cuenta, List<contacto_s> contactos, String typo_cuenta)
      {
        this.cuenta = cuenta;
        this.contactos = contactos;
        this.typo_cuenta = typo_cuenta;
      }
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
      
      public documents_s(Boolean selected, String name, String document_type, String document_reference, String document_description, String document_url, String id_doc, decimal espacio, string porespacio)
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
    
    ApexPages.StandardController con;
    
    private void addaccount(Account myaccount,Id myId, string tipo)
    {
      cuenta_s new_account = new cuenta_s(myaccount,null,'');
    
      List<Contact> contactos_cuenta = [select Id, Name, Email, AccountId from Contact where AccountId =: myId];// and Email != null
      List<contacto_s> contactos = new List<contacto_s>();
      for(Contact c : contactos_cuenta)
      {
        contactos.add(new contacto_s(c,false, (c.Email != null ? ' ('+c.Email+')' : ''  )));
      }
      new_account.typo_cuenta = tipo;
      new_account.contactos = contactos;
      
      clientes_seleccionados.add(new_account);
    }
    public NEU_SendDocuments_Catalog_Price_List(ApexPages.StandardController stdController) 
    {
         con = stdController;
            system.debug( con.getRecord() );
      try { 
       record = [select Id, Name, Items_Account_Owner__c, Items_Account_Owner__r.Name, Supply_Project__c, Supply_Project__r.Name from Price_List__c where id = :con.getRecord().id];
      } catch( Exception ee) { 
        record = new Price_List__c();
      }
        asunto='Catalog Price List: ' + record.Name;
        Due_Date_task = new Shipment__c();
        select_users = new List<SelectOption>(); 
        Status_task = 'Completed';
        subject_task = '';
        subject_task ='Catalog Price List: ' + record.Name;
        tabla_referencias = '';
        tabla_referencias += '<div id="capa_referencias">';
        tabla_referencias += '<table class="tabla_referencias">';
        
        tabla_referencias += '</table>';
        tabla_referencias += '</div>';
        priority_task = 'Normal';
        select_status_task = new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldResult = Task.Status .getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            select_status_task .add(new SelectOption(f.getValue(),f.getValue()));
        }
        OwnerId_task = UserInfo.getUserId();
        create_task = true;
        texto_email='';
        clientes_seleccionados = new List<cuenta_s>();
        if(record.Items_Account_Owner__c != null)
            addaccount(record.Items_Account_Owner__r,record.Items_Account_Owner__c,'Account Owner');
         
        usuarios = [select Id, Name, IsActive, Email from User where IsActive = true and ContactId =: null and (NOT  Name like: '%Guest User%') order by ContactId];
        for(User us : usuarios)
            select_users .add(new SelectOption(us.Id,us.Name));
            
    
        porc_ocupacion = '0';
        bytesocupados   = 0;

        List<Associated_Document__c> documents = new List<Associated_Document__c>();
        if(record.Supply_Project__c != null)
        {
            documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment__c, Account__c, Supply_Project__c
            from Associated_Document__c where Supply_Project__c =: record.Supply_Project__c order by Document_Type__c];
        }
        else
        {
            documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment__c, Account__c, Supply_Project__c
            from Associated_Document__c where Account__c =: record.Items_Account_Owner__c order by Document_Type__c];
        }  
        List<documents_s> docs = new List<documents_s>();
        
        for(Associated_Document__c ad : documents)
        {
            system.debug('holaaa2'+ad+ad.Document_URL__c);
            String id_doc = '';
          if (!Test.isRunningTest()) 
              if(ad.Document_URL__c != null && ad.Document_URL__c != '')
              {
                if(ad.Document_URL__c.contains('?id=') == true)
                    id_doc = ad.Document_URL__c.substringBetween('?id=','&oid=');
                  else if(ad.Document_URL__c.contains('?file=') == true)
                    id_doc = ad.Document_URL__c.substringBetween('?file=','&oid=');
                  docs.add(new documents_s(false, ad.Name, ad.Document_Type__c , ad.Document_Reference__c, ad.Document_Description__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), id_doc,0,'0'));
                system.debug('holaaa'+docs);
              }
        }

        if (!Test.isRunningTest()) 
        {
            Set<String> list_documents = new Set<String>();
            for(documents_s ad : docs)
            {
                if(ad.id_doc != null)
                    list_documents.add(ad.id_doc);
            }
            
            Map<Id,Document> doc = new Map<Id,Document>([select Id, Name, Body from Document where Id IN: list_documents]);
            
            for(documents_s ad : docs)
            {
                if(ad.id_doc != null)
                {     
                    if(doc.containskey(ad.id_doc))
                    { 
                      Blob b = doc.get(ad.id_doc).Body;
                      ad.espacio = b.size();
                      if(b.size()> 5242880)
                          ad.porespacio = '100';
                      else
                         ad.porespacio = string.valueof(b.size()*100/5242880);  
                    }
                }
            }
        }
        
        associated_documents = docs;
        
    }
  
  public void add_link_to_body()
  {
    if(texto_email == null)
      texto_email = '';
      
     /* CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
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
        defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/'+record.Id;
      else
        defaultUrl+='/'+record.Id;    */  
    string defaultUrl = 'http://neurored-developer-edition.eu2.force.com/suppliers/'+record.Id;
    texto_email +=' '+defaultUrl;
    //texto_email +=' '+defaultUrl+'?id='+record.Id;
  }
  
    public void send_email()
    {
      List<Contact> contacts = [select Id, Name, Email, AccountId from Contact where Email != null and AccountId =: record.Items_Account_Owner__c];
  
      List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
      
      String[] receptores = new String[]{};
      String[] receptoresId = new String[]{};
      String[] receptores_usuarios = new String[]{};
      string nombre_documentos_enviados = '';
      List<Id> list_contactos = new List<id>();
      //Email Administración
      if(user_list != null && user_list != '' && user_list != '[]')
        receptores_usuarios = user_list.split(',',0);
  
      List<Messaging.EmailFileAttachment> documentos_adjuntos = new List<Messaging.EmailFileAttachment>();
    
      total_peso_ficheros =0;
      integer lugar_extension_fichero = 0;
      string nombre_ficheros_extension = '';
      string nombre_ficheros = '';
      
      for(documents_s ad : associated_documents)
      {
            if(ad.selected)
            {
               List<Document> doc = [select Id, Name, Body, Type, DeveloperName from Document where Id =: ad.id_doc];
               nombre_documentos_enviados += ad.Name +' ('+URL.getSalesforceBaseUrl().toExternalForm() + ad.document_url+') \n';
              if(doc.size()>0)
              {
                
                Blob b = doc[0].Body;
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                if(ad.Name.contains('.') == true)
                   efa.setFileName(ad.name);
                else
                {
                   string documento_typo = doc[0].Type;
                   efa.setContentType('application/'+documento_typo);
                   string name_documento_adjunto = ad.name+'.'+doc[0].Type;
                   efa.setFileName(name_documento_adjunto);
                     
                } 
                if(efa.FileName.contains('.html'))
                    efa.FileName = efa.FileName.replace('.html','.'+doc[0].Type);
                efa.setBody(b);
                total_peso_ficheros += b.size();
                documentos_adjuntos.add(efa); 
              }
            }
      }
    
      List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo']; 
      List<SObject> relaciones_con_task = new List<SObject>();
      String estilo_email = '';
      estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
      estilo_email += 'p{margin:0; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
      estilo_email += '.user_name{font-weight:bold;}';
      
      List<User> user_loged = [select Id, Name, FirstName, LastName, Department, Title, Street, Phone, MobilePhone, Email 
      from User where Id =: UserInfo.getUserId()];
      
      String firma = '';
      if(user_loged.size() > 0)
      {
        firma += '<br/>';
        firma += '<p class="user_name">'+(user_loged[0].FirstName != null ? user_loged[0].FirstName : '') +' '+user_loged[0].LastName+'</p>';
        firma += '<p class="user_company">'+(user_loged[0].Department != null ? user_loged[0].Department : '')+'</p>';
        firma += '<p class="user_rol">'+(user_loged[0].Title != null ? user_loged[0].Title : '')+'</p>';
        firma += '<br/>';
        firma += '<p class="user_address2">'+(user_loged[0].Street != null ? user_loged[0].Street : '')+'</p>';
        firma += '<p class="user_phone">Tel: '+(user_loged[0].Phone != null ? user_loged[0].Phone : '')+', Móvil: '+(user_loged[0].MobilePhone != null ? user_loged[0].MobilePhone : '')+'</p>';
        firma += '<p class="user_email">E-mail: '+(user_loged[0].Email != null ? user_loged[0].Email : '')+'</p>';
        firma += '<br/>';
        firma += '<img src="'+URL.getSalesforceBaseUrl().toExternalForm()+'/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" class="company_logo"/>';
      }
      boolean hay_envio = false;
      String contactos = '';
      String texto_email_form = texto_email;
      
      if(clientes_seleccionados != null)
      {
        for(cuenta_s c : clientes_seleccionados)
        {
          if(c.contactos != null)
          {
            for(contacto_s con : c.contactos)
            {
              if(con.selected)
              {
                if(con.contact.Email != null)
                {
                  receptores.add(con.contact.Email);
                  receptoresId.add(con.contact.Id);
                  contactos += con.contact.Name+', ';
                  list_contactos.add(con.contact.Id);
                  hay_envio = true;
                }
              }
            }
          }
  
          if(receptores.size()>0)
          {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setFileAttachments(documentos_adjuntos);
            mail.setToAddresses(receptores);
            mail.setCcAddresses(receptores_usuarios);
            mail.setSenderDisplayName((user_loged.size() > 0 ? (user_loged[0].FirstName != null ? user_loged[0].FirstName : '') +' '+user_loged[0].LastName : 'Grupo ED'));
            mail.setSubject(asunto);
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            mail.setCharset('UTF-8');
            mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
            theEmails.add(mail);

            receptores.clear();
            list_contactos = new List<id>();
            receptoresId.clear();
            contactos = '';
          }
        }
      }
      
      if(hay_envio == false)
      {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setFileAttachments(documentos_adjuntos);
        mail.setToAddresses(receptores_usuarios );
        mail.setSenderDisplayName((user_loged.size() > 0 ?  (user_loged[0].FirstName != null ? user_loged[0].FirstName : '')+' '+user_loged[0].LastName : 'Grupo ED'));
        mail.setSubject(asunto);
        mail.setBccSender(false); 
        mail.setUseSignature(false); 
        mail.setCharset('UTF-8');
        mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
        theEmails.add(mail);
      }
      
         
      List<Messaging.Email> allMails = new List<Messaging.Email>();
      for(Integer j = 0; j < theEmails.size(); j++)
      {
        allMails.add(theEmails.get(j));
      }
      
      try
      {
        Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The email was sent successfully.'));
      }
      catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}
      
      //crear las tareas una vez enviado el email
      if(clientes_seleccionados != null)
      {
        for(cuenta_s c : clientes_seleccionados)
        {
          if(c.contactos != null)
          {
            for(contacto_s con : c.contactos)
            {
              if(con.selected)
              {
                if(con.contact.Email != null)
                {
                  receptores.add(con.contact.Email);
                  receptoresId.add(con.contact.Id);
                  contactos += con.contact.Name+', ';
                  list_contactos.add(con.contact.Id);
                  hay_envio = true;
                }
              }
            }
          }
          if(receptores.size()>0)
          {
             if(create_task == true)
            {
                //TAREA CUENTA
                Task new_task_account = new Task();
                new_task_account.ActivityDate = Due_Date_task.Conversion_Rate_Date__c;
                new_task_account.Subject =subject_task;
                new_task_account.Status = Status_task;
                new_task_account.Type = 'Email';
                new_task_account.OwnerId = OwnerId_task;
                new_task_account.WhatId = record.Id;
                if(!NEU_TaskUtils.withTaskRelation())
                  new_task_account.WhoId = receptoresId[0];
                new_task_account.Send_Emails__c = true;
                new_task_account.Priority = priority_task;
               
                string descripcion_email = (texto_email != null ? texto_email + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
                new_task_account.Description = descripcion_email;
                try
                {
                  insert new_task_account;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}  
                  
                for(Id i: list_contactos)
                {
                    SObject new_task_relation=NEU_TaskUtils.newTaskRelation(new_task_account.Id,false,i);
                  if(new_task_relation!=null)
                      relaciones_con_task.add(new_task_relation);
                }
            }
          }
            receptores.clear();
            list_contactos = new List<id>();
            receptoresId.clear();
            contactos = '';
          
        }
      }
      
      // si no hay ningun cliente envio a los users
      if(hay_envio == false)
      {
        if(create_task == true)
        {
            //TAREA CUENTA
            Task new_task_account = new Task();
            new_task_account.ActivityDate = Due_Date_task.Conversion_Rate_Date__c;
            new_task_account.Subject = subject_task ;//'Shipment Order';
            new_task_account.Status = Status_task;
            new_task_account.Type = 'Email';
            new_task_account.OwnerId = OwnerId_task;
            new_task_account.WhatId = record.Id;
            new_task_account.Send_Emails__c = true;
            new_task_account.Priority = priority_task;
            string descripcion_email = (texto_email != null ? texto_email + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
            new_task_account.Description = descripcion_email;
         
            try
              {
              insert new_task_account;
            }
              catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}  
        }     
        receptores.clear();
        receptoresId.clear();
        contactos = '';
      }
      
      //CREACIÓN DE TAREAS RELACIONES CON CUENTAS
      if(create_task == true)
      {
        try
        {
          insert relaciones_con_task;
        }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}
      }
    }
    
    public PageReference return_catalog_price_list()
    {
      PageReference pgReturnPage;
      String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
          pgReturnPage.setRedirect(true);
      return pgReturnPage;
    }
}