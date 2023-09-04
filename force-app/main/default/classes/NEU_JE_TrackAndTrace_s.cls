global class NEU_JE_TrackAndTrace_s implements Comparable {

    global Integer compareTo(Object compareTo) {
        NEU_JE_TrackAndTrace_s compareToitem = (NEU_JE_TrackAndTrace_s)compareTo;
        Integer returnValue = 0;
        if((Date_c==null)&&(compareToitem.Date_c!=null))
        	returnValue = 1;
        if((Date_c!=null)&&(compareToitem.Date_c==null))
        	returnValue = -1;
        else if (Date_c > compareToitem.Date_c) {
            returnValue = -1;
        } else if (Date_c < compareToitem.Date_c) {
            returnValue = 1;
        }
        return returnValue;       
    }
	
    	public String ATAPOD {get; set;}
    	public String Activity {get; set;}
    	public String Activity_Code {get; set;}
    	public String Bl_no {get; set;}
    	public String Booking_no {get; set;}
    	public String Capacity {get; set;}
    	public String Container_no {get; set;}
    	public String Container_type {get; set;}
    	public String Date_c {get; set;}
    	public String ETA_ATA {get; set;}
    	public String ETD {get; set;}
    	public String Final_Discharge {get; set;}
    	public String Final_Discharge_Code {get; set;}
    	public String Imo_Number {get; set;}
    	public String Mmsi {get; set;}
    	public Boolean online{get;set;}
    	public String Location {get; set;}
    	public String Location_Code {get; set;}
    	public String Operator {get; set;}
    	public String Origin {get; set;}
    	public String Origin_Code {get; set;}
    	public String Port_Of_Discharging {get; set;}
    	public String Port_Of_Discharging_Code {get; set;}
    	public String Port_Of_Loading {get; set;}
    	public String Port_Of_Loading_Code {get; set;}
    	public String SCAC_Carrier_Code {get; set;}
    	public String Service_Name {get; set;}
    	public String Source {get; set;}
    	public String Vessel_Train_Truck {get; set;}
    	public String Voyage_Number {get; set;}
    	public String Weight {get; set;}
    	
    	public String Letra_posicion {get; set;}
    	public boolean Ha_Pasado {get; set;}
    	public boolean searched {get; set;}
    	
    	public NEU_JE_TrackAndTrace_s(String ATAPOD, String Activity, String Activity_Code, String Bl_no, String Booking_no, String Capacity, 
    	String Container_no, String Container_type, String Date_c, String ETA_ATA, String ETD, String Final_Discharge, String Final_Discharge_Code, 
    	String Imo_Number, String Location, String Location_Code, String Operator, String Origin, String Origin_Code,
    	String Port_Of_Discharging, String Port_Of_Discharging_Code, String Port_Of_Loading, String Port_Of_Loading_Code, String SCAC_Carrier_Code, String Service_Name, String Source,
    	String Vessel_Train_Truck, String Voyage_Number, String Weight, String Letra_posicion)
		{
			this.ATAPOD=ATAPOD;
			this.Activity=Activity;
			this.Activity_Code=Activity_Code;
			this.Bl_no=Bl_no;
			this.Booking_no=Booking_no;
			this.Capacity=Capacity;
			this.Container_no=Container_no;
			this.Container_type = Container_type;
			this.Ha_Pasado = false;
			this.Date_c = Date_c;
	 		if(system.now().formatGmt('yyyy-MM-dd HH:mm').replace(' ','T') > this.Date_c)
	 			this.Ha_Pasado = true;
			this.ETA_ATA=ETA_ATA;
			this.ETD=ETD;
			this.Final_Discharge=Final_Discharge.replace('&amp;','&');
			this.Final_Discharge_Code=Final_Discharge_Code;
			this.Imo_Number=Imo_Number.trim();
			if(this.Imo_Number.length()!=7)
				this.Imo_Number='';
			this.Mmsi='';
			this.online=false;
			this.Location=Location.replace('&amp;','&');
			this.Location_Code=Location_Code;
			this.Operator=Operator.replace('&amp;','&');
			this.Origin=Origin.replace('&amp;','&');
			this.Origin_Code=Origin_Code;
			this.Port_Of_Discharging=Port_Of_Discharging.replace('&amp;','&');
			this.Port_Of_Discharging_Code=Port_Of_Discharging_Code;
			this.Port_Of_Loading=Port_Of_Loading.replace('&amp;','&');
			this.Port_Of_Loading_Code = Port_Of_Loading_Code;
			this.SCAC_Carrier_Code = SCAC_Carrier_Code;
			this.Service_Name = Service_Name;
			this.Source = Source;
			this.Vessel_Train_Truck = Vessel_Train_Truck;
			this.Voyage_Number = Voyage_Number;
			this.Weight = Weight;
			
			this.Letra_posicion = Letra_posicion;
			this.searched=false;
		}
}