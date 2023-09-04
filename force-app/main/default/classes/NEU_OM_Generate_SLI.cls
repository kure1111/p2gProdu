public with sharing class NEU_OM_Generate_SLI {

public Shipment__c record;
    public string resultado {get;set;}
    public string informe_sli {get;set;}
    
    ApexPages.StandardController con;
    
    public NEU_OM_Generate_SLI(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Account_for__c, Account_for__r.Name, Truck_Vessel_Flight__c, Carriers_OI__c, Track_Option__c, Destination_Address__c, Number__c, Account_Shipment_Reference__c, Truck_Vessel_Flight__r.Name, Truck_Vessel_Flight_ETA__c,  Site_of_Load__c, Site_of_Load__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name, Freight_Mode__c  from Shipment__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }
        
        string id_shipment;
        informe_sli = '';
        string id_transporter = '';
        string delivery_collection_address = '';
        string vessel_agent_name = '';
        string remittance_number = '';
        string transportistas = '';
        integer cont = 0;
                
        List<Transport_Packaging_Data__c>   shipment_packaging_data = new List<Transport_Packaging_Data__c>();
        shipment_packaging_data = [select Id, Name, Shipment__c, Transporter__c, Transporter__r.Name, Container_Nbrs__c from Transport_Packaging_Data__c where Shipment__c =: record.Id];
        
        for(Transport_Packaging_Data__c spd : shipment_packaging_data)
        {
            if(spd.Transporter__c != null)
            {
                if(transportistas.contains(spd.Transporter__r.Name) == false)
                {
                    if(transportistas == '')
                        transportistas += spd.Transporter__r.Name;
                    else
                        transportistas += ', '+spd.Transporter__r.Name;
                }
            }
        }
        
        informe_sli += '<div id="contenedor_pdf" style="display:block; margin: 0 auto; padding: 0; width: 700px; height:100%;">';
        informe_sli += '    <div style="margin: 0px auto 0px; padding:0; background: #FFFFFF; width:700px; border: 1px solid black;">';
        informe_sli += '        <table cellspacing="0" cellpadding="0" border="0" style="margin: 10px; width:680px;">';
        informe_sli += '            <tr>';
        informe_sli += '                <td>';
        informe_sli += '                    <table cellspacing="0" cellpadding="0" border="0">';
        informe_sli += '                        <tr>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:14px; text-align:left; font-weight: bold; padding: 0 0 5px 0;" colspan="2">Neurored</td>';
        informe_sli += '                            <td></td>';
        informe_sli += '                        </tr>';
        informe_sli += '                        <tr>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Tel No:</td>';
        informe_sli += '                        </tr>';
        informe_sli += '                        <tr>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Fax No: </td>';
        informe_sli += '                        </tr>';
        informe_sli += '                        <tr>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Electronic Fax: </td>';
        informe_sli += '                        </tr>';
        informe_sli += '                        <tr>';
        informe_sli += '                            <td></td>';
        informe_sli += '                            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;Email:</td>';
        informe_sli += '                        </tr>';
        informe_sli += '                    </table>';
        informe_sli += '                </td>';
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :'company_logo'];
        string url = '';
        if (resourceList.size() == 1)
        {
           String namespace = resourceList[0].NamespacePrefix;
           url ='/resource/' + resourceList[0].SystemModStamp.getTime() + '/'+ (namespace != null && namespace != '' ? namespace + '__' : '') + 'company_logo';
        }
        informe_sli += '                <td style="text-align: right;"><img src="'+url+'"/></td>';
        informe_sli += '            </tr>';
        informe_sli += '        </table>';
        informe_sli += '    </div>';
        //informe_sli += '  <hr/>';
        informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:23px; width:700px; text-align:center; font-weight:bold; margin:10px 0 10px 0; border: 1px solid black; font-style: italic;">SHIPPING LINE INSTRUCTION</p>';
        informe_sli += '    <table border="0" cellspacing="0" cellpadding="5">';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">TO</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
        if(record.Carriers_OI__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Carriers_OI__c+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">OUR REFERENCE</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
        
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Name+'</td>';
    
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">CUSTOMER NAME</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
        if(record.Account_for__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Account_for__r.Name+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">IMPORTER REF</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
        if(record.Account_Shipment_Reference__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Account_Shipment_Reference__c+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">DATE</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+System.Now().format('dd/MM/yyyy', 'GMT+2')+'</td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">TIME</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">:</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+System.Now().format('HH:mm a', 'GMT+2')+'</td>';
        informe_sli += '        </tr>';
        informe_sli += '    </table>';
        informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; margin:10px 0 10px 0;">Dear Sirs,</p>';
        if(record.Destination_Address__c != null)
            informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; margin:10px 0 10px 0;">Kindly arrange delivery by Merchant haulage of the Containers as listed to the following address: '+record.Destination_Address__c+'</p>';
        else
            informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; margin:10px 0 10px 0;">Kindly arrange delivery by Merchant haulage of the Containers as listed to the following address: </p>';
        informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:690px; text-align:left; font-weight:bold; margin:10px 0 10px 0; border: 1px solid black; font-style: italic; padding: 5px;">TRANSPORTERS: '+transportistas+'</p>';
        informe_sli += '    <table border="0" cellspacing="0" cellpadding="5" style="width:100%;">';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Vessel and Voyage :</td>';
        if(record.Truck_Vessel_Flight__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Truck_Vessel_Flight__r.Name+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">ETA :</td>';
        if(record.Truck_Vessel_Flight_ETA__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Truck_Vessel_Flight_ETA__c+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+(record.Track_Option__c != null ? record.Track_Option__c +':' : '')+' </td>';
        
        if(record.Number__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Number__c+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Port From :</td>';
        if(record.Site_of_Load__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Site_of_Load__r.Name+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Port To :</td>';
        if(record.Site_of_Discharge__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Site_of_Discharge__r.Name+'</td>';
        else
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '    </table>';
        if(record.Freight_Mode__c != null)
            informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:690px; text-align:left; margin:10px 0 10px 0; border:1px solid black; padding: 5px;">Mode of Transport: <span style="text-transform: uppercase;">ROAD / RAIL</span> (Delete whichever not applicable)</p>';
        else
            informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:690px; text-align:left; margin:10px 0 10px 0; border:1px solid black; padding: 5px;">Mode of Transport: (Delete whichever not applicable)</p>';
        informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; margin:5px 0 5px 0; font-weight:bold;">HERE WITH DOCUMENTS AND PAYMENT KINDLY STAMP CTO / UPDATE YOUR NAVIS SYSTEM.</p>';
        informe_sli += '    <table border="0" cellspacing="0" cellpadding="5" style="border:1px solid black; width:100%;">';
        informe_sli += '        <tr>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Bill of Entry Number</th>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Bill of Entry Date</th>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Cargo Dues Number</th>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Cargo Dues Date</th>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Transport Doc Number</th>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr><td colspan="5"><hr style="margin:0;"/></td></tr>';
        informe_sli += '        <tr>';
        /*if(record.Bill_of_Entry_Number__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Bill_of_Entry_Number__c+'</td>';
        else*/
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        /*if(record.Bill_of_Entry_Date__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Bill_of_Entry_Date__c+'</td>';
        else*/
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        /*if(record.Cargo_Dues_Ref__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Cargo_Dues_Ref__c+'</td>';
        else*/
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        /*if(record.Cargo_Dues_Date__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Cargo_Dues_Date__c+'</td>';
        else*/
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        /*if(record.Master_Bill__c != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+record.Master_Bill__c+'</td>';
        else*/
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '    </table>';
        informe_sli += '    <div style="height:200px;">';
        informe_sli += '    <table border="0" cellspacing="0" cellpadding="5" style="border:1px solid black; width:100%; margin: 10px 0 0 0;">';
        informe_sli += '        <tr>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; text-decoration: underline;">Container No</th>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; text-decoration: underline;">Depot Name</th>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; text-decoration: underline;">Terminal Name</th>';
        informe_sli += '            <th style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; text-decoration: underline;">Container Spec. Desc.</th>';
        informe_sli += '        </tr>';
        
        for(Transport_Packaging_Data__c spd : shipment_packaging_data)
        {
            informe_sli += '    <tr>';
            if(spd.Container_Nbrs__c != null)
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+spd.Container_Nbrs__c+'</td>';
            else
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
                
            /*if(spd.Empty_Depot__c != null)
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+spd.Empty_Depot__c+'</td>';
            else*/
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
            /*if(spd.Full_Depot__c != null)
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+spd.Full_Depot__c+'</td>';
            else*/
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
            /*if(spd.Container_Type__c != null)
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">'+spd.Container_Type__c+'</td>';
            else*/
                informe_sli += '        <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
            informe_sli += '    </tr>';
        } 
        
        informe_sli += '</table>';
        informe_sli += '</div>';
        informe_sli += '    <table border="0" cellspacing="0" cellpadding="5" style="border:1px solid black; width:100%; margin: 10px 0 0 0;">';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">ANF / SOB</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">No</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">Descriptive Literature</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;">No</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; font-weight:bold;">Original Bill:</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"><span style="width:30px; height:30px; border:1px solid black;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>';
        /*if(remittance_number != '' && remittance_number != null)
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; text-align:right; font-weight:bold;">Remittance Number: '+remittance_number+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>';
        else*/
            informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; text-align:right; font-weight:bold;">Remittance Number: _____________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>';
        informe_sli += '        </tr>';
        informe_sli += '        <tr>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left; font-weight:bold;">Telex:</td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"><span style="width:30px; height:30px; border:1px solid black;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>';
        informe_sli += '            <td style="font-family: Arial, Helvetica, sans-serif; font-size:12px; text-align:left;"></td>';
        informe_sli += '        </tr>';
        informe_sli += '    </table>';
        informe_sli += '    <p style="font-family: Arial, Helvetica, sans-serif; font-size:12px; width:700px; text-align:left; margin:10px 0 0 0; text-decoration: underline; font-weight:bold;">Document Generated by: '+System.Userinfo.getName()+'</p>';
        informe_sli += '</div>';
    }
    
    public Pagereference update_shipment()
    {
        try
        {
            record.SLI_Created__c = system.now();
            update record;
        }
        catch(Exception ex)
        {
        }
        
        return null;
    }
    
}