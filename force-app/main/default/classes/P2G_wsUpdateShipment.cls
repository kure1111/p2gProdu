@RestResource(urlMapping='/updateShipmnet/*')
global class P2G_wsUpdateShipment {
    public static final String NOMBRE_SERVICIO = 'url';
    @HttpPost
    global static String updateShipmnet(){
        String message;
        String trackinId='';
        if(RestContext.request != null){
            String requestBody = RestContext.request.requestBody.toString();
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
            String idShip = (String)jsonMap.get('idShip');
            String status = (String)jsonMap.get('status');
            message = updateStatus(idShip, status);
        }
        return 'Conexion Exitosa'+message;
    }
    public static String updateStatus(String idShip, String status){
        String message;
        try{
            Shipment__c ship = [SELECT Shipment_Status_Mon__c FROM Shipment__c WHERE id=:idShip];
            if(status=='success'){        
            	ship.Shipment_Status_Mon__c= 'Delivery on Route_M';     
            }
            else{
                ship.Shipment_Status_Mon__c= 'Error en Monitoreo_M';
            }
            update ship;            
        }
        catch(Exception e){
            message = e.getMessage()+ ' '+e.getLineNumber();
        }
        return message;
    }
}