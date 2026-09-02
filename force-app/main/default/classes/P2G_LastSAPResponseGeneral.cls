public class P2G_LastSAPResponseGeneral {
    public void main(List<Response__c> listResponses){
        for(Response__c response:listResponses){
            if(response.Object__c=='Shipment' && response.Shipment__c!=null){
				updateFieldLastSAPResponseGeneral(response);                
            }
        }        
    }
    
    static void updateFieldLastSAPResponseGeneral(Response__c response){
        try{
        	List<Response__c> getListResponse= getLastSAPResponse(response.Shipment__c);            
            if(getlistResponse.size()>0){                                        
                getListResponse[0].Last_SAP_Response_General__c=false;
                update getListResponse[0];
            }
            response.Last_SAP_Response_General__c=true;  
            
        }catch(Exception e){
            System.debug('Error: '+ e.getMessage());
        }
        
    }
    static List<Response__c> getLastSAPResponse(Id shipmentId){
        return  [SELECT Id,Last_SAP_Response_General__c, Shipment__c, CreatedDate FROM Response__c 
                 WHERE Shipment__c=:shipmentId ORDER BY CreatedDate DESC];        
    }   
}