trigger NEU_Update_IE_Route on Shipment_Consolidation_Data__c (after insert, after update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    Set<Id> listado_shipment_consolidation = new Set<Id>();
    if(trigger.isInsert == true)
    {
        for(Shipment_Consolidation_Data__c  scd:trigger.new)
        {
            if(scd.Import_Export_Quote__c != null)
            {
                listado_shipment_consolidation.add(scd.Id);
            }
        }
    }
    
    if(trigger.isUpdate == true)
    {
        for(Shipment_Consolidation_Data__c  scd:trigger.new)
        {
            Shipment_Consolidation_Data__c   oldship_cons_data = Trigger.oldMap.get(scd.ID);
            if((scd.Import_Export_Quote__c != null && scd.Import_Export_Quote__c  != oldship_cons_data.Import_Export_Quote__c))
            {
                listado_shipment_consolidation.add(scd.Id);
            }
        }
    }
    
    if(listado_shipment_consolidation != null && listado_shipment_consolidation.size()>0)
    {
        List<Shipment_Consolidation_Data__c> query_ship_conso = [select Id, Name, Import_Export_Route__c, Shipment__c, Shipment__r.Name, Shipments_Program__c, Shipments_Program__r.Name, Import_Export_Quote__c,  Import_Export_Quote__r.Name, Import_Export_Quote__r.Route__r.Name, References_hidden__c,Import_Export_Quote__r.Route__c from  Shipment_Consolidation_Data__c   where Id IN: listado_shipment_consolidation ];
        for(Shipment_Consolidation_Data__c   scd: query_ship_conso )
        {
            if(scd.Import_Export_Quote__r.Route__c != null)
                scd.Import_Export_Route__c  = scd.Import_Export_Quote__r.Route__r.Name;
                
            scd.References_hidden__c = '';
            if(scd.Import_Export_Quote__c != null)
              scd.References_hidden__c +=  scd.Import_Export_Quote__r.Name+' , ';
            if(scd.Shipment__c != null)
              scd.References_hidden__c +=  scd.Shipment__r.Name+' , ';   
            if(scd.Shipments_Program__c!= null)
              scd.References_hidden__c +=  scd.Shipments_Program__r.Name+' , ';
        }
        if(query_ship_conso  != null && query_ship_conso.size()>0)
            update query_ship_conso;
    }
      
}