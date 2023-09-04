global class Batch_Prodly_Shipment implements Database.Batchable<sObject> {
    global DataBase.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        for ( Account a : scope)
        {
           a.Phone='123';
        }
        update scope;
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}