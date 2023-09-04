public with sharing class NEU_Shipment_Warnings
{
	public Shipment__c record;

	ApexPages.StandardController con;
	
	public NEU_Shipment_Warnings(ApexPages.StandardController stdController) 
	{
   		con = stdController;

		try 
		{ 
			record = [select Id, Name
			from Shipment__c where id = :con.getRecord().id];
		} 
		catch(Exception ee){record = new Shipment__c();}	
	}
}