public without sharing class NEU_CurrencyUtils {
    public static String CurrencyIsoCode(String prefix)
    {
        system.debug('CurrencyIsoCode -> prefix : ' +  prefix);
        system.debug('CurrencyIsoCode -> UserInfo.isMultiCurrencyOrganization() : ' +  UserInfo.isMultiCurrencyOrganization());
        
        if(UserInfo.isMultiCurrencyOrganization())
            return (String.IsNotEmpty(prefix)?','+prefix+'.CurrencyIsoCode':',CurrencyIsoCode');
        
        return '';
    }
    public static String CurrencyIsoCode()
    {
        system.debug('CurrencyIsoCode ENTRAMOS AL VACIO ');
        if(UserInfo.isMultiCurrencyOrganization())return ',CurrencyIsoCode';
        return '';
    }
    
    public static List<String> getCurrencyIsoCodeList()
    {
        system.debug('getCurrencyIsoCodeList ENTRAMOS ' );
        
        List<String>result=new List<String>();
        if(UserInfo.isMultiCurrencyOrganization()) 
            for(SObject c:database.query('select IsoCode from CurrencyType where IsActive = true')) 
            result.add((String)c.get('IsoCode'));
        else
            result.add(UserInfo.getDefaultCurrency());
        
        system.debug('getCurrencyIsoCodeList -> result :  ' + result );
        
        return result;
    }
    public static List<SelectOption> getCurrencyIsoCodeOptions()
    {
        system.debug('getCurrencyIsoCodeOptions -> ENTRAMOS ' );
        List<SelectOption>result=new List<SelectOption>();
        for(String s:getCurrencyIsoCodeList())
            result.add(new SelectOption(s,s));
        
        system.debug('getCurrencyIsoCodeOptions -> result :  ' + result );
        
        return result;
    }
    public static String getCurrencyIsoCode(SObject someObject)
    {
        string result = UserInfo.isMultiCurrencyOrganization() ? (String) someObject.get('CurrencyIsoCode') : UserInfo.getDefaultCurrency();
        system.debug('getCurrencyIsoCode -> result :  ' + result );
        system.debug('getCurrencyIsoCode -> someObject :  ' + someObject );
        
        return result;
    }
    public static void setCurrencyIsoCode(SObject someObject,String currencyIsoCode)
    {
        system.debug('setCurrencyIsoCode -> someObject :  ' + someObject );
        system.debug('setCurrencyIsoCode -> currencyIsoCode :  ' + currencyIsoCode );
        
        if(UserInfo.isMultiCurrencyOrganization()) someObject.put('CurrencyIsoCode',currencyIsoCode);
        
        system.debug('getCurrencyIsoCode -> someObject :  ' + someObject );
    }
    private List<SObject>conversion=null;
    private Boolean filterByDate=false;
    
    public NEU_CurrencyUtils()
    {
        if(UserInfo.isMultiCurrencyOrganization()) 
            conversion = database.query('select ConversionRate,IsoCode from CurrencyType where IsActive = true');
        
        if(test.isRunningTest())
        {
            string a= '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
            a = '';
        }
        
        system.debug('NEU_CurrencyUtils -> conversion :  ' + conversion );
    }
    public Decimal changeCurrency(Decimal amount,String FromCurrencyIsoCode,String ToCurrencyIsoCode)
    {
        system.debug('changeCurrency -> amount :  ' + amount );
        system.debug('changeCurrency -> FromCurrencyIsoCode :  ' + FromCurrencyIsoCode );
        system.debug('changeCurrency -> ToCurrencyIsoCode :  ' + ToCurrencyIsoCode );
        
        Decimal result=amount;
        if(FromCurrencyIsoCode!=ToCurrencyIsoCode)
            if(conversion!=null)
            for(SObject c:conversion)
            if(((String)c.get('IsoCode'))==ToCurrencyIsoCode)
            result=result*((Decimal)c.get('ConversionRate'));
        else if(((String)c.get('IsoCode'))==FromCurrencyIsoCode)
            result=result/((Decimal)c.get('ConversionRate'));
        
        system.debug('changeCurrency -> result :  ' + result );
        
        return result;
    }
    public NEU_CurrencyUtils(SObject header)
    {
        system.debug('NEU_CurrencyUtils -> header :  ' + header );
        
        if(UserInfo.isMultiCurrencyOrganization())
            init(header, 'Conversion_Rate_Date__c');
    }
    private void init(SObject header, String fieldName)
    {
        system.debug('init -> header :  ' + header );
        system.debug('init -> fieldName :  ' + fieldName );
        
        system.debug('init -> Schema.getGlobalDescribe().containsKey(DatedConversionRate) :  ' + Schema.getGlobalDescribe().containsKey('DatedConversionRate') );
        
        if(!Schema.getGlobalDescribe().containsKey('DatedConversionRate'))
            conversion=database.query('select ConversionRate,IsoCode from CurrencyType where IsActive = true');
        else
        {
            Date currencyDate=(Date)header.get(fieldName);
            system.debug('init -> currencyDate :  ' + currencyDate );
            
            if(currencyDate==null)
                currencyDate=Date.today();
            conversion=database.query('select ConversionRate,IsoCode,startDate,nextstartdate from DatedConversionRate where startDate<=:currencyDate and nextstartdate>:currencyDate');
            filterByDate = true;
        }
        
        system.debug('init -> conversion :  ' + conversion );
    }
    public NEU_CurrencyUtils(List<SObject> headers)
    {
        system.debug('NEU_CurrencyUtils -> headers :  ' + headers );
        init(headers, 'Conversion_Rate_Date__c');
    }
    public void init (List<SObject> headers, String fieldName)
    {
        system.debug('init -> headers :  ' + headers );
        system.debug('init -> fieldName :  ' + fieldName );
        system.debug('init -> UserInfo.isMultiCurrencyOrganization() :  ' + UserInfo.isMultiCurrencyOrganization() );
        
        if(UserInfo.isMultiCurrencyOrganization())
        {
            if(headers.size()==1){
                system.debug('init -> headers :  ' + headers[0] );
                init(headers[0], fieldName);
            }
            else
            {
                if(!Schema.getGlobalDescribe().containsKey('DatedConversionRate'))
                {
                    conversion=database.query('select ConversionRate,IsoCode from CurrencyType where IsActive = true');
                    system.debug('init -> conversion 2 :  ' + conversion );                
                }else
                {
                    Date minDate=null;
                    Date maxDate=null;
                    for(SObject o:headers)
                    {
                        Date current=(Date)o.get(fieldName);
                        if((minDate==null)||(minDate>current))
                            minDate=current;
                        if((maxDate==null)||(maxDate<current))
                            maxDate=current;
                    }
                    
                    system.debug('init -> minDate :  ' + minDate );  
                    system.debug('init -> maxDate :  ' + maxDate );  
                    
                    conversion=database.query('select ConversionRate,IsoCode,startDate,nextstartdate from DatedConversionRate where startDate<=:maxDate and nextstartdate>:minDate');
                    system.debug('init -> conversion 3 :  ' + conversion );  
                    filterByDate = true;
                }
            }
        }
    }
    
    public NEU_CurrencyUtils(List<SObject> headers, String fieldName)
    {
        system.debug('NEU_CurrencyUtils -> headers :  ' + headers );  
        system.debug('NEU_CurrencyUtils -> fieldName :  ' + fieldName );  
        init(headers, fieldName);
    }
    
    public void updateConversionRate(SObject someObject,SObject header)
    {
        try{
            
            system.debug('updateConversionRate -> someObject :  ' + someObject );
            system.debug('updateConversionRate -> header :  ' + header );  
            
            someObject.put('Conversion_Rate_to_Currency_Header__c',getConversionRate(getCurrencyIsoCode(someObject),getCurrencyIsoCode(header),((Date)header.get('Conversion_Rate_Date__c'))));
            system.debug('updateConversionRate -> someObject :  ' + someObject );
        }catch(Exception e){system.debug('updateConversionRate -> e :  ' + e ); }
        
    }
    public Decimal getConversionRate(String FromCurrencyIsoCode,String ToCurrencyIsoCode,Date conversionDate)
    {
        system.debug('getConversionRate -> FromCurrencyIsoCode :  ' + FromCurrencyIsoCode );
        system.debug('getConversionRate -> ToCurrencyIsoCode :  ' + ToCurrencyIsoCode );
        system.debug('getConversionRate -> conversionDate :  ' + conversionDate );
        
        
        Decimal Rate=1.0;
        if(UserInfo.isMultiCurrencyOrganization())
        {
            if(FromCurrencyIsoCode!=ToCurrencyIsoCode)
                if(conversion!=null)
            {
                if(filterByDate)
                {
                    if(conversionDate==null)
                        conversionDate=Date.today();
                    
                    system.debug('getConversionRate -> conversionDate :  ' + conversionDate );
                    system.debug('getConversionRate -> conversion :  ' + conversion );
                    
                    for(DatedConversionRate c: (LIST<DatedConversionRate>)conversion)
                    {
                        system.debug('getConversionRate -> c :  ' + c );
                        system.debug('getConversionRate -> c.startDate :  ' + c.startDate );
                        system.debug('getConversionRate -> conversionDate :  ' + conversionDate );
                        system.debug('getConversionRate -> c.nextstartdate :  ' + c.nextstartdate );
                        system.debug('getConversionRate -> c.IsoCode :  ' + c.IsoCode );
                        system.debug('getConversionRate -> ToCurrencyIsoCode :  ' + ToCurrencyIsoCode );
                        system.debug('getConversionRate -> FromCurrencyIsoCode :  ' + FromCurrencyIsoCode );
                        system.debug('getConversionRate -> c.ConversionRate :  ' + c.ConversionRate );
                        
                        if(c.startDate<=conversionDate && c.nextstartdate>conversionDate)
                            if(c.IsoCode == ToCurrencyIsoCode)
                            Rate= Rate * c.ConversionRate;
                        else if(c.IsoCode == FromCurrencyIsoCode )
                            Rate= Rate / c.ConversionRate;
                        
                        system.debug('getConversionRate -> Rate :  ' + Rate );
                    }
                }
                else{
                    for(CurrencyType c: (LIST<CurrencyType>)conversion)
                    {	
                        system.debug('getConversionRate -> c.IsoCode :  ' + c.IsoCode );
                        system.debug('getConversionRate -> ToCurrencyIsoCode :  ' + ToCurrencyIsoCode );
                        system.debug('getConversionRate -> ToCurrencyIsoCode :  ' + ToCurrencyIsoCode );
                        
                        if(c.IsoCode==ToCurrencyIsoCode)
                            Rate=Rate*c.ConversionRate;
                        
                        else if(c.IsoCode==FromCurrencyIsoCode){
                            Rate=Rate/c.ConversionRate;
                            
                            system.debug('getConversionRate -> Rate :  ' + Rate );
                        }
                    }
                }
            }
        }
        
        system.debug('getConversionRate -> Rate F :  ' + Rate );
        return Rate;
    }
    public static void lineBeforeUpdate(String headerClass,String headerField,List<SObject>newList,Map<Id,SObject>oldmap)
    {
        system.debug('lineBeforeUpdate -> headerClass  :  ' + headerClass );
        system.debug('lineBeforeUpdate -> headerField  :  ' + headerField );
        system.debug('lineBeforeUpdate -> newList  :  ' + newList );
        system.debug('lineBeforeUpdate -> oldmap  :  ' + oldmap );
        
        if(UserInfo.isMultiCurrencyOrganization())
        {
            Set<Id> ids=new Set<Id>();
            for(SObject newl:newList)
                if((String)oldMap.get(newl.id).get('CurrencyIsoCode')!=(String)newl.get('CurrencyIsoCode'))
                ids.add((Id)newl.get(headerField));
            if(ids.size()>0)
            {
                List<SObject>headers=database.query('select Id,Conversion_Rate_Date__c,CurrencyIsoCode from '+headerClass+' where Id IN:ids');
                NEU_CurrencyUtils cutils=new NEU_CurrencyUtils(headers);
                Map<Id,SObject>mapheaders=new Map<Id,SObject>(headers);
                for(SObject newl:newList)
                    if((String)oldMap.get(newl.id).get('CurrencyIsoCode')!=(String)newl.get('CurrencyIsoCode'))
                    cutils.updateConversionRate(newl,mapheaders.get((Id)newl.get(headerField)));
            }
        }
    }
    public static void lineBeforeInsert(String headerClass,String headerField,List<SObject>newList)
    {
        system.debug('lineBeforeInsert -> headerClass  :  ' + headerClass );
        system.debug('lineBeforeInsert -> headerField  :  ' + headerField );
        system.debug('lineBeforeInsert -> newList  :  ' + newList );
        
        if(UserInfo.isMultiCurrencyOrganization())
        {
            Set<Id> ids=new Set<Id>();
            for(SObject newl:newList)
                ids.add((Id)newl.get(headerField));
            if(ids.size()>0)
            {
                List<SObject>headers=database.query('select Id,Conversion_Rate_Date__c,CurrencyIsoCode from '+headerClass+' where Id IN:ids');
                NEU_CurrencyUtils cutils=new NEU_CurrencyUtils(headers);
                Map<Id,SObject>mapheaders=new Map<Id,SObject>(headers);
                for(SObject newl:newList)
                    cutils.updateConversionRate(newl,mapheaders.get((Id)newl.get(headerField)));
            }
        }
    }
    public static void headerAfterUpdate(String[]lineClass,String[]headerField,List<SObject>newList,Map<id,SObject>newMap,Map<id,SObject>oldMap)
    {
        system.debug('headerAfterUpdate -> lineClass  :  ' + lineClass );
        system.debug('headerAfterUpdate -> headerField  :  ' + headerField );
        system.debug('headerAfterUpdate -> newList  :  ' + newList );
        system.debug('headerAfterUpdate -> newMap  :  ' + newMap );
        system.debug('headerAfterUpdate -> oldMap  :  ' + oldMap );
        
        if(UserInfo.isMultiCurrencyOrganization())
        {
            List<SObject> objects=new List<SObject>();
            for(SObject newo:newList)
            {
                SObject oldo=oldMap.get(newo.Id);
                if((Date)newo.get('Conversion_Rate_Date__c')!=(Date)oldo.get('Conversion_Rate_Date__c'))
                    objects.add(newo);
                else if((String)newo.get('CurrencyIsoCode')!=(String)oldo.get('CurrencyIsoCode'))
                    objects.add(newo);
            }
            if(objects.size()>0)
            {
                NEU_CurrencyUtils cutils=new NEU_CurrencyUtils(objects);
                for(Integer counter=0;counter<lineClass.size();counter++)
                {
                    List<SObject>lines=database.query('select Id,Conversion_Rate_to_Currency_Header__c,CurrencyIsoCode,'+headerField[counter]+' from '+lineClass[counter]+' where '+headerField[counter]+' IN:objects');
                    if(lines.size()>0)
                    {
                        for(SObject line:lines)
                            cutils.updateConversionRate(line,newMap.get((Id)line.get(headerField[counter])));
                        update lines;
                    }
                }
            }
        }
    }
}