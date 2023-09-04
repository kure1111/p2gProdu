trigger NEU_ActualizaFolioIE on Customer_Quote__c (before insert, before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}
    
    if(Test.isRunningTest() || (!RecursiveCheck.triggerMonitor.contains('NEU_ActualizaFolioIE'))){
        RecursiveCheck.triggerMonitor.add('NEU_ActualizaFolioIE');
       	system.debug('Se ejecuto el trigger NEU_ActualizaFolioIE....');
            
        if(trigger.isInsert == true)
        {
            if(trigger.isbefore)
            {
                system.debug('GenerateDateLoad.GenerarTimeResponse 1');
                GenerateDateLoad.GenerarTimeResponse(trigger.new,Trigger.oldMap);
            }
            for(Customer_Quote__c ie : trigger.new)
            {
                string ref = '';
                
                List<IE_Counter__c> contador = [SELECT Contador__c FROM IE_Counter__c FOR UPDATE];
                List<User> user = [SELECT Id, Name, Team__c from User WHERE Id =: UserInfo.getUserId()];        
                
                if(!Test.isRunningTest())
                {   Integer contadorAnual = 0;
                 if(system.now().month() == 12){
                     // contadorAnual = [SELECT COUNT() FROM Customer_Quote__c WHERE CALENDAR_MONTH(CreatedDate) = 12 limit 10];
                     contadorAnual = contadorAnual == 0 ? 1 : contadorAnual;
                 }
                 else{
                     contadorAnual = [SELECT COUNT() FROM Customer_Quote__c WHERE CreatedDate = this_year limit 10];
                 }
                 //Si hemos cambiado de año reiniciamos el contador, si no es así simplemente lo incrementamos
                 
                 
                 if(contadorAnual == 0)
                     contador[0].Contador__c = 1;
                 else
                     contador[0].Contador__c += 1;
                 
                 ie.Numero_Folio__c = contador[0].Contador__c;
                }
                else{ 
                    
                    ie.Numero_Folio__c = 1;
                }
                
                //if(user[0].Team__c == 'P2G' || (user[0].Team__c == 'WCA' && ie.Team__c == 'P2G'))
                
                
                if(ie.Team__c == 'P2G' || (ie.Team__c == null && user[0].Team__c == 'P2G'))
                {
                    //SEA
                    if(ie.Freight_Mode__c == 'Sea'){ref = 'M';}                                            
                    //ROAD
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'FTL'){ref = 'FI';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'LTL'){ref = 'FI';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'FP'){ref = 'FP';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'FO'){ref = 'FO';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'TARIMAS'){ref = 'FI';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'MAYOREO'){ref = 'FI';}                                            
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'FTL'){ref = 'FI';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'LTL'){ref = 'FI';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'FP'){ref = 'FP';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'FO'){ref = 'FO';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'TARIMAS'){ref = 'FI';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'MAYOREO'){ref = 'FI';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'FTL'){ref = 'FN';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'LTL'){ref = 'FN';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'FP'){ref = 'FP';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'FO'){ref = 'FO';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'TARIMAS'){ref = 'T';}                        
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'MAYOREO'){ref = 'PQ';}                        
                    //Folio nuevo para la condicion siguiente por parte de pak2go 31/01/18  Solcom
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'Extras'){ref = 'EX';}                                            
                    if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'INTERNATIONAL'){ref = 'FI';}                        
                    if(ie.Service_Mode__c == 'PORT'){ref = 'PTO';}                                            
                    //AIR
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'INTERNATIONAL' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'INTERNATIONAL' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                        
                    if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'ENVIO NACIONAL'){ref = 'ES';}                        
                }
                else
                {
                    //if(user[0].Team__c == 'WCA')
                    if(ie.Team__c == 'WCA' || (ie.Team__c == null && user[0].Team__c == 'WCA'))
                    {
                        if(ie.Freight_Mode__c == 'Sea')
                        {
                            if(ie.Service_Mode__c == 'IMPORT')
                            {
                                ref = 'R';
                            }
                            else
                            {
                                ref = 'W';
                            }
                        }
                        else if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'EXPORT')
                        {
                            ref = 'AW';
                        }
                        else
                            ref = 'R';
                    }
                }
                
                //La Import-Export tiene servicio de Warehouse
                if(ie.Warehouse__c != null){ref += 'WH';}                    
                //La Import-Export solo tiene servicio de Warehouse
                if(ie.Only_Warehouse_Service__c){ref = 'WH';}                    
                
                if(ie.Comercio_Exterior__c == 'Si'){ ref = 'CE';}
                //}// fin
                //   else
                //     ie.Numero_Folio__c = 1;
                
                String numeroFolio = ie.Numero_Folio__c != null ? String.valueOf(ie.Numero_Folio__c) : '';
                numeroFolio = numeroFolio.removeEnd('.0');
                
                ref += '-'+string.valueof(system.today().year()).right(2)+'-';
                ref += ('000000' + (numeroFolio)).right(6);
                
                ie.Name = ref;
                
                update contador;    
            }
        }
        else if(trigger.isUpdate == true)
        {
            if(trigger.isbefore)
            {
                system.debug('GenerateDateLoad.GenerarTimeResponse 2');
                // GenerateDateLoad.GenerarTimeResponse(trigger.new,Trigger.oldMap);
                NEU_ActualizaFolioIE.GenerarTimeResponse(trigger.new);
                
            }
            
            
            map<string, User> mapUSer = new map<string, User>([SELECT Id, Name, Team__c from User ]);
            //List<User> user = [SELECT Id, Name, Team__c from User WHERE Id =: ie.CreatedById];
            
            
            for(Customer_Quote__c ie : trigger.new)
            {
                Customer_Quote__c old_ie = Trigger.oldMap.get(ie.Id);
                
                if(old_ie.Freight_Mode__c != ie.Freight_Mode__c || old_ie.Service_Mode__c != ie.Service_Mode__c
                   || old_ie.Service_Type__c != ie.Service_Type__c || old_ie.Team__c != ie.Team__c
                   || old_ie.Warehouse__c != ie.Warehouse__c || old_ie.Only_Warehouse_Service__c != ie.Only_Warehouse_Service__c)
                {
                    
                    
                    string ref = '';
                    //if(user[0].Team__c == 'P2G' || (user[0].Team__c == 'WCA' && ie.Team__c == 'P2G'))
                    if(ie.Team__c == 'P2G' || (ie.Team__c == null && mapUSer.get(ie.CreatedById).Team__c == 'P2G'))
                    {
                        //SEA
                        if(ie.Freight_Mode__c == 'Sea'){ref = 'M';}                            
                        
                        //ROAD
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'FTL'){ref = 'FI';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'LTL'){ref = 'FI';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'FP'){ref = 'FP';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'FO'){ref = 'FO';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'TARIMAS'){ref = 'FI';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'MAYOREO'){ref = 'FI';}                                                    
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'FTL'){ref = 'FI';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'LTL'){ref = 'FI';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'FP'){ref = 'FP';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'FO'){ref = 'FO';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'TARIMAS'){ref = 'FI';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'MAYOREO'){ref = 'FI';}                                   
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'FTL'){ref = 'FN';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'LTL'){ref = 'FN';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'FP'){ref = 'FP';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'FO'){ref = 'FO';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'TARIMAS'){ref = 'T';}                            
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'MAYOREO'){ref = 'PQ';}                            
                        //Folio nuevo para la condicion siguiente por parte de pak2go 31/01/18  Solcom
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'Extras'){ref = 'EX';}                                                    
                        if(ie.Freight_Mode__c == 'Road' && ie.Service_Mode__c == 'INTERNATIONAL'){ref = 'FI';}                            
                        if(ie.Service_Mode__c == 'PORT'){ref = 'PTO';}                            
                        
                        //AIR
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'IMPORT' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'EXPORT' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'INTERNATIONAL' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'INTERNATIONAL' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'PAQUETERIA'){ref = 'ES';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'CARGA'){ref = 'A';}                            
                        if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'NATIONAL' && ie.Service_Type__c == 'ENVIO NACIONAL'){ref = 'ES';}                            
                    }
                    else
                    {
                        //if(user[0].Team__c == 'WCA')
                        if(ie.Team__c == 'WCA' || (ie.Team__c == null && mapUSer.get(ie.CreatedById).Team__c == 'WCA'))
                        {
                            if(ie.Freight_Mode__c == 'Sea')
                            {
                                if(ie.Service_Mode__c == 'IMPORT')
                                {
                                    ref = 'R';
                                }
                                else
                                {
                                    ref = 'W';
                                }
                            }
                            else if(ie.Freight_Mode__c == 'Air' && ie.Service_Mode__c == 'EXPORT')
                            {
                                ref = 'AW';
                            }
                            else
                                ref = 'R';
                        }
                    }
                    
                    //La Import-Export tiene servicio de Warehouse 
                    if(ie.Warehouse__c != null){ref += 'WH';}                        
                    //La Import-Export solo tiene servicio de Warehouse
                    if(ie.Only_Warehouse_Service__c){ref = 'WH';}                        
                    
                    if(ie.Comercio_Exterior__c == 'Si'){ref = 'CE';}
                    
                    String numeroFolio = ie.Numero_Folio__c != null ? String.valueOf(ie.Numero_Folio__c) : '';
                    numeroFolio = numeroFolio.removeEnd('.0');
                    
                    ref += '-'+string.valueof(system.today().year()).right(2)+'-';
                    ref += ('000000' + (numeroFolio)).right(6);
                    
                    
                    
                    ie.Name = ref;
                }
                else
                    ie.Name = old_ie.Name;
                
                
            }
        }

    
    	/*if(Test.isRunningTest())
    	{
        string       Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
    }*/
    }    
}