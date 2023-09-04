public with sharing class NEU_Air_Waybills_PDF 
{
    public Air_Waybill__c record;
    public String string_awb {get;set;}
    public boolean displayBackground {get;set;}
    ApexPages.StandardController con;
    
    public NEU_Air_Waybills_PDF(ApexPages.StandardController stdController) 
    {
    	con = stdController;
        
    	// DATOS DEL WAYBILL
        try 
        {
        	record = [SELECT Id, Name, Accounting_Information__c, Carrier_Account__r.Name, Alternative_Fligtht_1__c, 
        			  Airline_Code_Number__c, Airport_of_Departure__c, Site_of_Destination__c, Alternative_Fligtht_2__c, 
        			  Site_of_Destination__r.Name, Airport_of_Departure_Code__c, Total_Chargeable_Weight__c,
        			  Airport_To_by_First_Carrier__c, Airport_To_by_First_Carrier_Code__c, 
        			  Airport_To_by_Second_Carrier__c, Airport_To_by_Second_Carrier_Code__c, 
        			  Airport_To_by_Third_Carrier__c, Shipper_Account__r.Name, Weight_Charge__c,
        			  Airport_To_by_Third_Carrier_Code__c, at_place__c, Carriers_Agent_Address__c,
        			  By_First_Carrier_Account__c, By_Second_Carrier_Account__c, Currency__c,
        			  By_Third_Carrier_Account__c, Carriers_Agent_Account__c, Executed_on_date__c,
        			  Issuing_Carrier_s_Signature__c, By_Second_Carrier_Account__r.Name,
        			  Special_Customs_Information__c, Total_Number_of_Pieces__c, IATA_Code__c,
        			  Carrier_Account_Address__c, Total_Other_Charges_Due__c, Total_Collect__c,
        			  Total_Other_Charges_Due_Agent__c, Tax__c, Direct_Shipment__c, Consignee_Alternative_Account__r.Name, 
        			  Country_To_by_Second_Carrier__c, Total_Gross_Weight__c, Total_Prepaid__c,
        			  Country_To_by_Third_Carrier__c, Carriers_Agent_City__c, Flight_Number__c,
        			  Carrier_Account__c, Consignee_Account__c, Consignee_Account_Address__c,
        			  Consignee_Account_Phone__c, Country_of_Departure__c, Date_of_Flight__c,
        			  Country_To_by_First_Carrier__c, Handling_Information__c, Consignee_Alternative_Account__c, 
        			  Prepaid_Collect_Other__c, Prepaid_Collect_WT_VAL__c, Display_House_Number_on_PDF__c,
        			  By_First_Carrier_Account__r.Name, Shipments_Program__c, Shipper_Account__c,
        			  Shipper_s_Signature__c, Carriers_Agent_Account__r.Name, Valuation_Charge__c,
        			  Shipper_Account_Address__c, By_Third_Carrier_Account__r.Name, Amount_of_Insurance__c,
        			  Consignee_Account__r.Name, Airport_of_Departure__r.Name, Serial_Number__c,
        			  Shipper_Account_Phone__c, Site_of_Destination__r.IATA_Code__c, Hide_House_Totals__c,
                	  Shipper_Account__r.Brand_Name__c, Carriers_Agent_Account__r.Brand_Name__c,
                	  Airport_of_Departure__r.IATA_Code__c, By_First_Carrier_Account_Address__c,
                	  House_Reference__c, Declared_Value_For_Customs__c, Declared_Value_For_Carriage__c, 
                	  Enable_Shipper_Alternative_Address__c, Enable_Consignee_Alternative_Address__c, 
                	  Shipper_Alternative_Address__c, Shipper_Alternative_Country__c, Shipper_Alternative_Country__r.Name,
					  Shipper_Alternative_Location__c, Shipper_Alternative_Location__r.Name,
					  Consignee_Alternative_Address__c, Consignee_Alternative_Country__c, Consignee_Alternative_Country__r.Name,
					  Consignee_Alternative_Location__c, Consignee_Alternative_Location__r.Name,
					  Enable_Consignee_House_Alt_Address__c, Consignee_House__c, Consignee_House__r.Name,
					  Consignee_House_Account_Address__c, Consignee_House_Alternative_Address__c,
					  Consignee_House_Alternative_Country__c, Consignee_House_Alternative_Country__r.Name,
					  Consignee_House_Alternative_Location__c, Consignee_House_Alternative_Location__r.Name,
					  By_Second_Carrier_Account__r.Airline_Prefix__c, By_Third_Carrier_Account__r.Airline_Prefix__c,
					  Prepaid_Collect_House_Other__c, Prepaid_Collect_House_WT_VAL__c, Weight_Charge_House__c, 
					  Valuation_Charge_House__c, Tax_House__c, Total_Other_Charges_Due_Agent_House__c,
					  Total_Other_Charges_Due_House__c, Total_Prepaid_House_SBR__c, Total_WT_VAL_House__c, 
					  Total_Collect_House_SBR__c, Other_Charges_House__c, Tax_Master__c, Total_Collect_House__c, 
					  Weight_Charge_Master__c, Valuation_Charge_Master__c, Total_Other_Charges_Due_Agent_Master__c,
					  Total_Other_Charges_Due_Master__c, Total_Prepaid_Master_SBR__c, Total_WT_VAL_Master__c, 
					  Total_Collect_Master_SBR__c, Other_Charges_Master__c, Total_Prepaid_House__c, 
					  Total_Rate_Charge__c, Total_Rate_Charge_House__c, Total_Rate_Charge_Master__c, 
					  Consignee_House_Alternative_Account__c, Consignee_House_Alternative_Account__r.Name, 
					  House_Reference__r.Name, Shipper_Alternative_Account__c, Shipper_Alternative_Account__r.Name, Nature_of_Goods__c,
					  House_Reference__r.Nature_of_Goods_House__c
        			  FROM Air_Waybill__c WHERE Id = :con.getRecord().Id];
        } 
        catch(Exception ee){record = new Air_Waybill__c();}
        
       // DATOS DE LAS WAYBILL LINES MASTER
       List<Air_Waybill_Line__c> lines_master = [SELECT Id, Name, Gross_Weight__c, RCP__c ,Kg_Lb__c, Rate_Class__c, 
       									  Commodity_Item_No__c, No_of_Pieces__c, Min_Amount__c, Chargeable_Weight_Master__c,  
       									  Description__c, Total_Service_Charge__c, Nature_and_Quantity_of_Goods__c, 
       									  Total_Volume_m3__c, Comments__c, Dimensions__c, Length__c, Width__c, Height__c, 
       									  Min_Amount_Master__c, Rate_Charge__c, House_Reference__c, House_Reference__r.Name, 
       									  Rate_Charge_Master__c, Total_Service_Charge_Master__c FROM Air_Waybill_Line__c 
       									  WHERE Air_Waybill__c =: record.Id order by Name];
       									  
      	// DATOS DE LAS WAYBILL LINES HOUSE
      	List<Air_Waybill_Line__c> lines_house = [SELECT Id, Name, Gross_Weight__c, RCP__c ,Kg_Lb__c, Rate_Class__c, 
       									  Commodity_Item_No__c, No_of_Pieces__c, Min_Amount__c, Min_Amount_House__c,  
       									  Description__c, Total_Service_Charge__c, Nature_and_Quantity_of_Goods__c, Rate_Charge__c,
       									  Total_Volume_m3__c, Comments__c, Dimensions__c, Length__c, Width__c, Height__c, 
       									  Rate_Charge_House__c, Total_Service_Charge_House__c, House_Reference__r.Name, 
       									  Chargeable_Weight__c, Chargeable_Weight_House__c, House_Reference__c 
       									  FROM Air_Waybill_Line__c WHERE Air_Waybill__c =: record.Id 
       									  and House_Reference__c=:record.House_Reference__c order by Name];
       									  
       	// DATOS DE LA CONSOLIDATION MASTER 
       	List<Waybill_Consolidation__c> consolidation_master = [SELECT Id, Name FROM Waybill_Consolidation__c 
       													WHERE Waybill__c =: record.Id order by Name];
       	
       	// DATOS DE LA CONSOLIDATION HOUSE 
       	List<Waybill_Consolidation__c> consolidation_house = [SELECT Id, Name, Shipper_Account__c, Shipper_Account__r.Name, Shipper_Account_Address__c, 
       													Enable_Shipper_Alternative_Address__c, Shipper_Alternative_Address__c, 
       													Shipper_Alternative_Country__c, Shipper_Alternative_Country__r.Name, 
       													Shipper_Alternative_Location__c, Shipper_Alternative_Location__r.Name, 
       													Shipper_Account__r.BillingStreet, Shipper_Account__r.BillingCity, 
       													Shipper_Account__r.BillingState, Shipper_Account__r.BillingCountry, 
       													Consignee_House__c, Consignee_House__r.Name, Consignee_House_Account_Address__c,
       													Enable_Consignee_House_Alternative__c, Consignee_Alternative_Address__c, 
       													Consignee_Alternative_Country__c, Consignee_Alternative_Country__r.Name, 
       													Consignee_Alternative_Location__c, Consignee_Alternative_Location__r.Name, 
       													Consignee_House__r.BillingStreet, Consignee_House__r.BillingCity, 
       													Consignee_House__r.BillingState, Consignee_House__r.BillingCountry, 
       													Accounting_Information_House__c FROM Waybill_Consolidation__c 
       													WHERE Waybill__c =: record.Id and Id=:record.House_Reference__c 
       													order by Name];
       									  
       	// DATOS DEL OTHER CHARGE 
       List<Waybill_Other_Charge__c> other_charge = [SELECT Id, Charge_Amount__c, Other_Charges__c, Recipient_of_Charge_Amount__c, 
       												Other_Charge_Rate__c FROM Waybill_Other_Charge__c WHERE Waybill__c =: record.Id];
       									  
       	displayBackground = (ApexPages.currentPage().getParameters().get('background') == 'true' ? true : false);								  								     	
    	 
        string_awb ='';
        string_awb += '<div id="contenedor">';  
        
        if(displayBackground)  
        	string_awb += '    <img src="/resource/1529309927000/NEU_Air_Waybill_Background_Letter" style="position:fixed; z-index:-1; top: 2.5mm; left: 7.5mm; height: 275mm; width: 195.00mm;"/>';
 
		// MASTER AIR WAYBILL
		if(ApexPages.currentPage().getParameters().get('type') == 'master')
   		{
	        // 	1A		1		1B					1A		1B
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 1.05cm;" class="referencia">'+NEU_Utils.safeString(record.Airline_Code_Number__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 1.95cm;" class="referencia">'+NEU_Utils.safeString(record.Airport_of_Departure__r.IATA_Code__c).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 3cm;" class="referencia">'+NEU_Utils.safeString(record.Serial_Number__c)+'</span>';
	          
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 17.25cm;" class="referencia">'+NEU_Utils.safeString(record.Airline_Code_Number__c)+'-'+NEU_Utils.safeString(record.Serial_Number__c)+'</span>';      
	        
	        
	        // 	1C
	        string_awb += '<span style="position: absolute; top: 1.15cm; left: 13.05cm; width: 250px;">'+NEU_Utils.safeString(record.By_First_Carrier_Account__r.Name).left(47).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 1.80cm; left: 13.05cm; width: 250px;">'+NEU_Utils.safeString(record.By_First_Carrier_Account_Address__c).toUpperCase()+'</span>';
	        
	        
	        // 	2
	        if(!record.Direct_Shipment__c)
	        {
		        string_awb += '<span style="position: absolute; top: 2cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Carriers_Agent_Account__r.Name).left(43).toUpperCase()+'</span>';
		        string_awb += '<span style="position: absolute; top: 2.35cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Carriers_Agent_Address__c).toUpperCase()+'</span>';
	        }
	        else
	        {
	        	if(!record.Enable_Shipper_Alternative_Address__c)
		        {		        	
		        	string_awb += '<span style="position: absolute; top: 2cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Shipper_Account__r.Name).left(43).toUpperCase()+'</span>';
			        string_awb += '<span style="position: absolute; top: 2.35cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Shipper_Account_Address__c).toUpperCase()+'</span>';	        	
		        }
		        else
		        {
		        	string_awb += '<span style="position: absolute; top: 2cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Shipper_Alternative_Account__r.Name).left(43).toUpperCase()+'</span>';
			        string_awb += '<span style="position: absolute; top: 2.35cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Shipper_Alternative_Address__c).toUpperCase()+', '+NEU_Utils.safeString(record.Shipper_Alternative_Location__r.Name).toUpperCase()+', '+NEU_Utils.safeString(record.Shipper_Alternative_Country__r.Name).toUpperCase()+'</span>';	        			        	
		        }
	        }
	        
	        
	        // 	4
	        if(!record.Direct_Shipment__c)
	        {
		        if(!record.Enable_Consignee_Alternative_Address__c)
		        {
		        	string_awb += '<span style="position: absolute; top: 4.10cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safestring(record.Consignee_Account__r.Name).left(86).toUpperCase()+'</span>';
		        	string_awb += '<span style="position: absolute; top: 4.90cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Consignee_Account_Address__c).toUpperCase()+'</span>';
		        }
		        else
		        {
		        	string_awb += '<span style="position: absolute; top: 4.10cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safestring(record.Consignee_Alternative_Account__r.Name).left(86).toUpperCase()+'</span>';
		        	string_awb += '<span style="position: absolute; top: 4.90cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Consignee_Alternative_Address__c).toUpperCase()+', '+NEU_Utils.safeString(record.Consignee_Alternative_Location__r.Name).toUpperCase()+', '+NEU_Utils.safeString(record.Consignee_Alternative_Country__r.Name).toUpperCase()+'</span>';	        	
		        }
	        }
	        else
	        {
		        if(!record.Enable_Consignee_House_Alt_Address__c)
		        {
		        	string_awb += '<span style="position: absolute; top: 4.10cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safestring(record.Consignee_House__r.Name).left(86).toUpperCase()+'</span>';
		        	string_awb += '<span style="position: absolute; top: 4.90cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Consignee_House_Account_Address__c).toUpperCase()+'</span>';
		        }
		        else
		        {
		        	string_awb += '<span style="position: absolute; top: 4.10cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safestring(record.Consignee_House_Alternative_Account__r.Name).left(86).toUpperCase()+'</span>';
		        	string_awb += '<span style="position: absolute; top: 4.90cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Consignee_House_Alternative_Address__c).toUpperCase()+', '+NEU_Utils.safeString(record.Consignee_House_Alternative_Location__r.Name).toUpperCase()+', '+NEU_Utils.safeString(record.Consignee_House_Alternative_Country__r.Name).toUpperCase()+'</span>';
		        }
	        }
	        
	       
	        // 	6
	        string_awb += '<span style="position: absolute; top: 6.50cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Carriers_Agent_Account__r.Name).left(43).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 6.85cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Carriers_Agent_City__c).toUpperCase()+'</span>';
	    
	
			// 	7		8
	       	string_awb += '<span style="position: absolute; top: 8.20cm; left: 1.05cm;">'+NEU_Utils.safeString(record.IATA_Code__c)+'</span>';		    
	        string_awb += '<span style="position: absolute; top: 8cm; left: 1.25cmpx;"></span>';
	        
	        
	        // 	9
	        string_awb += '<span style="position: absolute; top: 9cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Airport_of_Departure__r.Name).left(43).toUpperCase()+'</span>';
	        
	
			//	10
	        string_awb += '<span style="position: absolute; top: 6.45cm; left: 10.55cm; width: 340px;">'+NEU_Utils.safeString(record.Accounting_Information__c).toUpperCase()+'</span>';
	        
	
			// 	34A		34B
	        string_awb += '<span style="position: absolute; top: 6.45cm; left: 360px;"></span>';
	        string_awb += '<span style="position: absolute; top: 6.45cm; left: 500px; font-size: 10px;"></span>';        
	        
	
			//	11A		11B		11C		11D		11E		11F         
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 1.05cm;">'+NEU_Utils.safeString(record.Airport_To_by_First_Carrier_Code__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 2.10cm; font-size: 9px; width: 175px;">'+NEU_Utils.safeString(record.By_First_Carrier_Account__r.Name).left(27).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 6.75cm;">'+NEU_Utils.safeString(record.Airport_To_by_Second_Carrier_Code__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 7.75cm;">'+NEU_Utils.safeString(record.By_Second_Carrier_Account__r.Airline_Prefix__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 8.55cm;">'+NEU_Utils.safeString(record.Airport_To_by_Third_Carrier_Code__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 9.55cm;">'+NEU_Utils.safeString(record.By_Third_Carrier_Account__r.Airline_Prefix__c)+'</span>';
	
	
			//	12
	        if (!Test.isRunningTest())
	        	string_awb += '<span style="position: absolute; top: 9.90cm; left: 10.40cm;">'+ NEU_CurrencyUtils.getCurrencyIsoCode(record)+'</span>';        
	        
	
			//	13
			if (record.Prepaid_Collect_Other__c == 'Prepaid' && record.Prepaid_Collect_WT_VAL__c == 'Prepaid')
				string_awb += '<span style="position: absolute; top: 10cm; left: 11.40cm; font-size: 10px">PP</span>';		
			else if (record.Prepaid_Collect_Other__c == 'Collect' && record.Prepaid_Collect_WT_VAL__c == 'Collect')
				string_awb += '<span style="position: absolute; top: 10cm; left: 11.40cm; font-size: 10px">CC</span>';		
	        	        
	
	
			//	14A		14B		
			if(record.Prepaid_Collect_WT_VAL__c != null || Test.isRunningTest())
			{          
				if(NEU_Utils.safeString(record.Prepaid_Collect_WT_VAL__c) == 'Prepaid')
					string_awb += '<span style="position: absolute; top: 10cm; left: 11.95cm;">X</span>';
				else if(NEU_Utils.safeString(record.Prepaid_Collect_WT_VAL__c) == 'Collect')
					string_awb += '<span style="position: absolute; top: 10cm; left: 12.45cm;">X</span>';
			}
			
			
			//	15A		15B
			if(record.Prepaid_Collect_Other__c != null || Test.isRunningTest())
			{
				if(NEU_Utils.safeString(record.Prepaid_Collect_Other__c) == 'Prepaid')
					string_awb += '<span style="position: absolute; top: 10cm; left: 12.95cm;">X</span>';
				else if(NEU_Utils.safeString(record.Prepaid_Collect_Other__c) == 'Collect')
					string_awb += '<span style="position: absolute; top: 10cm; left: 13.45cm;">X</span>';
			}
	        
			
			//	16		17     
	       	string_awb += '<span style="position: absolute; top: 9.90cm; left: 14.75cm;">'+(record.Declared_Value_For_Carriage__c == null || record.Declared_Value_For_Carriage__c == 0 ? 'NVD' : NEU_Utils.safeString(record.Declared_Value_For_Carriage__c))+'</span>';
	       	string_awb += '<span style="position: absolute; top: 9.90cm; left: 17.80cm;">'+(record.Declared_Value_For_Customs__c == null || record.Declared_Value_For_Customs__c == 0 ? 'NCV' : NEU_Utils.safeString(record.Declared_Value_For_Customs__c))+'</span>';     
	        
	        
	        // 18
	        string_awb += '<span style="position: absolute; top: 10.75cm; left: 1.05cm; width: 175px;">'+NEU_Utils.safeString(record.Site_of_Destination__r.Name).left(22).toUpperCase()+'</span>';


	        // 19A
	        if(record.Alternative_Fligtht_1__c != null)
	        	string_awb += '<span style="position: absolute; top: 10.75cm; left: 6.00cm; width: 100px;">'+NEU_Utils.safeString(record.Alternative_Fligtht_1__c)+'</span>';
	        else
	        	string_awb += '<span style="position: absolute; top: 10.75cm; left: 6.00cm; width: 100px;">'+NEU_Utils.safeString(record.Flight_Number__c)+'</span>';	
	      	
	      	
	      	// 19B
	      	if(record.Alternative_Fligtht_2__c != null)
	      		string_awb += '<span style="position: absolute; top: 10.75cm; left: 8.25cm; width: 100px;">'+NEU_Utils.safeString(record.Alternative_Fligtht_2__c)+'</span>';
	      	else
	      		string_awb += '<span style="position: absolute; top: 10.75cm; left: 8.25cm; width: 100px;">'+NEU_Utils.safeString((record.Date_of_Flight__c != null ? record.Date_of_Flight__c.format() : ''))+'</span>';
	      
	      
	        // 20
			string_awb += '<span style="position: absolute; top: 10.75cm; left: 11cm;">'+(record.Amount_of_Insurance__c == null || record.Amount_of_Insurance__c == 0 ? 'NIL' : NEU_Utils.safeString(record.Amount_of_Insurance__c))+'</span>';        
	        
	
			// 21		21A        
	       	string_awb += '<span style="position: absolute; top: 11.70cm; left: 1.05cm; width: 450px;">'+NEU_Utils.safeString(record.Handling_Information__c).toUpperCase()+'</span>';        
	       	string_awb += '<span style="position: absolute; top: 12.45cm; left: 18.40cm; width: 100px;">'+NEU_Utils.safeString(record.Special_Customs_Information__c).toUpperCase()+'</span>';
	
			decimal total = 0.00;
			//	AIRWAYBILL LINES (CON RESUMEN DE LÍNEAS ACTIVO)
			if(lines_master.size()>0)
			{
				decimal position_top = 14;
				String comments='';
				String house='';
				String description='';
				decimal m3=0.0;
				decimal commodity=0.0;				
				if(record.House_Reference__c == null)
				{
					string_awb ='';
					return;
				}
				for(Air_Waybill_Line__c awl: lines_master)
				{
					if(awl.Rate_Charge__c==null)
					{
						string_awb ='';
						return;	
					}
					if(awl.House_Reference__c == null)
					{
						string_awb ='';
						return;	
					} 					
						// 	22A					
						string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 20.00cm;" class="lines">'+NEU_Utils.safeDecimal(record.Total_Number_of_Pieces__c)+'</span>';	
						//	22B
						string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 18.20cm;" class="lines">'+NEU_Utils.safeDecimal(record.Total_Gross_Weight__c)+'</span>';	
						//	22C
						string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 3.7cm;" class="lines">'+NEU_Utils.safeString(awl.Kg_Lb__c)+'</span>';
						//	22D
						string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 4.2cm;" class="lines">'+(awl.Rate_Class__c != null ? awl.Rate_Class__c.substring(0,1) : '')+'</span>';
						//	22F
						string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 13.50cm;" class="lines">'+(NEU_Utils.safeDecimal(awl.Chargeable_Weight_Master__c) != 0 ? NEU_Utils.safeDecimal(awl.Chargeable_Weight_Master__c) : NEU_Utils.safeDecimal(record.Total_Chargeable_Weight__c))+'</span>';
						//	22G
						string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 11.20cm;" class="lines">'+(NEU_Utils.safeDecimal(awl.Rate_Charge_Master__c) != 0 ? NEU_Utils.safeDecimal(awl.Rate_Charge_Master__c) : NEU_Utils.safeDecimal(awl.Rate_Charge__c))+'</span>';									
						if (NEU_Utils.safeDecimal(awl.Min_Amount_Master__c) != 0)
							total=awl.Min_Amount_Master__c;
						else
							total = (NEU_Utils.safeDecimal(awl.Rate_Charge_Master__c) != 0 ? NEU_Utils.safeDecimal(record.Total_Chargeable_Weight__c*awl.Rate_Charge_Master__c) : NEU_Utils.safeDecimal(record.Total_Chargeable_Weight__c*awl.Rate_Charge__c));
						//	22H
						string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 7.75cm;" class="lines">'+total.setScale(2)+'</span>';										
						comments=(awl.Comments__c != null ? awl.Comments__c.toUpperCase() : '');
						description=(awl.Description__c != null ? awl.Description__c.left(150).toUpperCase() : '');	
						break;						
				}
				Integer i = 0;
				if(record.Display_House_Number_on_PDF__c && record.House_Reference__c != null)
				{
					for(Waybill_Consolidation__c conso: consolidation_master)
					{
						if(i != 0)
							house+=' - ';	
						house+=conso.Name;
						i++;
					}
				}
				//	22I	
				/*string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 14.75cm; width: 200px;" class="lines">'+(comments != '' ? comments +'<br/><br/>': '')+(house != '' ? 'HOUSES ' + house + '<br/><br/>': '');	
				for(Air_Waybill_Line__c awl: lines_master)
				{	
					string_awb +=(awl.Length__c != null && awl.Width__c != null && awl.Height__c != null ? awl.Dimensions__c : '')+'<br/>';
					m3+=NEU_Utils.safeDecimal(awl.Total_Volume_m3__c);		
					commodity+=(awl.Commodity_Item_No__c != null ? NEU_Utils.safeDecimal(awl.Commodity_Item_No__c) : 0.00);																		
				}
				string_awb +='<br/>'+NEU_Utils.safeString(description)+'<br/><br/>'+(m3 != null ? m3 + ' CBM' : '')+'</span>';*/
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 14.75cm; width: 200px;" class="lines">'+(record.Nature_of_Goods__c != null ? record.Nature_of_Goods__c : '')+'</span>';
				
				//	22E
				//string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 5.15cm; width: 50px;" class="lines">'+NEU_Utils.safeString(commodity)+'</span>';
			}	
			/*
			// AIRWAYBILL LINES (SIN RESUMEN DE LÍNEAS)
			if(lines.size()>0)
			{
				decimal position_top = 13.70;
				for(Air_Waybill_Line__c awl: lines)
				{	
					// 	22A
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 20.00cm;" class="lines">'+NEU_Utils.safeDecimal(awl.No_of_Pieces__c)+'</span>';	
					//	22B
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 18.20cm;" class="lines">'+NEU_Utils.safeDecimal(awl.Gross_Weight__c)+'</span>';	
					//	22C
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 3.55cm;" class="lines">'+NEU_Utils.safeString(awl.Kg_Lb__c)+'</span>';
					//	22D
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 4.05cm;" class="lines">'+(awl.Rate_Class__c != null ? awl.Rate_Class__c.substring(0,1) : '')+'</span>';
					//	22E
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 5.15cm; width: 50px;" class="lines">'+NEU_Utils.safeString(awl.Commodity_Item_No__c)+'</span>';
					//	22F
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 13.50cm;" class="lines">'+NEU_Utils.safeDecimal(awl.Chargeable_Weight__c)+'</span>';
					//	22G
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 11.20cm;" class="lines">'+(awl.Rate_Charge_Master__c != null ? NEU_Utils.safeDecimal(awl.Rate_Charge_Master__c) : NEU_Utils.safeDecimal(awl.Rate_Charge__c))+'</span>';
					//	22H
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 7.75cm;" class="lines">'+(awl.Total_Service_Charge_Master__c != null ? NEU_Utils.safeDecimal(awl.Total_Service_Charge_Master__c) : NEU_Utils.safeDecimal(awl.Total_Service_Charge__c))+'</span>';
					//	22I					
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 14.50cm; width: 185px; font-size: 10px;" class="lines">'+(awl.Comments__c != null ? awl.Comments__c.toUpperCase() +'<br/>': '')+NEU_Utils.safeString(awl.Description__c).left(26).toUpperCase()+'<br/>'+(record.Display_House_Number_on_PDF__c ? 'HOUSES ' + record.House_Reference__c.toUpperCase() + '<br/>' : '')+(awl.Length__c != null && awl.Width__c != null && awl.Height__c != null ? awl.Dimensions__c : '')+'<br/>'+(awl.Total_Volume_m3__c != null ? awl.Total_Volume_m3__c + ' CBM' : '')+'</span>';
					position_top += 1.90;
				}
			}
			*/
	
	
			//	22J		22K		22L
	       	string_awb += '<span style="position: absolute; top: 19.40cm; right: 20.00cm;">'+NEU_Utils.safeDecimal(record.Total_Number_of_Pieces__c)+'</span>'; 
	       	string_awb += '<span style="position: absolute; top: 19.40cm; right: 18.20cm;">'+NEU_Utils.SafeDecimal(record.Total_Gross_Weight__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 19.40cm; right: 7.75cm;">'+total.setScale(2)+'</span>';       	
	
	
			// 23
			decimal position_top_other = 20.50;
			decimal position_left_other = 8.5;
			if(record.Other_Charges_Master__c == null)
			{
				if(other_charge.size()>0)
				{
					integer i=1;
					for(Waybill_Other_Charge__c oc: other_charge)
					{
						string_awb += '<span style="position: absolute; top: '+position_top_other+'cm; left: '+position_left_other+'cm; width: 420 px;">'+NEU_Utils.safeString(oc.Other_Charges__c)+NEU_Utils.safeString(oc.Recipient_of_Charge_Amount__c)+' '+NEU_Utils.SafeDecimal(oc.Charge_Amount__c)+'</span>';	
						position_top_other += 0.75;
						i++;
						if(i==4 || i==7)
						{
							position_top_other = 20.50;
							position_left_other += 4.00;
						}
					}	       	            
				}
			}
			else
				string_awb += '<span style="position: absolute; top: '+position_top_other+'cm; left: '+position_left_other+'cm; width: 420 px;">'+NEU_Utils.safeString(record.Other_Charges_Master__c)+'</span>';
			
	
	
			//	24A		24B
			if(record.Prepaid_Collect_WT_VAL__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_WT_VAL__c == 'Prepaid')
					string_awb += '<span style="position: absolute; top: 20.50cm; right: 17.50cm;">'+(record.Weight_Charge_Master__c != null ? NEU_Utils.safeDecimal(record.Weight_Charge_Master__c.setScale(2)) : NEU_Utils.safeDecimal(record.Weight_Charge__c.setScale(2)))+'</span>';
				else if(record.Prepaid_Collect_WT_VAL__c == 'Collect')
					string_awb += '<span style="position: absolute; top: 20.50cm; right: 13.75cm;">'+(record.Weight_Charge_Master__c != null ? NEU_Utils.safeDecimal(record.Weight_Charge_Master__c.setScale(2)) : NEU_Utils.safeDecimal(record.Weight_Charge__c.setScale(2)))+'</span>';
			}
	
	
	        // 	25A		25B 
			if(record.Prepaid_Collect_WT_VAL__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_WT_VAL__c == 'Prepaid')
					string_awb += '<span style="position: absolute; top: 21.30cm; right: 17.50cm;">'+(record.Valuation_Charge_Master__c != null ? NEU_Utils.safeDecimal(record.Valuation_Charge_Master__c) : NEU_Utils.safeDecimal(record.Valuation_Charge__c))+'</span>';
				else if(record.Prepaid_Collect_WT_VAL__c == 'Collect')
					string_awb += '<span style="position: absolute; top: 21.30cm; right: 13.75cm;">'+(record.Valuation_Charge_Master__c != null ? NEU_Utils.safeDecimal(record.Valuation_Charge_Master__c) : NEU_Utils.safeDecimal(record.Valuation_Charge__c))+'</span>';
			}              
	
	
			//	26A		26B
			if(record.Prepaid_Collect_WT_VAL__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_WT_VAL__c == 'Prepaid')
					string_awb += '<span style="position: absolute; top: 22.25cm; right: 17.50cm;">'+(record.Tax_Master__c != null ? NEU_Utils.safeDecimal(record.Tax_Master__c) : NEU_Utils.safeDecimal(record.Tax__c))+'</span>';
				else if(record.Prepaid_Collect_WT_VAL__c == 'Collect')
					string_awb += '<span style="position: absolute; top: 22.25cm; right: 13.75cm;">'+(record.Tax_Master__c != null ? NEU_Utils.safeDecimal(record.Tax_Master__c) : NEU_Utils.safeDecimal(record.Tax__c))+'</span>';
			}				
	
	
	        //	27A		27B
			if(record.Prepaid_Collect_Other__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_Other__c == 'Prepaid')
					string_awb += '<span style="position: absolute;  top: 23.1cm; right: 17.50cm;">'+(record.Total_Other_Charges_Due_Agent_Master__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent_Master__c) : NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent__c))+'</span>';
				else if(record.Prepaid_Collect_Other__c == 'Collect')
					string_awb += '<span style="position: absolute;  top: 23.1cm; right: 13.75cm;">'+(record.Total_Other_Charges_Due_Agent_Master__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent_Master__c) : NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent__c))+'</span>';
			}
			
			
			//	28A		28B   	
			if(record.Prepaid_Collect_Other__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_Other__c == 'Prepaid')
					string_awb += '<span style="position: absolute;  top: 23.95cm;  right: 17.50cm;">'+(record.Total_Other_Charges_Due_Master__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Master__c) : NEU_Utils.safeDecimal(record.Total_Other_Charges_Due__c))+'</span>';
				else if(record.Prepaid_Collect_Other__c == 'Collect')
					string_awb += '<span style="position: absolute;  top: 23.95cm;  right: 13.75cm;">'+(record.Total_Other_Charges_Due_Master__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Master__c) : NEU_Utils.safeDecimal(record.Total_Other_Charges_Due__c))+'</span>';
			}
	
	
	        //	30A		30B
	        if(record.Prepaid_Collect_Other__c == 'Prepaid')
	        	string_awb += '<span style="position: absolute; top: 25.70cm; right: 17.50cm;">'+(record.Total_Prepaid_Master_SBR__c != 0 ? NEU_Utils.safeDecimal(record.Total_Prepaid_Master_SBR__c) : NEU_Utils.safeDecimal(record.Total_Prepaid__c))+'</span>';
	       	if(record.Prepaid_Collect_Other__c == 'Collect')
	       		string_awb += '<span style="position: absolute; top: 25.70cm; right: 13.75cm;">'+(record.Total_Collect_Master_SBR__c != 0 ? NEU_Utils.safeDecimal(record.Total_Collect_Master_SBR__c) : NEU_Utils.safeDecimal(record.Total_Collect__c))+'</span>';   
	
	
			//	31
			string_awb += '    <span style="position: absolute; top: 23.95cm; left: 8.50cm; width: 420px; text-align: center;">'+NEU_Utils.safeString(record.Shipper_Account__r.Name)+'</span>';     
	       	string_awb += '    <span style="position: absolute; top: 24.30cm; left: 8.50cm; width: 420px; text-align: center;">'+NEU_Utils.safeString(record.Shipper_s_Signature__c)+'</span>';     
	     
	       	
			//	32A		32B		32C		
	        string_awb += '<span style="position: absolute; top: 25.75cm; left: 8.50cm; width: 100px;">'+(record.Executed_on_date__c != null ? record.Executed_on_date__c.format() : '')+'</span>';
	        string_awb += '<span style="position: absolute; top: 25.75cm; left: 11.70cm; width: 100px; text-align: center;">'+(record.at_place__c != null ? NEU_Utils.safeString(record.at_place__c).toUpperCase() : '')+'</span>';
	        string_awb += '<span style="position: absolute; top: 25.75cm; left: 15.55cm; width: 150px; text-align: center;">'+NEU_Utils.safeString(record.Issuing_Carrier_s_Signature__c).toUpperCase()+'</span>';
	
			
			// 	1A		1B  
			string_awb += '    <span style="position: absolute; top: 27.1cm; left: 17.75cm;" class="referencia">'+NEU_Utils.safeString(record.Airline_Code_Number__c)+'-'+NEU_Utils.safeString(record.Serial_Number__c)+'</span>';   			
   		}
   		// HOUSE AIR WAYBILL
   		else
   		{	
   			// 	1A		1		1B					1A		1B
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 1.05cm;" class="referencia">'+NEU_Utils.safeString(record.Airline_Code_Number__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 1.95cm;" class="referencia">'+NEU_Utils.safeString(record.Airport_of_Departure__r.IATA_Code__c).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 3cm;" class="referencia">'+NEU_Utils.safeString(record.Serial_Number__c)+'</span>';
	        
	        string_awb += '<span style="position: absolute; top: 0.35cm;  left: 17.25cm;" class="referencia">'+NEU_Utils.safeString(record.House_Reference__r.Name)+'</span>';      
	        
	        
	        // 	1C
	        string_awb += '<span style="position: absolute; top: 1.15cm; left: 13.05cm; width: 250px;">'+NEU_Utils.safeString(record.Carriers_Agent_Account__r.Name).left(47).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 1.80cm; left: 13.05cm; width: 250px;">'+NEU_Utils.safeString(record.Carriers_Agent_Address__c).toUpperCase()+'</span>';
	        

			 // 	2
			string_awb += '<span style="position: absolute; top: 2cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(consolidation_house[0].Shipper_Account__r.Name).left(43).toUpperCase()+'</span>';
	        if(!consolidation_house[0].Enable_Shipper_Alternative_Address__c)
	        	string_awb += '<span style="position: absolute; top: 2.35cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(consolidation_house[0].Shipper_Account_Address__c).toUpperCase()+'</span>';
	        else
	        	string_awb += '<span style="position: absolute; top: 2.35cm;  left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(consolidation_house[0].Shipper_Alternative_Address__c).toUpperCase()+', '+NEU_Utils.safeString(consolidation_house[0].Shipper_Alternative_Location__r.Name).toUpperCase()+', '+NEU_Utils.safeString(consolidation_house[0].Shipper_Alternative_Country__r.Name).toUpperCase()+'</span>';	        	
			

	        // 	4
	        string_awb += '<span style="position: absolute; top: 4.10cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safestring(consolidation_house[0].Consignee_House__r.Name).left(86).toUpperCase()+'</span>';
	        if(!consolidation_house[0].Enable_Consignee_House_Alternative__c)
	        	string_awb += '<span style="position: absolute; top: 4.90cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(consolidation_house[0].Consignee_House_Account_Address__c).toUpperCase()+'</span>';
	        else
	        	string_awb += '<span style="position: absolute; top: 4.90cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(consolidation_house[0].Consignee_Alternative_Address__c).toUpperCase()+', '+NEU_Utils.safeString(consolidation_house[0].Consignee_Alternative_Location__r.Name).toUpperCase()+', '+NEU_Utils.safeString(consolidation_house[0].Consignee_Alternative_Country__r.Name).toUpperCase()+'</span>';
	       
	       
	        // 	6
	        string_awb += '<span style="position: absolute; top: 6.50cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Carriers_Agent_Account__r.Name).left(43).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 6.85cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Carriers_Agent_City__c).toUpperCase()+'</span>';
	    
	
			// 	7		8
	       	string_awb += '<span style="position: absolute; top: 8.20cm; left: 1.05cm;">'+NEU_Utils.safeString(record.IATA_Code__c)+'</span>';		    
	        string_awb += '<span style="position: absolute; top:8cm; left: 210px;"></span>';
	        
	        
	        // 	9
	        string_awb += '<span style="position: absolute; top: 9cm; left: 1.05cm; width: 325px;">'+NEU_Utils.safeString(record.Airport_of_Departure__r.Name).left(43).toUpperCase()+'</span>';
	        
	
			//	10
			if(consolidation_house[0].Accounting_Information_House__c != null)
	        	string_awb += '<span style="position: absolute; top: 6.45cm; left: 10.55cm; width: 340px;">'+NEU_Utils.safeString(consolidation_house[0].Accounting_Information_House__c).toUpperCase()+'</span>';
	        else
	        	string_awb += '<span style="position: absolute; top: 6.45cm; left: 10.55cm; width: 340px;">'+NEU_Utils.safeString(record.Accounting_Information__c).toUpperCase()+'</span>';
	        
	
			// 	34A		34B
	        string_awb += '<span style="position: absolute; top: 6.45cm; left: 360px;"></span>';
	        string_awb += '<span style="position: absolute; top: 6.45cm; left: 500px; font-size: 10px;"></span>';        
	        
	
			//	11A		11B		11C		11D		11E		11F         
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 1.05cm;">'+NEU_Utils.safeString(record.Airport_To_by_First_Carrier_Code__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 2.10cm; font-size: 9px; width: 175px;">'+NEU_Utils.safeString(record.By_First_Carrier_Account__r.Name).left(27).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 6.75cm;">'+NEU_Utils.safeString(record.Airport_To_by_Second_Carrier_Code__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 7.75cm;">'+NEU_Utils.safeString(record.By_Second_Carrier_Account__r.Airline_Prefix__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 8.55cm;">'+NEU_Utils.safeString(record.Airport_To_by_Third_Carrier_Code__c)+'</span>';
	        string_awb += '<span style="position: absolute; top: 9.90cm; left: 9.55cm;">'+NEU_Utils.safeString(record.By_Third_Carrier_Account__r.Airline_Prefix__c)+'</span>';
	
	
			//	12
	        if (!Test.isRunningTest())
	        	string_awb += '<span style="position: absolute; top: 9.90cm; left: 10.40cm;">'+ NEU_CurrencyUtils.getCurrencyIsoCode(record)+'</span>';        
	        
	
			//	13
			if (record.Prepaid_Collect_House_Other__c == 'Prepaid' && record.Prepaid_Collect_House_WT_VAL__c == 'Prepaid')
				string_awb += '<span style="position: absolute; top: 10cm; left: 11.40cm; font-size: 10px">PP</span>';		
			else if (record.Prepaid_Collect_House_Other__c == 'Collect' && record.Prepaid_Collect_House_WT_VAL__c == 'Collect')
				string_awb += '<span style="position: absolute; top: 10cm; left: 11.40cm; font-size: 10px">CC</span>';		
	
	
			//	14A		14B		
			if(record.Prepaid_Collect_House_WT_VAL__c != null || Test.isRunningTest())
			{          
				if(NEU_Utils.safeString(record.Prepaid_Collect_House_WT_VAL__c) == 'Prepaid')
					string_awb += '<span style="position: absolute; top: 10cm; left: 11.95cm;">X</span>';
				else if(NEU_Utils.safeString(record.Prepaid_Collect_House_WT_VAL__c) == 'Collect')
					string_awb += '<span style="position: absolute; top: 10cm; left: 12.45cm;">X</span>';
			}
			
			
			//	15A		15B
			if(record.Prepaid_Collect_House_Other__c != null || Test.isRunningTest())
			{
				if(NEU_Utils.safeString(record.Prepaid_Collect_House_Other__c) == 'Prepaid')
					string_awb += '<span style="position: absolute; top: 10cm; left: 12.95cm;">X</span>';
				else if(NEU_Utils.safeString(record.Prepaid_Collect_House_Other__c) == 'Collect')
					string_awb += '<span style="position: absolute; top: 10cm; left: 13.45cm;">X</span>';
			}
	        
			
			//	16		17     
	       	string_awb += '<span style="position: absolute; top: 9.90cm; left: 14.75cm;">'+(record.Declared_Value_For_Carriage__c == null || record.Declared_Value_For_Carriage__c == 0 ? 'NVD' : NEU_Utils.safeString(record.Declared_Value_For_Carriage__c))+'</span>';
	       	string_awb += '<span style="position: absolute; top: 9.90cm; left: 17.80cm;">'+(record.Declared_Value_For_Customs__c == null || record.Declared_Value_For_Customs__c == 0 ? 'NCV' : NEU_Utils.safeString(record.Declared_Value_For_Customs__c))+'</span>';     
	        
	        
	        // 18
	        string_awb += '<span style="position: absolute; top: 10.75cm; left: 1.05cm; width: 175px;">'+NEU_Utils.safeString(record.Site_of_Destination__r.Name).left(22).toUpperCase()+'</span>';


			// 19A
	        if(record.Alternative_Fligtht_1__c != null)
	        	string_awb += '<span style="position: absolute; top: 10.75cm; left: 6.00cm; width: 100px;">'+NEU_Utils.safeString(record.Alternative_Fligtht_1__c)+'</span>';
	        else
	        	string_awb += '<span style="position: absolute; top: 10.75cm; left: 6.00cm; width: 100px;">'+NEU_Utils.safeString(record.Flight_Number__c)+'</span>';	
	      	
	      	
	      	// 19B
	      	if(record.Alternative_Fligtht_2__c != null)
	      		string_awb += '<span style="position: absolute; top: 10.75cm; left: 8.25cm; width: 100px;">'+NEU_Utils.safeString(record.Alternative_Fligtht_2__c)+'</span>';
	      	else
	      		string_awb += '<span style="position: absolute; top: 10.75cm; left: 8.25cm; width: 100px;">'+NEU_Utils.safeString((record.Date_of_Flight__c != null ? record.Date_of_Flight__c.format() : ''))+'</span>';


	        // 20
			string_awb += '<span style="position: absolute; top: 10.75cm; left: 11cm;">'+(record.Amount_of_Insurance__c == null || record.Amount_of_Insurance__c == 0 ? 'NIL' : NEU_Utils.safeString(record.Amount_of_Insurance__c))+'</span>';        
	        
	
			// 21		21A        
	       	string_awb += '<span style="position: absolute; top: 11.70cm; left: 1.05cm; width: 450px;">'+NEU_Utils.safeString(record.Handling_Information__c).toUpperCase()+'</span>';        
	       	string_awb += '<span style="position: absolute; top: 12.45cm; left: 18.40cm; width: 100px;">'+NEU_Utils.safeString(record.Special_Customs_Information__c).toUpperCase()+'</span>';
	
	
			decimal position_top = 14;
			String description='';
			decimal m3=0.0;
			decimal commodity=0.0;
			decimal pieces = 0;
			decimal gross = 0.0;
			decimal chargeable = 0.0;
			decimal total = 0.0;
			String rate_class;
			String kg;
			decimal rate_charge = 0.0;
			//	AIRWAYBILL LINES (CON RESUMEN DE LÍNEAS ACTIVO)
			if(lines_house.size()>0)
			{
				if(record.House_Reference__c == null)
				{
					string_awb ='';
					return;
				}
				for(Air_Waybill_Line__c awl: lines_house)
				{
					if(awl.Rate_Charge__c == null)
					{
						string_awb ='';
						return;	
					}
					if(awl.House_Reference__c == null)
					{
						string_awb ='';
						return;	
					}
					pieces+=awl.No_of_Pieces__c;
					gross+=NEU_Utils.safeDecimal(awl.Gross_Weight__c);
					chargeable+=(NEU_Utils.safeDecimal(awl.Chargeable_Weight_House__c) != 0 ? NEU_Utils.safeDecimal(awl.Chargeable_Weight_House__c) : NEU_Utils.safeDecimal(awl.Chargeable_Weight__c));
					rate_class=(awl.Rate_Class__c != null ? awl.Rate_Class__c.substring(0,1) : '');
					kg=NEU_Utils.safeString(awl.Kg_Lb__c);
					rate_charge=(NEU_Utils.safeDecimal(awl.Rate_Charge_House__c) != 0 ? NEU_Utils.safeDecimal(awl.Rate_Charge_House__c) : NEU_Utils.safeDecimal(awl.Rate_Charge__c));
					description=(awl.Description__c != null ? awl.Description__c.left(150).toUpperCase() : '');
					m3+=NEU_Utils.safeDecimal(awl.Total_Volume_m3__c);		
					commodity+=(awl.Commodity_Item_No__c != null ? NEU_Utils.safeDecimal(awl.Commodity_Item_No__c) : 0.00);
					if (NEU_Utils.safeDecimal(awl.Min_Amount_House__c) != 0)
						total+=awl.Min_Amount_House__c;
					else
						total+= (NEU_Utils.safeDecimal(awl.Total_Service_Charge_House__c) != 0 ? NEU_Utils.safeDecimal(awl.Total_Service_Charge_House__c) : NEU_Utils.safeDecimal(awl.Total_Service_Charge__c));
				}
				// 	22A					
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 20.00cm;" class="lines">'+pieces+'</span>';	
				//	22B
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 18.20cm;" class="lines">'+gross+'</span>';	
				//	22C
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 3.7cm;" class="lines">'+kg+'</span>';
				//	22D
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 4.2cm;" class="lines">'+rate_class+'</span>';
				//	22E
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 5.15cm; width: 50px;" class="lines">'+NEU_Utils.safeString(commodity)+'</span>';
				//	22F
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 13.50cm;" class="lines">'+chargeable+'</span>';	
				//	22G
				if(record.Hide_House_Totals__c)
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 11.20cm;" class="lines">AS AGREED</span>';										
				else
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 11.20cm;" class="lines">'+rate_charge+'</span>';						
				//	22H
				if(record.Hide_House_Totals__c)
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 7.75cm;" class="lines">AS AGREED</span>';
				else
					string_awb += '<span style="position: absolute;  top: '+position_top+'cm; right: 7.75cm;" class="lines">'+total.setScale(2)+'</span>';						
				//	22I	
				/*string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 14.75cm; width: 200px;" class="lines">'+(description != '' ? description +'<br/><br/>': '');
				for(Air_Waybill_Line__c awl: lines_house)
					string_awb +=(awl.Length__c != null && awl.Width__c != null && awl.Height__c != null ? awl.Dimensions__c : '')+'<br/>';
				string_awb +='<br/>'+(m3 != null ? m3 + ' CBM' : '')+'</span>';*/
				string_awb += '<span style="position: absolute;  top: '+position_top+'cm; left: 14.75cm; width: 200px;" class="lines">'+(record.House_Reference__c != null && record.House_Reference__r.Nature_of_Goods_House__c != null ? record.House_Reference__r.Nature_of_Goods_House__c : '')+'</span>';
			}
	
	
			//	22J		22K		22L
	       	string_awb += '<span style="position: absolute; top: 19.40cm; right: 20.00cm;" class="lines">'+pieces+'</span>'; 
	       	string_awb += '<span style="position: absolute; top: 19.40cm; right: 18.20cm;" class="lines">'+gross+'</span>';
	        if(record.Hide_House_Totals__c)
	        	string_awb += '<span style="position: absolute; top: 19.40cm; right: 7.75cm;" class="lines">AS AGREED</span>';
	        else
	            string_awb += '<span style="position: absolute; top: 19.40cm; right: 7.75cm;" class="lines">'+total.setScale(2)+'</span>';   	
	
	
			// 23
			decimal position_top_other = 20.50;
			decimal position_left_other = 8.5;
			decimal total_agent = 0.0;
			decimal total_carrier = 0.0;
			if(record.Other_Charges_House__c == null)
			{
				if(other_charge.size()>0)
				{					
					integer i=1;
					for(Waybill_Other_Charge__c oc: other_charge)
					{
						if(record.Hide_House_Totals__c)
							string_awb += '<span style="position: absolute; top: '+position_top_other+'cm; left: '+position_left_other+'cm; width: 420 px;">AS AGREED</span>';
						else
						{
							if(NEU_Utils.safeString(oc.Recipient_of_Charge_Amount__c) == 'A')
							{
								if(oc.Other_Charge_Rate__c != 0)
									total_agent += (total*NEU_Utils.SafeDecimal(oc.Other_Charge_Rate__c)).setScale(2);
								else
									total_agent += NEU_Utils.SafeDecimal(oc.Charge_Amount__c);
							}
							else if(NEU_Utils.safeString(oc.Recipient_of_Charge_Amount__c) == 'C')
							{
								if(oc.Other_Charge_Rate__c != 0)
									total_carrier += (total*NEU_Utils.SafeDecimal(oc.Other_Charge_Rate__c)).setScale(2);
								else
									total_carrier += NEU_Utils.SafeDecimal(oc.Charge_Amount__c);
							}
							string_awb += '<span style="position: absolute; top: '+position_top_other+'cm; left: '+position_left_other+'cm; width: 420 px;">'+NEU_Utils.safeString(oc.Other_Charges__c)+NEU_Utils.safeString(oc.Recipient_of_Charge_Amount__c)+' '+total_carrier.setScale(2)+'</span>';	
						}
						position_top_other += 0.75;
						i++;
						if(i==4 || i==7)
						{
							position_top_other = 20.50;
							position_left_other += 4.00;
						}
					}	       	            
				}
			}
			else
				string_awb += '<span style="position: absolute; top: '+position_top_other+'cm; left: '+position_left_other+'cm; width: 420 px;">'+NEU_Utils.safeString(record.Other_Charges_House__c)+'</span>';
			        
	
			//	24A		24B
			decimal weight = 0.0;
			if(record.Prepaid_Collect_House_WT_VAL__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_House_WT_VAL__c == 'Prepaid')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute; top: 20.50cm; right: 17.50cm;">AS AGREED</span>';
					else
					{
						weight=(record.Weight_Charge_House__c != null ? NEU_Utils.safeDecimal(record.Weight_Charge_House__c) : total.setScale(2));
						string_awb += '<span style="position: absolute; top: 20.50cm; right: 17.50cm;">'+weight+'</span>';
					}
				}
				else if(record.Prepaid_Collect_House_WT_VAL__c == 'Collect')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute; top: 20.50cm; right: 13.75cm;">AS AGREED</span>';
					else
					{
						weight=(record.Weight_Charge_House__c != null ? NEU_Utils.safeDecimal(record.Weight_Charge_House__c) : total.setScale(2));
						string_awb += '<span style="position: absolute; top: 20.50cm; right: 13.75cm;">'+weight+'</span>';
					}
				}
			}
	
	
	        // 	25A		25B 
	        decimal valuation = 0.0;
			if(record.Prepaid_Collect_House_WT_VAL__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_House_WT_VAL__c == 'Prepaid')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute; top: 21.30cm; right: 17.50cm;">AS AGREED</span>';
					else
					{
						valuation = (record.Valuation_Charge_House__c != null ? NEU_Utils.safeDecimal(record.Valuation_Charge_House__c) : NEU_Utils.safeDecimal(record.Valuation_Charge__c));
						string_awb += '<span style="position: absolute; top: 21.30cm; right: 17.50cm;">'+valuation+'</span>';
					}
				}
				else if(record.Prepaid_Collect_House_WT_VAL__c == 'Collect')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute; top: 21.30cm; right: 13.75cm;">AS AGREED</span>';
					else
					{
						valuation = (record.Valuation_Charge_House__c != null ? NEU_Utils.safeDecimal(record.Valuation_Charge_House__c) : NEU_Utils.safeDecimal(record.Valuation_Charge__c));
						string_awb += '<span style="position: absolute; top: 21.30cm; right: 13.75cm;">'+valuation+'</span>';
					}
				}
			}              
	
	
			//	26A		26B
			decimal tax = 0.0;
			if(record.Prepaid_Collect_House_WT_VAL__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_House_WT_VAL__c == 'Prepaid')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute; top: 22.25cm; right: 17.50cm;">AS AGREED</span>';
					else
					{
						tax = (record.Tax_House__c != null ? NEU_Utils.safeDecimal(record.Tax_House__c) : NEU_Utils.safeDecimal(record.Tax__c));
						string_awb += '<span style="position: absolute; top: 22.25cm; right: 17.50cm;">'+tax+'</span>';
					}
				}
				else if(record.Prepaid_Collect_House_WT_VAL__c == 'Collect')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute; top: 22.25cm; right: 13.75cm;">AS AGREED</span>';
					else
					{
						tax = (record.Tax_House__c != null ? NEU_Utils.safeDecimal(record.Tax_House__c) : NEU_Utils.safeDecimal(record.Tax__c));
						string_awb += '<span style="position: absolute; top: 22.25cm; right: 13.75cm;">'+tax+'</span>';
					}
				}
			}				
	
	
	        //	27A		27B
	        decimal agent = 0.0;
			if(record.Prepaid_Collect_House_Other__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_House_Other__c == 'Prepaid')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute;  top: 23.1cm; right: 17.50cm;">AS AGREED</span>';
					else
					{
						agent = (record.Total_Other_Charges_Due_Agent_House__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent_House__c) : total_agent.setScale(2));
						string_awb += '<span style="position: absolute;  top: 23.1cm; right: 17.50cm;">'+agent+'</span>';
					}
				}
				else if(record.Prepaid_Collect_House_Other__c == 'Collect')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute;  top: 23.1cm; right: 13.75cm;">AS AGREED</span>';
					else
					{
						agent = (record.Total_Other_Charges_Due_Agent_House__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_Agent_House__c) : total_agent.setScale(2));
						string_awb += '<span style="position: absolute;  top: 23.1cm; right: 13.75cm;">'+agent+'</span>';
					}
				}       	
			}
			
			
			//	28A		28B   	
			decimal carrier = 0.0;
			if(record.Prepaid_Collect_House_Other__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_House_Other__c == 'Prepaid')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute;  top: 23.95cm;  right: 17.50cm;">AS AGREED</span>';
					else
					{
						carrier = (record.Total_Other_Charges_Due_House__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_House__c) : total_carrier.setScale(2));
						string_awb += '<span style="position: absolute;  top: 23.95cm;  right: 17.50cm;">'+carrier+'</span>';
					}
				}
				else if(record.Prepaid_Collect_House_Other__c == 'Collect')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute;  top: 23.95cm;  right: 13.75cm;">AS AGREED</span>';
					else
					{
						carrier = (record.Total_Other_Charges_Due_House__c != null ? NEU_Utils.safeDecimal(record.Total_Other_Charges_Due_House__c) : total_carrier.setScale(2));
						string_awb += '<span style="position: absolute;  top: 23.95cm;  right: 13.75cm;">'+carrier+'</span>';
					}
				}
			}
	
	
	        //	30A		30B
	        decimal totals = 0.0;
	        if(record.Prepaid_Collect_House_Other__c != null || Test.isRunningTest())
			{
				if(record.Prepaid_Collect_House_Other__c == 'Prepaid')
				{
	        		if(record.Hide_House_Totals__c)
	        			string_awb += '<span style="position: absolute; top: 25.70cm; right: 17.50cm;">AS AGREED</span>';
	        		else
	        		{
	        			totals = weight+valuation+tax+agent+carrier;
	        			string_awb += '<span style="position: absolute; top: 25.70cm; right: 17.50cm;">'+totals+'</span>';
	        		}
				}
				else if(record.Prepaid_Collect_House_Other__c == 'Collect')
				{
					if(record.Hide_House_Totals__c)
						string_awb += '<span style="position: absolute; top: 25.70cm; right: 13.75cm;">AS AGREED</span>';
					else
					{
						totals = weight+valuation+tax+agent+carrier; 
						string_awb += '<span style="position: absolute; top: 25.70cm; right: 13.75cm;">'+totals+'</span>';
					}
				}
			}	       	   
	
	
			//	31
			string_awb += '    <span style="position: absolute; top: 23.95cm; left: 8.50cm; width: 420px; text-align: center;">'+NEU_Utils.safeString(consolidation_house[0].Shipper_Account__r.Name).toUpperCase()+'</span>';
	       	string_awb += '    <span style="position: absolute; top: 24.30cm; left: 8.50cm; width: 420px; text-align: center;">'+NEU_Utils.safeString(record.Shipper_s_Signature__c)+'</span>';     
	     
	       	
			//	32A		32B		32C		
	        string_awb += '<span style="position: absolute; top: 25.75cm; left: 8.50cm; width: 100px;">'+(record.Executed_on_date__c != null ? record.Executed_on_date__c.format() : '')+'</span>';
	        string_awb += '<span style="position: absolute; top: 25.75cm; left: 11.70cm; width: 100px; text-align: center;">'+NEU_Utils.safeString(record.at_place__c).toUpperCase()+'</span>';
	        string_awb += '<span style="position: absolute; top: 25.75cm; left: 15.55cm; width: 150px; text-align: center;">'+NEU_Utils.safeString(record.Issuing_Carrier_s_Signature__c).toUpperCase()+'</span>';
	
			
			// 	1A		1B  
			string_awb += '    <span style="position: absolute; top: 27.1cm; left: 17.75cm;" class="referencia">'+NEU_Utils.safeString(record.House_Reference__r.Name)+'</span>';
   		}
    	string_awb += '</div>';   
	}
}