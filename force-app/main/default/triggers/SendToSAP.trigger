trigger SendToSAP on OrderItem (after insert, after update, after delete) {
    Set<Id> orders;
    System.debug('SendToSAP Trigger');
    if(Trigger.isInsert || Trigger.isUpdate){
        orders = new Set<Id>();
        for(OrderItem l : Trigger.New){
            if(!orders.contains(l.OrderId)){
                orders.add(l.OrderId);
            }
        }
        System.debug('SendToSAP Trigger orders: ' + orders);
        if(orders.size()>0){
            SendOrderSAP.sendToSap(orders);
        }
    }
    
    if(Trigger.isDelete){
        orders = new Set<Id>();
        for(OrderItem l : Trigger.Old){
            if(!orders.contains(l.OrderId)){
                orders.add(l.OrderId);
            }
        }
        if(orders.size()>0){
            SendOrderSAP.sendToSap(orders);
        }
    }
}