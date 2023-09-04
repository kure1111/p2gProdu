trigger ResponseOVSC on Response__c (before insert, after insert) {
    
    if(trigger.isbefore)
    {
        for(Response__c r : Trigger.New)
        {
            String msj = r.Message__c != null ? r.Message__c : '';
            
            if(msj.contains('Actualizada Sol.Compra'))
            {
                r.SolOrdenCompraSAP__c = msj.substringAfter('Actualizada Sol.Compra:').trim();
            }  
            else if(msj.contains('Solicitud de Compra creada'))
            {
                r.SolOrdenCompraSAP__c = msj.substringAfter('Solicitud de Compra creada:').trim();
            }
            else if(msj.contains('Solicitud de Compra Actualizada') && msj.contains('/'))
            {
                r.SolOrdenCompraSAP__c = msj.substringAfter('Solicitud de Compra Actualizada:').substringbefore('/').trim();
            }  
            else if(msj.contains('Solicitud de Compra Actualizada'))
            {
                r.SolOrdenCompraSAP__c = msj.substringAfter('Solicitud de Compra Actualizada:').trim();
            }  
            
            if(msj.contains('Orden de Venta Actualizada')&& msj.contains('Solicitud de Compra creada:') )
            {
                r.OrdenVentaSAP__c  = msj.substringAfter('Orden de Venta Actualizada:').substringbefore('Solicitud de Compra creada:').trim();
            }
            else if(msj.contains('Orden de Venta Actualizada')&& msj.contains('Actualizada Sol.Compra:') )
            {
                r.OrdenVentaSAP__c  = msj.substringAfter('Orden de Venta Actualizada:').substringbefore('Actualizada Sol.Compra:').trim();
            }
            else if(msj.contains('Orden de Venta creada'))
            {
                r.OrdenVentaSAP__c = msj.substringAfter('Orden de Venta creada:').trim();
            } 
            else if(msj.contains('Orden de Venta Actualizada') && msj.contains('/'))
            {
                r.OrdenVentaSAP__c = msj.substringAfter('Orden de Venta Actualizada:').substringbefore('/').trim();
            }
            
            else if(msj.contains('Orden de Venta Actualizada'))
            {
                r.OrdenVentaSAP__c = msj.substringAfter('Orden de Venta Actualizada:').trim();
            }
        }
        
    }
    else if(trigger.isAfter)
    {
        Map<id, shipment__c> shipOlds = new Map<id, shipment__c>();
        set<string> ids = new set<string>();
        
        for(Response__c res : Trigger.New)
        {
            ids.add(res.Shipment__c);
        }
        
        for(Shipment__c ship: [SELECT Id, SolicitudCompra__c, OrdenVenta__c FROM Shipment__c where id =: ids])
        {
            shipOlds.put(ship.id, ship);
        }
        
        for(Response__c r : Trigger.New)
        {
            system.debug('ressss ' + r);
            
            Shipment__c ship = null;
            
            if(r.Shipment__c != null)
                ship =  shipOlds.get(r.Shipment__c); 
            
            system.debug('r.Shipment__c ' + r.Shipment__c);
            system.debug('ship 1  ' + ship );
            
            if(ship != null)
            {   
                if(r.SolOrdenCompraSAP__c != null )
                    ship.SolicitudCompra__c = r.SolOrdenCompraSAP__c ;
                
                if(r.OrdenVentaSAP__c != null)
                    ship.OrdenVenta__c = r.OrdenVentaSAP__c ;
                
            }
            
            
            if( ship!= null && ( r.SolOrdenCompraSAP__c != null  ||   r.OrdenVentaSAP__c != null ))
            {
                NEU_StaticVariableHelper.setBoolean1(true);
                update ship;
                NEU_StaticVariableHelper.setBoolean1(false);
            }
            
            system.debug('r.SolOrdenCompraSAP__c ' + r.SolOrdenCompraSAP__c );
            system.debug('  r.OrdenVentaSAP__c   ' +  r.OrdenVentaSAP__c   );
            system.debug('ship  2 ' + ship );
        }

    }
}