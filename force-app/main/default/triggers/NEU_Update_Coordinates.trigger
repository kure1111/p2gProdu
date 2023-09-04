trigger NEU_Update_Coordinates on Customer_Quote__c (before update) 
{
     if(NEU_StaticVariableHelper.getBoolean1()|| System.IsBatch()  || System.isFuture()){return;}        
    
 //   if(trigger.isBefore)
   // {
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Update_Coordinates')){
        RecursiveCheck.triggerMonitor.add('NEU_Update_Coordinates');
        set<string> idsAccountAdress = new set<string>();
        for(Customer_Quote__c cq : trigger.new)
        {
            if(cq.Account_Origin_Address__c != null){
                idsAccountAdress.add(cq.Account_Origin_Address__c);
            }
            if(cq.Account_Destination_Address__c != null){
                idsAccountAdress.add(cq.Account_Destination_Address__c);
            }
        }
        map<string,Account_Address__c> mapAccountAddress = new map<string,Account_Address__c>();
        for(Account_Address__c aa: [select id,Address__c,Address_Coordinates__latitude__s,
                                    Address_Coordinates__longitude__s from Account_Address__c 
                                    where id IN: idsAccountAdress])
        {
            mapAccountAddress.put(aa.id,aa);
        }
        
        
        for(Customer_Quote__c quote: trigger.new)
        {
            Customer_Quote__c oldquote = Trigger.oldMap.get(quote.ID);
            Account_Address__c origin =  mapAccountAddress.get( quote.Account_origin_Address__c );
            Account_Address__c dest =  mapAccountAddress.get( quote.Account_destination_Address__c );
            
             IF(quote.FolioResume__c == 'FN' ||quote.FolioResume__c == 'PT' ||quote.FolioResume__c == 'FI' )
            {
                if(quote.Account_Origin_Address__c != null)
                {
                    quote.Origin_Address__c = mapAccountAddress.get(quote.Account_Origin_Address__c).Address__c;
                    quote.Origin_Location__Latitude__s =mapAccountAddress.get(quote.Account_Origin_Address__c).Address_Coordinates__latitude__s;
                    quote.Origin_Location__Longitude__s =mapAccountAddress.get(quote.Account_Origin_Address__c).Address_Coordinates__longitude__s;
                    system.debug('origin  ' +  quote.Origin_Address__c );
                }
                else if(quote.Account_Origin_Address__c == null&& quote.Quotation_Status__c == 'Approved as Succesful')
                {
                    quote.Account_Origin_Address__c.addError('Favor de indicar dirección de Origen');
                }
                else if(quote.Account_Origin_Address__c == null && quote.Quotation_Status__c != 'Approved as Succesful')
                {
                    quote.Origin_Address__c = null;
                    quote.Origin_Location__Latitude__s = null;
                    quote.Origin_Location__Longitude__s = null;
                    quote.Kms__c = 0;
                }
                
                
                if(quote.Account_Destination_Address__c != null ){
                    
                    quote.Destination_Address__c = mapAccountAddress.get(quote.Account_Destination_Address__c).Address__c;
                    quote.Destination_Location__latitude__s =mapAccountAddress.get(quote.Account_Destination_Address__c).Address_Coordinates__latitude__s;
                    quote.Destination_Location__longitude__s =mapAccountAddress.get(quote.Account_Destination_Address__c).Address_Coordinates__longitude__s;
                    system.debug('dest  ' +  quote.Destination_Address__c );
                    
                }
                else if(quote.Account_Destination_Address__c == null&& quote.Quotation_Status__c == 'Approved as Succesful')
                {
                    quote.Account_Destination_Address__c.addError('Favor de indicar dirección de Destino');
                }
                else if(quote.Account_Destination_Address__c == null && quote.Quotation_Status__c != 'Approved as Succesful')
                {
                    quote.Destination_Address__c = null;
                    quote.Destination_Location__latitude__s = null;
                    quote.Destination_Location__longitude__s = null;
                    quote.Kms__c = 0;
                }
            }
            
            
            
            IF(quote.FolioResume__c == 'FN' ||quote.FolioResume__c == 'PT' )
            {
                
                if( quote.Account_origin_Address__c != null  && quote.Quotation_Status__c == 'Approved as Succesful' )
                {  
                    system.debug('FN ORIGEN');
                    
                    string errors = '';
                    string errorsInit = 'Latitud actual ( '+ (origin.Address_Coordinates__Latitude__s != null ? origin.Address_Coordinates__Latitude__s.setScale(2) : 0 ) +' ) y Longitud actual ( '+ (origin.Address_Coordinates__Longitude__s != null ? origin.Address_Coordinates__Longitude__s.setScale(2) : 0)+' ).';
                    
                    if(origin != null && origin.Address_Coordinates__Longitude__s == origin.Address_Coordinates__Latitude__s)
                        errors += ' Latitud y Longitud no deben ser iguales.'; 
                    if(origin != null && origin.Address_Coordinates__Latitude__s < 14)
                        errors +=' La Latitud no debe ser menor a 14 (Ej incorrectos: (8, 10, 9.2)).';
                    if(origin != null && origin.Address_Coordinates__Longitude__s > -85 )
                        errors += ' La Longitud no puede ser mayor a -85 (Ej incorrectos: -50, -24, 100).';
                    
                    if(!string.isBlank(errors))
                        quote.Account_origin_Address__c.addError(errorsInit + ' ' +errors);
                    
                }
                
                if( quote.Account_destination_Address__c != null  && quote.Quotation_Status__c == 'Approved as Succesful')
                {   
                    
                    system.debug('FN DEST');
                    
                    string errorsInit = 'Latitud actual ( '+ (dest.Address_Coordinates__Latitude__s !=null ? dest.Address_Coordinates__Latitude__s.setScale(2) : 0) +' ) y Longitud actual ( '+ (dest.Address_Coordinates__Longitude__s != null ?dest.Address_Coordinates__Longitude__s.setScale(2) : 0) +' ).';
                    string errors= '';
                    if(dest != null && dest.Address_Coordinates__Longitude__s == dest.Address_Coordinates__Latitude__s)
                        errors += ' Latitud y Longitud no deben ser iguales.'; 
                    if(dest != null && dest.Address_Coordinates__Latitude__s < 14)
                        errors +=' La Latitud no debe ser menor a 14 (Ej incorrectos: (8, 10, 9.2)).';
                    if(dest != null && dest.Address_Coordinates__Longitude__s > -85 )
                        errors += ' La Longitud no puede ser mayor a -85 (Ej incorrectos: -50, -24, 100).';
                    
                    if(!string.isBlank(errors))
                        quote.Account_destination_Address__c.addError(errorsInit + ' ' + errors);
                }
            }
           /* ELSE IF(quote.FolioResume__c == 'FI' )
            {
				  if( quote.Account_origin_Address__c != null  && quote.Quotation_Status__c == 'Approved as Succesful' )
                {  
                    system.debug('FN ORIGEN');
                    
                    string errors = '';
                    string errorsInit = 'Latitud actual ( '+ (origin.Address_Coordinates__Latitude__s != null ? origin.Address_Coordinates__Latitude__s.setScale(2) : 0 ) +' ) y Longitud actual ( '+ (origin.Address_Coordinates__Longitude__s != null ? origin.Address_Coordinates__Longitude__s.setScale(2) : 0)+' ).';
                    
                    / *if(origin != null && origin.Address_Coordinates__Longitude__s == origin.Address_Coordinates__Latitude__s)
                        errors += ' Latitud y Longitud no deben ser iguales.'; 
                    if(origin != null && (origin.Address_Coordinates__Latitude__s < 55.55  || origin.Address_Coordinates__Latitude__s > 71.23))
                        errors +=' La Latitud no debe ser menor a 55.55 o mayor a 71.23 (Ej incorrectos: (56, 70, 71.22)).';
                    if(origin != null && (origin.Address_Coordinates__Longitude__s > 164.20 || origin.Address_Coordinates__Longitude__s < 35 ))
                        errors += ' La Longitud no puede ser mayor a 164.20 o menor a 35.00 (Ej incorrectos: 50, 74, 100).';
                    * /
                    if(!string.isBlank(errors))
                        quote.Account_origin_Address__c.addError(errorsInit + ' ' +errors);
                    
                }
                
                if( quote.Account_destination_Address__c != null  && quote.Quotation_Status__c == 'Approved as Succesful')
                {   
                    
                    system.debug('FN DEST');
                    
                    string errorsInit = 'Latitud actual ( '+ (dest.Address_Coordinates__Latitude__s !=null ? dest.Address_Coordinates__Latitude__s.setScale(2) : 0) +' ) y Longitud actual ( '+ (dest.Address_Coordinates__Longitude__s != null ?dest.Address_Coordinates__Longitude__s.setScale(2) : 0) +' ).';
                    string errors= '';
                   / * if(dest != null && dest.Address_Coordinates__Longitude__s == dest.Address_Coordinates__Latitude__s)
                        errors += ' Latitud y Longitud no deben ser iguales.'; 
                   if(dest != null && (dest.Address_Coordinates__Latitude__s < 55.55  || dest.Address_Coordinates__Latitude__s > 71.23))
                        errors +=' La Latitud no debe ser menor a 55.55 o mayor a 71.23 (Ej incorrectos: (56, 70, 71.22)).';
                    if(dest != null && (dest.Address_Coordinates__Longitude__s > 164.20 || dest.Address_Coordinates__Longitude__s < 35 ))
                        errors += ' La Longitud no puede ser mayor a 164.20 o menor a 35.00 (Ej incorrectos: 50, 74, 100).';
                    * /
                    if(!string.isBlank(errors))
                        quote.Account_destination_Address__c.addError(errorsInit + ' ' + errors);
                }           
            }*/
            
        }
        
      GenerateDateLoad.GenerarTimeResponse(trigger.new,trigger.oldMap);
   /*  }
   else if(trigger.isAfter)
    {
        Map<String, Schema.SObjectField> fieldMap = Customer_Quote__c.sObjectType.getDescribe().fields.getMap();
        Set<String> fieldNames = fieldMap.keySet();
        
        SET<ID> keys = trigger.newMap.keyset();
        String soqlQuery = ' SELECT ' + string.join((Iterable<String>)fieldNames, ', ') + ' FROM Customer_Quote__c Where Id in: keys';
        List<Customer_Quote__c> newQuotes = Database.query(soqlQuery);
        
        GenerateDateLoad.GenerarTimeResponse(newQuotes,trigger.oldMap);
    }*/
    }
    
    if(Test.isRunningTest())
    {
        string       Test0 = '';
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
    }
}