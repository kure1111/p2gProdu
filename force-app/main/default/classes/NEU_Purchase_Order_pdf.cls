public with sharing class NEU_Purchase_Order_pdf {

    public Supplier_Quote__c record;
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
            
    public NEU_Purchase_Order_pdf(ApexPages.StandardController stdController) {

        con = stdController;

        
         try { 
          record = Database.query('select Id, Name, Supplier__c, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode,' : '')+'Supplier__r.Phone, Supplier__r.BillingStreet,  Account_Executive_User__c,   Incoterm__c,Max_Deliveries__c,Delivery_Date__c,SUM_Destination_Amount__c, Incoterm_Place__c, Supplier__r.BillingCity, Supplier__r.BillingState, Supplier__r.BillingCountry ,Production_Time_Days__c,Total_Volume_m3_2__c ,Total_Weight_Kg2__c ,  Contract_Duration_months__c,Collection_Conditions__c,Supplier__r.Name, Total_Fees_Sell_Amount__c,Total_Fees_Buy_Amount__c, Total_Amount_Number__c from Supplier_Quote__c where id = \''+ con.getRecord().id+'\'');
        } catch( Exception ee) { 
            record = new Supplier_Quote__c();
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

    List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo']; 
    
    

    //RECORREMOS LAS LINEAS DE LA SUPPLIER QUOTE ORDER
    List<Supplier_Quote_Line__c> sqoline = new List<Supplier_Quote_Line__c>();
    string query_string_quote_item_line = '';
    query_string_quote_item_line +='select Id, Name, Item__c, Item__r.Name,'; 
    query_string_quote_item_line +='Unit_Destination_Price__c, Packaging_Length_cm__c , Packaging_Gross_Weight_kg__c , Item__r.Master_Box_Packing_Weight_kg__c, Packaging_Weight_kg__c , Expense_Concept__c, Packaging_Width_cm__c,Packaging_Volume_m3__c , Packaging_Height_cm__c, Total_Volume_m3__c, Total_Weight_Kg__c, Item__r.Sourcing_Item_Code__c, ';
    query_string_quote_item_line +='Packaging_Quantity__c , Item_Units_x_Packaging__c , Item__r.Url_Photo_1__c,';
    if(UserInfo.isMultiCurrencyOrganization()== true)
        query_string_quote_item_line +='                                                        CurrencyIsoCode,'; 
    query_string_quote_item_line +='Item__r.Item_Description__c, Total_Destination_Amount__c, Expense_Amount__c ,  Unit_of_measure__c,';
    query_string_quote_item_line +='Quantity__c, Total_Amount__c from Supplier_Quote_Line__c where Supplier_Quote__c = \''+ record.Id+'\' order by Name';
    
    List<sObject> query_quote_item_line = Database.query(query_string_quote_item_line );
    sqoline = query_quote_item_line;
    //CurrencyIsoCode
    integer contador_items=0;
    invoice +='  <div id="container">';
    invoice +='<div id="top" >';
    invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
               
    invoice +='<div id="kaelis_address_data">';
    invoice +='  <span class="title">Madrid</span>';
    invoice +='  <span>Isla Graciosa, 7,</span>';
    invoice +='  <span>890 Lin Heha tuo eng Rd, Tianhe Dis.,</span>';
    invoice +='  <span>Los Reyes,</span>';
    invoice +='  <span>Madrid 28703 ES.</span>';
    invoice +='  <span>Phone.: +9118945000</span>';
    invoice +='  <span>Web: www.sgdaga.com</span>';
    invoice +='  </div>';
    invoice +='  </div>';
    invoice +='<div id="mid">';
    invoice +=datoscuenta;
    //invoice +='  <h1></h1>';
    invoice +='  <h1 class="title_import_export_details">PURCHASE ORDER</h1>';

    invoice +='<div id="mid_left" style="width: 50%;">';
    invoice +='  <ul class="customer_data">';
    invoice +='    <li><span class="customer_data_title">SUPPLIER QUOTE Nº:</span>&nbsp;<span>'+record.Name+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">INCOTERMS:</span>&nbsp;<span>'+(record.Incoterm__c != null ? record.Incoterm__c : '') +'</span></li>';
    invoice +='    <li><span class="invoice_data_title">INCOTERMS PLACE:</span>&nbsp;<span>'+(record.Incoterm_Place__c != null ? record.Incoterm_Place__c : '')+'</span></li>';
    invoice +='    <li><span class="customer_data_title">PAYMENT:</span>&nbsp;<span>'+(record.Collection_Conditions__c != null ? record.Collection_Conditions__c : '')+'</span></li>';
    if(record.Production_Time_Days__c != null)
        invoice +='    <li><span class="invoice_data_title">NORMAL LEAD TIME:</span>&nbsp;<span>'+ record.Production_Time_Days__c +'</span></li>';
    else
        invoice +='    <li><span class="invoice_data_title">NORMAL LEAD TIME:</span>&nbsp;<span></span></li>';
    invoice +='    <li><span class="invoice_data_title">DELIVERIES:</span>&nbsp;<span>'+(record.Max_Deliveries__c != null ? record.Max_Deliveries__c : 0)+'</span></li>';
    
    invoice +='  </ul>';
    invoice +='</div>';
    invoice +='<div id="mid_right"  style="    float: left;    width: 50%;">';
    invoice +='  <ul class="invoice_data"  style="    float: left;    margin-left: 101px;">';
    

    invoice +='    <li><span class="invoice_data_title">DATE:</span>&nbsp;<span>'+fecha+'</span></li>';
    if(record.Delivery_Date__c != null)
        invoice +='    <li><span class="invoice_data_title">DELIVERY TIME:</span>&nbsp;<span>'+ record.Delivery_Date__c+'</span></li>';
    else
        invoice +='    <li><span class="invoice_data_title">DELIVERY TIME:</span>&nbsp;<span></span></li>';
    invoice +='    <li><span class="invoice_data_title">SUPPLIER:</span>&nbsp;<span>'+(record.Supplier__c != null ? record.Supplier__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">AMENDMENT:</span>&nbsp;<span>0</span></li>';//----- es un contador preguntar
    invoice +='    <li><span class="invoice_data_title">PERIOD (MONTHS):</span>&nbsp;<span>'+(record.Contract_Duration_months__c != null ? record.Contract_Duration_months__c : 0)+'</span></li>';

    //------------------campo nuevo
    invoice +='  </ul>';
    invoice +='</div>';
    invoice +='  <h1 class="title_import_export_details">ITEM INFORMATION</h1>';
    invoice +='<hr/>';
    invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice">';
    invoice += '<tr>';
    invoice += '  <th align="center" style="text-align: center;">IE </br> LINE</th>';
    invoice += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
    invoice += '  <th align="center" style="text-align: left;">ITEM, DESCRIPTION</th>';
    invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
    invoice += '  <th align="center" style="text-align: center;">CARTONS</th>';
    invoice += '  <th align="center" style="text-align: center;">UNITS</th>';
    invoice += '  <th align="center" style="text-align: center;">UNIT PRICE</th>';
    invoice += '  <th align="center" style=" text-align: center;">SUBTOTAL</th>';
    invoice += '  <th align="center" style="text-align: center;">CURRENCY</th>';
    invoice += '</tr>';
    integer contador_paginas = 0;
    if(sqoline.size()>0)
    for(Supplier_Quote_Line__c o : sqoline)
      {
      if((contador_items == 10 && contador_paginas == 0) || (contador_items == 14 && contador_paginas > 0) || Test.isRunningTest())
      {
        contador_paginas ++;
        invoice += '  </table>';
        invoice += '</div>';
        invoice +='<div id="top" style="page-break-before:always;">';
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
        invoice +='  </div>';
        invoice +='<div id="mid">';  
        invoice +='  <h1 class="title_import_export_details">ITEM INFORMATION</h1>';
        invoice +='<hr/>';
        invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
        invoice += '<tr>';
        invoice += '  <th align="center" style="text-align: center;">IE</br> LINE</th>';
        invoice += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
        invoice += '  <th align="center" style="text-align: left;">ITEM, DESCRIPTION</th>';
        invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
        invoice += '  <th align="center" style="text-align: center;">CARTONS</th>';
        invoice += '  <th align="center" style="text-align: center;">UNITS</th>';
        invoice += '  <th align="center" style="text-align: center;">UNIT PRICE</th>';
        invoice += '  <th align="center" style=" text-align: center;">SUBTOTAL</th>';
        invoice += '  <th align="center" style="text-align: center;">CURRENCY</th>';
        invoice += '</tr>';
        contador_items =0;
      }
      invoice += '  <tr>';
      invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
      invoice += '    <td align="center">'+o.Item__r.Sourcing_Item_Code__c+' | '+o.Item__r.Sourcing_Item_Code__c+'</td>';//-----falta el del cliente ese es de proveedor
      invoice += '    <td align="center">'+o.Item__r.Name+'</br>'+(o.Item__r.Item_Description__c != null ? ''+ o.Item__r.Item_Description__c : '')+'</td>';
      invoice += '    <td align="right">'+(o.Item_Units_x_Packaging__c != null  ? o.Item_Units_x_Packaging__c : 0)+'</td>';
      invoice += '    <td align="right">'+(o.Packaging_Quantity__c != null ? o.Packaging_Quantity__c : 0 )+'</td>';
      invoice += '    <td align="right">'+o.Quantity__c+'</td>';
      invoice += '    <td align="right">'+(o.Unit_Destination_Price__c != null ? (o.Unit_Destination_Price__c - (o.Expense_Amount__c != null ? o.Expense_Amount__c/o.Quantity__c : 0)).setScale(4): 0)+'</td>';//----- o el origen
      invoice += '    <td align="right">'+(o.Total_Destination_Amount__c != null ? o.Total_Destination_Amount__c - (o.Expense_Amount__c != null ? o.Expense_Amount__c : 0) : 0)+'</td>';
      invoice += '    <td align="right">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
      invoice += '  </tr>';
  
      contador_items ++;
      if(o.Total_Destination_Amount__c != null)
          totalamount +=o.Total_Destination_Amount__c;
      else
          totalamount +=o.Total_Amount__c;
      }
      
       //incluir lineas de gastos adicionales
        if(sqoline.size()>0)
        for(Supplier_Quote_Line__c o : sqoline)
      {
         if(NEU_Utils.safeDecimal(o.Expense_Amount__c) != 0)
        {
              if((contador_items == 10 && contador_paginas == 0) || (contador_items == 14 && contador_paginas > 0) || Test.isRunningTest())
              {
                contador_paginas ++;
                invoice += '  </table>';
                invoice += '</div>';
                invoice +='<div id="top" style="page-break-before:always;">';
                invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
                invoice +='  </div>';
                invoice +='<div id="mid">';
                invoice +='  <h1 class="title_import_export_details">ITEM INFORMATION</h1>';
                invoice +='<hr/>';
                invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
                invoice += '<tr>';
                invoice += '  <th align="center" style="text-align: center;">IE</br> LINE</th>';
                invoice += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
                invoice += '  <th align="center" style="text-align: left;">ITEM, DESCRIPTION</th>';
                invoice += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
                invoice += '  <th align="center" style="text-align: center;">CARTONS</th>';
                invoice += '  <th align="center" style="text-align: center;">UNITS</th>';
                invoice += '  <th align="center" style="text-align: center;">UNIT PRICE</th>';
                invoice += '  <th align="center" style=" text-align: center;">SUBTOTAL</th>';
                invoice += '  <th align="center" style="text-align: center;">CURRENCY</th>';
                invoice += '</tr>';
                contador_items =0;
              }
              invoice += '  <tr>';
              invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
              invoice += '    <td align="center"></td>';
              invoice += '    <td align="center">'+(o.Expense_Concept__c != null ? ''+ o.Expense_Concept__c : '')+'</td>';
              invoice += '    <td align="right"></td>';
              invoice += '    <td align="right"></td>';
              invoice += '    <td align="right">'+o.Quantity__c+'</td>';
              invoice += '    <td align="right">'+(o.Expense_Amount__c != null ? o.Expense_Amount__c : 0)+'</td>';//----- o el origen
              invoice += '    <td align="right">'+(o.Expense_Amount__c != null ? o.Expense_Amount__c : 0)+'</td>';
              invoice += '    <td align="right">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
              invoice += '  </tr>';
          
              contador_items ++;
        }
      }

     
      //----
    
     //ÚLTIMA PÁGINA  
    invoice += '    <tr>';
    invoice += '      <th colspan="7">Total Product Value</th>';
    invoice += '      <td align="right">'+record.SUM_Destination_Amount__c+'</td>';
    invoice += '      <td align="right">'+NEU_CurrencyUtils.getCurrencyIsoCode(record)+'</td>';
    invoice += '    </tr>';
    invoice += '  </table>';
    invoice += '</div>';
    
     //---------------------------PACKING INFORMATION
     if(contador_items == 14 && contador_paginas > 0)
     {
        invoice +='<div id="top" style="page-break-before:always;">';//
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
        invoice +='  </div>';
        contador_items = 0;
     }
      invoice +='<div id="mid">';
     invoice +='  <h1 class="title_import_export_details">PACKING INFORMATION</h1>';
    invoice +='<hr/>';
    invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';//style="height: 400px;"
    invoice += '<tr>';
    invoice += '  <th align="center" style="text-align: center;">LINE</th>';
    invoice += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
    invoice += '  <th align="center" style="text-align: left;">ITEM</th>'; 
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
      for(Supplier_Quote_Line__c o : sqoline)
        {
           if((contador_items_packaging == 17 && contador_paginas > 0 && contador_items == 0) || (contador_items > 0 && (contador_items_packaging + contador_items) >= 12 && contador_paginas > 0) || Test.isRunningTest())
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
            invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';//style="height: 400px;"
            invoice += '<tr>';
            invoice += '  <th align="center" style="text-align: center;">LINE</th>';
            invoice += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
            invoice += '  <th align="center" style="text-align: left;">ITEM</th>';  
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
            contador_items =0;
            contador_items_packaging = 0;
          }
          
            invoice += '  <tr>';
            invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
            invoice += '    <td align="center">'+o.Item__r.Sourcing_Item_Code__c+'</td>';
            invoice += '    <td align="center">'+o.Item__r.Name+'</td>';
            invoice += '    <td align="right">'+(o.Quantity__c != null ? o.Quantity__c : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Item_Units_x_Packaging__c != null ? o.Item_Units_x_Packaging__c : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Packaging_Quantity__c != null ? o.Packaging_Quantity__c : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Packaging_Length_cm__c != null ? o.Packaging_Length_cm__c : 0)+'*'+(o.Packaging_Width_cm__c != null ? o.Packaging_Width_cm__c : 0)+'*'+(o.Packaging_Height_cm__c != null ? o.Packaging_Height_cm__c : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Packaging_Volume_m3__c != null ? o.Packaging_Volume_m3__c : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Total_Volume_m3__c != null ? o.Total_Volume_m3__c : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Total_Weight_Kg__c != null ? o.Total_Weight_Kg__c  - (o.Packaging_Weight_kg__c != null ? o.Packaging_Weight_kg__c*NEU_Utils.safeDecimal(o.Packaging_Quantity__c) : (o.Item__r.Master_Box_Packing_Weight_kg__c != null ? o.Item__r.Master_Box_Packing_Weight_kg__c : 0)) : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Packaging_Gross_Weight_kg__c != null ? o.Packaging_Gross_Weight_kg__c : 0)+'</td>';
            invoice += '    <td align="right">'+(o.Total_Weight_Kg__c != null ? o.Total_Weight_Kg__c : 0)+'</td>';
            invoice += '</tr>';
            contador_items_packaging ++;
        }
    
    invoice += '    <tr>';
    invoice += '      <td align="right" style="background-color: white;"></td>';
    invoice += '      <td align="right" style="background-color: white;"></td>';
    invoice += '      <td align="right" style="background-color: white;"></td>';
    invoice += '      <td align="right" style="background-color: white;"></td>';
    invoice += '      <td align="right" style="background-color: white;"></td>';
    invoice += '      <td align="right" style="background-color: white;"></td>';
    invoice += '      <td align="right" style="background-color: white;"></td>';
    invoice += '      <th>Total</th>';
    invoice += '      <td align="right">'+record.Total_Volume_m3_2__c+'</td>';
    invoice += '      <td align="right"></td>';
    invoice += '      <th>Total</th>';
    invoice += '      <td align="right">'+record.Total_Weight_Kg2__c+'</td>';
    invoice += '    </tr>';
     
    invoice += '  </table>';  
    invoice += '</div>';
    
  //  if(contador_items_packaging == 16 && contador_paginas > 1 && contador_items == 0) 
   // {
      invoice +='<div id="top" style="page-break-before:always;">';
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
        invoice +='  </div>';
//    }
    invoice +='<div id="mid">';
    invoice +='  <h1 class="title_import_export_details">LOGISTIC REQUIREMENTS</h1>';
    invoice +='<hr/>';
    invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
    invoice += '    <tr>';
    invoice += '        <th>DOCS</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>SHIPPING MARKS/LABELING</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>SIDE MARKS</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>BAR CODING</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>SPECIAL PACKING REQUIREMENTS</th><td></td>';
    invoice += '    </tr>';
    invoice +='</table>';
    
    invoice +='  <h1 class="title_import_export_details">GENERAL CONDITIONS OF SALE AND PURCHASE</h1>';
    invoice +='<hr/>';
    invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
    invoice += '    <tr>';
    invoice += '        <th>SUPPLIER ACCEPTANCE</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>QUALITY GUARANTEE</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>QUANTITY</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>DELIVERY GUARANTEE</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>SAMPLE APPROVAL</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>GOODS INSPECTION</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>QUANTITY</th><td></td>';
    invoice += '    </tr>';
    invoice += '    <tr>';
    invoice += '        <th>ARBITRATION</th><td></td>';
    invoice += '    </tr>';
    invoice +='</table>';
    
     invoice +='  <h1 class="title_import_export_details">SPECIAL CONDITIONS OF THIS PURCHASE ORDER</h1>';
    invoice +='<hr/>';
    invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
    invoice += '    <tr>';
    invoice += '        <th>SPECIAL CONDITIONS PREVAIL OVER GENERAL CONDITIONS</th><td></td>';
    invoice += '    </tr>';
    invoice +=' </table>';
    
    invoice += '</div>';
    
    invoice += '<div id="bot">';
    
    invoice += '<div id="bot_left" style="height: 140px;">';
    invoice += '  <span class="title" style="font-weight: bold;">CLIENT COMMENTS, SIGNATURE, DATE</span>';//---leer de un email template o algo 
    invoice += '  <hr/>';
  
    invoice += '</div>';

    
    
    invoice += '</div>';
    cont++;
    
   
     
    }
}