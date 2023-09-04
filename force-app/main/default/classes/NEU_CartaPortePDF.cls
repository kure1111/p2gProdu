public with sharing class NEU_CartaPortePDF 
{
    
    public Shipment__c record;
    public string pdf {get;set;}
    
    ApexPages.StandardController con;
    
    public NEU_CartaPortePDF(){}
    
    public NEU_CartaPortePDF(ApexPages.StandardController stdController){
        con = stdController;        
        System.debug('id ->' + con.getRecord().Id);
        
        try 
       	{
       		record = getShipmentByID(con.getRecord().Id);
        } 
        catch(Exception ee){record = new Shipment__c();}
		
		integer cont = 0;
        
        
        //
        CPV2.DataCP dataCP = NULL;
        
        //-------------------------------------------------------------------------------------------
        //Fragmento de código para consultar los documentos asociados del cliente (Account for)
        List<Shipment__c> ship = New List<Shipment__c>();//Lista para consultar el Shipment actual
        Id shipID = con.getRecord().Id;//Variable que almacena el Id del shipment actual
        //Consulta que retornará el Id del cliente asociado al Shipment (Account for)
        ship = [
            SELECT Name, Account_for__c, Account_for__r.Name
            FROM Shipment__c
            WHERE Id =: shipID
        ];
        System.debug('Shipment: '+ship);
        
        //Lista para almacenar los documentos asociados del cliente
        List<Associated_Document__c> documents = New List<Associated_Document__c>();
        //Este ciclo recorre la lista ship
        for(Shipment__c SP : ship){
            documents = [
                SELECT Id, Name, Document_URL__c, Document_Type__c
                FROM Associated_Document__c
               WHERE Account__c =: SP.Account_for__c AND (Document_Type__c = 'QR - Protocolo Devoluciones' OR Document_Type__c = 'QR - Protocolo Acuses' OR Document_Type__c = 'QR - Protocolo Siniestros')
            ];
        }
        System.debug('Documentos: '+documents);
        //-------------------------------------------------------------------------------------
       
        
       List<Carta_Porte__c> cps = getCartaPorteByIdAndType(con.getRecord().Id,'Ingreso');
        
        Carta_Porte__c cp = null;
        
        if(cps.size()>0)
            cp = cps[0];
        
        List<StaticResource> logo_carta_porte = getStaticResourseByName('logo_carta_porte');
         
        List<Shipment_Line__c> cargo_lines = getShipmentLineBySpID(record.Id);

        if(record.Shipment_Type__c == 'FN' || record.Shipment_Type__c == 'PTO' || record.Shipment_Type__c == 'FI')  
        {
            dataCP = CPV2.getDataCP(con.getRecord().Id);
            //VARIABLES
            TimeZone tz = UserInfo.getTimeZone();
            Time myTime = Time.newInstance(0, 0, 0, 0);
            DateTime dtSalida = DateTime.newInstance(dataCP.datosCPShip.ETD_from_Point_of_Load__c, (dataCP.datosCPShip.ETD_Time_from_Point_of_Load__c != null ? dataCP.datosCPShip.ETD_Time_from_Point_of_Load__c : myTime));
            DateTime dtllegada = DateTime.newInstance(dataCP.datosCPShip.ETA_Point_of_Discharge__c, (dataCP.datosCPShip.ETA_Time_Point_of_Discharge__c != null ? dataCP.datosCPShip.ETA_Time_Point_of_Discharge__c : myTime));
            //String dateSalida = dtSalida.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
            String dateSalida = dtSalida.format('yyyy-MM-dd\'T\'HH:mm:ss', tz.getID());
            //String dateLlegada = dtllegada.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
            String dateLlegada = dtllegada.format('yyyy-MM-dd\'T\'HH:mm:ss', tz.getID());
            double totalKms = 0;
            pdf = '';
            pdf += '<div class="pagina"> <div class="container"> <div class="header header_lvl1"> <div class="header_lvl1_left"> <img class="logo_carta_porte" src="/resource/'+logo_carta_porte[0].SystemModStamp.getTime()+'/'+(logo_carta_porte[0].NamespacePrefix != null && logo_carta_porte[0].NamespacePrefix != '' ? logo_carta_porte[0].NamespacePrefix+ '__' : '')+'logo_carta_porte"/> </div> <div class="header_lvl1_right">';
            pdf += '<h3>CFDI Versión: 3.3</h3> <h3 >Pedido: '+dataCP.datosCPShip.Name+'</h3> <h3 >Fecha y Hora de Timbrado: '+(cp != null ?  (cp.Fecha_TFD__c!= null ? string.valueOf(cp.Fecha_TFD__c): '')  : '')+'</h3> <h3 >CP N°: '+(cp != null ? cp.name : '')+'</h3> <h3 >Tipo de Comprobante:  T </h3> <h3 >Customer Reference: '+(dataCP.datosCPShip.Account_Shipment_Reference__c!= null ? dataCP.datosCPShip.Account_Shipment_Reference__c : '')+'</h3> </div> </div> <div class="header header_lvl2"> <div class="cargo_lines"> <table border="0" class="table_data"> <tr> <th>Cantidad</th> <th>Unidad</th><th>Clave</th><th>Descripcion</th><th>Precio</th><th>Importe</th></tr><tr> <td>'+1+'</td> <td>'+'ACT'+'</td> <td>'+'78101800'+'</td>';
            if(dataCP.datosCPShip.Shipment_Type__c == 'FI')      
                pdf += '<td>'+'FLETE INTERNACIONAL'+'</td>';
            else
                pdf += '<td>'+'FLETE NACIONAL'+'</td>';

            //RFC Emisor: Cliente || RFC Receptor: Cliente
            //pdf += '<td>'+0+'</td> <td>'+0+'</td></tr> </table> </div> <div class="cargo_lines"> <table border="0" class="table_data"> <tr> <th>RFC Emisor : </th> <td>'+ (string.isBlank( dataCP.datosCPShip.account_for__r.TAX_ID__c) ? '' :  dataCP.datosCPShip.account_for__r.TAX_ID__c )  +'</td> <th>RFC Receptor : </th> <td>'+(string.isBlank(dataCP.datosCPShip.account_for__r.TAX_ID__c) ? '' : dataCP.datosCPShip.account_for__r.TAX_ID__c)+'</td> <th>Forma Pago : </th> <td>'+''+'</td></tr><tr><th>Nombre del Emisor : </th><td>'+(string.isBlank(dataCP.datosCPShip.account_for__r.name) ? '' : dataCP.datosCPShip.account_for__r.name)+'</td> <th>Nombre del Receptor : </th> <td>'+(string.isBlank(dataCP.datosCPShip.account_for__r.name) ? '' : dataCP.datosCPShip.account_for__r.name)+'</td>';
            //RFC Emisor: PGL || RFC Receptor: PGL
            pdf += '<td>'+0+'</td> <td>'+0+'</td></tr> </table> </div> <div class="cargo_lines"> <table border="0" class="table_data"> <tr> <th>RFC Emisor : </th> <td>'+ (string.isBlank( dataCP.emisor.RFC__c) ? '' :  dataCP.emisor.RFC__c )  +'</td> <th>RFC Receptor : </th> <td>'+(string.isBlank(dataCP.emisor.RFC__c) ? '' : dataCP.emisor.RFC__c)+'</td> <th>Forma Pago : </th> <td>'+''+'</td></tr><tr><th>Nombre del Emisor : </th><td>'+(string.isBlank(dataCP.emisor.Name) ? '' : dataCP.emisor.Name)+'</td> <th>Nombre del Receptor : </th> <td>'+(string.isBlank(dataCP.emisor.Name) ? '' : dataCP.emisor.Name)+'</td>';
            pdf += '<th>Método de pago : </th> <td>'+''+'</td> </tr> <tr> <th>Régimen Fiscal : </th> <td>'+(string.isBlank(dataCP.emisor.Regimen_Fiscal__c) ? '' : dataCP.emisor.Regimen_Fiscal__c)+'</td> <th>Uso de CFDI : </th> <td>'+'S01'+'</td> <th>Condiciones de Pago : </th><td>'+''+'</td></tr><tr><th>Lugar de Expedición: : </th> <td>'+'66367'+'</td><th> </th><td>'+''+'</td><th>Moneda : </th><td>'+'XXX'+'</td></tr></table></div><div class="cargo_lines"><table border="0" class="table_data"><tr><th colspan="4" style="text-align:center">Datos Generales</th></tr><tr><th>Transporte Internacional : </th><th>Entrada o Salida de Mercancías : </th><th>Vía de entrada o salida : </th><th>Total de Distancia recorrida en (KM) : </th></tr><tr>';
            if(dataCP.datosCPShip.Shipment_Type__c == 'FI'){
                string entradaSalida =(dataCP.datosCPShip.Service_Mode__c != null ? ( dataCP.datosCPShip.Service_Mode__c == 'EXPORT'? 'Salida'  : 'Entrada' ): '' );
                pdf += '<td>'+'Sí'+'</td> <td>'+entradaSalida+'</td> <td>'+'Autotransporte'+'</td>'; 
            }
            else{
                pdf += '<td>'+'No'+'</td> <td>'+''+'</td> <td>'+''+'</td>'; 
            }
            pdf += '<td>'+string.valueOf(dataCP.datosCPShip.kms__C)+'</td> </tr> </table> </div> <div class="cargo_lines"> <table border="0" class="table_data"> <tr> <th colspan="16" style="text-align:center">Ubicaciones</th> </tr> <tr> <th colspan="2" style="text-align:center">RFC Destinatario</th> <th colspan="2" style="text-align:center">Destinatario</th> <th colspan="2" style="text-align:center">Tipo Salida  </th> <th colspan="2" style="text-align:center">ID  </th> <th colspan="2" style="text-align:center">LLegada  </th> <th colspan="1" style="text-align:center">Distancia  </th> <th colspan="5" style="text-align:center">Dirección  </th> </tr>';      
            //ORIGEN
            pdf += '<tr> <td colspan="2">'+(string.isBlank(dataCP.datosCPShip.account_for__r.TAX_ID__c) ? '' : dataCP.datosCPShip.account_for__r.TAX_ID__c ) +'</td> <td colspan="2">'+(string.isBlank(dataCP.datosCPShip.account_for__r.Name) ? '' : dataCP.datosCPShip.account_for__r.Name ) +'</td> <td colspan="2">'+'Origen'+'</td>';
        
            if(dataCP.datosCPShip.Account_Origin_Address__c != null)
                pdf += '<td colspan="2">'+'OR' + (string.isBlank(dataCP.datosCPShip.Account_Origin_Address__r.Folio_Origen_Destino2__c)  ? '': dataCP.datosCPShip.Account_Origin_Address__r.Folio_Origen_Destino2__c )  +'</td>';
            else
                pdf += '<td colspan="2">'+''+'</td>';
        
            pdf += '<td colspan="2">'+dateSalida+'</td> <td colspan="1">'+''+'</td>'; 
        
            if(dataCP.datosCPShip.Account_Origin_Address__c != null)
                pdf += '<td colspan="5">'+(string.isBlank(dataCP.datosCPShip.Account_Origin_Address__r.Direcci_n__c) ? '' : dataCP.datosCPShip.Account_Origin_Address__r.Direcci_n__c)+'</td>';
            else
                pdf += '<td colspan="5">'+''+'</td>';   
       
            pdf += '</tr>';  
            //REPARTOS DESTINO         
            decimal  kms = 0;
            if(dataCP.repartos.size()>0){
			    for(Direccion_RepartoSp__c reparto : dataCP.repartos){
                    pdf += '<tr> <td colspan="2">'+(dataCP.datosCPquote.client_of_Client__c == null ? (string.isBlank(dataCP.datosCPShip.account_for__r.TAX_ID__c) ? '' : dataCP.datosCPShip.account_for__r.TAX_ID__c) : (string.isBlank(dataCP.datosCPquote.client_of_Client__r.TAX_ID__c) ? '' : dataCP.datosCPquote.client_of_Client__r.TAX_ID__c)) +'</td> <td colspan="2">'+(dataCP.datosCPquote.client_of_Client__c == null ? (string.isBlank(dataCP.datosCPShip.account_for__r.Name) ? '' : dataCP.datosCPShip.account_for__r.Name) : (string.isBlank(dataCP.datosCPquote.client_of_Client__r.Name) ? '' : dataCP.datosCPquote.client_of_Client__r.Name)) +'</td> <td colspan="2">'+'Destino'+'</td>';
                    if(reparto.Direccion_de_Reparto__C != null )
        	            pdf += '<td colspan="2">'+'DE'+ (string.isBlank(reparto.Direccion_de_Reparto__r.Folio_Origen_Destino2__c)  ? '': reparto.Direccion_de_Reparto__r.Folio_Origen_Destino2__c )  +'</td>';
                    else
         	            pdf += '<td colspan="2">'+''+'</td>';
        
                    pdf += '<td colspan="2">'+dateLlegada+'</td>';
                    kms +=reparto.kms__c != null ? reparto.kms__c : 0;
                    pdf += '<td colspan="1">'+(reparto.kms__c != null ? string.valueof(reparto.kms__c) : '')+'</td>'; 
        
                    if(reparto.Direccion_de_Reparto__C != null )
                        pdf += '<td colspan="5">'+(string.isBlank(reparto.Direccion_de_Reparto__r.Direcci_n__c) ? '' : reparto.Direccion_de_Reparto__r.Direcci_n__c)+'</td>';
                    else
                        pdf += '<td colspan="5">'+''+'</td>';

                    pdf += '</tr>';  
                }
            }
            pdf += '<tr><td colspan="2">'+(dataCP.datosCPquote.client_of_Client__c == null ? (string.isBlank(dataCP.datosCPShip.account_for__r.TAX_ID__c) ? '' : dataCP.datosCPShip.account_for__r.TAX_ID__c) : (string.isBlank(dataCP.datosCPquote.client_of_Client__r.TAX_ID__c) ? '' : dataCP.datosCPquote.client_of_Client__r.TAX_ID__c)) +'</td><td colspan="2">'+(dataCP.datosCPquote.client_of_Client__c == null ? (string.isBlank(dataCP.datosCPShip.account_for__r.Name) ? '' : dataCP.datosCPShip.account_for__r.Name) : (string.isBlank(dataCP.datosCPquote.client_of_Client__r.Name) ? '' : dataCP.datosCPquote.client_of_Client__r.Name)) +'</td><td colspan="2">'+'Destino'+'</td>';
            if(dataCP.datosCPShip.Account_Destination_Address__c != null)
        	    pdf += '<td colspan="2">'+'DE'+ (string.isBlank(dataCP.datosCPShip.Account_Destination_Address__r.Folio_Origen_Destino2__c)  ? '': dataCP.datosCPShip.Account_Destination_Address__r.Folio_Origen_Destino2__c )  +'</td>';
            else
         	    pdf += '<td colspan="2">'+''+'</td>';
        
            pdf += '<td colspan="2">'+dateLlegada+'</td>';
            decimal kmsfinal = 0;
            if(dataCP.repartos.size() == 0 )
                kmsfinal =(dataCP.datosCPShip.kms__c != null ? dataCP.datosCPShip.kms__c : 0 ) ;
            else  
                kmsfinal = dataCP.datosCPShip.kms__c - kms;
            pdf += '<td colspan="1">'+string.valueOf(kmsfinal)+'</td>'; 
        
            if(dataCP.datosCPShip.Account_Destination_Address__c != null)
                pdf += '<td colspan="5">'+(string.isBlank(dataCP.datosCPShip.Account_Destination_Address__r.Direcci_n__c) ? '' : dataCP.datosCPShip.Account_Destination_Address__r.Direcci_n__c)+'</td>';
            else
                pdf += '<td colspan="5">'+''+'</td>';   
    
            pdf += '</tr> </table></div>';
            //COMIENZA MERCANCIAS
            pdf += '<div class="cargo_lines"><table border="0" class="table_data"><tr>';
            if(dataCP.datosCPShip.Shipment_Type__c == 'FI' || dataCP.datosCPShip.Shipment_Type__c == 'PTO')
                pdf += '<th colspan="24" style="text-align:center">Mercancia</th>';
             else
                 pdf += '<th colspan="20" style="text-align:center">Mercancia</th>';
             
            pdf += '</tr><tr>';
            if(dataCP.datosCPShip.Shipment_Type__c == 'FI' || dataCP.datosCPShip.Shipment_Type__c == 'PTO'){
                pdf += '<th colspan="6" style="text-align:center">Unidad de peso</th><th colspan="6" style="text-align:center">Peso bruto  </th><th colspan="6" style="text-align:center">Peso Neto  </th><th colspan="6" style="text-align:center">Total Mercancias </th>';
            }
            else{
                pdf += '<th colspan="5" style="text-align:center">Unidad de peso  </th><th colspan="5" style="text-align:center">Peso bruto  </th><th colspan="5" style="text-align:center">Peso Neto  </th><th colspan="5" style="text-align:center">Total Mercancias </th>';
            }
            pdf += '</tr><tr><td colspan="6">KGM</td><td colspan="6">'+string.valueof(dataCP.datosCPShip.Total_Weight_Kg__c)+'</td><td colspan="7">'+string.valueof(dataCP.datosCPShip.Total_Peso_Neto__c)+'</td><td colspan="7">'+string.valueof(dataCP.lines.size())+'</td></tr><tr>';
            // pdf += '</tr><tr><td colspan="6">'+(dataCP.datosCPquote.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(dataCP.datosCPquote.Clave_de_Unidad_de_Peso__r.Clave_SAT__c)  ? '': dataCP.datosCPquote.Clave_de_Unidad_de_Peso__r.Clave_SAT__c ) : '' ) +'</td><td colspan="6">'+string.valueof(dataCP.datosCPShip.Total_Weight_Kg__c)+'</td><td colspan="7">'+string.valueof(dataCP.datosCPShip.Total_Peso_Neto__c)+'</td><td colspan="7">'+string.valueof(dataCP.lines.size())+'</td></tr><tr>';
            if(dataCP.datosCPShip.Shipment_Type__c == 'FI' || dataCP.datosCPShip.Shipment_Type__c == 'PTO')
                pdf += '<th colspan="24" style="text-align:center">Detalles</th>';
            else
                pdf += '<th colspan="20" style="text-align:center">Detalles</th>';
             
            pdf += '</tr><tr><th colspan="2" style="text-align:center">Bienes Transportados  </th><th colspan="2" style="text-align:center">Descripcion  </th><th colspan="2" style="text-align:center">Descripción de Producto PAK  </th><th colspan="2" style="text-align:center">Cantidad  </th><th colspan="2" style="text-align:center">Clave unidad  </th><th colspan="2" style="text-align:center">Unidad  </th><th colspan="2" style="text-align:center">Moneda  </th><th colspan="2" style="text-align:center">Material Peligroso  </th><th colspan="2" style="text-align:center">Clave Material Peligroso  </th><th colspan="2" style="text-align:center">Embalaje </th>';
            if(dataCP.datosCPShip.Shipment_Type__c == 'FI' || dataCP.datosCPShip.Shipment_Type__c == 'PTO' )
            {
                pdf += '<th colspan="2" style="text-align:center">Fracción Arancelaria  </th> <th colspan="2" style="text-align:center">Pedimento </th>';
            }
            pdf += '</tr>';    
            for(Shipment_Line__c line : dataCP.lines){
                pdf += '<tr> <td colspan="2">'+(line.Clave_de_Servicio__c != null ? (string.isBlank(line.Clave_de_Servicio__r.Clave_SAT__c)  ? '': line.Clave_de_Servicio__r.Clave_SAT__c ) : '' ) +'</td> <td colspan="2">'+(line.Clave_de_Servicio__c != null ? (string.isBlank(line.Clave_de_Servicio__r.NAME)  ? '': line.Clave_de_Servicio__r.NAME ) : '' ) +'</td> <td colspan="2">'+(line.CE_Descripcion_PAK__c != null ? (string.isBlank(line.CE_Descripcion_PAK__c)  ? '': line.CE_Descripcion_PAK__c ) : '' ) +'</td> <td colspan="2">'+ string.ValueOf(line.Units_Shipped__c)+'</td> <td colspan="2">'+(dataCP.datosCPquote.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(dataCP.datosCPquote.Clave_de_Unidad_de_Peso__r.Clave_SAT__c)  ? '': dataCP.datosCPquote.Clave_de_Unidad_de_Peso__r.Clave_SAT__c ) : '' )+'</td> <td colspan="2">'+(dataCP.datosCPquote.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(dataCP.datosCPquote.Clave_de_Unidad_de_Peso__r.name)  ? '': dataCP.datosCPquote.Clave_de_Unidad_de_Peso__r.name ) : '' )+'</td> <td colspan="2">'+line.CurrencyIsoCode+'</td>';
                if(line.Clave_de_Servicio__r.Material_PeligrosoCP__c){
                    pdf += '<td colspan="2">'+'Sí'+'</td><td colspan="2">'+(string.isBlank(line.Material_Peligroso__r.Clave_SAT__c)  ? '': line.Material_Peligroso__r.Clave_SAT__c )+'</td> <td colspan="2">'+(string.isBlank(line.Embalaje__r.Clave_SAT__c)  ? '': line.Embalaje__r.Clave_SAT__c )+'</td>';
                }
                else  if(!line.Clave_de_Servicio__r.Material_PeligrosoCP__c && line.Clave_de_Servicio__r.name.contains('(NP)'))
                {
                    pdf += '<td colspan="2">'+'Sí'+'</td><td colspan="2">'+(string.isBlank(line.Material_Peligroso__r.Clave_SAT__c)  ? '': line.Material_Peligroso__r.Clave_SAT__c )+'</td> <td colspan="2">'+(string.isBlank(line.Embalaje__r.Clave_SAT__c)  ? '': line.Embalaje__r.Clave_SAT__c )+'</td>';
                }
                else
                {
                    pdf += '<td colspan="2">'+'No'+'</td> <td colspan="2">'+''+'</td> <td colspan="2">'+''+'</td>'; 
                }
                 if(dataCP.datosCPShip.Shipment_Type__c == 'FI' || dataCP.datosCPShip.Shipment_Type__c == 'PTO')
                {
                    pdf += '<td colspan="2">'+(string.isBlank(line.CP_Fraccion_Arancelaria__r.name)  ? '': line.CP_Fraccion_Arancelaria__r.name )+'<br/> '+line.CP_Fraccion_Arancelaria__r.Clave_SAT__c+'</td>';
                    pdf += '<td colspan="2">'+(string.isBlank(line.pedimento__c)  ? '': line.pedimento__c )+'</td>';
                }
                pdf += '</tr>';
                pdf += '<tr> <td colspan="6"><b>Item Height(cm):</b>'+ (line.SPCL_Item_Height__c==null  ? 0 : line.SPCL_Item_Height__c )+'</td> <td colspan="6"><b>Item Width(cm):</b>'+ (line.SPCL_Item_Width_cm__c == null ? 0: line.SPCL_Item_Width_cm__c ) +'</td> <td colspan="6"><b>Item Lenght(cm):</b>'+ (line.SPCL_Item_Lenght_cm__c==null  ? 0: line.SPCL_Item_Lenght_cm__c )+'  </td>  <td colspan="6"><b>Item Volume(m3):</b> '+(line.SPCL_Item_Volume_m3__c==null  ? 0: line.SPCL_Item_Volume_m3__c )  +'</td> </tr>';
            }
            pdf += '</table></div> <div class="cargo_lines"> <table border="0" class="table_data"> <tr> <th colspan="24" style="text-align:center">Autotransporte federal</th> </tr> <tr> <th colspan="3" style="text-align:center">Permiso SCT  </th> <th colspan="3" style="text-align:center">No permiso SCT  </th> <th colspan="3" style="text-align:center">Nombre aseguradora  </th> <th colspan="3" style="text-align:center">No Poliza seguro  </th> <th colspan="3" style="text-align:center">Config vehicular  </th> <th colspan="3" style="text-align:center">Placa VM  </th> <th colspan="2" style="text-align:center">Año modelo VM  </th> <th colspan="2" style="text-align:center">Placa Remolque 1 </th> <th colspan="2" style="text-align:center">Placa Remolque 2  </th> </tr> <tr> <td colspan="3">'+ (dataCP.camion.Tipo_de_Permiso__c != null ? (string.isBlank(dataCP.camion.Tipo_de_Permiso__r.Clave_SAT__c)  ? '': dataCP.camion.Tipo_de_Permiso__r.Clave_SAT__c ) : '' )  +'</td> <td colspan="3">'+ (string.isBlank( dataCP.camion.Numero_de_Permiso_SCT__c ) ? '' : dataCP.camion.Numero_de_Permiso_SCT__c)+'</td> <td colspan="3">'+(string.isBlank( dataCP.camion.Nombre_Aseguradora__c) ? '' :dataCP.camion.Nombre_Aseguradora__c) +'</td> <td colspan="3">'+ (string.isBlank( dataCP.camion.Numero_Poliza_Seguro__c) ? '' :dataCP.camion.Numero_Poliza_Seguro__c) +'</td> <td colspan="3">'+(dataCP.camion.Configuracion_Vehicularcat__c != null ? (string.isBlank(dataCP.camion.Configuracion_Vehicularcat__r.Clave_SAT__c)  ? '': dataCP.camion.Configuracion_Vehicularcat__r.Clave_SAT__c ) : '' )+'</td> <td colspan="3">'+(string.isBlank(dataCP.camion.Num_Placa_Tracto__c) ? '' :dataCP.camion.Num_Placa_Tracto__c)+'</td> <td colspan="2">'+string.valueof(dataCP.camion.Ano__c)+'</td> <td colspan="2">'+(string.isBlank(dataCP.camion.Caja_Remolque__c) ? '' :dataCP.camion.Caja_Remolque__r.Num_Placa_Caja__c)+'</td> <td colspan="2">'+(string.isBlank(dataCP.camion.Caja_Remolque_2__c) ? '' :dataCP.camion.Caja_Remolque_2__r.Num_Placa_Caja__c)+'</td> </tr> </table> </div>';
            /*pdf += '			</div>';
            pdf += '			</div>';
            pdf += '<div class="pagina" style="page-break-before:always;">';
            pdf += '	<div class="container">';
            pdf += '		<div class="header header_lvl1">';
            pdf += '			<div class="header_lvl1_left">';
            pdf += '				<img class="logo_carta_porte" src="/resource/'+logo_carta_porte[0].SystemModStamp.getTime()+'/'+(logo_carta_porte[0].NamespacePrefix != null && logo_carta_porte[0].NamespacePrefix != '' ? logo_carta_porte[0].NamespacePrefix+ '__' : '')+'logo_carta_porte"/>';
            pdf += '			</div>';
            pdf += '			<div class="header_lvl1_right">';
            pdf += '				<h3>CFDI Versión: 3.3</h3>';	
            pdf += '				<h3 >Pedido: '+dataCP.datosCPShip.Name+'</h3>';	
            pdf += '				<h3 >Fecha y Hora de Timbrado: '+(cp != null ?  (cp.Fecha_TFD__c!= null ? string.valueOf(cp.Fecha_TFD__c): '')  : '')+'</h3>';	
            pdf += '				<h3 >CP N°: '+(cp != null ? cp.name : '')+'</h3>';	
            pdf += '				<h3 >Tipo de Comprobante:  T </h3>';	
            pdf += '				<h3 >Customer Reference: '+(dataCP.datosCPShip.Account_Shipment_Reference__c!= null ? dataCP.datosCPShip.Account_Shipment_Reference__c : '')+'</h3>';
            pdf += '			</div>';
            pdf += '		</div>';*/
              
            pdf += '<div class="cargo_lines"> <table border="0" class="table_data"> <tr> <th colspan="17" style="text-align:center">Figura de Transporte</th> </tr> <tr> <th colspan="17" style="text-align:center">Operadores</th> </tr> <tr> <th colspan="3" style="text-align:center">RFC  </th> <th colspan="3" style="text-align:center">Nombre  </th> <th colspan="3" style="text-align:center">No Licencia  </th> <th colspan="5" style="text-align:center">Dirección  </th> </tr>';    
            if( dataCP.datosCPShip.National_Operator__c != null){
                pdf += '<tr> <td colspan="3">'+(string.isBlank( dataCP.datosCPShip.National_Operator__r.RFC_Operador__c) ? '' : dataCP.datosCPShip.National_Operator__r.RFC_Operador__c)+'</td> <td colspan="3">'+(string.isBlank(dataCP.datosCPShip.National_Operator__r.name) ? '' : dataCP.datosCPShip.National_Operator__r.name)+'</td> <td colspan="3">'+(string.isBlank( dataCP.datosCPShip.National_Operator__r.Numlicvig_ope__c) ? '' : dataCP.datosCPShip.National_Operator__r.Numlicvig_ope__c)+'</td> <td colspan="5">'+(string.isBlank(dataCP.datosCPShip.National_Operator__r.Direcci_n__c) ? '' : dataCP.datosCPShip.National_Operator__r.Direcci_n__c)+'</td> </tr>';
            }
            if( dataCP.datosCPShip.Operator_2__c != null){
                pdf += '<tr> <td colspan="3">'+(string.isBlank( dataCP.datosCPShip.Operator_2__R.RFC_Operador__c) ? '' : dataCP.datosCPShip.Operator_2__R.RFC_Operador__c)+'</td> <td colspan="3">'+(string.isBlank(dataCP.datosCPShip.Operator_2__R.name) ? '' : dataCP.datosCPShip.Operator_2__R.name)+'</td> <td colspan="3">'+(string.isBlank( dataCP.datosCPShip.Operator_2__R.Numlicvig_ope__c) ? '' : dataCP.datosCPShip.Operator_2__R.Numlicvig_ope__c)+'</td> <td colspan="5">'+(string.isBlank(dataCP.datosCPShip.Operator_2__R.Direcci_n__c) ? '' : dataCP.datosCPShip.Operator_2__R.Direcci_n__c)+'</td> </tr>';  
            }  
            pdf += '</table> </div>';
            if((dataCP.datosCPShip.Traslado_Ingreso__c == 'Traslado'&&cp!= null) || cp!= null){
                pdf += '<div class="qr"> <div class="header_lvl1_leftQR"> <img width="100%" class="logo_qr" src="'+cp.QR__c+'"/> </div> <div class="header_lvl1_rightQR"> <p><strong> Sello digital del SAT</strong> </p> <p>'+  LineSplitter.splitLines(cp.Sello_TFD__c,90)+'</p> <p><strong> Sello digital del CFDI</strong> </p> <p >'+  LineSplitter.splitLines(cp.UUID_TFD__c,90)+'</p> <p><strong> Cadena original del complemento de certificación digital del SAT</strong> </p> <p >'+  LineSplitter.splitLines(cp.Cadena_Original__c,90)+'</p> </div> </div>';
            }
            //INICIA  Protocolos Especiales
            if(dataCP.datosCPShip.Traslado_Ingreso__c == 'Traslado' && documents.size() > 0){//Está condicional permite mostrar los documentos si la lista documents no está vacía y la carta porte es de Traslado
                String extension;//La variable extension se utilizara para consultar el formato del documento asociado (png,jpg,jpeg)
                pdf += '<div class="cargo_lines"> <table border="0" class="table_data"><tr> <th colspan="3" style="text-align:center">Protocolos de operaciones</th> </tr><tr>';
                for(Associated_Document__c docs : documents){//Bucle for para colocar el tipo de documento como nombre de la columna
                    extension = System.Url.getSalesforceBaseUrl().toExternalForm().substringBeforeLast('/') + docs.Document_URL__c;
                    extension = extension.substringAfterLast('.');
                    if(extension == 'png' || extension == 'jpg' || extension == 'jpeg'){
                    	pdf += '<th colspan="1" style="text-align:center">'+docs.Document_Type__c+'</th>';
                    }
                }
                pdf += '</tr><tr align="center">';
                for(Associated_Document__c docs : documents){//Bucle for para mostrar el documento asociado en la tabla de protocolos de operaciones
                    extension = System.Url.getSalesforceBaseUrl().toExternalForm().substringBeforeLast('/') + docs.Document_URL__c;
                    extension = extension.substringAfterLast('.');
                    if(extension == 'png' || extension == 'jpg' || extension == 'jpeg'){
                        System.debug('Se encontró una imagen para el documento de tipo: '+docs.Document_Type__c);
                        pdf += '<td colspan="1"><img src="'+docs.Document_URL__c+'?v=1" width="70" height="70" /></td>';
                    }
                }
                pdf += '</tr></table> </div>';
                
            }
            //TERMINA Protocolos Especiales
            pdf += '</div> </div>';
        }
        else{
            pdf = '';
            //TOP ZONE
            string top_zone = '';
            top_zone += '<div class="container"> <div class="header header_lvl1"> <div class="header_lvl1_left"> <h1>BILL OF LADING</h1> <img class="logo_carta_porte" src="/resource/'+logo_carta_porte[0].SystemModStamp.getTime()+'/'+(logo_carta_porte[0].NamespacePrefix != null && logo_carta_porte[0].NamespacePrefix != '' ? logo_carta_porte[0].NamespacePrefix+ '__' : '')+'logo_carta_porte"/> <p>'+(record.Account_for__c != null ? record.Account_for__r.Name : '')+'</p> <p>';
            top_zone +=(record.Account_for__c != null && record.Account_for__r.BillingStreet != null ? record.Account_for__r.BillingStreet : '');
            top_zone +=(record.Account_for__c != null && record.Account_for__r.BillingCity != null ? ', '+record.Account_for__r.BillingCity : '');
            top_zone +=(record.Account_for__c != null && record.Account_for__r.BillingPostalCode != null ? ', '+record.Account_for__r.BillingPostalCode : '');
            top_zone +=(record.Account_for__c != null && record.Account_for__r.BillingState != null ? ', '+record.Account_for__r.BillingState : '');
            top_zone +=(record.Account_for__c != null && record.Account_for__r.BillingCountry != null ? ', '+record.Account_for__r.BillingCountry : '');
            top_zone += '</p> </div> <div class="header_lvl1_right"> <h1>CARTA PORTE</h1> <p class="info_pedido">Pedido: '+record.Name+'</p> <p class="warning">Le recomendamos que no arriesgue y asegure su mercancía</p> </div> </div> <div class="header header_lvl2"> <div class="header_lvl2_left"> <table border="0" class="table_data"> <tr> <th>REMITENTE / SHIPPER</th> <th>RFC</th> </tr> <tr> <td>'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td> <td>'+(record.Supplier_Account__c != null && record.Supplier_Account__r.TAX_ID__c != null ? record.Supplier_Account__r.TAX_ID__c : '')+'</td> </tr> <tr> <th colspan="2">DIRECCIÓN / ADDRESS</th> </tr> <tr> <td colspan="2">'+(record.Origin_Address__c != null ? record.Origin_Address__c : '')+'</td> </tr> <tr> <th>CONTACTO / CONTACT NAME</th> <th>TELÉFONO / PHONE</th> </tr> <tr>';
            top_zone += '<td>'+(record.Shipper_Contact__c != null ? record.Shipper_Contact__r.Name : '')+'</td> <td>'+(record.Shipper_Contact__c != null && record.Shipper_Contact__r.Phone != null ? record.Shipper_Contact__r.Phone : '')+'</td> </tr> <tr> <th colspan="2">CORREO ELECTRÓNICO / EMAIL</th> </tr> <tr> <td colspan="2">'+(record.Shipper_Contact__c != null && record.Shipper_Contact__r.Email != null ? record.Shipper_Contact__r.Email : '')+'</td> </tr> </table> </div> <div class="header_lvl2_right"> <table border="0" class="table_data"> <tr> <th>DESTINATARIO / CONSIGNEE</th> <th>RFC</th> </tr> <tr> <td>'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td> <td>'+(record.Consignee__c != null && record.Consignee__r.TAX_ID__c != null ? record.Consignee__r.TAX_ID__c : '')+'</td> </tr> <tr> <th colspan="2">DIRECCIÓN / ADDRESS</th> </tr> <tr> <td colspan="2">'+(record.Destination_Address__c != null ? record.Destination_Address__c : '')+'</td> </tr> <tr> <th>CONTACTO / CONTACT NAME</th> <th>TELÉFONO / PHONE</th> </tr> <tr> <td>'+(record.Consignee_Contact__c != null ? record.Consignee_Contact__r.Name : '')+'</td> <td>'+(record.Consignee_Contact__c != null && record.Consignee_Contact__r.Phone != null ? record.Consignee_Contact__r.Phone : '')+'</td> </tr> <tr> <th colspan="2">CORREO ELECTRÓNICO / EMAIL</th> </tr> <tr> <td colspan="2">'+(record.Consignee_Contact__c != null && record.Consignee_Contact__r.Email != null ? record.Consignee_Contact__r.Email : '')+'</td> </tr> </table> </div> </div> <div class="header header_lvl3"> <div class="header_lvl3_left"> <table border="0" class="table_data"> <tr> <th>FACTURAR A / BILL TO</th> <th>RFC</th> </tr> <tr> <td>'+(record.Account_for__c != null ? record.Account_for__r.Name : '')+'</td>';
            top_zone += '<td>'+(record.Account_for__c != null && record.Account_for__r.TAX_ID__c != null ? record.Account_for__r.TAX_ID__c : '')+'</td> </tr> <tr> <th colspan="2">DIRECCIÓN / ADDRESS</th> </tr> <tr> <td colspan="2">'+(record.Account_for__c != null && record.Account_for__r.BillingStreet != null ? record.Account_for__r.BillingStreet : '')+'</td> </tr> <tr> <th>COLONIA / COUNTRY</th> <th>CP / ZIP</th> </tr> <tr> <td>'+(record.Account_for__c != null && record.Account_for__r.BillingCountry != null ? ', '+record.Account_for__r.BillingCountry : '')+'</td> <td>'+(record.Account_for__c != null && record.Account_for__r.BillingPostalCode != null ? ', '+record.Account_for__r.BillingPostalCode : '')+'</td> </tr> <tr> <th>CIUDAD / CITY</th> <th>ESTADO / STATE</th> </tr> <tr> <td>'+(record.Account_for__c != null && record.Account_for__r.BillingCity != null ? ', '+record.Account_for__r.BillingCity : '')+'</td> <td>'+(record.Account_for__c != null && record.Account_for__r.BillingState != null ? ', '+record.Account_for__r.BillingState : '')+'</td> </tr> <tr> <th>CONTACTO / CONTACT NAME</th> <th>TELÉFONO / PHONE</th> </tr> <tr> <td>'+(record.Contact__c != null ? record.Contact__r.Name : '')+'</td> <td>'+(record.Contact__c != null && record.Contact__r.Phone != null ? record.Contact__r.Phone : '')+'</td> </tr> <tr> <th colspan="2">CORREO ELECTRÓNICO / EMAIL</th> </tr> <tr> <td colspan="2">'+(record.Contact__c != null && record.Contact__r.Email != null ? record.Contact__r.Email : '')+'</td> </tr> </table> </div> <div class="header_lvl3_right"> <table border="0" class="table_data"> <tr> <th colspan="4">DATOS UNIDAD</th> </tr> <tr> <th>MARCA</th>';
            top_zone += '<td>'+(record.Vehicle__c != null && record.Vehicle__r.Marca__c != null ? record.Vehicle__r.Marca__c : '')+'</td> <th>PLACAS DE TRACTO</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Num_Placa_Tracto__c != null ? record.Vehicle__r.Num_Placa_Tracto__c : '')+'</td> </tr> <tr> <th>MODELO</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Modelo__c != null ? record.Vehicle__r.Modelo__c : '')+'</td> <th>PLACAS DE CAJA</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Num_Placa_Caja__c != null ? record.Vehicle__r.Num_Placa_Caja__c : '')+'</td> </tr> <tr> <th>COLOR TRACTO</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Color_Tracto__c != null ? record.Vehicle__r.Color_Tracto__c : '')+'</td> <th>NUMERO ECO</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Name != null ? record.Vehicle__r.Name : '')+'</td> </tr> <tr> <th>COLOR CAJA</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Color_Caja__c != null ? record.Vehicle__r.Color_Caja__c : '')+'</td> <th>TIPO CAJA</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Tipo_de_Caja__c != null ? record.Vehicle__r.Tipo_de_Caja__c : '')+'</td> </tr> <tr> <th>TIPO DE UNIDAD</th> <td>'+(record.Vehicle__c != null && record.Vehicle__r.Tipo_de_Unidad__c != null ? record.Vehicle__r.Tipo_de_Unidad__c : '')+'</td> <th>OPERADOR</th>';
            top_zone += '<td>'+(record.National_Operator__c != null && record.National_Operator__r.Name != null ? record.National_Operator__r.Name : '')+'</td> </tr> </table> </div> </div> <div class="middle"> <div class="requirements"> <table class="table_data"> <tr><th colspan="3" align="center" width="33%">REQUERIMIENTOS ESPECIALES</th></tr> <tr> <th align="center" width="33%">ORIGEN</th> <th align="center" width="33%">DESTINO</th> <th align="center" width="33%">DE FACTURACION Y/O COBRANZA</th> </tr> <tr> <td>'+(record.Special_Requirements_Origin__c != null ? record.Special_Requirements_Origin__c : '')+'</td>';
            top_zone += '<td>'+(record.Special_Requirements_Destination__c != null ? record.Special_Requirements_Destination__c : '')+'</td> <td>'+(record.Special_Requirements_Invoicing__c != null ? record.Special_Requirements_Invoicing__c : '')+'</td> </tr> </table> </div> <div class="cargo_lines"> <table class="table_data"> <tr> <th>NMFC CLASS</th> <th>PIEZAS/PCS</th> <th>DESCRIPCION/DESCRIPTION</th> <th>LARGO/LONG</th> <th>ANCHO/WIDE</th> <th>ALTO/HEIGHT</th> <th>PESO/WEIGHT</th> </tr>';
	    
            pdf += '<div class="pagina">'+ top_zone;
    	    for(Shipment_Line__c c : cargo_lines)
	        {
	        	cont++;
                if(cont == 16){
                    pdf += '</table> </div> </div> </div> </div> <div class="pagina" style="page-break-before:always;">';
                    pdf += top_zone;
                    cont = 1;
                }
		        pdf += '<tr> <td>'+(c.Item_Name__c != null && c.Item_Name__r.NMFC__c != null ? c.Item_Name__r.NMFC__c : '')+(c.Item_Name__c != null && c.Item_Name__r.Freight_Class__c != null ? ' ('+c.Item_Name__r.Freight_Class__c+')' : '')+'</td> <td align="right">'+(c.Units_Shipped__c != null ? string.valueof(c.Units_Shipped__c) : '')+'</td> <td>'+(c.Item_Name__c != null ? c.Item_Name__r.Name : '')+'</td> <td align="right">'+c.Packaging_Length_cm__c+'</td> <td align="right">'+c.Packaging_Width_cm__c+'</td><td align="right">'+c.Packaging_Height_cm__c+'</td><td align="right">'+(c.Shipping_Weight_Kg__c != null ? string.valueof(c.Shipping_Weight_Kg__c) : '')+'</td></tr>';
	        }
    	    pdf += '</table> </div> </div> </div> </div>';
	        //LAST PAGE
            pdf += '<div class="pagina" style="page-break-before:always;"><div class="container"><div class="bottom"><div class="notas_text"><h2 class="title_notes">CONDICIONES ACTUALES DEL CONTRATO DE TRANSPORTE QUE AMPARA ESTA CARTA PORTE, CONFORME A LA NORMATIVIDAD VIGENTE.</h2><p>PRIMERA.- El objeto del presente contrato es la Prestación del Servicio de Transporte de Carga, el cual podrá ser local o foráneo, según se determine en la carátula de la carta porte.</p> <p>SEGUNDA.- Para los efectos del presente contrato de transporte se denomina “Porteador”, al transportista y “Remitente” al usuario que contrate el servicio.</p> <p>TERCERA.- El “Remitente” debe declarar al “Porteador” el tipo de mercancía o efectos de que se trate, peso, medidas y/o número de carga que entrega para su transporte y, en su caso el valor de la misma. La carga que se entregue a granel será pesada por el “Porteador” en presencia de el “Remitente” en el primer punto donde haya báscula dentro de la localidad en la cual se celebra el contrato sin que por ningún motivo se rebase el límite establecido por la normatividad aplicable.</p> <p>CUARTA.- Es obligación del “Remitente” declarar verazmente al proveedor, toda la información relativa a la descripción valor, cantidad, peso y demás características de la mercancía que pretende transportar, en caso de falsedad, el “Remitente” asumirá la responsabilidad respectiva.</p> <p>QUINTA.- Para efectos del transporte el “Remitente”, deberá entregar al “Porteador” los documentos que las leyes y reglamentos exijan para llevar a cabo el servicio, en caso de no cumplir con estos requisitos el “Porteador” está obligado a rehusar el transporte de las mercancías.</p> <p>SEXTA.- El “Porteador” deberá recoger y entregar la carga precisamente en los domicilios que señale el “Remitente”, ajustándose a los términos y condiciones convenidos. El “Porteador” sólo está obligado a llevar la carga al domicilio señalado por el remitente para su entrega una sola vez. Si ésta no fuera recibida, se dejará aviso de que la mercancía queda a disposición del interesado en las bodegas que indique el “Porteador”.</p> <p>SÉPTIMA.- El “Porteador”, y el “Remitente” negociarán libremente el precio del servicio, tomando en cuenta su tipo, características de los embarques, volumen, regularidad, clase de carga y sistema de pago.</p> <p>OCTAVA.- El precio del transporte deberá pagarse en origen, salvo convenio entre las partes de pago en destino. Cuando el transporte se hubiere concertado por cobrar, la entrega de las mercancías o efectos se hará contra el pago y el “Porteador”, tendrá derecho a retener mientras no se le cubra el precio convenido.</p> <p>NOVENA.- El “Porteador” queda eximido de la obligación de recibir mercancías o efectos para su transporte, en los siguientes casos:<p> <ul>';
            pdf += '<li>a) Cuando se trate de carga que por su naturaleza, peso, volumen, embalaje defectuoso o cualquier otra circunstancia no pueda transportarse sin destruirse o sin causar daño a los demás artículos o al material rodante, salvo que la empresa de que se trate tenga el equipo adecuado.</li> <li>b) Las mercancías cuyo transporte haya sido prohibido por disposiciones legales o reglamentarias. Cuando tales disposiciones no prohíban precisamente el transporte de determinadas mercancías, pero si ordenen la presentación de ciertos documentos para que puedan ser transportadas, el “Remitente” estará obligado a entregar al “Porteador” los documentos correspondientes.</li> </ul> <p>DÉCIMA.- Para el caso de que el “Remitente” contrate carro por entero, este aceptara la responsabilidad solidaria para con el “Porteador” mediante la figura de la corresponsabilidad que contempla el artículo 10 del Reglamento Sobre el Peso, Dimensiones y Capacidad de los Vehículos de Autotransporte que Transitan en los Caminos y Puentes de Jurisdicción Federal, por lo que el “Remitente” queda obligado a verificar que la carga y el vehículo que la transporta, cumplan con el peso y dimensiones máximas establecidos en la NOM-012-SCT-2-2008. Para el caso de incumplimiento e inobservancia a las disposiciones que regulan el peso y dimensiones, por parte del “Remitente”, este será corresponsable de las infracciones y multas que la Secretaría de Comunicaciones y Transportes y la Policía Federal impongan al “Porteador”, por cargar las unidades con exceso de peso.</p> <p>DECIMA PRIMERA.- Es obligación de “El Porteador” de que el personal que se encargará de las maniobras de carga y descarga de los bienes, se identifiquen plenamente ante el “Remitente”, antes de iniciar las operaciones contratadas, o en su caso se compromete a contratar personal que cumpla con ese requisito.</p> <p>DÉCIMA SEGUNDA.- En caso de pérdida, daños o robo de la mercancía transportada, el “Porteador” cuenta con una póliza de seguro por lo que en caso de darse alguna de las eventualidades antes precisadas es importante que el “Remitente” previamente declare el valor de las mercancías objeto del contrato. En caso de no ser declarado tal valor, si sobrevinieran pérdidas o daños a dichos bienes, el “Porteador” pagará, la cantidad equivalente a 15 días de salario mínimo general vigente en el Distrito Federal por tonelada, o la parte proporcional que corresponda tratándose de embarques de menor peso, de conformidad con el artículo 66 fracción V de la Ley de Caminos, Puentes y Autotransporte Federal vigente.</p> <p>DÉCIMA TERCERA.- Si al momento de la entrega resulta algún faltante o avería, el “Remitente” o “Destinatario” deberá hacerla constar en ese acto en la carta de porte y formular su reclamación por escrito al “Porteador”, dentro de las 24 horas siguientes.</p><p>DÉCIMA CUARTA.- El “Porteador” se obliga a entregar al “Remitente” una copia del presente contrato de adhesión al momento de su firma. (puede ser via correo electrónico).</p><p>DÉCIMA QUINTA.- La Secretaría de Comunicaciones y Transportes es competente en la vía administrativa para resolver cualquier controversia que se suscite sobre la interpretación o cumplimiento del presente contrato. Sin perjuicio de lo anterior, las partes se someten a la jurisdicción que pudiera corresponderles, por razón de sus domicilios presentes o futuros o por cualquier otra razón.</p> </div> </div>';
            pdf += '<table class="firmas"> <tr> <th>EMBARCADOR/SHIPPER</th> <th>#PZAS. ENTREGADAS</th> <th>TRANSPORTISTA/CARRIER</th> <th>#PZAS RECIBIDAS</th> </tr> <tr> <td></td> <td></td> <td></td> <td></td> </tr> <tr> <th colspan="2">NOMBRE Y FIRMA</th> <th colspan="2">NOMBRE Y FIRMA</th> </tr> </table> </div></div>';
        }
    }
    public static Shipment__c getShipmentByID(String shipmentID){
        return [select Id, Name, Account_for__c, Account_for__r.Name, Supplier_Account__c, Supplier_Account__r.Name,
        Shipper_Contact__c, Shipper_Contact__r.Name, Shipper_Contact__r.Phone, Shipper_Contact__r.Email, Consignee__c,
        Consignee__r.Name, Consignee_Contact__c, Consignee_Contact__r.Name, Consignee_Contact__r.Phone, Consignee_Contact__r.Email, Contact__c, Contact__r.Name,
        Contact__r.Phone, Contact__r.Email, Account_for__r.BillingStreet, Account_for__r.BillingCity, Account_for__r.BillingPostalCode, Account_for__r.BillingState, 
        Account_for__r.BillingCountry, Vehicle__c, Origin_Address__c, Destination_Address__c, Special_Requirements_Origin__c, Special_Requirements_Destination__c,
        Special_Requirements_Invoicing__c, Account_for__r.TAX_ID__c, Supplier_Account__r.TAX_ID__c, Consignee__r.TAX_ID__c, National_Operator__r.Name,
        National_Operator__c, National_Operator__r.Marca_ope__c, National_Operator__r.Numplatra_ope__c, National_Operator__r.Numplacaj_ope__c, National_Operator__r.Color_ope__c,
        Vehicle__r.Modelo__c, Vehicle__r.Numero_Eco__c, Vehicle__r.Color_Caja__c, Vehicle__r.Tipo_de_Caja__c, Vehicle__r.Tipo_de_Unidad__c, Vehicle__r.Num_Placa_Tracto__c,
        Vehicle__r.Num_Placa_Caja__c, Vehicle__r.Color_Tracto__c, Vehicle__r.Ano__c, Vehicle__r.Marca__c, Vehicle__r.Name,Shipment_Type__c,Traslado_Ingreso__c
        from Shipment__c where Id =: shipmentID];
    }
    public static  List<Carta_Porte__c> getCartaPorteByIdAndType(String shipmentID, string tipo){
        return [SELECT Id,Name, XML__c, Shipment__c, QR__c, Sello_TFD__c,Fecha_TFD__c, UUID_TFD__c, PDF_Url__c, Cadena_Original__c 
        FROM Carta_Porte__c 
        WHERE Shipment__c =:shipmentID  
        AND Tipo__c!=: tipo
        ORDER by CreatedDate desc limit 1];
    }
    public static  List<StaticResource> getStaticResourseByName(String name){
        return [SELECT Id, Name, Body, SystemModStamp, NamespacePrefix FROM StaticResource WHERE Name =: name];
    }
    public static  List<Shipment_Line__c> getShipmentLineBySpID(String shimentID){
        return [SELECT Id, Name, Item_Name__c, Item_Name__r.NMFC__c, Item_Name__r.Freight_Class__c, Units_Shipped__c, Item_Name__r.Name,
        Packaging_Length_cm__c, Packaging_Width_cm__c, Packaging_Height_cm__c, Shipping_Weight_Kg__c,SPCL_Item_Height__c,SPCL_Item_Width_cm__c,SPCL_Item_Lenght_cm__c,SPCL_Item_Volume_m3__c 
        FROM Shipment_Line__c WHERE Shipment__c =: shimentID];
    }
    public void test()
    {
         string a = '';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         
        
    }
	
}