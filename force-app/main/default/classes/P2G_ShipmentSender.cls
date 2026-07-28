public class P2G_ShipmentSender {
    
    public static void enviar(Id shipmentId) {        
        // Validar antes de enviar
        if (!debeEnviar(shipmentId)) {
            System.debug('Shipment no cumple condiciones para envío automático: ' + shipmentId);
            return;
        }
        
        // Ejecutar envío asíncrono
        enviarAsync(shipmentId);
    }
    
    private static Boolean debeEnviar(Id shipmentId) {        
        try {
            Boolean flagSendSAP=false;
            List<Shipment__c> ships = [
                SELECT Id, Name, Shipment_Type__c, Shipment_Status_Mon__c,
                       Ocean_Shipment_Status__c, Shipment_Status__c,
                       Air_Shipment_Status__c, Account_for__r.Venta_Sap__c,
                       Shipment_Status_Plann__c, Freight_Mode__c
                FROM Shipment__c 
                WHERE Id = :shipmentId 
                LIMIT 1
            ];
            System.debug('ships '+ships);
            // Ahora sí podemos validar si está vacío
            if (ships.isEmpty()) {
                System.debug('Shipment no encontrado: ' + shipmentId);
                return flagSendSAP;
            }
            
            Shipment__c ship = ships[0];
            String tipo = ship.Shipment_Type__c;

            /*
            if (tipo != 'M' && tipo != 'A') {
                System.debug('Tipo no válido: ' + tipo);
                return false;
            }            
            
            if (tipo == 'M') {
                if (ship.Ocean_Shipment_Status__c == 'ETD' || ship.Shipment_Status__c == 'ETD') {
                    System.debug('Tipo M - ETD encontrado');
                    return true;
                } else {
                    System.debug('Tipo M - No se encontró ETD. Ocean: ' + ship.Ocean_Shipment_Status__c + 
                                 ' | Shipment: ' + ship.Shipment_Status__c);
                    return false;
                }
            }
            
            if (tipo == 'A') {
                if (ship.Air_Shipment_Status__c == 'Flight Confirmation') {
                    System.debug('Tipo A - Flight Confirmation encontrado');
                    return true;
                } else {
                    System.debug('Tipo A - Air_Shipment_Status__c: ' + ship.Air_Shipment_Status__c);
                    return false;
                }
            }*/
            switch on tipo{
                when 'M'{                    
                    //Maritimo Import
                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Ocean_Shipment_Status__c == 'ETD') {
                        System.debug('Tipo M - ETD encontrado');
                        flagSendSAP=true;
                    } 
                    
                    if(ship.Account_for__r.Venta_Sap__c == 'Contado' && ship.Ocean_Shipment_Status__c == 'Booking Confirmation') {
                        System.debug('Tipo M - Booking Confirmation encontrado');
                        flagSendSAP=true;
                    }
                    
                    //Maritimo Export
                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Shipment_Status__c == 'Delivered') {
                        System.debug('Tipo M - ETD encontrado');
                        flagSendSAP=true;
                    } 
                    //Schedules -> Pending but Pre-Captured
                    if(ship.Account_for__r.Venta_Sap__c == 'Contado' && ship.Shipment_Status__c == 'Pending but Pre-Captured') {
                        System.debug('Tipo M - Booking Confirmation encontrado');
                       	flagSendSAP=true;
                    }                    
                    /*
                     else {
                        System.debug('Tipo M - No se encontró ETD. Ocean: ' + ship.Ocean_Shipment_Status__c + 
                                     ' | Shipment: ' + ship.Shipment_Status__c);
                        return false;
                    }*/
                }
                when 'A'{
                    if (ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Air_Shipment_Status__c == 'Flight Confirmation') {
                        System.debug('Tipo A - Flight Confirmation encontrado');
                        flagSendSAP=true;
                    }
                    if (ship.Account_for__r.Venta_Sap__c == 'Contado' && ship.Air_Shipment_Status__c == 'Contact with Origin') {
                        System.debug('Tipo A - Contact with Origin encontrado');
                        flagSendSAP=true;
                    }
                }
                when 'PTO'{
                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Shipment_Status_Mon__c=='Delivery on Route_M' ){
                        System.debug('Tipo PTO - Delivery on route encontrado');
                        flagSendSAP=true;
                    }
                    if(ship.Account_for__r.Venta_Sap__c == 'Contado' && ship.Shipment_Status_Mon__c=='In Progress_M'){
                        System.debug('Tipo PTO - In progress encontrado');
                        flagSendSAP=true;
                    }
                }
                when 'FI'{                    
                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Shipment_Status_Mon__c=='Delivery on Route_M' ){
                        System.debug('Tipo PTO - Delivery on route encontrado');
                        flagSendSAP=true;
                    }
                    if(ship.Account_for__r.Venta_Sap__c == 'Contado' && ship.Shipment_Status_Mon__c=='In Progress_M'){
                        System.debug('Tipo PTO - In progress encontrado');
                        flagSendSAP=true;
                    }                    
                }
                when 'FN'{         
                    System.debug('Entra a los FN');
                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Shipment_Status_Mon__c=='Delivery on Route_M' ){                        
                        System.debug('Tipo FN - Delivery on route encontrado');
                        flagSendSAP=true;
                    }
                    if(ship.Account_for__r.Venta_Sap__c == 'Contado' && ship.Shipment_Status_Mon__c=='In Progress_M'){
                        System.debug('Tipo FN - In progress encontrado');
                        flagSendSAP=true;
                    }
                }
                when 'PQ'{
                     if(ship.Account_for__r.Venta_Sap__c == 'Contado' && ship.Shipment_Status_Plann__c == 'In progress') {
                        System.debug('Tipo PQ - In progress');
                        flagSendSAP=true;
                    }

                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Shipment_Status_Plann__c == 'Confirmed') {
                        System.debug('Tipo PQ - Confirmed');
                        flagSendSAP=true;
                    }                    
                }
                when 'W'{
                    //ETD -> Delivered
                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Shipment_Status__c == 'Delivered') {
                        System.debug('Tipo W - Delivered encontrado');
                        flagSendSAP=true;
                    }
                }

                when 'R'{
                    if(ship.Freight_Mode__c=='Air'){
                        if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Air_Shipment_Status__c=='Consigness Notification'){
                            System.debug('Tipo R/Air - Consigness Notification encontrado');
                            flagSendSAP=true;                            
                        }                        
                    }
                    if(ship.Freight_Mode__c=='Sea'){
                        if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Shipment_Status__c=='ETA -15'){
                            System.debug('Tipo R/SEA - ETA-15 encontrado');
                            flagSendSAP=true;
                        }                        
                    }                    
                    
                }
                when 'AW'{
                    if(ship.Account_for__r.Venta_Sap__c == 'Credito' && ship.Air_Shipment_Status__c=='Pickup and Delivery to Airline'){
                        System.debug('Tipo AW - Pickup and Delivery to Airline encontrado');
                        flagSendSAP=true;
                    }
                }
                when else{
                    System.debug('No entra en ninguna condicion encontrado');                    
                }                
            }
            return flagSendSAP;
                        
        } catch (Exception e) {
            System.debug('Error en validación: ' + e.getMessage());
            return false;
        }
    }
    
    private static void enviarAsync(Id shipmentId) {
        Boolean flagSendToSAPTest=Boolean.valueOf(System.Label.SendToSAPTest);
        //= Boolean.valueOf(System.Label.SendToSAPTest);
        try {
            Shipment__c mockShipment = new Shipment__c(Id = shipmentId);
            ApexPages.StandardController mockController = new ApexPages.StandardController(mockShipment);
            
            // Ejecutar tu clase existente
            if(flagSendToSAPTest){
            	System.debug('Envio exitoso para Shipment Test: ' + shipmentId);    
            }else{
                PAK_SendToOrder sendToOrder = new PAK_SendToOrder(mockController);
            	sendToOrder.IdShipment = shipmentId;
            	sendToOrder.SendWS();   
                System.debug('Envio exitoso para Shipment: ' + shipmentId);                	
            }                        
            
            
        } catch (Exception e) {
            System.debug('Error en envío para Shipment ' + shipmentId + ': ' + e.getMessage());
        }
    }
}