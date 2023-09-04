/**
 * Created by aserrano on 14/12/2017.
 */

public with sharing class NEU_Air_Manifest_pdf_ES
{
    public Air_Waybill__c record;
    public string manifest {get;set;}
    public List<Air_Waybill_Line__c> lineas;

    ApexPages.StandardController con;

    public NEU_Air_Manifest_pdf_ES(ApexPages.StandardController stdController)
    {

        con = stdController;

        /*try
        {
            record = [SELECT Id, Name, Shipment__r.Account_for__r.Name, Shipment__r.Account_for__r.BillingStreet, Shipment__r.Account_for__r.BillingCity,
                    Shipment__r.Account_for__r.BillingState, Shipment__r.Account_for__r.BillingPostalCode, Shipment__r.Account_for__r.BillingCountry,
                    Waybill_Master__r.Name, Site_of_Destination__r.Name, Flight_Number__c, Date_of_Flight__c,
                    Carrier_Account__r.Name, Shipper_Account__r.Name, Shipper_Account_Address__c, Shipper_Account__r.TAX_ID__c,
                    Consignee_Account_Address__c, Consignee_Account__r.TAX_ID__c, Consignee_Account__r.Name,
                    MAWB_Number__c, Total_Number_of_Pieces__c, Total_Gross_Weight__c, Payment__c FROM Air_Waybill__c WHERE id = :con.getRecord().Id]; //House_Reference__c

        }
        catch(Exception ee){record = new Air_Waybill__c();}

        lineas = [SELECT Id, Name, No_of_Pieces__c, Gross_Weight__c, Description__c from Air_Waybill_Line__c
            WHERE Air_Waybill__c =: record.Id]; //Commodity_Item_No__c

        integer cont = 0;

        //PageReference.forResource('quotation_map').getUrl()

        manifest = '';
        manifest += '<div class="pagina">';
        manifest += '<h1 class="title">AIR CARGO MANIFEST</h1>';
        manifest += '<div class="content">';
        manifest += '<table class="tabla">';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1 colorAmarillo">';
        manifest += '       <p class="header center">CONSIGNED TO:</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1 colorAmarillo">';
        manifest += '       <p class="header center">MAWB' + NEU_Utils.safeString(record.MAWB_Number__c) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Shipment__r.Account_for__r.Name) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        //manifest += '       <p class="data"><span class="negra">HAWB: </span>'+ NEU_Utils.safeString(record.House_Reference__c) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Shipment__r.Account_for__r.BillingStreet) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data"><span class="negra">DESTINATION: </span>'+ NEU_Utils.safeString(record.Site_of_Destination__r.Name) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Shipment__r.Account_for__r.BillingPostalCode)
                + ' ' + NEU_Utils.safeString(record.Shipment__r.Account_for__r.BillingCity) + ' ' + NEU_Utils.safeString(record.Shipment__r.Account_for__r.BillingState) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data"><span class="negra">FLIGHT NO: </span>'+ NEU_Utils.safeString(record.Flight_Number__c) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Shipment__r.Account_for__r.BillingCountry) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data"><span class="negra">FLIGHT DATE: </span>'+ NEU_Utils.safeString(record.Date_of_Flight__c) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data"><span class="negra">CARRIER: </span>'+ NEU_Utils.safeString(record.Carrier_Account__r.Name) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';


        manifest += '  <tr class="espacio">';
        manifest += '    <td>';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td>';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td>';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '  </tr>';


        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1 colorAmarillo">';
        manifest += '       <p class="header center">SHIPPER:</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1 colorAmarillo">';
        manifest += '       <p class="header center">CONSIGNEE:</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Shipper_Account__r.Name) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Consignee_Account__r.Name) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Shipper_Account_Address__c) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">'+ NEU_Utils.safeString(record.Consignee_Account_Address__c) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';

        manifest += '  <tr class="zona1">';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">RFC: '+ NEU_Utils.safeString(record.Shipper_Account__r.TAX_ID__c) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="espacio noBorder">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '    <td class="zona1">';
        manifest += '       <p class="data">RFC: '+ NEU_Utils.safeString(record.Consignee_Account__r.TAX_ID__c) +'</p>';
        manifest += '    </td>';
        manifest += '  </tr>';
        manifest += '</table>';

        //Id, Name, Commodity_Item_No__c, No_of_Pieces__c, Gross_Weight__c, Description__c

        manifest += '<div class="lineas">';

        manifest += '<table class="tabla2">';
        manifest += '  <tr>';
        manifest += '    <td class="header col1">';
        manifest += '       <p class="header center">Item Code</p>';
        manifest += '    </td>';
        manifest += '    <td class="header col2">';
        manifest += '       <p class="header center">Nº of Pkg</p>';
        manifest += '    </td>';
        manifest += '    <td class="header col3">';
        manifest += '       <p class="header center">Weight (kg)</p>';
        manifest += '    </td>';
        manifest += '    <td class="header col4">';
        manifest += '       <p class="header center">Commodity</p>';
        manifest += '    </td>';
        manifest += '    <td class="header col5">';
        manifest += '       <p class="header center">PP/CC</p>';
        manifest += '    </td>';
        manifest += '  </tr>';


        //Imprimir las lineas

        for (Air_Waybill_Line__c line : lineas)
        {
            manifest += '  <tr>';
            manifest += '    <td class="data">';
            //manifest += '       <p class="data center">'+ NEU_Utils.safeString(line.Commodity_Item_No__c) +'</p>';
            manifest += '    </td>';
            manifest += '    <td class="data">';
            manifest += '       <p class="data center">'+ NEU_Utils.safeString(line.No_of_Pieces__c) +'</p>';
            manifest += '    </td>';
            manifest += '    <td class="data">';
            manifest += '       <p class="data center">'+ NEU_Utils.safeString(line.Gross_Weight__c) +'</p>';
            manifest += '    </td>';
            manifest += '    <td class="data">';
            manifest += '       <p class="data center">'+ NEU_Utils.safeString(line.Description__c) +'</p>';
            manifest += '    </td>';
            manifest += '    <td class="data">';
            manifest += '       <p class="data center">'+ (record.Payment__c=='Prepaid'?'PP':'CC') +'</p>';
            manifest += '    </td>';
            manifest += '  </tr>';
        }

        manifest += '  </table>';

        manifest += '  <table class="tabla3">';
        manifest += '  <tr>';
        manifest += '    <td class="header col1 colorAmarillo">';
        manifest += '       <p class="header center">TOTAL:</p>';
        manifest += '    </td>';
        manifest += '    <td class="header col2">';
        manifest += '       <p class="header center">'+ NEU_Utils.safeString(record.Total_Number_of_Pieces__c) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="header col3">';
        manifest += '       <p class="header center">'+ NEU_Utils.safeString(record.Total_Gross_Weight__c) +'</p>';
        manifest += '    </td>';
        manifest += '    <td class="data col4">';
        manifest += '       ';
        manifest += '    </td>';
        manifest += '  </tr>';
        manifest += '</table>';

        manifest += '</div>';

        manifest += '		<p class="footer">GRUPO PGLM S.A. DE C.V. , Calle Argentina no. 205-1 Col. Industrial Martel, Santa Catarina, Nuevo León, C.P. 66367 RFC: GPG-120220-8X7, Internet: www.pak2go.com.mx. All Business carried out is subject to the general terms and conditions of GRUPO PGLM S.A. DE C.V. as well as the norms established in the corresponding transport document. A copy of the most recent version of our terms and conditions is available through your written commercial business record.</p>';
        manifest += '</div>';
        manifest += '</div>';*/
    }
}