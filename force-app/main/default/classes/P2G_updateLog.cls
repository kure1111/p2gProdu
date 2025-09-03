public class P2G_updateLog {
    public static void handleUpdate(Fee__c feeToUpdate) {
        Log_Aprobacion__c log = new Log_Aprobacion__c();
        List<Shipment_Fee_Line__c> spLine =[SELECT Shipment__c FROM Shipment_Fee_Line__c where Service_Rate_Name__c =: feeToUpdate.Id]; 
        if(spLine.size() > 0){
            cambiaStatus(spLine[0].Shipment__c);
        }  
    }
    public static void cambiaStatus(String idShipment){
        List<Log_Aprobacion__c> aprobacion = [SELECT Id,Status__c,montoMaximo__c,montoPorAprobar__c,Shipment__c, motivoSolicitud__c,SolicitadoPor__c, Shipment__r.Name 
                                                  FROM Log_Aprobacion__c 
                                                  WHERE Shipment__c =:idShipment];
        if(aprobacion.size() > 0){
            aprobacion[0].Status__c = 'Cambio Precio';
            update aprobacion;
        }
        
    }
}