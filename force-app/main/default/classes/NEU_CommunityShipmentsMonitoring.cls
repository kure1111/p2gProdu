public class NEU_CommunityShipmentsMonitoring 
{
    public class shipment_s
	{
        @AuraEnabled
		public Shipment__c shipment {get;set;}
        @AuraEnabled
        public string container_types {get;set;}
        
        public shipment_s(Shipment__c shipment, string container_types)
  		{
  			this.shipment = shipment;
  			this.container_types = container_types;
  		}
    }
    
	@AuraEnabled
    public static List<shipment_s> getShipments() 
    {
        List<shipment_s> shipments = new List<shipment_s>();
        
        List<Shipment__c> shipments_query = [SELECT Id, Name, Route__c, Route__r.Name, National_Operator__c, National_Operator__r.Name, Vehicle__c, Vehicle__r.Name,Date_Deactivate_Monitoring__c,
		Container_Type__c, Container_Type__r.Name, Shipment_Status_Mon__c, Equip_Placed__c, Equip_Unloaded__c, Operator_Name__c, Special_Notes__c, Account_Shipment_Reference__c,
		(select Id, Container_Type__r.Name from Shipment_Lines__r WHERE Container_Type__c != null)
       	FROM Shipment__c 
       	WHERE Shipment_Status_Mon__c != 'Finished_M' AND Shipment_Status_Mon__c != 'Failure_M' AND Shipment_Status_Mon__c != 'Cancel_M'
        AND Shipment_Status_Mon__c != 'In Warehouse_M' AND Shipment_Status_Mon__c != 'False_M' AND Shipment_Status_Mon__c != 'Operative Failure_M' AND Shipment_Status_Mon__c != null
		AND Freight_Mode__c = 'Road'
        ORDER BY Shipment_Status_Mon__c ASC];
		
		for(Shipment__c s : shipments_query)   
        {
            shipment_s new_ship = new shipment_s(s,'');
                
            for(Integer i = 0; i < s.Shipment_Lines__r.size(); i++) 
            {
                new_ship.container_types += s.Shipment_Lines__r[i].Container_Type__r.Name+', ';
			}
            
            if(new_ship.container_types != '')
            	new_ship.container_types = new_ship.container_types.substring(0, new_ship.container_types.length()-2);

            if(s.Date_Deactivate_Monitoring__c == null || s.Date_Deactivate_Monitoring__c > System.now().addDays(1) )
                shipments.add(new_ship);
        }
        
        return shipments;
    }

    @AuraEnabled
    public static List<shipment_s> getShipmentsSeaExpo()
    {
        List<shipment_s> shipments = new List<shipment_s>();

        List<Shipment__c> shipments_query = [SELECT Id, Name, Route__c, Route__r.Name, National_Operator__c, National_Operator__r.Name, Vehicle__c, Vehicle__r.Name,
                Container_Type__c, Container_Type__r.Name, Shipment_Status_Mon__c, Equip_Placed__c, Equip_Unloaded__c, Operator_Name__c, Special_Notes__c, Account_Shipment_Reference__c,
                Supplier_Account__r.Name, MBL_Number__c, Ocean_Shipment_Status__c, Sea_Booking_Number__c, Date_Deactivate_Monitoring__c,
        (select Id, Container_Type__r.Name from Shipment_Lines__r WHERE Container_Type__c != null)
        FROM Shipment__c
        WHERE Freight_Mode__c = 'Sea' and Shipment_Status__c != null
        ORDER BY Shipment_Status_Mon__c ASC];

        for(Shipment__c s : shipments_query)
        {
            shipment_s new_ship = new shipment_s(s,'');

            for(Integer i = 0; i < s.Shipment_Lines__r.size(); i++)
            {
                new_ship.container_types += s.Shipment_Lines__r[i].Container_Type__r.Name+', ';
            }

            if(new_ship.container_types != '')
                new_ship.container_types = new_ship.container_types.substring(0, new_ship.container_types.length()-2);

            if(s.Date_Deactivate_Monitoring__c == null || s.Date_Deactivate_Monitoring__c > System.now().addDays(1) )
                shipments.add(new_ship);
        }

        return shipments;
    }

    @AuraEnabled
    public static List<shipment_s> getShipmentsSeaImpo()
    {
        List<shipment_s> shipments = new List<shipment_s>();

        List<Shipment__c> shipments_query = [SELECT Id, Name, Route__c, Route__r.Name, National_Operator__c, National_Operator__r.Name, Vehicle__c, Vehicle__r.Name,
                Container_Type__c, Container_Type__r.Name, Shipment_Status_Mon__c, Equip_Placed__c, Equip_Unloaded__c, Operator_Name__c, Special_Notes__c, Account_Shipment_Reference__c,
                Supplier_Account__r.Name, MBL_Number__c, Ocean_Shipment_Status__c, Sea_Booking_Number__c, Date_Deactivate_Monitoring__c,
        (select Id, Container_Type__r.Name from Shipment_Lines__r WHERE Container_Type__c != null)
        FROM Shipment__c
        WHERE Freight_Mode__c = 'Sea' and Ocean_Shipment_Status__c != null
        ORDER BY Shipment_Status_Mon__c ASC];

        for(Shipment__c s : shipments_query)
        {
            shipment_s new_ship = new shipment_s(s,'');

            for(Integer i = 0; i < s.Shipment_Lines__r.size(); i++)
            {
                new_ship.container_types += s.Shipment_Lines__r[i].Container_Type__r.Name+', ';
            }

            if(new_ship.container_types != '')
                new_ship.container_types = new_ship.container_types.substring(0, new_ship.container_types.length()-2);

            if(s.Date_Deactivate_Monitoring__c == null || s.Date_Deactivate_Monitoring__c > System.now().addDays(1) )
                shipments.add(new_ship);
        }

        return shipments;
    }
}