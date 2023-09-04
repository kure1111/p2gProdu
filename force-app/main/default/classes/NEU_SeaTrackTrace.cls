public with sharing class NEU_SeaTrackTrace 
{
    public Shipment__c record;
    public string direccion_origen {get;set;}
    public string direccion_destino {get;set;}
    public string direcciones_recogidas {get;set;}
     
    public static List<Status_s> processstatus;
    public static List<Milestone_s> milestones;
    public Decimal totaldays {get;set;}
    public Decimal todaydays {get;set;}
    
    ApexPages.StandardController con;
     
    public NEU_SeaTrackTrace(ApexPages.StandardController stdController) 
    {
        con = stdController;
              
        try 
        { 
            record = [select Id, Name, Site_of_Load__c, Site_of_Load__r.Name, Country_of_Load__c, Country_of_Load__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name,
            Country_of_Discharge__c, Country_of_Discharge__r.Name, Vessel_Information__c, Truck_Vessel_Latitude__c, Truck_Vessel_Longitude__c, Port_of_Transshipment_1__c, 
            Port_of_Transshipment_2__c, Port_of_Transshipment_3__c, Truck_Number__c, Flight_Number__c, Origin__c, Port_Of_Loading__c, Vessel_1__c, Vessel_2__c, Vessel_3__c, 
            Vessel_4__c, Port_Of_Discharging__c, Final_Discharge__c
            from Shipment__c where Id =: con.getRecord().id];
        } 
        catch(Exception ee){record = new Shipment__c();} 
		
       	Integer TIMEOUT = 50000;

       	//DIRECCIONES
        direccion_origen = '';
        direccion_destino = '';
        direcciones_recogidas = '';

        direccion_origen = (record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+', '+(record.Country_of_Load__c != null ? record.Country_of_Load__r.Name : '');
        direccion_destino = (record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+', '+(record.Country_of_Discharge__c != null ? record.Country_of_Discharge__r.Name : '');
            
        //ORIGIN
        if(direccion_origen != '')
        {
	        direcciones_recogidas += (record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+', '+(record.Country_of_Load__c != null ? record.Country_of_Load__r.Name : '')+'|';
	        direcciones_recogidas += '/sfsites/c/resource/origin_icon|';
	        
	        //COORDINATES
			Http h = new Http(); 
			HttpRequest req = new HttpRequest();
			req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+direccion_origen.replace(' ','+')+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig'); 
			req.setMethod('GET');
			req.setTimeout(TIMEOUT);
			HttpResponse res;
			if (!Test.isRunningTest())
				res = h.send(req); 
			
			if(res != null && res.getBody() != null)
        	{
        		JSONParser parser = JSON.createParser(res.getBody());
        		
        		while(parser.nextToken() != null)
        		{
        			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) 
		        	{
		                parser.nextToken();
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LATITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0)+'|';
			            
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LONGITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0)+';';
			            
			            break;
		            }
        		}
        	}
        }

        //DESTINATION
        if(direccion_destino != '')
        {
	       	direcciones_recogidas += (record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+', '+(record.Country_of_Discharge__c != null ? record.Country_of_Discharge__r.Name : '')+'|';
	        direcciones_recogidas += '/sfsites/c/resource/destination_icon|';
	        
	        //COORDINATES
    		Http h = new Http(); 
			HttpRequest req = new HttpRequest();
			req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+direccion_destino.replace(' ','+')+'&key=AIzaSyAK8UqXuiT9IFTwkvhF-Nh1wS2JAdk6Fig'); 
			req.setMethod('GET');
			req.setTimeout(TIMEOUT);
			HttpResponse res;
			if (!Test.isRunningTest())
				res = h.send(req); 
			
			if(res != null && res.getBody() != null)
        	{
        		JSONParser parser = JSON.createParser(res.getBody());
        		
        		while(parser.nextToken() != null)
        		{
        			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) 
		        	{
		                parser.nextToken();
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LATITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0)+'|';
			            
			            parser.nextToken();
			            parser.nextToken();
			            
			            //LONGITUDE
			            direcciones_recogidas += (parser.getText() != null ? double.valueof(parser.getText()) : 0)+';';
			            
			            break;
		            }
        		}
        	}
        }

        //LAST VESSEL POSITION
        direcciones_recogidas += (record.Vessel_Information__c != null ? record.Vessel_Information__c.replace('\n','<br/>').replace('MMSI:','<b>MMSI:</b>').replace('IMO:','<b>IMO:</b>').replace('Vessel:','<b>Vessel:</b>').replace('Detection Time:','<b>Detection Time:</b>').replace('Speed:','<b>Speed:</b>').replace('Course:','<b>Course:</b>').replace('ETA:','<b>ETA:</b>').replace('Destination Port:','<b>Destination Port:</b>').replace('Flag:','<b>Flag:</b>').replace('Last Port:','<b>Last Port:</b>').replace('Last Port Time:','<b>Last Port Time:</b>')+'|' : '');
        direcciones_recogidas += '/sfsites/c/resource/vessel_icon|';
        	
        //LATITUDE
        direcciones_recogidas += (record.Truck_Vessel_Latitude__c != null ? record.Truck_Vessel_Latitude__c : 0)+'|';

        //LONGITUDE
        direcciones_recogidas += (record.Truck_Vessel_Longitude__c != null ? record.Truck_Vessel_Longitude__c : 0);
    }
    
    public Integer transportType
    {
        get
        {
            if(transportType==null)
            {
                transportType=1;
                if(record!=null)
                {
                    if(String.isNotEmpty(record.Truck_Number__c))
                        transportType=2;
                    else if(String.isNotEmpty(record.Flight_Number__c))
                        transportType=3;
                }
            }
            return transportType;
        }
        set
        {
            if(transportType!=value)
                transportType=value;
        }
    }
    
    public class Status_s
    {
        public String stringstatus {get;set;}
        public String classstatus {get;set;}
        public String pngstatus {get;set;}
        public String classpngstatus {get;set;}
        public Integer colspanstatus {get;set;}
        public String classlocation {get;set;}
        public String stringlocation {get;set;}
    }
    
    public static Integer[] milestonesType = new Integer[]{0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,0,0,0,0,0};
    public static String[] milestonesXml = new String[]{'empty_pickup_','origin_pickup_','pol_arrival_','pol_loaded_','pol_vsldeparture_','tsp1_vslarrival_','tsp1_discharge_','tsp1_loaded_','tsp1_vsldeparture_','tsp2_vslarrival_','tsp2_discharge_','tsp2_loaded_','tsp2_vsldeparture_','tsp3_vslarrival_','tsp3_discharge_','tsp3_loaded_','tsp3_vsldeparture_','pod_vslarrival_','pod_discharge_','pod_departure_','dlv_delivery_','empty_return_'};
    public static Integer[] milestonesPng = new Integer[]{1,2,3,4,5,6,7,8,9,6,7,8,9,6,7,8,9,10,11,12,13,14};
    public static String[] milestonesName = new String[]{'Container empty to shipper','Container pickup at shipper','Container arrival at first POL','Container loaded at first POL','Vessel departure from first POL','Vessel arrival at T/S port 1','Container discharge at T/S port1','Container loaded at T/S port 1','Vessel departure from T/S 1','Vessel arrival at T/S port 2','Container discharge at T/S port 2','Container loaded at T/S port 2','Vessel departure from T/S 2','Vessel arrival at T/S port 3','Container discharge at T/S port 3','Container loaded at T/S port 3','Vessel departure from T/S port 3','Vessel arrival at final POD','Container discharge at final POD','Container departure from final POD','Container delivery to consignee','Container empty return to depot'};
    public static String[] milestonesCode = new String[]{'CEP','CPS','CGI','CLL','VDL','VAT1','CDT1','CLT1','VDT1','VAT2','CDT2','CLT2','VDT2','VAT3','CDT3','CLT3','VDT3','VAD','CDD','CGO','CDC','CER'};
    public static String[] milestonesNamet = new String[]{'Container empty to shipper','Container pickup at shipper','Container arrival at first POL','Container loaded at first POL','Truck departure from first POL','Truck arrival at T/S port 1','Container discharge at T/S port1','Container loaded at T/S port 1','Truck departure from T/S 1','Truck arrival at T/S port 2','Container discharge at T/S port 2','Container loaded at T/S port 2','Truck departure from T/S 2','Truck arrival at T/S port 3','Container discharge at T/S port 3','Container loaded at T/S port 3','Truck departure from T/S port 3','Truck arrival at final POD','Container discharge at final POD','Container departure from final POD','Container delivery to consignee','Container empty return to depot'};
    public static String[] milestonesNamef = new String[]{'Container empty to shipper','Container pickup at shipper','Container arrival at first POL','Container loaded at first POL','Flight departure from first POL','Flight arrival at T/S port 1','Container discharge at T/S port1','Container loaded at T/S port 1','Flight departure from T/S 1','Flight arrival at T/S port 2','Container discharge at T/S port 2','Container loaded at T/S port 2','Flight departure from T/S 2','Flight arrival at T/S port 3','Container discharge at T/S port 3','Container loaded at T/S port 3','Flight departure from T/S port 3','Flight arrival at final POD','Container discharge at final POD','Container departure from final POD','Container delivery to consignee','Container empty return to depot'};
    public static String[] stringstatus = new String[]{'Waiting for pick-up','Land transport to POL','In POL Terminal','Waiting for departure from POL','Ocean transport on vessel','In trans-shipment','Ocean transport on vessel','In trans-shipment','Ocean transport on vessel','In trans-shipment','Ocean transport on vessel','Waiting for discharge at final POD','In POD terminal','Land transport to place of delivery','Delivered; Returning container'};
    public static String[] stringstatust = new String[]{'Waiting for pick-up','Land transport to POL','In POL Terminal','Waiting for departure from POL','Transport on truck','In trans-shipment','Transport on truck','In trans-shipment','Transport on truck','In trans-shipment','Transport on truck','Waiting for discharge at final POD','In POD terminal','Land transport to place of delivery','Delivered; Returning container'};
    public static String[] stringstatusf = new String[]{'Waiting for pick-up','Land transport to POL','In POL Terminal','Waiting for departure from POL','Transport on flight','In trans-shipment','Transport on flight','In trans-shipment','Transport on flight','In trans-shipment','Transport on flight','Waiting for discharge at final POD','In POD terminal','Land transport to place of delivery','Delivered; Returning container'};
    public static Integer[] statustype = new Integer[]{0,0,0,0,0,1,1,2,2,3,3,0,0,0,0};
    public static String[] classlocation = new String[]{'line3 nobr','line3 nobr nobl','line3 nobl','line4','line4','line4','line4','line4','line4','line4','line4','line4','line3 nobr','line3 nobr nobl','line3 nobl'};
    public static String[] stringlocation = new String[]{'Origin__c',null,'Port_Of_Loading__c',null,'Vessel_1__c','Port_of_Transshipment_1__c','Vessel_2__c','Port_of_Transshipment_2__c','Vessel_3__c','Port_of_Transshipment_3__c','Vessel_4__c',null,'Port_Of_Discharging__c',null,'Final_Discharge__c'};
    public static String[] pngstatus = new String[]{'houses.png','truck.png','crane.png','ship1.png','ship2.png','load2.png','ship2.png','load2.png','ship2.png','load2.png','ship2.png','ship1.png','crane2.png','truck.png','houses2.png'};
    public static String[] pngstatust = new String[]{'houses.png','truck.png','crane.png','truck.png','truck.png','load2.png','truck.png','load2.png','truck.png','load2.png','truck.png','truck.png','crane2.png','truck.png','houses2.png'};
    public static String[] pngstatusf = new String[]{'houses.png','truck.png','crane.png','flight1.png','flight2.png','load2.png','flight2.png','load2.png','flight2.png','load2.png','flight2.png','flight1.png','crane2.png','truck.png','houses2.png'};
    public static String[] classpngstatus = new String[]{'','',' textright',' textleft','','','','','','','',' textright',' textleft','',''};
    public static Integer[] colspanstatus = new Integer[]{1,1,1,1,1,3,1,3,1,3,1,1,1,1,1};
    
    public static Boolean hasTs1 = false;
    public static Boolean hasTs2 = false;
    public static Boolean hasTs3 = false;

    public List<Status_s> getprocessstatus()
    {
        hasTs1 = false;
        hasTs2 = false;
        hasTs3 = false;
        
        hasts1 = String.IsNotEmpty(record.Port_of_Transshipment_1__c);
        hasts2 = String.IsNotEmpty(record.Port_of_Transshipment_2__c);
        hasts3 = String.IsNotEmpty(record.Port_of_Transshipment_3__c);
        
        transportType = 1;
        if(String.isNotEmpty(record.Truck_Number__c))
            transportType = 2;
        else if(String.isNotEmpty(record.Flight_Number__c))
            transportType = 3;
            
        processstatus = new List<Status_s>();

		Integer i = 0;
        Boolean odd = true;
        String[] mystringstatus = stringstatus;
        String[] mypngstatus = pngstatus;
        if(transportType == 2)
        {
			mystringstatus = stringstatust;
            mypngstatus = pngstatust;
        }
        else if(transportType == 3)
        {
            mystringstatus = stringstatusf;
            mypngstatus = pngstatusf;
        }
		for(i = 0; i < statustype.size(); i++)
        {
            if(statustype[i] == 1 && !hasts1)
                continue;
            else if(statustype[i] == 2 && !hasts2)
                continue;
            else if(statustype[i] == 3 && !hasts3)
                continue;
                    
            Status_s s = new Status_s();
            s.stringstatus = mystringstatus[i];
            if(odd)
            {
                odd = false;
                s.classstatus = 'line1';
            }
            else
            {
                odd = true;
                s.classstatus = 'line2';
            }
            
            s.pngstatus = mypngstatus[i];
            s.classpngstatus = classpngstatus[i];
            s.colspanstatus = colspanstatus[i];
            s.classlocation = classlocation[i];
            if(String.IsNotEmpty(stringlocation[i]))
                s.stringlocation = (String)record.get(stringlocation[i]);
            processstatus.add(s);
		}                   
        return processstatus;
    }
    
    public class Milestone_s
    {
        public DateTime mydate{get;set;}
        public DateTime plannedday{get;set;}
        public Decimal dayFirst{get;set;}
        public Decimal dayLast{get;set;}
        public Decimal dayCount{
            get
            {
                Decimal res=dayLast-dayFirst;
                if(res==0)
                    return null;
                return res;
            }
            set;}
        public Decimal dayEvent{get;set;}
        public Decimal dayEventDelay{get;set;}
        public Decimal dayEventNoDelay{get;set;}
        public String dateString{get;set;}
        public String dateDescription{get;set;}
        public Integer position{get;set;}
        public Integer png{get;set;}
        public Integer tstype{get;set;}
        public Integer steps{get;set;}
        public Boolean showtoday{get;set;}
        public Decimal totaldays{get;set;}
        public Decimal todaydays{get;set;}
    }
    
    public List<Milestone_s> getmilestones()
    {
        hasTs1 = false;
        hasTs2 = false;
        hasTs3 = false;
        
        hasts1 = String.IsNotEmpty(record.Port_of_Transshipment_1__c);
        hasts2 = String.IsNotEmpty(record.Port_of_Transshipment_2__c);
        hasts3 = String.IsNotEmpty(record.Port_of_Transshipment_3__c);
        
        totaldays = 0;
        todaydays = 0;
        milestones = new List<Milestone_s>();
        Integer i = 0;
        Milestone_s lastmilestone = null;
        DateTime firstDate = null;
        DateTime lastDate = null;
        
		for(i = 0; i < milestonesType.size(); i++)
		{
			if(milestonesType[i] == 1 && !hasts1)
				continue;
			else if(milestonesType[i] == 2 && !hasts2)
				continue;
			else if(milestonesType[i] == 3 && !hasts3)
				continue;
            
            Milestone_s m = new Milestone_s();
            m.position = i;
            m.tstype = milestonesType[i];
            m.png = milestonesPng[i];
            m.steps = 0;
            m.dayFirst = 0;
            m.dayLast = 0;
            m.dayEvent = 0;
            m.dayEventDelay = 0;
            m.dayEventNoDelay = 0;
            m.showtoday = false;
            m.totaldays = 0;
        	m.todaydays = 0;
            
            if(lastmilestone != null)
            	lastmilestone.steps++;
            
			Event__c e = getEvent(milestonesXml[i],null);
			if(e != null)
            {
				if(e.Date_Time__c!=null)
				{
                    m.mydate = e.Date_Time__c;
                    m.dateString = m.mydate.Date().Format();
                    m.plannedday = e.Planned_Date_Time__c;
                    lastmilestone = m;
                    if(firstDate == null || m.mydate < firstDate)
                        firstDate = m.mydate;
                    if(lastDate == null || m.mydate > lastDate)
                        lastDate = m.mydate;
                    if(firstDate == null || m.plannedday < firstDate)
                        firstDate = m.plannedday;
                    if(lastDate == null || m.plannedday > lastDate)
                        lastDate = m.plannedday;
                    milestones.add(m);
				}
			}
			if(lastmilestone == null)
			{
                lastmilestone = new Milestone_s();
                lastmilestone.position = i;
                lastmilestone.tstype = -1;
                lastmilestone.png = 0;
                lastmilestone.steps = 0;
                lastmilestone.dayFirst = 0;
                lastmilestone.dayLast = 0;
                lastmilestone.dayEvent = 0;
                lastmilestone.dayEventDelay = 0;
                lastmilestone.dayEventNoDelay = 0;
                lastmilestone.mydate = null;
                lastmilestone.dateString = null;
                lastmilestone.plannedday = null;
                lastmilestone.showtoday = false;
                lastmilestone.totaldays = 0;
                lastmilestone.todaydays = 0;
                milestones.add(lastmilestone);
			}
		}               
        if(lastmilestone != null)
            lastmilestone.steps++;
        if(firstDate != null && lastDate != null)
        {
			totaldays = (lastDate.getTime()-firstDate.getTime())/86400000L;
            todaydays = (DateTime.now().getTime()-firstDate.getTime())/86400000L;
        }
		lastmilestone = null;
		for(Milestone_s m : milestones)
		{
			if(m.mydate == null)
				continue;
            m.dayFirst = (m.mydate.getTime()-firstDate.getTime())/86400000L;
            m.dayLast = m.dayFirst;
            if(todaydays > m.dayFirst && todaydays <= m.dayLast)
                m.showtoday = true;
            else
                m.showtoday = false;
            m.totaldays = totaldays;
            m.todaydays = todaydays;
			if(lastmilestone != null)
			{
                lastmilestone.dayLast = m.dayFirst;
                lastmilestone.dayEvent = lastmilestone.dayLast - lastmilestone.dayFirst;
				if(lastmilestone.dayEvent < 0)
				{
                    lastmilestone.dayEvent = 0;
                    lastmilestone.dayFirst = lastmilestone.dayLast;
				}
				if(m.plannedday != null)
				{
                    Decimal diff = (m.mydate.getTime()-m.plannedday.getTime())/86400000L;
                    if(diff > 0)
                    {
                        lastmilestone.dayEvent -= diff;
                        if(lastmilestone.dayEvent < 0)
                        {
                            lastmilestone.dayFirst += lastmilestone.dayEvent;
                            lastmilestone.dayEvent = 0;
                        }
                        lastmilestone.dayEventDelay = diff;
                    }
                    else if(diff < 0)
                        lastmilestone.dayEventNoDelay = -diff;
				}
                if(todaydays > lastmilestone.dayFirst && todaydays <= lastmilestone.dayLast)
                    lastmilestone.showtoday = true;
                else
                    lastmilestone.showtoday = false;
			}
			lastmilestone = m;
		}
        if(totaldays == 0)
			totaldays = 1;
        
		return milestones;
    }
    
    public Event__c getEvent(String eventName, List<Event__c> newevents)
    {
        List<Event__c> events = [SELECT Id, Name, Event__c, Shipment__c, Detected_Date_Time__c, Initial_Planned_Date_Time__c, Notified_Date_Time__c,
		Planned_Date_Time__c, Date_Time__c, Previous_Event_Code__c, Days_from_Previous_Event__c, Flight_Number__c, Departure_IATA_Code__c, Arrival_IATA_Code__c, 
		Additional_Information__c, Weight_kg__c, Number_of_Pieces__c, Shipments_Program__c
		FROM Event__c
		WHERE Shipment__c =: record.Id order by Date_Time__c asc];
        
        String eventType = null;
        String eventCode = null;
        String[] mymilestonesName = milestonesName;
        if(transportType == 2)
            mymilestonesName = milestonesNamet;
        else if(transportType == 3)
            mymilestonesName = milestonesNamef;
        
        for(Integer s = 0; s < milestonesXml.size(); s++)
        {
            if(eventName.startsWith(milestonesXml[s]))
            {
                eventType = mymilestonesName[s];
                eventCode = milestonesCode[s];
                break;
            }
		}
        
        if(eventType == null)
			return null;
        for(Event__c e : events)
        {
			if(e.Event__c == eventType)
				return e;
		}
        if(newevents == null)
			return null;
        for(Event__c e : newevents)
        {
			if(e.Event__c == eventType)
				return e;
		}
        
        Event__c ret = new Event__c();
        ret.Name = EventCode;
        ret.Shipment__c = record.Id;
        ret.Event__c = eventType;
        newevents.add(ret);
        return ret;
    }
}