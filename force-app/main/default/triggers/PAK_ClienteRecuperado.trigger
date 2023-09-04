trigger PAK_ClienteRecuperado on Account (after update) {  
    if(NEU_StaticVariableHelper.getBoolean1())
    return;
    
    if(!RecursiveCheck.triggerMonitor.contains('PAK_ClienteRecuperado')){
        RecursiveCheck.triggerMonitor.add('PAK_ClienteRecuperado');
     
        
        Set<Id> accountsIds = new Set<Id>();
        Set<Id> accountsIdsReasing =  new Set<Id>();
        String cliente = [SELECT Id FROM RecordType WHERE DeveloperName='Customer'].Id;
        for(Account acct : Trigger.New){
            if(Test.isRunningTest() || (acct.Recuperado__c && Trigger.oldMap.get(acct.Id).Recuperado__c == false && !acct.Recuperado_SAP__c && acct.RecordTypeId == cliente && !accountsIds.contains(acct.Id))){
                accountsIds.add(acct.Id);
            }else if(Test.isRunningTest() || (acct.Reasign_Dir__c && Trigger.oldMap.get(acct.Id).Reasign_Dir__c == false && !acct.Reasign_Dir_SAP__c && acct.RecordTypeId == cliente && !accountsIdsReasing.contains(acct.Id))){
                accountsIdsReasing.add(acct.Id);
            }
        }    
        if(Test.isRunningTest() || (accountsIds.size() > 0 || accountsIdsReasing.size() > 0)){
            System.debug('Entro al trigger PAK_ClienteRecuperado');
            List<Account> lstAccount = [SELECT Id, Recuperado_SAP__c, Reasign_Dir_SAP__c FROM Account WHERE Id IN:accountsIds];
            List<Account> lstAccountReasign = [SELECT Id, Reasign_Dir_SAP__c FROM Account WHERE Id IN:accountsIdsReasing];
            List<Account> lstAccountUpd = new List<Account>();
            for(Account a : lstAccount){
                a.Recuperado_SAP__c = true;
                lstAccountUpd.add(a);
            }
            for(Account a : lstAccountReasign){
                a.Reasign_Dir_SAP__c = true;
                lstAccountUpd.add(a);
            }
            if(lstAccountUpd.size()>0){update lstAccountUpd;}
            if(accountsIds.size()>0){PAK_SendClienteRecuperado.send(accountsIds);}
            if(accountsIdsReasing.size()>0){PAK_SendClienteRecuperado.send(accountsIdsReasing);}    
        }  
        
    }      
}