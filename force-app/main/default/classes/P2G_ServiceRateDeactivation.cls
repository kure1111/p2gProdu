public class P2G_ServiceRateDeactivation {
    public static void deactivateFee(List<Fee__c> fees) {
        for (Fee__c fee : fees) {
            if (fee.Route__c != null && fee.SAP_Service_Type__c != null) {
                fee.Active__c = false;     
            }
        }
        if(!fees.isEmpty()){
            update fees;
        }
	}
}