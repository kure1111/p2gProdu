public  class NEU_ActualizaFolioIE {

    public static void GenerarTimeResponse(list<Customer_Quote__c> listaQuote)
    {
        datetime FechaDataSend = null;
        datetime FechaDatePricing = null;
        datetime fechaTotal = datetime.now();
        Time HorarioEntrada = Time.newInstance(9, 0, 0, 0);
        Time HorarioSalida = Time.newInstance(18, 30, 0, 0);
        Time HorarioSalidaSabado = Time.newInstance(13, 0, 0, 0);
        for(Customer_Quote__c cq : listaQuote)
        {
            if(cq.Date_Send_Request__c != null && cq.Date_Pricing_responded__c != null)
            {
                time tiempoTotal = Time.newInstance(0, 0, 0, 0);
                time tiempoResultado = Time.newInstance(0, 0, 0, 0);
				String tipo = cq.name.substring(0,3);
                Integer offset = UserInfo.getTimezone().getOffset(cq.Date_Send_Request__c);
				FechaDataSend = cq.Date_Send_Request__c.addSeconds(offset/1000);
                offset = UserInfo.getTimezone().getOffset(cq.Date_Pricing_responded__c);
                FechaDatePricing = cq.Date_Pricing_responded__c.addSeconds(offset/1000);
                system.debug('FechaDataSend = ' + FechaDataSend.timeGmt());
                system.debug('FechaDatePricing = ' + FechaDatePricing.timeGmt());
                integer intDays =  FechaDataSend.Date().daysBetween(FechaDatePricing.Date());
                system.debug('intDays = ' + intDays);
                     
                if(intDays > 0)
                {
                    String dayOfWeek ='';
                    for (Integer i = 0; i <= intDays; i++) {
                        
                        FechaDataSend = FechaDataSend.addDays(i);
                        tiempoResultado = Time.newInstance(0, 0, 0, 0);
                     
                        if(FechaDataSend.date() == cq.Date_Pricing_responded__c.Date()){
                            FechaDataSend = FechaDatePricing;
                        }
                        
                        dayOfWeek = FechaDataSend.format('E');
                        
                        if(tipo =='FN-' && dayOfWeek == 'Sat')
                        {
                            
                            tiempoResultado = tiempoTranscurrido(FechaDataSend,HorarioEntrada,HorarioSalidaSabado,false);
                        }
                        else if(dayOfWeek == 'Sun' || dayOfWeek == 'Sat')
                            continue;
						
                        
                        
                        if(FechaDataSend.date() != cq.Date_Send_Request__c.Date() && FechaDataSend.date() != cq.Date_Pricing_responded__c.Date()){
                            
                            if(dayOfWeek == 'Sat'){
                                tiempoTotal = tiempoTotal.addHours(4);
                            	tiempoTotal = tiempoTotal.addMinutes(0);
                            }else{
                                tiempoTotal = tiempoTotal.addHours(9);
                           		tiempoTotal = tiempoTotal.addMinutes(30);
                            }
                            
                            system.debug('DiaCompleto = ' + tiempoTotal);
                        }else{
                            if(FechaDataSend.date() == cq.Date_Send_Request__c.Date())
                            {
                                tiempoResultado = tiempoTranscurrido(FechaDataSend,HorarioEntrada,HorarioSalida,false);
                            	system.debug('tiempoResultadoSend_Request = ' + tiempoResultado);
                            }else{
                                tiempoResultado = tiempoTranscurrido(FechaDataSend,HorarioEntrada,HorarioSalida,true);
                            }
                            
                        }
                     
                        
                        tiempoTotal = tiempoTotal.addHours(tiempoResultado.hour());
                        tiempoTotal = tiempoTotal.addMinutes(tiempoResultado.minute());
                        
                    }//end for
                    system.debug('Tiempo Total Dias = ' + tiempoTotal);
                    cq.Time_Response_HR__c = tiempoTotal.hour()+':'+tiempoTotal.minute();
                }
                else{
                   cq.Time_Response_HR__c ='00:00';
                   if(FechaDataSend.timeGmt() < HorarioEntrada ) 
                   {
                        FechaDataSend = DateTime.newInstanceGmt(FechaDataSend.date(), HorarioEntrada);
                   }
                   if((FechaDatePricing.timeGmt() >= HorarioEntrada && FechaDatePricing.timeGmt() <= HorarioSalida) &&(FechaDataSend.timeGmt() >= HorarioEntrada && FechaDataSend.timeGmt() <= HorarioSalida))
                   {
                        Long  timeAvailable = FechaDatePricing.getTime() - FechaDataSend.getTime();
                        system.debug('Tiempo Total = ' + datetime.newInstance(timeAvailable).timeGmt());
                        time tiempoTranscurrido = datetime.newInstance(timeAvailable).timeGmt();
                        cq.Time_Response_HR__c = tiempoTranscurrido.hour()+':'+ tiempoTranscurrido.minute();
                   }
                    
                }
              
                            
            }
        }
    }
    public static time tiempoTranscurrido(datetime Fecha,Time HorarioEntrada,Time HorarioSalida,boolean fechaFinal)
    {

 		    Long timeAvailable =0; 	    
        
        		if(Fecha.timeGmt() >= HorarioEntrada && Fecha.timeGmt() <= HorarioSalida)
                {
                    for (Integer i = HorarioEntrada.hour(); i <= HorarioSalida.hour(); i++) {
                       
                        if(fecha.timeGmt() >= Time.newInstance(i, 00, 0, 0) && fecha.timeGmt() <= Time.newInstance(i, 59, 59, 0))
                        {
                            if(fechaFinal)
                            {
                                datetime fechaHoraEntrada =  DateTime.newInstanceGmt(Date.today(), HorarioEntrada);
                                datetime fechaIngresada =  DateTime.newInstanceGmt(Date.today(), fecha.timeGmt());
                                timeAvailable =  fechaIngresada.getTime() - fechaHoraEntrada.getTime();
                                }else{
                                datetime fechaSalida =  DateTime.newInstance(Date.today(), HorarioSalida);
                                datetime fechaIngresada =  DateTime.newInstance(Date.today(), fecha.timeGmt());
                                timeAvailable = fechaSalida.getTime() - fechaIngresada.getTime();
                               
                            }  
                                break; 
                            
                        }
                        
                    } // endfor
                    	
                }
              system.debug('tiempo = ' + datetime.newInstance(timeAvailable).timeGmt());
        	return datetime.newInstance(timeAvailable).timeGmt();
        
    }
    
}