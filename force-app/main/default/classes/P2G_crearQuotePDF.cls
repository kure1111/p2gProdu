public with sharing class P2G_crearQuotePDF {
	public string pdfFinal {get;set;}
    public Quote quote {get;set;}
    ApexPages.StandardController con;
    public P2G_crearQuotePDF(ApexPages.StandardController stdController){
        con = stdController;
        System.debug('id ->' + con.getRecord().Id);
        
        quote = [select Id, ExpirationDate, QuoteNumber, Contact.Name, Phone, Email, BillingName, ShippingName,CurrencyIsoCode,
                		Subtotal, Discount, TotalPrice, GrandTotal from Quote where Id =: con.getRecord().Id];
        StaticResource logoQuote = [SELECT Id, Name, Body, SystemModStamp, NamespacePrefix FROM StaticResource WHERE Name = 'logoQuote'];
        StaticResource piePaginaQuote = [SELECT Id, Name, Body, SystemModStamp, NamespacePrefix FROM StaticResource WHERE Name = 'piePaginaQuote' Limit 1];
        Organization orAddress = [SELECT Country FROM Organization LIMIT 1];
        User user = [SELECT Name, Email From User WHERE Id =: UserInfo.getUserId()];
        List<QuoteLineItem> listaQuoteLine = [SELECT Id, Product2.Name,Tipo_de_Linea__c,UnitPrice,
                                              Sales_Price_Converted__c,Quantity,Discount,TotalPrice
                                              FROM QuoteLineItem WHERE QuoteId =: quote.Id];
        String pdf;
        pdf = '<div class="formatoText"><div>';
        //inicia header
        pdf += '<div class="slds-grid slds-grid slds-gutters textChico">';
        pdf += '<div class="slds-col slds-size_6-of-12 margenLogo">';
        //pdf += '<div><img src="/resource/1711730610000/logoQuote"/></div>';
        pdf += '<div><img class="logoTamaño" src="/resource/'+logoQuote.SystemModStamp.getTime()+'/'+(logoQuote.NamespacePrefix != null && logoQuote.NamespacePrefix != '' ? logoQuote.NamespacePrefix+ '__' : '')+'logoQuote"/></div>';
        pdf += '</div><div class="slds-col slds-size_6-of-12 textDerecho">';
		pdf += '<span>Calle Argentina no. 205-1 Col. Industrial Martel</span><br>';
		pdf += '<span>de Santa Catarina, N.L. México, C.P. 66367</span>';
		pdf += '<p>Tel. 01 800 APOYO 06</p><p class="titulos">www.2gologistics.com</p>';
        pdf += '</div></div>';
        //fin header
        //Inicia Cuerpo
        pdf += '<br><br>';
		//Company Address
        pdf += '<table class="slds-table">';
  		pdf += '<tbody><tr>';
      	pdf += '<td class="borderTabla" style="width:20%;">';
        pdf += '<div class="slds-truncate titulos">Company Address</div>';
      	pdf += '</td><td class="borderTabla" style="width:80%">';
        pdf += '<div class="slds-truncate">'+orAddress.Country+'</div>';
      	pdf += '</td></tr>';
  		pdf += '</tbody></table>';
        pdf += '<br><br>';
		//Fechas
        pdf += '<table class="slds-table">';
  		pdf += '<tbody><tr class="slds-line-height_reset">';
      	pdf += '<td class="azulAmarillo" style="width:16%">';
        pdf += '<div class="slds-truncate">Created Date</div>';
      	pdf += '</td><td class="borderTabla" style="width:16%">';
        pdf += '<div class="slds-truncate">'+System.today()+'</div>';
      	pdf += '</td><td class="borderTabla azulAmarillo"  style="width:16%">';
        pdf += '<div class="slds-truncate">Expiration Date</div>';
      	pdf += '</td><td class="borderTabla" style="width:16%">';
        pdf += '<div class="slds-truncate">'+quote.ExpirationDate+'</div>';//2024-05-02</div>';//--------------------------
      	pdf += '</td><td class="borderTabla azulAmarillo"  style="width:16%">';
        pdf += '<div class="slds-truncate">Quote Number</div>';
      	pdf += '</td><td class="borderTabla" style="width:16%">';
        pdf += '<div class="slds-truncate">'+quote.QuoteNumber+'</div>';
      	pdf += '</td></tr>';
  		pdf += '</tbody></table>';
        pdf += '<br><br>';
		//info vendedor/cliente
		pdf += '<table class="slds-table slds-table_cell-buffer slds-table_bordered slds-table_col-bordered">';
        pdf += '<tbody><tr>';
        pdf += '<td class="borderTabla"><div class="slds-truncate titulos">Preparede By</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate">'+user.Name+'</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate titulos">Contact Name</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate">'+quote.Contact.Name+'</div>';//Rafael Hernandez Cruz</div>';//--------------------------
        pdf += '</td></tr><tr>';
        pdf += '<td class="borderTabla"><div class="slds-truncate titulos">Email</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate">'+user.Email+'</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate titulos">Phone</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate">'+quote.Phone+'</div>';//56489235697</div>';//-------------------------
        pdf += '</td></tr><tr>';
        pdf += '<td class="borderTabla"><div class="slds-truncate titulos"></div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate"></div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate titulos">Email</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate">'+quote.Email+'</div>';//rafael.Hernandez@uncorreo.com</div>';//--------
        pdf += '</td></tr>';
		pdf += '</tbody>';
		pdf += '</table>';
        pdf += '<br><br>';
		pdf += '<table class="slds-table slds-table_cell-buffer slds-no-row-hover slds-table_bordered">';
        pdf += '<tbody><tr>';
        pdf += '<td class="borderTabla"><div class="slds-truncate titulos">Bill To Name</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate">'+quote.BillingName+'</div>';//ZHEJIANG TALENTS INTERNATIONAL LOGISTICS CO., LTD</div>';//------------
        pdf += '</td><td class="borderTabla"><div class="slds-truncate titulos">Ship To Name</div>';
        pdf += '</td><td class="borderTabla"><div class="slds-truncate">'+quote.ShippingName+'</div>';//ZHEJIANG TALENTS INTERNATIONAL LOGISTICS CO., LTD</div>';//-----------
        pdf += '</td></tr>';
		pdf += '</tbody>';
		pdf += '</table>';
        pdf += '<br><br>';
		//Lista de productos
		pdf += '<table class="slds-table slds-table_cell-buffer slds-table_bordered slds-table_col-bordere">';
		pdf += '<thead><tr><th class="bordeInferiror azulAmarillo">';
		pdf += '<div>Product</div>';
		pdf += '</th><th class="bordeInferiror azulAmarillo">';
		pdf += '<div>Tipo de Linea</div>';
		pdf += '</th><th class="bordeInferiror azulAmarillo">';
		pdf += '<div>Sales Price</div>';
		pdf += '</th><th class="bordeInferiror azulAmarillo" scope="col">';
		pdf += '<div>Sales Price Converted</div>';
		pdf += '</th><th class="bordeInferiror azulAmarillo">';
		pdf += '<div>Quantity</div>';
        pdf += '</th><th class="bordeInferiror azulAmarillo" scope="col">';
        pdf += '<div>Discount (Percentage)</div>';
        pdf += '</th><th class="bordeInferiror azulAmarillo" scope="col">';
        pdf += '<div>Total Price</div>';
        pdf += '</th></tr></thead>';
        if(listaQuoteLine.size() > 0){
            pdf += '<tbody>';
            for(QuoteLineItem quoteLine : listaQuoteLine){
                pdf += '<tr><td class="bordeInferiror"><div>'+quoteLine.Product2.Name+'</div>';
                pdf += '</td><td class="bordeInferiror"><div>'+quoteLine.Tipo_de_Linea__c+'</div>';
                pdf += '</td><td class="bordeInferiror"><div>'+quote.CurrencyIsoCode+' $'+quoteLine.UnitPrice.format()+'</div>';
                pdf += '</td><td class="bordeInferiror"><div>'+quoteLine.Sales_Price_Converted__c+'</div>';
                pdf += '</td><td class="bordeInferiror"><div>'+quoteLine.Quantity+'</div>';
                pdf += '</td><td class="bordeInferiror"><div>'+quoteLine.Discount+'</div>';
                pdf += '</td><td class="bordeInferiror"><div>'+quote.CurrencyIsoCode+' $'+quoteLine.TotalPrice.format()+'</div>';
                pdf += '</td></tr>';
            }
            pdf += '</tbody>';
        }
		pdf += '</table>';
        pdf += '<br><br>';
        //totales
        pdf += '<table class="slds-table tablaDerecha" style="width:30%">';
  		pdf += '<tbody><tr>';
      	pdf += '<td class="borderTabla">';
        pdf += '<div class="slds-truncate">Subtotal</div>';
      	pdf += '</td><td class="borderTabla">';
        pdf += '<div class="slds-truncate">'+quote.CurrencyIsoCode+' $'+quote.Subtotal.format()+'</div>';
      	pdf += '</td></tr><tr>';
      	pdf += '<td class="borderTabla">';
        pdf += '<div class="slds-truncate">Discount</div>';
      	pdf += '</td><td class="borderTabla">';
        pdf += '<div class="slds-truncate">'+quote.Discount+'</div>';
      	pdf += '</td></tr><tr>';
      	pdf += '<td class="borderTabla">';
        pdf += '<div class="slds-truncate">Total Price</div>';
      	pdf += '</td><td class="borderTabla">';
        pdf += '<div class="slds-truncate">'+quote.CurrencyIsoCode+' $'+quote.TotalPrice.format()+'</div>';
      	pdf += '</td></tr><tr>';
      	pdf += '<td class="borderTabla azulAmarillo">';
        pdf += '<div>Grand Total</div>';
      	pdf += '</td><td class="borderTabla azulAmarillo">';
        pdf += '<div>'+quote.CurrencyIsoCode+' $'+quote.GrandTotal.format()+'</div>';
      	pdf += '</td></tr>';
  		pdf += '</tbody></table>';
		pdf += '</div>';
        pdf += '</div></div>';
        
        //inicia footer
        pdf += '<div class="footer formatoText">';
        //cotizacion incluye
        pdf += '<div class="vline"></div>';
        pdf += '<div><span>Grand Total</span><br>';
        pdf += '<span class="textGrande titulos">'+quote.CurrencyIsoCode+' $'+quote.GrandTotal.format()+'</span><br>';
		pdf += '<span style="font-weight: bold;">Tu cotización incluye:</span><br>';
		pdf += '<ul>';
        pdf += '<li>Control Room 24/7</li>';
        pdf += '<li>Atención Personalizada</li>';
        pdf += '<li>Asesoría Legal</li>';
        pdf += '<li>Equipo Dedicado</li>';
    	pdf += '</ul>';
        //pdf += '<div><img src="/resource/1712067590000/piePaginaQuote"/></div>';
        pdf += '<img src="/resource/'+piePaginaQuote.SystemModStamp.getTime()+'/'+(piePaginaQuote.NamespacePrefix != null && piePaginaQuote.NamespacePrefix != '' ? piePaginaQuote.NamespacePrefix+ '__' : '')+'piePaginaQuote"/>';
        pdf += '<div class="line"><hr></div>';
        pdf += '<div class="pieRecuadro"></div>';
        pdf += '</div>';
        //fin footer
        
        String sinfecha = pdf.replace('00:00:00',' ');
        pdfFinal = sinfecha.replace('null',' ');
    }
}