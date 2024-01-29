trigger OpportunityName on Opportunity (before insert, before update) {
    System.debug('OpportunityName IN');   
   
   //Lectura de Account
    Set<Id> setAccounts = new Set<Id>();
    Map<Id, String> mapAccount = new Map<Id, String>();
    
    
    for(Opportunity op :Trigger.New){
        if(op.AccountId != null){
            setAccounts.add(op.AccountId);
        }
    }
    
    for(Account a : [SELECT Id, Name FROM Account WHERE Id IN:setAccounts]){
        mapAccount.put(a.Id, a.Name);
    }
    
    
    //Lectura de Owner
    Set<Id> setOwner = new Set<Id>();
    Map<Id, String> mapOwnerOpp = new Map<Id, String>();
    
    
      for(Opportunity op :Trigger.New){
        if(op.OwnerId != null){
            setOwner.add(op.OwnerId);
        }
    }
    
      for(User b : [SELECT Id, Name FROM User WHERE Id IN:setOwner]){
        mapOwnerOpp.put(b.Id, b.Name);
    }
    
    //Actualización del Campo    
    for(Opportunity op : Trigger.New){
        if(op.AccountId != null && op.Service_Type__c != null){
            op.Name = op.Service_Type__c + ' - ' + mapAccount.get(op.AccountId)+ ' - ' + mapOwnerOpp.get(op.OwnerId) + ' - ' + op.Opportunity_Record_Number__c;
        }
    }
}