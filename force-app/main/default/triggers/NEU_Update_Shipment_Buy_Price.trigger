trigger NEU_Update_Shipment_Buy_Price on Ship_Service_Consol__c (after insert, after update, after delete)
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id>ids_shipment_service=new Set<Id>();
     if(trigger.isInsert || trigger.isUpdate)
     {
         for(Ship_Service_Consol__c  ssc:trigger.new)
         {
             ids_shipment_service.add(ssc.Shipment_Service_Line__c);
         }
     }
     else
     {
         for(Ship_Service_Consol__c  ssc:trigger.old)
         {
             ids_shipment_service.add(ssc.Shipment_Service_Line__c);
         }
     }
     
     if(ids_shipment_service != null && ids_shipment_service.size()>0)
     {
         List<Ship_Service_Consol__c> query_ship_service_consol = [select Id, Name, Cost_Allocated__c, Shipment_Service_Line__c, 
         Shipment_Service_Line__r.Units__c, Shipment_Service_Line__r.Shipment_Buy_Price__c from Ship_Service_Consol__c where Shipment_Service_Line__c IN: ids_shipment_service order by Shipment_Service_Line__c];
         
         Map<id, decimal> new_map_ship_line = new Map<Id, decimal>();
         List<Shipment_Fee_Line__c> list_to_update = new List<Shipment_Fee_Line__c>();
         
         decimal total = 0;
         string ultima_linea = '';
         Shipment_Fee_Line__c ultimo_id;
         for(Ship_Service_Consol__c ssc : query_ship_service_consol)
         {
             total = 0;
             if(new_map_ship_line.containsKey(ssc.Shipment_Service_Line__c))
                total = new_map_ship_line.get(ssc.Shipment_Service_Line__c) + NEU_Utils.safedecimal(ssc.Cost_Allocated__c);
             else
                total = ssc.Cost_Allocated__c;
                

             new_map_ship_line.put(ssc.Shipment_Service_Line__c,total);
             
             if(ultima_linea != '' && ultima_linea !=ssc.Shipment_Service_Line__c && ultimo_id.Units__c != null)
             {
                 ultimo_id.Shipment_Buy_Price__c = NEU_Utils.safedecimal(new_map_ship_line.get(ultima_linea))/ NEU_Utils.safedecimal(ultimo_id.Units__c);
                 list_to_update.add(ultimo_id);
             }
             ultima_linea = ssc.Shipment_Service_Line__c;
             ultimo_id = ssc.Shipment_Service_Line__r;
         }
         
         if(ultima_linea != '')
         {
             ultimo_id.Shipment_Buy_Price__c = NEU_Utils.safedecimal(new_map_ship_line.get(ultima_linea))/NEU_Utils.safedecimal(ultimo_id.Units__c);
             list_to_update.add(ultimo_id);
             
             if(list_to_update != null && list_to_update.size()>0)
                 update list_to_update;
         }
     }
}