public class PAK_SendToOrder {
    public ApexPages.StandardController C {get;set;}
    public String IdShipment {get;set;}
    public String TipoShipment; 
    private boolean Bandera {get;set;}
    private String Estatus {get;set;}
    public PAK_SendToOrder(ApexPages.StandardController Controller){
        if(!Test.isRunningTest()){
            C = Controller;
            IdShipment = Controller.getId();   
        }
    }
    public PageReference SendWS(){
        try{
            Bandera = false;
            Shipment__c S = [Select Id,Name,Order__c, Account_for__r.Venta_Sap__c, Shipment_Status_Plann__c, Shipment_Status__c,
                             Freight_Mode__c, Service_Mode__c, Status_Shipment__c, Ocean_Shipment_Status__c, Air_Shipment_Status__c 
                             ,Routing_Operation_Status__c,VerificacionPak__c,Shipment_Status_Mon__c 
                             From Shipment__c 
                             Where Id=:IdShipment limit 1];
            
            Order ordr = [SELECT Id, DefaultPbe__c, DefaultProduct__c FROM Order WHERE Id=:S.Order__c LIMIT 1];
            
            List<OrderItem> lstLines = new List<OrderItem>();
            
            List<Shipment_Fee_Line__c> Lines = [Select Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,
                                                Shipment_Buy_Price__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,
                                                Service_Rate_Name__r.SAP_Service_Type__r.Name, Service_Rate_Name__r.SAP_Service_Type__r.VAT__c, Currency_Buy_Price__c, Conversion_Rate_to_Buy_Currency_Header__c,
                                                Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Record_Locked__c
                                                From Shipment_Fee_Line__c 
                                                Where Shipment__c=:IdShipment /*and SAP__c=false*/];
            
            system.debug('lines 1 : ' + lines);
            
            TipoShipment = S.Name.substringBetween('-','-');
            Estatus = '';
            
            if(S.Account_for__r.Venta_Sap__c == null || S.Account_for__r.Venta_Sap__c == ''){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Tipo de venta SAP no configurado para este cliente');ApexPages.addMessage(myMsg);return null;}
           
            {
                    system.debug('entro  ValidarEstatus : ' + s);
                ValidarEstatus(S); 
                  system.debug('termino  ValidarEstatus : ' );
            }
            
            if(Bandera){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Validacion: Estatus Incorrecto '+Estatus);
                ApexPages.addMessage(myMsg);
                return null;
            }
            if(Lines.isEmpty()){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: agregar Shipment Service Lines');
                ApexPages.addMessage(myMsg);           
            }else{
                String Body = '';
                if(!Lines.isEmpty()){
                    for(Shipment_Fee_Line__c LI: Lines){
                         system.debug('entro  ifLines : ' + li);
                        
                       if(li.Record_Locked__c)
                            LI.Record_Locked__c = false;
                        
                        LI.SAP__c = true;
                        LI.Block__c = true;
                        String ItemCode = LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c:'';
                        if(ItemCode == ''){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Capturar SAP Service Type para la línea ' + LI.Name);ApexPages.addMessage(myMsg);return null;}                        
                        Double units = LI.Units__c != null ? LI.Units__c: 1;
                        String ServTypeLine = LI.Service_Rate_Name__r.SAP_Service_Type__r.Name != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Name:'';
                        String Concepto = LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c:'';                        
                        String Vat = LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c : '';
                        String Ret = LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c != null ? LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c : '';
                        OrderItem line = new OrderItem();
                        line.ShipServLineId__c = LI.Id;
                        line.ServLine_Name__c = LI.Name;
                        line.Service_Rate_Name__c = ServTypeLine;
                        line.Retention__c = Ret;
                        line.Quantity = units;
                        line.UnitPrice = LI.Shipment_Sell_Net_Price__c;
                        line.VAT__c = Vat;
                        line.Group__c = Concepto;
                        line.ItemCode__c = ItemCode;
                        line.CurrencyLine__c = LI.CurrencyIsoCode;
                        line.Std_Buy_Amount__c = LI.Shipment_Buy_Price__c;
                        line.Product2Id = ordr.DefaultProduct__c;
                        line.PricebookEntryId = ordr.DefaultPbe__c;
                        line.OrderId = ordr.Id;
                        
                        lstLines.add(line);                       
                    }
                }
                 system.debug('entro  upsert : ' + lstLines);
                upsert lstLines ShipServLineId__c;

                if(S.Account_for__r.Venta_Sap__c == 'Contado'){S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Shipment_Status_Bloq_Contado' limit 1].Id;}else{S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'ShipmentStatus' limit 1].Id;}                    
                S.Status_Shipment__c = 'Send to Sap';                    
                S.Date_Receive_from_SAP__c = datetime.now();
                S.AUTORIZAR_GASTO_EXTRA__c = false;
                S.NotificarGastoExtra__c = false;
                update S;
                system.debug('lines antes ' + lines);
                update Lines;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Se envío la información exitosamente. Verificar área de Responses.');
                ApexPages.addMessage(myMsg);   
            }
            return null;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: ' + e.getLineNumber()+' - '+e.getMessage());
            ApexPages.addMessage(myMsg);
            
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
            return null;
        }
    }
    public void ValidarEstatus(Shipment__c S)
    {
          system.debug('entro aqui  ValidarEstatus : ' + s);
        // agregar campo VPC
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'FN' && S.Shipment_Status_Mon__c != 'Delivery on Route_M' && S.Shipment_Status_Mon__c != 'Finished_M'  && s.VerificacionPak__c != true){Bandera=true;Estatus ='para continuar debe ser Delivery on Route / Finished y estar validado por pack control';}
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FI' || TipoShipment == 'PTO') && S.Shipment_Status_Mon__c != 'Delivery on Route_M' && S.Shipment_Status_Mon__c != 'Finished_M'){Bandera=true;Estatus ='para continuar debe ser Delivery on Route o Finished';}
        
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO')){
            System.debug('Entro contado val');
            System.debug('Values - Status_Shipment__c: ' + S.Status_Shipment__c + ' - Shipment_Status_Plann__c: ' + S.Shipment_Status_Plann__c);
            if(S.Status_Shipment__c == 'Send to Sap' && S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False' && S.Shipment_Status_Plann__c != 'In Progress'){
                System.debug('Entro val estatus sap');
                Bandera=true;Estatus ='para continuar debe ser In Progress, Confirmed o False (Contado)';
            }else if(S.Status_Shipment__c != 'Send to Sap' && S.Shipment_Status_Plann__c != 'In Progress' && S.Shipment_Status_Plann__c != 'False'){
                System.debug('Else estatus sap');
                Bandera=true;Estatus ='para continuar debe ser In Progress o False (Contado)';
            }
        }
        /*
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && S.Shipment_Status_Plann__c != 'In Progress'){
            Bandera=true;Estatus ='para continuar debe ser In Progress (Contado)';
        }*/
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'A') && (S.Air_Shipment_Status__c != 'Contact with Origin' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline' && S.Air_Shipment_Status__c != 'Documentation' && S.Air_Shipment_Status__c != 'Flight Confirmation' && S.Air_Shipment_Status__c != 'Layover' && S.Air_Shipment_Status__c != 'Arrival Confirmation' && S.Air_Shipment_Status__c != 'Pending with Customs Broker' && S.Air_Shipment_Status__c != 'Final Delivery' && S.Air_Shipment_Status__c != 'Finish')){
            Bandera=true;Estatus ='para continuar debe ser Contact with Origin, Pickup and Delivery to Airline, Documentation, Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Contado)';
        }
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != 'Booking Confirmation' && S.Ocean_Shipment_Status__c != 'Pickup Confirmation' && S.Ocean_Shipment_Status__c != 'Documents' && S.Ocean_Shipment_Status__c != 'ETD' && S.Ocean_Shipment_Status__c != 'ETA-15' && S.Ocean_Shipment_Status__c != 'ETA-10' && S.Ocean_Shipment_Status__c != 'ETA-7' && S.Ocean_Shipment_Status__c != 'ETA-4' && S.Ocean_Shipment_Status__c != 'ETA' && S.Ocean_Shipment_Status__c != 'Telex Confirmation' && S.Ocean_Shipment_Status__c != 'Customs Clearences' && S.Ocean_Shipment_Status__c != 'Final Delivery' && S.Ocean_Shipment_Status__c != 'Finished' && S.Ocean_Shipment_Status__c != 'Pending Information')){
            System.debug('Estatus: ' + S.Ocean_Shipment_Status__c);
            Bandera=true;Estatus ='para continuar debe ser Booking Confirmation, Pickup Confirmation, Documents, ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Contado)';   
        }            
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'EXPORT' && (S.Shipment_Status__c != 'Pending but Pre-Captured' && S.Shipment_Status__c != 'Booking Confirmation' && S.Shipment_Status__c != 'Planned for delivery - Not yet on route' && S.Shipment_Status__c != 'Captured but not yet sent EDI' && S.Shipment_Status__c != 'Pending - Missing Documents/Instructions' && S.Shipment_Status__c != 'Submitted to Customs' && S.Shipment_Status__c != 'Cleared but Awaiting Vessel' && S.Shipment_Status__c != 'Delivered' && S.Shipment_Status__c != 'Cleared but Stopped' && S.Shipment_Status__c != 'Delivered to Depot' && S.Shipment_Status__c != 'Agent Notified' && S.Shipment_Status__c != 'ETA -15' && S.Shipment_Status__c != 'ETA -10' && S.Shipment_Status__c != 'ETA -7' && S.Shipment_Status__c != 'ETA -4' && S.Shipment_Status__c != 'In Progress' && S.Shipment_Status__c != 'TLX Confirmation' && S.Shipment_Status__c != 'Delivery On route' && S.Shipment_Status__c != 'Finished')){
            Bandera=true;Estatus ='para continuar debe ser Schedules, Booking Confirmation, Pickup, Documents, Shipping Instructions / VGM, Cut Off, BL Draft, ETD, Invoice, MBL/HBL, Payment, ETA -15, ETA -10, ETA -7, ETA -4, ETA, TLX Confirmation, Delivery On route o Finished (Contado)';
        }
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'W') && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c == 'Delivered'){
            // Bandera=true;Estatus ='validacion de leo XD';
            Bandera=true;Estatus ='es necesario que el status sea Delivered el servicio  EXPORT y tipo contado';
            system.debug('No se mandara a llamar sendtoSap por que lo dice leo XD ');
        }
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'M') && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c == 'Booking Confirmation'){
            Bandera=true;Estatus ='es necesario que el status sea Booking Confirmation el servicio  EXPORT y tipo credito';
            // Bandera=true;Estatus ='validacion de leo XD';
            system.debug('No se mandara a llamar sendtoSap por que lo dice leo XD ');
        }
        // agregar campo VPC
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'FN' && S.Shipment_Status_Mon__c != 'Delivery on Route_M' && S.Shipment_Status_Mon__c != 'Finished_M' && s.VerificacionPak__c != true ){Bandera=true;Estatus ='para continuar debe ser Delivery on Route / Finished y estar validado por pack control';}
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FI' || TipoShipment == 'PTO') && S.Shipment_Status_Mon__c != 'Delivery on Route_M' && S.Shipment_Status_Mon__c != 'Finished_M'){Bandera=true;Estatus ='para continuar debe ser Delivery on Route o Finished (Crédito)';}
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'A') && (S.Air_Shipment_Status__c != 'Flight Confirmation' && S.Air_Shipment_Status__c != 'Layover' && S.Air_Shipment_Status__c != 'Arrival Confirmation' && S.Air_Shipment_Status__c != 'Pending with Customs Broker' && S.Air_Shipment_Status__c != 'Final Delivery' && S.Air_Shipment_Status__c != 'Finish')){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Crédito)';}
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'M' && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != 'ETD' && S.Ocean_Shipment_Status__c != 'ETA-15' && S.Ocean_Shipment_Status__c != 'ETA-10' && S.Ocean_Shipment_Status__c != 'ETA-7' && S.Ocean_Shipment_Status__c != 'ETA-4' && S.Ocean_Shipment_Status__c != 'ETA' && S.Ocean_Shipment_Status__c != 'Telex Confirmation' && S.Ocean_Shipment_Status__c != 'Customs Clearences' && S.Ocean_Shipment_Status__c != 'Final Delivery' && S.Ocean_Shipment_Status__c != 'Finished' && S.Ocean_Shipment_Status__c != 'Pending Information')){Bandera=true;Estatus ='para continuar debe ser ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Crédito)';}
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}
        
        // if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
        //if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
        // if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered' && S.Account_for__r.Venta_Sap__c == 'Credito' ){Bandera=true;Estatus ='para continuar debe ser ETD';}  
        
        
        
      //  if(TipoShipment == 'R' && S.Freight_Mode__c =='Air' && S.Air_Shipment_Status__c != 'Consigness Notification'){Bandera=true;Estatus ='para continuar debe ser Consigness Notification';}

        if((TipoShipment == 'WH' || TipoShipment == 'EX' || TipoShipment == 'ES' || TipoShipment == 'FP' || TipoShipment == 'FO') && S.Shipment_Status_Plann__c != 'Confirmed'){
            Bandera=true;Estatus ='para continuar debe ser Confirmed';
        }
        if(TipoShipment == 'PQ' || TipoShipment == 'T' ){
            if(S.Shipment_Status_Plann__c != 'Confirmed'&&S.Account_for__r.Venta_Sap__c == 'Credito'){
                Bandera=true;Estatus ='para continuar debe ser Confirmed';
            }
            if(S.Shipment_Status_Plann__c != 'In progress'&&S.Account_for__r.Venta_Sap__c == 'Contado'){
                Bandera=true;Estatus ='para continuar debe ser in progress';
            }
        }
        
        set<string> setEstatus = new set<string>();
        setEstatus.add('Delivered');
        setEstatus.add('ETA-15');
        setEstatus.add('ETD');
        setEstatus.add('Cleared but Stopped');
        setEstatus.add('Delivered to Depot');
        setEstatus.add('Agent Notified');
        setEstatus.add('ETA -10');
        setEstatus.add('ETA -7');
        setEstatus.add('ETA -4');
        setEstatus.add('In Progress');
        setEstatus.add('TLX Confirmation');
        setEstatus.add('Delivery On route');
        setEstatus.add('Finished');
        setEstatus.add('Cancel');
        setEstatus.add('Booking Confirmation');
        
        system.debug('Estaus Shipment '+ s.Shipment_Status__c);
        system.debug('TipoShipment '+ TipoShipment);
        system.debug('Freight_Mode__c '+ S.Freight_Mode__c);
        system.debug('Service_Mode__c '+ S.Service_Mode__c);
        system.debug('Se encontro: '+ setEstatus.contains(s.Shipment_Status__c));
          system.debug('llego aqui ValidarEstatus : ');
        
        if(TipoShipment == 'R' && (S.Freight_Mode__c == 'Sea' || S.Freight_Mode__c =='Air' ) && ( S.Routing_Operation_Status__c != 'Gestión de Documentos'))
        {
            Bandera=true;Estatus ='para ov';
        }
        
        if(s.Shipment_Status__c != null)
        {
            if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Shipment_Status__c';}
            
            if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)  && S.Account_for__r.Venta_Sap__c == 'Credito') {Bandera=true;Estatus ='para continuar debe ser ETD';}
        }
        
        if(TipoShipment == 'W' && S.Service_Mode__c == 'IMPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Ocean_Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Ocean_Shipment_Status__c';}
        
    }
    public static void TestMetodo(){
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
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
                Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
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