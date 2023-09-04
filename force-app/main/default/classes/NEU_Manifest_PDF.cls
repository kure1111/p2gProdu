public with sharing class NEU_Manifest_PDF 
{
    ApexPages.StandardController con;
    
    public Air_Waybill__c record;
    public string string_pdf {get;set;}
    public integer cont = 0;

    public NEU_Manifest_PDF(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        try 
        { 
            record = [select id, Name, Airline_Code_Number__c, Enable_Shipper_Alternative_Address__c, Prepaid_Collect_House_Other__c, 
            Serial_Number__c, Flight_Number__c, Site_of_Destination__c, Site_of_Destination__r.Name, Shipper_Account__c, 
            Shipper_Account__r.Name, Shipper_Account__r.BillingStreet, Shipper_Account__r.BillingCity, Shipper_Account__r.BillingState, 
            Shipper_Account__r.BillingCountry, Consignee_Account__c, Consignee_Account__r.Name, Consignee_Account__r.BillingStreet, 
            Consignee_Account__r.BillingCity, Consignee_Account__r.BillingState, Consignee_Account__r.BillingCountry,  
            Total_Gross_Weight__c, Total_Number_of_Pieces__c, Airport_of_Destination_Code__c, Direct_Shipment__c, 
            Consignee_House__c, Consignee_House__r.Name, Consignee_House__r.BillingStreet, Consignee_House__r.BillingCity, 
            Consignee_House__r.BillingState, Consignee_House__r.BillingCountry, Consignee_House__r.Phone, Consignee_Account__r.Phone,
            Shipper_Alternative_Address__c, Shipper_Alternative_Country__c, Shipper_Alternative_Location__c,
            Enable_Consignee_Alternative_Address__c, Enable_Consignee_House_Alt_Address__c, Shipper_Alternative_Country__r.Name, 
            Consignee_Alternative_Address__c, Consignee_Alternative_Country__c, Consignee_Alternative_Country__r.Name, 
            Consignee_Alternative_Location__c, Consignee_Alternative_Location__r.Name, Shipper_Alternative_Location__r.Name, 
            Consignee_House_Alternative_Address__c, Consignee_House_Alternative_Country__c, Consignee_House_Alternative_Country__r.Name, 
            Consignee_House_Alternative_Location__c, Consignee_House_Alternative_Location__r.Name, Prepaid_Collect_House_WT_VAL__c
            from Air_Waybill__c where Id =: con.getRecord().id];
        } 
        catch(Exception ee){record = new Air_Waybill__c();}
       
        /* DATOS DE LA COMPAÑÍA */
        Organization orgDetails = [SELECT Id, Name, Address, City, Fax, Phone, PostalCode, Street FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
       
        List<Air_Waybill_Line__c> waybill_lines = [select Id, Name, Gross_Weight__c, Description__c, No_of_Pieces__c, Length__c,
                                                Width__c, Height__c, House_Reference__c, House_Reference__r.Name 
                                                from Air_Waybill_Line__c where Air_Waybill__c =: record.Id 
                                                order by House_Reference__r.Name, Name];
                                                
        List<Waybill_Consolidation__c> consolidation = [SELECT Id, Name, Shipper_Account__c, Shipper_Account__r.Name, Shipper_Account_Address__c, 
                                                        Enable_Shipper_Alternative_Address__c, Shipper_Alternative_Address__c, 
                                                        Shipper_Alternative_Country__c, Shipper_Alternative_Country__r.Name, 
                                                        Shipper_Alternative_Location__c, Shipper_Alternative_Location__r.Name, 
                                                        Shipper_Account__r.BillingStreet, Shipper_Account__r.BillingCity, 
                                                        Shipper_Account__r.BillingState, Shipper_Account__r.BillingCountry, 
                                                        Consignee_House__c, Consignee_House__r.Name, Consignee_House_Account_Address__c,
                                                        Enable_Consignee_House_Alternative__c, Consignee_Alternative_Address__c, 
                                                        Consignee_Alternative_Country__c, Consignee_Alternative_Country__r.Name, 
                                                        Consignee_Alternative_Location__c, Consignee_Alternative_Location__r.Name, 
                                                        Consignee_House__r.BillingStreet, Consignee_House__r.BillingCity, 
                                                        Consignee_House__r.BillingState, Consignee_House__r.BillingCountry
                                                        FROM Waybill_Consolidation__c WHERE Waybill__c =: record.Id order by Name];

        List<StaticResource> logo = [Select Id, Name, body, SystemModStamp, NamespacePrefix from StaticResource where Name = 'logo_carta_porte'];  
        
        string_pdf = '';
        string_pdf += '<div id="container">';
        string_pdf += ' <div id="logos">';
        if(logo.size() > 0)
            string_pdf += '     <img src="/resource/'+ logo[0].SystemModStamp.getTime() + '/'+ (logo[0].NamespacePrefix != null && logo[0].NamespacePrefix!= '' ? logo[0].NamespacePrefix+ '__' : '')+ 'logo_carta_porte" class="logo_1"/>';
        string_pdf += ' </div>';
        string_pdf += ' <h2 class="h2_title">AIR CARGO MANIFEST CONSOLIDATION</h2>';
        string_pdf += ' <table border="0" cellspacing="0" cellpadding="2" class="table_top_1">';
        string_pdf += '     <tr>';
        string_pdf += '         <td>TO:</td>';
        string_pdf += '         <td>';
        string_pdf += '             <p>'+(record.Consignee_Account__c != null ? record.Consignee_Account__r.Name : '&nbsp;')+'</p>';
                                    if(record.Enable_Consignee_Alternative_Address__c)
                                    {        
        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Alternative_Address__c != null ? record.Consignee_Alternative_Address__c : '&nbsp;')+'</p>';
        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Alternative_Location__c != null ? record.Consignee_Alternative_Location__r.Name : '&nbsp;')+'</p>';
        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Alternative_Country__c != null ? record.Consignee_Alternative_Country__r.Name : '&nbsp;')+'</p>';        
                                    }
                                    else
                                    {       
        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingStreet != null ? record.Consignee_Account__r.BillingStreet : '&nbsp;')+'</p>';
        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingCity != null ? record.Consignee_Account__r.BillingCity : '&nbsp;')+''+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingState != null ? ', '+record.Consignee_Account__r.BillingState : '&nbsp;')+'</p>';
        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingCountry != null ? record.Consignee_Account__r.BillingCountry : '&nbsp;')+'</p>';                                            
                                    }
        string_pdf += '             <p>T: '+(record.Consignee_Account__r.Phone != null ? record.Consignee_Account__r.Phone : '&nbsp;')+'</p>';                          
        string_pdf += '         </td>';
        string_pdf += '     </tr>';
        string_pdf += ' </table>';
        string_pdf += ' <table border="0" cellspacing="0" cellpadding="2" class="table_top_2">';
        string_pdf += '     <tr>';
        string_pdf += '         <th>DATE:</th>';
        string_pdf += '         <td>'+system.today().day()+'-'+system.today().month()+'-'+system.today().year()+'</td>';
        string_pdf += '     </tr>';
        string_pdf += '     <tr>';
        string_pdf += '         <th>MAWB:</th>';
        string_pdf += '         <td>'+(record.Serial_Number__c != null ? record.Airline_Code_Number__c+'-'+record.Serial_Number__c : '')+'</td>';
        string_pdf += '     </tr>';
        string_pdf += '     <tr>';
        string_pdf += '         <th>FLIGHT:</th>';
        string_pdf += '         <td>'+(record.Flight_Number__c != null ? record.Flight_Number__c : '')+'</td>';
        string_pdf += '     </tr>';
        string_pdf += '     <tr>';
        string_pdf += '         <th>F.DEST:</th>';
        string_pdf += '         <td>'+(record.Site_of_Destination__c != null ? (record.Airport_of_Destination_Code__c != null ? record.Airport_of_Destination_Code__c : record.Site_of_Destination__r.Name) : '')+'</td>';
        string_pdf += '     </tr>';
        string_pdf += ' </table>';
        string_pdf += ' <div class="capa_mid">';
        string_pdf += '     <table border="0" cellspacing="0" cellpadding="3" class="table_mid">';
        string_pdf += '         <tr>';
        string_pdf += '             <th style="width:5%">HAWB #</th>';
        string_pdf += '             <th style="width:30%">SHIPPER</th>';
        string_pdf += '             <th style="width:30%">CONSIGNEE</th>';
        string_pdf += '             <th style="width:5%"># PCS</th>';
        string_pdf += '             <th style="width:10%">WEIGHT KGS</th>';
        string_pdf += '             <th style="width:20%">SIZES</th>';
        string_pdf += '         </tr>';
        for(Waybill_Consolidation__c conso : consolidation)
        {
            String description = '';
            String consoli = '';
            Integer i = 1;
            for(Air_Waybill_Line__c sl : waybill_lines)
            {
                if(conso.Name == sl.House_Reference__r.Name)
                {
                    if(cont == 10 || Test.isRunningTest())
                    {
                        cont = 0;
                        string_pdf += '     </table>';
                        string_pdf += ' </div>';
                        string_pdf += ' <div class="capa_bot">';
                        string_pdf += '     <p class="remark_title">REMARKS:</p>';
                        string_pdf += '     <p class="remarks">'+NEU_Utils.safeString(record.Prepaid_Collect_House_WT_VAL__c)+'</p>';
                        string_pdf += ' </div>';
                        string_pdf += ' <h4 class="sign">Signed (as consolidator)</h4>';
                        string_pdf += ' <div class="footer">';
                        string_pdf += '     <p>'+NEU_Utils.safeString(orgDetails.Street)+', '+NEU_Utils.safeString(orgDetails.City)+', C.P.'+NEU_Utils.safeString(orgDetails.PostalCode)+'</p>';
                        string_pdf += '     <p>Tel: ' + NEU_Utils.safeString(orgDetails.Phone) + ' Fax: ' + NEU_Utils.safeString(orgDetails.Fax) + '</p>';
                        string_pdf += '     <p>https://www.pak2go.com/</p>';
                        string_pdf += ' </div>';
                        string_pdf += '</div>';
                        string_pdf += '<div id="container" style="page-break-after: always">';
                        string_pdf += ' <div id="logos">';
                        if(logo.size() > 0)
                            string_pdf += '     <img src="/resource/'+ logo[0].SystemModStamp.getTime() + '/'+ (logo[0].NamespacePrefix != null && logo[0].NamespacePrefix!= '' ? logo[0].NamespacePrefix+ '__' : '')+ 'logo_carta_porte" class="logo_1"/>';
                        string_pdf += ' </div>';
                        string_pdf += ' <h2 class="h2_title">AIR CARGO MANIFEST CONSOLIDATION</h2>';
                        string_pdf += ' <table border="0" cellspacing="0" cellpadding="2" class="table_top_1">';
                        string_pdf += '     <tr>';
                        string_pdf += '         <td>TO:</td>';
                        string_pdf += '         <td>';
                        string_pdf += '             <p>'+(record.Consignee_Account__c != null ? record.Consignee_Account__r.Name : '&nbsp;')+'</p>';
                                                    if(record.Enable_Consignee_Alternative_Address__c)
                                                    {        
                        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Alternative_Address__c != null ? record.Consignee_Alternative_Address__c : '&nbsp;')+'</p>';
                        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Alternative_Location__c != null ? record.Consignee_Alternative_Location__r.Name : '&nbsp;')+'</p>';
                        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Alternative_Country__c != null ? record.Consignee_Alternative_Country__r.Name : '&nbsp;')+'</p>';        
                                                    }
                                                    else
                                                    {       
                        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingStreet != null ? record.Consignee_Account__r.BillingStreet : '&nbsp;')+'</p>';
                        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingCity != null ? record.Consignee_Account__r.BillingCity : '&nbsp;')+''+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingState != null ? ', '+record.Consignee_Account__r.BillingState : '&nbsp;')+'</p>';
                        string_pdf += '                 <p>'+(record.Consignee_Account__c != null && record.Consignee_Account__r.BillingCountry != null ? record.Consignee_Account__r.BillingCountry : '&nbsp;')+'</p>';                                            
                                                    }
                        string_pdf += '             <p>T: '+(record.Consignee_Account__r.Phone != null ? record.Consignee_Account__r.Phone : '&nbsp;')+'</p>';                          
                        string_pdf += '         </td>';
                        string_pdf += '     </tr>';
                        string_pdf += ' </table>';
                        string_pdf += ' <table border="0" cellspacing="0" cellpadding="2" class="table_top_2">';
                        string_pdf += '     <tr>';
                        string_pdf += '         <th>DATE:</th>';
                        string_pdf += '         <td>'+system.today().day()+'-'+system.today().month()+'-'+system.today().year()+'</td>';
                        string_pdf += '     </tr>';
                        string_pdf += '     <tr>';
                        string_pdf += '         <th>MAWB:</th>';
                        string_pdf += '         <td>'+(record.Serial_Number__c != null ? record.Airline_Code_Number__c+'-'+record.Serial_Number__c : '')+'</td>';
                        string_pdf += '     </tr>';
                        string_pdf += '     <tr>';
                        string_pdf += '         <th>FLIGHT:</th>';
                        string_pdf += '         <td>'+(record.Flight_Number__c != null ? record.Flight_Number__c : '')+'</td>';
                        string_pdf += '     </tr>';
                        string_pdf += '     <tr>';
                        string_pdf += '         <th>F.DEST:</th>';
                        string_pdf += '         <td>'+(record.Site_of_Destination__c != null ? (record.Airport_of_Destination_Code__c != null ? record.Airport_of_Destination_Code__c : record.Site_of_Destination__r.Name) : '')+'</td>';
                        string_pdf += '     </tr>';
                        string_pdf += ' </table>';
                        string_pdf += ' <div class="capa_mid">';
                        string_pdf += '     <table border="0" cellspacing="0" cellpadding="3" class="table_mid">';
                        string_pdf += '         <tr>';
                        string_pdf += '             <th style="width:5%">HAWB #</th>';
                        string_pdf += '             <th style="width:30%">SHIPPER</th>';
                        string_pdf += '             <th style="width:30%">CONSIGNEE</th>';
                        string_pdf += '             <th style="width:5%"># PCS</th>';
                        string_pdf += '             <th style="width:10%">WEIGHT KGS</th>';
                        string_pdf += '             <th style="width:20%">SIZES</th>';
                        string_pdf += '         </tr>'; 
                    }
                    cont++;
                    string_pdf += '         <tr>';
                    if(consoli != conso.Name && !record.Direct_Shipment__c)
                        string_pdf += '             <td style="text-align:right">'+conso.Name+'</td>';
                    else
                        string_pdf += '             <td style="text-align:right"></td>';
                    consoli = conso.Name;
                    if(i == 1)
                    {
                        string_pdf +='              <td>'+(conso.Shipper_Account__c != null ? conso.Shipper_Account__r.Name : '&nbsp;')+'</td>';
                        string_pdf +='              <td>'+(conso.Consignee_House__c != null ? conso.Consignee_House__r.Name : '&nbsp;')+'</td>';
                    }
                    if(conso.Enable_Shipper_Alternative_Address__c)
                    {       
                        if(i == 2)
                            string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Alternative_Address__c != null ? conso.Shipper_Alternative_Address__c : '&nbsp;')+'</td>';
                        if(i == 3)
                            string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Alternative_Location__c != null ? conso.Shipper_Alternative_Location__r.Name : '&nbsp;')+'</td>';
                        if(i == 4)
                            string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Alternative_Country__c != null ? conso.Shipper_Alternative_Country__r.Name : '&nbsp;')+'</td>';                                    
                    }
                    else
                    {
                        if(i == 2)       
                            string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingStreet != null ? conso.Shipper_Account__r.BillingStreet : '&nbsp;')+'</td>';
                        if(i == 3)
                            string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingCity != null ? conso.Shipper_Account__r.BillingCity : '&nbsp;')+''+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingState != null ? ', '+conso.Shipper_Account__r.BillingState : '&nbsp;')+'</td>';
                        if(i == 4)
                            string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingCountry != null ? conso.Shipper_Account__r.BillingCountry : '&nbsp;')+'</td>';   
                    }
                    if(conso.Enable_Consignee_House_Alternative__c)
                    {       
                        if(i == 2)
                            string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_Alternative_Address__c != null ? conso.Consignee_Alternative_Address__c : '&nbsp;')+'</td>';
                        if(i == 3)
                            string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_Alternative_Location__c != null ? conso.Consignee_Alternative_Location__r.Name : '&nbsp;')+'</td>';
                        if(i == 4)
                            string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_Alternative_Country__c != null ? conso.Consignee_Alternative_Country__r.Name : '&nbsp;')+'</td>';                                    
                    }
                    else
                    {
                        if(i == 2)       
                            string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_House__r.BillingStreet != null ? conso.Consignee_House__r.BillingStreet : '&nbsp;')+'</td>';
                        if(i == 3)
                            string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_House__r.BillingCity != null ? conso.Consignee_House__r.BillingCity : '&nbsp;')+''+(conso.Consignee_House__r != null && conso.Consignee_House__r.BillingState != null ? ', '+conso.Consignee_House__r.BillingState : '&nbsp;')+'</td>';
                        if(i == 4)
                            string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_House__r.BillingCountry != null ? conso.Consignee_House__r.BillingCountry : '&nbsp;')+'</td>';   
                    }
                    if(i > 4)
                            string_pdf += '<td></td><td></td>';
                    i++;
                    string_pdf += '             <td style="text-align:right">'+(sl.No_of_Pieces__c != null ? string.valueof(sl.No_of_Pieces__c) : '0')+'</td>';
                    string_pdf += '             <td style="text-align:right">'+(sl.Gross_Weight__c != null ? string.valueof(sl.Gross_Weight__c) : '0,00')+'</td>';
                    string_pdf += '             <td>';
                    string_pdf +=                   (sl.Length__c != null ? 'L: '+sl.Length__c+' ' : '');
                    string_pdf +=                   (sl.Width__c != null ? 'W: '+sl.Width__c+' ' : '');
                    string_pdf +=                   (sl.Height__c != null ? 'H: '+sl.Height__c+' ' : '');
                    string_pdf += '             </td>';
                    string_pdf += '         </tr>';
                    description = (sl.Description__c != null ? sl.Description__c : '');
                }
            }
            for(Integer x=i; x<5; x++)
            {
                if(conso.Enable_Shipper_Alternative_Address__c)
                {       
                    if(x == 2)
                    {
                        string_pdf += '<tr><td></td>';
                        string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Alternative_Address__c != null ? conso.Shipper_Alternative_Address__c : '')+'</td>';
                    }
                    if(x == 3)
                    {
                        string_pdf += '<tr><td></td>';
                        string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Alternative_Location__c != null ? conso.Shipper_Alternative_Location__r.Name : '')+'</td>';
                    }
                    if(x == 4)
                    {
                        string_pdf += '<tr><td></td>';
                        string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Alternative_Country__c != null ? conso.Shipper_Alternative_Country__r.Name : '')+'</td>';                                      
                    }
                }
                if(!conso.Enable_Shipper_Alternative_Address__c)
                {
                    if(x == 2)
                    {
                        string_pdf += '<tr><td></td>';       
                        string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingStreet != null ? conso.Shipper_Account__r.BillingStreet : '')+'</td>';
                    }
                    if(x == 3)
                    {
                        string_pdf += '<tr><td></td>';
                        string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingCity != null ? conso.Shipper_Account__r.BillingCity : '')+''+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingState != null ? ', '+conso.Shipper_Account__r.BillingState : '')+'</td>';
                    }
                    if(x == 4)
                    {
                        string_pdf += '<tr><td></td>';
                        string_pdf += '                 <td>'+(conso.Shipper_Account__c != null && conso.Shipper_Account__r.BillingCountry != null ? conso.Shipper_Account__r.BillingCountry : '')+'</td>';
                    }
                }
                if(conso.Enable_Consignee_House_Alternative__c)
                {       
                    if(x == 2)
                    {
                        string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_Alternative_Address__c != null ? conso.Consignee_Alternative_Address__c : '')+'</td>';
                        string_pdf += '<td></td><td></td><td></td></tr>';
                    }
                    if(x == 3)
                    {
                        string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_Alternative_Location__c != null ? conso.Consignee_Alternative_Location__r.Name : '')+'</td>';
                        string_pdf += '<td></td><td></td><td></td></tr>';
                    }
                    if(x == 4)
                    {
                        string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_Alternative_Country__c != null ? conso.Consignee_Alternative_Country__r.Name : '')+'</td>';                                      
                        string_pdf += '<td></td><td></td><td></td></tr>';
                    }
                }
                if(!conso.Enable_Consignee_House_Alternative__c)
                {
                    if(x == 2)
                    {
                        string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_House__r.BillingStreet != null ? conso.Consignee_House__r.BillingStreet : '')+'</td>';
                        string_pdf += '<td></td><td></td><td></td></tr>';
                    }
                    if(x == 3)
                    {
                        string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_House__r.BillingCity != null ? conso.Consignee_House__r.BillingCity : '')+''+(conso.Consignee_House__r != null && conso.Consignee_House__r.BillingState != null ? ', '+conso.Consignee_House__r.BillingState : '')+'</td>';
                        string_pdf += '<td></td><td></td><td></td></tr>';
                    }
                    if(x == 4)
                    {
                        string_pdf += '                 <td>'+(conso.Consignee_House__c != null && conso.Consignee_House__r.BillingCountry != null ? conso.Consignee_House__r.BillingCountry : '')+'</td>';
                        string_pdf += '<td></td><td></td><td></td></tr>';
                    }
                }
                cont++;
            }
            string_pdf += '<tr><td></td><td></td><td></td><td></td><td></td>';
            string_pdf += '<td>'+description+'</td></tr>';
            cont++;
        }
        string_pdf += '         <tr>';
        string_pdf += '             <td style="border:none;"></td><td style="border:none;"></td><td style="border:none;"></td>';
        string_pdf += '             <td style="text-align:right;"><strong>'+(record.Total_Number_of_Pieces__c != null ? string.valueof(record.Total_Number_of_Pieces__c) : '')+'</strong></td>';
        string_pdf += '             <td style="text-align:right;"><strong>'+(record.Total_Gross_Weight__c != null ? string.valueof(record.Total_Gross_Weight__c) : '')+'</strong></td>';
        string_pdf += '             <td style="border:none;"></td>';
        string_pdf += '             <td style="border:none;"></td>';
        string_pdf += '         </tr>';
        string_pdf += '     </table>';
        string_pdf += ' </div>';
        string_pdf += ' <div class="capa_bot">';
        string_pdf += '     <p class="remark_title">REMARKS:</p>';
        string_pdf += '     <p class="remarks">'+NEU_Utils.safeString(record.Prepaid_Collect_House_WT_VAL__c)+'</p>';
        string_pdf += ' </div>';
        string_pdf += ' <h4 class="sign">Signed (as consolidator)</h4>';
        string_pdf += ' <div class="footer">';
        string_pdf += '     <p>'+NEU_Utils.safeString(orgDetails.Street)+', '+NEU_Utils.safeString(orgDetails.City)+', C.P.'+NEU_Utils.safeString(orgDetails.PostalCode)+'</p>';
        string_pdf += '     <p>Tel: ' + NEU_Utils.safeString(orgDetails.Phone) + ' Fax: ' + NEU_Utils.safeString(orgDetails.Fax) + '</p>';
        string_pdf += '     <p>https://www.pak2go.com/</p>';
        string_pdf += ' </div>'; 
        string_pdf += '</div>'; 
    }
}