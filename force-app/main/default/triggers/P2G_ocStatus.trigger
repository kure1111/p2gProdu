trigger P2G_ocStatus on Response__c (after insert) {
    List<String> listMessages = new List<String>();
    for (Response__c response : Trigger.new) {
        if (Trigger.isInsert && response.Object__c == 'Shipment' && String.isNotBlank(response.Message__c)) {
            listMessages.add(response.Message__c);        
        }
    }
    if(!listMessages.isEmpty()){
        P2g_updateServiceLineOC.inOcStatus(listMessages);    
    }
}