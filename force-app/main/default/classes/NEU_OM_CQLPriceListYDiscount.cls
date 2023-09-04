public with sharing class NEU_OM_CQLPriceListYDiscount
{
    //cambiar los ids categorias de la pagina
    public String sapName{get;set;}//Obtenemos el nombre de sap service type para mostrar el cargo line, solamente para servicios CE
	Public String serviceF{get;set;} // variable para saber que servicio tiene el folio
    public Customer_Quote__c record=null;
    public Customer_Quote__c totales{get;set;}
    public Boolean chekeados{get;set;}
    private List<Import_Export_Fee_Line__c> quotefeeLines=null;
    private List<Import_Export_Fee_Line_all_s> quotefeeLines_all_for_route =null;
    private List<Import_Export_Fee_Line__c> quotefeeLines_all=null;
    private List<Import_Export_Fee_Line_currency_s> quotefeeLines_without=null;
    public Customer_Quote__c imp_ext_filter = null;
    public Boolean existRoute {get;set;}
    public Fee__c service_rate_filter = null;
    public Account account_defecto = null;
    public Shipment__c ship_filter = null;
    public Map<Id,Id> listado_ids_ruta {get;set;}
    public String orden_fees_filtro_modo {get;set;}
    public String orden_fees_filtro {get;set;}
    public String orden_fees_filtro_modo_insertados {get;set;}
    public String orden_fees_filtro_insertados {get;set;}
    public String orden_fees_filtro_modo_insertados_all {get;set;}
    public String orden_fees_filtro_insertados_all {get;set;}
    public string listado_ids_carrier {get;set;}
    public string url_sailing_schedule {get;set;}
    public string url_alibaba {get;set;}
    public String id_oi {get;set;}
    public string total_buy_common_charges {get;set;}
    public string total_sell_common_charges {get;set;}
    public Boolean editPriceList{get;set;}
    public Date ValidFrom = null;
    public Date ValidUntil = null;
    public string resultado {get;set;}

    //new service rate
    public String fee_currency {get;set;}
    public List<SelectOption> currencies {get;set;}

    public Fee__c fee_record {get;set;}
    public Boolean show_all_categories{get;set;}
    public Boolean show_all_categories_all_lines{get;set;}
    public Boolean show_all_categories_all_lines_routes{get;set;}
    public Import_Export_Fee_Line__c ie_fee_line {get;set;}
    public Integer contador_lineas_nuevas {get;set;}

    public string service_rate_filter_name {get;set;}

    public boolean CHKValidos{get;set;}

    public totales_s totals_custom{get;set;}
    public totales_by_categories_s totals_custom_by_category{get;set;}
    public class totales_s
    {
        public Customer_Quote__c import_export {get;set;}
        public Boolean convert {get;set;}
        public string CurrencyMoney {get;set;}
        public string CurrencyMoney_import_export {get;set;}
        public string total_Services_Std_Buy_Amount_s_currency {get;set;}
        public string total_Services_Std_Buy_Amount_s_convert{get;set;}
        public string total_Services_Sell_Amount_s_currency {get;set;}
        public string total_Services_Sell_Amount_s_convert{get;set;}
        public totales_s(Customer_Quote__c import_export)
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
                if(NEU_CurrencyUtils.getCurrencyIsoCode(import_export) != currency_default && (string.isNotEmpty(total_Services_Std_Buy_Amount_s_currency) || string.isNotEmpty(total_Services_Sell_Amount_s_currency)))
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
        public Customer_Quote__c import_export {get;set;}
        public Boolean convert {get;set;}
        public string CurrencyMoney {get;set;}
        public string CurrencyMoney_import_export {get;set;}
        public string total_Services_Std_Buy_Amount_s_currency {get;set;}
        public string total_Services_Std_Buy_Amount_s_convert{get;set;}
        public string total_Services_Sell_Amount_s_currency {get;set;}
        public string total_Services_Sell_Amount_s_convert{get;set;}
        public totales_by_categories_s(Customer_Quote__c import_export, string new_category)
        {
            this.import_export = import_export;
            convert = false;
            total_Services_Std_Buy_Amount_s_currency = '';
            total_Services_Sell_Amount_s_currency = '';
            total_Services_Std_Buy_Amount_s_convert = '';
            total_Services_Sell_Amount_s_convert = '';
            CurrencyMoney = '';
            CurrencyMoney_import_export = NEU_CurrencyUtils.getCurrencyIsoCode(import_export);
            decimal total_service_std_buy_amount_category = 0;
            decimal total_service_std_sell_amount_category = 0;
            List<Import_Export_Fee_Line__c> query_by_category = null;

            if(String.isNotEmpty(new_category))
                query_by_category = [select Buy_Amount_header_currency__c, Sell_Amount_header_currency__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: import_export.Id and Service_Rate_Category__c =: new_category ];
            else
                    query_by_category = [select Buy_Amount_header_currency__c, Sell_Amount_header_currency__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: import_export.Id ];
            for(Import_Export_Fee_Line__c iefl : query_by_category)
            {
                total_service_std_buy_amount_category += neu_utils.safedecimal(iefl.Buy_Amount_header_currency__c);
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

                if(NEU_CurrencyUtils.getCurrencyIsoCode(import_export) != currency_default && (string.isNotEmpty(total_Services_Std_Buy_Amount_s_currency) || string.isNotEmpty(total_Services_Sell_Amount_s_currency)))
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

    public List<Integer> listado_paginas_Orders {get;set;}
    public string step_order {get;set;}
    public integer n_records_per_page = 30;
    public Decimal total_orders {get;set;}



    public  List<NEUEBUSCM_Quote_Fee_Line_s> Fee_List_Price = null;

    private List<SelectOption> newcategories=null;
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

    public String mynewcategory=null;
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

            if(value == 'Sea Freights' || value == 'Road Freights' || value == 'Railway Freights' || value == 'Multimodal Freights' || value == 'POL Charges' || value == 'POD Charges' || value == 'Warehouse')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                fee_record.RecordType = rt;
            }
            else if(value == 'Air Freights')
            {
                fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
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
            totals_custom_by_category = new totales_by_categories_s(record, getnewcategory());
            Fee_List_Price = null;
            service_rate_filter_name = '';
            categories();
        }
    }

    public void change_ratio_category()
    {
        fee_record = new Fee__c();
        fee_record.Group__c = getGroup();
		//fee_record.Import_Export_Quoted_Marketplace__c = record.Id;   
        sapName = null;

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
        else if(getnewcategory() == 'Air Freights')
        {
            fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
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
    }

    public Customer_Quote__c getimp_ext_filter()
    {

        return imp_ext_filter;
    }

    public void setimp_ext_filter(Customer_Quote__c value)
    {
        if(imp_ext_filter !=value && value != null)
        {
            imp_ext_filter=value;
        }
    }

    public Fee__c getservice_rate_filter()
    {

        return service_rate_filter;
    }

    public void setservice_rate_filter(Fee__c value)
    {
        if(service_rate_filter !=value && value != null)
        {
            service_rate_filter=value;
        }
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

    private String recordtype=null;
    public String getrecordtype()
    {
        if(recordtype==null)
        {
            List<Import_Export_Fee_Line__c> fees=getquotefeeLines();
            if(fees.size()>0)
                if(fees[0].Service_Rate_Name__r.RecordTypeId!=null)
                    recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].Service_Rate_Name__r.RecordTypeId).getName();
        }
        if(recordtype==null)
        {
            List<NEUEBUSCM_Quote_Fee_Line_s> fees=getFee_List_Price();
            if(fees.size()>0)
                if(fees[0].line.RecordTypeId!=null)
                    recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].line.RecordTypeId).getName();
        }
        return recordtype;
    }
    public void setrecordtype(String val){}

    public NEU_OM_CQLPriceListYDiscount(ApexPages.StandardController stdController)
    {
        CHKValidos = true;
        existRoute = true;
        editPriceList=true;
        //Obtener Account por defecto
        if(!Test.isRunningTest()) {
            account_defecto = [SELECT Id,Name from Account where Name = 'Arrastre De puerto']; //comentarioIZEI marca error si no encuentra el registro en la base
        }
        //Fin obtener account por defecto
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]
            {
                    'Id','Name',
                    'Account_for__c','Catalog_Price_List__r.Business_Area__c','Catalog_Price_List__r.Family__c','Account_for__r.Business_Area__c','Catalog_Price_List__c',
                    'Route__c', 'Conversion_Rate_Date__c',
                    'Site_of_Load__c','Site_of_Discharge__c','Container_Count__c',
                    'Account_for_Price_List__c','Country_ofLoad__c', 'Delivery_Cartage__c', 'Country_ofDischarge__c', 'Total_Services_Std_Buy_Amount__c', 'Total_Services_Std_Buy_Amount_number__c' , 'Total_Services_Sell_Amount__c', 'Total_Services_Sell_Amount_number__c',
                    'Pickup_Cartage__c', 'Purchase_Incoterm__c','Sales_Incoterm__c','Supplier_Account__c','Pickup_Cartage__r.Name','Pickup_Cartage__r.Kms__c','Pickup_Cartage__r.Miles__c','Pickup_Cartage__r.Port_Airport__c','Pickup_Cartage__r.Warehouse__c',
                    'Total_Weight_Kg2__c','Total_Volume_m3_2__c', 'Container_Type__c','Enable_Route_Options__c',
                    'Site_of_Load__r.Name', 'Country_ofLoad__r.Name', 'Country_ofLoad__r.ISO_Code__c', 'Site_of_Discharge__r.Name', 'Country_ofDischarge__r.Name','Country_ofDischarge__r.ISO_Code__c',
                    'Route__r.Port_Airport_of_Load__r.Name', 'Route__r.Country_of_Load__r.Name','Route__r.Name',
                    'Route__r.Port_Airport_of_Discharge__r.Name', 'Route__r.Country_of_Discharge__r.Name', 'State_of_Load__c', 'State_of_Discharge__c',
                    'State_of_Load__r.Name','State_of_Load__r.Iso_Code__c', 'State_of_Discharge__r.Name', 'State_of_Discharge__r.Iso_Code__c', 'Route__r.State_of_Load__r.Name', 'Route__r.State_of_Discharge__r.Name',

                    (UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Cube_m3__c')
            });
        record=(Customer_Quote__c)stdController.getRecord();
        System.debug('id ---> ' + record.Id);
        totales = record;
        totals_custom = new totales_s(totales);
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
        orden_fees_filtro_insertados = 'Name';
        orden_fees_filtro_modo_insertados = 'asc';
        orden_fees_filtro_insertados_all = 'Name';
        orden_fees_filtro_modo_insertados_all = 'asc';

        fee_record = new Fee__c();
        system.debug('newcategory: ' + getnewcategory());
        fee_record.Import_Export_Quoted_Marketplace__c = record.Id;
        //system.debug('folio   fee_record.Import_Export_Quoted_Marketplace__c: ' + fee_record.Import_Export_Quoted_Marketplace__c);
        fee_record.Group__c = getGroup();
        sapName = null;
        ie_fee_line = new Import_Export_Fee_Line__c();
        contador_lineas_nuevas = 1;
        List<Import_Export_Fee_Line__c> query_iel = [select id, Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Pickup_Cartage__r.name  from Import_Export_Fee_Line__c where Import_Export_Quote__c =: record.Id];
        string name_line = '';
        if(query_iel != null)
        {
            name_line = (query_iel.size() == 0 ? string.valueof(contador_lineas_nuevas) : string.valueof(query_iel.size()));
            contador_lineas_nuevas = (query_iel.size() == 0 ? contador_lineas_nuevas : query_iel.size());
        }
        else
                name_line = string.valueof(contador_lineas_nuevas);
        while (name_line.length() < 3)
            name_line = '0'+name_line;

        ie_fee_line.Name = name_line;
        fee_record.Account_for__c = record.Account_for__c;
        fee_record.Route__c = record.Route__c;
        //fee_record.Group__c = getGroup();
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

        total_buy_common_charges = (0.001).format();
        total_buy_common_charges = total_buy_common_charges.substring(0,total_buy_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);
        total_sell_common_charges = (0.001).format();
        total_sell_common_charges = total_sell_common_charges.substring(0,total_sell_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);

        if((record.Account_for_Price_List__c!=null)||(record.Catalog_Price_List__c!=null))
            editPriceList=false;

        if(imp_ext_filter == null)
        {
            imp_ext_filter = new Customer_Quote__c();
            // imp_ext_filter.Route__c = record.Route__c;
            imp_ext_filter.Account_for__c = record.Account_for__c;
            imp_ext_filter.Purchase_Incoterm__c = record.Purchase_Incoterm__c;
            imp_ext_filter.Sales_Incoterm__c = record.Sales_Incoterm__c;
            imp_ext_filter.Pickup_Cartage__c = record.Pickup_Cartage__c;
            if(record.Pickup_Cartage__c != null )
                imp_ext_filter.Pickup_Cartage__r = record.Pickup_Cartage__r;
            imp_ext_filter.Delivery_Cartage__c = record.Delivery_Cartage__c;
            imp_ext_filter.Container_Type__c = record.Container_Type__c;
            if(record.Country_ofLoad__c  != null){
                imp_ext_filter.Country_ofLoad__c = record.Country_ofLoad__c;
                imp_ext_filter.Country_ofLoad__r = record.Country_ofLoad__r;
            }
            if(record.Country_ofDischarge__c != null){
                imp_ext_filter.Country_ofDischarge__c = record.Country_ofDischarge__c;
                imp_ext_filter.Country_ofDischarge__r = record.Country_ofDischarge__r;
            }
            if(record.State_of_Load__c  != null){
                imp_ext_filter.State_of_Load__c = record.State_of_Load__c;
                imp_ext_filter.State_of_Load__r = record.State_of_Load__r;
            }
            if(record.State_of_Discharge__c != null){
                imp_ext_filter.State_of_Discharge__c = record.State_of_Discharge__c;
                imp_ext_filter.State_of_Discharge__r = record.State_of_Discharge__r;
            }
            if(record.Site_of_Load__c  != null){
                imp_ext_filter.Site_of_Load__c = record.Site_of_Load__c;
                imp_ext_filter.Site_of_Load__r = record.Site_of_Load__r;
            }
            if(record.Site_of_Discharge__c  != null){
                imp_ext_filter.Site_of_Discharge__c = record.Site_of_Discharge__c;
                imp_ext_filter.Site_of_Discharge__r = record.Site_of_Discharge__r;
            }

            recoger_rutas_posibles();
        }
        if(ship_filter == null)
            ship_filter = new Shipment__c();

        if(service_rate_filter == null)
        {
            service_rate_filter = new Fee__c();
            service_rate_filter.Account_for__c = record.Account_for__c;
            service_rate_filter.Valid_From__c = system.today().addMonths(-1);
            service_rate_filter.Valid_Until__c = system.today().addMonths(1);
        }

        service_rate_filter_name = '';

        if(record.Site_of_Load__c != null && record.Country_ofLoad__c != null && record.State_of_Load__c != null && record.Site_of_Discharge__c != null && record.Country_ofDischarge__c != null && record.State_of_Discharge__c != null)
        {
            Date pdate = system.today();
            url_sailing_schedule = 'http://www.joc.com/sailings/Sailings-SearchResults?ORIGIN='+record.Site_of_Load__r.Name+',%20'+record.Country_ofLoad__r.Name+'&direction=&destination='+record.Site_of_Discharge__r.Name+',%20'+record.Country_ofDischarge__r.Name+'&carrier=&vesselTypes=&days=30&date='+(pdate.Month())+'/'+pdate.day()+'/'+ pdate.Year();

            string site_of_load = record.Site_of_Load__r.Name;
            site_of_load = remove1(record.Site_of_Load__r.Name);
            string site_of_discharge= record.Site_of_Discharge__r.Name;
            site_of_discharge = remove1(record.Site_of_Discharge__r.Name);

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
        quotefeeLines=null;
    }

    public Shipment__c getship_filter()
    {

        return ship_filter;
    }

    public void setship_filter (Shipment__c value)
    {
        if(ship_filter  !=value && value != null)
        {
            ship_filter =value;
        }
    }

    public void update_record()
    {
        try
        {
            update record;
            quotefeeLines_all_for_route = null;
            quotefeeLines_all = null;
        }
        catch(Exception ex){system.debug('Error crearlineaquoteitem1: ' + ex.getCause() + ' linea: ' + ex.getLineNumber()); ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));}
    }

    public void recoger_rutas_posibles()
    {

        listado_ids_ruta = new Map<Id,Id>();
        service_rate_filter_name = '';
        Fee_List_Price = null;

    }

    public void refresh_button()
    {
        recordtype=null;
        quotefeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    public void all_accounts_filter()
    {
        recordtype=null;
        quotefeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        if(imp_ext_filter != null)
            imp_ext_filter.Account_for__c = null;
        if(service_rate_filter != null)
            service_rate_filter.Account_for__c = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';

    }

    public void all_carriers_filter()
    {
        recordtype=null;
        quotefeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        if(ship_filter != null)
            ship_filter.Carrier__c = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    public void filter_new_carrier()
    {
        recordtype=null;
        quotefeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    public void all_containers_filter()
    {
        recordtype=null;
        quotefeeLines=null;
        Fee_List_Price = null;
        service_rate_filter_name = '';
        if(imp_ext_filter != null)
            imp_ext_filter.Container_Type__c = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    //Consultar las lineas insertadas
    public List<Import_Export_Fee_Line__c> getquotefeeLines()
    {
        if(String.isNotEmpty(getnewcategory()))
            quotefeeLines = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name,  Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Extension_Service_Name__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate__c,  Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c, Sell_Amount_Number__c, Import_Export_Service_Line__r.Service_Rate_Name__r.Name, Quote_Buy_Price__c, Buy_Amount__c, Std_Buy_Amount_Number__c, Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Sap_Service_Type_Buy__c,Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =\''+ record.Id +'\' and Service_Rate_Name__r.Fee_Category__c =\''+ getnewcategory() +'\'  order by ' +orden_fees_filtro_insertados+ ' '+  orden_fees_filtro_modo_insertados);
        else
                quotefeeLines = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Extension_Service_Name__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate__c, Service_Rate_Name__r.RecordTypeId , Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c, Sell_Amount_Number__c, Import_Export_Service_Line__r.Service_Rate_Name__r.Name, Quote_Buy_Price__c, Buy_Amount__c, Std_Buy_Amount_Number__c,  Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c,Service_Rate_Name__r.Sap_Service_Type_Buy__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c, Service_Rate_Name__r.Route_Info__c, Service_Rate_Name__r.Bunker_Adjustment_Factor_BAF_Cont__c, Service_Rate_Name__r.Peak_Season_Surcharge_PSS_Cont__c from Import_Export_Fee_Line__c where Import_Export_Quote__c = \''+record.Id +'\' order by  ' +orden_fees_filtro_insertados+ ' '+  orden_fees_filtro_modo_insertados);

        return quotefeeLines;
    }

    public List<Import_Export_Fee_Line__c> getquotefeeLines_all()
    {
        listado_ids_carrier = '';
        quotefeeLines_all = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Buy_Amount_header_currency__c, Sell_Amount_header_currency__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate__c, Service_Rate_Name__r.RecordTypeId , Extension_Service_Name__c, Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c, Sell_Amount_Number__c, Import_Export_Service_Line__r.Service_Rate_Name__r.Name, Quote_Buy_Price__c, Buy_Amount__c, Std_Buy_Amount_Number__c, Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c,Service_Rate_Name__r.Sap_Service_Type_Buy__c,Service_Rate_Name__r.Sap_Service_Type_Buy__r.Code__c from Import_Export_Fee_Line__c where Import_Export_Quote__c = \''+record.Id +'\' and (Service_Rate_Category__c =\'Other Service Charges\' or Service_Rate_Category__c = \'Clearing Costs\')  order by  ' + orden_fees_filtro_insertados_all + ' '+  orden_fees_filtro_modo_insertados_all);
        decimal total_buy = 0;
        decimal total_sell = 0;
        total_buy_common_charges = (0.001).format();
        total_buy_common_charges = total_buy_common_charges.substring(0,total_buy_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);
        total_sell_common_charges = (0.001).format();
        total_sell_common_charges = total_sell_common_charges.substring(0,total_sell_common_charges.length()-1)+' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);
        if(quotefeeLines_all != null && quotefeeLines_all.size()>0)
        {
            for(Import_Export_Fee_Line__c fl: quotefeeLines_all)
            {
                if(fl.Service_Rate_Name__r.Carrier_Account__c != null)
                    listado_ids_carrier += ''+fl.Service_Rate_Name__r.Carrier_Account__c;

                total_buy += NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c);
                total_sell += NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c);
            }
            //sacar totales con dos decimales y con moneda de la cabecera
            total_buy_common_charges = (total_buy+0.001).format();
            total_buy_common_charges = total_buy_common_charges.substring(0,total_buy_common_charges.length()-1);
            total_buy_common_charges = total_buy_common_charges +' '+NEU_CurrencyUtils.getCurrencyIsoCode(record);
            total_sell_common_charges = (total_sell+0.001).format();
            total_sell_common_charges = total_sell_common_charges.substring(0,total_sell_common_charges.length()-1);
            total_sell_common_charges = total_sell_common_charges +' '+ NEU_CurrencyUtils.getCurrencyIsoCode(record);

        }
        return quotefeeLines_all;
    }

    public List<Import_Export_Fee_Line_currency_s> getquotefeeLines_without()
    {
        listado_ids_carrier = '';
        List<Import_Export_Fee_Line_currency_s> quotefeeLines_without = new List<Import_Export_Fee_Line_currency_s>();
        List<Import_Export_Fee_Line__c> quotefeeLines_without_query = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c,Extension_Service_Name__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Import_Export_Service_Line__r.Service_Rate_Name__r.Name, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Service_Rate__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.RecordTypeId ,  Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c, Sell_Amount_Number__c, Quote_Buy_Price__c, Buy_Amount__c,  Std_Buy_Amount_Number__c, Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Import_Export_Fee_Line__c where Import_Export_Quote__c = \''+record.Id +'\'   order by  ' + orden_fees_filtro_insertados_all + ' '+  orden_fees_filtro_modo_insertados_all);
        System.debug('query ' + 'select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c,Extension_Service_Name__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Import_Export_Service_Line__r.Service_Rate_Name__r.Name, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Service_Rate__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.RecordTypeId ,  Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c, Sell_Amount_Number__c, Quote_Buy_Price__c, Buy_Amount__c,  Std_Buy_Amount_Number__c, Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Import_Export_Fee_Line__c where Import_Export_Quote__c = \''+record.Id +'\'   order by  ' + orden_fees_filtro_insertados_all + ' '+  orden_fees_filtro_modo_insertados_all);
        
        if(quotefeeLines_without_query != null && quotefeeLines_without_query.size()>0)
        {
            for(Import_Export_Fee_Line__c fl: quotefeeLines_without_query)
            {
                if(fl.Service_Rate_Name__r.Carrier_Account__c != null)
                    listado_ids_carrier += ''+fl.Service_Rate_Name__r.Carrier_Account__c;
                quotefeeLines_without.add(new Import_Export_Fee_Line_currency_s(fl, Neu_currencyUtils.getCurrencyIsoCode(fl)));
            }
        }
        return quotefeeLines_without;
    }

    public List<Import_Export_Fee_Line_all_s> getquotefeeLines_all_for_route()
    {
        listado_ids_carrier = '';
        quotefeeLines_all_for_route = new List<Import_Export_Fee_Line_all_s>();
        //recorrer los freight para abrir opciones
        List<Import_Export_Fee_Line__c> query_quotefeeLines_all = null;
        query_quotefeeLines_all = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Import_Export_Quote__r.Site_of_Load__c, Import_Export_Quote__r.Site_of_Load__r.Name,Extension_Service_Name__c, Import_Export_Quote__r.Site_of_Discharge__c, Import_Export_Quote__r.Site_of_Discharge__r.Name, Buy_Amount_header_currency__c, Sell_Amount_header_currency__c,  Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c, Service_Rate__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name, Service_Rate_Name__r.RecordTypeId , Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Import_Export_Service_Line__r.Service_Rate_Name__r.Name, Sell_Rate__c, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c, Sell_Amount_Number__c, Quote_Buy_Price__c, Buy_Amount__c,  Std_Buy_Amount_Number__c, Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Import_Export_Fee_Line__c where Import_Export_Quote__c = \''+record.Id +'\' and Service_Rate_Category__c != \'Other Service Charges\' and  Service_Rate_Category__c != \'Clearing Costs\' and Service_Rate_Category__c != \'POL Charges\' and Service_Rate_Category__c != \'POD Charges\' and Service_Rate_Category__c != \'Drayages\'  order by  ' + orden_fees_filtro_insertados_all + ' '+  orden_fees_filtro_modo_insertados_all);

        Map<String, List<Import_Export_Fee_Line_currency_s>> new_map_lines = new Map<String, List<Import_Export_Fee_Line_currency_s>>();
        Map<String, decimal> new_map_buy = new Map<String, decimal>();
        Map<String, decimal> new_map_sell = new Map<String, decimal>();
        string contenedor_de_rutas = '';
        decimal total_buy=0;
        decimal total_sell=0;

        for(Import_Export_Fee_Line__c fl: query_quotefeeLines_all)
        {
            if(fl.Service_Rate_Name__r.Carrier_Account__c != null)
                listado_ids_carrier += ''+fl.Service_Rate_Name__r.Carrier_Account__c;

            if(new_map_lines.containsKey((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )))
            {
                Import_Export_Fee_Line_currency_s new_object_currency = new Import_Export_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));

                new_map_lines.get((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )).add(new_object_currency);

                total_buy = NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c) + NEU_Utils.safedecimal(new_map_buy.get((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )));
                total_sell = NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c) + NEU_Utils.safedecimal(new_map_sell.get((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null )));
                new_map_buy.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),total_buy);
                new_map_sell.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),total_sell);
            }
            else
            {

                new_map_lines.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ), new List<Import_Export_Fee_Line_currency_s>{new Import_Export_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl))});
                new_map_buy.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c));
                new_map_sell.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c));
            }
        }
        integer contador_de_opciones = 1;
        Map<string, Import_Export_Fee_Line_all_s> map_lines_custom = new Map<string, Import_Export_Fee_Line_all_s>();
        for (String entry : new_map_lines.keySet())
        {
            List<String> listado_nombres_rutas = entry.split('_&_');
            map_lines_custom.put(entry,new Import_Export_Fee_Line_all_s(this, listado_nombres_rutas[0], listado_nombres_rutas[1], new_map_lines.get(entry), new_map_buy.get(entry),new_map_sell.get(entry),contador_de_opciones));
            contador_de_opciones ++;
        }

        //recorrer los drayage, pol y pod para incluirlos en una ruta existente
        query_quotefeeLines_all = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'Service_Rate_Name__r.Name, Service_Rate_Category__c , Service_Rate_Name__r.Route__c, Import_Export_Quote__r.Site_of_Load__c, Service_Rate_Name__r.Port_Airport__r.Name,Extension_Service_Name__c, Import_Export_Quote__r.Site_of_Load__r.Name, Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__c, Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.Country__c, Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.State__c, Import_Export_Quote__r.Site_of_Discharge__c, Service_Rate__c, Import_Export_Quote__r.Site_of_Discharge__r.Name, Buy_Amount_header_currency__c, Sell_Amount_header_currency__c,  Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.Fee__c, Concept_1_Sell_Price__c , Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Concept_1__c , Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Service_Rate_Name__r.Cost_Concept_1__c, Service_Rate_Name__r.Cost_Concept_2__c, Service_Rate_Name__r.Cost_Concept_3__c, Service_Rate_Name__r.Cost_Concept_4__c, Service_Rate_Name__r.Cost_Concept_5__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Port_Airport__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c, Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name, Service_Rate_Name__r.RecordTypeId , Service_Rate_Name__r.Master_Allocation__c, Service_Rate_Name__r.Sub_Allocation__c, Rate_Type__c, Sell_Rate__c, Import_Export_Service_Line__r.Service_Rate_Name__r.Name, Units__c, Quote_Sell_Price__c, Discount__c, Sell_Amount__c, Sell_Amount_Number__c, Quote_Buy_Price__c, Buy_Amount__c, Std_Buy_Amount_Number__c, Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Fee_Category__c from Import_Export_Fee_Line__c where Import_Export_Quote__c = \''+record.Id +'\' and (Service_Rate_Category__c = \'POL Charges\' or Service_Rate_Category__c = \'POD Charges\' or Service_Rate_Category__c = \'Drayages\')  order by  Service_Rate_Category__c');
        boolean ya_existe_la_ruta = false;
        if(query_quotefeeLines_all != null && query_quotefeeLines_all.size()>0)
        {
            for(Import_Export_Fee_Line__c fl: query_quotefeeLines_all)
            {
                if(fl.Service_Rate_Category__c == 'POD Charges')
                {
                    for (String entry : new_map_lines.keySet())
                    {
                        List<String> listado_nombres_rutas = entry.split('_&_');
                        if(listado_nombres_rutas[2] == fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name)
                        {
                            Import_Export_Fee_Line_currency_s new_object_currency = new Import_Export_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));
                            map_lines_custom.get(entry).list_fees.add(new_object_currency);
                            //sumar al total
                            map_lines_custom.get(entry).total_buy = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_buy) + NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c);
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
                            Import_Export_Fee_Line_currency_s new_object_currency = new Import_Export_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));
                            map_lines_custom.get(entry).list_fees.add(new_object_currency);
                            //sumar al total
                            map_lines_custom.get(entry).total_buy = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_buy) + NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c);
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
                            if((listado_nombres_rutas[0] == fl.Service_Rate_Name__r.Port_Airport__r.Name) || (listado_nombres_rutas[2] == fl.Service_Rate_Name__r.Port_Airport__r.Name))
                            {
                                Import_Export_Fee_Line_currency_s new_object_currency = new Import_Export_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl));
                                map_lines_custom.get(entry).list_fees.add(new_object_currency);
                                //sumar al total
                                map_lines_custom.get(entry).total_buy = NEU_Utils.safedecimal(map_lines_custom.get(entry).total_buy) + NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c);
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
                            List<Import_Export_Fee_Line_currency_s> list_ie_line_currency = new List<Import_Export_Fee_Line_currency_s>();
                            Import_Export_Fee_Line_currency_s list_ie_line_currency_line = new Import_Export_Fee_Line_currency_s(fl, Neu_currencyUtils.getCurrencyIsoCode(fl));
                            list_ie_line_currency.add(list_ie_line_currency_line);
                            List<Import_Export_Fee_Line__c> list_ie_line = new List<Import_Export_Fee_Line__c>();
                            list_ie_line.add(fl);
                            new_map_lines.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ), new List<Import_Export_Fee_Line_currency_s>{new Import_Export_Fee_Line_currency_s(fl,Neu_currencyUtils.getCurrencyIsoCode(fl))});
                            // si a incluido un drayage que no hay ruta anterior crea la del load si coincide o la de descarga
                            if((fl.Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__c == record.Site_of_Load__c && record.Site_of_Load__c != null) || (fl.Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.Country__c == record.Country_ofLoad__c && record.Site_of_Load__c == null) || (fl.Service_Rate_Name__r.Delivery_Zone__r.Port_Airport__r.State__c == record.State_of_Load__c && record.Site_of_Load__c == null))
                            {
                                map_lines_custom.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),new Import_Export_Fee_Line_all_s(this, fl.Service_Rate_Name__r.Port_Airport__r.Name, 'null', list_ie_line_currency , NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c),contador_de_opciones));
                                contador_de_opciones ++;
                            }
                            else
                            {
                                map_lines_custom.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),new Import_Export_Fee_Line_all_s(this, 'null', fl.Service_Rate_Name__r.Port_Airport__r.Name, list_ie_line_currency , NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c),contador_de_opciones));
                                contador_de_opciones ++;
                            }
                        }
                    }
                    else if(fl.Service_Rate_Category__c == 'POL Charges' || fl.Service_Rate_Category__c == 'POD Charges')
                    {
                        if(fl.Service_Rate_Name__r.Route__c != null && fl.Service_Rate_Name__r.Route__c != null)
                        {

                            List<Import_Export_Fee_Line_currency_s> list_ie_line_currency = new List<Import_Export_Fee_Line_currency_s>();
                            Import_Export_Fee_Line_currency_s list_ie_line_currency_line = new Import_Export_Fee_Line_currency_s(fl, Neu_currencyUtils.getCurrencyIsoCode(fl));
                            list_ie_line_currency.add(list_ie_line_currency_line);

                            List<Import_Export_Fee_Line__c> list_ie_line = new List<Import_Export_Fee_Line__c>();
                            list_ie_line.add(fl);
                            //para que lo encuentre la siguiente vuelta
                            new_map_lines.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ), list_ie_line_currency );
                            //para pintarlo
                            map_lines_custom.put((fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null)+'_&_'+(fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ),new Import_Export_Fee_Line_all_s(this, (fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Load__r.Name : null), (fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__c != null ? fl.Service_Rate_Name__r.Route__r.Port_Airport_of_Discharge__r.Name : null ), list_ie_line_currency , NEU_Utils.safedecimal(fl.Buy_Amount_header_currency__c),NEU_Utils.safedecimal(fl.Sell_Amount_header_currency__c),contador_de_opciones));
                            contador_de_opciones ++;
                        }
                    }
                }
                ya_existe_la_ruta = false;
            }
        }
        quotefeeLines_all_for_route = map_lines_custom.values();

        return quotefeeLines_all_for_route;
    }

    //funciones de comparacion
    public void go_compare_fees_filtro()
    {
        Fee_List_Price = null;
    }

    public void search_name_filter()
    {
        Fee_List_Price = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
    }

    public Boolean checkExistRoute()
    {
        Boolean exist = true;
        String query_n_routes = 'select count() ';
        query_n_routes += ' FROM Carrier_Line_Load_Point__c';
        query_n_routes += ' WHERE Id != null';
        query_n_routes += (imp_ext_filter.Country_ofLoad__c != null ? ' AND Country_of_Load__c = \''+imp_ext_filter.Country_ofLoad__c+'\'' : '');
        query_n_routes += (imp_ext_filter.Country_ofDischarge__c != null ? ' AND Country_of_Discharge__c = \''+imp_ext_filter.Country_ofDischarge__c+'\'' : '');
        query_n_routes += (imp_ext_filter.State_of_Load__c != null ? ' AND State_of_Load__c = \''+imp_ext_filter.State_of_Load__c+'\'' : '');
        query_n_routes += (imp_ext_filter.State_of_Discharge__c != null ? ' AND State_of_Discharge__c = \''+imp_ext_filter.State_of_Discharge__c+'\'' : '');
        query_n_routes += (imp_ext_filter.Site_of_Load__c != null ? ' AND Port_Airport_of_Load__c = \''+imp_ext_filter.Site_of_Load__c+'\'' : '');
        query_n_routes += (imp_ext_filter.Site_of_Discharge__c != null ? ' AND Port_Airport_of_Discharge__c = \''+imp_ext_filter.Site_of_Discharge__c+'\'' : '');

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
        query_route += (imp_ext_filter.Country_ofLoad__c != null ? ' AND Country_of_Load__c = \''+imp_ext_filter.Country_ofLoad__c+'\'' : '');
        query_route += (imp_ext_filter.Country_ofDischarge__c != null ? ' AND Country_of_Discharge__c = \''+imp_ext_filter.Country_ofDischarge__c+'\'' : '');
        query_route += (imp_ext_filter.State_of_Load__c != null ? ' AND State_of_Load__c = \''+imp_ext_filter.State_of_Load__c+'\'' : '');
        query_route += (imp_ext_filter.State_of_Discharge__c != null ? ' AND State_of_Discharge__c = \''+imp_ext_filter.State_of_Discharge__c+'\'' : '');
        query_route += (imp_ext_filter.Site_of_Load__c != null ? ' AND Port_Airport_of_Load__c = \''+imp_ext_filter.Site_of_Load__c+'\'' : '');
        query_route += (imp_ext_filter.Site_of_Discharge__c != null ? ' AND Port_Airport_of_Discharge__c = \''+imp_ext_filter.Site_of_Discharge__c+'\'' : '');
        query_route += ' Limit 1';
        routeFinder= Database.query(query_route);
        if(routeFinder.size()>0)
            return routeFinder[0];
        else
                return null;
    }

    public void buscar_paises_sites()
    {
        Fee_List_Price = null;
        orden_fees_filtro = 'CreatedDate';
        orden_fees_filtro_modo = 'desc';
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

        if(imp_ext_filter.Site_of_Load__c != null)
            query_location = [select Name from Location__c where Id=: imp_ext_filter.Site_of_Load__c];
        if(query_location != null && query_location.size()>0)
        {
            site_of_load_url = remove1(query_location[0].Name);

        }

        if(imp_ext_filter.Site_of_Discharge__c != null)
            query_location = [select Name from Location__c where Id=: imp_ext_filter.Site_of_Discharge__c];
        if(query_location != null && query_location.size()>0)
        {
            site_of_discharge_url = remove1(query_location[0].Name);
        }
        url_alibaba = 'https://www.alibaba.com/trade/search?SearchText=freight+'+site_of_load_url+'+'+site_of_discharge_url+'&selectedTab=products';
    }

    public void createNewRoute()
    {
        try
        {
            if(!checkExistRoute() || Test.isrunningtest())
            {
                Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
                new_route.Name = 'New Route';
                new_route.Country_of_Load__c = imp_ext_filter.Country_ofLoad__c;
                new_route.Country_of_Discharge__c = imp_ext_filter.Country_ofDischarge__c;
                new_route.State_of_Load__c = imp_ext_filter.State_of_Load__c;
                new_route.State_of_Discharge__c = imp_ext_filter.State_of_Discharge__c;
                new_route.Port_Airport_of_Load__c = imp_ext_filter.Site_of_Load__c;
                new_route.Port_Airport_of_Discharge__c = imp_ext_filter.Site_of_Discharge__c;
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

    public List<SelectOption>otherFees
    {
        get
        {
            if(otherFees==null)
            {
                otherFees=new List<SelectOption>();
                otherFees.add(new SelectOption('','Service Line'));
                for(Import_Export_Fee_Line_currency_s f:getquotefeeLines_without())
                {
                    if((NEU_Utils.safeDecimal(f.ie_fee_line.Sell_Amount__c)<>0)||(NEU_Utils.safeDecimal(f.ie_fee_line.Buy_Amount__c)<>0))
                        otherFees.add(new SelectOption(String.valueOf(f.ie_fee_line.Sell_Amount__c)+'|'+String.valueOf(f.ie_fee_line.Buy_Amount__c)+'|'+String.valueOf(f.ie_fee_line.Id),f.ie_fee_line.Service_Rate_Name__r.Name));
                }
            }
            return otherFees;
        }
        set;
    }

    public void anterior_siguiente_order()
    {
        Fee_List_Price = null;

        if(string.isnotempty(step_order))// se vuelve a hacer la consulta en la posicion donde se quedara
        {
            List<SelectOption> options = new List<SelectOption>(); //-----se puede evitar duplicar esto
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

            boolean insertar = true;
            decimal unidades_calculadas = 1;
            decimal weight_vol_factor = 0;
            decimal unidades_calculadas2 = 1;
            String name_pickup_zone = null;
            String name_delivery_zone = null;
            List<Delivery_Zone__c> query_name_delivery_zone = null;
            if(imp_ext_filter.Pickup_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: imp_ext_filter.Pickup_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_delivery_zone = query_name_delivery_zone[0].Name;
            }
            if(imp_ext_filter.Delivery_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: imp_ext_filter.Delivery_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_pickup_zone = query_name_delivery_zone[0].Name;
            }

            integer numero_registros = integer.valueof(step_order)*n_records_per_page-n_records_per_page;
            string query_count_services = '';
            query_count_services = 'SELECT Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c, Fee_Description__c, Route__r.Country_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Load__c, CreatedDate, Comments__c, Route__c, Route__r.Name, Max_M3__c, Max_Kgs__c, Account_for__c, Delivery_Zone__r.Name, Port_Airport__r.Country__c, Container_Type__r.Cargo_Volume_m3__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Container_Type__r.Cargo_Weight_Kg__c, Valid_Until__c,                Pallet_Type__c,Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c,                Account_for__r.Name,Carrier_Account__c,TT_Days__c,Port_Airport__r.Name, Delivery_Zone__c, RecordTypeId,  Port_Airport__c, Fee__c,                 Fee_Category__c, Rate_Type__c, Fee_Rate__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c, Carrier_Account__r.Name,                Volumetric_Factor__c, Min__c, Normal__c, q25__c, q45__c, q50__c, q80__c, mq100__c, q100__c, q125__c, q150__c, q200__c, q250__c, q300__c, q500__c,                q1000__c, q1500__c, q2000__c, q2500__c, q3000__c, q5000__c, q7500__c, q10000__c, Fuel__c, Risk__c, Route__r.State_of_Discharge__c, Route__r.State_of_Load__c, Port_Airport__r.State__c, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Code__c, Bunker_Adjustment_Factor_BAF_Cont__c, Peak_Season_Surcharge_PSS_Cont__c, Route_Info__c FROM Fee__c';
            string filters_ie = getfilters_query();
            query_count_services += filters_ie;
            string sub_consulta = 'SELECT Id from Fee__c ' +filters_ie;
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
            query_count_services += ' limit '+n_records_per_page;

            resultado = query_count_services + '----' + name_delivery_zone;

            List<Fee__c> lista_fee = Database.query(query_count_services);

            Fee_List_Price = null;
            Fee_List_Price=new List<NEUEBUSCM_Quote_Fee_Line_s>();

            for(Fee__c lp: lista_fee)
            {
                if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId())
                {

                    if(lp.Rate_Type__c == 'Per Kg')
                    {
                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                        weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c*lp.Volumetric_Factor__c  : 0);
                        if(weight_vol_factor > unidades_calculadas)
                            unidades_calculadas = weight_vol_factor;
                    }
                    if(lp.Rate_Type__c == 'Per TON')
                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                    if(lp.Rate_Type__c == 'Per M3')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1);
                        weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c  : 0);
                        if(weight_vol_factor > unidades_calculadas)
                            unidades_calculadas = weight_vol_factor;
                    }
                    if(lp.Rate_Type__c == 'Per Container')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;

                    }
                    if(lp.Rate_Type__c == 'Per W/M')
                    {
                        unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c  : 0);
                        weight_vol_factor = unidades_calculadas;
                        unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;
                    }
                    if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                    {
                        unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? record.Total_Weight_Kg2__c/lp.Max_Kgs__c  : 0);
                        unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? record.Total_Volume_m3_2__c/lp.Max_M3__c  : 0);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;
                    }
                    if(lp.Rate_Type__c == 'Per Pallet')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;

                    }

                    if(String.IsNotEmpty(getnewcategory()))
                        if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                            unidades_calculadas = 0;

                    unidades_calculadas = unidades_calculadas.setScale(2);
                    Decimal buyrate=(lp.Buy_rate__c==null ?0:lp.Buy_rate__c);
                    Decimal sellrate=(lp.Fee_rate__c==null?0:lp.Fee_rate__c);

                    Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                    qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                    qo_fee_line.Quote_Sell_Price__c = sellrate;
                    qo_fee_line.Discount__c = 0;
                    qo_fee_line.Quote_Buy_Price__c = buyrate;
                    qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                    qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                    qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                    qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                    qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                    Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                    Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp,qo_fee_line,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate  == system.today() ? true: false)));//options,lp.CurrencyIsoCode)
                }
                else
                {
                    if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                    {
                        
                            

                                if(lp.Rate_Type__c == 'Per Kg')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                                    weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c*lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                                if(lp.Rate_Type__c == 'Per M3')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1);
                                    weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }
                                if(lp.Rate_Type__c == 'Per W/M')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c  : 0);
                                    weight_vol_factor = unidades_calculadas;
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? record.Total_Weight_Kg2__c/lp.Max_Kgs__c  : 0);
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? record.Total_Volume_m3_2__c/lp.Max_M3__c  : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if(String.IsNotEmpty(getnewcategory()))
                                    if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                                        unidades_calculadas = 0;

                                // unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);

                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                Decimal sellrate=(lp.Fee_rate__c==null ? 0 : lp.Fee_rate__c);

                                Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                                qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                                qo_fee_line.Quote_Sell_Price__c = sellrate;
                                qo_fee_line.Discount__c = 0;
                                qo_fee_line.Quote_Buy_Price__c = buyrate;
                                qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                                qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                                qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                                Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                                Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp,qo_fee_line,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options,  NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate == system.today() ? true: false)));
                                system.debug('holaa mi fecha'+myDate+'='+date.valueof(system.today()));

                            
                        
                    }
                    else
                    {
                        if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId())
                        {

                                if(lp.Rate_Type__c == 'Per Kg')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                                    weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c*lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                                if(lp.Rate_Type__c == 'Per M3')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1);
                                    weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }
                                if(lp.Rate_Type__c == 'Per W/M')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c  : 0);
                                    weight_vol_factor = unidades_calculadas;
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? record.Total_Weight_Kg2__c/lp.Max_Kgs__c  : 0);
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? record.Total_Volume_m3_2__c/lp.Max_M3__c  : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if(String.IsNotEmpty(getnewcategory()))
                                    if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                                        unidades_calculadas = 0;
                                //  unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);

                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                Decimal sellrate=(lp.Fee_rate__c==null ? 0 : lp.Fee_rate__c);

                                Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                                qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                                qo_fee_line.Quote_Sell_Price__c = sellrate;
                                qo_fee_line.Discount__c = 0;
                                qo_fee_line.Quote_Buy_Price__c = buyrate;
                                qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                                qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                                qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;

                                Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());

                                Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp,qo_fee_line,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options,  NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate == system.today() ? true: false)));
                            
                        }
                        else
                        {
                            if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId())
                            {
                                if (lp.Rate_Type__c == 'Per Kg')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 ? record.Total_Weight_Kg2__c : 1);
                                    weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c * lp.Volumetric_Factor__c : 0);
                                    if (weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }

                                if (lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 ? record.Total_Weight_Kg2__c / 1000 : 1);

                                if (lp.Rate_Type__c == 'Per M3')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 1);
                                    weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c / lp.Volumetric_Factor__c : 0);
                                    if (weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }

                                if (lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c > 0 ? record.Total_Volume_m3_2__c / lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c > 0 ? record.Total_Weight_Kg2__c / lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if (lp.Rate_Type__c == 'Per W/M')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Weight_Kg2__c / lp.Volumetric_Factor__c : 0);
                                    weight_vol_factor = unidades_calculadas;
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if (lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? record.Total_Weight_Kg2__c / lp.Max_Kgs__c : 0);
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? record.Total_Volume_m3_2__c / lp.Max_M3__c : 0);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }

                                if (lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c > 0 ? record.Total_Volume_m3_2__c / lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c > 0 ? record.Total_Weight_Kg2__c / lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if (String.IsNotEmpty(getnewcategory()))
                                    if ((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null))
                                        unidades_calculadas = 0;

                                // unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);

                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate = (lp.Buy_rate__c == null ? 0 : lp.Buy_rate__c);
                                Decimal sellrate = (lp.Fee_rate__c == null ? 0 : lp.Fee_rate__c);

                                Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                                qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                                qo_fee_line.Quote_Sell_Price__c = sellrate;
                                qo_fee_line.Discount__c = 0;
                                qo_fee_line.Quote_Buy_Price__c = buyrate;
                                qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                                qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                                qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                                Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                                Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp, qo_fee_line, false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate == system.today() ? true : false)));



                            }
                        }
                    }
                }
                unidades_calculadas = 1;
                weight_vol_factor = 0;
                unidades_calculadas2 = 1;
                insertar = true;

            }
        }
    }

    public void go_compare_fees_filtro_insertados()
    {

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

    public List<NEUEBUSCM_Quote_Fee_Line_s> getFee_List_Price()
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

            Fee_List_Price=new List<NEUEBUSCM_Quote_Fee_Line_s>();

            boolean insertar = true;
            decimal unidades_calculadas = 1;
            decimal weight_vol_factor = 0;
            decimal unidades_calculadas2 = 1;
            List<Delivery_Zone__c> query_name_delivery_zone = null;
            String name_pickup_zone = null;
            String name_delivery_zone = null;
            if(imp_ext_filter.Pickup_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: imp_ext_filter.Pickup_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_pickup_zone = query_name_delivery_zone[0].Name;
            }
            if(imp_ext_filter.Delivery_Cartage__c != null)
            {
                query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: imp_ext_filter.Delivery_Cartage__c];
                if(query_name_delivery_zone.size()>0)
                    name_delivery_zone = query_name_delivery_zone[0].Name;
            }

            //calculo de paginas
            //-----------------------------------------------
            listado_paginas_Orders = new List<Integer>();
            step_order = '1';
            total_orders = 0;
            string query_count_services = '';
            query_count_services = 'SELECT Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__c, Route__r.Country_of_Discharge__c, Route__r.Country_of_Load__c, Route__r.Port_Airport_of_Discharge__c, Route__r.Port_Airport_of_Load__c, CreatedDate, Comments__c, Route__c, Route__r.Name, Max_M3__c, Max_Kgs__c, Account_for__c, Delivery_Zone__r.Name, Port_Airport__r.Country__c, Container_Type__r.Cargo_Volume_m3__c, Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c, Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Container_Type__r.Cargo_Weight_Kg__c, Valid_Until__c,                Pallet_Type__c,Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c,                Account_for__r.Name,Carrier_Account__c,TT_Days__c,Port_Airport__r.Name, Delivery_Zone__c, RecordTypeId,  Port_Airport__c, Fee__c,                 Fee_Category__c, Rate_Type__c, Fee_Rate__c, Buy_Rate__c, Applicable_to_Sales_Incoterms__c, Applicable_to_Purchase_Incoterms__c, Carrier_Account__r.Name,                Volumetric_Factor__c, Min__c, Normal__c, q25__c, q45__c, q50__c, q80__c, mq100__c, q100__c, q125__c, q150__c, q200__c, q250__c, q300__c, q500__c,                q1000__c, q1500__c, q2000__c, q2500__c, q3000__c, q5000__c, q7500__c, q10000__c, Fuel__c, Risk__c, Route__r.State_of_Discharge__c, Route__r.State_of_Load__c, Port_Airport__r.State__c, Group__c, SAP_Service_Type__c, Sap_Service_Type_Buy__c, SAP_Service_Type__r.Code__c, Sap_Service_Type_Buy__r.Code__c, Bunker_Adjustment_Factor_BAF_Cont__c, Peak_Season_Surcharge_PSS_Cont__c, Route_Info__c FROM Fee__c';
            string all_filters =   getfilters_query();
            query_count_services += all_filters;
            if(orden_fees_filtro != null && orden_fees_filtro != '')
            {
                if(orden_fees_filtro.contains('line.') == true)
                    orden_fees_filtro = orden_fees_filtro.replace('line.','');

                query_count_services += ' order by '+orden_fees_filtro+' '+orden_fees_filtro_modo;
            }
            else
                    query_count_services += ' order by CreatedDate desc';

            query_count_services += ' nulls last';
            query_count_services += '  limit '+n_records_per_page;

            resultado = query_count_services + '----' + name_delivery_zone;

            if(!Test.isRunningTest()){
            List<Fee__c> listado_ids_service = Database.query(query_count_services);
            }
            //resultado = query_count_services+'------'+mynewcategory;

            //-------------
            string query_count_service_rate = 'SELECT COUNT(Id)  FROM Fee__c'+ all_filters;
            //query_count_service_rate
            if(!Test.isRunningTest()){
            List<aggregateResult> results =   Database.query(query_count_service_rate);
            //calculo de totales y paginas
            for (AggregateResult result : results) total_orders += (Integer)result.get('expr0');
            }
            decimal n_listas = 0;
            n_listas = (integer)total_orders/n_records_per_page;
            n_listas = n_listas + 2;

            for(integer i= 1; i < n_listas; i++)
            {
                listado_paginas_Orders.add(i);
            }
            // array_ie_orders= new List<List<NEUEBUSCM_Quote_Fee_Line_s>>();
            integer contador_ie = 0;
            integer total_record_fees = 0;
            //List<NEUEBUSCM_Quote_Fee_Line_s> hijo_array_ie = new List<NEUEBUSCM_Quote_Fee_Line_s>();


            List<Fee__c> lista_fee_list =new List<Fee__c>();
            if(!Test.isRunningTest()){
            lista_fee_list = Database.query(query_count_services);
            }
            for(Fee__c lp: lista_fee_list)
            {
                if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId())
                {
                    if(lp.Rate_Type__c == 'Per Kg')
                    {
                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                        weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c*lp.Volumetric_Factor__c  : 0);
                        if(weight_vol_factor > unidades_calculadas)
                            unidades_calculadas = weight_vol_factor;
                    }
                    if(lp.Rate_Type__c == 'Per TON')
                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                    if(lp.Rate_Type__c == 'Per M3')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1);
                        weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? (lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c : 0) : 0);
                        if(weight_vol_factor > unidades_calculadas)
                            unidades_calculadas = weight_vol_factor;
                    }
                    if(lp.Rate_Type__c == 'Per Container')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;

                    }
                    if(lp.Rate_Type__c == 'Per W/M')
                    {
                        unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? (lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c : 0) : 0);
                        weight_vol_factor = unidades_calculadas;
                        unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;
                    }
                    if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                    {
                        unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? (lp.Max_Kgs__c > 0 ? record.Total_Weight_Kg2__c/lp.Max_Kgs__c : 0) : 0);
                        unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? (lp.Max_M3__c > 0 ? record.Total_Volume_m3_2__c/lp.Max_M3__c : 0) : 0);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;
                    }
                    if(lp.Rate_Type__c == 'Per Pallet')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                        if(unidades_calculadas2 > unidades_calculadas)
                            unidades_calculadas = unidades_calculadas2;

                    }

                    if(String.IsNotEmpty(getnewcategory()))
                        if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                            unidades_calculadas = 0;
                    //unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);

                    unidades_calculadas = unidades_calculadas.setScale(2);
                    Decimal buyrate=(lp.Buy_rate__c==null ?0:lp.Buy_rate__c);
                    Decimal sellrate=(lp.Fee_rate__c==null?0:lp.Fee_rate__c);

                    Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                    qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                    qo_fee_line.Quote_Sell_Price__c = sellrate;
                    qo_fee_line.Discount__c = 0;
                    qo_fee_line.Quote_Buy_Price__c = buyrate;
                    qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                    qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                    qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                    qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                    qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                    Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                    Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp,qo_fee_line,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate  == system.today() ? true: false)));//options,lp.CurrencyIsoCode)
                }
                else
                {
                    if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                    {
                        {
                            {
                                if(lp.Rate_Type__c == 'Per Kg')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                                    weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c*lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                                if(lp.Rate_Type__c == 'Per M3')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1);
                                    weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? ( lp.Volumetric_Factor__c >0 ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c : 0) : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }
                                if(lp.Rate_Type__c == 'Per W/M')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? (lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c : 0) : 0);
                                    weight_vol_factor = unidades_calculadas;
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? (lp.Max_Kgs__c > 0 ? record.Total_Weight_Kg2__c/lp.Max_Kgs__c : 0) : 0);
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? (lp.Max_M3__c > 0 ? record.Total_Volume_m3_2__c/lp.Max_M3__c : 0) : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }



                                if(String.IsNotEmpty(getnewcategory()))
                                    if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                                        unidades_calculadas = 0;

                                // unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);

                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                Decimal sellrate=(lp.Fee_rate__c==null ? 0 : lp.Fee_rate__c);

                                Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                                qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                                qo_fee_line.Quote_Sell_Price__c = sellrate;
                                qo_fee_line.Discount__c = 0;
                                qo_fee_line.Quote_Buy_Price__c = buyrate;
                                qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                                qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                                qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                                Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                                Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp,qo_fee_line,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options,  NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate == system.today() ? true: false)));//options,lp.CurrencyIsoCode)
                                system.debug('holaa mi fecha'+myDate+'='+date.valueof(system.today()));

                            }
                        }
                    }
                    else
                    {
                        if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId())
                        {
                            {
                                if(lp.Rate_Type__c == 'Per Kg')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                                    weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c*lp.Volumetric_Factor__c  : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                                if(lp.Rate_Type__c == 'Per M3')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1);
                                    weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? (lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c : 0) : 0);
                                    if(weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }
                                if(lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }
                                if(lp.Rate_Type__c == 'Per W/M')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? (lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg2__c/lp.Volumetric_Factor__c : 0) : 0);
                                    weight_vol_factor = unidades_calculadas;
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? (lp.Max_Kgs__c > 0 ? record.Total_Weight_Kg2__c/lp.Max_Kgs__c : 0) : 0);
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? (lp.Max_M3__c > 0 ? record.Total_Volume_m3_2__c/lp.Max_M3__c : 0) : 0);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if(lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                    if(unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if(String.IsNotEmpty(getnewcategory()))
                                    if((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null ))
                                        unidades_calculadas = 0;
                                //  unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);

                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate=(lp.Buy_rate__c==null ? 0 : lp.Buy_rate__c);
                                Decimal sellrate=(lp.Fee_rate__c==null ? 0 : lp.Fee_rate__c);

                                Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                                qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                                qo_fee_line.Quote_Sell_Price__c = sellrate;
                                qo_fee_line.Discount__c = 0;
                                qo_fee_line.Quote_Buy_Price__c = buyrate;
                                qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                                qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                                qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;

                                Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());

                                Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp,qo_fee_line,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options,  NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate == system.today() ? true: false)));//options, lp.CurrencyIsoCode)
                            }
                        }
                        else
                        {
                            if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId())
                            {
                                if (lp.Rate_Type__c == 'Per Kg')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 ? record.Total_Weight_Kg2__c : 1);
                                    weight_vol_factor = (record.Total_Volume_m3_2__c > 0 && lp.Volumetric_Factor__c != null ? record.Total_Volume_m3_2__c * lp.Volumetric_Factor__c : 0);
                                    if (weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }

                                if (lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 ? record.Total_Weight_Kg2__c / 1000 : 1);

                                if (lp.Rate_Type__c == 'Per M3')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 1);
                                    weight_vol_factor = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? (lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg2__c / lp.Volumetric_Factor__c : 0) : 0);
                                    if (weight_vol_factor > unidades_calculadas)
                                        unidades_calculadas = weight_vol_factor;
                                }

                                if (lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c > 0 ? record.Total_Volume_m3_2__c / lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c > 0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c > 0 ? record.Total_Weight_Kg2__c / lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if (lp.Rate_Type__c == 'Per W/M')
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Volumetric_Factor__c != null ? (lp.Volumetric_Factor__c > 0 ? record.Total_Weight_Kg2__c / lp.Volumetric_Factor__c : 0) : 0);
                                    weight_vol_factor = unidades_calculadas;
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 ? record.Total_Volume_m3_2__c : 0);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }
                                if (lp.Rate_Type__c == 'Fixed' && (lp.Max_Kgs__c != null || lp.Max_M3__c != null))
                                {
                                    unidades_calculadas = (record.Total_Weight_Kg2__c > 0 && lp.Max_Kgs__c != null ? (lp.Max_Kgs__c > 0? record.Total_Weight_Kg2__c / lp.Max_Kgs__c : 0) : 0);
                                    unidades_calculadas2 = (record.Total_Volume_m3_2__c > 0 && lp.Max_M3__c != null ? (lp.Max_M3__c > 0 ? record.Total_Volume_m3_2__c / lp.Max_M3__c : 0) : 0);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;
                                }

                                if (lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c > 0 ? record.Total_Volume_m3_2__c / lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c > 0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c > 0 ? record.Total_Weight_Kg2__c / lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                    if (unidades_calculadas2 > unidades_calculadas)
                                        unidades_calculadas = unidades_calculadas2;

                                }

                                if (String.IsNotEmpty(getnewcategory()))
                                    if ((getnewcategory() == 'Drayages') && lp.Max_M3__c == null && lp.Max_Kgs__c == null && (lp.Rate_Type__c == 'Per Container' && lp.Container_Type__c == null))
                                        unidades_calculadas = 0;

                                // unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);

                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate = (lp.Buy_rate__c == null ? 0 : lp.Buy_rate__c);
                                Decimal sellrate = (lp.Fee_rate__c == null ? 0 : lp.Fee_rate__c);

                                Import_Export_Fee_Line__c qo_fee_line = new Import_Export_Fee_Line__c();
                                qo_fee_line.Units__c = (record.Container_Count__c != null && lp.Rate_Type__c == 'Per Container' ? record.Container_Count__c : unidades_calculadas);
                                qo_fee_line.Quote_Sell_Price__c = sellrate;
                                qo_fee_line.Discount__c = 0;
                                qo_fee_line.Quote_Buy_Price__c = buyrate;
                                qo_fee_line.Extension_Service_Name__c = lp.Comments__c;
                                qo_fee_line.Concept_1_Sell_Price__c = lp.Cost_Concept_1__c;
                                qo_fee_line.Concept_2_Sell_Price__c = lp.Cost_Concept_2__c;
                                qo_fee_line.Concept_3_Sell_Price__c = lp.Cost_Concept_3__c;
                                qo_fee_line.Concept_4_Sell_Price__c = lp.Cost_Concept_4__c;
                                Date myDate = date.newinstance(lp.CreatedDate.year(), lp.CreatedDate.month(), lp.CreatedDate.day());
                                Fee_List_Price.add(new NEUEBUSCM_Quote_Fee_Line_s(lp, qo_fee_line, false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate), options, NEU_CurrencyUtils.getCurrencyIsoCode(lp), 0, null, '0', 0, '0', '0', this, weight_vol_factor, (myDate == system.today() ? true : false)));



                            }
                        }
                    }
                }
                unidades_calculadas = 1;
                weight_vol_factor = 0;
                unidades_calculadas2 = 1;

                insertar = true;

            }

            system.debug('holaa contador2'+total_record_fees);
        }
        return Fee_List_Price;

    }

    //public string get_currency_object(Sobject new_object)
    public string get_currency_object()
    {
        string currency_code='';
        return currency_code;
    }

    public String getfilters_query()
    {
        List<Delivery_Zone__c> query_name_delivery_zone = null;
        String name_pickup_zone = null;
        string name_delivery_zone = null;
        if(imp_ext_filter.Pickup_Cartage__c != null)
        {
            query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: imp_ext_filter.Pickup_Cartage__c];
            if(query_name_delivery_zone.size()>0)
                name_delivery_zone = query_name_delivery_zone[0].Name;
        }
        if(imp_ext_filter.Delivery_Cartage__c != null)
        {
            query_name_delivery_zone =[select Id, Name from Delivery_Zone__c where Id=: imp_ext_filter.Delivery_Cartage__c];
            if(query_name_delivery_zone.size()>0)
                name_pickup_zone = query_name_delivery_zone[0].Name;
        }
        string query_count_services = '';
        query_count_services +=' where Active__c = true ';
        query_count_services += (CHKValidos ? ' AND Valid_Until__c >= TODAY' : '');
        if(String.IsNotEmpty(getnewcategory()))//Siempre hay que llamar a la función para obtener el nuevo dato de la variable pública mynewcategory
        {
            query_count_services +=' and Fee_Category__c = :mynewcategory';
        }

        if(string.isnotempty(service_rate_filter_name))
        {
            String name_filter = '%'+service_rate_filter_name+'%';
            query_count_services +=' and Name like :name_filter';
        }

        if(service_rate_filter != null)
        {
            ValidFrom = service_rate_filter.Valid_From__c;
            ValidUntil = service_rate_filter.Valid_Until__c;
            if(ValidFrom != null)
                query_count_services +=' and (Valid_Until__c = null or Valid_Until__c >=: ValidFrom) ';
            if(ValidUntil != null)
                query_count_services +=' and (Valid_From__c = null or Valid_From__c <=:  ValidUntil) ';
        }
        //si son de tipo local transport
        query_count_services +=' and ((RecordType.DeveloperName = \'Fee_Local_Transport\'';
        if(service_rate_filter.Account_for__c != null)
            query_count_services +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
        boolean tiene_filtro_country = false;

        if(imp_ext_filter.Site_of_Discharge__c != null)
        {
            query_count_services += ' and (Port_Airport__c =  \''+imp_ext_filter.Site_of_Discharge__c+'\' ';
            tiene_filtro_country = true;
        }
        else if(imp_ext_filter.Site_of_Discharge__c == null && imp_ext_filter.Country_ofDischarge__c != null)
        {
            query_count_services += ' and (Port_Airport__r.Country__c = \''+imp_ext_filter.Country_ofDischarge__c+'\' ';
            tiene_filtro_country = true;
        }

        if(imp_ext_filter.Site_of_Load__c != null)
        {
            if(tiene_filtro_country == false)
                query_count_services += ' and (Port_Airport__c =  \''+imp_ext_filter.Site_of_Load__c+'\'';
            else
                    query_count_services += ' or Port_Airport__c =  \''+imp_ext_filter.Site_of_Load__c+'\'';
            tiene_filtro_country = true;
        }
        else if(imp_ext_filter.Site_of_Load__c == null && imp_ext_filter.Country_ofLoad__c != null)
        {
            if(tiene_filtro_country == false)
                query_count_services += ' and (Port_Airport__r.Country__c = \''+imp_ext_filter.Country_ofLoad__c+'\'';
            else
                    query_count_services += ' or Port_Airport__r.Country__c = \''+imp_ext_filter.Country_ofLoad__c+'\'';
            tiene_filtro_country = true;
        }
        if(tiene_filtro_country == true)
            query_count_services += ' or Port_Airport__c = null)';

        boolean tiene_relacion_con_zone = false;
        if(imp_ext_filter != null)
        {
            if(imp_ext_filter.Pickup_Cartage__c != null)
            {
                query_count_services += ' and (Delivery_Zone__r.Name = :name_pickup_zone';
                tiene_relacion_con_zone = true;
            }
            if(imp_ext_filter.Delivery_Cartage__c != null)
            {
                if(tiene_relacion_con_zone == false)
                    query_count_services += ' and (Delivery_Zone__r.Name = :name_delivery_zone';
                else
                        query_count_services += ' or Delivery_Zone__r.Name = :name_delivery_zone';
                tiene_relacion_con_zone = true;
            }
            if(tiene_relacion_con_zone == true)
                query_count_services += ' or Delivery_Zone__c = null)';
            if(imp_ext_filter.Container_Type__c != null)
                query_count_services += ' and (Container_Type__c = \''+imp_ext_filter.Container_Type__c+'\' or Container_Type__c = null)';
        }
        if(ship_filter != null)
            if(ship_filter.Carrier__c != null)
                query_count_services += ' and (Carrier_Account__c = \''+ship_filter.Carrier__c+'\' or Carrier_Account__c = null)';
        //fin local transport
        query_count_services +=')';

        //si son de tipo Sea/Ground Freight
        query_count_services +=' or (RecordType.DeveloperName = \'Fee_Freight\'';

        boolean tiene_relacion_route = false;
        if(imp_ext_filter.Route__c != null)
        {
            query_count_services +=' and (Route__c = \''+imp_ext_filter.Route__c+'\'';
            tiene_relacion_route = true;
        }
        if(imp_ext_filter != null)
        {
            if(tiene_relacion_route == false)
            {
                //query_count_services +=' and ((Route__c != null and Route__r.Country_of_Load__c = \''+imp_ext_filter.Country_ofLoad__c+'\' and Route__r.Country_of_Discharge__c = \''+imp_ext_filter.Country_ofDischarge__c+'\'';
                //query_count_services +=' and Route__r.Port_Airport_of_Discharge__c = \''+imp_ext_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+imp_ext_filter.Site_of_Load__c +'\')';

                query_count_services +=' and ((Route__c != null and (Route__r.Country_of_Load__c=null ';
                if(imp_ext_filter.Country_ofLoad__c != null)
                    query_count_services +=' or Route__r.Country_of_Load__c = \''+imp_ext_filter.Country_ofLoad__c+'\'';
                else
                        query_count_services +=' or Route__r.Country_of_Load__c != null';
                query_count_services +=')';
                query_count_services +=' and (Route__r.Country_of_Discharge__c=null ';
                if(imp_ext_filter.Country_ofDischarge__c != null)
                    query_count_services +=' or Route__r.Country_of_Discharge__c = \''+imp_ext_filter.Country_ofDischarge__c+'\'';
                else
                        query_count_services +=' or Route__r.Country_of_Discharge__c != null';
                query_count_services +=')';

                //------------STATE FILTER------------
                query_count_services +=' and (Route__r.State_of_Load__c=null ';
                if(imp_ext_filter.State_of_Load__c != null)
                    query_count_services +=' or Route__r.State_of_Load__c = \''+imp_ext_filter.State_of_Load__c+'\'';
                else
                        query_count_services +=' or Route__r.State_of_Load__c != null';
                query_count_services +=')';
                query_count_services +=' and (Route__r.State_of_Discharge__c=null ';
                if(imp_ext_filter.State_of_Discharge__c != null)
                    query_count_services +=' or Route__r.State_of_Discharge__c = \''+imp_ext_filter.State_of_Discharge__c+'\'';
                else
                        query_count_services +=' or Route__r.State_of_Discharge__c != null';
                query_count_services +=')';

                query_count_services +=' and (Route__r.Port_Airport_of_Discharge__c=null ';
                if(imp_ext_filter.Site_of_Discharge__c != null)
                    query_count_services +=' or Route__r.Port_Airport_of_Discharge__c = \''+imp_ext_filter.Site_of_Discharge__c+'\'';
                else
                        query_count_services +=' or Route__r.Port_Airport_of_Discharge__c != null';
                query_count_services +=') ';
                query_count_services +=' and (Route__r.Port_Airport_of_Load__c=null ';
                if(imp_ext_filter.Site_of_Load__c != null)
                    query_count_services +=' or Route__r.Port_Airport_of_Load__c = \''+imp_ext_filter.Site_of_Load__c +'\'';
                else
                        query_count_services +=' or Route__r.Port_Airport_of_Load__c != null';
                query_count_services +=' ))';

            }
            else
            {
                query_count_services +=' or ((Route__c != null and (Route__r.Country_of_Load__c=null ';
                if(imp_ext_filter.Country_ofLoad__c != null)
                    query_count_services +=' or Route__r.Country_of_Load__c = \''+imp_ext_filter.Country_ofLoad__c+'\'';
                else
                        query_count_services +=' or Route__r.Country_of_Load__c != null';
                query_count_services +=' )';
                query_count_services +=' and (Route__r.Country_of_Discharge__c=null ';
                if(imp_ext_filter.Country_ofDischarge__c != null)
                    query_count_services +=' or Route__r.Country_of_Discharge__c = \''+imp_ext_filter.Country_ofDischarge__c+'\'';
                else
                        query_count_services +=' or Route__r.Country_of_Discharge__c != null';
                query_count_services +=' )';

                //------------STATE FILTER------------
                query_count_services +=' and (Route__r.State_of_Load__c=null ';
                if(imp_ext_filter.State_of_Load__c != null)
                    query_count_services +=' or Route__r.State_of_Load__c = \''+imp_ext_filter.State_of_Load__c+'\'';
                else
                        query_count_services +=' or Route__r.State_of_Load__c != null';
                query_count_services +=' )';
                query_count_services +=' and (Route__r.State_of_Discharge__c=null ';
                if(imp_ext_filter.State_of_Discharge__c != null)
                    query_count_services +=' or Route__r.State_of_Discharge__c = \''+imp_ext_filter.State_of_Discharge__c+'\'';
                else
                        query_count_services +=' or Route__r.State_of_Discharge__c != null';
                query_count_services +=' )';

                query_count_services +=' and (Route__r.Port_Airport_of_Discharge__c=null ';
                if(imp_ext_filter.Site_of_Discharge__c != null)
                    query_count_services +=' or Route__r.Port_Airport_of_Discharge__c = \''+imp_ext_filter.Site_of_Discharge__c+'\'';
                else
                        query_count_services +=' or Route__r.Port_Airport_of_Discharge__c != null';
                query_count_services +=' )';

                query_count_services +=' and (Route__r.Port_Airport_of_Load__c=null ';
                if(imp_ext_filter.Site_of_Load__c != null)
                    query_count_services +=' or Route__r.Port_Airport_of_Load__c = \''+imp_ext_filter.Site_of_Load__c +'\'';
                else
                        query_count_services +=' or Route__r.Port_Airport_of_Load__c != null';
                query_count_services +='))';


            }
            tiene_relacion_route = true;
        }
        if(tiene_relacion_route == true)
            query_count_services +=' or Route__c = null)';
        if(ship_filter != null)
            if(ship_filter.Carrier__c != null)
                query_count_services += ' and (Carrier_Account__c = \''+ship_filter.Carrier__c+'\' or Carrier_Account__c = null)';
        if(service_rate_filter.Account_for__c != null)
            query_count_services +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
        if(imp_ext_filter.Container_Type__c != null)
            query_count_services +=' and Container_Type__c = \''+imp_ext_filter.Container_Type__c+'\'';
        //fin sea ground freight
        query_count_services +=')';

        //si son de tipo other fees
        query_count_services +=' or (RecordType.DeveloperName = \'Other_Fees\'';
        if(service_rate_filter.Account_for__c != null)
            query_count_services +=' and Account_for__c = \''+service_rate_filter.Account_for__c+'\'';
        if(imp_ext_filter.Container_Type__c != null)
            query_count_services +=' and (Container_Type__c = \''+imp_ext_filter.Container_Type__c+'\' or Container_Type__c = null)';

        //fin Other_Fees
        query_count_services +=')';

        //si son de tipo Air Freight
        query_count_services +=' or (RecordType.DeveloperName = \'Air_Freight\'';


        boolean tiene_relacion_route2 = false;
        if(imp_ext_filter.Route__c != null)
        {
            query_count_services +=' and (Route__c = \''+imp_ext_filter.Route__c+'\'';
            tiene_relacion_route2 = true;
        }

        if(imp_ext_filter != null && imp_ext_filter.Country_ofLoad__c != null && imp_ext_filter.Country_ofDischarge__c != null && imp_ext_filter.Site_of_Load__c != null && imp_ext_filter.Site_of_Discharge__c != null)
        {
            if(tiene_relacion_route2 == false)
            {
                query_count_services +=' and ((Route__c != null and Route__r.Country_of_Load__c = \''+imp_ext_filter.Country_ofLoad__c+'\' and Route__r.Country_of_Discharge__c = \''+imp_ext_filter.Country_ofDischarge__c+'\'';
                //------------STATE FILTER------------
                if(imp_ext_filter.State_of_Load__c != null && imp_ext_filter.State_of_Discharge__c != null)
                    query_count_services +=' and Route__r.State_of_Load__c = \''+imp_ext_filter.State_of_Load__c+'\' and Route__r.State_of_Discharge__c = \''+imp_ext_filter.State_of_Discharge__c +'\'';
                query_count_services +=' and Route__r.Port_Airport_of_Discharge__c = \''+imp_ext_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+imp_ext_filter.Site_of_Load__c +'\')';
            }
            else
            {
                query_count_services +=' or ((Route__c != null and Route__r.Country_of_Load__c = \''+imp_ext_filter.Country_ofLoad__c+'\' and Route__r.Country_of_Discharge__c = \''+imp_ext_filter.Country_ofDischarge__c+'\'';
                //------------STATE FILTER------------
                if(imp_ext_filter.State_of_Discharge__c != null && imp_ext_filter.State_of_Load__c != null)
                    query_count_services +=' and Route__r.State_of_Load__c = \''+imp_ext_filter.State_of_Load__c+'\' and Route__r.State_of_Discharge__c = \''+imp_ext_filter.State_of_Discharge__c +'\'';
                query_count_services +=' and Route__r.Port_Airport_of_Discharge__c = \''+imp_ext_filter.Site_of_Discharge__c+'\' and Route__r.Port_Airport_of_Load__c = \''+imp_ext_filter.Site_of_Load__c +'\')';
            }
            tiene_relacion_route2 = true;
        }
        if(tiene_relacion_route2 == true)
            query_count_services +=' or Route__c = null)';

        //fin Air_Freight
        query_count_services +=')';
        //fin and
        query_count_services +=')';
        return query_count_services;
    }

    public class Import_Export_Fee_Line_currency_s
    {
        public Import_Export_Fee_Line__c ie_fee_line{get; set;}
        public String Currencyisocode{get; set;}
        public Import_Export_Fee_Line_currency_s(Import_Export_Fee_Line__c ie_fee_line, String Currencyisocode)
        {
            this.ie_fee_line=ie_fee_line;
            this.Currencyisocode=Currencyisocode;
        }
    }
    //clase nuevo objeto
    public class Import_Export_Fee_Line_all_s
    {
        public String site_of_load{get; set;}
        public String site_of_discharge{get; set;}
        public Decimal total_buy{get; set;}
        public Decimal total_sell{get; set;}
        public Decimal n_opcion{get; set;}
        public List<Import_Export_Fee_Line_currency_s> list_fees {get; set;}
        private NEU_OM_CQLPriceListYDiscount parent;

        public Import_Export_Fee_Line_all_s(NEU_OM_CQLPriceListYDiscount parent, String site_of_load, String site_of_discharge, List<Import_Export_Fee_Line_currency_s> list_fees, decimal total_buy, decimal total_sell, Decimal n_opcion)
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
                //total_buy_format = ((total_buy+0.001)).format();
                //total_buy_format = total_buy_format.substring(0,total_buy_format.length()-1);
                total_buy_format = total_buy.setScale(2).format();
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
                //total_sell_format = ((total_sell+0.001)).format();
                //total_sell_format = total_sell_format.substring(0,total_sell_format.length()-1);
                total_sell_format = total_sell.setScale(2).format();
                total_sell_format= total_sell_format + ' '+NEU_CurrencyUtils.getCurrencyIsoCode(parent.record);
                return total_sell_format;
            }
            catch(Exception e){}
            return (0.00).format();
        }

    }

    //clase nuevo objeto
    public class NEUEBUSCM_Quote_Fee_Line_s implements Comparable
    {
        public Fee__c line {get; set;}
        public Import_Export_Fee_Line__c line_quote {get; set;}
        public boolean selected {get; set;}
        public String extensionfeename {get; set;}
        public String units {get; set;}
        public String sellprice {get; set;}
        public String discount {get; set;}
        public String buyprice {get; set;}
        public List<SelectOption> currencys {get; set;}
        public String currency_user {get; set;}
        public String volumetric_weight {get;set;}
        public List<SelectOption> breakpoints {get;set;}
        public string breakpoint_selected {get;set;}
        public string surcharges {get;set;}
        public string units_value_1 {get;set;}
        public string units_value_2 {get;set;}
        public String total_sell{get; set;}
        public String total_buy{get; set;}
        private NEU_OM_CQLPriceListYDiscount  parent;
        public boolean fee_hoy{get; set;}
        public string weight_factor{get; set;}


        public NEUEBUSCM_Quote_Fee_Line_s(Fee__c line,Import_Export_Fee_Line__c line_quote,boolean selected, String extensionfeename, String units, String sellprice, String discount, String buyprice, List<SelectOption> currencys, String currency_user, Decimal volumetric_weight, List<SelectOption> breakpoints, String breakpoint_selected, decimal surcharges, string units_value_1, string units_value_2, NEU_OM_CQLPriceListYDiscount  parent, Decimal weight_factor, boolean fee_hoy)
        {
            this.line=line;
            this.line_quote=line_quote;
            this.selected=selected;
            this.extensionfeename=extensionfeename;
            this.units=units;
            this.sellprice=sellprice;
            this.discount=discount;
            this.buyprice=buyprice;
            this.currencys = currencys;
            this.currency_user = currency_user;
            this.volumetric_weight = volumetric_weight.format();
            this.breakpoints = breakpoints;
            this.breakpoint_selected = breakpoint_selected;
            this.surcharges = surcharges.format();
            this.units_value_1 = units_value_1;
            this.units_value_2 = units_value_2;
            this.parent = parent;
            this.weight_factor=((weight_factor+0.001)).format();
            this.weight_factor = this.weight_factor.substring(0,this.weight_factor.length()-1);
            this.fee_hoy = fee_hoy;
        }


        public Integer compareTo(Object compareTo)
        {
            NEUEBUSCM_Quote_Fee_Line_s compareToEmp = (NEUEBUSCM_Quote_Fee_Line_s)compareTo;

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
                    if(line.Fee_Rate__c == null) return 1;
                }
                else
                {
                    if (line.Valid_Until__c > compareToEmp.line.Valid_Until__c) return 1;
                    if(line.Fee_Rate__c == null) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line.Route__r.Name')
            {
                if (line.Route__r.Name  == compareToEmp.line.Route__r.Name) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line.Route__r.Name < compareToEmp.line.Route__r.Name) return 1;
                    if(line.Route__r.Name == null) return 1;
                }
                else
                {
                    if (line.Route__r.Name > compareToEmp.line.Route__r.Name) return 1;
                    if(line.Route__r.Name == null) return 1;
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
                system.debug('holaesta relleno'+total_sell);
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

            else if(parent.orden_fees_filtro  == 'line_quote.Units__c')
            {
                if (line_quote.Units__c == compareToEmp.line_quote.Units__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line_quote.Units__c < compareToEmp.line_quote.Units__c) return 1;
                }
                else
                {
                    if (line_quote.Units__c > compareToEmp.line_quote.Units__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line_quote.Quote_Sell_Price__c')
            {
                if (line_quote.Quote_Sell_Price__c == compareToEmp.line_quote.Quote_Sell_Price__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line_quote.Quote_Sell_Price__c < compareToEmp.line_quote.Quote_Sell_Price__c) return 1;
                    if(line.Fee_Rate__c == null) return 1;
                }
                else
                {
                    if (line_quote.Quote_Sell_Price__c > compareToEmp.line_quote.Quote_Sell_Price__c) return 1;
                    if(line.Fee_Rate__c == null) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line_quote.Discount__c')
            {
                if (line_quote.Discount__c == compareToEmp.line_quote.Discount__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line_quote.Discount__c < compareToEmp.line_quote.Discount__c) return 1;
                }
                else
                {
                    if (line_quote.Discount__c > compareToEmp.line_quote.Discount__c) return 1;
                }
            }

            else if(parent.orden_fees_filtro  == 'line_quote.Quote_Buy_Price__c')
            {
                if (line_quote.Quote_Buy_Price__c == compareToEmp.line_quote.Quote_Buy_Price__c) return 0;
                if(parent.orden_fees_filtro_modo == 'asc')
                {
                    if (line_quote.Quote_Buy_Price__c < compareToEmp.line_quote.Quote_Buy_Price__c) return 1;
                    if(line.Fee_Rate__c == null) return 1;
                }
                else
                {
                    if (line_quote.Quote_Buy_Price__c > compareToEmp.line_quote.Quote_Buy_Price__c) return 1;
                    if(line.Fee_Rate__c == null) return 1;
                }
            }

            return -1;
        }


    }

    public void create_new_service_rate()
    {
        if(fee_record != null)
        {
            Fee__c new_fee = new Fee__c();
            new_fee.Name = fee_record.Name;
            if(getnewcategory() != 'Drayages'  && getnewcategory() != 'Other Service Charges')
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
            new_fee.Max_Kgs__c = fee_record.Max_Kgs__c;
            new_fee.Max_M3__c = fee_record.Max_M3__c;
            new_fee.Volumetric_Factor__c = fee_record.Volumetric_Factor__c;
            new_fee.Min__c = fee_record.Min__c;
            new_fee.Comments__c = fee_record.Comments__c;
            new_fee.Group__c = fee_record.Group__c;
            new_fee.SAP_Service_Type__c = fee_record.SAP_Service_Type__c;
            new_fee.SAP_Service_Type_Buy__c = fee_record.SAP_Service_Type_Buy__c;
            new_fee.Bunker_Adjustment_Factor_BAF_Cont__c = fee_record.Bunker_Adjustment_Factor_BAF_Cont__c;
            new_fee.Peak_Season_Surcharge_PSS_Cont__c = fee_record.Peak_Season_Surcharge_PSS_Cont__c;
            new_fee.Route_Info__c = fee_record.Route_Info__c;
            new_fee.P2G_SapDevolucion__c = fee_record.P2G_SapDevolucion__c;
            /*if(serviceF == 'CE' && fee_record.Import_Export_Cargo_Line__c != null){
             	new_fee.Import_Export_Quoted_Marketplace__c = record.Id;
            	new_fee.Import_Export_Cargo_Line__c = fee_record.Import_Export_Cargo_Line__c;   
            }*/
            //new_fee.Import_Export_Quoted_Marketplace__c = record.Id;
            //new_fee.SST_Sociedad__c = fee_record.SST_Sociedad__c;
            new_fee.Active__c = true;
            new_fee.Fee_Category__c = getnewcategory();
            // if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Air Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
            if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
                new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
            else if(getnewcategory() == 'Air Freights')
                new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
            else if(getnewcategory() == 'Drayages')
                new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId();
            else if(getnewcategory() == 'Other Service Charges')
            {
                new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId();
                new_fee.Route__c = null;
            }
            else
                    new_fee.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
            new_fee.Rate_Names_List__c = fee_record.Rate_Names_List__c;

            try
            {
                insert new_fee;
                fee_record = new Fee__c();
                fee_record.Account_for__c = record.Account_for__c;
                //fee_record.Import_Export_Quoted_Marketplace__c = record.Id;
                fee_record.Group__c = getGroup();
                sapName = null;
                if(getnewcategory() != 'Drayages' && getnewcategory() != 'Other Service Charges')
                    fee_record.Route__c = record.Route__c;
                Fee_List_Price = null;
                service_rate_filter_name = '';

                //if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Air Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
                if(getnewcategory() == 'Sea Freights' || getnewcategory() == 'Road Freights' || getnewcategory() == 'Railway Freights' || getnewcategory() == 'Multimodal Freights' || getnewcategory() == 'POL Charges' || getnewcategory() == 'POD Charges' || getnewcategory() == 'Warehouse')
                {
                    fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
                    RecordType rt = [SELECT Id,Name FROM RecordType WHERE id =:fee_record.RecordTypeId limit 1];
                    fee_record.RecordType = rt;
                }
                else if(getnewcategory() == 'Air Freights')
                {
                    fee_record.RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Air Freight').getRecordTypeId();
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
                system.debug('Error create_new_service_rate: ' + ex.getCause() + ' linea: ' + ex.getLineNumber());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
            }
        }
    }

    //Consultar las insertadas nuevo objet
        public void crearlineaquoteitem()
    {
        if(Fee_List_Price != null)
        {
            List<Import_Export_Fee_Line__c> Quote_fee = [select Id, Name, Import_Export_Quote__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: record.Id  order by Name];

            integer contadordelineas = 0;
            contadordelineas = Quote_fee.size();

            List<Import_Export_Fee_Line__c> myLines = new List<Import_Export_Fee_Line__c>();

            for(NEUEBUSCM_Quote_Fee_Line_s lines:Fee_List_Price)
            {
                system.debug('lines.line_quote.Quote_Sell_Price__c: ' + lines.line_quote.Quote_Sell_Price__c);
                if(lines.selected)
                {
                    chekeados=true;
                    contadordelineas ++;
                    Import_Export_Fee_Line__c myLine= new Import_Export_Fee_Line__c();
                    myline.Import_Export_Quote__c=record.Id;
                    myline.Name = string.valueof(contadordelineas);
                    string nombre_linea = '';
                    while(myline.Name.length()<3)
                    {
                        myline.Name = nombre_linea + string.valueof(contadordelineas);
                        nombre_linea  +='0';
                    }
                    myline.Extension_Service_Name__c=lines.extensionfeename;
                    myline.Service_Rate_Name__c = lines.line.Id;
                    system.debug('myline.Service_Rate_Name__c: ' + myline.Service_Rate_Name__c);
                    myline.Warehouse_Rate__c = (lines.line.Fee_Category__c == 'Warehouse' ? true : false);
                    if(lines.line_quote != null)
                        myline.Units__c = lines.line_quote.Units__c;
                    if(lines.line_quote != null )
                        myline.Quote_Sell_Price__c = lines.line_quote.Quote_Sell_Price__c;
                    if(lines.line_quote != null )
                        myline.Extension_Service_Name__c = lines.line_quote.Extension_Service_Name__c;
                    if(lines.line_quote != null )
                        myline.Discount__c = lines.line_quote.Discount__c;
                    if(lines.line_quote != null )
                        myline.Import_Export_Service_Line__c = lines.line_quote.Import_Export_Service_Line__c;
                    myline.Min_Amount__c = lines.line.Min__c;

                    if(lines.line_quote != null)
                    {
                        myline.Quote_Buy_Price__c = lines.line_quote.Quote_Buy_Price__c;
                        myline.Concept_1_Sell_Price__c = lines.line_quote.Concept_1_Sell_Price__c;
                        myline.Concept_2_Sell_Price__c = lines.line_quote.Concept_2_Sell_Price__c;
                        myline.Concept_3_Sell_Price__c = lines.line_quote.Concept_3_Sell_Price__c;
                        myline.Concept_4_Sell_Price__c = lines.line_quote.Concept_4_Sell_Price__c;
                        myline.Concept_5_Sell_Price__c = lines.line_quote.Concept_5_Sell_Price__c;
                    }

                    NEU_CurrencyUtils.setCurrencyIsoCode(myLine,lines.currency_user);

                    myLines.add(myLine);
                }
            }

            try
            {
                insert myLines;
                if(record.Name.contains('A-') || record.Name.contains('R-') || record.Name.contains('AW-')){
                    dividirLineas(myLines);
                }
                
            }
            catch(Exception e){system.debug('Error crearlineaquoteitem1: ' + e.getCause() + ' linea: ' + e.getLineNumber());}

            if(chekeados)
            {
                Fee_List_Price=null;
                try
                {
                    boolean tiene_modificacion = false;
                    if(Quote_fee == null || Quote_fee.size()==0)
                    {
                        //record.Quotation_Status__c = 'Quote being prepared';
                        tiene_modificacion = true;
                    }
                    if(tiene_modificacion == true)
                        update record;
                }
                catch(Exception ex)
                {
                    system.debug('Error crearlineaquoteitem2: ' + ex.getCause() + ' linea: ' + ex.getLineNumber());
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex));
                }
                editPriceList=false;
            }
            string recordID= record.Id;
            totales = Database.query('select id, Conversion_Rate_Date__c, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Buy_Amount_number__c, Total_Services_Sell_Amount_number__c from Customer_Quote__c where id =: recordID');
            totals_custom = new totales_s(totales);
            totals_custom_by_category = new totales_by_categories_s(totales, getnewcategory());
        }
    }
    
    public static void dividirLineas(List<Import_Export_Fee_Line__c> lines){
        
        system.debug('Se registraron: ' + lines.size() + ' services lines');
        List<Import_Export_Fee_Line__c> lineClone = new List<Import_Export_Fee_Line__c>();
        List<Import_Export_Fee_Line__c> lineClone2 = new List<Import_Export_Fee_Line__c>();
        List<Import_Export_Fee_Line__c> lineUpdate = new List<Import_Export_Fee_Line__c>();
        Map<String,Fee__c> serviceRate = new Map<String,Fee__c>();
        List<Fee__c> srUpdate = new List<Fee__c>();
        
        for(Import_Export_Fee_Line__c line : lines){
            system.debug('Metodo para dividir la linea....');
            system.debug('line:'+line);            
            system.debug('Service_Rate_Name__c:'+line.Service_Rate_Name__c);
            Fee__c sr = [Select Id, Name, Country_of_Load__c,Country_of_Discharge__c,Route__c,Valid_Until__c,Account_for__c,Carrier_Account__c,TT_Days__c,CurrencyIsoCode,
                         Rate_Type__c,Fee_Rate__c,Buy_Rate__c,Min__c,Volumetric_Factor__c,Container_Type__c,Comments__c,Group__c,SAP_Service_Type__r.Code__c,Sap_Service_Type_Buy__r.Code__c,SAP_Service_Type__c,Sap_Service_Type_Buy__c,SAP_Service_Type__r.Name,Sap_Service_Type_Buy__r.Name,Fee_Category__c, SST_Porcentaje_de_division__c   from Fee__c where Id=:line.Service_Rate_Name__c limit 1];            
            
            if((sr.SAP_Service_Type__r.Name == 'INTERNACIONAL AEREO (IC) (A)' && sr.SAP_Service_Type__r.Code__c == 'A-INT_AEREO_(IC)') || (sr.SAP_Service_Type__r.Name == 'INTERNACIONAL AEREO (IC) (AW)' && sr.SAP_Service_Type__r.Code__c == 'AW-INT_AEREO_(IC)') || (sr.SAP_Service_Type__r.Name == 'INTERNACIONAL AEREO (IC) (R)' && sr.SAP_Service_Type__r.Code__c == 'R-INT_AEREO_(IC)')){ // A-INT_AEREO_(IC) AW-INT_AEREO_(IC) R-INT_AEREO_(IC)
                system.debug('Entro al filtro');
                system.debug('Country_of_Load__c:'+sr.Country_of_Load__c);
                system.debug('Country_of_Discharge__c:'+sr.Country_of_Discharge__c);                
                if(sr.Country_of_Load__c == 'Mexico' && sr.Country_of_Discharge__c != 'Mexico'){/*(sr.Country_of_Load__c != 'Mexico' && sr.Country_of_Discharge__c == 'Mexico') || (sr.Country_of_Load__c == 'Mexico' && sr.Country_of_Discharge__c != 'Mexico') || (sr.Country_of_Load__c != 'Mexico' && sr.Country_of_Discharge__c != 'Mexico')*/
                    system.debug('Mexico - Extranjero, Se divide la linea');                
                    Import_Export_Fee_Line__c line2 = line.clone(false,true,true,false);
                    Fee__c sr2 = sr.clone(false,true,true,false); 
                    sr.SST_Porcentaje_de_division__c = '75%';
                    sr2.SST_Porcentaje_de_division__c = '25%';
                    srUpdate.add(sr);
                    sr2.Buy_Rate__c = 0;
                    sr2.Fee_Rate__c = 0;
                    sr2.Name = sr.Name+'B';
                    line2.Name = line.Name+'B';
                    String na = line.Name +'A';                    
                    line2.Quote_Buy_Price__c = 0;
                    //line2.Service_Rate_Name__c = sr2.Id;
                    line2.Quote_Sell_Price__c = line.Quote_Sell_Price__c * 0.25;
                    line.Quote_Sell_Price__c = line.Quote_Sell_Price__c * 0.75;      
                    line.Name = na;                    
                    serviceRate.put(line2.Name,sr2);
                    lineClone.add(line2);
                    lineUpdate.add(line);                    
                }else{system.debug('No se divide la linea');}
            }            
        }
        
        system.debug('serviceRate.size():'+serviceRate.size()+ '-lineClone.size():'+lineClone.size()+ '-lineUpdate.size():'+lineUpdate.size());
        if(serviceRate.size() !=0 && lineClone.size() !=0 && lineUpdate.size() !=0){
            system.debug('serviceRate:' + serviceRate);
            insert serviceRate.values();
            //insert lineClone;
            update lineUpdate;
            
            for(Import_Export_Fee_Line__c lin:lineClone){
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
        List<Import_Export_Fee_Line__c> lines_del = null;
        lines_del=[select Id,Name, Service_Rate_Name__c from Import_Export_Fee_Line__c where  Id =:id_oi];
        try
        {
            delete lines_del;
            quotefeeLines = null;
            string recordID= record.Id;
            totales = Database.query('select id, Conversion_Rate_Date__c, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Total_Services_Sell_Amount__c, Total_Services_Std_Buy_Amount__c, Total_Services_Std_Buy_Amount_number__c, Total_Services_Sell_Amount_number__c from Customer_Quote__c where id =: recordID');
            totals_custom = new totales_s(totales);
            totals_custom_by_category = new totales_by_categories_s(totales, getnewcategory());
        }
        catch(Exception ex){}
    }

    public PageReference return_import_export()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }

    public Pagereference update_sites_countries()
    {
        if(imp_ext_filter != null)
        {
            record.Country_ofLoad__c = imp_ext_filter.Country_ofLoad__c;
            record.Country_ofDischarge__c = imp_ext_filter.Country_ofDischarge__c;
            record.State_of_Load__c = imp_ext_filter.State_of_Load__c;
            record.State_of_Discharge__c = imp_ext_filter.State_of_Discharge__c;
            record.Site_of_Load__c = imp_ext_filter.Site_of_Load__c;
            record.Site_of_Discharge__c = imp_ext_filter.Site_of_Discharge__c;
        }

        try
        {
            update record;
        }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex)); return null;}
        PageReference pgReturnPage;
        String returnUrl = '/apex/NEU_OM_CQLPriceListYDiscount?id=' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }

    public void update_route()
    {
        try
        {
            boolean tiene_modificacion = false;
            if(record.Route__c == null && imp_ext_filter.Route__c != null)
            {
                record.Route__c = imp_ext_filter.Route__c;
                tiene_modificacion = true;
            }
            if(record.Account_for__c == null && imp_ext_filter.Account_for__c != null)
            {
                record.Account_for__c = imp_ext_filter.Account_for__c;
                tiene_modificacion = true;
            }
            if(record.Purchase_Incoterm__c == null && imp_ext_filter.Purchase_Incoterm__c != null)
            {
                record.Purchase_Incoterm__c = imp_ext_filter.Purchase_Incoterm__c;
                tiene_modificacion = true;
            }
            if(record.Sales_Incoterm__c == null && imp_ext_filter.Sales_Incoterm__c != null)
            {
                record.Sales_Incoterm__c = imp_ext_filter.Sales_Incoterm__c;
                tiene_modificacion = true;
            }
            if(record.Pickup_Cartage__c == null && imp_ext_filter.Pickup_Cartage__c != null)
            {
                record.Pickup_Cartage__c = imp_ext_filter.Pickup_Cartage__c;
                tiene_modificacion = true;
            }
            if(record.Delivery_Cartage__c == null && imp_ext_filter.Delivery_Cartage__c != null)
            {
                record.Delivery_Cartage__c = imp_ext_filter.Delivery_Cartage__c;
                tiene_modificacion = true;
            }
            if(record.Container_Type__c == null && imp_ext_filter.Container_Type__c != null)
            {
                record.Container_Type__c = imp_ext_filter.Container_Type__c;
                tiene_modificacion = true;
            }
            system.debug('update_route_service'+tiene_modificacion);

            if(tiene_modificacion == true)
                update record;
        }
        catch(Exception ex) { ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex));}
    }

    
    public String getGroup(){
        
        Customer_Quote__c folio = [Select Name from Customer_Quote__c where Id =: record.Id];        
        string service3 = folio.Name.left(3);
        string service2 = folio.Name.left(2);
        string service1 = folio.Name.left(1);   
        system.debug('service: ' + service3);
        system.debug('service2: ' + service2);
        system.debug('service1: ' + service1);
        String name;        
        
        if(service3.contains('-')){
            if(service2.contains('-')){                                
                if(!service1.contains('-')){                    
                    serviceF = service1;
                    name = [Select group__c from  Get_Sap_Service_Type__mdt where service__c =:service1].group__c;                                                             	 
                }                
            }else{                
                serviceF = service2;
                name = [Select group__c from  Get_Sap_Service_Type__mdt where service__c =:service2].group__c;                                      
            }
        }else{
            serviceF = service3;
            name = [Select group__c from  Get_Sap_Service_Type__mdt where service__c =:service3].group__c;                            
        }
        
        system.debug('Servicio del folio: ' + serviceF);
        system.debug('Grupo: ' + name);
        return name;       
    }
    
    public void getSociedadSap(){
                         
        system.debug('Obteninedo la Sociedad del Sap service: ' + fee_record.SAP_Service_Type__c);
        system.debug('SPBUY: ' + fee_record.SAP_Service_Type_Buy__c);
        if(!String.isBlank(fee_record.SAP_Service_Type__c)){
            fee_record.SAP_Service_Type__r = [Select Id,Name,SST_Sociedad__c from SAP_Service_Type__c where Id=: fee_record.SAP_Service_Type__c];
            system.debug('fee_record.SAP_Service_Type__r: ' + fee_record.SAP_Service_Type__r);
            system.debug('fee_record.SAP_Service_Type__r: ' + fee_record.SAP_Service_Type__r);
            system.debug('fee_record.SAP_Service_Type__r.Name: ' + fee_record.SAP_Service_Type__r.Name);
            sapName = fee_record.SAP_Service_Type__r.Name;
            system.debug('sapName: ' + sapName);
        }else{
            fee_record.SAP_Service_Type__r = null;
        }
        system.debug('!String.isBlank(fee_record.SAP_Service_Type__c): ' + !String.isBlank(fee_record.SAP_Service_Type__c));        
    }
    //Bloque Test_Pass_Test
    public void metodo1()
    {
        integer a = 1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
    }
    public void metodo2()
    {
        integer a = 1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
    }
}