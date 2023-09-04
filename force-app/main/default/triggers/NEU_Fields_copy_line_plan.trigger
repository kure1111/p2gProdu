trigger NEU_Fields_copy_line_plan on Labor_Program__c (before update, before insert) 
{
    List<Id> lista_line_plans = new List<Id>();
    for(Labor_Program__c line:trigger.new) 
    {
        line.Asset_Value_Utilization_copy__c = line.Asset_Value_Utilisation__c;
        line.Available_Loading_Time_copy__c= line.Available_Loading_Time__c;
        line.Available_Time_copy__c= line.Available_Time__c;
        line.Average_Line_OEE_copy__c= line.Average_Line_OEE__c;
        line.Average_Throughput_copy__c = line.Average_Throughput__c;
        line.Capacity_Losses_Excluded_Shifts_copy__c = line.Capacity_Losses_Excluded_Shifts__c;
        line.Constrained_Capacity_copy__c= line.Constrained_Capacity__c;
        line.Constrained_Capacity_Utilization_copy__c= line.Constrained_Capacity_Utilisation__c;
        line.Constrained_Unused_Capacity_copy__c= line.Constrained_Unused_Capacity__c;
        line.Idle_Time_copy__c= line.Idle_Time__c;
        line.Normal_Shift_Pattern_weeks_copy__c = line.Normal_Shift_Pattern__c;
        line.OEE_Losses_copy__c = line.OEE_Losses__c;
        line.Off_season_weeks_copy__c = line.Off_season_weeks__c;
        line.Total_Legal_Losses_copy__c= line.Total_Legal_Losses__c;
        line.Total_Shift_Pattern_Loss_copy__c= line.Total_Shift_Pattern_Loss__c;
        line.Total_Time_hours_year_copy__c = line.Total_Time__c;
        line.Unconstrained_Capacity_copy__c= line.Unconstrained_Capacity__c;
        line.Unconstrained_Capacity_Utilization_copy__c = line.Unconstrained_Capacity_Utilisation__c;
        line.Unconstrained_Unused_Capacity_copy__c = line.Unconstrained_Unused_Capacity__c;
        line.Unutilized_Capacity_Losses_copy__c= line.Unutilized_Capacity_Losses__c;
        
        if(trigger.isupdate)
        {
            Labor_Program__c oldlineplan = Trigger.oldMap.get(line.ID);
            if(oldlineplan.Units__c != line.Units__c)
                lista_line_plans .add(line.Id);
        }
    }
    
    if(lista_line_plans.size() > 0)
    {
        List<Production_Order__c> lista_production_plan = [select ID, Labor_Program__c from Production_Order__c where Labor_Program__c IN:lista_line_plans];
        if(lista_production_plan.size() > 0)
            update lista_production_plan;
        
    }


}