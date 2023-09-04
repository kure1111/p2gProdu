trigger NEU_SQOLine_Update_Conversions on Supplier_Quote_Line__c (before insert, before update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    if(trigger.isInsert)
        NEU_CurrencyUtils.lineBeforeInsert('Supplier_Quote__c','Supplier_Quote__c',trigger.new);
    if(trigger.isUpdate)
        NEU_CurrencyUtils.lineBeforeUpdate('Supplier_Quote__c','Supplier_Quote__c',trigger.new,trigger.oldMap);
}