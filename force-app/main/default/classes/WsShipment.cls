// @ts-nocheck
@RestResource(urlMapping='/Shipment__c/*')
global with sharing class WsShipment {

    private static set<string> setRoadType {get;set;}
    private static set<string> setAirType {get;set;}
    private static set<string> setOceanType {get;set;}

    public static void GenerarSets(){
        setRoadType = new set<string>();
        setAirType = new set<string>();
        setOceanType = new set<string>();
        setRoadType.add('SP-PT');
        setRoadType.add('SP-FI');
        setRoadType.add('SP-FN');
        setAirType.add('SP-A-');
        setOceanType.add('SP-M-');
    }

    @HttpPut
    global static string UpdateShipment() {
		try {
            RestRequest req = RestContext.request;
            String body = req.requestBody.toString();
            System.debug('bodyC: '+ body);
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(body);

            String idShipment = (String)data.get('idShipment');
            String status = (String)data.get('status');
            String eventDatetime = (String)data.get('eventDatetime');
            String specialNote = (String)data.get('specialNote');
            String otd = (String)data.get('otd');

            String mensaje = validarParametros(idShipment);
            GenerarSets();
            if(mensaje != 'OK' ) {
                return 'Error: '+ mensaje;
            }
            DateTime fecha;
            Boolean resetDate = false;
            if (String.isNotBlank(eventDatetime)) {
                if (eventDatetime != 'NA'){
                    fecha = DateTime.valueOfGmt(eventDatetime);
                }
                else resetDate = true;
            }

            Shipment__c ship = [
                SELECT Id, 
                	Equip_Placed__c, Equip_Reserved__c, Equip_Loaded__c, Departure_Time__c, 
                	Equip_Solicited__c, Equip_Unloaded__c,ShipmentService__c,Service_Mode__c
                FROM Shipment__c 
                WHERE Id = :idShipment 
                LIMIT 1
           	];
            String type = ship.ShipmentService__c;
            String servicesMode = ship.Service_Mode__c;
            if(resetDate && status == 'Awaiting load_M'){
                ship.Equip_Loaded__c = null;
                ship.Shipment_Status_Mon__c = 'Awaiting load_M';
            }

            if(resetDate && status == 'Awaiting Unload_M'){
                ship.Equip_Solicited__c = null;
                ship.Shipment_Status_Mon__c = 'Awaiting Unload_M';
            }
            if(status == 'Awaiting load_M' && !resetDate){
                ship.Equip_Placed__c = fecha;
            }

            if(setRoadType.contains(type) && !resetDate) {
                if (status != 'Arrive Origin' && status != 'Arrive Destination' && status!= null) {
                    ship.Shipment_Status_Mon__c = status;
                }
                
                if(fecha !=null) {
                    switch on status{
                        when 'Arrive Destination' {
                            ship.Equip_Reserved__c = fecha;
                        }
                        when 'Awaiting Unload_M' {
                            if(ship.Equip_Reserved__c == null) {
                                ship.Equip_Reserved__c = fecha;
                            }
                        }
                        when 'Delivery on Route_M' {
                            if(ship.Departure_Time__c == null) {
                                ship.Departure_Time__c = fecha;
                            }
                        }
                        when 'Finished_M' {
                            if(ship.Equip_Unloaded__c == null) {
                                ship.Equip_Unloaded__c = Fecha;
                            }
                        }
                        when 'Loading_M' {
                            if(ship.Equip_Loaded__c == null) {
                                ship.Equip_Loaded__c = fecha;
                            }
                        }
                        when 'Unloading_M' {
                            if(ship.Equip_Solicited__c == null) {
                                ship.Equip_Solicited__c = fecha;
                            }
                        }
                    }
                }
            }
                
            if(setAirType.contains(type) && status != null) {
                ship.Air_Shipment_Status__c  = status;
            }
                
            if(String.isNotBlank(servicesMode) && setOceanType.contains(type) && status!=null) {
                if(servicesMode == 'EXPORT') {
                    ship.Shipment_Status__c  = status;
                }
                if(servicesMode == 'IMPORT') {
                    ship.Ocean_Shipment_Status__c  = status;
                }
            }

            if(String.isNotBlank(specialNote)) {
                ship.Special_Notes__c = specialNote;
            }

            if(String.isNotBlank(otd)){
                ship.OTD__c = otd;
            }
            update ship;
            return 'El shipment fue Actualizado con Éxito..';
        } catch(Exception ex) {
            System.debug('Error: '+ex.getMessage());
            return 'Error: '+ ex.getMessage();
        }

    }

    private static string validarParametros(string idShipment) {
        if(string.isEmpty(idShipment)) {
          return 'Favor de enviar el id del Shipment';
        }
        return 'OK';
    }
}