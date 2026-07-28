public with sharing class P2G_Notification {
    @AuraEnabled(cacheable=true)
    public static Response__c getSapResponse(Id recordId){
    	List<Response__c> responses = [
        	SELECT Id, Name, Type__c, Message__c, Invoice__c, CreatedDate  
            FROM Response__c 
            WHERE Shipment__c = :recordId
            ORDER BY CreatedDate DESC LIMIT 1
            ];
            if(responses.isEmpty()) {
                return null;
            }
            return responses[0];
        }

    }