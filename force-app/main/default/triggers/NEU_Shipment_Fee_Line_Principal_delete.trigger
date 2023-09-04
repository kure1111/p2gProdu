trigger NEU_Shipment_Fee_Line_Principal_delete on Shipment_Fee_Line__c (before delete) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    List<Shipment_Fee_Line__c>toDelete= [select Id from Shipment_Fee_Line__c where Rate_Type__c='% of Charge' and Shipment_Service_Line__c IN:trigger.old];
    if(toDelete.size()>0)
        delete toDelete;
}