trigger NEU_MD_UploadRecordTypeSQO on Supplier_Quote__c (before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    List<Supplier_Quote_Line__c> query_lista = new List<Supplier_Quote_Line__c>();
    for(Supplier_Quote__c sq : trigger.new)
    {
        if(sq.Supplier_Quote_Status__c == 'Approved' && sq.recordTypeId != Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Order').getRecordTypeId())
            sq.RecordTypeId = Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Order').getRecordTypeId();
        
        Supplier_Quote__c oldquote = Trigger.oldMap.get(sq.ID);
        if(oldquote.recordTypeId != sq.recordTypeId)
        {
            query_lista = [select Id, Name, RecordTypeId, Supplier_Quote__c from Supplier_Quote_Line__c where Supplier_Quote__c=: sq.Id ];  
            if(sq.RecordTypeId == Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Order').getRecordTypeId() || sq.RecordTypeId == Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Quote').getRecordTypeId())
            {
                for(Supplier_Quote_Line__c sql : query_lista)
                {
                    sql.RecordTypeId = Schema.SobjectType.Supplier_Quote_Line__c.getRecordTypeInfosByName().get('Supplier Quote/Order Line').getRecordTypeId();
                }
            }
            else
            {
                for(Supplier_Quote_Line__c sql : query_lista)
                {
                    sql.RecordTypeId = Schema.SobjectType.Supplier_Quote_Line__c.getRecordTypeInfosByName().get('Supplier Quote/Order Line Hidden').getRecordTypeId();
                }
            }
            
            try
            {
                update query_lista;
            }
            catch(Exception ex){}
        }
    }
}