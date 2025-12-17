public class P2G_ChangeCampoControl {
    @TestVisible
    private static final String OBJECT_INVOICE = 'Invoice';
    @TestVisible
    private static final String MESSAGE_ENTREGA_CREADA = 'Entrega Creada No. :';
    @TestVisible
    private static final String MESSAGE_ENTREGA_ACTUALIZADA='Entrega Actualizada No. :';
    @TestVisible
    private static final String MESSAGE_ID_LINES = 'IdLines:';
    @TestVisible
    private static final String UPDATE_SUCCESS_MSG='Se ha actualizado de forma correcta el siguiente registro';
    @TestVisible
    private static final String UPDATE_ERROR_MSG='No se ha podido actualizar los registros solicitados';


    public static void main(List<Response__c> newResponses){ 
        System.debug('Entrando a mi clase');
        try{
            List<Response__c> validResponse= getValidResponses(newResponses);
            //List<Response__c> updateResponse=getUpdateResponse(newResponses);
            if(validResponse!=null){
                //OBTENEMOS LOS Ids 
                //Shipment Service line
                Set<String> shipmentServiceLineIds=processValidMessage(validResponse);
                //Invoice
                SET<String> invoiceIds=getIdInvoicefromResponse(validResponse);                
                //Listado de objetos para actualizar
                List<Shipment_Fee_Line__c> listShipmentServiceLine;
                List<Invoice__c> listInvoice;
                List<Invoice_Line__c> listInvoiceLine; 
                
                
                //Actualizacion y consulta
                //Invoice e Invoice Line
                System.debug(invoiceIds);
                if(invoiceIds!=null){                    
                    listInvoice=getAllInvoiceById(invoiceIds);
                    listInvoiceLine=getInvoiceLineByInvoice(invoiceIds);
                    updateInvoice(listInvoice);
                    updateInvoiceLine(listInvoiceLine);
                } 
                
                //Shipment Service Line
                if(shipmentServiceLineIds!=null){
                    listShipmentServiceLine=getAllShipmentServiceLineById(shipmentServiceLineIds);
                    updateShipmentServiceLine(listShipmentServiceLine);
                }

                                               
            }
/*
            if(updateResponse!=null){
                SET<String> invoiceIdsFromUpdateResponse= getIdInvoicefromResponse(updateResponse);
            }
*/
        }catch(Exception e){
			System.debug('\nError: ' + e.getMessage() + ' | Linea: ' + e.getLineNumber());
        }
    }
	@TestVisible
    private static List<Response__c> getValidResponses(List<Response__c> newResponses){
        List<Response__c> validResponse= new List<Response__c>();
        for(Response__c response: newResponses){
            if(isValidResponse(response)){
                validResponse.add(response);
            }
        }
        return validResponse;
    }
    /*
    @TestVisible
    private static List<Response__c> getUpdateResponse(List<Response__c> newResponses){
         List<Response__c> updateResponse= new List<Response__c>();
        for(Response__c response: newResponses){
            if(isValidUpdateResponse(response)){
                updateResponse.add(response);
            }
        }
        return updateResponse;
    }
*/
	@TestVisible
    private static boolean isValidResponse(Response__c response){
        if(response.Message__c != null && 
               response.Object__c == OBJECT_INVOICE &&(response.Message__c.contains(MESSAGE_ENTREGA_CREADA) &&response.Message__c.contains(MESSAGE_ID_LINES))){                   
                return true;
        }
        return false;        
    }
    /*
    @TestVisible
    private static boolean isValidUpdateResponse(Response__c response){
        if(response.Message__c != null && 
               response.Object__c == OBJECT_INVOICE &&
               response.Message__c.contains(MESSAGE_ENTREGA_ACTUALIZADA)){                   
            return true;
        }
        return false;        
    }
    */
    //Verificacion para casos en donde solo recibimos el mensaje "Entrega Actualizada No. :"
    /*
    @TestVisible
    private static Boolean entregasActualizadasMSG(List<Response__c> validResponse) {
        for(Response__c response : validResponse) {
            if(response.Message__c != null && response.Message__c.contains(MESSAGE_ENTREGA_ACTUALIZADA)) {
                return true;
            }
        }
        return false;
    }
	*/

	@TestVisible
    private static Set<String> getIdInvoicefromResponse(List<Response__c> validResponse){        
        SET<String> invoiceIds= new Set<String>();
        for(Response__c response: validResponse){
            if(response.Invoice__c!=null){
                invoiceIds.add(response.Invoice__c);
            }
        }
        return invoiceIds;
    }
	@TestVisible
    private static SET<String> processValidMessage(List<Response__c> validResponse) {
        Set<String> shipmentServiceLineIds = new Set<String>();
        
        for (Response__c response : validResponse) { 
            
            Integer idLinesIndex = response.Message__c.indexOf(MESSAGE_ID_LINES);
            String idLinesPart = response.Message__c.substring(idLinesIndex + MESSAGE_ID_LINES.length()).trim();
                        
            String[] partes = idLinesPart.split('\\|');
            
            for (String parte : partes) {
                String idLimpio = parte.trim();            
                if (idLimpio.length() == 15 || idLimpio.length() == 18) {
                    shipmentServiceLineIds.add(idLimpio);
                }
            }
        }
                
        System.debug('IDs encontrados: ' + shipmentServiceLineIds);
        return shipmentServiceLineIds;
                
    }
	@TestVisible
    private static List<Invoice__c> getAllInvoiceById(SET<String> invoiceIds){
        return [SELECT Id, Shipment__c, Campo_Control__c 
                FROM Invoice__c 
                WHERE Id IN :invoiceIds
                AND Campo_Control__c != true];
    }
	@TestVisible
    private static List<Shipment_Fee_Line__c> getAllShipmentServiceLineById(SET<String> shipmentServiceLineIds){
        return [SELECT Id, Campo_Control__c, Shipment__c 
                                                         FROM Shipment_Fee_Line__c 
                                                         WHERE Id IN :shipmentServiceLineIds 
                                                         AND Campo_Control__c != true];
    }
    @TestVisible
    private static List<Invoice_Line__c> getInvoiceLineByInvoice(SET<String> invoiceIds){
        return [SELECT Id, Campo_Control__c 
                FROM Invoice_Line__c 
                WHERE Invoice__c IN :invoiceIds
                AND Campo_Control__c != true];
    }
	@TestVisible
    private static String updateShipmentServiceLine(List<Shipment_Fee_Line__c> listShipmentServiceLine){
        if(!listShipmentServiceLine.isEmpty()){
            for(Shipment_Fee_Line__c shipServiceLine : listShipmentServiceLine){
                shipServiceLine.Campo_Control__c = true;
            }
            update listShipmentServiceLine;
            return UPDATE_SUCCESS_MSG + '. Listado de Shipment Service Line para actualizar '+ listShipmentServiceLine;
        }
        return UPDATE_ERROR_MSG;
    }
	@TestVisible
    private static String updateInvoice(List<Invoice__c> listInvoice){
        if(!listInvoice.isEmpty()){
            for(Invoice__c invoice : listInvoice){
                invoice.Campo_Control__c = true;
            }
            update listInvoice;
            return UPDATE_SUCCESS_MSG + '. Listado de Invoice para actualizar '+ listInvoice;
        }
        return UPDATE_ERROR_MSG;
    }
	@TestVisible
    private static String updateInvoiceLine(List<Invoice_Line__c> listInvoiceLine){
        if(!listInvoiceLine.isEmpty()){
            for(Invoice_Line__c invoiceLine : listInvoiceLine){
                invoiceLine.Campo_Control__c = true;
            }
            update listInvoiceLine;
            return UPDATE_SUCCESS_MSG + '. Listado de Invoice para actualizar '+ listInvoiceLine;
        }
        return UPDATE_ERROR_MSG;
    }

}