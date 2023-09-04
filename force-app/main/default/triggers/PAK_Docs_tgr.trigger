trigger PAK_Docs_tgr on Associated_Document__c (after insert) {
    if(NEU_StaticVariableHelper.getBoolean1())
    return;
    list<Customer_Quote__c> QUOTE = new list<Customer_Quote__c>();
    QUOTE = [Select Id,BOL_Associated__c,Guia_Consolidado__c From Customer_Quote__c Where Id=:trigger.new[0].Import_Export_Quote__c];
    if(trigger.new[0].Document_Type__c == 'Bill of Lading'){if(!QUOTE.isEmpty()){QUOTE[0].BOL_Associated__c=true;update QUOTE[0];}}
    if(trigger.new[0].Document_Type__c == 'Guía Consolidado'){if(!QUOTE.isEmpty()){QUOTE[0].Guia_Consolidado__c=true;update QUOTE[0];}}
}