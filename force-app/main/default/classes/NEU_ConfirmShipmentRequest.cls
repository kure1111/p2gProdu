public with sharing class NEU_ConfirmShipmentRequest 
{
  public Shipment__c record;
  public String resultado {get;set;}

    ApexPages.StandardController con;
            
    public NEU_ConfirmShipmentRequest(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, RecordTypeId
        from Shipment__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }
    }
    
    public PageReference confirm_request()
    {
      record.RecordTypeId = Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Quote').getRecordTypeId(); //Shipment Quote
      
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