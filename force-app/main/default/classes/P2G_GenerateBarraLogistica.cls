public class P2G_GenerateBarraLogistica {
    public void mainShipment(List<Shipment__c> newRecords, Map<Id, Shipment__c> oldMap){
        Set<Id> shipmentIds=new Set<Id>();
        Shipment__c oldShipment;
        for(Shipment__c shipment: newRecords){
            oldShipment=oldMap.get(shipment.Id);
            if(shipment.Requiere_barras_logisticas__c && 
               (shipment.Requiere_barras_logisticas__c!=oldShipment.Requiere_barras_logisticas__c) && 
               shipment.Carrier__c!=null){
                createBarraLogistica(shipment);
            }
        }
    }
    
    public static List<Barra_Logistica__c> getAllBarraLogistica(Id shipmentId){
        return [SELECT Id, Shipment__c, CreatedDate FROM Barra_Logistica__c WHERE Shipment__c =: shipmentId ORDER BY CreatedDate DESC LIMIT 1];
    }
    
    public static void createBarraLogistica(Shipment__c shipment){        
        List<Barra_Logistica__c> listBarrasLogisticas = getAllBarraLogistica(shipment.Id);
        Account getInfoCarrier=getDataToCarrier(shipment.Carrier__c);
        if(listBarrasLogisticas.isEmpty()){
            Barra_Logistica__c newBarraLogistica= new Barra_Logistica__c();
            newBarraLogistica.Shipment__c=shipment.Id;
            newBarraLogistica.Account__c=getInfoCarrier.Id;
            insert newBarraLogistica;
        }        
    }  
    
    public static Account getDataToCarrier(Id accountId){
        return [SELECT Id,Retorno_barras_logisticas__c,Barras_logisticas_pendientes__c,
                Monto_retenido_incidencias_barras__c,Tiempo_promedio_devolucion_barras__c,
                Total_barras_perdidas__c, Costo_reposicion_barra_logistica__c
                FROM Account WHERE Id=:accountId];
    }
    
    public void mainBarraLogistica(List<Barra_Logistica__c> newRecords, Map<Id, Barra_Logistica__c> oldMap){        
        Set<Id> barraLogisticaIds=new Set<Id>();
        Barra_Logistica__c oldBarraLogistica;
        for(Barra_Logistica__c barra: newRecords){
            oldBarraLogistica=oldMap.get(barra.Id);
            if((barra.Faltantes__c!=null && barra.Faltantes__c!=oldBarraLogistica.Faltantes__c) || 
               (barra.Danadas__c!=null && barra.Danadas__c!= oldBarraLogistica.Danadas__c)){
                   updateBarraLogistica(barra);				                
            }
        }
    }
    
    public static void updateBarraLogistica(Barra_Logistica__c barraLogistica){
        Account getInfoCarrier=getDataToCarrier(barraLogistica.Account__c);
        if(getInfoCarrier!=null){
            Double danadas = barraLogistica.Danadas__c != null ? barraLogistica.Danadas__c : 0;
    		Double faltantes = barraLogistica.Faltantes__c != null ? barraLogistica.Faltantes__c : 0;
    		Double costo = getInfoCarrier.Costo_reposicion_barra_logistica__c != null ? getInfoCarrier.Costo_reposicion_barra_logistica__c : 0;
			Double deudaTotalAdeudo = costo * (danadas + faltantes);
    		barraLogistica.Cargo_no_retorno__c = deudaTotalAdeudo;
            //update barraLogistica;
        }
    }
    
}