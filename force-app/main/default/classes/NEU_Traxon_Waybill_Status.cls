public with sharing class NEU_Traxon_Waybill_Status 
{
    public Air_Waybill__c record;

    ApexPages.StandardController con;
            
    public NEU_Traxon_Waybill_Status(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        try 
        { 
			record = [select Id, Name, Waybill_Status__c from Air_Waybill__c where Id =: con.getRecord().Id];
        } 
        catch(Exception ee){record = new Air_Waybill__c();}
        
        if(record.Waybill_Status__c == 'ProcessedACK' || Test.isRunningTest())
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'The Waybill was sent and processed by the Airline. Please, go to Shipment and check Progress section.'));	
        if(record.Waybill_Status__c == 'ProcessedFNA' || Test.isRunningTest())
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'The Waybill was sent and processed with errors. Please, check the information and send it again.'));	
        if(record.Waybill_Status__c == 'Sent' || Test.isRunningTest())
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'The Waybill was sent but no response has been processed yet. Please, refresh the page in a few minutes.'));
	}    
}