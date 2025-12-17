@RestResource(urlMapping='/v2/invoice')
global with sharing class P2G_CancelacionInvoiceController {

    @HttpPut
    global static String cancelInvoice() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        P2G_InvoiceHandlerService service = new P2G_InvoiceHandlerService();

        jsonResponse response = new jsonResponse();

        try {
            String dataSAP = req.requestBody.toString();
            System.debug('DataSAP: ' + dataSAP);

            if (String.isBlank(dataSAP)) {
                res.statusCode = 400;
                response.statusJSON = 'Error';
                response.messageError = 'Error en línea 24: JSON vacío';
                return JSON.serialize(response);
            }

            InvoiceCancelWrapper data = (InvoiceCancelWrapper) JSON.deserialize(dataSAP, InvoiceCancelWrapper.class);
            List<String> errores = validarDatosEntrada(data);

            if (!errores.isEmpty()) {
                res.statusCode = 400;
                response.statusJSON = 'Error';
                response.messageError = 'Error en línea 33: ' + String.join(errores, ' | ');
                return JSON.serialize(response);
            }

            // --- Caso con invoiceId ---
            if (!String.isBlank(data.invoiceId)) {
                Invoice__c invoice = service.getInvoice(data.invoiceId);
                Boolean actualizado = service.updateInvoice(invoice, data.datosFactura);
                Set<String> shipmentServiceLineIds = service.getShipmentServiceLineByInvoiceId(data.invoiceId);
                service.updateShipmentServiceLine(shipmentServiceLineIds);
            }

            // --- Caso con lineasIds ---
            if (data.lineasIds != null && !data.lineasIds.isEmpty() && String.isBlank(data.invoiceId)) {
                Set<String> validLineIds = new Set<String>();
                for (String lineId : data.lineasIds) {
                    if (String.isNotBlank(lineId)) validLineIds.add(lineId);
                }

                if (!validLineIds.isEmpty()) {
                    service.updateShipmentServiceLine(validLineIds);
                }
            }

            if (data.idsOrdenCancel != null) {
                System.debug('idsOrdenCancel recibido: ' + data.idsOrdenCancel + ', tamaño: ' + data.idsOrdenCancel.size());
            }

            res.statusCode = 200;
            response.statusJSON = 'Success';
            response.messageError = '';
            return JSON.serialize(response);

        } catch (Exception e) {
            res.statusCode = 500;
            response.statusJSON = 'Error';
            response.messageError = 'Error en línea ' + e.getLineNumber() + ': ' + e.getMessage();
            return JSON.serialize(response);
        }
    }

    // --- Validación ---
    private static List<String> validarDatosEntrada(InvoiceCancelWrapper data) {
        List<String> errores = new List<String>();

        Boolean tieneInvoiceId = String.isNotBlank(data.invoiceId);
        Boolean tieneLineasIds = data.lineasIds != null && !data.lineasIds.isEmpty();

        if (tieneLineasIds) {
            Boolean tieneLineasValidas = false;
            for (String lineId : data.lineasIds) {
                if (String.isNotBlank(lineId)) {
                    tieneLineasValidas = true;
                    break;
                }
            }
            tieneLineasIds = tieneLineasValidas;
        }

        if (!tieneInvoiceId && !tieneLineasIds)
            errores.add('Se requiere al menos invoiceId o lineasIds con valores válidos');

        if (tieneInvoiceId && tieneLineasIds)
            errores.add('No se puede enviar invoiceId y lineasIds al mismo tiempo');

        return errores;
    }
    
    global class InvoiceCancelWrapper {
        global String invoiceId;
        global List<String> lineasIds;
        global DataFactura datosFactura;
        global List<String> idsOrdenCancel;
    }

    global class DataFactura {
        global String statusFactura;
        global String UUID;
    }
    
    global class jsonResponse{
    	global String statusJSON;
    	global String messageError;
	}

}