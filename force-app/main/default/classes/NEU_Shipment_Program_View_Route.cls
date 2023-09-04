public virtual with sharing class NEU_Shipment_Program_View_Route {
    public Shipment_Program__c mysp{get;set;}
    public ID myshipmentid{get;set;}
    public string direcciones_recogidas {get;set;}
    public List<shipment_s> list_shipment_related_load{get;set;}
    public List<shipment_s> list_shipment_related_discharge{get;set;}
    public decimal maximun_shipments {get;set;}
            
    public static String[]usedFields=new String[]{
        'Id'
        ,'Name'
        ,'Total_Distance_kms__c'
        };
    public NEU_Shipment_Program_View_Route(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest()) {stdController.AddFields(usedFields);}
        mysp=(Shipment_Program__c)stdController.getRecord();
        initAll();
    }
    public NEU_Shipment_Program_View_Route()
    {
    }
    public void readSP(ID SId)
    {
        myshipmentid=SId;
        initAll();
    }
    public void initAll()
    {
        direcciones_recogidas= '';
        maximun_shipments = 0;
        
        Readlist_shipment_related();
        reorder_shipments();
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
                direcciones_recogidas += '<span style="font-weight: bold;">Origin Address : </span>'+s.shipments.Origin_Address_Shipment__c+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;">ETD: </span>'+NEU_Utils.safeString(s.shipments.ETD_from_Point_of_Load__c)+'| marker_green'+s.letter+'|'+s.shipments.Id+'| origin| ' +(string.isempty(s.shipments.Origin_Address_Latitude__c) == false ? s.shipments.Origin_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Origin_Address_Longitude__c) == false ? s.shipments.Origin_Address_Longitude__c : 'none')+'|'+s.shipments.Origin_Address_Shipment__c+'|';
            else if(s.shipments.Site_of_Load__c != null)
                direcciones_recogidas += '<span style="font-weight: bold;">Origin Address : </span>'+s.shipments.Country_of_Load__r.Name+', '+s.shipments.State_of_Load__r.Name+', '+s.shipments.Site_of_Load__r.Name +'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;">ETD: </span>'+NEU_Utils.safeString(s.shipments.ETD_from_Point_of_Load__c)+'| marker_green'+s.letter+'|'+s.shipments.Id+'| origin| '+(string.isempty(s.shipments.Origin_Address_Latitude__c) == false ? s.shipments.Origin_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Origin_Address_Longitude__c) == false ? s.shipments.Origin_Address_Longitude__c : 'none')+'|'+s.shipments.Country_of_Load__r.Name+', '+s.shipments.State_of_Load__r.Name+', '+s.shipments.Site_of_Load__r.Name +'|';
            
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
                direcciones_recogidas += '<span style="font-weight: bold;">Destination Address : </span> '+s.shipments.Delivery_Address_Shipment__c+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;">ETA: </span>'+NEU_Utils.safeString(s.shipments.ETA_Point_of_Discharge__c)+'| marker'+ s.letter+'|'+s.shipments.Id+'| destination| '+(string.isempty(s.shipments.Final_Delivery_Address_Latitude__c) == false ? s.shipments.Final_Delivery_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Final_Delivery_Address_Longitude__c) == false ? s.shipments.Final_Delivery_Address_Longitude__c : 'none')+'|'+s.shipments.Delivery_Address_Shipment__c+'|';
            else if(s.shipments.Site_of_Discharge__c != null)
                direcciones_recogidas += '<span style="font-weight: bold;">Destination Address : </span>'+s.shipments.Country_of_Discharge__r.Name+', '+s.shipments.State_of_Discharge__r.Name+', '+s.shipments.Site_of_Discharge__r.Name+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;">ETA: </span>'+NEU_Utils.safeString(s.shipments.ETA_Point_of_Discharge__c)+'| marker'+s.letter+'|'+s.shipments.Id+'| destination| '+(string.isempty(s.shipments.Final_Delivery_Address_Latitude__c) == false ? s.shipments.Final_Delivery_Address_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Final_Delivery_Address_Longitude__c) == false ? s.shipments.Final_Delivery_Address_Longitude__c : 'none')+'|'+s.shipments.Country_of_Discharge__r.Name+', '+s.shipments.State_of_Discharge__r.Name+', '+s.shipments.Site_of_Discharge__r.Name+'|';
                
            if(string.isnotempty(s.shipments.Additional_Location_Destination__c) == true)
                direcciones_recogidas += '<span style="font-weight: bold;">Route Through : </span> '+s.shipments.Additional_Location_Destination__c+'| <span style="font-weight: bold;">Shipment : '+s.shipments.Name+' </span>| <span style="font-weight: bold;"> </span>| marker_orange'+s.letter+' |'+s.shipments.Id+'1| destinationt| '+(string.isempty(s.shipments.Additional_Location_Destination_Latitude__c) == false ? s.shipments.Additional_Location_Destination_Latitude__c : 'none')+'| '+(string.isempty(s.shipments.Additional_Location_Destination_Longitud__c) == false ? s.shipments.Additional_Location_Destination_Longitud__c : 'none')+'|'+s.shipments.Additional_Location_Destination__c+'|';
        }
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
            Map<id,Customer_Quote__c> map_ie = new Map<id,Customer_Quote__c>();
            List<Shipment_Consolidation_Data__c> query_ie;
            if(mysp!=null)
                query_ie = [select id, Name, Shipment__c, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipments_Program__c =: mysp.Id and Import_Export_Quote__c != null];
            else
                query_ie = [select id, Name, Shipment__c, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipment__c =:myshipmentid and Import_Export_Quote__c != null];
            for(Shipment_Consolidation_Data__c scd: query_ie)
                map_ie.put(scd.Shipment__c,scd.Import_Export_Quote__r);
            List<Shipment__c> query_shipment;
            if(mysp!=null)
                query_shipment = [select id, Name, Google_Time__c,Google_Time_Delivery__c,Additional_Location_Destination_Latitude__c ,Additional_Location_Destination_Longitud__c ,Delivery_Address_Shipment__c, Country_of_Discharge__r.Name, State_of_Discharge__r.Name, Site_of_Load__c,Equip_Unloaded__c ,Route_Position_Destination__c, Additional_Location_Latitude__c, Additional_Location_Longitude__c, Additional_Location_Destination__c, Kms_Destination__c, Kms_Origin__c, Additional_Location__c,  Country_of_Load__r.Name, State_of_Load__r.Name, Origin_Address_Latitude__c, Origin_Address_Longitude__c, Final_Delivery_Address_Latitude__c, Final_Delivery_Address_Longitude__c,  Equip_Placed__c, ETA_Point_of_Discharge__c,  ETD_from_Point_of_Load__c, Site_of_Load__r.Name, Route_Position__c, Origin_Address__c, Origin_Address_Shipment__c, Destination_Address__c, Site_of_Discharge__c, Site_of_Discharge__r.Name  from Shipment__c where Inbound_Consolidation_Program__c =: mysp.Id order by Route_Position__c, CreatedDate];
            else
                query_shipment = [select id, Name, Google_Time__c,Google_Time_Delivery__c,Additional_Location_Destination_Latitude__c ,Additional_Location_Destination_Longitud__c ,Delivery_Address_Shipment__c, Country_of_Discharge__r.Name, State_of_Discharge__r.Name, Site_of_Load__c,Equip_Unloaded__c ,Route_Position_Destination__c, Additional_Location_Latitude__c, Additional_Location_Longitude__c, Additional_Location_Destination__c, Kms_Destination__c, Kms_Origin__c, Additional_Location__c,  Country_of_Load__r.Name, State_of_Load__r.Name, Origin_Address_Latitude__c, Origin_Address_Longitude__c, Final_Delivery_Address_Latitude__c, Final_Delivery_Address_Longitude__c,  Equip_Placed__c, ETA_Point_of_Discharge__c,  ETD_from_Point_of_Load__c, Site_of_Load__r.Name, Route_Position__c, Origin_Address__c, Origin_Address_Shipment__c, Destination_Address__c, Site_of_Discharge__c, Site_of_Discharge__r.Name  from Shipment__c where Id=:myshipmentid order by Route_Position__c, CreatedDate];
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
}