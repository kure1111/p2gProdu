trigger NEU_Import_Export_Line_Update_Margin on Quote_Item_Line__c (before insert) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    List<Id>ids=new List<Id>();
    for(Quote_Item_Line__c l:trigger.new)
    {
        if((l.Margin_at_Destination__c==null)&&((l.Margin__c==null)||(l.Margin__c==0)) )
            ids.add(l.Import_Export_Quote__c);

    }   
    if(ids.size() >0)
    {
        Map<Id,Customer_Quote__c>ss=new Map<Id,Customer_Quote__c>([SELECT Id,Margin_at_Destination_by_Default__c FROM Customer_Quote__c WHERE Id IN:ids]);
        for(Quote_Item_Line__c l:trigger.new)
            if((l.Margin_at_Destination__c==null)&&((l.Margin__c==null)||(l.Margin__c==0)))
                l.Margin_at_Destination__c=ss.get(l.Import_Export_Quote__c).Margin_at_Destination_by_Default__c;
    }
}