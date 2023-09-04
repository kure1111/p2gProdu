trigger NEU_OM_UpdateFoAssociated_Document on Associated_Document__c (after insert) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;
    
    Set<Id>users=new Set<Id>();
    Set<Id>accounts=new Set<Id>();
    List<Associated_Document__c> associated_document=[select Id, Name, Account__c, Account__r.Account_Executive_User__c, Account__r.Account_External_Follower_User__c, Account__r.OwnerId, CreatedById, LastModifiedById, Claim__r.CreatedById, Import_Export_Quote__r.CreatedById, SCM_Contract__r.CreatedById,
    Shipment__r.CreatedById, Shipment_Consolidation_Data__r.CreatedById, Shipment_Disbursement__r.CreatedById, Shopping_Cart__r.CreatedById, Supplier_Quote__r.CreatedById,
    Supplier_Request_RFP__r.CreatedById, Supply_Project__r.CreatedById, Shipment_Packaging_Consolidation_Data__r.CreatedById from Associated_Document__c  where Id IN:trigger.new];
    
    for(Associated_Document__c obj : associated_document)
    {
        if(obj.Account__r.Account_Executive_User__c!=null)
            users.add(obj.Account__r.Account_Executive_User__c);
        if(obj.Account__r.OwnerId!=null)
            users.add(obj.Account__r.OwnerId);
        if(obj.Account__r.Account_External_Follower_User__c!=null)
            users.add(obj.Account__r.Account_External_Follower_User__c);
        if(obj.CreatedById!=null)
            users.add(obj.CreatedById);
        if(obj.Claim__r.CreatedById!=null)
            users.add(obj.Claim__r.CreatedById);
        if(obj.Import_Export_Quote__r.CreatedById!=null)
            users.add(obj.Import_Export_Quote__r.CreatedById);
        if(obj.SCM_Contract__r.CreatedById !=null)
            users.add(obj.SCM_Contract__r.CreatedById);
        if(obj.Shipment__r.CreatedById !=null)
            users.add(obj.Shipment__r.CreatedById);
        if(obj.Shipment_Consolidation_Data__r.CreatedById!=null)
            users.add(obj.Shipment_Consolidation_Data__r.CreatedById);
        if(obj.Shipment_Disbursement__r.CreatedById!=null)
            users.add(obj.Shipment_Disbursement__r.CreatedById);
        if(obj.Shopping_Cart__r.CreatedById!=null)
            users.add(obj.Shopping_Cart__r.CreatedById);
        if(obj.Supplier_Quote__r.CreatedById!=null)
            users.add(obj.Supplier_Quote__r.CreatedById);
        if(obj.Supplier_Request_RFP__r.CreatedById!=null)
            users.add(obj.Supplier_Request_RFP__r.CreatedById);
        if(obj.Supply_Project__r.CreatedById!=null)
            users.add(obj.Supply_Project__r.CreatedById);
        if(obj.Shipment_Packaging_Consolidation_Data__r.CreatedById!=null)
            users.add(obj.Shipment_Packaging_Consolidation_Data__r.CreatedById);
        if(obj.Account__c!=null)
            accounts.add(obj.Account__c);
    }
    String masterCommId=null;
    Map<String,EntitySubscription>entities=new Map<String,EntitySubscription>();
    for(User qi: [select Id,AccountId from User where Id IN :users OR AccountId IN :accounts])
    {
        for(Associated_Document__c obj:associated_document)
        {
            if((obj.Account__r.Account_Executive_User__c == qi.Id)             ||(obj.Account__r.Account_External_Follower_User__c == qi.Id)             ||(obj.Account__r.OwnerId == qi.Id)             ||(obj.CreatedById ==  qi.Id)              ||(obj.Claim__r.CreatedById == qi.Id)              ||(obj.Import_Export_Quote__r.CreatedById == qi.Id)              ||(obj.SCM_Contract__r.CreatedById == qi.Id)              ||(obj.Shipment__r.CreatedById == qi.Id)              ||(obj.Shipment_Consolidation_Data__r.CreatedById == qi.Id)              ||(obj.Shipment_Disbursement__r.CreatedById == qi.Id)              ||(obj.Shopping_Cart__r.CreatedById == qi.Id)              ||(obj.Supplier_Quote__r.CreatedById == qi.Id)              ||(obj.Supplier_Request_RFP__r.CreatedById == qi.Id)              ||(obj.Supply_Project__r.CreatedById == qi.Id)              ||(obj.Shipment_Packaging_Consolidation_Data__r.CreatedById == qi.Id)              ||(obj.Account__c == qi.AccountId))
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