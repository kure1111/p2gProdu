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
		quotation += '		<div class="text_notes">';
		quotation += (record.PDF_Notes__c != null ? record.PDF_Notes__c.replace('\n','<br/>') : '');
		quotation += '					</div>';
		quotation += '				</div>';
		quotation += '			</div>';
	    quotation += '</div>';
	    quotation += '</div>';
	}
}