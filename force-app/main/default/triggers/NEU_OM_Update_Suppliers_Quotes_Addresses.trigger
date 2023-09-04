trigger NEU_OM_Update_Suppliers_Quotes_Addresses on Supplier_Quote__c (after insert, after update) {

  if(NEU_StaticVariableHelper.getBoolean1())
    return;
  
if(trigger.isInsert)
    {
        List<Id>ids=new List<Id>();
        for(Supplier_Quote__c iefl : trigger.new)
        {
            if(iefl.Customer__c!= null)
            {
               ids.add(iefl.Id);

            }
         }
           if(ids.size()>0)
         {   
  List<Supplier_Quote__c>toUpdate=new List<Supplier_Quote__c>();
  for(Supplier_Quote__c s:[select Id, DeliveryAddress__c, Receipt_Address__c, Delivery_Account__c, Customer__c, Delivery_Account__r.ShippingStreet, Delivery_Account__r.ShippingCity, Delivery_Account__r.ShippingState, Delivery_Account__r.ShippingPostalCode, Delivery_Account__r.ShippingCountry, Customer__r.ShippingStreet, Customer__r.ShippingCity, Customer__r.ShippingState, Customer__r.ShippingPostalCode, Customer__r.ShippingCountry from Supplier_Quote__c WHERE Id IN:ids])
  {
    Boolean modified=false;
    if((String.IsEmpty(s.DeliveryAddress__c))&&(s.Delivery_Account__c!=null))
    {
      Integer linenumber=0;
      String myAddress=null;
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingStreet))
      {
        myAddress=s.Delivery_Account__r.ShippingStreet;
        linenumber=1;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingCity))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingCity;
        else
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingCity;
        linenumber=2;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingState))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingState;
        else
          myAddress=myAddress+', '+s.Delivery_Account__r.ShippingState;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingPostalCode))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingPostalCode;
        else if(linenumber==2)
          myAddress=myAddress+', '+s.Delivery_Account__r.ShippingPostalCode;
        else
          myAddress=myAddress+' '+s.Delivery_Account__r.ShippingPostalCode;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingCountry))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingCountry;
        else
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingCountry;
        linenumber=4;
      }
      if(linenumber!=0)
      {
        s.DeliveryAddress__c=myAddress;
        modified=true;
      }
    }
    if((String.IsEmpty(s.Receipt_Address__c))&&(s.Customer__c!=null))
    {
      Integer linenumber=0;
      String myAddress=null;
      if(String.IsNotEmpty(s.Customer__r.ShippingStreet))
      {
        myAddress=s.Customer__r.ShippingStreet;
        linenumber=1;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingCity))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingCity;
        else
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingCity;
        linenumber=2;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingState))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingState;
        else
          myAddress=myAddress+', '+s.Customer__r.ShippingState;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingPostalCode))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingPostalCode;
        else if(linenumber==2)
          myAddress=myAddress+', '+s.Customer__r.ShippingPostalCode;
        else
          myAddress=myAddress+' '+s.Customer__r.ShippingPostalCode;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingCountry))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingCountry;
        else
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingCountry;
        linenumber=4;
      }
      if(linenumber!=0)
      {
        s.Receipt_Address__c=myAddress;
        modified=true;
      }
    }
    if(modified)
      toUpdate.add(s);
  }
  if(toUpdate.size()>0)
    update toUpdate;
    }
    
    }
    
    
    
    if(trigger.isupdate)
    {
        List<Id>ids=new List<Id>();
        for(Supplier_Quote__c iefl : trigger.new)
        {
            if(iefl.Customer__c != null || iefl.Delivery_Account__c != null)
            {
                Supplier_Quote__c oldquote = Trigger.oldMap.get(iefl.ID);
                 system.debug('hola1'+oldquote.Name);
                if((iefl.Customer__c != oldquote.Customer__c) ||(iefl.Delivery_Account__c != oldquote.Delivery_Account__c))
                {
                    system.debug('hola'+oldquote.Customer__c);
                   ids.add(iefl.Id);
                 }
             }
         }
           if(ids.size()>0)
         {   
  List<Supplier_Quote__c>toUpdate=new List<Supplier_Quote__c>();
  for(Supplier_Quote__c s:[select Id, DeliveryAddress__c, Receipt_Address__c, Delivery_Account__c, Customer__c, Delivery_Account__r.ShippingStreet, Delivery_Account__r.ShippingCity, Delivery_Account__r.ShippingState, Delivery_Account__r.ShippingPostalCode, Delivery_Account__r.ShippingCountry, Customer__r.ShippingStreet, Customer__r.ShippingCity, Customer__r.ShippingState, Customer__r.ShippingPostalCode, Customer__r.ShippingCountry from Supplier_Quote__c WHERE Id IN:ids])
  {
    Boolean modified=false;
    if((String.IsEmpty(s.DeliveryAddress__c))&&(s.Delivery_Account__c!=null))
    {
      Integer linenumber=0;
      String myAddress=null;
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingStreet))
      {
        myAddress=s.Delivery_Account__r.ShippingStreet;
        linenumber=1;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingCity))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingCity;
        else
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingCity;
        linenumber=2;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingState))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingState;
        else
          myAddress=myAddress+', '+s.Delivery_Account__r.ShippingState;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingPostalCode))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingPostalCode;
        else if(linenumber==2)
          myAddress=myAddress+', '+s.Delivery_Account__r.ShippingPostalCode;
        else
          myAddress=myAddress+' '+s.Delivery_Account__r.ShippingPostalCode;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Delivery_Account__r.ShippingCountry))
      {
        if(linenumber==0)
          myAddress=s.Delivery_Account__r.ShippingCountry;
        else
          myAddress=myAddress+'\r\n'+s.Delivery_Account__r.ShippingCountry;
        linenumber=4;
      }
      if(linenumber!=0)
      {
        s.DeliveryAddress__c=myAddress;
        modified=true;
      }
    }
    if((String.IsEmpty(s.Receipt_Address__c))&&(s.Customer__c!=null))
    {
      Integer linenumber=0;
      String myAddress=null;
      if(String.IsNotEmpty(s.Customer__r.ShippingStreet))
      {
        myAddress=s.Customer__r.ShippingStreet;
        linenumber=1;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingCity))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingCity;
        else
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingCity;
        linenumber=2;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingState))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingState;
        else
          myAddress=myAddress+', '+s.Customer__r.ShippingState;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingPostalCode))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingState;
        else if(linenumber==1)
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingPostalCode;
        else if(linenumber==2)
          myAddress=myAddress+', '+s.Customer__r.ShippingPostalCode;
        else
          myAddress=myAddress+' '+s.Customer__r.ShippingPostalCode;
        linenumber=3;
      }
      if(String.IsNotEmpty(s.Customer__r.ShippingCountry))
      {
        if(linenumber==0)
          myAddress=s.Customer__r.ShippingCountry;
        else
          myAddress=myAddress+'\r\n'+s.Customer__r.ShippingCountry;
        linenumber=4;
      }
      if(linenumber!=0)
      {
        s.Receipt_Address__c=myAddress;
        modified=true;
      }
    }
    if(modified)
      toUpdate.add(s);
  }
  if(toUpdate.size()>0)
    update toUpdate;
    }
    
    }
}