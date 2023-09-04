trigger NEU_Shipment_Line_Update_Margin on Shipment_Line__c (before insert) {

   if(NEU_StaticVariableHelper.getBoolean1())
        return;

List<Id>ids=new List<Id>();
for(Shipment_Line__c l:trigger.new)
    ids.add(l.Shipment__c);
List<Shipment__c>ss=[SELECT Id,Margin_at_Destination_by_Default__c FROM Shipment__c WHERE Id IN:ids];
for(Shipment_Line__c l:trigger.new)
    if((l.Margin_at_Destination__c==null)&&((l.Margin_at_Origin__c==null)||(l.Margin_at_Origin__c==0)))
        for(Shipment__c s:ss)
            if(s.Id==l.Shipment__c)
                l.Margin_at_Destination__c=s.Margin_at_Destination_by_Default__c;
}