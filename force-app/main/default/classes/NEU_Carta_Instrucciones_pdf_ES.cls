/**
 * Created by aserrano on 20/11/2017.
 */

public with sharing class NEU_Carta_Instrucciones_pdf_ES
{
    public Shipment__c record;
    public string carta {get;set;}

    ApexPages.StandardController con;

    public NEU_Carta_Instrucciones_pdf_ES(ApexPages.StandardController stdController)
    {

        con = stdController;

        try
        {
            record = [SELECT Id, Name, Account_for__r.Name, Contact__r.Name, Contact__r.Email, Contact__r.Phone,
                    Supplier_Account__c, Supplier_Account__r.Name, Supplier_Account__r.BillingAddress,
                    Supplier_Account__r.NEU_Email__c, Supplier_Account__r.Phone, Consignee__c, Consignee__r.Name,
                    Consignee__r.NEU_Email__c, Consignee__r.Phone, Consignee_Contact__r.Name, Consignee_Contact__r.Phone,
                    Consignee_Contact__r.Email, Truck_Vessel_Flight__r.Name, Voyage_Number_s__c, Site_of_Load__r.Name,
                    Country_of_Load__r.Name, Site_of_Discharge__r.Name, Country_of_Discharge__r.Name, ETD_from_Point_of_Load__c,
                    ETA_Point_of_Discharge__c, Total_Weight_Kg__c, Delivery_Cartage__r.Name, Shipper_Contact__r.Name,
                    Shipper_Contact__r.Phone, Shipper_Contact__r.Email, Sales_Incoterm__c, Equip_Loaded__c, Nature_Merchandise__c,
                    Customs_Broker__c, Drayage__c, Free_Days__c, Instruction_Letter_Notes__c, Pickup_Cartage__r.Name,
                    Total_Units_Shipped__c, Container_Type__r.Name, Total_Volume_m3__c FROM Shipment__c WHERE id = :con.getRecord().Id];

        }
        catch(Exception ee){record = new Shipment__c();}

        integer cont = 0;

        //PageReference.forResource('quotation_map').getUrl()

        carta = '';
        carta += '<div class="pagina">';
        carta += '<h1 class="title">CARTA DE INSTRUCCIONES / EMBARQUE NUEVO</h1>';
        carta += '<div class="content">';
        carta += '<table class="tabla">';
        carta += '  <tr style="height:30px">';
        carta += '    <td colspan="4" class="center">';
        carta += '       <p class="title">INFORMACIÓN GENERAL</p>';
        carta += '    </td>';
        carta += '  </tr>';
        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers colorAmarillo">';
        carta += '       <p class="header">CLIENTE:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Account_for__r.Name) +'</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers colorAmarillo">';
        carta += '       <p class="header">SHIPPER:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Supplier_Account__r.Name) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">CONTACTO:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Contact__r.Name) +'</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">CONTACTO:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Shipper_Contact__r.Name) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">EMAIL:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Contact__r.Email) +'</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">EMAIL:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Shipper_Contact__r.Email) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">TELÉFONO:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Contact__r.Phone) +'</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">TELÉFONO:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Shipper_Contact__r.Phone) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">INCOTERM:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Sales_Incoterm__c) +'</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';
        carta += '       ';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       ';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="espacio">';
        carta += '    <td colspan="4">';
        carta += '       ';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers colorAmarillo">';
        carta += '       <p class="header">CONSIGNEE:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Consignee__r.Name) +'</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="header"> <span style="margin-right: 15px;">AGENTE ADUANAL:</span>' +
                (record.Customs_Broker__c==true?' SI':' NO') + '</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">CONTACTO:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Consignee_Contact__r.Name) +'</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="header">(FAVOR INDICAR SI ESTÁ INCLUIDO EN SERVICIO)</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">EMAIL:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Consignee_Contact__r.Email) +'</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';

        Contact aduana;

        //Agente aduanal
        if(record.Account_for__r.Id != null && record.Customs_Broker__c == true)
        {
            List<Contact> listAduana = [SELECT Id, Name, Phone, Email FROM Contact WHERE Account.Id =:record.Account_for__r.Id AND Customs_Broker__c = true];
            if(listAduana.size()>0)
            {
                aduana = listAduana[0];
            }
            else
            {
                aduana = new Contact();
            }
        }
        else
        {
            aduana = new Contact();
        }

        carta += '       <p class="data">'+ NEU_Utils.safeString(aduana.Name) +'</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data">' + NEU_Utils.safeString(aduana.Phone) + '</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">TELÉFONO:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Consignee_Contact__r.Phone) +'</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="data">' + NEU_Utils.safeString(aduana.Email) + '</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="espacio">';
        carta += '    <td colspan="4">';
        carta += '       ';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr style="height:30px">';
        carta += '    <td colspan="4" class="center">';
        carta += '       <p class="title">INFORMACIÓN OPERATIVA</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">ORIGEN:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">' + NEU_Utils.safeString(record.Pickup_Cartage__r.Name) + '</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">CARGA LISTA:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Equip_Loaded__c) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">POL:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">DIAS LIBRES:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeDecimal(record.Free_Days__c) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">POD:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">DELIVERY:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Delivery_Cartage__r.Name) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td class="zona1Headers">';
        carta += '       <p class="header">ARRASTRE:</p>';
        carta += '    </td>';
        carta += '    <td class="zona1Data">';
        carta += '       <p class="data center">'+ NEU_Utils.safeString(record.Drayage__c) +'</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Headers center">';
        carta += '       <img src="' + Site.getBaseUrl()+ '/img/checkbox_checked.gif' + '"/><label style="vertical-align: 3px; margin-right: 15px">Dentro de BL</label>';
        carta += '       <img src="' + Site.getBaseUrl()+ '/img/checkbox_unchecked.gif' + '"/><label style="vertical-align: 3px;">Fuera de BL</label>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="espacio">';
        carta += '    <td colspan="4">';
        carta += '       ';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="header">PRODUCTO / COMMODITY:</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Data">';
        carta += '       <p class="data">'+ NEU_Utils.safeString(record.Nature_Merchandise__c) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="header">NÚMERO DE ORDEN / PURCHASE ORDER:</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Data">';
        carta += '       <p class="data">'+ record.Name +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="header">EQUIPO CANTIDAD Y TIPO DE CNTR(FCL):</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Data">';
        carta += '       <p class="data">'+ (record.Total_Units_Shipped__c!=null?'Units: '+ record.Total_Units_Shipped__c:'')
                        + (record.Container_Type__r.Name!=null?' CNTR: '+record.Container_Type__r.Name:'') +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="header">CARGA DIMENSIONES (LCL):</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Data">';
        carta += '       <p class="data">'+ (record.Total_Volume_m3__c!=null?record.Total_Volume_m3__c+' m3':'') +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td colspan="2" class="zona1Headers">';
        carta += '       <p class="header">PESO:</p>';
        carta += '    </td>';
        carta += '    <td colspan="2" class="zona1Data">';
        carta += '       <p class="data">' + (record.Total_Weight_Kg__c!=null?record.Total_Weight_Kg__c+' Kg':'') + '</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="espacio">';
        carta += '    <td colspan="4">';
        carta += '       ';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td colspan="4" class="zona1Headers">';
        carta += '       <p class="header">INSTRUCCIONES ESPECIALES:</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '  <tr class="zona1">';
        carta += '    <td colspan="4" class="vTop" style="height:100px">';
        carta += '       <p class="data">'+ NEU_Utils.safeString(record.Instruction_Letter_Notes__c) +'</p>';
        carta += '    </td>';
        carta += '  </tr>';

        carta += '</table>';
        carta += '</div>';
        carta += '</div>';


    }
}