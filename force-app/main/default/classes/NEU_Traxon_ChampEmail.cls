global class NEU_Traxon_ChampEmail implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
	  {
	  		Log__c mylog=new Log__c();
	  		if(String.IsNotEmpty(email.subject))
		  		mylog.Subject__c=email.subject.left(255);
	  		if(String.IsNotEmpty(email.plainTextBody))
		  		mylog.Body__c=email.plainTextBody.left(32678);
	  		if(String.IsNotEmpty(email.fromAddress))
		  		mylog.From__c=email.fromAddress.left(255);
	  		for(String address:email.toAddresses)
	  		{
	  			if(String.isempty(mylog.To__c))
	  				mylog.To__c=NEU_Utils.safeString(address);
	  			else
	  				mylog.To__c+=','+NEU_Utils.safeString(address);
	  		}
	  		insert mylog;
            if(String.IsNotEmpty(email.fromAddress))
            {
				List<Organization>org=[SELECT Id, IsSandbox FROM Organization LIMIT 1];
				Boolean isSandbox=false;
				if(org.size()>0)
					if(org[0].IsSandbox)
						isSandbox=true;
				if(email.fromAddress.EndsWith('@neurored.com'))
            	{
				    List<Messaging.Email> allMails = new List<Messaging.Email>();
		            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'champ_email'];
		            if(owea.size()>0)
		                mail.setOrgWideEmailAddressId(owea[0].Id);
		            if(isSandbox)
		            	mail.setToAddresses(new String[]{'cargohub-test@edi.champ.aero'});
		            else
		            	mail.setToAddresses(new String[]{'cargohub-edi@edi.champ.aero'});
		            mail.setSubject(email.subject);
		            mail.setPlainTextBody(email.plainTextBody);
			        allMails.add(mail);
				    try{
				    	Messaging.sendEmail(allMails);
				    }catch(Exception e){}
            	}
            	else if((email.fromAddress.EndsWith('cargohub-edi@edi.champ.aero')&&!isSandbox)
            		||(email.fromAddress.EndsWith('cargohub-test@edi.champ.aero')&&isSandbox)
            		||(email.fromAddress=='josespinosa@gmail.com')
            		||(email.fromAddress=='test@test.neurored.com'))
            	{
            		if(String.isNotEmpty(email.plainTextBody))
            		{
            			updateStatusAWB(email.plainTextBody);
            			processFSA(email.plainTextBody,MyLog.Id);
            		}
            	}
            }
			Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		    result.success = true;
			return result;
      }
      global class eventData implements Comparable
      {
      	String name;
      	String description;
      	public DateTime mydatetime;
      	String departureCode;
      	String arrivalCode;
      	String flightNumber;
      	Integer pieces;
      	Decimal weight;
      	String additional;
      	global Integer compareTo(Object compareTo)
      	{
      		if(this.mydatetime==((eventData)compareTo).mydatetime)
      			return 0;
      		if(this.mydatetime==null)
      			return -1;
      		if(((eventData)compareTo).mydatetime==null)
      			return 1;
      		if(this.mydatetime>((eventData)compareTo).mydatetime)
      			return 1;
      		return -1;
      	}
      }
      public static String[] months=new String[]{'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'};
      public Integer getMonth(String myMonth)
      {
      	for(Integer res=0;res<months.size();res++)
      		if(months[res]==myMonth)
      			return res+1;
      	return 0;
      }
      public DateTime getDate(String DayMonth)
      {
      	if(DayMonth.length()<5)
      		return null;
		try{
	      	Date myToday=System.today();
			if (Test.isRunningTest())
				myToday=Date.newInstance(2017,1,1);
			Integer myYear=myToday.year();
			Integer todayMonth=myToday.month();
				Integer myDay=Integer.valueOf(DayMonth.left(2));
				Integer myMonth=getMonth(DayMonth.substring(2,5));
				if(myMonth==0)
					return null;
				if(myMonth-todayMonth>6)
					myYear-=1;
				else if(myMonth-todayMonth<-6)
					myYear+=1;
				return DateTime.newInstance(myYear,myMonth,myDay);
		}
		catch(Exception e){}
		return null;
      }
      public DateTime getDateTime(String DayMonthTime)
      {
      	if(DayMonthTime.length()<9)
      		return null;
      	return getDateTime(DayMonthTime.left(5),DayMonthTime.substring(5));
      }
      public DateTime getDateTime(String DayMonth,String myTime)
      {
      	DateTime res=getDate(DayMonth);
      	if(res==null)
      		return null;
      	if(myTime==null)
      		return res;
      	if((myTime.left(1)<'0')||(myTime.left(1)>'9'))
      		myTime=myTime.substring(1);
      	if(myTime.length()<4)
      		return res;
		Integer myHour=Integer.valueOf(myTime.left(2));
		Integer myMin=Integer.valueOf(myTime.substring(2,4));
		res=DateTime.newInstance(res.Year(),res.Month(),res.Day(),myHour,myMin,0);
		if(myTime.Length()>5)
		{
			String dayModif=myTime.substring(4,6);
			if(dayModif=='-P')
				res=res.AddDays(-1);
			else if(dayModif=='-N')
				res=res.AddDays(1);
			else if(dayModif=='-S')
				res=res.AddDays(2);
			else if(dayModif=='-T')
				res=res.AddDays(3);
			else if(dayModif=='-A')
				res=res.AddDays(4);
			else if(dayModif=='-B')
				res=res.AddDays(5);
			else if(dayModif=='-C')
				res=res.AddDays(6);
			else if(dayModif=='-D')
				res=res.AddDays(7);
			else if(dayModif=='-E')
				res=res.AddDays(8);
			else if(dayModif=='-F')
				res=res.AddDays(9);
			else if(dayModif=='-G')
				res=res.AddDays(10);
			else if(dayModif=='-H')
				res=res.AddDays(11);
			else if(dayModif=='-I')
				res=res.AddDays(12);
			else if(dayModif=='-J')
				res=res.AddDays(13);
			else if(dayModif=='-K')
				res=res.AddDays(14);
			else if(dayModif=='-L')
				res=res.AddDays(15);
		}
		return res;
      }
      public Integer getInteger(String toExtract)
      {
      	if(String.isEmpty(toExtract))
      		return null;
      	Integer lastO=toExtract.indexOfAnyBut('0123456789');
      	if(lastO==0)
      		return null;
      	if(lastO>0)
      		toExtract=toExtract.left(lastO);
      	return Integer.valueOf(toExtract);
      }
      public Decimal getDecimal(String toExtract)
      {
      	if(String.isEmpty(toExtract))
      		return null;
      	Integer lastO=toExtract.indexOfAnyBut('0123456789.');
      	if(lastO==0)
      		return null;
      	if(lastO>0)
      		toExtract=toExtract.left(lastO);
      	return Decimal.valueOf(toExtract);
      }
      public void readPW(String firstLine,eventData myEventData)
      {
			if(String.IsNotEmpty(firstLine))
			{
				firstLine=firstline.substring(1);
				myEventData.pieces=getInteger(firstLine);
				Integer nextPos=firstLine.indexOfAnyBut('0123456789');
				if(nextPos>=0)
				{
					firstLine=firstLine.substring(nextPos);
					if(firstLine.startsWith('K'))
						myEventData.weight=getDecimal(firstLine.substring(1));
					else if(firstLine.startsWith('L'))
						myEventData.weight=getDecimal(firstLine.substring(1))*0.453592;
				}
			}
      }
      public Boolean processFSA(String plainTextBody, Id myLogId)
      {
		String[] mydata=plainTextBody.split('\n');
		if(mydata.size()>2)
		{
			try{
				Integer firstChar=mydata[0].indexOf('+CIMFSA:')+8;
				if(firstChar==7)
					firstChar=mydata[0].indexOf('+CIMFSU:')+8;
				if(firstChar==7)
					return false;
				Integer lastChar=mydata[0].indexOf('+',firstChar);
				if((firstChar<8)||(lastChar<8))
					return false;
				Integer version=Integer.valueOf(mydata[0].substring(firstChar,lastChar));
				if(version<14)
					return false;
				String[] myLine=mydata[1].split('/');
				String myAWB=myLine[0].left(12);
				if(myAWB.length()<12)
					return false;
				Integer pieces=0;
				Decimal weight=0;
				if(myline.size()>1)
				{
					String firstLine=myLine[1];
					if(firstLine.length()>0)
					{
						firstLine=firstline.substring(1);
						pieces=getInteger(firstLine);
						Integer nextPos=firstLine.indexOfAnyBut('0123456789');
						if(nextPos>=0)
						{
							firstLine=firstLine.substring(nextPos);
							if(firstLine.startsWith('K'))
								weight=getDecimal(firstLine.substring(1));
							else if(firstLine.startsWith('L'))
								weight=getDecimal(firstLine.substring(1))*0.453592;
						}
					}
				}
				List<String>names=new List<String>();
				List<eventData>mylist=new List<eventData>();
				for(Integer line=2;line<mydata.size();line++)
				{
					myLine=mydata[line].split('/');
					if(myline[0]=='RCS')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='RCS';
								myEventData.Description='The consignment has been physically received from the shipper or the shipper’s agent and is considered by the carrier as ready for carriage on this date at this location';
								myEventData.departureCode=myline[2].left(3);
								if(myline.size()>3)
								{
									readPW(myLine[3],myEventData);
									if(myline.size()>4)
										myEventData.additional=myline[4].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='RCT')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='RCT';
								myEventData.Description='The consignment has been physically received from this carrier on this date at this location';
								myEventData.arrivalCode=myline[3].left(3);
								if(myline.size()>4)
								{
									readPW(myLine[4],myEventData);
									if(myline.size()>6)
										myEventData.additional=myline[6].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='RCF')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='RCF';
								myEventData.Description='The consignment has been physically received from a given flight or surface transport of the given airline';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.arrivalCode=myline[3].left(3);
								if(myline.size()>4)
									readPW(myLine[4],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='BKD')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							if(myline.size()>5)
								myEventData.mydatetime=getDateTime(myline[2],myline[5]);
							else
								myEventData.mydatetime=getDate(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='BKD';
								myEventData.Description='The consignment has been booked for transport between these locations on this scheduled date and this flight';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.departureCode=myline[3].left(3);
								myEventData.arrivalCode=myline[3].right(3);
								if(myline.size()>4)
									readPW(myLine[4],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='MAN')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							if(myline.size()>5)
								myEventData.mydatetime=getDateTime(myline[2],myline[5]);
							else
								myEventData.mydatetime=getDate(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='MAN';
								myEventData.Description='The consignment has been manifested for this flight on this scheduled date for transport between these location';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.departureCode=myline[3].left(3);
								myEventData.arrivalCode=myline[3].right(3);
								if(myline.size()>4)
									readPW(myLine[4],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='DEP')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							if(myline.size()>5)
								myEventData.mydatetime=getDateTime(myline[2],myline[5]);
							else
								myEventData.mydatetime=getDate(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='DEP';
								myEventData.Description='The consignment has physically departed this location on this scheduled date and flight for transport to the arrival location';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.departureCode=myline[3].left(3);
								myEventData.arrivalCode=myline[3].right(3);
								if(myline.size()>4)
									readPW(myLine[4],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='PRE')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							if(myline.size()>5)
								myEventData.mydatetime=getDateTime(myline[2],myline[5]);
							else
								myEventData.mydatetime=getDate(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='PRE';
								myEventData.Description='The consignment has been prepared for loading on this flight for transport between these locations on this scheduled date';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.departureCode=myline[3].left(3);
								myEventData.arrivalCode=myline[3].right(3);
								if(myline.size()>4)
									readPW(myLine[4],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='TFD')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='TFD';
								myEventData.Description='The consignment has been physically transferred to this carrier on this date at this location';
								myEventData.departureCode=myline[3].left(3);
								if(myline.size()>4)
								{
									readPW(myLine[4],myEventData);
									if(myline.size()>7)
										myEventData.additional=myline[7].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='NFD')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='NFD';
								myEventData.Description='The consignee or the consignee’s agent has been notified, on this date at this location, of the arrival of the consignment';
								myEventData.arrivalCode=myline[2].left(3);
								if(myline.size()>3)
								{
									readPW(myLine[3],myEventData);
									if(myline.size()>4)
										myEventData.additional=myline[4].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='AWD')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='AWD';
								myEventData.Description='The arrival documentation has been physically delivered to the consignee or the consignee’s agent on this date at this location';
								myEventData.arrivalCode=myline[2].left(3);
								if(myline.size()>3)
								{
									readPW(myLine[3],myEventData);
									if(myline.size()>4)
										myEventData.additional=myline[4].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='CCD')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='CCD';
								myEventData.Description='The consignment has been cleared by the Customs authorities on this date at this location';
								myEventData.arrivalCode=myline[2].left(3);
								if(myline.size()>3)
									readPW(myLine[3],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='DLV')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='DLV';
								myEventData.Description='The consignment has been physically delivered to the consignee or the Consignee’s agent on this date at this location';
								myEventData.arrivalCode=myline[2].left(3);
								if(myline.size()>3)
								{
									readPW(myLine[3],myEventData);
									if(myline.size()>4)
										myEventData.additional=myline[4].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='DIS')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='DIS';
								myEventData.Description='An apparent error has occurred, on this date at this location, with the handling of the consignment or its documentation, which is further clarified by the accompanying discrepancy code';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.departureCode=myline[3].left(3);
								if(myline.size()>5)
									readPW(myLine[5],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='CRC')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='CRC';
								myEventData.Description='The consignment has been reported to the Customs authorities on this date at this location';
								myEventData.arrivalCode=myline[3].left(2);
								if(myline.size()>3)
								{
									readPW(myLine[3],myEventData);
									if(myline.size()>4)
										myEventData.flightNumber=myline[4].left(7);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='DDL')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='DDL';
								myEventData.Description='The consignment has been physically delivered to the consignee’s door on this date at this location';
								myEventData.arrivalCode=myline[2].left(3);
								if(myline.size()>3)
								{
									readPW(myLine[3],myEventData);
									if(myline.size()>4)
										myEventData.additional=myline[4].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='TGC')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='TGC';
								myEventData.Description='The consignment has been transferred to Customs/Government control';
								myEventData.arrivalCode=myline[2].left(3);
								if(myline.size()>3)
									readPW(myLine[3],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='ARR')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='ARR';
								myEventData.Description='The consignment has arrived on a scheduled flight at this location';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.arrivalCode=myline[3].left(3);
								if(myline.size()>4)
									readPW(myLine[4],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='AWR')
					{
						if(myline.size()>3)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[2]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='AWR';
								myEventData.Description='The arrival documentation has been physically received from a scheduled flight at this location';
								myEventData.flightNumber=myline[1].left(7);
								myEventData.arrivalCode=myline[3].left(3);
								if(myline.size()>4)
									readPW(myLine[4],myEventData);
								myList.add(myEventData);
							}
						}
						continue;
					}
					else if(myline[0]=='FOH')
					{
						if(myline.size()>2)
						{
							eventData myEventData=new eventData();
							myEventData.mydatetime=getDateTime(myline[1]);
							if(myEventData.mydatetime!=null)
							{
								myEventData.Name='FOH';
								myEventData.Description='The consignment is on hand on this date at this location pending “ready for carriage” determination';
								myEventData.departureCode=myline[2].left(3);
								if(myline.size()>3)
								{
									readPW(myLine[3],myEventData);
									if(myline.size()>4)
										myEventData.additional=myline[4].left(40);
								}
								myList.add(myEventData);
							}
						}
						continue;
					}
				}				
				if(myList.size()>0)
		        {
		        	myList.sort();
			        List<List<Event__c>>toUpdateEvents=new List<List<Event__c>>();
			        List<Event__c>toInsert=new List<Event__c>();
			        List<Shipment__c>ships=[select Id from Shipment__c where MAWB_Number__c=:myAWB];
			        List<Shipment_Program__c>shipprogs=[select Id from Shipment_Program__c where MAWB_Number__c=:myAWB];
			        List<Event__c> list_event=new list<Event__c>();  
			        Id lastId=null;
			        for(Event__c e:[select Id,Name,Arrival_IATA_Code__c,Departure_IATA_Code__c,Flight_Number__c,Previous_Event_Code__c,Shipment__c,Shipments_Program__c from Event__c where Shipment__c IN:ships or Shipments_Program__c IN:shipprogs order by Date_Time__c asc])			      	
			            list_event.add(e);

					if(ships.size()>0)
					{
			        	for(Shipment__c s:ships)
			        	{
			        		List<Event__c>events=new List<Event__c>();
					        toUpdateEvents.add(events);				        
					        Event__c e;
					        boolean find_event=false;				        
					        for(eventData d:myList)
					        {	
					        	for(Event__c ne:list_event)
						        {
						        	if(ne.Name==d.Name && ne.Flight_Number__c==d.flightNumber && s.Id==ne.Shipment__c &&
						        		ne.Departure_IATA_Code__c==d.departureCode && ne.Arrival_IATA_Code__c==d.arrivalCode)
						        	{
						        		e=ne;
						        		find_event=true;
						        		break;
						        	}					        	
						        	lastId=ne.Id;
						        }		
					        	if(!find_event)
					        		e=new Event__c();
					            e.Mail_Log__c=myLogId;
							    e.Number_of_Pieces__c=d.pieces!=null?d.pieces:pieces;
							    e.Weight_kg__c=d.weight!=null?d.weight:weight;
							    e.Additional_Information__c=d.additional;
							    e.Shipment__c=s.Id;
							    e.Name=d.Name;
							    e.Event__c=d.Description;
							    e.Notified_Date_Time__c=d.mydatetime;
							    e.Flight_Number__c=d.flightNumber;
							    e.Departure_IATA_Code__c=d.departureCode;
							    e.Arrival_IATA_Code__c=d.arrivalCode;
							    toInsert.add(e);
							    events.add(e);
					        }
			        	}
					} 
					else
					{
						String addressTo='jcandido@neurored.com';
						List<Messaging.Email> allMails = new List<Messaging.Email>();
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				        mail.setToAddresses(new String[]{addressTo});
				        mail.setSubject('Error Email');
				        mail.setPlainTextBody('Email: '+myLogId);
				        allMails.add(mail);
				        Messaging.SendEmailResult[] myresult=Messaging.sendEmail(allMails);
					}
			        for(Shipment_Program__c p:shipprogs)
			        {
				        List<Event__c>events=new List<Event__c>();
				        toUpdateEvents.add(events);
				        Event__c e;
				        boolean find_event=false;
				        for(eventData d:myList)
				        {
				        	for(Event__c ne:list_event)
					        {
					        	if(ne.Name==d.Name && ne.Flight_Number__c==d.flightNumber && p.Id==ne.Shipments_Program__c && 
					        	ne.Arrival_IATA_Code__c==d.arrivalCode && ne.Departure_IATA_Code__c==d.departureCode)
					        	{
					        		e=ne;
					        		find_event=true;
					        		break;
					        	}
					        	lastId=ne.Id;
					        }
		        			if(!find_event)
		        				e=new Event__c();		        			
				            e.Mail_Log__c=myLogId;
				            e.Number_of_Pieces__c=d.pieces!=null?d.pieces:pieces;
				            e.Weight_kg__c=d.weight!=null?d.weight:weight;
				            e.Additional_Information__c=d.additional;
				            e.Shipments_Program__c=p.Id;
				            e.Name=d.Name;
				            e.Event__c=d.Description;
				            e.Notified_Date_Time__c=d.mydatetime;
				            e.Flight_Number__c=d.flightNumber;
				            e.Departure_IATA_Code__c=d.departureCode;
				            e.Arrival_IATA_Code__c=d.arrivalCode;
				            toInsert.add(e);
				            events.add(e);				        	
		            	}
		        	}
			        if(toInsert.size()>0)
				    {
				        upsert toInsert;
				        List<Event__c>toUpdate=new List<Event__c>();
				        for(List<Event__c> l:toUpdateEvents)
				        {
				            if(l.size()>0)
				            {					            
					            for(Event__c e:l)
					            {
					            	if(lastId!=null)
					                {
						                e.Previous_Event_Code__c=lastId;
						                toUpdate.add(e);
					                }
				                  	lastId=e.Id;
				                }
			            	}
			        	}
			            if(toUpdate.size()>0)
			              update toUpdate;
			        }
		        }
			}
			catch(Exception e){return false;}
		}
		return true;
    }
    public void updateStatusAWB(String plainTextBody)
    {
    	String[] mydata1=plainTextBody.split('\n');
	    if(mydata1.size()>2)
	    {
	    	try{
		        // Waybill Staus
		        String wbstatus='ProcessedACK';  
		        if(plainTextBody.contains('+CIMFNA:') && plainTextBody.contains('FWB'))
		        {
	          		wbstatus='ProcessedFNA';
	        	}	        
	        	String[] myLine1=mydata1[3].split('/');
	        	String myAWB1=myLine1[0].left(12);
	       		String[] mawbn=myAWB1.split('-');
	       		if(Neu_Utils.safeDecimal(mawbn[0]) == 0 || Neu_Utils.safeDecimal(mawbn[1]) == 0)
	       		{
	       			myLine1=mydata1[4].split('/');
		        	myAWB1=myLine1[0].left(12);
		       		mawbn=myAWB1.split('-');
	       		}
	        	List<Air_Waybill__c> awb = [SELECT Id, Waybill_Status__c FROM Air_Waybill__c WHERE Airline_Code_Number__c = :mawbn[0] AND Serial_Number__c = :mawbn[1]];
	        	if(awb.size()>0)
	        	{
	          		awb[0].Waybill_Status__c = wbstatus;
	        	}
	        	update awb;
	      	}  
	      	catch(Exception e){}
	    }        
    }      
}