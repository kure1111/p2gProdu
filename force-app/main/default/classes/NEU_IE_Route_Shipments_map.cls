public with sharing class NEU_IE_Route_Shipments_map 
{
    public Customer_Quote__c record=null;
    public String direcciones_recogidas {get;set;}
    
    public NEU_IE_Route_Shipments_map(ApexPages.StandardController stdController) 
    {
         if (!Test.isRunningTest()) 
         {
            stdController.AddFields(new String[]
            {
                'Id',
                'Name',
                'Origin_Address__c',
                'Destination_Address__c',
                'Freight_Mode__c',
                'Country_ofDischarge__c',
                'Country_ofDischarge__r.Name',
                'State_of_Discharge__c',
                'State_of_Discharge__r.Name', 
                'Site_of_Discharge__c', 
                'Site_of_Discharge__r.Name',
                'Country_ofLoad__c', 
                'Country_ofLoad__r.Name',
                'State_of_Load__c', 
                'State_of_Load__r.Name', 
                'Site_of_Load__c',
                'Site_of_Load__r.Name',
                'Delivery_Date__c', 
                'Delivery_Date__c',
                'Destination_Address__c'
            });
            
         }
         record=(Customer_Quote__c)stdController.getRecord();
         direcciones_recogidas ='';
            
         if(record.Origin_Address__c != null)
            direcciones_recogidas += record.Origin_Address__c +'';
         else
         { 
            if(record.Country_ofLoad__c != null)
                direcciones_recogidas += record.Country_ofLoad__r.Name+' ';
            if(record.State_of_Load__c != null)
                direcciones_recogidas += record.State_of_Load__r.Name+' ';
            if(record.Site_of_Load__c != null)
                direcciones_recogidas += record.Site_of_Load__r.Name;
         } 
         if(record.Delivery_Date__c != null)
            direcciones_recogidas += '_&_O_&_<b>ETD:</b>'+record.Delivery_Date__c ; 
         else
            direcciones_recogidas += '_&_O_&_<b>ETD:</b>';
        // direcciones_recogidas +='_&_'+record.Freight_Mode__c;
         direcciones_recogidas +='_&_null';
         direcciones_recogidas +='_&&_';
        
         
         List<Shipment_Consolidation_Data__c> query_shipment_consolidation_data = [select Id, Name, Shipment__c, Shipment__r.Name, Shipment__r.Country_of_Load__r.Name,
         Shipment__r.Country_of_Discharge__r.Name, Shipment__r.ETD_from_Point_of_Load__c, Shipment__r.Freight_Mode__c, Shipment__r.ETA_Point_of_Discharge__c, 
         Shipment__r.Route__c, Shipment__r.Route__r.Name, Shipment__r.Port_of_Transshipment_1__c, Shipment__r.Port_of_Transshipment_2__c, Shipment__r.Port_of_Transshipment_3__c, 
         Shipment__r.Site_of_Load__r.Name, Shipment__r.Site_of_Discharge__r.Name, Shipment__r.State_of_Load__r.Name, Shipment__r.State_of_Discharge__r.Name  
         from Shipment_Consolidation_Data__c where Import_Export_Quote__c =: record.Id order by CreatedDate asc];
         
         integer contador = 0;
         for(Shipment_Consolidation_Data__c scd: query_shipment_consolidation_data)
         {
            if(scd.Shipment__r.Country_of_Load__c != null)
                direcciones_recogidas += scd.Shipment__r.Country_of_Load__r.Name+' ';
            if(scd.Shipment__r.State_of_Load__c != null)
                direcciones_recogidas += scd.Shipment__r.State_of_Load__r.Name+' ';
            if(scd.Shipment__r.Site_of_Load__c != null)
                direcciones_recogidas += scd.Shipment__r.Site_of_Load__r.Name;
            direcciones_recogidas += '_&_POL';
            direcciones_recogidas += '_&_<b>'+scd.Shipment__r.Name+'('+(scd.Shipment__r.Route__c != null ? scd.Shipment__r.Route__r.Name :' ')+')</b><br />';
            if(scd.Shipment__r.ETD_from_Point_of_Load__c != null)
                direcciones_recogidas +='<b>Planned ETD :</b>'+scd.Shipment__r.ETD_from_Point_of_Load__c +'<br />';
            else
                direcciones_recogidas +='<b>Planned ETD :</b><br />';
            if(scd.Shipment__r.ETA_Point_of_Discharge__c != null)
                direcciones_recogidas +='<b>Planned ETA :</b>'+scd.Shipment__r.ETA_Point_of_Discharge__c +'<br />';
            else
                direcciones_recogidas +='<b>Planned ETA :</b><br />';
            direcciones_recogidas +='_&_'+scd.Shipment__r.Freight_Mode__c;
            direcciones_recogidas +='_&&_';
                
            if(string.isnotempty(scd.Shipment__r.Port_of_Transshipment_1__c) == true)
            {
                direcciones_recogidas += scd.Shipment__r.Port_of_Transshipment_1__c;
                direcciones_recogidas += '_&_ts1'; 
                direcciones_recogidas += '_&_<b>'+scd.Shipment__r.Name+'(Port of Transshipment 1 '+neu_utils.safestring(scd.Shipment__r.Port_of_Transshipment_1__c)+')</b><br />';
                if(scd.Shipment__r.ETD_from_Point_of_Load__c != null)
                    direcciones_recogidas +='<b>Planned ETD :</b>'+scd.Shipment__r.ETD_from_Point_of_Load__c +'<br />';
                else
                    direcciones_recogidas +='<b>Planned ETD :</b><br />';
                if(scd.Shipment__r.ETA_Point_of_Discharge__c != null)
                    direcciones_recogidas +='<b>Planned ETA :</b>'+scd.Shipment__r.ETA_Point_of_Discharge__c +'<br />';
                else
                    direcciones_recogidas +='<b>Planned ETA :</b><br />';
                direcciones_recogidas +='_&_'+scd.Shipment__r.Freight_Mode__c;
                direcciones_recogidas +='_&&_';
                
            }
            if(string.isnotempty(scd.Shipment__r.Port_of_Transshipment_2__c) == true)
            {
                direcciones_recogidas += scd.Shipment__r.Port_of_Transshipment_2__c;
                direcciones_recogidas += '_&_ts2';
                direcciones_recogidas += '_&_<b>'+scd.Shipment__r.Name+'(Port of Transshipment 2 '+neu_utils.safestring(scd.Shipment__r.Port_of_Transshipment_2__c)+')</b><br />';
                if(scd.Shipment__r.ETD_from_Point_of_Load__c != null)
                    direcciones_recogidas +='<b>Planned ETD :</b>'+scd.Shipment__r.ETD_from_Point_of_Load__c +'<br />';
                else
                    direcciones_recogidas +='<b>Planned ETD :</b><br />';
                if(scd.Shipment__r.ETA_Point_of_Discharge__c != null)
                    direcciones_recogidas +='<b>Planned ETA :</b>'+scd.Shipment__r.ETA_Point_of_Discharge__c +'<br />';
                else
                    direcciones_recogidas +='<b>Planned ETA :</b><br />';
                direcciones_recogidas +='_&_'+scd.Shipment__r.Freight_Mode__c;
                direcciones_recogidas +='_&&_';
            }
            if(string.isnotempty(scd.Shipment__r.Port_of_Transshipment_3__c) == true)
            {
                direcciones_recogidas += scd.Shipment__r.Port_of_Transshipment_2__c;
                direcciones_recogidas += '_&_ts3';
                direcciones_recogidas += '_&_<b>'+scd.Shipment__r.Name+'(Port of Transshipment 3 '+neu_utils.safestring(scd.Shipment__r.Port_of_Transshipment_3__c)+')</b><br />';
                if(scd.Shipment__r.ETD_from_Point_of_Load__c != null)
                    direcciones_recogidas +='<b>Planned ETD :</b>'+scd.Shipment__r.ETD_from_Point_of_Load__c +'<br />';
                else
                    direcciones_recogidas +='<b>Planned ETD :</b><br />';
                if(scd.Shipment__r.ETA_Point_of_Discharge__c != null)
                    direcciones_recogidas +='<b>Planned ETA :</b>'+scd.Shipment__r.ETA_Point_of_Discharge__c +'<br />';
                else
                    direcciones_recogidas +='<b>Planned ETA :</b><br />';
                direcciones_recogidas +='_&_'+scd.Shipment__r.Freight_Mode__c;
                direcciones_recogidas +='_&&_';
            }
            
            contador ++;
            if(scd.Shipment__r.Country_of_Discharge__c != null)
                direcciones_recogidas += scd.Shipment__r.Country_of_Discharge__r.Name+' ';
            if(scd.Shipment__r.State_of_Discharge__c != null)
                direcciones_recogidas += scd.Shipment__r.State_of_Discharge__r.Name+' ';
            if(scd.Shipment__r.Site_of_Discharge__c != null)
                direcciones_recogidas += scd.Shipment__r.Site_of_Discharge__r.Name;
            /*if(query_shipment_consolidation_data.size() != contador)
                direcciones_recogidas += '_&_POC';
            else*/
                direcciones_recogidas += '_&_POD';
            direcciones_recogidas += '_&_<b>'+scd.Shipment__r.Name+'('+(scd.Shipment__r.Route__c != null ? scd.Shipment__r.Route__r.Name :' ')+')</b><br />';
            if(scd.Shipment__r.ETD_from_Point_of_Load__c != null)
                direcciones_recogidas +='<b>Planned ETD :</b>'+scd.Shipment__r.ETD_from_Point_of_Load__c +'<br />';
            else
                direcciones_recogidas +='<b>Planned ETD :</b><br />';
            if(scd.Shipment__r.ETA_Point_of_Discharge__c != null)
                direcciones_recogidas +='<b>Planned ETA :</b>'+scd.Shipment__r.ETA_Point_of_Discharge__c +'<br />';
            else
                direcciones_recogidas +='<b>Planned ETA :</b><br />';
            direcciones_recogidas +='_&_'+scd.Shipment__r.Freight_Mode__c;
            direcciones_recogidas +='_&&_';
            
         }
         
         if(record.Destination_Address__c != null)
            direcciones_recogidas += record.Destination_Address__c+'';
         else
         {
             if(record.Country_ofDischarge__c != null)
                direcciones_recogidas += record.Country_ofDischarge__r.Name+' ';
             if(record.State_of_Discharge__c != null)
                direcciones_recogidas += record.State_of_Discharge__r.Name+' ';
             if(record.Site_of_Discharge__c != null)
                direcciones_recogidas += record.Site_of_Discharge__r.Name;  
         }
         direcciones_recogidas += '_&_D';
         if(record.Delivery_Date__c != null)
            direcciones_recogidas +='_&_<b> ETA (Final Delivery Place):</b>'+record.Delivery_Date__c +'';  
        else
            direcciones_recogidas +='_&_<b> ETA (Final Delivery Place):</b>';
         //direcciones_recogidas +='_&_'+record.Freight_Mode__c;
         direcciones_recogidas +='_&_null';
    }
}