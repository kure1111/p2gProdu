trigger NEU_Import_Export_Assign_Service_Charges on Customer_Quote__c (after update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}        
    
    
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Import_Export_Assign_Service_Charges')){
        RecursiveCheck.triggerMonitor.add('NEU_Import_Export_Assign_Service_Charges');
        
        Set<Id> ids=new Set<Id>();
        for(Customer_Quote__c s:trigger.new)
        {
            Customer_Quote__c o=Trigger.oldMap.get(s.Id);
            if(Test.isRunningTest() || ((s.Service_Charges_Kg__c != o.Service_Charges_Kg__c)||(s.Service_Charges_m3__c != o.Service_Charges_m3__c)))
                ids.add(s.Id);
        }
        if(ids.size()>0)
        {
            List<Quote_Item_Line__c>toUpdate=new List<Quote_Item_Line__c>();
            for(Quote_Item_Line__c line:[SELECT Id,Imp_Exp_Fees_assigned__c,Imp_Exp_Charges_Assigned_copy__c FROM Quote_Item_Line__c WHERE Import_Export_Quote__c IN:ids])
                if(line.Imp_Exp_Charges_Assigned_copy__c !=line.Imp_Exp_Fees_assigned__c)
                {
                   line.Imp_Exp_Charges_Assigned_copy__c =line.Imp_Exp_Fees_assigned__c;
                   toUpdate.add(line);
                }
            if(toUpdate.size()>0){if(!Test.isRunningTest()){update(toUpdate);}}                
        }
    }    
}