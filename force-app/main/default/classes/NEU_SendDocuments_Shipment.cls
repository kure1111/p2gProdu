public with sharing class NEU_SendDocuments_Shipment
{

	public Shipment__c record;

	public Shipment_Program__c buscador {get;set;}
	public List<User> usuarios {get;set;}
	public String user_list {get;set;}
	public List<documents_s> associated_documents {get;set;}
	public List<cuenta_s> clientes_seleccionados {get;set;}
	public string asunto {get;set;}
	public decimal total_peso_ficheros {get;set;}
	public decimal bytesocupados	{get;set;}
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
	public string comentarios {get;set;}
	public string html_body {get;set;}
	public string plain_text {get;set;}
	public string estilo_email {get;set;}
	public string firma {get;set;}
	public string cabecera {get;set;}
	public string defaultBcc {get;set;}
	public string defaultCc {get;set;}
	public string link_one {get;set;}
	public string link_two {get;set;}
	public String id_usuario {get;set;}
	public string link_publico{get;set;}
	
	public List<User> usuarios_cc {get; set;}{
		usuarios_cc = new List<User>();
	}
	
	public List<Shipment_Fee_Line__c> listado_de_lineas_de_fees {get; set;}{
		listado_de_lineas_de_fees = new List<Shipment_Fee_Line__c>();
	}
	
	public List<Shipment_Line__c> query_shipment_lines {get; set;}{
		query_shipment_lines = new List<Shipment_Line__c>();
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
		public Id id_file {get;set;}
		public decimal espacio{get;set;}
		public String porespacio{get;set;}

		public documents_s(Boolean selected, String name, String document_type, String document_reference, String document_description, String document_url, String id_doc, Id id_file, decimal espacio, string porespacio)
		{
			this.selected = selected;
			this.name = name;
			this.document_type = document_type;
			this.document_reference = document_reference;
			this.document_description = document_description;
			this.document_url = document_url;
			this.id_doc = id_doc;
			this.id_file = id_file;
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
			contactos.add(new contacto_s(c,false, (c.Email != null ? ' ('+c.Email+')' : ''	)));
		}
		new_account.typo_cuenta = tipo;
		new_account.contactos = contactos;
			
		clientes_seleccionados.add(new_account);
	}
	
	public void add_usuario()
	{
		List<User> usuarios = new List<User>();
		if(buscador.User_Create_ShipmentSearch__c != null)
		{
			String consulta = '';
			consulta += 'SELECT Id, Name, Email FROM User WHERE Id = \''+buscador.User_Create_ShipmentSearch__c +'\'';
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
	
	public NEU_SendDocuments_Shipment(ApexPages.StandardController stdController) 
	{
		con = stdController;
		system.debug(con.getRecord().Id);
		
		/* DATOS DEL SHIPMENT */	
		try { 
			record = [select Id, Name, Account_for__c, Number__c, Nature_Merchandise__c,
					 Container_Type__r.Name, Consignee__c, Vessel_1__c, Account_Shipment_Reference__c, 
					 Carrier_Shipment_Reference__c, Notify_Party__c, Carrier__c, Forwarder__c, 
					 Equipment__c, ETA_Point_of_Discharge__c, Service_Mode__c,
					 ETD_from_Point_of_Load__c, Supplier_Account__c, Truck_Vessel_Flight__c, Service_Type__c, 
					 Sales_Incoterm__c, Country_of_Load__c, Country_of_Discharge__c, MBL_Number__c, Freight_Mode__c,
					 Account_for__r.Name, Supplier_Account__r.Name, Site_of_Discharge__r.Name, Flight_Number__c, 
					 Site_of_Load__r.Name, Carrier__r.Name, Truck_Vessel_Flight__r.Name, Country_of_Load__r.Name, 
					 Country_of_Discharge__r.Name, Consignee__r.Name, Notify_Party__r.Name, MAWB_Number__c,	
					 Voyage_Number__c, Forwarder__r.Name
					 from Shipment__c where id = :con.getRecord().id];
		} catch( Exception ee) { 
			record = new Shipment__c();
		}
		
		/* DATOS CARGO LINES */ 
		try{	
			query_shipment_lines = [select id, Name, Item_Name__c, Shipping_Weight_Kg__c, Shipping_Volume_m3__c, 
									Extension_Item_Name__c, Units_Shipped__c, Item_Name__r.Name 
									from Shipment_Line__c where Shipment__c =: record.Id order by Name];
		} catch(Exception ee) { 
			query_shipment_lines = new List<Shipment_Line__c>();
		}
		
		/* DATOS SERVICE LINES */
		try{	
			listado_de_lineas_de_fees = [select Id, Name, Service_Rate_Name__c, Rate_Type__c, Units__c, Sell_Rate__c	
										 from Shipment_Fee_Line__c where Shipment__c =: record.Id order by Name];
		} catch(Exception ee) { 
			listado_de_lineas_de_fees = new List<Shipment_Fee_Line__c>();
		}
		
		buscador = new Shipment_Program__c();
				
		asunto='Shipment: ' + record.Name;
		Due_Date_task = new Shipment__c();
		ver_enlace_externo = false;
		if(string.isnotempty(record.Vessel_1__c))
			ver_enlace_externo = true;
		ver_link_externo2 = '';
		ver_link_externo = '';
		//--------------------------------
			
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
		List<Shipment_Track__c> lst_track = new List<Shipment_Track__c>();
		lst_track = [select Id, Shipment__c from Shipment_Track__c where Shipment__c =: record.Id];
		if(lst_track.size()>0){
			ver_link_externo = 'http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Shipment_View_Tracking_Share?id='+record.Id;
		}else{
			ver_link_externo = ver_link_externo+'?id='+record.Id;
		}
		
		//---------------------------------------
		select_users = new List<SelectOption>(); 
		Status_task = 'Completed';
		subject_task = '';
		subject_task ='Shipment: ' + record.Name;
		tabla_referencias = '';
		tabla_referencias += '<div id="capa_referencias">';
		tabla_referencias += '<table class="tabla_referencias">';
		
		tabla_referencias += '</table>';
		tabla_referencias += '</div>';
		priority_task = 'Normal';
		select_status_task = new List<SelectOption>(); 
		Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for(Schema.PicklistEntry f : ple)
		{
			select_status_task.add(new SelectOption(f.getValue(),f.getValue()));
		}

		OwnerId_task = UserInfo.getUserId();
		create_task = true;

		clientes_seleccionados = new List<cuenta_s>();
		addaccount(record.Account_for__r,record.Account_for__c,'Account for (Buyer)');
		if(record.Carrier__c!=null)
			addaccount(record.Carrier__r,record.Carrier__c,'Carrier');
		if(record.Consignee__c != null)
			addaccount(record.Consignee__r,record.Consignee__c,'Consignee Account (Destination)');
		if(record.Forwarder__c!=null)
			addaccount(record.Forwarder__r,record.Forwarder__c,'Forwarder');
		if(record.Notify_Party__c != null)
			addaccount(record.Notify_Party__r,record.Notify_Party__c,'Notify Party');
		if(record.Supplier_Account__c!=null)
			addaccount(record.Supplier_Account__r,record.Supplier_Account__c,'Supplier/Shipper Account (Origin)');
		
		usuarios = [select Id, Name, IsActive, Email from User where IsActive = true and ContactId =: null and (NOT	Name like: '%Guest User%') order by ContactId];
		for(User us : usuarios)
			select_users .add(new SelectOption(us.Id,us.Name));
			
		porc_ocupacion = '0';
		bytesocupados	= 0;

		List<Associated_Document__c> documents = new List<Associated_Document__c>();
		documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment__c, Account__c, File_Content_Version_Id__c
		from Associated_Document__c where Shipment__c =: record.Id order by Document_Type__c];

		List<documents_s> docs = new List<documents_s>();

		for(Associated_Document__c ad : documents)
		{
			Boolean selected = false;
			String id_doc = '';
			Id id_file = null;
			String document_selected = '';
			//if (!Test.isRunningTest())
			//{
			if(String.isNotEmpty(ad.File_Content_Version_Id__c))
			{
				id_doc = '';
				id_file = Id.valueof(ad.File_Content_Version_Id__c);
			}
			else if(ad.Document_URL__c != null && ad.Document_URL__c != '')
			{
				id_file = null;
				if(ad.Document_URL__c.contains('file='))
				{
					id_doc = ad.Document_URL__c.substringBetween('?file=','&oid=');
				}else{
					id_doc = ad.Document_URL__c.substringBetween('?id=','&oid=');
				}

			}
			if(String.isNotEmpty(document_selected) && ad.Id == document_selected)
				selected = true;

			docs.add(new documents_s(selected, ad.Name, ad.Document_Type__c, ad.Document_Reference__c, ad.Document_Description__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), id_doc, id_file,0,'0'));
			//}
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
		defaultCc='';
		
		//comentarios = 'We hope this information has been useful for you.';

		estilo_email	= '#contenedor { font-family: Arial, Helvetica, sans-serif; font-size: 12px; }';
		estilo_email += 'p, h4, h3, h2 { margin: 2px; }';
		estilo_email += 'table.tabla { border: 2px solid black; padding: 5px; width: 100%; }';
		estilo_email += 'table.tabla thead { border-bottom: 2px solid black;}';
		estilo_email += 'table.tabla thead th { font-size: 25px; text-align: center;}';
		estilo_email += 'table.tabla thead th:last-child { padding-bottom:10px; }';
		estilo_email += 'table.tabla thead th:last-child { padding-bottom:10px; }';
		estilo_email += 'th.pBottom, td.pBottom { padding-bottom:10px; }';
		estilo_email += 'table.tabla tbody th, table.tabla tbody td { padding-top:10px; padding-left:10px; padding-right:10px; }';
		estilo_email += 'table.tabla tbody tr:last-child th, table.tabla tbody tr:last-child td { padding-bottom:10px; }';
		estilo_email += 'tr.centroGrande th, tr.centroGrande td { text-align: center; font-size: 125%; border: 2px solid black; padding-bottom:10px}';
		estilo_email += 'table.tabla tbody th { width: 30%; text-align:left; }';
		estilo_email += 'table.tabla tbody th, table.tabla tbody td { font-family: Arial, Helvetica, sans-serif; font-size: 12px; }';
		
		estilo_email += '/* Client-specific Styles */';
	 	estilo_email += '#outlook a {padding:0;} /* Force Outlook to provide a "view in browser" menu link. */';
	 	estilo_email += 'body{width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0;}';
	 	estilo_email += '/* Prevent Webkit and Windows Mobile platforms from changing default font sizes, while not breaking desktop design. */';
	 	estilo_email += '.ExternalClass {width:100%;} /* Force Hotmail to display emails at full width */';
	 	estilo_email += '.ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height: 100%;} /* Force Hotmail to display normal line spacing.*/';
	 	estilo_email += 'img {outline:none; text-decoration:none;border:none; -ms-interpolation-mode:bicubic;}';
	 	estilo_email += 'a img {border:none;text-decoration:none;border:none; -ms-interpolation-mode:bicubic;}';
	 	estilo_email += 'p {margin: 0px 0px !important;}';
	 	estilo_email += 'table { border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; }';
	 	estilo_email += 'table td {border-collapse: collapse;}';
	 	estilo_email += '/*STYLES*/';
	 	estilo_email += '/*################################################*/';
	 	estilo_email += '/*IPAD STYLES*/';
	 	estilo_email += '/*################################################*/';
	 	estilo_email += '@media only screen and (max-width: 640px) {';
		estilo_email += '	 a[href^="tel"], a[href^="sms"] {';
		estilo_email += 'text-decoration:none;';
		estilo_email += 'color:#212121; /* or whatever your want */';
		estilo_email += ' pointer-events:none;';
		estilo_email += ' cursor:default;';
		estilo_email += ' }';
		estilo_email += ' .mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {';
		estilo_email += ' text-decoration:default;';
		estilo_email += ' color:#212121 !important;';
		estilo_email += ' pointer-events:auto;';
		estilo_email += ' cursor:default;';
		estilo_email += ' }';
		estilo_email += ' }';
	 	estilo_email += '/*##############################################*/';
	 	estilo_email += '/*IPHONE STYLES*/';
	 	estilo_email += '/*##############################################*/';
	 	estilo_email += '@media only screen and (max-width: 480px) {';
	 	estilo_email += '	 a[href^="tel"], a[href^="sms"] {';
		estilo_email += '	 text-decoration:none;';
		estilo_email += '	 color:#212121; /* or whatever your want */';
		estilo_email += '	 pointer-events:none;';
		estilo_email += '	 cursor:default;';
		estilo_email += '	 }';
		estilo_email += '	 .mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {';
		estilo_email += '	 text-decoration:default;';
		estilo_email += '	 color:#212121 !important; ';
		estilo_email += '	 pointer-events:auto;';
		estilo_email += '	 cursor:default;';
		estilo_email += '	 }';
	 	estilo_email += '}';
		estilo_email += '@import url(http://fonts.googleapis.com/css?family=Montserrat:400,700);';
	
		//comentarios = 'We hope this information has been useful for you.';	
	
		firma	=	' <tr>';
		
		List<User> user_loged = [select Id, Name, FirstName, LastName, Department, Title, Street, Phone, MobilePhone, Email from User where Id =: UserInfo.getUserId()];
		String firmaEmail = '';
		if(user_loged.size() > 0)
		{
			firma += '<br/><hr/><br/><table width="640" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">';
			firma += '	<tbody>';
			firma += '		<tr>';
			firma += '			<td width="90" valign="top" align="left" style="padding:0 20px 0 0;">';
			firma += '            	<table width="100%" border="0" cellspacing="0" cellpadding="0">';
			firma += '                	<tr>';
			firma += '                        <td valign="middle" align="center" style="width:90px; height:90px;">';
			firma += '                            <img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wh&oid=00D0Y0000033Ye1&lastMod=1528278379000" alt="Logo" style="display:block; border:none;" />';
			firma += '                        </td>';
			firma += '                	</tr>';
			firma += '                </table>';
			firma += '            </td>';
			firma += '			<td width="562" valign="top" align="left">';
			firma += '				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">';
			firma += '					<tbody>';
			firma += '						<tr>';
			firma += '							<td style="font-family:\'Montserrat\', sans-serif, Arial; font-size:16px; line-height:24px; font-weight:700; color:212121; padding:0 0 0 10px; letter-spacing:2px; text-transform:uppercase;">'+(user_loged[0].FirstName != null ? user_loged[0].FirstName : '') +' '+user_loged[0].LastName+'</td>';
			firma += '						</tr>';
			firma += '						<tr>';
			firma += '							<td style="font-family:\'Montserrat\', sans-serif, Arial; font-size:10px; line-height:14px; font-weight:400; color:#212121; padding:0 0 0 10px; letter-spacing:1px; text-transform:uppercase;">'+(user_loged[0].Title != null ? user_loged[0].Title : '')+'</td>';
			firma += '						</tr>';
			firma += '                        <tr>';
			firma += '							<td style="padding:15px 0 10px 10px;"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xk&oid=00D0Y0000033Ye1&lastMod=1528278950000" alt="" /></td>';
			firma += '						</tr>';
			firma += '						<tr>';
			firma += '							<td align="left" style="padding:5px 0 10px 10px;">';
			firma += '                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">';
			firma += '                                    <tbody>';
			firma += '                                        <tr>';	
			firma += '                                			<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wm&oid=00D0Y0000033Ye1&lastMod=1528278437000" alt="Map" style="display:block;" /></td>';
			firma += '                                            <td width="93%" height="35" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:700; color:#212121; letter-spacing:1px;">'+(user_loged[0].Street != null ? user_loged[0].Street : '')+'</td>';
			firma += '                                        </tr>';
			firma += '                                        <tr>';   
			firma += '                                			<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wr&oid=00D0Y0000033Ye1&lastMod=1528278477000" alt="Phone" style="display:block;" /></td>';
			firma += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;">'+(user_loged[0].Phone != null ? user_loged[0].Phone : '')+'</td>';
			firma += '                                        </tr>';
			firma += '                                        <tr>';   
			firma += '                                			<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wr&oid=00D0Y0000033Ye1&lastMod=1528278477000" alt="Phone" style="display:block;" /></td>';
			firma += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;">'+(user_loged[0].MobilePhone != null ? user_loged[0].MobilePhone : '')+' Celular</td>';
			firma += '                                        </tr>';                                        
			firma += '                                        <tr>';
			firma += '											<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6ww&oid=00D0Y0000033Ye1&lastMod=1528278510000" alt="Email" style="display:block;" /></td>';
			firma += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;">'+(user_loged[0].Email != null ? user_loged[0].Email : '')+'</td>';
			firma += '                                        </tr>';
			firma += '                                        <tr>';
			firma += '											<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6x1&oid=00D0Y0000033Ye1&lastMod=1528278571000" alt="Web" style="display:block;" /></td>';
			firma += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;"><a href="https://www.pak2go.com/" target="_blank">http://pak2go.com </td>';
			firma += '                                    	</tr>';
			firma += '                                    </tbody>';
			firma += '                                </table>';
			firma += '                            </td>';
			firma += '						</tr>';
			firma += '						<tr>';
			firma += '							<td style="padding:10px 0 0 5px;">';
			firma += '								<a href="https://www.facebook.com/pak2go/" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xB&oid=00D0Y0000033Ye1&lastMod=1528278603000" alt="Facebook" /></a>';
			firma += '								<a href="https://twitter.com/pak2go" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xG&oid=00D0Y0000033Ye1&lastMod=1528278629000" alt="Twitter" /></a>';
			firma += '								<a href="https://mx.linkedin.com/company/pak2go-logistics" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xL&oid=00D0Y0000033Ye1&lastMod=1528278653000" alt="LinkedIN" /></a>';
			firma += '                				<a href="http://instagram.com/pak2go2020" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xQ&oid=00D0Y0000033Ye1&lastMod=1528278683000" alt="Instagram" /></a>';
			firma += '							</td>';
			firma += '						</tr>';
			firma += '					</tbody>';
			firma += '				</table>';
			firma += '			</td>';
			firma += '		</tr>';
			firma += '	</tbody>';
			firma += '</table>';
		}
		
		load_template(); 
	}
	
	public void load_template()
	{
		cuerpo_notificacion = '';
		//asunto = '';
		
		if(optionTemplate==0)
		{
			//asunto += 'Import/Export: ' + record.Name;
			cuerpo_notificacion += plain_text;
		}
		else 
		{
			NEU_Shipment_Notifications_PDF notificaciones = new NEU_Shipment_Notifications_PDF(new ApexPages.StandardController(record));
			notificaciones.optionTemplate = optionTemplate;
			notificaciones.optionLanguage = optionLanguage;
			
			notificaciones.load_template();
			//asunto += notificaciones.asunto;
			cuerpo_notificacion += notificaciones.string_pdf;
			
			cuerpo_notificacion +=	'<table>';
			cuerpo_notificacion +=	'	<tr>';
			cuerpo_notificacion +=	'		<td style="font-family: Arial, Helvetica, sans-serif;">';
			cuerpo_notificacion +=	'			<p>&nbsp;</p>';
			cuerpo_notificacion +=	'			<p>'+Comentarios+'</p>';
			cuerpo_notificacion +=	'		</td>';
			cuerpo_notificacion +=	'	</tr>';
			cuerpo_notificacion +=	'	<tr>';
			cuerpo_notificacion +=	'		<td style="font-family: Arial, Helvetica, sans-serif;">';
			cuerpo_notificacion +=	'			<p>&nbsp;</p>';
			/*if(optionLanguage==1)
			{
				// Inglés
				cuerpo_notificacion +=	'		<p>PDF Notification Link:</p>';
			}else if(optionLanguage==2){
				// Español
				cuerpo_notificacion +=	'		<p>Enlace de notificación al documento PDF:</p>';
			}*/
			//cuerpo_notificacion +=	'			<p><a>'+link_publico+'/apex/NEU_Shipment_Notifications_PDF?id='+record.Id+'&optionTemplate='+optionTemplate+'&optionLanguage='+optionLanguage+'</a></p>';
			cuerpo_notificacion +=	'		</td>';
			cuerpo_notificacion +=	'	</tr>';
			cuerpo_notificacion +=	'	<tr>';
			cuerpo_notificacion +=	'		<td style="font-family: Arial, Helvetica, sans-serif;">';
			cuerpo_notificacion +=	'			<p>&nbsp;</p>';
			cuerpo_notificacion +=	'			<p>'+(link_one != null ? link_one : '')+'</p>';
			cuerpo_notificacion +=	'		</td>';
			cuerpo_notificacion +=	'	</tr>';
			cuerpo_notificacion +=	'	<tr>';
			cuerpo_notificacion +=	'		<td style="font-family: Arial, Helvetica, sans-serif;">';
			cuerpo_notificacion +=	'			<p>&nbsp;</p>';
			cuerpo_notificacion +=	'			<p>'+(link_two != null ? link_two : '')+'</p>';
			cuerpo_notificacion +=	'		</td>';
			cuerpo_notificacion +=	'	</tr>';
			cuerpo_notificacion +=	'</table>';
		}
		
		html_body = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body><div style="background-color: #ffffff; min-width: 720px; border: 1px solid #8a9ebe; padding: 5px;display:inline-block;">'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+firma+'</div></body></html>';
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
	
	public void send_email()
	{
		load_template();
		
		List<Contact> contacts = [select Id, Name, Email, AccountId from Contact where Email != null and AccountId =: record.Account_for__c];
		
		List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
		
		String[] receptores = new String[]{};
		String[] receptoresId = new String[]{};
		String[] receptores_usuarios = new String[]{};
		String[] receptores_usuarios_bcc = new String[]{};
		string nombre_documentos_enviados = '';
		List<Id> list_contactos = new List<id>();
		
		if(defaultCc != null && defaultCc != '' && defaultCc != '[]')
        	receptores_usuarios = defaultCc.split(';',0);
		
		if(usuarios_cc.size() > 0)
		{
			for(User u : usuarios_cc)
			{
				receptores_usuarios.add(u.Email);
			}
		}
		
		if(defaultBcc != null && defaultBcc != '' && defaultBcc != '[]'){
			receptores_usuarios_bcc = defaultBcc.split(';',0);
		}
		
		/* DUDAS DE SI HARÁ FALTA EN EL FUTURO */
		/*
		Blob body;
		PageReference pdf = Page.NEU_ShipmentOrderPDF;
		pdf.getParameters().put('id',record.Id);
		pdf.setRedirect(true);
		try 
		{
			body = pdf.getContent();
		}
		catch(VisualforceException e){body = Blob.valueOf('Some Text');} 
		
		if(Test.isRunningTest())
		{
			body = Blob.valueOf('Some Text');	
		}
		*/

		List<Messaging.EmailFileAttachment> documentos_adjuntos = new List<Messaging.EmailFileAttachment>();

		/* BEGIN: Documentos asociados */
		total_peso_ficheros =0;
		integer lugar_extension_fichero = 0;
		string nombre_ficheros_extension = '';
		string nombre_ficheros = '';

		Set<Id> documents_ids = new Set<Id>();
		Set<Id> files_ids = new Set<Id>();
		for(documents_s ad : associated_documents)
		{
			if(ad.selected)
			{
				//Documents
				if(String.isNotEmpty(ad.id_doc))
					documents_ids.add(ad.id_doc);
				//Files
				if(ad.id_file != null)
					files_ids.add(ad.id_file);
			}
		}
		List<Document> documents_list = [select Id, Name, Body, Type, DeveloperName from Document where Id IN :documents_ids];
		Map<Id, Document> mapDocuments = new Map<Id, Document>();
		for(Document dc :documents_list)
		{
			mapDocuments.put(dc.Id, dc);
		}

		List<ContentVersion> files_list = [Select Id, Title, VersionData, FileExtension from ContentVersion where Id IN :files_ids];
		Map<Id, ContentVersion> mapFiles = new Map<Id, ContentVersion>();
		for(ContentVersion cv: files_list)
		{
			mapFiles.put(cv.Id, cv);
		}

		for(documents_s ad : associated_documents)
		{
			if(ad.selected)
			{
				Blob bfile = null;
				Messaging.EmailFileAttachment eFileAttach = new Messaging.EmailFileAttachment();
				//Option Files
				if(ad.id_file != null)
				{
					ContentVersion cvFile = mapFiles.get(ad.id_file);
					bfile = cvFile.VersionData;

					String fileName = ad.Name;
					if(!fileName.contains((cvFile.FileExtension != null ? cvFile.FileExtension : '.pdf')))
						fileName = fileName + '.' + cvFile.FileExtension;

					eFileAttach.setFileName(fileName);

					if(eFileAttach.FileName.contains('.html'))
						eFileAttach.FileName = eFileAttach.FileName.replace('.html','.'+cvFile.FileExtension);

					eFileAttach.setContentType('application/'+cvFile.FileExtension);

					/*ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Document:' + eFileAttach.FileName));*/

					//if(String.isNotEmpty(ad.document_url))
					nombre_documentos_enviados += ad.Name + '('+ ad.document_url + ') \n';
				}
				else if(String.isNotEmpty(ad.id_doc))//Options Documents
				{
					Document documentAux = mapDocuments.get(ad.id_doc);
					bfile = documentAux.Body;

					if(bfile.size()>0)
					{
						nombre_documentos_enviados += ad.Name +' ('+URL.getSalesforceBaseUrl().toExternalForm() + ad.document_url+') \n';

						if(ad.Name.contains('.') == true)
							eFileAttach.setFileName(ad.name);
						else
						{
							string documento_typo = documentAux.Type;
							eFileAttach.setContentType('application/'+documento_typo);
							string name_documento_adjunto = ad.name+'.'+documentAux.Type;
							eFileAttach.setFileName(name_documento_adjunto);
						}
					}
					if(eFileAttach.FileName.contains('.html'))
						eFileAttach.FileName = eFileAttach.FileName.replace('.html','.'+documentAux.Type);
				}

				eFileAttach.setBody(bfile);
				total_peso_ficheros += bfile.size();
				documentos_adjuntos.add(eFileAttach);
			}
		}
		//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Total Size:'+total_peso_ficheros));
		if(total_peso_ficheros >= 10485760)//10MB
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Maximum limit exceeded of 10mb in attached files'));
		}
		/* END: Documentos asociados */
	
		//------------------------------
		List<Document> query_logo = [Select Id from Document where Name = 'logo_pak2go_notifications'];
		string logotipo = '';
		if(query_logo.size() > 0)
			logotipo = '<img src="'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+query_logo[0].Id+'&oid='+UserInfo.getOrganizationId()+'"/>';
		 
		List<SObject> relaciones_con_task = new List<SObject>();
		String estilo_email = '';
		estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += 'p{margin:0; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += '.user_name{font-weight:bold;}';
		
		estilo_email += '/* Client-specific Styles */';
	 	estilo_email += '#outlook a {padding:0;} /* Force Outlook to provide a "view in browser" menu link. */';
	 	estilo_email += 'body{width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0;}';
	 	estilo_email += '/* Prevent Webkit and Windows Mobile platforms from changing default font sizes, while not breaking desktop design. */';
	 	estilo_email += '.ExternalClass {width:100%;} /* Force Hotmail to display emails at full width */';
	 	estilo_email += '.ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height: 100%;} /* Force Hotmail to display normal line spacing.*/';
	 	estilo_email += 'img {outline:none; text-decoration:none;border:none; -ms-interpolation-mode:bicubic;}';
	 	estilo_email += 'a img {border:none;text-decoration:none;border:none; -ms-interpolation-mode:bicubic;}';
	 	estilo_email += 'p {margin: 0px 0px !important;}';
	 	estilo_email += 'table { border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; }';
	 	estilo_email += 'table td {border-collapse: collapse;}';
	 	estilo_email += '/*STYLES*/';
	 	estilo_email += '/*################################################*/';
	 	estilo_email += '/*IPAD STYLES*/';
	 	estilo_email += '/*################################################*/';
	 	estilo_email += '@media only screen and (max-width: 640px) {';
		estilo_email += '	 a[href^="tel"], a[href^="sms"] {';
		estilo_email += 'text-decoration:none;';
		estilo_email += 'color:#212121; /* or whatever your want */';
		estilo_email += ' pointer-events:none;';
		estilo_email += ' cursor:default;';
		estilo_email += ' }';
		estilo_email += ' .mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {';
		estilo_email += ' text-decoration:default;';
		estilo_email += ' color:#212121 !important;';
		estilo_email += ' pointer-events:auto;';
		estilo_email += ' cursor:default;';
		estilo_email += ' }';
		estilo_email += ' }';
	 	estilo_email += '/*##############################################*/';
	 	estilo_email += '/*IPHONE STYLES*/';
	 	estilo_email += '/*##############################################*/';
	 	estilo_email += '@media only screen and (max-width: 480px) {';
	 	estilo_email += '	 a[href^="tel"], a[href^="sms"] {';
		estilo_email += '	 text-decoration:none;';
		estilo_email += '	 color:#212121; /* or whatever your want */';
		estilo_email += '	 pointer-events:none;';
		estilo_email += '	 cursor:default;';
		estilo_email += '	 }';
		estilo_email += '	 .mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {';
		estilo_email += '	 text-decoration:default;';
		estilo_email += '	 color:#212121 !important; ';
		estilo_email += '	 pointer-events:auto;';
		estilo_email += '	 cursor:default;';
		estilo_email += '	 }';
	 	estilo_email += '}';
		estilo_email += '@import url(http://fonts.googleapis.com/css?family=Montserrat:400,700);';
		
		List<User> user_loged = [select Id, Name, FirstName, LastName, Department, Title, Street, Phone, MobilePhone, Email from User where Id =: UserInfo.getUserId()];
		String firmaEmail = '';
		if(user_loged.size() > 0)
		{
			firmaEmail += '<br/><hr/><br/><table width="640" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">';
			firmaEmail += '	<tbody>';
			firmaEmail += '		<tr>';
			firmaEmail += '			<td width="90" valign="top" align="left" style="padding:0 20px 0 0;">';
			firmaEmail += '            	<table width="100%" border="0" cellspacing="0" cellpadding="0">';
			firmaEmail += '                	<tr>';
			firmaEmail += '                        <td valign="middle" align="center" style="width:90px; height:90px;">';
			firmaEmail += '                            <img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wh&oid=00D0Y0000033Ye1&lastMod=1528278379000" alt="Logo" style="display:block; border:none;" />';
			firmaEmail += '                        </td>';
			firmaEmail += '                	</tr>';
			firmaEmail += '                </table>';
			firmaEmail += '            </td>';
			firmaEmail += '			<td width="562" valign="top" align="left">';
			firmaEmail += '				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">';
			firmaEmail += '					<tbody>';
			firmaEmail += '						<tr>';
			firmaEmail += '							<td style="font-family:\'Montserrat\', sans-serif, Arial; font-size:16px; line-height:24px; font-weight:700; color:212121; padding:0 0 0 10px; letter-spacing:2px; text-transform:uppercase;">'+(user_loged[0].FirstName != null ? user_loged[0].FirstName : '') +' '+user_loged[0].LastName+'</td>';
			firmaEmail += '						</tr>';
			firmaEmail += '						<tr>';
			firmaEmail += '							<td style="font-family:\'Montserrat\', sans-serif, Arial; font-size:10px; line-height:14px; font-weight:400; color:#212121; padding:0 0 0 10px; letter-spacing:1px; text-transform:uppercase;">'+(user_loged[0].Title != null ? user_loged[0].Title : '')+'</td>';
			firmaEmail += '						</tr>';
			firmaEmail += '                        <tr>';
			firmaEmail += '							<td style="padding:15px 0 10px 10px;"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xk&oid=00D0Y0000033Ye1&lastMod=1528278950000" alt="" /></td>';
			firmaEmail += '						</tr>';
			firmaEmail += '						<tr>';
			firmaEmail += '							<td align="left" style="padding:5px 0 10px 10px;">';
			firmaEmail += '                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">';
			firmaEmail += '                                    <tbody>';
			firmaEmail += '                                        <tr>';	
			firmaEmail += '                                			<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wm&oid=00D0Y0000033Ye1&lastMod=1528278437000" alt="Map" style="display:block;" /></td>';
			firmaEmail += '                                            <td width="93%" height="35" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:700; color:#212121; letter-spacing:1px;">'+(user_loged[0].Street != null ? user_loged[0].Street : '')+'</td>';
			firmaEmail += '                                        </tr>';
			firmaEmail += '                                        <tr>';   
			firmaEmail += '                                			<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wr&oid=00D0Y0000033Ye1&lastMod=1528278477000" alt="Phone" style="display:block;" /></td>';
			firmaEmail += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;">'+(user_loged[0].Phone != null ? user_loged[0].Phone : '')+'</td>';
			firmaEmail += '                                        </tr>';
			firmaEmail += '                                        <tr>';   
			firmaEmail += '                                			<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6wr&oid=00D0Y0000033Ye1&lastMod=1528278477000" alt="Phone" style="display:block;" /></td>';
			firmaEmail += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;">'+(user_loged[0].MobilePhone != null ? user_loged[0].MobilePhone : '')+' Celular</td>';
			firmaEmail += '                                        </tr>';                                        
			firmaEmail += '                                        <tr>';
			firmaEmail += '											<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6ww&oid=00D0Y0000033Ye1&lastMod=1528278510000" alt="Email" style="display:block;" /></td>';
			firmaEmail += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;">'+(user_loged[0].Email != null ? user_loged[0].Email : '')+'</td>';
			firmaEmail += '                                        </tr>';
			firmaEmail += '                                        <tr>';
			firmaEmail += '											<td width="7%" height="35" align="left" valign="middle"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6x1&oid=00D0Y0000033Ye1&lastMod=1528278571000" alt="Web" style="display:block;" /></td>';
			firmaEmail += '                                            <td width="93%" height="35" align="left" valign="middle" style="font-family:\'Montserrat\', sans-serif, Arial; font-size:12px; line-height:24px; font-weight:400; color:#212121; letter-spacing:1px;"><a href="https://www.pak2go.com/" target="_blank">http://pak2go.com </td>';
			firmaEmail += '                                    	</tr>';
			firmaEmail += '                                    </tbody>';
			firmaEmail += '                                </table>';
			firmaEmail += '                            </td>';
			firmaEmail += '						</tr>';
			firmaEmail += '						<tr>';
			firmaEmail += '							<td style="padding:10px 0 0 5px;">';
			firmaEmail += '								<a href="https://www.facebook.com/pak2go/" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xB&oid=00D0Y0000033Ye1&lastMod=1528278603000" alt="Facebook" /></a>';
			firmaEmail += '								<a href="https://twitter.com/pak2go" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xG&oid=00D0Y0000033Ye1&lastMod=1528278629000" alt="Twitter" /></a>';
			firmaEmail += '								<a href="https://mx.linkedin.com/company/pak2go-logistics" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xL&oid=00D0Y0000033Ye1&lastMod=1528278653000" alt="LinkedIN" /></a>';
			firmaEmail += '                				<a href="http://instagram.com/pak2go2020" target="_blank"><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a6xQ&oid=00D0Y0000033Ye1&lastMod=1528278683000" alt="Instagram" /></a>';
			firmaEmail += '							</td>';
			firmaEmail += '						</tr>';
			firmaEmail += '					</tbody>';
			firmaEmail += '				</table>';
			firmaEmail += '			</td>';
			firmaEmail += '		</tr>';
			firmaEmail += '	</tbody>';
			firmaEmail += '</table>';
		}
		boolean hay_envio = false;
		String contactos = '';
		String cuerpo_notificacion_form = cuerpo_notificacion;
	
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
						mail.setBccAddresses(receptores_usuarios_bcc);
					}
					mail.setSenderDisplayName('PAK2GO');
					mail.setSubject(asunto);
					mail.setUseSignature(false); 
					mail.setCharset('UTF-8');
					mail.setHtmlBody(html_body);
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
			mail.setToAddresses(receptores_usuarios);
			mail.setSenderDisplayName('PAK2GO');
			mail.setSubject(asunto);
			mail.setUseSignature(false); 
			mail.setCharset('UTF-8');
			if(receptores_usuarios_bcc.size()>0){
				mail.setBccAddresses(receptores_usuarios_bcc);
			}			
			// Con firma de usuario
			// mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+'<br/>'+firmaEmail+'</body></html>');
			// Sin firma de usuario
			mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+firmaEmail+'</body></html>');
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
	
		/* BEGIN: Crear las tareas una vez enviado el email */
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
						new_task_account.Subject =subject_task;//'Shipment Order';
						new_task_account.Status = Status_task;
						new_task_account.Type = 'Email';
						new_task_account.OwnerId = OwnerId_task;
						new_task_account.WhatId = record.Id;
						if(!NEU_TaskUtils.withTaskRelation())
							new_task_account.WhoId = receptoresId[0];
						new_task_account.Send_Emails__c = true;
						new_task_account.Priority = priority_task;
						//new_task_account.WhoId = receptoresId[0];
						// new_task_account.TaskWhoRelations = list_contactos;
						//new_task_account.TaskWhoIds = list_contactos;
			
						string descripcion_email = (cuerpo_notificacion != null ? cuerpo_notificacion + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
						new_task_account.Description = descripcion_email;//(descripcion_email != null ? (descripcion_email.length() < 255 ? descripcion_email : descripcion_email.substring(0,255)) :'');
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
				string descripcion_email = (cuerpo_notificacion != null ? cuerpo_notificacion + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
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
		/* END: Crear las tareas una vez enviado el email */	
	}
	
	public PageReference return_shipment()
	{
		PageReference pgReturnPage;
		String returnUrl = '/' + record.Id;
		pgReturnPage = new PageReference(returnUrl);
		pgReturnPage.setRedirect(true);
		return pgReturnPage;
	}
}