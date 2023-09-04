//This apex class is used to upload a document and create records with the information of excel
public with sharing class NEU_PaqueteriaExpressINT {
    //0 Type (columns[10])
    //1 Carrier (columns[5])
    //2 Valid From (columns[7])
    //3 Valid To (columns[8])
    //4 Distance (columns[39])
    //5 Volume (columns[40])
    //6 Weight (columns[35])
    //7 Buy Price (columns[11])
    //8 Sell Price (columns[12])
    //9 SAP Service Type (columns[41])

    public Integer[]columns=new Integer[]{35,13,16,38,41,1,12,2,3,11,0,7,8,18,19,20,21,17,14,37,15,41,22,23,24,25,26,27,28,29,30,31,32,33,34,6,39,36,37,4,5,9};//42
    public Integer[] getcolumns()
    {
        return columns;
    }
//Errors
    //columns[0] Name
    //columns[1] Country Load
    //columns[2] Location Load
    //columns[3] Country Discharge
    //columns[4] Location Discharge
    //columns[5] Carrier
    //columns[6] Container
    //columns[7] Valid From
    //columns[8] Valid To
    //columns[9] Category
    //columns[10] Type
    //columns[11] Buy Price
    //columns[12] Sell Price
    //columns[13] Concept 1
    //columns[14] Concept 2
    //columns[15] Concept 3
    //columns[16] Concept 4
    //columns[17] Concept 5
    //columns[18] State Load
    //columns[19] State Discharge
    //columns[20] Sell Price 2
    //columns[21] Observations
    //columns[22] Contract
    //columns[23] TT Days
    //columns[24] Agent
    //columns[25] Frecuency
    //columns[26] Max Kg
    //columns[27] Max M3
    //columns[28] Price Min
    //columns[29] IATA Code Load
    //columns[30] IATA Code Discharge
    //columns[31] Transhipment
    //columns[32] Modality
    //columns[33] Surcharge
    //columns[34] Pickup Zone
    //columns[35] Weight
    //columns[36] Additional KG Zone 1 - 4
    //columns[37] Additional KG Zone 5 - 8
    //columns[38] Extended Area
    //columns[39] Distance
    //columns[40] Volume
    //columns[41] SAP Service Type
    //columns[42] BUNKER ADJUSTMENT FACTOR (BAF) / CONTAINER
    //columns[43] PEAK SEASON SURCHARGE (PSS) / CONTAINER
    
    public NEU_PaqueteriaExpressINT()
    {
        firstDocument=true;
        adjustTemplate();
    }
    //define variables
    public Boolean firstDocument{get;set;}
    public transient String documento1Name{get;set;}
    public transient Blob documento1{get;set;}
    public transient String datafile{get;set;}
    public transient String sharedStrings{get;set;}
    public transient String worksheet{get;set;}
    private transient List<String>strings;
    private transient Integer stringsize;    
    private transient List<rateData>ratesData;
    public transient Integer ratesDataNumber; 
    public ID recordTypeID; 
    public String carrier{get;set;}
    public Integer getratesDataNumber()
    {
        if(ratesDataNumber!=null)
            return ratesDataNumber;
        return 0;
    }
    public Fee__c filter
    {
        get
        {
            if(filter==null)
            {
                filter=new Fee__c();                
                filter.Route__r=new Carrier_Line_Load_Point__c();
                NEU_CurrencyUtils.setCurrencyISOCode(filter,UserInfo.getDefaultCurrency());
            }
            return filter;
        }
        set;
    }
    private void adjustTemplate()
    {
        filter.Fee_Category__c='Mayoreo';
        recordTypeID=Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();       
    }
    public String filterCurrencyISOCode
    {
        get
        {
            return NEU_CurrencyUtils.getCurrencyISOCode(filter);
        }
        set
        {
            NEU_CurrencyUtils.setCurrencyISOCode(filter,value);
        }
    }
    public List<SelectOption>CurrencyIsoCodeOptions
    {
        get
        {
            if(CurrencyIsoCodeOptions==null)
                CurrencyIsoCodeOptions=NEU_CurrencyUtils.getCurrencyIsoCodeOptions();
            return CurrencyIsoCodeOptions;
        }
        set;
    }
    public List<SelectOption>getCategory()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult categoryFieldDescription = Fee__c.Fee_Category__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : categoryFieldDescription.getPicklistValues())
            options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        return options;
    }
    // check if document uploaded is correct
    public void upload()
    {
        firstDocument=false;
        if(String.IsNotEmpty(documento1Name)&&(documento1!=null))
        {
            if(documento1Name.tolowerCase().endsWith('.xlsx'))
            {
                if(documento1.size()>2376688)
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File is too large'));
                else
                {
                    datafile=EncodingUtil.base64Encode(documento1);
                    if(String.isNotEmpty(datafile))
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Processing: First step...  Please Wait'));
                        return;
                    }
                    datafile=null;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File is corrupted (FC1)'));
                }
            }
            else
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File must be a .xlsx'));
        }
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select an Excel document'));
    }
    public PageReference cleanPage()
    {
        PageReference p=Page.NEU_PaqueteriaExpressINT;
        p.setRedirect(true);
        return p;
    }
    //create a object to create new records
    private static Integer columnsNumber=42;
    public Boolean[] showColumn = new Boolean[]{true,true,true,false,true,true,true,true,true,true,true,false,false,false,false,false,false,false,true,true,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true};//42
    public Boolean[] getshowColumn()
    {
        return showColumn;
    }
    public class rateData
    {
        public rateData()
        {
            errors=new Integer[]{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//42
            errorsNumber=0;
            values=new String[]{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''};//42
        }
        private void setError(Integer errNumber)
        {
            errors[errNumber]=1;
            errorsNumber++;
        }
        public Integer[] errors{get;set;}
        public Integer errorsNumber{get;set;}
        public String[] values{get;set;}
        private Fee__c fee0;      
        ID CarrierID;
        ID SapstID;
        string SapGroup;
        Date validFrom;
        Date validTo;
        Decimal BuyRate;
        Decimal SellRate1;
        public String margin1{
            get
            {
                if(BuyRate != null && SellRate1 != null)
                    return NEU_Utils.safeString((((SellRate1-BuyRate)/BuyRate)*100).setScale(2),2)+'%';
                return null;
            }
        }
        public ID getfeeId()
        {
            if(fee0!=null)
                return fee0.Id;
            return null;
        }
    }
    public List<rateData>getratesData()
    {
        return ratesData;
    }
    public void tooManyLines()
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File is too large (FL1)'));
    }
     // check if document uploaded is correct
    public void processData()
    {
        if(String.IsNotEmpty(worksheet))
            processsheet();
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File is corrupted (FC2)'));
    }
     // Check if it is possible to upload the document and process it
    private void processsheet()
    {
        if(!extractData(true))
            return;
        if(ratesDataNumber>ratesData.size())
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Too many lines to show on this screen'));
        else if(ratesDataNumber==0)
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'There is no new line to add'));
    }
    //extract data by columns 
    private Boolean extractData(Boolean limited)
    {
        ratesData=null;
        ratesDataNumber=0;
        if(!processstrings())
            return false;
        ratesData=new List<rateData>();
        Dom.Document domDoc = new Dom.Document();
        Integer counter=0;
        Integer cpuLimit=Limits.getLimitCpuTime()*95/100;
        Integer heapLimit=Limits.getLimitHeapSize()*95/100;
        Set<String>accounts=new Set<String>();         
        try
        {
            domDoc.load(worksheet);
            for(Dom.XMLNode b : domDoc.getRootElement().getChildElements())
            {
                if(b.getName()=='sheetData')
                {
                    domDoc=null;
                    List<Dom.XMLNode>myrows=b.getChildElements();
                    b=null;
                    Integer totalLines=myrows.size()-1;
                    if(totalLines<=0)
                        break;
                    myrows.remove(0);
                    while(--totalLines>=0)
                    {                                               
                        Dom.XMLNode mycels=myrows.remove(0);
                        if(++counter>50 || Test.isRunningTest())
                        {
                            counter=0;
                            if((Limits.getHeapSize()>heapLimit)||(Limits.getCpuTime()>cpuLimit))
                            {
                                if(Limits.getHeapSize()>heapLimit)
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL1)'));
                                else
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL2)'));
                                ratesData=null;
                                return false;
                            }
                        }
                        Integer collength=mycels.getAttribute('r', '').length()+1;
                        rateData newRate=new rateData();
                        Boolean selectImport=false;
                        for(Dom.XMLNode mycel: mycels.getChildElements())
                        {
                            String celpos=mycel.getAttribute('r', '');
                            if(celpos.length()==collength)
                            {
                                Integer celposN=celpos.charAt(0)-65;
                                if((celposN<0)||(celposN>=columnsNumber))
                                    continue;
                                String s=xmlValue(mycel);
                                if(String.isEmpty(s))
                                    if(celposN==0)
                                        break;
                                    else
                                        continue;
                                newRate.values[celposN]=s;
                                if(celposN==columns[10])
                                    selectImport=true;
                                else if(celposN==columns[5])
                                    accounts.add(s);                                                         
                            }
                        }
                        if(selectImport)
                        {
                            ratesDataNumber++;
                            if((!limited)||(ratesDataNumber<=1000))
                                ratesData.add(newRate);
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File is corrupted (FC3)'));
            ratesData=null;
            return false;
        }
        //check data errors        
        map<String,Account>mapAccounts=new map<String,Account>();
        for(Account a:[select Id,Name from Account where Name IN:accounts])
            mapAccounts.put(a.Name.toUpperCase(),a);
        map<String,rateData>myFees=new map<String,rateData>();
        
        //getting SAP Service Types
        map<String,SAP_Service_Type__c>mapSapService=new map<String,SAP_Service_Type__c>();
        for(SAP_Service_Type__c c:[select Id,Name,Code__c,Group__c from SAP_Service_Type__c])
        	mapSapService.put(c.Code__c,c);
        
        for(rateData newRate:ratesData)
        {
        	//variable boolean per SAP Service Type
            Boolean sapst = false;
            
            if(++counter>50 || Test.isRunningTest())
            {
                counter=0;
                if((Limits.getHeapSize()>heapLimit)||(Limits.getCpuTime()>cpuLimit))
                {
                    if(Limits.getHeapSize()>heapLimit)
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL9)'));
                    else
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL10)'));
                    ratesData=null;
                    return false;
                }
            }            
            if(String.IsNotEmpty(newRate.values[columns[5]]))
            {
                Account a=mapAccounts.get(newRate.values[columns[5]].toUpperCase());
                if(a!=null)
                {
                    newRate.CarrierID=a.Id;
                    newRate.values[columns[5]]=a.Name;
                }
                else
                    newRate.setError(columns[5]);
            }
            else if(filter.Carrier_Account__c!=null)
            {               
                newRate.CarrierID=filter.Carrier_Account__c;
                newRate.values[columns[5]]=carrier;
            }   
            else
                 newRate.setError(columns[5]);    
            
            //Set SAP Service Type
         	if(String.IsNotEmpty(newRate.values[columns[41]]))
            {
                SAP_Service_Type__c s=mapSapService.get(newRate.values[columns[41]].toUpperCase());
                if(s!=null)   
                {              
                    newRate.SapstID=s.Id;
                    newRate.SapGroup=s.Group__c;
					sapst = true;
                }
                /*else
                    newRate.setError(columns[41]);*/
            }
         	/*else
                newRate.setError(columns[41]);*/
                      
            if(newrate.errorsNumber==0)
            {
                String myKey=(NEU_Utils.safeString(newRate.values[columns[10]])+'|'+NEU_Utils.safeString(newRate.values[columns[39]])+'|'+NEU_Utils.safeString(newRate.values[columns[40]])+'|'+NEU_Utils.safeString(newRate.values[columns[35]])).toUpperCase()+'|||'+NEU_Utils.safeString(newRate.CarrierId).left(15);
                if(myFees.containsKey(myKey))
                    newrate.SetError(columns[0]);
                else
                    myFees.put(myKey,newrate);                
            }
            newRate.values[columns[0]]=NEU_Utils.safeString(newRate.values[columns[10]]).left(15)+'-'+NEU_Utils.safeString(newRate.values[columns[39]]).left(18)+'-'+NEU_Utils.safeString(newRate.values[columns[40]]).left(13)+'-'+NEU_Utils.safeString(newRate.values[columns[35]]).left(15)+'-'+NEU_Utils.safeString(newRate.values[columns[5]]).left(15);           
        }
        if(myFees.size()>0)
        {
        	String query='select Id'+NEU_CurrencyUtils.CurrencyISOCode()+',Key_Description__c,Buy_Rate__c,Fee_Rate__c,Name,Valid_from__c,Valid_Until__c,Fee_Category__c from Fee__c';                   
            String AccountFor=filter.Account_for__c;
            Set<String> keySet=myFees.keySet();
            query+=' where Key_Description__c IN:keySet and Account_for__c=:AccountFor and RecordtypeID=:recordTypeId';
            String CurrencyISOCode=NEU_CurrencyUtils.getCurrencyISOCode(filter);
            if(UserInfo.isMultiCurrencyOrganization())
                query+=' and CurrencyISOCode=:CurrencyISOCode';
            List<Fee__c>fee=(List<Fee__c>)DataBase.query(query);
            for(Fee__c f:fee)
            {
                if(++counter>50 || Test.isRunningTest())
                {
                    counter=0;
                    if((Limits.getHeapSize()>heapLimit)||(Limits.getCpuTime()>cpuLimit))
                    {
                        if(Limits.getHeapSize()>heapLimit)
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL11)'));
                        else
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL12)'));
                        ratesData=null;
                        return false;
                    }
                }
                rateData newRate=myFees.get(f.Key_Description__c);
                if(newRate!=null)
                    newRate.fee0=f;
            }
        }
        String ValidFromFormat;
        if(filter.Valid_From__c!=null)
            ValidFromFormat=filter.Valid_From__c.format();
        else
            ValidFromFormat='';
        String ValidToFormat;
        if(filter.Valid_Until__c!=null)
            ValidToFormat=filter.Valid_Until__c.format();
        else
            ValidToFormat='';
        for(rateData newRate:ratesData)
        {
            if(++counter>50 || Test.isRunningTest())
            {
                counter=0;
                if((Limits.getHeapSize()>heapLimit)||(Limits.getCpuTime()>cpuLimit))
                {
                    if(Limits.getHeapSize()>heapLimit)
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL13)'));
                    else
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL14)'));
                    ratesData=null;
                    return false;
                }
            }
            if(newRate.fee0==null)
            {
                newRate.fee0=new Fee__c();
                //base data
                newRate.fee0.Account_for__c=filter.Account_for__c;
                NEU_CurrencyUtils.setCurrencyISOCode(newRate.fee0,filterCurrencyISOCode);
            }              
            if(String.IsNotEmpty(newrate.values[columns[7]]))
            {
                newrate.fee0.Valid_From__c=xmlDate(newrate.values[columns[7]]);
                if(newrate.fee0.Valid_From__c==null)
                    newrate.setError(columns[7]);
                else
                    newRate.values[columns[7]]=newrate.fee0.Valid_From__c.format();
            }   
            else
            {
                newrate.fee0.Valid_From__c=filter.Valid_From__c;
                newrate.values[columns[7]]=ValidFromFormat;
            }
            if(String.IsNotEmpty(newrate.values[columns[8]]))
            {
                newrate.fee0.Valid_Until__c=xmlDate(newrate.values[columns[8]]);
                if(newrate.fee0.Valid_Until__c==null)
                    newrate.setError(columns[8]);
                else
                    newRate.values[columns[8]]=newrate.fee0.Valid_Until__c.format();
            }   
            else
            {
                newrate.fee0.Valid_Until__c=filter.Valid_Until__c;
                newrate.values[columns[8]]=ValidToFormat;
            }
            if(String.IsNotEmpty(newrate.values[columns[11]]))
            {          
                classCurrency money = xmlCurrency(newrate.values[columns[11]]);            
                if(money==null)
                    newrate.setError(columns[11]);
                else
                {
                    newrate.BuyRate=money.Amount;
                    newRate.values[columns[11]]=newrate.BuyRate.format();
                }
                showColumn[11]=true;
            }             
            if(String.IsNotEmpty(newrate.values[columns[12]]))
            {          
                classCurrency money = xmlCurrency(newrate.values[columns[12]]);            
                if(money==null)
                    newrate.setError(columns[12]);
                else
                {
                    newrate.SellRate1=money.Amount;
                    newRate.values[columns[12]]=newrate.SellRate1.format();
                }
                showColumn[12]=true;
            }  
            if(newrate.BuyRate==null && newrate.SellRate1==null) 
            {
                newrate.setError(columns[11]);
                newrate.setError(columns[12]);
                showColumn[11]=true;
                showColumn[12]=true;
            }                              
        }
        return true;
    }
    // convert document uploaded in xml
    private Boolean processstrings()
    {
        strings=new List<String>();
        if(String.IsNotEmpty(sharedStrings))
        {
            Dom.Document domDoc = new Dom.Document();
            try{
                domDoc.load(EncodingUtil.base64Decode(sharedStrings).toString());
                Dom.XMLNode root = domDoc.getRootElement();
                Integer counter=0;
                Integer cpuLimit=Limits.getLimitCpuTime()*95/100;
                Integer heapLimit=Limits.getLimitHeapSize()*95/100;
                if(root.getName()=='sst')
                    for(Dom.XMLNode b : root.getChildElements())
                        for(Dom.XMLNode c : b.getChildElements())
                        {
                            if(++counter>50 || Test.isRunningTest())
                            {
                                counter=0;
                                if((Limits.getHeapSize()>heapLimit)||(Limits.getCpuTime()>cpuLimit))
                                {
                                    strings.clear();
                                    if(Limits.getHeapSize()>heapLimit)
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL3)'));
                                    else
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many lines to process (TL4)'));
                                    return false;
                                }
                            }
                            strings.add(c.getText());
                        }
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File is corrupted (FC4)'));
            }
        }
        stringsize=strings.size();
        return true;
    }
     //read document converted to xml
    private String xmlValue(Dom.XMLNode node)
    {
        for(Dom.XMLNode d:node.getChildElements())
            if(d.getName()=='v')
            {
                String res=d.getText();
                if(String.IsNotEmpty(res))
                    if(node.getAttribute('t', '')=='s')
                    {
                        try
                        {
                            Integer i=Integer.valueOf(res);
                            if((i>=0)&&(i<stringsize))
                                return strings[i];
                        }
                        catch(Exception e){}
                    }
                return res;
            }
        return null;
    }
    private Date xmlDate(String value)
    {
        try
        {
            return Date.newInstance(1899, 12, 30).addDays(Integer.valueOf(value));
        }
        catch(Exception e){}
        return null;
    }
    private Decimal xmlDecimal(String value)
    {
        try
        {
            return Decimal.valueOf(value);
        }
        catch(Exception e){}
        return null;
    }
    public class classCurrency
    {
        public String CurrencySymbol;
        public Decimal Amount;
    }
    private classCurrency xmlCurrency(String value)
    {
        classCurrency res=new classCurrency();
        String[] mydata=value.split(' ');
        try
        {            
            if(mydata.size()==1)
                res.Amount=Decimal.valueOf(value);
            else if(mydata.size()==2)
            {
                if(xmlDecimal(mydata[0])>0)
                    res.Amount=Decimal.valueOf(mydata[0]);
                else
                    res.Amount=Decimal.valueOf(mydata[1]);
            }
            return res;
        }
        catch(Exception e){}
        return null;
    }
    //create records with data of xml
    public PageReference saveLines()
    {
        //extract data again
        if(!extractData(false))
            return null;
        if(ratesDataNumber==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No data to save'));
            if(ratesData.size()>1000 || Test.isRunningTest())
            {
                ratesData=null;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Too many lines to show on this screen'));
            }
            return null;
        }
        Set<String>routes=new Set<String>();
        //check errors
        for(rateData cdata:ratesData)
        {
            if(cdata.errorsNumber>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There are one or more errors in data. Please review'));
                if(ratesData.size()>1000 || Test.isRunningTest())
                {
                    ratesData=null;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Too many lines to show on this screen'));
                }
                return null;
            }           
        }
        //execute inserts
        Savepoint sp=Database.setSavepoint();       
        try{
            List<Fee__c>fees=new List<Fee__c>();
            for(rateData cdata:ratesData)
            {
                //Copy data old rates
                if(cdata.fee0.Id!=null)
                {
                    if(cdata.fee0.Route__r!=null)
                        cdata.fee0.Route__c=cdata.fee0.Route__r.Id;
                    else
                        cdata.fee0.Route__c=null;
                }
                //Copy data new rates
                else
                {
                    if(cdata.fee0.Route__r!=null)
                        cdata.fee0.Route__c=cdata.fee0.Route__r.Id;
                    cdata.fee0.RecordTypeID=recordTypeID;
                }
                //Copy data all rates
                NEU_CurrencyUtils.setCurrencyISOCode(cdata.fee0,NEU_CurrencyUtils.getCurrencyISOCode(filter));
                cdata.fee0.Name=cdata.values[columns[0]];
                cdata.fee0.Carrier_Account__c=cdata.CarrierID;
                cdata.fee0.SAP_Service_Type__c = (cdata.SapstID != null ? cdata.SapstID : null);
                cdata.fee0.Group__c = (cdata.SapGroup != null ? cdata.SapGroup : '');
                cdata.fee0.Fee_Description__c=cdata.values[columns[10]];
                cdata.fee0.Buy_Rate__c=cdata.BuyRate;
                cdata.fee0.Fee_Rate__c=cdata.SellRate1;    
                cdata.fee0.Fee_Category__c=filter.Fee_Category__c;  
                cdata.fee0.Distance__c=cdata.values[columns[39]];
                cdata.fee0.Volume__c=cdata.values[columns[40]];
                cdata.fee0.Weight__c=cdata.values[columns[35]];   
                cdata.fee0.Comments__c=cdata.values[columns[21]];      
                cdata.fee0.Active__c=true;

                fees.add(cdata.fee0);
            }
            if(fees.size()>0)
            {
                upsert fees;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,String.valueOf(ratesDataNumber)+' lines updated ('+String.valueOf(fees.size())+')'));
        }
        catch(Exception e)
        {
            Database.rollback(sp);
        }
        if(ratesData.size()>1000 || Test.isRunningTest())
        {
            ratesData=null;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Too many lines to show on this screen'));
        }
        return null;
    }
}