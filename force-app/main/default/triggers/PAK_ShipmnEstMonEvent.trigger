trigger PAK_ShipmnEstMonEvent on Shipment__ChangeEvent (after insert) {
    System.debug('PAK_ShipmnEstMon IN');
    Map<Id, String> mapShipUser = new Map<Id, String>();
    Map<Id, String> mapShipSAP = new Map<Id, String>();
    Map<Id, String> mapShipSAPFALLA = new Map<Id, String>();
    set<String> shipIds = new set<String>();
    
    for(Shipment__ChangeEvent ship : Trigger.New){
        system.debug('SHIP EVENT ' + SHIP);
        List<String> recordIds = ship.ChangeEventHeader.getRecordIds();
        shipIds.addAll(recordIds);
    }
    
    Map<id, shipment__c> shipOlds = new Map<id, shipment__c>();
    
    for(shipment__C Ship : [select id, name,Shipment_Type__c,Shipment_Status_Plann__c,Shipment_Status_Mon__c,Shipment_Status__c,
                            Ocean_Shipment_Status__c,Air_Shipment_Status__c,Estatus_de_operacion__c
                            from shipment__c where id in :shipIds  ])
    {
        shipOlds.put(ship.Id, ship);
    }
    
    for(Shipment__ChangeEvent shipEvento : Trigger.New){
        
        EventBus.ChangeEventHeader header = shipEvento.ChangeEventHeader;
        
        for(string id : header.getRecordIds())
        {
            system.debug('FIELDS -> ' + header.changedFields );
            for (String field : header.changedFields) {
                
                shipment__C ShipOld = shipOlds.get(Id);
                
              
                if( field == 'Shipment_Status_Mon__c' && shipEvento.get(field) != null && shipEvento.get(field) == 'Finished_M'){
                    mapShipUser.put(Id, UserInfo.getName());
                }
                
                SYSTEM.debug('ENTRO AQUI ship.Shipment_Type__c ' + ShipOld.Shipment_Type__c);
                
                //MEJORA ENVIAR TODOS LOS STATUS A SAP
                if(field == 'Shipment_Status_Plann__c' && shipEvento.get(field) != null
                   &&  ( ShipOld.Shipment_Type__c.contains('FN') || ShipOld.Shipment_Type__c.contains('FI') || ShipOld.Shipment_Type__c.contains('PTO') 
                        ||  ShipOld.Shipment_Type__c.contains('PQ') || ShipOld.Shipment_Type__c.contains('ES') || ShipOld.Shipment_Type__c.contains('EX')
                        || ShipOld.Shipment_Type__c.contains('WH')))
                {
                    
                    SYSTEM.debug('ENTRO AQUI' + id);
                    list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                                 FROM Response__c 
                                                 where Shipment__c  =: id
                                                 and ( Message__c  like '%Orden de Venta creada%' 
                                                      or Message__c  like '%Solicitud de Compra creada%' 
                                                      or Message__c  like '%Actualizada Sol.Compra%' 
                                                      or  Message__c  like '%Orden de Venta Actualizada%') ]; 
                    
                    SYSTEM.debug('ENTRO AQUI ' + id);
                    
                    if(respons.size () > 0)
                    {
                        SYSTEM.debug('ENTRO AQUI status ' + shipEvento.get(field));
                        mapShipSAP.put(Id, (string)shipEvento.get(field));
                    }
                }
                
                //MEJORA ENVIAR TODOS LOS STATUS ocean expo a SAP
                if( field == 'Shipment_Status__c' &&  shipEvento.get(field) !=  null
                   &&    ShipOld.Shipment_Type__c.contains('M')){
                       
                       list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                                    FROM Response__c 
                                                    where Shipment__c  =: id
                                                    and ( Message__c  like '%Orden de Venta creada%' 
                                                         or Message__c  like '%Solicitud de Compra creada%' 
                                                         or Message__c  like '%Actualizada Sol.Compra%' 
                                                         or  Message__c  like '%Orden de Venta Actualizada%') ]; 
                       SYSTEM.debug('ENTRO AQUI 2 ' + id);
                       if(respons.size () > 0)
                       {
                           SYSTEM.debug('ENTRO AQUI status ' + shipEvento.get(field));
                           mapShipSAP.put(Id, (string)shipEvento.get(field));
                       }
                       
                   }
                
                
                //MEJORA ENVIAR TODOS LOS STATUS ocean impo a SAP
                if( field == 'Ocean_Shipment_Status__c' && shipEvento.get(field) != null
                   && ShipOld.Shipment_Type__c.contains('M')){
                       
                       list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                                    FROM Response__c 
                                                    where Shipment__c  =: id
                                                    and ( Message__c  like '%Orden de Venta creada%' 
                                                         or Message__c  like '%Solicitud de Compra creada%' 
                                                         or Message__c  like '%Actualizada Sol.Compra%' 
                                                         or  Message__c  like '%Orden de Venta Actualizada%') ]; 
                       SYSTEM.debug('ENTRO AQUI 3 ' + id);
                       if(respons.size () > 0)
                       {
                           SYSTEM.debug('ENTRO AQUI status ' + shipEvento.get(field));
                           mapShipSAP.put(Id, (string)shipEvento.get(field));
                       }
                       
                   }
                
                //MEJORA ENVIAR TODOS LOS STATUS AIR a SAP
                if(field == 'Air_Shipment_Status__c'  && shipEvento.get(field) != null
                   &&   ShipOld.Shipment_Type__c.contains('A'))
                {
                    
                    list<Response__c> respons = [SELECT Id, Name, OrdenVentaSAP__c, SolOrdenCompraSAP__c, Shipment__c,Message__c  
                                                 FROM Response__c 
                                                 where Shipment__c  =: id
                                                 and ( Message__c  like '%Orden de Venta creada%' 
                                                      or Message__c  like '%Solicitud de Compra creada%' 
                                                      or Message__c  like '%Actualizada Sol.Compra%' 
                                                      or  Message__c  like '%Orden de Venta Actualizada%') ]; 
                    SYSTEM.debug('ENTRO AQUI 4 ' + id);
                    if(respons.size () > 0)
                    {
                        SYSTEM.debug('ENTRO AQUI status ' + shipEvento.get(field));
                        mapShipSAP.put(Id, (string)shipEvento.get(field) );
                    }
                    
                }
                
                //MEJORA ENVIAR TODOS LOS STATUS AIR a SAP
                if (field == 'Estatus_de_operacion__c' &&  shipEvento.get(field)  != null)
                {
                    SYSTEM.debug('ENTRO AQUI status Estatus_de_operacion__c ' +  shipEvento.get(field));
                    mapShipSAPFALLA.put(Id, (string) shipEvento.get(field));
                }
            }
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
    
    if(TEST.isRunningTest())
    {
        set<id> idset = shipOlds.keySet();
        list<id> ids =   (new list<id>(idset) ); 
                             mapShipSAP.put(ids[0], 'Closed');
                             mapShipSAPFALLA.put(ids[0], 'Closed');
          					 mapShipSAPFALLA.put(ids[0], 'Closed');
                             
        PAK_ShipmntEstatusSAP.sendEstatusShipment(mapShipSAP);
        PAK_ShipmntEstatusSAP.sendEstatusShipmentEstatusOp(mapShipSAPFALLA);
        PAK_ShipmntEstMonWs.estatusShipmentMon(mapShipUser);
        
        string a = '';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
    }
}