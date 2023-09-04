public with sharing class NEU_Generic_SendDocuments 
{
	public List<documents_s> associated_documents {get;set;}
	public String subject {get;set;}
	public String subject_hidden {get;set;}
	public String message_hidden {get;set;}
	public String to {get;set;}
	public String to_hidden {get;set;}
	public String cc {get;set;}
	public String cc_hidden {get;set;}
	public decimal total_peso_ficheros {get;set;}
	public decimal bytesocupados  {get;set;}
	public string porc_ocupacion {get;set;}
	public string Id_cuenta {get;set;}
	public string[] Id_cuenta_array = new string[]{};
	public List<SelectOption> select_users{get; set;}
	public List<User> usuarios {get;set;}
	public string OwnerId_task{get;set;}
	public string subject_task{get;set;}
	public string Status_task{get;set;}
	public List<SelectOption> select_status_task{get; set;}
	public string priority_task{get;set;}
	public Shipment__c Due_Date_task{get;set;}
	public boolean create_task{get;set;}
	public string id_object{get;set;}
	public List<cuenta_s> clientes_seleccionados {get;set;}
	public string label_object2{get;set;}
	public String user_list {get;set;}
	public string label_object{get;set;}
	public string texto_email {get;set;}
	public String id_usuario {get;set;}
	public List<EmailTemplate> templates {get;set;}
	public String id_template {get;set;}
	
	public List<User> users_cc {get; set;}{
		users_cc = new List<User>();
	}
	
	public string defaultBcc {get;set;}
	{
		defaultBcc = '';
	}

	public Customer_Quote__c buscador {get;set;}
	{
		buscador = new Customer_Quote__c();
	}
  
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
    
    ApexPages.StandardController con;
    
	public PageReference load_documents()
  	{
  		templates = [select Id, Name, Subject, Body, HtmlValue from EmailTemplate where FolderId = '00l0Y000000xvCj'];
  		
    	String object_select = '';
    	String object_id = '';
    	porc_ocupacion = '0';
    	bytesocupados   = 0;
	    if(ApexPages.currentPage().getParameters().get('object_select') != null)
	      object_select = ApexPages.currentPage().getParameters().get('object_select');
	    if(ApexPages.currentPage().getParameters().get('object_id') != null)
	    {
	      object_id = ApexPages.currentPage().getParameters().get('object_id');
	      id_object = ApexPages.currentPage().getParameters().get('object_id');
    	}
	      Id_cuenta = '';
	    //-------------------
	    subject_task = '';
	    label_object ='';
	    List<SObject> name_object = null;
	    //-----------------------
	    List<Associated_Document__c> documents = new List<Associated_Document__c>();
    
	    if(object_select == 'account' && object_id != '')
	    {
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Account__c
	      				from Associated_Document__c where Account__c =: object_id];
	      	subject_task ='Account: ';
	      	name_object = [select Id, Name from Account where id =: object_id];
	      	List<Account> listado_cuentas = [select Id, Name from Account  where id =: object_id];
	      	clientes_seleccionados = new List<cuenta_s>();
	      	if(listado_cuentas.size()>0)
		  		addaccount(listado_cuentas[0],listado_cuentas[0].Id,'Account');
	    }
    
    	if(object_select == 'claim' && object_id != '')
    	{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Claim__c, Account__c
  						from Associated_Document__c where Claim__c =: object_id];
      		subject_task ='Claim: ';
      		name_object = [select Id, Name from Claim__c where id =: object_id];
      		List<Claim__c> listado_claims = [select Id, Name, Customer__c, Customer__r.Name, Account_engaged__c, Account_engaged__r.Name from Claim__c  where id =: object_id];
      		clientes_seleccionados = new List<cuenta_s>();
			if(listado_claims.size()>0)
			{
				addaccount(listado_claims[0].Customer__r,listado_claims[0].Customer__c,'Customer');
				if(listado_claims[0].Account_engaged__c !=null)
					addaccount(listado_claims[0].Account_engaged__r,listado_claims[0].Account_engaged__c,'Account engaged');
			}
    	}
      
    	if(object_select == 'scm_contract' && object_id != '')
    	{
			documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, SCM_Contract__c, Account__c
						from Associated_Document__c where SCM_Contract__c =: object_id];
			subject_task ='SCM Contracts: ';
			name_object = [select Id, Name from SCM_Contract__c where id =: object_id];
			List<SCM_Contract__c> listado_scm_contract= [select Id, Name, Account_for__c, Account_for__r.Name from SCM_Contract__c where id =: object_id];
			clientes_seleccionados = new List<cuenta_s>();
			if(listado_scm_contract.size()>0)
			{
				addaccount(listado_scm_contract[0].Account_for__r,listado_scm_contract[0].Account_for__c,'Account for');
			}
    	}
      
    	if(object_select == 'shipment_consolidation_data' && object_id != '')
    	{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment_Consolidation_Data__c, Account__c
      					 from Associated_Document__c where Shipment_Consolidation_Data__c =: object_id];
      		subject_task ='Shipment Consolidation Data: ';
      		name_object = [select Id, Name from Shipment_Consolidation_Data__c where id =: object_id];
      		List<Shipment_Consolidation_Data__c> listado_shipment_consolidation_data = [select Id, Name, Customer_Buyer__r.Name , Customer_Buyer__c, Supplier__r.Name, Supplier__c  from Shipment_Consolidation_Data__c where id =: object_id];
      
      		clientes_seleccionados = new List<cuenta_s>();
      		if(listado_shipment_consolidation_data.size()>0)
      		{
       			if(listado_shipment_consolidation_data[0].Customer_Buyer__c!=null)
		   			addaccount(listado_shipment_consolidation_data[0].Customer_Buyer__r,listado_shipment_consolidation_data[0].Customer_Buyer__c,'Customer/Buyer');
				if(listado_shipment_consolidation_data[0].Supplier__c!=null)
		   			addaccount(listado_shipment_consolidation_data[0].Supplier__r,listado_shipment_consolidation_data[0].Supplier__c,'Supplier');
      		}
    	}
      
    	if(object_select == 'shipment_disbursement' && object_id != '')
    	{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment_Disbursement__c, Account__c
      					 from Associated_Document__c where Shipment_Disbursement__c =: object_id];
      		subject_task ='Shipment Disbursements: ';
      		name_object = [select Id, Name from Shipment_Disbursement__c where id =: object_id];
      
      		List<Shipment_Disbursement__c> listado_shipment_disbursement = [select Id, Name, Account__c, Account__r.name from Shipment_Disbursement__c where id =: object_id];
      
      		clientes_seleccionados = new List<cuenta_s>();
      		if(listado_shipment_disbursement.size()>0)
      		{
       			if(listado_shipment_disbursement[0].Account__c!=null)
		   			addaccount(listado_shipment_disbursement[0].Account__r,listado_shipment_disbursement[0].Account__c,'Account');
      		}
    	}
      
    	if(object_select == 'shopping_cart' && object_id != '')
    	{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shopping_Cart__c, Account__c
      					 from Associated_Document__c where Shopping_Cart__c =: object_id];
      		subject_task ='Customer Order Line: ';
      		name_object = [select Id, Name from Shopping_Cart__c where id =: object_id];
      
      		List<Shopping_Cart__c> listado_customer_orde = [select Id, Name, Customer__r.Name, Customer__c, Shopping_Cart_Agent__c, Shopping_Cart_Agent__r.Name  from Shopping_Cart__c where id =: object_id];
      		clientes_seleccionados = new List<cuenta_s>();
      		if(listado_customer_orde.size()>0)
      		{
      			addaccount(listado_customer_orde[0].Customer__r,listado_customer_orde[0].Customer__c,'Account for');
       			if(listado_customer_orde[0].Shopping_Cart_Agent__c!=null)
		   			addaccount(listado_customer_orde[0].Shopping_Cart_Agent__r,listado_customer_orde[0].Shopping_Cart_Agent__c,'Customer Order Agent');
      		}
    	}
      
    	if(object_select == 'supplier_quote' && object_id != '')
    	{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Supplier_Quote__c, Account__c
      				     from Associated_Document__c where Supplier_Quote__c =: object_id];
      		subject_task ='Suppliers Quotes/Orders: ';
      		name_object = [select Id, Name from Supplier_Quote__c where id =: object_id];
      		List<Supplier_Quote__c> listado_supplier_quote = [select Id, Name, Supplier__r.Name, Supplier__c, Customer__r.Name, Customer__c, Delivery_Account__r.Name, Delivery_Account__c  from Supplier_Quote__c where id =: object_id];
      		clientes_seleccionados = new List<cuenta_s>();
      		if(listado_supplier_quote.size()>0)
      		{
		  		addaccount(listado_supplier_quote[0].Supplier__r,listado_supplier_quote[0].Supplier__c,'Supplier');
		  		if(listado_supplier_quote[0].Customer__c != null)
		       		addaccount(listado_supplier_quote[0].Customer__r,listado_supplier_quote[0].Customer__c , 'Buyer Account');
		  		if(listado_supplier_quote[0].Delivery_Account__c != null)
		       		addaccount(listado_supplier_quote[0].Delivery_Account__r,listado_supplier_quote[0].Delivery_Account__c , 'Pickup / Delivery Account');
      		}
    	}
      
    	if(object_select == 'supplier_request_rfp' && object_id != '')
    	{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Supplier_Request_RFP__c, Account__c
      					 from Associated_Document__c where Supplier_Request_RFP__c =: object_id];
      		subject_task ='Supplier Requests: ';
      		name_object = [select Id, Name from Supplier_Request_RFP__c where id =: object_id];
      		List<Supplier_Request_RFP__c> listado_supplier_request = [select Id, Name, Supplier__c, Supplier__r.Name from Supplier_Request_RFP__c where id =: object_id];
  			clientes_seleccionados = new List<cuenta_s>();
      		if(listado_supplier_request.size()>0)
      		{
		  		addaccount(listado_supplier_request[0].Supplier__r,listado_supplier_request[0].Supplier__c,'Supplier');
      		}
    	}
      
		if(object_select == 'supply_project' && object_id != '')
		{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Supply_Project__c, Account__c
      					 from Associated_Document__c where Supply_Project__c =: object_id];
      		subject_task ='Supply Projects: ';
      		name_object = [select Id, Name from Supply_Project__c where id =: object_id];
      
      		List<Supply_Project__c> listado_supply_project = [select Id, Name, Customer__r.Name, Customer__c, Project_Sales_Agent__r.Name, Project_Sales_Agent__c from Supply_Project__c where id =: object_id];
      		clientes_seleccionados = new List<cuenta_s>();
      		if(listado_supply_project.size()>0)
      		{
		  		addaccount(listado_supply_project[0].Customer__r,listado_supply_project[0].Customer__c,'Customer/Buyer Account');
		  		if(listado_supply_project[0].Project_Sales_Agent__c!=null)
		      		addaccount(listado_supply_project[0].Project_Sales_Agent__r,listado_supply_project[0].Project_Sales_Agent__c,'Project Sales Agent');
      		}
    	}
    
    	if(object_select == 'shipment_packaging_consolidation_data' && object_id != '')
    	{
      		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment_Packaging_Consolidation_Data__c, Account__c
      					 from Associated_Document__c where Shipment_Packaging_Consolidation_Data__c =: object_id];
      		subject_task ='Transport Packaging Data: ';
      		name_object = [select Id, Name from Transport_Packaging_Data__c where id =: object_id];
      
      		List<Transport_Packaging_Data__c> listado_transport_packaging_data = [select Id, Name, Ship_to_Door_Account__r.Name, Ship_to_Door_Account__c, Ship_from_Door_Account__c, Ship_from_Door_Account__r.Name , Transporter__c, Transporter__r.Name from Transport_Packaging_Data__c where id =: object_id];
      		clientes_seleccionados = new List<cuenta_s>();
      		if(listado_transport_packaging_data.size()>0)
      		{
       			if(listado_transport_packaging_data[0].Ship_to_Door_Account__c!=null)
		   			addaccount(listado_transport_packaging_data[0].Ship_to_Door_Account__r,listado_transport_packaging_data[0].Ship_to_Door_Account__c,'Delivery to (Account)');
				if(listado_transport_packaging_data[0].Ship_from_Door_Account__c !=null)
		   			addaccount(listado_transport_packaging_data[0].Ship_from_Door_Account__r,listado_transport_packaging_data[0].Ship_from_Door_Account__c,'Pickup from (Account)'); 
				if(listado_transport_packaging_data[0].Transporter__c!=null)
		   			addaccount(listado_transport_packaging_data[0].Transporter__r,listado_transport_packaging_data[0].Transporter__c,'Transporter');
      		}
    	}
    
    	List<documents_s> docs = new List<documents_s>();
    	//------
    	Status_task = 'Completed'; 
	    priority_task = 'Normal';
	    texto_email = '';
	    label_object2 = '';
	    create_task = false;
	    Due_Date_task = new Shipment__c();
	    select_status_task = new List<SelectOption>(); 
	    Schema.DescribeFieldResult fieldResult = Task.Status .getDescribe();
	    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	    for( Schema.PicklistEntry f : ple)
	    {
        	select_status_task .add(new SelectOption(f.getValue(),f.getValue()));
	    }
    
	    if(name_object != null && name_object.size()>0)	
	    {
	    	subject_task += String.valueOf( name_object[0].get('Name') ); 
	    	label_object2 = String.valueOf( name_object[0].get('Name') ); 
	    }
	    label_object = subject_task;
	    subject = subject_task;
	    OwnerId_task = UserInfo.getUserId();
	    select_users = new List<SelectOption>(); 
		usuarios = [select Id, Name, IsActive, Email from User where IsActive = true and  ContactId =: null and (NOT  Name like: '%Guest User%') order by ContactId];
		for(User us : usuarios)
		{
	   		select_users .add(new SelectOption(us.Id,us.Name));
		}
    
    
	    for(Associated_Document__c ad : documents)
	    {
      		String id_doc = '';
    		if (!Test.isRunningTest()) 
	        	if(ad.Document_URL__c != null && ad.Document_URL__c != '')
	        	{
	            	id_doc = ad.Document_URL__c.substringBetween('?id=','&oid=');
	            	docs.add(new documents_s(false, ad.Name, ad.Document_Description__c, ad.Document_Reference__c, ad.Document_Type__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), id_doc,0,'0'));
	            	Id_cuenta += ad.Account__c+',';
	            
	        	}
    	}
    
	    if(Id_cuenta != null)
	    {
        	Id_cuenta_array = Id_cuenta.split(',',0);
	    }
    
	    if (!Test.isRunningTest()) 
	    {
	        for(documents_s ad : docs)
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
    	associated_documents = docs;
    
		return null;
	}
  
	public PageReference return_shipment()
	{
		PageReference pgReturnPage;
		String returnUrl = '/' + id_object;
		pgReturnPage = new PageReference(returnUrl);
		pgReturnPage.setRedirect(true);
		return pgReturnPage;
	}
    
 	public void send_email()
    {
  
  		List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
      
		String[] receptores = new String[]{};
		String[] receptoresId = new String[]{};
		string nombre_documentos_enviados = '';
		List<Id> list_contactos = new List<id>();
		String[] receptores_usuarios = new String[]{};
		String[] receptores_usuarios_bcc = new String[]{};
  
		if(users_cc.size() > 0){
			for(User e : users_cc)
			{
				receptores_usuarios.add(e.Email);
			}
		}
		
		if(defaultBcc != null && defaultBcc != '' && defaultBcc != '[]'){
			receptores_usuarios_bcc = defaultBcc.split(';',0);
		}    
  
      	List<Messaging.EmailFileAttachment> documentos_adjuntos = new List<Messaging.EmailFileAttachment>();
    
	    //--------------------
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
    
    	//------------------------------
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
					if(receptores_usuarios.size()>0){
						mail.setCcAddresses(receptores_usuarios);
					}
					if(receptores_usuarios_bcc.size()>0){
						//mail.setBccSender(true); 
						mail.setBccAddresses(receptores_usuarios_bcc);
					}
					// Mejorar mediante el Development executive¿?
					// mail.setSenderDisplayName((user_loged.size() > 0 ? (user_loged[0].FirstName != null ? user_loged[0].FirstName : '') +' '+user_loged[0].LastName : ''));
					mail.setSenderDisplayName('NEURORED');
		            mail.setSubject(subject);
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
			if(receptores_usuarios.size()>0){
				mail.setCcAddresses(receptores_usuarios);
			}
			if(receptores_usuarios_bcc.size()>0){
				//mail.setBccSender(true); 
				mail.setBccAddresses(receptores_usuarios_bcc);
			}
			// Mejorar mediante el Development executive¿?
			// mail.setSenderDisplayName((user_loged.size() > 0 ? (user_loged[0].FirstName != null ? user_loged[0].FirstName : '') +' '+user_loged[0].LastName : ''));
			mail.setSenderDisplayName('NEURORED');
	        mail.setSubject(subject);
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
		                new_task_account.WhatId = id_object;
		                if(!NEU_TaskUtils.withTaskRelation() && !receptoresId.isEmpty())
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
	            new_task_account.WhatId = id_object;
	            new_task_account.Send_Emails__c = true;
	            new_task_account.Priority = priority_task;
	            string descripcion_email = (texto_email != null ? texto_email + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
	            new_task_account.Description = descripcion_email;//(descripcion_email != null ? (descripcion_email.length() < 255 ? descripcion_email : descripcion_email.substring(0,255)) :'');
         
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

	public void add_usuario()
	{
		List<User> usuarios = new List<User>();
		if(buscador.User_Create_Import_ExportQuotesSearch__c != null)
		{
			String consulta = '';
			consulta += 'SELECT Id, Name, Email FROM User WHERE Id = \''+buscador.User_Create_Import_ExportQuotesSearch__c	+'\'';
			usuarios = Database.query(consulta);
		}
					
		for(User e : usuarios)
		{
			users_cc.add(e);
		}
	}
	
	public void remove_usuario()
	{
		Integer i = 0;
		
		if(users_cc.size() > 0)
		{
			for(User e : users_cc)
			{
				if(e.Id == id_usuario)
					break;
				
				i++;
			}
			users_cc.remove(i);
		}
	}
	
	public void load_template()
	{
		EmailTemplate template_selected = [select Id, Name, Body from EmailTemplate where Id =: id_template];
		if(template_selected != null)
			texto_email = template_selected.Body;
	}
	

}