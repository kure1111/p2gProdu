public with sharing class NEU_DO_save_pdf
{
	public Customer_Quote__c record;
	public string language {get;set;}
	public Customer_Quote__c new_ie{get;set;}
	public Boolean enabled{get;set;}
	public string url_pdf {get;set;}
	public Document documento_asociado
	{
		get
			{
				if (documento_asociado == null)
					documento_asociado = new Document();
				return documento_asociado;
			}
		set;
	}

	ApexPages.StandardController con;

	public NEU_DO_save_pdf(ApexPages.StandardController stdController)
		{

			con = stdController;

			try {
				record = [select Id, Name, Freight_Mode__c, B_L_Status__c, Account_for__c, Account_for__r.Id, Account_for__r.Name, Contact__c, Consignee__c,
						Consignee_Contact__c, POD_incoterm__c,DO_Contact_1_Shipment_Pickup__c,
						DO_Contact_1_Release_to_Company__c, DO_Release_to_Company__c, DO_Release_Date__c,
						DO_Release_Valid_To__c, DO_Remarks__c, DO_Remarks_Shipment_Pickup__c, DO_Shipment_Pickup__c
						from Customer_Quote__c where id =: con.getRecord().id limit 1 for update];
			} catch( Exception ee) {
				record = new Customer_Quote__c();
			}

			new_ie = new Customer_Quote__c();
			//Id Release To company == > The first time will always be empty, but if the document is edited a second time, the app get the specific fields
			if(!String.isEmpty(record.DO_Release_to_Company__c))
			{
				new_ie.Account_for__c = record.DO_Release_to_Company__c;

				//Id Contact 1 Release To company
				if(!String.isEmpty(record.DO_Contact_1_Release_to_Company__c))
					new_ie.Contact__c = record.DO_Contact_1_Release_to_Company__c;
			}
			else
			{
				//If the document does not yet exist, the data for the IE account is obtained
				new_ie.Account_for__c = record.Account_for__c;
				new_ie.Contact__c = record.Contact__c;
			}

			//Shipment Pickup Account
			if(!String.isEmpty(record.DO_Shipment_Pickup__c))
			{
				new_ie.Consignee__c = record.DO_Shipment_Pickup__c;

				//Id Contact 1 Shipment Pickup Account
				if(!String.isEmpty(record.DO_Contact_1_Shipment_Pickup__c))
					new_ie.Consignee_Contact__c = record.DO_Contact_1_Shipment_Pickup__c;

			}
			/*else
			{
				new_ie.Consignee__c = record.Consignee__c;
				new_ie.Consignee_Contact__c = record.Consignee_Contact__c;
			}*/

			//Release Date
			if(record.DO_Release_Date__c != null)
				new_ie.DO_Release_Date__c = record.DO_Release_Date__c;
			else
				new_ie.DO_Release_Date__c = system.today();
			//Valid To
			if(record.DO_Release_Valid_To__c != null)
				new_ie.DO_Release_Valid_To__c = record.DO_Release_Valid_To__c;
			else
				new_ie.DO_Release_Valid_To__c = system.today().adddays(3);
			/*Required Fields for Temporal Import/Export*/
			//Release Date
			new_ie.Last_Shipment_Delivery_Date__c = system.today();
			//Release Valid To
			new_ie.Valid_From__c = system.today().adddays(3);

			//Remarks For Goods
			if(!String.isEmpty(record.DO_Remarks__c))
				new_ie.DO_Remarks__c = record.DO_Remarks__c;
			//Remarks for Shipment Pick up
			if(!String.isEmpty(record.DO_Remarks_Shipment_Pickup__c))
				new_ie.DO_Remarks_Shipment_Pickup__c = record.DO_Remarks_Shipment_Pickup__c;

			//Comments future

			//Conditions for enabled Delivery Order
			enabled = true;
			if(record.Freight_Mode__c == 'Sea')
			{
				if(record.B_L_Status__c == null || record.B_L_Status__c == 'Original')
				{
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Needed Bill\'s of Lading (B/L Status) in Import/Export: '+record.Name));
					enabled = false;
				}
			}
			if(enabled)
			{
				generarURL_pdf();
			}
		}

	public void generarURL_pdf()
		{
			if(new_ie != null)
			{
				url_pdf = '';
				url_pdf += 'id=' + record.Id;
				url_pdf += '&id_rc=' +(new_ie.Account_for__c != null ? neu_utils.safestring(new_ie.Account_for__c) : '');
				url_pdf += '&id_rc_c1='+ (new_ie.Contact__c != null ? neu_utils.safestring(new_ie.Contact__c) : '');
				url_pdf += '&id_fd='+ (new_ie.Consignee__c != null ? neu_utils.safestring(new_ie.Consignee__c) : '');
				url_pdf += '&id_fd_c1='+ (new_ie.Consignee_Contact__c != null ? neu_utils.safestring(new_ie.Consignee_Contact__c) : '');
				url_pdf += '&remarks='+ (new_ie.DO_Remarks__c != null ? neu_utils.safestring(new_ie.DO_Remarks__c) : '');
				url_pdf += '&release_date='+new_ie.DO_Release_Date__c.format();
				url_pdf += '&release_valid='+new_ie.DO_Release_Valid_To__c.format();
				url_pdf += '&shipment_pick_up='+ (new_ie.DO_Remarks_Shipment_Pickup__c != null ? neu_utils.safestring(new_ie.DO_Remarks_Shipment_Pickup__c) : '');
			}
		}

	public string date_release {get;set;}
	public string date_valid_to {get;set;}

	public void generar_pdf()
		{
			//Release To Company previuosly Account For Import/Export
			List<Account> query_accountRelease = [select Id, Name from Account where Id=:new_ie.Account_for__c];
			if(query_accountRelease != null & query_accountRelease.size()>0)
			{
				//Check contacts
				List<Contact> query_contactRTC1 = [Select Id, Name from Contact where AccountId  =: new_ie.Account_for__c and Id =: new_ie.Contact__c];
				if(query_contactRTC1 == null || query_contactRTC1.size()==0)
					new_ie.Contact__c = null;
			}
			else
			{
				new_ie.Contact__c = null;

			}
			//Shipment Pickup Account previuosly FInal Delivery Account
			List<Account> query_accountFinal = [select Id, Name from Account where Id=:new_ie.Consignee__c];
			if(query_accountFinal != null & query_accountFinal.size()>0)
			{
				//Check contacts
				List<Contact> query_contactSP1 = [Select Id, Name from Contact where AccountId  =: new_ie.Consignee__c and Id =: new_ie.Consignee_Contact__c];
				if(query_contactSP1 == null || query_contactSP1.size()==0)
					new_ie.Consignee_Contact__c = null;

			}
			else
			{
				new_ie.Consignee_Contact__c = null;
			}

			//Reload pdf url
			generarURL_pdf();
		}

	public PageReference return_page()
		{
			return con.view();
		}

	public PageReference crear()
		{
			//Checks Required Fields
			Boolean error = false;
			if(new_ie.DO_Release_Date__c == null)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You must choose "Release Date"'));
				error = true;
			}
			if(new_ie.DO_Release_Valid_To__c == null)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You must choose "Release Valid To"'));
				error = true;
			}
			if(!error && Date.valueOf(new_ie.DO_Release_Date__c) >  new_ie.DO_Release_Valid_To__c)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Release Date must be greater than Release Valid To'));
				error = true;
			}
			if(error)
				return null;

			PageReference pdf = null;
			pdf = Page.NEU_DO_pdf;
			pdf.getParameters().put('id',record.Id);
			pdf.getParameters().put('id_rc',new_ie.Account_for__c);
			pdf.getParameters().put('id_rc_c1',new_ie.Contact__c);
			pdf.getParameters().put('id_fd',new_ie.Consignee__c);
			pdf.getParameters().put('id_fd_c1',new_ie.Consignee_Contact__c);
			pdf.getParameters().put('remarks',new_ie.DO_Remarks__c);
			pdf.getParameters().put('release_date',new_ie.DO_Release_Date__c.format());
			pdf.getParameters().put('release_valid',new_ie.DO_Release_Valid_To__c.format());
			pdf.getParameters().put('shipment_pick_up',new_ie.DO_Remarks_Shipment_Pickup__c);
			Blob body;

			try
			{
				body = pdf.getContent();
			}
			catch (VisualforceException e) { body = Blob.valueOf('Some Text');}
			String nameDocument = 'DO '+record.name +'.pdf';
			List<Folder> directorio = new List<Folder>();
			directorio = [Select Id, Name from Folder where Name =:'DO'];
			documento_asociado.Body = body;
			documento_asociado.Name = nameDocument;
			documento_asociado.AuthorId = UserInfo.getUserId();
			if(directorio.size()>0)
				documento_asociado.FolderId = directorio[0].Id;
			documento_asociado.IsPublic = true;

			//Update Fields in the Import/Export
			record.DO_Release_to_Company__c = new_ie.Account_for__c;
			record.DO_Contact_1_Release_to_Company__c = new_ie.Contact__c;
			record.DO_Shipment_Pickup__c = new_ie.Consignee__c;
			record.DO_Contact_1_Shipment_Pickup__c = new_ie.Consignee_Contact__c;
			record.DO_Release_Date__c = new_ie.DO_Release_Date__c;
			record.DO_Release_Valid_To__c = new_ie.DO_Release_Valid_To__c;
			record.DO_Remarks__c = new_ie.DO_Remarks__c;
			record.DO_Remarks_Shipment_Pickup__c = new_ie.DO_Remarks_Shipment_Pickup__c;
			try
			{
				update record;
			}catch (DMLException e)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error to Save Information in IE.'));
				return null;
			}

			//Delete Document if exists before
			List<Document> documents_old = [Select Id, Name from Document where Name = :nameDocument];
			try
			{
				delete documents_old;
			}catch (Exception e)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failed to delete old document'));
			}

			//Delete Associated Documents
			List<Associated_Document__c> asociated_documents_old = [Select Id, Name from Associated_Document__c where Name = :nameDocument];
			try
			{
				delete asociated_documents_old;
			}catch (DMLException e)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failed to delete associated document.'));
			}

			//Create New Document
			try
			{
				if(documento_asociado.Name != '' && documento_asociado.Name != null)
					insert documento_asociado;
			}
			catch (DMLException e)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
			}

			Associated_Document__c new_document = new Associated_Document__c();
			new_document.Account__c = record.Account_for__c;
			new_document.Name = nameDocument;
			new_document.Document_Type__c = 'DO';
			new_document.Import_Export_Quote__c =record.Id;


			new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId();

			//Create Associated Document
			try
			{
				insert new_document;
				return new PageReference('/'+record.Id);
			}
			catch(Exception ex){return null;}


		}
}