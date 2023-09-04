trigger NEU_SQO_Update_Conversions on Supplier_Quote__c (after update) {

	if(NEU_StaticVariableHelper.getBoolean1())
		return;
	
	NEU_CurrencyUtils.headerAfterUpdate(new String[]{'Supplier_Quote_Line__c','Supplier_Quote_Order_Fee_Line__c'},new String[]{'Supplier_Quote__c','Supplier_Quote_Order__c'},trigger.new,trigger.newMap,trigger.oldMap);
}