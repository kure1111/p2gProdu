public with sharing class NEU_Create_Disbursement_Service_Item extends NEU_Controller_Comparable
{

    public Shipment_Disbursement__c record = null;
    public string amount{get;set;}
    public string id_linea{get;set;}
    public integer contador_lineas_disbursement{get;set;}

    public String Disbursement_Currency_String
    {
        get
        {
            if (UserInfo.isMultiCurrencyOrganization())
                return ' (' + NEU_CurrencyUtils.getCurrencyIsoCode(record) + ')';
            else if (!UserInfo.isMultiCurrencyOrganization())
                return ' (' + Userinfo.getDefaultCurrency() + ')';
            return '';
        }
    }

    public override void sortList(Integer listNumber)
    {
        if(listNumber==0)
            Lines_ie_services.sort();
        else if(listNumber==1)
            Lines_shipment_services.sort();
    }

    public class Disbursement_Line_s extends NEU_Line_Comparable
    {
        public Disbursement_Line_s(NEU_Controller_Comparable parent)
        {
            super(parent);
        }
        public override Object getValue(String compareField)
        {
            if(compareField=='selected')
                return selected;
            return getValue(line,compareField);
        }
        public boolean selected{get;set;}
        public String id_record{get;set;}
        public Decimal total_include_vat{get;set;}
        public String total_include_vatString{
            get
            {
                return NEU_Utils.safeString(total_include_vat,2);
            }
        }
        public Disbursement_Line__c line{get;set;}

        public Fee__c fee_filter{get;set;}
        public List<SelectOption> valores_nombre{get;set;}
        public String nombre_selected{get;set;}

    }

    public void new_disbursement_line()
    {
        system.debug('Controlador');

        Disbursement_Line_s d_line_new = new Disbursement_Line_s(this);
        contador_lineas_disbursement ++;
        string numerodelinea = string.valueof(contador_lineas_disbursement);
        while(numerodelinea.length()<3)
        {
            numerodelinea ='0'+numerodelinea;
        }
        d_line_new.selected = false;
        Disbursement_Line__c new_dl = new Disbursement_Line__c();

        new_dl.Amount__c = NEU_Utils.safeDecimal(amount);
        for(Schema.PicklistEntry pv:Disbursement_Line__c.VAT__c.getDescribe().getPicklistValues())
        {
            if(pv.isDefaultValue())
            {
                new_dl.VAT__c=pv.getValue();
                break;
            }
        }

        // Nuevas Shipment Service Lines:
        for(DisbursementS_s dl: Lines_shipment_services)
        {
            if(dl.line != null && dl.line.Shipment_Service_Line__c != null && string.isnotempty(id_linea))
                if(dl.line.Shipment_Service_Line__c == id_linea)
                {
                    // Construcción del concepto al igual que en las líneas del documento de cotización.
                    String concepto = '';
                    if(dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.RecordType.Name == 'Sea/Ground Freight')
                    {
                        if(dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c == 'POL Charges' || dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c == 'Automotive' || dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c == 'OBC')
                        {
                            concepto += dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c + ' - ' + dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Name;
                        }
                        else
                        {
                            if (dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Port_Airport_of_Load__c!=null && 	dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Port_Airport_of_Discharge__c!=null)
                            {
                                concepto += dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c + ' - ' + dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Port_Airport_of_Load__c + '-' + dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Port_Airport_of_Discharge__c;
                            }
                            else
                            {
                                concepto += dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c;
                            }
                        }
                    }
                    else if(dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.RecordType.Name == 'Local Transport')
                    {
                        if(dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Port_Airport__r.Name!=null && dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Delivery_Zone__r.Name!=null)
                        {
                            concepto += dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c + ' - ' + dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Port_Airport__r.Name + '-' + dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Delivery_Zone__r.Name;
                        }else{
                            concepto += dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c;
                        }
                    }
                    else if(dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.RecordType.Name == 'Other Service Charges')
                    {
                        concepto += dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Fee_Category__c + ' - ' + dl.line.Shipment_Service_Line__r.Service_Rate_Name__r.Name;
                    }

                    new_dl.Concept__c = concepto;

                    if(dl.same_currency)
                    {
                        new_dl.Unit_Price__c = dl.line.Shipment_Service_Line__r.Shipment_Buy_Price__c;
                    }
                    else
                    {
                        new_dl.Unit_Price__c =  (NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Shipment_Buy_Price__c) * NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(dl.Disbursement_Conversion_Rate)).setScale(2);
                    }


                    if(dl.line.Shipment_Service_Line__r.Std_Buy_Amount__c == NEU_Utils.safeDecimal(amount) && dl.same_currency)
                    {
                        new_dl.Units__c = Math.abs(NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Units__c));
                    }
                    else
                    {
                        if(dl.same_currency)
                        {
                            new_dl.Units__c = Math.abs((NEU_Utils.safeDecimal(amount)*NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Units__c))/NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Std_Buy_Amount__c));
                        }
                        else
                        {
                            new_dl.Units__c = Math.abs((NEU_Utils.safeDecimal(amount)*NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Units__c))/(NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Std_Buy_Amount__c) * NEU_Utils.safeDecimal(dl.line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(dl.Disbursement_Conversion_Rate)).setScale(2));
                        }
                    }

                    new_dl.Import_Export_Quote_Order__c=dl.line.Shipment_Service_Line__r.Import_Export_Quote__c;
                    new_dl.Shipment__c = dl.line.Shipment_Service_Line__r.Shipment__c;

                    break;
                }
        }

        new_dl.Amount__c =NEU_Utils.safeDecimal(amount);
        new_dl.Disbursement__c = record.Id;
        new_dl.Name = numerodelinea;
        new_dl.CurrencyIsoCode = record.CurrencyIsoCode;
        d_line_new.line = new_dl;
        datetime expire = system.now();
        String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
                expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';
        d_line_new.id_record = string.valueof(expire).replace(' ','').replace('-','').replace(':','');
        Lines_disbursements.add(d_line_new);
    }

    public void quit_line_select()
    {
        if(Lines_disbursements!=null)
        {
            contador_lineas_disbursement --;
            for(integer i = 0; i<Lines_disbursements.size(); i++)
            {
                if(Lines_disbursements[i].id_record == id_linea)
                    Lines_disbursements.remove(i);
            }

            for(integer i = 0; i<Lines_disbursements.size(); i++)
            {
                string numerodelinea = string.valueof(i+1);
                while(numerodelinea.length()<3)
                {
                    numerodelinea ='0'+numerodelinea;
                }
                Lines_disbursements[i].line.Name = numerodelinea;
            }
        }
    }


    public void delete_line_select()
    {
        contador_lineas_disbursement--;
        List<Disbursement_Line__c> lines_del = null;
        lines_del = [select Id,Name from Disbursement_Line__c where Id = :id_linea];
        try
        {
            if (Lines_disbursements != null)
            {
                for (integer i = 0; i < Lines_disbursements.size(); i++)
                {
                    if (Lines_disbursements[i].line.Id == id_linea)
                        Lines_disbursements.remove(i);
                }

                for (integer i = 0; i < Lines_disbursements.size(); i++)
                {
                    string numerodelinea = string.valueof(i + 1);
                    while (numerodelinea.length() < 3)
                    {
                        numerodelinea = '0' + numerodelinea;
                    }
                    Lines_disbursements[i].line.Name = numerodelinea;
                }
            }
            delete lines_del;
        }
        catch (Exception ex) { }
    }

    public void new_line_disbursementline_empty()
    {
        Disbursement_Line_s d_line_new = new Disbursement_Line_s(this);
        contador_lineas_disbursement ++;
        string numerodelinea = string.valueof(contador_lineas_disbursement);
        while(numerodelinea.length()<3)
        {
            numerodelinea ='0'+numerodelinea;
        }
        d_line_new.selected = false;
        datetime expire = system.now();
        String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
                expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';
        d_line_new.id_record = string.valueof(expire).replace(' ','').replace('-','').replace(':','');
        Disbursement_Line__c new_dl = new Disbursement_Line__c();
        for(Schema.PicklistEntry pv:Disbursement_Line__c.VAT__c.getDescribe().getPicklistValues())
        {
            if(pv.isDefaultValue())
            {
                new_dl.VAT__c=pv.getValue();
                break;
            }
        }
        new_dl.name = numerodelinea;
        new_dl.Disbursement__c = record.Id;
        new_dl.Import_Export_Quote_Order__c = record.Import_Export_Quote_Order__c;
        new_dl.Shipment__c = record.Shipment__c;
        if(Lines_disbursements != null && Lines_disbursements.size()>0)
            new_dl.VAT__c = Lines_disbursements[0].line.VAT__c;
        new_dl.CurrencyIsoCode = record.CurrencyIsoCode;
        d_line_new.line = new_dl;
        Lines_disbursements.add(d_line_new);
    }

    public List<Disbursement_Line_s> Lines_disbursements
    {
        get
        {
            if(Lines_disbursements==null)
            {
                Lines_disbursements=new List<Disbursement_Line_s>();
                List<Disbursement_Line__c> query_disbursement_lines = [select Id, Name, Amount__c, Concept__c, Total_VAT__c, Unit_Price__c, Units__c, VAT__c, VAT_Withholding__c, 
                VAT_Withholding_ISR__c, SAP_Service_Type__c, Group__c  
                from Disbursement_Line__c where Disbursement__c =: record.Id order by name];
                for(Disbursement_Line__c d_line: query_disbursement_lines)
                {
                    Disbursement_Line_s d_line_new = new Disbursement_Line_s(this);
                    d_line_new.selected = true;
                    d_line_new.line = d_line;
                    datetime expire = system.now();
                    String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
                            expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';
                    d_line_new.id_record = d_line.Id;//string.valueof(expire).replace(' ','').replace('-','').replace(':','');
                    Lines_disbursements.add(d_line_new);
                    contador_lineas_disbursement++;
                }
            }
            return Lines_disbursements;
        }
        set;
    }

    public class Disbursement_ie_services_s extends NEU_Line_Comparable
    {
        public Disbursement_ie_services_s (NEU_Controller_Comparable parent)
        {
            super(parent);
            this.same_currency = true;
        }
        public override Object getValue(String compareField)
        {
            if(compareField=='selected')
                return selected;
            return getValue(line,compareField);
        }
        public boolean selected{get;set;}
        public boolean same_currency{get;set;}
        public Import_Export_Service_Line_Disbursement__c line{get;set;}

        // Nuevos cambios para líneas en otras monedas distintas a las de la cabecera
        public Decimal Disbursement_Conversion_Rate{get;set;}

        public String Quote_Buy_Price_String{
            get
            {
                if(this.same_currency)
                {
                    return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + NEU_Utils.safeString(this.line.Import_Export_Service_Line__r.Quote_Buy_Price__c,2);
                }
                return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + (NEU_Utils.safeDecimal(this.line.Import_Export_Service_Line__r.Quote_Buy_Price__c) * NEU_Utils.safeDecimal(this.line.Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2) + ' (' + NEU_CurrencyUtils.getCurrencyIsoCode(this.line.Import_Export_Service_Line__r) + ' ' +this.line.Import_Export_Service_Line__r.Quote_Buy_Price__c + ')';
            }
        }

        public String Buy_Amount_String{
            get
            {
                if(this.same_currency)
                {
                    return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + NEU_Utils.safeString(this.line.Import_Export_Service_Line__r.Buy_Amount__c,2);
                }
                return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + (NEU_Utils.safeDecimal(this.line.Import_Export_Service_Line__r.Buy_Amount__c) * NEU_Utils.safeDecimal(this.line.Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2) + ' (' + NEU_CurrencyUtils.getCurrencyIsoCode(this.line.Import_Export_Service_Line__r) + ' ' +this.line.Import_Export_Service_Line__r.Buy_Amount__c + ')';
            }
        }

        public Decimal Disbursement_Outstanding_Balance{
            get
            {
                if(this.same_currency)
                {
                    return this.line.Import_Export_Service_Line__r.Disbursement_Outstanding_Balance__c;
                }
                return (NEU_Utils.safeDecimal(this.line.Import_Export_Service_Line__r.Disbursement_Outstanding_Balance__c) * NEU_Utils.safeDecimal(this.line.Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2);
            }
            set;
        }
        public String Disbursement_Outstanding_Balance_String{
            get
            {
                return NEU_Utils.safeString(Disbursement_Outstanding_Balance,2);
            }
        }
        public Decimal Disbursement_Outstanding_Base{
            get
            {
                if(this.same_currency)
                {
                    return Disbursement_Outstanding_Base;
                }
                return (NEU_Utils.safeDecimal(Disbursement_Outstanding_Base) * NEU_Utils.safeDecimal(this.line.Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2);
            }
            set;
        }
    }

    public List<Disbursement_ie_services_s> Lines_ie_services{
        get
        {
            if(Lines_ie_services==null)
            {
                Lines_ie_services=new List<Disbursement_ie_services_s>();
                string id_ie_record = record.Import_Export_Quote_Order__c;

                List<Import_Export_Fee_Line__c> slines=[select Id,Name,Disbursement_Outstanding_Balance__c,CurrencyIsoCode,Service_Rate_Category__c,Service_Rate_Name__r.Name,Rate_Type__c,Units__c,Quote_Buy_Price__c,Buy_Amount__c,Conversion_Rate_to_Currency_Header__c,Service_Rate_Name__r.Port_Airport__r.Name,Service_Rate_Name__r.Delivery_Zone__r.Name,Import_Export_Quote__c,Service_Rate_Name__r.RecordType.Name,Service_Rate_Name__r.Fee_Category__c,Service_Rate_Name__r.Port_Airport_of_Load__c,Service_Rate_Name__r.Port_Airport_of_Discharge__c from Import_Export_Fee_Line__c where Import_Export_Quote__c=: id_ie_record order by Name asc];
                List<Import_Export_Service_Line_Disbursement__c> dlines=[select Id,Name,Amount__c,Disbursement__c,Import_Export_Service_Line__c from Import_Export_Service_Line_Disbursement__c where Disbursement__c =: record.Id];

                for(Import_Export_Fee_Line__c sline:slines)
                {
                    Disbursement_ie_services_s dline=new Disbursement_ie_services_s(this);
                    for(Import_Export_Service_Line_Disbursement__c d:dlines)
                    {
                        if(d.Import_Export_Service_Line__c==sline.Id)
                        {
                            dline.line=d;
                            dline.line.Name='SDN-'+sline.Name;
                            dline.line.CurrencyIsoCode = record.CurrencyIsoCode;
                            dline.Disbursement_Conversion_Rate = record.Conversion_Rate_to_Imp_Exp_Currency__c;
                            dline.line.Import_Export_Service_Line__r=sline;
                            dline.Disbursement_Outstanding_Base=dline.Disbursement_Outstanding_Balance+NEU_Utils.safeDecimal(d.Amount__c);
                            dline.selected=true;
                            dline.same_currency= true;
                            if(NEU_CurrencyUtils.getCurrencyIsoCode(record) != NEU_CurrencyUtils.getCurrencyIsoCode(sline))
                                dline.same_currency= false;
                            break;
                        }
                    }
                    if(dline.line==null)
                    {
                        dline.line=new Import_Export_Service_Line_Disbursement__c();
                        dline.line.Name='SDN-'+sline.Name;
                        dline.line.CurrencyIsoCode = record.CurrencyIsoCode;
                        dline.Disbursement_Conversion_Rate = record.Conversion_Rate_to_Imp_Exp_Currency__c;
                        dline.line.Disbursement__c=record.Id;
                        dline.line.Import_Export_Service_Line__c=sline.Id;
                        dline.line.Import_Export_Service_Line__r=sline;
                        dline.Disbursement_Outstanding_Base=NEU_Utils.safeDecimal(sline.Disbursement_Outstanding_Balance__c);
                        dline.selected=false;
                        dline.same_currency= true;
                        if(NEU_CurrencyUtils.getCurrencyIsoCode(record) != NEU_CurrencyUtils.getCurrencyIsoCode(sline))
                            dline.same_currency= false;

                        if(dline.same_currency==true)
                        {
                            dline.line.Amount__c=NEU_Utils.safeDecimal(sline.Disbursement_Outstanding_Balance__c);
                        }
                        else
                        {
                            dline.line.Amount__c=(NEU_Utils.safeDecimal(NEU_Utils.safeDecimal(sline.Disbursement_Outstanding_Balance__c)) * NEU_Utils.safeDecimal(sline.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(dline.Disbursement_Conversion_Rate)).setScale(2);
                        }
                    }
                    Lines_ie_services.add(dline);
                }
            }
            return Lines_ie_services;
        }
        set;
    }

    public class DisbursementS_s extends NEU_Line_Comparable
    {
        public DisbursementS_s(NEU_Controller_Comparable parent)
        {
            super(parent);
            this.same_currency = true;
        }
        public override Object getValue(String compareField)
        {
            if(compareField=='selected')
                return selected;
            return getValue(line,compareField);
        }
        public boolean selected{get;set;}
        public boolean same_currency{get;set;}
        public Shipment_Service_Line_Disbursement__c line{get;set;}

        // Nuevos cambios para líneas en otras monedas distintas a las de la cabecera
        public Decimal Disbursement_Conversion_Rate{get;set;}

        public String Shipment_Buy_Price_String
        {
            get
            {
                if(this.same_currency)
                {
                    return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + NEU_Utils.safeString(this.line.Shipment_Service_Line__r.Shipment_Buy_Price__c,2);
                }
                return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + (NEU_Utils.safeDecimal(this.line.Shipment_Service_Line__r.Shipment_Buy_Price__c) * NEU_Utils.safeDecimal(this.line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2) + ' (' + NEU_CurrencyUtils.getCurrencyIsoCode(this.line.Shipment_Service_Line__r) + ' ' +this.line.Shipment_Service_Line__r.Shipment_Buy_Price__c + ')';
            }
        }

        public String Buy_Amount_String{
            get
            {
                if(this.same_currency)
                {
                    return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + NEU_Utils.safeString(this.line.Shipment_Service_Line__r.Std_Buy_Amount__c,2);
                }
                return NEU_CurrencyUtils.getCurrencyIsoCode(this.line) + ' ' + (NEU_Utils.safeDecimal(this.line.Shipment_Service_Line__r.Std_Buy_Amount__c) * NEU_Utils.safeDecimal(this.line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2) + ' (' + NEU_CurrencyUtils.getCurrencyIsoCode(this.line.Shipment_Service_Line__r) + ' ' +this.line.Shipment_Service_Line__r.Std_Buy_Amount__c + ')';
            }
        }

        public Decimal Disbursement_Outstanding_Balance
        {
            get
            {
                if(this.same_currency)
                {
                    return this.line.Shipment_Service_Line__r.Outstanding_Balance__c;
                }
                return (NEU_Utils.safeDecimal(this.line.Shipment_Service_Line__r.Outstanding_Balance__c) * NEU_Utils.safeDecimal(this.line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2);
            }
            set;
        }

        public String Disbursement_Outstanding_Balance_String{
            get
            {
                return NEU_Utils.safeString(Disbursement_Outstanding_Balance,2);
            }
        }

        public Decimal Disbursement_Outstanding_Base{
            get
            {
                if(this.same_currency)
                {
                    return Disbursement_Outstanding_Base;
                }
                return (NEU_Utils.safeDecimal(Disbursement_Outstanding_Base) * NEU_Utils.safeDecimal(this.line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(this.Disbursement_Conversion_Rate)).setScale(2);
            }
            set;
        }
    }

    public List<DisbursementS_s> Lines_shipment_services
    {
        get
        {
            if(Lines_shipment_services==null)
            {
                Lines_shipment_services=new List<DisbursementS_s>();
                List<Shipment_Fee_Line__c> slines = [select Id, Name,CurrencyIsoCode, Outstanding_Balance__c,Service_Rate_Category__c,Service_Rate_Name__r.Name,Rate_Type__c,Units__c,Shipment_Buy_Price__c,Std_Buy_Amount__c,Conversion_Rate_to_Currency_Header__c,Service_Rate_Name__r.Port_Airport__r.Name,Service_Rate_Name__r.Delivery_Zone__r.Name,Import_Export_Quote__c,Service_Rate_Name__r.RecordType.Name,Service_Rate_Name__r.Fee_Category__c,Service_Rate_Name__r.Port_Airport_of_Load__c,Service_Rate_Name__r.Port_Airport_of_Discharge__c, Shipment__c from Shipment_Fee_Line__c where Shipment__c=:record.Shipment__c order by Name asc];
                List<Shipment_Service_Line_Disbursement__c> dlines=[select Id, Name, Amount__c,Shipment_Disbursement__c,Shipment_Service_Line__c from Shipment_Service_Line_Disbursement__c where Shipment_Disbursement__c=:record.Id];
                for(Shipment_Fee_Line__c sline:slines)
                {
                    DisbursementS_s dline=new DisbursementS_s(this);
                    for(Shipment_Service_Line_Disbursement__c d : dlines)//---hacer con un map
                    {
                        if (d.Shipment_Service_Line__c == sline.Id)
                        {
                            dline.line = d;
                            dline.line.Name = 'SDN-' + sline.Name;
                            dline.line.CurrencyIsoCode = record.CurrencyIsoCode;
                            dline.Disbursement_Conversion_Rate = record.Conversion_Rate_to_Imp_Exp_Currency__c;
                            dline.line.Shipment_Service_Line__r = sline;
                            dline.Disbursement_Outstanding_Base = dline.Disbursement_Outstanding_Balance + NEU_Utils.safeDecimal(d.Amount__c);
                            dline.selected = true;
                            dline.same_currency = true;
                            if (NEU_CurrencyUtils.getCurrencyIsoCode(record) != NEU_CurrencyUtils.getCurrencyIsoCode(sline))
                                dline.same_currency = false;
                            break;
                        }
                    }

                    if(dline.line==null)
                    {
                        dline.line=new Shipment_Service_Line_Disbursement__c();
                        dline.line.Name='SDN-'+sline.Name;
                        dline.line.CurrencyIsoCode = record.CurrencyIsoCode;
                        dline.Disbursement_Conversion_Rate = record.Conversion_Rate_to_Imp_Exp_Currency__c;
                        dline.line.Shipment_Disbursement__c=record.Id;
                        dline.line.Shipment_Service_Line__c=sline.Id;
                        dline.line.Shipment_Service_Line__r=sline;
                        dline.Disbursement_Outstanding_Base=NEU_Utils.safeDecimal(sline.Outstanding_Balance__c);
                        dline.selected=false;
                        dline.same_currency= true;
                        if(NEU_CurrencyUtils.getCurrencyIsoCode(record) != NEU_CurrencyUtils.getCurrencyIsoCode(sline))
                            dline.same_currency= false;

                        if(dline.same_currency==true)
                        {
                            dline.line.Amount__c=NEU_Utils.safeDecimal(sline.Outstanding_Balance__c);
                        }
                        else
                        {
                            dline.line.Amount__c=(NEU_Utils.safeDecimal(NEU_Utils.safeDecimal(sline.Outstanding_Balance__c)) * NEU_Utils.safeDecimal(sline.Conversion_Rate_to_Currency_Header__c) / NEU_Utils.safeDecimal(dline.Disbursement_Conversion_Rate)).setScale(2);
                        }
                    }
                    Lines_shipment_services.add(dline);
                }
            }
            return Lines_shipment_services;
        }
        set;
    }

    ApexPages.StandardController con;
    public NEU_Create_Disbursement_Service_Item(ApexPages.StandardController stdController) {
        super(2);
        if (!Test.isRunningTest()){stdController.AddFields(new String[]{'Id','Invoice_Amount_Exc__c','Shipment__c','Import_Export_Quote_Order__c','CurrencyIsoCode','Conversion_Rate_to_Imp_Exp_Currency__c'});}//Outstanding_Balance__c
        con=stdController;
        record=(Shipment_Disbursement__c)stdController.getRecord();

        contador_lineas_disbursement = 0;
    }

    public PageReference cancel()
    {
        return con.view();
    }

    public PageReference generate()
    {
        List<Import_Export_Service_Line_Disbursement__c>toUpsert=new List<Import_Export_Service_Line_Disbursement__c>();
        List<Import_Export_Service_Line_Disbursement__c>toDelete=new List<Import_Export_Service_Line_Disbursement__c>();
        for(Disbursement_ie_services_s line:Lines_ie_services)
        {
            NEU_CurrencyUtils.setCurrencyIsoCode(line.line,NEU_CurrencyUtils.getCurrencyIsoCode(record));
            if(!line.selected)
            {
                if(line.line.Id!=null)
                    toDelete.add(line.line);
            }
            else
                    toUpsert.add(line.line);
        }
        if(toUpsert.size()>0)
            upsert toUpsert;
        if(toDelete.size()>0)
            delete toDelete;



        List<Shipment_Service_Line_Disbursement__c>toUpsertS=new List<Shipment_Service_Line_Disbursement__c>();
        List<Shipment_Service_Line_Disbursement__c>toDeleteS=new List<Shipment_Service_Line_Disbursement__c>();
        for(DisbursementS_s line:Lines_shipment_services)
        {
            NEU_CurrencyUtils.setCurrencyIsoCode(line.line,NEU_CurrencyUtils.getCurrencyIsoCode(record));
            if(!line.selected)
            {
                if(line.line.Id!=null)
                    toDeleteS.add(line.line);
            }
            else
                    toUpsertS.add(line.line);
        }
        if(toUpsertS.size()>0)
            upsert toUpsertS;
        if(toDeleteS.size()>0)
            delete toDeleteS;

        if(Lines_disbursements != null)
        {
            List<Disbursement_Line__c> listado_disbursement_line = new List<Disbursement_Line__c>();
            for(Disbursement_Line_s dl: Lines_disbursements)
            {
                dl.line.Amount__c = NEU_Utils.safeDecimal(dl.line.Amount__c);
                listado_disbursement_line.add(dl.line);
            }
            if(listado_disbursement_line.size()>0)
                upsert listado_disbursement_line;
        }

        //update record; de momento no se actualiza el campo outstanding balance
        return con.view();
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

}