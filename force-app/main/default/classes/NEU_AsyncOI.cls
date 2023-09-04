global class NEU_AsyncOI implements Schedulable
{
 global void execute(SchedulableContext ctx)
 {
 	NEU_AsyncOI.query_oi_future();
 	if (Test.isRunningTest())
		NEU_AsyncOI.enviarNotificacion('asunto', 'cuerpo');
 }

@future(callout=true)
 public static void query_oi_future()
 {
 	NEU_AsyncOI.query_oi();
 }
 public static void query_oi()
 {
    string url = NEU_Settings.OIevents;
    String username = NEU_Settings.OIuser;
    String password = NEU_Settings.OIpass;
    HttpRequest req = new HttpRequest();
    req.setTimeout(100000);
    req.setMethod('GET');
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'BASIC ' +
    EncodingUtil.base64Encode(headerValue);
    req.setHeader('Authorization', authorizationHeader);
    req.setHeader('Accept','application/json');
	Set<String>shipment_ids=new Set<String>();
	Integer OIpage=1;
	Boolean nextPage=true;
    while((nextPage)&&(Limits.getCallouts()<Limits.getLimitCallouts()))
    {
    	nextPage=false;
	    req.setEndpoint(url+'?page='+String.valueOf(OIpage++)); 
		JSONParser parser = null;
	    try
	    {
	        if(!Test.isRunningTest())
	        {
	            HttpResponse res = (new Http()).send(req);
	            String Links=res.getHeader('Link');
	            if(String.IsNotEmpty(Links))
	            	if(Links.containsIgnoreCase('rel="next"'))
	            		nextPage=true;
	            parser=JSON.createParser(res.getBody());
	        }
	        else
	        {
	            parser=JSON.createParser('[{"shipment_id": 1751956}]');
	        }
		    if(parser!=null)
			    while(parser.nextToken()!=null)
			    	if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='shipment_id'))
		    		{
				    	parser.nextToken();
				    	String shipment_id=parser.getText();
				    	if(String.IsNotEmpty(shipment_id))
			        		shipment_ids.add('sh'+shipment_id);
		    		}
	    }
	    catch(Exception ex)
	    {
	    	enviarNotificacion('Error AsynOI', 'Error: '+ex);
	    }
    }
    //Clear Shipments After 7 Days
    List<Shipment__c> list_shipment_update = [select id,External_Reference_OI__c from Shipment__c where External_Reference_OI__c!='' and External_Reference_OI__c!=null and (LastModifiedDate<LAST_N_DAYS:7) and (NOT External_Reference_OI__c like 'sh%')];
    if(list_shipment_update.size()>0)
    {
    	for(Shipment__c sh: list_shipment_update)
	    {
	    	sh.External_Reference_OI__c = null;
	    }	
	    update list_shipment_update;
    }
    //Clear Shipments Programs After 7 Days
    List<Shipment_Program__c> list_bl_update = [select id,External_Reference_OI__c from Shipment_Program__c where External_Reference_OI__c!='' and External_Reference_OI__c!=null and (LastModifiedDate<LAST_N_DAYS:7) and (NOT External_Reference_OI__c like 'sh%')];
    if(list_bl_update.size()>0)
    {
    	for(Shipment_Program__c sp: list_bl_update)
    	{
    		sp.External_Reference_OI__c = null;
    	}	
    	update list_bl_update;
    }
 	for(Shipment__c s:[select id,External_Reference_OI__c from Shipment__c where External_Reference_OI__c!='' and External_Reference_OI__c!=null and (LastModifiedDate>=LAST_N_DAYS:7) and (NOT External_Reference_OI__c like 'sh%')])
		shipment_ids.add(s.External_Reference_OI__c);
 	for(Shipment_Program__c s:[select id,External_Reference_OI__c from Shipment_Program__c where External_Reference_OI__c!='' and External_Reference_OI__c!=null and (LastModifiedDate>=LAST_N_DAYS:7) and (NOT External_Reference_OI__c like 'sh%')])
		shipment_ids.add(s.External_Reference_OI__c);
	if(shipment_ids.size()>0)
	{
		if(!Test.isRunningTest())
			System.enqueueJob(new NEU_AsyncOIShipment(shipment_ids));
	}
 }
 
 public static void enviarNotificacion(string asunto, string cuerpo)
	{
		List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    mail.setToAddresses(new String[]{'mario@neurored.com, joseantonio@neurored.com'});
		mail.setSenderDisplayName('Pack2Go');
		mail.setSubject(asunto);
		mail.setBccSender(false); 
		mail.setUseSignature(false); 
		mail.setCharset('UTF-8');
		mail.setPlainTextBody(cuerpo);
		
		theEmails.add(mail);
		
		List<Messaging.Email> allMails = new List<Messaging.Email>();
		for(Integer j = 0; j < theEmails.size(); j++)
		{
			allMails.add(theEmails.get(j));
		}
		
		try
		{
			if (!Test.isRunningTest())
				Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
		}
		catch(Exception exc){}		
	}
}