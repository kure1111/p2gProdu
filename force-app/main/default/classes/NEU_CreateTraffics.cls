public with sharing class NEU_CreateTraffics 
{
	public string resultado {get;set;}
	
    public PageReference create_traffic()
    {
		List<Customer_Quote__c> importexport = [select Id, Name from Customer_Quote__c 
		where Freight_Mode__c != 'Multimodal' and Traffic__c = null and Ignore__c = false and Service_Type__c != 'PAQUETERIA' limit 1];
		
		try
		{
			if(importexport.size() > 0)
			{
				update importexport;
				
				PageReference pgReturnPage;
		        String returnUrl = '/apex/NEU_CreateTraffics';
		        pgReturnPage = new PageReference(returnUrl);
		        pgReturnPage.setRedirect(true);
		        return pgReturnPage;
			}
			else
			{
				resultado = 'FIN';
				return null;
			}
		}
		catch(Exception ex)
		{
			resultado = ''+ex;
			return null;
		}
    }
}