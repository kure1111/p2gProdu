trigger NEU_MD_SCMR2 on Fee__c (before update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    List<Import_Export_Fee_Line__c> fee_quote_lines = null;
    List<SCM_Rule_Applied__c> rules_applied = new List<SCM_Rule_Applied__c>();
    
    List<SCM_Activity__c> scm_activity = new List<SCM_Activity__c>();
    List<Task> listado_task = new List<Task>();
    List<SCM_Rule__c> scm_rule = null;
    
    Set<Id> list_ids_service = new Set<Id>();
    Map<Id, List<Import_Export_Fee_Line__c>> map_service_lines = new Map<Id, List<Import_Export_Fee_Line__c>>();
    for(Fee__c fee : trigger.new)
    {
        Fee__c oldfee = Trigger.oldMap.get(fee.ID);
        if(oldfee.Fee_Rate__c != fee.Fee_Rate__c)
        {
             list_ids_service.add(fee.Id);
        }
    }
    
    for(Fee__c fee : trigger.new)
    {
        Fee__c oldfee = Trigger.oldMap.get(fee.ID);

        if(oldfee.Fee_Rate__c != fee.Fee_Rate__c)
        { 
            if(scm_rule  == null)
            {
                scm_rule = [select Id, Name, Enabled__c, Fee_Alarm_Text__c, SCM_Rule_Code__c from SCM_Rule__c where SCM_Rule_Code__c = 'SCMR2' and Enabled__c = true];
                //crear tareas si tiene scm activity
                scm_activity = [select Id, Name, Enabled__c, Assigned_To__c, Comments__c, SCM_Rule__c, Subject__c, SCM_Rule__r.SCM_Rule_Code__c from SCM_Activity__c where SCM_Rule__r.SCM_Rule_Code__c = 'SCMR2' and Enabled__c = true];
                if(scm_rule.size() > 0)
                {
                    if(fee_quote_lines == null)
                        fee_quote_lines = [select Id, Name, Service_Rate_Name__c, Import_Export_Quote__c, Import_Export_Quote__r.Quotation_Status__c, Import_Export_Quote__r.Account_for__c, Import_Export_Quote__r.LastModifiedBy.Id from Import_Export_Fee_Line__c where Service_Rate_Name__c IN: list_ids_service and Import_Export_Quote__r.Quotation_Status__c != 'Approved as Succesful' and Import_Export_Quote__r.Quotation_Status__c != 'Declined' and Import_Export_Quote__r.Quotation_Status__c != 'Shipped'];
                        for(Import_Export_Fee_Line__c iefee_line : fee_quote_lines)
                        {
                            if(map_service_lines.containskey(iefee_line.Service_Rate_Name__c))
                            {
                                map_service_lines.get(iefee_line.Service_Rate_Name__c).add(iefee_line);
                            }
                            else
                            {
                                map_service_lines.put(iefee_line.Service_Rate_Name__c, new List<Import_Export_Fee_Line__c>{iefee_line});
                            }
                        }
                 }
            }      
                  
            if(scm_rule.size() > 0)
            {
                String id_fq = '';
                String fee_alarm_text = scm_rule[0].Fee_Alarm_Text__c;
                fee_alarm_text = fee_alarm_text.replace('(Fee_Name)',fee.Name);
                fee_alarm_text = fee_alarm_text.replace('(Quote_Sell_Price_Old_Value)',(oldfee.Fee_Rate__c != null ? string.valueof(oldfee.Fee_Rate__c) : '0'));
                fee_alarm_text = fee_alarm_text.replace('(Quote_Sell_Price_Price_New_Value)',(fee.Fee_Rate__c != null ? string.valueof(fee.Fee_Rate__c) : '0'));
                
                //FEE QUOTE
                if(map_service_lines.containskey(fee.Id))
                for(Import_Export_Fee_Line__c fql : map_service_lines.get(fee.Id))
                {
                    if(fql.Service_Rate_Name__c == fee.Id)
                    {
                        if(id_fq.contains(fql.Import_Export_Quote__c) == false)
                        {
                            if (!Test.isRunningTest()) 
                                ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, fql.Import_Export_Quote__c, fee_alarm_text);
                            fql.Quote_Sell_Price__c = fee.Fee_Rate__c;
    
                            SCM_Rule_Applied__c new_rule_applied = new SCM_Rule_Applied__c();
                            new_rule_applied.SCM_Rule__c = scm_rule[0].Id;
                            new_rule_applied.Account_for__c = fql.Import_Export_Quote__r.Account_for__c;
                            new_rule_applied.Import_Export_Quote__c = fql.Import_Export_Quote__c;
                            new_rule_applied.Fee_Name__c = fee.Id;
                            rules_applied.add(new_rule_applied);
                            //------------------------
                            for(SCM_Activity__c sc :scm_activity)
                           {
                               Task nueva_tarea = new Task();
                               string subject_activity = (sc.Subject__c != null ? sc.Subject__c : '');
                               if(subject_activity !='')
                               {
                                    subject_activity = subject_activity.replace('(Fee_Name)',(fee.Name != null ? fee.Name : ''));
                                    subject_activity = subject_activity.replace('(Quote_Sell_Price_Old_Value)',(oldfee.Fee_Rate__c != null ? string.valueof(oldfee.Fee_Rate__c) : '0'));
                                    subject_activity = subject_activity.replace('(Quote_Sell_Price_Price_New_Value)',(fee.Fee_Rate__c != null ? string.valueof(fee.Fee_Rate__c) : '0'));
                               }
                               nueva_tarea.Subject = subject_activity;
                               nueva_tarea.Status = 'Completed';
                               nueva_tarea.Priority ='Normal';
                               string description_activity = (sc.Comments__c != null ? sc.Comments__c : '');
                               if(description_activity !='')
                               {
                                    description_activity = description_activity.replace('(Fee_Name)',(fee.Name != null ? fee.Name : ''));
                                    description_activity = description_activity.replace('(Quote_Sell_Price_Old_Value)',(oldfee.Fee_Rate__c != null ? string.valueof(oldfee.Fee_Rate__c) : '0'));
                                    description_activity = description_activity.replace('(Quote_Sell_Price_Price_New_Value)',(fee.Fee_Rate__c != null ? string.valueof(fee.Fee_Rate__c) : '0'));
                               }
                               nueva_tarea.Description = description_activity;
                               if(sc.Assigned_To__c != null)
                                nueva_tarea.OwnerId = sc.Assigned_To__c;
                               else
                                nueva_tarea.OwnerId= fql.Import_Export_Quote__r.LastModifiedBy.Id;
                               nueva_tarea.WhatId = fql.Import_Export_Quote__c;
                               listado_task.add(nueva_tarea);
                           }
                                
                            
                            
                            //-----------
                        }
                        
                        id_fq += fql.Import_Export_Quote__c + '_';
                    }
                }
            }
        }
    }
    
    try
    {
        if(rules_applied != null && rules_applied.size()>0)
            insert rules_applied;
        if(fee_quote_lines != null && fee_quote_lines.size()>0)
            update fee_quote_lines;
        if(listado_task != null && listado_task.size()>0)    
            insert listado_task;
    }
    catch(Exception ex){}
}