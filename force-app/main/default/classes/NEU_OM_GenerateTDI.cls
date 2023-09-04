public with sharing class NEU_OM_GenerateTDI {

    public Transport_Packaging_Data__c record;//transporter
    public string resultado {get;set;}
    public string informe_tdi {get;set;}
    public string id_shipment {get;set;}
    
    ApexPages.StandardController con;
    
    public NEU_OM_GenerateTDI(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Transporter__c, Shipment__c, Special_Instructions__c, Shipment__r.Carriers_OI__c, Shipment__r.Number__c, Ship_to_Door_Location__c, Ship_from_Door_Address__c, Ship_to_Door_Location__r.Name, Ship_to_Door_Address__c, Container_Pallets__c, Container_Pallets__r.Name, Ship_from_Door_Location__c, Ship_from_Door_Location__r.Name, Cargo_Description__c, Shipment__r.Track_Option__c, Container_Nbrs__c, Shipment__r.Account_for__r.Name, Shipment__r.Truck_Vessel_Flight_Name__c, Shipment__r.Site_of_Load__c, Shipment__r.Site_of_Load__r.Name, Transporter__r.Name, Total_Weight_Items_Kg__c, Shipment__r.Name from Transport_Packaging_Data__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Transport_Packaging_Data__c();
        }
        
        informe_tdi = '';
        string id_transporter = ''; 
        string t_rate = '';
        string delivery_collection_address = '';
        string special_instructions = '';
        integer cont = 0;
        string tgc_file_number = '';
        
        /*if(ApexPages.currentPage().getParameters().get('ids') != null)
            id_shipment = ApexPages.currentPage().getParameters().get('ids');
            
        List<Shippment_Line__c> shipment_packaging_data = new List<Shippment_Line__c>();
        shipment_packaging_data = [select Id, Name, Transport_delivery_Address__r.Address__c, Shipment__c, Shipment__r.Name, Transport_Rate_Amount__c, Transporter__c, Special_Instructions__c, Container_Type__c, Shipment__r.Transport_Delivery_Addres_Value__c, Shipment__r.Shipping_Line_Name__c, Shipment__r.Vessel_Name__c, Shipment__r.Customer_Name__c, Shipment__r.Port_of_Load_Text__c, Container_Nbr__c, Gross_Mass__c, Empty_Depot__c, Buy_rate__c, Delivery_Collection_Address__c, Shipment__r.Master_Bill__c, Shipment__r.Description__c from Shippment_Line__c where Transporter__c =: record.Id and Shipment__c =: id_shipment];
        
        //SPECIAL INSTRUCTIONS
        for(Shippment_Line__c spd : shipment_packaging_data)
        {
            if(spd.Special_Instructions__c != null)
                special_instructions += '(<strong>'+spd.Container_Nbr__c+'</strong>) '+spd.Special_Instructions__c+'<br/><br/>';
        }       
        */
        
        informe_tdi += '<div id="contenedor_pdf" style="display:block; margin: 0 auto; padding: 0; width: 700px; height:100%;">';
        informe_tdi += '    <div style="margin: 0px auto 0px; padding:0; background: #FFFFFF; border:1px solid black; width:700px;">';
        informe_tdi += '        <table cellspacing="0" cellpadding="0" border="0" style="margin: 10px; width:680px;">';
        informe_tdi += '            <tr>';
        informe_tdi += '                <td>';
        informe_tdi += '                    <table cellspacing="0" cellpadding="0" border="0">';
        informe_tdi += '                        <tr>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:14px; text-align:left; font-weight: bold; padding: 0 0 5px 0;" colspan="2">NEURORED</td>';
        informe_tdi += '                        </tr>';
        informe_tdi += '                        <tr>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Reg No: </td>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Vat No: </td>';
        informe_tdi += '                        </tr>';
        informe_tdi += '                        <tr>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Tel No: </td>';
        informe_tdi += '                        </tr>';
        informe_tdi += '                        <tr>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Fax No: </td>';
        informe_tdi += '                        </tr>';
        informe_tdi += '                        <tr>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Electronic Fax: </td>';
        informe_tdi += '                        </tr>';
        informe_tdi += '                        <tr>';
        informe_tdi += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Email:</td>';
        informe_tdi += '                            <td></td>';
        informe_tdi += '                        </tr>';
        informe_tdi += '                    </table>';
        informe_tdi += '                </td>';
        informe_tdi += '                <td style="text-align: right;"><img src="'+Site.getBaseUrl()+'/servlet/servlet.ImageServer?id=015b0000000AeRa&oid=00Db0000000cLrt&lastMod=1386235275000"/></td>';
        informe_tdi += '            </tr>';                                     
        informe_tdi += '        </table>';
        informe_tdi += '    </div>';
        informe_tdi += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:23px; width:700px; text-align:center; font-weight:bold; margin:5px 0 5px 0;">Transporter Delivery Instruction</p>';
        
        /*for(Shippment_Line__c spd : shipment_packaging_data)
        {
            if(cont == 0)
            {*/
                informe_tdi += '    <table border="0" cellspacing="0" cellpadding="5">';
                informe_tdi += '        <tr>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Date</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+System.Now().format('dd/MM/yyyy', 'GMT+2')+'</td>';
                informe_tdi += '        </tr>';
                informe_tdi += '        <tr>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Our Reference</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"><strong>'+record.Shipment__r.Name+'</strong></td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Vessel Operator</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Shipment__r.Carriers_OI__c+'</td>';//+(spd.Shipment__r.Shipping_Line_Name__c != null ? spd.Shipment__r.Shipping_Line_Name__c : '')+
                informe_tdi += '        </tr>';
                informe_tdi += '        <tr>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Transporter</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Transporter__r.Name+'</td>';
                informe_tdi += '        </tr>';
                informe_tdi += '    </table>';
                informe_tdi += '    <table border="0" cellspacing="0" cellpadding="5" style="border:1px solid black; width:100%;">';
                informe_tdi += '        <tr>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Shipment__r.Track_Option__c+'</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Shipment__r.Number__c != null ? record.Shipment__r.Number__c : '')+'</td>';///*+(spd.Shipment__r.Master_Bill__c != null ? spd.Shipment__r.Master_Bill__c : '')+*/
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Port of Loading</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Shipment__r.Site_of_Load__c != null ? record.Shipment__r.Site_of_Load__r.Name : '')+'</td>';
                informe_tdi += '        </tr>';
                informe_tdi += '        <tr>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Vessel and Voyage Nbr</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Shipment__r.Truck_Vessel_Flight_Name__c != null ? record.Shipment__r.Truck_Vessel_Flight_Name__c : '')+'</td>';
                informe_tdi += '        </tr>';
                informe_tdi += '        <tr>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Account</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
                informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Shipment__r.Account_for__r.Name != null ? record.Shipment__r.Account_for__r.Name  : '')+'</td>';
                informe_tdi += '        </tr>';
                informe_tdi += '    </table>';
                informe_tdi += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; font-weight:bold; margin:5px 0 5px 0; text-decoration:underline;">Special Instructions</p>';
                informe_tdi += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; margin:5px 0 5px 0;"><strong>'+(record.Container_Nbrs__c != null ? '('+record.Container_Nbrs__c+')' :'')+'</strong> '+(record.Special_Instructions__c != null ? record.Special_Instructions__c : '')+'<br/><br/></p>';
                informe_tdi += '    <div>';
                informe_tdi += '    <table border="0" cellspacing="0" cellpadding="5" style="border:1px solid black; width:100%;">';
                informe_tdi += '        <tr>';
                informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Container No</th>';
                informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Description</th>';
                informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Container Type</th>';
                informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Mass</th>';
                informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Turn In Deport</th>';
                informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Rate</th>';
                informe_tdi += '        </tr>';
        //  }
            
            informe_tdi += '        <tr>';
            informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Container_Nbrs__c != null ? record.Container_Nbrs__c : '')+'</td>';
            informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Cargo_Description__c != null ? record.Cargo_Description__c : '')+'</td>';
            informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Container_Pallets__c != null ? record.Container_Pallets__r.Name : '')+'</td>';///*+(spd.Container_Type__c != null ? spd.Container_Type__c : '')+*/
            informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Total_Weight_Items_Kg__c != null ? record.Total_Weight_Items_Kg__c : 0.00)+'</td>';
            informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';///*+(spd.Empty_Depot__c != null ? spd.Empty_Depot__c : '')+*/
            informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">  + VAT</td>';///*+(spd.Transport_Rate_Amount__c != null ? spd.Transport_Rate_Amount__c : 0.00)+*/
            informe_tdi += '        </tr>'; 
            
            /*if(spd.Transport_delivery_Address__c != null)
                delivery_collection_address += '(<strong>'+(spd.Container_Nbr__c != null ? spd.Container_Nbr__c : '')+'</strong>) '+(spd.Transport_delivery_Address__r.Address__c != null ? spd.Transport_delivery_Address__r.Address__c : '')+'<br/>';
                
            tgc_file_number = spd.Name;
            
            cont++;*/
        //} 
        
        informe_tdi += '    </table>';
        informe_tdi += '    </div>';
        informe_tdi += '    <table border="0" cellspacing="0" cellpadding="5" style="border:1px solid black; width:100%; margin:5px 0 0 0;">';
        
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; vertical-align:top; width: 104px;">Deliver from:</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"> '+(record.Ship_from_Door_Location__c != null ? record.Ship_from_Door_Location__r.Name :'')+' '+(record.Ship_from_Door_Address__c != null ? record.Ship_from_Door_Address__c :'')+'</td>';// <strong>'+(record.Container_Nbrs__c != null ? '('+record.Container_Nbrs__c+')' : '')+'</strong>
        informe_tdi += '        </tr>';
        
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; vertical-align:top; width: 104px;">Deliver to:</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"> '+(record.Ship_to_Door_Location__c != null ? record.Ship_to_Door_Location__r.Name :'')+' '+(record.Ship_to_Door_Address__c != null ? record.Ship_to_Door_Address__c :'')+'</td>';//<strong>'+(record.Container_Nbrs__c != null ? '('+record.Container_Nbrs__c+')' : '')+'</strong>
        informe_tdi += '        </tr>';
        
    
        informe_tdi += '    </table>';
        informe_tdi += '    <table border="0" cellspacing="0" cellpadding="5" style="width:100%; margin:5px 0 0 0;">';
        informe_tdi += '        <tr>';
        informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; text-decoration: underline;" colspan="2">Terms and Conditions:</th>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">1.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; font-weight:bold;">Do NOT subcontract this CARGO / CONTAINER / GOODS without explicit written instructions from Neurored</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">2.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Container to be turned into correct depot. All additional charges for your account </td>';//+ R500.00
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">3.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">JHB turn-ins returned to a depot in DBN will be subject to an administration fee of 40% (Shipping line and Neurored). Refund given once received from Shipping Line.</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">4.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Should there be a need to turn a container into any depot other than the nominated depot a request needs to be sent to operations@neurored.com</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">5.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">All written instructions to be adhered to. No verbal instruction will be accepted.</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">6.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Rates may not be altered, as this additional charge will be refuted.</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">7.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">No standing time charges will be accepted unless approved in writing and emailed to logistics@neurored.com</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">8.</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">In the event of damages and/or loss of cargo please email to claims@neurored.com</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;" colspan="2">No responsibility for damage or shortage will be accepted unless the delivery note is endorsed accordingly</th>';
        informe_tdi += '        </tr>';
        informe_tdi += '    </table>';
        informe_tdi += '    <table border="0" cellspacing="0" cellpadding="5" style="width:100%; margin:50px 0 0 0;">';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; width:20%;">'+System.Now().format('dd/MM/yyyy HH:mm a', 'GMT+2')+'</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; width:20%;"></td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; width:20%;"></td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; width:20%;"></td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; width:20%;"></td>';
        informe_tdi += '        </tr>';
        informe_tdi += '        <tr>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; vertical-align:top; width:20%; border-top:1px solid black;">Date / Time:</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; width:20%;"></td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; vertical-align:top; width:20%; border-top:1px solid black;">Name (Print):</td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; width:20%;"></td>';
        informe_tdi += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; vertical-align:top; width:20%; border-top:1px solid black;">Received in Good order and Condition Signature:</td>';
        informe_tdi += '        </tr>';
        informe_tdi += '    </table>';
        informe_tdi += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; margin:5px 0 0 0; text-decoration: underline; font-weight:bold;">Document Generated by: '+System.Userinfo.getName()+' ('+record.Name+')</p>';
        informe_tdi += '</div>';
    }
    
    public Pagereference update_shipment()
    {
        /*if(ApexPages.currentPage().getParameters().get('ids') != null)
            id_shipment = ApexPages.currentPage().getParameters().get('ids');
            
        List<Shippment__c> shipments = new List<Shippment__c>();
        shipments = [select Id, Name, TDI_Created__c from Shippment__c where Id =: id_shipment];
        
        try
        {
            for(Shippment__c s : shipments)
            {
                s.TDI_Created__c = system.now();
            }
            
            update shipments;
        }
        catch(Exception ex)
        {   
        }*/
        
        return null;
    }
}