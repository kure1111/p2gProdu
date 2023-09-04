trigger NEU_LaunchIntegrationWC on Carrier_Line_Load_Point__c (before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;
    
    for(Carrier_Line_Load_Point__c route : trigger.new)
    {
        Carrier_Line_Load_Point__c old_route = Trigger.oldMap.get(route.ID);
        
        if(route.Last_Call_to_WCN__c != old_route.Last_Call_to_WCN__c)
            route.Available_to_Call_WCN__c = true;
        else
            route.Available_to_Call_WCN__c = false;
            
        if(route.Last_Receipt_Information_from_WCN__c != old_route.Last_Receipt_Information_from_WCN__c)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{route.Email_WCN__c});
            mail.setSenderDisplayName('WebCargoNet Integration');
            mail.setSubject('Updating Completed Fees for this Route: '+route.Name);
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            mail.setCharset('UTF-8');
                    
            String emailbody = '';
            emailbody += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head></head><body style="font-family:Arial; font-size:12px;">';
            emailbody += 'Updating Completed Fees for the Route <strong>'+route.Name+'</strong>, click <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+route.Id+'">here</a> to see the record.';
            emailbody += '</body></html>';
            
            mail.setHtmlBody(emailbody);
            
            try
            {
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            catch(Exception ex){}
        }
    }
}