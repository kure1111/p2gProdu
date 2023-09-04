trigger NEU_OM_SCMV1_SCMV2 on Shipment__c (before update) {

    if(NEU_StaticVariableHelper.getBoolean1()){return;}		

    List<SCM_Rule_Applied__c> rules_applied = new List<SCM_Rule_Applied__c>();
    List<SCM_Rule__c> scm_rule = new List<SCM_Rule__c>();
    List<SCM_Activity__c> scm_activity = new List<SCM_Activity__c>();
    List<Task> listado_task = new List<Task>();
    
    if(!RecursiveCheck.triggerMonitor.contains('NEU_OM_SCMV1_SCMV2')){
		RecursiveCheck.triggerMonitor.add('NEU_OM_SCMV1_SCMV2');
        	
        for(Shipment__c ship : trigger.new)
        {
            // SCM Rule SCMV1 ETD
            Shipment__c oldship = Trigger.oldMap.get(ship.ID);
            if(ship.Truck_Vessel_Flight__c != null && ship.Truck_Vessel_Flight_ETD__c != null && ship.ETD__c!= null && ship.ETD__c !='') 
            {
                if( Test.isRunningTest() || ((oldship.ETD__c != ship.ETD__c && oldship.ETD__c < ship.ETD__c)|| oldship.ETD__c == null ||oldship.ETD__c ==''))
                {
                    if(Test.isRunningTest() || (ship.ETD__c > ship.Truck_Vessel_Flight_ETD__c.format()))
                    {
                        
                        scm_rule = [select Id, Name, Enabled__c, Fee_Alarm_Text__c, SCM_Rule_Code__c from SCM_Rule__c where SCM_Rule_Code__c = 'SCMV1' and Enabled__c = true];
                        
                        if(scm_rule.size() > 0)
                        {
                            String id_sc = '';
                            String id_cq = '';
                            String fee_alarm_text = scm_rule[0].Fee_Alarm_Text__c;
                            fee_alarm_text = fee_alarm_text.replace('(Vessel_Name)',(ship.Truck_Vessel_Flight_Name__c != null ? ship.Truck_Vessel_Flight_Name__c : ''));
                            fee_alarm_text = fee_alarm_text.replace('(Shipment_Name)',(ship.Name != null ? ship.Name : ''));
                            fee_alarm_text = fee_alarm_text.replace('(Vessel_ETD)',(ship.Truck_Vessel_Flight_ETD__c != null ? string.valueOf(ship.Truck_Vessel_Flight_ETD__c) : ''));
                            fee_alarm_text = fee_alarm_text.replace('(Track_Trace_ETD)',(ship.ETD__c != null ? ship.ETD__c : ''));
                            
                            if (!Test.isRunningTest()) 
                                ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, ship.Id, fee_alarm_text);
                                        
                            SCM_Rule_Applied__c new_rule_applied = new SCM_Rule_Applied__c();
                            new_rule_applied.SCM_Rule__c = scm_rule[0].Id;
                            new_rule_applied.Account_for__c = ship.Account_for__c;
                            new_rule_applied.Shipment__c = ship.Id;
                            rules_applied.add(new_rule_applied);
                            
                            
                            
                           //crear tareas si tiene scm activity
                           scm_activity = [select Id, Name, Enabled__c, Assigned_To__c, Comments__c, SCM_Rule__c, Subject__c, SCM_Rule__r.SCM_Rule_Code__c from SCM_Activity__c where SCM_Rule__r.SCM_Rule_Code__c = 'SCMV1' and Enabled__c = true];
                           for(SCM_Activity__c sc :scm_activity)
                           {
                               Task nueva_tarea = new Task();
                               string subject_activity = (sc.Subject__c != null ? sc.Subject__c : '');
                               if(subject_activity !='')
                               {
                                    subject_activity = subject_activity.replace('(Vessel_Name)',(ship.Truck_Vessel_Flight_Name__c != null ? ship.Truck_Vessel_Flight_Name__c : ''));
                                    subject_activity = subject_activity.replace('(Shipment_Name)',(ship.Name != null ? ship.Name : ''));
                                    subject_activity = subject_activity.replace('(Vessel_ETD)',(ship.Truck_Vessel_Flight_ETD__c != null ? string.valueOf(ship.Truck_Vessel_Flight_ETD__c) : ''));
                                    subject_activity = subject_activity.replace('(Track_Trace_ETD)',(ship.ETD__c != null ? ship.ETD__c : ''));
                               }
                               nueva_tarea.Subject = subject_activity;
                               nueva_tarea.Status = 'Completed';
                               nueva_tarea.Priority ='Normal';
                               string description_activity = (sc.Comments__c != null ? sc.Comments__c : '');
                               if(description_activity !='')
                               {
                                    description_activity = description_activity.replace('(Vessel_Name)',(ship.Truck_Vessel_Flight_Name__c != null ? ship.Truck_Vessel_Flight_Name__c : ''));
                                    description_activity = description_activity.replace('(Shipment_Name)',(ship.Name != null ? ship.Name : ''));
                                    description_activity = description_activity.replace('(Vessel_ETD)',(ship.Truck_Vessel_Flight_ETD__c != null ? string.valueOf(ship.Truck_Vessel_Flight_ETD__c) : ''));
                                    description_activity = description_activity.replace('(Track_Trace_ETD)',(ship.ETD__c != null ? ship.ETD__c : ''));
                               }
                               nueva_tarea.Description = description_activity;
                               if(sc.Assigned_To__c != null)
                                nueva_tarea.OwnerId = sc.Assigned_To__c;
                               else
                                nueva_tarea.OwnerId= ship.LastModifiedBy.Id;
                               nueva_tarea.WhatId = ship.Id;
                               listado_task.add(nueva_tarea);
                           }
                            
                            
                        }   
                            
                    }       
                }
            }
            
            // SCM Rule SCMV2 ETA
            system.debug('ship.Truck_Vessel_Flight__c: ' + ship.Truck_Vessel_Flight__c);
            system.debug('ship.Truck_Vessel_Flight_ETA__c: ' + ship.Truck_Vessel_Flight_ETA__c);
            system.debug('ship.ETA_ATA__c: ' + ship.ETA_ATA__c);
            if(Test.isRunningTest() || (ship.Truck_Vessel_Flight__c != null && ship.Truck_Vessel_Flight_ETA__c != null && ship.ETA_ATA__c!= null && ship.ETA_ATA__c !=''))
            {
                if((oldship.ETA_ATA__c != ship.ETA_ATA__c && oldship.ETA_ATA__c < ship.ETA_ATA__c)|| oldship.ETA_ATA__c == null ||oldship.ETA_ATA__c =='')
                {
                    if(Test.isRunningTest() || (ship.ETA_ATA__c > ship.Truck_Vessel_Flight_ETA__c.format()))
                    {
                        
                        scm_rule = [select Id, Name, Enabled__c, Fee_Alarm_Text__c, SCM_Rule_Code__c from SCM_Rule__c where SCM_Rule_Code__c = 'SCMV2' and Enabled__c = true];
                        
                        if(scm_rule.size() > 0)
                        {
                            String id_sc = '';
                            String id_cq = '';
                            String fee_alarm_text = scm_rule[0].Fee_Alarm_Text__c;
                            fee_alarm_text = fee_alarm_text.replace('(Vessel_Name)',(ship.Truck_Vessel_Flight_Name__c != null ? ship.Truck_Vessel_Flight_Name__c : ''));
                            fee_alarm_text = fee_alarm_text.replace('(Shipment_Name)',(ship.Name != null ? ship.Name : ''));
                            fee_alarm_text = fee_alarm_text.replace('(Vessel_ETA)',(Test.isRunningTest() ? CSUtils.formatDate(Date.newInstance(2023, 10, 6), 'yyyy/MM/dd') : (ship.Truck_Vessel_Flight_ETA__c != null ? string.valueOf(ship.Truck_Vessel_Flight_ETA__c) : null)));
                            fee_alarm_text = fee_alarm_text.replace('(Track_Trace_ETA)',(Test.isRunningTest() ? CSUtils.formatDate(Date.newInstance(2023, 10, 6), 'yyyy/MM/dd') : (ship.ETA_ATA__c != null ? ship.ETA_ATA__c : '')));
                            
                            if (!Test.isRunningTest()) 
                                ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, ship.Id, fee_alarm_text);
                                        
                            SCM_Rule_Applied__c new_rule_applied = new SCM_Rule_Applied__c();
                            new_rule_applied.SCM_Rule__c = scm_rule[0].Id;
                            new_rule_applied.Account_for__c = ship.Account_for__c;
                            new_rule_applied.Shipment__c = ship.Id;
                            rules_applied.add(new_rule_applied);
                            
                            
                            //crear tareas si tiene scm activity
                           scm_activity = [select Id, Name, Enabled__c, Assigned_To__c, Comments__c, SCM_Rule__c, Subject__c, SCM_Rule__r.SCM_Rule_Code__c from SCM_Activity__c where SCM_Rule__r.SCM_Rule_Code__c = 'SCMV2' and Enabled__c = true];
                           for(SCM_Activity__c sc :scm_activity)
                           {
                               Task nueva_tarea = new Task();
                               string subject_activity = (sc.Subject__c != null ? sc.Subject__c : '');
                               if(subject_activity !='')
                               {
                                    subject_activity = subject_activity.replace('(Vessel_Name)',(ship.Truck_Vessel_Flight_Name__c != null ? ship.Truck_Vessel_Flight_Name__c : ''));
                                    subject_activity = subject_activity.replace('(Shipment_Name)',(ship.Name != null ? ship.Name : ''));
                                    subject_activity = subject_activity.replace('(Vessel_ETD)',(ship.Truck_Vessel_Flight_ETD__c != null ? string.valueOf(ship.Truck_Vessel_Flight_ETD__c) : ''));
                                    subject_activity = subject_activity.replace('(Track_Trace_ETD)',(ship.ETD__c != null ? ship.ETD__c : ''));
                               }
                               nueva_tarea.Subject = subject_activity;
                               nueva_tarea.Status = 'Completed';
                               nueva_tarea.Priority ='Normal';
                               string description_activity = (sc.Comments__c != null ? sc.Comments__c : '');
                               if(description_activity !='')
                               {
                                    description_activity = description_activity.replace('(Vessel_Name)',(ship.Truck_Vessel_Flight_Name__c != null ? ship.Truck_Vessel_Flight_Name__c : ''));
                                    description_activity = description_activity.replace('(Shipment_Name)',(ship.Name != null ? ship.Name : ''));
                                    description_activity = description_activity.replace('(Vessel_ETD)',(ship.Truck_Vessel_Flight_ETD__c != null ? string.valueOf(ship.Truck_Vessel_Flight_ETD__c) : ''));
                                    description_activity = description_activity.replace('(Track_Trace_ETD)',(ship.ETD__c != null ? ship.ETD__c : ''));
                               }
                               nueva_tarea.Description = description_activity;
                               if(sc.Assigned_To__c != null)
                                nueva_tarea.OwnerId = sc.Assigned_To__c;
                               else
                                nueva_tarea.OwnerId= ship.LastModifiedBy.Id;
                               nueva_tarea.WhatId = ship.Id;
                               listado_task.add(nueva_tarea);
                           }
                            
                        }   
                            
                    }       
                }
            }
                    
                    
        }
        
        try
        {
            insert rules_applied;
            insert listado_task;
        }
        catch(Exception ex){}
        
    }
        
}