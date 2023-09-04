public with sharing class NEU_Traxon_FHL 
{
	String senderPIMA;
	String addressTo;
	ApexPages.StandardController con;
	Air_Waybill__c record;
	List<Air_Waybill_Line__c> lines=new List<Air_Waybill_Line__c>();

	public static String[]usedFields=new String[]{
		'Id'
		,'Name'
		,'Carrier_Account__c'
		,'Carrier_Account__r.PIMA_Address__c'
		,'Carrier_Account__r.Airline_Code_Number__c'
		,'Serial_Number__c'
		,'Airport_of_Departure__c'
		,'Airport_of_Departure_Code__c'
		,'Airport_of_Departure__r.IATA_Code__c'
		,'Site_of_Destination__c'
		,'Airport_of_Destination_Code__c'
		,'Site_of_Destination__r.IATA_Code__c'
		,'Total_Number_of_Pieces__c'
		,'Total_Gross_Weight__c'
		,'Shipper_Account__c'
		,'Shipper_Account__r.Name'
		,'Shipper_Account__r.BillingStreet'
		,'Shipper_Account__r.BillingCity'
		,'Shipper_Account__r.BillingCountry'
		,'Consignee_Account__c'
		,'Consignee_Account__r.Name'
		,'Consignee_Account__r.BillingStreet'
		,'Consignee_Account__r.BillingCity'
		,'Consignee_Account__r.BillingCountry'
		,'CurrencyISOCode'
		,'Enable_Shipper_Alternative_Address__c'
		,'Shipper_Alternative_Address__c'
		,'Shipper_Alternative_Country__c'
		,'Shipper_Alternative_Country__r.Name'
		,'Shipper_Alternative_Location__c'
		,'Shipper_Alternative_Location__r.Name'
		,'Enable_Consignee_Alternative_Address__c'
		,'Consignee_Alternative_Account__c'
		,'Consignee_Alternative_Account__r.Name'
		,'Consignee_Alternative_Address__c'
		,'Consignee_Alternative_Country__c'
		,'Consignee_Alternative_Country__r.Name'
		,'Consignee_Alternative_Location__c'
		,'Consignee_Alternative_Location__r.Name'
		,'Prepaid_Collect_WT_VAL__c'
		,'Prepaid_Collect_Other__c'
		,'Declared_Value_For_Carriage__c'
		,'Declared_Value_For_Customs__c'
		,'Amount_of_Insurance__c'
		};
    public NEU_Traxon_FHL(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest()) {stdController.AddFields(usedFields);}
        con = stdController;
        record=(Air_Waybill__c)con.getRecord();
        lines=[select Id, Description__c,No_of_Pieces__c,Gross_Weight__c, Kg_Lb__c, House_Reference__c, House_Reference__r.Name
        		from Air_Waybill_Line__c where Air_Waybill__c=:con.getRecord().Id];
        sandbox();
    }
    public String sandbox()
    {
    	List<Organization>org=[SELECT Id, IsSandbox FROM Organization LIMIT 1];
		Boolean isSandbox=false;
		if(org.size()>0)
			if(org[0].IsSandbox)
				isSandbox=true;
		if(isSandbox)
			addressTo='cargohub-test@edi.champ.aero';
		else
			addressTo='cargohub-edi@edi.champ.aero';
		return addressTo;
    }
    public PageReference sendToTraxon()
    {
    	Boolean errors=false;
    	if(record.Carrier_Account__c==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Carrier_Account__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	else
    	{
	    	if(String.isEmpty(record.Carrier_Account__r.PIMA_Address__c))
	    	{
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Carrier_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.PIMA_Address__c.getDescribe().getLabel()+' not found'));
	    		errors=true;
	    	}
	    	if(String.isEmpty(record.Carrier_Account__r.Airline_Code_Number__c))
	    	{
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Carrier_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.Airline_Code_Number__c.getDescribe().getLabel()+' not found'));
	    		errors=true;
	    	}
    	}
    	if(String.isEmpty(record.Serial_Number__c))
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Serial_Number__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	if(record.Airport_of_Departure__c==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Airport_of_Departure__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	else if(String.isEmpty(record.Airport_of_Departure__r.IATA_Code__c))
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Airport_of_Departure__c.getDescribe().getLabel()+': '+Schema.Location__c.fields.IATA_Code__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	if(record.Site_of_Destination__c==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Site_of_Destination__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	else if(String.isEmpty(record.Site_of_Destination__r.IATA_Code__c))
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Site_of_Destination__c.getDescribe().getLabel()+': '+Schema.Location__c.fields.IATA_Code__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	/*List<String>countryNames=new List<String>();
    	if(record.Shipper_Account__c==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Account__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	else
    	{
    		if(!record.Enable_Shipper_Alternative_Address__c)
    		{
		    	if(String.isEmpty(record.Shipper_Account__r.BillingStreet))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingStreet.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Shipper_Account__r.BillingCity))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCity.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Shipper_Account__r.BillingCountry))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCountry.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		    	else
			    	countryNames.add(NEU_Utils.removeAccents(record.Shipper_Account__r.BillingCountry));
    		}
    		else
    		{
		    	if(String.isEmpty(record.Shipper_Alternative_Address__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Alternative_Address__c.getDescribe().getLabel()+': '+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Shipper_Alternative_Location__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Alternative_Location__c.getDescribe().getLabel()+': '+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Shipper_Alternative_Country__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Alternative_Country__c.getDescribe().getLabel()+': '+' not found'));
		    		errors=true;
		    	}
		    	else
			    	countryNames.add(record.Shipper_Alternative_Country__r.Name);
    		}
    	}
    	if(record.Consignee_Account__c==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Account__c.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
    	else
    	{
    		if(!record.Enable_Consignee_Alternative_Address__c)
    		{
		    	if(String.isEmpty(record.Consignee_Account__r.BillingStreet))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingStreet.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Consignee_Account__r.BillingCity))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCity.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Consignee_Account__r.BillingCountry))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCountry.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		    	else
			    	countryNames.add(NEU_Utils.removeAccents(record.Consignee_Account__r.BillingCountry));
    		}
    		else
    		{
    			if(String.isEmpty(record.Consignee_Alternative_Account__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Alternative_Account__c.getDescribe().getLabel()+': '+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Consignee_Alternative_Address__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Alternative_Address__c.getDescribe().getLabel()+': '+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Consignee_Alternative_Location__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Alternative_Location__c.getDescribe().getLabel()+': '+' not found'));
		    		errors=true;
		    	}
		    	if(String.isEmpty(record.Consignee_Alternative_Country__c))
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Alternative_Country__c.getDescribe().getLabel()+': '+' not found'));
		    		errors=true;
		    	}
		    	else
			    	countryNames.add(record.Consignee_Alternative_Country__r.Name);
    		}
    	}*/
    	if(String.isEmpty(record.CurrencyISOCode))
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.CurrencyISOCode.getDescribe().getLabel()+' not found'));
    		errors=true;
    	}
		/*Map<String,String>countries=new Map<String,String>();
		for(Country__c c:[select Name,ISO_Code_2c__c from Country__c where ISO_Code_2c__c!=null and ISO_Code_2c__c!='' and Name IN:countryNames])
			countries.put(c.Name.toUpperCase(),c.ISO_Code_2c__c);
		if(!record.Enable_Shipper_Alternative_Address__c)
		{
			if(record.Shipper_Account__r.BillingCountry!=null)
		    	if(countries.get(NEU_Utils.removeAccents(record.Shipper_Account__r.BillingCountry.toUpperCase()))==null)
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCountry.getDescribe().getLabel()+': '+Schema.Country__c.fields.ISO_Code_2c__c.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		}
		else
		{
			if(record.Shipper_Alternative_Country__c!=null)
		    	if(countries.get(record.Shipper_Alternative_Country__r.Name.toUpperCase())==null)
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Shipper_Alternative_Country__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCountry.getDescribe().getLabel()+': '+Schema.Country__c.fields.ISO_Code_2c__c.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		}
		if(!record.Enable_Consignee_Alternative_Address__c)
		{
	    	if(record.Consignee_Account__r.BillingCountry!=null)
		    	if(countries.get(NEU_Utils.removeAccents(record.Consignee_Account__r.BillingCountry.toUpperCase()))==null)
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Account__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCountry.getDescribe().getLabel()+': '+Schema.Country__c.fields.ISO_Code_2c__c.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		}	
		else
		{
			if(record.Consignee_Alternative_Country__c!=null)
		    	if(countries.get(record.Consignee_Alternative_Country__r.Name.toUpperCase())==null)
		    	{
		    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill__c.fields.Consignee_Alternative_Country__c.getDescribe().getLabel()+': '+Schema.Account.fields.BillingCountry.getDescribe().getLabel()+': '+Schema.Country__c.fields.ISO_Code_2c__c.getDescribe().getLabel()+' not found'));
		    		errors=true;
		    	}
		}*/
	    if(lines.size()>6)
	    {
	    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Maximum number of lines is 6'));
	    	errors=true;
	    }	    	
	    for(Air_Waybill_Line__c awl: lines)
		{				
			if(awl.No_of_Pieces__c==null)
		   	{
		   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill_Line__c.fields.No_of_Pieces__c.getDescribe().getLabel()+' not found'));
		   		errors=true;
		   	}
		   	if(String.isEmpty(awl.Description__c))
		   	{
		   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill_Line__c.fields.Description__c.getDescribe().getLabel()+' not found'));
		   		errors=true;
		   	}
		   	if(awl.Gross_Weight__c==null)
		   	{
		   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill_Line__c.fields.Gross_Weight__c.getDescribe().getLabel()+' not found'));
		   		errors=true;
		   	}
		   	if(awl.House_Reference__c==null)
		   	{
		   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Schema.Air_Waybill_Line__c.fields.House_Reference__c.getDescribe().getLabel()+' not found'));
		   		errors=true;
		   	}
		} 	    	
    	if(errors)
    		return null;
    	
    	String reg='[^a-zA-Z0-9 .-]';    		
    	String mymessage='FHL/5\r\n';//message/version/separator
    	
    	mymessage+='MBI/';//Master Waybill Identification
    	mymessage+=record.Carrier_Account__r.Airline_Code_Number__c;//airline prefix
    	mymessage+='-';//separator
    	mymessage+=record.Serial_Number__c;//AWB serial number
    	mymessage+=record.Airport_of_Departure__r.IATA_Code__c;//airport/city code (origin)
    	mymessage+=record.Site_of_Destination__r.IATA_Code__c;//airport/city code (destination)
    	mymessage+='/';//separator
    	mymessage+='T';//shipment description code (total "T" or partial "P")
    	mymessage+=String.valueOf(record.Total_Number_of_Pieces__c);//numbers of pieces
    	mymessage+='K';//weight code (kg "K" or libras "L")
    	mymessage+=String.valueOf(NEU_Utils.safeDecimal(record.Total_Gross_Weight__c));//weight
    	mymessage+='\r\n';//serarator
    	
		if(lines.size()>0)
		{
			for(Air_Waybill_Line__c awl: lines)
			{
				mymessage+='HBS/';//House Waybill
		    	mymessage+=awl.House_Reference__r.Name.toUpperCase();//HWB Serial Number 
		    	mymessage+='/';
		    	mymessage+=record.Airport_of_Departure__r.IATA_Code__c;//airport/city code (origin)
    			mymessage+=record.Site_of_Destination__r.IATA_Code__c;//airport/city code (destination)
    			mymessage+='/';
    			mymessage+=awl.No_of_Pieces__c;//number of pieces
    			mymessage+='/';
    			mymessage+=awl.Kg_Lb__c;//weight code (kg "K" or libras "L")
    			mymessage+=String.valueOf(NEU_Utils.safeDecimal(awl.Gross_Weight__c));//weight
    			mymessage+='//';
    			String description = NEU_Utils.safeString(awl.Description__c);
				description=NEU_Utils.removeAccents(description);
		    	description=description.replaceAll(reg, '');
				mymessage+=description.left(15);//Nature and Quantity of Goods
    			mymessage+='\r\n';//serarator
			}
		}
		
		/*mymessage+='SHP';//SHIPPER
    	mymessage+='\r\n';//serarator
    	mymessage+='NAM';//Name
    	mymessage+='/';//separator
    	String name_shp = NEU_Utils.removeAccents(record.Shipper_Account__r.Name);
    	name_shp=name_shp.replaceAll(reg, '');  
    	mymessage+=name_shp.left(35);//name
    	mymessage+='\r\n';//serarator
    	mymessage+='ADR';//Address
    	mymessage+='/';//separator
    	String street_shp;
    	String city_shp;
    	if(!record.Enable_Shipper_Alternative_Address__c)
    	{
	    	street_shp = NEU_Utils.removeAccents(record.Shipper_Account__r.BillingStreet);
	    	street_shp=street_shp.replaceAll(reg, '');    	
	    	mymessage+=street_shp.left(35);//street address
	    	mymessage+='\r\n';//serarator
	    	mymessage+='LOC';//Location
	    	mymessage+='/';//separator
	    	city_shp = NEU_Utils.removeAccents(record.Shipper_Account__r.BillingCity);
	    	city_shp=city_shp.replaceAll(reg, '');
	    	mymessage+=city_shp.left(17);//place
	    	mymessage+='\r\n';//serarator
	    	mymessage+='/';//separator
	    	mymessage+=countries.get(NEU_Utils.removeAccents(record.Shipper_Account__r.BillingCountry.toUpperCase()));//ISO country code
    	}
    	else
    	{
    		street_shp = NEU_Utils.removeAccents(record.Shipper_Alternative_Address__c);
	    	street_shp=street_shp.replaceAll(reg, '');    	
	    	mymessage+=street_shp.left(35);//street address
	    	mymessage+='\r\n';//serarator
	    	mymessage+='LOC';//Location
	    	mymessage+='/';//separator
	    	city_shp = record.Shipper_Alternative_Location__r.Name;
	    	city_shp=city_shp.replaceAll(reg, '');
	    	mymessage+=city_shp.left(17);//place
	    	mymessage+='\r\n';//serarator
	    	mymessage+='/';//separator
	    	mymessage+=countries.get(record.Shipper_Alternative_Country__r.Name.toUpperCase());//ISO country code
    	}    	
    	mymessage+='\r\n';//serarator*/

    	/*mymessage+='CNE';//Consignee
    	mymessage+='\r\n';//serarator
    	mymessage+='NAM';//Name
    	mymessage+='/';//separator
    	String name_cne;
    	String street_cne;
	    String city_cne;
    	if(!record.Enable_Consignee_Alternative_Address__c)
    	{
    		name_cne = NEU_Utils.removeAccents(record.Consignee_Account__r.Name);
	    	name_cne=name_cne.replaceAll(reg, '');
	    	mymessage+=name_cne.left(35);//name
	    	mymessage+='\r\n';//serarator
	    	mymessage+='ADR';//Address
	    	mymessage+='/';//separator
	    	street_cne = NEU_Utils.removeAccents(record.Consignee_Account__r.BillingStreet);
	    	street_cne=street_cne.replaceAll(reg, '');   	
	    	mymessage+=street_cne.left(35);//street address
	    	mymessage+='\r\n';//serarator
	    	mymessage+='LOC';//Location
	    	mymessage+='/';//separator
	    	city_cne = NEU_Utils.removeAccents(record.Consignee_Account__r.BillingCity);
	    	city_cne=city_cne.replaceAll(reg, '');
	    	mymessage+=city_cne.left(17);//place
	    	mymessage+='\r\n';//serarator
	    	mymessage+='/';//separator
	    	mymessage+=countries.get(NEU_Utils.removeAccents(record.Consignee_Account__r.BillingCountry.toUpperCase()));//ISO country code
    	}
    	else
    	{
    		name_cne = NEU_Utils.removeAccents(record.Consignee_Alternative_Account__r.Name);
	    	name_cne=name_cne.replaceAll(reg, '');
	    	mymessage+=name_cne.left(35);//name
	    	mymessage+='\r\n';//serarator
	    	mymessage+='ADR';//Address
	    	mymessage+='/';//separator
    		street_cne = NEU_Utils.removeAccents(record.Consignee_Alternative_Address__c);
	    	street_cne=street_cne.replaceAll(reg, '');   	
	    	mymessage+=street_cne.left(35);//street address
	    	mymessage+='\r\n';//serarator
	    	mymessage+='LOC';//Location
	    	mymessage+='/';//separator
	    	city_cne = record.Consignee_Alternative_Location__r.Name;
	    	city_cne=city_cne.replaceAll(reg, '');
	    	mymessage+=city_cne.left(17);//place
	    	mymessage+='\r\n';//serarator
	    	mymessage+='/';//separator
	    	mymessage+=countries.get(record.Consignee_Alternative_Country__r.Name.toUpperCase());//ISO country code
    	}
    	mymessage+='\r\n';//serarator*/
		
		mymessage+='CVD';//Charge declarations
	   	mymessage+='/';//separator
    	mymessage+=record.CurrencyISOCode;//ISO currency code
    	mymessage+='/';//separator
    	if(record.Prepaid_Collect_WT_VAL__c != '' && record.Prepaid_Collect_WT_VAL__c != null &&
    		record.Prepaid_Collect_Other__c != '' && record.Prepaid_Collect_Other__c != null)
    	{
	    	if(record.Prepaid_Collect_WT_VAL__c.equals('Prepaid'))
	    		mymessage+='P';//P/C Ind. (Weight/Valuation)
	    	else if(record.Prepaid_Collect_WT_VAL__c.equals('Collect'))
	    		mymessage+='C';//P/C Ind. (Weight/Valuation)
	    		   		
	    	if(record.Prepaid_Collect_Other__c.equals('Prepaid'))
	    		mymessage+='P';//P/C Ind. (Other Charges)
	    	else if(record.Prepaid_Collect_Other__c.equals('Collect'))
	    		mymessage+='C';//P/C Ind. (Other Charges)
    	}
		mymessage+='/';//separator    	
    	if(record.Declared_Value_For_Carriage__c != 0 && record.Declared_Value_For_Carriage__c !=null)
    		mymessage+=String.valueOf(NEU_Utils.safeDecimal(record.Declared_Value_For_Carriage__c));//declared value or NVD
    	else
    		mymessage+='NVD';//declared value or NVD
    		
    	mymessage+='/';//separator
    	if(record.Declared_Value_For_Customs__c != 0 && record.Declared_Value_For_Customs__c !=null)
    		mymessage+=String.valueOf(NEU_Utils.safeDecimal(record.Declared_Value_For_Customs__c));//value of customs or NCV
    	else
    		mymessage+='NCV';//value of customs or NCV
    		
    	mymessage+='/';//separator
    	if(record.Amount_of_Insurance__c != 0 && record.Amount_of_Insurance__c !=null)
    		mymessage+=String.valueOf(NEU_Utils.safeDecimal(record.Amount_of_Insurance__c));//value for insurance or XXX
    	else
    		mymessage+='XXX';//value for insurance or XXX
    	mymessage+='\r\n';//serarator
    	
    	if(!sendMessage(record.Carrier_Account__r.PIMA_Address__c,'FHL','5',mymessage.toUpperCase()))
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Communications error'));
    		return null;
    	}
   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'FHL generated and notified'));  		
    	
    	PageReference pgReturnPage;
		String returnUrl = '/' + record.Id;
    	pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
    	return pgReturnPage;
    }
    public PageReference cancel()
    {
    	return con.view();
    }    
    private boolean sendMessage(String destpima,String mytype,String myversion,String mymessage)
    {
    	senderPIMA=NEU_Utils.getPIMA(record.Airport_of_Departure_Code__c,record.Airport_of_Destination_Code__c);
    	DateTime now=System.now();
    	String msgid=now.format('yyMMddHHmmssSSS');
    	String header='UNB+IATA:1+'+senderPIMA+':PIMA+'+destpima+':PIMA+'+now.format('yyMMdd:HHmm')+'+ICREF+0\'UNH+MSGREF+CIM'+mytype+':'+myversion+'+'+msgid+'\'';
    	String footer='\'UNT+3+MSGREF\'UNZ+1+ICREF\'';
		String mysubject=mytype+':'+destpima+':'+msgid;
	    List<Messaging.Email> allMails = new List<Messaging.Email>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName = 'champ_email'];
        if(owea.size()>0)
            mail.setOrgWideEmailAddressId(owea[0].Id);
        mail.setToAddresses(new String[]{addressTo});
        mail.setSubject(mysubject);
        mail.setPlainTextBody(header+mymessage+footer);
        allMails.add(mail);
	    try{
	    	Boolean result=true;
	    	try{
	    		/*Messaging.SendEmailResult[] myresult=Messaging.sendEmail(allMails);
	    		if(myresult.size()>0)
	    			if(myresult[0].isSuccess())*/
	    				result=true;
	    	}
	    	catch(Exception e)
    		{
    			result=Test.isRunningTest();
    		}
	    	if(result)
    		{
				Log__c mylog=new Log__c();
		  		mylog.Subject__c=mail.subject.left(255);
		  		mylog.Body__c=mail.plainTextBody.left(32678);
		  		if(owea.size()>0)
			  		mylog.From__c=owea[0].Address;
  				mylog.To__c=addressTo;
		  		insert mylog;
    			return true;
    		}
	    }catch(Exception e)
	    {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    }
	   	return false;
    }
}