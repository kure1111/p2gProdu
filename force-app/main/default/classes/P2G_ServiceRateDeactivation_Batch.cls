public class P2G_ServiceRateDeactivation_Batch implements Database.Batchable<sObject> {
    @TestVisible
    String ServiceRateQuery;
    @testVisible
    public P2G_ServiceRateDeactivation_Batch(){
        ServiceRateQuery = 'SELECT Id, Active__c, Valid_Until__c, Route__c, SAP_Service_Type__c FROM Fee__c WHERE Valid_Until__c < TODAY AND Active__c = true AND Tarifario_Compras__c =true AND Route__c != null AND SAP_Service_Type__c != null LIMIT 5';
        }
        
     public Database.QueryLocator start(Database.BatchableContext bc){
     	return Database.getQueryLocator(ServiceRateQuery);
     }
    
    public void execute (Database.BatchableContext bc, List<Fee__c> serviceRates){
        P2G_ServiceRateDeactivation.deactivateFee(serviceRates);
        Database.SaveResult[] results = Database.update(serviceRates, false);

    }
     public void finish(Database.BatchableContext bc){
        System.debug('Finalizo');
    }
}