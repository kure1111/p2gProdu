public with sharing class NEU_Shipping_Marks_pdf {

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
            
    public NEU_Shipping_Marks_pdf(ApexPages.StandardController stdController) {

        con = stdController;
        
        try { 
        record = [select Id, Name, Account_for__c,
        Account_for__r.Phone, Account_for__r.BillingStreet,
        Account_for__r.BillingCity, Account_for__r.BillingState,
        Account_for__r.BillingCountry ,Account_for__r.Name,Supplier_Account__c, Supplier_Account__r.Name,
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
        
        invoice +='  <div id="container">';
        
        List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo'];


         List<Shipment_Line__c> sqoline = new List<Shipment_Line__c>();
        string query_string_quote_item_line = '';
        query_string_quote_item_line +='select Id, Name, Item_Name__c, Item_Name__r.Name,Packaging_Length_cm__c,Packaging_Width_cm__c,'; 
        query_string_quote_item_line +='Unit_Destination_Price__c, Item_Name__r.Sourcing_Item_Code__c, Import_Export_Quote__c, Import_Export_Quote__r.Name, Shipping_Weight_Kg__c,  ';
        query_string_quote_item_line +='Packaging_Quantity__c , Item_Units_x_Packaging__c , Item_Name__r.Url_Photo_1__c, Item_Code__c, Shipment__c, Shipment__r.Name,';
        if(UserInfo.isMultiCurrencyOrganization()== true)
            query_string_quote_item_line +='                                                        CurrencyIsoCode,'; 
        query_string_quote_item_line +='Item_Name__r.Item_Description__c, Destination_Amount__c, Unit_of_measure__c, Packaging_Height_cm__c,';
        query_string_quote_item_line +='Units_Shipped__c, Origin_Buy_Amount__c from Shipment_Line__c where Shipment__c = \''+ record.Id+'\' order by Name';
        List<sObject> query_quote_item_line = Database.query(query_string_quote_item_line );
        sqoline = query_quote_item_line;
        integer contador_lineas = 0;
        if(sqoline.size()>0)
            for(Shipment_Line__c o : sqoline)
            {
            
                if(contador_lineas == 0)
                    invoice +='     <div id="top" >';
                else
                    invoice +='<div id="top" style="page-break-before:always;">';
                invoice +='<img src="/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" id="KAELIS_logo"/>';
                invoice +='<div id="kaelis_address_data">';
                invoice +='  <span>Web: www.neurored.com</span>';
                invoice +='  <span>Supplier: '+(record.Supplier_Account__r.Name != null ? record.Supplier_Account__r.Name : '')+'</span>';
                invoice +='  </div>';
                invoice +='     </div>';
                
                
                invoice +='     <div id="mid">';
                invoice +='         <table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
                invoice += '            <tr>';
                invoice += '                <th colspan="2" style="text-align: center; font-size:15px;     background: #DDCDE0;    font-weight: bold;">FRONT MARKS</th>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td colspan="2" style="text-align: center; font-size:15px;">'+record.Account_for__r.Name+'</td>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td>CUSTOMER ORDER No.</td><td>'+o.Import_Export_Quote__r.Name+'</td>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td>ITEM CODE</td><td>'+o.Item_Code__c+'</td>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td>CUSTOMER PRODUCT CODE</td><td></td>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td>PRODUCT DESCRIPTION</td><td>'+(o.Item_Name__r.Item_Description__c != null ? o.Item_Name__r.Item_Description__c : '') +'</td>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td>KAELIS ORDER No.</td><td></td>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td>SHIPMENT No.</td><td>'+o.Shipment__r.Name+'</td>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                //-----aqui va un if con un check
                invoice += '                <td>BATCH No. / PRODUCTION DATE / EXPIRATION DATE</td><td></td>';
                invoice += '            </tr>';
                invoice += '        </table>';
                invoice +='     </div>';
                
                invoice +='     <div id="mid">';
                invoice +='         <table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
                invoice += '            <tr>';
                invoice += '                <th colspan="2" style="text-align: center; font-size:15px;     background: #DDCDE0;    font-weight: bold;">SIDE MARKS</th>';
                invoice += '            </tr>';
                invoice += '            <tr>';
                invoice += '                <td>G.W.</td><td style="    text-align: right;">'+(o.Shipping_Weight_Kg__c != null ? o.Shipping_Weight_Kg__c : 0)+'</td>';
                invoice += '            </tr>'; 
                invoice += '            <tr>';
                invoice += '                <td>PCS/INNER</td><td style="    text-align: right;"></td>';
                invoice += '            </tr>'; 
                invoice += '            <tr>';
                invoice += '                <td>PCS/CNT</td><td style="    text-align: right;">'+o.Item_Units_x_Packaging__c+'</td>';
                invoice += '            </tr>'; 
                invoice += '            <tr>';
                invoice += '                <td>CTN DIMENSION</td><td style="    text-align: right;">'+o.Packaging_Height_cm__c+'*'+o.Packaging_Length_cm__c+'*'+o.Packaging_Width_cm__c+'</td>';
                invoice += '            </tr>'; 
                invoice += '            <tr>';
                invoice += '                <td>CARTON No.</td><td style="    text-align: right;">'+o.Packaging_Quantity__c+'</td>';
                invoice += '            </tr>'; 
                invoice += '        </table>';
                invoice +='     </div>';
                contador_lineas ++;
            }
        
        
        invoice +='  </div>';
    }
}