global class NEU_AsyncOIShipment implements Queueable {
    public static String[] milestonesXml=new String[]{'empty_pickup_','origin_pickup_','pol_arrival_','pol_loaded_','pol_vsldeparture_','tsp1_vslarrival_','tsp1_discharge_','tsp1_loaded_','tsp1_vsldeparture_','tsp2_vslarrival_','tsp2_discharge_','tsp2_loaded_','tsp2_vsldeparture_','tsp3_vslarrival_','tsp3_discharge_','tsp3_loaded_','tsp3_vsldeparture_','pod_vslarrival_','pod_discharge_','pod_departure_','dlv_delivery_','empty_return_'};
    public static String[] milestonesName=new String[]{'Container empty to shipper','Container pickup at shipper','Container arrival at first POL','Container loaded at first POL','Vessel departure from first POL','Vessel arrival at T/S port 1','Container discharge at T/S port1','Container loaded at T/S port 1','Vessel departure from T/S 1','Vessel arrival at T/S port 2','Container discharge at T/S port 2','Container loaded at T/S port 2','Vessel departure from T/S 2','Vessel arrival at T/S port 3','Container discharge at T/S port 3','Container loaded at T/S port 3','Vessel departure from T/S port 3','Vessel arrival at final POD','Container discharge at final POD','Container departure from final POD','Container delivery to consignee','Container empty return to depot'};
    public static String[] milestonesCode=new String[]{'CEP','CPS','CGI','CLL','VDL','VAT1','CDT1','CLT1','VDT1','VAT2','CDT2','CLT2','VDT2','VAT3','CDT3','CLT3','VDT3','VAD','CDD','CGO','CDC','CER'};
	
    public void execute(QueueableContext context) {
        NEU_AsyncOIShipment.update_oi_future(shipments);
    }
    Set<String>shipments;
	public NEU_AsyncOIShipment(Set<String>shipments)
	{
		this.shipments=shipments;
	}
@future(callout=true)
 public static void update_oi_future(Set<String>shipments)
 {
 	NEU_AsyncOIShipment.update_oi(shipments);
 }
 public static void update_oi(String shipment)
 {
	Set<String> shipments=new Set<String>();
	shipments.add(shipment);
	NEU_AsyncOIShipment.update_oi(shipments);
 }
 public static void update_oi(Set<String>shipments)
 {
 	if(shipments.size()==0)
 		return;
 	List<Shipment__c> shipmentUpdate=new List<Shipment__c>();
 	List<Shipment_Program__c> shipmentUpdateP=new List<Shipment_Program__c>();
	Map<String,List<Shipment__c>> shipmentMap=new Map<String,List<Shipment__c>>();
	for(Shipment__c s:[select Id,OI_Status_Code__c,OI_Status__c,ETD__c,ETA_ATA__c,ATAPOD__c,Origin__c,Origin_Code__c,Final_Discharge__c,Final_Discharge_Code__c,Port_Of_Loading__c,Port_Of_Loading_Code__c
		,Port_Of_Discharging__c,Port_Of_Discharging_Code__c,Vessel_Name__c,IMO_Number__c,Port_of_Transshipment_1__c,Port_of_Transshipment_Code_1__c,Port_of_Transshipment_2__c
		,Port_of_Transshipment_Code_2__c,Port_of_Transshipment_3__c,Port_of_Transshipment_Code_3__c,Vessel_1__c,Vessel_Imo_1__c,Vessel_2__c,Vessel_Imo_2__c,Vessel_3__c,Vessel_Imo_3__c
		,Vessel_4__c,Vessel_Imo_4__c,Truck_Vessel_Latitude__c,Truck_Vessel_Longitude__c,Vessel_Course__c,Vessel_Information__c,External_Reference_OI__c
		from Shipment__c where External_Reference_OI__c=:shipments])
 		if(String.IsNotEmpty(s.External_Reference_OI__c))
 		{
 			List<Shipment__c>slist=shipmentMap.get(s.External_Reference_OI__c);
 			if(slist==null)
 			{
 				slist=new List<Shipment__c>();
 				shipmentMap.put(s.External_Reference_OI__c,slist);
 			}
 			slist.add(s);
 		}
	Map<String,List<Shipment_Program__c>> shipmentMapP=new Map<String,List<Shipment_Program__c>>();
	for(Shipment_Program__c s:[select Id,OI_Status_Code__c,OI_Status__c,ETD__c,ETA_ATA__c,ATAPOD__c,Origin__c,Origin_Code__c,Final_Discharge__c,Final_Discharge_Code__c,Port_Of_Loading__c,Port_Of_Loading_Code__c
		,Port_Of_Discharging__c,Port_Of_Discharging_Code__c,Vessel_Name__c,IMO_Number__c,Port_of_Transshipment_1__c,Port_of_Transshipment_Code_1__c,Port_of_Transshipment_2__c
		,Port_of_Transshipment_Code_2__c,Port_of_Transshipment_3__c,Port_of_Transshipment_Code_3__c,Vessel_1__c,Vessel_Imo_1__c,Vessel_2__c,Vessel_Imo_2__c,Vessel_3__c,Vessel_Imo_3__c
		,Vessel_4__c,Vessel_Imo_4__c,Truck_Vessel_Latitude__c,Truck_Vessel_Longitude__c,Vessel_Course__c,Vessel_Information__c,External_Reference_OI__c
		from Shipment_Program__c where External_Reference_OI__c=:shipments])
 		if(String.IsNotEmpty(s.External_Reference_OI__c))
 		{
 			List<Shipment_Program__c>slist=shipmentMapP.get(s.External_Reference_OI__c);
 			if(slist==null)
 			{
 				slist=new List<Shipment_Program__c>();
 				shipmentMapP.put(s.External_Reference_OI__c,slist);
 			}
 			slist.add(s);
 		}
	List<Event__c> eventList=new List<Event__c>();
    for(String ship:shipments)
    {
    	Boolean haveShipments=false;
    	List<Shipment__c>myShipmentList=shipmentMap.get(ship);
    	if(myShipmentList!=null)
	    	if(myShipmentList.size()>0)
	    		haveShipments=true;
    	List<Shipment_Program__c>myShipmentListP=shipmentMapP.get(ship);
    	if(myShipmentListP!=null)
	    	if(myShipmentListP.size()>0)
	    		haveShipments=true;
    	if(haveShipments)
    	{
	    	if(Limits.getCallouts()<Limits.getLimitCallouts())
	    	{
	    		shipments.remove(ship);
	    		JSONParser parser=queryShipment(ship);
	    		if(parser!=null)
	    		{
	    			processShipment(parser,myShipmentList,myShipmentListP,eventList);
	    			if(myShipmentList!=null)
		    			shipmentUpdate.addAll(myShipmentList);
	    			if(myShipmentListP!=null)
		    			shipmentUpdateP.addAll(myShipmentListP);
	    		}
	    	}
	    	else
	    	{
	    		if(shipments.size()>0)
		    		if(!Test.isRunningTest())
						System.enqueueJob(new NEU_AsyncOIShipment(shipments));
	    		break;
	    	}
    	}
    }
    if((shipmentUpdate.size()>0)||(shipmentUpdateP.size()>0))
    {
	    if(shipmentUpdate.size()>0)
	    	update shipmentUpdate;
	    if(shipmentUpdateP.size()>0)
	    	update shipmentUpdateP;
    	delete [select Id from Event__c where Shipment__c IN:shipmentUpdate or Shipments_Program__c IN:shipmentUpdateP];
    	if(eventList.size()>0)
    	{
    		insert eventList;
    		Map<Id,Map<String,Event__c>>mapEvents=new Map<Id,Map<String,Event__c>>();
    		for(Event__c e:eventList)
    		{
    			ID myID=e.Shipment__c;
    			if(myID==null)
    				 myID=e.Shipments_Program__c;
    			Map<String,Event__c> events=mapEvents.get(myID);
    			if(events==null)
    			{
    				events=new Map<String,Event__c>();
    				mapEvents.put(myID,events);
    			}
   				events.put(e.Name,e);
    		}
    		List<Event__c>toUpdate=new List<Event__c>();
    		for(Map<String,Event__c> events:mapEvents.values())
    		{
    			ID lastEvent=null;
    			for(String code:milestonesCode)
    			{
    				Event__c e=events.get(code);
    				if(e!=null)
    				{
    					if(lastEvent!=null)
    					{
    						e.Previous_Event_Code__c=lastEvent;
    						toUpdate.add(e);
    					}
    					lastEvent=e.Id;
    				}
    			}
    		}
    		if(toUpdate.size()>0)
    			update toUpdate;
    	}
	}
 }
 public static void processShipment(JSONParser parser,List<Shipment__c> shipmentList,List<Shipment_Program__c> shipmentListP,List<Event__c>eventList)
 {
	String Origin=null;
	String Origin_Code=null;
	String Final_Discharge=null;
	String Final_Discharge_Code=null;
	String Port_Of_Loading=null;
	String Port_Of_Loading_Code=null;
	String Port_Of_Discharging=null;
	String Port_Of_Discharging_Code=null;
	DateTime ETD=null;
	DateTime ETA=null;
	DateTime ATAPOD=null;
	String Bl_no=null;
	String Container_no=null;
	String Booking_no=null;
	String Container_type=null;
	String SCAC_Carrier_Code=null;
	String Weight=null;
	String Operator=null;
	String Status=null;
	String StatusCode=null;
	String Vessel_Name=null;
	String IMO_Number=null;
	String Port_of_Transshipment_1=null;
	String Port_of_Transshipment_Code_1=null;
	String Port_of_Transshipment_2=null;
	String Port_of_Transshipment_Code_2=null;
	String Port_of_Transshipment_3=null;
	String Port_of_Transshipment_Code_3=null;
	String Vessel_1=null;
	String Vessel_Imo_1=null;
	String Vessel_2=null;
	String Vessel_Imo_2=null;
	String Vessel_3=null;
	String Vessel_Imo_3=null;
	String Vessel_4=null;
	String Vessel_Imo_4=null;
	String Vessel_Information='';
	Decimal Truck_Vessel_Latitude=null;
	Decimal Truck_Vessel_Longitude=null;
	Integer Vessel_Course=null;
	String subscription_id=null;
	String shipment_id=null;
	List<Event__c> newevents=new List<Event__c>();
	Integer objectsNumber=0;
	while(parser.nextToken()!=null)
	{
    	if(parser.getCurrentToken()==JSONToken.START_OBJECT)
    		objectsNumber++;
    	else if(parser.getCurrentToken()==JSONToken.END_OBJECT)
    	{
    		if(--objectsNumber<0)
    			break;
    	}
    	else if(parser.getCurrentToken()==JSONToken.FIELD_NAME)
    	{
    		String currentText=parser.getText();
    		if(currentText=='pol_vsldeparture_planned_initial')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
			    	if(ETD==null)
						ETD=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='pol_vsldeparture_planned_last')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
			    	if(ETD==null)
						ETD=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='pol_vsldeparture_actual')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
			    	if(ETD==null)
						ETD=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='pol_vsldeparture_detected')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
					ETD=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='pod_vslarrival_planned_initial')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
		    		if(ETA==null)
						ETA=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='pod_vslarrival_planned_last')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
					ETA=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='pod_vslarrival_actual')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
		    		ATAPOD=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='pod_vslarrival_detected')
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
		    	{
		    		if(ATAPOD==null)
						ATAPOD=eventDateTime;
					setEvent(currentText,eventDateTime,newevents);
		    	}
			}
    		else if(currentText=='origin_loc')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Origin=parser.getText();
			    		else if(currentText=='locode')
			    			Origin_Code=parser.getText();
			    	}
			}
    		else if(currentText=='dlv_loc')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Final_Discharge=parser.getText();
			    		else if(currentText=='locode')
			    			Final_Discharge_Code=parser.getText();
			    	}
			}
    		else if(currentText=='pol_loc')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Port_Of_Loading=parser.getText();
			    		else if(currentText=='locode')
			    			Port_Of_Loading_Code=parser.getText();
			    	}
			}
    		else if(currentText=='pod_loc')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Port_Of_Discharging=parser.getText();
			    		else if(currentText=='locode')
			    			Port_Of_Discharging_Code=parser.getText();
			    	}
			}
    		else if(currentText=='shipmentsubscription_id')
			{
	    		parser.nextToken();
	    		subscription_id=parser.getText();
			}
    		else if(currentText=='id')
			{
	    		parser.nextToken();
	    		shipment_id='sh'+parser.getText();
			}
    		else if(currentText=='bl_number')
			{
	    		parser.nextToken();
	    		Bl_no=parser.getText();
			}
    		else if(currentText=='container_number')
			{
	    		parser.nextToken();
	    		Container_no=parser.getText();
			}
    		else if(currentText=='booking_number')
			{
	    		parser.nextToken();
	    		Booking_no=parser.getText();
			}
    		else if(currentText=='container_type_str')
			{
	    		parser.nextToken();
	    		Container_type=parser.getText();
			}
    		else if(currentText=='carrier_scac')
			{
	    		parser.nextToken();
	    		SCAC_Carrier_Code=parser.getText();
			}
    		else if(currentText=='weight')
			{
	    		parser.nextToken();
	    		Weight=parser.getText();
			}
    		else if(currentText=='carrier_name')
			{
	    		parser.nextToken();
	    		Operator=parser.getText();
			}
    		else if(currentText=='status')
			{
	    		parser.nextToken();
	    		StatusCode=parser.getText();
			}
    		else if(currentText=='status_verbose')
			{
	    		parser.nextToken();
	    		Status=parser.getText();
			}
    		else if(currentText=='current_vessel')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    		{
			    			Vessel_Name=parser.getText();
                            Vessel_Information+='Vessel: '+Vessel_Name+'\r\n';
			    		}
			    		else if(currentText=='imo')
			    		{
			    			IMO_Number=parser.getText();
			    			Vessel_Information+='IMO: '+IMO_Number+'\r\n';
			    		}
			    	}
			}
    		else if(currentText=='current_vessel_position')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='latitude')
			    			Truck_Vessel_Latitude=parser.getDecimalValue();
			    		else if(currentText=='longitude')
			    			Truck_Vessel_Longitude=parser.getDecimalValue();
			    		else if(currentText=='heading')
			    			Vessel_Course=parser.getIntegerValue();
			    		else if(currentText=='timestamp')
			    		{
			    			DateTime vesselDateTime=getDateTimeValue(parser);
			    			if(vesselDateTime!=null)
	                            Vessel_Information+='Detection Time: '+vesselDateTime.format()+'\r\n';
			    		}
			    	}
			}
    		else if(currentText=='current_vessel_nextport')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Vessel_Information+='Detination: '+parser.getText()+'\r\n';
			    		else if(currentText=='locode')
                            Vessel_Information+='Detination code: '+parser.getText()+'\r\n';
			    		else if(currentText=='eta')
			    		{
			    			DateTime eventDateTime=getDateTimeValue(parser);
			    			if(eventDateTime!=null)
	                            Vessel_Information+='ETA: '+eventDateTime.format()+'\r\n';
			    		}
			    	}
			}
    		else if(currentText=='tsp1_loc')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Port_of_Transshipment_1=parser.getText();
			    		else if(currentText=='locode')
			    			Port_of_Transshipment_Code_1=parser.getText();
			    	}
			}
    		else if(currentText=='tsp2_loc')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Port_of_Transshipment_2=parser.getText();
			    		else if(currentText=='locode')
			    			Port_of_Transshipment_Code_2=parser.getText();
			    	}
			}
    		else if(currentText=='tsp3_loc')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Port_of_Transshipment_3=parser.getText();
			    		else if(currentText=='locode')
			    			Port_of_Transshipment_Code_3=parser.getText();
			    	}
			}
    		else if(currentText=='leg1_vessel')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Vessel_1=parser.getText();
			    		else if(currentText=='imo')
			    			Vessel_Imo_1=parser.getText();
			    	}
			}
    		else if(currentText=='leg2_vessel')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Vessel_2=parser.getText();
			    		else if(currentText=='imo')
			    			Vessel_Imo_2=parser.getText();
			    	}
			}
    		else if(currentText=='leg3_vessel')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Vessel_3=parser.getText();
			    		else if(currentText=='imo')
			    			Vessel_Imo_3=parser.getText();
			    	}
			}
    		else if(currentText=='leg4_vessel')
			{
		    	if(parser.nextToken()==JSONToken.START_OBJECT)
			    	while(parser.nextToken()==JSONToken.FIELD_NAME)
			    	{
			    		currentText=parser.getText();
			    		parser.nextToken();
			    		if(currentText=='name')
			    			Vessel_4=parser.getText();
			    		else if(currentText=='imo')
			    			Vessel_Imo_4=parser.getText();
			    	}
			}
			else
			{
		    	parser.nextToken();
		    	DateTime eventDateTime=getDateTimeValue(parser);
		    	if(eventDateTime!=null)
					setEvent(currentText,eventDateTime,newevents);
			}
    	}
	}
	if(shipmentList!=null)
		for(Shipment__c s:shipmentList)
		{
	    	s.ETD__c=NEU_Utils.safeString(ETD);
			s.ETA_ATA__c=NEU_Utils.safeString(ETA);
			s.ATAPOD__c=NEU_Utils.safeString(ATAPOD);
			s.Origin__c=Origin;
			s.Origin_Code__c=Origin_Code;
			s.Final_Discharge__c=Final_Discharge;
			s.Final_Discharge_Code__c=Final_Discharge_Code;
			s.Port_Of_Loading__c=Port_Of_Loading;
			s.Port_Of_Loading_Code__c=Port_Of_Loading_Code;
			s.Port_Of_Discharging__c=Port_Of_Discharging;
			s.Port_Of_Discharging_Code__c=Port_Of_Discharging_Code;
			s.OI_Status__c=Status;
			if(StatusCode==null)
				s.OI_Status_Code__c=null;
			else
				s.OI_Status_Code__c=StatusCode.left(2);
			s.Vessel_Name__c=Vessel_Name;
			s.IMO_Number__c=IMO_Number;
			s.Port_of_Transshipment_1__c=Port_of_Transshipment_1;
			s.Port_of_Transshipment_Code_1__c=Port_of_Transshipment_Code_1;
			s.Port_of_Transshipment_2__c=Port_of_Transshipment_2;
			s.Port_of_Transshipment_Code_2__c=Port_of_Transshipment_Code_2;
			s.Port_of_Transshipment_3__c=Port_of_Transshipment_3;
			s.Port_of_Transshipment_Code_3__c=Port_of_Transshipment_Code_3;
			s.Vessel_1__c=Vessel_1;
			s.Vessel_Imo_1__c=Vessel_Imo_1;
			s.Vessel_2__c=Vessel_2;
			s.Vessel_Imo_2__c=Vessel_Imo_2;
			s.Vessel_3__c=Vessel_3;
			s.Vessel_Imo_3__c=Vessel_Imo_3;
			s.Vessel_4__c=Vessel_4;
			s.Vessel_Imo_4__c=Vessel_Imo_4;
			s.Truck_Vessel_Latitude__c=Truck_Vessel_Latitude;
			s.Truck_Vessel_Longitude__c=Truck_Vessel_Longitude;
			s.Vessel_Course__c=Vessel_Course;
		 	s.Vessel_Information__c=Vessel_Information;
		 	s.External_Reference_OI__c=shipment_id;
		 	for(Event__c e:newevents)
		 	{
		 		Event__c newe=e.clone(false,true);
				newe.Shipment__c=s.Id;
		 		eventList.add(newe);
		 	}
		}
	if(shipmentListP!=null)
		for(Shipment_Program__c s:shipmentListP)
		{
	    	s.ETD__c=NEU_Utils.safeString(ETD);
			s.ETA_ATA__c=NEU_Utils.safeString(ETA);
			s.ATAPOD__c=NEU_Utils.safeString(ATAPOD);
			s.Origin__c=Origin;
			s.Origin_Code__c=Origin_Code;
			s.Final_Discharge__c=Final_Discharge;
			s.Final_Discharge_Code__c=Final_Discharge_Code;
			s.Port_Of_Loading__c=Port_Of_Loading;
			s.Port_Of_Loading_Code__c=Port_Of_Loading_Code;
			s.Port_Of_Discharging__c=Port_Of_Discharging;
			s.Port_Of_Discharging_Code__c=Port_Of_Discharging_Code;
			s.OI_Status__c=Status;
			if(StatusCode==null)
				s.OI_Status_Code__c=null;
			else
				s.OI_Status_Code__c=StatusCode.left(2);
			s.Vessel_Name__c=Vessel_Name;
			s.IMO_Number__c=IMO_Number;
			s.Port_of_Transshipment_1__c=Port_of_Transshipment_1;
			s.Port_of_Transshipment_Code_1__c=Port_of_Transshipment_Code_1;
			s.Port_of_Transshipment_2__c=Port_of_Transshipment_2;
			s.Port_of_Transshipment_Code_2__c=Port_of_Transshipment_Code_2;
			s.Port_of_Transshipment_3__c=Port_of_Transshipment_3;
			s.Port_of_Transshipment_Code_3__c=Port_of_Transshipment_Code_3;
			s.Vessel_1__c=Vessel_1;
			s.Vessel_Imo_1__c=Vessel_Imo_1;
			s.Vessel_2__c=Vessel_2;
			s.Vessel_Imo_2__c=Vessel_Imo_2;
			s.Vessel_3__c=Vessel_3;
			s.Vessel_Imo_3__c=Vessel_Imo_3;
			s.Vessel_4__c=Vessel_4;
			s.Vessel_Imo_4__c=Vessel_Imo_4;
			s.Truck_Vessel_Latitude__c=Truck_Vessel_Latitude;
			s.Truck_Vessel_Longitude__c=Truck_Vessel_Longitude;
			s.Vessel_Course__c=Vessel_Course;
		 	s.Vessel_Information__c=Vessel_Information;
		 	s.External_Reference_OI__c=shipment_id;
		 	for(Event__c e:newevents)
		 	{
		 		Event__c newe=e.clone(false,true);
				newe.Shipments_Program__c=s.Id;
		 		eventList.add(newe);
		 	}
		}
 }
 public static DateTime getDateTimeValue(JSONParser parser)
 {
 	try{
 		return parser.getDateTimeValue();
 	}
 	catch(Exception e){}
 	return null;
 }
 public static Date getDateValue(JSONParser parser)
 {
 	try{
 		return parser.getDateValue();
 	}
 	catch(Exception e){}
 	return null;
 }
    public static Boolean setEvent(String eventName,DateTime eventDateTime,List<Event__c>newevents)
    {
        if((!eventName.endsWith('_actual'))
            &&(!eventName.endsWith('_detected'))
            &&(!eventName.endsWith('_planned_initial'))
            &&(!eventName.endsWith('_planned_last')))
            return false;
        if(eventDateTime==null)
            return false;
        Event__c e=getEvent(eventName,newevents);
        if(e==null)
            return false;
        if(eventName.endsWith('_actual'))
            e.Notified_Date_Time__c=eventDateTime;
        else if(eventName.endsWith('_detected'))
            e.Detected_Date_Time__c=eventDateTime;
        else if(eventName.endsWith('_planned_initial'))
        {
            e.Initial_Planned_Date_Time__c=eventDateTime;
            if(e.Planned_Date_Time__c==null)
                e.Planned_Date_Time__c=eventDateTime;
        }
        else if(eventName.endsWith('_planned_last'))
        {
            e.Planned_Date_Time__c=eventDateTime;
            if(e.Initial_Planned_Date_Time__c==null)
                e.Initial_Planned_Date_Time__c=eventDateTime;
        }
        return true;
    }
    public static Event__c getEvent(String eventName,List<Event__c>newevents)
    {
        String eventType=null;
        String eventCode=null;
        String[] mymilestonesName=milestonesName;
        for(Integer s=0;s<milestonesXml.size();s++)
            if(eventName.startsWith(milestonesXml[s]))
            {
                eventType=mymilestonesName[s];
                eventCode=milestonesCode[s];
                break;
            }
        if(eventType==null)
            return null;
        for(Event__c e:newevents)
            if(e.Event__c==eventType)
                return e;
        Event__c ret=new Event__c();
        ret.Name=EventCode;
        ret.Event__c=eventType;
        newevents.add(ret);
        return ret;
    }
 public static JSONParser queryShipment(String shipment_id)
 {
    if(!shipment_id.startsWith('sh'))
    	return querySubscription(shipment_id);
	shipment_id=shipment_id.substring(2);
    string url = NEU_Settings.OIshipments;
    String username = NEU_Settings.OIuser;
    String password = NEU_Settings.OIpass;
    HttpRequest req = new HttpRequest();
    req.setTimeout(100000);
    req.setMethod('GET');
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'BASIC ' +
    EncodingUtil.base64Encode(headerValue);
    req.setHeader('Authorization', authorizationHeader);
    req.setHeader('Accept','application/json');
    if(shipment_id.startsWith('sh'))
    	shipment_id=shipment_id.substring(2);
    req.setEndpoint(url+shipment_id+'/');
	JSONParser parser=null;
	try{
	    if(!Test.isRunningTest()){parser=JSON.createParser((new Http()).send(req).getBody());}
	    else
	    	parser=JSON.createParser('{"id": 2497553,"shipmentsubscription_status_verbose": "active","shipmentsubscription_status": 1,"shipmentsubscription_id": 2641243,"status_verbose": "ocean transport to POD","current_vessel_nextport": null,"current_vessel_position": null,"current_vessel": {"name": "APL USE-CMA CGM CASSIOPEIA (IMO: --)","imo": "123456789"},"tsp4_loc": null,"tsp3_loc": null,"tsp2_loc": null,"tsp1_loc": {"name": "Singapore","locode": "SGSIN"},"leg5_vessel": null,"leg4_vessel": null,"leg3_vessel": null,"leg2_vessel": {"name": "APL USE-CMA CGM CASSIOPEIA (IMO: --)","imo": "123456789"},"leg1_vessel": {"name": "APL USE-HIJAU SAMUDRA (IMO: --)","imo": "123456789"},"dlv_loc": null,"pod_loc": null,"pol_loc": {"name": "Belawan","locode": "IDBLW"},"origin_loc": {"name": "Belawan","locode": "IDBLW"},"carrier_name": "CMA CGM","carrier_scac": "CMDU","container_type_iso": "22GP","container_type_str": "20 ft Standard Container","url": "http://capi.ocean-insights.com/containertracking/v1/shipments/2497553/","container_number": "TGCU0042577","booking_number": null,"bl_number": null,"weight": null,"status": 16,"lifecycle_status": 0,"id_date": "2017-08-25","descriptive_name": null,"empty_pickup_planned_initial": null,"empty_pickup_planned_last": null,"empty_pickup_actual": "2017-08-25","origin_pickup_planned_initial": null,"origin_pickup_planned_last": null,"origin_pickup_actual": null,"pol_arrival_planned_initial": null,"pol_arrival_planned_last": null,"pol_arrival_actual": "2017-08-30","pol_loaded_planned_initial": null,"pol_loaded_planned_last": null,"pol_loaded_actual": "2017-08-31","pol_vsldeparture_planned_initial": null,"pol_vsldeparture_planned_last": null,"pol_vsldeparture_actual": null,"pol_vsldeparture_detected": null,"leg1_voyage": "5FJSMR053","tsp1_vslarrival_planned_initial": null,"tsp1_vslarrival_planned_last": null,"tsp1_vslarrival_actual": null,"tsp1_vslarrival_detected": null,"tsp1_discharge_planned_initial": null,"tsp1_discharge_planned_last": null,"tsp1_discharge_actual": "2017-09-03","tsp1_loaded_planned_initial": null,"tsp1_loaded_planned_last": null,"tsp1_loaded_actual": "2017-09-08","tsp1_vsldeparture_planned_initial": null,"tsp1_vsldeparture_planned_last": null,"tsp1_vsldeparture_actual": null,"tsp1_vsldeparture_detected": null,"leg2_voyage": "SIOCMA231","tsp2_vslarrival_planned_initial": null,"tsp2_vslarrival_planned_last": null,"tsp2_vslarrival_actual": null,"tsp2_vslarrival_detected": null,"tsp2_discharge_planned_initial": null,"tsp2_discharge_planned_last": null,"tsp2_discharge_actual": null,"tsp2_loaded_planned_initial": null,"tsp2_loaded_planned_last": null,"tsp2_loaded_actual": null,"tsp2_vsldeparture_planned_initial": null,"tsp2_vsldeparture_planned_last": null,"tsp2_vsldeparture_actual": null,"tsp2_vsldeparture_detected": null,"leg3_voyage": null,"tsp3_vslarrival_planned_initial": null,"tsp3_vslarrival_planned_last": null,"tsp3_vslarrival_actual": null,"tsp3_vslarrival_detected": null,"tsp3_discharge_planned_initial": null,"tsp3_discharge_planned_last": null,"tsp3_discharge_actual": null,"tsp3_loaded_planned_initial": null,"tsp3_loaded_planned_last": null,"tsp3_loaded_actual": null,"tsp3_vsldeparture_planned_initial": null,"tsp3_vsldeparture_planned_last": null,"tsp3_vsldeparture_actual": null,"tsp3_vsldeparture_detected": null,"leg4_voyage": null,"tsp4_vslarrival_planned_initial": null,"tsp4_vslarrival_planned_last": null,"tsp4_vslarrival_actual": null,"tsp4_vslarrival_detected": null,"tsp4_discharge_planned_initial": null,"tsp4_discharge_planned_last": null,"tsp4_discharge_actual": null,"tsp4_loaded_planned_initial": null,"tsp4_loaded_planned_last": null,"tsp4_loaded_actual": null,"tsp4_vsldeparture_planned_initial": null,"tsp4_vsldeparture_planned_last": null,"tsp4_vsldeparture_actual": null,"tsp4_vsldeparture_detected": null,"leg5_voyage": null,"pod_vslarrival_planned_initial": null,"pod_vslarrival_planned_last": null,"pod_vslarrival_actual": null,"pod_vslarrival_detected": null,"pod_discharge_planned_initial": null,"pod_discharge_planned_last": null,"pod_discharge_actual": null,"pod_departure_planned_initial": null,"pod_departure_planned_last": null,"pod_departure_actual": null,"dlv_delivery_planned_initial": null,"dlv_delivery_planned_last": null,"dlv_delivery_actual": null,"empty_return_planned_initial": null,"empty_return_planned_last": null,"empty_return_actual": null,"ts_count": 1,"plausibility_issue": false,"plausibility_issue_actual": false,"plausibility_issue_planned": false,"last_carrier_update": "2017-09-12T07:45+0000","last_actuals_update": "2017-09-12T10:39+0000","created": "2017-09-11T18:17+0000","modified": "2017-09-12T10:39+0000","shipmentsubscription": "http://capi.ocean-insights.com/containertracking/v1/subscriptions/2641243/","empty_pickup_loc": {"name": "Belawan","locode": "IDBLW"},"lif_loc": null,"empty_return_loc": null}');
	}
	catch(Exception e){}
    return parser;
 }
 public static JSONParser querySubscription(String subscription_id)
 {
    string url = NEU_Settings.OIsubscriptions;
    String username = NEU_Settings.OIuser;
    String password = NEU_Settings.OIpass;
    HttpRequest req = new HttpRequest();
    req.setTimeout(100000);
    req.setMethod('GET');
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'BASIC ' +
    EncodingUtil.base64Encode(headerValue);
    req.setHeader('Authorization', authorizationHeader);
    req.setHeader('Accept','application/json');
    req.setEndpoint(url+subscription_id+'/');
	try{
		JSONParser parser=null;		
	    if(!Test.isRunningTest()){parser=JSON.createParser((new Http()).send(req).getBody());}
	    else
	    	parser=JSON.createParser('{"id": 2641243,"request_carrier_name": "CMA CGM","suspicious_key": false,"descriptive_name": null,"containershipments": [{"id": 2497553,"shipmentsubscription_status_verbose": "active","shipmentsubscription_status": 1,"shipmentsubscription_id": 2641243,"status_verbose": "ocean transport to POD","current_vessel_nextport": null,"current_vessel_position": null,"current_vessel": {"name": "APL USE-CMA CGM CASSIOPEIA (IMO: --)","imo": "1234567"},"tsp4_loc": null,"tsp3_loc": null,"tsp2_loc": null,"tsp1_loc": {"name": "Singapore","locode": "SGSIN"},"leg5_vessel": null,"leg4_vessel": null,"leg3_vessel": null,"leg2_vessel": {"name": "APL USE-CMA CGM CASSIOPEIA (IMO: --)","imo": "123456789"},"leg1_vessel": {"name": "APL USE-HIJAU SAMUDRA (IMO: --)","imo": "123456789"},"dlv_loc": null,"pod_loc": null,"pol_loc": {"name": "Belawan","locode": "IDBLW"},"origin_loc": {"name": "Belawan","locode": "IDBLW"},"carrier_name": "CMA CGM","carrier_scac": "CMDU","container_type_iso": "22GP","container_type_str": "20 ft Standard Container","url": "http://capi.ocean-insights.com/containertracking/v1/shipments/2497553/","container_number": "TGCU0042577","booking_number": null,"bl_number": null,"weight": null,"status": 16,"lifecycle_status": 0,"id_date": "2017-08-25","descriptive_name": null,"empty_pickup_planned_initial": null,"empty_pickup_planned_last": null,"empty_pickup_actual": "2017-08-25","origin_pickup_planned_initial": null,"origin_pickup_planned_last": null,"origin_pickup_actual": null,"pol_arrival_planned_initial": null,"pol_arrival_planned_last": null,"pol_arrival_actual": "2017-08-30","pol_loaded_planned_initial": null,"pol_loaded_planned_last": null,"pol_loaded_actual": "2017-08-31","pol_vsldeparture_planned_initial": null,"pol_vsldeparture_planned_last": null,"pol_vsldeparture_actual": null,"pol_vsldeparture_detected": null,"leg1_voyage": "5FJSMR053","tsp1_vslarrival_planned_initial": null,"tsp1_vslarrival_planned_last": null,"tsp1_vslarrival_actual": null,"tsp1_vslarrival_detected": null,"tsp1_discharge_planned_initial": null,"tsp1_discharge_planned_last": null,"tsp1_discharge_actual": "2017-09-03","tsp1_loaded_planned_initial": null,"tsp1_loaded_planned_last": null,"tsp1_loaded_actual": "2017-09-08","tsp1_vsldeparture_planned_initial": null,"tsp1_vsldeparture_planned_last": null,"tsp1_vsldeparture_actual": null,"tsp1_vsldeparture_detected": null,"leg2_voyage": "SIOCMA231","tsp2_vslarrival_planned_initial": null,"tsp2_vslarrival_planned_last": null,"tsp2_vslarrival_actual": null,"tsp2_vslarrival_detected": null,"tsp2_discharge_planned_initial": null,"tsp2_discharge_planned_last": null,"tsp2_discharge_actual": null,"tsp2_loaded_planned_initial": null,"tsp2_loaded_planned_last": null,"tsp2_loaded_actual": null,"tsp2_vsldeparture_planned_initial": null,"tsp2_vsldeparture_planned_last": null,"tsp2_vsldeparture_actual": null,"tsp2_vsldeparture_detected": null,"leg3_voyage": null,"tsp3_vslarrival_planned_initial": null,"tsp3_vslarrival_planned_last": null,"tsp3_vslarrival_actual": null,"tsp3_vslarrival_detected": null,"tsp3_discharge_planned_initial": null,"tsp3_discharge_planned_last": null,"tsp3_discharge_actual": null,"tsp3_loaded_planned_initial": null,"tsp3_loaded_planned_last": null,"tsp3_loaded_actual": null,"tsp3_vsldeparture_planned_initial": null,"tsp3_vsldeparture_planned_last": null,"tsp3_vsldeparture_actual": null,"tsp3_vsldeparture_detected": null,"leg4_voyage": null,"tsp4_vslarrival_planned_initial": null,"tsp4_vslarrival_planned_last": null,"tsp4_vslarrival_actual": null,"tsp4_vslarrival_detected": null,"tsp4_discharge_planned_initial": null,"tsp4_discharge_planned_last": null,"tsp4_discharge_actual": null,"tsp4_loaded_planned_initial": null,"tsp4_loaded_planned_last": null,"tsp4_loaded_actual": null,"tsp4_vsldeparture_planned_initial": null,"tsp4_vsldeparture_planned_last": null,"tsp4_vsldeparture_actual": null,"tsp4_vsldeparture_detected": null,"leg5_voyage": null,"pod_vslarrival_planned_initial": null,"pod_vslarrival_planned_last": null,"pod_vslarrival_actual": null,"pod_vslarrival_detected": null,"pod_discharge_planned_initial": null,"pod_discharge_planned_last": null,"pod_discharge_actual": null,"pod_departure_planned_initial": null,"pod_departure_planned_last": null,"pod_departure_actual": null,"dlv_delivery_planned_initial": null,"dlv_delivery_planned_last": null,"dlv_delivery_actual": null,"empty_return_planned_initial": null,"empty_return_planned_last": null,"empty_return_actual": null,"ts_count": 1,"plausibility_issue": false,"plausibility_issue_actual": false,"plausibility_issue_planned": false,"last_carrier_update": "2017-09-12T07:45+0000","last_actuals_update": "2017-09-12T10:39+0000","created": "2017-09-11T18:17+0000","modified": "2017-09-12T10:39+0000","shipmentsubscription": "http://capi.ocean-insights.com/containertracking/v1/subscriptions/2641243/","empty_pickup_loc": {"name": "Belawan","locode": "IDBLW"},"lif_loc": null,"empty_return_loc": null}],"url": "http://capi.ocean-insights.com/containertracking/v1/subscriptions/2641243/","request_type": "c_id","request_key": "TGCU0042577","contractual_eta_pod": null,"contractual_eta_dlv": null,"owner_internal_id": null,"created": "2017-09-11T18:13+0000","modified": "2017-09-12T10:39+0000","last_carrier_request": "2017-09-12T07:42+0000","last_carrier_update": "2017-09-12T07:45+0000","last_actuals_request": "2017-09-12T10:37+0000","last_actuals_update": "2017-09-12T10:39+0000","last_position_request": null,"last_position_update": null,"status": 1}');
		while(parser.nextToken()!=null)
	    	if(parser.getCurrentToken()==JSONToken.FIELD_NAME)
	    		if(parser.getText()=='containershipments')
	    		{
	    			if(parser.nextToken()==JSONToken.START_ARRAY)
	    				if(parser.nextToken()==JSONToken.START_OBJECT)
	    					return parser;
	    			break;
	    		}
	}
	catch(Exception e){}
    return null;
 }
}