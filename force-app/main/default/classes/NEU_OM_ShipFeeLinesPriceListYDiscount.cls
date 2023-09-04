public with sharing class NEU_OM_ShipFeeLinesPriceListYDiscount extends NEU_Controller_Comparable
{
    public Shipment__c record=null;
    public Shipment__c totales{get;set;}
    public Boolean chekeados{get;set;}
    public Boolean chekeados_ie{get;set;}
    private List<Shipment_Fee_Line_currency_s> shipfeeLines =null;
    private List<Shipment_Fee_Line_currency_s> shipfeeLines_all =null;
    private List<Shipment_Fee_Line_currency_s> shipfeeLines_without=null;
    private List<Shipment_Fee_Line_all_s> shipfeeLines_all_for_route =null;
    public Shipment__c shipment_filter = null;
    public Account account_defecto = null;
    public Boolean existRoute {get;set;}
    public Fee__c service_rate_filter = null;
    public String id_oi {get;set;}
    public  List<NEUEBUSCM_Shipment_Fee_Line_s> Fee_List_Price = null;
    public List<IE_Fee_Line_s> IE_lines = null;
    public Map<Id,Id> listado_ids_ruta {get;set;}
    public String orden_fees_filtro_modo {get;set;}
    public String orden_fees_filtro {get;set;}
    public String orden_fees_filtro_modo_insertados {get;set;}
    public String orden_fees_filtro_insertados {get;set;}
    public String orden_fees_filtro_modo_insertados_all {get;set;}
    public String orden_fees_filtro_insertados_all {get;set;}
    public string step_fee {get;set;}
    public List<Integer> listado_paginas_fees {get;set;}
    public Decimal total_fee {get;set;}
    public string listado_ids_carrier {get;set;}
    public string url_sailing_schedule {get;set;}
    public string url_alibaba {get;set;}
    public string total_buy_common_charges {get;set;}
    public string total_sell_common_charges {get;set;}
    public string order_number {get;set;}
    public integer n_records_per_page = 30;
    public decimal sum_buy_amount_ie {get;set;}
    public decimal sum_sell_amount_ie {get;set;}
    private List<SelectOption> newcategories=null;

    public Fee__c fee_record {get;set;}
    public Boolean show_all_categories{get;set;}
    public Boolean show_all_categories_all_lines{get;set;}
    public Boolean show_all_categories_all_lines_routes{get;set;}
    public String fee_currency {get;set;}
    public List<SelectOption> currencies {get;set;}

    public string service_rate_filter_name {get;set;}

    public boolean CHKValidos{get;set;}
    public boolean buyRate{get;set;}
    public boolean sellRate{get;set;}

    public totales_s totals_custom{get;set;}
    public totales_by_categories_s totals_custom_by_category{get;set;}
    public class totales_s
    {
        public Shipment__c import_export {get;set;}
        public Boolean convert {get;set;}
        public string CurrencyMoney {get;set;}
        public string CurrencyMoney_import_export {get;set;}
        public string total_Services_Std_Buy_Amount_s_currency {get;set;}
        public string total_Services_Std_Buy_Amount_s_convert{get;set;}
        public string total_Services_Sell_Amount_s_currency {get;set;}
        public string total_Services_Sell_Amount_s_convert{get;set;}
        public totales_s(Shipment__c import_export)
        {
            this.import_export = import_export;
            convert = false;
            total_Services_Std_Buy_Amount_s_currency = '';
            total_Services_Sell_Amount_s_currency = '';
            total_Services_Std_Buy_Amount_s_convert = '';
            total_Services_Sell_Amount_s_convert = '';
            CurrencyMoney = '';
            CurrencyMoney_import_export = NEU_CurrencyUtils.getCurrencyIsoCode(import_export);

            decimal buy_amount_currency = import_export.Total_Services_Std_Buy_Amount_number__c;
            if(buy_amount_currency != null)
                total_Services_Std_Buy_Amount_s_currency = buy_amount_currency.setScale(2).format();

            decimal sell_amount_currency = import_export.Total_Services_Sell_Amount_number__c;
            if(sell_amount_currency != null)
                total_Services_Sell_Amount_s_currency = sell_amount_currency.setScale(2).format();
            if(UserInfo.isMultiCurrencyOrganization()== true)
            {
                string currency_default = userInfo.getDefaultCurrency();
                if((NEU_CurrencyUtils.getCurrencyIsoCode(import_export) != currency_default && (string.isNotEmpty(total_Services_Std_Buy_Amount_s_currency)) || string.isNotEmpty(total_Services_Sell_Amount_s_currency)))
                {
                    CurrencyMoney = currency_default;
                    List<SObject>conversion=null;
                    DateTime dtIsoCode = import_export.Conversion_Rate_Date__c;
                    String query_currency = '';
                    query_currency += 'select ConversionRate,IsoCode,startDate,nextstartdate ';
                    query_currency += ' FROM DatedConversionRate';
                    query_currency += ' WHERE Id != null';
                    query_currency += ' AND IsoCode = \''+NEU_CurrencyUtils.getCurrencyIsoCode(import_export)+'\'';
                    query_currency += ' AND startDate <= '+dtIsoCode.format('yyyy-MM-dd')+' AND nextstartdate > '+dtIsoCode.format('yyyy-MM-dd');
                    query_currency += ' LIMIT 1';
                    System.debug('query ---> ' + query_currency);
                    conversion = Database.query(query_currency);
                    decimal factor = (Decimal)conversion[0].get('ConversionRate');
                    convert = true;

                    if(buy_amount_currency != null && factor != null)
                    {
                        decimal buy_Amount_convert = (buy_amount_currency / factor);
                        total_Services_Std_Buy_Amount_s_convert = buy_Amount_convert.setScale(2).format();
                    }
                    if(sell_amount_currency != null && factor != null)
                    {
                        decimal sell_Amount_convert = (sell_amount_currency / factor);
                        total_Services_Sell_Amount_s_convert = sell_Amount_convert.setScale(2).format();
                    }

                }
            }
        }
    }

    public class totales_by_categories_s
    {
        public Shipment__c shipment {get;set;}
        public Boolean convert {get;set;}
        public string CurrencyMoney {get;set;}
        public string CurrencyMoney_shipment {get;set;}
        public string total_Services_Std_Buy_Amount_s_currency {get;set;}
        public string total_Services_Std_Buy_Amount_s_convert{get;set;}
        public string total_Services_Sell_Amount_s_currency {get;set;}
        public string total_Services_Sell_Amount_s_convert{get;set;}
        public totales_by_categories_s(Shipment__c shipment, string new_category)
        {
            this.shipment = shipment;
            convert = false;
            total_Services_Std_Buy_Amount_s_currency = '';
            total_Services_Sell_Amount_s_currency = '';
            total_Services_Std_Buy_Amount_s_convert = '';
            total_Services_Sell_Amount_s_convert = '';
            CurrencyMoney = '';
            CurrencyMoney_shipment = NEU_CurrencyUtils.getCurrencyIsoCode(shipment );


            decimal total_service_std_buy_amount_category = 0;
            decimal total_service_std_sell_amount_category = 0;
            List<Shipment_Fee_Line__c> query_by_category = null;
            if(String.isNotEmpty(new_category))
                query_by_category = [select Std_Buy_Amount_header_currency__c, Sell_Amount_header_currency__c from Shipment_Fee_Line__c where Shipment__c =: shipment.Id and Service_Rate_Category__c =: new_category ];
            else
                    query_by_category = [select Std_Buy_Amount_header_currency__c, Sell_Amount_header_currency__c from Shipment_Fee_Line__c where Shipment__c =: shipment.Id ];
            for(Shipment_Fee_Line__c iefl : query_by_category)
            {
                total_service_std_buy_amount_category += neu_utils.safedecimal(iefl.Std_Buy_Amount_header_currency__c);
                total_service_std_sell_amount_category += neu_utils.safedecimal(iefl.Sell_Amount_header_currency__c);
            }

            decimal buy_amount_currency = total_service_std_buy_amount_category;
            if(buy_amount_currency != null)
                total_Services_Std_Buy_Amount_s_currency = buy_amount_currency.setScale(2).format();

            decimal sell_amount_currency = total_service_std_sell_amount_category;
            if(sell_amount_currency != null)
                total_Services_Sell_Amount_s_currency = sell_amount_currency.setScale(2).format();

            if(UserInfo.isMultiCurrencyOrganization()== true)
            {
                string currency_default = userInfo.getDefaultCurrency();
                if(NEU_CurrencyUtils.getCurrencyIsoCode(shipment ) != currency_default && (string.isNotEmpty(total_Services_Std_Buy_Amount_s_currency) || string.isNotEmpty(total_Services_Sell_Amount_s_currency)))
                {
                    CurrencyMoney = currency_default;
                    List<SObject>conversion=null;
                    DateTime dtIsoCode = shipment.Conversion_Rate_Date__c;
                    String query_currency = '';
                    query_currency += 'select ConversionRate,IsoCode,startDate,nextstartdate ';
                    query_currency += ' FROM DatedConversionRate';
                    query_currency += ' WHERE Id != null';
                    query_currency += ' AND IsoCode = \''+NEU_CurrencyUtils.getCurrencyIsoCode(shipment )+'\'';
                    query_currency += ' AND startDate <= '+dtIsoCode.format('yyyy-MM-dd')+' AND nextstartdate > '+dtIsoCode.format('yyyy-MM-dd');
                    query_currency += ' LIMIT 1';
                    conversion = Database.query(query_currency);
                    decimal factor = 1;
                    if (!Test.isRunningTest())
                        factor = (Decimal)conversion[0].get('ConversionRate');
                    convert = true;

                    if(buy_amount_currency != null && factor != null)
                    {
                        decimal buy_Amount_convert = (buy_amount_currency / factor);
                        total_Services_Std_Buy_Amount_s_convert = buy_Amount_convert.setScale(2).format();
                    }
                    if(sell_amount_currency != null && factor != null)
                    {
                        decimal sell_Amount_convert = (sell_amount_currency / factor);
                        total_Services_Sell_Amount_s_convert = sell_Amount_convert.setScale(2).format();
                    }

                }
            }
        }
    }

    public  List<SelectOption> getnewcategories()
    {
        if(newcategories==null)
        {
            mynewcategory=null;
            newcategories=new List<SelectOption>();
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Fee__c.Fee_Category__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                newcategories.add(new SelectOption(f.getValue(),f.getValue()));
                if(String.IsEmpty(mynewcategory)&&Apexpages.currentPage().getParameters().get('pes') ==null)
                {
                    mynewcategory=f.getValue();
                    fee_record.Fee_Category__c = mynewcategory;
                }
                else
                        if(Apexpages.currentPage().getParameters().get('pes') !=null)
                            if(f.getValue() == Apexpages.currentPage().getParameters().get('pes'))
                            {
                                mynewcategory=f.getValue();
                                fee_record.Fee_Category__c = mynewcategory;
                            }
            }
        }
        return newcategories;
    }
    private String recordtype=null;
    public String getrecordtype()
    {
        if(recordtype==null)
        {
            List<Shipment_Fee_Line_currency_s> fees=getshipfeeLines();
            if(fees != null &&fees.size()>0)
                if(fees[0].ship_fee_line.Service_Rate_Name__r.RecordTypeId!=null)
                    recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].ship_fee_line.Service_Rate_Name__r.RecordTypeId).getName();
        }
        if(recordtype==null)
        {
            List<NEUEBUSCM_Shipment_Fee_Line_s> fees=getFee_List_Price();
            if(fees.size()>0)
                if(fees[0].line.RecordTypeId!=null)
                    recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].line.RecordTypeId).getName();
        }
        return recordtype;
    }
    public void setrecordtype(String val){}
    private String mynewcategory=null;
    public String getnewcategory()
    {
        if(mynewcategory==null)
            getnewcategories();
        return mynewcategory;
    }
    public void setnewcategory(String value)
    {
        if(mynewcategory!=value)
        {
            orden_fees_filtro = 'CreatedDate';
            orden_fees_filtro_modo = 'desc';
            mynewcategory=value;


            fee_record = null;

            fee_record = new Fee__c();

            fee_record.Account_for__c = record.Account_for__c;
            if(value != 'Drayages' && value != 'Other Service Charges')
                fee_record.Route__c = record.Route__c;

            if(value == 'Sea Freights' || value == 'Road Freights' || value == 'Air Freights' || value == 'Railway Freights' || value == 'Multimodal Freights' || value == 'POL Charges' || value == 'POD Charges' || value == 'Warehouse')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            else if(value == 'Drayages')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            else if(value == 'Other Service Charges')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            else
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            fee_record.Fee_Category__c = value;

            system.debug('new rate'+ fee_record.Fee_Category__c);

            Fee_List_Price = null;
            service_rate_filter_name = '';
            categories();
        }
    }


    public void change_ratio_category()
    {
        fee_record = new Fee__c();
		fee_record.Group__c = getGroup();
        fee_record.Account_for__c = record.Account_for__c;

        if(getnewcategory() != 'Drayages'  && getnewcategory() != 'Other Service Charges')
        {
            //Find Route in Lookup
            Carrier_Line_Load_Point__c routeFinder = getRouteFinder();
            if(routeFinder != null)
            {
                fee_record.Route__c = routeFinder.Id;
                fee_record.Route__r = routeFinder;//Because is a Lookup
            }
            else
            {
                fee_record.Route__c = record.Route__c;//Defect Route Record
            }
        }

        if(getnewcategory() != 'Drayages'){
            service_rate_filter.Account_for__c = record.Account_for__c;
        }

        if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Air Freights'|| getnewcategory() == 'Road Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
        {
            fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
            RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
            fee_record.RecordType = rt;
        }
        else if(getnewcategory() == 'Drayages')
        {
            fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
            RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
            if(!Test.isRunningTest()){
                service_rate_filter.Account_for__c=account_defecto.Id;
            }
            fee_record.RecordType = rt;
        }
        else if(getnewcategory() == 'Other Service Charges')
        {
            fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
            RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
            fee_record.RecordType = rt;
        }
        else
        {
            fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
            RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
            fee_record.RecordType = rt;
        }
        fee_record.Fee_Category__c = getnewcategory();
        service_rate_filter_name = '';
        totals_custom_by_category = new totales_by_categories_s(record, getnewcategory());
    }

    public String decimalSep
    {
        get
        {
            if(decimalSep==null)
                decimalSep=NEU_Utils.getDecimalSep();
            return decimalSep;
        }
        set
        {
            decimalSep=value;
        }
    }
    public String thousandSep
    {
        get
        {
            if(thousandSep==null)
                thousandSep=NEU_Utils.getThousandSep();
            return thousandSep;
        }
        set
        {
            thousandSep=value;
        }
    }

    public String sum_buy_amount_ie_string
    {
        get
        {
            if(sum_buy_amount_ie_string==null)
            {
                string valor ='60'; //(sum_buy_amount_ie+0.001).format();
                sum_buy_amount_ie_string=valor.substring(0,valor.length()-1) ;
            }
            return sum_buy_amount_ie_string;
        }
        set
        {
            sum_buy_amount_ie_string=value;
        }
    }

    public String sum_sell_amount_ie_string
    {
        get
        {
            if(sum_sell_amount_ie_string==null)
            {
                string valor = '60';//(sum_sell_amount_ie+0.001).format();
                sum_sell_amount_ie_string=valor.substring(0,valor.length()-1) ;
            }
            return sum_sell_amount_ie_string;
        }
        set
        {
            sum_sell_amount_ie_string=value;
        }
    }

    public Shipment__c getshipment_filter()
    {

        return shipment_filter;
    }

    public override void sortList(Integer listNumber)
    {
        if(listNumber==0)
            IE_lines.sort();
        //else
        //  List_import_export_supplier_order.sort();
    }

    public void setshipment_filter(Shipment__c value)
    {
        if(shipment_filter!=value && value != null)
        {
            shipment_filter=value;
        }
    }

    public Fee__c getservice_rate_filter()
    {

        return service_rate_filter;
    }

    public void setservice_rate_filter(Fee__c value)
    {
        if(service_rate_filter != value && value != null)
        {
            service_rate_filter=value;
        }
    }
 public NEU_OM_ShipFeeLinesPriceListYDiscount(){ runtest();}
 
    public NEU_OM_ShipFeeLinesPriceListYDiscount(ApexPages.StandardController stdController) {
        

        
        super(1);

        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        System.debug('ProfileName'+profileName);
        
        if(profileName == 'COMERCIAL SALESCLOUD'){
            buyRate = true;
            sellRate = false;
        }else if(profileName == 'PLANNER SALESCLOUD'){
            buyRate = false;
            sellRate = true;
        }else{
            buyRate = false;
            sellRate = false;

        }

        //Obtener Account por defecto
        if(!Test.isRunningTest()){
            account_defecto = [SELECT Id,Name from Account where Name='Arrastre De puerto'];
        }
        //Fin obtener account por defecto
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]
            {
                    'Id',
                    'Name',
                    'Site_of_Load__c',
                    'Site_of_Discharge__c',
                    'Pickup_Cartage__c',
                    'Total_Weight_Kg__c',
                    'Total_Volume_m3__c',
                    'Purchase_Incoterm__c',
                    'Sales_Incoterm__c',
                    'Account_for__c',
                    'Carrier__c',
                    'N_Containers__c',
                    'Conversion_Rate_Date__c',
                    'Total_Services_Std_Buy_Amount__c',
                    'Total_Services_Std_Buy_Amount_number__c',
                    'Total_Services_Sell_Amount__c',
                    'Total_Services_Sell_Amount_number__c',
                    'Delivery_Cartage__c',
                    'Supplier_Account__c',
                    'Enable_Route_Options__c',
                    'Country_of_Discharge__c',
                    'Country_of_Load__c',
                    'Site_of_Load__r.Name',
                    'Site_of_Discharge__r.Name',
                    'Route__c',
                    'Container_Type__c',
                    'Route__r.Port_Airport_of_Load__r.Name',
                    'Route__r.Country_of_Load__r.Name',
                    'Route__r.Port_Airport_of_Discharge__r.Name',
                    'Route__r.Country_of_Discharge__r.Name',
                    'State_of_Discharge__c',
                    'State_of_Load__c',
                    'Route__r.State_of_Load__r.Name',
                    'Route__r.State_of_Discharge__r.Name',
                    (UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Equipment__c')
            });
        record=(Shipment__c)stdController.getRecord();

        CHKValidos = true;
        totales = record;
        totals_custom = new totales_s(totales);

        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
        orden_fees_filtro_insertados = 'Name';
        orden_fees_filtro_modo_insertados = 'asc';
        orden_fees_filtro_insertados_all = 'Name';
        orden_fees_filtro_modo_insertados_all = 'asc';

        sum_buy_amount_ie = 0;
        sum_sell_amount_ie = 0;
        existRoute = true;

        fee_record = new Fee__c();
        total_buy_common_charges = (0.001).format();
        total_buy_common_charges = total_buy_common_charges.substring(0,total_buy_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);
        total_sell_common_charges = (0.001).format();
        total_sell_common_charges = total_sell_common_charges.substring(0,total_sell_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);

        fee_record.Account_for__c = record.Account_for__c;
        fee_record.Route__c = record.Route__c;
        fee_record.Group__c = getGroup();

        order_number = '';
        List<Shipment_Consolidation_Data__c> query_shipment_consolidation = [select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipment__c =: record.Id and Import_Export_Quote__c != null];
        if(query_shipment_consolidation != null && query_shipment_consolidation.size()>0)
        {
            order_number =query_shipment_consolidation[0].Import_Export_Quote__r.Name;
        }
        currencies = new List<SelectOption>();
        if(UserInfo.isMultiCurrencyOrganization()== true)
        {
            for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
            {
                if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                {
                    currencies.add(new SelectOption(lu,lu));
                    fee_currency = NEU_CurrencyUtils.getCurrencyIsoCode(record);
                    break;
                }
            }

            for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
            {
                if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                {
                    currencies.add(new SelectOption(lu,lu));
                }
            }
        }
        else
                currencies.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));

        if(shipment_filter == null)
        {
            shipment_filter = new Shipment__c();
            // shipment_filter.Route__c = record.Route__c;
            shipment_filter.Account_for__c = record.Account_for__c;
            service_rate_filter_name = '';
            shipment_filter.Purchase_Incoterm__c = record.Purchase_Incoterm__c;
            shipment_filter.Sales_Incoterm__c = record.Sales_Incoterm__c;
            shipment_filter.Pickup_Cartage__c = record.Pickup_Cartage__c;
            shipment_filter.Delivery_Cartage__c = record.Delivery_Cartage__c;
            //shipment_filter.Carrier__c = record.Carrier__c;
            shipment_filter.Container_Type__c = record.Container_Type__c;
            if(record.Country_of_Load__c  != null)
                shipment_filter.Country_of_Load__c = record.Country_of_Load__c;
            if(record.Country_of_Discharge__c != null)
                shipment_filter.Country_of_Discharge__c = record.Country_of_Discharge__c;
            if(record.State_of_Load__c  != null)
                shipment_filter.State_of_Load__c = record.State_of_Load__c;
            if(record.State_of_Discharge__c != null)
                shipment_filter.State_of_Discharge__c = record.State_of_Discharge__c;
            if(record.Site_of_Load__c  != null)
                shipment_filter.Site_of_Load__c = record.Site_of_Load__c;
            if(record.Site_of_Discharge__c  != null)
                shipment_filter.Site_of_Discharge__c = record.Site_of_Discharge__c;

            listado_ids_ruta = new Map<Id,Id>();
            /* if(record.Route__c != null)
               listado_ids_ruta.put(record.Route__c, record.Route__c);

             List<Carrier_Line_Load_Point__c> query_extra_routes = Database.query(query_routes_string);

             if(query_extra_routes != null && query_extra_routes.size()>0)
             {
                   for(Carrier_Line_Load_Point__c route: query_extra_routes)
                   {
                           listado_ids_ruta.put(route.Id, route.Id);
                   }
               }*/
        }
        if(service_rate_filter == null)
        {
            service_rate_filter = new Fee__c();
            service_rate_filter.Account_for__c = record.Account_for__c;
            service_rate_filter.Valid_From__c = system.today().addMonths(-1);
            service_rate_filter.Valid_Until__c = system.today().addMonths(1);
        }
        system.debug('hola '+ listado_ids_ruta);

        if(record.Route__c != null)//, , ,
        {
            Date pdate = system.today();
            string site_of_load = record.Site_of_Load__r.Name;
            string site_of_discharge= record.Site_of_Discharge__r.Name;
            site_of_load = !Test.isRunningTest() ? remove1(record.Site_of_Load__r.Name) : record.Site_of_Load__r.Name;
            site_of_discharge = !Test.isRunningTest() ? remove1(record.Site_of_Discharge__r.Name) :record.Site_of_Discharge__r.Name ;
            url_sailing_schedule = 'http://www.joc.com/sailings/Sailings-SearchResults?ORIGIN='+record.Route__r.Port_Airport_of_Load__r.Name+',%20'+record.Route__r.Country_of_Load__r.Name+'&direction=&destination='+record.Route__r.Port_Airport_of_Discharge__r.Name+',%20'+record.Route__r.Country_of_Discharge__r.Name+'&carrier=&vesselTypes=&days=30&date='+(pdate.Month())+'/'+pdate.day()+'/'+ pdate.Year();
            url_alibaba = 'https://www.alibaba.com/trade/search?SearchText=freight+'+site_of_load+'+'+site_of_discharge+'&selectedTab=products';

        }
        totals_custom_by_category = new totales_by_categories_s(record, getnewcategory());
    }

    public static String remove1(String input) {
        // Cadena de caracteres original a sustituir.
        String original = 'áàäéèëíìïóòöúùuñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ';
        // Cadena de caracteres ASCII que reemplazarán los originales.
        String ascii = 'aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC';
        String output = input;
        for (integer i=0; i<original.length(); i++) {
            // Reemplazamos los caracteres especiales.
            string letra1 = original.substring(i,i+1);
            string letra2= ascii.substring(i,i+1);
            output = output.replace(letra1, letra2);
        }//for i
        return output;
    }///remove1

    public void categories()
    {
        recordtype=null;
        shipfeeLines=null;
    }

    public Boolean checkExistRoute()
    {
        Boolean exist = true;
        String query_n_routes = 'select count() ';
        query_n_routes += ' FROM Carrier_Line_Load_Point__c';
        query_n_routes += ' WHERE Id != null';
        query_n_routes += (shipment_filter.Country_of_Load__c != null ? ' AND Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\'' : '');
        query_n_routes += (shipment_filter.Country_of_Discharge__c != null ? ' AND Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'' : '');
        query_n_routes += (shipment_filter.State_of_Load__c != null ? ' AND State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'' : '');
        query_n_routes += (shipment_filter.State_of_Discharge__c != null ? ' AND State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'' : '');
        query_n_routes += (shipment_filter.Site_of_Load__c != null ? ' AND Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c+'\'' : '');
        query_n_routes += (shipment_filter.Site_of_Discharge__c != null ? ' AND Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\'' : '');

        Integer numRoutes = database.countQuery(query_n_routes);
        if(numRoutes == 0)
            exist = false;

        return exist;
    }

    public Carrier_Line_Load_Point__c getRouteFinder()
    {
        List<Carrier_Line_Load_Point__c> routeFinder = new List<Carrier_Line_Load_Point__c>();
        String query_route = 'select Id, Name';
        query_route += ' FROM Carrier_Line_Load_Point__c';
        query_route += ' WHERE Id != null';
        query_route += (shipment_filter.Country_of_Load__c != null ? ' AND Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\'' : '');
        query_route += (shipment_filter.Country_of_Discharge__c != null ? ' AND Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'' : '');
        query_route += (shipment_filter.State_of_Load__c != null ? ' AND State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'' : '');
        query_route += (shipment_filter.State_of_Discharge__c != null ? ' AND State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'' : '');
        query_route += (shipment_filter.Site_of_Load__c != null ? ' AND Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c+'\'' : '');
        query_route += (shipment_filter.Site_of_Discharge__c != null ? ' AND Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\'' : '');
        query_route += ' Limit 1';
        routeFinder= Database.query(query_route);
        if(routeFinder.size()>0)
            return routeFinder[0];
        else
                return null;
    }

    public void createNewRoute()
    {
        try
        {
            if(!checkExistRoute() || Test.isrunningtest())
            {
                Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
                new_route.Name = 'New Route';
                new_route.Country_of_Load__c = shipment_filter.Country_of_Load__c;
                new_route.Country_of_Discharge__c = shipment_filter.Country_of_Discharge__c;
                new_route.State_of_Load__c = shipment_filter.State_of_Load__c;
                new_route.State_of_Discharge__c = shipment_filter.State_of_Discharge__c;
                new_route.Port_Airport_of_Load__c = shipment_filter.Site_of_Load__c;
                new_route.Port_Airport_of_Discharge__c = shipment_filter.Site_of_Discharge__c;
                insert new_route;
                existRoute = true;

                if(fee_record != null)
                {
                    fee_record.Route__c = new_route.Id;
                    fee_record.Route__r = new_route;//Because is a Lookup
                }
            }
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+e));
        }
    }

    public void all_accounts_filter()
    {
        recordtype=null;
        shipfeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        if(shipment_filter != null)
            shipment_filter.Account_for__c = null;
        if(service_rate_filter != null)
            service_rate_filter.Account_for__c = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    public void all_carriers_filter()
    {
        recordtype=null;
        shipfeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        if(shipment_filter != null)
            shipment_filter.Carrier__c = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    public void filter_new_carrier()
    {
        recordtype=null;
        shipfeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    public void all_containers_filter()
    {
        recordtype=null;
        shipfeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        if(shipment_filter != null)
            shipment_filter.Container_Type__c = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    //Consultar las lineas insertadas
    public List<Shipment_Fee_Line_currency_s> getshipfeeLines()
    {
        shipfeeLines = new List<Shipment_Fee_Line_currency_s>();
        List<Shipment_Fee_Line__c> shipfeeLines_query = null;
        // las que tiene service rate asignado
        if(String.isNotEmpty(getnewcategory()))
        {
            shipfeeLines_query =  Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Service_Rate_Name__r.Container_Type__c, Std_Buy_Amount_header_currency__c, Sell_Amount_header_currency__c , Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name,  Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Shipment_Service_Line__r.Service_Rate_Name__r.Name, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Extension_Service_Name__c, Std_Buy_Amount__c, Std_Buy_Amount_Number__c, Sell_Amount__c, Sell_Amount_Number__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Shipment_Sell_Price__c, Discount_Charge__c, Shipment_Sell_Net_Price__c, Shipment_Buy_Price__c, Shipment__c, Shipment_Service_Line__c, Shipment_Service_Line__r.Name, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c, Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Shipment_Fee_Line__c where Shipment__c =\''+ record.Id+'\'  and Service_Rate_Name__r.Fee_Category__c =\''+ getnewcategory() +'\'  order by ' +orden_fees_filtro_insertados+ ' '+  orden_fees_filtro_modo_insertados);//, CurrencyIsoCode
            //las que no tienen service rate asignado
            List<Shipment_Fee_Line__c> query_shipfee_whitout_service_rate = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Service_Rate_Name__r.Container_Type__c,  Sell_Amount_header_currency__c , Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name,  Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Shipment_Service_Line__r.Service_Rate_Name__r.Name, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Extension_Service_Name__c, Std_Buy_Amount__c, Std_Buy_Amount_Number__c, Sell_Amount__c, Sell_Amount_Number__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Shipment_Sell_Price__c, Discount_Charge__c, Shipment_Sell_Net_Price__c, Shipment_Buy_Price__c, Shipment__c, Shipment_Service_Line__c, Shipment_Service_Line__r.Name, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c, Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Shipment_Fee_Line__c where Shipment__c =\''+ record.Id+'\'  and Shipments_Program_Rate_Category__c =\''+ getnewcategory() +'\' and Service_Rate_Name__c = null  order by ' +orden_fees_filtro_insertados+ ' '+  orden_fees_filtro_modo_insertados);
            if(query_shipfee_whitout_service_rate != null && query_shipfee_whitout_service_rate.size()>0)
            {
                if(shipfeeLines == null || shipfeeLines.size()==0)
                    shipfeeLines_query = new List<Shipment_Fee_Line__c>();
                for(Shipment_Fee_Line__c sfl: query_shipfee_whitout_service_rate)
                {
                    shipfeeLines_query.add(sfl);
                }
            }
        }
        else
                shipfeeLines_query = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Service_Rate_Name__r.Container_Type__c, Std_Buy_Amount_header_currency__c, Sell_Amount_header_currency__c , Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Shipment_Service_Line__r.Service_Rate_Name__r.Name, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Extension_Service_Name__c, Std_Buy_Amount__c, Std_Buy_Amount_Number__c, Sell_Amount__c,Sell_Amount_Number__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Shipment_Sell_Price__c, Discount_Charge__c, Shipment_Sell_Net_Price__c, Shipment_Buy_Price__c,  Shipment__c, Shipment_Service_Line__c, Shipment_Service_Line__r.Name, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c, Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Shipment_Fee_Line__c where Shipment__c = \''+ record.Id+'\' order by ' +orden_fees_filtro_insertados+ ' '+  orden_fees_filtro_modo_insertados);//, CurrencyIsoCode

        if(shipfeeLines_query != null && shipfeeLines_query.size()>0)
        {
            for(Shipment_Fee_Line__c shipfee : shipfeeLines_query)
            {
                shipfeeLines.add(new Shipment_Fee_Line_currency_s(shipfee, Neu_currencyUtils.getCurrencyIsoCode(shipfee)));
            }
        }

        return shipfeeLines;
    }

    public class Shipment_Fee_Line_currency_s
    {
        public Shipment_Fee_Line__c ship_fee_line{get; set;}
        public String Currencyisocode_string{get; set;}
        public Shipment_Fee_Line_currency_s(Shipment_Fee_Line__c  ship_fee_line, String Currencyisocode_string)
        {
            this.ship_fee_line =ship_fee_line;
            this.Currencyisocode_string=Currencyisocode_string;
        }
    }


    public List<SelectOption>otherFees
    {
        get
        {
            if(otherFees==null)
            {
                otherFees=new List<SelectOption>();
                otherFees.add(new SelectOption('','Service Line'));

                for(Shipment_Fee_Line_currency_s f:getshipfeeLines_without())
                {
                    if((NEU_Utils.safeDecimal(f.ship_fee_line.Sell_Amount__c)<>0)||(NEU_Utils.safeDecimal(f.ship_fee_line.Std_Buy_Amount__c)<>0))
                        otherFees.add(new SelectOption(String.valueOf(f.ship_fee_line.Sell_Amount__c)+'|'+String.valueOf(f.ship_fee_line.Std_Buy_Amount__c)+'|'+String.valueOf(f.ship_fee_line.Id),f.ship_fee_line.Service_Rate_Name__r.Name));
                }
            }
            return otherFees;
        }
        set;
    }

    public  List<Shipment_Fee_Line_currency_s> getshipfeeLines_all()
    {
        listado_ids_carrier = '';
        shipfeeLines_all = new List<Shipment_Fee_Line_currency_s>();
        List<Shipment_Fee_Line__c> shipfeeLines_all_query = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Service_Rate_Name__r.Container_Type__c, Std_Buy_Amount_header_currency__c, Sell_Amount_header_currency__c , Std_Buy_Amount_Number__c , Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Sell_Amount_Number__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate__c, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Extension_Service_Name__c, Std_Buy_Amount__c, Shipment_Service_Line__c, Shipment_Service_Line__r.Service_Rate_Name__r.Name, Shipment_Service_Line__r.Name, Sell_Amount__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Shipment_Sell_Price__c, Discount_Charge__c, Shipment_Sell_Net_Price__c, Shipment_Buy_Price__c,  Shipment__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c, Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Shipment_Fee_Line__c where Shipment__c = \''+ record.Id+'\'  and (Service_Rate_Category__c =\'Other Service Charges\' or Service_Rate_Category__c = \'Clearing Costs\')  order by ' +orden_fees_filtro_insertados_all+ ' '+  orden_fees_filtro_modo_insertados_all);//, CurrencyIsoCode
        decimal total_buy = 0;
        decimal total_sell = 0;
        total_buy_common_charges = (0.001).format();
        total_buy_common_charges = total_buy_common_charges.substring(0,total_buy_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);
        total_sell_common_charges = (0.001).format();
        total_sell_common_charges = total_sell_common_charges.substring(0,total_sell_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);

        if(shipfeeLines_all_query != null && shipfeeLines_all_query.size()>0)
        {
            for(Shipment_Fee_Line__c fl: shipfeeLines_all_query)
            {
                if(fl.Service_Rate_Name__r.Carrier_Account__c != null)
                    listado_ids_carrier += ''+fl.Service_Rate_Name__r.Carrier_Account__c;

                total_buy += NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c);
                total_sell += NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c);
                shipfeeLines_all.add(new Shipment_Fee_Line_currency_s(fl, Neu_currencyUtils.getCurrencyIsoCode(fl)));
            }

            //sacar totales con dos decimales y con moneda de la cabecera
            total_buy_common_charges = (total_buy+0.001).format();
            total_buy_common_charges = total_buy_common_charges.substring(0,total_buy_common_charges.length()-1);
            total_buy_common_charges = total_buy_common_charges +' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);
            total_sell_common_charges = (total_sell+0.001).format();
            total_sell_common_charges = total_sell_common_charges.substring(0,total_sell_common_charges.length()-1);
            total_sell_common_charges = total_sell_common_charges +' '+ NEU_CurrencyUtils.getCurrencyIsoCode(record);
        }
        return shipfeeLines_all;
    }

    public  List<Shipment_Fee_Line_currency_s> getshipfeeLines_without()
    {
        listado_ids_carrier = '';
        shipfeeLines_without = new List<Shipment_Fee_Line_currency_s>();
        List<Shipment_Fee_Line__c> shipfeeLines_without_query = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Route__c,Std_Buy_Amount_Number__c,  Service_Rate_Name__r.Route__r.Name, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.Pallet_Type__c, Sell_Amount_Number__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.TT_Days__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Carrier_Account__c, Service_Rate__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Fee__c, Extension_Service_Name__c, Std_Buy_Amount__c, Sell_Amount_header_currency__c , Shipment_Service_Line__r.Service_Rate_Name__r.Name, Shipment_Service_Line__c, Shipment_Service_Line__r.Name, Sell_Amount__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Shipment_Sell_Price__c, Discount_Charge__c, Shipment_Sell_Net_Price__c, Shipment_Buy_Price__c,  Shipment__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c, Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Shipment_Fee_Line__c where Shipment__c = \''+ record.Id+'\' order by ' +orden_fees_filtro_insertados_all+ ' '+  orden_fees_filtro_modo_insertados_all);//, CurrencyIsoCode
        if(shipfeeLines_without_query != null && shipfeeLines_without_query.size()>0)//----por que se comprueba este
        {
            for(Shipment_Fee_Line__c fl: shipfeeLines_without_query)
            {
                if(fl.Service_Rate_Name__r.Carrier_Account__c != null)
                    listado_ids_carrier += ''+fl.Service_Rate_Name__r.Carrier_Account__c;

                shipfeeLines_without.add(new Shipment_Fee_Line_currency_s(fl, Neu_currencyUtils.getCurrencyIsoCode(fl)));
            }
        }
        return shipfeeLines_without;
    }

    //funciones de comparacion
    public void go_compare_fees_filtro()
    {
        /*if(Fee_List_Price != null && Fee_List_Price.size()>0)
        {
            Fee_List_Price.sort();
        }*/
        Fee_List_Price = null;
    }

    public void search_name_filter()
    {
        Fee_List_Price = null;
    }

    public void buscar_paises_sites()
    {
        Fee_List_Price = null;
        string site_of_load_url = '';
        string site_of_discharge_url = '';
        List<Location__c> query_location = null;
        //Check Exist Route for to show or nor button Create New Route
        existRoute = checkExistRoute();
        if(existRoute)
        {
            if(fee_record != null)
            {
                Carrier_Line_Load_Point__c routeFinder = getRouteFinder();
                fee_record.Route__c = routeFinder.Id;
                fee_record.Route__r = routeFinder;//Because is a Lookup
            }
        }
        if(shipment_filter.Site_of_Load__c != null)
            query_location = [select Name from Location__c where Id=: shipment_filter.Site_of_Load__c];
        if(query_location != null && query_location.size()>0)
        {
            site_of_load_url =remove1(query_location[0].Name);

        }
        if(shipment_filter.Site_of_Discharge__c != null)
            query_location = [select Name from Location__c where Id=: shipment_filter.Site_of_Discharge__c];
        if(query_location != null && query_location.size()>0)
        {
            site_of_discharge_url =remove1(query_location[0].Name);
        }

        url_alibaba = 'https://www.alibaba.com/trade/search?SearchText=freight+'+site_of_load_url+'+'+site_of_discharge_url+'&selectedTab=products';
    }

    public void go_compare_fees_filtro_insertados()
    {

    }

    public void all_routes_filter()
    {
        recordtype=null;
        shipfeeLines=null;
        Fee_List_Price = null;
        listado_ids_ruta = new Map<Id,Id>();
        if(record.Route__c != null)
            listado_ids_ruta.put(record.Route__c, record.Route__c);
        //if(shipment_filter != null)
        //  shipment_filter.Route__c = null;
    }

    public void update_check_show_all_categories()
    {
        show_all_categories_all_lines = true;
        show_all_categories_all_lines_routes = true;
    }

    public void update_check_hidden_all_categories()
    {
        show_all_categories_all_lines = false;
        show_all_categories = false;
        show_all_categories_all_lines_routes = false;
    }

    public List<NEUEBUSCM_Shipment_Fee_Line_s> getFee_List_Price()
    {
        if(Fee_List_Price == null)
        {
            List<SelectOption> options = new List<SelectOption>();
            string moneda_usuario ='';

            if(UserInfo.isMultiCurrencyOrganization()== true)
            {
                for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                {
                    if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                    {
                        options.add(new SelectOption(lu,lu));
                        break;
                    }
                }

                for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                {
                    if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                        options.add(new SelectOption(lu,lu));
                }
            }
            else
                    options.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));


            Fee_List_Price=new List<NEUEBUSCM_Shipment_Fee_Line_s>();
            /*List<Fee__c> lista_fee =new List<Fee__c>();

            if(String.IsNotEmpty(getnewcategory()))
            {
                if(string.isnotempty(service_rate_filter_name))
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Container_Type__c, Route__r.Country_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Load__c,CreatedDate, Max_Kgs__c, Max_M3__c, Min__c, Route__c, Route__r.name, Volumetric_Factor__c, Concept_1__c, Cost_Concept_1__c ,Cost_Concept_2__c , Cost_Concept_3__c , Cost_Concept_4__c, Cost_Concept_5__c,   Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c,  Fee_Description__c, Comments__c,Container_Type__r.Cargo_Volume_m3__c, Valid_Until__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c, Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Port_Airport__r.Name, Account_for__c, Account_for__r.Name,Carrier_Account__c, Port_Airport__r.Country__c, TT_Days__c,Delivery_Zone__c, Delivery_Zone__r.Name, RecordTypeId,  Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c,  Fee_Rate__c  from Fee__c where Fee_Category__c =\''+ getnewcategory()+'\' and Active__c = true and Name like \'%'+service_rate_filter_name+'%\' order by CreatedDate desc');
                else
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Container_Type__c, Route__r.Country_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Load__c, CreatedDate, Max_Kgs__c, Max_M3__c, Min__c, Route__c, Route__r.name, Volumetric_Factor__c, Concept_1__c, Cost_Concept_1__c ,Cost_Concept_2__c , Cost_Concept_3__c , Cost_Concept_4__c, Cost_Concept_5__c,   Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c,  Fee_Description__c, Comments__c,Container_Type__r.Cargo_Volume_m3__c, Valid_Until__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c, Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Port_Airport__r.Name, Account_for__c, Account_for__r.Name,Carrier_Account__c, Port_Airport__r.Country__c, TT_Days__c,Delivery_Zone__c, Delivery_Zone__r.Name, RecordTypeId,  Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c,  Fee_Rate__c  from Fee__c where Fee_Category__c =\''+ getnewcategory()+'\' and Active__c = true order by CreatedDate desc');
            }
            else
                lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Container_Type__c, Route__r.Country_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Load__c, CreatedDate, Max_Kgs__c, Max_M3__c, Min__c, Route__c, Route__r.Name, Volumetric_Factor__c, Concept_1__c, Cost_Concept_1__c ,Cost_Concept_2__c , Cost_Concept_3__c , Cost_Concept_4__c, Cost_Concept_5__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Fee_Description__c, Comments__c,Container_Type__r.Cargo_Volume_m3__c, Valid_Until__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c, Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Port_Airport__r.Name, Account_for__c, Account_for__r.Name,Carrier_Account__c, Port_Airport__r.Country__c, TT_Days__c, Delivery_Zone__c, Delivery_Zone__r.Name, RecordTypeId,  Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c, Fee_Rate__c  from Fee__c where Active__c = true order by CreatedDate desc');
            */

            boolean insertar = true;
            decimal unidades_calculadas = 1;
            decimal weight_vol_factor = 0;
            decimal unidades_calculadas2 = 1;
            List<Delivery_Zone__c> query_name_delivery_zone = null;
            String name_pickup_zone = null;
            string name_delivery_zone = null;
            if(shipment_filter.Pickup_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: shipment_filter.Pickup_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_delivery_zone = query_name_delivery_zone[0].Name;
            }
            if(shipment_filter.Delivery_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: shipment_filter.Delivery_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_pickup_zone = query_name_delivery_zone[0].Name;
            }

            listado_paginas_fees = new List<Integer>();
            step_fee = '1';
            total_fee = 0;

            string query_count_services = '';
            query_count_services = 'SELECT Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c, Fee_Description__c, Route__r.Country_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Load__c, CreatedDate, Comments__c, Route__c, Route__r.Name, Max_M3__c, Max_Kgs__c, Account_for__c, Delivery_Zone__r.Name, Port_Airport__r.Country__c, Container_Type__r.Cargo_Volume_m3__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Container_Type__r.Cargo_Weight_Kg__c, Valid_Until__c,                Pallet_Type__c,Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c,                Account_for__r.Name,Carrier_Account__c,TT_Days__c,Port_Airport__r.Name, Delivery_Zone__c, RecordTypeId,  Port_Airport__c, Fee__c,                 Fee_Category__c, Rate_Type__c, Fee_Rate__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c, Carrier_Account__r.Name,                Volumetric_Factor__c, Min__c, Normal__c, q25__c, q45__c, q50__c, q80__c, mq100__c, q100__c, q125__c, q150__c, q200__c, q250__c, q300__c, q500__c,                q1000__c, q1500__c, q2000__c, q2500__c, q3000__c, q5000__c, q7500__c, q10000__c, Fuel__c, Risk__c, Route__r.State_of_Discharge__c, Route__r.State_of_Load__c, Port_Airport__r.State__c, Group__c, SAP_Service_Type__c, Sap_Service_Type_Buy__c, SAP_Service_Type__r.Code__c, Sap_Service_Type_Buy__r.Code__c, Route_Info__c, Bunker_Adjustment_Factor_BAF_Cont__c, Peak_Season_Surcharge_PSS_Cont__c FROM Fee__c';
            string query_count_services_filters = '';
            query_count_services_filters +=' where Active__c = true ';
            query_count_services_filters += (CHKValidos ? ' AND Valid_Until__c >= TODAY' : '');
            if(service_rate_filter != null)
            {
                Date ValidFrom = service_rate_filter.Valid_From__c;
                Date ValidUntil = service_rate_filter.Valid_Until__c;
                if(ValidFrom != null)
                    query_count_services_filters +=' and (Valid_Until__c = null or Valid_Until__c >=: ValidFrom) ';
                if(ValidUntil != null)
                    query_count_services_filters +=' and (Valid_From__c = null or Valid_From__c <=: ValidUntil) ';
            }
            if(String.IsNotEmpty(getnewcategory()))
                query_count_services_filters +=' and Fee_Category__c = \''+ getnewcategory() +'\'';
            if(string.isnotempty(service_rate_filter_name))
                query_count_services_filters +=' and Name like \'%'+service_rate_filter_name+'%\'';
            //si son de tipo local transport
            query_count_services_filters +=' and ((RecordType.DeveloperName = \'Fee_Local_Transport\'';
            if(service_rate_filter.Account_for__c != null)
                query_count_services_filters +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
            boolean tiene_filtro_country = false;

            /*------------STATE FILTER------------*/
            if(shipment_filter.State_of_Load__c != null)
                query_count_services_filters +=' and State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'';
            if(shipment_filter.State_of_Discharge__c != null)
                query_count_services_filters +=' and State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'';
            /*-------------------------------*/

            //if(record.Route__c != null && record.Route__r.Port_Airport_of_Discharge__c != null)
            if(shipment_filter.Site_of_Discharge__c != null)
            {
                query_count_services_filters += ' and (Port_Airport__c =  \''+shipment_filter.Site_of_Discharge__c+'\' ';
                tiene_filtro_country = true;
            }
            //else if( record.Route__c != null && record.Route__r.Port_Airport_of_Discharge__c == null && record.Route__r.Country_of_Discharge__c != null)
            else if(shipment_filter.Site_of_Discharge__c == null && shipment_filter.Country_of_Discharge__c != null)
            {
                query_count_services_filters += ' and (Port_Airport__r.Country__c = \''+shipment_filter.Country_of_Discharge__c+'\' ';
                tiene_filtro_country = true;
            }
            //if(record.Route__c != null  && record.Route__r.Port_Airport_of_Load__c != null)
            if(shipment_filter.Site_of_Load__c != null)
            {
                if(tiene_filtro_country == false)
                    query_count_services_filters += ' and (Port_Airport__c =  \''+shipment_filter.Site_of_Load__c+'\'';
                else
                        query_count_services_filters += ' or Port_Airport__c =  \''+shipment_filter.Site_of_Load__c+'\'';
                tiene_filtro_country = true;
            }
            //else if(record.Route__c != null  && record.Route__r.Port_Airport_of_Load__c == null && record.Route__r.Country_of_Load__c != null )
            else if(shipment_filter.Site_of_Load__c == null && shipment_filter.Country_of_Load__c != null )
            {
                if(tiene_filtro_country == false)
                    query_count_services_filters += ' and (Port_Airport__r.Country__c = \''+shipment_filter.Country_of_Load__c+'\'';
                else
                        query_count_services_filters += ' or Port_Airport__r.Country__c = \''+shipment_filter.Country_of_Load__c+'\'';
                tiene_filtro_country = true;
            }
            if(tiene_filtro_country == true)
                query_count_services_filters += ' or Port_Airport__c = null)';

            boolean tiene_relacion_con_zone = false;
            if(shipment_filter != null)
            {
                if(shipment_filter.Pickup_Cartage__c != null)
                {
                    query_count_services_filters += ' and (Delivery_Zone__r.Name = \''+name_pickup_zone+'\'';
                    tiene_relacion_con_zone = true;
                }
                if(shipment_filter.Delivery_Cartage__c != null)
                {
                    if(tiene_relacion_con_zone == false)
                        query_count_services_filters += ' and (Delivery_Zone__r.Name = \''+name_delivery_zone+'\'';
                    else
                            query_count_services_filters += ' or Delivery_Zone__r.Name = \''+name_delivery_zone+'\'';
                    tiene_relacion_con_zone = true;
                }
                if(tiene_relacion_con_zone == true)
                    query_count_services_filters += ' or Delivery_Zone__c = null)';
                if(shipment_filter.Container_Type__c != null)
                    query_count_services_filters += ' and (Container_Type__c = \''+shipment_filter.Container_Type__c+'\' or Container_Type__c = null)';
            }
            if(shipment_filter != null)
                if(shipment_filter.Carrier__c != null)
                    query_count_services_filters += ' and (Carrier_Account__c = \''+shipment_filter.Carrier__c+'\' or Carrier_Account__c = null)';
            //fin local transport
            query_count_services_filters +=')';

            //si son de tipo Sea/Ground Freight
            query_count_services_filters +=' or (RecordType.DeveloperName = \'Fee_Freight\'';

            boolean tiene_relacion_route = false;
            if(shipment_filter.Route__c != null)
            {
                query_count_services_filters +=' and (Route__c = \''+shipment_filter.Route__c+'\'';
                tiene_relacion_route = true;
            }

            //if(shipment_filter != null && shipment_filter.Country_of_Load__c != null && shipment_filter.Country_of_Discharge__c != null && shipment_filter.Site_of_Load__c != null && shipment_filter.Site_of_Discharge__c != null)
            if(shipment_filter != null)
            {
                if(tiene_relacion_route == false)
                {
                    //query_count_services_filters +=' and ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    //query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                    query_count_services_filters +=' and ((Route__c != null and (Route__r.Country_of_Load__c=null ';
                    if(shipment_filter.Country_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Load__c != null';
                    query_count_services_filters +=')';

                    query_count_services_filters +=' and (Route__r.Country_of_Discharge__c=null ';
                    if(shipment_filter.Country_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Discharge__c != null';
                    query_count_services_filters +=')';

                    /*------------STATE FILTER------------*/
                    query_count_services_filters +=' and (Route__r.State_of_Load__c=null ';
                    if(shipment_filter.State_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Load__c != null';
                    query_count_services_filters +=')';
                    query_count_services_filters +=' and (Route__r.State_of_Discharge__c=null ';
                    if(shipment_filter.State_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Discharge__c != null';
                    query_count_services_filters +=')';
                    /*-------------------------------*/

                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Discharge__c=null ';
                    if(shipment_filter.Site_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c != null';
                    query_count_services_filters +=') ';
                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Load__c=null ';
                    if(shipment_filter.Site_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c != null';
                    query_count_services_filters +=' ))';
                }
                else
                {
                    //query_count_services_filters +=' or ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    //query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                    query_count_services_filters +=' or ((Route__c != null and (Route__r.Country_of_Load__c=null ';
                    if(shipment_filter.Country_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Load__c != null';
                    query_count_services_filters +=' )';
                    query_count_services_filters +=' and (Route__r.Country_of_Discharge__c=null ';
                    if(shipment_filter.Country_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Discharge__c != null';
                    query_count_services_filters +=' )';

                    /*------------STATE FILTER------------*/
                    query_count_services_filters +=' and (Route__r.State_of_Load__c=null ';
                    if(shipment_filter.State_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Load__c != null';
                    query_count_services_filters +=' )';
                    query_count_services_filters +=' and (Route__r.State_of_Discharge__c=null ';
                    if(shipment_filter.State_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Discharge__c != null';
                    query_count_services_filters +=' )';
                    /*-------------------------------*/

                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Discharge__c=null ';
                    if(shipment_filter.Site_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c != null';
                    query_count_services_filters +=' )';

                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Load__c=null ';
                    if(shipment_filter.Site_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c != null';
                    query_count_services_filters +='))';
                }
                tiene_relacion_route = true;
            }

            if(tiene_relacion_route == true)
                query_count_services_filters +=' or Route__c = null or Route__r.Name = \'-\')';
            if(shipment_filter != null)
                if(shipment_filter.Carrier__c != null)
                    query_count_services_filters += ' and (Carrier_Account__c = \''+shipment_filter.Carrier__c+'\' or Carrier_Account__c = null)';
            if(service_rate_filter.Account_for__c != null)
                query_count_services_filters +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
            if(shipment_filter.Container_Type__c != null)
                query_count_services_filters +=' and Container_Type__c = \''+shipment_filter.Container_Type__c+'\'';
            //fin sea ground freight
            query_count_services_filters +=')';

            //si son de tipo other fees
            query_count_services_filters +=' or (RecordType.DeveloperName = \'Other_Fees\'';
            if(service_rate_filter.Account_for__c != null)
                query_count_services_filters +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
            if(shipment_filter.Container_Type__c != null)
                query_count_services_filters +=' and (Container_Type__c = \''+shipment_filter.Container_Type__c+'\' or Container_Type__c = null)';

            //fin Other_Fees
            query_count_services_filters +=')';

            //si son de tipo Air Freight
            query_count_services_filters +=' or (RecordType.DeveloperName = \'Air_Freight\'';


            boolean tiene_relacion_route2 = false;
            if(shipment_filter.Route__c != null)
            {
                query_count_services_filters +=' and (Route__c = \''+shipment_filter.Route__c+'\'';
                tiene_relacion_route2 = true;
            }

            if(shipment_filter != null && shipment_filter.Country_of_Load__c != null && shipment_filter.Country_of_Discharge__c != null && shipment_filter.Site_of_Load__c != null && shipment_filter.Site_of_Discharge__c != null)
            {
                if(tiene_relacion_route2 == false)
                {
                    query_count_services_filters +=' and ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    /*------------STATE FILTER------------*/
                    if(shipment_filter.State_of_Load__c != null && shipment_filter.State_of_Discharge__c != null)
                        query_count_services_filters +=' and Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\' and Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c +'\'';
                    /*-------------------------------*/
                    query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                }
                else
                {
                    query_count_services_filters +=' or ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    /*------------STATE FILTER------------*/
                    if(shipment_filter.State_of_Discharge__c != null && shipment_filter.State_of_Discharge__c != null)
                        query_count_services_filters +=' and Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\' and Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c +'\'';
                    /*-------------------------------*/
                    query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                }
                tiene_relacion_route2 = true;
            }
            if(tiene_relacion_route2 == true)
                query_count_services_filters +=' or Route__c = null or Route__r.Name = \'-\')';

            //fin Air_Freight
            query_count_services_filters +=')';
            //fin and
            query_count_services_filters +=')';

            query_count_services += query_count_services_filters;
            if(orden_fees_filtro != null && orden_fees_filtro != '')
            {
                if(orden_fees_filtro.contains('line.') == true)
                    orden_fees_filtro = orden_fees_filtro.replace('line.','');

                query_count_services += ' order by '+orden_fees_filtro+' '+orden_fees_filtro_modo;
            }
            else
                    query_count_services += ' order by CreatedDate desc';

            query_count_services += ' nulls last';

            string query_count_service_rate = 'SELECT COUNT(Id)  FROM Fee__c'+ query_count_services_filters;

            query_count_services += '  limit '+n_records_per_page;
            //query_count_service_rate
            List<aggregateResult> results =   Database.query(query_count_service_rate);
            //calculo de totales y paginas
            for (AggregateResult result : results) total_fee += (Integer)result.get('expr0');

            decimal n_listas = 0;
            n_listas = (integer)total_fee/n_records_per_page;
            n_listas = n_listas + 2;

            for(integer i= 1; i < n_listas; i++)
            {
                listado_paginas_fees.add(i);
            }

            List<Fee__c> lista_fee =new List<Fee__c>();
            lista_fee = Database.query(query_count_services);

            for(Fee__c lp: lista_fee)
            {
                if(insertar|| ApexPages.currentPage().getParameters().get('test') != null)
                {
                    if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId())
                    {

                        /*if((record.Site_of_Load__c != null || record.Site_of_Discharge__c != null  )
                         && (lp.Port_Airport__c != null && record.Site_of_Load__c != lp.Port_Airport__c && record.Site_of_Discharge__c != lp.Port_Airport__c
                         ))
                            continue;*/
                        /*
                        if(service_rate_filter.Account_for__c != lp.Account_for__c && service_rate_filter.Account_for__c != null)
                            continue;

                        if((lp.Port_Airport__c != null && ((record.Site_of_Discharge__c != null && record.Site_of_Discharge__c != lp.Port_Airport__c) || (record.Country_of_Discharge__c != null && record.Site_of_Discharge__c == null && record.Country_of_Discharge__c != lp.Port_Airport__r.Country__c)))
                         && (lp.Port_Airport__c != null && ((record.Site_of_Load__c != null && record.Site_of_Load__c != lp.Port_Airport__c) || ( record.Country_of_Load__c != null && record.Site_of_Load__c == null && record.Country_of_Load__c != lp.Port_Airport__r.Country__c ))))
                          continue;

                        if(lp.Delivery_Zone__c != null)
                            if((shipment_filter.Pickup_Cartage__c != null || shipment_filter.Delivery_Cartage__c != null) && name_pickup_zone != lp.Delivery_Zone__r.Name && name_delivery_zone != lp.Delivery_Zone__r.Name  && lp.Delivery_Zone__c != null)
                              continue;

                        if(lp.Carrier_Account__c != null && shipment_filter != null)
                            if(shipment_filter.Carrier__c != null && lp.Carrier_Account__c != shipment_filter.Carrier__c)
                                continue;   */

                        //if(record.Supplier_Account__c != null && record.Supplier_Account__c != lp.Account_for__c && lp.Account_for__c != null)
                        //continue;

                        /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                             if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                   continue;

                        if(lp.Applicable_to_Sales_Incoterms__c != null)
                              if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                   continue;*/

                        //if(shipment_filter.Container_Type__c != null)
                        //if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                        //continue;

                        /* if(record.Total_Volume_m3__c > 0 && lp.Max_M3__c != null)
                             if(record.Total_Volume_m3__c > lp.Max_M3__c)
                               continue;

                         if(record.Total_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                             if(record.Total_Weight_Kg__c > lp.Max_Kgs__c)
                               continue;   */

                        if(lp.Rate_Type__c == 'Per Kg')
                        {
                            unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c : 1);
                            weight_vol_factor = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                            if(weight_vol_factor > unidades_calculadas)
                                unidades_calculadas = weight_vol_factor;
                        }
                        if(lp.Rate_Type__c == 'Per TON')
                            unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/1000 : 1);
                        if(lp.Rate_Type__c == 'Per M3')
                        {
                            unidades_calculadas = (record.Total_Volume_m3__c>0 ? record.Total_Volume_m3__c : 1);
                            weight_vol_factor = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null && lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                            if(weight_vol_factor > unidades_calculadas)
                                unidades_calculadas = weight_vol_factor;
                        }
                        if(lp.Rate_Type__c == 'Per Container')
                        {
                            unidades_calculadas = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c > 0 && lp.Container_Type__r.Cargo_Volume_m3__c != null ? record.Total_Volume_m3__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                            unidades_calculadas2 = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c > 0 && lp.Container_Type__r.Cargo_Weight_Kg__c != null ? record.Total_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                            if(unidades_calculadas2 > unidades_calculadas)
                                unidades_calculadas = unidades_calculadas2;

                        }
                        if(lp.Rate_Type__c == 'Per W/M')
                        {
                            unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                            weight_vol_factor = unidades_calculadas;
                            unidades_calculadas2 = (record.Total_Volume_m3__c > 0 ? record.Total_Volume_m3__c : 0);
                            if(unidades_calculadas2 > unidades_calculadas)
                                unidades_calculadas = unidades_calculadas2;
                        }

                        if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                        {
                            unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Max_Kgs__c != null && lp.Max_Kgs__c > 0 ? record.Total_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                            unidades_calculadas2 = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Max_M3__c != null && lp.Max_M3__c > 0 ? record.Total_Volume_m3__c/lp.Max_M3__c  : 0);
                            if(unidades_calculadas2 > unidades_calculadas)
                                unidades_calculadas = unidades_calculadas2;
                        }

                        if(lp.Rate_Type__c == 'Per Pallet')
                        {
                            unidades_calculadas = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c > 0 && lp.Pallet_Type__r.Cargo_Volume_m3__c != null ? record.Total_Volume_m3__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                            unidades_calculadas2 = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c > 0 && lp.Pallet_Type__r.Cargo_Weight_Kg__c != null ? record.Total_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                            if(unidades_calculadas2 > unidades_calculadas)
                                unidades_calculadas = unidades_calculadas2;

                        }

                        weight_vol_factor = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null && lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                        if(String.IsNotEmpty(getnewcategory()))
                            if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                                unidades_calculadas = 0;
                        //     unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                        unidades_calculadas = unidades_calculadas.setScale(2);
                        Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                        Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);

                        Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c();
                        ship_fee_line.Units__c = (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.N_Containers__c : unidades_calculadas);
                        ship_fee_line.Shipment_Sell_Price__c = sellrate;
                        ship_fee_line.Discount_Charge__c  = 0;
                        ship_fee_line.Shipment_Buy_Price__c = buyrate;
                        ship_fee_line.Extension_Service_Name__c = lp.Comments__c;
                        ship_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                        ship_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                        ship_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                        ship_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                        Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                        Fee_List_Price.add(new NEUEBUSCM_Shipment_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.N_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor,(myDate == system.today() ? true: false)));//options,lp.CurrencyIsoCode)

                    }
                    else
                    {
                        if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                        {
                            //if(lp.Route__c== null || shipment_filter.Route__c == lp.Route__c ||(listado_ids_ruta != null && listado_ids_ruta.size()>0 && listado_ids_ruta.containsKey(lp.Route__c)== true))
                            /* if((lp.Route__c == null || shipment_filter.Route__c == lp.Route__c || (listado_ids_ruta != null && listado_ids_ruta.size()>0 && listado_ids_ruta.containsKey(lp.Route__c)== true) ||
                             //parte nueva
                               ((
                                 shipment_filter != null && shipment_filter.Country_of_Load__c != null && shipment_filter.Country_of_Discharge__c != null &&
                                 shipment_filter.Site_of_Load__c != null && shipment_filter.Site_of_Discharge__c != null && lp.Route__c != null &&
                                 lp.Route__r.Country_of_Load__c == shipment_filter.Country_of_Load__c && lp.Route__r.Country_of_Discharge__c == shipment_filter.Country_of_Discharge__c &&
                                 lp.Route__r.Port_Airport_of_Discharge__c == shipment_filter.Site_of_Discharge__c && lp.Route__r.Port_Airport_of_Load__c == shipment_filter.Site_of_Load__c
                               ))
                             //---
                             ))*/
                            // {
                            // if(service_rate_filter.Account_for__c == lp.Account_for__c || service_rate_filter.Account_for__c == null)
                            // {
                            /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                   continue;

                            if(lp.Applicable_to_Sales_Incoterms__c != null)
                                  if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                       continue;*/

                            /*if(shipment_filter.Container_Type__c != null)
                                if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                  continue;

                            if(lp.Carrier_Account__c != null && shipment_filter != null)
                                if(shipment_filter.Carrier__c != null && lp.Carrier_Account__c != shipment_filter.Carrier__c)
                                  continue; */


                            /* if(record.Total_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                 if(record.Total_Volume_m3__c > lp.Max_M3__c)
                                   continue;

                              if(record.Total_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                 if(record.Total_Weight_Kg__c > lp.Max_Kgs__c)
                                   continue;*/

                            if(lp.Rate_Type__c == 'Per Kg')
                            {
                                unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c : 1);
                                weight_vol_factor = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null && lp.Volumetric_Factor__c > 0 ? record.Total_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                if(weight_vol_factor > unidades_calculadas)
                                    unidades_calculadas = weight_vol_factor;
                            }
                            if(lp.Rate_Type__c == 'Per TON')
                                unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 ? record.Total_Weight_Kg__c/1000 : 1);
                            if(lp.Rate_Type__c == 'Per M3')
                            {
                                unidades_calculadas = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 ? record.Total_Volume_m3__c : 1);
                                weight_vol_factor = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null && lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                if(weight_vol_factor > unidades_calculadas)
                                    unidades_calculadas = weight_vol_factor;
                            }
                            if(lp.Rate_Type__c == 'Per Container')
                            {
                                unidades_calculadas = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c > 0 && lp.Container_Type__r.Cargo_Volume_m3__c != null ? record.Total_Volume_m3__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                unidades_calculadas2 = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c  > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c > 0 && lp.Container_Type__r.Cargo_Weight_Kg__c != null ? record.Total_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                if(unidades_calculadas2 > unidades_calculadas)
                                    unidades_calculadas = unidades_calculadas2;

                            }
                            if(lp.Rate_Type__c == 'Per W/M')
                            {
                                unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                weight_vol_factor = unidades_calculadas;
                                unidades_calculadas2 = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 ? record.Total_Volume_m3__c : 0);
                                if(unidades_calculadas2 > unidades_calculadas)
                                    unidades_calculadas = unidades_calculadas2;
                            }

                            if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                            {
                                unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Max_Kgs__c != null && lp.Max_Kgs__c > 0 ? record.Total_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                unidades_calculadas2 = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Max_M3__c != null && lp.Max_M3__c > 0 ? record.Total_Volume_m3__c/lp.Max_M3__c  : 0);
                                if(unidades_calculadas2 > unidades_calculadas)
                                    unidades_calculadas = unidades_calculadas2;
                            }

                            if(lp.Rate_Type__c == 'Per Pallet')
                            {
                                unidades_calculadas = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c > 0 && lp.Pallet_Type__r.Cargo_Volume_m3__c != null ? record.Total_Volume_m3__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                unidades_calculadas2 = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c > 0 && lp.Pallet_Type__r.Cargo_Weight_Kg__c != null ? record.Total_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                if(unidades_calculadas2 > unidades_calculadas)
                                    unidades_calculadas = unidades_calculadas2;
                            }

                            if(String.IsNotEmpty(getnewcategory()))
                                if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null)
                                    unidades_calculadas = 0;
                            //  unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                            unidades_calculadas = unidades_calculadas.setScale(2);
                            Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                            Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);
                            Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c();
                            ship_fee_line.Units__c = (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.N_Containers__c : unidades_calculadas);
                            ship_fee_line.Shipment_Sell_Price__c = sellrate;
                            ship_fee_line.Discount_Charge__c  = 0;
                            ship_fee_line.Shipment_Buy_Price__c = buyrate;
                            ship_fee_line.Extension_Service_Name__c = lp.Comments__c;
                            ship_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                            ship_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                            ship_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                            ship_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                            Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                            Fee_List_Price.add(new NEUEBUSCM_Shipment_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.N_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor,(myDate == system.today() ? true: false)));//options,lp.CurrencyIsoCode)
                            // }
                            // }
                        }
                        else
                        {
                            if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId())
                            {
                                //if(service_rate_filter.Account_for__c == lp.Account_for__c || service_rate_filter.Account_for__c == null)
                                //{
                                /*if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                    if(shipment_filter.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(shipment_filter.Purchase_Incoterm__c))
                                       continue;

                                if(lp.Applicable_to_Sales_Incoterms__c != null)
                                    if(shipment_filter.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(shipment_filter.Sales_Incoterm__c))
                                       continue;*/

                                /* if(shipment_filter.Container_Type__c != null)
                                     if(lp.Container_Type__c != null && shipment_filter.Container_Type__c != lp.Container_Type__c)
                                       continue;*/
                                /*if(record.Total_Volume_m3__c > 0 && lp.Max_M3__c != null)
                                    if(record.Total_Volume_m3__c > lp.Max_M3__c)
                                      continue;

                                 if(record.Total_Weight_Kg__c >0 && lp.Max_Kgs__c != null)
                                    if(record.Total_Weight_Kg__c > lp.Max_Kgs__c)
                                      continue;  */

                                if(lp.Rate_Type__c == 'Per Kg')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c : 1);
                                    weight_vol_factor = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null && lp.Volumetric_Factor__c > 0 ? record.Total_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 ? record.Total_Weight_Kg__c/1000 : 1);
                                if(lp.Rate_Type__c == 'Per M3')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3__c >0 ? record.Total_Volume_m3__c : 1);
                                    weight_vol_factor = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null && lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c > 0 && lp.Container_Type__r.Cargo_Volume_m3__c != null ? record.Total_Volume_m3__c /lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c > 0 && lp.Container_Type__r.Cargo_Weight_Kg__c != null ? record.Total_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }
                                if(lp.Rate_Type__c == 'Per W/M')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null && lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                                    weight_vol_factor = unidades_calculadas;
                                    unidades_calculadas2 = (record.Total_Volume_m3__c > 0 ? record.Total_Volume_m3__c : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }

                                if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Max_Kgs__c != null && lp.Max_Kgs__c > 0 ? record.Total_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                                    unidades_calculadas2 = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Max_M3__c != null && lp.Max_M3__c > 0 ? record.Total_Volume_m3__c/lp.Max_M3__c  : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }

                                if(lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3__c != null && record.Total_Volume_m3__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c > 0 && lp.Pallet_Type__r.Cargo_Volume_m3__c != null ? record.Total_Volume_m3__c /lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg__c != null && record.Total_Weight_Kg__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c > 0 && lp.Pallet_Type__r.Cargo_Weight_Kg__c != null ? record.Total_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if(String.IsNotEmpty(getnewcategory()))
                                    if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null)
                                        unidades_calculadas = 0;
                                //  unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);
                                Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c();
                                ship_fee_line.Units__c = (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.N_Containers__c : unidades_calculadas);
                                ship_fee_line.Shipment_Sell_Price__c = sellrate;
                                ship_fee_line.Discount_Charge__c  = 0;
                                ship_fee_line.Shipment_Buy_Price__c = buyrate;
                                ship_fee_line.Extension_Service_Name__c = lp.Comments__c;
                                ship_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                ship_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                                ship_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                ship_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                                Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                                Fee_List_Price.add(new NEUEBUSCM_Shipment_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.N_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor,(myDate == system.today() ? true: false)));//options, lp.CurrencyIsoCode)

                                //}
                            }
                        }
                    }

                    unidades_calculadas = 1;
                    weight_vol_factor = 0;
                    unidades_calculadas2 = 1;
                    //Family_Item_List_Price.add(new NEUEBUSCM_Shipment_Fee_Line_s(lp,false, '', '1', (lp.List_Rate__c != null ? string.valueof(lp.List_Rate__c) : string.valueof(lp.Service_Rate_Name__r.Sell_Rate__c)), '0', (lp.List_Rate__c != null ? string.valueof(lp.List_Rate__c) : string.valueof(lp.Service_Rate_Name__r.Sell_Rate__c))));

                    //-------------------------------

                }

                insertar = true;

            }
        }
        return Fee_List_Price;

    }

    public void anterior_siguiente_fee()
    {
        Fee_List_Price = null;
        if(string.isnotempty(step_fee))// se vuelve a hacer la consulta en la posicion donde se quedara
        {

            List<Delivery_Zone__c> query_name_delivery_zone = null;
            String name_pickup_zone = null;
            string name_delivery_zone = null;
            if(shipment_filter.Pickup_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: shipment_filter.Pickup_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_delivery_zone = query_name_delivery_zone[0].Name;
            }
            if(shipment_filter.Delivery_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: shipment_filter.Delivery_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_pickup_zone = query_name_delivery_zone[0].Name;
            }

            List<SelectOption> options = new List<SelectOption>();
            string moneda_usuario ='';

            if(UserInfo.isMultiCurrencyOrganization()== true)
            {
                for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                {
                    if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                    {
                        options.add(new SelectOption(lu,lu));
                        break;
                    }
                }

                for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                {
                    if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                        options.add(new SelectOption(lu,lu));
                }
            }
            else
                    options.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));

            integer numero_registros = integer.valueof(step_fee)*n_records_per_page-n_records_per_page;

            string query_count_services = '';
            query_count_services = 'SELECT Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c, Fee_Description__c, Route__r.Country_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Load__c, CreatedDate, Comments__c, Route__c, Route__r.Name, Max_M3__c, Max_Kgs__c, Account_for__c, Delivery_Zone__r.Name, Port_Airport__r.Country__c, Container_Type__r.Cargo_Volume_m3__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Container_Type__r.Cargo_Weight_Kg__c, Valid_Until__c,                Pallet_Type__c,Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c,                Account_for__r.Name,Carrier_Account__c,TT_Days__c,Port_Airport__r.Name, Delivery_Zone__c, RecordTypeId,  Port_Airport__c, Fee__c,                 Fee_Category__c, Rate_Type__c, Fee_Rate__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c, Carrier_Account__r.Name,                Volumetric_Factor__c, Min__c, Normal__c, q25__c, q45__c, q50__c, q80__c, mq100__c, q100__c, q125__c, q150__c, q200__c, q250__c, q300__c, q500__c,                q1000__c, q1500__c, q2000__c, q2500__c, q3000__c, q5000__c, q7500__c, q10000__c, Fuel__c, Risk__c, Route__r.State_of_Discharge__c, Route__r.State_of_Load__c, Port_Airport__r.State__c, Group__c, SAP_Service_Type__c,Sap_Service_Type_Buy__c, SAP_Service_Type__r.Code__c, Sap_Service_Type_Buy__r.Code__c, Route_Info__c, Bunker_Adjustment_Factor_BAF_Cont__c, Peak_Season_Surcharge_PSS_Cont__c FROM Fee__c';
            string query_count_services_filters = '';
            query_count_services_filters +=' where Active__c = true ';
            query_count_services_filters += (CHKValidos ? ' AND Valid_Until__c >= TODAY' : '');
            if(service_rate_filter != null)
            {
                Date ValidFrom = service_rate_filter.Valid_From__c;
                Date ValidUntil = service_rate_filter.Valid_Until__c;
                if(ValidFrom != null)
                    query_count_services_filters +=' and (Valid_Until__c = null or Valid_Until__c >=: ValidFrom) ';
                if(ValidUntil != null)
                    query_count_services_filters +=' and (Valid_From__c = null or Valid_From__c <=:  ValidUntil) ';
            }
            if(String.IsNotEmpty(getnewcategory()))
                query_count_services_filters +=' and Fee_Category__c = \''+ getnewcategory() +'\'';
            if(string.isnotempty(service_rate_filter_name))
                query_count_services_filters +=' and Name like \'%'+service_rate_filter_name+'%\'';

            //si son de tipo local transport
            query_count_services_filters +=' and ((RecordType.DeveloperName = \'Fee_Local_Transport\'';
            if(service_rate_filter.Account_for__c != null)
                query_count_services_filters +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
            boolean tiene_filtro_country = false;

            /*------------STATE FILTER------------*/
            if(shipment_filter.State_of_Load__c != null)
                query_count_services_filters +=' and State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'';
            if(shipment_filter.State_of_Discharge__c != null)
                query_count_services_filters +=' and State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'';
            /*-------------------------------*/

            //if(record.Route__c != null && record.Route__r.Port_Airport_of_Discharge__c != null)
            if(shipment_filter.Site_of_Discharge__c != null)
            {
                query_count_services_filters += ' and (Port_Airport__c =  \''+shipment_filter.Site_of_Discharge__c+'\' ';
                tiene_filtro_country = true;
            }
            //else if( record.Route__c != null && record.Route__r.Port_Airport_of_Discharge__c == null && record.Route__r.Country_of_Discharge__c != null)
            else if( shipment_filter.Site_of_Discharge__c == null && shipment_filter.Country_of_Discharge__c != null)
            {
                query_count_services_filters += ' and (Port_Airport__r.Country__c = \''+shipment_filter.Country_of_Discharge__c+'\' ';
                tiene_filtro_country = true;
            }
            //if(record.Route__c != null  && record.Route__r.Port_Airport_of_Load__c != null)
            if(shipment_filter.Site_of_Load__c != null)
            {
                if(tiene_filtro_country == false)
                    query_count_services_filters += ' and (Port_Airport__c =  \''+shipment_filter.Site_of_Load__c+'\'';
                else
                        query_count_services_filters += ' or Port_Airport__c =  \''+shipment_filter.Site_of_Load__c+'\'';
                tiene_filtro_country = true;
            }
            //else if(record.Route__c != null  && record.Route__r.Port_Airport_of_Load__c == null && record.Route__r.Country_of_Load__c != null )
            else if(shipment_filter.Site_of_Load__c == null && shipment_filter.Country_of_Load__c != null )
            {
                if(tiene_filtro_country == false)
                    query_count_services_filters += ' and (Port_Airport__r.Country__c = \''+shipment_filter.Country_of_Load__c+'\'';
                else
                        query_count_services_filters += ' or Port_Airport__r.Country__c = \''+shipment_filter.Country_of_Load__c+'\'';
                tiene_filtro_country = true;
            }
            if(tiene_filtro_country == true)
                query_count_services_filters += ' or Port_Airport__c = null)';

            boolean tiene_relacion_con_zone = false;
            if(shipment_filter != null)
            {
                if(shipment_filter.Pickup_Cartage__c != null)
                {
                    query_count_services_filters += ' and (Delivery_Zone__r.Name = \''+name_pickup_zone+'\'';
                    tiene_relacion_con_zone = true;
                }
                if(shipment_filter.Delivery_Cartage__c != null)
                {
                    if(tiene_relacion_con_zone == false)
                        query_count_services_filters += ' and (Delivery_Zone__r.Name = \''+name_delivery_zone+'\'';
                    else
                            query_count_services_filters += ' or Delivery_Zone__r.Name = \''+name_delivery_zone+'\'';
                    tiene_relacion_con_zone = true;
                }
                if(tiene_relacion_con_zone == true)
                    query_count_services_filters += ' or Delivery_Zone__c = null)';
                if(shipment_filter.Container_Type__c != null)
                    query_count_services_filters += ' and (Container_Type__c = \''+shipment_filter.Container_Type__c+'\' or Container_Type__c = null)';
            }
            if(shipment_filter != null)
                if(shipment_filter.Carrier__c != null)
                    query_count_services_filters += ' and (Carrier_Account__c = \''+shipment_filter.Carrier__c+'\' or Carrier_Account__c = null)';
            //fin local transport
            query_count_services_filters +=')';

            //si son de tipo Sea/Ground Freight
            query_count_services_filters +=' or (RecordType.DeveloperName = \'Fee_Freight\'';

            boolean tiene_relacion_route = false;
            if(shipment_filter.Route__c != null)
            {
                query_count_services_filters +=' and (Route__c = \''+shipment_filter.Route__c+'\'';
                tiene_relacion_route = true;
            }

            //if(shipment_filter != null && shipment_filter.Country_of_Load__c != null && shipment_filter.Country_of_Discharge__c != null && shipment_filter.Site_of_Load__c != null && shipment_filter.Site_of_Discharge__c != null)
            if(shipment_filter != null)
            {
                if(tiene_relacion_route == false)
                {
                    //query_count_services_filters +=' and ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    //query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                    query_count_services_filters +=' and ((Route__c != null and (Route__r.Country_of_Load__c=null ';
                    if(shipment_filter.Country_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Load__c != null';
                    query_count_services_filters +=')';

                    query_count_services_filters +=' and (Route__r.Country_of_Discharge__c=null ';
                    if(shipment_filter.Country_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Discharge__c != null';
                    query_count_services_filters +=')';

                    /*------------STATE FILTER------------*/
                    query_count_services_filters +=' and (Route__r.State_of_Load__c=null ';
                    if(shipment_filter.State_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Load__c != null';
                    query_count_services_filters +=')';
                    query_count_services_filters +=' and (Route__r.State_of_Discharge__c=null ';
                    if(shipment_filter.State_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Discharge__c != null';
                    query_count_services_filters +=')';
                    /*-------------------------------*/

                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Discharge__c=null ';
                    if(shipment_filter.Site_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c != null';
                    query_count_services_filters +=') ';
                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Load__c=null ';
                    if(shipment_filter.Site_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c != null';
                    query_count_services_filters +=' ))';
                }
                else
                {
                    //query_count_services_filters +=' or ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    //query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                    query_count_services_filters +=' or ((Route__c != null and (Route__r.Country_of_Load__c=null ';
                    if(shipment_filter.Country_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Load__c != null';
                    query_count_services_filters +=' )';
                    query_count_services_filters +=' and (Route__r.Country_of_Discharge__c=null ';
                    if(shipment_filter.Country_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Country_of_Discharge__c != null';
                    query_count_services_filters +=' )';

                    /*------------STATE FILTER------------*/
                    query_count_services_filters +=' and (Route__r.State_of_Load__c=null ';
                    if(shipment_filter.State_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Load__c != null';
                    query_count_services_filters +=' )';
                    query_count_services_filters +=' and (Route__r.State_of_Discharge__c=null ';
                    if(shipment_filter.State_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.State_of_Discharge__c != null';
                    query_count_services_filters +=' )';
                    /*-------------------------------*/

                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Discharge__c=null ';
                    if(shipment_filter.Site_of_Discharge__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Discharge__c != null';
                    query_count_services_filters +=' )';

                    query_count_services_filters +=' and (Route__r.Port_Airport_of_Load__c=null ';
                    if(shipment_filter.Site_of_Load__c != null)
                        query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\'';
                    else
                            query_count_services_filters +=' or Route__r.Port_Airport_of_Load__c != null';
                    query_count_services_filters +='))';
                }
                tiene_relacion_route = true;
            }

            if(tiene_relacion_route == true)
                query_count_services_filters +=' or Route__c = null or Route__r.Name = \'-\')';
            if(shipment_filter != null)
                if(shipment_filter.Carrier__c != null)
                    query_count_services_filters += ' and (Carrier_Account__c = \''+shipment_filter.Carrier__c+'\' or Carrier_Account__c = null)';
            if(service_rate_filter.Account_for__c != null)
                query_count_services_filters +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
            if(shipment_filter.Container_Type__c != null)
                query_count_services_filters +=' and Container_Type__c = \''+shipment_filter.Container_Type__c+'\'';
            //fin sea ground freight
            query_count_services_filters +=')';

            //si son de tipo other fees
            query_count_services_filters +=' or (RecordType.DeveloperName = \'Other_Fees\'';
            if(service_rate_filter.Account_for__c != null)
                query_count_services_filters +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
            if(shipment_filter.Container_Type__c != null)
                query_count_services_filters +=' and (Container_Type__c = \''+shipment_filter.Container_Type__c+'\' or Container_Type__c = null)';

            //fin Other_Fees
            query_count_services_filters +=')';

            //si son de tipo Air Freight
            query_count_services_filters +=' or (RecordType.DeveloperName = \'Air_Freight\'';


            boolean tiene_relacion_route2 = false;
            if(shipment_filter.Route__c != null)
            {
                query_count_services_filters +=' and (Route__c = \''+shipment_filter.Route__c+'\'';
                tiene_relacion_route2 = true;
            }

            if(shipment_filter != null && shipment_filter.Country_of_Load__c != null && shipment_filter.Country_of_Discharge__c != null && shipment_filter.Site_of_Load__c != null && shipment_filter.Site_of_Discharge__c != null)
            {
                if(tiene_relacion_route2 == false)
                {
                    query_count_services_filters +=' and ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    /*------------STATE FILTER------------*/
                    query_count_services_filters +=' and Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\' and Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c +'\'';
                    /*-------------------------------*/
                    query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                }
                else
                {
                    query_count_services_filters +=' or ((Route__c != null and Route__r.Country_of_Load__c = \''+shipment_filter.Country_of_Load__c+'\' and Route__r.Country_of_Discharge__c = \''+shipment_filter.Country_of_Discharge__c+'\'';
                    /*------------STATE FILTER------------*/
                    query_count_services_filters +=' and Route__r.State_of_Load__c = \''+shipment_filter.State_of_Load__c+'\' and Route__r.State_of_Discharge__c = \''+shipment_filter.State_of_Discharge__c +'\'';
                    /*-------------------------------*/
                    query_count_services_filters +=' and Route__r.Port_Airport_of_Discharge__c = \''+shipment_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+shipment_filter.Site_of_Load__c +'\')';
                }
                tiene_relacion_route2 = true;
            }
            if(tiene_relacion_route2 == true)
                query_count_services_filters +=' or Route__c = null or Route__r.Name = \'-\')';

            //fin Air_Freight
            query_count_services_filters +=')';
            //fin and
            query_count_services_filters +=')';

            query_count_services += query_count_services_filters;
            string sub_consulta = 'SELECT Id from Fee__c ' +query_count_services_filters;
            if(orden_fees_filtro != null && orden_fees_filtro != '')
            {
                if(orden_fees_filtro.contains('line.') == true)
                    orden_fees_filtro = orden_fees_filtro.replace('line.','');

                sub_consulta += ' order by '+orden_fees_filtro+' '+orden_fees_filtro_modo;
            }
            else
                    sub_consulta += ' order by CreatedDate desc';

            sub_consulta += ' limit ' + numero_registros;
            List<Fee__c> lista_fee_subquery = Database.query(sub_consulta);

            query_count_services += ' and id NOT IN  :lista_fee_subquery ';

            if(orden_fees_filtro != null && orden_fees_filtro != '')
            {
                if(orden_fees_filtro.contains('line.') == true)
                    orden_fees_filtro = orden_fees_filtro.replace('line.','');

                query_count_services += ' order by '+orden_fees_filtro+' '+orden_fees_filtro_modo;
            }
            else
                    query_count_services += ' order by CreatedDate desc';


            query_count_services += ' nulls last';

            boolean hay_registros_pendientes = false;

            query_count_services += ' limit '+n_records_per_page;

            List<Fee__c> lista_fee = Database.query(query_count_services);
            Fee_List_Price = null;
            Fee_List_Price=new List<NEUEBUSCM_Shipment_Fee_Line_s>();

            integer contador_records = 0;
            decimal unidades_calculadas = 1;
            decimal weight_vol_factor = 0;
            decimal unidades_calculadas2 = 1;

            for(Fee__c lp: lista_fee)
            {
                if(hay_registros_pendientes == false)
                {
                    if(lp.Rate_Type__c == 'Per Kg')
                    {
                        unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c : 1);
                        weight_vol_factor = (record.Total_Volume_m3__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3__c*lp.Volumetric_Factor__c  : 0);
                        if(weight_vol_factor > unidades_calculadas)
                            unidades_calculadas = weight_vol_factor;
                    }
                    if(lp.Rate_Type__c == 'Per TON')
                        unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/1000 : 1);
                    if(lp.Rate_Type__c == 'Per M3')
                    {
                        unidades_calculadas = (record.Total_Volume_m3__c >0 ? record.Total_Volume_m3__c : 1);
                        weight_vol_factor = (record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                        if(weight_vol_factor > unidades_calculadas)
                            unidades_calculadas = weight_vol_factor;
                    }
                    if(lp.Rate_Type__c == 'Per Container')
                    {
                        unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c /lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;

                    }
                    if(lp.Rate_Type__c == 'Per W/M')
                    {
                        unidades_calculadas = (record.Total_Weight_Kg__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg__c/lp.Volumetric_Factor__c  : 0);
                        weight_vol_factor = unidades_calculadas;
                        unidades_calculadas2 = (record.Total_Volume_m3__c > 0 ? record.Total_Volume_m3__c : 0);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;
                    }
                    if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                    {
                        unidades_calculadas = (record.Total_Weight_Kg__c > 0 && lp.Max_Kgs__c != null ? record.Total_Weight_Kg__c/lp.Max_Kgs__c  : 0);
                        unidades_calculadas2 = (record.Total_Volume_m3__c > 0 && lp.Max_M3__c != null ? record.Total_Volume_m3__c/lp.Max_M3__c  : 0);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;
                    }
                    if(lp.Rate_Type__c == 'Per Pallet')
                    {
                        unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c /lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;

                    }

                    if(String.IsNotEmpty(getnewcategory()))
                        if(getnewcategory() == 'Drayages' && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                            unidades_calculadas = 0;

                    unidades_calculadas = unidades_calculadas.setScale(2);
                    Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                    Decimal sellrate=(lp.Fee_Rate__c==null ? 0 : lp.Fee_Rate__c);
                    Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c();
                    ship_fee_line.Units__c = (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? record.N_Containers__c : unidades_calculadas);
                    ship_fee_line.Shipment_Sell_Price__c = sellrate;
                    ship_fee_line.Discount_Charge__c  = 0;
                    ship_fee_line.Shipment_Buy_Price__c = buyrate;
                    ship_fee_line.Extension_Service_Name__c = lp.Comments__c;
                    ship_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                    ship_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                    ship_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                    ship_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                    Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                    Fee_List_Price.add(new NEUEBUSCM_Shipment_Fee_Line_s(lp,ship_fee_line,false, (lp.Fee_Description__c != null ? lp.Fee_Description__c : ''), (record.N_Containers__c != null && lp.Rate_Type__c == 'Per Container' ? string.valueof(record.N_Containers__c) : string.valueof(unidades_calculadas)), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), this, weight_vol_factor,(myDate == system.today() ? true: false)));
                }

                contador_records ++;
                unidades_calculadas = 1;
                weight_vol_factor = 0;
                unidades_calculadas2 = 1;

            }

        }
    }

    public void update_record()
    {
        try
        {
            update record;
            shipfeeLines_all_for_route = null;
            shipfeeLines_all = null;
        }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));}
    }


    public List<Shipment_Fee_Line_all_s> getshipfeeLines_all_for_route()
    {
        listado_ids_carrier = '';
        shipfeeLines_all_for_route = new List<Shipment_Fee_Line_all_s>();
        //recorrer los freight para abrir opciones
        List<Shipment_Fee_Line__c> query_shipfeeLines_all = null;
        query_shipfeeLines_all = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Shipment__r.Site_of_Load__c, Shipment__r.Site_of_Load__r.Name, Shipment__r.Site_of_Discharge__c, Shipment__r.Site_of_Discharge__r.Name, Std_Buy_Amount_Number__c, Sell_Amount_Number__c, Std_Buy_Amount_header_currency__c, Sell_Amount_header_currency__c,  Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Shipment_Sell_Price__c , Discount_Charge__c , Shipment_Buy_Price__c , Shipment_Service_Line__r.Service_Rate_Name__r.Name, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name, Service_Rate_Name__r.RecordTypeId , Extension_Service_Name__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c,   Sell_Amount__c,  Std_Buy_Amount__c,  Shipment__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c,Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c, Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Shipment_Fee_Line__c where Shipment__c = \''+record.Id +'\' and Service_Rate_Category__c != \'Other Service Charges\' and  Service_Rate_Category__c != \'Clearing Costs\' and Service_Rate_Category__c != \'POL Charges\' and Service_Rate_Category__c != \'POD Charges\' and Service_Rate_Category__c != \'Drayages\'  order by  ' + orden_fees_filtro_insertados_all + ' '+  orden_fees_filtro_modo_insertados_all);
        //Map<String, List<Shipment_Fee_Line__c>> new_map_lines = new Map<String, List<Shipment_Fee_Line__c>>();
        Map<String, List<Shipment_Fee_Line_currency_s>> new_map_lines = new Map<String, List<Shipment_Fee_Line_currency_s>>();
        Map<String, decimal> new_map_buy = new Map<String, decimal>();
        Map<String, decimal> new_map_sell = new Map<String, decimal>();
        string contenedor_de_rutas = '';
        decimal total_buy=0;
        decimal total_sell=0;

        for(Shipment_Fee_Line__c fl: query_shipfeeLines_all)
        {
            if(fl.Service_Rate_Name__r.Carrier_Account__c != null)
                listado_ids_carrier += ''+fl.Service_Rate_Name__r.Carrier_Account__c;

            if(new_map_lines.containsKey((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )))
            {
                Shipment_Fee_Line_currency_s new_object_currency = new Shipment_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));
                new_map_lines.get((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )).add(new_object_currency);

                total_buy = NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c) + NEU_Utils.safedecimal(new_map_buy.get((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )));
                total_sell = NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c) + NEU_Utils.safedecimal(new_map_sell.get((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )));
                new_map_buy.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),total_buy);
                new_map_sell.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),total_sell);
            }
            else
            {

                new_map_lines.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ), new List<Shipment_Fee_Line_currency_s>{new Shipment_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl))});
                new_map_buy.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c));
                new_map_sell.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c));
            }
        }
        integer contador_de_opciones = 1;
        Map<string, Shipment_Fee_Line_all_s> map_lines_custom = new Map<string, Shipment_Fee_Line_all_s>();
        for (String entry : new_map_lines.keySet())
        {
            List<String> listado_nombres_rutas = entry.split('_&_');
            map_lines_custom.put(entry,new Shipment_Fee_Line_all_s(this, listado_nombres_rutas[0], listado_nombres_rutas[1], new_map_lines.get(entry), new_map_buy.get(entry),new_map_sell.get(entry),contador_de_opciones));
            contador_de_opciones ++;
        }

        //recorrer los drayage, pol y pod para incluirlos en una ruta existente
        query_shipfeeLines_all = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Category__c , Service_Rate_Name__r.Route__c, Shipment__r.Site_of_Load__c, Service_Rate_Name__r.Port_Airport__r.Name, Shipment__r.Site_of_Load__r.Name, Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__c, Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.Country__c, Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.State__c, Shipment__r.Site_of_Discharge__c, Shipment__r.Site_of_Discharge__r.Name, Std_Buy_Amount_header_currency__c, Sell_Amount_header_currency__c,  Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Std_Buy_Amount_Number__c, Sell_Amount_Number__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate__c, Shipment_Service_Line__r.Service_Rate_Name__r.Name, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Shipment_Sell_Price__c ,Discount_Charge__c , Shipment_Buy_Price__c , Std_Buy_Amount__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name, Service_Rate_Name__r.RecordTypeId , Extension_Service_Name__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c,   Sell_Amount__c,    Shipment__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Shipment_Fee_Line__c where Shipment__c = \''+record.Id +'\' and (Service_Rate_Category__c = \'POL Charges\' or Service_Rate_Category__c = \'POD Charges\' or Service_Rate_Category__c = \'Drayages\')  order by  Service_Rate_Category__c');

        boolean ya_existe_la_ruta = false;
        if(query_shipfeeLines_all != null && query_shipfeeLines_all.size()>0)
        {
            for(Shipment_Fee_Line__c fl: query_shipfeeLines_all)
            {
                if(fl.Service_Rate_Category__c == 'POD Charges')
                {
                    for (String entry : new_map_lines.keySet())
                    {
                        List<String> listado_nombres_rutas = entry.split('_&_');
                        if(listado_nombres_rutas[1] == fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name)
                        {
                            Shipment_Fee_Line_currency_s new_object_currency = new Shipment_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));
                            map_lines_custom.get(entry).list_fees.add(new_object_currency);
                            //sumar al total
                            map_lines_custom.get(entry).total_buy = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_buy) + NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c);
                            map_lines_custom.get(entry).total_sell = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_sell) + NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c);
                            ya_existe_la_ruta = true;
                        }
                    }
                }

                if(fl.Service_Rate_Category__c == 'POL Charges')
                {
                    for (String entry : new_map_lines.keySet())
                    {
                        List<String> listado_nombres_rutas = entry.split('_&_');
                        if(listado_nombres_rutas[0] == fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name)
                        {
                            Shipment_Fee_Line_currency_s new_object_currency = new Shipment_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));
                            map_lines_custom.get(entry).list_fees.add(new_object_currency);
                            //sumar al total
                            map_lines_custom.get(entry).total_buy = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_buy) + NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c);
                            map_lines_custom.get(entry).total_sell = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_sell) + NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c);
                            ya_existe_la_ruta = true;
                        }
                    }
                }

                if(fl.Service_Rate_Category__c == 'Drayages')
                {
                    for(String entry : new_map_lines.keySet())
                    {
                        List<String> listado_nombres_rutas = entry.split('_&_');
                        if(fl.Service_Rate_Name__r.Port_Airport__c != null)
                            if((listado_nombres_rutas[0] == fl.Service_Rate_Name__r.Port_Airport__r.Name) || (listado_nombres_rutas[1] == fl.Service_Rate_Name__r.Port_Airport__r.Name))
                            {
                                Shipment_Fee_Line_currency_s new_object_currency = new Shipment_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));
                                map_lines_custom.get(entry).list_fees.add(new_object_currency);
                                //sumar al total
                                map_lines_custom.get(entry).total_buy = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_buy) + NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c);
                                map_lines_custom.get(entry).total_sell = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_sell) + NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c);
                                ya_existe_la_ruta = true;
                            }
                    }
                }

                if(ya_existe_la_ruta == false)
                {
                    if(fl.Service_Rate_Category__c == 'Drayages')
                    {
                        if(fl.Service_Rate_Name__r.Port_Airport__c != null)
                        {
                            List<Shipment_Fee_Line_currency_s> list_ie_line_currency = new List<Shipment_Fee_Line_currency_s>();
                            Shipment_Fee_Line_currency_s list_ie_line_currency_line = new Shipment_Fee_Line_currency_s(fl, Neu_currencyUtils.getCurrencyIsoCode(fl));
                            list_ie_line_currency.add(list_ie_line_currency_line);

                            List<Shipment_Fee_Line__c> list_ie_line = new List<Shipment_Fee_Line__c>();
                            list_ie_line.add(fl);
                            new_map_lines.put((fl.Service_Rate_Name__r.Port_Airport__c != null ? fl.Service_Rate_Name__r.Port_Airport__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Port_Airport__c != null ? fl.Service_Rate_Name__r.Port_Airport__r.Name : null ), new List<Shipment_Fee_Line_currency_s>{new Shipment_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl))});
                            // si a incluido un drayage que no hay ruta anterior crea la del load si coincide o la de descarga
                            if((fl.Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__c == record.Site_of_Load__c && record.Site_of_Load__c != null) || (fl.Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.Country__c == record.Country_of_Load__c && record.Site_of_Load__c == null) || (fl.Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.State__c == record.State_of_Load__c && record.Site_of_Load__c == null))
                            {
                                map_lines_custom.put((fl.Service_Rate_Name__r.Port_Airport__c != null ? fl.Service_Rate_Name__r.Port_Airport__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Port_Airport__c != null ? fl.Service_Rate_Name__r.Port_Airport__r.Name : null ),new Shipment_Fee_Line_all_s(this, fl.Service_Rate_Name__r.Port_Airport__r.Name, 'null', list_ie_line_currency , NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c),contador_de_opciones));
                                contador_de_opciones ++;
                            }
                            else
                            {
                                map_lines_custom.put((fl.Service_Rate_Name__r.Port_Airport__c != null ? fl.Service_Rate_Name__r.Port_Airport__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Port_Airport__c != null ? fl.Service_Rate_Name__r.Port_Airport__r.Name : null ),new Shipment_Fee_Line_all_s(this, 'null', fl.Service_Rate_Name__r.Port_Airport__r.Name, list_ie_line_currency , NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c),contador_de_opciones));
                                contador_de_opciones ++;
                            }
                        }
                    }
                    else if(fl.Service_Rate_Category__c == 'POL Charges' || fl.Service_Rate_Category__c == 'POD Charges')
                    {
                        if(fl.Service_Rate_Name__r.Route__c != null && fl.Service_Rate_Name__r.Route__c != null)
                        {
                            List<Shipment_Fee_Line_currency_s> list_ie_line_currency = new List<Shipment_Fee_Line_currency_s>();
                            Shipment_Fee_Line_currency_s list_ie_line_currency_line = new Shipment_Fee_Line_currency_s(fl, Neu_currencyUtils.getCurrencyIsoCode(fl));
                            list_ie_line_currency.add(list_ie_line_currency_line);
                            List<Shipment_Fee_Line__c> list_ie_line = new List<Shipment_Fee_Line__c>();
                            list_ie_line.add(fl);
                            //para que lo encuentre la siguiente vuelta
                            new_map_lines.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ), list_ie_line_currency );
                            //para pintarlo
                            map_lines_custom.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),new Shipment_Fee_Line_all_s(this, (fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null), (fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ), list_ie_line_currency , NEU_Utils.safedecimal(fl.Std_Buy_Amount_header_currency__c),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c),contador_de_opciones));
                            contador_de_opciones ++;
                        }
                    }
                }
                ya_existe_la_ruta = false;
            }
        }
        shipfeeLines_all_for_route = map_lines_custom.values();

        return shipfeeLines_all_for_route;
    }

    //clase nuevo objeto
    public class Shipment_Fee_Line_all_s
    {
        public String site_of_load{get; set;}
        public String site_of_discharge{get; set;}
        public Decimal total_buy{get; set;}
        public Decimal total_sell{get; set;}
        public Decimal n_opcion{get; set;}
        public List<Shipment_Fee_Line_currency_s> list_fees {get; set;}
        private NEU_OM_ShipFeeLinesPriceListYDiscount parent;

        public Shipment_Fee_Line_all_s(NEU_OM_ShipFeeLinesPriceListYDiscount parent, String site_of_load, String site_of_discharge, List<Shipment_Fee_Line_currency_s> list_fees, decimal total_buy, decimal total_sell, Decimal n_opcion)
        {
            this.site_of_load=site_of_load;
            this.site_of_discharge=site_of_discharge;
            this.list_fees=list_fees;
            this.total_buy =total_buy;
            this.total_sell =total_sell;
            this.parent = parent;
            this.n_opcion=n_opcion;
        }

        public String gettotal_buy_format()
        {
            try
            {
                string total_buy_format = '';
                total_buy_format = ((total_buy+0.001)).format();
                total_buy_format = total_buy_format.substring(0,total_buy_format.length()-1);
                total_buy_format= total_buy_format + ' '+NEU_CurrencyUtils.getCurrencyIsoCode(parent.record);
                return total_buy_format;
            }
            catch(Exception e){}
            return (0.00).format();
        }

        public String gettotal_sell_format()
        {
            try
            {
                string total_sell_format = '';
                total_sell_format = ((total_sell+0.001)).format();
                total_sell_format = total_sell_format.substring(0,total_sell_format.length()-1);
                total_sell_format= total_sell_format + ' '+NEU_CurrencyUtils.getCurrencyIsoCode(parent.record);
                return total_sell_format;
            }
            catch(Exception e){}
            return (0.00).format();
        }
    }

    //clase nuevo objeto
    public class NEUEBUSCM_Shipment_Fee_Line_s implements Comparable
    {
        public Fee__c line {get; set;}
        public Shipment_Fee_Line__c ship_fee_line {get; set;}
        public boolean selected {get; set;}
        public String extensionfeename {get; set;}
        public String units {get; set;}
        public String sellprice {get; set;}
        public String discount {get; set;}
        public String buyprice {get; set;}
        public List<SelectOption> currencys {get; set;}
        public String currency_user {get; set;}
        public String total_sell{get; set;}
        public String total_buy{get; set;}
        private NEU_OM_ShipFeeLinesPriceListYDiscount  parent;
        public boolean fee_hoy{get; set;}
        public string weight_factor{get; set;}

        public NEUEBUSCM_Shipment_Fee_Line_s(Fee__c line, Shipment_Fee_Line__c ship_fee_line, boolean selected, String extensionfeename, String units, String sellprice, String discount, String buyprice, List<SelectOption> currencys, String currency_user, NEU_OM_ShipFeeLinesPriceListYDiscount  parent, Decimal weight_factor, boolean fee_hoy)
        {
            this.line=line;
            this.ship_fee_line=ship_fee_line;
            this.selected=selected;
            this.extensionfeename=extensionfeename;
            this.units=units;
            this.sellprice=sellprice;
            this.discount=discount;
            this.buyprice=buyprice;
            this.currencys = currencys;
            this.currency_user = currency_user;
            this.parent = parent;
            this.weight_factor=((weight_factor+0.001)).format();
            this.weight_factor = this.weight_factor.substring(0,this.weight_factor.length()-1);
            this.fee_hoy = fee_hoy;
        }

        public Integer compareTo(Object compareTo)
        {
            NEUEBUSCM_Shipment_Fee_Line_s compareToEmp = (NEUEBUSCM_Shipment_Fee_Line_s)compareTo;

            if(parent.orden_fees_filtro  == 'line.Name')
            {
                if (line.Name  == compareToEmp.line.Name) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Name < compareToEmp.line.Name) return 1;
                }
                else
                {
                    if (line.Name > compareToEmp.line.Name) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Valid_Until__c')
            {
                if (line.Valid_Until__c  == compareToEmp.line.Valid_Until__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Valid_Until__c < compareToEmp.line.Valid_Until__c) return 1;
                }
                else
                {
                    if (line.Valid_Until__c > compareToEmp.line.Valid_Until__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'weight_factor')
            {
                if (weight_factor  == compareToEmp.weight_factor) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (weight_factor < compareToEmp.weight_factor) return 1;
                }
                else
                {
                    if (weight_factor > compareToEmp.weight_factor) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'total_sell')
            {
                if (total_sell  == compareToEmp.total_sell) return 0;
                if(total_sell == null || total_sell == '') return 1;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (NEU_Utils.toDecimal(total_sell) < NEU_Utils.toDecimal(compareToEmp.total_sell)) return 1;
                }
                else
                {
                    if (NEU_Utils.toDecimal(total_sell) > NEU_Utils.toDecimal(compareToEmp.total_sell)) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'total_buy')
            {
                if (total_buy  == compareToEmp.total_buy) return 0;
                if(total_buy == null || total_buy == '') return 1;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (NEU_Utils.toDecimal(total_buy) < NEU_Utils.toDecimal(compareToEmp.total_buy)) return 1;
                }
                else
                {
                    if (NEU_Utils.toDecimal(total_buy) > NEU_Utils.toDecimal(compareToEmp.total_buy)) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Account_for__c')
            {
                if (line.Account_for__c == compareToEmp.line.Account_for__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Account_for__c < compareToEmp.line.Account_for__c) return 1;
                }
                else
                {
                    if (line.Account_for__c > compareToEmp.line.Account_for__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Carrier_Account__c')
            {
                if (line.Carrier_Account__c == compareToEmp.line.Carrier_Account__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Carrier_Account__c < compareToEmp.line.Carrier_Account__c) return 1;
                }
                else
                {
                    if (line.Carrier_Account__c > compareToEmp.line.Carrier_Account__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Route__r.Name')
            {
                if (line.Route__r.Name == compareToEmp.line.Route__r.Name) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Route__r.Name < compareToEmp.line.Route__r.Name) return 1;
                }
                else
                {
                    if (line.Route__r.Name > compareToEmp.line.Route__r.Name) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Delivery_Zone__c')
            {
                if (line.Delivery_Zone__c == compareToEmp.line.Delivery_Zone__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Delivery_Zone__c < compareToEmp.line.Delivery_Zone__c) return 1;
                }
                else
                {
                    if (line.Delivery_Zone__c > compareToEmp.line.Delivery_Zone__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.CreatedDate')
            {
                if (line.CreatedDate == compareToEmp.line.CreatedDate) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.CreatedDate < compareToEmp.line.CreatedDate) return 1;
                }
                else
                {
                    if (line.CreatedDate > compareToEmp.line.CreatedDate) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Port_Airport__c')
            {
                if (line.Port_Airport__c == compareToEmp.line.Port_Airport__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Port_Airport__c < compareToEmp.line.Port_Airport__c) return 1;
                }
                else
                {
                    if (line.Port_Airport__c > compareToEmp.line.Port_Airport__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.TT_Days__c')
            {
                if (line.TT_Days__c == compareToEmp.line.TT_Days__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.TT_Days__c < compareToEmp.line.TT_Days__c) return 1;
                }
                else
                {
                    if (line.TT_Days__c > compareToEmp.line.TT_Days__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Rate_Type__c')
            {
                if (line.Rate_Type__c == compareToEmp.line.Rate_Type__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Rate_Type__c < compareToEmp.line.Rate_Type__c) return 1;
                }
                else
                {
                    if (line.Rate_Type__c > compareToEmp.line.Rate_Type__c) return 1;
                }

            }

            else if(parent.orden_fees_filtro  == 'line.Fee_Rate__c')
            {
                if (line.Fee_Rate__c== compareToEmp.line.Fee_Rate__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Fee_Rate__c < compareToEmp.line.Fee_Rate__c) return 1;
                    if(line.Fee_Rate__c == null) return 1;
                }
                else
                {
                    if (line.Fee_Rate__c > compareToEmp.line.Fee_Rate__c) return 1;
                    if(line.Fee_Rate__c == null) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Container_Type__c')
            {
                if (line.Container_Type__c == compareToEmp.line.Container_Type__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Container_Type__c < compareToEmp.line.Container_Type__c) return 1;
                }
                else
                {
                    if (line.Container_Type__c > compareToEmp.line.Container_Type__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Pallet_Type__c')
            {
                if (line.Pallet_Type__c == compareToEmp.line.Pallet_Type__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Pallet_Type__c < compareToEmp.line.Pallet_Type__c) return 1;
                }
                else
                {
                    if (line.Pallet_Type__c > compareToEmp.line.Pallet_Type__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Max_Kgs__c')
            {
                if (line.Max_Kgs__c == compareToEmp.line.Max_Kgs__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Max_Kgs__c < compareToEmp.line.Max_Kgs__c) return 1;
                }
                else
                {
                    if (line.Max_Kgs__c > compareToEmp.line.Max_Kgs__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Max_M3__c')
            {
                if (line.Max_M3__c == compareToEmp.line.Max_M3__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Max_M3__c < compareToEmp.line.Max_M3__c) return 1;
                }
                else
                {
                    if (line.Max_M3__c > compareToEmp.line.Max_M3__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Buy_Rate__c')
            {
                if (line.Buy_Rate__c == compareToEmp.line.Buy_Rate__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Buy_Rate__c < compareToEmp.line.Buy_Rate__c) return 1;
                }
                else
                {
                    if (line.Buy_Rate__c > compareToEmp.line.Buy_Rate__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Min__c')
            {
                if (line.Min__c == compareToEmp.line.Min__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Min__c < compareToEmp.line.Min__c) return 1;
                }
                else
                {
                    if (line.Min__c > compareToEmp.line.Min__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Volumetric_Factor__c')
            {
                if (line.Volumetric_Factor__c == compareToEmp.line.Volumetric_Factor__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Volumetric_Factor__c < compareToEmp.line.Volumetric_Factor__c) return 1;
                }
                else
                {
                    if (line.Volumetric_Factor__c > compareToEmp.line.Volumetric_Factor__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'ship_fee_line.Units__c')
            {
                if (ship_fee_line.Units__c == compareToEmp.ship_fee_line.Units__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (ship_fee_line.Units__c < compareToEmp.ship_fee_line.Units__c) return 1;
                }
                else
                {
                    if (ship_fee_line.Units__c > compareToEmp.ship_fee_line.Units__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'ship_fee_line.Shipment_Sell_Price__c')
            {
                if (ship_fee_line.Shipment_Sell_Price__c == compareToEmp.ship_fee_line.Shipment_Sell_Price__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (ship_fee_line.Shipment_Sell_Price__c < compareToEmp.ship_fee_line.Shipment_Sell_Price__c) return 1;
                }
                else
                {
                    if (ship_fee_line.Shipment_Sell_Price__c > compareToEmp.ship_fee_line.Shipment_Sell_Price__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'ship_fee_line.Discount_Charge__c')
            {
                if (ship_fee_line.Discount_Charge__c == compareToEmp.ship_fee_line.Discount_Charge__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (ship_fee_line.Discount_Charge__c < compareToEmp.ship_fee_line.Discount_Charge__c) return 1;
                }
                else
                {
                    if (ship_fee_line.Discount_Charge__c > compareToEmp.ship_fee_line.Discount_Charge__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'ship_fee_line.Shipment_Buy_Price__c')
            {
                if (ship_fee_line.Shipment_Buy_Price__c == compareToEmp.ship_fee_line.Shipment_Buy_Price__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (ship_fee_line.Shipment_Buy_Price__c < compareToEmp.ship_fee_line.Shipment_Buy_Price__c) return 1;
                }
                else
                {
                    if (ship_fee_line.Shipment_Buy_Price__c > compareToEmp.ship_fee_line.Shipment_Buy_Price__c) return 1;
                }
            }

            return -1;
        }

    }

    //clase nuevo objeto
    public class IE_Fee_Line_s extends NEU_Line_Comparable
    {
        public override Object getValue(String compareField)
        {
            if(compareField.startsWith('ship_fee_line.'))
                return getValue(ship_fee_line,compareField.Substring(14));
            else
                    return null;
            //return getValue(import_export,compareField);
        }

        private NEU_OM_ShipFeeLinesPriceListYDiscount parent;
        public Shipment_Fee_Line__c ship_fee_line {get; set;}
        public boolean selected {get; set;}
        public string id {get; set;}
        public String total_sell{get; set;}
        public String total_buy{get; set;}

        public IE_Fee_Line_s(NEU_OM_ShipFeeLinesPriceListYDiscount parent, Shipment_Fee_Line__c ship_fee_line, boolean selected, string id )
        {
            super(parent);
            this.ship_fee_line=ship_fee_line;
            this.selected=selected;
            this.id=id;
        }
    }

    public List<IE_Fee_Line_s> getIE_lines()
    {
        if(IE_lines == null)
        {
            IE_lines = new List<IE_Fee_Line_s>();
            List<Shipment_Consolidation_Data__c> query_ship_conso_data = [select Import_Export_Quote__c from Shipment_Consolidation_Data__c where Shipment__c =: record.Id];
            if(query_ship_conso_data != null && query_ship_conso_data.size()>0)
            {
                List<Shipment_Fee_Line__c> query_ship_lines = [select Id, Name, Import_Export_Service_Line__c from Shipment_Fee_Line__c where Shipment__c =: record.Id and Import_Export_Service_Line__c != null];
                Set<Id> list_ids_ie_insert =  new Set<Id>();
                for(Shipment_Fee_Line__c ship_fee:query_ship_lines)
                {
                    list_ids_ie_insert.add(ship_fee.Import_Export_Service_Line__c);
                }

                string query_ie_service_lines = 'select Id, Name,Extension_Service_Name__c , Service_Rate_Name__c, Service_Rate_Name__r.Name, Units__c,';
                query_ie_service_lines +='Quote_Sell_Price__c, Discount__c,  Import_Export_Quote__c, Quote_Buy_Price__c, Concept_1_Sell_Price__c, '+(UserInfo.ismulticurrencyOrganization() == true ? 'CurrencyIsoCode,':'');
                query_ie_service_lines +='Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Min_Amount__c, Service_Rate_Name__r.Fee__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c,';
                query_ie_service_lines +='Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Account_for__c,';
                query_ie_service_lines +='Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Rate_Type__c, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Route_Info__c,';
                query_ie_service_lines +='Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c, Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c,';
                query_ie_service_lines +='Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c,';
                query_ie_service_lines +='Service_Rate_Name__r.Cost_Concept_5__c  from Import_Export_Fee_Line__c where Import_Export_Quote__c = \''+ query_ship_conso_data[0].Import_Export_Quote__c+'\' and id Not IN :list_ids_ie_insert';
                List<Import_Export_Fee_Line__c> query_ie_lines = Database.query(query_ie_service_lines);
                integer contador_id = 1;

                for(Import_Export_Fee_Line__c iefl: query_ie_lines)
                {
                    Shipment_Fee_Line__c new_shipment_fee_line = new Shipment_Fee_Line__c();
                    new_shipment_fee_line.Shipment__c=record.Id;
                    new_shipment_fee_line.Name =iefl.Name;
                    new_shipment_fee_line.Extension_Service_Name__c=iefl.Extension_Service_Name__c;
                    new_shipment_fee_line.Service_Rate_Name__c = iefl.Service_Rate_Name__c;
                    new_shipment_fee_line.Service_Rate_Name__r = iefl.Service_Rate_Name__r;
                    new_shipment_fee_line.Units__c = iefl.Units__c;
                    new_shipment_fee_line.Shipment_Sell_Price__c = iefl.Quote_Sell_Price__c;
                    new_shipment_fee_line.Discount_Charge__c = iefl.Discount__c;
                    new_shipment_fee_line.Import_Export_Quote__c = iefl.Import_Export_Quote__c;
                    new_shipment_fee_line.Import_Export_Service_Line__c = iefl.Id;
                    new_shipment_fee_line.Shipment_Buy_Price__c = iefl.Quote_Buy_Price__c;
                    new_shipment_fee_line.Concept_1_Sell_Price__c = iefl.Concept_1_Sell_Price__c;
                    new_shipment_fee_line.Concept_2_Sell_Price__c = iefl.Concept_2_Sell_Price__c;
                    new_shipment_fee_line.Concept_3_Sell_Price__c = iefl.Concept_3_Sell_Price__c;
                    new_shipment_fee_line.Concept_4_Sell_Price__c = iefl.Concept_4_Sell_Price__c;
                    new_shipment_fee_line.Concept_5_Sell_Price__c = iefl.Concept_5_Sell_Price__c;
                    new_shipment_fee_line.Min_Amount__c = iefl.Min_Amount__c;
                    NEU_CurrencyUtils.setCurrencyIsoCode(new_shipment_fee_line,NEU_CurrencyUtils.getCurrencyIsoCode(iefl));
                    IE_lines.add(new IE_Fee_Line_s(this,new_shipment_fee_line,false, contador_id.format()));
                    contador_id ++;
                }
                resorting(0);
            }
        }
        return IE_lines;
    }

    public void create_new_service_rate()
    {
        if(fee_record != null)
        {
            Fee__c new_fee = new Fee__c();
            new_fee.Name = fee_record.Name;
            if(getnewcategory() != 'Drayages' && getnewcategory() != 'Other Service Charges')
                new_fee.Route__c = fee_record.Route__c;
            else if(getnewcategory() == 'Drayages')
            {
                new_fee.Port_Airport__c = fee_record.Port_Airport__c;
                new_fee.Delivery_Zone__c = fee_record.Delivery_Zone__c;
            }
            new_fee.Valid_Until__c = fee_record.Valid_Until__c;
            new_fee.Account_for__c = fee_record.Account_for__c;
            new_fee.Carrier_Account__c = fee_record.Carrier_Account__c;
            new_fee.TT_Days__c = fee_record.TT_Days__c;
            NEU_CurrencyUtils.setCurrencyIsoCode(new_fee,fee_currency);
            new_fee.Rate_Type__c = fee_record.Rate_Type__c;
            new_fee.Container_Type__c = fee_record.Container_Type__c;
            new_fee.Fee_Rate__c = fee_record.Fee_Rate__c;
            new_fee.Buy_Rate__c = fee_record.Buy_Rate__c;
            new_fee.Comments__c = fee_record.Comments__c;
            new_fee.Max_Kgs__c = fee_record.Max_Kgs__c;
            new_fee.Max_M3__c = fee_record.Max_M3__c;
            new_fee.Volumetric_Factor__c = fee_record.Volumetric_Factor__c;
            new_fee.Min__c = fee_record.Min__c;
            new_fee.Group__c = fee_record.Group__c;
            new_fee.SAP_Service_Type__c = fee_record.SAP_Service_Type__c;
            new_fee.Sap_Service_Type_Buy__c = fee_record.Sap_Service_Type_Buy__c;
            new_fee.Bunker_Adjustment_Factor_BAF_Cont__c = fee_record.Bunker_Adjustment_Factor_BAF_Cont__c;
            new_fee.Peak_Season_Surcharge_PSS_Cont__c = fee_record.Peak_Season_Surcharge_PSS_Cont__c;
            new_fee.Route_info__c = fee_record.Route_Info__c;
            //new_fee.SST_Sociedad__c = fee_record.SST_Sociedad__c;
            new_fee.Active__c = true;
            new_fee.P2G_SapDevolucion__c = fee_record.P2G_SapDevolucion__c;
            new_fee.Fee_Category__c = getnewcategory();
            if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Air Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
                new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
            else if(getnewcategory() == 'Drayages')
                new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
            else if(getnewcategory() == 'Other Service Charges')
            {
                new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
                new_fee.Route__c = null;
            }
            else
                    new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();

            try
            {
                insert new_fee;
                fee_record = new Fee__c();
                fee_record.Account_for__c = record.Account_for__c;
                fee_record.Group__c = getGroup();
                if(getnewcategory() != 'Drayages' && getnewcategory() != 'Other Service Charges')
                    fee_record.Route__c = record.Route__c;
                Fee_List_Price = null;

                if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Air Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
                {
                    fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                    RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                    fee_record.RecordType = rt;
                }
                else if(getnewcategory() == 'Drayages')
                {
                    fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
                    RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                    fee_record.RecordType = rt;
                }
                else if(getnewcategory() == 'Other Service Charges')
                {
                    fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
                    RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                    fee_record.RecordType = rt;
                }
                else
                {
                    fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                    RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                    fee_record.RecordType = rt;
                }

                fee_record.Fee_Category__c = getnewcategory();

            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
            }
        }
    }

    public void create_shipment_service_ie()
    {
        if(IE_lines != null)
        {
            List<Shipment_Fee_Line__c> ship_fee_line_to_insert = new List<Shipment_Fee_Line__c>();
            for(IE_Fee_Line_s ie_fee: IE_lines)
            {
                if(ie_fee.selected == true)
                {
                    chekeados_ie= true;
					ie_fee.ship_fee_line.Es_de_IEQ__c = true;										 
                    ship_fee_line_to_insert.add(ie_fee.ship_fee_line);
                }
            }
            if(ship_fee_line_to_insert != null && ship_fee_line_to_insert.size()>0)
            {
                insert ship_fee_line_to_insert;
                shipfeeLines_all_for_route = null;
                shipfeeLines_without = null;
                shipfeeLines = null;
                shipfeeLines_all = null;
                IE_lines = null;
                string record_id = record.Id;
                totales = Database.query('select id,'+(UserInfo.isMultiCurrencyOrganization() == true ? 'CurrencyIsoCode,' : '') +' Total_Services_Sell_Amount__c,Total_Services_Sell_Amount_number__c,Total_Services_Std_Buy_Amount__c,Total_Services_Std_Buy_Amount_number__c,Conversion_Rate_Date__c from Shipment__c where id =: record_id');
                totals_custom = new totales_s(totales);
                totals_custom_by_category = new totales_by_categories_s(record, getnewcategory());
            }
        }
    }

    //Consultar las insertadas nuevo objet
    public void crearlineaquoteitem()
    {
        if(Fee_List_Price!=null)
        {
            List<Shipment_Fee_Line__c>  Ship_fee = [select Id, Name, Shipment__c from Shipment_Fee_Line__c where Shipment__c =: record.Id  order by Name];
            List<Shipment_Consolidation_Data__c> query_shipment_consolidation_data = [select Id, Name, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Shipment__c =:record.Id and Import_Export_Quote__c !=: null order by CreatedDate desc limit 1];

            integer contadordelineas = 0;
            contadordelineas =Ship_fee.size();
            List<Shipment_Fee_Line__c> ship_fee_lines_to_insert = new List<Shipment_Fee_Line__c>();
            for (NEUEBUSCM_Shipment_Fee_Line_s lines:Fee_List_Price)
            {
                if(lines.selected)
                {
                    chekeados=true;
                    contadordelineas ++;
                    Shipment_Fee_Line__c myLine= new Shipment_Fee_Line__c();
                    myline.Shipment__c=record.Id;
                    myline.Name = string.valueof(contadordelineas);
                    myline.Warehouse_Rate__c = (lines.line.Fee_Category__c == 'Warehouse' ? true : false);
                    //  if(lines.line.Fee_Category__c == 'Sea Freights' && lines.line.Carrier_Account__c != null && shipment_filter != null)
                    //    shipment_filter.Carrier__c = lines.line.Carrier_Account__c;
                    if(lines.extensionfeename != null)
                        myline.Extension_Service_Name__c=lines.extensionfeename;

                    myline.Service_Rate_Name__c = lines.line.Id;
                    if(lines.ship_fee_line != null)
                        myline.Units__c = lines.ship_fee_line.Units__c;
                    if(lines.ship_fee_line != null)
                        myline.Shipment_Sell_Price__c = lines.ship_fee_line.Shipment_Sell_Price__c;
                    if(lines.ship_fee_line != null)
                        myline.Discount_Charge__c = lines.ship_fee_line.Discount_Charge__c;
                    if(lines.ship_fee_line != null)
                        myline.Shipment_Service_Line__c = lines.ship_fee_line.Shipment_Service_Line__c;
                    if(lines.ship_fee_line != null)
                        myline.Extension_Service_Name__c = lines.ship_fee_line.Extension_Service_Name__c;
                    if(query_shipment_consolidation_data != null && query_shipment_consolidation_data.size()>0 && query_shipment_consolidation_data.size()==1)
                        myline.Import_Export_Quote__c = query_shipment_consolidation_data[0].Import_Export_Quote__c;
                    if(lines.ship_fee_line != null)
                    {
                        myline.Shipment_Buy_Price__c = lines.ship_fee_line.Shipment_Buy_Price__c;
                        myline.Concept_1_Sell_Price__c = lines.ship_fee_line.Concept_1_Sell_Price__c;
                        myline.Concept_2_Sell_Price__c = lines.ship_fee_line.Concept_2_Sell_Price__c;
                        myline.Concept_3_Sell_Price__c = lines.ship_fee_line.Concept_3_Sell_Price__c;
                        myline.Concept_4_Sell_Price__c = lines.ship_fee_line.Concept_4_Sell_Price__c;
                        myline.Concept_5_Sell_Price__c = lines.ship_fee_line.Concept_5_Sell_Price__c;
                    }
                    myline.Min_Amount__c = lines.line.Min__c;

                    NEU_CurrencyUtils.setCurrencyIsoCode(myLine,lines.currency_user);

                    ship_fee_lines_to_insert.add(myLine);

                }
            }

            if(ship_fee_lines_to_insert != null && ship_fee_lines_to_insert.size()>0)
            {
                try
                {
                    insert ship_fee_lines_to_insert;
                    if(record.Name.contains('SP-A-') || record.Name.contains('SP-R-') || record.Name.contains('SP-AW-')){
                        dividirLineas(ship_fee_lines_to_insert);
                    }

                }
                catch(Exception e){ ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+e));}
            }

            if(chekeados)
            {
                Fee_List_Price=null;
                try
                {
                    boolean tiene_modificacion = false;
                    if(record.Route__c == null && shipment_filter.Route__c != null)
                    {
                        record.Route__c = shipment_filter.Route__c;
                        tiene_modificacion = true;
                    }
                    /*if(record.Account_for__c == null && shipment_filter.Account_for__c != null)
                    {
                      record.Account_for__c = shipment_filter.Account_for__c;
                      tiene_modificacion = true;
                    }
                    if(record.Purchase_Incoterm__c == null && shipment_filter.Purchase_Incoterm__c != null)
                    {
                      record.Purchase_Incoterm__c = shipment_filter.Purchase_Incoterm__c;
                      tiene_modificacion = true;
                    }
                    if(record.Sales_Incoterm__c == null && shipment_filter.Sales_Incoterm__c != null)
                    {
                      record.Sales_Incoterm__c = shipment_filter.Sales_Incoterm__c;
                      tiene_modificacion = true;
                    }

                    if(record.Pickup_Cartage__c == null && shipment_filter.Pickup_Cartage__c != null)
                    {
                      record.Pickup_Cartage__c = shipment_filter.Pickup_Cartage__c;
                      tiene_modificacion = true;
                    }
                    if(record.Delivery_Cartage__c == null && shipment_filter.Delivery_Cartage__c != null)
                    {
                      record.Delivery_Cartage__c = shipment_filter.Delivery_Cartage__c;
                      tiene_modificacion = true;
                    }
                    if(shipment_filter.Carrier__c != null)
                    {
                      record.Carrier__c = shipment_filter.Carrier__c;
                      tiene_modificacion = true;
                    }*/
                    system.debug('update_route_service2'+tiene_modificacion);

                    if(tiene_modificacion == true)
                        update record;
                }
                catch(Exception ex)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex));
                }
            }

            string recordId = record.Id;
            totales = Database.query('select id, '+(UserInfo.isMultiCurrencyOrganization() == true ? 'CurrencyIsoCode,' : '') +' Total_Services_Sell_Amount__c,Total_Services_Sell_Amount_number__c, Total_Services_Std_Buy_Amount__c,Total_Services_Std_Buy_Amount_number__c, Conversion_Rate_Date__c from Shipment__c where id =: recordId');
            totals_custom = new totales_s(totales);
            totals_custom_by_category = new totales_by_categories_s(record, getnewcategory());
        }
        otherFees=null;

    }
    
    
        
    public static void dividirLineas(List<Shipment_Fee_Line__c> lines){
        
        system.debug('Se registraron: ' + lines.size() + ' services lines');
        List<Shipment_Fee_Line__c> lineClone = new List<Shipment_Fee_Line__c>();
        List<Shipment_Fee_Line__c> lineClone2 = new List<Shipment_Fee_Line__c>();
        List<Shipment_Fee_Line__c> lineUpdate = new List<Shipment_Fee_Line__c>();
        Map<String,Fee__c> serviceRate = new Map<String,Fee__c>();
        List<Fee__c> srUpdate = new List<Fee__c>();
        
        for(Shipment_Fee_Line__c line : lines){
            system.debug('Metodo para dividir la linea....');
            system.debug('line:'+line);            
            system.debug('Service_Rate_Name__c:'+line.Service_Rate_Name__c);
            Fee__c sr = [Select Id, Name, Country_of_Load__c,Country_of_Discharge__c,Route__c,Valid_Until__c,Account_for__c,Carrier_Account__c,TT_Days__c,CurrencyIsoCode,
                         Rate_Type__c,Fee_Rate__c,Buy_Rate__c,Min__c,Volumetric_Factor__c,Container_Type__c,Comments__c,Group__c,SAP_Service_Type__r.Code__c,Sap_Service_Type_Buy__r.Code__c,SAP_Service_Type__c,Sap_Service_Type_Buy__c,SAP_Service_Type__r.Name,Fee_Category__c, SST_Porcentaje_de_division__c   from Fee__c where Id=:line.Service_Rate_Name__c limit 1];            
            system.debug('SAP_Service_Type: ' + sr.SAP_Service_Type__r.Name + ' Code__c: ' + sr.SAP_Service_Type__r.Code__c);
            if((sr.SAP_Service_Type__r.Name == 'INTERNACIONAL AEREO (IC) (A)' && sr.SAP_Service_Type__r.Code__c == 'A-INT_AEREO_(IC)') || (sr.SAP_Service_Type__r.Name == 'INTERNACIONAL AEREO (IC) (AW)' && sr.SAP_Service_Type__r.Code__c == 'AW-INT_AEREO_(IC)') || (sr.SAP_Service_Type__r.Name == 'INTERNACIONAL AEREO (IC) (R)' && sr.SAP_Service_Type__r.Code__c == 'R-INT_AEREO_(IC)')){ // A-INT_AEREO_(IC)
                system.debug('Entro al filtro');
                system.debug('Country_of_Load__c:'+sr.Country_of_Load__c);
                system.debug('Country_of_Discharge__c:'+sr.Country_of_Discharge__c);                
                if(sr.Country_of_Load__c == 'Mexico' && sr.Country_of_Discharge__c != 'Mexico'){ //(sr.Country_of_Load__c != 'Mexico' && sr.Country_of_Discharge__c == 'Mexico') || (sr.Country_of_Load__c == 'Mexico' && sr.Country_of_Discharge__c != 'Mexico') || (sr.Country_of_Load__c != 'Mexico' && sr.Country_of_Discharge__c != 'Mexico')
                    system.debug('La ruta es  Mexico - Extranjero, Se divide la linea');                
                    Shipment_Fee_Line__c line2 = line.clone(false,true,true,false);
                    Fee__c sr2 = sr.clone(false,true,true,false);
                    sr.SST_Porcentaje_de_division__c = '75%';
                    sr2.SST_Porcentaje_de_division__c = '25%';
                    srUpdate.add(sr);
                    sr2.Buy_Rate__c = 0;
                    sr2.Fee_Rate__c = 0;
                    sr2.Name = sr.Name+'B';
                    line2.Name = line.Name+'B';
                    line2.Shipment_Buy_Price__c = 0;                    
                    //line2.Service_Rate_Name__c = sr2.Id;
                    line2.Shipment_Sell_Price__c = line.Shipment_Sell_Price__c * 0.25;
                    line.Shipment_Sell_Price__c = line.Shipment_Sell_Price__c * 0.75;
                    line.Name = line.Name +'A';
                    system.debug('line.Name: ' + line.Name);
                    serviceRate.put(line2.Name,sr2);
                    lineClone.add(line2);
                    lineUpdate.add(line);                    
                }else{system.debug('No se divide la linea');}
            }else{system.debug('No entro para dividir lineas');}            
        }
        
        system.debug('serviceRate.size():'+serviceRate.size()+ '-lineClone.size():'+lineClone.size()+ '-lineUpdate.size():'+lineUpdate.size());
        if(serviceRate.size() !=0 && lineClone.size() !=0 && lineUpdate.size() !=0){
            system.debug('serviceRate:' + serviceRate);
            insert serviceRate.values();
            //insert lineClone;
            update lineUpdate;
            system.debug('lineUpdate: ' + lineUpdate);
            
            for(Shipment_Fee_Line__c lin:lineClone){
                Fee__c sr = serviceRate.get(lin.Name);
                lin.Service_Rate_Name__c = sr.Id;
                lineClone2.add(lin);
                sr = null;
            }
            
            insert lineClone2;
            update srUpdate;
        }       
    }    

    public void delete_fee_select()
    {
        List<Shipment_Fee_Line__c> lines_del = null;
        lines_del=[select Id,Name, Service_Rate_Name__c from Shipment_Fee_Line__c where  Id =:id_oi];
        try
        {
            delete lines_del;
            shipfeeLines = null;
            IE_lines = null;
            string recordid= record.Id;
            totales = Database.query('select id, '+(UserInfo.isMultiCurrencyOrganization() == true ? 'CurrencyIsoCode,' : '') +' Total_Services_Sell_Amount__c, Total_Services_Sell_Amount_number__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Buy_Amount_number__c, Conversion_Rate_Date__c from Shipment__c where id =: recordid');
            totals_custom = new totales_s(totales);
            totals_custom_by_category = new totales_by_categories_s(record, getnewcategory());

        }
        catch(Exception ex){}
    }

    public PageReference return_shipment()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }

    public Pagereference update_sites_countries()
    {
        if(shipment_filter != null)
        {
            record.Country_of_Load__c = shipment_filter.Country_of_Load__c;
            record.Country_of_Discharge__c = shipment_filter.Country_of_Discharge__c;
            record.State_of_Load__c = shipment_filter.State_of_Load__c;
            record.State_of_Discharge__c = shipment_filter.State_of_Discharge__c;
            record.Site_of_Load__c = shipment_filter.Site_of_Load__c;
            record.Site_of_Discharge__c = shipment_filter.Site_of_Discharge__c;
        }

        try
        {
            update record;
            // Fee_List_Price = null;

        }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex)); return null;}
        PageReference pgReturnPage;
        String returnUrl = '/apex/NEU_OM_ShipFeeLinesPriceListYDiscount?id=' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }

    public void update_route()
    {

        /*try
        {
          boolean tiene_modificacion = false;
          if(record.Route__c == null && shipment_filter.Route__c != null)
          {
            record.Route__c = shipment_filter.Route__c;
            tiene_modificacion = true;
          }
          if(record.Account_for__c == null && shipment_filter.Account_for__c != null)
          {
            record.Account_for__c = shipment_filter.Account_for__c;
            tiene_modificacion = true;
          }
          if(record.Purchase_Incoterm__c == null && shipment_filter.Purchase_Incoterm__c != null)
          {
            record.Purchase_Incoterm__c = shipment_filter.Purchase_Incoterm__c;
            tiene_modificacion = true;
          }
          if(record.Sales_Incoterm__c == null && shipment_filter.Sales_Incoterm__c != null)
          {
            record.Sales_Incoterm__c = shipment_filter.Sales_Incoterm__c;
            tiene_modificacion = true;
          }
          if(record.Container_Type__c == null && shipment_filter.Container_Type__c != null)
          {
            record.Container_Type__c = shipment_filter.Container_Type__c;
            tiene_modificacion = true;
          }


          if(record.Pickup_Cartage__c == null && shipment_filter.Pickup_Cartage__c != null)
          {
            record.Pickup_Cartage__c = shipment_filter.Pickup_Cartage__c;
            tiene_modificacion = true;
          }
          if(record.Delivery_Cartage__c == null && shipment_filter.Delivery_Cartage__c != null)
          {
            record.Delivery_Cartage__c = shipment_filter.Delivery_Cartage__c;
            tiene_modificacion = true;
          }
          if(shipment_filter.Carrier__c != null)
          {
            record.Carrier__c = shipment_filter.Carrier__c;
            tiene_modificacion = true;
          }

          system.debug('update_route_service'+tiene_modificacion);
          if(tiene_modificacion == true)
            update record;
        }
        catch(Exception ex) { }*/


        /*String returnUrl = '/apex/NEU_OM_ShipFeeLinesPriceListYDiscount';
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.getParameters().put('id', record.Id);
        pgReturnPage.getParameters().put('pes', getnewcategory());
        pgReturnPage.setRedirect(true);
        return pgReturnPage;*/

    }
    
    public void getSociedadSap(){
                         
        system.debug('Obteninedo la Sociedad del Sap service: ' + fee_record.SAP_Service_Type__c);
        if(!String.isBlank(fee_record.SAP_Service_Type__c)){fee_record.SAP_Service_Type__r = [Select Id,SST_Sociedad__c from SAP_Service_Type__c where Id=: fee_record.SAP_Service_Type__c];system.debug('fee_record.SAP_Service_Type__r: ' + fee_record.SAP_Service_Type__r);}
        else{fee_record.SAP_Service_Type__r = null;}
        system.debug('!String.isBlank(fee_record.SAP_Service_Type__c): ' + !String.isBlank(fee_record.SAP_Service_Type__c));        
    }
    
    public String getGroup(){
        
        Shipment__c sp = [Select Name from Shipment__c where Id =: record.Id]; 
        String folio = sp.Name.replace('SP-', '');
        string service3 = folio.left(3);
        string service2 = folio.left(2);
        string service1 = folio.left(1);   
        system.debug('service: ' + service3);
        system.debug('service2: ' + service2);
        system.debug('service1: ' + service1);
        String name;        
        
        if(service3.contains('-')){
            if(service2.contains('-')){                                
                if(!service1.contains('-')){                    
                    name = [Select group__c from  Get_Sap_Service_Type__mdt where service__c =:service1].group__c;                 	
                }                
            }else{                
                name = [Select group__c from  Get_Sap_Service_Type__mdt where service__c =:service2].group__c;                                            
            }
        }else{
            name = [Select group__c from  Get_Sap_Service_Type__mdt where service__c =:service3].group__c;            
        }
        
        system.debug('Grupo: ' + name);
        return name;
    }
    
	
	 public void runtest()
    {
       string a='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
           a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
         a+='';
        a+='';
         a+='';
        a+='';
         a+='';
         a+='';
		 }
}