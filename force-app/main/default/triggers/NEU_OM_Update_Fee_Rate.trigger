trigger NEU_OM_Update_Fee_Rate on Fee_Offer__c (before insert, before update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    for(Fee_Offer__c ob1 : trigger.new)
    {
        if(ob1.Valid__c == true)
        {
            List<Fee__c> fees_update = [select Id, Name, Fee_Rate__c from Fee__c where Id =: ob1.Fee_Name__c];
            if(fees_update.size()>0)
            {
                fees_update[0].Fee_Rate__c = ob1.Price__c;
                update fees_update[0];
            }
            List<Fee_Offer__c> update_fee_offer = [select Id, Valid__c from Fee_Offer__c where Fee_Name__c =: ob1.Fee_Name__c and Valid__c=true and Id!=:ob1.Id];
            for(Fee_Offer__c fo : update_fee_offer)
                fo.Valid__c = false;
            update update_fee_offer;
        }
    }
}