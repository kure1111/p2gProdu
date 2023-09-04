public with sharing class NEU_Invoice_PDF
{
    ApexPages.StandardController con;

    public Invoice__c record;

    public integer maxLineas { get; set; }
    public integer grupos { get; set; }
    public integer contador { get; set; }

    public String string_pdf { get; set; }
    public String string_pagina { get; set; }
    public String string_linea_vacia { get; set; }

    public NEU_Invoice_PDF(ApexPages.StandardController stdController)
    {
        List<String> plantilla = new String[]
        {
                '2', 'number', '###,###,##0.00'
        };

        Organization orgDetails = [SELECT Id, Name, Address, City, Fax,Phone,PostalCode, Street FROM Organization WHERE Id = :UserInfo.getOrganizationId()];

        /* DATOS DE LA INVOICE */
        try
        {
            String SoQLSTR = 'SELECT Id, Name, Account__c, Date_of_Invoice__c, Account__r.Name, Contact__c, Contact__r.Name, Standard_S__c, ' +
                    'Non_Applicable_N__c, Zero_Z__c, Total_VAT__c, Total_Excl_VAT__c, Total_Incl_VAT__c, Account__r.BillingStreet, Account__r.BillingCity,' +
                    'Account__r.BillingState, Account__r.BillingPostalCode, Account__r.BillingCountry, Contact__r.MailingState, Contact__r.MailingCountry,' +
                    'Contact__r.MailingPostalCode, Contact__r.MailingStreet, Import_Export_Quote_Order__r.Supplier_Account__r.Name, ' +
                    'Import_Export_Quote_Order__r.Supplier_Account__r.BillingStreet, Comments__c, Contact__r.MailingCity, Import_Export_Quote_Order__r.Consignee__r.Name,' +
                    'Import_Export_Quote_Order__r.Consignee__r.BillingStreet, Invoice_Concept__c, Import_Export_Quote_Order__r.Total_Volume_m3_2__c,' +
                    'Import_Export_Quote_Order__r.ETD__c, Import_Export_Quote_Order__r.Planned_ETA_SP__c, Import_Export_Quote_Order__r.Last_Shipment__r.Truck_Vessel_Flight__r.Name,' +
                    'Import_Export_Quote_Order__r.Site_of_Load__r.Name, ' +
                    'Import_Export_Quote_Order__r.Site_of_Discharge__r.Name, ' +
                    'Import_Export_Quote_Order__r.Nature_Merchandise__c, Import_Export_Quote_Order__r.Total_Weight_Kg2__c, Import_Export_Quote_Order__r.Total_Items_Units__c,' +
                    'Import_Export_Quote_Order__r.POD_Incoterm__c, Import_Export_Quote_Order__r.Last_Shipment__r.Carrier__r.Name, Import_Export_Quote_Order__r.Customer_Reference__c,' +
                    'CurrencyIsoCode, Type__c, Import_Export_Quote_Order__r.Name, Import_Export_Quote_Order__r.Last_Shipment__r.MBL_Number__c,' +
                    'Import_Export_Quote_Order__r.Last_Shipment__r.HBL_Number__c, Import_Export_Quote_Order__r.Last_Shipment__r.MAWB_Number__c,' +
                    'Import_Export_Quote_Order__r.Last_Shipment__r.Freight_Mode__c, Import_Export_Quote_Order__r.Last_Shipment__r.Account_Shipment_Reference__c,' +
                    'Shipment__r.Total_Units_Shipped__c,Shipment__r.Total_Volume_m3__c,Shipment__r.Total_Weight_Kg__c,Import_Export_Quote_Order__r.Freight_Mode__c';
            System.debug('\n\n\n\n' + SoQLSTR + ' FROM Invoice__c WHERE id = \'' + stdController.getRecord().id + '\'' + '\n\n\n\n');
            record = Database.query(SoQLSTR + ' FROM Invoice__c WHERE id = \'' + stdController.getRecord().id + '\'');
        } catch (Exception ee)
        {
            record = new Invoice__c();
        }


        /* MULTILINEA */
        List<Invoice_Line__c> query_invoice_lines = [select id, Name, CurrencyIsoCode, Concept__c, VAT__c, Total_VAT__c, Total_Incl_VAT__c, Amount__c, VAT_Withholding__c, VAT_Withholding_ISR__c from Invoice_Line__c where Invoice__c = :record.id order by Name];
        maxLineas = 4;
        if (query_invoice_lines.size() > maxLineas)
        {
            grupos = (query_invoice_lines.size() / maxLineas) + 1;
        }
        else
        {
            grupos = 1;
        }

        List<String> string_lineas = new List<String>();
        for (contador = 0; contador < grupos; contador++)
        {
            string_lineas.add('');
        }

        contador = 0;
        for (Invoice_Line__c il : query_invoice_lines)
        {
            string_pagina = string_lineas.get(contador / maxLineas);
            string_pagina += '                        <div class="linea">';
            string_pagina += '                            <div class="descripcion">' + NEU_Utils.safeString(il.Concept__c) + '</div>';
            string_pagina += '                            <div class="moneda">' + NEU_currencyUtils.getcurrencyIsoCode(il) + '</div>';
            if (il.VAT__c.equals('Non Applicable'))
            {
                string_pagina += '                            <div class="tipoImpuesto">NA</div>';
            }
            else
            {
                string_pagina += '                            <div class="tipoImpuesto">' + ((NEU_Utils.safeDecimal(il.Amount__c) * NEU_Utils.safeDecimal(il.VAT__c)) / 100) + '<br/>(' + il.VAT__c + '%)</div>';
            }
            if (il.VAT_Withholding__c != null)
            {
                string_pagina += '                            <div class="tipoRetencion">' + ((NEU_Utils.safeDecimal(il.Amount__c) * NEU_Utils.safeDecimal(il.VAT_Withholding__c)) / 100).setScale(2) + '<br/>(' + il.VAT_Withholding__c + '%)</div>';
            }
            else
            {
                string_pagina += '                            <div class="tipoRetencion">&nbsp;</div>';
            }
            if (il.VAT_Withholding_ISR__c != null)
            {
                string_pagina += '                            <div class="tipoRetencionISR">' + ((NEU_Utils.safeDecimal(il.Amount__c) * NEU_Utils.safeDecimal(il.VAT_Withholding_ISR__c)) / 100) + '<br/>(' + il.VAT_Withholding_ISR__c + '%)</div>';
            }
            else
            {
                string_pagina += '                            <div class="tipoRetencionISR">&nbsp;</div>';
            }
            string_pagina += '                            <div class="subtotal">' + String.format(NEU_Utils.safeDecimal(il.Amount__c).setScale(2).format(), plantilla) + '</div>';
            string_pagina += '                            <div class="impuesto">' + String.format(NEU_Utils.safeDecimal(il.Total_VAT__c).setScale(2).format(), plantilla) + '</div>';
            string_pagina += '                            <div class="precio">' + String.format(NEU_Utils.safeDecimal(il.Total_Incl_VAT__c).setScale(2).format(), plantilla) + '</div>';
            string_pagina += '                        </div>';
            string_lineas.set(contador / maxLineas, string_pagina);
            contador++;
        }

        string_linea_vacia = '';
        string_linea_vacia += '                        <div class="linea">';
        string_linea_vacia += '                            <div class="descripcion">&nbsp;</div>';
        string_linea_vacia += '                            <div class="moneda">&nbsp;</div>';
        string_linea_vacia += '                            <div class="tipoImpuesto">&nbsp;</div>';
        string_linea_vacia += '                            <div class="tipoRetencion">&nbsp;</div>';
        string_linea_vacia += '                            <div class="tipoRetencionISR">&nbsp;</div>';
        string_linea_vacia += '                            <div class="subtotal">&nbsp;</div>';
        string_linea_vacia += '                            <div class="impuesto">&nbsp;</div>';
        string_linea_vacia += '                            <div class="precio">&nbsp;</div>';
        string_linea_vacia += '                        </div>';

        string_pdf = '';
        string_pdf += '     <div id="container">';
        for (contador = 0; contador < grupos; contador++)
        {
            string_pdf += '            <table id="table_head">';
            string_pdf += '                <tr>';
            string_pdf += '                    <th><img src="/resource/1511434218000/p2goLogoPeq" class="logo"></img></th>';
            string_pdf += '                    <th  class="info">';
            string_pdf += '                        <h3>' + orgDetails.Name + '</h3>';
            string_pdf += '                        <p>' + NEU_Utils.safestring(orgDetails.Street) + '</p>';
            string_pdf += '                        <p>' + NEU_Utils.safestring(orgDetails.City) + ', C.P.' + NEU_Utils.safestring(orgDetails.PostalCode) + '</p>';
            string_pdf += '                    </th>';
            string_pdf += '                    <th><img src="/resource/1513603221000/NEU_Invoice_PDF_IATA"></img></th>';
            string_pdf += '                    <th>';
            string_pdf += '                        <h3>' + (record.Type__c != null ? record.Type__c : '') + '</h3>';
            string_pdf += '                        <div>';
            string_pdf += '                            <p><b>Folio </b>' + (record.Name != null ? record.Name : '') + '</p>';
            string_pdf += '                        </div>';
            string_pdf += '                    </th>';
            string_pdf += '                </tr>';
            string_pdf += '            </table>';

            string_pdf += '            <table id="table_body">';
            string_pdf += '                <tr>';
            string_pdf += '                    <td colspan="4">';
            string_pdf += '                        <h4>Shipper:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Supplier_Account__r.Name != null ? record.Import_Export_Quote_Order__r.Supplier_Account__r.Name : '') + '</p>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Supplier_Account__r.BillingStreet != null ? record.Import_Export_Quote_Order__r.Supplier_Account__r.BillingStreet : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="4">';
            string_pdf += '                        <h4>Date:</h4>';
            string_pdf += '                  <p>' + (record.Date_of_Invoice__c != null ? record.Date_of_Invoice__c.format() : '') + '</p>';
            string_pdf += '                        <h4>REF:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Name != null ? record.Import_Export_Quote_Order__r.Name : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                </tr>';
            string_pdf += '                <tr rowspan="2">';
            string_pdf += '                    <td colspan="4">';
            string_pdf += '                        <h4>Consignee:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Consignee__r.Name != null ? record.Import_Export_Quote_Order__r.Consignee__r.Name : '') + '</p>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Consignee__r.BillingStreet != null ? record.Import_Export_Quote_Order__r.Consignee__r.BillingStreet : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="4">';
            string_pdf += '                        <h4>Invoice To:</h4>';
            string_pdf += '                        <p>' + (record.Account__c != null ? record.Account__r.Name : '') + '</p>';
            if (record.Account__c != null)
            {
                string_pdf += '<p>';
                string_pdf += (record.Account__r.BillingStreet != null ? record.Account__r.BillingStreet : '');
                string_pdf += (record.Account__r.BillingCity != null ? ', ' + record.Account__r.BillingCity : '');
                string_pdf += (record.Account__r.BillingState != null ? ' (' + record.Account__r.BillingState + ') ' : '');
                string_pdf += (record.Account__r.BillingPostalCode != null ? ', ' + record.Account__r.BillingPostalCode : '');
                string_pdf += (record.Account__r.BillingCountry != null ? ', ' + record.Account__r.BillingCountry : '');
                string_pdf += '</p>';
            }
            else
            {
                string_pdf += '               <p>&nbsp;</p>';
            }
            string_pdf += '                    </td>';
            string_pdf += '                </tr>';
            string_pdf += '                <tr>';
            string_pdf += '                    <td colspan="3">';
            string_pdf += '                        <h4>Etd/Eta:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.ETD__c != null ? record.Import_Export_Quote_Order__r.ETD__c.format() : 'None') + ' / ' + (record.Import_Export_Quote_Order__r.Planned_ETA_SP__c != null ? record.Import_Export_Quote_Order__r.Planned_ETA_SP__c.format() : 'None') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="5">';
            string_pdf += '                        <h4>Freight terms:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.POD_Incoterm__c != null ? record.Import_Export_Quote_Order__r.POD_Incoterm__c : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                </tr>';
            string_pdf += '                <tr>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="3">';
            if (record.Import_Export_Quote_Order__r.Last_Shipment__r.Freight_Mode__c == 'Air')
            {
                string_pdf += '                        <h4>MAWB No.:</h4>';
                string_pdf += '                      <p>' + (record.Import_Export_Quote_Order__r.Last_Shipment__r.MAWB_Number__c != null ? record.Import_Export_Quote_Order__r.Last_Shipment__r.MAWB_Number__c : '') + '</p>';
            }
            else
            {
                string_pdf += '                        <h4>MBL No.:</h4>';
                string_pdf += '                      <p>' + (record.Import_Export_Quote_Order__r.Last_Shipment__r.MBL_Number__c != null ? record.Import_Export_Quote_Order__r.Last_Shipment__r.MBL_Number__c : '') + '</p>';
            }
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="5">';
            if (record.Import_Export_Quote_Order__r.Last_Shipment__r.Freight_Mode__c == 'Air')
            {
                //string_pdf += '                        <h4>HAWB No.:</h4>';
                //string_pdf += '                      <p>' + (record.Import_Export_Quote_Order__r.Last_Shipment__r.HAWB_Number__c != null ? record.Import_Export_Quote_Order__r.Last_Shipment__r.HAWB_Number__c : '') + '</p>';
            }
            else
            {
                string_pdf += '                        <h4>HBL No.:</h4>';
                string_pdf += '                      <p>' + (record.Import_Export_Quote_Order__r.Last_Shipment__r.HBL_Number__c != null ? record.Import_Export_Quote_Order__r.Last_Shipment__r.HBL_Number__c : '') + '</p>';
            }
            string_pdf += '                    </td>';
            string_pdf += '                </tr>';
            string_pdf += '                <tr>';
            string_pdf += '                    <td colspan="3">';
            string_pdf += '                        <h4>Commercial INV:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Last_Shipment__r.Account_Shipment_Reference__c != null ? record.Import_Export_Quote_Order__r.Last_Shipment__r.Account_Shipment_Reference__c : (record.Import_Export_Quote_Order__r.Customer_Reference__c != null ? record.Import_Export_Quote_Order__r.Customer_Reference__c : '')) + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="3">';
            string_pdf += '                        <h4>Origin:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Site_of_Load__r.Name != null ? record.Import_Export_Quote_Order__r.Site_of_Load__r.Name : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="2">';
            string_pdf += '                        <h4>Destination:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Site_of_Discharge__r.Name != null ? record.Import_Export_Quote_Order__r.Site_of_Discharge__r.Name : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                </tr>';
            string_pdf += '                <tr>';
            string_pdf += '                    <td colspan="6">';
            string_pdf += '                        <h4>Agent:</h4>';
            //string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Ag.Name != null ? record.Import_Export_Quote_Order__r.Agent_Account__r.Name : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="2"></td>';
            string_pdf += '                </tr>';
            string_pdf += '                <tr>';
            string_pdf += '                    <td colspan="2">';
            string_pdf += '                        <h4>Marks:</h4>';
            string_pdf += '                        <p>' + (record.Invoice_Concept__c != null ? record.Invoice_Concept__c : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="2">';
            string_pdf += '                        <h4>PCS:</h4>';
            string_pdf += '                        <p>' + NEU_Utils.safeString(record.Shipment__r.Total_Units_Shipped__c) + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="2">';
            string_pdf += '                        <h4>Content:</h4>';
            string_pdf += '                        <p>' + (record.Import_Export_Quote_Order__r.Nature_Merchandise__c != null ? record.Import_Export_Quote_Order__r.Nature_Merchandise__c : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="1">';
            string_pdf += '                        <h4>Gross Weight:</h4>';
            /*
            if (record.Import_Export_Quote_Order__r.ShowUSCS__c == true && record.Import_Export_Quote_Order__r.Freight_Mode__c == 'Road')
                string_pdf += '                        <p>' + (record.Shipment__r.Total_Weight_Kg__c != null ? NEU_Utils.safeString(EPutils.kgToPounds(record.Shipment__r.Total_Weight_Kg__c, true)) + ' Lb' : '') + '</p>';
            else
            */
                    string_pdf += '                        <p>' + (record.Shipment__r.Total_Weight_Kg__c != null ? NEU_Utils.safeString(record.Shipment__r.Total_Weight_Kg__c) + ' KG' : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                    <td colspan="1">';
            string_pdf += '                        <h4>Volume:</h4>';
            /*
            if (record.Import_Export_Quote_Order__r.ShowUSCS__c == true && record.Import_Export_Quote_Order__r.Freight_Mode__c == 'Road')
                string_pdf += '                        <p>' + (record.Shipment__r.Total_Volume_m3__c != null ? NEU_Utils.safeString(EPutils.meters3tofeet(record.Shipment__r.Total_Volume_m3__c, true)) + ' CFT' : '') + '</p>';
            else
            */
                    string_pdf += '                        <p>' + (record.Shipment__r.Total_Volume_m3__c != null ? NEU_Utils.safeString(record.Shipment__r.Total_Volume_m3__c) + ' CBM' : '') + '</p>';
            string_pdf += '                    </td>';
            string_pdf += '                </tr>';
            string_pdf += '                <tr class="lineas">';
            string_pdf += '                    <td colspan="8">';
            // LÍNEAS
            string_pdf += '                        <div class="linea" style="margin-top: -5px;">';
            string_pdf += '                            <div class="descripcion"><h4>Concept</h4></div>';
            string_pdf += '                            <div class="moneda"><h4>Currency</h4></div>';
            string_pdf += '                            <div class="tipoImpuesto"><h4>VAT</h4></div>';
            string_pdf += '                            <div class="tipoRetencion"><h4>WHT</h4></div>';
            string_pdf += '                            <div class="tipoRetencionISR"><h4>ISR</h4></div>';
            string_pdf += '                            <div class="subtotal"><h4>Subtotal</h4></div>';
            string_pdf += '                            <div class="impuesto"><h4>Total VAT</h4></div>';
            string_pdf += '                            <div class="precio"><h4>Total (Incl. VAT)</h4></div>';
            string_pdf += '                        </div>';
            string_pdf += string_lineas.get(contador);
            // TOTALES
            if (contador == grupos - 1)
            {
                string_pdf += string_linea_vacia;
                string_pdf += string_linea_vacia;
                /*
                string_pdf += '                        <div class="linea">';
                string_pdf += '                            <div class="descripcion" style="font-weight: bold;">Tax summary:</div>';
                string_pdf += '                            <div class="moneda" style="font-weight: bold;">S = '+NEU_Utils.safeDecimal(record.Standard_S__c)+'</div>';
                string_pdf += '                            <div class="tipoImpuesto" style="font-weight: bold;">Z = '+NEU_Utils.safeDecimal(record.Zero_Z__c)+'</div>';
                string_pdf += '                            <div class="subtotal" style="font-weight: bold;">N = '+NEU_Utils.safeDecimal(record.Non_Applicable_N__c)+'</div>';
                string_pdf += '                            <div class="impuesto" style="font-weight: bold;">&nbsp;</div>';
                string_pdf += '                            <div class="precio">&nbsp;</div>';
                string_pdf += '                        </div>';
                string_pdf += string_linea_vacia;
                */
                string_pdf += '                        <div class="linea">';
                string_pdf += '                            <div class="descripcion" style="font-weight: bold;">Total (Excl. VAT)</div>';
                string_pdf += '                            <div class="moneda">&nbsp;</div>';
                string_pdf += '                            <div class="tipoImpuesto">&nbsp;</div>';
                string_pdf += '                            <div class="tipoRetencion">&nbsp;</div>';
                string_pdf += '                            <div class="tipoRetencionISR">&nbsp;</div>';
                string_pdf += '                            <div class="subtotal">&nbsp;</div>';
                string_pdf += '                            <div class="impuesto">&nbsp;</div>';
                string_pdf += '                            <div class="precio" style="font-weight: bold;">' + NEU_Utils.safeDecimal(record.Total_Excl_VAT__c) + ' ' + NEU_Utils.safeString(NEU_CurrencyUtils.getCurrencyIsoCode(record)) + '</div>';
                string_pdf += '                        </div>';
                string_pdf += '                        <div class="linea">';
                string_pdf += '                            <div class="descripcion" style="font-weight: bold;">Total VAT</div>';
                string_pdf += '                            <div class="moneda">&nbsp;</div>';
                string_pdf += '                            <div class="tipoImpuesto">&nbsp;</div>';
                string_pdf += '                            <div class="tipoRetencion">&nbsp;</div>';
                string_pdf += '                            <div class="tipoRetencionISR">&nbsp;</div>';
                string_pdf += '                            <div class="subtotal">&nbsp;</div>';
                string_pdf += '                            <div class="impuesto">&nbsp;</div>';
                string_pdf += '                            <div class="precio" style="font-weight: bold;">' + NEU_Utils.safeDecimal(record.Total_VAT__c) + ' ' + NEU_Utils.safeDecimal(NEU_CurrencyUtils.getCurrencyIsoCode(record)) + '</div>';
                string_pdf += '                        </div>';
                string_pdf += string_linea_vacia;
                string_pdf += '                        <div class="linea">';
                string_pdf += '                            <div class="descripcion" style="font-weight: bold;">' + NEU_Utils_NumberToWords.english_currency(NEU_Utils.safeDecimal(record.Total_Incl_VAT__c)) + ' / ' + NEU_Utils.safeString(NEU_CurrencyUtils.getCurrencyIsoCode(record)) + '</div>';
                string_pdf += '                            <div class="moneda">&nbsp;</div>';
                string_pdf += '                            <div class="tipoImpuesto">&nbsp;</div>';
                string_pdf += '                            <div class="tipoRetencion">&nbsp;</div>';
                string_pdf += '                            <div class="tipoRetencionISR">&nbsp;</div>';
                string_pdf += '                            <div class="subtotal">&nbsp;</div>';
                string_pdf += '                            <div class="impuesto">&nbsp;</div>';
                string_pdf += '                            <div class="precio" style="font-weight: bold;">' + NEU_Utils.safeDecimal(record.Total_Incl_VAT__c) + ' ' + NEU_Utils.safeString(NEU_CurrencyUtils.getCurrencyIsoCode(record)) + '</div>';
                string_pdf += '                        </div>';
                string_pdf += '                    </td>';
            }
            string_pdf += '                </tr>';
            string_pdf += '            </table>';
            if (contador < grupos - 1)
            {
                string_pdf += '<div style="page-break-after: always!important;"/>';
            }
        }
        string_pdf += '  </div>';
    }
}