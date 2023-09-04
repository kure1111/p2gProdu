public with sharing class NEU_AWB_Report 
{
	public List<Log__c> mylog;
	public List<Air_Waybill__c> waybills;
	public List<Air_Waybill__c> results{get;set;}
	public String awb;
	public String myAWB;
	public String error;
	public integer month {get;set;}
	public integer year {get;set;}
	public integer total {get;set;}
	public integer totalsent {get;set;}
	public integer totalsuccess {get;set;}
	public integer totalerror {get;set;}
	public boolean errors{get; set;}
	public boolean findFWB;
	public boolean findFMA;
	public boolean findFNA;
	
	public NEU_AWB_Report() 
	{
	}
	
	public Air_Waybill__c filter
	{
		get
		{
			if(filter==null)
				filter=new	Air_Waybill__c();
			return filter;
		}
		set;
	}
	
	public void search_AWB () 
	{
		errors=false;
		if(filter.Carrier_Account__c == null)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insert Carrier'));
			errors=true;
		}
		if(month < 1 || month > 12)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Month Between 1 and 12'));
			month=null;
			errors=true;
		}
		if(year < 2017)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Year min 2017'));
			year=null;
			errors=true;
		}
		if(errors)
			return;
			
		waybills = [select Id, Name, Carrier_Account__c, Accounting_Information__c, Display_House_Number_on_PDF__c, CreatedBy.Name, 
					Handling_Information__c, Direct_Shipment__c, Hide_House_Totals__c, Airline_Code_Number__c, Serial_Number__c, 
					Shipper_Alternative_Address__c, Consignee_Alternative_Address__c, Other_Charges_House__c, CreatedDate 
					from Air_Waybill__c where CALENDAR_MONTH(CreatedDate)=:month and CALENDAR_YEAR(CreatedDate) =:year 
					and Carrier_Account__c =: filter.Carrier_Account__c order by CreatedDate desc];
		
		mylog = [select Id, Body__c, CreatedBy.Name, CreatedDate from Log__c where CALENDAR_MONTH(CreatedDate)=:month 
					and CALENDAR_YEAR(CreatedDate) =:year];
		
		totalsent=0;
		totalsuccess=0;
		totalerror=0;
		results = new List<Air_Waybill__c>();
		if(waybills.size() != 0)
		{
			for(Air_Waybill__c w:waybills)
				results.add(w);
				
			for(Air_Waybill__c wb:results)
			{
				findFWB=false;
				findFMA=false;
				findFNA=false;
				for(Log__c lg:mylog)
				{
					String[] mydata=lg.Body__c.split('\n');
					awb=wb.Airline_Code_Number__c+'-'+wb.Serial_Number__c;
					if(lg.Body__c.contains('+CIMFWB:'))
					{
						String[] myLine=mydata[1].split('/');
						myAWB=myLine[0].left(12);
						if(myAWB == awb)
						{
							wb.Direct_Shipment__c=true;//Sent
							wb.Other_Charges_House__c=wb.CreatedDate.format('dd/MM/YYYY HH:mm:ss');//Created Date
							wb.Handling_Information__c=wb.CreatedBy.Name;//Created By
							wb.Shipper_Alternative_Address__c=lg.CreatedDate.format('dd/MM/YYYY HH:mm:ss');//Sent Date
							wb.Consignee_Alternative_Address__c=lg.CreatedBy.Name;//Sent By
							findFWB=true;
							totalsent++;
						}
					}
					else if(lg.Body__c.contains('+CIMFMA:'))
					{
						String[] myLine=mydata[3].split('/');
						myAWB=myLine[0].left(12);
						if(myAWB == awb)
						{
							wb.Display_House_Number_on_PDF__c=true;//Success
							findFMA=true;
							totalsuccess++;
						}
					}
					else if(lg.Body__c.contains('+CIMFNA:') && lg.Body__c.contains('FWB'))
					{
						String[] myLine=mydata[3].split('/');
						String[] myLine1=mydata[1].split('/');
						
						myAWB=myLine[0].left(12);
						String[] mawbn=myAWB.split('-');
						if(Neu_Utils.safeDecimal(mawbn[0]) == 0 || Neu_Utils.safeDecimal(mawbn[1]) == 0)
			       		{
			       			myLine=mydata[4].split('/');
				        	myAWB=myLine[0].left(12);
			       		}
						error=myLine1[1];
						String typeerror = mydata[2].replace('/','');
						if(!typeerror.contains('FWB'))
							error +=', '+typeerror;
						if(myAWB == awb)
						{
							wb.Hide_House_Totals__c=true;//Error
							wb.Accounting_Information__c=error;//Type
							findFNA=true;
							totalerror++;
						}
					}
				}
				if(!findFWB)
				{
					wb.Direct_Shipment__c=false;
					wb.Other_Charges_House__c=wb.CreatedDate.format('dd/MM/YYYY HH:mm:ss');
					wb.Handling_Information__c=wb.CreatedBy.Name;
					wb.Shipper_Alternative_Address__c='';
					wb.Consignee_Alternative_Address__c='';
				}
				if(!findFMA)
					wb.Display_House_Number_on_PDF__c=false;
				if(!findFNA)
				{
					wb.Hide_House_Totals__c=false;
					wb.Accounting_Information__c='';
				}
			}
			total = results.size();
		}
		else
		{
			Air_Waybill__c new_waybill = new Air_Waybill__c();
			new_waybill.Name = 'No results';
			results.add(new_waybill);
			total = 0;
		}
	}
}