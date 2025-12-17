trigger P2G_altaSap on Response__c (after insert) {
    Set<String> excludedSapErrorUserIds = new Set<String>();

    String labelValue = System.Label.excludedSapErrorUserIds;
	if(String.isNotBlank(labelValue)){
        excludedSapErrorUserIds.addAll(labelValue.split(','));
    }    
    
    for (Response__c resp : Trigger.new) {
        if (resp.Message__c != null) {
            P2G_altaSpot.processMessage(resp.Message__c);
        }
        if(!excludedSapErrorUserIds.contains(resp.CreatedById)){
            P2G_LastSAPResponseError.mainTrigger(resp);
        }
        
    }
    
    P2G_ChangeCampoControl.main(Trigger.new);
}