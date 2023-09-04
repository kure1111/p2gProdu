public with sharing class NEU_IE_Notifications_PDF {

	public Customer_Quote__c record;
	
    public string string_pdf {get;set;}
	public string cabecera {get;set;}
    public string cuerpo_notificacion {get;set;}
    public string asunto {get;set;}
    
	public List<Import_Export_Fee_Line__c> listado_de_lineas_de_fees {get; set;}{
		listado_de_lineas_de_fees = new List<Import_Export_Fee_Line__c>();
	}
	
	public List<Quote_Item_Line__c> query_shipment_lines {get; set;}{
		query_shipment_lines = new List<Quote_Item_Line__c>();
	}

	public Integer optionTemplate { get; set; }
	{
	   optionTemplate = 1;
	}
	
	public Integer optionLanguage { get; set; }
	{
	   optionLanguage = 1;
	}
    
    ApexPages.StandardController con;
            
    public NEU_IE_Notifications_PDF(ApexPages.StandardController stdController) 
    {
        con = stdController;

      	/* DATOS DE LA IMPORT/EXPORT */   
      	try { 
       		record = [select Id, Name, Account_for__c, Container_Type__r.Name, Consignee__c, 
	       			 Equipment__c, Service_Mode__c, Supplier_Account__c,  Service_Type__c,  
	       			 Freight_Mode__c, Account_for__r.Name, Supplier_Account__r.Name,
				  	 Site_of_Discharge__r.Name, Site_of_Load__r.Name, Consignee__r.Name,
				  	 Country_ofLoad__r.Name, Country_ofDischarge__r.Name,
				  	 State_of_Load__r.Name, State_of_Discharge__r.Name
			  	 	 from Customer_Quote__c where id = :con.getRecord().id];
      	} catch( Exception ee) { 
        	record = new Customer_Quote__c();
      	}
      
      	/* DATOS CARGO LINES */ 
      	try{  
			query_shipment_lines = [select id, Name, Item_Name__c, Total_Shipping_Weight_Kgs__c, Total_Shipping_Volume_m3__c, 
									Extension_Item_Name__c, Units__c, Item_Name__r.Name 
									from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Name];
      	} catch(Exception ee) { 
        	query_shipment_lines = new List<Quote_Item_Line__c>();
      	}
      	
      	/* DATOS SERVICE LINES */
      	try
      	{  
      		string consulta = '';
      		consulta += 'SELECT Id, Name, Service_Rate_Name__r.Name, Rate_Type__c, Units__c, Sell_Rate__c';
      		consulta += (UserInfo.isMultiCurrencyOrganization() ? ', CurrencyIsoCode' : '');
      		consulta += ' FROM Import_Export_Fee_Line__c';
      		consulta += ' WHERE Import_Export_Quote__c = \''+record.Id+'\' order by Name';
	      	listado_de_lineas_de_fees = database.query(consulta);
      	} 
      	catch(Exception ee){listado_de_lineas_de_fees = new List<Import_Export_Fee_Line__c>();}
        
        cabecera = 	 '<table id="table_head">';
		cabecera +=  '	<tr>';
		cabecera +=  '		<th><img src="https://c.cs86.content.force.com/servlet/servlet.ImageServer?id=0157E000000GrRm&oid=00D7E0000008vuy&lastMod=1511531319000" class="logo"/></th>';
		cabecera +=  '	</tr>';
		cabecera +=  '</table>';
	
		if(ApexPages.currentPage().getParameters().get('optionTemplate') != null)
		{
			optionTemplate = integer.valueof(ApexPages.currentPage().getParameters().get('optionTemplate'));
		}
		
		if(ApexPages.currentPage().getParameters().get('optionLanguage') != null)
		{
			optionLanguage = integer.valueof(ApexPages.currentPage().getParameters().get('optionLanguage'));
		}

		load_template();		
    }
    
    public void load_template()
    {
		if (optionTemplate==1)
		{
			if(optionLanguage==1)
			{
				asunto = 'Booking Confirmation of Import/Export: ' + record.Name;
				load_template_booking_english(); 
			}
			else
			{
				asunto = 'Confirmación de Reserva del Import/Export: ' + record.Name;
				load_template_booking_spanish(); 
			}			
		}
		string_pdf = cuerpo_notificacion;    	
    }
    
    /* ######################## COMIENZO PLANTILLAS ######################## */
    public void load_template_booking_english(){
		cuerpo_notificacion  = cabecera;
		cuerpo_notificacion +=  '<table id="table_body">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '			<p>Dear '+(record.Account_for__r.Name != null ? record.Account_for__r.Name : 'Customer')+',</p>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '			<p>Below you can find details of our service. Please attach this document as support of our Invoice.</p>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Shipper</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';	
		cuerpo_notificacion +=  '					<td>'+(record.Supplier_Account__r.Name != null ? record.Supplier_Account__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Consignee</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Consignee__r.Name != null ? record.Consignee__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Origin</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Country_ofLoad__r.Name != null ? record.Country_ofLoad__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>SOL</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.State_of_Load__r.Name != null ? record.State_of_Load__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>POL</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Site_of_Load__r.Name != null ? record.Site_of_Load__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>POD</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Site_of_Discharge__r.Name != null ? record.Site_of_Discharge__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>SOD</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.State_of_Discharge__r.Name != null ? record.State_of_Discharge__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><p><b>Destination</b></p></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Country_ofDischarge__r.Name != null ? record.Country_ofDischarge__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><p><b>Container Size/type</b></p></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Container_Type__r.Name != null ? record.Container_Type__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Commodity</b></td>';
		cuerpo_notificacion +=  '					<td><b>Description</b></td>';
		cuerpo_notificacion +=  '					<td><b>Gross Weight</b></td>';
		cuerpo_notificacion +=  '					<td><b>Total Packages</b></td>';
		cuerpo_notificacion +=  '					<td><b>Volume</b></td>';
		cuerpo_notificacion +=  '				</tr>';
        for(Quote_Item_Line__c ql: query_shipment_lines)
        {		
			cuerpo_notificacion +=  '				<tr>';
			cuerpo_notificacion +=  '					<td>'+(ql.Item_Name__r.Name != null ? ql.Item_Name__r.Name : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Extension_Item_Name__c != null ? ql.Extension_Item_Name__c : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Total_Shipping_Weight_Kgs__c != null ? ql.Total_Shipping_Weight_Kgs__c + ' kgs' : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Units__c != null ? NEU_Utils.safestring(ql.Units__c) : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Total_Shipping_Volume_m3__c != null ? ql.Total_Shipping_Volume_m3__c + ' CBM' : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '				</tr>';
        }
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Charge</b></td>';
		cuerpo_notificacion +=  '					<td><b>Unit</b></td>';
		cuerpo_notificacion +=  '					<td><b>Quantity</b></td>';
		cuerpo_notificacion +=  '					<td><b>Rate</b></td>';
		cuerpo_notificacion +=  '				</tr>';
        for(Import_Export_Fee_Line__c fl: listado_de_lineas_de_fees)
        {		
			cuerpo_notificacion +=  '				<tr>';
			cuerpo_notificacion +=  '					<td>'+(fl.Service_Rate_Name__r.Name != null ? fl.Service_Rate_Name__r.Name : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(fl.Rate_Type__c != null ? fl.Rate_Type__c : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(fl.Units__c != null ? NEU_Utils.safestring(fl.Units__c) : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(fl.Sell_Rate__c != null ? NEU_Utils.safestring(fl.Sell_Rate__c) + ' ' + NEU_CurrencyUtils.getCurrencyIsoCode(fl) : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '				</tr>';
        }
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_booking_spanish(){
		cuerpo_notificacion  = cabecera;
		cuerpo_notificacion +=  '<table id="table_body">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '			<p>Estimado '+(record.Account_for__r.Name != null ? record.Account_for__r.Name : 'Customer')+',</p>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '			<p>A continuación usted puede encontrar los de talles del servicio. Por favor, adjunte este documento como apoyo a la factura.</p>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Shipper</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';	
		cuerpo_notificacion +=  '					<td>'+(record.Supplier_Account__r.Name != null ? record.Supplier_Account__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Consignee</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Consignee__r.Name != null ? record.Consignee__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Origin</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Country_ofLoad__r.Name != null ? record.Country_ofLoad__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>SOL</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.State_of_Load__r.Name != null ? record.State_of_Load__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>POL</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Site_of_Load__r.Name != null ? record.Site_of_Load__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>POD</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Site_of_Discharge__r.Name != null ? record.Site_of_Discharge__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>SOD</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.State_of_Discharge__r.Name != null ? record.State_of_Discharge__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><p><b>Destination</b></p></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Country_ofDischarge__r.Name != null ? record.Country_ofDischarge__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><p><b>Container Size/type</b></p></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Container_Type__r.Name != null ? record.Container_Type__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Mercancía</b></td>';
		cuerpo_notificacion +=  '					<td><b>Descripción</b></td>';
		cuerpo_notificacion +=  '					<td><b>Peso bruto</b></td>';
		cuerpo_notificacion +=  '					<td><b>Número de paquetes</b></td>';
		cuerpo_notificacion +=  '					<td><b>Volumen</b></td>';
		cuerpo_notificacion +=  '				</tr>';
        for(Quote_Item_Line__c ql: query_shipment_lines)
        {		
			cuerpo_notificacion +=  '				<tr>';
			cuerpo_notificacion +=  '					<td>'+(ql.Item_Name__r.Name != null ? ql.Item_Name__r.Name : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Extension_Item_Name__c != null ? ql.Extension_Item_Name__c : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Total_Shipping_Weight_Kgs__c != null ? ql.Total_Shipping_Weight_Kgs__c + ' kgs' : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Units__c != null ? NEU_Utils.safestring(ql.Units__c) : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(ql.Total_Shipping_Volume_m3__c != null ? ql.Total_Shipping_Volume_m3__c + ' CBM' : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '				</tr>';
        }
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Cargo</b></td>';
		cuerpo_notificacion +=  '					<td><b>Unidad</b></td>';
		cuerpo_notificacion +=  '					<td><b>Cantidad</b></td>';
		cuerpo_notificacion +=  '					<td><b>Tarifa</b></td>';
		cuerpo_notificacion +=  '				</tr>';
        for(Import_Export_Fee_Line__c fl: listado_de_lineas_de_fees)
        {		
			cuerpo_notificacion +=  '				<tr>';
			cuerpo_notificacion +=  '					<td>'+(fl.Service_Rate_Name__r.Name != null ? fl.Service_Rate_Name__r.Name : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(fl.Rate_Type__c != null ? fl.Rate_Type__c : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(fl.Units__c != null ? NEU_Utils.safestring(fl.Units__c) : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(fl.Sell_Rate__c != null ? NEU_Utils.safestring(fl.Sell_Rate__c) + ' ' + NEU_CurrencyUtils.getCurrencyIsoCode(fl) : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '				</tr>';
        }
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</table>';
    }
    /* ######################## FINAL PLANTILLAS ######################## */ 
    
}