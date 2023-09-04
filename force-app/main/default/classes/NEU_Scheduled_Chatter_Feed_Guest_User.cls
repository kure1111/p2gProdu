global class NEU_Scheduled_Chatter_Feed_Guest_User implements Schedulable
{
    global void execute(SchedulableContext ctx)
    {
      List<Chatter_Feed_Guest_User__c> chat_feed_guest = [select Id, Name, Feed_Text__c, Record_Id__c from Chatter_Feed_Guest_User__c];
      if(chat_feed_guest != null)
      {
      	try
        {
	        for(Chatter_Feed_Guest_User__c cfgu: chat_feed_guest)
	        {
	          ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, cfgu.Record_Id__c, cfgu.Feed_Text__c);
	        }
	        
       		delete chat_feed_guest;
         
        }
        catch(Exception ex){ Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[]{'oscar@neurored.com'}); mail.setSenderDisplayName('paquete'); mail.setSubject('Error pasar a quote'); mail.setBccSender(false);  mail.setUseSignature(false); mail.setCharset('UTF-8');   mail.setPlainTextBody('Error:'+ex);try  {if (!Test.isRunningTest()) { Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });}}catch(System.EmailException exc){}}
      }
        
    }
}