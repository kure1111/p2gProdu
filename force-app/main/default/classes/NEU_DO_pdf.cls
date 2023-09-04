public with sharing class NEU_DO_pdf {



	public Customer_Quote__c record;
	public String string_pdf {get;set;}
	ApexPages.StandardController con;

	public NEU_DO_pdf(ApexPages.StandardController stdController) {

		con = stdController;

		try {
			record = [select Id, Name, Account_for__c,
					Account_for__r.Phone, Account_for__r.BillingStreet, Freight_Mode__c, Total_Weight_Kg2__c, Total_Volume_m3_2__c,
					Account_for__r.BillingCity, Account_for__r.BillingState,Customer_Reference__c,Account_for__r.NEU_Email__c, Site_of_Load__c, Consignee__c, Consignee__r.Name, Site_of_Load__r.Name,
					Country_ofDischarge__c, Country_ofDischarge__r.Name, POL_incoterm__c , Office__c, Valid_From__c, Supplier_Account__c , Supplier_Account__r.name, Valid_Until__c,Account_Destination_Address__r.Address__c, Account_Origin_Address__r.Address__c, POD_incoterm__c, Origin_Address__c, Site_of_Discharge__c, Site_of_Discharge__r.Name,
					B_L_Status__c, Contact__r.Email, Account_for_Billing_Address__c , Total_Items_Units__c , Account_for__r.Swift_Number__c,
					Account_for__r.BillingCountry ,Account_for__r.Name, Destination_Address__c, Account_Origin_Address__c,
					Contact__r.Name, SUM_Sell_Origin_Amount__c
					from Customer_Quote__c where id =: con.getRecord().id limit 1 for update];
		} catch( Exception ee) {
			record = new Customer_Quote__c();
		}

		StaticResource query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo'];

		string_pdf ='';
		User query_user = [select Id, Name, CompanyName, Phone, Email, Street,City,PostalCode,State,Country from User where Id =: UserInfo.getUserId() limit 1];
		Organization query_company = [select Id, Name,Street, City, State, Country,PostalCode from Organization];

		Account releaseCompany = null;
		Account shipper = null;
		Account consignee = null;
		Account finalDelivery = null;//At the moment isn't necesary

		String id_rc = neu_utils.safeString(ApexPages.currentPage().getParameters().get('id_rc'));//Id Release Company
		String id_rc_c1 = neu_utils.safeString(ApexPages.currentPage().getParameters().get('id_rc_c1'));//Id Contact 1 Release Company
		String id_fd = neu_utils.safeString(ApexPages.currentPage().getParameters().get('id_fd'));//Id Final Delivery Account
		String id_fd_c1 = neu_utils.safeString(ApexPages.currentPage().getParameters().get('id_fd_c1'));//Id Contact 1 Final Delivery Account
		//String id_wh = neu_utils.safeString(ApexPages.currentPage().getParameters().get('id_wh'));//Id Warehouse Final Delivery Account


		List<Account> query_rc = [Select Id, Name, TAX_ID__c, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry from Account where Id =: id_rc];
		if(query_rc != null && query_rc.size()>0)
			releaseCompany = query_rc[0];

		List<Account> query_sh = [Select Id, Name, TAX_ID__c, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry from Account where Id =: record.Supplier_Account__c];
		if(query_sh != null && query_sh.size()>0)
			shipper = query_sh[0];

		List<Account> query_cg = [Select Id, Name, TAX_ID__c, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry from Account where Id =: record.Consignee__c];
		if(query_cg != null && query_cg.size()>0)
			consignee = query_cg[0];


		Contact contact1= null;
		Contact contact2 = null;
		Contact contact3 = null;
		Contact finalDeliveryContact1 = null;
		Contact finalDeliveryContact2 = null;
		Contact finalDeliveryContact3 = null;
		Warehouse__c warehouseDAP = null;
		Country__c warehouseCountry  = null;
		Location__c warehouseLocation = null;

		//Release To company's Contact
		List<Contact> query_contact1 = [Select Id, Name, Email, MobilePhone, Phone, Fax from Contact where Id =: id_rc_c1];
		if(query_contact1 != null && query_contact1.size()>0)
			contact1 = query_contact1[0];


		//Final Delivery Account Contacts
		List<Account> query_fdc = [Select Id, Name, TAX_ID__c, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry from Account where Id =: id_fd];
		if(query_fdc != null && query_fdc.size()>0)
			finalDelivery = query_fdc[0];
		List<Contact> query_fda1 = [Select Id, Name, Email, MobilePhone, Phone, Fax from Contact where Id =: id_fd_c1];
		if(query_fda1 != null && query_fda1.size()>0)
			finalDeliveryContact1 = query_fda1[0];


		string_pdf +=' <div id="contenedor" style="    font-size: 9px;">';
		string_pdf +='    <table cellspacing="0" class="table_cabecera" style="    border: 1px solid gray;">';
		string_pdf +='      <tr>';
		string_pdf +='          <th colspan="2">SHIPPER</th>';
		string_pdf +='          <th style="    border-left: 1px solid gray;">JOB NO:</th>';
		string_pdf +='          <td style="font-size: 15px;">'+record.Name+'</td>';
		string_pdf +='          <th>CUSTOMER REFERENCE:</th>';
		string_pdf +='          <td style="font-size: 10px;font-family:Arial Unicode MS;">'+neu_utils.safestring(record.Customer_Reference__c)+'</td>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		string_pdf +='          <td colspan="2" style="height: 60px;     border-bottom: 1px solid gray;     width: 350px;     vertical-align: top;">'+neu_utils.safestring(record.Supplier_Account__r.Name);
		string_pdf +=               '<br></br>'+(shipper != null ? 'VAT: '+neu_utils.safestring(shipper.TAX_ID__c) : '');
		string_pdf +=               '<br></br>'+(shipper != null ? neu_utils.safestring(shipper.BillingStreet) : '')+'<br></br>'+(shipper != null ? neu_utils.safestring(shipper.BillingCity) : '')+ ' '+(shipper != null ? neu_utils.safestring(shipper.BillingPostalCode) : '')+ '  '+(shipper != null ? neu_utils.safestring(shipper.BillingCountry) : '')+'<br></br>';
		string_pdf +=          '</td>';
		string_pdf +='          <th colspan="4" rowspan="3" style="border-left: 1px solid gray;border-top: 1px solid gray;vertical-align: top;"><span class="title_document" style="font-size: 15px;float:left;">RELEASE ORDER / DELIVERY ORDER</span>';
		string_pdf += '         </th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr>';
		string_pdf +='          <th colspan="2">CONSIGNEE</th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		string_pdf +='          <td colspan="2" style="height: 60px;border-bottom: 1px solid gray;vertical-align: top;">'+neu_utils.safestring(record.Consignee__r.Name);
		string_pdf +=               '<br></br>'+(consignee != null ? 'VAT: '+neu_utils.safestring(consignee.TAX_ID__c) : '');
		string_pdf +=               '<br></br>'+(consignee != null ? neu_utils.safestring(consignee.BillingStreet) : '')+'<br></br>'+(consignee != null ? neu_utils.safestring(consignee.BillingCity) : '')+ ' '+(consignee != null ? neu_utils.safestring(consignee.BillingPostalCode) : '')+ '  '+(consignee != null ? neu_utils.safestring(consignee.BillingCountry) : '')+'<br></br>';
		string_pdf +=          '</td>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		string_pdf +='          <th colspan="2">RELEASE TO COMPANY:</th>';
		string_pdf +='          <th colspan="4" rowspan="13" style="border-left: 1px solid gray;border-top: 1px solid gray;vertical-align: top;text-align: center;border-top: 0;"><img src="/resource/'+query_logo.SystemModStamp.getTime()+ '/'+(String.IsNotEmpty(query_logo.NamespacePrefix)?query_logo.NamespacePrefix+'__':'')+query_logo.Name+'" class="company_logo"></th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		string_pdf +='          <td colspan="2" style="height: 60px;vertical-align: top;">'+(releaseCompany != null ? neu_utils.safestring(releaseCompany.Name) : '');
		string_pdf +=               '<br></br>'+(releaseCompany != null ? ' VAT: '+neu_utils.safestring(releaseCompany.TAX_ID__c) : '');
		string_pdf +=               '<br></br>'+(releaseCompany != null ? neu_utils.safestring(releaseCompany.BillingStreet) : '')+'<br></br>'+(releaseCompany != null ? neu_utils.safestring(releaseCompany.BillingCity) : '')+ ' '+(releaseCompany != null ? neu_utils.safestring(releaseCompany.BillingPostalCode) : '')+ '  '+(releaseCompany != null ? neu_utils.safestring(releaseCompany.BillingCountry) : '')+'<br></br>';
		string_pdf +=          '</td>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr>';
		string_pdf +='          <th colspan="2">CONTACTS:</th>';
		string_pdf +='      </tr>';
		string border = '';
		if(contact1 == null && contact2 == null && contact3 == null)
		{
			border = 'border-bottom: 1px solid gray;';
			string_pdf +='      <tr>';
			string_pdf +='          <td colspan="2" style="height: 20px;'+border+'vertical-align: top;">';
			string_pdf +=          '</td>';
			string_pdf +='      </tr>';
		}
		if(contact1 != null)
		{
			border = '';
			if(contact2 == null && contact3 == null)
				border = 'border-bottom: 1px solid gray;';
			string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
			string_pdf +='          <td colspan="2" style="height: 20px;'+border+'vertical-align: top;">'+(contact1 != null ? neu_utils.safestring(contact1.Name) : '');
			string_pdf +=               +'<br></br>'+(contact1 != null ? '   PHONE: '+neu_utils.safestring(contact1.Phone) : '')+(contact1 != null ? '  MOBILE: '+neu_utils.safestring(contact1.MobilePhone) : '') + (contact1 != null ? ' FAX: '+neu_utils.safestring(contact1.Fax) : '');
			string_pdf +=               +'<br></br>'+(contact1 != null ? 'EMAIL: '+neu_utils.safestring(contact1.Email) : '')+'<br></br>';
			string_pdf +=          '</td>';
			string_pdf +='      </tr>';
		}

		string_pdf +='      <tr style="border-top: 1px solid gray;">';
		string_pdf +='      <tr>';
		string_pdf +='          <th>CARRIAGE BY</th>';
		string_pdf +='          <th>PLACE OF RECEIPT</th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr>';
		string_pdf +='          <td style="border-bottom: 1px solid gray;height: 28px;">'+neu_utils.safeString(record.Freight_Mode__c)+'</td>';
		string_pdf +='          <td style="border-bottom: 1px solid gray;height: 28px;">'+neu_utils.safeString(record.Origin_Address__c)+'</td>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr>';
		string_pdf +='          <th>VESSEL/VOYAGE</th>';
		string_pdf +='          <th>PORT OF LOADING</th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr>';
		if(record.Freight_Mode__c == 'Sea')
		{
			List<Shipment_Consolidation_Data__c> query_ship_consolidation = [select Id, Name, Shipment__c, Shipment__r.Truck_Vessel_Flight__r.Name  from Shipment_Consolidation_Data__c where Import_Export_Quote__c =: record.Id and Shipment__r.Freight_Mode__c =:'Sea'];
			if(query_ship_consolidation != null && query_ship_consolidation.size()>0)
				string_pdf +='<td style="border-bottom: 1px solid gray;height: 28px;">'+(query_ship_consolidation[0].Shipment__r.Truck_Vessel_Flight__c != null ? query_ship_consolidation[0].Shipment__r.Truck_Vessel_Flight__r.Name : '')+'</td>';
			else
				string_pdf +='<td style="border-bottom: 1px solid gray;height: 28px;"></td>';
		}
		else
			string_pdf +='<td style="border-bottom: 1px solid gray;height: 28px;font-family:Arial Unicode MS;"></td>';
		string_pdf +='          <td style="    border-bottom: 1px solid gray;     height: 28px;">'+(record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+'</td>';
		string_pdf +='      </tr>';

		string_pdf +='      <tr>';
		string_pdf +='          <th>PORT OF DISCHARGE</th>';
		string_pdf +='          <th>PLACE OF DELIVERY</th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		string_pdf +='          <td style="    height: 28px;">'+(record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+'</td>';
		string_pdf +='          <td style="    height: 28px;">'+neu_utils.safestring(record.Destination_Address__c)+'</td>';
		string_pdf +='      </tr>';

		string_pdf +='    </table>';
		string_pdf +='    <table class="table_cabecera" style="border: 1px solid gray;">';
		string_pdf +='      <tr>';
		string_pdf +='          <th>MARKS & NUMBERS</th>';
		string_pdf +='          <th>NO. OF PKGS.</th>';
		string_pdf +='          <th>DESCRIPTION OF GOODS</th>';
		string_pdf +='          <th>GROSS WEIGHT</th>';
		string_pdf +='          <th>MEASUREMENT</th>';
		string_pdf +='      </tr>';
		list<Quote_Item_Line__c> query_quote_lines = [select Id, Name, Packaging_Description__c, Extension_Item_Name__c,Total_Shipping_Weight_Kgs__c, Units__c, Total_Shipping_Volume_m3__c, Packaging_Quantity__c, Item_Name__c, Item_Name__r.Name from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id];
		for(Quote_Item_Line__c qil: query_quote_lines)
			{
				string_pdf +='      <tr>';
				string_pdf +='          <td style="    background: #d0d8da;">'+neu_utils.safestring(qil.Extension_Item_Name__c)+'</td>';
				string_pdf +='          <td style="    background: #d0d8da;     text-align: right;">'+neu_utils.safeDecimal(qil.Units__c)+'</td>';
				string_pdf +='          <td style="    background: #d0d8da;">'+(qil.Item_Name__c != null ? qil.Item_Name__r.Name : '')+'</td>';
				string_pdf +='          <td style="    background: #d0d8da;     text-align: right;">'+neu_utils.safeDecimal(qil.Total_Shipping_Weight_Kgs__c)+'</td>';
				string_pdf +='          <td style="    background: #d0d8da;     text-align: right;">'+neu_utils.safeDecimal(qil.Total_Shipping_Volume_m3__c)+'</td>';
				string_pdf +='      </tr>';
			}
		string_pdf +='      <tr>';
		string_pdf +='          <th>REMARKS:</th>';
		//viene por parametro
		string_pdf +='          <td colspan="4" style="font-size: 15px;font-family:Arial Unicode MS;">'+neu_utils.safeString(ApexPages.currentPage().getParameters().get('remarks'))+'</td>';
		string_pdf +='      </tr>';

		string_pdf +='    </table>';
		string_pdf +='    <table cellspacing="0" class="table_cabecera" style="border: 1px solid gray;">';
		string_pdf +='      <tr>';
		string_pdf +='          <th>RELEASE DATE</th>';
		string_pdf +='          <th style="    border-left: 1px solid gray;">RELEASE VALID TO</th>';
		string_pdf +='          <th style="border-left: 1px solid gray;">RELEASE COMPANY</th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		//viene por parametro
		string_pdf +='          <td style="border-bottom: 1px solid gray;height: 28px;">'+neu_utils.safeString(ApexPages.currentPage().getParameters().get('release_date'))+'</td>';
		string_pdf +='          <td style=" border-left: 1px solid gray;    border-bottom: 1px solid gray;     height: 28px;">'+neu_utils.safeString(ApexPages.currentPage().getParameters().get('release_valid'))+'</td>';
		string_pdf +='          <td rowspan="9" style="border-left: 1px solid gray; vertical-align: top;">';
		string_pdf +=           ''+neu_utils.safestring(query_user.CompanyName)+'<br></br>';
		//string_pdf +=           'VAT reg. number '+neu_utils.safestring(query_user.VAT_number__c)+'<br></br>';
		string_pdf +=           neu_utils.safestring(query_user.Street) +', '+ neu_utils.safestring(query_user.City) + ', '+ neu_utils.safestring(query_user.PostalCode) +', '+ neu_utils.safestring(query_user.State) +', '+neu_utils.safestring(query_user.Country)+'<br></br>';
		string_pdf +=           'Tel.: '+neu_utils.safestring(query_user.Phone)+' E-mail: '+neu_utils.safestring(query_user.Email)+'<br></br>';
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
		string_pdf += '<img src="/resource/'+query_logo.SystemModStamp.getTime()+ '/'+(String.IsNotEmpty(query_logo.NamespacePrefix)?query_logo.NamespacePrefix+'__':'')+query_logo.Name+'" class="company_logo"/>';

		string_pdf +='          </td>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr>';
		string_pdf +='          <th>RELEASE PLACE OF ISSUE</th>';
		string_pdf +='          <th style="border-left: 1px solid gray;">B/L STATUS:</th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		string_pdf +='          <td style="border-bottom: 1px solid gray;height: 28px;">'+neu_utils.safestring(record.Office__c)+'</td>';
		string_pdf +='          <td style="border-bottom: 1px solid gray; border-left: 1px solid gray;height: 28px;">'+neu_utils.safestring(record.B_L_Status__c)+'</td>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr>';
		string_pdf +='          <th colspan="2">FOR SHIPMENT PICK UP, PLEASE CONTACT</th>';
		string_pdf +='      </tr>';
		string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
		string_pdf +='          <td colspan="2" style="height: 20px;vertical-align: top;">'+neu_utils.safeString(ApexPages.currentPage().getParameters().get('shipment_pick_up'))+'</td>';
		string_pdf +='      </tr>';
		if(finalDelivery != null)
		{
			string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
			string_pdf +='          <td colspan="2" style="height: 15px;vertical-align: top;">'+(finalDelivery != null ? neu_utils.safestring(finalDelivery.Name) : '');
			string_pdf +=               ' ,'+(finalDelivery != null ? neu_utils.safestring(finalDelivery.BillingStreet) : '')+'  '+(finalDelivery != null ? neu_utils.safestring(finalDelivery.BillingCity) : '')+ ' '+(finalDelivery != null ? neu_utils.safestring(finalDelivery.BillingPostalCode) : '')+ ' '+(finalDelivery != null ? neu_utils.safestring(finalDelivery.BillingCountry) : '');
			string_pdf +=          '</td>';
			string_pdf +='      </tr>';
		}
		if(finalDeliveryContact1 != null)
		{
			string_pdf +='      <tr style="font-family:Arial Unicode MS;">';
			string_pdf +='          <td colspan="2" style="height: 15px;vertical-align: top;">'+(finalDeliveryContact1 != null ? '1: '+neu_utils.safestring(finalDeliveryContact1.Name) : '');
			string_pdf +=               '   '+(finalDeliveryContact1 != null ? '   ,PHONE: '+neu_utils.safestring(finalDeliveryContact1.Phone) : '')+(finalDeliveryContact1 != null ? '  MOBILE: '+neu_utils.safestring(finalDeliveryContact1.MobilePhone) : '') + (finalDeliveryContact1 != null ? ' FAX: '+neu_utils.safestring(finalDeliveryContact1.Fax) : '');
			string_pdf +=               '   '+(finalDeliveryContact1 != null ? 'EMAIL: '+neu_utils.safestring(finalDeliveryContact1.Email) : '')+'<br></br>';
			string_pdf +=          '</td>';
			string_pdf +='      </tr>';
		}

		string_pdf +='    </table>';
		string_pdf +=' </div>';

		String nameDocument = 'DO '+record.name +'.pdf';
		Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+nameDocument);
	}
}