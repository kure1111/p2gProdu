public class NEU_Updated_Position_of_Ship{
      public Shipment__c record=null;
      public String contenido_del_chat{get;set;}
      public NEU_Updated_Position_of_Ship(ApexPages.StandardController stdController) {
            if (!Test.isRunningTest())
            	stdController.AddFields(new String[] {'Id','Name','Route__c',(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Equipment__c') });
            record=(Shipment__c)stdController.getRecord();
            
            CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
            if(sr == null)
            {
              sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
              if(sr == null) sr = CSH_Supplier_Request__c.getOrgDefaults();
            }
            
            String defaultUrl=null;
            Boolean useExternal=false;
            if(sr!=null)
            {
              defaultUrl=sr.Default_External_URL__c;
              useExternal=sr.Use_External_Url__c;
            }
            
            if(String.IsEmpty(defaultUrl)||(!useExternal))
              defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Trace';
            else
              defaultUrl+='/NEU_Trace';
              
            contenido_del_chat = 'The Container tracking has been updated. For more details see the link bellow  \n '+defaultUrl+'?id='+record.Id;
        }
        
public void create_feed() {

        // Crear segmento de texto
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = contenido_del_chat;

        // Cuerpo del mensaje
        ConnectApi.MessageBodyInput messageBody = new ConnectApi.MessageBodyInput();
        messageBody.messageSegments = new List<ConnectApi.MessageSegmentInput>{ textSegment };

        // Entrada del elemento del feed
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.subjectId = record.Id;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.body = messageBody;

        // Publicar en el feed del registro
        ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);
    
}



}