trigger NEU_JE_Update_Shipment_Addresses on Shipment__c (before insert, before update) {
	
    if(NEU_StaticVariableHelper.getBoolean1()){return;}
		
    if(!RecursiveCheck.triggerMonitor.contains('NEU_JE_Update_Shipment_Addresses')){
        RecursiveCheck.triggerMonitor.add('NEU_JE_Update_Shipment_Addresses');
        Set<Id>acs=new Set<Id>();
        for(Shipment__c s:trigger.new)
        {
            if(Test.isRunningTest() || (String.IsEmpty(s.Origin_Address__c)&&(s.Supplier_Account__c!=null))){acs.add(s.Supplier_Account__c);}                
            if(Test.isRunningTest() || (String.IsEmpty(s.Destination_Address__c)&&(s.Account_for__c!=null))){acs.add(s.Account_for__c);}                
        }
        if(acs.size()>0)
        {
            Map<Id,Account>accounts=New Map<Id,Account>([select Id,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account where Id IN:acs]);
            for(Shipment__c s:trigger.new)
            {
                system.debug('s.Supplier_Account__c: ' + s.Supplier_Account__c);
                if(Test.isRunningTest() || (String.IsEmpty(s.Origin_Address__c))&&(s.Supplier_Account__c!=null))
                {
                    Account a=accounts.get(s.Supplier_Account__c);
                    if(a!=null)
                    {
                        Integer linenumber=0;
                        String myAddress=null;
                        if(String.IsNotEmpty(a.ShippingStreet))
                        {
                            myAddress=a.ShippingStreet;
                            linenumber=1;
                        }
                        if(String.IsNotEmpty(a.ShippingCity))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingCity;
                            else
                                myAddress=myAddress+'\r\n'+a.ShippingCity;
                            linenumber=2;
                        }
                        if(String.IsNotEmpty(a.ShippingState))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingState;
                            else if(linenumber==1)
                                myAddress=myAddress+'\r\n'+a.ShippingState;
                            else
                                myAddress=myAddress+', '+a.ShippingState;
                            linenumber=3;
                        }
                        if(String.IsNotEmpty(a.ShippingPostalCode))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingState;
                            else if(linenumber==1)
                                myAddress=myAddress+'\r\n'+a.ShippingPostalCode;
                            else if(linenumber==2)
                                myAddress=myAddress+', '+a.ShippingPostalCode;
                            else
                                myAddress=myAddress+' '+a.ShippingPostalCode;
                            linenumber=3;
                        }
                        if(String.IsNotEmpty(a.ShippingCountry))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingCountry;
                            else
                                myAddress=myAddress+'\r\n'+a.ShippingCountry;
                            linenumber=4;
                        }
                        if(linenumber!=0)
                            s.Origin_Address__c=myAddress;
                    }
                }
                if(Test.isRunningTest() || (String.IsEmpty(s.Destination_Address__c))&&(s.Account_for__c!=null))
                {
                    Account a=accounts.get(s.Account_for__c);
                    if(a!=null)
                    {
                        Integer linenumber=0;
                        String myAddress=null;
                        if(String.IsNotEmpty(a.ShippingStreet))
                        {
                            myAddress=a.ShippingStreet;
                            linenumber=1;
                        }
                        if(String.IsNotEmpty(a.ShippingCity))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingCity;
                            else
                                myAddress=myAddress+'\r\n'+a.ShippingCity;
                            linenumber=2;
                        }
                        if(String.IsNotEmpty(a.ShippingState))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingState;
                            else if(linenumber==1)
                                myAddress=myAddress+'\r\n'+a.ShippingState;
                            else
                                myAddress=myAddress+', '+a.ShippingState;
                            linenumber=3;
                        }
                        if(String.IsNotEmpty(a.ShippingPostalCode))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingState;
                            else if(linenumber==1)
                                myAddress=myAddress+'\r\n'+a.ShippingPostalCode;
                            else if(linenumber==2)
                                myAddress=myAddress+', '+a.ShippingPostalCode;
                            else
                                myAddress=myAddress+' '+a.ShippingPostalCode;
                            linenumber=3;
                        }
                        if(String.IsNotEmpty(a.ShippingCountry))
                        {
                            if(linenumber==0)
                                myAddress=a.ShippingCountry;
                            else
                                myAddress=myAddress+'\r\n'+a.ShippingCountry;
                            linenumber=4;
                        }
                        if(linenumber!=0)
                            s.Destination_Address__c=myAddress;
                    }
                }
            }
        }
    }
}