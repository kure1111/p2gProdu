global class DistanceIEQ implements Database.AllowsCallouts{
    
    @future (callout=true)
    public static void googleMapsDistanceKM(String jsonString)
    {
        if(jsonString == null || string.isBlank(jsonString))
            return;
        
        List<Customer_Quote__c> quotes = (List<Customer_Quote__c>)Json.deserialize(jsonString,List<Customer_Quote__c>.class);
        ServiceGoogle services = new ServiceGoogle();
        List<Customer_Quote__c>  quoteUP = new  List<Customer_Quote__c> ();
        
        for(Customer_Quote__c cq : quotes )
        {     
            integer kms = services.googleMapsDistanceKM(CQ.Origin_Location__Latitude__s, CQ.Origin_Location__Longitude__s, CQ.Destination_Location__Latitude__s,CQ.Destination_Location__Longitude__s);          
            Customer_Quote__c qu = new Customer_Quote__c (id= cq.id, Kms__c = kms );
            quoteUP.add(qu);
            
        }
        if(quoteUP.size()>0)
        {
            NEU_StaticVariableHelper.setBoolean1(true);
            update quoteUP;
            NEU_StaticVariableHelper.setBoolean1(false);
            system.debug('terminamos ' + quoteUP);
        }
    }
    
    @future (callout=true)
    public static void googleMapsDistanceKMShipment(String jsonString)
    {
        if(jsonString == null || string.isBlank(jsonString))
            return;
        
        List<shipment__c> quotes = (List<shipment__c>)Json.deserialize(jsonString,List<shipment__c>.class);
        List<shipment__c>  quoteUP = new  List<shipment__c> ();
        ServiceGoogle services = new ServiceGoogle();
        
        for(shipment__c cq : quotes )
        {  
            
            integer kms = services.googleMapsDistanceKM(CQ.Origin_Location__Latitude__s, CQ.Origin_Location__Longitude__s, CQ.Destination_Location__Latitude__s,CQ.Destination_Location__Longitude__s);
            shipment__c qu = new shipment__c (id= cq.id, Kms__c = kms );
            quoteUP.add(qu);
        }
        
        if(quoteUP.size()>0)
        {
            NEU_StaticVariableHelper.setBoolean1(true);
            update quoteUP;
            NEU_StaticVariableHelper.setBoolean1(false);
            system.debug('terminamos ship ' + quoteUP);
        }
    }
}