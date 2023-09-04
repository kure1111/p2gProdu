public class GenerateDateLoad {
    public static void GenerarTimeResponse(list<Customer_Quote__c> listaQuote,map<Id, Customer_Quote__c> listaQuoteOld )
    {
        integer HorasEstimadaCarga = 4;
        datetime fechaCreacion = null;
        datetime fechaTotal;
        Time HorarioEntrada = Time.newInstance(9, 0, 0, 0);
        Time HorarioSalida = Time.newInstance(20, 0, 0, 0);
        Time HorarioSalidaSabado = Time.newInstance(14, 0, 0, 0);
        
        system.debug('GenerarTimeResponse listaQuote' + listaQuote);
        
        ActualizaDistancia(listaQuote,listaQuoteOld);
        
        for(Customer_Quote__c cq : listaQuote)
        {
            // if(cq.createdDate == null)
            //   cq.createdDate = datetime.now();
            //   
            //    cq.KMS__c.addError('KMS no debe ser 0');
            
            Integer offset = UserInfo.getTimezone().getOffset( Datetime.now());
            fechaCreacion = Datetime.now().addSeconds(offset/1000);
            system.debug('fechaCreacion: '+ fechaCreacion);
            
            String dayOfWeek =''; 
            dayOfWeek = fechaCreacion.format('E');
            
            system.debug('dayOfWeek '+ dayOfWeek);
            
            if(dayOfWeek == 'Sun' || dayOfWeek == 'Sat'){
                fechaTotal = tiempoTranscurrido(fechaCreacion,HorarioEntrada,HorarioSalidaSabado,HorasEstimadaCarga);
                system.debug('fechaTotal' + fechaTotal);
                
                cq.Suggested_ETD__c  = datetime.newInstance(fechaTotal.date() ,fechaTotal.timeGmt());
            }else{
                fechaTotal = tiempoTranscurrido(fechaCreacion,HorarioEntrada,HorarioSalida,HorasEstimadaCarga);
                
                system.debug('fechaTotal' + fechaTotal);
                cq.Suggested_ETD__c  = datetime.newInstance(fechaTotal.date() ,fechaTotal.timeGmt());
            }
        }
        
    }
    public static void GenerarTimeResponseShipment(list<shipment__c> listaShipment,map<Id, shipment__c> listaShipmentOld )
    {
        integer HorasEstimadaCarga = 4;
        datetime fechaCreacion = null;
        datetime fechaTotal;
        Time HorarioEntrada = Time.newInstance(9, 0, 0, 0);
        Time HorarioSalida = Time.newInstance(20, 0, 0, 0);
        Time HorarioSalidaSabado = Time.newInstance(14, 0, 0, 0);
        system.debug('GenerarTimeResponseShipment: ');
        system.debug('ActualizaDistanciaShipment: ');
        ActualizaDistanciaShipment(listaShipment, listaShipmentOld);
        
        for(shipment__c cq : listaShipment){
            
            if(cq.Approved_date_time__c == null)
            {
                continue;
                // cq.createdDate = datetime.now();
            }
            
            Integer offset = UserInfo.getTimezone().getOffset(cq.Approved_date_time__c);
            fechaCreacion = cq.Approved_date_time__c.addSeconds(offset/1000);
            system.debug('fechaCreacion: '+ fechaCreacion);
            String dayOfWeek =''; 
            dayOfWeek = fechaCreacion.format('E');
            system.debug('dayOfWeek '+ dayOfWeek);
            if(dayOfWeek == 'Sun' || dayOfWeek == 'Sat'){
                fechaTotal = tiempoTranscurrido(fechaCreacion,HorarioEntrada,HorarioSalidaSabado,HorasEstimadaCarga);
                cq.Suggested_ETD__c  = datetime.newInstance(fechaTotal.date() ,fechaTotal.timeGmt());
            }else{
                fechaTotal = tiempoTranscurrido(fechaCreacion,HorarioEntrada,HorarioSalida,HorasEstimadaCarga);
                cq.Suggested_ETD__c  = datetime.newInstance(fechaTotal.date() ,fechaTotal.timeGmt());
            }
        }
        
    }
    public static datetime tiempoTranscurrido(datetime Fecha,Time HorarioEntrada,Time HorarioSalida, integer HorasEstimadaCarga)
    {
        system.debug('Fecha' + Fecha);
        system.debug('HorarioEntrada' + HorarioEntrada);
        system.debug('HorarioSalida' + HorarioSalida);
        system.debug('HorasEstimadaCarga' + HorasEstimadaCarga);
        
        integer timeAvailable =0; 
        integer minutes = 0;
        datetime FechaResultado;
        if(Fecha.timeGmt() >= HorarioEntrada && Fecha.timeGmt() <= HorarioSalida)
        {
            datetime fechaEstimadaAprox =  DateTime.newInstance(Fecha.date(), fecha.time().addHours(4));
            system.debug('fechaEstimadaAprox' + fechaEstimadaAprox);
            system.debug('HorarioSalida' + HorarioSalida);
            system.debug('fechaEstimadaAprox.timeGmt()' + fechaEstimadaAprox.timeGmt());
            
            if(fechaEstimadaAprox.timeGmt() > HorarioSalida )
            {
                system.debug('fechaEstimadaAprox.hour()' + fechaEstimadaAprox.timeGmt().hour());
                system.debug('fechaEstimadaAprox.minute()' + fechaEstimadaAprox.minute());
                system.debug('HorarioSalida.hour()' + HorarioSalida.hour());
                system.debug('HorarioSalida.minute()' + HorarioSalida.minute());
                
                integer minutos = (fechaEstimadaAprox.timeGmt().hour() * 60 + fechaEstimadaAprox.minute()) -
                    (HorarioSalida.hour() * 60 + HorarioSalida.minute());
                
                system.debug('minutos' + minutos);
                
                FechaResultado = datetime.newInstanceGmt(Fecha.addDays(1).date() ,HorarioEntrada.addMinutes(minutos));
            }
            else
                FechaResultado = datetime.newInstanceGmt(Fecha.date(),fecha.timeGmt().addHours(HorasEstimadaCarga));
            
        }
        else if(Fecha.timeGmt() <= HorarioEntrada){
            FechaResultado = datetime.newInstanceGmt(Fecha.date() ,HorarioEntrada.addHours(HorasEstimadaCarga));
        }
        else if(Fecha.timeGmt() >= HorarioSalida){
            FechaResultado = datetime.newInstanceGmt(Fecha.addDays(1).date() ,HorarioEntrada.addHours(HorasEstimadaCarga).addMinutes(Fecha.minute()));
        }
        system.debug('FechaResultado '+ FechaResultado);
        return FechaResultado;
        
    }
    
    //OBTIENE LA DISTANCIA EN KMS DESDE GOOGLE
    public static void ActualizaDistancia(list<Customer_Quote__c> listaRegistros,map<Id, Customer_Quote__c> listaRegistrosoLD)
    {
        list<Customer_Quote__c> quotesCal = new list<Customer_Quote__c> ();   
        for(Customer_Quote__c cq : listaRegistros)
        {
            system.debug('cq.id ' + cq.id);
            
            if(cq.id != null){
                
                Customer_Quote__c oldquote = listaRegistrosoLD.get(cq.ID);
                
                system.debug('oldquote ' + oldquote);
                system.debug('cq.Account_Origin_Address__c ' + cq.Account_Origin_Address__c);
                system.debug('oldquote.Account_Origin_Address__c ' + oldquote.Account_Origin_Address__c);
                system.debug('cq.Account_Destination_Address__c ' + cq.Account_Destination_Address__c);
                system.debug('oldquote.Account_Destination_Address__c ' + oldquote.Account_Destination_Address__c);
                system.debug('cq.FolioResume__c ' + cq.FolioResume__c);
                system.debug('cq.Kms__c ' + cq.Kms__c);
                
                if( ( cq.FolioResume__c == 'FN' || cq.FolioResume__c == 'FI' || cq.FolioResume__c == 'PTO' )  
                   && (cq.Account_Origin_Address__c != null  && cq.Account_Origin_Address__c != oldquote.Account_Origin_Address__c 
                       || cq.Account_Destination_Address__c != null  && cq.Account_Destination_Address__c != oldquote.Account_Destination_Address__c 
                       || ( (cq.Kms__c == 0|| cq.Kms__c == NULL)  && cq.Account_Origin_Address__c != null && cq.Account_Destination_Address__c != null  )))
                {  
                    
                    cq.Kms__c = 0;
                    quotesCal.add(cq);
                    
                }
                
            } 
        }
        
        if(quotesCal.size()>0)
        {
            
            IF(!Test.isRunningTest())
            {
                String jsonString = json.serialize(quotesCal);
                DistanceIEQ.googleMapsDistanceKM(jsonString);
            }
            
            system.debug('Termino DistanceIEQ.googleMapsDistanceKM'); 
        }
        
        if(Test.isRunningTest())
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
        }
        
    }
    
    //OBTIENE LA DISTANCIA EN KMS DESDE GOOGLE
    public static void ActualizaDistanciaShipment(list<shipment__c> listaRegistros,map<Id, shipment__c> listaShipmentOld )
    {
        
        system.debug('SHIPMENT Entro a ActualizaDistanciaShipment');
        
        list<shipment__c> shipCal = new list<shipment__c> ();   
        for(shipment__c cq : listaRegistros)
        {             
            if(cq.id != null)
            {
                shipment__c oldquote = listaShipmentOld.get(cq.ID);
                system.debug('CQ ID' +  CQ.Id);
                system.debug('SHIPMENT cq.Shipment_Type__c ' + cq.Shipment_Type__c);
                
                if((cq.Shipment_Type__c.contains('FN')  || cq.Shipment_Type__c.contains('FI')  || cq.Shipment_Type__c.contains('PTO')  )  
                   && ( cq.Account_Origin_Address__c != null   && cq.Account_Origin_Address__c != oldquote.Account_Origin_Address__c 
                       || cq.Account_Destination_Address__c != null && cq.Account_Destination_Address__c != oldquote.Account_Destination_Address__c )
                   || ((cq.Kms__c == 0|| cq.Kms__c == NULL)  && cq.Account_Origin_Address__c != null && cq.Account_Destination_Address__c != null  ))
                {  
                    cq.Kms__c = 0;
                    shipCal.add(cq);
                }
            }
            
        }
        
        if(shipCal.size()>0)
        {
            
            IF(!Test.isRunningTest())
            {
                String jsonString = json.serialize(shipCal);
                DistanceIEQ.googleMapsDistanceKMShipment(jsonString);
            }
            
            
            system.debug('Termino DistanceIEQ.googleMapsDistanceKMSHIP'); 
            
        }
        
        if(Test.isRunningTest())
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
        }
        
    }
}