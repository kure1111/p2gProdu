public class P2G_AccountUsageService implements Database.Batchable<sObject>{

    @TestVisible
    private String consultaSOQL;
    
    public P2G_AccountUsageService(){
        this.consultaSOQL='SELECT Id, Name, TAX_ID__c, Record_Type_Name__c, Customer_Id__c, CreatedDate FROM Account '+
            'WHERE Record_Type_Name__c =\'Customer\' AND TAX_ID__c !=NULL AND Customer_Id__c!=NULL ' +
            'AND Owner.SalesEmployer__c!=NULL ORDER BY CreatedDate DESC';
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(consultaSOQL);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> listAccounts) {                
    	P2G_AccountRelationShipmentService accService=new P2G_AccountRelationShipmentService();
        accService.main(listAccounts);
    }
    public void finish(Database.BatchableContext BC){
        System.debug('finalizo');
    }
    
}