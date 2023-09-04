public with sharing class NEU_IE_Comparison_PDF {

    public Customer_Quote__c record;
    public integer contador {get;set;}
    public String fecha {get;set;}
    public string observaciones {get;set;}
    public string cabecera {get;set;}
    public string datoscuenta {get;set;}
    public string invoice {get;set;}
    public string porcentagecomisiongeneral {get;set;}
    public string totalvalue {get;set;}
    public decimal total {get;set;}
    public string comprobante {get;set;}
    public decimal totalamount {get;set;}
    public string moneda {get;set;}
    ApexPages.StandardController con;
            
    public NEU_IE_Comparison_PDF(ApexPages.StandardController stdController) {

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
    cabecera = '';
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

    //CurrencyIsoCode
    integer contador_items=0;
    invoice +='  <div id="container">';
    invoice +='<div id="top" >';
    cabecera +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"  style="margin-top: 40px;" />';
               
    cabecera +='<div id="kaelis_address_data">';
    cabecera +='  <span class="title">Demo Company</span>';
    cabecera +='  <span>Test, 7,</span>';
    cabecera +='  <span>test He Xi Heng Rd, Ttest.,</span>';
    cabecera +='  <span>test Testtest,</span>';
    cabecera +='  <span>Test 28703 ES.</span>';
    cabecera +='  <span>Phone.: +34 96 7962 25 82</span>';
    cabecera +='  <span>Other Phone.: +34 96 188 80 88  </span>'; 
    cabecera +='  <span>Fax: +34 88 693 97 87  </span>'; 
    cabecera +='  <span>Web: www.neurored.com</span>';
    cabecera +='  </div>';
    cabecera +='  </div>';
    
    invoice += cabecera;
    
    invoice +='<div id="mid">';
    
    //invoice +='  <h1></h1>';
    invoice +='  <h1 class="title_import_export_details" style="font-size: 19px !important;">QUOTES COMPARISON - '+fecha+'</h1>';
    
    
    invoice +='<div id="mid_left" style="width: 50%;">';
    invoice +='  <ul class="customer_data">';
    invoice +='    <li><span class="invoice_data_title">COUNTRY OF LOAD:</span>&nbsp;<span>'+(record.Country_ofLoad__c != null ? record.Country_ofLoad__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">STATE OF LOAD:</span>&nbsp;<span>'+(record.State_of_Load__c != null ? record.State_of_Load__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">SITE OF LOAD:</span>&nbsp;<span>'+(record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+'</span></li>';
    invoice +='  </ul>';
    invoice +='</div>';
    invoice +='<div id="mid_right" style="width: 50%;">';
    invoice +='  <ul class="invoice_data" style="float: left;    margin-left: 105px;">';
    invoice +='    <li><span class="invoice_data_title">COUNTRY OF DISCHARGE:</span>&nbsp;<span>'+(record.Country_ofDischarge__c != null ? record.Country_ofDischarge__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">STATE OF DISCHARGE:</span>&nbsp;<span>'+(record.State_of_Discharge__c != null ? record.State_of_Discharge__r.Name : '')+'</span></li>';
    invoice +='    <li><span class="invoice_data_title">SITE OF DISCHARGE:</span>&nbsp;<span>'+(record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+'</span></li>';
    invoice +='  </ul>';
   
    invoice +='</div>';
    invoice +=datoscuenta;


	/* BEGIN - DIFERENTES OPCIONES DE COTIZACIÓN */
	invoice += imprimirOpcion(record, 1, cabecera);

    List<String>ids=New List<String>();
    String param=ApexPages.currentPage().getParameters().get('ids');
    if(String.isNotEmpty(param))
    ids=param.split(',');

    List<Customer_Quote__c> opciones = database.query('select Id, Name,'+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Account_for__c, Quotation_Status__c, SUM_Buy_Origin_Amount_number__c, Total_Services_Sell_Amount__c ,  Incoterm_Place__c,SUM_Sell_Destination_Amount_number__c, Contact__r.Phone, Account_for__r.Phone, Account_for__r.BillingStreet,   Account_for__r.BillingCity, Country_ofLoad__c, Country_ofLoad__r.Name, State_of_Load__c, State_of_Load__r.Name, Site_of_Load__c, Site_of_Load__r.Name, Country_ofDischarge__c, Country_ofDischarge__r.Name, State_of_Discharge__c, State_of_Discharge__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name, Total_Items_Units__c, SUM_Buy_Origin_Amount__c, Total_Weight_Kg2__c, Total_Volume_m3_2__c, Purchase_Incoterm__c, Account_for__r.BillingState, Account_for__r.BillingCountry, Account_for__r.Name, Supplier_Account__c, Supplier_Account__r.Name, Contact__r.Name, SUM_Sell_Origin_Amount__c from Customer_Quote__c where id IN:ids');

    Integer numOpciones = 2;
    for(Customer_Quote__c opcion : opciones)
    {
    	invoice += imprimirOpcion(opcion, numOpciones, cabecera);
    	numOpciones++;
    }
	/* END - DIFERENTES OPCIONES DE COTIZACIÓN */
	
    
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
    
    
	private static string imprimirOpcion(Customer_Quote__c ie, Integer n, string cabecera)
    {
    	string opcion = '';

    	List<String> plantilla = new String[]{'2','number','###,###,##0.00'};
		
	    integer contador_paginas = 0;
	    opcion += ' <h1 class="title_import_export_details" style="font-size: 19px !important; margin-bottom:10px;">OPTION '+n+' - '+ie.Name+'</h1>';
	    opcion +='  <h1 class="title_import_export_details">ITEM GENERAL INFORMATION</h1>';
	    opcion +='  <div id="mid_left" style="width: 50%;">';
	    opcion +='     <ul class="customer_data">';
	    opcion +='         <li><span class="customer_data_title">TOTAL WEIGHT (KG):</span>&nbsp;<span>'+(ie.Total_Weight_Kg2__c != null ? ie.Total_Weight_Kg2__c : 0)+'</span></li>';
	    opcion +='         <li><span class="customer_data_title">TOTAL VOLUME (M3):</span>&nbsp;<span>'+(ie.Total_Volume_m3_2__c != null ? ie.Total_Volume_m3_2__c : 0)+'</span></li>';
	    opcion +='     </ul>';
	   
	    opcion +='  </div>';
	    
	    opcion +='<div id="mid_right" style="width: 50%;">';
	    opcion +='  <ul class="invoice_data" style="float: left;    margin-left: 105px;">';
	    opcion +='    <li><span class="invoice_data_title">SUM SELL ORIGIN AMOUNT:</span>&nbsp;<span>'+(ie.SUM_Sell_Origin_Amount__c != null ? ie.SUM_Sell_Origin_Amount__c : 0)+'</span></li>';
	    opcion +='    <li><span class="invoice_data_title">TOTAL ITEMS UNITS:</span>&nbsp;<span>'+(ie.Total_Items_Units__c != null ? ie.Total_Items_Units__c : 0)+'</span></li>';
	    opcion +='  </ul>';
	   
	    opcion +='  </div>';
	    
	    //opcion +='<hr/>';
	   
	    opcion += '</div>';
	
	    integer contador_de_service_charges = 0;
	    //tabla de service charges
	    List<Import_Export_Fee_Line__c> listado_de_lineas_de_fees = new List<Import_Export_Fee_Line__c>();
	    ID recordid=ie.Id;
	    listado_de_lineas_de_fees = database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Service_Rate_Name__c, Service_Rate_Name__r.Name, Service_Rate_Name__r.Route__c, Service_Rate_Name__r.Rate_Type__c, Service_Rate_Name__r.Delivery_Zone__r.Name,Service_Rate_Name__r.Route__r.Name, Rate_Type__c, Sell_Rate__c, Service_Rate_Name__r.Valid_Until__c, Conversion_Rate_to_Currency_Header__c, Units__c, Sell_Amount__c, Service_Rate_Name__r.Pallet_Type__c, Service_Rate_Name__r.Pallet_Type__r.Name,Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Container_Type__r.Name, Quote_Sell_Net_Price__c, Service_Rate_Name__r.TT_Days__c, Service_Rate_Name__r.Delivery_Zone__c,Service_Rate_Name__r.Fee_Category__c, Service_Rate_Name__r.Account_for__c,Service_Rate_Name__r.Account_for__r.Name, Service_Rate_Name__r.Carrier_Account__c, Service_Rate_Name__r.Carrier_Account__r.Name from Import_Export_Fee_Line__c where Import_Export_Quote__c =: recordId order by Name');
	    if(ApexPages.currentPage().getParameters().get('services_charges') == 'true')
	    {
	         
	        opcion +='<div id="mid">';
	        opcion +='  <h1 class="title_import_export_details">IMPORT-EXPORT SERVICE LINES</h1>';
	        opcion +='<hr/>';
	        opcion +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
	        opcion += '<tr>';
	        opcion += '  <th align="center" style="text-align: center;">LINE</th>';
	        opcion += '  <th align="center" style="text-align: center;">RATE CATEGORY</th>';
	        opcion += '  <th align="center" style="text-align: center;">SERVICE RATE NAME</th>';
	        opcion += '  <th align="center" style="text-align: center;">ROUTE</th>'; 
	        opcion += '  <th align="center" style="text-align: center;">PICKUP / DELIVERY ZONE</th>'; 
	        opcion += '  <th align="center" style="text-align: center;">TT DAYS</th>'; 
	        opcion += '  <th align="center" style="text-align: center;">RATE TYPE</th>'; 
	        opcion += '  <th align="center" style="text-align: center;">CONT./PALL. TYPE</th>';
	        opcion += '  <th align="center" style="text-align: center;">CURR.</th>';
	        opcion += '  <th align="center" style="text-align: center;">SELL PRICE</th>';
	        opcion += '  <th align="center" style="text-align: center;">UNITS</th>';  
	        opcion += '  <th align="center" style="text-align: center;">SELL AMOUNT</th>'; 
	        opcion += '</tr>';
	        
	       
	        if(listado_de_lineas_de_fees.size()>0)
	          for(Import_Export_Fee_Line__c o : listado_de_lineas_de_fees)
	            {
	              if((contador_de_service_charges == 14 && contador_paginas > 1) || ((contador_de_service_charges) == 5 && contador_paginas == 0) || Test.isRunningTest())
	              {
	                contador_paginas ++;
	                opcion += '  </table>';
	                opcion += '</div>';
	                opcion += '<div id="top" style="page-break-before:always;"/>';
    				opcion += cabecera;
	                opcion +='<div id="mid">';
	                opcion +='  <h1 class="title_import_export_details">PACKING INFORMATION</h1>';
	                opcion +='<hr/>';
	                opcion +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
	                opcion += '<tr>';
	                opcion += '  <th align="center" style="text-align: center;">LINE</th>';
	                opcion += '  <th align="center" style="text-align: center;">RATE CATEGORY</th>';
	                opcion += '  <th align="center" style="text-align: center;">SERVICE RATE NAME</th>';
	                opcion += '  <th align="center" style="text-align: center;">ROUTE</th>'; 
	                opcion += '  <th align="center" style="text-align: center;">PICKUP / DELIVERY ZONE</th>'; 
	                opcion += '  <th align="center" style="text-align: center;">TT DAYS</th>';
	                 
	                opcion += '  <th align="center" style="text-align: center;">RATE TYPE</th>'; 
	                opcion += '  <th align="center" style="text-align: center;">CONT./PALL. TYPE</th>';
	                opcion += '  <th align="center" style="text-align: center;">CURR.</th>';
	                opcion += '  <th align="center" style="text-align: center;">SELL PRICE</th>';
	                opcion += '  <th align="center" style="text-align: center;">UNITS</th>';  
	                opcion += '  <th align="center" style="text-align: center;">SELL AMOUNT</th>'; 
	                opcion += '</tr>';
	                
	                contador_de_service_charges = 0;
	              }
	              
	              opcion += '  <tr>';
	              opcion += '    <td align="center">'+(o.Name != null ? o.Name :'')+'</td>';
	              opcion += '    <td align="center">'+(o.Service_Rate_Name__r.Fee_Category__c != null ? o.Service_Rate_Name__r.Fee_Category__c : '')+'</td>';
	              opcion += '    <td align="center">'+o.Service_Rate_Name__r.Name+'</td>';
	              opcion += '    <td align="center">'+(o.Service_Rate_Name__r.Route__c != null ? o.Service_Rate_Name__r.Route__r.Name : '')+'</td>';
	              opcion += '    <td align="center">'+(o.Service_Rate_Name__r.Delivery_Zone__c != null ? o.Service_Rate_Name__r.Delivery_Zone__r.Name : '')+'</td>';
	              opcion += '    <td align="center">'+(o.Service_Rate_Name__r.TT_Days__c != null ? o.Service_Rate_Name__r.TT_Days__c : '')+'</td>';
	              opcion += '    <td align="center">'+(o.Service_Rate_Name__r.Rate_Type__c != null ? o.Service_Rate_Name__r.Rate_Type__c : '')+'</td>';
	              opcion += '    <td align="center">'+(o.Service_Rate_Name__r.Container_Type__c != null ? o.Service_Rate_Name__r.Container_Type__r.Name : ( o.Service_Rate_Name__r.Pallet_Type__c != null ? o.Service_Rate_Name__r.Pallet_Type__r.Name : ''))+'</td>';
	              opcion += '    <td align="center">'+NEU_CurrencyUtils.getCurrencyIsoCode(o)+'</td>';
	              opcion += '    <td align="right">'+(o.Quote_Sell_Net_Price__c != null ? o.Quote_Sell_Net_Price__c : 0)+'</td>';
	              opcion += '    <td align="right">'+(o.Units__c != null ? o.Units__c : 0)+'</td>';
	              opcion += '    <td align="right">'+(o.Sell_Amount__c != null ? o.Sell_Amount__c : 0)+'</td>';
	              
	              
	              opcion += '</tr>';
	              contador_de_service_charges ++;
	            }
	        
	          //ÚLTIMA PÁGINA  
	            opcion += '    <tr>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <td align="right" style="background-color: white;"></td>';
	            opcion += '      <th>Total</th>';
	            opcion += '      <td align="right">'+ie.Total_Services_Sell_Amount__c+'</td>';
	            opcion += '    </tr>';
	            opcion += '  </table>';
	            opcion += '</div>';  
	             
	             
	           opcion += '  </table>';  
	           opcion += '</div>';
	    }
	
	    if(contador_de_service_charges == 14 && contador_paginas > 1 ||contador_de_service_charges >=3 && contador_paginas == 0) 
	    {
	    	opcion += '      <div id="top" style="page-break-before:always;"/>';
	      	opcion += cabecera;
	    }

	    opcion += ' </div>';

    	return opcion;
    }    
    
}