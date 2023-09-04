public with sharing class NEU_Ground_Track_Trace_Planning {
    
    public Shipment_Program__c mysp{get;set;}
    
    public string direcciones_recogidas {get;set;}
    public List<shipment_s> list_shipment_related_load{get;set;}
    public List<shipment_s> list_shipment_related_discharge{get;set;}
    public string id_shipment_pos {get;set;}
    public decimal maximun_shipments {get;set;}
    public boolean Optimization_by_Google{get;set;}
    
    public static String[]usedFields=new String[]{
        'Id'
        ,'Name'
        ,'Total_Distance_kms__c'
        };
    public NEU_Ground_Track_Trace_Planning(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest()) {stdController.AddFields(usedFields);}
        mysp=(Shipment_Program__c)stdController.getRecord();
        
        initAll();
    }
        
    public void initAll()
    {
        direcciones_recogidas= '';
        maximun_shipments = 0;
        
        updateAddresses();
        Readlist_shipment_related();
        reorder_shipments();
    }
    private void updateAddresses()
    {
        List<Shipment_Consolidation_Data__c> query_shipment_consolidation = [select Id, Name, Shipment__c, Shipment__r.Site_of_Discharge__c, Shipment__r.Site_of_Discharge__r.Name, Shipment__r.Name,
        Shipment__r.Site_of_Load__c, Shipment__r.Route_Position_Destination__c, Shipment__r.Total_Weight_Kg__c ,Shipment__r.Route_Position__c, Shipment__r.Site_of_Load__r.Name, Shipment__r.Origin_Address_Shipment__c, Shipment__r.Delivery_Address_Shipment__c, Import_Export_Quote__c, Import_Export_Quote__r.Name  from Shipment_Consolidation_Data__c where Shipments_Program__c =: mysp.Id and Shipment__c != null order by Shipment__r.CreatedDate];
        
            
        boolean todos_con_posicion = true;
        for(Shipment_Consolidation_Data__c scd : query_shipment_consolidation)
            if(scd.Shipment__r.Route_Position_Destination__c == null || scd.Shipment__r.Route_Position__c == null)
                todos_con_posicion = false;
        if(todos_con_posicion == true)
            Optimization_by_Google = false;
        else
            Optimization_by_Google = true;
        
    }
    
    public void reorder_shipments()
    {
        //ordenar con las nuevas posiciones
        list_shipment_related_load.sort();
        integer contador_posicion = 0;
        direcciones_recogidas = ''; 
        Shipment__c shipment_before = null;
        for(shipment_s s : list_shipment_related_load)
        {
            s.position = contador_posicion;
            contador_posicion++;
            s.shipments_before = shipment_before;
            shipment_before = s.shipments;
            
            if(String.isNotEmpty(s.shipments.Origin_Address_Shipment__c))
                direcciones_recogidas += '<span style="font-weight: bold;">Origin Address : </span>'+s.shipments.Origin_Address_Shipment__c+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;"> </span>| marker_green'+s.letter+'|'+s.shipments.Id+'| origin| ' +(string.isempty(s.shipments.Origin_Address_Latitude__c) == false ? s.shipments.Origin_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Origin_Address_Longitude__c) == false ? s.shipments.Origin_Address_Longitude__c : 'none')+'|'+s.shipments.Origin_Address_Shipment__c+'|';
            else if(s.shipments.Site_of_Load__c != null)
                direcciones_recogidas += '<span style="font-weight: bold;">Origin Address : </span>'+s.shipments.Country_of_Load__r.Name+', '+s.shipments.State_of_Load__r.Name+', '+s.shipments.Site_of_Load__r.Name +'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;"> </span>| marker_green'+s.letter+'|'+s.shipments.Id+'| origin| '+(string.isempty(s.shipments.Origin_Address_Latitude__c) == false ? s.shipments.Origin_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Origin_Address_Longitude__c) == false ? s.shipments.Origin_Address_Longitude__c : 'none')+'|'+s.shipments.Country_of_Load__r.Name+', '+s.shipments.State_of_Load__r.Name+', '+s.shipments.Site_of_Load__r.Name +'|';
            
            if(string.isnotempty(s.shipments.Additional_Location__c))
                direcciones_recogidas += '<span style="font-weight: bold;">Route Through  : </span>'+s.shipments.Additional_Location__c+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;"> </span>| marker_yellow'+s.letter+'|'+s.shipments.Id+'1| origint| '+(string.isempty(s.shipments.Additional_Location_Latitude__c) == false ? s.shipments.Additional_Location_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Additional_Location_Longitude__c) == false ? s.shipments.Additional_Location_Longitude__c : 'none')+'|'+s.shipments.Additional_Location__c+'|';
        }
        list_shipment_related_discharge.sort();
        contador_posicion = 0;
            
        for(shipment_s s : list_shipment_related_discharge)
        {
            s.position = contador_posicion;
            contador_posicion++;
            s.shipments_before = shipment_before;
            shipment_before = s.shipments;
            
            if(s.shipments.Delivery_Address_Shipment__c != null)                                                                                                                                                                                                        //puede que si no encuentra falle esto
                direcciones_recogidas += '<span style="font-weight: bold;">Destination Address : </span> '+s.shipments.Delivery_Address_Shipment__c+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;"> </span>| marker'+ s.letter+'|'+s.shipments.Id+'| destination| '+(string.isempty(s.shipments.Final_Delivery_Address_Latitude__c) == false ? s.shipments.Final_Delivery_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Final_Delivery_Address_Longitude__c) == false ? s.shipments.Final_Delivery_Address_Longitude__c : 'none')+'|'+s.shipments.Delivery_Address_Shipment__c+'|';
            else if(s.shipments.Site_of_Discharge__c != null)
                direcciones_recogidas += '<span style="font-weight: bold;">Destination Address : </span>'+s.shipments.Country_of_Discharge__r.Name+' , '+s.shipments.State_of_Discharge__r.Name+' , '+s.shipments.Site_of_Discharge__r.Name+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;"> </span>| marker'+s.letter+'|'+s.shipments.Id+'| destination| '+(string.isempty(s.shipments.Final_Delivery_Address_Latitude__c) == false ? s.shipments.Final_Delivery_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Final_Delivery_Address_Longitude__c) == false ? s.shipments.Final_Delivery_Address_Longitude__c : 'none')+'|'+s.shipments.Country_of_Discharge__r.Name+' , '+s.shipments.State_of_Discharge__r.Name+' , '+s.shipments.Site_of_Discharge__r.Name+'|';
                
            if(string.isnotempty(s.shipments.Additional_Location_Destination__c) == true)
                direcciones_recogidas += '<span style="font-weight: bold;">Route Through : </span> '+s.shipments.Additional_Location_Destination__c+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;"> </span>| marker_orange'+s.letter+' |'+s.shipments.Id+'1| destinationt| '+(string.isempty(s.shipments.Additional_Location_Destination_Latitude__c) == false ? s.shipments.Additional_Location_Destination_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Additional_Location_Destination_Longitud__c) == false ? s.shipments.Additional_Location_Destination_Longitud__c : 'none')+'|'+s.shipments.Additional_Location_Destination__c+'|';
        }
    }
    
    public void reorder_load_up()
    {
        
        shipment_s shipment_anterior =null;
        if(list_shipment_related_load != null)
        {
            List<Shipment__c> shipment_update = new List<Shipment__c>();
            for(shipment_s s : list_shipment_related_load)
            {
                if(s.shipments.Id == id_shipment_pos)
                {
                    if(shipment_anterior!=null)
                    {
                        Integer pos=shipment_anterior.position;
                        shipment_anterior.position=s.position;
                        s.position = pos;

                        s.shipments.Kms_Origin__c =null;
                        shipment_anterior.shipments.Kms_Origin__c =null;
                        s.shipments.Google_Time__c =null;
                        shipment_anterior.shipments.Google_Time__c =null;

                        s.shipments.Route_Position__c = s.position;
                        shipment_anterior.shipments.Route_Position__c = shipment_anterior.position;

                        shipment_update.add(s.shipments);
                        shipment_update.add(shipment_anterior.shipments);
                    }
                    break;
                }
                shipment_anterior=s;
            }
            if(shipment_update.size()>0)
            {
                try
                {
                    update shipment_update;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex+' ('+ex.getLineNumber()+')'));}
                reorder_shipments();
            }
        }
    }
    
    public void reorder_load_down()
    {
        
        shipment_s shipment_anterior=null;
        if(list_shipment_related_load != null)
        {
            List<Shipment__c> shipment_update = new List<Shipment__c>();
            for(shipment_s s : list_shipment_related_load)
            {
                if(shipment_anterior!=null)
                {
                        Integer pos=shipment_anterior.position;
                        shipment_anterior.position=s.position;
                        s.position = pos;

                        s.shipments.Kms_Origin__c =null;
                        shipment_anterior.shipments.Kms_Origin__c =null;
                        s.shipments.Google_Time__c =null;
                        shipment_anterior.shipments.Google_Time__c =null;

                        s.shipments.Route_Position__c = s.position;
                        shipment_anterior.shipments.Route_Position__c = shipment_anterior.position;

                        shipment_update.add(s.shipments);
                        shipment_update.add(shipment_anterior.shipments);
                        break;
                }
                if(s.shipments.Id == id_shipment_pos)
                    shipment_anterior=s;
            }
            if(shipment_update.size()>0)
            {
                try
                {
                    update shipment_update;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex+' ('+ex.getLineNumber()+')'));}
                reorder_shipments();
            }
        }
    }
    
    public void reorder_discharge_up()
    {
        shipment_s shipment_anterior =null;
        if(list_shipment_related_discharge != null)
        {
            List<Shipment__c> shipment_update = new List<Shipment__c>();
            for(shipment_s s : list_shipment_related_discharge)
            {
                if(s.shipments.Id == id_shipment_pos)
                {
                    if(shipment_anterior!=null)
                    {
                        Integer pos=shipment_anterior.position;
                        shipment_anterior.position=s.position;
                        s.position = pos;

                        s.shipments.Kms_Destination__c =null;
                        shipment_anterior.shipments.Kms_Destination__c =null;
                        s.shipments.Google_Time_Delivery__c =null;
                        shipment_anterior.shipments.Google_Time_Delivery__c =null;

                        s.shipments.Route_Position_Destination__c = s.position;
                        shipment_anterior.shipments.Route_Position_Destination__c = shipment_anterior.position;

                        shipment_update.add(s.shipments);
                        shipment_update.add(shipment_anterior.shipments);
                        break;
                    }
                }
                shipment_anterior=s;
            }
            if(shipment_update.size()>0)
            {
                try
                {
                    update shipment_update;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex+' ('+ex.getLineNumber()+')'));}
                reorder_shipments();
            }
        }
    }
    
    public void reorder_discharge_down()
    {
        
        shipment_s shipment_anterior=null;
        if(list_shipment_related_discharge != null)
        {
            List<Shipment__c> shipment_update = new List<Shipment__c>();
            for(shipment_s s : list_shipment_related_discharge)
            {
                if(shipment_anterior!=null)
                {
                        Integer pos=shipment_anterior.position;
                        shipment_anterior.position=s.position;
                        s.position = pos;

                        s.shipments.Kms_Destination__c =null;
                        shipment_anterior.shipments.Kms_Destination__c =null;
                        s.shipments.Google_Time_Delivery__c =null;
                        shipment_anterior.shipments.Google_Time_Delivery__c =null;

                        s.shipments.Route_Position_Destination__c = s.position;
                        shipment_anterior.shipments.Route_Position_Destination__c = shipment_anterior.position;

                        shipment_update.add(s.shipments);
                        shipment_update.add(shipment_anterior.shipments);
                        break;
                }
                if(s.shipments.Id == id_shipment_pos)
                    shipment_anterior=s;
            }
            if(shipment_update.size()>0)
            {
                try
                {
                    update shipment_update;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex+' ('+ex.getLineNumber()+')'));}
                reorder_shipments();
            }
        }
    }
    
    public void save_coordenadas()
    {
        List<Shipment__c> query_shipment = new List<Shipment__c>();
        for(shipment_s s : list_shipment_related_load)
        {
            s.shipments.Route_Position__c = s.position;
            query_shipment.add(s.shipments);
        }
        for(shipment_s s : list_shipment_related_discharge)
            s.shipments.Route_Position_Destination__c = s.position;
        if(query_shipment.size()>0)
            try
            {
                update query_shipment;
            }
            catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+'Error: '+ex+' ('+ex.getLineNumber()+')'));system.debug('bad result '+ex);}      
        update mysp;
        reorder_shipments();
    }
    
    public class shipment_s implements Comparable
    {
        public Shipment__c shipments {get;set;}
        public Integer position {get;set;}
        public string link_icon {get;set;}
        public String letter{get;set;}
        public Shipment__c shipments_before {get;set;}
        public Customer_Quote__c ie {get;set;}

        public shipment_s(Shipment__c shipments, Customer_Quote__c ie, Integer position, string link_icon,String letter)
        {
          this.shipments = shipments;
          this.ie = ie;
          this.position = position;
          this.link_icon = link_icon;
          this.letter=letter;
        }
        
        public String Loading_Time
        {
            get
            {

                if(shipments.Equip_Placed__c != null && shipments.ETD_from_Point_of_Load__c != null )
                {
                    DateTime ETD = shipments.ETD_from_Point_of_Load__c;
                    if(ETD!=null)
                    {
                        DateTime ATA=date.valueof(shipments.Equip_Placed__c);
                        if(ATA!=null)
                        {
                            //cambios a dias horas
                            Datetime startDate = ATA;// Start date   
                            Datetime endDate = ETD;//End Date 
                            integer intDays = 0;
                            String total_dias_horas ='';
                            Long dt1Long = startDate.getTime();
                            Long dt2Long = endDate.getTime();
                            Long milliseconds = dt2Long - dt1Long;
                            Long seconds = milliseconds / 1000;
                            Long minutes = seconds / 60;
                            Long hours = minutes / 60;
                            Long days = hours / 24;
                            minutes = math.mod(integer.valueof(minutes),60);
                            hours = math.mod(integer.valueof(hours),24);
                            total_dias_horas = days+ ' days '+hours+' hours '+minutes+' minutes ';
                            return total_dias_horas;
                        }
                    }
                    
                    
                }
                return null;
            }
        }
        
        public String Unloading_Time
        {
            get
            {

                if(shipments.ETA_Point_of_Discharge__c != null && shipments.Equip_Unloaded__c != null )
                {
                    DateTime ETD = date.valueof(shipments.Equip_Unloaded__c);
                    if(ETD!=null)
                    {
                        DateTime ATA=shipments.ETA_Point_of_Discharge__c;
                        if(ATA!=null)
                        {
                            //cambios a dias horas
                            Datetime startDate = ATA;// Start date   
                            Datetime endDate = ETD;//End Date 
                            String total_dias_horas ='';
                            Long dt1Long = startDate.getTime();
                            Long dt2Long = endDate.getTime();
                            Long milliseconds = dt2Long - dt1Long;
                            Long seconds = milliseconds / 1000;
                            Long minutes = seconds / 60;
                            Long hours = minutes / 60;
                            Long days = hours / 24;
                            minutes = math.mod(integer.valueof(minutes),60);
                            hours = math.mod(integer.valueof(hours),24);
                            total_dias_horas = days+ ' days '+hours+' hours '+minutes+' minutes ';
                            return total_dias_horas;    
                        }
                    }
                }
                return null;
            }
        }
        
        public String Transit_time
        {
            get
            {
                if(position == 0)
                    return null;
                if(shipments_before != null)
                {
                    if(shipments.Equip_Placed__c != null && shipments_before.ETD_from_Point_of_Load__c != null )
                    {
                        Datetime ETD = shipments_before.ETD_from_Point_of_Load__c;
                        if(ETD!=null)
                        {
                            Datetime ATA=date.valueof(shipments.Equip_Placed__c);
                            if(ATA!=null)
                            {
                                //cambios a dias horas
                                Datetime startDate = ETD;// Start date      
                                Datetime endDate = ATA;//End Date 
                                String total_dias_horas ='';
                                Long dt1Long = startDate.getTime();
                                Long dt2Long = endDate.getTime();
                                Long milliseconds = dt2Long - dt1Long;
                                Long seconds = milliseconds / 1000;
                                Long minutes = seconds / 60;
                                Long hours = minutes / 60;
                                Long days = hours / 24;
                                minutes = math.mod(integer.valueof(minutes),60);
                                hours = math.mod(integer.valueof(hours),24);
                                total_dias_horas = days+ ' days '+hours+' hours '+minutes+' minutes ';
                                return total_dias_horas;    
                            }
                        }
                    }
                }
                return null;
            }
            
        }
        
        public String Transit_time_discharge
        {
            get
            {
                if(shipments_before != null)
                {
                    if(shipments.ETA_Point_of_Discharge__c != null && shipments_before.ETD_from_Point_of_Load__c != null &&  position == 0)
                    {
                        Datetime ETD = shipments_before.ETD_from_Point_of_Load__c;
                        if(ETD!=null)
                        {
                            Datetime ATA=date.valueof(shipments.ETA_Point_of_Discharge__c);
                            if(ATA!=null)
                            {
                                //cambios a dias horas
                                Datetime startDate = ETD;// Start date    
                                Datetime endDate = ATA;//End Date 
                                String total_dias_horas ='';
                                Long dt1Long = startDate.getTime();
                                Long dt2Long = endDate.getTime();
                                Long milliseconds = dt2Long - dt1Long;
                                Long seconds = milliseconds / 1000;
                                Long minutes = seconds / 60;
                                Long hours = minutes / 60;
                                Long days = hours / 24;
                                minutes = math.mod(integer.valueof(minutes),60);
                                hours = math.mod(integer.valueof(hours),24);
                                total_dias_horas = days+ ' days '+hours+' hours '+minutes+' minutes ';
                                return total_dias_horas;    
                            }
                        }
                    }
                    else if(shipments.ETA_Point_of_Discharge__c != null && shipments_before.Equip_Unloaded__c != null && position != 0)
                    {
                        Date ATA2 = date.valueof(shipments_before.Equip_Unloaded__c);
                        if(ATA2!=null)
                        {
                            Date ATA=date.valueof(shipments.ETA_Point_of_Discharge__c);
                            if(ATA!=null)
                            {  
                                //cambios a dias horas
                                Datetime startDate = ATA2;// Start date     
                                Datetime endDate = ATA;//End Date 
                                String total_dias_horas ='';
                                Long dt1Long = startDate.getTime();
                                Long dt2Long = endDate.getTime();
                                Long milliseconds = dt2Long - dt1Long;
                                Long seconds = milliseconds / 1000;
                                Long minutes = seconds / 60;
                                Long hours = minutes / 60;
                                Long days = hours / 24;
                                minutes = math.mod(integer.valueof(minutes),60);
                                hours = math.mod(integer.valueof(hours),24);
                                total_dias_horas = days+ ' days '+hours+' hours '+minutes+' minutes ';
                                return total_dias_horas;    
                            }
                        }
                    }
                    
                }
                return null;
            } 
        }
        
        public Integer compareTo(Object compareTo) 
        {
            shipment_s compareToEmp = (shipment_s)compareTo;
            if (position  == compareToEmp.position) return 0;
            if (position > compareToEmp.position) return 1;
            return -1; 
        }          
    }
    
    void Readlist_shipment_related()
    {
        list_shipment_related_load = new List<shipment_s>();
        list_shipment_related_discharge = new List<shipment_s>();
        if(mysp==null)
            return;
        Map<id,Customer_Quote__c> map_ie = new Map<id,Customer_Quote__c>();
        List<Shipment_Consolidation_Data__c> query_ie = [select id, Name, Shipment__c, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipments_Program__c =: mysp.Id and Import_Export_Quote__c != null];
        for(Shipment_Consolidation_Data__c scd: query_ie)
            map_ie.put(scd.Shipment__c,scd.Import_Export_Quote__r);
        List<Shipment__c> query_shipment = [select id, Name, Google_Time__c,Google_Time_Delivery__c,Total_Weight_Kg__c,Additional_Location_Destination_Latitude__c ,Additional_Location_Destination_Longitud__c ,Delivery_Address_Shipment__c, Country_of_Discharge__r.Name, State_of_Discharge__r.Name, Site_of_Load__c,Equip_Unloaded__c ,Route_Position_Destination__c, Additional_Location_Latitude__c, Additional_Location_Longitude__c, Additional_Location_Destination__c, Kms_Destination__c, Kms_Origin__c, Additional_Location__c,  Country_of_Load__r.Name, State_of_Load__r.Name, Origin_Address_Latitude__c, Origin_Address_Longitude__c, Final_Delivery_Address_Latitude__c, Final_Delivery_Address_Longitude__c,  Equip_Placed__c, ETA_Point_of_Discharge__c,  ETD_from_Point_of_Load__c, Site_of_Load__r.Name, Route_Position__c, Origin_Address__c, Origin_Address_Shipment__c, Destination_Address__c, Site_of_Discharge__c, Site_of_Discharge__r.Name  from Shipment__c where Inbound_Consolidation_Program__c =: mysp.Id order by Route_Position__c, CreatedDate];
        List<String> abecedario = new List<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M','N','O','P','Q','R','S','T','U','V','W', 'X','Y','Z' };
   
        Integer contador_abecedario = 0;
        maximun_shipments = query_shipment.size();
        for(Shipment__c s : query_shipment)
        {
            list_shipment_related_load.add(new shipment_s(s,map_ie.get(s.Id),NEU_Utils.safeInteger(s.Route_Position__c),'https://maps.google.com/mapfiles/marker_green'+abecedario[contador_abecedario]+'.png',abecedario[contador_abecedario]));
            list_shipment_related_discharge.add(new shipment_s(s,map_ie.get(s.Id),NEU_Utils.safeInteger(s.Route_Position_Destination__c),'https://maps.google.com/mapfiles/marker'+abecedario[contador_abecedario]+'.png',abecedario[contador_abecedario]));
            contador_abecedario++;
            if(contador_abecedario>=abecedario.size())
                contador_abecedario=0;
        }
    }
    public Boolean emptyAditionals{get;set;}
    public void save_changes_shipments()
    {
        List<Shipment__c> list_shipment_update = new List<Shipment__c>();
        for(shipment_s ship: list_shipment_related_load)
        {
            ship.shipments.Route_Position__c = ship.position;
            if(emptyAditionals!=null)
                if(emptyAditionals)
                    ship.shipments.Additional_Location__c=null;
            list_shipment_update.add(ship.shipments);
        }
        for(shipment_s ship: list_shipment_related_discharge)
        {
            ship.shipments.Route_Position_Destination__c = ship.position;
            if(emptyAditionals!=null)
                if(emptyAditionals)
                    ship.shipments.Additional_Location_Destination__c=null;
        }
        update list_shipment_update;
        reorder_shipments();
    }
}