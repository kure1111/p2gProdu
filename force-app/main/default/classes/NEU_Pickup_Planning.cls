public with sharing class NEU_Pickup_Planning {
    public List<Shipment__c>lines
    {
        get
        {
            if(lines==null)
            {
                Id SRID=null;
                RecordTypeInfo info=Schema.SobjectType.Shipment__c.getRecordTypeInfosByName().get('Shipment Request');
                if(info!=null)
                    SRID=info.getRecordTypeId();
                lines=[select Id,Name,Container_Type__r.Id,Container_Type__r.Name,N_Containers__c,ETD_from_Point_of_Load__c,Freight_Mode__c,Service_Mode__c,Shipment_Status__c,ETA_Point_of_Discharge__c,Nature_Merchandise__c,Total_Units_Shipped__c,Account_for__r.Id,Account_for__r.Name,Contact__r.Id,Contact__r.Name,Origin_Address__c,Destination_Address__c,Origin_Location__Latitude__s,Origin_Location__Longitude__s,Destination_Location__Latitude__s,Destination_Location__Longitude__s from Shipment__c where RecordTypeId=:SRID order by Name desc];
            }
            return lines;
        }
        set
        {
            if(lines!=value)
                lines=value;
        }
    }
    public List<Vehicle__c>vehicles
    {
        get
        {
            if(vehicles==null)
            {
                vehicles=[select Id,Name,Registration_Number__c,Last_Address__c,Last_Location__Latitude__s,Last_Location__Longitude__s,Last_Location_Time__c from Vehicle__c order by Last_Location_Time__c desc];
            }
            return vehicles;
        }
        set
        {
            if(vehicles!=value)
                vehicles=value;
        }
    }
    public String shipmentid{get;set;}
    public Decimal latitude{get;set;}
    public Decimal longitude{get;set;}
    public void originlocation()
    {
        try{
            if(String.IsNotEmpty(shipmentid))
            {
                List<Shipment__c>ships=[select Id,Origin_Location__Latitude__s,Origin_Location__Longitude__s from Shipment__c where Id=:shipmentid];
                if(ships.size()>0)
                {
                    ships[0].Origin_Location__Latitude__s=latitude;
                    ships[0].Origin_Location__Longitude__s=longitude;
                    update ships[0];
                }
            }
        }catch(Exception e){System.debug(e.getMessage());}
    }
    public void destinationlocation()
    {
        try{
            if(String.IsNotEmpty(shipmentid))
            {
                List<Shipment__c>ships=[select Id,Destination_Location__Latitude__s,Destination_Location__Longitude__s from Shipment__c where Id=:shipmentid];
                if(ships.size()>0)
                {
                    ships[0].Destination_Location__Latitude__s=latitude;
                    ships[0].Destination_Location__Longitude__s=longitude;
                    update ships[0];
                }
            }
        }catch(Exception e){System.debug(e.getMessage());}
    }
    public String vehicleid{get;set;}
    public String address{get;set;}
    public void vehicleaddress()
    {
        try{
            if(String.IsNotEmpty(vehicleid))
            {
                List<Vehicle__c>vehicles=[select Id,Last_Address__c from Vehicle__c where Id=:vehicleid];
                if(vehicles.size()>0)
                {
                    vehicles[0].Last_Address__c=address;
                    update vehicles[0];
                }
            }
        }catch(Exception e){System.debug(e.getMessage());}
    }
}