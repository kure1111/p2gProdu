public with sharing class NEU_Freight_Rates_Emails_save_pdf
{
    public Document documento_asociado
    {
        get
            {
                if (documento_asociado == null)
                    documento_asociado = new Document();
                return documento_asociado;
            }
        set;
    }
    public void updateFilters()
        {
            Boolean required = false;

            //Required Account for
            if(String.isEmpty(String.valueOf(filter.Account_for__c)))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Account for: You must enter a value'));
                required = true;
            }

            //Valid From and Valid Until
            //if(String.isEmpty(String.valueOf(filter.Valid_From__c)) || String.isEmpty(String.valueOf(filter.Valid_Until__c)))
            if(String.isEmpty(String.valueOf(filter.Valid_Until__c)))
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Valid From/Valid Until: You must enter a value'));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Valid Until: You must enter a value'));
                required = true;
            }else
            {
                if(filter.Valid_From__c > filter.Valid_Until__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Valid Until must be greater or equal than Valid From'));
                    required = true;
                }
            }

            if(!required)
            {
                querystring=null;

                //Save Rates Selection in Session Caché
                SaveSessionFeesReport();
            }
        }
    public String documentName
    {
        get
            {
                if(documentName==null)
                    documentName=NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('name'));
                return documentName;
            }
        set;
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

    public String filterRateTypeFreights {get;set;}

    public List<SelectOption>RateTypeList
    {
        get
            {
                if(RateTypelist==null)
                {
                    RateTypelist=new List<SelectOption>();
                    String none = '--None--';
                    RateTypelist.add(new SelectOption(none,none));
                    //List<string> pickListSimple = NEU_Utils.getPicklistSimple('Fee__c', 'Rate_Type__c');
                    List<string> pickListSimple = NEU_Utils.getPicklistSimple('Fee__c', 'Rate_Type__c');
                    for(String pv : pickListSimple)
                        {
                            RateTypelist.add(new SelectOption(pv,pv));
                        }
                }

                return RateTypelist;
            }
        set
            {
                if(RateTypeList!=value)
                    RateTypeList=value;
            }
    }

    public Country__c loadFilter
    {
        get
            {
                if(loadFilter==null)
                    loadFilter=new Country__c();
                return loadFilter;
            }
        set;
    }
    public Country__c dischargeFilter
    {
        get
            {
                if(dischargeFilter==null)
                    dischargeFilter=new Country__c();
                return dischargeFilter;
            }
        set;
    }

    public Fee__c filter {get;set;}

    public Integer BuySell{ get { if(BuySell==null) BuySell=1; return BuySell; } set;}

    public List<SelectOption>buyselllist
    {
        get
            {
                if(buyselllist==null)
                {
                    buyselllist=new List<SelectOption>();
                    buyselllist.add(new SelectOption('1','Buy Rate'));
                    buyselllist.add(new SelectOption('2','Sell Rate'));
                    buyselllist.add(new SelectOption('3','Buy & Sell Rate'));
                }
                return buyselllist;
            }
        set
            {
                if(buyselllist!=value)
                    buyselllist=value;
            }
    }

    public List<customFees_s>feesReport
    {
        get
            {
                if(feesReport==null)
                {
                    try{
                        feesReport = new List<customFees_s>();
                        String ra_ct = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('ra_ct'));

                        //List<string> pickListSimple = NEU_Utils.getPicklistSimple('Fee__c', 'Fee_Category__c');
                        List<string> pickListSimple = NEU_Utils.getPicklistSimple('NEUEBUSCM__Fee__c', 'Fee_Category__c');
                        for(String pv : pickListSimple)
                            {
                                Boolean activeCategory = false;
                                if(String.IsNotEmpty(ra_ct) && ra_ct.equals(pv))
                                {
                                    activeCategory = true;
                                }
                                feesReport.add(new customFees_s(activeCategory, pv));
                            }
                    }catch (Exception e) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+e));
                    }
                }
                return feesReport;

            }
        set
            {
                if(feesReport!=value)
                    feesReport=value;
            }
    }

    public class customFees_s
    {
        public Boolean selectedFee {get;set;}
        public String NameFee {get;set;}

        public customFees_s (Boolean selectedFee, String NameFee)
            {
                this.selectedFee = selectedFee;
                this.NameFee = NameFee;
            }
    }

    public NEU_Freight_Rates_Emails_save_pdf()
        {

            //Get Data of Freights Rates Management
            filter=new Fee__c();
            filter.Route__r=new Carrier_Line_Load_Point__c();
            String id_af = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('id_af'));
            if(String.isNotEmpty(id_af))
                filter.Account_for__c= id_af;
            filter.Route__r=new Carrier_Line_Load_Point__c();
            BuySell = NEU_Utils.safeInteger(ApexPages.currentPage().getParameters().get('rt_ct'));//Show Rates (BuySell)

            //Currency
            String isoc = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('isoc'));
            if(String.isNotEmpty(isoc))
                filterCurrencyISOCode = isoc;

            //Rates Categories
            String ra_ct = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('ra_ct'));
            if(String.isNotEmpty(ra_ct))
                filter.Fee_Category__c =  ra_ct;

            String rt_ty= NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('rt_ty'));//Rate Type
            if(String.isNotEmpty(rt_ty))
                filterRateTypeFreights = rt_ty;

            //Carrier
            String id_ca = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('id_ca'));
            if(String.isNotEmpty(id_ca))
                filter.Carrier_Account__c = id_ca;

            //Valid From and Valid until
            String va_fr = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('va_fr'));//Valid From;
            String va_un = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('va_un'));//Valid Until;
            if(String.IsNotEmpty(va_fr))
                filter.Valid_From__c = date.parse(va_fr);
            if(String.IsNotEmpty(va_un))
                filter.Valid_Until__c= date.parse(va_un);

            //Regions
            String re_lo = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('re_lo'));
            if(String.IsNotEmpty(re_lo))
                loadFilter.Region__c = re_lo;

            String re_dc = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('re_dc'));
            if(String.IsNotEmpty(re_dc))
                dischargeFilter.Region__c = re_dc;

            //Contries
            String co_lo = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('co_lo'));
            if(String.IsNotEmpty(co_lo))
                filter.Route__r.Country_of_Load__c = co_lo;

            String co_dc = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('co_dc'));
            if(String.IsNotEmpty(co_dc))
                filter.Route__r.Country_of_Discharge__c = co_dc;

            //Sites
            String st_ld = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('st_ld'));
            if(String.IsNotEmpty(st_ld))
                filter.Route__r.Port_Airport_of_Load__c = st_ld;

            String st_dc = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('st_dc'));
            if(String.IsNotEmpty(st_dc))
                filter.Route__r.Port_Airport_of_Discharge__c = st_dc;

        }

    public void SaveSessionFeesReport()
        {
            if(feesReport != null && feesReport.size()>0)
            {
                try
                {
                    if(feesReport != null && feesReport.size()>0)
                        Cache.Session.put('RatesSelection', JSON.serialize(feesReport));//Rate filter is sent per session
                }catch (Exception e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'SAVE SESSION:'+e));
                }
            }
        }

    /*Search URL*/
    public String queryString
    {
        get
            {
                if(queryString==null)
                {
                    queryString = '?';
                    queryString += 'id_af=' + (filter.Account_for__c != null ? neu_utils.safestring(filter.Account_for__c) : '');//Account for
                    queryString += '&rt_ct=' + (BuySell > 0 ? neu_utils.safestring(BuySell) : '');//Show Rates (BuySell)
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    //It's Necessary for 1st load
                    queryString += '&ra_ct=' + EncodingUtil.urlEncode(ApexPages.currentPage().getParameters().get('ra_ct'),'UTF-8');//Rate Category
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    queryString += '&isoc='  + (!String.isEmpty(filterCurrencyISOCode) ? neu_utils.safestring(filterCurrencyISOCode) : '');//Currency
                    queryString += '&rt_ty='  + (filterRateTypeFreights != null &&  filterRateTypeFreights != '--None--' ? EncodingUtil.urlEncode(filterRateTypeFreights,'UTF-8') : '');//Rate Type
                    queryString += '&id_ca=' + (filter.Carrier_Account__c != null ? neu_utils.safestring(filter.Carrier_Account__c) : '');//Id Carrier
                    queryString += '&va_fr=' + (filter.Valid_From__c != null ? EncodingUtil.urlEncode(filter.Valid_From__c.format(),'UTF-8') : '');//Valid From
                    queryString += '&va_un=' + (filter.Valid_Until__c != null ? EncodingUtil.urlEncode(filter.Valid_Until__c.format(),'UTF-8') : '');//Valid Until
                    queryString += '&re_lo=' + (loadFilter.Region__c != null ? neu_utils.safestring(loadFilter.Region__c) : '');//Region of Load
                    queryString += '&re_dc=' + (dischargeFilter.Region__c != null ? neu_utils.safestring(dischargeFilter.Region__c) : '');//Region of Discharge
                    queryString += '&co_lo=' + (filter.Route__r.Country_of_Load__c != null ? neu_utils.safestring(filter.Route__r.Country_of_Load__c) : '');//Country of Load
                    queryString += '&co_dc=' + (filter.Route__r.Country_of_Discharge__c != null ? neu_utils.safestring(filter.Route__r.Country_of_Discharge__c) : '');//Country of Discharge
                    queryString += '&st_ld=' + (filter.Route__r.Port_Airport_of_Load__c != null ? neu_utils.safestring(filter.Route__r.Port_Airport_of_Load__c) : '');//Site of Load
                    queryString += '&st_dc=' + (filter.Route__r.Port_Airport_of_Discharge__c != null ? neu_utils.safestring(filter.Route__r.Port_Airport_of_Discharge__c) : '');//Site of Discharge
                    queryString += '&name=' + (String.isNotEmpty(documentName) ? EncodingUtil.urlEncode(documentName, 'UTF-8') : '');//Name Document
                }
                return queryString;
            }
        set;
    }


    public PageReference crear()
        {
            Boolean required = false;

            //Required Name of Document
            if(String.isEmpty(documentName))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Document Name: You must enter a value'));
                required = true;
            }
            //Required Account for
            if(String.isEmpty(String.valueOf(filter.Account_for__c)))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Account for: You must enter a value'));
                required = true;
            }

            //Valid From and Valid Until
            //if(String.isEmpty(String.valueOf(filter.Valid_From__c)) || String.isEmpty(String.valueOf(filter.Valid_Until__c)))
            if(String.isEmpty(String.valueOf(filter.Valid_Until__c)))
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Valid From/Valid Until: You must enter a value'));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Valid Until: You must enter a value'));
                required = true;
            }else
            {
                if(filter.Valid_From__c > filter.Valid_Until__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Valid Until must be greater or equal than Valid From'));
                    required = true;
                }
            }

            //Required Service rate
            if(feesReport != null && feesReport.size()>0)
            {
                Integer conGlobal = 0;
                for(customFees_s cfs: feesReport)
                {
                    if(cfs.selectedFee)
                        conGlobal++;
                }
                if(conGlobal == 0)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Rates Selection: You must choose some Rate Name value'));
                    required = true;
                }
            }

            if(required)
                return null;

            PageReference pdf = null;
            pdf = Page.NEU_Freight_Rates_Emails_pdf;

            pdf.getParameters().put('id_af', NEU_Utils.safeString(filter.Account_for__c));//Account for
            pdf.getParameters().put('rt_ct', (BuySell > 0 ? neu_utils.safestring(BuySell) : ''));//Show Rates (BuySell);//Show Rates (BuySell)

            try
            {
                if(feesReport != null && feesReport.size()>0)
                    Cache.Session.put('RatesSelection', JSON.serialize(feesReport));//Rate filter is sent per session
            }catch (Exception e)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'CREATE PDF:'+e));
            }
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //It's Necessary for 1st load
            pdf.getParameters().put('ra_ct',  neu_utils.safestring(ApexPages.currentPage().getParameters().get('ra_ct')));//Currency
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            pdf.getParameters().put('isoc',  (!String.isEmpty(filterCurrencyISOCode) ? neu_utils.safestring(filterCurrencyISOCode) : ''));//Currency
            pdf.getParameters().put('rt_ty', (filterRateTypeFreights != null &&  filterRateTypeFreights != '--None--' ? neu_utils.safestring(filterRateTypeFreights) : ''));//Rate Type
            pdf.getParameters().put('id_ca', (filter.Carrier_Account__c != null ? neu_utils.safestring(filter.Carrier_Account__c) : ''));//Id Carrier
            pdf.getParameters().put('va_fr', (filter.Valid_From__c != null ? neu_utils.safestring(filter.Valid_From__c.format()) : ''));//Valid From
            pdf.getParameters().put('va_un', (filter.Valid_Until__c != null ? neu_utils.safestring(filter.Valid_Until__c.format()) : ''));//Valid Until
            pdf.getParameters().put('re_lo', (loadFilter.Region__c != null ? neu_utils.safestring(loadFilter.Region__c) : ''));//Region of Load
            pdf.getParameters().put('re_dc', (dischargeFilter.Region__c != null ? neu_utils.safestring(dischargeFilter.Region__c) : ''));//Region of Discharge
            pdf.getParameters().put('co_lo', (filter.Route__r.Country_of_Load__c != null ? neu_utils.safestring(filter.Route__r.Country_of_Load__c) : ''));//Country of Load
            pdf.getParameters().put('co_dc', (filter.Route__r.Country_of_Discharge__c != null ? neu_utils.safestring(filter.Route__r.Country_of_Discharge__c) : ''));//Country of Discharge
            pdf.getParameters().put('st_ld', (filter.Route__r.Port_Airport_of_Load__c != null ? neu_utils.safestring(filter.Route__r.Port_Airport_of_Load__c) : ''));//Site of Load
            pdf.getParameters().put('st_dc', (filter.Route__r.Port_Airport_of_Discharge__c != null ? neu_utils.safestring(filter.Route__r.Port_Airport_of_Discharge__c) : ''));//Site of Discharge
            pdf.getParameters().put('name',  (String.isNotEmpty(documentName) ? documentName : ''));//Document Name

            Blob body;
            try
            {
                body = pdf.getContent();
            } catch (Exception e)
            {
                body = Blob.valueOf('Some Text');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+e));
                return null;
            }
            //Get Name Folder
            try
            {
                List<Folder> directorio = new List<Folder>();
                directorio = [Select Id, Name from Folder where Name =:'Price Lists'];
                documento_asociado.Body = body;
                documento_asociado.Name = documentName+'.pdf';
                documento_asociado.AuthorId = UserInfo.getUserId();
                if(directorio.size()>0)
                    documento_asociado.FolderId = directorio[0].Id;
                documento_asociado.IsPublic = true;
            }catch (Exception e)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+e));
                return null;
            }

            //Create Document PDF
            try
            {
                insert documento_asociado;
            }
            catch (Exception e)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+e));
                return null;
            }


            Associated_Document__c new_document = new Associated_Document__c();
            new_document.Account__c = filter.Account_for__c;
            new_document.Name = documentName+'.pdf';
            new_document.Document_Type__c = 'Price List';
            new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId();

            //Create Associated Document with Account for
            try
            {
                insert new_document;
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
            }

            //Clear Caché Session
            try
            {
                Cache.Session.put('RatesSelection', null);//Rate filter is sent per session
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
            }

            //Return Page Send Document
            try
            {
                PageReference p=Page.NEU_Freight_Rates_Send_Emails;
                p.getParameters().put('document_id',String.valueOf(new_document.Id));
                p.getParameters().put('object_select','account');
                p.getParameters().put('object_id',String.valueOf(new_document.Account__c));
                return p;
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
                return null;
            }
        }
}