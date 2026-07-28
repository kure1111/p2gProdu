public class P2G_AccountRouteByStatus_Batch implements Database.Batchable<sObject> {

    @TestVisible
    private String consultaSOQL;
	@TestVisible
    private DateTime startDate;
    public P2G_AccountRouteByStatus_Batch(){
        Integer monthsToConsider = Integer.valueOf(System.Label.monthsToConsider);
        this.startDate = System.now().addMonths(-monthsToConsider);
     	consultaSOQL = 'SELECT Id, Account.Id, Account.Name, ' +
                      'Import_Export_Quote_Order__r.Route__c, ' +
                      'CreatedDate, ' +
                      'Import_Export_Quote_Order__r.Route__r.Name, ' +
                      'Account.Estatus_cuenta__c, Service_Type__c ' +
                      'FROM Opportunity ' +
                      'WHERE Import_Export_Quote_Order__r.Route__r.Name != null ' +
                      'AND Account.Estatus_cuenta__c IN (\'Nuevo\',\'Recurrente\') ' +
                      'AND CreatedDate >= :startDate ' +
                      'AND Service_Type__c != \'FN\' ' +
                      'ORDER BY AccountId'; 
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(consultaSOQL);
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity> listOpp) {                    	        
        P2G_AccountRouteByStatus.customerTypeGroups grupos = P2G_AccountRouteByStatus.groupAccountsByCustomerStatus(listOpp);
        if(!grupos.newCustomer.isEmpty()){
            System.debug('grupos.newCustomer '+ grupos.newCustomer);
            P2G_AccountRouteByStatus.getNewCustomerByRoute(grupos.newCustomer);
        }
        if(!grupos.recurrentCustomer.isEmpty()){
            System.debug('grupos.recurrentCustomer ' +grupos.recurrentCustomer);
 			P2G_AccountRouteByStatus.getRecurrentAccountByRoute(grupos.recurrentCustomer);
        }
    }
    public void finish(Database.BatchableContext BC){
        System.debug('finalizo');
    }
}