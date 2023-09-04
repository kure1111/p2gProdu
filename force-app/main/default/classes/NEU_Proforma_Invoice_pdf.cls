public with sharing class NEU_Proforma_Invoice_pdf{

    public Shipment__c record;
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
            
    public NEU_Proforma_Invoice_pdf(ApexPages.StandardController stdController) {

        con = stdController;
        
      
         try { 
        record = Database.query('select Id, Name,'+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Account_for__c,          Shipment_Status__c, SUM_Buy_Origin_Amount_number__c, Total_Services_Sell_Amount__c ,  Incoterm_Place__c,SUM_Destination_Amount_number__c,          Contact__r.Phone, Account_for__r.Phone, Account_for__r.BillingStreet,   Account_for__r.BillingCity,          Purchase_Incoterm__c,Total_Volume_m3__c, Total_Weight_Kg__c, Account_for__r.BillingState, Account_for__r.BillingCountry           ,Account_for__r.Name, Supplier_Account__c, Supplier_Account__r.Name, Contact__r.Name,           SUM_Sell_Origin_Amount__c from Shipment__c where id = \''+ con.getRecord().id+'\'');
        } catch( Exception ee) { 
            record = new Shipment__c();//Approved_Date__c, Max_Deliveries__c, Contract_Duration_months__c, Account_for_Shipping_Address__c, Account_for_Billing_Address__c
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
    List<Shipment_Line__c> sqoline = new List<Shipment_Line__c>();
    string query_string_quote_item_line = '';
    query_string_quote_item_line +='select Id, Name, Item_Name__c, Item_Name__r.Name,'; 
    query_string_quote_item_line +='Unit_Destination_Price__c, Item_Name__r.Sourcing_Item_Code__c,Unit_Origin_Sell_Price__c,Sell_Origin_Amount__c ,Destination_Amount_header_currency__c ,Conversion_Rate_to_Currency_Header__c,Packaging_Volume_m3__c ,Total_Weight_Items_Packaging_Kg__c ,Packaging_Length_cm__c , Packaging_Width_cm__c ,';
    query_string_quote_item_line +='Packaging_Quantity__c , Item_Units_x_Packaging__c , Packaging_Height_cm__c , Shipping_Weight_Kg__c, Packaging_Gross_Weight_kg__c , Item_Name__r.Url_Photo_1__c,Expense_Concept__c,Expense_Amount__c ,Shipping_Volume_m3__c,';
    if(UserInfo.isMultiCurrencyOrganization()== true)
        query_string_quote_item_line +='                                                        CurrencyIsoCode,'; 
    query_string_quote_item_line +='Item_Name__r.Item_Description__c, Destination_Amount__c, Unit_of_measure__c,';
    query_string_quote_item_line +='Units_Shipped__c, Sell_Origin_Amount_header_currency__c from Shipment_Line__c where Shipment__c = \''+ record.Id+'\' order by Name';
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
    
    //invoice +='  <h1></h1>';
    invoice +='  <h1 class="title_import_export_details" style="    font-size: 19px !important;">PROFORMA INVOICE</h1>';
    
    
    invoice +='<div id="mid_left" style="width: 50%;">';
    invoice +='  <ul class="customer_data">';
    invoice +='    <li><span class="customer_data_title">SHIPMENT ORDER Nº:</span>&nbsp;<span>'+record.Name+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">INCOTERMS:</span>&nbsp;<span>'+(record.Purchase_Incoterm__c != null ? record.Purchase_Incoterm__c : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">INCOTERMS PLACE:</span>&nbsp;<span>'+(record.Incoterm_Place__c != null ? record.Incoterm_Place__c : '') +'</span></li>';
    invoice +='    <li><span class="customer_data_title">PAYMENT TERMS:</span>&nbsp;<span></span></li>';
    invoice +='    <li><span class="customer_data_title">IMPORT TAX (%):</span>&nbsp;<span></span></li>';
   // invoice +='    <li><span class="invoice_data_title">HS CODE:</span>&nbsp;<span></span></li>';
    invoice +='  </ul>';
    invoice +='</div>';
    invoice +='<div id="mid_right" style="width: 50%;">';
    invoice +='  <ul class="invoice_data" style="float: left;    margin-left: 105px;">';
    invoice +='    <li><span class="invoice_data_title">DATE:</span>&nbsp;<span>'+fecha+'</span></li>';
    //invoice +='    <li><span class="invoice_data_title">CUSTOMER DELIVERY DATE:</span>&nbsp;<span></span></li>';
    invoice +='    <li><span class="customer_data_title">SUPPLIER:</span>&nbsp;<span>'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</span></li>';
   // invoice +='    <li><span class="invoice_data_title">LEAD TIME PER CALL OFF FROM SAMPLE APPROVAL:</span>&nbsp;<span></span></li>';
    /*if(record.Contract_Duration_months__c != null)
        invoice +='    <li><span class="invoice_data_title">CONTRACT PERIOD:</span>&nbsp;<span>'+record.Contract_Duration_months__c+'</span></li>';
     else
       invoice +='    <li><span class="invoice_data_title">CONTRACT PERIOD:</span>&nbsp;<span></span></li>';*/
  //  invoice +='    <li><span class="invoice_data_title">DELIVERIES:</span>&nbsp;<span>'+(record.Max_Deliveries__c != null ? record.Max_Deliveries__c : 1)+'</span></li>';
    
    
    //------------------campo nuevo
    invoice +='  </ul>';
   
    invoice +='</div>';
    invoice +=datoscuenta;
    invoice +='  <h1 class="title_import_export_details">ITEM GENERAL INFORMATION</h1>';
    invoice +='<hr/>';
    invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" ">';
    invoice += '<tr>';
    invoice += '  <th align="center" style="text-align: center;">IE </br> LINE</th>';
    invoice += '  <th align="center" style="text-align: center;">ITEM CODE</th>';
    invoice += '  <th align="center" style="width: 20%; text-align: center;">ITEM, DESCRIPTION</th>';
    invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
    invoice += '  <th align="center" style="text-align: center;">CARTONS</th>';
    invoice += '  <th align="center" style="text-align: center;">UNITS</th>';
    invoice += '  <th align="center" style="text-align: center;">UNIT PRICE</th>';
    invoice += '  <th align="center" style="text-align: center;">SUBTOTAL</th>';
    invoice += '  <th align="center" style="text-align: center;">CURR.</th>';
    invoice += '  <th align="center" style="text-align: center;"> RATE </br> ('+NEU_CurrencyUtils.getCurrencyIsoCode(record)+')</th>';//EXCHANGE 
    invoice += '  <th align="center" style="text-align: center;">PHOTO</th>';
    invoice += '</tr>';
    integer contador_paginas = 0;
    if(sqoline.size()>0)
    for(Shipment_Line__c o : sqoline)
      {
      if((contador_items == 4 && contador_paginas == 0) || (contador_items == 9 && contador_paginas > 0) || Test.isRunningTest())
      {
        contador_paginas ++;
        invoice += '  </table>';
        invoice += '</div>';
        invoice +='<div id="top" style="page-break-before:always;">';
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
        invoice +='  </div>';
        invoice +='<div id="mid">';
        invoice +='  <h1 class="title_import_export_details">ITEM GENERAL INFORMATION</h1>';
        invoice +='<hr/>';
        invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
        invoice += '<tr>';
        invoice += '  <th align="center" style="text-align: center;">IE</br> LINE</th>';
        invoice += '  <th align="center" style="text-align: center;">ITEM CODE</th>';
        invoice += '  <th align="center" style="width: 20%;text-align: center;">ITEM, DESCRIPTION</th>';
        invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
        invoice += '  <th align="center" style="text-align: center;">CARTONS</th>';
        invoice += '  <th align="center" style="text-align: center;">UNITS</th>';
        invoice += '  <th align="center" style="text-align: center;">UNIT PRICE</th>';
        invoice += '  <th align="center" style=" text-align: center;">SUBTOTAL</th>';
        invoice += '  <th align="center" style="text-align: center;">CURR.</th>';
        invoice += '  <th align="center" style="text-align: center;"> RATE </br> ('+NEU_CurrencyUtils.getCurrencyIsoCode(record)+')</th>';//EXCHANGE
        invoice += '  <th align="center" style="text-align: center;">PHOTO</th>';
        invoice += '</tr>';
        contador_items =0;
      }
      invoice += '  <tr>';
      invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
      invoice += '    <td align="center">'+o.Item_Name__r.Sourcing_Item_Code__c+' | '+o.Item_Name__r.Sourcing_Item_Code__c+'</td>';//-----falta el del cliente ese es de proveedor
      invoice += '    <td align="center">'+o.Item_Name__r.Name+' '+(o.Item_Name__r.Item_Description__c != null ? '</br>, '+o.Item_Name__r.Item_Description__c : '')+'</td>';
      invoice += '    <td align="right">'+(o.Item_Units_x_Packaging__c != null  ? o.Item_Units_x_Packaging__c : 0)+'</td>';
      invoice += '    <td align="right">'+(o.Packaging_Quantity__c != null ? o.Packaging_Quantity__c : 0 )+'</td>';
      invoice += '    <td align="right">'+o.Units_Shipped__c+'</td>';
      if(ApexPages.currentPage().getParameters().get('services_charges') != 'true')
        invoice += '    <td align="right">'+(o.Unit_Destination_Price__c != null ? (o.Unit_Destination_Price__c - (o.Expense_Amount__c != null ? o.Expense_Amount__c/o.Units_Shipped__c: 0)).setScale(4): 0)+'</td>';
      else
        invoice += '    <td align="right">'+(o.Unit_Origin_Sell_Price__c != null ? (o.Unit_Origin_Sell_Price__c).setScale(2): 0)+'</td>';
      if(ApexPages.currentPage().getParameters().get('services_charges') != 'true')
        invoice += '    <td align="right">'+(o.Destination_Amount_header_currency__c != null ? o.Destination_Amount_header_currency__c - (o.Expense_Amount__c != null ? o.Expense_Amount__c : 0) : 0)+'</td>';
      else
        invoice += '    <td align="right">'+(o.Sell_Origin_Amount__c != null ? o.Sell_Origin_Amount__c: 0)+'</td>';
      invoice += '    <td align="right">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
      invoice += '    <td align="right">'+(o.Conversion_Rate_to_Currency_Header__c != null ? o.Conversion_Rate_to_Currency_Header__c : 1 )+'</td>';
      invoice += '    <td align="right">'+(o.Item_Name__r.Url_Photo_1__c != null ? '<img src="'+o.Item_Name__r.Url_Photo_1__c+'" style="float: left;    width: 50px;"/>' : '<span style="float: left; width: 50px; height:50px;"></span>')+'</td>';
      invoice += '  </tr>';
    
  
      contador_items ++;
      if(o.Destination_Amount_header_currency__c!= null)
          totalamount +=o.Destination_Amount_header_currency__c;
      else
          totalamount +=o.Sell_Origin_Amount_header_currency__c;
      }
      
      //incluir lineas de gastos adicionales
      if(sqoline.size()>0)
       for(Shipment_Line__c o : sqoline)
      {
        if(NEU_Utils.safeDecimal(o.Expense_Amount__c) != 0)
        {
           if((contador_items == 5 && contador_paginas == 0) || (contador_items == 9 && contador_paginas > 0) || Test.isRunningTest())
           {
            contador_paginas ++;
            invoice += '  </table>';
            invoice += '</div>';
            invoice +='<div id="top" style="page-break-before:always;">';
            invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
            invoice +='  </div>';
            invoice +='<div id="mid">';
            invoice +='  <h1 class="title_import_export_details">ITEM GENERAL INFORMATION</h1>';
            invoice +='<hr/>';
            invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
            invoice += '<tr>';
            invoice += '  <th align="center" style="text-align: center;">IE</br> LINE</th>';
            invoice += '  <th align="center" style="text-align: center;">ITEM CODE</th>';
            invoice += '  <th align="center" style="width: 20%;text-align: center;">ITEM, DESCRIPTION</th>';
            invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
            invoice += '  <th align="center" style="text-align: center;">CARTONS</th>';
            invoice += '  <th align="center" style="text-align: center;">UNITS</th>';
            invoice += '  <th align="center" style="text-align: center;">UNIT PRICE</th>';
            invoice += '  <th align="center" style=" text-align: center;">SUBTOTAL</th>';
            invoice += '  <th align="center" style="text-align: center;">CURR.</th>';
            invoice += '  <th align="center" style="text-align: center;"> RATE </br> ('+NEU_CurrencyUtils.getCurrencyIsoCode(record)+')</th>';//EXCHANGE
            invoice += '  <th align="center" style="text-align: center;">PHOTO</th>';
            invoice += '</tr>';
           
           }
           contador_items ++;
           invoice += '  <tr>';
          invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
          invoice += '    <td align="center"></td>';
          invoice += '    <td align="center">'+(o.Expense_Concept__c != null ? o.Expense_Concept__c :'')+'</td>';
          invoice += '    <td align="center"></td>';
          invoice += '    <td align="center"></td>';
          invoice += '    <td align="right">1</td>';
          invoice += '    <td align="right">'+(o.Expense_Amount__c != null ? o.Expense_Amount__c : 0)+'</td>';//----- o el origen
          invoice += '    <td align="right">'+(o.Expense_Amount__c != null ? o.Expense_Amount__c : 0)+'</td>';
          invoice += '    <td align="right">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
          invoice += '    <td align="right">'+(o.Conversion_Rate_to_Currency_Header__c != null ? o.Conversion_Rate_to_Currency_Header__c : 1)+'</td>';
          invoice += '    <td align="right"></td>';
          invoice += '  </tr>';
        }
      }

     
      //----
    
    //ÚLTIMA PÁGINA  
    invoice += '    <tr>';
    invoice += '      <th colspan="7">Total Product Value</th>';
    if(ApexPages.currentPage().getParameters().get('services_charges') != 'true')
      invoice += '      <td align="right">'+record.SUM_Destination_Amount_number__c +'</td>';
    else
      invoice += '      <td align="right">'+record.SUM_Sell_Origin_Amount__c +'</td>';
    invoice += '      <td align="right">'+NEU_CurrencyUtils.getCurrencyIsoCode(record)+'</td>';
    invoice += '    </tr>';
    invoice += '  </table>';
    invoice += '</div>';
    
    
    
         //ITEM SPECIFIC INFORMATION
     if((contador_paginas == 0) || (contador_items == 9 && contador_paginas > 0))
     {
       invoice +='<div id="top" style="page-break-before:always;">';//
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
        invoice +='  </div>';
     }
     invoice +='<div id="mid">';
     invoice +='  <h1 class="title_import_export_details">ITEM SPECIFIC INFORMATION</h1>';
    invoice +='<hr/>';
    invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';//style="height: 400px;"
    invoice += '<tr>';
    invoice += '  <th align="center" style="text-align: center;">LINE</th>';
    invoice += '  <th align="center" style="text-align: center;">ITEM CODE</th>';
    invoice += '  <th align="center" style="text-align: center;">ITEM, DIMENSIONS,</br> MATERIAL, </br> WEIGHT, </br>COLOURS</th>';
    invoice += '  <th align="center" style="text-align: center;">LOGO: TYPE, COLOR.,</br> POS., DESCRIP., </br>DIMENS.</th>';
    invoice += '  <th align="center" style="text-align: center;">PACKAGING</th>';
    invoice += '  <th align="center" style="text-align: center;">SPECIAL </br>PACKAGING </br>REQUIREMENTS</th>'; 
    invoice += '  <th align="center" style="text-align: center;">REQUIRED </br>CERTIFICATIONS</th>';
    invoice += '</tr>';
    integer contador_items_especificos = 0;
    
    if(sqoline.size()>0)
      for(Shipment_Line__c o : sqoline)
        {
          if((contador_items_especificos == 11 && contador_paginas > 0 && contador_items == 0) || (contador_items > 0 && (contador_items_especificos + contador_items) == 7 && contador_paginas > 0) || Test.isRunningTest())
          {
            contador_paginas ++;
            invoice += '  </table>';
            invoice += '</div>';
            invoice +='<div id="top" style="page-break-before:always;">';//
            invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
            invoice +='  </div>';
            invoice +='<div id="mid">';
            invoice +='  <h1 class="title_import_export_details">ITEM SPECIFIC INFORMATION</h1>';
            invoice +='<hr/>';
            invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
            invoice += '<tr>';
            invoice += '  <th align="center" style="text-align: center;">LINE</th>';
            invoice += '  <th align="center" style="text-align: center;">ITEM CODE</th>';  
            invoice += '  <th align="center" style="text-align: center;">ITEM, DIMENSIONS,</br> MATERIAL, </br> WEIGHT, </br>COLOURS</th>';
            invoice += '  <th align="center" style="text-align: center;">LOGO: TYPE, COLOR.,</br> POS., DESCRIP., </br>DIMENS.</th>';
            invoice += '  <th align="center" style="text-align: center;">PACKAGING</th>';
            invoice += '  <th align="center" style="text-align: center;">SPECIAL </br>PACKAGING </br>REQUIREMENTS</th>'; 
            invoice += '  <th align="center" style="text-align: center;">REQUIRED </br>CERTIFICATIONS</th>';
            invoice += '</tr>';
            contador_items =0;
            contador_items_especificos =0;
          }
            invoice += '  <tr>';
          invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
          invoice += '    <td align="center">'+o.Item_Name__r.Sourcing_Item_Code__c+' | '+o.Item_Name__r.Sourcing_Item_Code__c+'</td>';
          invoice += '    <td align="right">'+o.Item_Name__r.Name+', '+o.Packaging_Volume_m3__c+' m3, '+o.Total_Weight_Items_Packaging_Kg__c+'Kg</td>';
          invoice += '    <td align="center"></td>';//------------rellenar estos
          invoice += '    <td align="center"></td>';
          invoice += '    <td align="center"></td>';
          invoice += '    <td align="center"></td>';//'+(o.Item_Name__r.Item_Description__c != null ? o.Item_Name__r.Item_Description__c : '')+'
          invoice += '</tr>';
            contador_items_especificos ++;
        }
      
    
    invoice += '  </table>';
    invoice += '</div>';
     //---------------------------PACKING INFORMATION
     if(contador_items_especificos == 11 && contador_paginas > 0 && contador_items == 0)
     {
        invoice +='<div id="top" style="page-break-before:always;">';//
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
        invoice +='  </div>';
     }
        invoice +='<div id="mid">';
        invoice +='  <h1 class="title_import_export_details">PACKING INFORMATION</h1>';
        invoice +='<hr/>';
        invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';//style="height: 400px;"
        invoice += '<tr>';
        invoice += '  <th align="center" style="text-align: center;">LINE</th>';
        invoice += '  <th align="center" style="text-align: center;">ITEM CODE</th>';
        invoice += '  <th align="center" style="text-align: center;">ITEM</th>'; 
        invoice += '  <th align="center" style="text-align: center;">TOTAL </br> UNITS</th>'; 
        invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
        invoice += '  <th align="center" style="text-align: center;">NUMBER </br>OF </br>CARTONS</th>';
        invoice += '  <th align="center" style="text-align: center;">CTN </br>DIMENSIONS</th>';
        invoice += '  <th align="center" style="text-align: center;">CTN </br>VOLUME</th>';
        invoice += '  <th align="center" style="text-align: center;">VOLUME </br>(CBM)</th>';  
        invoice += '  <th align="center" style="text-align: center;">NW/CARTON </br>(KG)</th>';
        invoice += '  <th align="center" style="text-align: center;">GW/CARTON </br>(KG)</th>';
        invoice += '  <th align="center" style="text-align: center;">TOTAL GW </br>(KG)</th>'; 
        invoice += '</tr>';
    integer contador_items_packaging = 0;
    if(sqoline.size()>0)
      for(Shipment_Line__c o : sqoline)
        {
          if((contador_items_packaging == 14 && contador_paginas > 1 && contador_items_especificos == 0) || (contador_items_especificos > 0 && (contador_items_packaging + contador_items_especificos) == 7 && contador_paginas > 1) || Test.isRunningTest())
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
            invoice += '  <th align="center" style="text-align: center;">ITEM CODE</th>';
            invoice += '  <th align="center" style="text-align: center;">ITEM</th>';  
            invoice += '  <th align="center" style="text-align: center;">TOTAL </br>UNITS</th>'; 
            invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
            invoice += '  <th align="center" style="text-align: center;"> NUMBER </br>OF </br>CARTONS</th>';
            invoice += '  <th align="center" style="text-align: center;">CTN </br>DIMENSIONS</th>';
            invoice += '  <th align="center" style="text-align: center;">CTN </br>VOLUME</th>';
            invoice += '  <th align="center" style="text-align: center;">VOLUME </br>(CBM)</th>';  
            invoice += '  <th align="center" style="text-align: center;">NW/CARTON </br>(KG)</th>';
            invoice += '  <th align="center" style="text-align: center;">GW/CARTON </br>(KG)</th>';
            invoice += '  <th align="center" style="text-align: center;">TOTAL GW </br>(KG)</th>'; 
          invoice += '</tr>';
            contador_items_especificos =0;
            contador_items_packaging = 0;
          }
          
            invoice += '  <tr>';
          invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
          invoice += '    <td align="center">'+o.Item_Name__r.Sourcing_Item_Code__c+'</td>';
          invoice += '    <td align="center">'+o.Item_Name__r.Name+'</td>';
          invoice += '    <td align="right">'+(o.Units_Shipped__c!= null ? o.Units_Shipped__c : 0)+'</td>';
          invoice += '    <td align="right">'+(o.Item_Units_x_Packaging__c != null ? o.Item_Units_x_Packaging__c : 0)+'</td>';
          invoice += '    <td align="right">'+(o.Packaging_Quantity__c != null ? o.Packaging_Quantity__c : 0)+'</td>';
          invoice += '    <td align="right">'+(o.Packaging_Length_cm__c != null ? o.Packaging_Length_cm__c : 0)+'*'+(o.Packaging_Width_cm__c != null ? o.Packaging_Width_cm__c : 0)+'*'+(o.Packaging_Height_cm__c != null ? o.Packaging_Height_cm__c : 0)+'</td>';
          invoice += '    <td align="right">'+(o.Packaging_Volume_m3__c != null ? o.Packaging_Volume_m3__c : 0)+'</td>';
          invoice += '    <td align="right">'+(o.Shipping_Volume_m3__c != null ? o.Shipping_Volume_m3__c : 0)+'</td>';
          invoice += '    <td align="center"></td>';//--falta rellenar esto
          invoice += '    <td align="right">'+(o.Packaging_Gross_Weight_kg__c != null ? o.Packaging_Gross_Weight_kg__c : 0)+'</td>';
          invoice += '    <td align="right">'+(o.Shipping_Weight_Kg__c != null ? o.Shipping_Weight_Kg__c : 0)+'</td>';
          invoice += '</tr>';
            contador_items_packaging ++;
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
    invoice += '      <th>Total</th>';
    invoice += '      <td align="right">'+record.Total_Volume_m3__c+'</td>';
    invoice += '      <td align="right"></td>';
    invoice += '      <th>Total</th>';
    invoice += '      <td align="right">'+record.Total_Weight_Kg__c+'</td>';
    invoice += '    </tr>';
    invoice += '  </table>';
    invoice += '</div>';  
     
     
   invoice += '  </table>';  
    invoice += '</div>';
    //------------------------------- 
    //-------------------------
    integer contador_de_service_charges = 0;
    //tabla de service charges
    List<Shipment_Fee_Line__c> listado_de_lineas_de_fees = new List<Shipment_Fee_Line__c>();
    listado_de_lineas_de_fees = [select Id, Name, Service_Rate_Name__c, Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Route__r.Name, Rate_Type__c, Sell_Rate__c, Units__c, Sell_Amount__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Container_Type__r.Name, Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Account_for__r.Name, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Carrier_Account__r.Name from Shipment_Fee_Line__c where Shipment__c =: record.Id];
  if(ApexPages.currentPage().getParameters().get('services_charges') == 'true')
  {
     if(contador_items_packaging == 11 && contador_paginas > 0 && contador_items == 0)
       {
          invoice +='<div id="top" style="page-break-before:always;">';//
          invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
          invoice +='  </div>';
       }
       
         invoice +='<div id="mid">';
          invoice +='  <h1 class="title_import_export_details">SHIPMENT SERVICE LINES</h1>';
          invoice +='<hr/>';
          invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
          invoice += '<tr>';
          invoice += '  <th align="center" style="text-align: center;">LINE</th>';
          invoice += '  <th align="center" style="text-align: center;">SERVICE RATE NAME</th>';
          invoice += '  <th align="center" style="text-align: center;">ROUTE</th>'; 
          invoice += '  <th align="center" style="text-align: center;">RATE TYPE</th>'; 
          invoice += '  <th align="center" style="text-align: center;">CONTAINER TYPE</th>';
          invoice += '  <th align="center" style="text-align: center;">ACCOUNT FOR</th>';
          invoice += '  <th align="center" style="text-align: center;">CARRIER ACCOUNT</th>';
          invoice += '  <th align="center" style="text-align: center;">CURR.</th>';
          invoice += '  <th align="center" style="text-align: center;">SELL RATE</th>';
          invoice += '  <th align="center" style="text-align: center;">UNITS</th>';  
          invoice += '  <th align="center" style="text-align: center;">SELL AMOUNT</th>'; 
          invoice += '</tr>';
          
          //------------------
          //integer contador_items_packaging = 0;
        if(sqoline.size()>0)
          for(Shipment_Fee_Line__c o : listado_de_lineas_de_fees)
            {
              if((contador_de_service_charges == 14 && contador_paginas > 1 && contador_items_packaging == 0) || (contador_items_packaging > 0 && (contador_de_service_charges + contador_items_packaging) == 7 && contador_paginas > 1) || Test.isRunningTest())
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
              invoice += '  <th align="center" style="text-align: center;">SERVICE RATE NAME</th>';
              invoice += '  <th align="center" style="text-align: center;">ROUTE</th>'; 
              invoice += '  <th align="center" style="text-align: center;">RATE TYPE</th>'; 
              
              invoice += '  <th align="center" style="text-align: center;">CONTAINER TYPE</th>';
              invoice += '  <th align="center" style="text-align: center;">ACCOUNT FOR</th>';
              invoice += '  <th align="center" style="text-align: center;">CARRIER ACCOUNT</th>';
              invoice += '  <th align="center" style="text-align: center;">CURR.</th>';
              
              invoice += '  <th align="center" style="text-align: center;">SELL RATE</th>';
              invoice += '  <th align="center" style="text-align: center;">UNITS</th>';  
              invoice += '  <th align="center" style="text-align: center;">SELL AMOUNT</th>'; 
                invoice += '</tr>';
                contador_items_packaging =0;
                contador_de_service_charges = 0;
              }
              
              invoice += '  <tr>';
              invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
              invoice += '    <td align="center">'+o.Service_Rate_Name__r.Name+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Route__c != null ? o.Service_Rate_Name__r.Route__r.Name : '')+'</td>';
              invoice += '    <td align="center">'+(o.Rate_Type__c != null ? o.Rate_Type__c : '')+'</td>';
              
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Container_Type__c != null ? o.Service_Rate_Name__r.Container_Type__r.Name : '')+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Account_for__c != null ? o.Service_Rate_Name__r.Account_for__r.Name : '')+'</td>';
              invoice += '    <td align="center">'+(o.Service_Rate_Name__r.Carrier_Account__c != null ? o.Service_Rate_Name__r.Carrier_Account__r.Name : '')+'</td>';
              
               invoice += '    <td align="center">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              
              invoice += '    <td align="right">'+(o.Sell_Rate__c != null ? o.Sell_Rate__c : 0)+'</td>';
              invoice += '    <td align="right">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
              invoice += '    <td align="right">'+(o.Sell_Amount__c != null ? o.Sell_Amount__c : 0)+'</td>';
              invoice += '</tr>';
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
        invoice += '      <th>Total</th>';
        invoice += '      <td align="right">'+record.Total_Services_Sell_Amount__c+'</td>';
        invoice += '    </tr>';
        invoice += '  </table>';
        invoice += '</div>';  
         
         
       invoice += '  </table>';  
       invoice += '</div>';
  }
  //---------------------------------------------
    //---------------------------------------
    if(ApexPages.currentPage().getParameters().get('services_charges') != 'true')
    {
      if(contador_items_packaging == 14 && contador_paginas > 1 && contador_items_especificos == 0) 
      {
        invoice +='<div id="top" style="page-break-before:always;">';
          invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
          invoice +='  </div>';
      }
    }
    else
    {
      if(contador_de_service_charges == 14 && contador_paginas > 1 && contador_items_packaging == 0) 
      {
        invoice +='<div id="top" style="page-break-before:always;">';
          invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
          invoice +='  </div>';
      }
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
    
    invoice += '<div id="bot_left" >';//style="height: 140px;"
    invoice += '  <span class="title" style="font-weight: bold;">SIGNATURE, NAME OF PURCHASE EXECUTIVE, COMPANY STAMP, DATE</span>';
    invoice += '  <hr/>';


    invoice += '</div>';
    invoice += '<div id="bot_right" >';//style="height: 140px;"
    invoice += '  <span class="title" style="font-weight: bold;">COMPANY SIGNATURE STATUS</span>';
    invoice += '  <hr style="    margin-top: 20px;"/>';
    
    invoice += '  <p class="observations" style="text-align: left;">'+observaciones+'</p>';
    invoice += '</div>';
    
    
    invoice += '</div>';
    cont++;
    
   
     
    }
}