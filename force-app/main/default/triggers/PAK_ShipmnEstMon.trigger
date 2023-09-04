trigger PAK_ShipmnEstMon on Shipment__c (after update) {
    if(NEU_StaticVariableHelper.getBoolean1()  ||  System.isFuture() == true)
        return;
    System.debug('PAK_ShipmnEstMon IN');
    Map<Id, String> mapShipUser = new Map<Id, String>();
    Map<Id, String> mapShipSAP = new Map<Id, String>();
      Map<Id, String> mapShipSAPFALLA = new Map<Id, String>();
    for(Shipment__c ship : Trigger.New){
        
        if(Trigger.oldMap.get(ship.Id).Shipment_Status_Mon__c != ship.Shipment_Status_Mon__c && ship.Shipment_Status_Mon__c == 'Finished_M'){
            mapShipUser.put(ship.Id, UserInfo.getName());
        }
         SYSTEM.debug('ENTRO AQUI ship.Shipment_Type__c ' + ship.Shipment_Type__c);
        
        //MEJORA ENVIAR TODOS LOS STATUS A SAP
        if(Trigger.oldMap.get(ship.Id).Shipment_Status_Plann__c != ship.Shipment_Status_Plann__c 
           &&  ( ship.Shipment_Type__c.contains('FN') || ship.Shipment_Type__c.contains('FI') || ship.Shipment_Type__c.contains('PTO') 
                ||  ship.Shipment_Type__c.contains('PQ') || ship.Shipment_Type__c.contains('ES') || ship.Shipment_Type__c.contains('EX')
                || ship.Shipment_Type__c.contains('WH')))
        {
            
            SYSTEM.debug('ENTRO AQUI' + ship.id);
            list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                         FROM Response__c 
                                         where Shipment__c  =: ship.id
                                         and ( Message__c  like '%Orden de Venta creada%' 
                                              or Message__c  like '%Solicitud de Compra creada%' 
                                              or Message__c  like '%Actualizada Sol.Compra%' 
                                              or  Message__c  like '%Orden de Venta Actualizada%') ]; 
            
            SYSTEM.debug('ENTRO AQUI ' + ship.id);
            
            if(respons.size () > 0)
            {
                SYSTEM.debug('ENTRO AQUI status ' + ship.Shipment_Status_Plann__c);
                mapShipSAP.put(ship.Id, ship.Shipment_Status_Plann__c );
            }
        }
        
        //MEJORA ENVIAR TODOS LOS STATUS ocean expo a SAP
        if(Trigger.oldMap.get(ship.Id).Shipment_Status__c != ship.Shipment_Status__c 
           &&    ship.Shipment_Type__c.contains('M')){
               
               list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                            FROM Response__c 
                                            where Shipment__c  =: ship.id
                                            and ( Message__c  like '%Orden de Venta creada%' 
                                                 or Message__c  like '%Solicitud de Compra creada%' 
                                                 or Message__c  like '%Actualizada Sol.Compra%' 
                                                 or  Message__c  like '%Orden de Venta Actualizada%') ]; 
               SYSTEM.debug('ENTRO AQUI 2 ' + ship.id);
               if(respons.size () > 0)
               {
                   SYSTEM.debug('ENTRO AQUI status ' + ship.Shipment_Status_Plann__c);
                   mapShipSAP.put(ship.Id, ship.Shipment_Status__c );
               }
               
           }
        
        
        //MEJORA ENVIAR TODOS LOS STATUS ocean impo a SAP
        if(Trigger.oldMap.get(ship.Id).Ocean_Shipment_Status__c != ship.Ocean_Shipment_Status__c 
           && ship.Shipment_Type__c.contains('M')){
               
               list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                            FROM Response__c 
                                            where Shipment__c  =: ship.id
                                            and ( Message__c  like '%Orden de Venta creada%' 
                                                 or Message__c  like '%Solicitud de Compra creada%' 
                                                 or Message__c  like '%Actualizada Sol.Compra%' 
                                                 or  Message__c  like '%Orden de Venta Actualizada%') ]; 
               SYSTEM.debug('ENTRO AQUI 3 ' + ship.id);
               if(respons.size () > 0)
               {
                   SYSTEM.debug('ENTRO AQUI status ' + ship.Shipment_Status_Plann__c);
                   mapShipSAP.put(ship.Id, ship.Ocean_Shipment_Status__c );
               }
               
           }
        
        //MEJORA ENVIAR TODOS LOS STATUS AIR a SAP
        if(Trigger.oldMap.get(ship.Id).Air_Shipment_Status__c != ship.Air_Shipment_Status__c 
           &&   ship.Shipment_Type__c.contains('A'))
        {
            
            list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                         FROM Response__c 
                                         where Shipment__c  =: ship.id
                                         and ( Message__c  like '%Orden de Venta creada%' 
                                              or Message__c  like '%Solicitud de Compra creada%' 
                                              or Message__c  like '%Actualizada Sol.Compra%' 
                                              or  Message__c  like '%Orden de Venta Actualizada%') ]; 
            SYSTEM.debug('ENTRO AQUI 4 ' + ship.id);
            if(respons.size () > 0)
            {
                SYSTEM.debug('ENTRO AQUI status ' + ship.Shipment_Status_Plann__c);
                mapShipSAP.put(ship.Id, ship.Air_Shipment_Status__c );
            }
            
        }
        
         //MEJORA ENVIAR TODOS LOS STATUS AIR a SAP
        if(Trigger.oldMap.get(ship.Id).Estatus_de_operacion__c != ship.Estatus_de_operacion__c )
        {
                SYSTEM.debug('ENTRO AQUI status Estatus_de_operacion__c ' + ship.Estatus_de_operacion__c);
                mapShipSAPFALLA.put(ship.Id, ship.Estatus_de_operacion__c );
        }
    }
    
    System.debug('PAK_ShipmnEstMon map: ' + mapShipUser);
    if(mapShipUser.size()>0){
        PAK_ShipmntEstMonWs.estatusShipmentMon(mapShipUser);
    }
    
    System.debug('PAK_ShipmntEstatusSAP map: ' + mapShipSAP);
    if(mapShipSAP.size()>0){
        System.debug('PAK_ShipmntEstatusSAP entro al size : ' + mapShipSAP.size());
        PAK_ShipmntEstatusSAP.sendEstatusShipment(mapShipSAP);
    }
           
    System.debug('PAK_ShipmntEstatusSAP map: FALLA ' + mapShipSAPFALLA);
    if(mapShipSAPFALLA.size()>0){
        System.debug('PAK_ShipmntEstatusSAP FALLA entro al size : ' + mapShipSAPFALLA.size());
        PAK_ShipmntEstatusSAP.sendEstatusShipmentEstatusOp(mapShipSAPFALLA);
    }
}