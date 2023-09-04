trigger NEU_Update_Buy_Rate on Fee__c (before insert, before update) {

    if(NEU_StaticVariableHelper.getBoolean1()){return;}		

    if(!RecursiveCheck.triggerMonitor.contains('NEU_Update_Buy_Rate')){
        RecursiveCheck.triggerMonitor.add('NEU_Update_Buy_Rate');
        
        if(trigger.isInsert || trigger.isUpdate)
        {
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
  
}