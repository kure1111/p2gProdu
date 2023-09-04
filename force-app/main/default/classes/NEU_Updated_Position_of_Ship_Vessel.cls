public class NEU_Updated_Position_of_Ship_Vessel{
      public Vessel_Flight__c record=null;
      public String contenido_del_chat{get;set;}
      public NEU_Updated_Position_of_Ship_Vessel(ApexPages.StandardController stdController) {
            if (!Test.isRunningTest())
            	stdController.AddFields(new String[] { 'Id','Name', (UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Route__c') });
            record=(Vessel_Flight__c)stdController.getRecord();
            
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
              defaultUrl='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/NEU_Vessel_Tracking';
            else
              defaultUrl+='/NEU_Vessel_Tracking';
              
            contenido_del_chat = 'The Vessel tracking has been updated. For more details see the link bellow  \n '+defaultUrl+'?id='+record.Id;
        }
        
        public void create_feed()
        {
             if(!Test.isRunningTest())
                ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.record, record.Id , contenido_del_chat);          
        }

}