trigger NEU_MD_SCMR1 on Sourcing_Item__c (before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;
    
    List<Shopping_Cart_line__c> shopping_cart_lines = null;
    List<Quote_Item_Line__c> customer_quote_lines = null;
    List<SCM_Rule_Applied__c> rules_applied = new List<SCM_Rule_Applied__c>();
    
    List<SCM_Activity__c> scm_activity = null;
    List<SCM_Rule__c> scm_rule = null;
    List<Task> listado_task = new List<Task>();
    
    Set<Id> list_ids_items = new Set<Id>();
    Map<Id, List<Shopping_Cart_line__c>> map_service_lines_scl = new Map<Id, List<Shopping_Cart_line__c>>();
    Map<Id, List<Quote_Item_Line__c>> map_item_lines_qil = new Map<Id, List<Quote_Item_Line__c>>();
    for(Sourcing_Item__c item : trigger.new)
    {
        Sourcing_Item__c olditem = Trigger.oldMap.get(item.ID);

        if(olditem.Item_Price__c != item.Item_Price__c)
        {
             list_ids_items.add(item.Id);
        }
    }
    
    for(Sourcing_Item__c item : trigger.new)
    {
        Sourcing_Item__c olditem = Trigger.oldMap.get(item.ID);

        if(olditem.Item_Price__c != item.Item_Price__c)
        { 
            if(scm_rule == null)
            {
                scm_rule = [select Id, Name, Enabled__c, Fee_Alarm_Text__c, SCM_Rule_Code__c from SCM_Rule__c where SCM_Rule_Code__c = 'SCMR1' and Enabled__c = true];
                //crear tareas si tiene scm activity
                scm_activity = [select Id, Name, Enabled__c, Assigned_To__c, Comments__c, SCM_Rule__c, Subject__c, SCM_Rule__r.SCM_Rule_Code__c from SCM_Activity__c where SCM_Rule__r.SCM_Rule_Code__c = 'SCMR1' and Enabled__c = true];
                //SHOPPING CART
                if(scm_rule.size() > 0)
                {
                    if(shopping_cart_lines == null)
                         shopping_cart_lines = [select Id, Name, Offer_Price__c, List_Price__c, Item_Price__c, Item_Name__c, Shopping_Cart__c, Shopping_Cart__r.Status__c, Shopping_Cart__r.Customer__c, Shopping_Cart__r.LastModifiedBy.Id from Shopping_Cart_line__c where Item_Name__c IN: list_ids_items and Shopping_Cart__r.Status__c != 'Consolidated'];
                         for(Shopping_Cart_line__c sc_fee_line : shopping_cart_lines)
                        {
                            if(map_service_lines_scl.containskey(sc_fee_line.Item_Name__c))
                            {
                                map_service_lines_scl.get(sc_fee_line.Item_Name__c).add(sc_fee_line);
                            }
                            else
                            {
                                map_service_lines_scl.put(sc_fee_line.Item_Name__c, new List<Shopping_Cart_line__c>{sc_fee_line});
                            }
                        }
                }
            }      
                  
            if(scm_rule.size() > 0)
            {
                String id_sc = '';
                String id_cq = '';
                String fee_alarm_text = scm_rule[0].Fee_Alarm_Text__c;
                fee_alarm_text = fee_alarm_text.replace('(Item_Name)',(item.Name != null ? item.Name : ''));
                fee_alarm_text = fee_alarm_text.replace('(Item_Price_Old_Value)',(olditem.Item_Price__c != null ? string.valueof(olditem.Item_Price__c) : '0'));
                fee_alarm_text = fee_alarm_text.replace('(Item_Price_New_Value)',(item.Item_Price__c != null ? string.valueof(item.Item_Price__c) : '0'));

                if(map_service_lines_scl.containskey(item.id))
                for(Shopping_Cart_line__c spl : map_service_lines_scl.get(item.Id))
                {
                    if(spl.Item_Name__c == item.Id)
                    {
                        if(id_sc.contains(spl.Shopping_Cart__c) == false)
                        {
                            if((spl.Offer_Price__c == null || spl.Offer_Price__c <= 0) && (spl.List_Price__c == null || spl.List_Price__c <= 0))
                            {
                                if (!Test.isRunningTest()) 
                                    ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, spl.Shopping_Cart__c, fee_alarm_text);
                            }
                            spl.Item_Price__c = item.Item_Price__c;
                            
                            SCM_Rule_Applied__c new_rule_applied = new SCM_Rule_Applied__c();
                            new_rule_applied.SCM_Rule__c = scm_rule[0].Id;
                            new_rule_applied.Account_for__c = spl.Shopping_Cart__r.Customer__c;
                            new_rule_applied.Shopping_Cart__c = spl.Shopping_Cart__c;
                            new_rule_applied.Item__c = item.Id;
                            rules_applied.add(new_rule_applied);
                            
                            //-------------------------------------
                            
                           for(SCM_Activity__c sc :scm_activity)
                           {
                               Task nueva_tarea = new Task();
                               string subject_activity = (sc.Subject__c != null ? sc.Subject__c : '');
                               if(subject_activity !='')
                               {
                                    subject_activity = subject_activity.replace('(Item_Name)',(item.Name != null ? item.Name : ''));
                                    subject_activity = subject_activity.replace('(Item_Price_Old_Value)',(olditem.Item_Price__c != null ? string.valueof(olditem.Item_Price__c) : '0'));
                                    subject_activity = subject_activity.replace('(Item_Price_New_Value)',(item.Item_Price__c != null ? string.valueof(item.Item_Price__c) : '0'));
                               }
                               nueva_tarea.Subject = subject_activity;
                               nueva_tarea.Status = 'Completed';
                               nueva_tarea.Priority ='Normal';
                               string description_activity = (sc.Comments__c != null ? sc.Comments__c : '');
                               if(description_activity !='')
                               {
                                    description_activity = description_activity.replace('(Item_Name)',(item.Name != null ? item.Name : ''));
                                    description_activity = description_activity.replace('(Item_Price_Old_Value)',(olditem.Item_Price__c != null ? string.valueof(olditem.Item_Price__c) : ''));
                                    description_activity = description_activity.replace('(Item_Price_New_Value)',(item.Item_Price__c != null ? string.valueof(item.Item_Price__c) : '0'));
                               }
                               nueva_tarea.Description = description_activity;
                               if(sc.Assigned_To__c != null)
                                nueva_tarea.OwnerId = sc.Assigned_To__c;
                               else
                                nueva_tarea.OwnerId= spl.Shopping_Cart__r.LastModifiedBy.Id;
                               nueva_tarea.WhatId = spl.Shopping_Cart__c;
                               listado_task.add(nueva_tarea);
                           }
                            
                            //--------------------------------------
                            
                        }
                        
                        id_sc += spl.Shopping_Cart__c + '_';
                    }
                }

                //CUSTOMER QUOTE
                if(customer_quote_lines == null)
                {
                   customer_quote_lines = [select Id, Name, Item_Name__c, Import_Export_Quote__c, Import_Export_Quote__r.Quotation_Status__c, Import_Export_Quote__r.Account_for__c, Import_Export_Quote__r.LastModifiedBy.Id from Quote_Item_Line__c where Item_Name__c IN: list_ids_items and Import_Export_Quote__r.Quotation_Status__c != 'Approved as Succesful' and Import_Export_Quote__r.Quotation_Status__c != 'Declined' and Import_Export_Quote__r.Quotation_Status__c != 'Shipped'];
                   for(Quote_Item_Line__c qi_fee_line : customer_quote_lines)
                   {    
                        if(map_item_lines_qil.containskey(qi_fee_line.Item_Name__c))
                        {
                            map_item_lines_qil.get(qi_fee_line.Item_Name__c).add(qi_fee_line);
                        }
                        else
                        {
                            map_item_lines_qil.put(qi_fee_line.Item_Name__c, new List<Quote_Item_Line__c>{qi_fee_line});
                        }
                    }
                }
                if(map_item_lines_qil.containskey(item.Id))
                for(Quote_Item_Line__c cql : map_item_lines_qil.get(item.Id))
                {
                    if(cql.Item_Name__c == item.Id)
                    {
                        if(id_cq.contains(cql.Import_Export_Quote__c) == false)
                        {
                            if (!Test.isRunningTest()) 
                                ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, cql.Import_Export_Quote__c, fee_alarm_text);
                            
                            SCM_Rule_Applied__c new_rule_applied = new SCM_Rule_Applied__c();
                            new_rule_applied.SCM_Rule__c = scm_rule[0].Id;
                            new_rule_applied.Account_for__c = cql.Import_Export_Quote__r.Account_for__c;
                            new_rule_applied.Import_Export_Quote__c = cql.Import_Export_Quote__c;
                            new_rule_applied.Item__c = item.Id;
                            rules_applied.add(new_rule_applied);
                            
                            
                                //-------------------------------------
                            
                           for(SCM_Activity__c sc :scm_activity)
                           {
                               Task nueva_tarea = new Task();
                               string subject_activity = (sc.Subject__c != null ? sc.Subject__c : '');
                               if(subject_activity !='')
                               {
                                    subject_activity = subject_activity.replace('(Item_Name)',(item.Name != null ? item.Name : ''));
                                    subject_activity = subject_activity.replace('(Item_Price_Old_Value)',(olditem.Item_Price__c != null ? string.valueof(olditem.Item_Price__c) : '0'));
                                    subject_activity = subject_activity.replace('(Item_Price_New_Value)',(item.Item_Price__c != null ? string.valueof(item.Item_Price__c) : '0'));
                               }
                               nueva_tarea.Subject = subject_activity;
                               nueva_tarea.Status = 'Completed';
                               nueva_tarea.Priority ='Normal';
                               string description_activity = (sc.Comments__c != null ? sc.Comments__c : '');
                               if(description_activity !='')
                               {
                                    description_activity = description_activity.replace('(Item_Name)',(item.Name != null ? item.Name : ''));
                                    description_activity = description_activity.replace('(Item_Price_Old_Value)',(olditem.Item_Price__c != null ? string.valueof(olditem.Item_Price__c) : ''));
                                    description_activity = description_activity.replace('(Item_Price_New_Value)',(item.Item_Price__c != null ? string.valueof(item.Item_Price__c) : '0'));
                               }
                               nueva_tarea.Description = description_activity;
                               if(sc.Assigned_To__c != null)
                                nueva_tarea.OwnerId = sc.Assigned_To__c;
                               else
                                nueva_tarea.OwnerId= cql.Import_Export_Quote__r.LastModifiedBy.Id;
                               nueva_tarea.WhatId = cql.Import_Export_Quote__c;
                               listado_task.add(nueva_tarea);
                           }
                            
                            //--------------------------------------
                        }
                    
                        id_cq += cql.Import_Export_Quote__c + '_';
                    }
                }   
                
            }
        }
    }
    
    try
    {
        if(rules_applied != null && rules_applied.size()>0)
            insert rules_applied;
        if(shopping_cart_lines != null && shopping_cart_lines.size()>0)    
            update shopping_cart_lines;
        if(listado_task != null && listado_task.size()>0)    
            insert listado_task;
    }
    catch(Exception ex){}
}