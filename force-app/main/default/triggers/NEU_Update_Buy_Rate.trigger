trigger NEU_Update_Buy_Rate on Fee__c (before insert, before update) {

    if(NEU_StaticVariableHelper.getBoolean1()){return;}		

    if(!RecursiveCheck.triggerMonitor.contains('NEU_Update_Buy_Rate')){
        RecursiveCheck.triggerMonitor.add('NEU_Update_Buy_Rate');
        
        if(trigger.isInsert || trigger.isUpdate)
        {
            if (trigger.isUpdate && isBuyRateUpdated(trigger.new[0])) {
                P2G_updateLog.handleUpdate(trigger.new[0]);
            }
            for(Fee__c fee : trigger.new)
            {
                if(fee.Cost_Concept_1__c != null || fee.Cost_Concept_2__c != null || fee.Cost_Concept_3__c != null || fee.Cost_Concept_4__c != null || fee.Cost_Concept_5__c != null)
                {
                    fee.Buy_Rate__c =  (fee.Cost_Concept_1__c != null ? fee.Cost_Concept_1__c : 0);
                    fee.Buy_Rate__c += (fee.Cost_Concept_2__c != null ? fee.Cost_Concept_2__c : 0);
                    fee.Buy_Rate__c += (fee.Cost_Concept_3__c != null ? fee.Cost_Concept_3__c : 0);
                    fee.Buy_Rate__c += (fee.Cost_Concept_4__c != null ? fee.Cost_Concept_4__c : 0);
                    fee.Buy_Rate__c += (fee.Cost_Concept_5__c != null ? fee.Cost_Concept_5__c : 0);
                }
            }
        }
    } 
    private Boolean isBuyRateUpdated(Fee__c fee) {
        if (Trigger.oldMap.containsKey(fee.Id)) {
            return Trigger.oldMap.get(fee.Id).Buy_Rate__c != fee.Buy_Rate__c;
        }
        return false;
    }
  
}