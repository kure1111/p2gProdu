public with sharing class NEU_Track_and_Trace_Vessel {
    private static String MarineAPi='168ea1c7d8cd4280eed12679b490aced0fdb6eaf';


    public Vessel_Flight__c record;


    public String no_encontrado {get;set;}

    public String Bl_no {get; set;}
    public String Booking_no {get; set;}
    public String Container_no {get; set;}
    public String Container_type {get; set;}
    public String Operator {get; set;}
    public String SCAC_Carrier_Code {get; set;}
    public String Source {get; set;}
    public String Weight {get; set;}
    
    public String Vessel_Information{get;set;}
    public String Vessel_Name{get;set;}
    public String Imo_Number{get;set;}
    public String MMSI{get;set;}
    public String Vessel_Name_origen{get;set;}
    public String Imo_Number_origen{get;set;}
    public String MMSI_origen{get;set;} 
    
    
    public NEU_Track_and_Trace_Vessel(ApexPages.StandardController stdController) 
    {
         if (!Test.isRunningTest()) {
            stdController.AddFields(new String[]
            {
                'Id',
                'Name',
                'Vessel_Information__c',
                'Vessel_Latitude__c',
                'Vessel_Longitude__c',
                'Vessel_Speed__c',
                'Vessel_Course__c',
                'Vessel_Train_Truck__c',
                'Last_Update__c',
                'MMSI__c',
                'IMO__c'
            });
         }      
        record=(Vessel_Flight__c)stdController.getRecord();
            
        
        Vessel_Information=record.Vessel_Information__c;
        if(String.IsNotEmpty(Vessel_Information))
            Vessel_Information=Vessel_Information.replace('\r\n',' |').replace('\n',' |');
            
        Vessel_Name=record.Vessel_Train_Truck__c;
        Imo_Number=record.IMO__c;
        MMSI=record.MMSI__c;
        Vessel_Name_origen=record.Vessel_Train_Truck__c;
        Imo_Number_origen=record.IMO__c;
        MMSI_origen=record.MMSI__c;
    }
     
    
    public void getbyvessel()
    {
        if(String.IsNotEmpty(Imo_Number))
        {
            getByIMO(IMO_Number,0);
        }
        else if(String.IsNotEmpty(MMSI))
        {
            getByIMO(MMSI,1);
        }
        else if(String.IsNotEmpty(Vessel_Name))
        {
            getByIMO(Vessel_Name,2);
        }
    }
    public boolean getByIMO(String name,Integer searchtype)
    {
            boolean makeupdate=false;
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
                            String Vessel_Information='';
                            String DestinationPort='';
                            DatetIme DestinationETA=null;
                            for(Dom.XMLNode d : child.getChildElements())
                            {
                                if(d.getName()=='mmsi')
                                {
                                    if(String.IsEmpty(record.Mmsi__c))
                                        record.Mmsi__c=d.getText();
                                    Vessel_Information+='MMSI: '+d.getText()+' |';
                                }
                                else if(d.getName()=='imo')
                                {
                                    if(String.IsEmpty(record.Imo__c))
                                        record.Imo__c=d.getText();
                                    Vessel_Information+='IMO: '+d.getText()+' |';
                                }
                                else if(d.getName()=='shipname')
                                {
                                    if(String.IsEmpty(record.Name))
                                        record.Name=d.getText();
                                    Vessel_Information+='Vessel: '+d.getText()+' |';
                                }
                                else if(d.getName()=='position')
                                {
                                    for(Dom.XMLNode p:d.getChildElements())
                                    {
                                        if(p.getName()=='received')
                                        {
                                            try{
                                                record.Last_Update__c=DateTime.newInstance((((DateTime)JSON.deserialize('"'+p.getText().replace(' ','T')+ '"',DateTime.class))).getTime());
                                                Vessel_Information+='Detection Time: '+record.Last_Update__c.format()+' |';
                                            }
                                            catch(Exception e){}
                                        }
                                        else if(p.getName()=='latitude')
                                        {
                                            try{
                                                record.Vessel_Latitude__c=Double.valueOf(p.getText());
                                            }
                                            catch(Exception e){}
                                        }
                                        else if(p.getName()=='longitude')
                                        {
                                            try{
                                                record.Vessel_Longitude__c=Double.valueOf(p.getText());
                                            }
                                            catch(Exception e){}
                                        }
                                        else if(p.getName()=='speed_over_ground')
                                        {
                                            Vessel_Information+='Speed: '+p.getText()+' kn |';
                                            try{
                                                record.Vessel_Speed__c=Double.valueOf(p.getText());
                                            }
                                            catch(Exception e){}
                                        }
                                        else if(p.getName()=='true_heading')
                                        {
                                            Vessel_Information+='Course: '+p.getText()+' |';
                                            try{
                                                record.Vessel_Course__c=Double.valueOf(p.getText());
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
                                record.Vessel_Flight_ETA_Point_of_Discharge__c=DestinationETA.Date();
                            }
                            if(String.IsNotEmpty(DestinationPort))
                            {
                                Vessel_Information+='Destination Port: '+DestinationPort+' |';
                            }
                            if(String.IsNotEmpty(Vessel_Information))
                            {
                                makeupdate=true;
                                record.Vessel_Information__c=Vessel_Information;
                            }
                            break;
                        }
                    }
                }
                catch(Exception e){}
                if(makeupdate)
                {
                    update record;
                    if (!Test.isRunningTest())
                        return true;
                }
            }
            if(!makeupdate)
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
                        record.Mmsi__c=parser.getText();
                        makeupdate=true;
                        if(searchtype==2)
                        {
                            searchtype=1;
                            name=record.Mmsi__c;
                        }
                    }
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('shipname')))
                    {
                        parser.nextToken();
                        record.Vessel_Train_Truck__c=parser.getText();
                        makeupdate=true;
                    }
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('imo')))
                    {
                        parser.nextToken();
                        record.IMO__c = parser.getText();
                        makeupdate=true;
                        if(searchtype==2)
                        {
                            searchtype=0;
                            name=record.IMO__c;
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
                        record.Mmsi__c=parser.getText();
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
                        record.Vessel_Train_Truck__c=parser.getText();
                        makeupdate=true;
                    }
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('imo')))
                    {
                        parser.nextToken();
                         record.IMO__c=parser.getText();
                        makeupdate=true;
                        if(searchtype==2)
                        {
                            searchtype=0;
                            name=record.IMO__c;
                        }
                    }
                }
            }
            if(makeupdate)
            {
                record.Vessel_Information__c=null;
                record.Vessel_Latitude__c=null;
                record.Vessel_Longitude__c=null;
                record.Vessel_Speed__c=null;
                record.Vessel_Course__c=null;
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
                            record.Vessel_Latitude__c=Double.valueOf(latitud);
                        }
                        catch(Exception e)
                        {
                            record.Vessel_Latitude__c=null;
                        }
                        String longitud = child.getAttribute('LON', '');
                        try{
                            record.Vessel_Longitude__c=Double.valueOf(longitud);
                        }
                        catch(Exception e)
                        {
                            record.Vessel_Longitude__c=null;
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
                                record.Vessel_Speed__c=Double.valueOf(speed);
                                Vessel_Information+='Speed: '+String.valueOf(record.Vessel_Speed__c)+' |';
                            }
                            catch(Exception e)
                            {
                                record.Vessel_Speed__c=null;
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
                                record.Vessel_Course__c=Double.valueOf(course);
                                Vessel_Information+='Course: '+String.valueOf(record.Vessel_Course__c)+' |';
                            }
                            catch(Exception e)
                            {
                                record.Vessel_Course__c=null;
                            }
                        }
                        record.Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
                        record.MMSI__c = child.getAttribute('MMSI', '');
                        record.IMO__c = child.getAttribute('IMO', '');
                        record.Vessel_Train_Truck__c = shipname;
                        record.Last_Update__c = system.today();
                        makeupdate=true;
                    }
                }
                catch(Exception e){}
                if(record.Vessel_Latitude__c==null || Test.isRunningTest())
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
                                    record.Vessel_Latitude__c=Double.valueOf(latitude);
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
                                    record.Vessel_Longitude__c=Double.valueOf(longitude);
                                    makeupdate=true;
                                }
                                catch(Exception e){}
                        }
                    }
                }
            
            
                if((record.Vessel_Information__c==null)&&(String.IsNotEmpty(record.Vessel_Train_Truck__c)))
                {
                    makeupdate=true;
                    Vessel_Information='Vessel: '+record.Vessel_Train_Truck__c+' |';
                    record.Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
                }
            }
            if(makeupdate)
            {
                try{
                    update record;
                }
                catch(Exception e){}
            }
            
        
        

            Vessel_Name=record.Vessel_Train_Truck__c;
            Imo_Number=record.IMO__c;
            MMSI=record.MMSI__c;
            
            
            if(Vessel_Name_origen != null && Vessel_Name_origen != '')
                record.Vessel_Train_Truck__c = Vessel_Name_origen;
            if(Imo_Number_origen != null && Imo_Number_origen != '')
                record.IMO__c = Imo_Number_origen;
            if(MMSI_origen != null && MMSI_origen != '')
                record.MMSI__c = MMSI_origen;   
                
            try
            {
                update record;
            }
            catch(Exception ex){}
            return makeupdate;
    }
}