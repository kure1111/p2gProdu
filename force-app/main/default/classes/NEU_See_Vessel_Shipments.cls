public with sharing class NEU_See_Vessel_Shipments {
    private static String MarineAPi='168ea1c7d8cd4280eed12679b490aced0fdb6eaf';

  Shipment__c[] shipments;
  public String posiciones {get; set;} 
  public List<Shipment__c> ship;
  
  
  //positions
  public String Id_shipment_consulta {get; set;} 
  public String Vessel_Information{get;set;}
  public String Vessel_Activities{get;set;}
  public String Vessel_Name{get;set;}
  public String Imo_Number{get;set;}
  public String MMSI{get;set;}
  
  //activities
  public List<Shipment__c> ship_to_update;
  public String Id_shipment_consulta_activities {get; set;} 
  public String Operator {get; set;}
  public String operators_selected {get; set;}
  public String Number_con_book {get;set;}
  public String trackoptions_selected {get;set;}
  private List<NEU_JE_TrackAndTrace_s> TrackAndTrace = null;
  public String no_encontrado {get;set;}
  public String Bl_no {get; set;}
  public String Booking_no {get; set;}
  public String Container_no {get; set;}
  public String Container_type {get; set;}
  public String SCAC_Carrier_Code {get; set;}
  public String Source {get; set;}
  public String Weight {get; set;}
  
  
    public String shipmentid{get;set;}
    public Shipment__c shipmentinfo {get;set;}
    public void updateshipmentinfo()
    {
        shipmentinfo=null;
        if(String.IsNotEmpty(shipmentid))
        {
            List<Shipment__c> ss=[select Id,
                                        Name,
                                        Vessel_Name__c,
                                        Imo_Number__c,
                                        Last_Activity__c,
                                        Date__c,
                                        Location__c,
                                        ETA_ATA__c,
                                        ETD__c,
                                        ATAPOD__c,
                                        Origin__c,
                                        Account_for__c,
                                        Supplier_Account__c,
                                        Origin_Address__c ,
                                        Destination_Address__c,
                                        Move_Type__c,
                                        Final_Discharge__c,
                                        Origin_Code__c,
                                        Final_Discharge_Code__c,
                                        Port_Of_Loading__c,
                                        Port_Of_Discharging__c,
                                        Port_Of_Loading_Code__c,
                                        Port_Of_Discharging_Code__c from Shipment__c where Id=:shipmentid];
            if(ss.size()>0)
                shipmentinfo=ss[0];
            else
                shipmentinfo=null;
        }
    }
  
 public List<NEU_JE_TrackAndTrace_s> getTrackAndTrace()
 {
   return TrackAndTrace;
 }   
    
  public NEU_See_Vessel_Shipments(ApexPages.StandardSetController stdController) 
  {
       shipments = stdController.getSelected();
       if(shipments != null)
       {
         string contenedor_rutas = '';
         integer contador_de_rutas = 0;
         
         ship = new List<Shipment__c>();
         ship = [select Id, Name, Route__c, Country_of_Load__c, Truck_Vessel_Flight_ETD__c, Truck_Vessel_Flight_ETA__c,  ATAPOD__c , Last_Activity__c, Port_Of_Loading__c, Port_Of_Discharging__c,
         Country_of_Discharge__c,   Route__r.Name, Date__c, Location__c, ETD__c,
         Truck_Vessel_Latitude__c, Truck_Vessel_Longitude__c, Vessel_Speed__c, Vessel_Course__c, Imo_Number__c, Vessel_Information__c, Vessel_Activities__c, Vessel_Name__c, MMSI__c, ETA_ATA__c  from Shipment__c 
         where Id IN: shipments and Country_of_Load__c != null and Country_of_Discharge__c != null and (Vessel_Name__c !=:null or Imo_Number__c !=:null or MMSI__c !=null)  order by Route__c];
        //
         posiciones = '';
         for(Shipment__c sh : ship)
         {
            if(String.IsNotEmpty(posiciones))
                posiciones += '_&_';
            posiciones +=(sh.Truck_Vessel_Latitude__c != null ? String.valueOf(sh.Truck_Vessel_Latitude__c) : '')+'_*_';//0
            posiciones +=(sh.Truck_Vessel_Longitude__c != null ? String.valueOf(sh.Truck_Vessel_Longitude__c) : '')+'_*_';//1
            posiciones +=(sh.Vessel_Course__c != null ? String.valueOf(sh.Vessel_Course__c) : '')+'_*_';//2
            posiciones +=(sh.Vessel_Speed__c != null ? String.valueOf(sh.Vessel_Speed__c) : '')+'_*_';//3
            posiciones +=(sh.Imo_Number__c != null ? sh.Imo_Number__c : '')+'_*_';//4
            posiciones +=(sh.Vessel_Name__c != null ? sh.Vessel_Name__c : '')+'_*_';//5
            posiciones +=(sh.Vessel_Information__c != null ? sh.Vessel_Information__c.replace('\r','').replace('\n',' |') : '') ;//6
         }
        }
  }
  
  //Search by Vessel (positions)
   public void getbyvessel()
  {
    integer numero_maximo_de_consultas = 0;
    for(Shipment__c sh: ship)
    {
        if(numero_maximo_de_consultas <3)//definir esto------------------------
        {
             Vessel_Information=sh.Vessel_Information__c;
            if(String.IsNotEmpty(Vessel_Information))
              Vessel_Information=Vessel_Information.replace('\r\n',' |').replace('\n',' |');
            Vessel_Activities=sh.Vessel_Activities__c;
            if(String.IsNotEmpty(Vessel_Activities))
              Vessel_Activities=Vessel_Activities.replace('\r\n',' |').replace('\n',' |');
            Vessel_Name=sh.Vessel_Name__c;
            
            Imo_Number=sh.Imo_Number__c;
            MMSI=sh.MMSI__c;
            
            Id_shipment_consulta = sh.Id;
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
        numero_maximo_de_consultas++;
    }
  }
  
  public boolean getByIMO(String name,Integer searchtype)
  {
    
      List<Shipment__c> ship_selected = new List<Shipment__c>();
      ship_selected = [select Id, Name, Route__c, Country_of_Load__c, Truck_Vessel_Flight_ETD__c, Truck_Vessel_Flight_ETA__c,  ATAPOD__c ,
      Country_of_Discharge__c, Route__r.Name, Date__c, Location__c, ETD__c,
      Truck_Vessel_Latitude__c, Truck_Vessel_Longitude__c, Vessel_Speed__c, Vessel_Course__c,Imo_Number__c, Vessel_Information__c, Vessel_Activities__c, Vessel_Name__c, MMSI__c, ETA_ATA__c  from Shipment__c 
      where Id =: Id_shipment_consulta  order by Route__c];
    
      boolean makeupdate=false;
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
                    ship_selected[0].Mmsi__c=parser.getText();
                    makeupdate=true;
                    if(searchtype==2)
                    {
                      searchtype=1;
                      name=ship_selected[0].Mmsi__c;
                    }
            }
          if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('shipname')))
          {
                    parser.nextToken();
                    ship_selected[0].Vessel_Name__c=parser.getText();
                    makeupdate=true;
            }
          if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('imo')))
          {
                    parser.nextToken();
                    ship_selected[0].IMO_Number__c=parser.getText();
                    makeupdate=true;
                    if(searchtype==2)
                    {
                      searchtype=0;
                      name=ship_selected[0].IMO_Number__c;
                    }
            }
          }
      }
      if(!makeupdate || Test.isRunningTest())
      {
        String url_imo = 'http://www.vesselfinder.com/vessels/livesearch?term='+EncodingUtil.urlEncode(name, 'UTF-8');
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
                    ship_selected[0].Mmsi__c=parser.getText();
                    makeupdate=true;
                    if(searchtype==2)
                    {
                      searchtype=1;
                      name=ship_selected[0].Mmsi__c;
                    }
            }
          if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('name')))
          {
                    parser.nextToken();
                    ship_selected[0].Vessel_Name__c=parser.getText();
                    makeupdate=true;
            }
          if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('imo')))
          {
                    parser.nextToken();
                    ship_selected[0].IMO_Number__c=parser.getText();
                    makeupdate=true;
                    if(searchtype==2)
                    {
                      searchtype=0;
                      name=ship_selected[0].IMO_Number__c;
                    }
            }
            }
      }
      if(makeupdate)
      {
        ship_selected[0].Vessel_Information__c=null;
        ship_selected[0].Truck_Vessel_Latitude__c=null;
        ship_selected[0].Truck_Vessel_Longitude__c=null;
        ship_selected[0].Vessel_Speed__c=null;
        ship_selected[0].Vessel_Course__c=null;
      }
      if(searchtype!=2)//-----------------------------------------
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
                  ship_selected[0].Truck_Vessel_Latitude__c=Double.valueOf(latitud);
                }
                catch(Exception e)
                {
                  ship_selected[0].Truck_Vessel_Latitude__c=null;
                }
                String longitud = child.getAttribute('LON', '');
                try{
                  ship_selected[0].Truck_Vessel_Longitude__c=Double.valueOf(longitud);
                }
                catch(Exception e)
                {
                  ship_selected[0].Truck_Vessel_Longitude__c=null;
                }
                Vessel_Information='';
                String shipname = child.getAttribute('SHIPNAME', '');
                if(String.IsNotEmpty(shipname))
                  Vessel_Information+='Vessel: '+shipname+' |';
                String speed = child.getAttribute('SPEED', '');
                if(String.IsNotEmpty(speed))
                {
                  try{
                    ship_selected[0].Vessel_Speed__c=Double.valueOf(speed);
                    Vessel_Information+='Speed: '+String.valueOf(ship_selected[0].Vessel_Speed__c)+' |';
                  }
                  catch(Exception e)
                  {
                    ship_selected[0].Vessel_Speed__c=null;
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
                    ship_selected[0].Vessel_Course__c=Double.valueOf(course);
                    Vessel_Information+='Course: '+String.valueOf(ship_selected[0].Vessel_Course__c)+' |';
                  }
                  catch(Exception e)
                  {
                    ship_selected[0].Vessel_Course__c=null;
                  }
                }
            ship_selected[0].Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
            ship_selected[0].MMSI__c = child.getAttribute('MMSI', '');
            ship_selected[0].IMO_Number__c = child.getAttribute('IMO', '');
            ship_selected[0].Vessel_Name__c = shipname;
            makeupdate=true;
              }
        }
        catch(Exception e){}
        //-------------------------------------------------------------------
        if(ship_selected[0].Truck_Vessel_Latitude__c==null || Test.isRunningTest())
        {
          //try vessel finder
          String url_imo;
          if(searchtype==0)
            url_imo='http://www.vesselfinder.com/?imo='+EncodingUtil.urlEncode(name, 'UTF-8');
          else if(searchtype==1)
            url_imo='http://www.vesselfinder.com/?mmsi='+EncodingUtil.urlEncode(name, 'UTF-8');
          Http h2 = new Http(); 
          HttpRequest req2 = new HttpRequest();
          req2.setTimeout(100000);
          req2.setEndpoint(url_imo); 
          req2.setMethod('GET');
          String query_mmsi_Number='';
          if (Test.isRunningTest())
            query_mmsi_Number='<script type="text/javascript">/*<![CDATA[*/var map_options={mmsi:636015859,update_info:false, auto_track:true,latitude:26.116796666667,longitude:-15.343575,zoom:9};var map=new VFOlMap();map.init(map_options);vfme.current_picture_id = 22072; vfme.no_picture = false; vfme.first_picture_url = "/vessels/ship-photo/9635640-636015859-cda13fa0d0eb6cd2569d248053381ba8/1";jQuery(function($) {vfme.auto_device_check = false;});/*]]>*/</script>';
          else
            try{
              query_mmsi_Number = h2.send(req2).getBody();
            }
            catch(Exception e){}
          Integer pos=query_mmsi_Number.indexOf('map_options');
          if(pos>=0)
          {
            query_mmsi_Number=query_mmsi_Number.substring(pos+11);
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
                      ship_selected[0].Truck_Vessel_Latitude__c=Double.valueOf(latitude);
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
                      ship_selected[0].Truck_Vessel_Longitude__c=Double.valueOf(longitude);
                          makeupdate=true;
                    }
                    catch(Exception e){}
            }
          }
            }
            if((ship_selected[0].Vessel_Information__c==null)&&(String.IsNotEmpty(ship_selected[0].Vessel_Name__c)))
            {
                  makeupdate=true;
                  Vessel_Information='Vessel: '+ship_selected[0].Vessel_Name__c+' |';
                  ship_selected[0].Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
            }
      }
      if(makeupdate)
      {
        try{
          update ship_selected;
        }
        catch(Exception e){}
      }
    /*  Vessel_Name=ship_selected[0].Vessel_Train_Truck__c;
      Imo_Number=ship_selected[0].Imo_Number__c;
      MMSI=ship_selected[0].MMSI__c;*/
      return makeupdate;
  }
  
  //-----------------------------
  //update activities
 public void getactivities()
 {
    integer numero_maximo_de_consultas_activities = 0;
    ship_to_update = new List<Shipment__c>();
    for(Shipment__c sh: ship)
    {
    //  if(numero_maximo_de_consultas_activities>3)//definir esto------------------------
    //  {
            Id_shipment_consulta_activities = sh.Id;
            getinformation();
        //}
        numero_maximo_de_consultas_activities ++;
    }
    guardar_cambios();
 }
  
  public void guardar_cambios()
  {
    update ship_to_update;
  }
  //update activities
  public void getinformation()
  {
      
      string track=''; 
      
      
      //consultar el id del shipment del momento
      List<Shipment__c> ship_selected = new List<Shipment__c>();
      ship_selected = [select Id, Name, Route__c, Country_of_Load__c,Account_for__c, Destination_Address__c, Origin_Address__c, Supplier_Account__c, Move_Type__c , Truck_Vessel_Flight_ETD__c, Truck_Vessel_Flight_ETA__c,  ATAPOD__c , Track_Option__c, Carriers_OI__c, Carriers_value_OI__c,
      Country_of_Discharge__c,  Route__r.Name, Date__c, Location__c, ETD__c, TrackOptions_Value__c, Number__c,
      Truck_Vessel_Latitude__c, Truck_Vessel_Longitude__c, Vessel_Speed__c, Vessel_Course__c,Imo_Number__c, Vessel_Information__c, Vessel_Activities__c, Vessel_Name__c, MMSI__c, ETA_ATA__c  from Shipment__c 
      where Id =: Id_shipment_consulta_activities  order by Route__c];
      
      
      // Sacar el nombre de la lista para guardarlo
       Schema.DescribeFieldResult fieldResult1 = Shipment__c.TrackOptions_Value__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult1.getPicklistValues();
         string[] id_trackoption = new string[1];
         for( Schema.PicklistEntry f : ple)
         {
           id_trackoption = f.getValue().split('&');
           if(id_trackoption[0] == ship_selected[0].Track_Option__c)
           {
             track = id_trackoption[0];
             trackoptions_selected = id_trackoption[1];
             break;
           }    
         } 
  
         
         Schema.DescribeFieldResult fieldResult2 = Shipment__c.Carriers_value_OI__c.getDescribe();
         List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
         string[] id_ope= new string[1];
         for( Schema.PicklistEntry f : ple2)
         {
           id_ope = f.getValue().split('_');
           if(id_ope[1] == operators_selected )
           {
             operators_selected =id_ope[1];
             operator = id_ope[1];
             break;
           }    
         }
        
        Number_con_book = ship_selected[0].Number__c;
         
        //http://api.oceaninsights.com:8080/api/Track?operator=SAFMARINE&No=MRKU7710646&Type=c_id -- Example 
        
      string url = 'http://api.oceaninsights.com:8080/api/Track?operator='+operators_selected+'&No='+Number_con_book+'&Type='+trackoptions_selected;
      string body_test2 = '';
      String username = 'NEUSIGHTS';
         String password = 'ocEan36491';
    
      Http h = new Http(); 
      HttpRequest req = new HttpRequest();
      req.setTimeout(100000);
      req.setEndpoint(url); 
      req.setMethod('GET');
  
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'BASIC ' +
         EncodingUtil.base64Encode(headerValue);
         req.setHeader('Content-Type','application/xml');
         req.setHeader('Authorization', authorizationHeader);
      
      HttpResponse res = new HttpResponse();
      if (!Test.isRunningTest())
        res = h.send(req); 
      else
      {
        
          body_test2 +='<TrackAndTraceCollectionOfTrackResultDfHSDcfW xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.datacontract.org/2004/07/LogisticPlatform.Domain">';
          body_test2 +='<Message>Success</Message>';
          body_test2 +='<Payload>';
          body_test2 +='  <Result>';
          body_test2 +='    <TrackResult>';
          body_test2 +='      <ATAPOD>sam 26</ATAPOD>';
          body_test2 +='      <Activity>sample 7</Activity>';
          body_test2 +='      <Activity_Code>sag 28</Activity_Code>';
          body_test2 +='      <Bl_no>string 2</Bl_no>';
          body_test2 +='      <Booking_no>sang 3</Booking_no>';
          body_test2 +='      <Capacity>sampg 13</Capacity>';
          body_test2 +='      <Container_no>samplg 1</Container_no>';
          body_test2 +='      <Container_type>samplng 4</Container_type>';
          body_test2 +='      <Date>null</Date>';
          body_test2 +='      <ETA_ATA>null</ETA_ATA>';
          body_test2 +='      <ETD>null</ETD>';
          body_test2 +='      <Final_Discharge>samg 24</Final_Discharge>';
          body_test2 +='      <Final_Discharge_Code>s5</Final_Discharge_Code>';
          body_test2 +='      <Imo_Number>1234567</Imo_Number>';
          body_test2 +='      <Location>sang 9</Location>';
          body_test2 +='      <Location_Code>10</Location_Code>';
          body_test2 +='      <Operator>samg 6</Operator>';
          body_test2 +='      <Origin>sam 16</Origin>';
          body_test2 +='      <Origin_Code>sam 17</Origin_Code>';
          body_test2 +='      <Port_Of_Discharging>samg 22</Port_Of_Discharging>';
          body_test2 +='      <Port_Of_Discharging_Code>sam 23</Port_Of_Discharging_Code>';
          body_test2 +='      <Port_Of_Loading>sam18</Port_Of_Loading>';
          body_test2 +='      <Port_Of_Loading_Code>samg 19</Port_Of_Loading_Code>';
          body_test2 +='      <SCAC_Carrier_Code>samg 27</SCAC_Carrier_Code>';
          body_test2 +='      <Service_Name>sang 14</Service_Name>';
          body_test2 +='     <Source>sampl9</Source>';
          body_test2 +='      <Vessel_Train_Truck>sam1</Vessel_Train_Truck>';
          body_test2 +='      <Voyage_Number>sing 15</Voyage_Number>';
          body_test2 +='      <Weight>sam5</Weight>';
          body_test2 +='      </TrackResult>';
          body_test2 +='      <TrackResult>';
          body_test2 +='        <ATAPOD>samp</ATAPOD>';
          body_test2 +='        <Activity>samp</Activity>';
          body_test2 +='        <Activity_Code>samp8</Activity_Code>';
          body_test2 +='        <Bl_no>saring 2</Bl_no>';
          body_test2 +='        <Booking_no>samg 3</Booking_no>';
          body_test2 +='        <Capacity>sam 13</Capacity>';
          body_test2 +='       <Container_no>samg 1</Container_no>';
          body_test2 +='        <Container_type>sang 4</Container_type>';
          body_test2 +='        <Date>null</Date>';
          body_test2 +='        <ETA_ATA>null</ETA_ATA>';
          body_test2 +='        <ETD>null</ETD>';
          body_test2 +='        <Final_Discharge>sam24</Final_Discharge>';
          body_test2 +='        <Final_Discharge_Code>sam5</Final_Discharge_Code>';
          body_test2 +='        <Imo_Number>1234567</Imo_Number>';
          body_test2 +='        <Location>samg 9</Location>';
          body_test2 +='        <Location_Code>10</Location_Code>';
          body_test2 +='        <Operator>sampng 6</Operator>';
          body_test2 +='        <Origin>samp16</Origin>';
          body_test2 +='       <Origin_Code>sang 17</Origin_Code>';
          body_test2 +='       <Port_Of_Discharging>samp 22</Port_Of_Discharging>';
          body_test2 +='        <Port_Of_Discharging_Code>samng 23</Port_Of_Discharging_Code>';
          body_test2 +='        <Port_Of_Loading>sam18</Port_Of_Loading>';
          body_test2 +='        <Port_Of_Loading_Code>sam19</Port_Of_Loading_Code>';
          body_test2 +='        <SCAC_Carrier_Code>samg 27</SCAC_Carrier_Code>';
          body_test2 +='        <Service_Name>samng 14</Service_Name>';
          body_test2 +='        <Source>samping 29</Source>';
          body_test2 +='        <Vessel_Train_Truck>samp11</Vessel_Train_Truck>';
          body_test2 +='        <Voyage_Number>sampng 15</Voyage_Number>';
          body_test2 +='        <Weight>saming 5</Weight>';
          body_test2 +='      </TrackResult>';
          body_test2 +='      <TrackResult>';
          body_test2 +='        <ATAPOD>sam8</ATAPOD>';
          body_test2 +='        <Activity>sampg 7</Activity>';
          body_test2 +='        <Activity_Code>sam 28</Activity_Code>';
          body_test2 +='        <Bl_no>samg 2</Bl_no>';
          body_test2 +='        <Booking_no>samg 3</Booking_no>';
          body_test2 +='       <Capacity>sag 13</Capacity>';
          body_test2 +='        <Container_no>sag 1</Container_no>';
          body_test2 +='        <Container_type>sam 4</Container_type>';
          body_test2 +='        <Date>null</Date>';
          body_test2 +='        <ETA_ATA>null</ETA_ATA>';
          body_test2 +='        <ETD>null</ETD>';
          body_test2 +='        <Final_Discharge>samg 24</Final_Discharge>';
          body_test2 +='        <Final_Discharge_Code>samg 25</Final_Discharge_Code>';
          body_test2 +='        <Imo_Number>1234567</Imo_Number>';
          body_test2 +='        <Location>sam9</Location>';
          body_test2 +='        <Location_Code>10</Location_Code>';
          body_test2 +='        <Operator>sang 6</Operator>';
          body_test2 +='        <Origin>samp16</Origin>';
          body_test2 +='        <Origin_Code>sampg 17</Origin_Code>';
          body_test2 +='        <Port_Of_Discharging>sam2</Port_Of_Discharging>';
          body_test2 +='        <Port_Of_Discharging_Code>sa3</Port_Of_Discharging_Code>';
          body_test2 +='        <Port_Of_Loading>sam18</Port_Of_Loading>';
          body_test2 +='        <Port_Of_Loading_Code>sam9</Port_Of_Loading_Code>';
          body_test2 +='        <SCAC_Carrier_Code>sam27</SCAC_Carrier_Code>';
          body_test2 +='        <Service_Name>sampl4</Service_Name>';
          body_test2 +='        <Source>sam29</Source>';
          body_test2 +='        <Vessel_Train_Truck>sam1</Vessel_Train_Truck>';
          body_test2 +='       <Voyage_Number>sampl5</Voyage_Number>';
          body_test2 +='       <Weight>samp5</Weight>';
          body_test2 +='     </TrackResult>';
          body_test2 +='    </Result>';
          body_test2 +='    <Status>sam 1</Status>';
          body_test2 +='  </Payload>';
          body_test2 +='  <Status>sag 1</Status>';
          body_test2 +='</TrackAndTraceCollectionOfTrackResultDfHSDcfW>';

      }
      
      
      Dom.Document doc = new Dom.Document();
      if (!Test.isRunningTest())
             doc = res.getBodyDocument(); 
          else
            doc.load(body_test2);  
            
       TrackAndTrace=new List<NEU_JE_TrackAndTrace_s>();
      
      //Retrieve the root element for this document.
          Dom.XMLNode Envelope = doc.getRootElement();        
          Dom.XMLNode Body = Envelope.getChildElements()[1];    
          //Get operators
      try
      {
            for(Dom.XMLNode child : Envelope.getChildElements()) 
            {
              if(child.getName() == 'Message')
              {
                if( child.getText() != 'Success')
                {
                  no_encontrado = child.getText();
                  break;
                }
              } 
              for(Dom.XMLNode child2 : child.getChildElements())
            {   
              for(Dom.XMLNode child3 : child2.getChildElements())
              { 
                String ATAPOD='';
                String Activity='';
                String Activity_Code='';
                String Capacity='';
                String Date_c='';
                String ETA_ATA='';
                String ETD='';
                String Operator='';
                String Final_Discharge='';
                String Final_Discharge_Code='';
                String Imo_Number='';
                String Location='';
                String Location_Code='';
                String Origin='';
                String Origin_Code='';
                String Port_Of_Discharging='';  
                String Port_Of_Discharging_Code='';
                String Port_Of_Loading='';
                String Port_Of_Loading_Code='';
                String Service_Name='';
                String Vessel_Train_Truck='';
                String Voyage_Number='';
                for(Dom.XMLNode child4 : child3.getChildElements())
                {
                  if(child4.getName() == 'ATAPOD')
                    ATAPOD = child4.getText();
                  if(child4.getName() == 'Activity')
                    Activity = child4.getText();
                  if(child4.getName() == 'Activity_Code')
                    Activity_Code = child4.getText();
                  if(child4.getName() == 'Bl_no')
                    Bl_no = child4.getText();
                  if(child4.getName() == 'Booking_no')
                    Booking_no = child4.getText();
                  if(child4.getName() == 'Capacity')
                    Capacity = child4.getText();
                  if(child4.getName() == 'Container_no')
                    Container_no = child4.getText();
                  if(child4.getName() == 'Container_type')
                    Container_type = child4.getText();
                  if(child4.getName() == 'Date')
                    Date_c = child4.getText();
                  if(child4.getName() == 'ETA_ATA')
                    ETA_ATA = child4.getText();
                  if(child4.getName() == 'ETD')
                    ETD = child4.getText();
                  if(child4.getName() == 'Final_Discharge')
                    Final_Discharge = child4.getText();
                  if(child4.getName() == 'Final_Discharge_Code')
                    Final_Discharge_Code = child4.getText();
                  if(child4.getName() == 'Imo_Number')
                    Imo_Number = child4.getText();
                  if(child4.getName() == 'Location')
                    Location = child4.getText();
                  if(child4.getName() == 'Location_Code')
                    Location_Code = child4.getText();
                  if(child4.getName() == 'Operator')
                    Operator = child4.getText();
                  if(child4.getName() == 'Origin')
                    Origin = child4.getText();  
                  if(child4.getName() == 'Origin_Code')
                    Origin_Code = child4.getText();    
                  if(child4.getName() == 'Port_Of_Discharging')
                    Port_Of_Discharging = child4.getText();
                  if(child4.getName() == 'Port_Of_Discharging_Code')
                    Port_Of_Discharging_Code = child4.getText();
                  if(child4.getName() == 'Port_Of_Loading')
                    Port_Of_Loading = child4.getText();
                  if(child4.getName() == 'Port_Of_Loading_Code')
                    Port_Of_Loading_Code = child4.getText();
                  if(child4.getName() == 'SCAC_Carrier_Code')
                    SCAC_Carrier_Code = child4.getText();
                  if(child4.getName() == 'Service_Name')
                    Service_Name = child4.getText();
                  if(child4.getName() == 'Source')
                    Source = child4.getText();
                  if(child4.getName() == 'Vessel_Train_Truck')
                    Vessel_Train_Truck = child4.getText();
                  if(child4.getName() == 'Voyage_Number')
                    Voyage_Number = child4.getText();
                  if(child4.getName() == 'Weight')
                    Weight = child4.getText();
                  
                }
                 TrackAndTrace.add(new NEU_JE_TrackAndTrace_s((ATAPOD != 'null' ? ATAPOD:''), (Activity != 'null' ? Activity :''), (Activity_Code != 'null' ? Activity_Code : ''), (Bl_no != 'null' ? Bl_no: ''), (Booking_no != 'null' ? Booking_no :''), (Capacity != 'null' ? Capacity :''), 
                  (Container_no != 'null' ? Container_no : ''), (Container_type != 'null' ? Container_type : ''), (Date_c != 'null' ? Date_c :''), (ETA_ATA != 'null' ? ETA_ATA : ''), (ETD != 'null' ? ETD :''), (Final_Discharge != 'null' ? Final_Discharge : ''), (Final_Discharge_Code != 'null' ? Final_Discharge_Code: ''), 
                  (Imo_Number != 'null' ? Imo_Number : ''), (Location != 'null' ? Location :''), (Location_Code != 'null' ? Location_Code : ''), (Operator != 'null' ? Operator : ''), (Origin != 'null' ? Origin :''), (Origin_Code != 'null' ? Origin_Code : ''),
                  (Port_Of_Discharging != 'null' ? Port_Of_Discharging : ''), (Port_Of_Discharging_Code != 'null' ? Port_Of_Discharging_Code : ''), (Port_Of_Loading != 'null' ? Port_Of_Loading : ''), (Port_Of_Loading_Code != 'null' ? Port_Of_Loading_Code : ''), (SCAC_Carrier_Code != 'null' ? SCAC_Carrier_Code : ''), (Service_Name != 'null' ? Service_Name : ''), (Source != 'null' ? Source :''),
                  (Vessel_Train_Truck != 'null' ? Vessel_Train_Truck : ''), (Voyage_Number != 'null' ? Voyage_Number: ''), (Weight != 'null' ? Weight :''),
                  ''));//letra posicion
              }
              break;
            }
            }

           // if(no_encontrado != null && no_encontrado != '')
            //  TrackAndTrace = null;
      }
      catch(Exception ex)
      {
      }
      TrackAndTrace.sort();
      
      String firstIMO='';
      for(NEU_JE_TrackAndTrace_s s:TrackAndTrace)
      {
        if(String.IsNotEmpty(s.Imo_Number)&&(s.Imo_Number!='null'))
          firstIMO=s.Imo_Number;
        if(String.IsNotEmpty(s.Date_c))
        {
           if(String.IsNotEmpty(firstIMO)&&(system.now().formatGmt('yyyy-MM-dd HH:mm').replace(' ','T')>s.Date_c))
             break;
        }
      }
      
     /* ship_selected[0].Vessel_Speed__c=null;
      ship_selected[0].Vessel_Information__c=null;
      ship_selected[0].Vessel_Latitude__c=null;
      ship_selected[0].Vessel_Longitude__c=null;
      ship_selected[0].Vessel_Course__c=null;
      ship_selected[0].MMSI__c = null;
      ship_selected[0].IMO_Number__c = null;
      ship_selected[0].Vessel_Train_Truck__c = null;*/
      Integer calloutcounter=1;
      
      for(NEU_JE_TrackAndTrace_s s:TrackAndTrace)
      {
        if(String.IsNotEmpty(s.Imo_Number)&&(s.Imo_Number!='null'))
        {
          boolean repeated=false;
          for(NEU_JE_TrackAndTrace_s s2:TrackAndTrace)
            if((s.Imo_Number==s2.Imo_Number)&&(s2.searched))
            {
              s.Mmsi=s2.Mmsi;
              s.online=s2.online;
              s.searched=s2.searched;
              repeated=true;
              break;
            }
          System.debug('calloutcounter='+String.valueOf(calloutcounter));
        /*  if((!repeated)&&(calloutcounter<=10))
          {
            s.searched=true;
            calloutcounter++;//-------------------------------------------------------------------------------------------------------------------------
           if(s.Imo_Number==firstIMO)//search in marine traffic extend
            {
              String url_position='http://services.marinetraffic.com/api/exportvessel/'+MarineApi+'/timespan:60/protocol:xml/msgtype:extended/imo:'+s.Imo_Number;
              Http h3 = new Http(); 
              HttpRequest req3 = new HttpRequest();
              req3.setTimeout(100000);
              req3.setEndpoint(url_position); 
              req3.setMethod('GET');
              try
              {
                     Dom.Document doc2 = h3.send(req3).getBodyDocument();
                     Dom.XMLNode Envelope2 = doc2.getRootElement();
                     for(Dom.XMLNode child : Envelope2.getChildElements()) 
                    {
                      String latitud = child.getAttribute('LAT', '');
                      try{
                        ship_selected[0].Vessel_Latitude__c=Double.valueOf(latitud);
                      }
                      catch(Exception e)
                      {
                        ship_selected[0].Vessel_Latitude__c=null;
                      }
                      String longitud = child.getAttribute('LON', '');
                      try{
                        ship_selected[0].Vessel_Longitude__c=Double.valueOf(longitud);
                      }
                      catch(Exception e)
                      {
                        ship_selected[0].Vessel_Longitude__c=null;
                      }
                      Vessel_Information='';
                      String shipname = child.getAttribute('SHIPNAME', '');
                      
                      if(String.IsNotEmpty(shipname))
                        Vessel_Information+='Vessel: '+shipname+' |';
                      String speed = child.getAttribute('SPEED', '');
                      if(String.IsNotEmpty(speed))
                      {
                        try{
                          ship_selected[0].Vessel_Speed__c=Double.valueOf(speed);
                          Vessel_Information+='Speed: '+String.valueOf(ship_selected[0].Vessel_Speed__c)+' |';
                        }
                        catch(Exception e)
                        {
                          ship_selected[0].Vessel_Speed__c=null;
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
                          ship_selected[0].Vessel_Course__c=Double.valueOf(course);
                          Vessel_Information+='Course: '+String.valueOf(ship_selected[0].Vessel_Course__c)+' |';
                        }
                        catch(Exception e)
                        {
                          ship_selected[0].Vessel_Course__c=null;
                        }
                      }
                      ship_selected[0].Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
                      ship_selected[0].MMSI__c = child.getAttribute('MMSI', '');
                      ship_selected[0].IMO_Number__c = firstIMO;
                      ship_selected[0].Vessel_Train_Truck__c = shipname;
                      s.Mmsi=ship_selected[0].MMSI__c;
                      s.online=String.IsNotEmpty(s.Mmsi);
                      break;
                    }
              }
              catch(Exception e){}
            }
            else //search in marine traffic simple
            {
              String url_position='http://services.marinetraffic.com/api/exportvessel/'+MarineApi+'/timespan:60/protocol:xml/msgtype:simple/imo:'+s.Imo_Number;
              Http h3 = new Http(); 
              HttpRequest req3 = new HttpRequest();
              req3.setTimeout(100000);
              req3.setEndpoint(url_position); 
              req3.setMethod('GET');
              try
              {
                     Dom.Document doc2 = h3.send(req3).getBodyDocument();
                     Dom.XMLNode Envelope2 = doc2.getRootElement();
                     for(Dom.XMLNode child : Envelope2.getChildElements()) 
                    {
                      s.Mmsi=child.getAttribute('MMSI','');
                      s.online=String.IsNotEmpty(s.Mmsi);
                      break;
                    }
              }
              catch(Exception e){}
            }
            //-------------------------------------
            if((String.IsEmpty(s.Mmsi))&&(calloutcounter<=10)) //search in shipfinder
            {
              calloutcounter++;
              String url_imo = 'http://www.shipfinder.com/Monitor/GETIHSData?imo='+s.Imo_Number;
              Http h2 = new Http(); 
              HttpRequest req2 = new HttpRequest();
              req2.setTimeout(100000);
              req2.setEndpoint(url_imo); 
              req2.setMethod('GET');
              String query_mmsi_Number='';
              if (Test.isRunningTest())
                query_mmsi_Number='{"Status":3,"Message":"no login,only get free","Data":[{"IMO":"9635640","ShipName":"MAERSK ELGIN","mmsi":"636015859","CallSign":"D5DE9","ShipType":"Container Ship (Fully Cellular)","FlagCountry":"Liberia","BuildDate":"2013/01","GT":"71112","NT":"-1","DWT":"80163","RegisteredOwner":"-1","Class":"-1","PandIClub":"-1","MouldLength":"270","MouldWidth":"0","Depth":"24.8","CargoCapacity":"-1","ShipPhone":"-1","HatchNum":"-1","GearHave":"-1","Pump":"-1","Propeller":"-1","Thruster":"-1","MainBHP":"-1","BulbousBow":"-1","PSCTime":"-1","Location":"-1","DefectsNum":"-1","UpdateDate":"2014-08-05"}]}';
              else
                try{
                  query_mmsi_Number = h2.send(req2).getBody();
                }
                catch(Exception e){}
              try{
                JSONParser parser = JSON.createParser(query_mmsi_Number);
                while (parser.nextToken() != null)
                {
                  if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('mmsi')))
                  {
                            parser.nextToken();
                            s.Mmsi=parser.getText();
                            s.online=false;
                            if(s.Imo_Number==firstIMO)
                            {
                              ship_selected[0].Mmsi__c=s.Mmsi;
                              ship_selected[0].IMO_Number__c=firstIMO;
                            }
                            else
                              break;
                        }
                  if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('shipname')))
                          if(s.Imo_Number==firstIMO)
                          {
                              parser.nextToken();
                              ship_selected[0].Vessel_Train_Truck__c=parser.getText();
                              ship_selected[0].IMO_Number__c=firstIMO;
                          }
                      }
              }
              catch(Exception e){}
            }
            if((String.IsEmpty(s.Mmsi))&&(calloutcounter<=10)) //search in vesselfinder
            {
              calloutcounter++;
              String url_imo = 'http://www.vesselfinder.com/vessels/livesearch?term='+s.Imo_Number;
              Http h2 = new Http(); 
              HttpRequest req2 = new HttpRequest();
              req2.setTimeout(100000);
              req2.setEndpoint(url_imo); 
              req2.setMethod('GET');
              String query_mmsi_Number='';
              if (Test.isRunningTest())
                query_mmsi_Number='{"n":"9982ca3c3c","list":[{"mmsi":"636015859","NAME":"MAERSK ELGIN","INRANGE":"1","DEST":" ALGECIRAS","ETATSTAMP":"1410055200","IMO":"9635640","valid_imo":"1","ll":"0"}]}';
              else
                try{
                  query_mmsi_Number = h2.send(req2).getBody();
                }
                catch(Exception e){}
              try{
                JSONParser parser = JSON.createParser(query_mmsi_Number);
                while (parser.nextToken() != null)
                {
                      if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('mmsi')))
                      {
                            parser.nextToken();
                            s.Mmsi=parser.getText();
                            s.online=false;
                            if(s.Imo_Number==firstIMO)
                            {
                              ship_selected[0].Mmsi__c=s.Mmsi;
                              ship_selected[0].IMO_Number__c=firstIMO;
                            }
                            else
                              break;
                        }
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText().equalsIgnoreCase('name')))
                          if(s.Imo_Number==firstIMO)
                          {
                              parser.nextToken();
                              ship_selected[0].Vessel_Train_Truck__c=parser.getText();
                              ship_selected[0].IMO_Number__c=firstIMO;
                          }
                  }
              }
              catch(Exception e){}
            }
          }   */       
        }
      }
          
      if((ship_selected[0].Truck_Vessel_Latitude__c==null)&&(String.isNotEmpty(ship_selected[0].IMO_Number__c))&&(calloutcounter<=10))
      {
        calloutcounter++;
        //try vessel finder
        String url_imo='http://www.vesselfinder.com/?imo='+EncodingUtil.urlEncode(ship_selected[0].IMO_Number__c, 'UTF-8');
        Http h2 = new Http(); 
        HttpRequest req2 = new HttpRequest();
        req2.setTimeout(100000);
        req2.setEndpoint(url_imo); 
        req2.setMethod('GET');
        String query_mmsi_Number='';
        if (Test.isRunningTest())
          query_mmsi_Number='<script type="text/javascript">/*<![CDATA[*/var map_options={mmsi:636015859,update_info:false, auto_track:true,latitude:26.116796666667,longitude:-15.343575,zoom:9};var map=new VFOlMap();map.init(map_options);vfme.current_picture_id = 22072; vfme.no_picture = false; vfme.first_picture_url = "/vessels/ship-photo/9635640-636015859-cda13fa0d0eb6cd2569d248053381ba8/1";jQuery(function($) {vfme.auto_device_check = false;});/*]]>*/</script>';
        else
          try{
            query_mmsi_Number = h2.send(req2).getBody();
          }
          catch(Exception e){}
        Integer pos=query_mmsi_Number.indexOf('map_options');
        if(pos>=0)
        {
          query_mmsi_Number=query_mmsi_Number.substring(pos+11);
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
                    ship_selected[0].Truck_Vessel_Latitude__c=Double.valueOf(latitude);
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
                    ship_selected[0].Truck_Vessel_Longitude__c=Double.valueOf(longitude);
                  }
                  catch(Exception e){}
          }
        }
        }
        if((ship_selected[0].Vessel_Information__c==null)&&(String.IsNotEmpty(ship_selected[0].Vessel_Name__c)))
        {
                Vessel_Information='Vessel: '+ship_selected[0].Vessel_Name__c+' |';
                ship_selected[0].Vessel_Information__c=Vessel_Information.replace(' |','\r\n');
        }
          NEU_JE_TrackAndTrace_s lastTr=null;
          for(NEU_JE_TrackAndTrace_s s:TrackAndTrace) //search for last activity
         {
                if(String.IsNotEmpty(s.Date_c))
                {
                   if(system.now().formatGmt('yyyy-MM-dd HH:mm').replace(' ','T')>s.Date_c)
                   {
                     lastTr=s;
                     break;
                   }
                }
        }
          if(lastTr!=null)
          {
            if(ship_selected[0].Date__c!=lastTr.Date_c)
            {
              ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, ship_selected[0].Id, 'Last Activity with '+operator+' operator and Track  '+track+' : '+ Number_con_book + ' of Shipment '+ ship_selected[0].Name+ ' is: \n\n'+
              'Last Activity : '+lastTr.Activity+'\n'+
              'Date : '+(lastTr.Date_c != null? lastTr.Date_c : '') +'\n'+
              'ETA_ATA : '+lastTr.ETA_ATA+'\n'+
              'ETD : '+lastTr.ETD+'\n'+
              'Location : '+lastTr.Location+'\n'+
              'Location_Code : '+lastTr.Location_Code+'\n'+
              'Operator : '+lastTr.Operator+'\n'+
              'Vessel_Train_Truck : '+lastTr.Vessel_Train_Truck+'\n'+
              'Imo_Number : '+lastTr.Imo_Number+'\n'+
              'Voyage_Number : '+lastTr.Voyage_Number+'\n'+
              'Origin : '+lastTr.Origin+'\n'+
              'Origin_Code : '+lastTr.Origin_Code+'\n'+
              'Port_Of_Loading : '+lastTr.Port_Of_Loading+'\n'+
              'Port_Of_Loading_Code : '+lastTr.Port_Of_Loading_Code+'\n'+
              'Port_Of_Discharging : '+lastTr.Port_Of_Discharging+'\n'+
              'Port_Of_Discharging_Code : '+lastTr.Port_Of_Discharging_Code+'\n'+
              'Final_Discharge : '+lastTr.Final_Discharge+'\n'+
              'Final_Discharge_Code : '+lastTr.Final_Discharge_Code+'\n');
            }
          }
          else if(TrackAndTrace.size()>0)
            lastTr=TrackAndTrace[TrackAndTrace.size()-1];
          if(lastTr!=null)
          {
            ship_selected[0].Last_Activity__c = lastTr.Activity;
            ship_selected[0].Date__c = lastTr.Date_c;
            ship_selected[0].ETA_ATA__c = lastTr.ETA_ATA;
            ship_selected[0].ATAPOD__c = lastTr.ATAPOD;
            ship_selected[0].ETD__c = lastTr.ETD;
            ship_selected[0].Location__c = lastTr.Location;
            ship_selected[0].Location_Code__c = lastTr.Location_Code;
            ship_selected[0].Operator__c = lastTr.Operator;
            if(String.IsEmpty(ship_selected[0].Vessel_Name__c))
              ship_selected[0].Vessel_Name__c = lastTr.Vessel_Train_Truck;
            if(String.IsEmpty(ship_selected[0].Imo_Number__c))
              ship_selected[0].Imo_Number__c = lastTr.Imo_Number;
            ship_selected[0].Voyage_Number__c = lastTr.Voyage_Number;
            ship_selected[0].Origin__c = lastTr.Origin;
            ship_selected[0].Origin_Code__c = lastTr.Origin_Code;
            ship_selected[0].Port_Of_Loading__c = lastTr.Port_Of_Loading;
            ship_selected[0].Port_Of_Loading_Code__c = lastTr.Port_Of_Loading_Code;
            ship_selected[0].Port_Of_Discharging__c = lastTr.Port_Of_Discharging;
            ship_selected[0].Port_Of_Discharging_Code__c = lastTr.Port_Of_Discharging_Code;
            ship_selected[0].Final_Discharge__c = lastTr.Final_Discharge;
            ship_selected[0].Final_Discharge_Code__c = lastTr.Final_Discharge_Code;
            if(String.IsEmpty(ship_selected[0].Mmsi__c))
              ship_selected[0].Mmsi__c=lastTr.Mmsi;
          }
    
      Integer posicion = TrackAndTrace.size()-1;
      List<String> abecedario = new List<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M','N','O','P','Q','R','S','T','U','V','W', 'X','Y','Z' };
      integer contador_track_and_trace = 0;
      Vessel_Activities='';
      for(NEU_JE_TrackAndTrace_s tat: TrackAndTrace)
      {
        tat.Letra_posicion = abecedario[posicion];
        posicion --;
        contador_track_and_trace ++;
        Vessel_Activities+=tat.Location+' |'+tat.Date_c+' |'+tat.Activity+' |';
      }
      ship_selected[0].Vessel_Activities__c=Vessel_Activities.replace(' |','\r\n');
      
      // ship_selected[0].TrackOptions__c =track;
        //cambio
        //ship_selected[0].Operators__c = operator;
         
      // ship_selected[0].Number__c = Number_con_book;  
       
       ship_to_update.add(ship_selected[0]);
    /*  try
      {
        update ship_selected;
      }
      catch(Exception ex){}*/
      Vessel_Name=ship_selected[0].Vessel_Name__c;
      Imo_Number=ship_selected[0].Imo_Number__c;
      MMSI=ship_selected[0].MMSI__c;
  }
  
  
  
}