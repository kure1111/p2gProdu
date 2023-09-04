global class NEU_Search_Supplier_Quote_Hidden implements Schedulable
{
    global void execute(SchedulableContext ctx)
    {
    	
    	List<Supplier_Quote__c> sup_quot = [select Id, Name, Supply_Project__c, RecordTypeId, Supply_Project__r.Date_Limit__c from Supplier_Quote__c where Supply_Project__r.Date_Limit__c !=: null and RecordTypeId =: Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Hidden Quote').getRecordTypeId() and Supply_Project__r.Date_Limit__c < Today];
    	if(sup_quot != null)
    	{
    		for(Supplier_Quote__c su_qo: sup_quot)
    		{
    			su_qo.RecordTypeId = Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Quote').getRecordTypeId();
    		}
    		try
    		{
    			update sup_quot;
    		}
    		catch(Exception ex){ Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[]{'oscar@neurored.com'}); mail.setSenderDisplayName('paquete'); mail.setSubject('Error pasar a quote'); mail.setBccSender(false);  mail.setUseSignature(false); mail.setCharset('UTF-8');   mail.setPlainTextBody('Error:'+ex);try  {if (!Test.isRunningTest()) { Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });}}catch(System.EmailException exc){}}
    	}
    		
    }
}