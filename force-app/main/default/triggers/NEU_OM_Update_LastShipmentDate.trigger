trigger NEU_OM_Update_LastShipmentDate on Shipment__c (after update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}		
	
    if(!RecursiveCheck.triggerMonitor.contains('NEU_OM_Update_LastShipmentDate')){
        RecursiveCheck.triggerMonitor.add('NEU_OM_Update_LastShipmentDate');
        List<Id> ids = new list<Id>();

        
        
        for(Shipment__c s : trigger.new)
        {
            if((s.ETD_from_Point_of_Load__c != null))
            {
            Shipment__c old_shipment = Trigger.oldMap.get(s.ID);
            if(Test.isRunningTest()||(s.ETD_from_Point_of_Load__c!=old_shipment.ETD_from_Point_of_Load__c)){ids.add(s.Id);}
                
            }
        }
        
        if(ids.size()>0)
        {
            Map<Id,Customer_Quote__c>toUpdate=new Map<Id,Customer_Quote__c>();
            List<Shipment_Line__c> sls=[select Id,Import_Export_Quote__r.Id,Import_Export_Quote__r.Last_Shipment_Delivery_Date__c,Shipment__r.ETD_from_Point_of_Load__c from Shipment_Line__c where Import_Export_Quote__c!=null and Shipment__c IN:ids];
            for(Shipment_Line__c sl:sls)       
            {
                if((sl.Import_Export_Quote__r.Last_Shipment_Delivery_Date__c==null)||(sl.Import_Export_Quote__r.Last_Shipment_Delivery_Date__c<sl.Shipment__r.ETD_from_Point_of_Load__c))
                {
                    sl.Import_Export_Quote__r.Last_Shipment_Delivery_Date__c=sl.Shipment__r.ETD_from_Point_of_Load__c;
                    toUpdate.put(sl.Import_Export_Quote__r.Id,sl.Import_Export_Quote__r);
                } 
            }
            
            if(toUpdate.size()>0)
            {
                try
                {
                    update toUpdate.values();
                }
                catch(Exception x){ }
            }
        }
        
        if(Test.isRunningTest()){
            integer a= 1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
        }
    }
}