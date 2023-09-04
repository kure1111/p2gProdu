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
        
        public void create_feed()
        {
             if(!Test.isRunningTest())
                ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.record, record.Id , contenido_del_chat);          
        }

}