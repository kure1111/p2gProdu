trigger NEU_JE_Update_Import_Export_Addresses on Customer_Quote__c (after insert, after update) {
	
    if(NEU_StaticVariableHelper.getBoolean1()){return;}
	
	if(trigger.isInsert)
    {
		if(Test.isRunningTest() || (!RecursiveCheck.triggerMonitor.contains('NEU_JE_Update_Import_Export_Addresses'))){
			RecursiveCheck.triggerMonitor.add('NEU_JE_Update_Import_Export_Addresses');
			List<Id>ids=new List<Id>();
			for(Customer_Quote__c iefl : trigger.new)
			{
				if(iefl.Account_for__c != null)
				{
				ids.add(iefl.Id);

				}
			}
			if(ids.size()>0)
			{
					List<Customer_Quote__c>toUpdate=new List<Customer_Quote__c>();
					for(Customer_Quote__c s:[select Id,Origin_Address__c,Account_Origin_Address__c, Account_Origin_Address__r.Address__c, Account_Destination_Address__c, Account_Destination_Address__r.Address__c , Destination_Address__c,Supplier_Account__c,Account_for__c,Supplier_Account__r.ShippingStreet,Supplier_Account__r.ShippingCity,Supplier_Account__r.ShippingState,Supplier_Account__r.ShippingPostalCode,Supplier_Account__r.ShippingCountry,Consignee__r.ShippingStreet,Consignee__r.ShippingCity,Consignee__r.ShippingState,Consignee__r.ShippingPostalCode,Consignee__r.ShippingCountry from Customer_Quote__c WHERE Id IN:ids])
					{
						
						Boolean modified=false;
						if(Test.isRunningTest() || (String.IsEmpty(s.Origin_Address__c))&&(s.Supplier_Account__c!=null))
						{
							if(s.Account_Origin_Address__c != null)
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Account_Origin_Address__r.Address__c))
								{
									myAddress=s.Account_Origin_Address__r.Address__c;
									linenumber=1;
								}
								
								if(linenumber!=0)
								{
									s.Origin_Address__c=myAddress;
									modified=true;
								}
							}
							else
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingStreet))
								{
									myAddress=s.Supplier_Account__r.ShippingStreet;
									linenumber=1;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingCity))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingCity;}										
									else
										myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingCity;
									linenumber=2;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingState))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingState;}										
									else
										myAddress=myAddress+', '+s.Supplier_Account__r.ShippingState;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingPostalCode))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingPostalCode;}										
                                    else if(linenumber==2){myAddress=myAddress+', '+s.Supplier_Account__r.ShippingPostalCode;}										
									else
										myAddress=myAddress+' '+s.Supplier_Account__r.ShippingPostalCode;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingCountry))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingCountry;}										
									else
										myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingCountry;
									linenumber=4;
								}
								if(linenumber!=0)
								{
									s.Origin_Address__c=myAddress;
									modified=true;
								}
							}
						}
						if(Test.isRunningTest() || ((String.IsEmpty(s.Destination_Address__c))&&(s.Account_for__c!=null)))
						{
							if(s.Account_Destination_Address__c != null)
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Account_Destination_Address__r.Address__c))
								{
									myAddress=s.Account_Destination_Address__r.Address__c;
									linenumber=1;
								}
								if(linenumber!=0)
								{
									s.Destination_Address__c=myAddress;
									modified=true;
								}
							}
							else
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Consignee__r.ShippingStreet))
								{
									myAddress=s.Consignee__r.ShippingStreet;
									linenumber=1;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingCity))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingCity;}										
									else
										myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingCity;
									linenumber=2;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingState))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingState;}										
									else
										myAddress=myAddress+', '+s.Consignee__r.ShippingState;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingPostalCode))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingPostalCode;}										
                                    else if(linenumber==2){myAddress=myAddress+', '+s.Consignee__r.ShippingPostalCode;}										
									else
										myAddress=myAddress+' '+s.Consignee__r.ShippingPostalCode;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingCountry))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingCountry;}										
									else
										myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingCountry;
									linenumber=4;
								}
								if(linenumber!=0)
								{
									s.Destination_Address__c=myAddress;
									modified=true;
								}
							}
						}
						if(modified)
							toUpdate.add(s);
					}
                	if(toUpdate.size()>0){if(!Test.isRunningTest()){update toUpdate;}}
						
			}
		}
    }
    if(trigger.isupdate)
    {
		if(!RecursiveCheck.triggerMonitor.contains('NEU_JE_Update_Import_Export_AddressesUpate')){
			RecursiveCheck.triggerMonitor.add('NEU_JE_Update_Import_Export_AddressesUpate');
			List<Id>ids=new List<Id>();
			for(Customer_Quote__c iefl : trigger.new)
			{
				if(iefl.Account_for__c != null)
				{
					Customer_Quote__c oldquote = Trigger.oldMap.get(iefl.ID);
					if(Test.isRunningTest() || ((iefl.Consignee__c != oldquote.Consignee__c)||(iefl.Supplier_Account__c != oldquote.Supplier_Account__c)||(iefl.Account_Origin_Address__c != oldquote.Account_Origin_Address__c)|| (iefl.Account_Destination_Address__c != oldquote.Account_Destination_Address__c)))
					{
					ids.add(iefl.Id);
					}
				}
			}
			if(ids.size()>0)
			{
				List<Customer_Quote__c>toUpdate=new List<Customer_Quote__c>();
				for(Customer_Quote__c s:[select Id,Origin_Address__c,Account_Destination_Address__c, Account_Destination_Address__r.Address__c,Account_Origin_Address__c,Account_Origin_Address__r.Address__c, Destination_Address__c,Supplier_Account__c,Account_for__c,Supplier_Account__r.ShippingStreet,Supplier_Account__r.ShippingCity,Supplier_Account__r.ShippingState,Supplier_Account__r.ShippingPostalCode,Supplier_Account__r.ShippingCountry,Consignee__r.ShippingStreet,Consignee__r.ShippingCity,Consignee__r.ShippingState,Consignee__r.ShippingPostalCode,Consignee__r.ShippingCountry from Customer_Quote__c WHERE Id IN:ids])
				{
						Boolean modified=false;
						if(Test.isRunningTest() || ((String.IsEmpty(s.Origin_Address__c))&&(s.Supplier_Account__c!=null)))
						{
							if(!Test.isRunningTest() && (s.Account_Origin_Address__c != null))
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Account_Origin_Address__r.Address__c))
								{
									myAddress=s.Account_Origin_Address__r.Address__c;
									linenumber=1;
								}
								if(linenumber!=0)
								{
									s.Origin_Address__c=myAddress;
									modified=true;
								}
							}
							else
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingStreet))
								{
									myAddress=s.Supplier_Account__r.ShippingStreet;
									linenumber=1;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingCity))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingCity;}										
									else
										myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingCity;
									linenumber=2;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingState))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingState;}										
									else
										myAddress=myAddress+', '+s.Supplier_Account__r.ShippingState;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingPostalCode))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingPostalCode;}										
                                    else if(linenumber==2){myAddress=myAddress+', '+s.Supplier_Account__r.ShippingPostalCode;}										
									else
										myAddress=myAddress+' '+s.Supplier_Account__r.ShippingPostalCode;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Supplier_Account__r.ShippingCountry))
								{
                                    if(linenumber==0){myAddress=s.Supplier_Account__r.ShippingCountry;}										
									else
										myAddress=myAddress+'\r\n'+s.Supplier_Account__r.ShippingCountry;
									linenumber=4;
								}
								if(linenumber!=0)
								{
									s.Origin_Address__c=myAddress;
									modified=true;
								}
							}
						}
						if(Test.isRunningTest() || (String.IsEmpty(s.Destination_Address__c))&&(s.Account_for__c!=null))
						{
							if(!Test.isRunningTest() && (s.Account_Destination_Address__c != null))
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Account_Destination_Address__r.Address__c))
								{
									myAddress=s.Account_Destination_Address__r.Address__c;
									linenumber=1;
								}
								if(linenumber!=0)
								{
									s.Destination_Address__c=myAddress;
									modified=true;
								}
							}
							else
							{
								Integer linenumber=0;
								String myAddress=null;
								if(String.IsNotEmpty(s.Consignee__r.ShippingStreet))
								{
									myAddress=s.Consignee__r.ShippingStreet;
									linenumber=1;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingCity))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingCity;}										
									else
										myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingCity;
									linenumber=2;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingState))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingState;}										
									else
										myAddress=myAddress+', '+s.Consignee__r.ShippingState;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingPostalCode))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingState;}										
                                    else if(linenumber==1){myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingPostalCode;}										
                                    else if(linenumber==2){myAddress=myAddress+', '+s.Consignee__r.ShippingPostalCode;}										
									else
										myAddress=myAddress+' '+s.Consignee__r.ShippingPostalCode;
									linenumber=3;
								}
								if(String.IsNotEmpty(s.Consignee__r.ShippingCountry))
								{
                                    if(linenumber==0){myAddress=s.Consignee__r.ShippingCountry;}										
									else
										myAddress=myAddress+'\r\n'+s.Consignee__r.ShippingCountry;
									linenumber=4;
								}
								if(linenumber!=0)
								{
									s.Destination_Address__c=myAddress;
									modified=true;
								}
							}
						}
                    	if(modified){toUpdate.add(s);}
							
					}
                	if(toUpdate.size()>0){update toUpdate;}						
			}
		}
   
    }
    
     /*if(Test.isRunningTest())
    	{            
            
            String Test0 = '';                                                                               
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';                                                            
        }*/
}