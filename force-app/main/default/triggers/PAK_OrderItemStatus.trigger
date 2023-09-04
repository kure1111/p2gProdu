trigger PAK_OrderItemStatus on Shipment_Fee_Line__c (after delete) {
    Set<Id> linesDeleted = Trigger.oldMap.keySet();
    List<OrderItem> lstOrderItems = [SELECT Id, ShipServLineId__c, ItemStatus_Shipment__c 
                                     FROM OrderItem 
                                     WHERE ShipServLineId__c IN:linesDeleted];
    for(OrderItem oi : lstOrderItems){
        oi.ItemStatus_Shipment__c = true;
    }
    if(lstOrderItems.size()>0){update lstOrderItems;}
}