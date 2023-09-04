trigger NEU_JE_Update_Transport_Packaging_Data_Addresses on Transport_Packaging_Data__c (after insert, after update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    List<Transport_Packaging_Data__c>toUpdate=new List<Transport_Packaging_Data__c>();
    for(Transport_Packaging_Data__c s:[select Id,Ship_from_Door_Address__c,Ship_to_Door_Address__c,Ship_from_Door_Account__c,Ship_to_Door_Account__c,Ship_from_Door_Account__r.ShippingStreet,Ship_from_Door_Account__r.ShippingCity,Ship_from_Door_Account__r.ShippingState,Ship_from_Door_Account__r.ShippingPostalCode,Ship_from_Door_Account__r.ShippingCountry,Ship_to_Door_Account__r.ShippingStreet,Ship_to_Door_Account__r.ShippingCity,Ship_to_Door_Account__r.ShippingState,Ship_to_Door_Account__r.ShippingPostalCode,Ship_to_Door_Account__r.ShippingCountry from Transport_Packaging_Data__c WHERE Id IN:trigger.new])
    {
        Boolean modified=false;
        if((String.IsEmpty(s.Ship_from_Door_Address__c))&&(s.Ship_from_Door_Account__c!=null))
        {
            Integer linenumber=0;
            String myAddress=null;
            if(String.IsNotEmpty(s.Ship_from_Door_Account__r.ShippingStreet))
            {
                myAddress=s.Ship_from_Door_Account__r.ShippingStreet;
                linenumber=1;
            }
            if(String.IsNotEmpty(s.Ship_from_Door_Account__r.ShippingCity))
            {
                if(linenumber==0)
                    myAddress=s.Ship_from_Door_Account__r.ShippingCity;
                else
                    myAddress=myAddress+'\r\n'+s.Ship_from_Door_Account__r.ShippingCity;
                linenumber=2;
            }
            if(String.IsNotEmpty(s.Ship_from_Door_Account__r.ShippingState))
            {
                if(linenumber==0)
                    myAddress=s.Ship_from_Door_Account__r.ShippingState;
                else if(linenumber==1)
                    myAddress=myAddress+'\r\n'+s.Ship_from_Door_Account__r.ShippingState;
                else
                    myAddress=myAddress+', '+s.Ship_from_Door_Account__r.ShippingState;
                linenumber=3;
            }
            if(String.IsNotEmpty(s.Ship_from_Door_Account__r.ShippingPostalCode))
            {
                if(linenumber==0)
                    myAddress=s.Ship_from_Door_Account__r.ShippingState;
                else if(linenumber==1)
                    myAddress=myAddress+'\r\n'+s.Ship_from_Door_Account__r.ShippingPostalCode;
                else if(linenumber==2)
                    myAddress=myAddress+', '+s.Ship_from_Door_Account__r.ShippingPostalCode;
                else
                    myAddress=myAddress+' '+s.Ship_from_Door_Account__r.ShippingPostalCode;
                linenumber=3;
            }
            if(String.IsNotEmpty(s.Ship_from_Door_Account__r.ShippingCountry))
            {
                if(linenumber==0)
                    myAddress=s.Ship_from_Door_Account__r.ShippingCountry;
                else
                    myAddress=myAddress+'\r\n'+s.Ship_from_Door_Account__r.ShippingCountry;
                linenumber=4;
            }
            if(linenumber!=0)
            {
                s.Ship_from_Door_Address__c=myAddress;
                modified=true;
            }
        }
        if((String.IsEmpty(s.Ship_to_Door_Address__c))&&(s.Ship_to_Door_Account__c!=null))
        {
            Integer linenumber=0;
            String myAddress=null;
            if(String.IsNotEmpty(s.Ship_to_Door_Account__r.ShippingStreet))
            {
                myAddress=s.Ship_to_Door_Account__r.ShippingStreet;
                linenumber=1;
            }
            if(String.IsNotEmpty(s.Ship_to_Door_Account__r.ShippingCity))
            {
                if(linenumber==0)
                    myAddress=s.Ship_to_Door_Account__r.ShippingCity;
                else
                    myAddress=myAddress+'\r\n'+s.Ship_to_Door_Account__r.ShippingCity;
                linenumber=2;
            }
            if(String.IsNotEmpty(s.Ship_to_Door_Account__r.ShippingState))
            {
                if(linenumber==0)
                    myAddress=s.Ship_to_Door_Account__r.ShippingState;
                else if(linenumber==1)
                    myAddress=myAddress+'\r\n'+s.Ship_to_Door_Account__r.ShippingState;
                else
                    myAddress=myAddress+', '+s.Ship_to_Door_Account__r.ShippingState;
                linenumber=3;
            }
            if(String.IsNotEmpty(s.Ship_to_Door_Account__r.ShippingPostalCode))
            {
                if(linenumber==0)
                    myAddress=s.Ship_to_Door_Account__r.ShippingState;
                else if(linenumber==1)
                    myAddress=myAddress+'\r\n'+s.Ship_to_Door_Account__r.ShippingPostalCode;
                else if(linenumber==2)
                    myAddress=myAddress+', '+s.Ship_to_Door_Account__r.ShippingPostalCode;
                else
                    myAddress=myAddress+' '+s.Ship_to_Door_Account__r.ShippingPostalCode;
                linenumber=3;
            }
            if(String.IsNotEmpty(s.Ship_to_Door_Account__r.ShippingCountry))
            {
                if(linenumber==0)
                    myAddress=s.Ship_to_Door_Account__r.ShippingCountry;
                else
                    myAddress=myAddress+'\r\n'+s.Ship_to_Door_Account__r.ShippingCountry;
                linenumber=4;
            }
            if(linenumber!=0)
            {
                s.Ship_to_Door_Address__c=myAddress;
                modified=true;
            }
        }
        if(modified)
            toUpdate.add(s);
    }
    if(toUpdate.size()>0)
        update toUpdate;
}