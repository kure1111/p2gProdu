public class NEU_ShipmentConfirmToInvoice 
{
	public Shipment__c record;
	
	ApexPages.StandardController con;
  
  	public NEU_ShipmentConfirmToInvoice(ApexPages.StandardController stdController)
  	{
        con = stdController;

	    try 
	    { 
	    	record = [select Id, Name, OK_FACTURAR_FI__c
	    	from Shipment__c where id =: con.getRecord().id];
	    } 
	    catch(Exception ee){record = new Shipment__c();} 
  	} 
  	
  	public pagereference update_shipment()
  	{
  		record.OK_FACTURAR_FI__c = true;
  		
  		try
  		{
  			update record;
  			
  			PageReference pgReturnPage;
	        String returnUrl = '/' + record.Id;
	        pgReturnPage = new PageReference(returnUrl);
	        pgReturnPage.setRedirect(true);
	        return pgReturnPage;
  		}
  		catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex)); return null;}
  	}   
}