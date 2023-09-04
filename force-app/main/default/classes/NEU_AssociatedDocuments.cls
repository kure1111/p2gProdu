public class NEU_AssociatedDocuments 
{
	public static Shipment__c record;
    
    @AuraEnabled
    public static Shipment__c getShipment(string recordId) 
    {
        return [SELECT Id, Name, Truck_Vessel_Latitude__c,
		Truck_Vessel_Longitude__c,Vessel_Speed__c, Vessel_Course__c,  Vessel_Activities__c,  Account_for__c,
		Account_for__r.Name, TrackOptions_Value__c, Carriers_value_OI__c, Track_Option__c,
		Carriers_OI__c, Last_Activity__c, Date__c,  ETA_ATA__c, ATAPOD__c, ETD__c, Location__c, Location_Code__c,
		Carrier_OI__c, Vessel_Name__c, Imo_Number__c, Voyage_Number__c,
		Origin__c, Origin_Code__c, MMSI__c, Port_Of_Loading__c, Port_Of_Loading_Code__c, Port_Of_Discharging__c, Port_Of_Discharging_Code__c, Final_Discharge__c,
		Vessel_Information_Vessel__c, Truck_Vessel_Flight__r.MMSI__c, 
		Truck_Vessel_Flight__r.Vessel_Latitude__c, Truck_Vessel_Flight__r.Vessel_Longitude__c,
		Truck_Vessel_Flight__r.Vessel_Speed__c, Truck_Vessel_Flight__r.Last_Update__c, Vessel_Information__c,
		Truck_Vessel_Flight__r.Vessel_Information__c, Truck_Vessel_Flight__r.Vessel_Course__c,
		Last_Update_Vessel__c, Final_Discharge_Code__c, Inbound_Consolidation_Program__c,
		External_Reference_OI__c, Port_of_Transshipment_1__c, Port_of_Transshipment_Code_1__c, Port_of_Transshipment_2__c,
		Port_of_Transshipment_Code_2__c, Port_of_Transshipment_3__c, Port_of_Transshipment_Code_3__c, Vessel_1__c, Vessel_Imo_1__c, Vessel_2__c,
		Vessel_Imo_2__c, Vessel_3__c, Vessel_Imo_3__c, Vessel_4__c, Vessel_Imo_4__c, Truck_Number__c, Country_of_Load__r.Name,
		Country_of_Discharge__r.Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, OI_Status__c,
		OI_Status_Code__c, Number__c, Freight_Mode__c , Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.IMO__c, Truck_Vessel_Flight__r.Name, MAWB_Number__c, 
		Flight_Number__c, ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c, Shipment_Status__c, Vessel_Latitude_Vessel__c, Vessel_Longitude_Vessel__c
       	FROM Shipment__c WHERE Id =: recordId limit 1];
    }
    
    @AuraEnabled
    public static List<Associated_Document__c> getDocuments(string recordId)
    {
        return [SELECT Id, Name, CreatedDate, Document_Type__c, Document_Reference__c, Document_Description__c, Document_URL__c, Type__c
       	FROM Associated_Document__c WHERE Shipment__c =: recordId AND Available_for_Community__c = true];
    }
    
    @AuraEnabled
    public static List<Associated_Document__c> createAssociatedDocuments(string recordId, string[] ids_ficheros)
    {		
        record = [select Id, Name, Account_for__c from Shipment__c where Id =: recordId limit 1];
        
        List<Associated_Document__c> new_documents = new List<Associated_Document__c>();
		
        for(string ids : ids_ficheros)
        {
            Associated_Document__c new_doc = new Associated_Document__c();
            new_doc.Shipment__c = record.Id;
            new_doc.Account__c = record.Account_for__c;
            new_doc.Available_for_Community__c = true;
            new_doc.Type__c = 'File';
            new_doc.Document_URL__c = ids.split('\\|',0)[0];
			new_doc.Name = ids.split('\\|',0)[1];   
            new_documents.add(new_doc);
        }
		
        try
        {
            insert new_documents;
            
            return [SELECT Id, Name, CreatedDate, Document_Type__c, Document_Reference__c, Document_Description__c, Document_URL__c, Type__c
       		FROM Associated_Document__c WHERE Shipment__c =: recordId AND Available_for_Community__c = true];
        }
        catch(Exception ex){return null;}
    }
    
    @AuraEnabled
    public static List<Associated_Document__c> deleteDocument(string recordId, string document_id)
    {
        try
        {
            List<Associated_Document__c> document = [select Id, Name from Associated_Document__c where Id =: document_id];
            delete document;
        }
        catch(Exception ex){}
        
        return [SELECT Id, Name, CreatedDate, Document_Type__c, Document_Reference__c, Document_Description__c, Document_URL__c, Type__c
       	FROM Associated_Document__c WHERE Shipment__c =: recordId AND Available_for_Community__c = true];
    }
}