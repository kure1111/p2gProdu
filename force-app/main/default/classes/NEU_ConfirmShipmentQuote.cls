public with sharing class NEU_ConfirmShipmentQuote 
{
  public Shipment__c record;
  public String resultado {get;set;}
  public List<Shipment_Fee_Line__c> shipment_service_lines {get;set;}

    ApexPages.StandardController con;
            
    public NEU_ConfirmShipmentQuote(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Freight_Mode__c, Service_Mode__c, Service_Type__c, Container_Size__c, N_Containers__c, Move_Type__c, Route__c, Route__r.Name,
        ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Total_Services_Sell_Amount__c
        from Shipment__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }
        
        shipment_service_lines = [select Id, Name, Service_Rate_Name__c, Service_Rate_Category__c, Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name,
        Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Carrier_Account__r.Name, Rate_Type__c, Service_Rate_Name__r.Container_Type__c,
        Service_Rate_Name__r.Container_Type__r.Name, Units__c, Shipment_Sell_Net_Price__c, Sell_Amount__c
        from Shipment_Fee_Line__c where Shipment__c =: record.Id];
    }
        
    public PageReference confirm_quote()
    {
      /*String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
        
    String url =  salesforceHost + '/services/data/v23.0/connect/communities/0DB2400000083HO/chatter/feeds/record/' + record.Id + '/feed-items';
    
      HttpRequest req = new HttpRequest();
                  
    req.setMethod('POST');
    req.setEndpoint(url);
    req.setHeader('Content-type', 'application/json');
    req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
      
    String mentions = '';
    List<EntitySubscription> followers = [select Id, parentId, SubscriberId from EntitySubscription where parentId =: record.Id];
    for(EntitySubscription f : followers)
    {
      mentions += '{ "type": "mention", "id" : "' + f.SubscriberId + '" }, ';
    }
    
    String message = 'The Shipment Quote has been confirmed.';
    
    req.setBody('{ "body" : { "messageSegments" : ['+mentions+'{ "type": "text",  "text" : "' + ' ' + message +  '" } ] } }');
    Http http = new Http();
      
    HTTPResponse res = http.send(req);*/
      
      record.RecordTypeId = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Order').getRecordTypeId(); //Shipment Order
      
      try
      {
        update record;  
        
        PageReference pgReturnPage;
            String returnUrl = '/'+record.Id;
            pgReturnPage = new PageReference(returnUrl);
            pgReturnPage.setRedirect(true);
            return pgReturnPage;
      }
      catch(Exception ex){resultado = 'Error:'+ex; return null;}
    }
}