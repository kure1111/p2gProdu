public with sharing class NEU_DeliveryNote_pdf {

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
            
    public NEU_DeliveryNote_pdf(ApexPages.StandardController stdController) {

        con = stdController;
        
        try { 
        record = [select Id, Name, Account_for__c,
        Account_for__r.Phone, Account_for__r.BillingStreet,
        Account_for__r.BillingCity, Account_for__r.BillingState,Account_for__r.NEU_Email__c,
        Account_for__r.BillingCountry ,Account_for__r.Name, ETA_Point_of_Discharge__c,Forwarder__r.Name,Destination_Address__c,
        Contact__r.Name, SUM_Sell_Origin_Amount__c from Shipment__c where id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Shipment__c();
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
        
        List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo']; 
        
        invoice +='  <div id="container">';
        invoice +='<div id="top" >';
        invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
                
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
        
        invoice +='  <h1 class="title_import_export_details">DELIVERY NOTE</h1>';//ALBARÁN DE ENTREGA
        invoice +='<div id="mid_left" style="width: 50%;">';
        invoice +='  <ul class="customer_data">';
        invoice +='    <li><span class="customer_data_title">SHIPMENT Nº:</span>&nbsp;<span>'+record.Name+'</span></li>';
        invoice +='    <li><span class="invoice_data_title">ORDER:</span>&nbsp;<span></span></li>';//PEDIDO
        invoice +='    <li><span class="invoice_data_title">SHIPPING:</span>&nbsp;<span></span></li>';//EMBARQUE
        if(record.ETA_Point_of_Discharge__c != null)
            invoice +='    <li><span class="invoice_data_title">DELIVERY DATE:</span>&nbsp;<span>'+record.ETA_Point_of_Discharge__c+'</span></li>';
        else
            invoice +='    <li><span class="invoice_data_title">DELIVERY DATE:</span>&nbsp;<span></span></li>';//FECHA ENTREGA
        invoice +='  </ul>';
        invoice +='</div>';
        invoice +='<div id="mid_right" style="width: 50%;">';
        invoice +='  <ul class="invoice_data"  style="float: left;    margin-left: 102px;">';
        invoice +='    <li><span class="invoice_data_title">Nº DELIVERY NOTE:</span>&nbsp;<span></span></li>';//N ALBARÁN
        invoice +='    <li><span class="invoice_data_title">DATE DELIVERY NOTE:</span>&nbsp;<span>'+fecha+'</span></li>';//FECHA ALBARÁN
        invoice +='    <li><span class="invoice_data_title">Nº CUSTOMER ORDER:</span>&nbsp;<span></span></li>';//PEDIDO CLIENTE
        invoice +='    <li><span class="invoice_data_title">FORWARDER:</span>&nbsp;<span>'+(record.Forwarder__c != null ? record.Forwarder__r.Name : '')+'</span></li>';//TRANSITARIO:
        invoice +='  </ul>';
        invoice +='</div>';
        
        
        invoice +='  <h1 class="title_client_information">CLIENT INFORMATION</h1>';
        invoice +=  '<div class="client_information">';
        invoice +='  <ul class="customer_data"  style="    width: 452px;">';
        invoice += '  <li><span class="customer_data_title">CLIENT:</span>&nbsp;<span>'+ (record.Account_for__r.Name != null ? record.Account_for__r.Name : '') +'</span></li>';
        if(record.Destination_Address__c != null)
            invoice += '  <li><span class="customer_data_title">DELIVERY ADDRESS:</span>&nbsp;<span>'+record.Destination_Address__c+'</span></li>';//DIRECCION DE ENTREGA
        else
            invoice += '  <li><span class="customer_data_title">DELIVERY ADDRESS:</span>&nbsp;<span></span></li>';//DIRECCION DE ENTREGA
        invoice += '  <li><span class="customer_data_title">PICKUP ADDRESS:</span>&nbsp;<span></span></li>';//DIRECCION DE RECOGIDA
        invoice +='  </ul>';
        invoice +='  <ul class="customer_data_derecha" style="    width: 247px;">';
        invoice += '  <li><span class="customer_data_title">PHONE.:</span>&nbsp;<span>'+(record.Account_for__r.Phone != null ? record.Account_for__r.Phone : '')+'</span></li>';
        invoice += '  <li><span class="customer_data_title">EMAIL:</span>&nbsp;<span>'+(record.Account_for__r.NEU_Email__c != null ? record.Account_for__r.NEU_Email__c : '')+'</span></li>';
        invoice +='  </ul>';
        invoice +=  '</div>'; 
        invoice +='</div>';
        
        
        invoice +='<div id="mid">';
        
        invoice +='  <h1 class="title_import_export_details">ITEM INFORMATION</h1>';
        invoice +='<hr/>';
        
        invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';//style="height: 400px;"
        invoice += '<tr>';
        invoice += '  <th align="center" style="text-align: center;">SL</br> LINE</th>';
        invoice += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
        invoice += '  <th align="center" style="text-align: left;">ITEM NAME</th>';
        invoice += '  <th align="center" style="text-align: left;">UNITS</th>';
        invoice += '  <th align="center" style="text-align: left;">UNITS </br> /CARTON</th>';
        invoice += '  <th align="center" style=" text-align: left;">Nº CARTON</th>';
        invoice += '  <th align="center" style=" text-align: left;">UNITS</br> LAST</br> CARTON</th>';
        invoice += '  <th align="center" style=" text-align: left;">WEIGHT</th>';
        invoice += '  <th align="center" style=" text-align: left;">VOLUME</th>';
        invoice += '  <th align="center" style=" text-align: left;">TYPE OF PALLET</th>';
        invoice += '  <th align="center" style=" text-align: left;">TOTAL CARTONS FOR PALLET</th>';
        invoice += '  </tr>';
        

        List<Shipment_Line__c> sqoline = new List<Shipment_Line__c>();
        string query_string_quote_item_line = '';
        query_string_quote_item_line +='select Id, Name, Item_Name__c, Item_Name__r.Name,'; 
        query_string_quote_item_line +='Unit_Destination_Price__c, Item_Name__r.Sourcing_Item_Code__c, ';
        query_string_quote_item_line +='Packaging_Quantity__c , Item_Units_x_Packaging__c , Item_Name__r.Url_Photo_1__c,';
        if(UserInfo.isMultiCurrencyOrganization()== true)
            query_string_quote_item_line +='                                                        CurrencyIsoCode,'; 
        query_string_quote_item_line +='Item_Name__r.Item_Description__c, Destination_Amount__c, Unit_of_measure__c, Shipping_Weight_Kg__c,Shipping_Volume_m3__c,';
        query_string_quote_item_line +='Units_Shipped__c, Origin_Buy_Amount__c from Shipment_Line__c where Shipment__c = \''+ record.Id+'\' order by Name';
        List<sObject> query_quote_item_line = Database.query(query_string_quote_item_line );
        sqoline = query_quote_item_line;
        
        integer contador_paginas = 0;
        integer contador_items = 0;
        decimal total_units = 0;
        decimal total_cajas = 0;
        decimal total_peso = 0;
        decimal total_volumnen = 0;
        if(sqoline.size()>0)
        for(Shipment_Line__c o : sqoline)
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
            invoice +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice">'; //style="height: 400px;"
            invoice += '<tr>';
            invoice += '  <th align="center" style="text-align: center;">SL</br> LINE</th>';
            invoice += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
            invoice += '  <th align="center" style="text-align: left;">ITEM NAME</th>';
            invoice += '  <th align="center" style="text-align: left;">UNITS</th>';
            invoice += '  <th align="center" style="text-align: left;">UNITS </br> /CARTON</th>';
            invoice += '  <th align="center" style=" text-align: left;">Nº CARTON</th>';
            invoice += '  <th align="center" style=" text-align: left;">UNITS </br>LAST</br> CARTON</th>';
            invoice += '  <th align="center" style=" text-align: left;">WEIGHT</th>';
            invoice += '  <th align="center" style=" text-align: left;">VOLUME</th>';
            invoice += '  <th align="center" style=" text-align: left;">TYPE OF PALLET</th>';
            invoice += '  <th align="center" style=" text-align: left;">TOTAL CARTONS FOR PALLET</th>';
            invoice += '</tr>';
            contador_items =0;
          }
          invoice += '  <tr>';
          invoice += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
          invoice += '    <td align="center">'+(o.Item_Name__r.Sourcing_Item_Code__c != null ? o.Item_Name__r.Sourcing_Item_Code__c :'') +'</td>';
          invoice += '    <td align="center">'+o.Item_Name__r.Name+'</td>';
          invoice += '    <td align="right">'+o.Units_Shipped__c+'</td>';
          invoice += '    <td align="right">'+(o.Item_Units_x_Packaging__c != null  ? o.Item_Units_x_Packaging__c : 0)+'</td>';
          invoice += '    <td align="right">'+(o.Packaging_Quantity__c != null ? o.Packaging_Quantity__c : 0 )+'</td>';
          invoice += '    <td align="right">'+(o.Item_Units_x_Packaging__c != null && NEU_Utils.safeDecimal(o.Item_Units_x_Packaging__c) != 0 && NEU_Utils.safeDecimal(o.Units_Shipped__c) != 0 ? Math.mod(integer.valueof(o.Units_Shipped__c), integer.valueof(o.Item_Units_x_Packaging__c)) : 0 )+'</td>';
          invoice += '    <td align="right">'+(o.Shipping_Weight_Kg__c != null ? o.Shipping_Weight_Kg__c : 0) +'</td>';
          invoice += '    <td align="right">'+(o.Shipping_Volume_m3__c != null ? o.Shipping_Volume_m3__c : 0)+'</td>';
          invoice += '    <td align="right"></td>';//---- type of pallet
          invoice += '    <td align="right"></td>';
          invoice += '  </tr>';
          total_units += (o.Units_Shipped__c != null ? o.Units_Shipped__c  : 0);
          total_cajas += (o.Packaging_Quantity__c != null ? o.Packaging_Quantity__c : 0 );
          total_peso += (o.Shipping_Weight_Kg__c != null ? o.Shipping_Weight_Kg__c : 0);
          total_volumnen += (o.Shipping_Volume_m3__c != null ? o.Shipping_Volume_m3__c : 0);
      
          contador_items ++;
          if(o.Destination_Amount__c != null)
              totalamount +=o.Destination_Amount__c;
          else
              totalamount +=o.Origin_Buy_Amount__c;
          }
    
         
          //----
        
        //ÚLTIMA PÁGINA  
        invoice += '    <tr>';
        invoice += '      <th colspan="3">Total</th>';
        invoice += '      <td align="right">'+total_units+'</td>';
        invoice += '      <td align="right"></td>';
        invoice += '      <td align="right">'+(total_cajas !=null ? total_cajas : 0)+'</td>';
        invoice += '      <td align="right"></td>';
        invoice += '      <td align="right">'+(total_peso !=null ? total_peso : 0)+'</td>';
        invoice += '      <td align="right">'+(total_volumnen !=null ? total_volumnen : 0)+'</td>';
        invoice += '      <td align="right"></td>';
        invoice += '      <td align="right"></td>';
        invoice += '    </tr>';
        invoice += '  </table>';
        invoice += '</div>';
        if(contador_items == 7)
        {
            invoice +='<div id="top" style="page-break-before:always;">';
            invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
            invoice +='  </div>';
        }
        invoice +='<div id="mid">';
        invoice +='  <h1 class="title_import_export_details">OBSERVATIONS</h1>';
        invoice +='<span style="float:left;color: #908e8e;                 font-size: 10px;                 font-family: Arial, Helvetica, sans-serif; ">Return completed, signed and stamped upon delivery of the goods to logistica@neurored.com</span>';//devolver rellenado, firmado y sellado una vez entregada la mercancía a logistica@kaelisgroup.com
        invoice +='<hr/>';
        invoice += '</div>';
        
        
        
        invoice +='  </div>';
    }
}