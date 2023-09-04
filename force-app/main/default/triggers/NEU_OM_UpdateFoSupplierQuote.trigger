trigger NEU_OM_UpdateFoSupplierQuote on Supplier_Quote__c (after insert) {
    
    Set<Id>users=new Set<Id>();
    Set<Id>accounts=new Set<Id>();
    
    List<Supplier_Quote__c> Supplier_Quote= [select Id, Name,Supplier__c, Supplier__r.Account_Executive_User__c, Supplier__r.OwnerId, Supplier__r.Account_External_Follower_User__c, CreatedById, LastModifiedById from Supplier_Quote__c where Id IN:trigger.new];
       
    for(Supplier_Quote__c obj : Supplier_Quote)
    {
        if(obj.Supplier__r.Account_Executive_User__c!=null)
            users.add(obj.Supplier__r.Account_Executive_User__c);
        if(obj.Supplier__r.OwnerId!=null)
            users.add(obj.Supplier__r.OwnerId);
        if(obj.Supplier__r.Account_External_Follower_User__c!=null)
            users.add(obj.Supplier__r.Account_External_Follower_User__c);
        if(obj.CreatedById!=null)
            users.add(obj.CreatedById);
        if(obj.Supplier__c!=null)
            accounts.add(obj.Supplier__c);
    }
    String masterCommId=null;
    Map<String,EntitySubscription>entities=new Map<String,EntitySubscription>();
    for(User qi: [select Id,AccountId from User where Id IN :users OR AccountId IN :accounts])
    {
        for(Supplier_Quote__c obj : Supplier_Quote)
        {
            if((obj.Supplier__r.Account_Executive_User__c==qi.Id)             ||(obj.Supplier__r.OwnerId==qi.Id)             ||(obj.Supplier__r.Account_External_Follower_User__c==qi.Id)             ||(obj.CreatedById==qi.Id)              ||(obj.Supplier__c==qi.AccountId))
             {
                if(string.isEmpty(qi.AccountId))
                {
                    String key=obj.id+'_'+qi.Id;
                    if(!entities.containsKey(key))
                    {
                        EntitySubscription new_subscription = new EntitySubscription();
                        new_subscription.parentId = obj.Id;
                        new_subscription.SubscriberId = qi.Id;
                        entities.put(key,new_subscription);
                    }
                }
                if(string.isnotEmpty(qi.AccountId) || Test.isRunningTest())
                {
                    if(masterCommId==null)
                    {
                        CSH_Community__c commId=CSH_Community__c.getOrgDefaults();
                        if(commId!=null)
                            masterCommId=commId.Community_Id__c;
                        else
                            masterCommId='';
                    }
                    if(String.IsNotEmpty(masterCommId))
                    {
                        String key=obj.id+'_'+qi.Id;
                        if(!entities.containsKey(key))
                        {
                            EntitySubscription new_subscription = new EntitySubscription();
                            new_subscription.parentId = obj.Id;
                            new_subscription.SubscriberId = qi.Id;
                            NEU_CommunityUtils.setNetworkId(new_subscription,masterCommId);
                            entities.put(key,new_subscription);
                        }
                    }
                }
            }
        }
    }
    try{
        insert entities.values();
    }
    catch(Exception e){}
}