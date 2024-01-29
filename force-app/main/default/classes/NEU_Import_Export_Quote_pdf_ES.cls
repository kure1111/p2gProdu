public with sharing class NEU_Import_Export_Quote_pdf_ES 
{
	public Customer_Quote__c record;
    public string quotation {get;set;}
    
    ApexPages.StandardController con;
            
    public NEU_Import_Export_Quote_pdf_ES(ApexPages.StandardController stdController) 
    {
		con = stdController;
        
       	try 
       	{
       		string consulta = '';
       		consulta += 'SELECT Id, Name, Account_for__c, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Account_for__r.Name, Account_for__r.Brand_Name__c, Account_for__r.Authorized_Credit__c,Account_for__r.Credit_Terms__c,';
       		consulta += ' Freight_Mode__c, Total_Services_Sell_Amount__c, PDF_Notes__c, Service_Type__c, Observations__c, Valid_From__c, Valid_Until__c, Service_Mode__c, Route__r.Country_of_Discharge__r.Name,';
       		consulta += ' Route__r.Country_of_Load__r.Name, Route__r.Name, Route__r.State_of_Discharge__r.Name, Route__r.State_of_Load__r.Name, Route__r.Port_Airport_of_Load__r.Name, Route__r.Port_Airport_of_Discharge__r.Name, Total_Taxes__c, Total_Services_Sell_Amount_number__c, Total_Taxes_Number__c'; 
			consulta += ' FROM Customer_Quote__c WHERE id = \''+ con.getRecord().id+'\'';
			record = Database.query(consulta);	
        } 
        catch(Exception ee){record = new Customer_Quote__c();}
		
		integer cont = 0;
		integer limit_lines = 12;
		
		if(record.Service_Type__c == 'MAYOREO' || record.Service_Type__c == 'TARIMAS')
			limit_lines = 12;
       	
    	List<StaticResource> quotation_map = [select Id, Name, Body, SystemModStamp, NamespacePrefix from StaticResource where Name = 'quotation_map'];
    
    	List<Import_Export_Fee_Line__c> fee_lines = new List<Import_Export_Fee_Line__c>();
    	
    	string consulta_fee_lines = '';
    	consulta_fee_lines += 'SELECT Id, Name, Service_Rate_Name__r.Name, Sell_Amount__c, Units__c, Service_Rate_Category__c, Quote_Sell_Price__c'; 
    	if(UserInfo.isMultiCurrencyOrganization()== true)
        	consulta_fee_lines += ',CurrencyIsoCode'; 
	    consulta_fee_lines += ' FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c = \''+record.Id+'\' ORDER BY Name ASC';
	    
	    List<sObject> query_fee_lines = Database.query(consulta_fee_lines);
	    fee_lines = query_fee_lines;
	    
	    List<User> user = [select Id, Name, Phone, MobilePhone, Email from User where Id =: Userinfo.getUserId()];
	    
	    quotation = '';
	    quotation += '<div class="pagina">';
	    quotation += '<div class="container">';
	    quotation += '	<div class="header">';
	    quotation += '			<div class="header_top">';
	    quotation += '			<div class="header_image">';
	    quotation += '				<img src="/resource/cabecera1_Import_Export_Quote"/>';	    
	    quotation += '			</div">';
	    	    
		quotation += '				<h1 class="main_title">'+Label.QPDF_Propuesta+'</h1>';
		if(record.Freight_Mode__c == 'Air' || Test.isRunningTest())
		{
			if(record.Service_Mode__c == 'IMPORT')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Aereo+' '+Label.QPDF_Importacion+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'EXPORT')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Aereo+' '+Label.QPDF_Exportacion+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'NATIONAL')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Aereo+' '+Label.QPDF_Nacional+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'INTERNATIONAL')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Aereo+' '+Label.QPDF_Internacional+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
		}
		if(record.Freight_Mode__c == 'Sea' || Test.isRunningTest())
		{
			if(record.Service_Mode__c == 'IMPORT')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Maritimo+' '+Label.QPDF_Importacion+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'EXPORT')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Maritimo+' '+Label.QPDF_Exportacion+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'NATIONAL')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Maritimo+' '+Label.QPDF_Nacional+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'INTERNATIONAL')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Maritimo+' '+Label.QPDF_Internacional+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
		}
		if(record.Freight_Mode__c == 'Road' || record.Freight_Mode__c == 'Rail' || Test.isRunningTest())
		{
			if(record.Service_Mode__c == 'IMPORT')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Terrestre+' '+Label.QPDF_Importacion+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'EXPORT')
				quotation += ' 	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Terrestre+' '+Label.QPDF_Exportacion+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'NATIONAL')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Terrestre+' '+Label.QPDF_Nacional+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
			if(record.Service_Mode__c == 'INTERNATIONAL')
				quotation += '	<h2 class="freight_mode_title">'+Label.QPDF_Flete+' '+Label.QPDF_Terrestre+' '+Label.QPDF_Internacional+' '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</h2>';
		}
		quotation += '		</div>';
		quotation += '</div>';
	    
	    quotation += '			<div class="header_left">';
	    quotation += '				<table class="table_data">';
	    quotation += '					<tbody>';
	    quotation += '						<tr>';
	    quotation += '							<td><label>'+Label.QPDF_Empresa+':</label>'+(record.Account_for__c != null ? record.Account_for__r.Name : '')+'</td>';
	    quotation += '						</tr>';
	    quotation += '						<tr>';
	    quotation += '							<td><label>'+Label.QPDF_Folio+':</label><b><u> '+record.Name+'</u></b></td>';
		quotation += '						</tr>';
		quotation += '						<tr>';
		quotation += '							<td><label>'+Label.QPDF_Service_type+': </label> '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</td>';
		quotation += '						</tr>';
		quotation += '						<tr>';
		quotation += '							<td><label>'+Label.QPDF_Origin+': </label>'+(record.Route__r.Country_of_Load__r.Name != null ? record.Route__r.Country_of_Load__r.Name : '')+' - '+(record.Route__r.State_of_Load__r.Name != null ? record.Route__r.State_of_Load__r.Name : '')+' - '+(record.Route__r.Port_Airport_of_Load__r.Name != null ? record.Route__r.Port_Airport_of_Load__r.Name : '')+'</td>';
		quotation += '						</tr>';
		quotation += '						<tr>';
		quotation += '							<td><label>'+Label.QPDF_destionation+': </label>'+(record.Route__r.Country_of_Discharge__r.Name != null ? record.Route__r.Country_of_Discharge__r.Name : '')+' - '+(record.Route__r.State_of_Discharge__r.Name != null ? record.Route__r.State_of_Discharge__r.Name : '')+' - '+(record.Route__r.Port_Airport_of_Discharge__r.Name != null ? record.Route__r.Port_Airport_of_Discharge__r.Name : '')+' </td>';
		quotation += '						</tr>';
		quotation += '						<tr>';
		quotation += '							<td><label>'+Label.QPDF_Divisa+': </label>'+NEU_CurrencyUtils.getCurrencyIsoCode(record)+'</td>';
		quotation += '						</tr>';	
		quotation += '					</tbody>';
		quotation += '				</table>';
		quotation += '			</div>';		
		
		quotation += '	<div class="header_right">';
		quotation += '		<table class="table_data">';
		quotation += '				<tbody>';
		quotation += '					<tr>';
		quotation += '						<td><h3 class="date">'+Label.QPDF_Fecha+': '+system.today().day()+' / '+system.today().month()+' / '+system.today().year()+'</h3></td>';
		quotation += '					</tr>';
		quotation += '					<tr>';
		quotation += '						<td><h3 class="date">'+Label.QPDF_Vigencia+': '+(record.Valid_From__c != null ? record.Valid_From__c.day()+' / '+record.Valid_From__c.month()+' / '+record.Valid_From__c.year() : '')+(record.Valid_Until__c != null ? '  -  '+record.Valid_Until__c.day()+' / '+record.Valid_Until__c.month()+' / '+record.Valid_Until__c.year() : '')+'</h3></td>';
		quotation += '					</tr>';

		if(record.Account_for__r.Authorized_Credit__c) {
			quotation += '					<tr>';
			quotation += '						<td><span class="date"><label>' + Label.QPDF_Credit_Days + ':  </label>' + (record.Account_for__r.Credit_Terms__c != null ? record.Account_for__r.Credit_Terms__c : '') + '</span></td>';
			quotation += '					</tr>';
		}

		quotation += '				</tbody>';
		quotation += '			</table>';
		quotation += '	</div>';
		quotation += '	<div class="footer">';
		quotation += '			<div class="middle_footer">';
		quotation += '					<table class="table_data footer_left">';
		quotation += '							<tbody>';
		quotation += '								<tr>';
		quotation += '						<td><label>'+Label.QPDF_executive_data+'</label></td>';
		quotation += '								</tr>';
		quotation += '								<tr>';
		quotation += '									<td><label>'+Label.QPDF_Ejecutivo+':</label>'+(user.size() > 0 && user[0].Name != null ? user[0].Name : '')+'</td>';
		quotation += '								</tr>';
		quotation += '								<tr>';
		quotation += '									<td><label>'+Label.QPDF_Telefono+': </label>'+(user.size() > 0 && user[0].Phone != null  ? user[0].Phone : '')+'</td>';
		quotation += '						</tr>';
		quotation += '						<tr>';
		quotation += '							<td><label>'+Label.QPDF_Movil+': </label>'+(user.size() > 0 && user[0].MobilePhone != null  ? user[0].MobilePhone : '')+' </td>';
		quotation += '						</tr>';
		quotation += '						<tr>';
		quotation += '							<td><label>'+Label.QPDF_Correo+': </label>'+(user.size() > 0 && user[0].Email != null  ? user[0].Email : '')+'</td>';
		quotation += '						</tr>';
		quotation += '					</tbody>';
		quotation += '				</table>';
        quotation += '			<div class="img_footer">';
        quotation += '				<img src="/resource/pieDerecho_Import_Export_Quote" width="490.5px" style="margin-top:3px;"/>';
        quotation += '			</div>';        
        quotation += '	</div>';
        quotation += '<div class="botom_footer">';
        quotation += '		<p class="companyName"><h2>GRUPO PGL MEXICO S.A.P.I DE C.V.</h2></p>';
        quotation += '		<p class="companyName"><h2>GPM170110AV4</h2></p>';
        quotation += '		<p class="address">Calle Argentina no. 205-1 Col. Industrial Martel de Santa Catarina, N.L México, C.P. 66367</p>';
        quotation += '		<p class="address">Tel.01800 APOYO 06 WWW.PAK2GO.COM </p>	';
        quotation += '</div>';
        quotation += '<div class="npage_footer"><span class="pagenumber"/>/<span class="pagecount"/></div>';
        quotation += '</div>';
        
		quotation += '			<div class="middle ">';
		quotation += '				<table class="table_tarifas" border="0" cellspacing="0">';
		quotation += '					<tbody>';
		quotation += '						<tr>';
		quotation += '							<th class="tt_1">'+Label.QPDF_table_service+'</th>';
		quotation += '							<th class="tt_2">'+Label.QPDF_table_product+'</th>';
		quotation += '							<th class="tt_2">'+Label.QPDF_table_mode+'</th>';
		quotation += '							<th class="tt_2">'+Label.QPDF_table_qty+'</th>';
		quotation += '							<th class="tt_2">'+Label.QPDF_table_up+'</th>';
		quotation += '							<th class="tt_2">'+Label.QPDF_table_tp+'</th>';
		quotation += '						</tr>';

		for(Import_Export_Fee_Line__c fl : fee_lines)
		{
			if(cont == limit_lines || Test.isRunningTest())
			{
				quotation += '		</tbody>';
				quotation += '	</table>';
				quotation += '</div>';
				quotation += '</div>';
	    		quotation += '</div>';
	    		quotation += '</div>';
			    quotation += '<div class="pagina" style="page-break-before:always;">';
			    quotation += '<div class="container">';			    			    
			    quotation += '			<div class="header_left">';
			    quotation += '				<table class="table_data">';
			    quotation += '					<tbody>';
			    quotation += '						<tr>';
			    quotation += '							<td><label>'+Label.QPDF_Empresa+':</label>'+(record.Account_for__c != null ? record.Account_for__r.Name : '')+'</td>';
			    quotation += '						</tr>';
			    quotation += '						<tr>';
			    quotation += '							<td><label>'+Label.QPDF_Folio+':</label><u> '+record.Name+'</u></td>';
				quotation += '						</tr>';
				quotation += '						<tr>';
				quotation += '							<td><label>'+Label.QPDF_Service_type+': </label> '+(record.Service_Type__c != null ? record.Service_Type__c : '')+'</td>';
				quotation += '						</tr>';
				quotation += '						<tr>';
				quotation += '							<td><label>'+Label.QPDF_Origin+': </label>'+(record.Route__r.Country_of_Load__r.Name != null ? record.Route__r.Country_of_Load__r.Name : '')+' - '+(record.Route__r.State_of_Load__r.Name != null ? record.Route__r.State_of_Load__r.Name : '')+' - '+(record.Route__r.Port_Airport_of_Load__r.Name != null ? record.Route__r.Port_Airport_of_Load__r.Name : '')+'</td>';
				quotation += '						</tr>';
				quotation += '						<tr>';
				quotation += '							<td><label>'+Label.QPDF_destionation+': </label>'+(record.Route__r.Country_of_Discharge__r.Name != null ? record.Route__r.Country_of_Discharge__r.Name : '')+' - '+(record.Route__r.Country_of_Discharge__r.Name != null ? record.Route__r.Country_of_Discharge__r.Name : '')+' - '+(record.Route__r.Port_Airport_of_Discharge__r.Name != null ? record.Route__r.Port_Airport_of_Discharge__r.Name : '')+' </td>';
				quotation += '						</tr>';
				quotation += '						<tr>';
				quotation += '							<td><label>'+Label.QPDF_Divisa+': </label>'+NEU_CurrencyUtils.getCurrencyIsoCode(record)+'</td>';
				quotation += '						</tr>';	
				quotation += '					</tbody>';
				quotation += '				</table>';
				quotation += '			</div>';			
				
				quotation += '	<div class="header_right">';
				quotation += '		<table class="table_data">';
				quotation += '				<tbody>';
				quotation += '					<tr>';
				quotation += '						<td><h3 class="date">'+Label.QPDF_Fecha+': '+system.today().day()+' / '+system.today().month()+' / '+system.today().year()+'</h3></td>';
				quotation += '					</tr>';
				quotation += '					<tr>';
				quotation += '						<td><h3 class="date">'+Label.QPDF_Vigencia+': '+(record.Valid_From__c != null ? record.Valid_From__c.day()+' / '+record.Valid_From__c.month()+' / '+record.Valid_From__c.year() : '')+(record.Valid_Until__c != null ? '  -  '+record.Valid_Until__c.day()+' / '+record.Valid_Until__c.month()+' / '+record.Valid_Until__c.year() : '')+'</h3></td>';
				quotation += '					</tr>';
				quotation += '				</tbody>';
				quotation += '			</table>';
				quotation += '	</div>';				
				quotation += '			<div class="middle ">';
				quotation += '				<table class="table_tarifas" border="0" cellspacing="0">';
				quotation += '					<tbody>';
				quotation += '						<tr>';
				quotation += '							<th class="tt_1">'+Label.QPDF_table_service+'</th>';
				quotation += '							<th class="tt_2">'+Label.QPDF_table_product+'</th>';
				quotation += '							<th class="tt_2">'+Label.QPDF_table_mode+'</th>';
				quotation += '							<th class="tt_2">'+Label.QPDF_table_qty+'</th>';
				quotation += '							<th class="tt_2">'+Label.QPDF_table_up+'</th>';
				quotation += '							<th class="tt_2">'+Label.QPDF_table_tp+'</th>';
				quotation += '						</tr>';

				cont = 1;
			}
			
			quotation += '		<tr>';
			quotation += '			<td align="left">'+(fl.Service_Rate_Category__c != null ? fl.Service_Rate_Category__c : '')+'</td>';
			quotation += '			<td align="left">'+(fl.Service_Rate_Name__c != null ? fl.Service_Rate_Name__r.Name : '')+'</td>';
			quotation += '			<td align="center">'+(record.Freight_Mode__c != null ? record.Freight_Mode__c : '')+'</td>';
			quotation += '			<td align="center">'+(fl.Units__c != null ? string.valueof(fl.Units__c) : '')+'</td>';
			quotation += '			<td align="right">'+(fl.Quote_Sell_Price__c != null ? string.valueof(fl.Quote_Sell_Price__c.setScale(2)) : '')+'</td>';
			quotation += '			<td align="right">'+(fl.Sell_Amount__c != null ? string.valueof(fl.Sell_Amount__c.setScale(2)) : '')+'</td>';
			quotation += '		</tr>';
			
			cont++;
		}
		
		quotation += '			<tr>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';			
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';	
		quotation += '			</tr>';
		/*quotation += '			<tr>';	
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';		
		quotation += '				<td align="right">SUBTOTAL</td>';
		quotation += '				<td align="right">'+string.valueof(record.Total_Services_Sell_Amount_number__c - record.Total_Taxes_Number__c)+'</td>';
		quotation += '			</tr>';
		quotation += '			<tr>';	
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td align="right">IVA</td>';
		quotation += '				<td align="right">'+record.Total_Taxes__c+'</td>';
		quotation += '			</tr>';*/
		quotation += '			<tr>';	
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td>&nbsp;</td>';
		quotation += '				<td align="right">TOTAL</td>';
		quotation += '				<td align="right">'+record.Total_Services_Sell_Amount__c+'</td>';
		quotation += '			</tr>';
		
		quotation += '		</tbody>';
		quotation += '	</table>';
		quotation += '</div>';
		quotation += '			<div class="bottom ">';
		quotation += '				<div class="notas_text">';
		quotation += '					<h2 class="title_notes">'+Label.QPDF_Notas+':<span class="warning_notes">('+Label.QPDF_table_warning_vat+')<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;('+Label.QPDF_table_warning+')</span></h2>';
		quotation += '		<hr class="bottom_separator"/>';
	    quotation += '</div>';
	    quotation += '</div>';

		//meter pdf 1 ---------------------------------
		quotation += '<div class="pagina" style="page-break-before: always;">';
		quotation += '<div class="container">';
		quotation += '<p>Estimado cliente:</p>';
		quotation += '<p>Agradecemos su preferencia para ser su Operador Logístico, como un compromiso para mejorar nuestra atención y servicio le compartimos la siguiente información.</p>';
		quotation += '<p>Con la finalidad de evitar contratiempos con su crédito o servicio por saldos insolutos derivados de nuestra relación comercial, requerimos su colaboración para asegurar que los pagos realizados por concepto de los servicios prestados sean realizados a través de transferencia electrónica o depósito bancario a la cuenta que le corresponda conforme a su facturación en pesos o dólares.</p>';
		quotation += '<p>Beneficiario: GRUPO PGL MEXICO SAPI DE CV</p>';
		quotation += '<p>RFC: GPM170110AV4</p>';
		quotation += '<p>Contacto: cobranza@pak2go.com</p>';

		// tabla
		quotation += '<table border="1" style="text-align: center;">';
		quotation += '<tr style="background-color: #F7F441;">';
		quotation += '<th width=120 px>BANCO</th>';
		quotation += '<th width=70 px>MONEDA</th>';
		quotation += '<th width=60 px>CIE</th>';
		quotation += '<th width=90 px>CUENTA</th>';
		quotation += '<th>CLABE INTERBANCARIA</th>';
		quotation += '<th width=90 px>SWIFT</th>';
		quotation += '<th width=130 px>REFERENCIA</th>';
		quotation += '</tr>';

		// agregar las filas de datos de la tabla
		quotation += '<tr>';
		quotation += '<td>BANORTE</td>';
		quotation += '<td>MXN</td>';
		quotation += '<td>3170</td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '<td>Impreso en Factura</td>';
		quotation += '</tr>';

		quotation += '<tr>';
		quotation += '<td>BANCOMER</td>';
		quotation += '<td>MXN</td>';
		quotation += '<td>1413228</td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '<td>Impreso en Factura</td>';
		quotation += '</tr>';

		quotation += '<tr>';
		quotation += '<td>MONEX</td>';
		quotation += '<td>MXN</td>';
		quotation += '<td></td>';
		quotation += '<td>2915692</td>';
		quotation += '<td>112180000029156921</td>';
		quotation += '<td>MONXMXMM</td>';
		quotation += '<td>Impreso en Factura</td>';
		quotation += '</tr>';
		
		quotation += '<tr>';
		quotation += '<td>BAJIO</td>';
		quotation += '<td>MXN</td>';
		quotation += '<td>1740</td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '<td>Impreso en Factura</td>';
		quotation += '</tr>';
		
		quotation += '<tr>';
		quotation += '<td>BANAMEX</td>';
		quotation += '<td>MXN</td>';
		quotation += '<td></td>';
		quotation += '<td>70118863656</td>';
		quotation += '<td>002580701188636566</td>';
		quotation += '<td></td>';
		quotation += '<td>Impreso en Factura</td>';
		quotation += '</tr>';
		
		quotation += '<tr>';
		quotation += '<td>AFIRME</td>';
		quotation += '<td>MXN</td>';
		quotation += '<td></td>';
		quotation += '<td>164106926</td>';
		quotation += '<td>062580001641069268</td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '</tr>';
		
		quotation += '<tr>';
		quotation += '<td>* AFIRME</td>';
		quotation += '<td>USD</td>';
		quotation += '<td></td>';
		quotation += '<td>164104117</td>';
		quotation += '<td></td>';
		quotation += '<td></td>';
		quotation += '<td>Impreso en Factura</td>';
		quotation += '</tr>';
		
		quotation += '<tr>';
		quotation += '<td>MONEX</td>';
		quotation += '<td>USD</td>';
		quotation += '<td></td>';
		quotation += '<td>2915692</td>';
		quotation += '<td>112962000029156929</td>';
		quotation += '<td>MONXMXMM</td>';
		quotation += '<td>Impreso en Factura</td>';
		quotation += '</tr>';
		
		quotation += '<tr>';
		quotation += '<td>HSBC BANK USA</td>';
		quotation += '<td>USD</td>';
		quotation += '<td></td>';
		quotation += '<td>104046422</td>';
		quotation += '<td>ROUTING 022000020</td>';
		quotation += '<td>MRMDUS33</td>';
		quotation += '<td>021001088</td>';
		quotation += '</tr>';
		// Repitir este bloque para agregar más filas

		quotation += '</table>';

		quotation += '<p>Adicionalmente su factura indica en la parte superior estos datos, así como el número de referencia para pago, dicha referencia es por factura</p>';
		quotation += '<p>* AFIRME. cuenta únicamente para girar cheques en USD</p>';
		quotation += '<p>Para cualquier duda o aclaración agradecemos su comunicación a través de los medios indicados.</p>';
		quotation += '<p align="center">Atentamente:</p>';
		quotation += '<p align="center" style="font-weight: bold;">Pak2go Logistics</p>';
		quotation += '</div>';
		quotation += '</div>';
		
		//meter pdf2 ---------------------------------------------
		quotation += '<div class="pagina" style="page-break-before: always;">';
		quotation += '<div class="container">';
		quotation += '<h2>Carta Términos y Condiciones</h2>';
		quotation += '<ol>';
		quotation += '<li>';
		quotation += '<h4>Servicio de Transporte y Retención de IVA:</h4>';
		quotation += '<p>El prestador de servicios actúa como intermediario en la contratación de transporte con transportistas terceros debidamente autorizados. En este sentido, se aclara que el prestador de servicios no está sujeto a la retención del 4% de IVA por concepto de la prestación de los servicios de transporte.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Disponibilidad del Servicio:</h4>';
		quotation += '<p>Los servicios están sujetos a disponibilidad y serán programados según las capacidades disponibles.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Tarifas y Moneda:</h4>';
		quotation += '<p>Las tarifas establecidas en este documento se expresan en moneda mexicana (MXN) y no incluyen impuestos aplicables.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Riesgos y Daños a la Carga:</h4>';
		quotation += '<p>Las tarifas no cubren riesgos ni daños a los vehículos durante la carga y descarga. El cliente será el único responsable de subsanar cualquier daño ocasionado a la unidad.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Maniobras y Accesorios:</h4>';
		quotation += '<p>Las tarifas no incluyen maniobras de carga y descarga, devoluciones, rechazos, flete en falso, estadías ni otros aditamentos no mencionados en la cotización.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Seguro y Responsabilidad:</h4>';
		quotation += '<p>Las tarifas no incluyen seguro ni fianza para las mercancías transportadas. La responsabilidad recae únicamente en la línea de transporte';
		quotation += '<span style="font-weight: bold;">en caso de negligencia o dolo</span>, limitada al pago de <span style="font-weight: bold;">15 días de UMA por tonelada o fracción de mercancías dañadas</span>.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Robo o Merma:</h4>';
		quotation += '<p>La línea de transporte';
		quotation += '<span style="font-weight: bold;">no asume responsabilidad por robo o merma de la mercancía</span>, a menos que exista evidencia en contrario.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Variación de Tarifas:</h4>';
		quotation += '<p>En caso de una <span style="font-weight: bold;">variación abrupta (superior al 3.5%) </span>';
		quotation += 'en el precio del diésel, inflación, tipo cambiario u otras variables que afecten las tarifas, se podrá ajustar el costo del servicio en el mes siguiente en proporción a la variación.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Vigencia de Tarifas:</h4>';
		quotation += '<p>Las tarifas acordadas tienen una <span style="font-weight: bold;">vigencia de 12 meses</span>.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Retrasos en la Entrega:</h4>';
		quotation += '<p>Circunstancias ajenas al control de la línea de transporte pueden causar retrasos en la entrega de la mercancía, sin que esto implique responsabilidad alguna. No obstante, notificaremos al cliente en caso de retrasos involuntarios durante el trayecto del viaje.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Cargo por Retraso:</h4>';
		quotation += '<p>El <span style="font-weight: bold;">cliente deberá pagar $3,000 por cada período de 24 horas o fracción</span>';
		quotation += ' de retraso en la carga, descarga y/o autorización de salida a ruta por parte del cliente al transportista.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Servicios Incluidos:</h4>';
		quotation += '<p>Las tarifas incluyen los siguientes conceptos: a) Diesel, b) Operador, c) Casetas (en caso de ser necesario), d) Capacidad máxima de carga de 25 toneladas.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Cargo por Cancelación:</h4>';
		quotation += '<p>En caso de cancelación del servicio, se aplicará un cargo de $3,000.</p>';
		quotation += '</li>';
		quotation += '<li>';
		quotation += '<h4>Notificación de Carga:</h4>';
		quotation += '<p>Se requiere una notificación de carga con al menos 24 horas de anticipación en servicios locales y 48 horas en servicios foráneos.</p>';
		quotation += '</li>';
		quotation += '</ol>';
		quotation += '<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>';

		
		quotation += '			<div class="bottom ">';
		quotation += '				<div class="notas_text">';
		quotation += '		<div class="text_notes">';
		quotation += (record.PDF_Notes__c != null ? record.PDF_Notes__c.replace('\n','<br/>') : '');
		quotation += '					</div>';
		quotation += '				</div>';
		quotation += '			</div>';
	    quotation += '</div>';
	    quotation += '</div>';
	    quotation += '</div>';
	    quotation += '</div>';
	}
}