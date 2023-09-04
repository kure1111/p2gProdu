trigger NEU_OM_Create_Feed on Chatter_Feed_Guest_User__c (after update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    for(Chatter_Feed_Guest_User__c new_cfgu : trigger.new)
    {
        ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, new_cfgu.Record_Id__c, new_cfgu.Feed_Text__c);
    }
}