public with sharing class NEU_SendDocuments_Shipments_Program 
{

	public Shipment_Program__c record;
	
	public Shipment_Program__c buscador {get;set;}
	public List<User> usuarios {get;set;}
	public String user_list {get;set;}
	public List<documents_s> associated_documents {get;set;}
	public List<shipments_s> shipments_related {get;set;}
    public List<cuenta_s> clientes_seleccionados {get;set;}
	public Map<String, List<cuenta_s>> map_shipments_related {get;set;}
	public string asunto {get;set;}
	public decimal total_peso_ficheros {get;set;}
	public decimal bytesocupados  {get;set;}
	public string porc_ocupacion {get;set;}
	public string cuerpo_notificacion {get;set;}
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
	public boolean ver_enlace_externo{get; set;}
	public string ver_link_externo2{get;set;}
	public string ver_link_externo{get;set;}
	public string id_first_shipment{get;set;}
	public string defaultBcc {get;set;}
    public string link_one {get;set;}
    public string link_two {get;set;}	
	public String id_usuario {get;set;}
	public string comentarios {get;set;}
	public string html_body {get;set;}
    public string plain_text {get;set;}
	public string estilo_email {get;set;}
	public string firma {get;set;}
	public string cabecera {get;set;}
    public string link_publico{get;set;}
	
	public List<User> usuarios_cc {get; set;}{
		usuarios_cc = new List<User>();
	}
	
	public Integer optionTemplate { get; set; }
	{
	   optionTemplate = 0;
	}
	
	public Integer optionLanguage { get; set; }
	{
	   optionLanguage = 1;
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
    
    public class shipments_s
	{
		public Shipment__c shipments {get;set;}
		public List<cuenta_s> cuentas {get;set;}
		public shipments_s(Shipment__c shipments, List<cuenta_s> cuentas)
		{
			this.shipments = shipments;
			this.cuentas = cuentas;	
		}
	}
	
	public class cuenta_s
	{
		public Account cuenta {get;set;}
		public List<contacto_s> contactos {get;set;}
		public String typo_cuenta {get;set;}
		public String id_shipment {get;set;}
		
		public cuenta_s(Account cuenta, List<contacto_s> contactos, String typo_cuenta, String id_shipment)
		{
			this.cuenta = cuenta;
			this.contactos = contactos;
			this.typo_cuenta = typo_cuenta;
			this.id_shipment = id_shipment;
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
	
	public void add_usuario()
	{
		List<User> usuarios = new List<User>();
		if(buscador.User_Create_ShipmentSearch__c != null)
		{
			String consulta = '';
			consulta += 'SELECT Id, Name, Email FROM User WHERE Id = \''+buscador.User_Create_ShipmentSearch__c	+'\'';
			usuarios = Database.query(consulta);
		}
					
		for(User e : usuarios)
		{
			usuarios_cc.add(e);
		}
	}
	
	public void remove_usuario()
	{
		Integer i = 0;
		
		if(usuarios_cc.size() > 0)
		{
			for(User e : usuarios_cc)
			{
				if(e.Id == id_usuario)
					break;
				
				i++;
			}
			usuarios_cc.remove(i);
		}
	}   
    
	ApexPages.StandardController con;

	private void addaccount(Account myaccount,Id myId, string tipo, Shipment__c shipment)
	{
		cuenta_s new_account = new cuenta_s(myaccount,null,'',shipment.Id);
		
		List<Contact> contactos_cuenta = [select Id, Name, Email, AccountId from Contact where AccountId =: myId];// and Email != null
		List<contacto_s> contactos = new List<contacto_s>();
		for(Contact c : contactos_cuenta)
		{
			contactos.add(new contacto_s(c,false, (c.Email != null ? ' ('+c.Email+')' : ''  )));
		}
		new_account.typo_cuenta = tipo;
		new_account.contactos = contactos;
		new_account.id_shipment = shipment.Id;
		
		if(map_shipments_related.containsKey(shipment.Id))
        {  
        	map_shipments_related.get(shipment.Id).add(new_account);
        } 
        else
        {
        	map_shipments_related.put(shipment.Id, new List<cuenta_s>{new_account});
        }
	}
	
	public NEU_SendDocuments_Shipments_Program(ApexPages.StandardController stdController) 
	{
		con = stdController;
		system.debug( con.getRecord() );
		try { 
			record = [select Id, Name, Route__c, Number__c, Vessel_1__c ,  Route__r.Name, Vessel__c, Vessel__r.Name, Pallet_Container_Type__c, Pallet_Container_Type__r.Name from Shipment_Program__c where id = :con.getRecord().id];
		} 
		catch( Exception ee) 
		{ 
			record = new Shipment_Program__c();
		}
		
		buscador = new Shipment_Program__c();
		
		asunto='Shipments Program: ' + record.Name;
		id_first_shipment = '';
		Due_Date_task = new Shipment__c();
		ver_enlace_externo = false;
		if(string.isnotempty(record.Vessel_1__c))
		ver_enlace_externo = true;
		ver_link_externo2 = '';
		ver_link_externo = '';
	            
		CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
		if(sr == null)
		{
			sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
			if(sr == null)
				sr = CSH_Supplier_Request__c.getOrgDefaults();
		}					
	
		Boolean useExternal=false;
		if(sr!=null)
		{
			ver_link_externo=sr.Default_External_URL__c;
			ver_link_externo2=sr.Default_External_URL__c;
			link_publico=sr.Default_External_URL__c;
			useExternal=sr.Use_External_Url__c;
		}
		        
		if(String.IsEmpty(ver_link_externo)||(!useExternal))
		{
			ver_link_externo ='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Trace';
			ver_link_externo2 ='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_MD_Associated_Documents';
			link_publico ='http://'+ApexPages.currentPage().getHeaders().get('Host');
		}
		else
		{
			ver_link_externo +='/NEU_Trace';  
			ver_link_externo2 +='/NEU_MD_Associated_Documents';  
		}
		ver_link_externo2 = ver_link_externo2+'?id='+record.Id;  
		 
		 
		select_users = new List<SelectOption>(); 
		Status_task = 'Completed';
		subject_task = '';
		subject_task ='Shipments Program: ' + record.Name;
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
		cuerpo_notificacion='';
		cuerpo_notificacion +='Number:';
		if(record.Number__c!= null)
			cuerpo_notificacion +=' '+record.Number__c;
		cuerpo_notificacion +='\n'; 
		cuerpo_notificacion +='Route:';
		if(record.Route__c!= null)
			cuerpo_notificacion +=' '+record.Route__r.Name;
		cuerpo_notificacion +='\n'; 
		cuerpo_notificacion +='Container Type:';
		if(record.Pallet_Container_Type__c != null)
			cuerpo_notificacion +=' '+record.Pallet_Container_Type__r.Name;
		cuerpo_notificacion +='\n'; 
		cuerpo_notificacion +='Vessel:';
		if(record.Vessel__c!= null)
			cuerpo_notificacion +=' '+record.Vessel__r.Name;
		cuerpo_notificacion +='\n';
		cuerpo_notificacion +='\n'; 
		        
		shipments_related = new List<shipments_s>();
		map_shipments_related = new Map<String, List<cuenta_s>>();
		
		List<Shipment__c> lista_shipments_program = [select Id, Name, Account_for__c, Account_for__r.Name, Account_for__r.NEU_Email__c, Carrier__c, Carrier__r.Name, Carrier__r.NEU_Email__c,
		Consignee__c, Consignee__r.Name, Consignee__r.NEU_Email__c, Forwarder__c, Forwarder__r.Name, Forwarder__r.NEU_Email__c, Notify_Party__c, Notify_Party__r.Name, Notify_Party__r.NEU_Email__c,
		Shipper__c, Shipper__r.Name, Shipper__r.NEU_Email__c, Supplier_Account__c, Supplier_Account__r.Name, 
		Supplier_Account__r.NEU_Email__c from Shipment__c where Inbound_Consolidation_Program__c =: record.Id];
		for(Shipment__c ship: lista_shipments_program)
		{
			if(id_first_shipment == '')
				id_first_shipment = ship.Id;
			shipments_s new_shipment = new shipments_s(ship, null);
			new_shipment.shipments = ship;
			addaccount(ship.Account_for__r,ship.Account_for__c,'Account for (Buyer)',ship);
			if(ship.Carrier__c!=null)
				addaccount(ship.Carrier__r,ship.Carrier__c,'Carrier',ship);
			if(ship.Consignee__c != null)
				addaccount(ship.Consignee__r,ship.Consignee__c,'Consignee Account (Destination)',ship);
			if(ship.Forwarder__c!=null)
				addaccount(ship.Forwarder__r,ship.Forwarder__c,'Forwarder',ship);
			if(ship.Notify_Party__c != null)
				addaccount(ship.Notify_Party__r,ship.Notify_Party__c,'Notify Party',ship);
			if(ship.Shipper__c != null)
				addaccount(ship.Shipper__r,ship.Shipper__c , 'Shipper',ship);
			if(ship.Supplier_Account__c!=null)
				addaccount(ship.Supplier_Account__r,ship.Supplier_Account__c,'Supplier/Shipper Account (Origin)',ship);
			
			if(map_shipments_related.containsKey(ship.Id))	
				new_shipment.cuentas = map_shipments_related.get(ship.Id);
			shipments_related.add(new_shipment);

		}     
		ver_link_externo = ver_link_externo+'?id='+id_first_shipment+'&sp='+record.Id;      
		usuarios = [select Id, Name, IsActive, Email from User where IsActive = true and ContactId =: null and (NOT  Name like: '%Guest User%') order by ContactId];
		for(User us : usuarios)
			select_users.add(new SelectOption(us.Id,us.Name));
		            
		    
		porc_ocupacion = '0';
		bytesocupados   = 0;
		
		List<Associated_Document__c> documents = new List<Associated_Document__c>();
		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment__c, Account__c
		from Associated_Document__c where Consolidation_Program__c =: record.Id order by Document_Type__c];
		          
		List<documents_s> docs = new List<documents_s>();
		        
		for(Associated_Document__c ad : documents)
		{
			String id_doc = '';
			if (!Test.isRunningTest()) 
				if(ad.Document_URL__c != null && ad.Document_URL__c != '')
				{
					if(ad.Document_URL__c.contains('?id=') == true)
						id_doc = ad.Document_URL__c.substringBetween('?id=','&oid=');
					else if(ad.Document_URL__c.contains('?file=') == true)
						id_doc = ad.Document_URL__c.substringBetween('?file=','&oid=');
					docs.add(new documents_s(false, ad.Name, ad.Document_Type__c , ad.Document_Reference__c, ad.Document_Description__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), id_doc,0,'0'));
				}
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
		
		defaultBcc='';
		
		comentarios = 'We hope this information has been useful for you.';

		estilo_email  = '#contenedor { font-family: Arial, Helvetica, sans-serif; font-size: 12px; }';
		estilo_email += 'p, h4, h3, h2 { margin: 2px; }';
		estilo_email += '#table_head, #table_body { width: 700px; }';
		estilo_email += 'table.tabla { border: 1px solid black; margin: 5px; }';	
		estilo_email += 'table.tabla td { padding-right: 10px; }';   
    
		comentarios = 'We hope this information has been useful for you.';    
    
		firma  =  '	<tr>';
		firma +=  '		<td>';
		firma +=  '			<p>&nbsp;</p>';
		firma +=  '			<p>'+UserInfo.getName()+'</p>';
		firma +=  '			<p>'+UserInfo.getUserEmail()+'</p>';
		firma +=  '			<p>'+UserInfo.getOrganizationName()+'</p>';
		firma +=  '		</td>';
		firma +=  '	</tr>';
		
    	load_template();				
	}
    
    public void add_link_to_body()
    {
        if(link_one == null)
            link_one = '';
            
        CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
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
          defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Trace';
        else
          defaultUrl+='/NEU_Trace';     
        
        link_one ='Public Tracking Link: <a>'+defaultUrl+'?id='+record.Id+'</a>';
        
        load_template();
    }
    
    public void add_link_to_body2()
    {
        if(link_two == null)
            link_two = '';
            
        CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
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
          	defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_MD_Associated_Documents';
        else
          	defaultUrl+='/NEU_MD_Associated_Documents';     
        
        link_two ='Public Document Upload: <a>'+defaultUrl+'?id='+record.Id+'</a>';
    
		load_template();    
    }
    
    public void load_template()
    {	
		cuerpo_notificacion = '';
		asunto = '';
		
        if(optionTemplate==0)
        {	
        	asunto += 'Import/Export: ' + record.Name;
        	cuerpo_notificacion += plain_text;
        }
        else
        { 		    	
			NEU_SP_Notifications_PDF notificaciones = new NEU_SP_Notifications_PDF(new ApexPages.StandardController(record));
			notificaciones.optionTemplate = optionTemplate;
			notificaciones.optionLanguage = optionLanguage;
			notificaciones.load_template();
			asunto += notificaciones.asunto;
			cuerpo_notificacion += notificaciones.string_pdf;
	
			cuerpo_notificacion +=  '<table>';		
			cuerpo_notificacion +=  '	<tr>';
			cuerpo_notificacion +=  '		<td>';
			cuerpo_notificacion +=  '			<p>&nbsp;</p>';
			cuerpo_notificacion +=  '			<p>'+Comentarios+'</p>';
			cuerpo_notificacion +=  '		</td>';
			cuerpo_notificacion +=  '	</tr>';
			cuerpo_notificacion +=  '	<tr>';
			cuerpo_notificacion +=  '		<td>';
			cuerpo_notificacion +=  '			<p>&nbsp;</p>';
			if(optionLanguage==1)
			{
				// Inglés
				cuerpo_notificacion +=  '			<p>PDF Notification Link:</p>';
			}else if(optionLanguage==2){
				// Español
				cuerpo_notificacion +=  '			<p>Enlace de notificación al documento PDF:</p>';
			}
			cuerpo_notificacion +=  '			<p><a>'+link_publico+'/apex/NEU_SP_Notifications_PDF?id='+record.Id+'&optionTemplate='+optionTemplate+'&optionLanguage='+optionLanguage+'</a></p>';
			cuerpo_notificacion +=  '		</td>';
			cuerpo_notificacion +=  '	</tr>';
			cuerpo_notificacion +=  '	<tr>';
			cuerpo_notificacion +=  '		<td>';
			cuerpo_notificacion +=  '			<p>&nbsp;</p>';
			cuerpo_notificacion +=  '			<p>'+(link_one != null ? link_one : '')+'</p>';
			cuerpo_notificacion +=  '		</td>';
			cuerpo_notificacion +=  '	</tr>';
			cuerpo_notificacion +=  '	<tr>';
			cuerpo_notificacion +=  '		<td>';
			cuerpo_notificacion +=  '			<p>&nbsp;</p>';
			cuerpo_notificacion +=  '			<p>'+(link_two != null ? link_two : '')+'</p>';
			cuerpo_notificacion +=  '		</td>';
			cuerpo_notificacion +=  '	</tr>';
			cuerpo_notificacion +=  firma;
			cuerpo_notificacion +=  '</table>';
        }
		
		html_body = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body><div style="background-color: #ffffff; width: 720px; border: 1px solid #8a9ebe; padding: 5px;">'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+'</div></body></html>';
    }
    
    public void send_email()
    {
    	load_template();
    	    	
	    List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
	      
	    String[] receptores = new String[]{};
	    String[] receptoresId = new String[]{};
	    String[] receptores_usuarios = new String[]{};
		String[] receptores_usuarios_bcc = new String[]{};
	    string nombre_documentos_enviados = '';
	    List<Id> list_contactos = new List<id>();

		if(usuarios_cc.size() > 0){
			for(User u : usuarios_cc)
			{
				receptores_usuarios.add(u.Email);
			}
		}
		
		if(defaultBcc != null && defaultBcc != '' && defaultBcc != '[]'){
			receptores_usuarios_bcc = defaultBcc.split(';',0);
		}   
	   		
	   		
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
		String cuerpo_notificacion_form = cuerpo_notificacion;
      
		if(shipments_related != null)
		{
			for(shipments_s ship : shipments_related)
			{
				for(cuenta_s cu : ship.cuentas)
				{
					if(cu.contactos != null)
					{
						for(contacto_s con : cu.contactos)
						{
							if(con.selected)
							{
								if(con.contact.Email != null)
								{
									receptores.add(con.contact.Email);
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
						mail.setSenderDisplayName('NEURORED');
						mail.setSubject(asunto);
						mail.setBccSender(false); 
						mail.setUseSignature(false); 
						mail.setCharset('UTF-8');
						mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
						theEmails.add(mail);
						
						receptores.clear();
						list_contactos = new List<id>();
					}
				}
			}
		}
      
		if(hay_envio == false)
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setFileAttachments(documentos_adjuntos);
			mail.setToAddresses(receptores_usuarios);
			mail.setSenderDisplayName('NEURORED');
			mail.setSubject(asunto);
			mail.setBccSender(false); 
			mail.setUseSignature(false); 
			mail.setCharset('UTF-8');
			mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
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
		if(create_task == true)
		{
			if(shipments_related != null)
			{
				for(shipments_s ship : shipments_related)
				{
					for(cuenta_s cu: ship.cuentas)
					{
						if(cu.contactos != null)
						{
							for(contacto_s con : cu.contactos)
							{
								if(con.selected)
								{
									if(con.contact.Email != null)
									{
										receptoresId.add(con.contact.Id);
										list_contactos.add(con.contact.Id);
										hay_envio = true;
									}
								}
							}
						}
					}
					
					if(receptoresId.size()>0)
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
						   
						string descripcion_email = (cuerpo_notificacion != null ? cuerpo_notificacion + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
						new_task_account.Description = descripcion_email;
						
						try
						{
							insert new_task_account;
						}
						catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));} 
						
						//TAREA SHIPMENT
						Task new_task_shipment = new Task();
						new_task_shipment.ActivityDate = Due_Date_task.Conversion_Rate_Date__c;
						new_task_shipment.Subject =subject_task;
						new_task_shipment.Status = Status_task;
						new_task_shipment.Type = 'Email';
						new_task_shipment.OwnerId = OwnerId_task;
						new_task_shipment.WhatId = ship.shipments.Id;
						if(!NEU_TaskUtils.withTaskRelation())
							new_task_shipment.WhoId = receptoresId[0];
						new_task_shipment.Send_Emails__c = true;
						new_task_shipment.Priority = priority_task;
						   
						descripcion_email = (cuerpo_notificacion != null ? cuerpo_notificacion + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
						new_task_shipment.Description = descripcion_email;
						
						try
						{
							insert new_task_shipment; 
						}
						catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}  
						      
						for(Id i: list_contactos)
						{
							SObject new_task_relation=NEU_TaskUtils.newTaskRelation(new_task_account.Id,false,i);
							if(new_task_relation!=null)
								relaciones_con_task.add(new_task_relation);
							
							SObject new_task_relation2=NEU_TaskUtils.newTaskRelation(new_task_shipment.Id,false,i);
							if(new_task_relation2!=null)
								relaciones_con_task.add(new_task_relation2);	
						}
						
				    }
				    
					list_contactos = new List<id>();
					receptoresId.clear();
	      
				}
			}
    	}
      
		// si no hay ningun cliente envio a los users
		if(hay_envio == false)
		{
			if(create_task == true)
			{
				
				//TAREA SHIPMENT PROGRAM
				Task new_task_account = new Task();
				new_task_account.ActivityDate = Due_Date_task.Conversion_Rate_Date__c;
				new_task_account.Subject = subject_task ;
				new_task_account.Status = Status_task;
				new_task_account.Type = 'Email';
				new_task_account.OwnerId = OwnerId_task;
				new_task_account.WhatId = record.Id;
				new_task_account.Send_Emails__c = true;
				new_task_account.Priority = priority_task;
				string descripcion_email = (cuerpo_notificacion != null ? cuerpo_notificacion + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
				new_task_account.Description = descripcion_email;
				 
				try
				{
					insert new_task_account;
				}
				catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}  
			}     
			receptores.clear();
			receptoresId.clear();
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
    
    public PageReference return_shipment_program()
	{
		PageReference pgReturnPage;
		String returnUrl = '/' + record.Id;
		pgReturnPage = new PageReference(returnUrl);
		pgReturnPage.setRedirect(true);
		return pgReturnPage;
	}
	
}