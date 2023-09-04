public with sharing class NEU_Order_Confirmation_IE_details_pdf 
{
	public Customer_Quote__c record;
    public integer contador {get;set;}
    public String fecha {get;set;}
    public string observaciones {get;set;}
    public string datoscuenta {get;set;}
    public string invoice {get;set;}
    public string porcentagecomisiongeneral {get;set;}
    public string totalvalue {get;set;}
    public decimal total {get;set;}
    public string comprobante {get;set;}
    public decimal totalamount {get;set;}
    public string moneda {get;set;}
    ApexPages.StandardController con;
            
    public NEU_Order_Confirmation_IE_details_pdf(ApexPages.StandardController stdController) {

        con = stdController;
         
        try { 
            record = Database.query('select Id, Name,'+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Account_for__c, Quotation_Status__c, SUM_Buy_Origin_Amount_number__c, Total_Services_Sell_Amount__c ,  Incoterm_Place__c,SUM_Sell_Destination_Amount_number__c, Contact__r.Phone, Account_for__r.Phone, Account_for__r.BillingStreet,   Account_for__r.BillingCity, Country_ofLoad__c, Country_ofLoad__r.Name, State_of_Load__c, State_of_Load__r.Name, Site_of_Load__c, Site_of_Load__r.Name, Country_ofDischarge__c, Country_ofDischarge__r.Name, State_of_Discharge__c, State_of_Discharge__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name, Total_Items_Units__c, SUM_Buy_Origin_Amount__c, Total_Weight_Kg2__c, Total_Volume_m3_2__c, Purchase_Incoterm__c, Account_for__r.BillingState, Account_for__r.BillingCountry, Account_for__r.Name, Supplier_Account__c, Supplier_Account__r.Name, Contact__r.Name, SUM_Sell_Origin_Amount__c from Customer_Quote__c where id = \''+ con.getRecord().id+'\'');
        } catch( Exception ee) { 
            record = new Customer_Quote__c(); 
        }
        
    comprobante = '';
    contador = 0;
    total = 0;
    fecha = '';
    observaciones = '';
    datoscuenta = '';
    totalvalue = '';
    porcentagecomisiongeneral = '';
    invoice = '';
    integer ultimalinea = 0;
    integer cont = 0;
    totalamount = 0;
    fecha = system.today().day()+' - '+system.today().month()+' - '+system.today().year();
    
    //DATOS BUYER / SUPPLIER
    datoscuenta +='  <h1 class="title_client_information">CLIENT INFORMATION</h1>';
    datoscuenta +=  '<div class="client_information">';
    datoscuenta +='  <ul class="customer_data" style="    width: 446px;">';
    datoscuenta += '  <li><span class="customer_data_title">COMPANY NAME:</span>&nbsp;<span>'+ (record.Account_for__r.Name != null ? record.Account_for__r.Name : '') +'</span></li>';
    datoscuenta += '  <li><span class="customer_data_title">COMPANY VAT NUMBER:</span>&nbsp;<span></span></li>';
    datoscuenta += '  <li><span class="customer_data_title">COMPANY BILLING ADDRESS:</span>&nbsp;<span>'+(record.Account_for__r.BillingStreet !=null ? record.Account_for__r.BillingStreet+', ' :'')+' '+(record.Account_for__r.BillingCity !=null ? record.Account_for__r.BillingCity+', ' :'')+' '+(record.Account_for__r.BillingState !=null ? record.Account_for__r.BillingState+', ' :'')+' '+(record.Account_for__r.BillingCountry !=null ? record.Account_for__r.BillingCountry+', ' :'')+'</span></li>';
    datoscuenta += '  <li><span class="customer_data_title">COMPANY TELEPHONE NUMBER:</span>&nbsp;<span>'+(record.Account_for__r.Phone !=null ? record.Account_for__r.Phone :'')+'</span></li>';
    datoscuenta +='  </ul>';
    
    datoscuenta +='  <ul class="customer_data_derecha" style="    width: 246px;">';
    datoscuenta += '  <li><span class="customer_data_title">CONTACT PERSON:</span>&nbsp;<span>'+(record.Contact__c != null ? record.Contact__r.Name : '')+'</span></li>';//-------- ver este contact
    datoscuenta += '  <li><span class="customer_data_title">CONTACT PERSON TELEPHONE NUMBER:</span>&nbsp;<span>'+(record.Contact__c != null ? record.Contact__r.Phone : '' )+'</span></li>';//-------- ver este contact
    datoscuenta +='  </ul>';
    
    datoscuenta +=  '</div>';
    
    List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo']; 

    
    //RECORREMOS LAS LINEAS DE L SHIPMENT
    List<Quote_Item_Line__c> sqoline = new List<Quote_Item_Line__c>();
    string query_string_quote_item_line = '';
    query_string_quote_item_line +='select Id, Name, Item_Name__c, Item_Name__r.Name,'; 
    query_string_quote_item_line +='Unit_Destination_Price__c, Item_Name__r.Sourcing_Item_Code__c,Price__c, Weight_Kgs__c, Destination_Sell_Amount_header_currency__c ,Amount__c ,Total_Destination_Amount__c ,Conversion_Rate_to_Currency_Header__c,Packaging_Volume_m3__c ,Packaging_Length_cm__c , Packaging_Width_cm__c ,';
    query_string_quote_item_line +='Packaging_Quantity__c , Item_Units_x_Packaging__c , Packaging_Height_cm__c , Total_Shipping_Weight_Kgs__c, Packaging_Gross_Weight_kg__c , Item_Name__r.Url_Photo_1__c,Expense_Concept__c,Expense_Amount__c ,Total_Shipping_Volume_m3__c,';
    if(UserInfo.isMultiCurrencyOrganization()== true)
        query_string_quote_item_line +='                                                        CurrencyIsoCode,'; 
    query_string_quote_item_line +='Item_Name__r.Item_Description__c, Unit_of_measure__c,';
    query_string_quote_item_line +='Units__c, Origin_Sell_Amount_header_currency__c from Quote_Item_Line__c where Import_Export_Quote__c = \''+ record.Id+'\' order by Name';
    
    
    List<sObject> query_quote_item_line = Database.query(query_string_quote_item_line );
    sqoline = query_quote_item_line;
    //CurrencyIsoCode
    integer contador_items=0;
    invoice +='  <div id="container">';
    invoice +='<div id="top" >';
    invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"  style="margin-top: 40px;" />';
               
    invoice +='<div id="kaelis_address_data">';
    invoice +='  <span class="title">Demo Company</span>';
    invoice +='  <span>Test, 7,</span>';
    invoice +='  <span>test He Xi Heng Rd, Ttest.,</span>';
    invoice +='  <span>test Testtest,</span>';
    invoice +='  <span>Test 28703 ES.</span>';
    invoice +='  <span>Phone.: +34 96 7962 25 82</span>';
    invoice +='  <span>Other Phone.: +34 96 188 80 88  </span>'; 
    invoice +='  <span>Fax: +34 88 693 97 87  </span>'; 
    invoice +='  <span>Web: www.neurored.com</span>';
    invoice +='  </div>';
    invoice +='  </div>';
    invoice +='<div id="mid">';
    
    invoice +='  <h1 class="title_import_export_details" style="    font-size: 19px !important;">ORDER CONFIRMATION</h1>';
    invoice +='<div id="mid_left" style="width: 50%;">';
    invoice +='  <ul class="customer_data">';
    invoice +='    <li><span class="customer_data_title">IMPORT-EXPORT QUOTE/ORDER Nº:</span>&nbsp;<span>'+record.Name+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">COUNTRY OF LOAD:</span>&nbsp;<span>'+(record.Country_ofLoad__c != null ? record.Country_ofLoad__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">STATE OF LOAD:</span>&nbsp;<span>'+(record.State_of_Load__c != null ? record.State_of_Load__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">SITE OF LOAD:</span>&nbsp;<span>'+(record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+'</span></li>';
    invoice +='  </ul>';
    invoice +='</div>';
    invoice +='<div id="mid_right" style="width: 50%;">';
    invoice +='  <ul class="invoice_data" style="float: left;    margin-left: 105px;">';
    invoice +='    <li><span class="invoice_data_title">DATE:</span>&nbsp;<span>'+fecha+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">COUNTRY OF DISCHARGE:</span>&nbsp;<span>'+(record.Country_ofDischarge__c != null ? record.Country_ofDischarge__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">STATE OF DISCHARGE:</span>&nbsp;<span>'+(record.State_of_Discharge__c != null ? record.State_of_Discharge__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">SITE OF DISCHARGE:</span>&nbsp;<span>'+(record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+'</span></li>';
    
    invoice +='  </ul>';
   
    invoice +='</div>';
    invoice +=datoscuenta;
    integer contador_paginas = 0;
    invoice +='  <h1 class="title_import_export_details">ITEM GENERAL INFORMATION</h1>';
    invoice +='  <div id="mid_left" style="width: 50%;">';
    invoice +='     <ul class="customer_data">';
    invoice +='         <li><span class="customer_data_title">TOTAL WEIGHT (KG):</span>&nbsp;<span>'+(record.Total_Weight_Kg2__c != null ? record.Total_Weight_Kg2__c : 0)+'</span></li>';
    invoice +='         <li><span class="customer_data_title">TOTAL VOLUME (M3):</span>&nbsp;<span>'+(record.Total_Volume_m3_2__c != null ? record.Total_Volume_m3_2__c : 0)+'</span></li>';
    invoice +='     </ul>';
   
    invoice +='  </div>';
    
    invoice +='<div id="mid_right" style="width: 50%;">';
    invoice +='  <ul class="invoice_data" style="float: left;    margin-left: 105px;">';
    invoice +='    <li><span class="invoice_data_title">SUM SELL ORIGIN AMOUNT:</span>&nbsp;<span>'+(record.SUM_Sell_Origin_Amount__c != null ? record.SUM_Sell_Origin_Amount__c : 0)+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">TOTAL ITEMS UNITS:</span>&nbsp;<span>'+(record.Total_Items_Units__c != null ? record.Total_Items_Units__c : 0)+'</span></li>';
    invoice +='  </ul>';
   
    invoice +='  </div>';
    
    //invoice +='<hr/>';
    
    invoice += '</div>';
    
    integer contador_de_service_charges = 0;
    //tabla de service charges
    List<Import_Export_Fee_Line__c> listado_de_lineas_de_fees = new List<Import_Export_Fee_Line__c>();
    ID recordid=record.Id;
    listado_de_lineas_de_fees = database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Service_Rate_Name__c, Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Rate_Type__c, Service_Rate_Name__r.Delivery_Zone__r.Name,Service_Rate_Name__r.Route__r.Name, Rate_Type__c, Sell_Rate__c, Service_Rate_Name__r.Valid_Until__c, Conversion_Rate_to_Currency_Header__c, Units__c, Sell_Amount__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Pallet_Type__r.Name,Concept_1_Sell_Price__c, Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c,Concept_1__c, Concept_2__c, Concept_3__c, Concept_4__c, Concept_5__c,Quote_Sell_Net_Price__c,Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Container_Type__r.Name, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c,Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Account_for__c,Service_Rate_Name__r.Account_for__r.Name, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Carrier_Account__r.Name from Import_Export_Fee_Line__c where Import_Export_Quote__c =: recordId order by Name');
    if(ApexPages.currentPage().getParameters().get('services_charges') == 'true')
    {
         
        invoice +='<div id="mid">';
        invoice +='  <h1 class="title_import_export_details">IMPORT-EXPORT SERVICE LINES</h1>';
        invoice +='<hr/>';
        invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
        invoice += '<tr>';
        invoice += '  <th align="center" style="text-align: center;">LINE</th>';
        invoice += '  <th align="center" style="text-align: center;">RATE CATEGORY</th>';
        invoice += '  <th align="center" style="text-align: center;">SERVICE RATE NAME</th>';
        invoice += '  <th align="center" style="text-align: center;">ROUTE</th>'; 
        invoice += '  <th align="center" style="text-align: center;">PICKUP / DELIVERY ZONE</th>'; 
        invoice += '  <th align="center" style="text-align: center;">TT DAYS</th>'; 
        invoice += '  <th align="center" style="text-align: center;">RATE TYPE</th>'; 
        invoice += '  <th align="center" style="text-align: center;">CONT./PALL. TYPE</th>';
        invoice += '  <th align="center" style="text-align: center;">CURR.</th>';
        invoice += '  <th align="center" style="text-align: center;">SELL PRICE</th>';
        invoice += '  <th align="center" style="text-align: center;">UNITS</th>';  
        invoice += '  <th align="center" style="text-align: center;">SELL AMOUNT</th>'; 
        invoice += '</tr>';
        
        //integer contador_items_packaging = 0;
        if(listado_de_lineas_de_fees.size()>0)
          for(Import_Export_Fee_Line__c o : listado_de_lineas_de_fees)
            {
              if((contador_de_service_charges >= 14 && contador_paginas > 1) || ((contador_de_service_charges) >= 6 && contador_paginas == 0) || Test.isRunningTest())
              {
                contador_paginas ++;
                invoice += '  </table>';
                invoice += '</div>';
                invoice +='<div id="top" style="page-break-before:always;">';
                invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
                invoice +='  </div>';
                invoice +='<div id="mid">';
                invoice +='  <h1 class="title_import_export_details">PACKING INFORMATION</h1>';
                invoice +='<hr/>';
                invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
                invoice += '<tr>';
                invoice += '  <th align="center" style="text-align: center;">LINE</th>';
		        invoice += '  <th align="center" style="text-align: center;">RATE CATEGORY</th>';
		        invoice += '  <th align="center" style="text-align: center;">SERVICE RATE NAME</th>';
		        invoice += '  <th align="center" style="text-align: center;">ROUTE</th>'; 
		        invoice += '  <th align="center" style="text-align: center;">PICKUP / DELIVERY ZONE</th>'; 
		        invoice += '  <th align="center" style="text-align: center;">TT DAYS</th>';
		         
		        invoice += '  <th align="center" style="text-align: center;">RATE TYPE</th>'; 
		        invoice += '  <th align="center" style="text-align: center;">CONT./PALL. TYPE</th>';
		        invoice += '  <th align="center" style="text-align: center;">CURR.</th>';
		        invoice += '  <th align="center" style="text-align: center;">SELL PRICE</th>';
		        invoice += '  <th align="center" style="text-align: center;">UNITS</th>';  
		        invoice += '  <th align="center" style="text-align: center;">SELL AMOUNT</th>'; 
                invoice += '</tr>';
                contador_de_service_charges = 0;
              }
             
              
              invoice += '  <tr>';
              invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Fee_Category__c != null ? o.Service_Rate_Name__r.Fee_Category__c : '')+'</td>';
              invoice += '    <td align="center">'+o.Service_Rate_Name__r.Name+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Route__c != null ? o.Service_Rate_Name__r.Route__r.Name : '')+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Delivery_Zone__c != null ? o.Service_Rate_Name__r.Delivery_Zone__r.Name : '')+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.TT_Days__c != null ? o.Service_Rate_Name__r.TT_Days__c : '')+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Rate_Type__c != null ? o.Service_Rate_Name__r.Rate_Type__c : '')+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Container_Type__c != null ? o.Service_Rate_Name__r.Container_Type__r.Name : ( o.Service_Rate_Name__r.Pallet_Type__c != null ? o.Service_Rate_Name__r.Pallet_Type__r.Name : ''))+'</td>';
              invoice += '    <td align="center">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              invoice += '    <td align="right">'+(o.Quote_Sell_Net_Price__c != null ? o.Quote_Sell_Net_Price__c : 0)+'</td>';
              invoice += '    <td align="right">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
              invoice += '    <td align="right">'+(o.Sell_Amount__c != null ? o.Sell_Amount__c : 0)+'</td>';
              
              
              invoice += '</tr>';
              
              if(o.Concept_1_Sell_Price__c != null || o.Concept_2_Sell_Price__c != null || o.Concept_3_Sell_Price__c != null || o.Concept_4_Sell_Price__c != null || o.Concept_5_Sell_Price__c != null)
              {
              	invoice += '<tr>';
              	invoice += ' 	<th colspan="12">Concepts Line '+o.Name+'</th>';	
              	invoice += '</tr>';
              }
              	
              if(o.Concept_1_Sell_Price__c != null && o.Concept_1_Sell_Price__c > 0) 
              {
              	invoice += '<tr>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+(o.Concept_1__c != null ? o.Concept_1__c : '' )+'</td>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              	invoice += '    <td align="right"colspan="3" style="background: #F3ECE7;">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
              	invoice += '    <td align="right" colspan="3" style="background: #F3ECE7;">'+(o.Concept_1_Sell_Price__c != null ? o.Concept_1_Sell_Price__c : 0).setScale(2) +'</td>';
              	invoice += '</tr>';	
              	contador_de_service_charges ++;
              }
              
              if(o.Concept_2_Sell_Price__c != null && o.Concept_2_Sell_Price__c > 0)
              {
              	
              	invoice += '<tr>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+(o.Concept_2__c != null ? o.Concept_2__c : '' )+'</td>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              	invoice += '    <td align="right"colspan="3" style="background: #F3ECE7;">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
              	invoice += '    <td align="right" colspan="3" style="background: #F3ECE7;">'+(o.Concept_2_Sell_Price__c != null ? o.Concept_2_Sell_Price__c : 0).setScale(2) +'</td>';
              	invoice += '</tr>';	
              	contador_de_service_charges ++;
              }
              
              if(o.Concept_3_Sell_Price__c != null && o.Concept_3_Sell_Price__c > 0)
              {
              	
              	invoice += '<tr>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+(o.Concept_3__c != null ? o.Concept_3__c : '' )+'</td>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              	invoice += '    <td align="right"colspan="3" style="background: #F3ECE7;">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
              	invoice += '    <td align="right" colspan="3" style="background: #F3ECE7;">'+(o.Concept_3_Sell_Price__c != null ? o.Concept_3_Sell_Price__c : 0).setScale(2) +'</td>';
              	invoice += '</tr>';	
              	contador_de_service_charges ++;
              }
              
              if(o.Concept_4_Sell_Price__c != null && o.Concept_4_Sell_Price__c > 0)
              {
              	
              	invoice += '<tr>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+(o.Concept_4__c != null ? o.Concept_4__c : '' )+'</td>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              	invoice += '    <td align="right"colspan="3" style="background: #F3ECE7;">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
              	invoice += '    <td align="right" colspan="3" style="background: #F3ECE7;">'+(o.Concept_4_Sell_Price__c != null ? o.Concept_4_Sell_Price__c : 0).setScale(2) +'</td>';
              	invoice += '</tr>';	
              	contador_de_service_charges ++;
              }
              
              if(o.Concept_5_Sell_Price__c != null && o.Concept_5_Sell_Price__c > 0)
              {
              	
              	invoice += '<tr>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+(o.Concept_5__c != null ? o.Concept_5__c : '' )+'</td>';
              	invoice += '    <td align="center" colspan="3" style="background: #F3ECE7;">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              	invoice += '    <td align="right"colspan="3" style="background: #F3ECE7;">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
              	invoice += '    <td align="right" colspan="3" style="background: #F3ECE7;">'+(o.Concept_5_Sell_Price__c != null ? o.Concept_5_Sell_Price__c : 0).setScale(2) +'</td>';
              	invoice += '</tr>';	
              	contador_de_service_charges ++;
              }
              
              if(o.Concept_1_Sell_Price__c != null || o.Concept_2_Sell_Price__c != null || o.Concept_3_Sell_Price__c != null || o.Concept_4_Sell_Price__c != null || o.Concept_5_Sell_Price__c != null)
              {
              	invoice += '<tr>';
              	invoice +='		<th colspan="12" style="    height: 0px;    padding-top: 0px;    margin-top: 0px;"></th>';
              	invoice += '</tr>';	
              }
              
              contador_de_service_charges ++;
            }
        
          //ÚLTIMA PÁGINA  
            invoice += '    <tr>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <td align="right" style="background-color: white;"></td>';
            invoice += '      <th>Total</th>';
            invoice += '      <td align="right">'+record.Total_Services_Sell_Amount__c+'</td>';
            invoice += '    </tr>';
            invoice += '  </table>';
            invoice += '</div>';  
             
             
           invoice += '  </table>';  
           invoice += '</div>';
    }

    if(contador_de_service_charges >= 14 && contador_paginas > 1 ||contador_de_service_charges >=3 && contador_paginas == 0) 
    {
      invoice +='<div id="top" style="page-break-before:always;">';
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
        invoice +='  </div>';
    }
    
    invoice += '<div id="bot">';
    
    invoice += '<div id="bot_left" style="height: 140px;">';
    invoice += '  <span class="title" style="font-weight: bold;">OTHER COMMENTS</span>';
    invoice += '  <hr/>';
  
    invoice += '</div>';
    invoice += '<div id="bot_right" style="height: 140px;">';
    invoice += '  <span class="title" style="font-weight: bold;">GENERAL CONDITIONS</span>';//---leer de un email template o algo 
    invoice += '  <hr/>';
    
    invoice += '  <p class="observations" style="text-align: left;">'+observaciones+'</p>';
    invoice += '</div>';
    
    invoice += '<div id="bot_left" >';
    invoice += '  <span class="title" style="font-weight: bold;">SIGNATURE, NAME OF PURCHASE EXECUTIVE, COMPANY STAMP, DATE</span>';
    invoice += '  <hr/>';


    invoice += '</div>';
    invoice += '<div id="bot_right" >';
    invoice += '  <span class="title" style="font-weight: bold;">COMPANY SIGNATURE STATUS</span>';
    invoice += '  <hr style="    margin-top: 20px;"/>';
    
    invoice += '  <p class="observations" style="text-align: left;">'+observaciones+'</p>';
    invoice += '</div>';
    
    
    invoice += '</div>';
    cont++;
    
   
     
    }
}