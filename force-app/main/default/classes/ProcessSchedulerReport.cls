global class ProcessSchedulerReport implements Schedulable {
    global void execute(SchedulableContext ctx) {

        string jobId = '';
        List<CronTrigger> listCronTrigger = new List<CronTrigger>();
        listCronTrigger = [SELECT Id FROM CronTrigger WHERE Id = :ctx.getTriggerId()];
        if(listCronTrigger.size() > 0) {
            jobId = listCronTrigger[0].Id;
            jobId = jobId.substring(0,15);
        }

        List<Scheduler_Shipment_Services_Lines__c> sr = [SELECT Id, Name,Document_Name__c, Cron_Job_Id__c,Historical_Time__c, Contact_Emails_Sent__c, Processed__c, Sender_Name__c, Cc_email__c, CCO_email__c, Subject_mail__c, Body_mail__c, Email_Template__c FROM Scheduler_Shipment_Services_Lines__c WHERE Cron_Job_Id__c = :jobId];
        string templateId = '';

        for(Scheduler_Shipment_Services_Lines__c s :sr) {

            /*  CONSTRUYENDO EXCEL */

            //obtenemos los historicos
            Date DateForHistory = null;

            if(s.Historical_Time__c == 'Month')
                DateForHistory = System.Date.today().toStartOfMonth();
            else
                DateForHistory = System.Date.today().toStartOfWeek();

            //List<Shipment_Fee_Line__History> sfl = [SELECT  Id,CreatedBy.Name, OldValue, NewValue, Field, createdDate FROM Shipment_Fee_Line__History where DAY_ONLY(createdDate) >=: DateForHistory AND ( Field = 'Shipment_Sell_Price__c' or Field = 'Shipment_Buy_Price__c') order by createdDate ASC];
            List<Shipment_Fee_Line__History> sfl = [SELECT  Id,CreatedBy.Name, OldValue, NewValue, Field, createdDate FROM Shipment_Fee_Line__History where DAY_ONLY(createdDate) >=: DateForHistory AND Shipment_Fee_Line__History.Field != 'created' order by createdDate ASC];

            //generando excel...
            String excelStr = '';
            excelStr += '<table border="1">';
            excelStr += '	<tr>';
            excelStr += '		<th>Record Id</th>';
            excelStr += '		<th>Modify By</th>';
            excelStr += '		<th>Field</th>';
            excelStr += '		<th>OldValue</th>';
            excelStr += '		<th>NewValue</th>';
            excelStr += '		<th>createdDate</th>';
            excelStr += '	</tr>';

            for(Shipment_Fee_Line__History ssh:sfl){
                excelStr += '	<tr>';
                excelStr += '		<td>'+ssh.Id+'</td>';
                excelStr += '		<td>'+ssh.CreatedBy.Name+'</td>';
                excelStr += '		<td>'+ssh.Field+'</td>';
                excelStr += '		<td>'+ssh.OldValue+'</td>';
                excelStr += '		<td>'+ssh.NewValue+'</td>';
                excelStr += '		<td>'+ssh.createdDate+'</td>';
                excelStr += '	</tr>';
            }

            excelStr += '</table>';

            //adjuntando excel
            List<Messaging.EmailFileAttachment> attList = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            blob excel = blob.valueOf(excelStr);

            attach.setBody(excel);
            attach.setFileName(s.Document_Name__c+'.xls');
            attList.add(attach);

            /* montando template */
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
                firmaEmail += '<br/><br/><br/><hr/><br/><table width="640" border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">';
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

            /*  ENVÍO DE EMAILS */
            string[] lista_envio = new string[]{};
            lista_envio = s.Contact_Emails_Sent__c.split('\n',0);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(s.Subject_mail__c);
            //mail.setPlainTextBody(s.Body_mail__c);
            mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(s.Body_mail__c != null ? s.Body_mail__c.replace('\n','<br/>') : '')+firmaEmail+'</body></html>');

            mail.setFileAttachments(attList);
            //mail.setTemplateId(templateId);
            mail.setWhatId(s.Id);
            //setting emails extra fields
            if(s.Sender_Name__c != null)
                mail.setSenderDisplayName(s.Sender_Name__c);
            if(s.Cc_email__c != null)
                mail.setCcAddresses(s.Cc_email__c.split(';'));
            if(s.CCO_email__c != null)
                mail.setBccAddresses(s.CCO_email__c.split(';'));
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSaveAsActivity(false);
            mail.setToAddresses(lista_envio);
            Messaging.sendEmail( new List<Messaging.Email>{mail} );
            s.Processed__c = true;
        }

        update sr;
    }

}