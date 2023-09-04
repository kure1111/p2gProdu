trigger NEU_Update_Last_Shipment_IE on Shipment_Consolidation_Data__c (after insert) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
     Set<ID> listado_import_export = new Set<Id>();
     Map<id, id> map_shipments = new Map<Id, Id>();
     for(Shipment_Consolidation_Data__c scd : trigger.new)
     {
         if(scd.Import_Export_Quote__c != null)
         {
             listado_import_export.add(scd.Import_Export_Quote__c);
             map_shipments.put(scd.Import_Export_Quote__c, scd.Shipment__c);
         }
     }
     
     if(listado_import_export!= null && listado_import_export.size()>0)
     {
         List<Customer_Quote__c> query_update =[select Id, Name, Last_Shipment__c  from Customer_Quote__c where Id IN: listado_import_export];
         for(Customer_Quote__c cq: query_update )
         {
             if(map_shipments.containsKey(cq.Id))
                 cq.Last_Shipment__c  =map_shipments.get(cq.Id);
         }
         update query_update;
     }
 
}