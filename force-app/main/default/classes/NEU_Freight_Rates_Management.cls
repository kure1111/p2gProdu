public with sharing class NEU_Freight_Rates_Management extends NEU_Controller_Comparable{
	public String message_data {get;set;}
	public String message_header {get;set;}
  	public String id_service {get;set;}
  	public String id_carrier {get;set;}
  	public String info_type {get;set;}
  	public Fee__c filter_date {get;set;}
  	public Decimal buy_rate_filter {get;set;}
  	public Decimal sell_rate_filter {get;set;}
    public String queryString{
        get
        {
            if(queryString==null)
            {
            	queryString = '?';
            	queryString += 'id_af=' + (filter.Account_for__c != null ? neu_utils.safestring(filter.Account_for__c) : '');//Account for
            	queryString += '&rt_ct=' + (BuySell > 0 ? neu_utils.safestring(BuySell) : '');//Show Rates (BuySell)
            	queryString += '&ra_ct=' + (filter.Fee_Category__c != null ? EncodingUtil.urlEncode(filter.Fee_Category__c, 'UTF-8') : '');
            	queryString += '&isoc='  + (!String.isEmpty(filterCurrencyISOCode) ? neu_utils.safestring(filterCurrencyISOCode) : '');//Currency
            	queryString += '&rt_ty='  + (filter.Rate_Type__c != null ? EncodingUtil.urlEncode(filter.Rate_Type__c, 'UTF-8') : '');//Rate Type
            	queryString += '&id_ca=' + (filter.Carrier_Account__c != null ? neu_utils.safestring(filter.Carrier_Account__c) : '');//Id Carrier
            	queryString += '&va_fr=' + (filter.Valid_From__c != null ? EncodingUtil.urlEncode(filter.Valid_From__c.format(),'UTF-8') : '');//Valid From
            	queryString += '&va_un=' + (filter.Valid_Until__c != null ? EncodingUtil.urlEncode(filter.Valid_Until__c.format(),'UTF-8') : '');//Valid Until
            	queryString += '&re_lo=' + (loadFilter.Region__c != null ? neu_utils.safestring(loadFilter.Region__c) : '');//Region of Load
            	queryString += '&re_dc=' + (dischargeFilter.Region__c != null ? neu_utils.safestring(dischargeFilter.Region__c) : '');//Region of Discharge
            	queryString += '&co_lo=' + (filter.Route__r.Country_of_Load__c != null ? neu_utils.safestring(filter.Route__r.Country_of_Load__c) : '');//Country of Load
            	queryString += '&co_dc=' + (filter.Route__r.Country_of_Discharge__c != null ? neu_utils.safestring(filter.Route__r.Country_of_Discharge__c) : '');//Country of Discharge
            	queryString += '&st_ld=' + (filter.Route__r.Port_Airport_of_Load__c != null ? neu_utils.safestring(filter.Route__r.Port_Airport_of_Load__c) : '');//Site of Load
            	queryString += '&st_dc=' + (filter.Route__r.Port_Airport_of_Discharge__c != null ? neu_utils.safestring(filter.Route__r.Port_Airport_of_Discharge__c) : '');//Site of Discharge
            }	
            return queryString;
        }
        set;
    }
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
	public Integer BuySell{
		get
		{
			if(BuySell==null)
				BuySell=1;
			return BuySell;
		}
		set;
	}
    public Country__c loadFilter
    {
        get
        {
            if(loadFilter==null)
                loadFilter=new Country__c();
            return loadFilter;
        }
        set;
    }
    public Country__c dischargeFilter
    {
        get
        {
            if(dischargeFilter==null)
                dischargeFilter=new Country__c();
            return dischargeFilter;
        }
        set;
    }
	public List<SelectOption>allcountries
	{
		get
		{
			if(allcountries==null)
			{
				allcountries=new List<SelectOption>();
				allcountries.add(new SelectOption('',''));
				for(Country__c c:[select Id,Name from Country__c order by Name asc])
					allcountries.add(new SelectOption(c.Id,c.Name));
			}
			return allcountries;
		}
		set
		{
			if(allcountries!=value)
				allcountries=value;
		}
	}

	public List<SelectOption>buyselllist
	{
		get
		{
			if(buyselllist==null)
			{
				buyselllist=new List<SelectOption>();
				buyselllist.add(new SelectOption('1','Buy Rate'));
				if((DisplayConcepts==0)&&(DisplayMins<=3))
				{
					buyselllist.add(new SelectOption('2','Sell Rate'));
					buyselllist.add(new SelectOption('3','Buy & Sell Rate'));
				}
			}
			return buyselllist;
		}
		set
		{
			if(buyselllist!=value)
				buyselllist=value;
		}
	}

    public List<SelectOption>rateCategoryList
    {
        get
        {
            if(rateCategoryList==null)
            {
                rateCategoryList = new List<SelectOption>();
                Schema.DescribeFieldResult fieldResult = Fee__c.Fee_Category__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry f : ple)
                {
                    rateCategoryList.add(new SelectOption(f.getValue(),f.getValue()));
                }
            }
            return rateCategoryList;
        }
        set
        {
            if(rateCategoryList!=value)
                rateCategoryList = value;
        }
    }

	public void updatefilters()
	{
		buyselllist=null;
		displayMinslist=null;
        queryString=null;
	}

	public Integer DisplayConcepts
    {
		get
		{
			if(filter.Rate_Type__c!='Per Container')
				return 0;
			if(DisplayConcepts==null)
				DisplayConcepts=0;
			return DisplayConcepts;
		}
		set
		{
			if(DisplayConcepts!=value)
			{
				DisplayConcepts=value;
				buyselllist=null;
			}
		}
	}
	public String Concept1{get;set;}
	public String Concept2{get;set;}
	public String Concept3{get;set;}
	public String Concept4{get;set;}
	public String Concept5{get;set;}
	public List<SelectOption>CurrencyIsoCodeOptions
	{
		get
		{
			if(CurrencyIsoCodeOptions==null)
				CurrencyIsoCodeOptions=NEU_CurrencyUtils.getCurrencyIsoCodeOptions();
			return CurrencyIsoCodeOptions;
		}
		set;
	}
	public String filterCurrencyISOCode
	{
		get
		{
			return NEU_CurrencyUtils.getCurrencyISOCode(filter);
		}
		set
		{
			NEU_CurrencyUtils.setCurrencyISOCode(filter,value);
		}
	}
	public List<SelectOption>displayMinslist
	{
		get
		{
			if(displayMinslist==null)
			{
				displayMinslist=new List<SelectOption>();
				displayMinslist.add(new SelectOption('0','No Display'));
				displayMinslist.add(new SelectOption('1','+ Kg'));
				displayMinslist.add(new SelectOption('2','+ M3'));
				displayMinslist.add(new SelectOption('3','+ Kg and M3'));
				if(filter.Rate_Type__c=='Per Kg')
				{
					displayMinslist.add(new SelectOption('8','+ Kg and breakpoints'));
				}
			}
			return displayMinslist;
		}
		set;
	}
	public Integer DisplayMins{
		get
		{
			if(DisplayMins==null)
				DisplayMins=0;
			if((filter.Rate_Type__c!='Per Kg')&&(DisplayMins>3))
				return 1;
			return DisplayMins;
		}
		set;
	}
	public class Country_Locations_s
	{
		public Id Country{get;set;}
		public List<List<SelectOption>>locations{get;set;}
	}
	public String[] containerNames
	{
		get
		{
			if(containerNames==null)
				containerNames=new String[]{'20" DV','40" DV','40" HC'};
			return containerNames;
		}
		set;
	}
	public Decimal Min1{get;set;}
	public String TMin1{
		get
		{
			return NEU_Utils.safeString(Min1);
		}
		set
		{
			Decimal res=NEU_Utils.toDecimal(value);
			if(res!=null)
				Min1=res;
		}
	}
	public Decimal Min2{get;set;}
	public String TMin2{
		get
		{
			return NEU_Utils.safeString(Min2);
		}
		set
		{
			Decimal res=NEU_Utils.toDecimal(value);
			if(res!=null)
				Min2=res;
		}
	}
	public Decimal Min3{get;set;}
	public String TMin3{
		get
		{
			return NEU_Utils.safeString(Min3);
		}
		set
		{
			Decimal res=NEU_Utils.toDecimal(value);
			if(res!=null)
				Min3=res;
		}
	}
	public Decimal Min4{get;set;}
	public String TMin4{
		get
		{
			return NEU_Utils.safeString(Min4);
		}
		set
		{
			Decimal res=NEU_Utils.toDecimal(value);
			if(res!=null)
				Min4=res;
		}
	}
	public Decimal Min5{get;set;}
	public String TMin5{
		get
		{
			return NEU_Utils.safeString(Min5);
		}
		set
		{
			Decimal res=NEU_Utils.toDecimal(value);
			if(res!=null)
				Min5=res;
		}
	}
	public Id[] containers
	{
		get
		{
			if(containers==null)
			{
				containers=new Id[3];
				List<Container_Type__c>cs=[select Id,Name from Container_Type__c where Name IN: containerNames];
				for(Container_Type__c c:cs)
				{
					if(c.Name==containerNames[0])
						containers[0]=c.Id;
					else if(c.Name==containerNames[1])
						containers[1]=c.Id;
					else if(c.Name==containerNames[2])
						containers[2]=c.Id;
				}
			}
			return containers;
		}
		set;
	}
	
	public transient List<Country_Locations_s>alllocations{get;set;}
	
	public List<Country_Locations_s>createalllocations()
	{
		List<Country_Locations_s>alllocations=new List<Country_Locations_s>();
		Country_Locations_s cls=new Country_Locations_s();
		cls.Country=null;
		cls.locations=new List<List<SelectOption>>();
		List<SelectOption> temporal = new List<SelectOption>();
		cls.locations.add(temporal);
		alllocations.add(cls);
		Integer cont = 0;
		
		for(Location__c l:[select Id,Name,Country__c from Location__c order by Country__c asc nulls first,Name asc nulls first])
		{
			if(cls.Country!=l.Country__c)
			{
				cls=new Country_Locations_s();
				cls.Country=l.Country__c;
				cls.locations=new List<List<SelectOption>>();
				temporal = new List<SelectOption>();
				cls.locations.add(temporal);
				alllocations.add(cls);
				cont = 0;
			}
			else if(cont == 1000)
			{
				temporal = new List<SelectOption>();
				cls.locations.add(temporal);
				cont = 0;				
			}	
			temporal.add(new SelectOption(l.Id,l.Name));
			cont++;
		}
		
		return alllocations;
	}
    public List<ServiceRate_s> myList{
    	get
    	{
    		if(myList==null)
    		{
    			myList=new List<ServiceRate_s>();
    			notSorted();
				Concept1=null;
				Concept2=null;
				Concept3=null;
				Concept4=null;
				Concept5=null;
				Min1=null;
				Min2=null;
				Min3=null;
				Min4=null;
				Min5=null;
	    		if(filter.Account_for__c!=null)
	    		{
	    			Map<String,ServiceRate_s>feeSearch=null;
    				if((filter.Rate_Type__c=='Per Container')&&(DisplayConcepts==0))
						feeSearch=new Map<String,ServiceRate_s>();
					else if(DisplayMins>3)
						feeSearch=new Map<String,ServiceRate_s>();
	    			String query='select Id,Comments__c'+NEU_CurrencyUtils.CurrencyISOCode()+',Active__c,Name,Min__c,Max_M3__c,Max_Kgs__c,Volumetric_Factor__c,Concept_1__c,Cost_Concept_1__c,Concept_2__c,Cost_Concept_2__c,Concept_3__c,Cost_Concept_3__c,Concept_4__c,Cost_Concept_4__c,Concept_5__c,Cost_Concept_5__c,Rate_Type__c,Fee_Category__c,Route__c,Route__r.Country_of_Load__c,Route__r.Country_of_Load__r.Name,Route__r.Port_Airport_of_Load__c,Route__r.Port_Airport_of_Load__r.Name,Route__r.Port_Airport_of_Load__r.Country__c,Route__r.Port_Airport_of_Load__r.Country__r.Name,Route__r.Country_of_Discharge__c,Route__r.Country_of_Discharge__r.Name,Route__r.Port_Airport_of_Discharge__c,Route__r.Port_Airport_of_Discharge__r.Name,Route__r.Port_Airport_of_Discharge__r.Country__c,Route__r.Port_Airport_of_Discharge__r.Country__r.Name, Carrier_Account__r.Name,TT_Days__c,Valid_From__c,Valid_Until__c,Account_for__r.Name,Container_Type__c,Buy_Rate__c,Fee_Rate__c from Fee__c';
					String Account=filter.Account_for__c;
					query+=' where Account_for__c=:Account';
					String CurrencyISOCode=NEU_CurrencyUtils.getCurrencyISOCode(filter);
	    			if(UserInfo.isMultiCurrencyOrganization())
	    				query+=' and CurrencyISOCode=:CurrencyISOCode';
	    			String Carrier=filter.Carrier_Account__c;
					if(String.IsNotEmpty(Carrier))
						query+=' and Carrier_Account__c=:Carrier';
					String Fee_Category=filter.Fee_Category__c;
					if(String.IsNotEmpty(Fee_Category))
						query+=' and Fee_Category__c=:Fee_Category';
					String Rate_Type=filter.Rate_Type__c;
					if(String.IsNotEmpty(Rate_Type))
						query+=' and Rate_Type__c=:Rate_Type';
                    String RegionL=loadFilter.Region__c;
                    if(String.IsNotEmpty(RegionL))
                        query+=' and Route__r.Country_of_Load__r.Region__c=:RegionL';
					String CountryL=filter.Route__r.Country_of_Load__c;
					if(String.IsNotEmpty(CountryL))
						query+=' and Route__r.Country_of_Load__c=:CountryL';
					String LocationL=filter.Route__r.Port_Airport_of_Load__c;
					if(String.IsNotEmpty(LocationL))
						query+=' and Route__r.Port_Airport_of_Load__c=:LocationL';
                    String RegionD=dischargeFilter.Region__c;
                    if(String.IsNotEmpty(RegionD))
                        query+=' and Route__r.Country_of_Discharge__r.Region__c=:RegionD';
					String CountryD=filter.Route__r.Country_of_Discharge__c;
					if(String.IsNotEmpty(CountryD))
						query+=' and Route__r.Country_of_Discharge__c=:CountryD';
					String LocationD=filter.Route__r.Port_Airport_of_Discharge__c;
					if(String.IsNotEmpty(LocationD))
						query+=' and Route__r.Port_Airport_of_Discharge__c=:LocationD';
					Date ValidFrom=filter.Valid_From__c;
					Date ValidUntil=filter.Valid_Until__c;
                    if(ValidFrom!=null)
                        query+=' and (Valid_Until__c=null or Valid_Until__c>=:ValidFrom)';
                    if(ValidUntil!=null)
                        query+=' and (Valid_From__c=null or Valid_From__c<=:ValidUntil)';
					System.debug('query '+query);
	    			List<Fee__c>fees=(List<Fee__c>)DataBase.query(query);
    				if((feeSearch!=null)&&(DisplayMins>3))
    				{
		    			for(Fee__c fee:fees)
		    			{
		    				Decimal Max_Kgs=NEU_Utils.safeDecimal(fee.Max_Kgs__c);
		    				if(Max_Kgs!=0)
		    				{
		    					if(Min1==null)
		    					{
		    						Min1=Max_Kgs;
		    						continue;
		    					}
	    						if(Min1==Max_Kgs)
	    							continue;
	    						if(Min1>Max_Kgs)
	    						{
	    							Min5=Min4;
	    							Min4=Min3;
	    							Min3=Min2;
	    							Min2=Min1;
	    							Min1=Max_Kgs;
	    							continue;
	    						}
		    					if(Min2==null)
		    					{
		    						Min2=Max_Kgs;
		    						if(DisplayMins<5)
		    							DisplayMins=5;
		    						continue;
		    					}
	    						if(Min2==Max_Kgs)
	    							continue;
	    						if(Min2>Max_Kgs)
	    						{
	    							Min5=Min4;
	    							Min4=Min3;
	    							Min3=Min2;
	    							Min2=Max_Kgs;
	    							continue;
	    						}
		    					if(Min3==null)
		    					{
		    						Min3=Max_Kgs;
		    						if(DisplayMins<6)
		    							DisplayMins=6;
		    						continue;
		    					}
	    						if(Min3==Max_Kgs)
	    							continue;
	    						if(Min3>Max_Kgs)
	    						{
	    							Min5=Min4;
	    							Min4=Min3;
	    							Min3=Max_Kgs;
	    							continue;
	    						}
		    					if(Min4==null)
		    					{
		    						Min4=Max_Kgs;
		    						if(DisplayMins<7)
		    							DisplayMins=7;
		    						continue;
		    					}
	    						if(Min4==Max_Kgs)
	    							continue;
	    						if(Min4>Max_Kgs)
	    						{
	    							Min5=Min4;
	    							Min4=Max_Kgs;
	    							continue;
	    						}
		    					if(Min5==null)
		    					{
		    						Min5=Max_Kgs;
		    						if(DisplayMins<8)
		    							DisplayMins=8;
		    						continue;
		    					}
	    						if(Min5==Max_Kgs)
	    							continue;
	    						if(Min5>Max_Kgs)
	    						{
	    							Min5=Max_Kgs;
	    							continue;
	    						}
		    				}
		    			}
    				}
	    			for(Fee__c fee:fees)
	    			{
	    				if(feeSearch!=null)
	    				{
		    				String feeKey=NEU_Utils.safeString(fee.Name)+'_|_'+NEU_Utils.safeString(fee.Fee_Category__c)+'_|_'+NEU_Utils.safeString(fee.Route__c)+'_|_'+NEU_Utils.safeString(fee.Carrier_Account__c)+'_|_'+NEU_Utils.safeString(fee.TT_Days__c)+'_|_'+NEU_Utils.safeString(fee.Valid_From__c)+'_|_'+NEU_Utils.safeString(fee.Valid_Until__c)+'_|_'+NEU_Utils.safeString(fee.Account_for__c);
		    				ServiceRate_s mySR=feeSearch.get(feeKey);
							Boolean newSR=false;
		    				if(mySR==null)
                            {
		    					mySR=new ServiceRate_s(this,fee);
                                newSR=true;
                            }
		    				if((filter.Rate_Type__c=='Per Container')&&(DisplayConcepts==0))
		    				{
			    				if(fee.Container_Type__c==containers[0])
			   						mySR.fee1=fee;
			    				else if(fee.Container_Type__c==containers[1])
				    				mySR.fee2=fee;
			    				else if(fee.Container_Type__c==containers[2])
				    				mySR.fee3=fee;
                                if(newSR)
                                	if(feeSearch.size()>=200)
			                        {
			                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Too much Service Rates. Please refine filters'));
			                            break;
			                        }
				    			feeSearch.put(feeKey,mySR);
		    				}
		    				else if(DisplayMins>3)
		    				{
			    				Decimal Max_Kgs=NEU_Utils.safeDecimal(fee.Max_Kgs__c);
			    				if(Max_Kgs==0)
			   						mySR.fee1=fee;
			   					else if(Max_Kgs==Min1)
			   						mySR.fee2=fee;
			   					else if(Max_Kgs==Min2)
			   						mySR.fee3=fee;
			   					else if(Max_Kgs==Min3)
			   						mySR.fee4=fee;
			   					else if(Max_Kgs==Min4)
			   						mySR.fee5=fee;
			   					else if(Max_Kgs==Min5)
			   						mySR.fee6=fee;
			   					else
			   						continue;
                            	if(feeSearch.size()>=200)
		                        {
		                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Too much Service Rates. Please refine filters'));
		                            break;
		                        }
				    			feeSearch.put(feeKey,mySR);
		    				}
	    				}
	    				else
	    				{
	    					if(DisplayConcepts>0)
	    					{
			    				if(String.isEmpty(Concept1)&&String.isNotEmpty(fee.Concept_1__c))
			    					Concept1=fee.Concept_1__c;
			    				if(String.isEmpty(Concept2)&&String.isNotEmpty(fee.Concept_2__c))
			    					Concept2=fee.Concept_2__c;
			    				if(String.isEmpty(Concept3)&&String.isNotEmpty(fee.Concept_3__c))
			    					Concept3=fee.Concept_3__c;
			    				if(String.isEmpty(Concept4)&&String.isNotEmpty(fee.Concept_4__c))
			    					Concept4=fee.Concept_4__c;
			    				if(String.isEmpty(Concept5)&&String.isNotEmpty(fee.Concept_5__c))
			    					Concept5=fee.Concept_5__c;
	    					}
		    				ServiceRate_s mySR=new ServiceRate_s(this,fee);
                            if(myList.size()>=200)
		    				{
		    					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Too much Service Rates. Please refine filters'));
		    					break;
		    				}
			    			myList.add(mySR);
	    				}
	    			}
	    			if(feeSearch!=null)
		    			myList=feeSearch.values();
	    		}
    		}
    		return myList;
    	}
    	set
    	{
    		if(myList!=value)
    			myList=value;
    	}
    }
    public override void sortList(Integer listNumber)
    {
    	updateCountriesLocations();
    	myList.sort();
    }
    public Fee__c filter
    {
    	get
    	{
    		if(filter==null)
    		{
    			filter=new Fee__c();
//    			filter.Account_for__c='001b000003N8ptq';
    			filter.Route__r=new Carrier_Line_Load_Point__c();
/*    			filter.Fee_Category__c='Sea Freights';
    			filter.Carrier_Account__c='001b000003KgC3c';
    			filter.Valid_Until__c=Date.newInstance(2016,4,14);
    			filter.Route__r.Country_of_Discharge__c='a0Tb0000006GOMW';
    			filter.Route__r.Port_Airport_of_Discharge__c='a0Xb0000002uRhs';*/
    			NEU_CurrencyUtils.setCurrencyISOCode(filter,UserInfo.getDefaultCurrency());
    		}
    		return filter;
    	}
    	set
    	{
    		if(filter!=value)
    			filter=value;
    	}
    }
    public void resetList()
    {
    	myList=null;
        queryString=null;
    }
    public class ServiceRate_s extends NEU_Line_Comparable
    {
    	private String getMargin(Fee__c f)
    	{
    		Decimal Sell=NEU_Utils.safeDecimal(f.Fee_Rate__c);
    		if(Sell==0)
    			return null;
    		return (((Sell-NEU_Utils.safeDecimal(f.Buy_Rate__c))/Sell)*100).setScale(2).format();
    		
    	}
    	public String margin0{
    		get
    		{
    			return getMargin(fee0);
    		}
    		set;
    	}
    	public String margin1{
    		get
    		{
    			return getMargin(fee1);
    		}
    		set;
    	}
    	public String margin2{
    		get
    		{
    			return getMargin(fee2);
    		}
    		set;
    	}
    	public String margin3{
    		get
    		{
    			return getMargin(fee3);
    		}
    		set;
    	}
		public ServiceRate_s(NEU_Controller_Comparable parent,Fee__c fee)
        {
        	super(parent);
        	fee0=fee;
        	fee1=new Fee__c();
        	fee2=new Fee__c();
        	fee3=new Fee__c();
        	fee4=new Fee__c();
        	fee5=new Fee__c();
        	fee6=new Fee__c();
        }
        public override Object getValue(String compareField)
    	{
    		if(compareField=='Mins0')
    			return fee1.Buy_Rate__c;
    		if(compareField=='Mins1')
    			return fee2.Buy_Rate__c;
    		if(compareField=='Mins2')
    			return fee3.Buy_Rate__c;
    		if(compareField=='Mins3')
    			return fee4.Buy_Rate__c;
    		if(compareField=='Mins4')
    			return fee5.Buy_Rate__c;
    		if(compareField=='Mins5')
    			return fee6.Buy_Rate__c;
    		if(compareField=='Margin0')
    			return NEU_Utils.toDecimal(margin0);
    		if(compareField=='Margin1')
    			return NEU_Utils.toDecimal(margin1);
    		if(compareField=='Margin2')
    			return NEU_Utils.toDecimal(margin2);
    		if(compareField=='Margin3')
    			return NEU_Utils.toDecimal(margin3);
    		if(compareField=='Buy_Rate1')
    			return fee1.Buy_Rate__c;
    		if(compareField=='Buy_Rate2')
    			return fee2.Buy_Rate__c;
    		if(compareField=='Buy_Rate3')
    			return fee3.Buy_Rate__c;
    		if(compareField=='Sell_Rate1')
    			return fee1.Fee_Rate__c;
    		if(compareField=='Sell_Rate2')
    			return fee2.Fee_Rate__c;
    		if(compareField=='Sell_Rate3')
    			return fee3.Fee_Rate__c;
	        return getValue(fee0,compareField);
    	}
    	public Fee__c fee0{get;set;}
    	public Fee__c fee1{get;set;}
    	public Fee__c fee2{get;set;}
    	public Fee__c fee3{get;set;}
    	public Fee__c fee4{get;set;}
    	public Fee__c fee5{get;set;}
    	public Fee__c fee6{get;set;}
    	public Id Port_Airport_of_Load
    	{
    		get
    		{
    			return fee0.Route__r.Port_Airport_of_Load__c;
    		}
    		set
    		{
    			if(fee0.Route__r.Port_Airport_of_Load__c!=value)
    				fee0.Route__r.Port_Airport_of_Load__c=value;
    		}
    	}
    	public Id Port_Airport_of_Discharge
    	{
    		get
    		{
    			return fee0.Route__r.Port_Airport_of_Discharge__c;
    		}
    		set
    		{
    			if(fee0.Route__r.Port_Airport_of_Discharge__c!=value)
    				fee0.Route__r.Port_Airport_of_Discharge__c=value;
    		}
    	}
    }
    public String idLines{get;set;}
    public Integer firstLine{get;set;}
    public void orderLines()
    {
    	validationOK='true';
    	if(String.IsEmpty(idLines))
    		return;
    	if(firstLine==null)
    		return;
    	updateCountriesLocations();
    	List<String>pasteids=idLines.split('_\\|_');
    	Integer pasteCounter=firstLine;
    	for(String pasteid:pasteIds)
    	{
    		ServiceRate_s myItem=null;
    		Integer myLine=pasteCounter;
    		for(;myLine<myList.size();myLine++)
    			if(myList[myLine].fee0.Name==pasteid)
    			{
    				myItem=myList[myLine];
    				break;
    			}
    		if(myItem!=null)
    		{
    			if(pasteCounter!=myLine)
    				if(pasteCounter<myList.size())
	    				myList.add(pasteCounter,myList.remove(myLine));
	    			else
	    				myList.add(myList.remove(myLine));
				pasteCounter++;
				continue;
    		}
    		myItem=generateSR();
    		myItem.fee0.Name=pasteid;
			if(pasteCounter<myList.size())
				myList.add(pasteCounter,myItem);
			else
				myList.add(myItem);
    		pasteCounter++;
    	}
    }
    public Integer numLines{get;set;}
    public void addLines()
    {
    	validationOK='true';
		updateCountriesLocations();
    	for(Integer counter=0;counter<numlines;counter++)
			myList.add(generateSR());
    }
    private ServiceRate_s generateSR()
    {
    	Fee__c fee0=new Fee__c();
    	NEU_CurrencyUtils.setCurrencyISOCode(fee0,NEU_CurrencyUtils.getCurrencyISOCode(filter));
    	fee0.Active__c=true;
    	fee0.Carrier_Account__c=filter.Carrier_Account__c;
    	fee0.Fee_Category__c=filter.Fee_Category__c;
    	fee0.Account_for__c=filter.Account_for__c;
    	fee0.Valid_From__c=filter.Valid_From__c;
    	fee0.Valid_Until__c=filter.Valid_Until__c;
    	fee0.Rate_Type__c=filter.Rate_Type__c;
    	fee0.Route__r=new Carrier_Line_Load_Point__c();
    	fee0.Route__r.Country_of_Load__c=filter.Route__r.Country_of_Load__c;
    	fee0.Route__r.Port_Airport_of_Load__c=filter.Route__r.Port_Airport_of_Load__c;
    	fee0.Route__r.Country_of_Discharge__c=filter.Route__r.Country_of_Discharge__c;
    	fee0.Route__r.Port_Airport_of_Discharge__c=filter.Route__r.Port_Airport_of_Discharge__c;
		ServiceRate_s myItem=new ServiceRate_s(this,fee0);
		myItem.fee1=new Fee__c();
		myItem.fee1.Route__r=new Carrier_Line_Load_Point__c();
		myItem.fee2=new Fee__c();
		myItem.fee3=new Fee__c();
		myItem.fee4=new Fee__c();
		myItem.fee5=new Fee__c();
		myItem.fee6=new Fee__c();
		return myItem;
    }
    public void addLine()
    {
    	updateCountriesLocations();
		myList.add(generateSR());
    }
    public void updateCountriesLocations()
    {
    	Map<Id,Country__c>countries=new Map<Id,Country__c>([select Id,Name from Country__c]);
    	Map<Id,Location__c>locations=new Map<Id,Location__c>([select Id,Name,Country__c,Country__r.Name from Location__c]);
    	for(ServiceRate_s myItem:myList)
    	{
    		if(myItem.fee0.Route__r!=null)
    		{
                Boolean isnull=true;
	    		if(myItem.fee0.Route__r.Country_of_Load__c!=null)
	    		{
                    isnull=false;
	    			if(myItem.fee0.Route__r.Country_of_Load__r==null)
		    			myItem.fee0.Route__r.Country_of_Load__r=countries.get(myItem.fee0.Route__r.Country_of_Load__c);
		    		else if(myItem.fee0.Route__r.Country_of_Load__c!=myItem.fee0.Route__r.Country_of_Load__r.Id)
		    			myItem.fee0.Route__r.Country_of_Load__r=countries.get(myItem.fee0.Route__r.Country_of_Load__c);
	    		}
	    		else
	    			myItem.fee0.Route__r.Country_of_Load__r=null;
	    		if(myItem.fee0.Route__r.Port_Airport_of_Load__c!=null)
	    		{
                    isnull=false;
	    			if(myItem.fee0.Route__r.Port_Airport_of_Load__r==null)
		    			myItem.fee0.Route__r.Port_Airport_of_Load__r=locations.get(myItem.fee0.Route__r.Port_Airport_of_Load__c);
		    		else if(myItem.fee0.Route__r.Port_Airport_of_Load__c!=myItem.fee0.Route__r.Port_Airport_of_Load__r.Id)
		    			myItem.fee0.Route__r.Port_Airport_of_Load__r=locations.get(myItem.fee0.Route__r.Port_Airport_of_Load__c);
		    		if(myItem.fee0.Route__r.Port_Airport_of_Load__r!=null)
		    			if(myItem.fee0.Route__r.Country_of_Load__c!=myItem.fee0.Route__r.Port_Airport_of_Load__r.Country__c)
		    			{
		    				myItem.fee0.Route__r.Country_of_Load__c=myItem.fee0.Route__r.Port_Airport_of_Load__r.Country__c;
		    				myItem.fee0.Route__r.Country_of_Load__r=myItem.fee0.Route__r.Port_Airport_of_Load__r.Country__r;
		    			}
	    		}
	    		else
	    			myItem.fee0.Route__r.Port_Airport_of_Load__r=null;
	    		if(myItem.fee0.Route__r.Country_of_Discharge__c!=null)
	    		{
                    isnull=false;
	    			if(myItem.fee0.Route__r.Country_of_Discharge__r==null)
		    			myItem.fee0.Route__r.Country_of_Discharge__r=countries.get(myItem.fee0.Route__r.Country_of_Discharge__c);
		    		else if(myItem.fee0.Route__r.Country_of_Discharge__c!=myItem.fee0.Route__r.Country_of_Discharge__r.Id)
		    			myItem.fee0.Route__r.Country_of_Discharge__r=countries.get(myItem.fee0.Route__r.Country_of_Discharge__c);
	    		}
	    		else
	    			myItem.fee0.Route__r.Country_of_Discharge__r=null;
	    		if(myItem.fee0.Route__r.Port_Airport_of_Discharge__c!=null)
	    		{
                    isnull=false;
	    			if(myItem.fee0.Route__r.Port_Airport_of_Discharge__r==null)
		    			myItem.fee0.Route__r.Port_Airport_of_Discharge__r=locations.get(myItem.fee0.Route__r.Port_Airport_of_Discharge__c);
		    		else if(myItem.fee0.Route__r.Port_Airport_of_Discharge__c!=myItem.fee0.Route__r.Port_Airport_of_Discharge__r.Id)
		    			myItem.fee0.Route__r.Port_Airport_of_Discharge__r=locations.get(myItem.fee0.Route__r.Port_Airport_of_Discharge__c);
		    		if(myItem.fee0.Route__r.Port_Airport_of_Discharge__r!=null)
		    			if(myItem.fee0.Route__r.Country_of_Discharge__c!=myItem.fee0.Route__r.Port_Airport_of_Discharge__r.Country__c)
		    			{
		    				myItem.fee0.Route__r.Country_of_Discharge__c=myItem.fee0.Route__r.Port_Airport_of_Discharge__r.Country__c;
		    				myItem.fee0.Route__r.Country_of_Discharge__r=myItem.fee0.Route__r.Port_Airport_of_Discharge__r.Country__r;
		    			}
	    		}
	    		else
	    			myItem.fee0.Route__r.Port_Airport_of_Discharge__r=null;
                if(isnull)
                    myItem.fee0.Route__c=null;
    		}
            else
                myItem.fee0.Route__c=null;
    		if(myItem.fee1.Route__r!=null)
    		{
                Boolean isnull=true;
	    		if(myItem.fee1.Route__r.Country_of_Discharge__c!=null)
	    		{
                    isnull=false;
	    			if(myItem.fee1.Route__r.Country_of_Discharge__r==null)
		    			myItem.fee1.Route__r.Country_of_Discharge__r=countries.get(myItem.fee1.Route__r.Country_of_Discharge__c);
		    		else if(myItem.fee1.Route__r.Country_of_Discharge__c!=myItem.fee1.Route__r.Country_of_Discharge__r.Id)
		    			myItem.fee1.Route__r.Country_of_Discharge__r=countries.get(myItem.fee1.Route__r.Country_of_Discharge__c);
	    		}
	    		else
	    			myItem.fee1.Route__r.Country_of_Discharge__r=null;
	    		if(myItem.fee1.Route__r.Port_Airport_of_Discharge__c!=null)
	    		{
                    isnull=false;
	    			if(myItem.fee1.Route__r.Port_Airport_of_Discharge__r==null)
		    			myItem.fee1.Route__r.Port_Airport_of_Discharge__r=locations.get(myItem.fee1.Route__r.Port_Airport_of_Discharge__c);
		    		else if(myItem.fee1.Route__r.Port_Airport_of_Discharge__c!=myItem.fee1.Route__r.Port_Airport_of_Discharge__r.Id)
		    			myItem.fee1.Route__r.Port_Airport_of_Discharge__r=locations.get(myItem.fee1.Route__r.Port_Airport_of_Discharge__c);
		    		if(myItem.fee1.Route__r.Port_Airport_of_Discharge__r!=null)
		    			if(myItem.fee1.Route__r.Country_of_Discharge__c!=myItem.fee1.Route__r.Port_Airport_of_Discharge__r.Country__c)
		    			{
		    				myItem.fee1.Route__r.Country_of_Discharge__c=myItem.fee1.Route__r.Port_Airport_of_Discharge__r.Country__c;
		    				myItem.fee1.Route__r.Country_of_Discharge__r=myItem.fee1.Route__r.Port_Airport_of_Discharge__r.Country__r;
		    			}
	    		}
	    		else
	    			myItem.fee1.Route__r.Port_Airport_of_Discharge__r=null;
                if(isnull)
                    myItem.fee1.Route__c=null;
    		}
            else
                myItem.fee1.Route__c=null;
    	}
    }
    private Carrier_Line_Load_Point__c getRoute(Map<String,Carrier_Line_Load_Point__c>maproutes,List<Carrier_Line_Load_Point__c>routes,List<Carrier_Line_Load_Point__c>legs,Fee__c fee0,Fee__c fee1,Boolean secondlevel)
    {
        if(fee0.Route__r==null)
            return null;
		String mapkey=NEU_Utils.safeString(fee0.Route__r.Country_of_Load__c)+'_|_'+NEU_Utils.safeString(fee0.Route__r.Port_Airport_of_Load__c)+'_|_'+NEU_Utils.safeString(fee0.Route__r.Country_of_Discharge__c)+'_|_'+NEU_Utils.safeString(fee0.Route__r.Port_Airport_of_Discharge__c);
		if(fee0.Fee_Category__c=='Multimodal Freights')
			mapkey+='_|_'+NEU_Utils.safeString(fee1.Route__r.Country_of_Discharge__c)+'_|_'+NEU_Utils.safeString(fee1.Route__r.Port_Airport_of_Discharge__c);
		else
			mapkey+='_|__|_';
		Carrier_Line_Load_Point__c r=maproutes.get(mapkey);
		if(r==null)
		{
			r=new Carrier_Line_Load_Point__c();
			r.Country_of_Load__c=fee0.Route__r.Country_of_Load__c;
			r.Country_of_Load__r=fee0.Route__r.Country_of_Load__r;
			r.Port_Airport_of_Load__c=fee0.Route__r.Port_Airport_of_Load__c;
			r.Port_Airport_of_Load__r=fee0.Route__r.Port_Airport_of_Load__r;
			r.Country_of_Discharge__c=fee0.Route__r.Country_of_Discharge__c;
			r.Country_of_Discharge__r=fee0.Route__r.Country_of_Discharge__r;
			r.Port_Airport_of_Discharge__c=fee0.Route__r.Port_Airport_of_Discharge__c;
			r.Port_Airport_of_Discharge__r=fee0.Route__r.Port_Airport_of_Discharge__r;
			if(fee0.Fee_Category__c=='Multimodal Freights')
			{
				Fee__c feeaux=new Fee__c();
				feeaux.Route__r=new Carrier_Line_Load_Point__c();
				feeaux.Route__r.Country_of_Load__c=fee0.Route__r.Country_of_Load__c;
				feeaux.Route__r.Country_of_Load__r=fee0.Route__r.Country_of_Load__r;
				feeaux.Route__r.Port_Airport_of_Load__c=fee0.Route__r.Port_Airport_of_Load__c;
				feeaux.Route__r.Port_Airport_of_Load__r=fee0.Route__r.Port_Airport_of_Load__r;
				feeaux.Route__r.Country_of_Discharge__c=fee1.Route__r.Country_of_Discharge__c;
				feeaux.Route__r.Country_of_Discharge__r=fee1.Route__r.Country_of_Discharge__r;
				feeaux.Route__r.Port_Airport_of_Discharge__c=fee1.Route__r.Port_Airport_of_Discharge__c;
				feeaux.Route__r.Port_Airport_of_Discharge__r=fee1.Route__r.Port_Airport_of_Discharge__r;
				r.First_Leg_Route__r=getRoute(maproutes,routes,legs,feeaux,null,true);

				feeaux.Route__r.Country_of_Load__c=fee1.Route__r.Country_of_Discharge__c;
				feeaux.Route__r.Country_of_Load__r=fee1.Route__r.Country_of_Discharge__r;
				feeaux.Route__r.Port_Airport_of_Load__c=fee1.Route__r.Port_Airport_of_Discharge__c;
				feeaux.Route__r.Port_Airport_of_Load__r=fee1.Route__r.Port_Airport_of_Discharge__r;
				feeaux.Route__r.Country_of_Discharge__c=fee0.Route__r.Country_of_Discharge__c;
				feeaux.Route__r.Country_of_Discharge__r=fee0.Route__r.Country_of_Discharge__r;
				feeaux.Route__r.Port_Airport_of_Discharge__c=fee0.Route__r.Port_Airport_of_Discharge__c;
				feeaux.Route__r.Port_Airport_of_Discharge__r=fee0.Route__r.Port_Airport_of_Discharge__r;
				r.Second_Leg_Route__r=getRoute(maproutes,routes,legs,feeaux,null,true);
			}
			maproutes.put(mapkey,r);
			if(secondlevel)
				legs.add(r);
			else
				routes.add(r);
		}
		return r;
    }
    public void saveData()
    {
		updateCountriesLocations();
    	Map<String,Carrier_Line_Load_Point__c>maproutes=new Map<String,Carrier_Line_Load_Point__c>();
    	for(Carrier_Line_Load_Point__c r:[select Id,Country_of_Load__c,Country_of_Load__r.Name,Port_Airport_of_Load__c,Port_Airport_of_Load__r.Name,Country_of_Discharge__c,Country_of_Discharge__r.Name,Port_Airport_of_Discharge__c,Port_Airport_of_Discharge__r.Name,First_Leg_Route__r.Country_of_Discharge__c,First_Leg_Route__r.Country_of_Discharge__r.Name,First_Leg_Route__r.Port_Airport_of_Discharge__c,First_Leg_Route__r.Port_Airport_of_Discharge__r.Name from Carrier_Line_Load_Point__c])
    		maproutes.put(NEU_Utils.safeString(r.Country_of_Load__c)+'_|_'+NEU_Utils.safeString(r.Port_Airport_of_Load__c)+'_|_'+NEU_Utils.safeString(r.Country_of_Discharge__c)+'_|_'+NEU_Utils.safeString(r.Port_Airport_of_Discharge__c)+'_|_'+NEU_Utils.safeString(r.First_Leg_Route__r.Country_of_Discharge__c)+'_|_'+NEU_Utils.safeString(r.First_Leg_Route__r.Port_Airport_of_Discharge__c),r);
    	List<Fee__c>fees=new List<Fee__c>();
    	List<Carrier_Line_Load_Point__c>routes=new List<Carrier_Line_Load_Point__c>();
    	List<Carrier_Line_Load_Point__c>legs=new List<Carrier_Line_Load_Point__c>();
    	for(ServiceRate_s myItem:myList)
    	{
    		if(String.IsNotEmpty(myItem.fee0.Name))
    		{
    			myItem.fee0.Route__r=getRoute(maproutes,routes,legs,myItem.fee0,myItem.fee1,false);
                if(myItem.fee0.Route__r!=null)
	    			myItem.fee0.Route__c=myItem.fee0.Route__r.Id;
                else
                    myItem.fee0.Route__c=null;
    		}
    	}
    	if(legs.size()>0)
    	{
    		try
    		{
    			insert legs;
    		}
    		catch(Exception e)
    		{
	    		String message=e.getMessage();
    			if(message.contains('_EXCEPTION, '))
    				message=message.substringAfter('_EXCEPTION, ').remove(': []');
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,message+' (new legs)'));
    		}
    	}
    	if(routes.size()>0)
    	{
    		try
    		{
    			insert routes;
    		}
    		catch(Exception e)
    		{
	    		String message=e.getMessage();
    			if(message.contains('_EXCEPTION, '))
    				message=message.substringAfter('_EXCEPTION, ').remove(': []');
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,message+' (new routes)'));
    		}
    	}
    	for(ServiceRate_s myItem:myList)
    	{
    		if(String.IsNotEmpty(myItem.fee0.Name))
    		{
                if((myItem.fee0.Route__c==null)&&(myItem.fee0.Route__r!=null))
	    			myItem.fee0.Route__c=myItem.fee0.Route__r.Id;
                if((myItem.fee0.Route__c!=null)&&(myItem.fee0.Route__r!=null))
                    if((myItem.fee0.Route__r.Country_of_Load__c==null)&&
                        (myItem.fee0.Route__r.Port_Airport_of_Load__c==null)&&
                        (myItem.fee0.Route__r.Country_of_Discharge__c==null)&&
                        (myItem.fee0.Route__r.Port_Airport_of_Discharge__c==null))
                        myItem.fee0.Route__c=null;
	    		if(filter.Rate_Type__c!='Per Container')
	    		{
		    		if((filter.Rate_Type__c=='Per Kg')&&(DisplayMins>3))
		    		{
	    				myItem.fee0.Rate_Type__c='Per Kg';
			    		if((myItem.fee1.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee1.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee1.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee1);
			    			myItem.fee1.Max_Kgs__c=null;
			    			fees.add(myItem.fee1);
			    		}
			    		if((myItem.fee2.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee2.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee2.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee2);
			    			myItem.fee2.Max_Kgs__c=Min1;
			    			fees.add(myItem.fee2);
			    		}
			    		if((myItem.fee3.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee3.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee3.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee3);
			    			myItem.fee3.Max_Kgs__c=Min2;
			    			fees.add(myItem.fee3);
			    		}
			    		if((myItem.fee4.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee4.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee4.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee4);
			    			myItem.fee4.Max_Kgs__c=Min3;
			    			fees.add(myItem.fee4);
			    		}
			    		if((myItem.fee5.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee5.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee5.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee5);
			    			myItem.fee5.Max_Kgs__c=Min4;
			    			fees.add(myItem.fee5);
			    		}
			    		if((myItem.fee6.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee6.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee6.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee6);
			    			myItem.fee6.Max_Kgs__c=Min5;
			    			fees.add(myItem.fee6);
			    		}
		    		}
		    		else
	    				fees.add(myItem.fee0);
	    		}
	    		else
	    		{
	    			if(DisplayConcepts>0)
	    			{
	    				myItem.fee0.Rate_Type__c='Per Container';
	    				if(NEU_Utils.safeDecimal(myItem.fee0.Cost_Concept_1__c)!=0)
	    					myItem.fee0.Concept_1__c=Concept1;
	    				else
	    				{
	    					myItem.fee0.Concept_1__c=null;
	    					myItem.fee0.Cost_Concept_1__c=null;
	    				}
	    				if((NEU_Utils.safeDecimal(myItem.fee0.Cost_Concept_2__c)!=0)&&(DisplayConcepts>1))
	    					myItem.fee0.Concept_2__c=Concept2;
	    				else
	    				{
	    					myItem.fee0.Concept_2__c=null;
	    					myItem.fee0.Cost_Concept_2__c=null;
	    				}
	    				if((NEU_Utils.safeDecimal(myItem.fee0.Cost_Concept_3__c)!=0)&&(DisplayConcepts>2))
	    					myItem.fee0.Concept_3__c=Concept3;
	    				else
	    				{
	    					myItem.fee0.Concept_3__c=null;
	    					myItem.fee0.Cost_Concept_3__c=null;
	    				}
	    				if((NEU_Utils.safeDecimal(myItem.fee0.Cost_Concept_4__c)!=0)&&(DisplayConcepts>3))
	    					myItem.fee0.Concept_4__c=Concept4;
	    				else
	    				{
	    					myItem.fee0.Concept_4__c=null;
	    					myItem.fee0.Cost_Concept_4__c=null;
	    				}
	    				if((NEU_Utils.safeDecimal(myItem.fee0.Cost_Concept_5__c)!=0)&&(DisplayConcepts>4))
	    					myItem.fee0.Concept_5__c=Concept5;
	    				else
	    				{
	    					myItem.fee0.Concept_5__c=null;
	    					myItem.fee0.Cost_Concept_5__c=null;
	    				}
		    			fees.add(myItem.fee0);
	    			}
	    			else
	    			{
	    				myItem.fee0.Rate_Type__c='Per Container';
			    		if((myItem.fee1.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee1.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee1.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee1);
			    			myItem.fee1.Container_Type__c=containers[0];
			    			fees.add(myItem.fee1);
			    		}
			    		if((myItem.fee2.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee2.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee2.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee2);
			    			myItem.fee2.Container_Type__c=containers[1];
			    			fees.add(myItem.fee2);
			    		}
			    		if((myItem.fee3.Id!=null)||(NEU_Utils.safeDecimal(myItem.fee3.Buy_Rate__c)!=0)||(NEU_Utils.safeDecimal(myItem.fee3.Fee_Rate__c)!=0))
			    		{
			    			copyFee(myItem.fee0,myItem.fee3);
			    			myItem.fee3.Container_Type__c=containers[2];
			    			fees.add(myItem.fee3);
			    		}
	    			}
	    		}
    		}
    	}
    	if(fees.size()>0)
    		try
    		{
	    		upsert fees;
    		}
    		catch(Exception e)
    		{
	    		String message=e.getMessage();
    			if(message.contains('_EXCEPTION, '))
    				message=message.substringAfter('_EXCEPTION, ').remove(': []');
	    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,message));
    		}
    	resetList();
    }
    private void copyFee(Fee__c orig,Fee__c dest)
    {
    	NEU_CurrencyUtils.setCurrencyIsoCode(dest,NEU_CurrencyUtils.getCurrencyIsoCode(orig));
		dest.Name=orig.Name;
		dest.Active__c=orig.Active__c;
		dest.Fee_Category__c=orig.Fee_Category__c;
		dest.Route__c=orig.Route__c;
		dest.Route__r=null;
		dest.Carrier_Account__c=orig.Carrier_Account__c;
		dest.TT_Days__c=orig.TT_Days__c;
		dest.Valid_From__c=orig.Valid_From__c;
		dest.Valid_Until__c=orig.Valid_Until__c;
		dest.Account_for__c=orig.Account_for__c;
		dest.Rate_Type__c=orig.Rate_Type__c;
		dest.Container_Type__c=orig.Container_Type__c;
		dest.Volumetric_Factor__c=orig.Volumetric_Factor__c;
		dest.Min__c=orig.Min__c;
		dest.Max_M3__c=orig.Max_M3__c;
		dest.Max_Kgs__c=orig.Max_Kgs__c;
        dest.Comments__c=orig.Comments__c;
	}
	
	public NEU_Freight_Rates_Management()
	{
		alllocations=createalllocations();
		filter_date = new Fee__c();
		filter_date.Valid_Until__c = system.today();
	}
	
	public void get_carrier_contact_details()
	{
		message_data = '';
		message_header = '';
		
		List<Contact> contact = [select Id, Name, Phone, MobilePhone, Email, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
		from Contact where AccountId =: id_carrier and Sales_Contact__c = true limit 1];
		if(contact.size() > 0)
		{
			message_header = contact[0].Name;
			
			message_data += '<table class="detailList">';
  			message_data += '	<tr class="dataRow">';
  			message_data += '		<td class="dataCell td_icon"><img src="/resource/1494244748000/FRM_phone" class="message_icon"/></td><td class="dataCell td_text">'+(contact[0].Phone != null ? contact[0].Phone : '')+'</td>';
  			message_data += '	</tr>';
  			message_data += '	<tr class="dataRow">';
  			message_data += '		<td class="dataCell td_icon"><img src="/resource/1494244729000/FRM_mobile_phone" class="message_icon"/></td><td class="dataCell td_text">'+(contact[0].MobilePhone != null ? contact[0].MobilePhone : '')+'</td>';
  			message_data += '	</tr>';
  			message_data += '	<tr class="dataRow">';
  			message_data += '		<td class="dataCell td_icon"><img src="/resource/1494244646000/FRM_email" class="message_icon"/></td><td class="dataCell td_text">'+(contact[0].Email != null ? contact[0].Email : '')+'</td>';
  			message_data += '	</tr>';
  			message_data += '	<tr class="dataRow">';
  			message_data += '		<td class="dataCell td_icon"><img src="/resource/1494244705000/FRM_location" class="message_icon"/></td>';
  			message_data += '		<td class="dataCell td_text">';
  			message_data += (contact[0].MailingStreet != null ? contact[0].MailingStreet : '');
  			message_data += (contact[0].MailingCity != null ? '<br/>'+contact[0].MailingCity : '');
  			message_data += (contact[0].MailingState != null ? '<br/>'+contact[0].MailingState : '');
  			message_data += (contact[0].MailingPostalCode != null ? '<br/>'+contact[0].MailingPostalCode : '');
  			message_data += (contact[0].MailingCountry != null ? '<br/>'+contact[0].MailingCountry : '');
  			message_data += '		</td>';
  			message_data += '	</tr>';
  			message_data += '</table>';
		}
		else
		{
			message_header = 'NO DATA AVAILABLE';
			message_data = 'NO DATA AVAILABLE';
		}
	}
	
	public void get_historical_prices()
	{
		message_data = '';
		message_header = 'Historical Prices';
		
		string query_this_fee = '';
		query_this_fee += 'SELECT Id, Name, Route__c, RecordTypeId, Fee_Category__c, Account_for__c, Carrier_Account__c, Container_Type__c, Rate_Type__c,';
		query_this_fee += ' Buy_Rate__c, Fee_Rate__c';
		if(UserInfo.isMultiCurrencyOrganization())
			query_this_fee += ', CurrencyIsoCode';
		query_this_fee += ' FROM Fee__c WHERE Id =: id_service LIMIT 1';
		
		Fee__c this_fee = Database.query(query_this_fee);
		
		StaticResource equal_icon_query = [select Id, Name, SystemModStamp from StaticResource where Name = 'FRM_equal_icon' limit 1];
		StaticResource arrow_red_query = [select Id, Name, SystemModStamp from StaticResource where Name = 'FRM_arrow_red' limit 1];
		StaticResource arrow_green_query = [select Id, Name, SystemModStamp from StaticResource where Name = 'FRM_arrow_green' limit 1];
		
		String equal_icon = '';
		String arrow_red = '';
		String arrow_green = '';
		
		if(equal_icon_query != null)
			equal_icon = '/resource/'+String.valueOf(((DateTime)equal_icon_query.get('SystemModStamp')).getTime())+'/'+equal_icon_query.get('Name');
		if(arrow_red_query != null)
			arrow_red = '/resource/'+String.valueOf(((DateTime)arrow_red_query.get('SystemModStamp')).getTime())+'/'+arrow_red_query.get('Name');
		if(arrow_green_query != null)
			arrow_green = '/resource/'+String.valueOf(((DateTime)arrow_green_query.get('SystemModStamp')).getTime())+'/'+arrow_green_query.get('Name');
		
		String date_filter = filter_date.Valid_Until__c.day()+'/'+filter_date.Valid_Until__c.month()+'/'+filter_date.Valid_Until__c.year();
		
		if(this_fee != null)
		{
			string route = this_fee.Route__c;
			string record_type = this_fee.RecordTypeId;
			string fee_category = this_fee.Fee_Category__c;
			string account_for = this_fee.Account_for__c;
			string container_type = this_fee.Container_Type__c;
			string rate_type = this_fee.Rate_Type__c;
			string carrier_account = this_fee.Carrier_Account__c;
			date since_date = filter_date.Valid_Until__c;
			
			string CurrencyISOCode = NEU_CurrencyUtils.getCurrencyISOCode(this_fee);
			
			if(info_type == 'buy_rate_1' || Test.isRunningTest())
			{
				//HISTORICAL BUY RATE (ALL TIME / ALL CARRIERS)
				string query_shipment_lines_1_min = '';
				query_shipment_lines_1_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type';
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for';
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type'; 
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_1_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_min += ' ORDER BY Shipment_Buy_Price__c ASC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_min = Database.query(query_shipment_lines_1_min);

				string query_shipment_lines_1_max = '';
				query_shipment_lines_1_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_max += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_1_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category';
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_1_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_max += ' ORDER BY Shipment_Buy_Price__c DESC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_max = Database.query(query_shipment_lines_1_max);
				
				string query_shipment_lines_1_avg = '';
				query_shipment_lines_1_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg'; 
				query_shipment_lines_1_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_avg += ' WHERE Service_Rate_Name__r.Route__c =: route';
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type';
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for';
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_1_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_1_avg = Database.query(query_shipment_lines_1_avg);

				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_1_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_1_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_1_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_1_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_1_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_min[0].CreatedDate.day()+'/'+shipment_lines_1_min[0].CreatedDate.month()+'/'+shipment_lines_1_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_1_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_1_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_1_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_1_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_max[0].CreatedDate.day()+'/'+shipment_lines_1_max[0].CreatedDate.month()+'/'+shipment_lines_1_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_avg.size() > 0  && shipment_lines_1_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_1_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
					
				//HISTORICAL BUY RATE (ALL TIME / THIS CARRIER)
				string query_shipment_lines_2_min = '';
				query_shipment_lines_2_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_2_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_min += ' ORDER BY Shipment_Buy_Price__c ASC';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_min = Database.query(query_shipment_lines_2_min);
				
				string query_shipment_lines_2_max = '';
				query_shipment_lines_2_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_2_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_max += ' ORDER BY Shipment_Buy_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_max = Database.query(query_shipment_lines_2_max);
				
				string query_shipment_lines_2_avg = '';
				query_shipment_lines_2_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg'; 
				query_shipment_lines_2_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_2_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_2_avg = Database.query(query_shipment_lines_2_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_2_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_2_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_2_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_2_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_2_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_min[0].CreatedDate.day()+'/'+shipment_lines_2_min[0].CreatedDate.month()+'/'+shipment_lines_2_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_2_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_2_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_2_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_2_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_max[0].CreatedDate.day()+'/'+shipment_lines_2_max[0].CreatedDate.month()+'/'+shipment_lines_2_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_avg.size() > 0  && shipment_lines_2_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_2_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
			}
			
			if(info_type == 'buy_rate_2' || Test.isRunningTest())
			{
				//HISTORICAL BUY RATE (SINCE THIS DATE / ALL CARRIERS)
				string query_shipment_lines_3_min = '';
				query_shipment_lines_3_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_min += ' ORDER BY Shipment_Buy_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_3_min = Database.query(query_shipment_lines_3_min);
				
				string query_shipment_lines_3_max = ''; 
				query_shipment_lines_3_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_max += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_3_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_max += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_max += ' ORDER BY Shipment_Buy_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_3_max = Database.query(query_shipment_lines_3_max);
				
				string query_shipment_lines_3_avg = '';
				query_shipment_lines_3_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg';
				query_shipment_lines_3_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				
				AggregateResult[] shipment_lines_3_avg = Database.query(query_shipment_lines_3_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_3_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_3_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_3_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_3_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_3_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_min[0].CreatedDate.day()+'/'+shipment_lines_3_min[0].CreatedDate.month()+'/'+shipment_lines_3_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_3_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_3_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_3_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_3_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_max[0].CreatedDate.day()+'/'+shipment_lines_3_max[0].CreatedDate.month()+'/'+shipment_lines_3_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_avg.size() > 0 && shipment_lines_3_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_3_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	

				//HISTORICAL BUY RATE (SINCE THIS DATE / THIS CARRIER)
				string query_shipment_lines_4_min = '';
				query_shipment_lines_4_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_4_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_min += ' ORDER BY Shipment_Buy_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_4_min = Database.query(query_shipment_lines_4_min);
				
				string query_shipment_lines_4_max = '';
				query_shipment_lines_4_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_4_max += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_max += ' ORDER BY Shipment_Buy_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_4_max = Database.query(query_shipment_lines_4_max);
				
				string query_shipment_lines_4_avg = '';
				query_shipment_lines_4_avg += 'SELECT AVG(Shipment_Buy_Price__c)avg';
				query_shipment_lines_4_avg += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_4_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_4_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				
				AggregateResult[] shipment_lines_4_avg = Database.query(query_shipment_lines_4_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_4_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_4_min[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_4_min[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_min[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_4_min[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_4_min[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_min[0].CreatedDate.day()+'/'+shipment_lines_4_min[0].CreatedDate.month()+'/'+shipment_lines_4_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < shipment_lines_4_max[0].Shipment_Buy_Price__c ? 'color:red;' : (buy_rate_filter > shipment_lines_4_max[0].Shipment_Buy_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_max[0].Shipment_Buy_Price__c+'</strong><img src="'+(buy_rate_filter < shipment_lines_4_max[0].Shipment_Buy_Price__c ? arrow_red : (buy_rate_filter > shipment_lines_4_max[0].Shipment_Buy_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_max[0].CreatedDate.day()+'/'+shipment_lines_4_max[0].CreatedDate.month()+'/'+shipment_lines_4_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_avg.size() > 0 && shipment_lines_4_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:red;' : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_4_avg[0].get('avg')+'</strong><img src="'+(buy_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_red : (buy_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	
			}
			
			if(info_type == 'sell_rate_1' || Test.isRunningTest())
			{
				//HISTORICAL SELL RATE (ALL TIME / ALL CARRIERS)
				string query_shipment_lines_1_min = '';
				query_shipment_lines_1_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_1_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_min += ' ORDER BY Shipment_Sell_Price__c ASC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_min = Database.query(query_shipment_lines_1_min);
				
				string query_shipment_lines_1_max = '';
				query_shipment_lines_1_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_1_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_1_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_1_max += ' ORDER BY Shipment_Sell_Price__c DESC LIMIT 1';
				
				List<Shipment_Fee_Line__c> shipment_lines_1_max = Database.query(query_shipment_lines_1_max);
				
				string query_shipment_lines_1_avg = '';
				query_shipment_lines_1_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg'; 
				query_shipment_lines_1_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_1_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_1_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())   
					query_shipment_lines_1_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_1_avg = Database.query(query_shipment_lines_1_avg);

				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_1_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_1_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_1_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_1_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_1_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_min[0].CreatedDate.day()+'/'+shipment_lines_1_min[0].CreatedDate.month()+'/'+shipment_lines_1_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_1_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_1_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_1_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_1_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_1_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_1_max[0].CreatedDate.day()+'/'+shipment_lines_1_max[0].CreatedDate.month()+'/'+shipment_lines_1_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_1_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_1_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_1_avg.size() > 0  && shipment_lines_1_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_1_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_1_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
					
				//HISTORICAL SELL RATE (ALL TIME / THIS CARRIER)
				string query_shipment_lines_2_min = '';
				query_shipment_lines_2_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_2_min += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_min += ' ORDER BY Shipment_Sell_Price__c asc';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_min = Database.query(query_shipment_lines_2_min);
			
				string query_shipment_lines_2_max = '';
				query_shipment_lines_2_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_2_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_2_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_2_max += ' ORDER BY Shipment_Sell_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_2_max = Database.query(query_shipment_lines_2_max);
				
				string query_shipment_lines_2_avg = '';
				query_shipment_lines_2_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg'; 
				query_shipment_lines_2_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_2_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account'; 
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type';
				query_shipment_lines_2_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type'; 
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_2_avg += ' AND CurrencyIsoCode =: CurrencyISOCode';
				
				AggregateResult[] shipment_lines_2_avg = Database.query(query_shipment_lines_2_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">ALL TIME / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_2_min.size() > 0)
				{
		  			
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_2_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_2_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_2_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_2_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_min[0].CreatedDate.day()+'/'+shipment_lines_2_min[0].CreatedDate.month()+'/'+shipment_lines_2_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_2_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_2_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_2_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_2_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_2_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_2_max[0].CreatedDate.day()+'/'+shipment_lines_2_max[0].CreatedDate.month()+'/'+shipment_lines_2_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_2_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_2_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_2_avg.size() > 0  && shipment_lines_2_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_2_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_2_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '		<th class="headerRow"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';
			}
			
			if(info_type == 'sell_rate_2' || Test.isRunningTest())
			{
				//HISTORICAL SELL RATE (SINCE THIS DATE / ALL CARRIERS)
				string query_shipment_lines_3_min = '';
				query_shipment_lines_3_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_min += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_min += ' ORDER BY Shipment_Sell_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_3_min = Database.query(query_shipment_lines_3_min);
				
				string query_shipment_lines_3_max = '';
				query_shipment_lines_3_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_3_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_max += ' WHERE Service_Rate_Name__r.Route__c =: route and Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())
					query_shipment_lines_3_max += ' AND CurrencyIsoCode =: CurrencyISOCode';
				query_shipment_lines_3_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_3_max += ' ORDER BY Shipment_Sell_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_3_max = Database.query(query_shipment_lines_3_max);
				
				string query_shipment_lines_3_avg = '';
				query_shipment_lines_3_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg';
				query_shipment_lines_3_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_3_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_3_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization()) 
					query_shipment_lines_3_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_3_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				
				AggregateResult[] shipment_lines_3_avg = Database.query(query_shipment_lines_3_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / ALL CARRIERS</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
				message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';	  			
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_3_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_3_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_3_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_3_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_3_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_min[0].CreatedDate.day()+'/'+shipment_lines_3_min[0].CreatedDate.month()+'/'+shipment_lines_3_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_3_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_3_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_3_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_3_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_3_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_3_max[0].CreatedDate.day()+'/'+shipment_lines_3_max[0].CreatedDate.month()+'/'+shipment_lines_3_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_3_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_3_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_3_avg.size() > 0 && shipment_lines_3_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_3_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_3_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	

				//HISTORICAL SELL RATE (SINCE THIS DATE / THIS CARRIER)
				string query_shipment_lines_4_min = '';
				query_shipment_lines_4_min += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_min += ' FROM Shipment_Fee_Line__c';
				query_shipment_lines_4_min += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())  
					query_shipment_lines_4_min += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_min += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_min += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_min += ' ORDER BY Shipment_Sell_Price__c ASC';
				
			  	List<Shipment_Fee_Line__c> shipment_lines_4_min = Database.query(query_shipment_lines_4_min);
				
				string query_shipment_lines_4_max = '';
				query_shipment_lines_4_max += 'SELECT Id, Name, Shipment_Buy_Price__c, Shipment_Sell_Price__c, Shipment__r.Name, CreatedDate';
				query_shipment_lines_4_max += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_max += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())   
					query_shipment_lines_4_max += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_max += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_max += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				query_shipment_lines_4_max += ' ORDER BY Shipment_Sell_Price__c DESC';
				
				List<Shipment_Fee_Line__c> shipment_lines_4_max = Database.query(query_shipment_lines_4_max);
				
				string query_shipment_lines_4_avg = '';
				query_shipment_lines_4_avg += 'SELECT AVG(Shipment_Sell_Price__c)avg';
				query_shipment_lines_4_avg += ' FROM Shipment_Fee_Line__c'; 
				query_shipment_lines_4_avg += ' WHERE Service_Rate_Name__r.Route__c =: route'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.RecordTypeId =: record_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Fee_Category__c =: fee_category'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Account_for__c =: account_for'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Container_Type__c =: container_type'; 
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Rate_Type__c =: rate_type';
				if(UserInfo.isMultiCurrencyOrganization())    
					query_shipment_lines_4_avg += ' AND CurrencyIsoCode =: CurrencyISOCode'; 
				query_shipment_lines_4_avg += ' AND DAY_ONLY(CreatedDate) >=: since_date';
				query_shipment_lines_4_avg += ' AND Service_Rate_Name__r.Carrier_Account__c =: carrier_account';
				
				AggregateResult[] shipment_lines_4_avg = Database.query(query_shipment_lines_4_avg);
				
				message_data += '<table class="list table_data">';
				message_data += '	<tr class="headerRow"><th class="headerRow" colspan="4" style="text-align:center;">SINCE '+date_filter+' / THIS CARRIER</th></tr>';
				message_data += '	<tr class="headerRow">';
				message_data += '		<th class="headerRow" style="text-align:center;"></th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">RATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">DATE</th>';
	  			message_data += '		<th class="headerRow" style="text-align:center;">SHIPMENT</th>';
	  			message_data += '	</tr>';
				if(shipment_lines_4_min.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MIN</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_4_min[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_4_min[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_min[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_4_min[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_4_min[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_min[0].CreatedDate.day()+'/'+shipment_lines_4_min[0].CreatedDate.month()+'/'+shipment_lines_4_min[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_min[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_min[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_max.size() > 0)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">MAX</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < shipment_lines_4_max[0].Shipment_Sell_Price__c ? 'color:red;' : (sell_rate_filter > shipment_lines_4_max[0].Shipment_Sell_Price__c ? 'color:green;' : ''))+'">'+shipment_lines_4_max[0].Shipment_Sell_Price__c+'</strong><img src="'+(sell_rate_filter < shipment_lines_4_max[0].Shipment_Sell_Price__c ? arrow_red : (sell_rate_filter > shipment_lines_4_max[0].Shipment_Sell_Price__c ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;">'+shipment_lines_4_max[0].CreatedDate.day()+'/'+shipment_lines_4_max[0].CreatedDate.month()+'/'+shipment_lines_4_max[0].CreatedDate.year()+'</td>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><a href="/'+shipment_lines_4_max[0].Id+'" target="_blank" class="campo_azul">'+shipment_lines_4_max[0].Shipment__r.Name+'</a></td>';
		  			message_data += '	</tr>';
				}
				if(shipment_lines_4_avg.size() > 0 && shipment_lines_4_avg[0].get('avg') != null)
				{
		  			message_data += '	<tr class="dataRow">';
		  			message_data += '		<th class="headerRow" style="text-align:center;">AVG</th>';
		  			message_data += '		<td class="dataCell" style="text-align:center;"><strong style="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:red;' : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? 'color:green;' : ''))+'">'+shipment_lines_4_avg[0].get('avg')+'</strong><img src="'+(sell_rate_filter < decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_red : (sell_rate_filter > decimal.valueof(string.valueof(shipment_lines_4_avg[0].get('avg'))) ? arrow_green : equal_icon))+'" style="height: 10px; margin: 0 0 0 4px;"></td>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '		<th class="headerRow" style="text-align:center;"></th>';
		  			message_data += '	</tr>';
				}
		  		message_data += '</table>';	
			}
		}
	}
}