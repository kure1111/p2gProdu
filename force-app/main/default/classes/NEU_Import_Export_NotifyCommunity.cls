public with sharing class NEU_Import_Export_NotifyCommunity
{
	public Customer_Quote__c record;
	
	ApexPages.StandardController con;
	
    public NEU_Import_Export_NotifyCommunity(ApexPages.StandardController stdController)
    {
		con = stdController;

		try 
		{ 
			record = [SELECT Id, Name, Community_Status__c, Contact__c, Contact__r.Email FROM Customer_Quote__c WHERE Id =: con.getRecord().Id];
        } catch( Exception ee) { 
			record = new Customer_Quote__c();
		}    	
    }
    
    public PageReference notificar()
    {
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
		cuerpo_notificacion += '				<h3>Quotation Updated</h3>';
        cuerpo_notificacion += '				<p>The Import-Export <a href="https://pak2gologistics.force.com/customers/s/customer-quote/'+NEU_Utils.safeString(record.Id)+'">'+NEU_Utils.safeString(record.Name)+'</a> has been completed by the Pak2Go executive, please, review the details.</p>';
		cuerpo_notificacion += '			</td>';
		cuerpo_notificacion += '		</tr>';
		cuerpo_notificacion += '	</table>';
		cuerpo_notificacion += '</center>';
		cuerpo_notificacion += '<br/>';

		String[] receptores = new String[]{};
		if(record.Contact__c != null && record.Contact__r.Email != null)
			receptores.add(record.Contact__r.Email);
		
		if(receptores.size() > 0)
		{
			List<Messaging.Email> allMails = new List<Messaging.Email>();
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(receptores);
	        mail.setSenderDisplayName('PAK2GO');
	        mail.setSubject('Import-Export updated from Pak2Go: ' + record.Name);
	        mail.setUseSignature(false); 
	        mail.setCharset('UTF-8');
	        mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(cuerpo_notificacion != null ? cuerpo_notificacion.replace('\n','<br/>') : '')+firma+'</body></html>');
	        allMails.add(mail);
	
	        try
	        {
	        	//if(![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox && !Test.isRunningTest())
	        	//{
	            	Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);	        		
	        	//}
	        }
	        catch(Exception ex) {}
		}
		
		try
        {
            record.Community_Status__c = 'COMPLETED BY PAK2GO';
            update record;
        }
        catch(Exception ex) {}
        
        return new PageReference('/'+record.Id);		            	
    }    
}