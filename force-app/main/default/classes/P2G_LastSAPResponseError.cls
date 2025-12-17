public class P2G_LastSAPResponseError {
    
    public static void mainTrigger(Response__c res){
        List<Response__c> listResponse= new List<Response__c>();
        Boolean isLastSAPResponseWithError;        
        if(res!=null){
            switch on res.Object__c {
                WHEN 'Invoice'{
                    isLastSAPResponseWithError=isLastSAPResponseWithErrorInvoice(res.Invoice__c);                
        			listResponse=getAllSAPResponseErrorOfInvoice(res.Invoice__c);
                    if(isLastSAPResponseWithError){            
                        updateSAPResponseError(listResponse);
                    }else{            
                        updateAllSAPResponseConfirm(listResponse);
                    }                    
                }when else{
                 	System.debug('No se realiza ninguna acción');   
                }
            }
        }
    }
    
    public static void main(PAK_WSMESSAGES.MESSAGE message){        
    	    
        List<Response__c> listResponse= new List<Response__c>();
        Boolean isLastSAPResponseWithError;
    
    	if(message.Invoice!=null){        
        isLastSAPResponseWithError=isLastSAPResponseWithErrorInvoice(message.Invoice);                
        listResponse=getAllSAPResponseErrorOfInvoice(message.Invoice);        
        
        if(isLastSAPResponseWithError){updateSAPResponseError(listResponse);
        }else{            
            updateAllSAPResponseConfirm(listResponse);
        }
    }
        if(message.Shipment!=null){            
            isLastSAPResponseWithError=isLastSAPResponseWithErrorShipment(message.Shipment);
            listResponse=getAllSAPResponseErrorOfShipment(message.Shipment);
            if(isLastSAPResponseWithError){
                updateSAPResponseError(listResponse);
            }else{updateAllSAPResponseConfirm(listResponse);
            }
        }        
    }
    
    public static List<Response__c> getAllSAPResponseErrorOfInvoice(String invoiceId){
        List<Response__c> responseOfInvoice;
        if(String.isNotBlank(invoiceId)){
			responseOfInvoice=[SELECT Id, Type__c,Last_SAP_Response__c, CreatedDate FROM Response__c 
                               WHERE Invoice__c =:invoiceId AND Type__c ='ERROR' ORDER BY CreatedDate];
        }        
        return responseOfInvoice;
    }
    
    
    
    public static List<Response__c> getAllSAPResponseErrorOfShipment(String shipmentId){
        List<Response__c> responseOfShipment;
        if(String.isNotBlank(shipmentId)){
            responseOfShipment=[SELECT Id, Type__c,Last_SAP_Response__c, CreatedDate FROM Response__c 
                               WHERE Shipment__c =:shipmentId AND Type__c ='ERROR' ORDER BY CreatedDate];
        }        
        return responseOfShipment;
    }
    
    public static Boolean isLastSAPResponseWithErrorInvoice(String invoiceId) {
    	if (String.isBlank(invoiceId)) {return false;}    
    	try {            
            List<Response__c> responses = [SELECT Id, Last_SAP_Response__c, Invoice__c, Type__c 
                                           FROM Response__c 
                                           WHERE Invoice__c = :invoiceId 
                                           ORDER BY CreatedDate DESC 
                                           LIMIT 1];                        
            if (responses.isEmpty()) {return false;}        
        	Response__c response = responses[0];                        
        	switch on response.Type__c {
                when 'ERROR' {  
                    return true;
                }
                when 'CONFIRM' {
                    return false;
                }
                when else {                
                    return false;
                }
        }
        
        } catch (Exception e) {   
            System.debug('Error en isLastSAPResponseWithErrorInvoice: ' + e.getMessage());
            return false;
        }
}  
    public static Boolean isLastSAPResponseWithErrorShipment(String shipmentId) {

        if (String.isBlank(shipmentId)) {
            return false;
        }
    
        try {            
            List<Response__c> responses = [SELECT Id, Last_SAP_Response__c, Shipment__c, Type__c 
                                           FROM Response__c 
                                           WHERE Shipment__c = :shipmentId
                                           ORDER BY CreatedDate DESC 
                                           LIMIT 1];                        
            if (responses.isEmpty()) {
                return false;
            }
            
            Response__c response = responses[0];
                    
            switch on response.Type__c {
                when 'ERROR' {
                    return true;
                }
                when 'CONFIRM' {
                    return false;
                }
                when else {                
                    return false;
                }
            }
            
        } catch (Exception e) {        
            System.debug('Error en isLastSAPResponseWithError: ' + e.getMessage());
            return false;
        }
    }
    
    public static void updateAllSAPResponseConfirm(List<Response__c> responses){
        if(!responses.isEmpty()){
            for(Response__c res:responses){
                res.Last_SAP_Response__c=false;
            }
            update responses;
        }
    }
    
    public static void updateSAPResponseError(List<Response__c> responses){
    	if(responses == null || responses.isEmpty()){
        return;
    }
        
        responses.sort();    
        Response__c last = responses[responses.size()-1];
        
        List<Response__c> toUpdate = new List<Response__c>();
        
    
        for(Integer i = 0; i < responses.size(); i++){
            if(i == responses.size()-1){
                
                if(!responses[i].Last_SAP_Response__c){
                    responses[i].Last_SAP_Response__c = true;
                    toUpdate.add(responses[i]);
                }
            } else {            
                if(responses[i].Last_SAP_Response__c){
                    responses[i].Last_SAP_Response__c = false;
                    toUpdate.add(responses[i]);
                }
            }
        }
        
        if(!toUpdate.isEmpty()){
        update toUpdate;
    }
}
    
}