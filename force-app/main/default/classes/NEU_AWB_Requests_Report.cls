public with sharing class NEU_AWB_Requests_Report 
{
	public List<Log__c> mylog;
    public String addressTo;
    public String AWB {get;set;}
    public String myAWB {get;set;}
    public integer totalFSR {get;set;}
    public integer totalFSA {get;set;}
    public integer totalFSU {get;set;}
    public integer totalFWB {get;set;}
    public integer totalFHL {get;set;}
    public integer totalFNA {get;set;}
    public integer month {get;set;}
    public integer year {get;set;}
    
    public NEU_AWB_Requests_Report() 
    {    	   	
    }
    
    public void search_AWB () 
    {
		totalFSR=0;
		totalFSA=0;
		totalFSU=0;
		totalFWB=0;
		totalFNA=0;
		totalFHL=0;
		mylog = [select Id, Body__c from Log__c where CALENDAR_MONTH(CreatedDate)=:month and CALENDAR_YEAR(CreatedDate) =:year];
		
		for(Log__c lg:mylog)
		{
			String[] mydata=lg.Body__c.split('\n');
			if(lg.Body__c.contains('+CIMFSR:'))
			{
				String[] myLine=mydata[1].split('/');
				myAWB=myLine[0].left(12);
				if(myAWB == AWB)
					totalFSR++;
			}
			else
			{
				if(lg.Body__c.contains('+CIMFSA:'))
				{
					String[] myLine=mydata[1].split('/');
					myAWB=myLine[0].left(12);
					if(myAWB == AWB)
						totalFSA++;
				}
				else
				{
					if(lg.Body__c.contains('+CIMFSU:'))
						{
						String[] myLine=mydata[1].split('/');
						myAWB=myLine[0].left(12);
						if(myAWB == AWB)
							totalFSU++;
					}
					else
					{
						if(lg.Body__c.contains('+CIMFWB:'))
						{
							String[] myLine=mydata[1].split('/');
							myAWB=myLine[0].left(12);
							if(myAWB == AWB)
								totalFWB++;
						}
						else
						{
							if(lg.Body__c.contains('+CIMFMA:'))
							{
								String[] myLine=mydata[3].split('/');
								myAWB=myLine[0].left(12);
								if(myAWB == AWB)
									totalFNA++;
							}
							else
							{
								if(lg.Body__c.contains('+CIMFHL:'))
								{
									String[] myLine=mydata[1].split('/');
									myAWB=myLine[1].left(12);
									if(myAWB == AWB)
										totalFHL++;
								}
							}
						}
					}
				}
			}					
		}
    }
}