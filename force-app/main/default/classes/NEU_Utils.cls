public without sharing class NEU_Utils {
    private String decimalSep=null;
    private String ThousandSep=null;
    
    public Decimal toDecimalR(String value)
    {
        if(String.IsEmpty(value))
            return null;
        if(ThousandSep==null)
            ThousandSep = getThousandSep();
        if(String.IsNotEmpty(ThousandSep))
        	value=value.remove(ThousandSep);
        if(decimalSep==null)
            decimalSep = getDecimalSep();
        if(decimalSep!='.')
        {
            value=value.remove('.').replace(decimalSep,'.');
            if(value.length()>1)
                if(value.startsWith('0'))
                    if(!value.startsWith('0.'))
                        return null;
        }
        try
        {
            return Decimal.valueOf(value);
        }
        catch(Exception e){}
        return null;
    }
    public String getDecimalSepR()
    {
        if(decimalSep==null)
            decimalSep = getDecimalSep();
        return decimalSep;
    }
    public String getThousandSepR()
    {
        if(ThousandSep==null)
            ThousandSep = getThousandSep();
        return ThousandSep;
    }
    public static String getDecimalSep()
    {
        return Test.isRunningTest()?',':(1.1).format().substring(1,2);
    }
    public static String getThousandSep()
    {
    	String f=(1000.0).format().substring(1,2);
    	if((f>='0')&&(f<='9'))
    		return '';
    	return Test.isRunningTest()?'.':f;
    }
    public static Decimal toDecimal(String value)
    {
        if(String.IsEmpty(value))
            return null;
        String ThousandSep = getThousandSep();
        if(String.IsNotEmpty(ThousandSep))
        	value=value.remove(ThousandSep);
        String decimalSep = getDecimalSep();
        if(decimalSep!='.')
        {
            value=value.remove('.').replace(decimalSep,'.');
            if(value.length()>1)
                if(value.startsWith('0'))
                    if(!value.startsWith('0.'))
                        return null;
        }
        try
        {
            return Decimal.valueOf(value);
        }
        catch(Exception e){}
        return null;
    }
    public static Decimal safeDecimal(Decimal value)
    {
        if(value==null)
            return 0;
        return value;
    }
    public static Decimal safeDecimal(String value)
    {
		try
        {
            return Decimal.valueOf(value);
        }
        catch(Exception e){}
        return 0;
    }
    
    public static String deserialize(string value)
    {
        if(string.isnotempty(value) && value.contains('__r":{"sobjectType":"'))
        {
            
            string cadena = value;
            while(value.contains('__r":{"sobjectType":"') == true)
            {
                Integer position_string = value.indexOf('__r":{"sobjectType":"',0);
                Integer final_position = value.indexOf('}', position_string);
                final_position +=1;
                string substrig_cadena = cadena.substring(final_position , cadena.length());
                integer init_position = cadena.lastIndexOf('"', position_string);
                
                string cadena_part_1 = cadena.substring(0,init_position-1);//el 1 es por la coma
                string cadena_part_2 = cadena.substring(final_position ,cadena.length());
                value= cadena_part_1 + cadena_part_2;
                cadena = value;
            }
            
        }
        return value;
        
    }
    
    public static Integer safeInteger(Integer value)
    {
        if(value==null)
            return 0;
        return value;
    }
    public static Integer safeInteger(Decimal value)
    {
        if(value==null)
            return 0;
        return value.intValue();
    }
    public static Integer safeInteger(String value)
    {
		try
        {
            return Integer.valueOf(value);
        }
        catch(Exception e){}
        return 0;
    }
    public static String safeString(object value)
    {
        if(value==null)
            return '';
        if(value instanceof Decimal)
        	return ((decimal)value).format();
        if(value instanceof Date)
        	return ((Date)value).format();
        if(value instanceof DateTime)
        	return ((DateTime)value).format();
        return string.valueof(value);
    }
    public static String safeString(Decimal value,Integer decimals)
    {
    	String res='0';
        if(value!=null)
            res=value.format();
        String sep=getDecimalSep();
        if(String.IsNotEmpty(sep))
        {
        	Integer pos=res.lastIndexOf(sep);
        	if(pos<0)
        		res+=sep;
        	else
	        	decimals-=res.length()-pos-1;
	        for(Integer c=0;c<decimals;c++)
				res+='0';
        }
        return res;
    }
    public static String getStringPopulate(SObject myObject)
    {
    	return String.join(getArrayPopulate(myObject),',');
    }
    public static String[] getArrayPopulate(SObject myObject)
    {
        return new List<String>(myObject.getSobjectType().getDescribe().fields.getMap().keySet());
    }
    public static SObject populate(SObject myObject)
    {
    	return populate(getArrayPopulate(myObject),myObject);
    }
    public static SObject populate(String[] myfields,SObject myObject)
    {
    	return populate(myfields,myObject.getSobjectType().getDescribe().getName(),(ID)myObject.get('Id'));
    }
    public static SObject populate(String[] myfields,String objectName,ID objectID)
    {
        String query='select '+String.join(myfields,',')+' from '+objectName+' where Id=:objectID';
        List<SObject>objects=database.query(query);
        if(objects.size()>0)
            return objects[0];
        return null;
    }
    public static SObject clone(SObject myObject)
    {
		return myObject.clone(false,true);
    }
    public static SObject populateClone(SObject myObject)
    {
		return clone(populate(myObject));
    }
    
    //INSERT FIELDS
    public static Map<string, string> List_Record_Types=null;
    
    public static String formatAddress(String Street,String City,String State,String PostalCode,String Country)
    {
        Integer linenumber=0;
        String myAddress=null;
        if(String.IsNotEmpty(Street))
        {
            myAddress=Street;
            linenumber=1;
        }
        if(String.IsNotEmpty(City))
        {
            if(linenumber==0)
                myAddress=City;
            else
                myAddress=myAddress+'\r\n'+City;
            linenumber=2;
        }
        if(String.IsNotEmpty(State))
        {
            if(linenumber==0)
                myAddress=State;
            else if(linenumber==1)
                myAddress=myAddress+'\r\n'+State;
            else
                myAddress=myAddress+', '+State;
            linenumber=3;
        }
        if(String.IsNotEmpty(PostalCode))
        {
            if(linenumber==0)
                myAddress=PostalCode;
            else if(linenumber==1)
                myAddress=myAddress+'\r\n'+PostalCode;
            else if(linenumber==2)
                myAddress=myAddress+', '+PostalCode;
            else
                myAddress=myAddress+' '+PostalCode;
            linenumber=3;
        }
        if(String.IsNotEmpty(Country))
        {
            if(linenumber==0)
                myAddress=Country;
            else
                myAddress=myAddress+'\r\n'+Country;
            linenumber=4;
        }
        return myAddress;
    }
    
    
    private class BitSet
    {
	    public Map<String,Integer> alphaNumCharCodes {get;set;}
	    public Map<String, Integer> base64CharCodes {get;set;}
	    
	    public BitSet(){
	        LoadCharCodes();
	    }
	    
	    //Method loads the character codes for all letters
	    private void LoadCharCodes(){
	        alphaNumCharCodes = new Map<String,Integer>{
	            'A'=>65,'B'=>66,'C'=>67,'D'=>68,'E'=>69,'F'=>70,'G'=>71,'H'=>72,'I'=>73,'J'=>74,
	            'K'=>75,'L'=>76,'M'=>77,'N'=>78,'O'=>79,'P'=>80,'Q'=>81,'R'=>82,'S'=>83,'T'=>84,
	            'U'=>85,'V'=> 86,'W'=>87,'X'=>88,'Y'=>89,'Z'=>90    
	        };
	        base64CharCodes = new Map<String, Integer>();
	        //all lower cases
	        Set<String> pUpperCase = alphaNumCharCodes.keySet();
	        for(String pKey : pUpperCase){
	            //the difference between upper case and lower case is 32
	            alphaNumCharCodes.put(pKey.toLowerCase(),alphaNumCharCodes.get(pKey)+32);
	            //Base 64 alpha starts from 0 (The ascii charcodes started from 65)
	            base64CharCodes.put(pKey,alphaNumCharCodes.get(pKey) - 65);
	            base64CharCodes.put(pKey.toLowerCase(),alphaNumCharCodes.get(pKey) - (65) + 26);
	        }
	        //numerics
	        for (Integer i=0; i<=9; i++){
	            alphaNumCharCodes.put(string.valueOf(i),i+48);
	            //base 64 numeric starts from 52
	            base64CharCodes.put(string.valueOf(i), i + 52);
	        }
	    }
	        
	      public List<Integer> testBits(String pValidFor,List<Integer> nList){
	            List<Integer> results = new List<Integer>();
	            List<Integer> pBytes = new List<Integer>();
	            Integer bytesBeingUsed = (pValidFor.length() * 6)/8;
	            Integer pFullValue = 0;
	            if (bytesBeingUsed <= 1)
	                return results;
	            for(Integer i=0;i<pValidFor.length();i++){
	                pBytes.Add((base64CharCodes.get((pValidFor.Substring(i, i+1)))));
	            }   
	            for (Integer i = 0; i < pBytes.size(); i++)
	            {
	                Integer pShiftAmount = (pBytes.size()-(i+1))*6;//used to shift by a factor 6 bits to get the value
	                pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));
	            }
	            
	            Integer bit;
	            Integer targetOctet;
	            Integer shiftBits;
	            Integer tBitVal;
	            Integer n;
	            Integer nListSize = nList.size();
	            for(Integer i=0; i<nListSize; i++){
	                n = nList[i];
	                bit = 7 - (Math.mod(n,8)); 
	                targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed); 
	                shiftBits = (targetOctet * 8) + bit;
	                tBitVal = ((Integer)(2 << (shiftBits-1)) & pFullValue) >> shiftBits;
	                if (tBitVal==1)
	                    results.add(n);
	            }
	            return results;
	        }
	}
	
	private class PicklistEntryWrapper
	{
	    public PicklistEntryWrapper(){ }
	    public String active {get;set;}
	    public String defaultValue {get;set;}
	    public String label {get;set;}
	    public String value {get;set;}
	    public String validFor {get;set;}
	}
    
    //Specific function to return Picklist dependent on an object
    public static List<String> getPicklistSimple(String objName, String contrfieldName)
    {
    	List<String> picklistString = new List<String>();
    	
    	String objectName = objName.toLowerCase();
        String controllingField = contrfieldName.toLowerCase();
    	
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!Schema.getGlobalDescribe().containsKey(objectName)){
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
        }
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return null;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField))
        {
            System.debug('FIELD NOT FOUND --.> ' + controllingField);
            return null;     
        }
        
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            picklistString.add(ctrlentry.getLabel());
        }
        return picklistString;
    }
    
    
    
    //Specific function to return Picklist dependent on an object with other field dependent
    public static Map<String,List<String>> getDependentPicklist(String objName, String contrfieldName, String depfieldName)
    {
        
        String objectName = objName.toLowerCase();
        String controllingField = contrfieldName.toLowerCase();
        String dependentField = depfieldName.toLowerCase();        
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!Schema.getGlobalDescribe().containsKey(objectName))
        {
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
        }
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Bitset bitSetObj = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        objFieldMap = null;
        List<Integer> controllingIndexes = new List<Integer>();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++)
        {            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            objResults.put(label,new List<String>());
            controllingIndexes.add(contrIndex);
        }
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<PicklistEntryWrapper> objJsonEntries = new List<PicklistEntryWrapper>();
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++)
        {            
               Schema.PicklistEntry depentry = depEntries[dependentIndex];
               objEntries.add(depentry);
        } 
        objJsonEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objEntries), List<PicklistEntryWrapper>.class);
        List<Integer> indexes;
        for (PicklistEntryWrapper objJson : objJsonEntries)
        {
            if (objJson.validFor==null || objJson.validFor==''){
                continue;
            }
            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);
            for (Integer idx : indexes){                
                String contrLabel = contrEntries[idx].getLabel();
                objResults.get(contrLabel).add(objJson.label);
            }
        }
        objEntries = null;
        objJsonEntries = null;
        return objResults;
    }

	public static List<Account>getAccounts(String record_type_api_names)
	{
		List<Account> New_Account_List = new List<Account>();
		if(List_Record_Types == null)
		{
			List_Record_Types = new Map<string, string>();
			List<RecordType> query_recordtype = [select Id, Name, DeveloperName from RecordType where IsActive = true and SobjectType ='Account'];
			for(RecordType rt: query_recordtype )
				{
					List_Record_Types.put(rt.DeveloperName, rt.Id);
				}
		}

		List<String> record_type_api = record_type_api_names.split(',');
		integer name_accounts = 0;

		for(String st: record_type_api)
		{
			Account new_account = new Account();
			new_account.Name = name_accounts+'';
			new_account.RecordTypeId = List_Record_Types.get(st);
			//new_account.RecordTypeId = '0120E0000004MVB';
			new_account.Business_Area__c = 'Other Services';
			new_account.Credit_Limit__c = 100;
			new_account.Status_Account__c = 'Active';
			new_account.BillingPostalCode = '01001';
			new_account.NEU_Email__c='email@domain.com';
			new_account.Secret__c='0000';
			new_account.Credit_Limit__c = 100;
			new_account.BillingStreet = 'Street';
			new_account.BillingCity = 'Vitoria-Gasteiz';
			//new_account.Type = 'Installer';
			//new_account.Location_Type__c ='Installer';
			new_account.BillingState = 'Álava';
			new_account.BillingCountry ='ES';
			//Especific Required Fields for Cosentino
			try
            {
            	new_account.put('BillingCountryCode','ES');
            	new_account.put('BillingStateCode','01');
            }catch(exception e){}

			//new_account.SAM_ID__c = '222222';
			// new_account.ShippingCountry = 'United States';
			New_Account_List.add(new_account);
			name_accounts ++;
		}

		return New_Account_List;
	}
	
	//EDITAR CON LOS VALORES CORRECTOS	
	public static String getCarrierAgentIATA(String departure, String destination)
    {
    	String IATA='';
	    if(departure == 'MTY' || destination == 'MTY')
	       	IATA = '94-7 0053/0014';		
	    else if(departure == 'GDL' || destination == 'GDL')
		    IATA = '94-7 0053/0036';					        		
        else
        	IATA='94-7 0053/0025'; //MEX
        return IATA;
    }
    
    //EDITAR CON LOS VALORES CORRECTOS
    public static String getPIMA(String departure, String destination)
    {
    	String PIMA='';
	    if(departure == 'MTY' || destination == 'MTY')
	       	PIMA = 'REUFFW91GPGL/MTY01';		
	    else if(departure == 'GDL' || destination == 'GDL')
		    PIMA = 'REUFFW91GPGL/GDL01';					        		
        else
        	PIMA = 'REUFFW91GPGL/MEX01';
        return PIMA;
    }
    
    public static String removeAccents(String myString)
	{
	    myString = myString.replaceAll('[Á]','A');
	    myString = myString.replaceAll('[á]','a');
	    myString = myString.replaceAll('[É]','E');
	    myString = myString.replaceAll('[é]','e');
	    myString = myString.replaceAll('[Í]','I');
	    myString = myString.replaceAll('[í]','i');
	    myString = myString.replaceAll('[Ó]','O');
	    myString = myString.replaceAll('[ó]','o');
	    myString = myString.replaceAll('[Ú]','U');
	    myString = myString.replaceAll('[ú]','u');
	
		return myString;    
	}
}