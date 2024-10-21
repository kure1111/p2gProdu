public class ShipmentTriggerHandler extends TriggerHandler {
    private Map<Id, Shipment__c> newOppMap;
    private list<Shipment__c> lista;
    private  map<string,Shipment__c> mapShipment {get; set;}
    
    public ShipmentTriggerHandler() {
        if(NEU_StaticVariableHelper.getBoolean1() || System.IsBatch() || System.isFuture() || test.isRunningTest())
            return;
        this.newOppMap = (Map<Id, Shipment__c>) Trigger.newMap;
        //  this.lista = (list<Shipment__c>)Trigger.new;
        if(!test.isRunningTest())
        {
            set<string> ids = new set<string>();
            
            for(Shipment__c s :(list<Shipment__c>)Trigger.new)
            {
                Shipment__c oldShip = (Shipment__c)Trigger.oldMap.get(s.id);              
                system.debug('TEST S.Shipment_Status_Plann__c ' + S.Shipment_Status_Plann__c);
                system.debug('TEST oldShip.Shipment_Status_Plann__c ' + oldShip.Shipment_Status_Plann__c);              
                if(s.Shipment_Status__c != oldship.Shipment_Status__c 
                   ||s.Ocean_Shipment_Status__c  != oldship.Ocean_Shipment_Status__c
                   ||s.Air_Shipment_Status__c  != oldship.Air_Shipment_Status__c 
                   ||s.Shipment_Status_Plann__c  != oldship.Shipment_Status_Plann__c
                   ||s.Shipment_Status_Mon__c != oldship.Shipment_Status_Mon__c 
                   ||s.Routing_Operation_Status__c  != oldship.Routing_Operation_Status__c)
                    ids.add(s.id);
            }          
            this.lista = [Select Id,Name,RecordTypeId,Account_for__r.Owner.Workplace__c,CurrencyIsoCode,Sell_Amount_Bloq__c,Shipment_Status__c,Ocean_Shipment_Status__c,Air_Shipment_Status__c,Shipment_Status_Plann__c,Account_for__r.Customer_Id__c,Account_for__r.Owner.SalesEmployer__c,Freight_Mode__c,Service_Mode__c,State_of_Load__c,State_of_Load__r.Name,State_of_Discharge__r.Name, Account_for__r.Venta_Sap__c,
                          Acuse_en_SAP__c,ShipmentLineNoSap__c,ShipmentLineSap__c,AUTORIZAR_GASTO_EXTRA__c,NotificarGastoExtra__c,Total_Services_Sell_Amount__c,OrdenVenta__c,Carrier__r.Customer_Id__c,Orden_de_Compra__c,Status_Shipment__c,Date_Receive_from_SAP__c,Plaza_Vendedor__c,Vendedor_Adicional__c,Service_Type__c, Operation_Executive__r.Name, Operation_Executive_2__r.Name, 
                          Site_of_Load__r.Frontera__c, Site_of_Discharge__r.Frontera__c, Route__r.Name,order__c,Routing_Operation_Status__c,CreatedDate,Shipment_Status_Mon__c  
                          From Shipment__c 
                          Where Id in:ids ];
        }
    }
    
    public override void afterInsert() {
        system.debug('lo que contiene Trigger.new: '+Trigger.new);
        List <Shipment__c> SPobj = (list<Shipment__c>)Trigger.new;
        if(SPobj.size()>0){
            API_send_SP_to_PakControl.send_SP(SPobj[0].id);
        }
    }
    
    public override void afterUpdate() {
        //if (P2G_llamadoWebHelper.getWebServiceUpdate()) {
        //     return;
        //}
        List <Shipment__c> SPobj = (list<Shipment__c>)Trigger.new;
        //--------------------------------
        List<Shipment__c> updatedShipments = new List<Shipment__c>();    
        for (Shipment__c ship : SPobj) {
            Shipment__c oldShip = (Shipment__c)Trigger.oldMap.get(ship.id);
            if(ship.Shipment_Status_Plann__c == 'Confirmed' && oldShip.Shipment_Status_Plann__c!='Confirmed' && ship.Service_Mode__c=='NATIONAL') {
                updatedShipments.add(ship);
            }

            if (ship.Shipment_Status_Plann__c == 'Confirmed' && ( ship.ETD_from_Point_of_Load__c != oldShip.ETD_from_Point_of_Load__c ||
            ship.ETA_Point_of_Discharge__c != oldShip.ETA_Point_of_Discharge__c ||
            ship.Vehicle__c != oldShip.Vehicle__c ||
            ship.Operation_Executive__c != oldShip.Operation_Executive__c ||
            ship.National_Operator__c != oldShip.National_Operator__c ||
            ship.Account_Origin_Address__c != oldShip.Account_Origin_Address__c ||
            ship.Account_Destination_Address__c != oldShip.Account_Destination_Address__c ||
            ship.Carrier__c != oldShip.Carrier__c)) {
                updatedShipments.add(ship);
        }
        }
        //--------------------------
        if(SPobj.size()>0){
            API_send_SP_to_PakControl.send_SP(SPobj[0].Id);
        }
        if (!updatedShipments.isEmpty()){
            try{P2G_creacionFolioWs.callSerCon(updatedShipments[0].Id);}catch(Exception e){System.debug('Error P2G_creacionFolioWs.callSerCon: '+e.getLineNumber());}      
        }
        if(NEU_StaticVariableHelper.getBoolean1() || System.IsBatch() || System.isFuture()||test.isRunningTest())
            return;
        set<string> listaShipment = new set<string>();
        set<string> listaOrders = new set<string>();
        mapShipment = new map<string,Shipment__c>();  
        for(Shipment__c s : lista)
        {
            Shipment__c oldShip = (Shipment__c)Trigger.oldMap.get(s.id);
            if(ValidaShipmentSend(s, oldShip) /*&& s.Enviado_Sap__c == false*/)
            {
                system.debug('EL-LOG ' + S);
                listaShipment.add(s.id);
                listaOrders.add(s.order__c);
            }
        }
        
        if(listaShipment.size() > 0){
            NEU_StaticVariableHelper.setBoolean1(true);
            PAK_SendToSap.sendShipmentTrigger(listaShipment,listaOrders); 
            NEU_StaticVariableHelper.setBoolean1(false);
        }
        
    }
    public Boolean ValidaShipmentSend(Shipment__c S, Shipment__c oldShip)
    {
        
        String TipoShipment; 
        TipoShipment = S.Name.substringBetween('-','-');
        
        system.debug('TipoShipment ' + TipoShipment);
        system.debug('S.Shipment_Status_Plann__c ' + S.Shipment_Status_Plann__c);
        system.debug('oldShip.Shipment_Status_Plann__c ' + oldShip.Shipment_Status_Plann__c);
        system.debug('S.Account_for__r.Venta_Sap__c  ' + S.Account_for__r.Venta_Sap__c );
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Mon__c != OldShip.Shipment_Status_Mon__c ) && S.Shipment_Status_Mon__c=='Delivery on Route_M' /*(S.Shipment_Status_Mon__c=='Delivery on Route_M' || S.Shipment_Status_Mon__c=='Finished_M' )*/)
            //if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != OldShip.Shipment_Status_Plann__c ) && (S.Shipment_Status_Plann__c == 'Confirmed' || S.Shipment_Status_Plann__c == 'False'))
        {
            system.debug('PRIMER IF'); 
            return true; //Estatus ='para continuar debe ser Confirmed o False';
        }
        
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO')){
            
            system.debug('SEGUNDO IF'); 
            if(S.Status_Shipment__c == 'Send to Sap' && (S.Shipment_Status_Plann__c != OldShip.Shipment_Status_Plann__c )&& (S.Shipment_Status_Plann__c == 'Confirmed' || S.Shipment_Status_Plann__c == 'False' || S.Shipment_Status_Plann__c == 'In Progress'))
            {
                system.debug('TERCERO IF'); 
                return true; //Estatus ='para continuar debe ser In Progress, Confirmed o False (Contado)';
            }
            else if(S.Status_Shipment__c != 'Send to Sap' && (S.Shipment_Status_Plann__c != OldShip.Shipment_Status_Plann__c ) && (S.Shipment_Status_Plann__c == 'In Progress' || S.Shipment_Status_Plann__c == 'False')){
                system.debug('CUARTO IF'); 
                return true; //Estatus ='para continuar debe ser In Progress o False (Contado)';
            }
        }
        /*
if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && S.Shipment_Status_Plann__c != 'In Progress'){
Bandera=true;Estatus ='para continuar debe ser In Progress (Contado)';
}*/
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (S.Air_Shipment_Status__c != OldShip.Air_Shipment_Status__c ) && (TipoShipment == 'A') && ((S.Air_Shipment_Status__c == 'Contact with Origin' || S.Air_Shipment_Status__c == 'Pickup and Delivery to Airline' || S.Air_Shipment_Status__c == 'Documentation' || S.Air_Shipment_Status__c == 'Flight Confirmation' || S.Air_Shipment_Status__c == 'Layover' || S.Air_Shipment_Status__c == 'Arrival Confirmation' || S.Air_Shipment_Status__c == 'Pending with Customs Broker' || S.Air_Shipment_Status__c == 'Final Delivery' || S.Air_Shipment_Status__c == 'Finish'))){
            system.debug('QUINTO IF'); 
            return true;//Estatus ='para continuar debe ser Contact with Origin, Pickup and Delivery to Airline, Documentation, Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Contado)';
        }
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != OldShip.Ocean_Shipment_Status__c ) && ( (S.Ocean_Shipment_Status__c == 'Booking Confirmation' || S.Ocean_Shipment_Status__c == 'Pickup Confirmation' || S.Ocean_Shipment_Status__c == 'Documents' || S.Ocean_Shipment_Status__c == 'ETD' || S.Ocean_Shipment_Status__c == 'ETA-15' || S.Ocean_Shipment_Status__c == 'ETA-10' || S.Ocean_Shipment_Status__c == 'ETA-7' || S.Ocean_Shipment_Status__c == 'ETA-4' || S.Ocean_Shipment_Status__c == 'ETA' || S.Ocean_Shipment_Status__c == 'Telex Confirmation' || S.Ocean_Shipment_Status__c == 'Customs Clearences' || S.Ocean_Shipment_Status__c == 'Final Delivery' || S.Ocean_Shipment_Status__c == 'Finished' || S.Ocean_Shipment_Status__c == 'Pending Information'))){
            System.debug('Estatus: ' + S.Ocean_Shipment_Status__c);
            system.debug('SEXTO IF'); 
            return true;//Estatus ='para continuar debe ser Booking Confirmation, Pickup Confirmation, Documents, ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Contado)';   
        }            
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'EXPORT' && (S.Shipment_Status__c != OldShip.Shipment_Status__c ) && ( (S.Shipment_Status__c == 'Pending but Pre-Captured' || S.Shipment_Status__c == 'Booking Confirmation' || S.Shipment_Status__c == 'Planned for delivery - Not yet on route' || S.Shipment_Status__c == 'Captured but not yet sent EDI' || S.Shipment_Status__c == 'Pending - Missing Documents/Instructions' || S.Shipment_Status__c == 'Submitted to Customs' || S.Shipment_Status__c == 'Cleared but Awaiting Vessel' || S.Shipment_Status__c == 'Delivered' || S.Shipment_Status__c == 'Cleared but Stopped' || S.Shipment_Status__c == 'Delivered to Depot' || S.Shipment_Status__c == 'Agent Notified' || S.Shipment_Status__c == 'ETA -15' || S.Shipment_Status__c == 'ETA -10' || S.Shipment_Status__c == 'ETA -7' || S.Shipment_Status__c == 'ETA -4' || S.Shipment_Status__c == 'In Progress' || S.Shipment_Status__c == 'TLX Confirmation' || S.Shipment_Status__c == 'Delivery On route' || S.Shipment_Status__c == 'Finished'))){
            system.debug('SEPTIMO IF'); 
            return true;//Estatus ='para continuar debe ser Schedules, Booking Confirmation, Pickup, Documents, Shipping Instructions / VGM, Cut Off, BL Draft, ETD, Invoice, MBL/HBL, Payment, ETA -15, ETA -10, ETA -7, ETA -4, ETA, TLX Confirmation, Delivery On route o Finished (Contado)';
        }
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Mon__c != OldShip.Shipment_Status_Mon__c ) &&  S.Shipment_Status_Mon__c=='Delivery on Route_M' /*(S.Shipment_Status_Mon__c=='Delivery on Route_M' || S.Shipment_Status_Mon__c=='Finished_M' )*/)
        {
            system.debug('OCTAVO IF'); 
            return true;//Estatus ='para continuar debe ser Confirmed o False (Crédito)';
        }
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'A')  && (S.Air_Shipment_Status__c != OldShip.Air_Shipment_Status__c )&& (S.Air_Shipment_Status__c == 'Flight Confirmation' || S.Air_Shipment_Status__c == 'Layover' || S.Air_Shipment_Status__c == 'Arrival Confirmation' || S.Air_Shipment_Status__c == 'Pending with Customs Broker' || S.Air_Shipment_Status__c == 'Final Delivery' || S.Air_Shipment_Status__c == 'Finish'))
        {
            system.debug('NOVENO IF'); 
            return true;//Estatus ='para continuar debe ser Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Crédito)';
        }
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'M' && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != OldShip.Ocean_Shipment_Status__c ) && (S.Ocean_Shipment_Status__c == 'ETD' || S.Ocean_Shipment_Status__c == 'ETA-15' || S.Ocean_Shipment_Status__c == 'ETA-10' || S.Ocean_Shipment_Status__c == 'ETA-7' || S.Ocean_Shipment_Status__c == 'ETA-4' || S.Ocean_Shipment_Status__c == 'ETA' || S.Ocean_Shipment_Status__c == 'Telex Confirmation' || S.Ocean_Shipment_Status__c == 'Customs Clearences' || S.Ocean_Shipment_Status__c == 'Final Delivery' || S.Ocean_Shipment_Status__c == 'Finished' || S.Ocean_Shipment_Status__c == 'Pending Information'))
        {
            system.debug('DECIMO IF'); 
            return true;//Estatus ='para continuar debe ser ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Crédito)';
        }
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && (S.Air_Shipment_Status__c != OldShip.Air_Shipment_Status__c ) && S.Air_Shipment_Status__c == 'Flight Confirmation')
        {
            system.debug('ONCE IF'); 
            return true;//Estatus ='para continuar debe ser Flight Confirmation';
        }
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && (S.Air_Shipment_Status__c != OldShip.Air_Shipment_Status__c ) && S.Air_Shipment_Status__c == 'Pickup and Delivery to Airline')
        {
            system.debug('DOCE IF'); 
            return true;//Estatus ='para continuar debe ser Pickup and Delivery to Airline';
        }
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && (S.Air_Shipment_Status__c != OldShip.Air_Shipment_Status__c ) && S.Air_Shipment_Status__c == 'Flight Confirmation')
        {
            system.debug('TRECE IF'); 
            return true;//Estatus ='para continuar debe ser Flight Confirmation';
        }
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && (S.Air_Shipment_Status__c != OldShip.Air_Shipment_Status__c ) && S.Air_Shipment_Status__c == 'Pickup and Delivery to Airline')
        {
            system.debug('CATORCE IF'); 
            return true;//Estatus ='para continuar debe ser Pickup and Delivery to Airline';
        }
        
        // if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
        //if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
        // if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered' && S.Account_for__r.Venta_Sap__c == 'Credito' ){Bandera=true;Estatus ='para continuar debe ser ETD';}  
        
        
        
        //  if(TipoShipment == 'R' && S.Freight_Mode__c =='Air' && S.Air_Shipment_Status__c != 'Consigness Notification'){Bandera=true;Estatus ='para continuar debe ser Consigness Notification';}
        
        if((TipoShipment == 'WH' || TipoShipment == 'EX' || TipoShipment == 'ES' || TipoShipment == 'FP' || TipoShipment == 'FO' ) && (S.Shipment_Status_Plann__c != OldShip.Shipment_Status_Plann__c ) && S.Shipment_Status_Plann__c == 'Confirmed')
        {
            system.debug('QUINCE IF'); 
            return true;//Estatus ='para continuar debe ser Confirmed';
        }
        if((TipoShipment == 'PQ'  ||  TipoShipment == 'T')&& ((S.Shipment_Status_Plann__c == 'Confirmed'&&S.Account_for__r.Venta_Sap__c == 'Credito')||(S.Shipment_Status_Plann__c == 'In progress'&&S.Account_for__r.Venta_Sap__c == 'Contado'))){
            system.debug('DIECISEIS IF'); 
            return true;//Estatus ='para continuar debe ser Confirmed';
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
        
        if(TipoShipment == 'R' && (S.Freight_Mode__c == 'Sea' || S.Freight_Mode__c =='Air' ) && (S.Routing_Operation_Status__c != OldShip.Routing_Operation_Status__c )&& ( S.Routing_Operation_Status__c == 'Gestión de Documentos'))
        {
            system.debug('DIECISEIS IF'); 
            return true;//Estatus ='para ov';
        }
        
        if(s.Shipment_Status__c != null && (S.Shipment_Status__c != OldShip.Shipment_Status__c ))
        {
            system.debug('17 IF'); 
            if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && setEstatus.contains(s.Shipment_Status__c)) 
            {
                system.debug('18 IF'); 
                return true;//Estatus ='para continuar debe ser Shipment_Status__c';
            }
            
            if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && setEstatus.contains(s.Shipment_Status__c)  && S.Account_for__r.Venta_Sap__c == 'Credito') 
            {
                system.debug('19 IF'); 
                return true;//Estatus ='para continuar debe ser ETD';
            }
        }
        
        if(TipoShipment == 'W' && S.Service_Mode__c == 'IMPORT' && S.Freight_Mode__c =='Sea' && (S.Ocean_Shipment_Status__c != OldShip.Ocean_Shipment_Status__c )&& setEstatus.contains(s.Ocean_Shipment_Status__c)) 
        {
            system.debug('20 IF'); 
            return true;//Estatus ='para continuar debe ser Ocean_Shipment_Status__c';
        }
        
        return false;
        
    }
    
    public void TestMetodo(){
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
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
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