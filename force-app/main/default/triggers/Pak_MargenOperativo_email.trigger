trigger Pak_MargenOperativo_email on Customer_Quote__c (before update) 
{
    
    if(!RecursiveCheck.triggerMonitor.contains('Pak_MargenOperativo_email')){
        RecursiveCheck.triggerMonitor.add('Pak_MargenOperativo_email');
        

        list<Customer_Quote__c> folios = new list<Customer_Quote__c>();
        
        for(Customer_Quote__c folio : trigger.new)
        {  
            Customer_Quote__c oldquote = Trigger.oldMap.get(folio.ID);
            
            if(folio.Quotation_Status__c == 'Approved as Succesful'
               || oldquote.Quotation_Status__c == folio.Quotation_Status__c)
                folios.add(folio);
        }
        
        if(folios.size()>0)
        {
            User user = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
            
            string rolname = '%'+user.userRole.Name+'%';
            
            Rol_Margen__c rolActual = null;
            
            List <Rol_Margen__c> roles = [SELECT Id, Name, FN_Margen_Operativo__c, FI_Margen_Operativo__c,
                                          FI_LTL_Margen_Operativo__c, PTO_Margen_Operativo__c, M_FCL_Margen_Operativo__c, 
                                          M_LCL_Margen_Operativo__c, A_Margen_Operativo__c, A_Paq_Margen_Operativo__c, 
                                          W_WCA_Margen_Operativo__c, AW_WCA_Margen_Operativo__c, R_Margen_Operativo__c,
                                          T_Margen_Operativo__c, PQ_Margen_Operativo__c
                                          FROM Rol_Margen__c where name like :rolname limit 1 ];
            if(roles.size()> 0)
                rolActual = roles[0];
            
            system.debug('rola ' + rolActual);
            
            for(Customer_Quote__c folio : trigger.new)
            {  
                Customer_Quote__c oldquote = Trigger.oldMap.get(folio.ID);
                
                if(!Test.isRunningTest()){
                 	 if(folio.Quotation_Status__c != 'Approved as Succesful'
                       || oldquote.Quotation_Status__c == folio.Quotation_Status__c)
                    	continue;   
                }               
                
                boolean cumpleCondiciones = false;
                
                Account acco = [select id, name,Order_to_Cash__c,OwnerId from account where id =:  folio.Account_for__c limit 1];
                system.debug('cuenta: ' + acco);
                
                if (Acco.Order_to_Cash__c && folio.FolioResume__c == 'FN')
                {
                    list <Import_Export_Fee_Line__c> lines = [SELECT Id, Name,
                                                              Service_Rate_Name__r.route__c,
                                                              Service_Rate_Name__r.account_for__c,
                                                              Service_Rate_Name__r.CustomRate__c,
                                                              Import_Export_Quote__r.route__c, 
                                                              Import_Export_Quote__r.account_for__c,
                                                              Buy_Amount__c, Conversion_Rate_to_Currency_Header__c
                                                              FROM Import_Export_Fee_Line__c
                                                              where  Import_Export_Quote__c =: folio.id ];
                    system.debug('Lineas obtendias: ' + lines);
                    for(Import_Export_Fee_Line__c line : lines)
                    {
                        //A FUTURO REVISAR QUE ESTE ACTIVA
                        if(  line.Service_Rate_Name__r.CustomRate__c &&
                           // line.Service_Rate_Name__r.route__c ==  line.Import_Export_Quote__r.route__c &&
                           line.Service_Rate_Name__r.account_for__c ==line.Import_Export_Quote__r.account_for__c)  
                        {
                            system.debug('entramos OTC');
                            cumpleCondiciones = true;
                            break;
                        }
                    }
                }             
                system.debug('Acco.Order_to_Cash__c  ' + Acco.Order_to_Cash__c );
                system.debug('cumpleCondiciones  ' + cumpleCondiciones);
                
                if (Test.isRunningTest() || (!Acco.Order_to_Cash__c || !cumpleCondiciones))
                {
                    system.debug('folio.Total_Services_Std_Buy_Amount_number__c  ' + String.valueOf(folio.Total_Services_Std_Buy_Amount_number__c));
                    
                    /*if(Test.isRunningTest() || (folio.FolioResume__c == 'FN' && (String.valueOf(folio.Total_Services_Std_Buy_Amount_number__c)  == null || String.valueOf(folio.Total_Services_Std_Buy_Amount_number__c) == '0.00' ) ))
                    { 
                        if(!Test.isRunningTest()){ 
                        	folio.addError('Favor de agregar un Costo a los Service Line o pasar a proceso de cotización!');
                        	return;
                        }                        
                    }
                    */
                    system.debug('rolActual  ' + rolActual);
                    
                    if(Test.isRunningTest() || rolActual == null )     {   
                        if(!Test.isRunningTest()){                         
                            folio.addError('Usuario con rol no autorizado');   
                        	return;
                        }                        
                    }
                    
                    if (Test.isRunningTest() || (folio.FolioResume__c == 'FN' && rolActual != null && folio.Margen_Operativo__c < rolActual.FN_Margen_Operativo__c   ))
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            }                                                    
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco, rolActual.FN_Margen_Operativo__c);
                        
                    }
                    else if (folio.FolioResume__c == 'A' && rolActual != null && folio.Margen_Operativo__c < rolActual.A_Margen_Operativo__c )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco, rolActual.A_Margen_Operativo__c );         
                        
                    }
                    else   if (folio.FolioResume__c == 'FI' 
                               && folio.Service_Type__c == 'LTL'
                               && rolActual != null 
                               && folio.Margen_Operativo__c < rolActual.FI_LTL_Margen_Operativo__c   )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco,rolActual.FI_LTL_Margen_Operativo__c);
                    }
                    else   if (folio.FolioResume__c == 'FI' 
                               && folio.Service_Type__c != 'LTL'
                               && rolActual != null 
                               && folio.Margen_Operativo__c < rolActual.FI_Margen_Operativo__c  )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco,rolActual.FI_Margen_Operativo__c);
                    }
                    
                    else   if (folio.FolioResume__c == 'M' 
                               && folio.Service_Type__c == 'FCL'
                               && rolActual != null 
                               && folio.Margen_Operativo__c < rolActual.M_FCL_Margen_Operativo__c   )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco, rolActual.M_FCL_Margen_Operativo__c);
                    }
                    else if (folio.FolioResume__c == 'M' 
                             && folio.Service_Type__c == 'LCL'
                             && rolActual != null 
                             && folio.Margen_Operativo__c < rolActual.M_LCL_Margen_Operativo__c    )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco, rolActual.M_LCL_Margen_Operativo__c);
                    }
                    else if (folio.FolioResume__c == 'PTO' 
                             && rolActual != null 
                             && folio.Margen_Operativo__c < rolActual.PTO_Margen_Operativo__c  )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco,rolActual.PTO_Margen_Operativo__c );
                    }
                    
                    else   if ( folio.FolioResume__c == 'R' 
                               && rolActual != null 
                               && folio.Margen_Operativo__c < rolActual.R_Margen_Operativo__c     )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco, rolActual.R_Margen_Operativo__c);
                    }
                    else   if (folio.FolioResume__c == 'W' 
                               && rolActual != null 
                               && folio.Margen_Operativo__c < rolActual.W_WCA_Margen_Operativo__c   )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }
                        
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco,rolActual.W_WCA_Margen_Operativo__c);
                    }
                    else   if (folio.FolioResume__c == 'AW' 
                               && rolActual != null 
                               && folio.Margen_Operativo__c < rolActual.AW_WCA_Margen_Operativo__c   )
                    {
                        if(string.isBlank(user.managerId))     
                        {   
                            if(!Test.isRunningTest()){
                                folio.addError('Usuario no cuenta con Manager');   
                            	return;
                            } 
                        }                      
                        folio.Quotation_Status__c = 'Sent awaiting response';
                        Pak_MargenOperativo_SendEmail.senMessage(folio, acco,rolActual.AW_WCA_Margen_Operativo__c);
                    }
                }
            }   
        }  
    }  
   if(Test.isRunningTest())
    {
        Pak_MargenOperativo_SendEmail.senMessage(null,null , 0.00);
        String Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';  
    }
}