public with sharing class NEU_Import_Export_Controller
{
    @AuraEnabled
    public static Customer_Quote__c getImportExport(Id recordId) 
    {
        return [SELECT Id, Name, Service_Type__c, Community_Status__c FROM Customer_Quote__c WHERE Id = :recordId][0];
    }
    
    @AuraEnabled
    public static string getImportExportNotes(Id recordId) 
    {
        return [SELECT Id, Observations__c FROM Customer_Quote__c WHERE Id = :recordId][0].Observations__c;
    }    
    
    @AuraEnabled
    public static List<Quote_Item_Line__c> getLines(Id recordId) 
    {
        return [SELECT Id, Name, Item_Name__r.Name, Extension_Item_Name__c, Units__c, Container_Type__r.Name,
        Item_Name__r.Master_Box_Packing_Weight_kg__c, Import_Export_Quote__r.Service_Type__c,
        Total_Shipping_Weight_Kgs__c FROM Quote_Item_Line__c WHERE Import_Export_Quote__c = :recordId ORDER BY Name ASC];
    }
    
    public class Import_Export_Cargo_Line_s
    {
        @AuraEnabled
        public Quote_Item_Line__c cargo_line {get;set;}
        @AuraEnabled
        public Sourcing_Item__c item {get;set;}
        @AuraEnabled
        public string shipment_type {get;set;}   
    } 

    @AuraEnabled
    public static Import_Export_Cargo_Line_s initializeCargoLine(id recordId) 
    {
        Import_Export_Cargo_Line_s new_ie_cargo_line_s = new Import_Export_Cargo_Line_s();
        
        new_ie_cargo_line_s.cargo_line = new Quote_Item_Line__c();
        new_ie_cargo_line_s.cargo_line.Name = ('000' + ([SELECT Id FROM Quote_Item_Line__c WHERE Import_Export_Quote__c = :recordId].size() + 1)).right(3);
        new_ie_cargo_line_s.item = new Sourcing_Item__c();
        
        if(String.isNotEmpty(recordId))
        {
            Customer_Quote__c query_ie = [SELECT Id, Name, Service_Type__c, Account_for__c 
                                          FROM Customer_Quote__c WHERE Id =: recordId LIMIT 1];
                                          
            new_ie_cargo_line_s.cargo_line.Import_Export_Quote__c = recordId;
            
            if(query_ie != null  && query_ie.Service_Type__c != null)
            {
                new_ie_cargo_line_s.shipment_type = query_ie.Service_Type__c;
            }
        }
        
        return new_ie_cargo_line_s;
    }   
    
    @AuraEnabled
    public static void saveCargoLine(string serializedCargoLine, string recordId, string conType) 
    {
       if(String.isNotEmpty(serializedCargoLine) && String.isNotEmpty(recordId))
       {
            Import_Export_Cargo_Line_s new_record = new Import_Export_Cargo_Line_s();  
            serializedCargoLine = neu_utils.deserialize(serializedCargoLine);
            new_record = (NEU_Import_Export_Controller.Import_Export_Cargo_Line_s) System.JSON.deserialize(serializedCargoLine, NEU_Import_Export_Controller.Import_Export_Cargo_Line_s.class);
           
            Quote_Item_Line__c qil = new Quote_Item_Line__c();
            qil.Name = new_record.cargo_line.Name;
            if(conType != '')
            {
                List<Container_Type__c> cts = [Select Id from Container_Type__c where Id = :conType];
                if(cts != null && cts.size()>0)
                {
                    qil.Container_Type__c = cts[0].Id;                  
                }
            }
            
            qil.Total_Shipping_Weight_Kgs__c = neu_utils.safedecimal(new_record.cargo_line.Total_Shipping_Weight_Kgs__c);
            qil.Total_Shipping_Volume_m3__c = neu_utils.safedecimal(new_record.cargo_line.Total_Shipping_Volume_m3__c);
            qil.Extension_Item_Name__c = new_record.cargo_line.Extension_Item_Name__c;
            qil.Units__c =  neu_utils.safedecimal(new_record.cargo_line.Units__c);
            qil.Import_Export_Quote__c = recordId;
            qil.Price__c = neu_utils.safedecimal(new_record.cargo_line.Price__c);
            NEU_CurrencyUtils.setCurrencyIsoCode(qil, new_record.cargo_line.CurrencyIsoCode);
            
            Sourcing_Item__c sit = new Sourcing_Item__c();
            sit.Name = new_record.item.Name;
            sit.Units_x_Master_Box__c = 1;
            Customer_Quote__c query_ie = [SELECT Id, Name, Service_Type__c, Account_for__c FROM Customer_Quote__c WHERE Id =: recordId LIMIT 1];
            
            if(query_ie != null && query_ie.Account_for__c != null)
            {
                sit.Account_Owner__c = query_ie.Account_for__c;
            }
            
            sit.Item_Price__c = neu_utils.safedecimal(new_record.cargo_line.Price__c);     
            NEU_CurrencyUtils.setCurrencyIsoCode(sit, new_record.cargo_line.CurrencyIsoCode);
            
            sit.Weight_Kgs__c = (neu_utils.safedecimal(new_record.cargo_line.Units__c) != 0 && neu_utils.safedecimal(new_record.cargo_line.Total_Shipping_Weight_Kgs__c) != 0 ? neu_utils.safedecimal(new_record.cargo_line.Total_Shipping_Weight_Kgs__c) / neu_utils.safedecimal(new_record.cargo_line.Units__c) : neu_utils.safedecimal(new_record.cargo_line.Total_Shipping_Weight_Kgs__c));
            sit.Master_Box_Packing_Weight_kg__c = neu_utils.safedecimal(new_record.item.Master_Box_Packing_Weight_kg__c);
            sit.Unit_of_measure__c = 'Unit';
            sit.Master_Box_Width_cm__c = neu_utils.safedecimal(new_record.item.Master_Box_Width_cm__c);
            sit.Master_Box_Height_cm__c = neu_utils.safedecimal(new_record.item.Master_Box_Height_cm__c) ;
            sit.Master_Box_Length_cm__c = neu_utils.safedecimal(new_record.item.Master_Box_Length_cm__c);
            sit.Freight_Class__c = new_record.item.Freight_Class__c ;
            
            try
            {
                insert sit;
                qil.Item_Name__c = sit.Id;
                insert qil;
            }
            catch(Exception ex)
            {
                throw new AuraHandledException('Exception: '+ ex.getMessage()); 
            }
        }
    }

    @AuraEnabled
    public static List<Quote_Item_Line__c> deleteCargoLine(Id recordId, Id importExportId) 
    {
        try
        {
            Quote_Item_Line__c line = [SELECT Id FROM Quote_Item_Line__c WHERE Id = :recordId][0];
            delete line;
            
            return [SELECT Id, Name, Item_Name__r.Name, Extension_Item_Name__c, Units__c, Container_Type__r.Name,
            Item_Name__r.Master_Box_Packing_Weight_kg__c, Total_Shipping_Weight_Kgs__c 
            FROM Quote_Item_Line__c WHERE Import_Export_Quote__c = :importExportId];
        }
        catch(Exception ex)
        {
            throw new AuraHandledException('Exception: '+ ex.getMessage()); 
        }       
    }
    
    @AuraEnabled
    public static List<String> getCurrencyOptions()
    {
        List<String>result=new List<String>();
        if(UserInfo.isMultiCurrencyOrganization())
        { 
            result.add(UserInfo.getDefaultCurrency());
            for(SObject c:database.query('select IsoCode from CurrencyType where IsActive = true'))
            {
                if((String)c.get('IsoCode') != UserInfo.getDefaultCurrency())
                {
                    result.add((String)c.get('IsoCode'));   
                }   
            }
        }
        else
        {
            result.add(UserInfo.getDefaultCurrency());
        }
        return result;
    }      
 
    @AuraEnabled
    public static void sendToPak2Go(string recordId)
    {
        List<Customer_Quote__c> ie = [SELECT Id, Name, Account_for__r.Name, Account_for__r.Account_Executive_User__c, Account_for__r.Account_Executive_User__r.Email,
                                      Freight_Mode__c, Service_Type__c, POD_Incoterm__c, Origin_Address__c, Destination_Address__c,
                                      CurrencyIsoCode, Delivery_Date__c, Service_Mode__c, Quotation_Status__c,
                                      Community_Status__c, Observations__c, Move_Type__c, Route__r.Name, Account_for__r.Sales_Executive_Email__c
                                      FROM Customer_Quote__c WHERE Id = :recordId];
        
        List<Quote_Item_Line__c> cargo_lines = [SELECT Id, Name, Item_Name__r.Name, Extension_Item_Name__c, 
                                                Units__c, Packaging_Length_cm__c, Packaging_Width_cm__c,
                                                Packaging_Height_cm__c, Packaging_Volume_m3__c, Amount__c,
                                                Total_Shipping_Volume_m3__c, Packaging_Weight_kg__c,
                                                Total_Shipping_Weight_Kgs__c FROM Quote_Item_Line__c WHERE Import_Export_Quote__c = :ie[0].Id];
      
        string estilo_email = '';
        estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += 'p{margin: 0 0 2px 10px; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += '.user_name{font-weight:bold; color:#505050;}';
		estilo_email += '.user_puesto{font-size:11px; color:#505050;}';
		estilo_email += '.user_division{font-size:11px; color:#929292;}';
		estilo_email += '.user_telefono{font-size:11px; color:#929292;}';
		estilo_email += '.user_address{font-size:11px; color:#929292;}';
		estilo_email += '.logo_td{border-right:1px solid #000000;}';
		estilo_email += '.company_logo{margin-right:10px;}';
		estilo_email += '#container{width:549px; margin:10px auto 10px auto; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += '#header_email{width:549px; border-bottom: 3px solid #000000; padding:0 0 10px 0; text-align:center;}';
		estilo_email += '#footer_email{border-top: 3px solid #ff0000; width:549px; display: inline-block; color: rgb(115, 114, 114); font-size: 8px; text-align: justify;}';
		estilo_email += '.inner_table{width:100%;}';
		estilo_email += '.inner_table th{border:1px solid; text-align:left;}';
		estilo_email += '.inner_table td{border:1px solid;}';
        
        List<User> user_loged = [select Id, Name, FirstName, LastName, Title, Division, Phone, MobilePhone, Street from User where Id =: UserInfo.getUserId()];
        
        string firma = '';
        if(user_loged.size() > 0)
        {
	        firma += '<br/>';
			firma += '<table>';
			firma += '	<tr>';
			firma += '		<td><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a4CS&oid=00D0Y0000033Ye1&lastMod=1527504712000" class="company_logo"/></td>';
			firma += '		<td></td>';
			firma += '		<td class="logo_td"></td>';
			firma += '		<td>';
			firma += '			<p class="user_name">'+user_loged[0].FirstName+' '+user_loged[0].LastName+'</p>';
			firma += '			<p class="user_puesto">'+(user_loged[0].Title != null ? user_loged[0].Title : '')+'</p>';
			firma += '			<p class="user_division">'+(user_loged[0].Division != null ? user_loged[0].Division : '')+'</p>';
			firma += '			<p class="user_telefono">Tel: '+(user_loged[0].Phone != null ? user_loged[0].Phone : '')+', Móvil: '+(user_loged[0].MobilePhone != null ? user_loged[0].MobilePhone : '')+'</p>';
			firma += '			<p class="user_address">'+(user_loged[0].Street != null ? user_loged[0].Street : '')+'</p>';
			firma += '		</td>';
			firma += '	</tr>';
			firma += '</table>';
        }
        
        string cuerpo_notificacion = '';
        
        cuerpo_notificacion += '<center>';
		cuerpo_notificacion += '	<table border="0" cellpadding="0" cellspacing="0" id="container">';
		cuerpo_notificacion += '		<tr>';
		cuerpo_notificacion += '			<td>';
		cuerpo_notificacion += '				<div id="header_email">';
		cuerpo_notificacion += '					<img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a4CN&oid=00D0Y0000033Ye1&lastMod=1527504695000"/>';
		cuerpo_notificacion += '				</div>';
		cuerpo_notificacion += '			</td>';
		cuerpo_notificacion += '		</tr>';
		cuerpo_notificacion += '		<tr>';
		cuerpo_notificacion += '			<td>';
		cuerpo_notificacion += '				<h3>Quotation Request</h3>';
        cuerpo_notificacion += '				<p>The following Quotation Request has been sent from the Community.</p>';
        cuerpo_notificacion += '				<br/>';
        cuerpo_notificacion += '				<h3><a href="https://pak2go.my.salesforce.com/'+NEU_Utils.safeString(ie[0].Id)+'">'+NEU_Utils.safeString(ie[0].Name)+'</a></h3>';
        cuerpo_notificacion += '				<br/>';
        cuerpo_notificacion += '				<h3>Import-Export details: </h3>';
        cuerpo_notificacion += '				<table class="inner_table">';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Import-Export:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Name)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Account for (Customer):</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Account_for__r.Name)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Quotation Status:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Quotation_Status__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Observations:</th>';
        cuerpo_notificacion += '           				<td>'+NEU_Utils.safeString(ie[0].Observations__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';                 
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>ETA:</th>';
        cuerpo_notificacion += '            			<td>'+(ie[0].Delivery_Date__c != null ? ie[0].Delivery_Date__c.format() : '')+'</td>';
        cuerpo_notificacion += '       			 	</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Freight Mode:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Freight_Mode__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Service Mode:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Service_Mode__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Shipment Type:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Service_Type__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';         
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Incoterm:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].POD_Incoterm__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Delivery Terms:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Move_Type__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Route:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Route__r.Name)+'</td>';
        cuerpo_notificacion += '        			</tr>';             
        cuerpo_notificacion += '       		 		<tr>';
        cuerpo_notificacion += '            			<th>Origin Address:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Origin_Address__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Destination Address:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].Destination_Address__c)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th>Currency:</th>';
        cuerpo_notificacion += '            			<td>'+NEU_Utils.safeString(ie[0].CurrencyIsoCode)+'</td>';
        cuerpo_notificacion += '        			</tr>';
        cuerpo_notificacion += '				</table>';
        cuerpo_notificacion += '				<br/>';
        cuerpo_notificacion += '				<h3>Import-Export Cargo Lines: </h3>';
        cuerpo_notificacion += '				<table class="inner_table">';
        cuerpo_notificacion += '        			<tr>';
        cuerpo_notificacion += '            			<th width="20%">Line</th>';
        cuerpo_notificacion += '            			<th width="20%">Cargo</th>';
        cuerpo_notificacion += '            			<th width="20%">Units</th>';
        cuerpo_notificacion += '            			<th width="20%">Total Shipping Volume (m3)</th>';
        cuerpo_notificacion += '            			<th width="20%">Total Shipping Weight (Kgs)</th>';
        cuerpo_notificacion += '        			</tr>';
        
        for(Quote_Item_Line__c line : cargo_lines)
        {
            cuerpo_notificacion += '<tr>';
            cuerpo_notificacion += '    <td>'+NEU_Utils.safeString(line.Name)+'</td>';
            cuerpo_notificacion += '    <td>'+NEU_Utils.safeString(line.Item_Name__r.Name)+'</td>';
            cuerpo_notificacion += '    <td align="right">'+NEU_Utils.safeString(line.Units__c)+'</td>';
            cuerpo_notificacion += '    <td align="right">'+NEU_Utils.safeString(line.Total_Shipping_Volume_m3__c)+'</td>';
            cuerpo_notificacion += '    <td align="right">'+NEU_Utils.safeString(line.Total_Shipping_Weight_Kgs__c)+'</td>';
            cuerpo_notificacion += '</tr>';                         
        }
        
        cuerpo_notificacion += '				</table>'; 
		cuerpo_notificacion += '			</td>';
		cuerpo_notificacion += '		</tr>';
		cuerpo_notificacion += '	</table>';
		cuerpo_notificacion += '</center>';
		cuerpo_notificacion += '<br/>';

        String[] receptores = new String[]{};
        
        // Notificaciones obligatorias:
        //if(ie[0].Account_for__c != null && ie[0].Account_for__r.Account_Executive_User__c != null && ie[0].Account_for__r.Account_Executive_User__r.Email != null)
        if(ie[0].Account_for__c != null && ie[0].Account_for__r.Sales_Executive_Email__c != null)
            receptores.add(ie[0].Account_for__r.Sales_Executive_Email__c);
        
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        if(receptores.size() > 0)
        {
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(receptores);
	        mail.setSenderDisplayName('PAK2GO');
	        mail.setSubject('Import-Export created from Community: ' + ie[0].Name);
	        mail.setUseSignature(false); 
	        mail.setCharset('UTF-8');
	        mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+cuerpo_notificacion+firma+'</body></html>');
	        allMails.add(mail);
        }
        
        try
        {
            //if(![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox && !Test.isRunningTest())
            //{
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);                    
            //}
            
            ie[0].Community_Status__c = 'SENT TO PAK2GO';
            update ie;
        }
        catch(Exception ex)
        {
            throw new AuraHandledException('Exception: '+ ex.getMessage());             
        }       
    }
    
    @AuraEnabled
    public static void confirmToPak2Go(string recordId)
    {
        List<Customer_Quote__c> ie = [SELECT Id, Name, Community_Status__c, Account_for__r.Account_Executive_User__c, Account_for__r.Account_Executive_User__r.Email,
		Account_for__r.Sales_Executive_Email__c
		FROM Customer_Quote__c WHERE Id = :recordId];
        
        string estilo_email = '';
        estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += 'p{margin: 0 0 2px 10px; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += '.user_name{font-weight:bold; color:#505050;}';
		estilo_email += '.user_puesto{font-size:11px; color:#505050;}';
		estilo_email += '.user_division{font-size:11px; color:#929292;}';
		estilo_email += '.user_telefono{font-size:11px; color:#929292;}';
		estilo_email += '.user_address{font-size:11px; color:#929292;}';
		estilo_email += '.logo_td{border-right:1px solid #000000;}';
		estilo_email += '.company_logo{margin-right:10px;}';
		estilo_email += '#container{width:549px; margin:10px auto 10px auto; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += '#header_email{width:549px; border-bottom: 3px solid #000000; padding:0 0 10px 0; text-align:center;}';
		estilo_email += '#footer_email{border-top: 3px solid #ff0000; width:549px; display: inline-block; color: rgb(115, 114, 114); font-size: 8px; text-align: justify;}';
		estilo_email += '.inner_table{width:100%;}';
		estilo_email += '.inner_table th{border:1px solid; text-align:left;}';
		estilo_email += '.inner_table td{border:1px solid;}';
        
        List<User> user_loged = [select Id, Name, FirstName, LastName, Title, Division, Phone, MobilePhone, Street from User where Id =: UserInfo.getUserId()];
        
        string firma = '';
        if(user_loged.size() > 0)
        {
	        firma += '<br/>';
			firma += '<table>';
			firma += '	<tr>';
			firma += '		<td><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a4CS&oid=00D0Y0000033Ye1&lastMod=1527504712000" class="company_logo"/></td>';
			firma += '		<td></td>';
			firma += '		<td class="logo_td"></td>';
			firma += '		<td>';
			firma += '			<p class="user_name">'+user_loged[0].FirstName+' '+user_loged[0].LastName+'</p>';
			firma += '			<p class="user_puesto">'+(user_loged[0].Title != null ? user_loged[0].Title : '')+'</p>';
			firma += '			<p class="user_division">'+(user_loged[0].Division != null ? user_loged[0].Division : '')+'</p>';
			firma += '			<p class="user_telefono">Tel: '+(user_loged[0].Phone != null ? user_loged[0].Phone : '')+', Móvil: '+(user_loged[0].MobilePhone != null ? user_loged[0].MobilePhone : '')+'</p>';
			firma += '			<p class="user_address">'+(user_loged[0].Street != null ? user_loged[0].Street : '')+'</p>';
			firma += '		</td>';
			firma += '	</tr>';
			firma += '</table>';
        }
        
        string cuerpo_notificacion = '';
        
        cuerpo_notificacion += '<center>';
		cuerpo_notificacion += '	<table border="0" cellpadding="0" cellspacing="0" id="container">';
		cuerpo_notificacion += '		<tr>';
		cuerpo_notificacion += '			<td>';
		cuerpo_notificacion += '				<div id="header_email">';
		cuerpo_notificacion += '					<img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a4CN&oid=00D0Y0000033Ye1&lastMod=1527504695000"/>';
		cuerpo_notificacion += '				</div>';
		cuerpo_notificacion += '			</td>';
		cuerpo_notificacion += '		</tr>';
		cuerpo_notificacion += '		<tr>';
		cuerpo_notificacion += '			<td>';
		cuerpo_notificacion += '				<h3>Quotation Request</h3>';
        cuerpo_notificacion += '				<p>The Import-Export <a href="https://pak2go.my.salesforce.com/'+NEU_Utils.safeString(ie[0].Id)+'">'+NEU_Utils.safeString(ie[0].Name)+'</a> has been confirmed from the Community.</p>';
		cuerpo_notificacion += '			</td>';
		cuerpo_notificacion += '		</tr>';
		cuerpo_notificacion += '	</table>';
		cuerpo_notificacion += '</center>';
		cuerpo_notificacion += '<br/>';
        
        String[] receptores = new String[]{};
        
        // Notificaciones obligatorias:
        //if(ie[0].Account_for__c != null && ie[0].Account_for__r.Account_Executive_User__c != null && ie[0].Account_for__r.Account_Executive_User__r.Email != null)
        if(ie[0].Account_for__c != null && ie[0].Account_for__r.Sales_Executive_Email__c != null)
            receptores.add(ie[0].Account_for__r.Sales_Executive_Email__c);
        
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        if(receptores.size() > 0)
        {
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(receptores);
	        mail.setSenderDisplayName('PAK2GO');
	        mail.setSubject('Import-Export confirmed from Community: ' + ie[0].Name);
	        mail.setUseSignature(false); 
	        mail.setCharset('UTF-8');
	        mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+cuerpo_notificacion+firma+'</body></html>');
	        allMails.add(mail);
        }

        try
        {
            //if(![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox && !Test.isRunningTest())
            //{
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);                    
            //}
            
            ie[0].Community_Status__c = 'CONFIRMED';
            update ie;
        }
        catch(Exception ex)
        {
            throw new AuraHandledException('Exception: '+ ex.getMessage());             
        }       
    } 

    @AuraEnabled
    public static void rejectQuote(string recordId, string reasons)
    {
        List<Customer_Quote__c> ie = [SELECT Id, Name, Community_Status__c, Account_for__r.Account_Executive_User__c, Account_for__r.Account_Executive_User__r.Email,
        Account_for__r.Sales_Executive_Email__c
		FROM Customer_Quote__c WHERE Id = :recordId];
        
        string estilo_email = '';
        estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += 'p{margin: 0 0 2px 10px; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += '.user_name{font-weight:bold; color:#505050;}';
		estilo_email += '.user_puesto{font-size:11px; color:#505050;}';
		estilo_email += '.user_division{font-size:11px; color:#929292;}';
		estilo_email += '.user_telefono{font-size:11px; color:#929292;}';
		estilo_email += '.user_address{font-size:11px; color:#929292;}';
		estilo_email += '.logo_td{border-right:1px solid #000000;}';
		estilo_email += '.company_logo{margin-right:10px;}';
		estilo_email += '#container{width:549px; margin:10px auto 10px auto; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
		estilo_email += '#header_email{width:549px; border-bottom: 3px solid #000000; padding:0 0 10px 0; text-align:center;}';
		estilo_email += '#footer_email{border-top: 3px solid #ff0000; width:549px; display: inline-block; color: rgb(115, 114, 114); font-size: 8px; text-align: justify;}';
		estilo_email += '.inner_table{width:100%;}';
		estilo_email += '.inner_table th{border:1px solid; text-align:left;}';
		estilo_email += '.inner_table td{border:1px solid;}';
        
        List<User> user_loged = [select Id, Name, FirstName, LastName, Title, Division, Phone, MobilePhone, Street from User where Id =: UserInfo.getUserId()];
        
        string firma = '';
        if(user_loged.size() > 0)
        {
	        firma += '<br/>';
			firma += '<table>';
			firma += '	<tr>';
			firma += '		<td><img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a4CS&oid=00D0Y0000033Ye1&lastMod=1527504712000" class="company_logo"/></td>';
			firma += '		<td></td>';
			firma += '		<td class="logo_td"></td>';
			firma += '		<td>';
			firma += '			<p class="user_name">'+user_loged[0].FirstName+' '+user_loged[0].LastName+'</p>';
			firma += '			<p class="user_puesto">'+(user_loged[0].Title != null ? user_loged[0].Title : '')+'</p>';
			firma += '			<p class="user_division">'+(user_loged[0].Division != null ? user_loged[0].Division : '')+'</p>';
			firma += '			<p class="user_telefono">Tel: '+(user_loged[0].Phone != null ? user_loged[0].Phone : '')+', Móvil: '+(user_loged[0].MobilePhone != null ? user_loged[0].MobilePhone : '')+'</p>';
			firma += '			<p class="user_address">'+(user_loged[0].Street != null ? user_loged[0].Street : '')+'</p>';
			firma += '		</td>';
			firma += '	</tr>';
			firma += '</table>';
        }
        
        string cuerpo_notificacion = '';
        
        cuerpo_notificacion += '<center>';
		cuerpo_notificacion += '	<table border="0" cellpadding="0" cellspacing="0" id="container">';
		cuerpo_notificacion += '		<tr>';
		cuerpo_notificacion += '			<td>';
		cuerpo_notificacion += '				<div id="header_email">';
		cuerpo_notificacion += '					<img src="https://pak2go--c.eu11.content.force.com/servlet/servlet.ImageServer?id=0150Y000002a4CN&oid=00D0Y0000033Ye1&lastMod=1527504695000"/>';
		cuerpo_notificacion += '				</div>';
		cuerpo_notificacion += '			</td>';
		cuerpo_notificacion += '		</tr>';
		cuerpo_notificacion += '		<tr>';
		cuerpo_notificacion += '			<td>';
		cuerpo_notificacion += '				<h3>Quotation Request Rejected</h3>';
        cuerpo_notificacion += '				<p>The Import-Export <a href="https://pak2go.my.salesforce.com/'+NEU_Utils.safeString(ie[0].Id)+'">'+NEU_Utils.safeString(ie[0].Name)+'</a> has been rejected from the Community with the following reasons:</p>';
    	cuerpo_notificacion += '				<p>'+NEU_Utils.safeString(reasons)+'</p>';
		cuerpo_notificacion += '			</td>';
		cuerpo_notificacion += '		</tr>';
		cuerpo_notificacion += '	</table>';
		cuerpo_notificacion += '</center>';
		cuerpo_notificacion += '<br/>';

        String[] receptores = new String[]{};
        
        // Notificaciones obligatorias:
        //if(ie[0].Account_for__c != null && ie[0].Account_for__r.Account_Executive_User__c != null && ie[0].Account_for__r.Account_Executive_User__r.Email != null)
        if(ie[0].Account_for__c != null && ie[0].Account_for__r.Sales_Executive_Email__c != null)
            receptores.add(ie[0].Account_for__r.Sales_Executive_Email__c);
        
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        if(receptores.size() > 0)
        {
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(receptores);
	        mail.setSenderDisplayName('PAK2GO');
	        mail.setSubject('Import-Export rejected from Community: ' + ie[0].Name);
	        mail.setUseSignature(false); 
	        mail.setCharset('UTF-8');
	        mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+firma+'</body></html>');
	        allMails.add(mail);
        }

        try
        {
            //if(![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox && !Test.isRunningTest())
            //{
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);                    
            //}
            
            ie[0].Rejection_Reasons__c = reasons;
            ie[0].Community_Status__c = 'REJECTED';
            update ie;
        }
        catch(Exception ex)
        {
            throw new AuraHandledException('Exception: '+ ex.getMessage());             
        }       
    }
    
    @AuraEnabled
    public static Boolean getPending(string status) 
    {
        return ([SELECT Id FROM Customer_Quote__c WHERE Community_Status__c = :status].size() > 0 ? true : false);
    }
    @AuraEnabled
    public static List<Customer_Quote__c> getImportExportsByStatus(string status) 
    {
        return [SELECT Id, Name FROM Customer_Quote__c WHERE Community_Status__c = :status];
    }                   
}