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
    global static string UpdateShipment(
      string status,
      string idShipment,
      string type,
      string eventDatetime,
      string specialNote,
      string servicesMode,
      string otd
      
    ) {
		try {
            string mensaje = validarParametros(status, idShipment, type, eventDatetime);
            GenerarSets();
            System.debug('specialNoteXX: '+ specialNote);
            if(mensaje != 'OK' ) {
                return 'Error: '+ mensaje;
            }
             
            DateTime fecha =  DateTime.valueOfGmt(eventDatetime);

            Shipment__c ship = [
                SELECT Id, 
                	Equip_Placed__c, Equip_Reserved__c, Equip_Loaded__c, Departure_Time__c, 
                	Equip_Solicited__c, Equip_Unloaded__c 
                FROM Shipment__c 
                WHERE Id = :idShipment 
                LIMIT 1
           	];

            if(setRoadType.contains(type)) {
                if (status != 'Arrive Origin' && status != 'Arrive Destination') {
                    ship.Shipment_Status_Mon__c = status;
                }
                
                if(fecha !=null) {
                    switch on status{
                       /* when 'Arrive Origin' {
                            ship.Equip_Placed__c = fecha;
                        }  */
                        when 'Arrive Destination' {
                            ship.Equip_Reserved__c = fecha;
                        }
                       /* when 'Awaiting load_M' {
                            if(ship.Equip_Placed__c == null) {
                                ship.Equip_Placed__c = fecha;
                            }
                        } */
// Se comenta el campo Equip_Placed__c derivado de que el equipo operativo requiere que no se actualice la fecha cada que se actualice el SP,
// dado que que ese campo se actualia por parte del usario lo que omite su actualización por parte de Control Room

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
                
            if(setAirType.contains(type)) {
                ship.Air_Shipment_Status__c  = status;
            }
                
            if(String.isNotBlank(servicesMode) && setOceanType.contains(type)) {
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

    private static string validarParametros(string status, string idShipment, string type, string eventDatetime) {
        if(string.isEmpty(idShipment)) {
          return 'Favor de enviar el id del Shipment';
        }
        if(string.isEmpty(status)) {
            return 'Favor de enviar un valor de estatus';
        }
        if(string.isEmpty(type)) {
            return 'Favor de enviar un tipo de shipment';
        }
        if(string.isEmpty(eventDatetime)) {
            return 'Favor de enviar un eventDatetime';
        }

        return 'OK';
    }
}