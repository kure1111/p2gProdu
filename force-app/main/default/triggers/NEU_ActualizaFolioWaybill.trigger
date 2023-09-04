trigger NEU_ActualizaFolioWaybill on Air_Waybill__c (before update) {
  
    if(NEU_StaticVariableHelper.getBoolean1())
        return;  

    if(trigger.isUpdate == true)
    {
        for(Air_Waybill__c awb:trigger.new)
        {    	
	        Air_Waybill__c old_awb = Trigger.oldMap.get(awb.Id);
	        if(old_awb.Carrier_Account__c != awb.Carrier_Account__c || old_awb.Serial_Number__c != awb.Serial_Number__c)
	  		{
	  			awb.addError('You are not allowed to modify Carrier or Serial Number.');
	  		}   
	  		if(old_awb.Name != awb.Name)
	  		{
	  			awb.addError('You are not allowed to modify Air WayBill Name.');
	  		}   
	  		if(old_awb.Airport_of_Departure__c != awb.Airport_of_Departure__c)
	  		{
	  			awb.Name=awb.Airline_Code_Number__c+'-'+awb.Airport_of_Departure_Code__c+'-'+NEU_Utils.safeString(awb.Serial_Number__c);
	  		}
	  		if(old_awb.Airport_of_Departure__c != awb.Airport_of_Departure__c || old_awb.Site_of_Destination__c != awb.Site_of_Destination__c)
	  		{
	  			awb.IATA_Code_Manual__c=NEU_Utils.getCarrierAgentIATA(awb.Airport_of_Departure_Code__c,awb.Airport_of_Destination_Code__c);
	  		}    	
        }
    }
      
}