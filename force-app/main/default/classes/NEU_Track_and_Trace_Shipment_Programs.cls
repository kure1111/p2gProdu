public class NEU_Track_and_Trace_Shipment_Programs {

    private static String MarineAPi='168ea1c7d8cd4280eed12679b490aced0fdb6eaf';
    public decimal todaydays{get;set;}
    public boolean sacar_vessel_information{get;set;}
    public String external_url_to_upload_docuemnt{get;set;}
    public decimal longitud_ship_prog{get;set;}
    public decimal latitud_ship_prog{get;set;}
    public Vessel_Flight__c vessel_update_shipment{get;set;}
    public boolean force_vessel_information{get;set;}
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
    }
    public Decimal totaldays{get;set;}
    public class Status_s
    {
        public String stringstatus{get;set;}
        public String classstatus{get;set;}
        public String pngstatus{get;set;}
        public String classpngstatus{get;set;}
        public Integer colspanstatus{get;set;}
        public String classlocation{get;set;}
        public String stringlocation{get;set;}
    }
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
    public Integer[] milestonesType=new Integer[]{0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,0,0,0,0,0};
    public String[] milestonesXml=new String[]{'empty_pickup_','origin_pickup_','pol_arrival_','pol_loaded_','pol_vsldeparture_','tsp1_vslarrival_','tsp1_discharge_','tsp1_loaded_','tsp1_vsldeparture_','tsp2_vslarrival_','tsp2_discharge_','tsp2_loaded_','tsp2_vsldeparture_','tsp3_vslarrival_','tsp3_discharge_','tsp3_loaded_','tsp3_vsldeparture_','pod_vslarrival_','pod_discharge_','pod_departure_','dlv_delivery_','empty_return_'};
    public Integer[] milestonesPng=new Integer[]{1,2,3,4,5,6,7,8,9,6,7,8,9,6,7,8,9,10,11,12,13,14};
    public String[] milestonesName=new String[]{'Container empty to shipper','Container pickup at shipper','Container arrival at first POL','Container loaded at first POL','Vessel departure from first POL','Vessel arrival at T/S port 1','Container discharge at T/S port1','Container loaded at T/S port 1','Vessel departure from T/S 1','Vessel arrival at T/S port 2','Container discharge at T/S port 2','Container loaded at T/S port 2','Vessel departure from T/S 2','Vessel arrival at T/S port 3','Container discharge at T/S port 3','Container loaded at T/S port 3','Vessel departure from T/S port 3','Vessel arrival at final POD','Container discharge at final POD','Container departure from final POD','Container delivery to consignee','Container empty return to depot'};
    public String[] milestonesCode=new String[]{'CEP','CPS','CGI','CLL','VDL','VAT1','CDT1','CLT1','VDT1','VAT2','CDT2','CLT2','VDT2','VAT3','CDT3','CLT3','VDT3','VAD','CDD','CGO','CDC','CER'};
    public String[] milestonesNamet=new String[]{'Container empty to shipper','Container pickup at shipper','Container arrival at first POL','Container loaded at first POL','Truck departure from first POL','Truck arrival at T/S port 1','Container discharge at T/S port1','Container loaded at T/S port 1','Truck departure from T/S 1','Truck arrival at T/S port 2','Container discharge at T/S port 2','Container loaded at T/S port 2','Truck departure from T/S 2','Truck arrival at T/S port 3','Container discharge at T/S port 3','Container loaded at T/S port 3','Truck departure from T/S port 3','Truck arrival at final POD','Container discharge at final POD','Container departure from final POD','Container delivery to consignee','Container empty return to depot'};
    public String[] milestonesNamef=new String[]{'Container empty to shipper','Container pickup at shipper','Container arrival at first POL','Container loaded at first POL','Flight departure from first POL','Flight arrival at T/S port 1','Container discharge at T/S port1','Container loaded at T/S port 1','Flight departure from T/S 1','Flight arrival at T/S port 2','Container discharge at T/S port 2','Container loaded at T/S port 2','Flight departure from T/S 2','Flight arrival at T/S port 3','Container discharge at T/S port 3','Container loaded at T/S port 3','Flight departure from T/S port 3','Flight arrival at final POD','Container discharge at final POD','Container departure from final POD','Container delivery to consignee','Container empty return to depot'};

    public String[] stringstatus=new String[]{'Waiting for pick-up','Land transport to POL','In POL Terminal','Waiting for departure from POL','Ocean transport on vessel','In trans-shipment','Ocean transport on vessel','In trans-shipment','Ocean transport on vessel','In trans-shipment','Ocean transport on vessel','Waiting for discharge at final POD','In POD terminal','Land transport to place of delivery','Delivered; Returning container'};
    public String[] stringstatust=new String[]{'Waiting for pick-up','Land transport to POL','In POL Terminal','Waiting for departure from POL','Transport on truck','In trans-shipment','Transport on truck','In trans-shipment','Transport on truck','In trans-shipment','Transport on truck','Waiting for discharge at final POD','In POD terminal','Land transport to place of delivery','Delivered; Returning container'};
    public String[] stringstatusf=new String[]{'Waiting for pick-up','Land transport to POL','In POL Terminal','Waiting for departure from POL','Transport on flight','In trans-shipment','Transport on flight','In trans-shipment','Transport on flight','In trans-shipment','Transport on flight','Waiting for discharge at final POD','In POD terminal','Land transport to place of delivery','Delivered; Returning container'};
    public Integer[] statustype=new Integer[]{0,0,0,0,0,1,1,2,2,3,3,0,0,0,0};
    public String[] classlocation=new String[]{'line3 nobr','line3 nobr nobl','line3 nobl','line4','line4','line4','line4','line4','line4','line4','line4','line4','line3 nobr','line3 nobr nobl','line3 nobl'};
    public String[] stringlocation=new String[]{'Origin__c',null,'Port_Of_Loading__c',null,'Vessel_1__c','Port_of_Transshipment_1__c','Vessel_2__c','Port_of_Transshipment_2__c','Vessel_3__c','Port_of_Transshipment_3__c','Vessel_4__c',null,'Port_Of_Discharging__c',null,'Final_Discharge__c'};
    public String[] pngstatus=new String[]{'houses.png','truck.png','crane.png','ship1.png','ship2.png','load2.png','ship2.png','load2.png','ship2.png','load2.png','ship2.png','ship1.png','crane2.png','truck.png','houses2.png'};
    public String[] pngstatust=new String[]{'houses.png','truck.png','crane.png','truck.png','truck.png','load2.png','truck.png','load2.png','truck.png','load2.png','truck.png','truck.png','crane2.png','truck.png','houses2.png'};
    public String[] pngstatusf=new String[]{'houses.png','truck.png','crane.png','flight1.png','flight2.png','load2.png','flight2.png','load2.png','flight2.png','load2.png','flight2.png','flight1.png','crane2.png','truck.png','houses2.png'};
    public String[] classpngstatus=new String[]{'','',' textright',' textleft','','','','','','','',' textright',' textleft','',''};
    public Integer[] colspanstatus=new Integer[]{1,1,1,1,1,3,1,3,1,3,1,1,1,1,1};
    
    public List<Milestone_s> milestones{
        get
        {
            if(milestones==null)
            {
                totaldays=0;
                todaydays=0;
                milestones=new List<Milestone_s>();
                Integer i=0;
                Milestone_s lastmilestone=null;
                DateTime firstDate=null;
                DateTime lastDate=null;
                for(i=0;i<milestonesType.size();i++)
                {
                    if((milestonesType[i]==1)&&(!hasts1))
                        continue;
                    else if((milestonesType[i]==2)&&(!hasts2))
                        continue;
                    else if((milestonesType [i]==3)&&(!hasts3))
                        continue;
                    Milestone_s m=new Milestone_s();
                    m.position=i;
                    m.tstype=milestonesType[i];
                    m.png=milestonesPng[i];
                    m.steps=0;
                    m.dayFirst=0;
                    m.dayLast=0;
                    m.dayEvent=0;
                    m.dayEventDelay=0;
                    m.dayEventNoDelay=0;
                    if(lastmilestone!=null)
                        lastmilestone.steps++;
                    Event__c e=getEvent(milestonesXml[i],null);
                    if(e!=null)
                        if(e.Date_Time__c!=null)
                        {
                            m.mydate=e.Date_Time__c;
                            m.dateString=m.mydate.Date().Format();
                            m.plannedday=e.Planned_Date_Time__c;
                            lastmilestone=m;
                            if((firstDate==null)||(m.mydate<firstDate))
                                firstDate=m.mydate;
                            if((lastDate==null)||(m.mydate>lastDate))
                                lastDate=m.mydate;
                            if((firstDate==null)||(m.plannedday<firstDate))
                                firstDate=m.plannedday;
                            if((lastDate==null)||(m.plannedday>lastDate))
                                lastDate=m.plannedday;
                            milestones.add(m);
                        }
                    if(lastmilestone==null)
                    {
                        lastmilestone=new Milestone_s();
                        lastmilestone.position=i;
                        lastmilestone.tstype=-1;
                        lastmilestone.png=0;
                        lastmilestone.steps=0;
                        lastmilestone.dayFirst=0;
                        lastmilestone.dayLast=0;
                        lastmilestone.dayEvent=0;
                        lastmilestone.dayEventDelay=0;
                        lastmilestone.dayEventNoDelay=0;
                        lastmilestone.mydate=null;
                        lastmilestone.dateString=null;
                        lastmilestone.plannedday=null;
                        milestones.add(lastmilestone);
                    }
                }               
                if(lastmilestone!=null)
                    lastmilestone.steps++;
                if((firstDate!=null)&&(lastDate!=null))
                {
                    totaldays=(lastDate.getTime()-firstDate.getTime())/86400000L;
                    todaydays=(DateTime.now().getTime()-firstDate.getTime())/86400000L;
                }
                lastmilestone=null;
                for(Milestone_s m:milestones)
                {
                    if(m.mydate==null)
                        continue;
                    m.dayFirst=(m.mydate.getTime()-firstDate.getTime())/86400000L;
                    m.dayLast=m.dayFirst;
                    if(lastmilestone!=null)
                    {
                        lastmilestone.dayLast=m.dayFirst;
                        lastmilestone.dayEvent=lastmilestone.dayLast-lastmilestone.dayFirst;
                        if(lastmilestone.dayEvent<0)
                        {
                            lastmilestone.dayEvent=0;
                            lastmilestone.dayFirst=lastmilestone.dayLast;
                        }
                        if(m.plannedday!=null)
                        {
                            Decimal diff=(m.mydate.getTime()-m.plannedday.getTime())/86400000L;
                            if(diff>0)
                            {
                                lastmilestone.dayEvent-=diff;
                                if(lastmilestone.dayEvent<0)
                                {
                                    lastmilestone.dayFirst+=lastmilestone.dayEvent;
                                    lastmilestone.dayEvent=0;
                                }
                                lastmilestone.dayEventDelay=diff;
                            }
                            else if(diff<0)
                                lastmilestone.dayEventNoDelay=-diff;
                        }
                    }
                    lastmilestone=m;
                }
                if(totaldays==0)
                    totaldays=1;
            }
            return milestones;
        }
        set
        {
            milestones=value;
        }
    }
    
    public List<Status_s> processstatus
    {
        get
        {
            if(processstatus==null)
            {
                processstatus=new List<Status_s>();
                Integer i=0;
                Boolean odd=true;
                String[] mystringstatus=stringstatus;
                String[] mypngstatus=pngstatus;
                if(transportType==2)
                {
                    mystringstatus=stringstatust;
                    mypngstatus=pngstatust;
                }
                else if(transportType==3)
                {
                    mystringstatus=stringstatusf;
                    mypngstatus=pngstatusf;
                }
                for(i=0;i<statustype.size();i++)
                {
                    system.debug('i='+i);
                    if((statustype[i]==1)&&(!hasts1))
                        continue;
                    else if((statustype[i]==2)&&(!hasts2))
                        continue;
                    else if((statustype[i]==3)&&(!hasts3))
                        continue;
                    
                    Status_s s=new Status_s();
                    s.stringstatus=mystringstatus[i];
                    if(odd)
                    {
                        odd=false;
                        s.classstatus='line1';
                    }
                    else
                    {
                        odd=true;
                        s.classstatus='line2';
                    }
                    s.pngstatus=mypngstatus[i];
                    s.classpngstatus=classpngstatus[i];
                    s.colspanstatus=colspanstatus[i];
                    s.classlocation=classlocation[i];
                    if(String.IsNotEmpty(stringlocation[i]))
                        s.stringlocation=(String)record.get(stringlocation[i]);
                    processstatus.add(s);
                }               
            }
            return processstatus;
        }
        set
        {
            processstatus=value;
        }
    }
    
    //actualizar el vessel cuando no tengo numero de contenedor
    
  public PageReference updatevessel()
  {
    if(record.Vessel__c != null)
    {
        if(String.IsNotEmpty(record.Vessel__r.IMO__c))
        {
          getByIMO(record.Vessel__r.IMO__c,0);
        }
        else if(String.IsNotEmpty(record.Vessel__r.MMSI__c))
        {
          getByIMO(record.Vessel__r.MMSI__c,1);
        }
        else if(String.IsNotEmpty(record.Vessel__r.Name))
        {
          getByIMO(record.Vessel__r.Name,2);
        }
    }
    return null;
  }
  
   public boolean getByIMO(String name,Integer searchtype)
  {
      String Vessel_Information='';
      boolean makeupdate=false;
      vessel_update_shipment = record.Vessel__r;
      //search in Ocean Insights
      {
        String url_position;
        url_position='http://capi.ocean-insights.com/vesseltracking/v1/lookup/?search='+EncodingUtil.urlEncode(name, 'UTF-8');
        String username = NEU_Settings.OIuser;
        String password = NEU_Settings.OIpass;
        Http h = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setTimeout(100000);
        req.setEndpoint(url_position); 
        req.setMethod('GET');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept','application/xml');
        try
        {
              Dom.Document doc2 = new Dom.Document();
              if (!Test.isRunningTest())
                  doc2 = h.send(req).getBodyDocument();
              else
              {
                 string body_test_position = '';
                 body_test_position +='<root><list-item><shipid_oi>112034</shipid_oi><mmsi>354141000</mmsi><imo>9520900</imo><shipname>TEN YU MARU</shipname><flag_iso2>PA</flag_iso2><callsign>3FKB</callsign><length>190</length><width>32</width><position><received>2015-11-06T06:06+0000</received><latitude>14.3906333333</latitude><longitude>-96.686815</longitude><speed_over_ground>11.3</speed_over_ground><true_heading>111</true_heading><rate_of_turn>0</rate_of_turn></position><voyage><received>2015-10-30T06:23+0000</received><destination>PA BLB</destination><eta>2015-11-10T20:00+0000</eta><draught>10.6</draught></voyage><scheduled_arrival><port_name>Panama City (Balboa)</port_name><port_locode>PABLB</port_locode><eta>2015-11-10T20:00+0000</eta><updated>2015-10-30T06:23+0000</updated></scheduled_arrival></list-item></root>';
                 doc2.load(body_test_position);  
              }
               
              Dom.XMLNode Envelope2 = doc2.getRootElement();
              for(Dom.XMLNode child : Envelope2.getChildElements()) 
              {
                if(child.getName()=='list-item')
                {
                  String DestinationPort='';
                  DatetIme DestinationETA=null;
                   for(Dom.XMLNode d : child.getChildElements())
                   {
                     if(d.getName()=='mmsi')
                     {
                       if(String.IsEmpty(vessel_update_shipment.Mmsi__c))
                         vessel_update_shipment.Mmsi__c=d.getText();
                      Vessel_Information+='MMSI: '+d.getText()+' |';
                     }
                     else if(d.getName()=='imo')
                     {
                       if(String.IsEmpty(vessel_update_shipment.Imo__c))
                         vessel_update_shipment.Imo__c=d.getText();
                      Vessel_Information+='IMO: '+d.getText()+' |';
                     }
                     else if(d.getName()=='shipname')
                     {
                       if(String.IsEmpty(vessel_update_shipment.Name))
                         vessel_update_shipment.Name=d.getText();
                      Vessel_Information+='Vessel: '+d.getText()+' |';
                     }
                     else if(d.getName()=='position')
                     {
                       for(Dom.XMLNode p:d.getChildElements())
                       {
                         if(p.getName()=='received')
                         {
                           try{
                                vessel_update_shipment.Last_Update__c=DateTime.newInstance((((DateTime)JSON.deserialize('"'+p.getText().replace(' ','T')+ '"',DateTime.class))).getTime());
                                Vessel_Information+='Detection Time: '+vessel_update_shipment.Last_Update__c.format()+' |';
                           }
                           catch(Exception e){}
                         }
                         else if(p.getName()=='latitude')
                         {
                           try{
                                vessel_update_shipment.Vessel_Latitude__c=Double.valueOf(p.getText());
                           }
                           catch(Exception e){}
                         }
                         else if(p.getName()=='longitude')
                         {
                             try{
                                vessel_update_shipment.Vessel_Longitude__c=Double.valueOf(p.getText());
                            }
                            catch(Exception e){}
                         }
                         else if(p.getName()=='speed_over_ground')
                         {
                            Vessel_Information+='Speed: '+p.getText()+' km |';
                            try{
                              vessel_update_shipment.Vessel_Speed__c=Double.valueOf(p.getText());
                            }
                            catch(Exception e){}
                         }
                         else if(p.getName()=='true_heading')
                         {
                            Vessel_Information+='Course: '+p.getText()+' |';
                            try{
                                 vessel_update_shipment.Vessel_Course__c=Double.valueOf(p.getText());
                            }
                            catch(Exception e){}
                         }
                       }
                     }
                     else if(d.getName()=='voyage')
                     {
                       for(Dom.XMLNode p:d.getChildElements())
                       {
                         if(p.getName()=='destination')
                         {
                           if(String.IsEmpty(DestinationPort))
                             DestinationPort=p.getText();
                         }
                         else if(p.getName()=='eta')
                         {
                           try{
                             if(DestinationETA!=null)
                                DestinationETA=DateTime.newInstance((((DateTime)JSON.deserialize('"'+p.getText().replace(' ','T')+ '"',DateTime.class))).getTime());
                           }
                           catch(Exception e){}
                         }
                       }
                     }
                     else if(d.getName()=='scheduled_arrival')
                     {
                       for(Dom.XMLNode p:d.getChildElements())
                       {
                         if(p.getName()=='port_name')
                         {
                           DestinationPort=p.getText();
                         }
                         else if(p.getName()=='eta')
                         {
                           try{
                            DestinationETA=DateTime.newInstance((((DateTime)JSON.deserialize('"'+p.getText().replace(' ','T')+ '"',DateTime.class))).getTime());
                           }
                           catch(Exception e){}
                         }
                       }
                     }
                   }
                   if(DestinationETA!=null)
                   {
                      Vessel_Information+='ETA: '+DestinationETA.format()+' |';
                      vessel_update_shipment.Vessel_Flight_ETA_Point_of_Discharge__c=DestinationETA.Date();
                   }
                   if(String.IsNotEmpty(DestinationPort))
                   {
                       Vessel_Information+='Destination Port: '+DestinationPort+' |';
                   }
                   if(String.IsNotEmpty(Vessel_Information))
                   {
                     makeupdate=true;
                     Vessel_Information2  = '';
                     Vessel_Information2 =Vessel_Information;
                     vessel_update_shipment.Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
                    }
                   break;
                }
              } 
        }
        catch(Exception e){}
        if(makeupdate)
        {
          update vessel_update_shipment;
          // Vessel_Information=Vessel_Information.replace(' |','\r\n');
           //Vessel_Information2 =vessel_update_shipment.Vessel_Information__c.replace(' |','\r\n');
           if(!Test.isRunningTest())
          return true;
        }
      }
      if((!makeupdate)||Test.isRunningTest())
      {
        //search in shipfinder
        String url_imo;
        if(searchtype==0)
          url_imo = 'http://www.shipfinder.com/Monitor/GETIHSData?imo='+EncodingUtil.urlEncode(name, 'UTF-8');
        else if(searchtype==1)
          url_imo = 'http://www.shipfinder.com/Monitor/GETIHSData?mmsi='+EncodingUtil.urlEncode(name, 'UTF-8');
        else if(searchtype==2)
          url_imo = 'http://www.shipfinder.com/Monitor/GETIHSData?shipname='+EncodingUtil.urlEncode(name, 'UTF-8');
        Http h2 = new Http(); 
        HttpRequest req2 = new HttpRequest();
        req2.setTimeout(100000);
        req2.setEndpoint(url_imo); 
        req2.setMethod('GET');
        String query_mmsi_Number='';
        if (Test.isRunningTest())
          query_mmsi_Number='{"Status":3,"Message":"no login,only get free","Data":[{"imo":"9635640","shipname":"MAERSK ELGIN","mmsi":"636015859","CallSign":"D5DE9","ShipType":"Container Ship (Fully Cellular)","FlagCountry":"Liberia","BuildDate":"2013/01","GT":"71112","NT":"-1","DWT":"80163","RegisteredOwner":"-1","Class":"-1","PandIClub":"-1","MouldLength":"270","MouldWidth":"0","Depth":"24.8","CargoCapacity":"-1","ShipPhone":"-1","HatchNum":"-1","GearHave":"-1","Pump":"-1","Propeller":"-1","Thruster":"-1","MainBHP":"-1","BulbousBow":"-1","PSCTime":"-1","Location":"-1","DefectsNum":"-1","UpdateDate":"2014-08-05"}]}';
        else
          try{
            query_mmsi_Number = h2.send(req2).getBody();
          }
          catch(Exception e){}
        JSONParser parser = JSON.createParser(query_mmsi_Number);
        while (parser.nextToken() != null)
        {
              if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('mmsi')))
              {
                        parser.nextToken();
                        vessel_update_shipment.Mmsi__c=parser.getText();
                        makeupdate=true;
                        if(searchtype==2)
                        {
                          searchtype=1;
                          name=vessel_update_shipment.Mmsi__c;
                        }
              }
              if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('shipname')))
              {
                        parser.nextToken();
                        vessel_update_shipment.Vessel_Train_Truck__c=parser.getText();
                        makeupdate=true;
              }
              if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('imo')))
              {
                        parser.nextToken();
                        vessel_update_shipment.IMO__c = parser.getText();
                        makeupdate=true;
                        if(searchtype==2)
                        {
                          searchtype=0;
                          name=vessel_update_shipment.IMO__c;
                        }
              }
          }
      }
      if(!makeupdate || Test.isRunningTest())
      {
        String url_imo = 'https://www.vesselfinder.com/vessels/livesearch?term='+EncodingUtil.urlEncode(name, 'UTF-8');
        Http h2 = new Http(); 
        HttpRequest req2 = new HttpRequest();
        req2.setTimeout(100000);
        req2.setEndpoint(url_imo); 
        req2.setMethod('GET');
        String query_mmsi_Number='';
        if (Test.isRunningTest())
          query_mmsi_Number='{"n":"9982ca3c3c","list":[{"mmsi":"636015859","name":"MAERSK ELGIN","INRANGE":"1","DEST":" ALGECIRAS","ETATSTAMP":"1410055200","imo":"9635640","valid_imo":"1","ll":"0"}]}';
        else
          try{
            query_mmsi_Number = h2.send(req2).getBody();
          }
          catch(Exception e){}
        JSONParser parser = JSON.createParser(query_mmsi_Number);
        while (parser.nextToken() != null)
        {
          if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('mmsi')))
          {
                    parser.nextToken();
                    vessel_update_shipment.Mmsi__c=parser.getText();
                    makeupdate=true;
                    if(searchtype==2)
                    {
                      searchtype=1;
                      name=record.Mmsi__c;
                    }
            }
          if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('name')))
          {
                    parser.nextToken();
                    vessel_update_shipment.Vessel_Train_Truck__c=parser.getText();
                    makeupdate=true;
            }
          if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('imo')))
          {
                    parser.nextToken();
                    vessel_update_shipment.IMO__c=parser.getText();
                    makeupdate=true;
                    if(searchtype==2)
                    {
                      searchtype=0;
                      name=vessel_update_shipment.IMO__c;
                    }
            }
            }
      }
      if(makeupdate)
      {
        vessel_update_shipment.Vessel_Information__c=null;
        vessel_update_shipment.Vessel_Latitude__c=null;
        vessel_update_shipment.Vessel_Longitude__c=null;
        vessel_update_shipment.Vessel_Speed__c=null;
        vessel_update_shipment.Vessel_Course__c=null;
      }
      if(searchtype!=2)
      {
        String url_position;
        if(searchtype==0)
          url_position='http://services.marinetraffic.com/api/exportvessel/'+MarineApi+'/timespan:60/protocol:xml/msgtype:extended/imo:'+EncodingUtil.urlEncode(name, 'UTF-8');
        else if(searchtype==1)
          url_position='http://services.marinetraffic.com/api/exportvessel/'+MarineApi+'/timespan:60/protocol:xml/msgtype:extended/mmsi:'+EncodingUtil.urlEncode(name, 'UTF-8');
        Http h3 = new Http(); 
        HttpRequest req3 = new HttpRequest();
        req3.setTimeout(100000);
        req3.setEndpoint(url_position); 
        req3.setMethod('GET');
        try
        {
               Dom.Document doc2 = new Dom.Document();
               if (!Test.isRunningTest())
                  doc2 = h3.send(req3).getBodyDocument();
               else
               {
                 string body_test_position = '';
                 body_test_position +='<pos>';
                 body_test_position +='<row MMSI="205623000" LAT="37.24538" LON="25.590981" SPEED="65" COURSE="288" TIMESTAMP="2012-04-18T19:21:00" SHIPNAME="MALACHITE" SHIPTYPE="70" IMO="9549645" CALLSIGN="ONHL" FLAG="BE" LAST_PORT="PORT SAID" LAST_PORT_TIME="2012-04-16T18:26:00" DESTINATION="DERINCE" ETA="2012-04-20T14:00:00" LENGTH="90" WIDTH="14" DRAUGHT="50" GRT="3517" DWT="5000" YEAR_BUILT="2012"/>';
                 body_test_position +='</pos>';
                 doc2.load(body_test_position);  
               }
               
               Dom.XMLNode Envelope2 = doc2.getRootElement();
               for(Dom.XMLNode child : Envelope2.getChildElements()) 
               {
                    String latitud = child.getAttribute('LAT', '');
                    try{
                      vessel_update_shipment.Vessel_Latitude__c=Double.valueOf(latitud);
                    }
                    catch(Exception e)
                    {
                        vessel_update_shipment.Vessel_Latitude__c=null;
                    }
                    String longitud = child.getAttribute('LON', '');
                    try{
                      vessel_update_shipment.Vessel_Longitude__c=Double.valueOf(longitud);
                    }
                    catch(Exception e)
                    {
                      vessel_update_shipment.Vessel_Longitude__c=null;
                    }
                    Vessel_Information='';
                    Vessel_Information+='Last Update: '+system.today()+' |';
                    String shipname = child.getAttribute('SHIPNAME', '');
                    if(String.IsNotEmpty(shipname))
                      Vessel_Information+='Vessel: '+shipname+' |';
                    String speed = child.getAttribute('SPEED', '');
                    if(String.IsNotEmpty(speed))
                    {
                      try{
                        vessel_update_shipment.Vessel_Speed__c=Double.valueOf(speed);
                        Vessel_Information+='Speed: '+String.valueOf(vessel_update_shipment.Vessel_Speed__c)+'\r\n';
                      }
                      catch(Exception e)
                      {
                        vessel_update_shipment.Vessel_Speed__c=null;
                      }
                    }
                    String timestamp = child.getAttribute('TIMESTAMP', '');
                    if(String.IsNotEmpty(timestamp))
                      Vessel_Information+='Time: '+timestamp+' |';
                    String flag = child.getAttribute('FLAG', '');
                    if(String.IsNotEmpty(flag))
                      Vessel_Information+='Flag: '+flag+' |';
                    String last_port = child.getAttribute('LAST_PORT', '');
                    if(String.IsNotEmpty(last_port))
                      Vessel_Information+='Last Port: '+last_port+' |';
                    String last_port_time = child.getAttribute('LAST_PORT_TIME', '');
                    if(String.IsNotEmpty(last_port_time))
                      Vessel_Information+='Last Port Time: '+last_port_time+' |';
                    String destination = child.getAttribute('DESTINATION', '');
                    if(String.IsNotEmpty(destination))
                      Vessel_Information+='Detination: '+destination+' |';
                    String ETA = child.getAttribute('ETA', '');
                    if(String.IsNotEmpty(ETA))
                      Vessel_Information+='ETA: '+ETA+' |';
                    String course = child.getAttribute('COURSE', '');
                    if(String.IsNotEmpty(course))
                    {
                      try{
                        vessel_update_shipment.Vessel_Course__c=Double.valueOf(course);
                        Vessel_Information+='Course: '+String.valueOf(vessel_update_shipment.Vessel_Course__c)+' |';
                      }
                      catch(Exception e)
                      {
                        vessel_update_shipment.Vessel_Course__c=null;
                      }
                    }
                    Vessel_Information2  = '';
                    Vessel_Information2 =Vessel_Information;//.replace(' |','\r\n');
                    vessel_update_shipment.Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
                    vessel_update_shipment.MMSI__c = child.getAttribute('MMSI', '');
                    vessel_update_shipment.IMO__c = child.getAttribute('IMO', '');
                    vessel_update_shipment.Vessel_Train_Truck__c = shipname;
                    vessel_update_shipment.Last_Update__c = system.today();
                    makeupdate=true;
              }
        }
        catch(Exception e){}
        if(vessel_update_shipment.Vessel_Latitude__c==null || Test.isRunningTest())
        {
          //try vessel finder
          String url_imo;
          if(searchtype==0)
            url_imo='https://www.vesselfinder.com/?imo='+EncodingUtil.urlEncode(name, 'UTF-8');
          else if(searchtype==1)
            url_imo='https://www.vesselfinder.com/?mmsi='+EncodingUtil.urlEncode(name, 'UTF-8');
          Http h2 = new Http(); 
          HttpRequest req2 = new HttpRequest();
          req2.setTimeout(100000);
          req2.setEndpoint(url_imo); 
          req2.setMethod('GET');
          String query_mmsi_Number='';
          if (Test.isRunningTest())
                query_mmsi_Number='var mo={mmsi:253298000,update_info:false, auto_track:true,latitude:30.282183333333,longitude:32.444093333333,zoom:9,g1:0,g2:0,}<span data-ts="1444374159" id="last_report" title="Last report" style="color:#ff0000">Oct 09, 2015 07:02 UTC</span>';
          else
            try{
              query_mmsi_Number = h2.send(req2).getBody();
            }
            catch(Exception e){}
            Integer pos=query_mmsi_Number.indexOf('var mo={');
          if(pos>=0)
          {
                query_mmsi_Number=query_mmsi_Number.substring(pos+8);
                pos=query_mmsi_Number.indexOf('latitude:');
                if(pos>=0)
                {
                      String latitude='';
                      Boolean hasdot=false;
                      Boolean hassign=false;
                      for(pos=pos+9;pos<query_mmsi_Number.length();pos++)
                      {
                            String nextc=query_mmsi_Number.substring(pos,pos+1);
                            if((!hassign)&&((nextc.equals('-'))||(nextc.equals('+'))))
                                latitude+=nextc;
                            else if((!hasdot)&&nextc.equals('.'))
                            {
                                hasdot=true;
                                latitude+=nextc;
                            }
                            else if((nextc.compareTo('0')>=0)&&(nextc.compareTo('9')<=0))
                                latitude+=nextc;
                            else
                                break;
                            hassign=true;
                      }
                      if(String.IsNotEmpty(latitude))
                            try{
                                  vessel_update_shipment.Vessel_Latitude__c=Double.valueOf(latitude);
                                  makeupdate=true;
                            }
                            catch(Exception e){}
                }
                pos=query_mmsi_Number.indexOf('longitude:');
                if(pos>=0)
                {
                      String longitude='';
                      Boolean hasdot=false;
                      Boolean hassign=false;
                      for(pos=pos+10;pos<query_mmsi_Number.length();pos++)
                      {
                        String nextc=query_mmsi_Number.substring(pos,pos+1);
                        if((!hassign)&&((nextc.equals('-'))||(nextc.equals('+'))))
                            longitude+=nextc;
                        else if((!hasdot)&&nextc.equals('.'))
                        {
                            hasdot=true;
                            longitude+=nextc;
                        }
                        else if((nextc.compareTo('0')>=0)&&(nextc.compareTo('9')<=0))
                            longitude+=nextc;
                        else
                            break;
                        hassign=true;
                      }
                      if(String.IsNotEmpty(longitude))
                            try{
                              vessel_update_shipment.Vessel_Longitude__c=Double.valueOf(longitude);
                              makeupdate=true;
                            }
                            catch(Exception e){}
                }
              }
            }
            if((vessel_update_shipment.Vessel_Information__c==null)&&(String.IsNotEmpty(vessel_update_shipment.Vessel_Train_Truck__c)))
            {
                  makeupdate=true;
                  Vessel_Information='Vessel: '+vessel_update_shipment.Vessel_Train_Truck__c+' |';
                  Vessel_Information2  = '';
                  Vessel_Information2 =Vessel_Information;//.replace(' |','\r\n');
                  vessel_update_shipment.Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
            }
      }
      if(makeupdate)
      {
        try{
          update vessel_update_shipment;
          
            Vessel_Information=Vessel_Information.replace(' |','\r\n');
            //Vessel_Information2 =vessel_update_shipment.Vessel_Information__c.replace(' |','\r\n');
        }
        catch(Exception e){}
      }
      return makeupdate;
  }

  
  
//----------------------------------------
    public Shipment_Program__c record;

    private string operators_selected='';
    private string operators_selectedv1='';
    private string track='';
    private string carrier='';
    public List<SelectOption> operators = null;

    public String no_encontrado {get;set;}
    public String Number_con_book {get;set;}
    private string trackoptions_selected='';
    public List<SelectOption> trackoptions = null;
    private List<NEU_JE_TrackAndTrace_s> TrackAndTrace = null;

    public String Bl_no {get; set;}
    public String Booking_no {get; set;}
    public String Container_no {get; set;}
    public String Container_type {get; set;}
    public String Operator {get; set;}
    public String SCAC_Carrier_Code {get; set;}
    public String Source {get; set;}
    public String Status {get; set;}
    public String Weight {get; set;}
    
    public String Vessel_Information{get;set;}
    public String Vessel_Information2{get;set;}
    public String Vessel_Activities{get;set;}
    
    public String Vessel_Name{get;set;}
    public String Imo_Number{get;set;}
    public String MMSI{get;set;}
    
    public Boolean hasTs1{get;set;}
    public Boolean hasTs2{get;set;}
    public Boolean hasTs3{get;set;}
    
   public List<Event__c>events{
        get
        {
            if(events==null)
                events=[select Id,Name,Event__c,Shipment__c,Detected_Date_Time__c,Initial_Planned_Date_Time__c,Notified_Date_Time__c,Planned_Date_Time__c,Date_Time__c,Previous_Event_Code__c,Days_from_Previous_Event__c,Flight_Number__c,Departure_IATA_Code__c,Arrival_IATA_Code__c,Additional_Information__c,Weight_kg__c,Number_of_Pieces__c,Shipments_Program__c  from Event__c where Shipments_Program__c =:record.Id order by Date_Time__c asc];
            return events;
        }
        set
        {
            events=value;
        }
    }
    public String getoperators_selected() 
    {
        if(operators==null)
            getoperators();
       return operators_selected;
    }
            
    public void setoperators_selected(String operators_selected)
    {
        this.operators_selected = operators_selected;
    }
    
    public List<SelectOption> getoperators()
    {
        if(operators==null)
        {
             operators = new List<SelectOption>();
             operators.add(new SelectOption('0', '-- Select Carrier --'));
             
             Schema.DescribeFieldResult fieldResult = Shipment__c.Carriers_value_OI__c.getDescribe();
             List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
             for( Schema.PicklistEntry f : ple)
             {
                string[] id_operador = f.getValue().split('_');
                operators.add(new SelectOption(id_operador[1],id_operador[0]));
                if(record.Carrier_OI__c == id_operador[0])
                    operators_selected = id_operador[1];
             }
        }
        return operators; 
    }
    
    public Boolean setEvent(Dom.XMLNode eventXML,List<Event__c>newevents)
    {
        String eventName=eventXML.getName();
        System.Debug('Event name='+eventName);
        if((!eventName.endsWith('_actual'))
            &&(!eventName.endsWith('_detected'))
            &&(!eventName.endsWith('_planned_initial'))
            &&(!eventName.endsWith('_planned_last')))
            return false;
        DateTime eventDateTime=null;
        try{
            System.Debug('Deserialize='+eventXML.getText());
            eventDateTime=DateTime.newInstance(((DateTime)JSON.deserialize('"'+eventXML.getText()+ '"',DateTime.class)).getTime());
            System.Debug('Deserialize res='+eventDateTime.format());
        }
        catch(Exception ex){}
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
    public Event__c getEvent(String eventName,List<Event__c>newevents)
    {
        System.debug('Event='+eventName);
        String eventType=null;
        String eventCode=null;
        String[] mymilestonesName=milestonesName;
        if(transportType==2)
            mymilestonesName=milestonesNamet;
        else if(transportType==3)
            mymilestonesName=milestonesNamef;
        for(Integer s=0;s<milestonesXml.size();s++)
            if(eventName.startsWith(milestonesXml[s]))
            {
                eventType=mymilestonesName[s];
                eventCode=milestonesCode[s];
                break;
            }
        if(eventType==null)
            return null;
        System.debug('Event detected='+eventType);
       for(Event__c e:events)
            if(e.Event__c==eventType)
                return e;
        if(newevents==null)
            return null;
        for(Event__c e:newevents)
            if(e.Event__c==eventType)
                return e;
        Event__c ret=new Event__c();
        ret.Name=EventCode;
        ret.Shipments_Program__c=record.Id;
        ret.Event__c=eventType;
        newevents.add(ret);
        return ret;
    }
    public String gettrackoptions_selected() 
    {
       return trackoptions_selected;
    }
            
    public void settrackoptions_selected(String trackoptions_selected)
    {
        this.trackoptions_selected = trackoptions_selected;
    }
    
    public List<SelectOption> gettrackoptions()
    {
        
         trackoptions = new List<SelectOption>();
         trackoptions.add(new SelectOption('0', '-- Select Track Options --'));
         
         Schema.DescribeFieldResult fieldResult = Shipment__c.TrackOptions_Value__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         string[] id_trackoption = new string[1];
         for( Schema.PicklistEntry f : ple)
         {
            id_trackoption = f.getValue().split('&');
            trackoptions.add(new SelectOption(id_trackoption[1],id_trackoption[0]));
            
            if(record.Track_Option__c == id_trackoption[0])
                trackoptions_selected = id_trackoption[1];
         }
                
        return trackoptions; 
    }
    
    
    ApexPages.StandardController con=null;
    public NEU_Track_and_Trace_Shipment_Programs(ApexPages.StandardController stdController) 
    {
         if (!Test.isRunningTest()) {
            stdController.AddFields(new String[]
            {
                'Id',
                'Name',
                'Number__c',
                'Truck_Vessel_Longitude__c',
                'Vessel__c',
                'Vessel__r.Name',
                'Vessel__r.Vessel_Information__c',
                'Carrier_OI__c',
                'Vessel_Information__c',
                'Vessel_Activities__c',
                'Vessel_Name__c',
                'Imo_Number__c',
                'MMSI__c',
                'Port_of_Transshipment_1__c',
                'Port_of_Transshipment_2__c',
                'Port_of_Transshipment_3__c',
                'Track_Option__c',
                'External_Reference_OI__c',
                'Vessel__r.IMO__c',
                'Vessel__r.MMSI__c',
                'Vessel__r.Last_Update__c',
                'Vessel__r.Vessel_Latitude__c',
                'Vessel__r.Vessel_Longitude__c',
                'Vessel__r.Vessel_Speed__c',                
                'Vessel__r.Vessel_Course__c',
                'Freight_Mode__c',
                'Vessel__r.Vessel_Flight_ETA_Point_of_Discharge__c',
                'Vessel__r.Vessel_Information__c', 
                'Vessel__r.Vessel_Course__c', 
                'Origin__c', 
                'Origin_Code__c',
                'Final_Discharge__c',
                'Final_Discharge_Code__c', 
                'Port_Of_Loading_Code__c',
                'Port_Of_Loading__c',
                'Port_Of_Discharging__c',
                'Port_Of_Discharging_Code__c',
                'Port_of_Transshipment_Code_1__c', 
                'Port_of_Transshipment_Code_2__c',
                'Port_of_Transshipment_Code_3__c', 
                'Vessel_1__c',
                'Vessel_2__c',
                'Vessel_3__c',
                'Vessel_4__c',
                'Vessel_Imo_1__c', 
                'Vessel_Imo_2__c',
                'Vessel_Imo_3__c', 
                'Vessel_Imo_4__c',
                'Truck_Vessel_Latitude__c',
                'Planned_ETA__c',
                'Vessel_Course__c',
                'ETD__c',
                'ETA_ATA__c',
                'ATAPOD__c', 
                'Last_Activity__c',
                'Location_Code__c', 
                'Location__c', 
                'Voyage_Number__c',
                'Date__c',
                'Vessel_Speed__c',
                'Truck_Number__c',
                'Flight_Number__c',
                'Route_Country_of_Load__c',
                'Route_Country_of_Discharge__c',
                'Route_State_of_Load__c',
                'Route_State_of_Discharge__c',
                'Route_Site_of_Load__c',
                'Route_Site_of_Discharge__c',
                'OI_Status__c',
                'OI_Status_Code__c'
            });
         }      
         
        
        con=stdController;
        updateAllData();
        gettrackoptions();
          
         getoperators();
         latitud_ship_prog = 0;
         if(record.Truck_Vessel_Latitude__c != null)
             latitud_ship_prog = record.Truck_Vessel_Latitude__c;
          
         longitud_ship_prog= 0;
         if(record.Truck_Vessel_Longitude__c!= null)
             longitud_ship_prog= record.Truck_Vessel_Longitude__c;   
          
    }
    public void updateAllData()
    {
        record=(Shipment_Program__c)con.getRecord();
        System.Debug('Id='+record.Id);
        sacar_vessel_information = true;
        force_vessel_information=false;
        Vessel_Information2  = '';
        Number_con_book = '';
        
        if(record.Number__c != null)
        {
            Number_con_book = record.Number__c;
            
        }  
        
        if(String.IsNotEMpty(record.Port_Of_Loading_Code__c)||String.IsNotEMpty(record.Port_Of_Discharging_Code__c))  
        {
            sacar_vessel_information = false;
        } 
        else//si voy a sacar el vessel lo relleno
        {
            vessel_update_shipment = record.Vessel__r;
            if(record.Vessel__c != null && record.Vessel__r.Vessel_Information__c != null)
                Vessel_Information2 +=record.Vessel__r.Vessel_Information__c.replace('\r\n',' |').replace('\n',' |');
        }
        getoperators();
        Vessel_Information=record.Vessel_Information__c;
        if(String.IsNotEmpty(Vessel_Information))
            Vessel_Information=Vessel_Information.replace('\r\n',' |').replace('\n',' |');
       
        Vessel_Activities=record.Vessel_Activities__c;
        if(String.IsNotEmpty(Vessel_Activities))
            Vessel_Activities=Vessel_Activities.replace('\r\n',' |').replace('\n',' |');
        Vessel_Name=record.Vessel_Name__c;
        Imo_Number=record.Imo_Number__c;
        MMSI=record.MMSI__c;
        hasts1=String.IsNotEmpty(record.Port_of_Transshipment_1__c);
        hasts2=String.IsNotEmpty(record.Port_of_Transshipment_2__c);
        hasts3=String.IsNotEmpty(record.Port_of_Transshipment_3__c);
        
        //conseguir la url externa 
        CSH_Supplier_Request__c sr = CSH_Supplier_Request__c.getInstance(userinfo.getuserid());
        if(sr == null)
        {
          sr = CSH_Supplier_Request__c.getInstance(userinfo.getProfileId());
          if(sr == null)
              sr = CSH_Supplier_Request__c.getOrgDefaults();
        }
        
        external_url_to_upload_docuemnt =null;
        Boolean useExternal=false;
        if(sr!=null)
        {
          external_url_to_upload_docuemnt=sr.Default_External_URL__c;
          useExternal=sr.Use_External_Url__c;
        }
        
        if(String.IsEmpty(external_url_to_upload_docuemnt)||(!useExternal))
          external_url_to_upload_docuemnt='http://'+ApexPages.currentPage().getHeaders().get('Host')+'/';
    }
    
   public List<NEU_JE_TrackAndTrace_s> getTrackAndTrace()
    {
       return TrackAndTrace;
    }   
    
    public void showVesselInformation()
    {
      force_vessel_information=true;
      updatevessel();
    }
    public void updateGraph()
    {
        milestones=null;
        processstatus=null;
        events=null;
        con.reset();
        updateAllData();
    }
    public class VesselInfo
    {
        public String imo=null;
        public String Name=null;
        public Decimal Latitude=-1; 
        public Decimal Longitude=-1;
        public Decimal Course=-1; 
        public Decimal Speed=-1; 
        public String nextPort=null;
        public string mssi=null;
        public DateTime ETA=null;
        public DateTime mytime=null;
        public String Information=null;
    }
    public VesselInfo getByVesselFinder(String myimo)
    {
        String url_imo='https://www.vesselfinder.com/?imo='+EncodingUtil.urlEncode(myimo,'UTF-8');
        Http h2 = new Http(); 
        HttpRequest req2 = new HttpRequest();
        req2.setTimeout(100000);
        req2.setEndpoint(url_imo); 
        req2.setMethod('GET');
        String query_mmsi_Number='';
        if (Test.isRunningTest())
            query_mmsi_Number='var mo={mmsi:253298000,update_info:false, auto_track:true,latitude:30.282183333333,longitude:32.444093333333,zoom:9,g1:0,g2:0,}<span data-ts="1444374159" id="last_report" title="Last report" style="color:#ff0000">Oct 09, 2015 07:02 UTC</span>';
        else
            try{
                query_mmsi_Number = h2.send(req2).getBody();
            }
            catch(Exception e)
            {
                return null;
            }
        Integer pos=query_mmsi_Number.indexOf('var mo={');
        if(pos>=0)
        {
            VesselInfo info=new VesselInfo();
            info.imo=myimo;
            info.Information='';
            String varMo=query_mmsi_Number.substring(pos+8);
            pos=varMo.indexOf('latitude:');
            if(pos>=0)
            {
                String latitude='';
                Boolean hasdot=false;
                Boolean hassign=false;
                for(pos=pos+9;pos<varMo.length();pos++)
                {
                    String nextc=varMo.substring(pos,pos+1);
                    if((!hassign)&&((nextc.equals('-'))||(nextc.equals('+'))))
                        latitude+=nextc;
                    else if((!hasdot)&&nextc.equals('.'))
                    {
                        hasdot=true;
                        latitude+=nextc;
                    }
                    else if((nextc.compareTo('0')>=0)&&(nextc.compareTo('9')<=0))
                        latitude+=nextc;
                    else
                        break;
                    hassign=true;
                }
                if(String.IsNotEmpty(latitude))
                    try{
                        info.latitude=Double.valueOf(latitude);
                    }
                    catch(Exception e){}
            }
            pos=varMo.indexOf('longitude:');
            if(pos>=0)
            {
                String longitude='';
                Boolean hasdot=false;
                Boolean hassign=false;
                for(pos=pos+10;pos<varMo.length();pos++)
                {
                    String nextc=varMo.substring(pos,pos+1);
                    if((!hassign)&&((nextc.equals('-'))||(nextc.equals('+'))))
                        longitude+=nextc;
                    else if((!hasdot)&&nextc.equals('.'))
                    {
                        hasdot=true;
                        longitude+=nextc;
                    }
                    else if((nextc.compareTo('0')>=0)&&(nextc.compareTo('9')<=0))
                        longitude+=nextc;
                    else
                        break;
                    hassign=true;
                }
                if(String.IsNotEmpty(longitude))
                    try{
                        info.longitude=Double.valueOf(longitude);
                    }
                    catch(Exception e){}
            }
            return Info;
      }
      return null;
    }
    
    public VesselInfo getByMarineTraffic(String myimo)
    {
        String url_position='http://services.marinetraffic.com/api/exportvessel/'+MarineApi+'/timespan:60/protocol:xml/msgtype:extended/imo:'+EncodingUtil.urlEncode(myimo,'UTF-8');
        Http h3 = new Http(); 
        HttpRequest req3 = new HttpRequest();
        req3.setTimeout(100000);
        req3.setEndpoint(url_position); 
        req3.setMethod('GET');
        try
        {
            Dom.Document doc2 = null;
            if (!Test.isRunningTest())
                 doc2 = h3.send(req3).getBodyDocument();
            else
            {
                string body_test_position = '<pos><row MMSI="205623000" LAT="37.24538" LON="25.590981" SPEED="65" COURSE="288" TIMESTAMP="2012-04-18T19:21:00" SHIPNAME="MALACHITE" SHIPTYPE="70" IMO="9549645" CALLSIGN="ONHL" FLAG="BE" LAST_PORT="PORT SAID" LAST_PORT_TIME="2012-04-16T18:26:00" DESTINATION="DERINCE" ETA="2012-04-20T14:00:00" LENGTH="90" WIDTH="14" DRAUGHT="50" GRT="3517" DWT="5000" YEAR_BUILT="2012"/></pos>';
                doc2=new Dom.Document();
                doc2.load(body_test_position);  
            }
            
            Dom.XMLNode Envelope2 = doc2.getRootElement();
            VesselInfo info=new VesselInfo();
            info.Information='';
            info.imo=myimo;
            for(Dom.XMLNode child : Envelope2.getChildElements()) 
            {
                String attribute=child.getAttribute('LAT', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.Latitude=Double.valueOf(attribute);
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('LON', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.longitude=Double.valueOf(attribute);
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('SPEED', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.speed=Double.valueOf(attribute);
                        info.Information+='Speed: '+info.speed+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('SHIPNAME', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.name=attribute;
                        info.Information+='Vessel: '+attribute+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('TIMESTAMP', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.mytime=DateTime.newInstance(((DateTime)JSON.deserialize('"'+attribute+ '"',DateTime.class)).getTime());
                        info.Information+='Detection Time: '+info.mytime.format()+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('FLAG', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.Information+='Flag: '+attribute+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('LAST_PORT', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.Information+='Last Port: '+attribute+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('LAST_PORT_TIME', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        DateTime mytime=DateTime.newInstance(((DateTime)JSON.deserialize('"'+attribute+ '"',DateTime.class)).getTime());
                        info.Information+='Last Port Time: '+mytime.format()+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('DESTINATION', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.Information+='Detination: '+attribute+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('ETA', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.eta=DateTime.newInstance(((DateTime)JSON.deserialize('"'+attribute+ '"',DateTime.class)).getTime());
                        info.Information+='ETA: '+info.eta.format()+' |';
                    }
                    catch(Exception e){}
                }
                attribute=child.getAttribute('COURSE', '');
                if(String.IsNotEmpty(attribute))
                {
                    try{
                        info.course=Double.valueOf(attribute);
                        info.Information+='Course: '+info.course+' |';
                    }
                    catch(Exception e){}
                }
                return info;
            }
        }
        catch(Exception e){}
        return null;
    }
    public PageReference registerOI()
    {
           track='';
           force_vessel_information=false;
            
            // Sacar el nombre de la lista para guardarlo
             Schema.DescribeFieldResult fieldResult1 = Shipment__c.TrackOptions_Value__c.getDescribe();
             List<Schema.PicklistEntry> ple = fieldResult1.getPicklistValues();
             for( Schema.PicklistEntry f : ple)
             {
                string[] id_trackoption = f.getValue().split('&');
                if(id_trackoption[1] == trackoptions_selected )
                {
                    track = id_trackoption[0];
                    break;
                }       
             }
             
             carrier='';
             operators_selectedv1 = '';
             Schema.DescribeFieldResult fieldResult2 = Shipment__c.Carriers_value_OI__c.getDescribe();
             List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
             for( Schema.PicklistEntry f : ple2)
             {
                string[] id_ope = f.getValue().split('_');
                system.debug('ope0'+id_ope[0]);
                system.debug('ope1'+id_ope[1]);
                system.debug('ope'+operators_selected);
                if(id_ope[1] == operators_selected )
                {
                    carrier = id_ope[0];
                    if(id_ope.size()>2)
                        operators_selectedv1 = id_ope[2];
                    break;
                }       
            }
            if(String.IsEmpty(track))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Track Option not found. Please, try again'));
                return null;
            }
            if(String.IsEmpty(carrier))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Carrier not found. Please, try again'));
                return null;
            }
            if(String.IsEmpty(Number_con_book))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number not found. Please, try again'));
                return null;
            }
            if(track == record.Track_Option__c && carrier == record.Carrier_OI__c && Number_con_book == record.Number__c && String.IsnotEmpty(record.External_Reference_OI__c))
            {
                updateOtherShipmentInfo();
                PageReference tempPage = ApexPages.currentPage();            
	            tempPage.setRedirect(true);
    		    return tempPage;
            }
            String myId='';
            
            {
                string url = 'http://capi.ocean-insights.com/containertracking/v1/subscriptions/';
                string payload = 'request_carrier_code='+operators_selected+'&request_key='+Number_con_book+'&request_type='+trackoptions_selected;
		        String username = NEU_Settings.OIuser;
		        String password = NEU_Settings.OIpass;
            
                Http h = new Http(); 
                HttpRequest req = new HttpRequest();
                req.setTimeout(100000);
                req.setEndpoint(url); 
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setHeader('Accept','application/xml');
                
                req.setBody(payload);
                System.debug(payload);
                Dom.Document doc = new Dom.Document();
                try
                {
                    if (!Test.isRunningTest())
                    {
                        HttpResponse res = h.send(req); 
                        System.debug(res.getBody());
                        doc = res.getBodyDocument(); 
                    }
                    else
                    {
                        String body_test2 ='<?xml version="1.0" encoding="utf-8"?><root><id>11744</id></root>';
                        doc.load(body_test2);  
                    }
            
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Read timed out, please try again later')); }
                
                
                Dom.XMLNode Envelope = doc.getRootElement();        
                try
                {
                    for(Dom.XMLNode child : Envelope.getChildElements()) 
                    {
                        if(child.getName() == 'id')
                        {
                            myId=child.getText();
                            System.debug('myid='+myid);
                            break;
                        } 
                    }
                }
                catch(Exception ex)
                {
                }
            }
            if((string.isempty(myid))||Test.isRunningTest())
            {
                string url = 'http://capi.ocean-insights.com/containertracking/v1/subscriptions/?search='+number_con_book;
		        String username = NEU_Settings.OIuser;
		        String password = NEU_Settings.OIpass;
                Http h = new Http(); 
                HttpRequest req = new HttpRequest();
                req.setTimeout(100000);
                req.setEndpoint(url); 
                req.setMethod('GET');
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setHeader('Accept','application/xml');
                
                Dom.Document doc = new Dom.Document();
                try
                {
                    if (!Test.isRunningTest())
                    {
                        HttpResponse res = h.send(req); 
                        System.debug(res.getBody());
                        doc = res.getBodyDocument(); 
                    }
                    else
                    {
                        String body_test2 ='<?xml version="1.0" encoding="utf-8"?><root><id>11744</id></root>';
                        doc.load(body_test2);  
                    }
            
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Read timeout. Please try again later')); }
                
                
                Dom.XMLNode Envelope = doc.getRootElement();        
                try
                {
                    for(Dom.XMLNode child : Envelope.getChildElements()) 
                    {
                        if(child.getName() == 'id')
                        {
                            myId=child.getText();
                            System.debug('myid='+myid);
                            break;
                        } 
                        for(Dom.XMLNode child2 : child.getChildElements()) 
                        {
                            if(child2.getName() == 'id')
                            {
                                myId=child2.getText();
                                System.debug('myid='+myid);
                                break;
                            } 
                        }
                    }
                }
                catch(Exception ex)
                {
                }
                
            
            }
            
            if(String.IsNotEmpty(myId))
            {
                delete events;
                events=null;
                emptyShipmentP(record);
                record.External_Reference_OI__c=myId;
                record.Carrier_OI__c=carrier;
                record.Track_Option__c=track;
                record.Number__c=Number_con_book;
                update record;
                
                List<Shipment__c> query_shipment_associated = [select id, Name, External_Reference_OI__c, 
                Carrier_OI__c, Track_Option__c, Number__c from Shipment__c 
                where Inbound_Consolidation_Program__c =: record.Id
                and External_Reference_OI__c=null];
                if(query_shipment_associated.size()>0)
                {
	                for(Shipment__c ship : query_shipment_associated)
	                {
	                    ship.External_Reference_OI__c = myId;
	                    ship.Carrier_OI__c = carrier;
	                    ship.Track_Option__c = track;
	                    ship.Number__c = Number_con_book;
	                }
                    update query_shipment_associated;
	                List<Event__c> query_event_to_delete = [select Id, Name from Event__c where Shipment__c IN: query_shipment_associated];
                    if(query_event_to_delete.size()>0)
                        delete query_event_to_delete;
                }
                updateOtherShipmentInfo();
                PageReference tempPage = ApexPages.currentPage();            
	            tempPage.setRedirect(true);
    		    return tempPage;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Data error. Please, try again'));
        return null;
    }
public void updateOtherShipmentInfo()
{
	NEU_AsyncOIShipment.update_oi(record.External_Reference_OI__c);
	if(String.IsNotEmpty(record.IMO_Number__c))
    {
    	if((record.Truck_Vessel_Latitude__c==null)||(record.Truck_Vessel_Longitude__c==null))
    	{
	        VesselInfo info=getByMarineTraffic(record.IMO_Number__c);
	        if(info!=null)
	            if(String.IsEmpty(info.Information))
	                info=null;
	        if(info!=null)
	        {
                record.Vessel_Information__c=info.Information.replace(' |','\r\n');
                record.Vessel_Name__c=Info.Name;
                record.Truck_Vessel_Latitude__c=info.latitude;
                record.Truck_Vessel_Longitude__c=info.longitude;
                record.Vessel_Course__c=info.course;
                record.Vessel_Speed__c=info.speed; 
	        }
	        else 
	        {
	            info=getByVesselFinder(record.IMO_Number__c);
	            if(info!=null)
	            {
	                record.Truck_Vessel_Latitude__c=info.latitude;
	                record.Truck_Vessel_Longitude__c=info.longitude;
	                record.Vessel_Information__c='Vessel: '+record.Vessel_Name__c+'\r\n';
	            }
	        }
    	}
    }
}
 public static void emptyShipmentP(Shipment_Program__c s)
 {
	s.ETD__c=null;
	s.ETA_ATA__c=null;
	s.ATAPOD__c=null;
	s.Origin__c=null;
	s.Origin_Code__c=null;
	s.Final_Discharge__c=null;
	s.Final_Discharge_Code__c=null;
	s.Port_Of_Loading__c=null;
	s.Port_Of_Loading_Code__c=null;
	s.Port_Of_Discharging__c=null;
	s.Port_Of_Discharging_Code__c=null;
	s.OI_Status__c=null;
	s.OI_Status_Code__c=null;
	s.Vessel_Name__c=null;
	s.IMO_Number__c=null;
	s.Port_of_Transshipment_1__c=null;
	s.Port_of_Transshipment_Code_1__c=null;
	s.Port_of_Transshipment_2__c=null;
	s.Port_of_Transshipment_Code_2__c=null;
	s.Port_of_Transshipment_3__c=null;
	s.Port_of_Transshipment_Code_3__c=null;
	s.Vessel_1__c=null;
	s.Vessel_Imo_1__c=null;
	s.Vessel_2__c=null;
	s.Vessel_Imo_2__c=null;
	s.Vessel_3__c=null;
	s.Vessel_Imo_3__c=null;
	s.Vessel_4__c=null;
	s.Vessel_Imo_4__c=null;
	s.Truck_Vessel_Latitude__c=null;
	s.Truck_Vessel_Longitude__c=null;
	s.Vessel_Course__c=null;
 	s.Vessel_Information__c=null;
 	s.External_Reference_OI__c=null;
 }
}