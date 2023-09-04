public class NEU_JE_RFP_guest {

    public Supplier_Request_RFP__c request{get;set;}
    
    public String myid{get;set;}
     
    public String email{get;set;}

    public String secret{get;set;}
    
    public Integer result{get;set;}

    public NEU_JE_RFP_guest()
    {
        result=0;
        myid=Apexpages.currentPage().getParameters().get('rfp');
        List<Supplier_Request_RFP__c>requestlist=[select Subject__c,Contact_Sent__r.Email,Contact_Sent__r.Other_Email__c,Contact_Sent__r.Secret__c,Contact_Sent__r.Other_Secret__c,Contact_Sent__r.Self_Registered_Name__c,Contact_Sent__r.Id,Supplier__r.NEU_Email__c,Supplier__r.Secret__c,Supplier__r.Id from Supplier_Request_RFP__c where Id=:myid];
        if(requestlist.size()>0)
        {
            request=requestlist[0];
        }
        else
            request=null;
    }
   
    public PageReference checkredirect()
    {
        if(!Site.isLoginEnabled())
            return null;
        if(request==null)
            return null;
        if(request.Contact_Sent__r==null)
            return null;
        if(String.isEmpty(request.Contact_Sent__r.Self_Registered_Name__c))
            return null;
        return new PageReference(Site.getBaseUrl()+'/'+myid);
    }
        
    private String getNewSecret()
    {
        Integer paswdLeng=4;
        String key = '0123456789';
        String pswd = '';
        Integer keylength=key.length();
        for (Integer i = 0; i < paswdLeng; i++) {
            Integer pos=Integer.valueOf(Math.random() * keylength);
            pswd+=key.substring(pos,pos+1);
        }
        return pswd;
    }
    
    public void validate()
    {
        result=0;
        if(request!=null)
            if((String.isNotEmpty(email))&&(String.isNotEmpty(secret)))
            {
                if(request.Contact_Sent__r!=null)
                {
                    if((request.Contact_Sent__r.Email==email)&&(request.Contact_Sent__r.Secret__c==secret))
                    {
                        result=-1;
                        return;
                    }
                    if((request.Contact_Sent__r.Other_Email__c == email)&&(request.Contact_Sent__r.Other_Secret__c==secret))
                    {
                        result=-1;
                        return;
                    }
                }
                else
                {
                    if((request.Supplier__r.NEU_Email__c==email)&&(request.Supplier__r.Secret__c==secret))
                    {
                        result=-1;
                        return;
                    }
                }
            }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The combination of email and PIN is not correct. Please try again'));
    }
    public void sendpin()
    {
        result=0;
        if(request!=null)
        {
            if(String.isEmpty(email))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please, enter your email'));
                return;
            }
            String mysecret=getNewSecret();
            if(request.Contact_Sent__r!=null)
            {
                if(request.Contact_Sent__r.Email!=email && request.Contact_Sent__r.Other_Email__c!=email)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Your email is not registered in our system. Please try again'));
                    return;
                }
                if(request.Contact_Sent__r.Email == email)
                    request.Contact_Sent__r.Secret__c=mysecret;
                if(request.Contact_Sent__r.Other_Email__c == email)
                    request.Contact_Sent__r.Other_Secret__c=mysecret;
                update request.Contact_Sent__r;
            }
            else
            {
                if(request.Supplier__r.NEU_Email__c!=email)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Your email is not registered in our system. Please try again'));
                    return;
                }
                request.Supplier__r.Secret__c=mysecret;
                update request.Supplier__r;
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new string[]{email});
            mail.setSubject(request.Subject__c);
            mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head></head><body style="font-family:Arial; font-size:14px;">You are receiving this email because someone requested your PIN<br/><br/>Your PIN:'+mysecret+'</body></html>');
            mail.setCharset('UTF-8');
            try{
                System.debug('You have made ' + Limits.getEmailInvocations() + ' email calls out of ' + Limits.getLimitEmailInvocations() + ' allowed');
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                if(resultMail[0].isSuccess())
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'We send you an email with your new PIN'));
                    return;
                }
            }catch(Exception ex){}
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error sending email. Please try again later'));
    }
}