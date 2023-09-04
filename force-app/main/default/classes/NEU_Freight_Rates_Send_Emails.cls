public with sharing class NEU_Freight_Rates_Send_Emails 
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
	public List<group_s> grupos_seleccionados {get;set;}
	public string label_object2{get;set;}
	public String user_list {get;set;}
	public string label_object{get;set;}
	public string texto_email {get;set;}
	public String id_usuario {get;set;}
	public String id_cuenta_seleccionada {get;set;}
	public String name_grupo_seleccionado {get;set;}
	public List<EmailTemplate> templates {get;set;}
	public String id_template {get;set;}
	public boolean with_signature {get;set;}

	public List<User> users_cc {get; set;}{
	users_cc = new List<User>();
}

	public string defaultTo {get;set;}
	{
		defaultTo = '';
	}

	public Customer_Quote__c buscador {get;set;}
	{
		if(buscador == null)
			buscador = new Customer_Quote__c();
	}

	public String userid='';
	public String getuserid()
		{
			userid =Userinfo.getUserId();
			return userid;
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

	public class group_s
	{
		public string Name {get;set;}
		public List<cuenta_s> accounts {get;set;}
		public Integer NumberContacts {get;set;}
		public Boolean selected {get;set;}

		public group_s(String name, List<cuenta_s> accounts, Integer NumberContacts, Boolean selected)
			{
				this.name = name;
				this.accounts = accounts;
				this.NumberContacts = NumberContacts;
				this.selected = selected;
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

	public boolean texto_plano = false;

	public String filterGroupEmail {get;set;}

	public List<SelectOption>filterGroupEmailList
	{
		get
			{
				if(filterGroupEmailList==null)
				{
					filterGroupEmailList=new List<SelectOption>();
					String none = 'None';
					filterGroupEmailList.add(new SelectOption(none,none));
					try{

						List<string> pickListSimple = NEU_Utils.getPicklistSimple('Contact', 'E_Mail_Rates_Group__c');
						for(String pv : pickListSimple)
							{
								filterGroupEmailList.add(new SelectOption(pv,pv));
							}
					}catch(Exception e)
					{
						ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failed to get contact groups.'));
					}
				}

				return filterGroupEmailList;
			}
		set
			{
				if(filterGroupEmailList!=value)
					filterGroupEmailList=value;
			}
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
						from Associated_Document__c where Document_Type__c = 'Price List' and Account__c =: object_id order by CreatedDate desc limit 50];
				subject_task ='Account: ';
				name_object = [select Id, Name from Account where id =: object_id];
				List<Account> listado_cuentas = [select Id, Name from Account  where id =: object_id];
				clientes_seleccionados = new List<cuenta_s>();
				if(listado_cuentas.size()>0)
					addaccount(listado_cuentas[0],listado_cuentas[0].Id,'Account');
			}
			//-----------------------------------


			List<documents_s> docs = new List<documents_s>();
			//------
			Status_task = 'Completed';
			priority_task = 'Normal';
			texto_email = '';
			label_object2 = '';
			create_task = true;
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
					Boolean selected = false;
					String id_doc = '';
					String document_selected = '';
					if (!Test.isRunningTest())
						if(ad.Document_URL__c != null && ad.Document_URL__c != '')
						{
							if(ad.Document_URL__c.contains('file='))
							{
								id_doc = ad.Document_URL__c.substringBetween('?file=','&oid=');
							}else{
								id_doc = ad.Document_URL__c.substringBetween('?id=','&oid=');
							}

							if(ApexPages.currentPage().getParameters().get('document_id') != null)
								document_selected = ApexPages.currentPage().getParameters().get('document_id');

							//system.debug('ad.Id: '+ad.Id+' document_selected: '+document_selected);

							if(String.isNotEmpty(document_selected) && ad.Id == document_selected)
								selected = true;

							docs.add(new documents_s(selected, ad.Name, ad.Document_Description__c, ad.Document_Reference__c, ad.Document_Type__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), id_doc,0,'0'));
							Id_cuenta += ad.Account__c+',';
						}
				}

			if(Id_cuenta != null)
			{
				Id_cuenta_array = Id_cuenta.split(',',0);
			}

			if (!Test.isRunningTest())
			{
				Set<Id> documents_ids = new Set<Id>();
				for(documents_s ad : docs)
					{
						if(ad.id_doc != null)
						{
							documents_ids.add(ad.id_doc);
						}
					}
				List<Document> documents_list = [select Id, Name, Body from Document where Id =: documents_ids];
				Map<Id, Document> mapDocuments = new Map<Id, Document>();
				for(Document dc :documents_list)
					{
						mapDocuments.put(dc.Id, dc);
					}

				for(documents_s ad : docs)
					{
						if(ad.id_doc != null)
						{
							Document d = mapDocuments.get(ad.id_doc);

							Blob b = d.Body;
							ad.espacio = b.size();
							if(b.size()> 5242880)
								ad.porespacio = '100';
							else
								ad.porespacio = string.valueof(b.size()*100/5242880);
						}
					}
			}
			associated_documents = docs;

			return null;
		}

	public PageReference return_page()
		{
			PageReference pgReturnPage;
			String returnUrl = '/' + id_object;
			pgReturnPage = new PageReference(returnUrl);
			pgReturnPage.setRedirect(true);
			return pgReturnPage;
		}

	public void put_template()
		{
			if(associated_documents != null && associated_documents.size()>0)
			{
				texto_plano = false;
				subject = '';
				subject +='NEW RATES ';

				Integer contador = 0;
				for(documents_s doc: associated_documents)
					{
						if(doc.selected && doc.document_description.equals('Price List'))
						{
							subject += doc.Name.replace('.pdf', '') + ', ';
							contador ++;
						}
					}
				subject = subject.substring(0, subject.length()-2);

				//Without Associated Documents
				if(contador==0)
				{
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You must select "Associated Documents" for Price List Type.'));
					subject = '';
					texto_email = '';
					return;
				}

				texto_email = '';
				texto_email +='Dear Customer, \n\n';

				texto_email +='We are pleased to provide you with our LCL Import Rates.\n';
				texto_email +='We reserve the right to adjust our rates immediately in case carriers are applying the same \n\n';

				texto_email +='Thank you for your support and do not hesitate to contact us in any case.\n\n';

				//---falta poner la firma
				User query_user = [select Id, Name,Title, MobilePhone , CompanyName, Phone, Email, Street, City, PostalCode, State, Country from User where Id =: UserInfo.getUserId()];
				texto_email +='Best regards, \n';
				texto_email +=''+query_user.Name+'\n';
				texto_email +=''+(query_user.Title != null ? query_user.Title : '')+'\n';
				texto_email +='Mob.: '+(query_user.MobilePhone != null ? query_user.MobilePhone : '')+'\n';
				texto_email +='E-mail: '+(query_user.Email != null ? query_user.Email : '')+'\n';
				with_signature = true;
			}
		}


	public void send_email()
		{
			List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();

			String[] receptores = new String[]{};
			String[] receptoresId = new String[]{};
			String[] receptores_usuarios = new String[]{};
			String[] receptores_sueltos = new String[]{};
			string nombre_documentos_enviados = '';
			List<Id> list_contactos = new List<id>();
			//Email Administración
			if(user_list != null && user_list != '' && user_list != '[]')
				receptores_usuarios = user_list.split(',',0);

			//Default To: Optional (Free)
			if(defaultTo != null && defaultTo != '' && defaultTo!= '[]')
				receptores_sueltos = defaultTo.split(';',0);

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

			List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo_email'];
			List<SObject> relaciones_con_task = new List<SObject>();
			String estilo_email = '';
			estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
			estilo_email += 'p{margin:0; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
			estilo_email += '.user_name{font-weight:bold;}';

			List<User> user_loged = [select Id, Name, FirstName, LastName, Department, Title, Street, Phone,MobilePhone, Email
					from User where Id =: UserInfo.getUserId()];
			String firma = '';

			if(with_signature == true)
			{
				CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
				if(sr == null)
				{
					sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
					if(sr == null)
						sr = CSH_Supplier_Request__c.getOrgDefaults();
				}
				String defaultUrl=null;
				if(sr!=null)
				{
					defaultUrl=sr.Default_External_URL__c;
				}

				List<StaticResource> query_logo2 = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'logo_twitter'];

				//firma += '<a href="https://twitter.com/bclineeu" style="    width: 100%;"><img src="'+defaultUrl+'/resource/'+ query_logo2[0].SystemModStamp.getTime() + '/'+ (query_logo2[0].NamespacePrefix != null && query_logo2[0].NamespacePrefix!= '' ? query_logo2[0].NamespacePrefix+ '__' : '')+ 'logo_twitter" class="company_logo" /></a>';
				firma += '</br><br>';
				firma += '</br><br>';
				//firma += '<img style="margin-top: 10px;" src="'+defaultUrl+'/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo_email" class="company_logo"/>';
			}

			boolean hay_envio = false;
			String contactos = '';

			String texto_email_form = texto_email;
			//Simple Account
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
							mail.setSubject(subject);
							mail.setBccSender(false);
							mail.setUseSignature(false);
							mail.setCharset('UTF-8');
							if(texto_plano == true)
								mail.setPlainTextBody((texto_email != null ? texto_email : ''));
							else
								mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
							theEmails.add(mail);

							receptores.clear();
							list_contactos = new List<id>();
							receptoresId.clear();
							contactos = '';

							hay_envio = true;
						}
					}
			}
			//Groups
			if(grupos_seleccionados != null)
			{
				for(group_s g : grupos_seleccionados)
					{
						if(g.selected)
						{
							for(cuenta_s c : g.accounts)
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
										mail.setSubject(subject);
										mail.setBccSender(false);
										mail.setUseSignature(false);
										mail.setCharset('UTF-8');
										if(texto_plano == true)
											mail.setPlainTextBody((texto_email != null ? texto_email : ''));
										else
											mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
										theEmails.add(mail);

										receptores.clear();
										list_contactos = new List<id>();
										receptoresId.clear();
										contactos = '';

										hay_envio = true;
									}
								}

						}
					}
			}
			//Receptores sueltos con ';'
			if((receptores_sueltos != null && receptores_sueltos.size()>0) || (!hay_envio && receptores_usuarios != null && receptores_usuarios.size()>0))
			{
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setFileAttachments(documentos_adjuntos);
				mail.setToAddresses(receptores_sueltos);
				mail.setCcAddresses(receptores_usuarios);
				mail.setSenderDisplayName((user_loged.size() > 0 ?  (user_loged[0].FirstName != null ? user_loged[0].FirstName : '')+' '+user_loged[0].LastName : 'Grupo ED'));
				mail.setSubject(subject);
				mail.setBccSender(false);
				mail.setUseSignature(false);
				mail.setCharset('UTF-8');
				if(texto_plano == true)
					mail.setPlainTextBody((texto_email != null ? texto_email : ''));
				else
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

			//Crear tareas a los contactos del grupo una vez creado el Mail
			if(grupos_seleccionados != null)
			{
				for(group_s g : grupos_seleccionados)
					{
						if(g.selected)
						{
							for(cuenta_s c : g.accounts)
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
													}
												}
											}
									}

									if(receptores.size()>0)
									{
										if(create_task == true)
										{
											//TAREA GROUPS
											Task new_task_account = new Task();
											new_task_account.ActivityDate = Due_Date_task.Conversion_Rate_Date__c;
											new_task_account.Subject =subject_task;
											new_task_account.Status = Status_task;
											new_task_account.Type = 'Email';
											new_task_account.OwnerId = OwnerId_task;
											new_task_account.WhatId = id_object;
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



	public void addAccountLista()
		{
			if(String.isNotEmpty(buscador.Account_for__c))
			{
				List<Account> accounts = new List<Account>();
				if(buscador.Account_for__c != null)
				{
					String consulta = '';
					consulta += 'SELECT Id, Name, Type';
					consulta += ' FROM Account WHERE Id = \''+buscador.Account_for__c+'\'';
					accounts = Database.query(consulta);
				}

				Boolean exists = false;
				if(accounts != null && accounts.size()>0)
				{
					if(clientes_seleccionados != null && clientes_seleccionados.size()>0)
					{
						for(cuenta_s c: clientes_seleccionados)
							{
								if(c.cuenta.Id.equals(String.valueof(accounts[0].Id)))
								{
									exists = true;
								}
								if(exists)
									break;
							}
					}
				}

				if(exists)
				{
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The customer has already been been added.'));
					return;
				}else
				{
					addAccount(accounts[0], accounts[0].Id, accounts[0].Type);
				}
			}else
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Must choose some Customer.'));
				return;
			}
		}

	public void addGroupLista()
		{
			List<Contact> contactos = new List<Contact>();
			if(filterGroupEmail != 'None')
			{
				String consulta = '';
				consulta += 'SELECT Id, Name, Email, AccountId, E_Mail_Rates_Group__c, Account.Name, Account.Id';
				consulta += ' FROM Contact WHERE E_Mail_Rates_Group__c INCLUDES (:filterGroupEmail)';
				consulta += ' order by AccountId';
				contactos = Database.query(consulta);
			}
			else
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please, You must choose a group.'));
				return;
			}

			if(contactos != null && contactos.size()>0)
			{
				if(grupos_seleccionados == null)
				{
					grupos_seleccionados = new List<group_s>();
				}
				else
				{
					if(grupos_seleccionados.size()>0)//Check groups
					{
						for(group_s g : grupos_seleccionados)
							{
								if(g.Name.equals(filterGroupEmail))
								{
									ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The group has already been added.'));
									return;
								}
							}
					}
				}

				List<cuenta_s> accounts_group = new List<cuenta_s>();
				Id myAccount = null;
				Integer number_contacts = 0;
				List<contacto_s> contacts_custom = null;
				cuenta_s miCuenta = null;
				for(Contact c :contactos)
					{
						if(c.AccountId != myAccount)
						{
							contacts_custom = new List<contacto_s>();

							miCuenta = new cuenta_s(c.Account, contacts_custom, 'Account');

							accounts_group.add(miCuenta);

							myAccount = c.AccountId;
						}

						contacts_custom.add(new contacto_s(c,true, c.Email));
						number_contacts++;
					}
				//Add new group
				grupos_seleccionados.add(new group_s(filterGroupEmail, accounts_group, number_contacts, true));

			}
			else
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Group does not contain contacts.'));
			}
		}

	private void addaccount(Account myaccount,Id myId, string tipo)
		{
			cuenta_s new_account = new cuenta_s(myaccount,null,'');

			List<Contact> contactos_cuenta = [select Id, Name, Email, AccountId from Contact where AccountId =: myId];// and Email != null
			List<contacto_s> contactos = new List<contacto_s>();
			for(Contact c : contactos_cuenta)
				{
					contactos.add(new contacto_s(c,true, (c.Email != null ? ' ('+c.Email+')' : ''  )));
				}
			new_account.typo_cuenta = tipo;
			new_account.contactos = contactos;

			clientes_seleccionados.add(new_account);
		}


	public void load_template()
		{
			EmailTemplate template_selected = [select Id, Name, Body from EmailTemplate where Id =: id_template];
			if(template_selected != null)
				texto_email = template_selected.Body;
		}

}