public with sharing class NEU_Generate_Waybill 
{
    ApexPages.StandardController con;
    
    public Shipment__c record;
    public String result {get;set;}
    public String errores {get;set;}
    public String id_waybill {get;set;}
    public Air_Waybill__c awb;
    public PageReference send;
    
    public List<Shipment_Line__c> query_shipment_lines {get;set;}
    
	public NEU_Generate_Waybill (ApexPages.StandardController stdController) 
    {
    	con = stdController;

		System.debug('id----' + con.getRecord().id);
    	
    	/* DATOS DEL SHIPMENT */
        try 
        { 
        	record = [select Id, CurrencyIsoCode, Account_for__c, Flight_Number__c, ETD_from_Point_of_Load__c,
					  Site_of_Load__c, Site_of_Discharge__c, Country_of_Load__c, Country_of_Discharge__c,
				   	  Supplier_Account__c, Consignee__c, Carrier__c, Agent_Account__c, Destination_Agent__c, 
				   	  Site_of_Load__r.Name from Shipment__c where id = :con.getRecord().id];
        } 
        catch(Exception ee){record = new Shipment__c();}
        
		/* DATOS LÍNEAS SHIPMENT */   
		query_shipment_lines = [select id, Name, Item_Name__r.Name, Shipping_Weight_Kg__c, Units_Shipped__c,
					   		    Shipping_Volume_m3__c, Extension_Item_Name__c, Container_Number__c,
					   		    Packaging_Length_cm__c, Packaging_Height_cm__c, Packaging_Width_cm__c
							    from Shipment_Line__c where Shipment__c =: record.id order by Name];
    	
    	errores = '';
        id_waybill = '';
    }
    
    public void generate_waybill()
    {  
    	List<User> user = [select Id, Name, Team__c from User where Id =: UserInfo.getUserId()];
    	
		List<Air_Waybill__c> awb_id = [SELECT Id FROM Air_Waybill__c WHERE Shipment__c =: record.Id];   	

    	if(awb_id.size()>0)
        {
        	id_waybill=awb_id[0].Id;
        	return;
        }
    	
        Air_Waybill__c new_waybill = new Air_Waybill__c();
        
        new_waybill.Shipment__c = record.Id;
        new_waybill.CurrencyIsoCode = record.CurrencyIsoCode;
        
        new_waybill.Waybill_Status__c = 'Created';
        
    	if(record.Carrier__c==null || record.Site_of_Load__c==null)
        {
        	errores='Carrier or Airport of Departure are null.';
        	return;
        } 		 		
 		new_waybill.Carrier_Account__c = record.Carrier__c;
 		new_waybill.Consignee_Account__c = record.Destination_Agent__c;
 		new_waybill.Consignee_House__c = record.Consignee__c;
 		new_waybill.Shipper_Account__c = record.Supplier_Account__c;

 		new_waybill.Country_of_Departure__c = record.Country_of_Load__c;
 		new_waybill.Airport_of_Departure__c = record.Site_of_Load__c;
 		new_waybill.Country_of_Destination__c = record.Country_of_Discharge__c;
 		new_waybill.Site_of_Destination__c = record.Site_of_Discharge__c;

		new_waybill.Flight_Number__c = record.Flight_Number__c;
		new_waybill.Date_of_Flight__c = record.ETD_from_Point_of_Load__c;
		new_waybill.at_place__c = record.Site_of_Load__r.Name.left(24);
		
		new_waybill.Issuing_Carrier_s_Signature__c = '';
		
    	// CONSTRUCCIÓN DEL AIRWAYBILL NAME + RELLENAR DATOS REFERENCIAS      	
        string ref = '';
		System.debug('SELECT Airline_Code_Number__c FROM Account WHERE Id =' + new_waybill.Carrier_Account__c);
    	List<Account> accs = [SELECT Airline_Code_Number__c FROM Account WHERE Id =: new_waybill.Carrier_Account__c];
    	if(accs.size()==0 || String.isEmpty(accs[0].Airline_Code_Number__c))
        {
        	errores='Airline Code Number is null or empty.';	
        	return;
        }        	
    	ref +=  accs[0].Airline_Code_Number__c;
    	
    	ref +=  '-';
    	
		List<Location__c> apts_dep = [SELECT IATA_Code__c FROM Location__c WHERE Id = :new_waybill.Airport_of_Departure__c];
    	if(String.isEmpty(apts_dep[0].IATA_Code__c))
        {
        	errores='Airport of Departure IATA Code is null or empty.';	
        	return;
        } 
        List<Location__c> apts_des = [SELECT IATA_Code__c FROM Location__c WHERE Id = :new_waybill.Site_of_Destination__c];
    	if(String.isEmpty(apts_des[0].IATA_Code__c))
        {
        	errores='Site of Destination IATA Code is null or empty.';	
        	return;
        }     		
		ref +=  apts_dep[0].IATA_Code__c;
		
    	ref +=  '-';
    	
    	List<Waybill_Master__c> awbms = [SELECT Id, Starting_Number__c, Count__c, Used_Numbers__c, Status__c 
    									 FROM Waybill_Master__c WHERE Airline__c =: new_waybill.Carrier_Account__c 
    									 AND Status__c = 'Open' ORDER BY CreatedDate ASC LIMIT 1];
    	
    	
    	if(awbms.size()==0)
        {
        	errores='There are no available Airwaybill Master Numbers for this Airline.';		
        	return;
        }
        
        new_waybill.Waybill_Master__c = awbms[0].Id;
        
    	new_waybill.Serial_Number__c = ('000000' + String.valueOf(awbms[0].Starting_Number__c + (awbms[0].Used_Numbers__c != null ? awbms[0].Used_Numbers__c : 0))).right(7) + String.valueOf(Math.mod(Integer.valueOf(awbms[0].Starting_Number__c + (awbms[0].Used_Numbers__c != null ? awbms[0].Used_Numbers__c : 0)), 7));
    	
    	awbms[0].Used_Numbers__c = (awbms[0].Used_Numbers__c != null ? awbms[0].Used_Numbers__c + 1 : 1);
    	if(awbms[0].Count__c == awbms[0].Used_Numbers__c)
			awbms[0].Status__c = 'Closed';
    	
        ref +=  NEU_Utils.safeString(new_waybill.Serial_Number__c);

    	new_waybill.Name = ref;
        
        //Precargar con una cuenta fija
    	new_waybill.Carriers_Agent_Account__c = null;
    	// Si el Aeropuerto no es el de Mexico City, asigno el código manualmente.
    	new_waybill.IATA_Code_Manual__c=NEU_Utils.getCarrierAgentIATA(apts_dep[0].IATA_Code__c,apts_des[0].IATA_Code__c);       	        	

        if(Test.isRunningTest())
		{
			new_waybill.Carriers_Agent_Account__c = record.Carrier__c;       	        				
		} 

        // DATOS ESPECÍFICOS PARA EL HOUSE AIRWAYBILL
        /*List<Executive__c> executives;
		if(!Test.isRunningTest())
		{
			List<Shipment__c> shipments = [SELECT Development_Executive__c FROM Shipment__c WHERE Id =: new_waybill.Shipment__c];
			
        	if(shipments.size() == 0 || shipments[0].Development_Executive__c == null)
            {
            	errores='Shipment or DE is null.';		
            	return;
            }  				
			
			// Si hemos cambiado de año reiniciamos el contador del ejecutivo, si no es así simplemente lo incrementamos
			Integer contadorAnual = [SELECT COUNT() FROM Air_Waybill__c 
									 WHERE CALENDAR_YEAR(CreatedDate) =: system.today().year() 
									 AND Shipment__r.Development_Executive__c =: shipments[0].Development_Executive__c];       
		    
			executives = [SELECT House_Counter__c, House_Executive_Letter__c 
						  FROM Executive__c WHERE Id =: shipments[0].Development_Executive__c 
						  FOR UPDATE];
											
        	if(executives.size() == 0 || executives[0].House_Counter__c == null || String.isEmpty(executives[0].House_Executive_Letter__c))
            {
            	errores='Error with Executive.';	
            	return;
            } 												 
											 
			if(contadorAnual == 0)
				executives[0].House_Counter__c = 1;
			else
				executives[0].House_Counter__c += 1;
				
			new_waybill.House_Executive_Counter__c = ('000' + (executives[0].House_Counter__c != null ? String.valueOf(executives[0].House_Counter__c) : '')).right(3);
			new_waybill.House_Executive_Letter__c = executives[0].House_Executive_Letter__c;     
			             
		}	*/	

		// CREACIÓN E INSERCCIÓN DE LAS LÍNEAS.
 		try
        {
    		insert new_waybill;
			//update executives; 
			update awbms; 
    		id_waybill = new_waybill.Id;
    		
    		awb=[select Id, Name, Airline_Code_Number__c, Serial_Number__c from Air_Waybill__c where Id=:id_waybill];  		
    		record.MAWB_Number__c=awb.Airline_Code_Number__c+'-'+awb.Serial_Number__c;    		
    		update record;
    		
    		List<Air_Waybill_Line__c> awb_lines = new List<Air_Waybill_Line__c>();
    		Integer cont = 0;
    		for(Shipment_Line__c sl : query_shipment_lines)
    		{
    			Air_Waybill_Line__c awb_line = new Air_Waybill_Line__c();
    			
    			awb_line.Air_Waybill__c = new_waybill.Id;
    			awb_line.Name = ('000' + String.valueOf(cont)).right(3);
    			awb_line.Shipment__c = record.Id;
    			awb_line.Shipment_Cargo_Line__c = sl.Id;
    			awb_line.No_of_Pieces__c = sl.Units_Shipped__c;
    			awb_line.Description__c = sl.Item_Name__r.Name;    			
    			awb_line.Gross_Weight__c = sl.Shipping_Weight_Kg__c;
    			//awb_line.Total_Volume_m3__c = sl.Shipping_Volume_m3__c;
    			awb_line.Kg_Lb__c = 'K';
    			awb_line.Length__c = sl.Packaging_Length_cm__c;
    			awb_line.Height__c = sl.Packaging_Height_cm__c;
    			awb_line.Width__c = sl.Packaging_Width_cm__c;
    			
    			/*if(awb_line.Gross_Weight__c > (awb_line.Total_Volume_m3__c/6000))
    				awb_line.Chargeable_Weight__c = awb_line.Gross_Weight__c;
    			else
    				awb_line.Chargeable_Weight__c = awb_line.Total_Volume_m3__c/6000;*/
    			
    			awb_lines.add(awb_line);
    			cont++;
    		}
    		
    		insert awb_lines;
		}
        catch(Exception ex)
        {
            errores += 'error';
            result = ''+ex.getMessage();
        }    		
    }
}