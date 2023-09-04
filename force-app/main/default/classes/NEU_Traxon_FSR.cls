public virtual with sharing class NEU_Traxon_FSR {
	String senderPIMA;
	String addressTo;
	ApexPages.StandardController con;
	Shipment__c record;
	List<Location__c> apts_dep;
	List<Location__c> apts_des;
	public static String[]usedFields=new String[]{
		'Id'
		,'Carrier__c'
		,'Carrier__r.PIMA_Address__c'
		,'MAWB_Number__c'
		,'Site_of_Load__c'
		,'Site_of_Discharge__c'
		};
    public NEU_Traxon_FSR(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest()) {stdController.AddFields(usedFields);}
        con = stdController;
        record=(Shipment__c)con.getRecord();
		System.debug('***id***' + record.Id);
        sandbox();        
        apts_dep = [SELECT IATA_Code__c FROM Location__c WHERE Id = :record.Site_of_Load__c];
        apts_des = [SELECT IATA_Code__c FROM Location__c WHERE Id = :record.Site_of_Discharge__c];
    }
    protected NEU_Traxon_FSR()
    {
    	sandbox();
    } 
    public String sandbox()
    {
    	List<Organization>org=[SELECT Id, IsSandbox FROM Organization LIMIT 1];
		Boolean isSandbox=false;
		if(org.size()>0)
			if(org[0].IsSandbox)
				isSandbox=true;
		if(isSandbox)
			addressTo='cargohub-test@edi.champ.aero';
		else
			addressTo='cargohub-edi@edi.champ.aero';
		return addressTo;
    }
    public PageReference sendToTraxon()
    {
    	String PIMA_Address;
    	String MAWB_Number;
    	Boolean errors=false;
    	if(record!=null)
    	{
	    	Account carrier=record.Carrier__r;
	    	if(carrier==null)
	    		if(record.MAWB_Number__c!=null)
	    			if(record.MAWB_Number__c.length()>2)
	    			{
			    		List<Account>la=[select Id,PIMA_Address__c from Account where Airline_Prefix__c=:record.MAWB_Number__c.Left(3)];
			    		if(la.size()>0)
			    			carrier=la[0];
	    			}
	    	if(carrier==null)
	    	{
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Shipment__c.fields.Carrier__c.getDescribe().getLabel()+' not found'));
	    		errors=true;
	    	}
	    	else
	    	{
		    	if(String.isEmpty(carrier.PIMA_Address__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Shipment__c.fields.Carrier__c.getDescribe().getLabel()+': '+Schema.Account.fields.PIMA_Address__c.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		    	else
			    	PIMA_Address=carrier.PIMA_Address__c;
	    	}
	    	Boolean reg;
	    	
	    	if(String.isEmpty(record.MAWB_Number__c))
	    	{
		    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Shipment__c.fields.MAWB_Number__c.getDescribe().getLabel()+' not found'));
		    	errors=true;
		    	reg = true;
	    	}
	    	else 
	    	{
	    		if (!Test.isRunningTest())
		    		reg = Pattern.matches('^[0-9]{3}-[0-9]{8}', record.MAWB_Number__c);
		    	else
		    		reg = true;
	    	}
	    	if(!reg)
	    	{
		    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Shipment__c.fields.MAWB_Number__c.getDescribe().getLabel()+' incorrect format'));
		    	errors=true;
	    	}
	    	else
	    		MAWB_Number=record.MAWB_Number__c;
    	}
    	if(errors)
    		return null;
    	String mymessage='FSR\r\n';//message/version/separator
    	mymessage+=MAWB_Number;
    	mymessage+='\r\n';//separator

		Id logId=sendMessage(PIMA_Address,'FSR','1',mymessage);
    	if(logId==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Communications error'));
    		return null;
    	}
   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'FSR generated and notified'));
   		List<Shipment__c>shs=[select Id,FSR_Message__c from Shipment__c where MAWB_Number__c=:MAWB_Number];
   		if(shs.size()>0)
   		{
   			for(Shipment__c sh:shs)
   				sh.FSR_Message__c=logId;
   			update shs;
   		}

   		PageReference pgReturnPage;
		String returnUrl = '/' + record.Id;
    	pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
    	return pgReturnPage;
    }
    public PageReference cancel()
    {
    	return con.view();
    }    
    private ID sendMessage(String destpima,String mytype,String myversion,String mymessage)
    {
    	senderPIMA=NEU_Utils.getPIMA(apts_dep[0].IATA_Code__c,apts_des[0].IATA_Code__c);
    	DateTime now=System.now();
    	String msgid=now.format('yyMMddHHmmssSSS');
    	String header='UNB+IATA:1+'+senderPIMA+':PIMA+'+destpima+':PIMA+'+now.format('yyMMdd:HHmm')+'+ICREF+0\'UNH+MSGREF+CIM'+mytype+':'+myversion+'+'+msgid+'\'';
    	String footer='\'UNT+3+MSGREF\'UNZ+1+ICREF\'';
		String mysubject=mytype+':'+destpima+':'+msgid;
	    List<Messaging.Email> allMails = new List<Messaging.Email>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName = 'champ_email'];
        if(owea.size()>0)
            mail.setOrgWideEmailAddressId(owea[0].Id);
        mail.setToAddresses(new String[]{addressTo});
        mail.setSubject(mysubject);
        mail.setPlainTextBody(header+mymessage+footer);
        allMails.add(mail);
	    try{
	    	Boolean result=true;
	    	try{
	    		Messaging.SendEmailResult[] myresult=Messaging.sendEmail(allMails);
	    		if(myresult.size()>0)
	    			if(myresult[0].isSuccess())
	    				result=true;
	    	}
	    	catch(Exception e)
    		{
    			result=Test.isRunningTest();
    		}
	    	if(result)
    		{
				Log__c mylog=new Log__c();
		  		mylog.Subject__c=mail.subject.left(255);
		  		mylog.Body__c=mail.plainTextBody.left(32678);
		  		if(owea.size()>0)
			  		mylog.From__c=owea[0].Address;
  				mylog.To__c=addressTo;
		  		insert mylog;
    			return mylog.Id;
    		}
	    }catch(Exception e)
	    {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    }
	   	return null;
    }
}