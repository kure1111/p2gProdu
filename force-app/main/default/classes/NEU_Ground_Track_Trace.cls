public class NEU_Ground_Track_Trace 
{
    public Shipment__c record;
    public string direccion_origen {get;set;}
    public string direccion_destino {get;set;}
    public string string_tabla {get;set;}
    public string direcciones_recogidas {get;set;}
    
    ApexPages.StandardController con;
     
    public NEU_Ground_Track_Trace(ApexPages.StandardController stdController) 
    {
        con = stdController;
              
        try 
        { 
            record = [select Id, Name, Supplier_Account__c, Supplier_Account__r.Public_Alias__c, Account_for__r.Public_Alias__c, Site_of_Load__c, Site_of_Load__r.Name, 
            Equip_Unloaded__c, Supplier_Account__r.Name, Account_for__c, Account_for__r.Name, Origin_Address__c, Destination_Address__c,  Arrival_to_B__c, 
            Stopping_Time_B_Hours__c, Departure_from_B__c, Arrival_to_C__c, Stopping_Time_C_Hours__c, Departure_from_C__c, Arrival_to_D__c, Stopping_Time_D_Hours__c, 
            Departure_from_D__c, Total_Cycle_Time_Hours__c, Equip_Loaded__c, Transit_Time_to_C_Hours__c, Transit_Time_to_B_Hours__c, Transit_Time_to_D_Hours__c, 
            Equip_Solicited__c, Loading_Time_Hours__c, Equip_Placed__c, Unloading_Time_Hours__c, Site_of_Discharge__c, Site_of_Discharge__r.Name, Account_Stop_B__c, 
            Account_Stop_B__r.Name, Account_Stop_B__r.ShippingStreet, Account_Stop_B__r.ShippingCity, Account_Stop_B__r.ShippingCountry, Account_Stop_C__c, 
            Account_Stop_C__r.Name, Account_Stop_C__r.ShippingStreet, Account_Stop_C__r.ShippingCity, Account_Stop_C__r.ShippingCountry,
            Account_Stop_B__r.ShippingState,
            Account_Stop_C__r.ShippingState, ATA__c, ATD__c, Transit_Time_from_Last_Stop_Hours__c
            from Shipment__c where id = :con.getRecord().id];
        } 
        catch(Exception ee){record = new Shipment__c();}

        string_tabla = '';

        List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'green_truck']; 
        List<StaticResource> query_flag = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'Flag_finish'];
        
        String namespace = query_logo[0].NamespacePrefix;
               // Resource URL
        String logo_truck ='/resource/' + query_logo[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + query_logo[0].Name; 
        String logo_flag ='/resource/' + query_flag[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + query_flag[0].Name; 
         
        string_tabla += '<div id="contenedor">';
        string_tabla += '   <table class="tabla_datos">';
        string_tabla += '       <tr>';
        string_tabla += '           <th colspan="4" class="cabecera_tabla"><img class="marca_tipo" src="https://maps.google.com/mapfiles/markerA.png"/><span class="titulo_cuenta">'+(record.Supplier_Account__r.Public_Alias__c != null ? record.Supplier_Account__r.Public_Alias__c : record.Supplier_Account__r.Name ) +' ('+(record.Site_of_Load__c != null ? record.Site_of_Load__r.Name : '')+')</span></th>';
        if(record.Account_Stop_B__c != null)
        {
            string_tabla += '       <th class="img_tabla"><img  id="logotipo" src="'+logo_truck+'"/></th>';
            string_tabla += '       <th  colspan="3" class="cabecera_tabla"><img class="marca_tipo" src="https://maps.google.com/mapfiles/marker_greenB.png"/><span class="titulo_cuenta">'+(record.Account_Stop_B__c != null ? record.Account_Stop_B__r.Name : '') +' ('+(record.Account_Stop_B__r.ShippingCity != null ? record.Account_Stop_B__r.ShippingCity : '')+' / '+(record.Account_Stop_B__r.ShippingState != null ? record.Account_Stop_B__r.ShippingState : '')+' )</span></th>';
            string_tabla += '       <th class="img_tabla"><img  id="logotipo" src="'+logo_truck+'"/></th>';//+ +
            string_tabla += '   </tr>';
            string_tabla += '   <tr>';
            string_tabla += '       <th>Equip. Placed Empty</th><th>Loading Time</th><th>Equip. Loaded</th><th>ATD</th>';
            string_tabla += '       <th>Transit Time</th>';
            string_tabla += '       <th>Arrival</th><th>Stopping Time</th><th>Departure</th>';
            string_tabla += '       <th>Transit Time</th>';
            string_tabla += '   </tr>';
            string_tabla += '   <tr>';
            string_tabla += '       <td>'+(record.Equip_Placed__c != null ? String.valueof(record.Equip_Placed__c) : '')+'</td>';
            string_tabla += '       <td style="text-align: right;">'+(record.Loading_Time_Hours__c != null ? record.Loading_Time_Hours__c : 0)+'</td>';
            string_tabla += '       <td>'+(record.Equip_Loaded__c != null ? String.valueof(record.Equip_Loaded__c) : '')+'</td>';
            string_tabla += '       <td>'+(record.ATD__c != null ? String.valueof(record.ATD__c) : '')+'</td>';
            string_tabla += '       <td style="text-align: right;">'+(record.Transit_Time_to_B_Hours__c != null ? record.Transit_Time_to_B_Hours__c : (record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0)) +'</td>';
            string_tabla += '       <td>'+(record.Arrival_to_B__c != null ? String.valueof(record.Arrival_to_B__c) : '')+'</td>';
            string_tabla += '       <td style="text-align: right;">'+(record.Stopping_Time_B_Hours__c != null ? record.Stopping_Time_B_Hours__c : 0)+'</td>';
            string_tabla += '       <td>'+(record.Departure_from_B__c != null ? String.valueof(record.Departure_from_B__c) : '')+'</td>';
          
            if(record.Account_Stop_C__c != null)
            {
                string_tabla += '       <td style="text-align: right;">'+(record.Transit_Time_to_C_Hours__c != null ? record.Transit_Time_to_C_Hours__c : (record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0))+'</td>';
                string_tabla += '   </tr>';
                string_tabla += '</table>';
                string_tabla += '<table class="tabla_datos">';
                string_tabla += '   <tr>';
            }
            else
            {
                string_tabla += '       <td style="text-align: right;">'+(record.Transit_Time_to_D_Hours__c != null ? record.Transit_Time_to_D_Hours__c : (record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0))+'</td>';
                string_tabla += '   </tr>';
                string_tabla += '</table>';
                string_tabla += '<table class="tabla_datos">';
                string_tabla += '  <tr>';
                string_tabla += '    <th colspan="3" class="cabecera_tabla"><img class="marca_tipo" src="'+logo_flag+'"/><span class="titulo_cuenta">'+(record.Account_for__r.Public_Alias__c != null ? record.Account_for__r.Public_Alias__c : record.Account_for__r.Name ) +' ('+(record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+')</span></th>';
                string_tabla += '    <th colspan="2" style="background-color: white; background-color: white; -webkit-box-shadow: 0px 0px 0px #999; -moz-box-shadow: 0px 0px 0px #999; filter: shadow(color=#999999, direction=135, strength=2);"></th>';
                string_tabla += '  </tr>';
                string_tabla += '  <tr>';
                string_tabla += '      <th>ATA</th><th>Unloading Time</th><th>Equip. Empty</th>';  
                string_tabla += '      <th>Total Cycle Time</th><th>Observations</th>';
                string_tabla += '  </tr>';
                string_tabla += '  <tr>';
            }
        }
        else
        {
            
            string_tabla += '       <th class="img_tabla"><img id="logotipo" src="'+logo_truck+'"/></th>';
            string_tabla += '       <th colspan="3" class="cabecera_tabla" style="width: 35%;"><img class="marca_tipo" src="'+logo_flag+'"/><span class="titulo_cuenta">'+(record.Account_for__r.Public_Alias__c != null ? record.Account_for__r.Public_Alias__c : record.Account_for__r.Name ) +' ('+(record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+')</span></th>';
            string_tabla += '       <th colspan="2" style="background-color: white; background-color: white; -webkit-box-shadow: 0px 0px 0px #999; -moz-box-shadow: 0px 0px 0px #999; filter: shadow(color=#999999, direction=135, strength=2);"></th>';
            string_tabla += '   </tr>';
            string_tabla += '   <tr>';
            string_tabla += '       <th>Equip. Solicited</th><th>Equip. Placed Empty</th><th>Loading Time</th><th>Equip. Loaded</th>';
            string_tabla += '       <th>Transit Time</th>';
            string_tabla += '       <th>ATA</th><th>Unloading Time</th><th>Equip. Empty</th>';
            string_tabla += '       <th>Total Cycle Time</th><th>Observations</th>';
            string_tabla += '   </tr>';
            string_tabla += '   <tr>';
            string_tabla += '       <td>'+(record.Equip_Solicited__c != null ? String.valueof(record.Equip_Solicited__c) : '')+'</td>';
            string_tabla += '       <td>'+(record.Equip_Placed__c != null ? String.valueof(record.Equip_Placed__c) : '')+'</td>';
            string_tabla += '       <td style="text-align: right;">'+(record.Loading_Time_Hours__c != null ? record.Loading_Time_Hours__c : 0)+'</td>';
            string_tabla += '       <td>'+(record.Equip_Loaded__c != null ? String.valueof(record.Equip_Loaded__c) : '')+'</td>';
            string_tabla += '       <td style="text-align: right;">'+(record.Transit_Time_to_D_Hours__c != null ? record.Transit_Time_to_D_Hours__c : (record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0))+'</td>';
        }
        
        if(record.Account_Stop_C__c != null)
        {
            string_tabla += '       <th colspan="3" class="cabecera_tabla"><img class="marca_tipo" src="https://maps.google.com/mapfiles/marker_yellowC.png"/><span class="titulo_cuenta">'+(record.Account_Stop_C__c != null ? record.Account_Stop_C__r.Name : '') +' ('+(record.Account_Stop_C__r.ShippingCity != null ? record.Account_Stop_C__r.ShippingCity : '')+' / '+(record.Account_Stop_C__r.ShippingState != null ? record.Account_Stop_C__r.ShippingState : '')+' )</span></th>';
           

            string_tabla += '       <th class="img_tabla"><img  id="logotipo" src="'+logo_truck+'"/></th>';
            string_tabla += '       <th colspan="3" class="cabecera_tabla" style="    width: 35%;"><img class="marca_tipo" src="'+logo_flag+'"/><span class="titulo_cuenta">'+(record.Account_for__r.Public_Alias__c != null ? record.Account_for__r.Public_Alias__c : record.Account_for__r.Name ) +' ('+(record.Site_of_Discharge__c != null ? record.Site_of_Discharge__r.Name : '')+')</span></th>';
            string_tabla += '       <th colspan="2" style="    background-color: white;              background-color: white;    -webkit-box-shadow: 0px 0px 0px #999;    -moz-box-shadow: 0px 0px 0px #999;    filter: shadow(color=#999999, direction=135, strength=2);"></th>';
            string_tabla += '   </tr>';
            string_tabla += '   <tr>';
            string_tabla += '       <th>Arrival</th><th>Stopping Time</th><th>Departure</th>';
            string_tabla += '       <th>Transit Time</th>';
            string_tabla += '       <th>ATA</th><th>Unloading Time</th><th>Equip. Empty</th>';
            string_tabla += '       <th>Total Cycle Time</th><th>Observations</th>';
            string_tabla += '   </tr>';
            string_tabla += '   <tr>';
            string_tabla += '       <td>'+(record.Arrival_to_C__c != null ? String.valueof(record.Arrival_to_C__c) : '')+'</td>';
            string_tabla += '       <td style="text-align: right;">'+(record.Stopping_Time_C_Hours__c != null ? record.Stopping_Time_C_Hours__c : 0) +'</td>';
            string_tabla += '       <td>'+(record.Departure_from_C__c != null ? String.valueof(record.Departure_from_C__c) : '')+'</td>';
            string_tabla += '       <td style="text-align: right;">'+(record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0)+'</td>';

        }
        
        string_tabla += '           <td>'+(record.ATA__c != null ? String.valueof(record.ATA__c) : '')+'</td>';
        string_tabla += '           <td style="text-align: right;">'+(record.Unloading_Time_Hours__c != null ? record.Unloading_Time_Hours__c :0) +'</td>';
        string_tabla += '           <td>'+(record.Equip_Unloaded__c != null ? String.valueof(record.Equip_Unloaded__c) : '')+'</td>';
        string_tabla += '           <td style="text-align: right;">'+(record.Total_Cycle_Time_Hours__c != null ? record.Total_Cycle_Time_Hours__c : 0) +'</td>';
        string_tabla += '           <td></td>';
        string_tabla += '       </tr>';
        string_tabla += '   </table>';
        string_tabla += '</div>';
        
        //DIRECCIONES
        direccion_origen = '';
        direccion_destino = '';
        direcciones_recogidas = '';
        
        if(record.Origin_Address__c != null && record.Origin_Address__c != '')
            direccion_origen = record.Origin_Address__c;
        if(record.Destination_Address__c != null && record.Destination_Address__c != '')
            direccion_destino = record.Destination_Address__c;
        
        //ORIGIN
        if(record.Origin_Address__c != null && record.Origin_Address__c != '')
        {
            direcciones_recogidas += record.Origin_Address__c+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">'+(record.Supplier_Account__c != null && record.Supplier_Account__r.Public_Alias__c != '' && record.Supplier_Account__r.Public_Alias__c != null ? record.Supplier_Account__r.Public_Alias__c : record.Supplier_Account__r.Name)+'</span>|';
            direcciones_recogidas += '<span style="font-weight: bold;">Equip. Placed Empty : </span>'+(record.Equip_Placed__c != null ? String.valueof(record.Equip_Placed__c) : '')+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Load Time (Days) : </span>'+(record.Loading_Time_Hours__c != null ? record.Loading_Time_Hours__c : 0)+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Equip. Loaded : </span>'+(record.Equip_Loaded__c != null ? String.valueof(record.Equip_Loaded__c) : '')+'|';
            direcciones_recogidas += '<span style="font-weight: bold;"></span> |';
            direcciones_recogidas += 'https://maps.google.com/mapfiles/markerA.png|';
            direcciones_recogidas += record.Supplier_Account__c+'|';
        }
        
        //PLACE B
        if(record.Account_Stop_B__c != null && record.Account_Stop_B__r.ShippingStreet != null)
        {
            direcciones_recogidas += record.Account_Stop_B__r.ShippingStreet+', '+record.Account_Stop_B__r.ShippingCity+', '+record.Account_Stop_B__r.ShippingCountry+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">'+(record.Account_Stop_B__c != null ? record.Account_Stop_B__r.Name : '')+'</span>|';
            direcciones_recogidas += '<span style="font-weight: bold;">Arrival to B : </span>'+(record.Arrival_to_B__c != null ? String.valueof(record.Arrival_to_B__c) : '')+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Transit Time (Origin to B) : </span>'+(record.Transit_Time_to_B_Hours__c != null ? record.Transit_Time_to_B_Hours__c : (record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0)) +'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Stopping Time (B) : </span>'+(record.Stopping_Time_B_Hours__c != null ? record.Stopping_Time_B_Hours__c : 0) +'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Departure from B : </span>'+(record.Departure_from_B__c != null ? String.valueof(record.Departure_from_B__c) : '')+'|';
            direcciones_recogidas += 'https://maps.google.com/mapfiles/marker_greenB.png|';
            direcciones_recogidas += record.Account_Stop_B__c+'|';
        }
        
        //PLACE C
        if(record.Account_Stop_C__c != null && record.Account_Stop_C__r.ShippingStreet != null)
        {
            direcciones_recogidas += record.Account_Stop_C__r.ShippingStreet+', '+record.Account_Stop_C__r.ShippingCity+', '+record.Account_Stop_C__r.ShippingCountry+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">'+(record.Account_Stop_C__c != null ? record.Account_Stop_C__r.Name : '')+'</span>|';
            direcciones_recogidas += '<span style="font-weight: bold;">Arrival to C : </span>'+(record.Arrival_to_C__c != null ? String.valueof(record.Arrival_to_C__c) : '')+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Transit Time (B to C) : </span>'+(record.Transit_Time_to_C_Hours__c != null ? record.Transit_Time_to_C_Hours__c : (record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0))+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Stopping Time (C) : </span>'+(record.Stopping_Time_C_Hours__c != null ? record.Stopping_Time_C_Hours__c : 0) +'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Departure from C : </span>'+(record.Departure_from_C__c != null ? String.valueof(record.Departure_from_C__c) : '')+'|';
            direcciones_recogidas += 'https://maps.google.com/mapfiles/marker_yellowC.png|';
            direcciones_recogidas += record.Account_Stop_C__c+'|';
        }

        //DESTINATION
        if(record.Destination_Address__c != null && record.Destination_Address__c != '')
        {
            direcciones_recogidas += record.Destination_Address__c+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">'+(record.Account_for__c != null && record.Account_for__r.Public_Alias__c != '' && record.Account_for__r.Public_Alias__c != null ? record.Account_for__r.Public_Alias__c : record.Account_for__r.Name)+'</span>|';
            direcciones_recogidas += '<span style="font-weight: bold;">Transit Time (to Final Destination) : </span>'+(record.Transit_Time_to_D_Hours__c != null ? record.Transit_Time_to_D_Hours__c : (record.Transit_Time_from_Last_Stop_Hours__c != null ? record.Transit_Time_from_Last_Stop_Hours__c : 0))+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Arrival to Destination : </span>'+(record.Arrival_to_D__c != null ? String.valueof(record.Arrival_to_D__c) : '')+'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Unloading Time (Days) : </span>'+(record.Unloading_Time_Hours__c != null ? record.Unloading_Time_Hours__c : 0) +'|';
            direcciones_recogidas += '<span style="font-weight: bold;">Equip. Reported Empty : </span> '+(record.Equip_Unloaded__c != null ? String.valueof(record.Equip_Unloaded__c) : '')+'|';
            direcciones_recogidas += ''+logo_flag+'|';
            direcciones_recogidas += record.Account_for__c+'|';
        }
    }
}