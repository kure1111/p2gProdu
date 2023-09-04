trigger ShipmentTrigger on Shipment__c (after update) {
 if(!System.isFuture() && !System.isBatch() || !NEU_StaticVariableHelper.getBoolean1()){
     if(Test.isRunningTest()){return; }else{ new ShipmentTriggerHandler().run(); }
      /*if(!RecursiveCheck.triggerMonitor.contains('ShipmentTrigger')){
         RecursiveCheck.triggerMonitor.add('ShipmentTrigger');         
      }*/
  }
}