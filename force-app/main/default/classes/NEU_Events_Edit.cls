public with sharing class NEU_Events_Edit extends NEU_Controller_Comparable{
	public String validationOK{get;set;}
	public String decimalSep
	{
		get{if(decimalSep==null)decimalSep=NEU_Utils.getDecimalSep();return decimalSep;}
		set{decimalSep=value;}
	}
	public String thousandSep
	{
		get{if(thousandSep==null)thousandSep=NEU_Utils.getThousandSep();return thousandSep;}
		set{thousandSep=value;}
	}
	private String[] events=new String[]{'Container empty to shipper|CEP','Container pickup at shipper|CPS','Container arrival at first POL|CGI'
		,'Container loaded at first POL|CLL','Vessel departure from first POL|VDL','Vessel arrival at T/S port 1|VAT1','Container discharge at T/S port1|CDT1'
		,'Container loaded at T/S port 1|CLT1','Vessel departure from T/S 1|VDT1','Vessel arrival at T/S port 2|VAT2','Container discharge at T/S port 2|CDT2'
		,'Container loaded at T/S port 2|CLT2','Vessel departure from T/S 2|VDT2','Vessel arrival at T/S port 3|VAT3','Container discharge at T/S port 3|CDT3'
		,'Container loaded at T/S port 3|CLT3','Vessel departure from T/S port 3|VDT3','Vessel arrival at final POD|VAD','Container discharge at final POD|CDD'
		,'Container departure from final POD|CGO','Container delivery to consignee|CDC','Container empty return to depot|CER'};
	private String[] eventst=new String[]{'Container empty to shipper|CEP','Container pickup at shipper|CPS','Container arrival at first POL|CGI'
		,'Container loaded at first POL|CLL','Truck departure from first POL|VDL','Truck arrival at T/S port 1|VAT1','Container discharge at T/S port1|CDT1'
		,'Container loaded at T/S port 1|CLT1','Truck departure from T/S 1|VDT1','Truck arrival at T/S port 2|VAT2','Container discharge at T/S port 2|CDT2'
		,'Container loaded at T/S port 2|CLT2','Truck departure from T/S 2|VDT2','Truck arrival at T/S port 3|VAT3','Container discharge at T/S port 3|CDT3'
		,'Container loaded at T/S port 3|CLT3','Truck departure from T/S 3|VDT3','Truck arrival at final POD|VAD','Container discharge at final POD|CDD'
		,'Container departure from final POD|CGO','Container delivery to consignee|CDC','Container empty return to depot|CER'};
	private String[] eventsf=new String[]{'Container empty to shipper|CEP','Container pickup at shipper|CPS','Container arrival at first POL|CGI'
		,'Container loaded at first POL|CLL','Flight departure from first POL|VDL','Flight arrival at T/S port 1|VAT1','Container discharge at T/S port1|CDT1'
		,'Container loaded at T/S port 1|CLT1','Flight departure from T/S 1|VDT1','Flight arrival at T/S port 2|VAT2','Container discharge at T/S port 2|CDT2'
		,'Container loaded at T/S port 2|CLT2','Flight departure from T/S 2|VDT2','Flight arrival at T/S port 3|VAT3','Container discharge at T/S port 3|CDT3'
		,'Container loaded at T/S port 3|CLT3','Flight departure from T/S 3|VDT3','Flight arrival at final POD|VAD','Container discharge at final POD|CDD'
		,'Container departure from final POD|CGO','Container delivery to consignee|CDC','Container empty return to depot|CER'};
    public override void sortList(Integer sortList)
    {
    	myList.sort();
    }
    private Shipment__c shipment=null;
    private Shipment_Program__c shipmentprogram=null;
    
    public String transportName
    {
    	get
    	{
    		if(transportName==null)
    		{
    			if(transportType==2)
    				transportName='Truck';
    			else if(transportType==3)
    				transportName='Flight';
    			else
    				transportName='Vessel';
    		}
    		return transportName;
    	}
    	set
    	{
    		if(transportName!=value)
    			transportName=value;
    	}
    }
    
    public Integer transportType
    {
    	get
    	{
    		if(transportType==null)
    		{
  				transportType=1;
	    		if(shipment!=null)
	    		{
	    			if(String.isNotEmpty(shipment.Truck_Number__c))
	    				transportType=2;
	    			else if(String.isNotEmpty(shipment.Flight_Number__c))
	    				transportType=3;
	    		}
	    		else if(shipmentprogram!=null)
	    		{
	    			if(String.isNotEmpty(shipmentprogram.Truck_Number__c))
	    				transportType=2;
	    			else if(String.isNotEmpty(shipmentprogram.Flight_Number__c))
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

    public ID parentId
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Id;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Id;
    		return null;
    	}
    }
    public Integer parentType
    {
    	get
    	{
    		if(shipment!=null)
    			return 1;
    		if(shipmentprogram!=null)
    			return 2;
    		return 0;
    	}
    }
    public String parentTypeName
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.getSobjectType().getDescribe().getLabel();
    		if(shipmentprogram!=null)
    			return shipmentprogram.getSobjectType().getDescribe().getLabel();
    		return null;
    	}
    }
    public String parentName
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Name;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Name;
    		return null;
    	}
    }
    public String polname
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Port_Of_Loading__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Port_Of_Loading__c;
    		return null;
    	}
    	set
    	{
    		if(polname!=value)
	    		if(shipment!=null)
	    			shipment.Port_Of_Loading__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Port_Of_Loading__c=value;
    	}
    }
    public String podname
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Port_Of_Discharging__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Port_Of_Discharging__c;
    		return null;
    	}
    	set
    	{
    		if(podname!=value)
	    		if(shipment!=null)
	    			shipment.Port_Of_Discharging__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Port_Of_Discharging__c=value;
    	}
    }
    public String ts1
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Port_of_Transshipment_1__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Port_of_Transshipment_1__c;
    		return null;
    	}
    	set
    	{
    		if(ts1!=value)
	    		if(shipment!=null)
	    			shipment.Port_of_Transshipment_1__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Port_of_Transshipment_1__c=value;
    	}
    }
    public String ts2
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Port_of_Transshipment_2__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Port_of_Transshipment_2__c;
    		return null;
    	}
    	set
    	{
    		if(ts2!=value)
	    		if(shipment!=null)
	    			shipment.Port_of_Transshipment_2__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Port_of_Transshipment_2__c=value;
    	}
    }
    public String ts3
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Port_of_Transshipment_3__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Port_of_Transshipment_3__c;
    		return null;
    	}
    	set
    	{
    		if(ts3!=value)
	    		if(shipment!=null)
	    			shipment.Port_of_Transshipment_3__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Port_of_Transshipment_3__c=value;
    	}
    }
    public String vessel1
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Vessel_1__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Vessel_1__c;
    		return null;
    	}
    	set
    	{
    		if(vessel1!=value)
	    		if(shipment!=null)
	    			shipment.Vessel_1__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Vessel_1__c=value;
    	}
    }
    public String vessel2
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Vessel_2__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Vessel_2__c;
    		return null;
    	}
    	set
    	{
    		if(vessel2!=value)
	    		if(shipment!=null)
	    			shipment.Vessel_2__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Vessel_2__c=value;
    	}
    }
    public String vessel3
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Vessel_3__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Vessel_3__c;
    		return null;
    	}
    	set
    	{
    		if(vessel3!=value)
	    		if(shipment!=null)
	    			shipment.Vessel_3__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Vessel_3__c=value;
    	}
    }
    public String vessel4
    {
    	get
    	{
    		if(shipment!=null)
    			return shipment.Vessel_4__c;
    		if(shipmentprogram!=null)
    			return shipmentprogram.Vessel_4__c;
    		return null;
    	}
    	set
    	{
    		if(vessel4!=value)
	    		if(shipment!=null)
	    			shipment.Vessel_4__c=value;
	    		if(shipmentprogram!=null)
	    			shipmentprogram.Vessel_4__c=value;
    	}
    }
    public NEU_Events_Edit()
    {
		String myId=ApexPages.currentPage().getParameters().get('id');
		if(String.isNotEmpty(myId))
		{
			if(myId.startsWith(Shipment__c.sObjectType.getDescribe().getKeyPrefix()))
			{
				List<Shipment__c>s=[select Id,Name,Truck_Number__c,Flight_Number__c,Truck_Vessel_Flight__c,Port_Of_Loading__c,Port_Of_Discharging__c,Port_of_Transshipment_1__c,Port_of_Transshipment_2__c,Port_of_Transshipment_3__c,Vessel_1__c,Vessel_2__c,Vessel_3__c,Vessel_4__c,Inbound_Consolidation_Program__c from Shipment__c where Id=:myId];
				if(s.size()>0)
					shipment=s[0];
			}
			else if(myId.startsWith(Shipment_Program__c.sObjectType.getDescribe().getKeyPrefix()))
			{
				List<Shipment_Program__c>s=[select Id,Name,Truck_Number__c,Flight_Number__c,Vessel__c,Port_Of_Loading__c,Port_Of_Discharging__c,Port_of_Transshipment_1__c,Port_of_Transshipment_2__c,Port_of_Transshipment_3__c,Vessel_1__c,Vessel_2__c,Vessel_3__c,Vessel_4__c from Shipment_Program__c where Id=:myId];
				if(s.size()>0)
					shipmentprogram=s[0];
			}
		}
    }
    public PageReference cancel()
    {
		if(parentType==1)
	    	return new ApexPages.standardController(shipment).view();
		else if(parentType==2)
	    	return new ApexPages.standardController(shipmentprogram).view();
	    return null;
    }
    public void saveData()
    {
    	validationOK='true';
    	List<Event__c>toUpsert=new List<Event__c>();
    	List<Event__c>toDelete=new List<Event__c>();
    	Boolean shipUpdate=false;
    	for(Event_s s:myList)
    	{
			if(s.position==2)
			{
				if((polname!=s.port)&&(String.isNotEmpty(polname)||String.isNotEmpty(s.port)))
				{
					polname=s.port;
					shipUpdate=true;
				}
			}
			else if(s.position==4)
			{
				if((vessel1!=s.transport)&&(String.isNotEmpty(vessel1)||String.isNotEmpty(s.transport)))
				{
					vessel1=s.transport;
					shipUpdate=true;
				}
			}
			else if(s.position==5)
			{
				if((ts1!=s.port)&&(String.isNotEmpty(ts1)||String.isNotEmpty(s.port)))
				{
					ts1=s.port;
					shipUpdate=true;
				}
			}
			else if(s.position==8)
			{
				if((vessel2!=s.transport)&&(String.isNotEmpty(vessel2)||String.isNotEmpty(s.transport)))
				{
					vessel2=s.transport;
					shipUpdate=true;
				}
			}
			else if(s.position==9)
			{
				if((ts2!=s.port)&&(String.isNotEmpty(ts2)||String.isNotEmpty(s.port)))
				{
					ts2=s.port;
					shipUpdate=true;
				}
			}
			else if(s.position==12)
			{
				if((vessel3!=s.transport)&&(String.isNotEmpty(vessel3)||String.isNotEmpty(s.transport)))
				{
					vessel3=s.transport;
					shipUpdate=true;
				}
			}
			else if(s.position==13)
			{
				if((ts3!=s.port)&&(String.isNotEmpty(ts3)||String.isNotEmpty(s.port)))
				{
					ts3=s.port;
					shipUpdate=true;
				}
			}
			else if(s.position==16)
			{
				if((vessel4!=s.transport)&&(String.isNotEmpty(vessel4)||String.isNotEmpty(s.transport)))
				{
					vessel4=s.transport;
					shipUpdate=true;
				}
			}
			else if(s.position==17)
			{
				if((podname!=s.port)&&(String.isNotEmpty(podname)||String.isNotEmpty(s.port)))
				{
					podname=s.port;
					shipUpdate=true;
				}
			}
    		if(s.objdateTime.Notified_Date_Time__c!=null)
    		{
    			if(s.DateTimeType==1)
    			{
    				if(s.obj.Initial_Planned_Date_Time__c!=s.objdateTime.Notified_Date_Time__c)
    					s.obj.Notified_Date_Time__c=s.objDateTime.Notified_Date_Time__c;
    			}
    			else if(s.DateTimeType==2)
    			{
    				if(s.obj.Planned_Date_Time__c!=s.objdateTime.Notified_Date_Time__c)
	    				s.obj.Notified_Date_Time__c=s.objDateTime.Notified_Date_Time__c;
    			}
    			else if(s.DateTimeType==3)
    				s.obj.Notified_Date_Time__c=s.objDateTime.Notified_Date_Time__c;
    			else if(s.DateTimeType==4)
    				s.obj.Detected_Date_Time__c=s.objDateTime.Notified_Date_Time__c;
    			s.obj.Previous_Event_Code__c=null;
    			toUpsert.add(s.obj);
    		}
    		else if(s.obj.Id!=null)
    			toDelete.add(s.obj);
    	}
    	if(toUpsert.size()>0)
    		upsert toUpsert;
		if(toDelete.size()>0)
			delete toDelete;
		if(shipUpdate)
			if(parentType==1)
				update shipment;
			else if(parentType==2)
				update shipmentprogram;
		myList=null;
		toUpsert=new List<Event__c>();
    	ID lastEvent=null;
    	for(Event_s s:myList)
    	{
    		if((s.obj.Initial_Planned_Date_Time__c!=null)||(s.obj.Planned_Date_Time__c!=null)||(s.obj.Notified_Date_Time__c!=null)||(s.obj.Detected_Date_Time__c!=null))
    		{
    			if(lastEvent!=null)
    			{
    				s.obj.Previous_Event_Code__c=lastEvent;
    				toUpsert.add(s.obj);
    			}
    			lastEvent=s.obj.Id;
    		}
    	}
    	if(toUpsert.size()>0)
    		upsert toUpsert;
    	Id mysp=null;
    	List<Event__c>eventsToInsert=new List<Event__c>();
    	if(parentType==1)
    	{
    		if(shipment.Inbound_Consolidation_Program__c!=null)
    		{
				List<Shipment_Program__c>sps=[select Id,Port_Of_Loading__c,Port_Of_Discharging__c,Port_of_Transshipment_1__c,Port_of_Transshipment_2__c,Port_of_Transshipment_3__c,Vessel_1__c,Vessel_2__c,Vessel_3__c,Vessel_4__c from Shipment_Program__c where Id=:shipment.Inbound_Consolidation_Program__c];
				if(sps.size()>0)
				{
					sps[0].Port_Of_Loading__c=polname;
					sps[0].Port_Of_Discharging__c=podname;
					sps[0].Port_of_Transshipment_1__c=ts1;
					sps[0].Port_of_Transshipment_2__c=ts2;
					sps[0].Port_of_Transshipment_3__c=ts3;
					sps[0].Vessel_1__c=vessel1;
					sps[0].Vessel_2__c=vessel2;
					sps[0].Vessel_3__c=vessel3;
					sps[0].Vessel_4__c=vessel4;
					update sps[0];
					mysp=sps[0].Id;
					for(Event_s s:myList)
			    	{
			    		if((s.obj.Initial_Planned_Date_Time__c!=null)||(s.obj.Planned_Date_Time__c!=null)||(s.obj.Notified_Date_Time__c!=null)||(s.obj.Detected_Date_Time__c!=null))
			    		{
			    			Event__c e=(Event__c)NEU_Utils.clone(s.obj);
   							e.Shipment__c=null;
   							e.Shipments_Program__c=mysp;
   							e.Previous_Event_Code__c=null;
		    				eventsToInsert.add(e);
			    		}
			    	}
				}
    		}
    	}
		List<Shipment__c>ss=null;
		if(mysp!=null)
			ss=[select Id,Port_Of_Loading__c,Port_Of_Discharging__c,Port_of_Transshipment_1__c,Port_of_Transshipment_2__c,Port_of_Transshipment_3__c,Vessel_1__c,Vessel_2__c,Vessel_3__c,Vessel_4__c from Shipment__c where Inbound_Consolidation_Program__c=:mysp and Id!=:parentId];
		else if(parentType==2)
			ss=[select Id,Port_Of_Loading__c,Port_Of_Discharging__c,Port_of_Transshipment_1__c,Port_of_Transshipment_2__c,Port_of_Transshipment_3__c,Vessel_1__c,Vessel_2__c,Vessel_3__c,Vessel_4__c from Shipment__c where Inbound_Consolidation_Program__c=:parentId];
		else
			ss=new List<Shipment__c>();
		if(ss.size()>0)
		{
			for(Shipment__c s:ss)
	   		{
				s.Port_Of_Loading__c=polname;
				s.Port_Of_Discharging__c=podname;
				s.Port_of_Transshipment_1__c=ts1;
				s.Port_of_Transshipment_2__c=ts2;
				s.Port_of_Transshipment_3__c=ts3;
				s.Vessel_1__c=vessel1;
				s.Vessel_2__c=vessel2;
				s.Vessel_3__c=vessel3;
				s.Vessel_4__c=vessel4;
				for(Event_s mye:myList)
		    	{
		    		if((mye.obj.Initial_Planned_Date_Time__c!=null)||(mye.obj.Planned_Date_Time__c!=null)||(mye.obj.Notified_Date_Time__c!=null)||(mye.obj.Detected_Date_Time__c!=null))
		    		{
		    			Event__c e=(Event__c)NEU_Utils.clone(mye.obj);
						e.Shipment__c=s.Id;
  						e.Shipments_Program__c=null;
   						e.Previous_Event_Code__c=null;
		    			eventsToInsert.add(e);
			    	}
			    }
	    	}
	    	update ss;
		}
    	delete [select Id from Event__c where Shipment__c IN:ss or (Shipments_Program__c!=null and Shipments_Program__c=:mysp)];
    	insert eventsToInsert;
    	toUpsert=new List<Event__c>();
    	Id LastId=null;
		lastEvent=null;
		for(Event__c s:eventsToInsert)
    	{
    		if(s.Shipment__c!=null)
    		{
    			if(s.Shipment__c!=LastId)
    			{
    				LastId=s.Shipment__c;
	    			lastEvent=null;
    			}
    		}
    		else if(s.Shipments_Program__c!=null)
    		{
    			if(s.Shipments_Program__c!=LastId)
    			{
    				LastId=s.Shipments_Program__c;
	    			lastEvent=null;
    			}
    		}
			if(lastEvent!=null)
			{
				s.Previous_Event_Code__c=lastEvent;
				toUpsert.add(s);
			}
			lastEvent=s.Id;
    	}
    	if(toUpsert.size()>0)
    		upsert toUpsert;
    }
    public List<Event_s>myList
    {
    	get
    	{
    		if(myList==null)
    		{
    			myList=new List<Event_s>();
    			Map<String,Event__c>myMap=new Map<String,Event__c>();
    			String myid=ApexPages.currentPage().getParameters().get('id');
    			if(String.isNotEmpty(myid))
    			{
    				List<Event__c> el=null;
    				if(parentType==1)
						el=[select Id,Name,Event__c,Initial_Planned_Date_Time__c,Planned_Date_Time__c,Notified_Date_Time__c,Detected_Date_Time__c,Previous_Event_Code__c from Event__c where Shipment__c=:parentid];
    				else if(parentType==2)
    					el=[select Id,Name,Event__c,Initial_Planned_Date_Time__c,Planned_Date_Time__c,Notified_Date_Time__c,Detected_Date_Time__c,Previous_Event_Code__c from Event__c where Shipments_Program__c=:parentid];
    				if(el!=null)
    				{
    					
	    				for(Event__c e:el)
	    					myMap.put(e.Name,e);
	    				integer counter=0;
	    				List<String>myevents=events;
	    				if(transportType==2)
	    					myevents=eventst;
	    				else if(transportType==3)
	    					myevents=eventsf;
	    				for(String s:myevents)
	    				{
	    					String[]s2=s.split('\\|');
	    					Event__c e=myMap.get(s2[1]);
	    					if(e==null)
	    					{
	    						e=new Event__c();
	    						e.Name=s2[1];
	    						e.Event__c=s2[0];
	    						if(parentType==1)
	    							e.Shipment__c=parentid;
	    						else if(parentType==2)
	    							e.Shipments_Program__c=parentid;
	    					}
	    					Event_s es=new Event_s(this);
	    					es.obj=e;
	    					if(counter==2)
	    						es.port=polname;
	    					else if(counter==4)
	    						es.transport=vessel1;
	    					else if(counter==5)
	    						es.port=ts1;
	    					else if(counter==8)
	    						es.transport=vessel2;
	    					else if(counter==9)
	    						es.port=ts2;
	    					else if(counter==12)
	    						es.transport=vessel3;
	    					else if(counter==13)
	    						es.port=ts3;
	    					else if(counter==16)
	    						es.transport=vessel4;
	    					else if(counter==17)
	    						es.port=podname;
	    					es.position=counter++;
	    					myList.add(es);
	    				}
    				}
    				sorting(0,'Name',1);
    			}
    		}
    		return myList;
    	}
    	set;
    }
    public class Event_s extends NEU_Line_Comparable
    {
    	public Event__c obj{
    		get
    		{
    			return obj;
    		}
    		set
    		{
    			if(obj!=value)
    			{
    				obj=value;
    				if(obj==null)
    				{
    					objdateTime.Notified_Date_Time__c=null;
    					DateTimeType=3;
    				}
    				else if(obj.Detected_Date_Time__c!=null)
    				{
    					objdateTime.Notified_Date_Time__c=obj.Detected_Date_Time__c;
    					DateTimeType=4;
    				}
    				else if(obj.Notified_Date_Time__c!=null)
    				{
    					objdateTime.Notified_Date_Time__c=obj.Notified_Date_Time__c;
    					DateTimeType=3;
    				}
    				else if(obj.Planned_Date_Time__c !=null)
    				{
    					objdateTime.Notified_Date_Time__c=obj.Planned_Date_Time__c ;
    					DateTimeType=2;
    				}
    				else if(obj.Initial_Planned_Date_Time__c!=null)
    				{
    					objdateTime.Notified_Date_Time__c=obj.Initial_Planned_Date_Time__c;
    					DateTimeType=1;
    				}
    				else
    				{
    					objdateTime.Notified_Date_Time__c=null;
    					DateTimeType=3;
    				}
    			}
    		}
    	}
    	public Integer DateTimeType{get;set;}
    	public Event__c objdateTime{get;set;}
    	public String port{get;set;}
    	public String transport{get;set;}
    	public Integer position{get;set;}
    	
		public Event_s(NEU_Controller_Comparable parent)
        {
        	super(parent);
        	objdateTime=new Event__c();
        	DateTimeType=3;
        }
        public override Object getValue(String compareField)
    	{
    		if(compareField=='DateTime')
    			return objdateTime.Notified_Date_Time__c;
    		if(compareField=='Name')
    			return position;
    		if(compareField=='port')
    			return port;
    		if(compareField=='transport')
    			return transport;
	        return getValue(obj,compareField);
    	}
    }
}