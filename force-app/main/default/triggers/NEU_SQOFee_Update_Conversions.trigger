trigger NEU_SQOFee_Update_Conversions on Supplier_Quote_Order_Fee_Line__c (before insert, before update) {
    if(trigger.isInsert)
    	NEU_CurrencyUtils.lineBeforeInsert('Supplier_Quote__c','Supplier_Quote_Order__c',trigger.new);
    if(trigger.isUpdate)
    	NEU_CurrencyUtils.lineBeforeUpdate('Supplier_Quote__c','Supplier_Quote_Order__c',trigger.new,trigger.oldMap);
}