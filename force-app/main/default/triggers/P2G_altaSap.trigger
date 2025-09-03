trigger P2G_altaSap on Response__c (after insert) {
    for (Response__c resp : Trigger.new) {
        if (resp.Message__c != null) {
            P2G_altaSpot.processMessage(resp.Message__c);
        }
    }
}