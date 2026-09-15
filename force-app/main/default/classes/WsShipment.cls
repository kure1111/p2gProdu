/**
 * Servicio REST que consume Control Room para empujar eventos de tracking al Shipment.
 * PUT /services/apexrest/Shipment__c/
 * Body: { idShipment, status, eventDatetime ('yyyy-MM-dd HH:mm:ss' GMT o 'NA' para reset),
 *         specialNote, otd, devolucion (boolean) }
 * Respuestas (texto plano, el bot las parsea — NO cambiar):
 *   'El shipment fue Actualizado con Éxito..' | 'Error: <detalle>'
 */
@RestResource(urlMapping='/Shipment__c/*')
global with sharing class WsShipment {

    private static final Set<String> TIPOS_ROAD  = new Set<String>{ 'SP-PT', 'SP-FI', 'SP-FN' };
    private static final Set<String> TIPOS_AIR   = new Set<String>{ 'SP-A-' };
    private static final Set<String> TIPOS_OCEAN = new Set<String>{ 'SP-M-' };

    @HttpPut
    global static String UpdateShipment() {
        try {
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());

            String idShipment    = (String) data.get('idShipment');
            String status        = (String) data.get('status');
            String eventDatetime = (String) data.get('eventDatetime');
            String specialNote   = (String) data.get('specialNote');
            String otd           = (String) data.get('otd');
            Boolean devolucion   = leerBoolean(data.get('devolucion'));

            if (String.isEmpty(idShipment)) {
                return 'Error: Favor de enviar el id del Shipment';
            }

            // 'NA' = borrar la fecha del evento; cualquier otro valor no vacio se parsea como GMT
            DateTime fecha = null;
            Boolean resetDate = false;
            if (String.isNotBlank(eventDatetime)) {
                if (eventDatetime == 'NA') {
                    resetDate = true;
                } else {
                    fecha = DateTime.valueOfGmt(eventDatetime);
                }
            }

            Shipment__c ship = [
                SELECT Id,
                    Equip_Placed__c, Equip_Reserved__c, Equip_Loaded__c, Departure_Time__c,
                    Equip_Solicited__c, Equip_Unloaded__c, ShipmentService__c, Service_Mode__c
                FROM Shipment__c
                WHERE Id = :idShipment
                LIMIT 1
            ];

            aplicarStatus(ship, status, fecha, resetDate);

            if (String.isNotBlank(specialNote)) {
                ship.Special_Notes__c = specialNote;
            }
            if (String.isNotBlank(otd)) {
                ship.OTD__c = otd;
            }
            if (devolucion) {
                ship.Devolucion__c = true;
            }

            update ship;
            return 'El shipment fue Actualizado con Éxito..';
        } catch (Exception ex) {
            System.debug('Error: ' + ex.getMessage());
            return 'Error: ' + ex.getMessage();
        }
    }

    private static void aplicarStatus(Shipment__c ship, String status, DateTime fecha, Boolean resetDate) {
        String tipo = ship.ShipmentService__c;

        if (resetDate) {
            // 'NA': borrar la fecha del evento correspondiente (aplica a cualquier tipo)
            if (status == 'Awaiting load_M') {
                ship.Equip_Loaded__c = null;
                ship.Shipment_Status_Mon__c = 'Awaiting load_M';
            }
            if (status == 'Awaiting Unload_M') {
                ship.Equip_Solicited__c = null;
                ship.Shipment_Status_Mon__c = 'Awaiting Unload_M';
            }
        }

        if (status == 'Awaiting load_M' && !resetDate) {
            ship.Equip_Placed__c = fecha;
        }

        if (TIPOS_ROAD.contains(tipo) && !resetDate) {
            if (status != 'Arrive Origin' && status != 'Arrive Destination' && status != null) {
                ship.Shipment_Status_Mon__c = status;
            }
            if (fecha != null) {
                switch on status {
                    when 'Arrive Destination' {
                        ship.Equip_Reserved__c = fecha;
                    }
                    when 'Awaiting Unload_M' {
                        if (ship.Equip_Reserved__c == null) {
                            ship.Equip_Reserved__c = fecha;
                        }
                    }
                    when 'Delivery on Route_M' {
                        if (ship.Departure_Time__c == null) {
                            ship.Departure_Time__c = fecha;
                        }
                    }
                    when 'Finished_M' {
                        ship.Date_time_FN_Finished__c = fecha;
                        if (ship.Equip_Unloaded__c == null) {
                            ship.Equip_Unloaded__c = fecha;
                        }
                    }
                    when 'Loading_M' {
                        if (ship.Equip_Loaded__c == null) {
                            ship.Equip_Loaded__c = fecha;
                        }
                    }
                    when 'Unloading_M' {
                        if (ship.Equip_Solicited__c == null) {
                            ship.Equip_Solicited__c = fecha;
                        }
                    }
                }
            }
        }

        if (TIPOS_AIR.contains(tipo) && status != null) {
            ship.Air_Shipment_Status__c = status;
        }

        if (TIPOS_OCEAN.contains(tipo) && String.isNotBlank(ship.Service_Mode__c) && status != null) {
            if (ship.Service_Mode__c == 'EXPORT') {
                ship.Shipment_Status__c = status;
            }
            if (ship.Service_Mode__c == 'IMPORT') {
                ship.Ocean_Shipment_Status__c = status;
            }
        }
    }

    // acepta true booleano o "true" como texto (por si el bot lo manda como string)
    private static Boolean leerBoolean(Object valor) {
        if (valor instanceof Boolean) {
            return (Boolean) valor;
        }
        return valor != null && String.valueOf(valor).equalsIgnoreCase('true');
    }
}
