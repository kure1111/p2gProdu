trigger trgUpdateLocation on Customer_Quote__c (before insert) {
		TriggerCustomerQuote.ActualizarLocations(trigger.new);
}