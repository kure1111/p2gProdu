public class CPV2 {
    
    public CPV2 () {}
    
    public static Comprobante getComprobante(string shipmentID, string TipoComprobante)
    {
        Comprobante cp = new Comprobante();
        
        try{
            
            DataCP dcp = getDataCP(shipmentID);
            
            if(dcp == null)
                throw new BaseException('No se encontró información para este shipment.'); 
            
            Company__c emisor = dcp.emisor;
            Customer_Quote__c datosCP=  dcp.datosCPQuote;
            shipment__C  datosCPShip = dcp.datosCPShip;
            list<Direccion_RepartoSp__c> repartos = dcp.repartos;
            list<Shipment_Line__c> lines =dcp.lines;
            Vehicle__c camion = dcp.camion;
            
            //VARIABLES
            Time myTime = Time.newInstance(0, 0, 0, 0);
            
            DateTime dtSalida = DateTime.newInstance(datosCPShip.ETD_from_Point_of_Load__c, (datosCPShip.ETD_Time_from_Point_of_Load__c != null ? datosCPShip.ETD_Time_from_Point_of_Load__c : myTime));
            DateTime dtllegada = DateTime.newInstance(datosCPShip.ETA_Point_of_Discharge__c, (datosCPShip.ETA_Time_Point_of_Discharge__c != null ? datosCPShip.ETA_Time_Point_of_Discharge__c : myTime));
            
            String dateSalida = dtSalida.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
            String dateLlegada = dtllegada.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
            double totalKms = 0;
            
            //ENCABEZADO
            
            if(tipoComprobante == 'T')
            {
                Integer offset = UserInfo.getTimezone().getOffset( Datetime.now());
                DateTime fechaCreacion = Datetime.now().addSeconds(offset/1000);
                String dateFormated = fechaCreacion.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
                
                system.debug('dateFormated : '+ dateFormated);
                
                String[] arrTest = datosCPShip.Name.split('-');
                string folio = '';
                if(arrTest.size()>0)
                    folio = arrTest[3];
                //SP-FN-21-23456
                CP.fecha=dateFormated;
                CP.serie=datosCPShip.Shipment_Type__c;
                CP.folio=folio;
                CP.subTotal='0.00';
                CP.moneda='XXX';//MXN';  
                CP.lugarExpedicion=(emisor == null ? '': (string.isBlank(emisor.C_digo_Postal__c) ? '' :emisor.C_digo_Postal__c));
                CP.total='0.00';
                CP.TipoDeComprobante=TipoComprobante;
                CP.formaPago=''; //solicitado por dll
                CP.condicionesPago='';//solicitado por dll
                CP.descuento=''; //solicitado por dll
                CP.tipoCambio='';	//solicitado por dll
                CP.confirmacion='';//solicitado por dll
                
                //Emisor Cliente
               /* CP.Emisor = new Emisor();
                CP.Emisor.rfc=(string.isBlank(datosCPShip.account_for__r.TAX_ID__c) ? '' : datosCPShip.account_for__r.TAX_ID__c);
                CP.Emisor.nombre= (string.isBlank(datosCPShip.account_for__r.name) ? '' : datosCPShip.account_for__r.name);
                CP.Emisor.regimenFiscal=  (emisor == null ? '' : (string.isBlank(emisor.Regimen_Fiscal__c) ? '' : emisor.Regimen_Fiscal__c)); */
                
                //Emisor PGL
                CP.Emisor = new Emisor();
                CP.Emisor.rfc= (emisor == null ? '' : (string.isBlank(emisor.RFC__c) ? '' : emisor.RFC__c ));
                CP.Emisor.nombre= (emisor == null ? '' : (string.isBlank(emisor.Name) ? '' : emisor.Name));
                CP.Emisor.regimenFiscal=  (emisor == null ? '' : (string.isBlank(emisor.Regimen_Fiscal__c) ? '' : emisor.Regimen_Fiscal__c));
                
                //Receptor Cliente
               /*
                CP.Receptor = new Receptor();
                CP.Receptor.rfc=(string.isBlank(datosCPShip.account_for__r.TAX_ID__c) ? '' : datosCPShip.account_for__r.TAX_ID__c);
                CP.Receptor.nombre=(string.isBlank(datosCPShip.account_for__r.name) ? '' : datosCPShip.account_for__r.name);
                CP.Receptor.usoCFDI='P01';                       	//PENDIENTE   
                CP.Receptor.residenciaFiscal='';        	//solicitado por dll         
                CP.Receptor.numRegIdTributario='';		//solicitado por dll 
               */
                
                //Receptor PGL
                CP.Receptor = new Receptor();
                CP.Receptor.rfc= (emisor == null ? '' : (string.isBlank(emisor.RFC__c) ? '' : emisor.RFC__c ));
                CP.Receptor.nombre= (emisor == null ? '' : (string.isBlank(emisor.Name) ? '' : emisor.Name));
                CP.Receptor.usoCFDI='S01';//Anterior usoCFDI:P01 || Actual usoCFDI(CartaPorte4.0):S01                       	//PENDIENTE   
                CP.Receptor.residenciaFiscal='';        	//solicitado por dll         
                CP.Receptor.numRegIdTributario='';		//solicitado por dll 

                CP.Conceptos = new Conceptos();
                
                CP.Conceptos.Concepto = new List<Concepto>();
                
                // for(Shipment_Line__c line : lines)
                //{
                Concepto concepto =  new Concepto();
                
                //concepto.ClaveProdServ = (line.Clave_de_Servicio__c != null ? (string.isBlank(line.Clave_de_Servicio__r.Clave_SAT__c)  ? '': line.Clave_de_Servicio__r.Clave_SAT__c ) : '' ) ;
                //concepto.NoIdentificacion =  line.name;
                //concepto.cantidad = string.ValueOf(line.Units_Shipped__c);
                //concepto.ClaveUnidad = (datosCP.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(datosCP.Clave_de_Unidad_de_Peso__r.Clave_SAT__c)  ? '': datosCP.Clave_de_Unidad_de_Peso__r.Clave_SAT__c ) : '' );
                //concepto.Unidad = (datosCP.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(datosCP.Clave_de_Unidad_de_Peso__r.name)  ? '': datosCP.Clave_de_Unidad_de_Peso__r.name ) : '' ); 
                //concepto.Descripcion = (string.isBlank(line.Item_Name__r.name) ? '' : line.Item_Name__r.name ) ;
                //Concepto.valorUnitario= '0.00';				 									//PENDIENTE   
                //Concepto.importe='0.00';	
                //Concepto.descuento=''; //solicitado por la dll
                
                
                Concepto.ClaveProdServ='78101800';  									//PENDIENTE (TRANSPORTADORES)   
                concepto.NoIdentificacion = 'ACT';
                Concepto.cantidad='1';							 									//PENDIENTE   
                Concepto.claveUnidad='ACT';					 									//PENDIENTE  Actividad (Unidad de recuento para definir el número de actividades (actividad: una unidad de trabajo o acción).)
                Concepto.descripcion= 'Flete Nacional';//(string.isBlank(datosCPShip.Description_Packages_Goods__c) ? 'Desconocido' :   datosCPShip.Description_Packages_Goods__c) ;		//PENDIENTE   
                Concepto.valorUnitario= '0.00';				 									//PENDIENTE   
                Concepto.importe='0.00';							 									//PENDIENTE   
                Concepto.unidad='';								    
                Concepto.noIdentificacion='';
                Concepto.descuento='';
                
                CP.Conceptos.Concepto.add(concepto);
                // }
            }
            
            //COMPLEMENTO CP
            CP.Complemento = new Complemento();
            CP.Complemento.CartaPorte = new CartaPorte();
            
            string entradaSalida = '';
// ESTO TIENE QUE SER PROVICIONAL
if(datosCPShip.Shipment_Type__c == 'FI'||datosCPShip.Shipment_Type__c == 'FN'||datosCPShip.Shipment_Type__c == 'PTO'){

    system.debug('lo que tenemos en origen Traslado_Ingreso__c : datosCPShip.Traslado_Ingreso__c'+' y en Clave_SAT__c: '+datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c);
    system.debug('lo que tenemos en destino Traslado_Ingreso__c : datosCPShip.Traslado_Ingreso__c'+' y en Clave_SAT__c: '+datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c);
    if(datosCPShip.Traslado_Ingreso__c=='Ingreso'&& datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c=='DIF'){
        datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c='CMX';
    }
    if(datosCPShip.Traslado_Ingreso__c=='Traslado'&& datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c=='CMX'){
        datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c='CMX';
    }
    if(datosCPShip.Traslado_Ingreso__c=='Ingreso'&& datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c=='DIF'){
        datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c='CMX';
    }
    if(datosCPShip.Traslado_Ingreso__c=='Traslado'&& datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c=='CMX'){
        datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c='CMX';
    }
}
// 
            if(datosCPShip.Shipment_Type__c == 'FI')
                entradaSalida =(datosCPShip.Service_Mode__c != null ? ( datosCPShip.Service_Mode__c == 'EXPORT'? 'Salida'  : 'Entrada' ): '' );
                
            //Ubicacion ORIGEN
            CP.Complemento.CartaPorte.Ubicaciones =  new Ubicaciones();
            CP.Complemento.CartaPorte.Ubicaciones.Ubicacion =  new List<Ubicacion>();
            totalKms = datosCPShip.kms__c;
            
            Ubicacion ubicacion = new Ubicacion(); 
            ubicacion.TipoUbicacion ='Origen' ;
            ubicacion.RFCRemitenteDestinatario  = (string.isBlank(datosCPShip.account_for__r.TAX_ID__c) ? '' : datosCPShip.account_for__r.TAX_ID__c ) ;
            ubicacion.NombreRemitenteDestinatario=(string.isBlank(datosCPShip.account_for__r.name) ? '' : datosCPShip.account_for__r.name);
            ubicacion.FechaHoraSalidaLlegada = dateSalida;
            
            //los pide la dll
            ubicacion.TipoEstacion = '';


            ubicacion.NumRegIdTrib = (string.isBlank(datosCPShip.account_for__r.CPNumero_Registro_de_ID__c) ? '' : datosCPShip.account_for__r.CPNumero_Registro_de_ID__c );
            SYSTEM.DEBUG('[CPV2.getComprobante]NumRegIdTrib: '+datosCPShip.account_for__r.CPNumero_Registro_de_ID__c );
            ubicacion.ResidenciaFiscal= (string.isBlank(datosCPShip.account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c)|| datosCPShip.account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c=='MEX' ? '' : datosCPShip.account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c );
            SYSTEM.DEBUG('[CPV2.getComprobante]ResidenciaFiscal: '+datosCPShip.account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c);
            ubicacion.NumEstacion = '';
            ubicacion.NombreEstacion = '';
            ubicacion.NavegacionTrafico = '';
            
            if(datosCPShip.Account_Origin_Address__c != null)
            {
                ubicacion.Domicilio =  new Domicilio();
                ubicacion.Domicilio.Calle =(string.isBlank(datosCPShip.Account_Origin_Address__r.Calle_cat__c) ? '' : datosCPShip.Account_Origin_Address__r.Calle_cat__c);
                ubicacion.Domicilio.NumeroExterior =(string.isBlank(datosCPShip.Account_Origin_Address__r.Numero_Ext_cp__c) ? '' :  datosCPShip.Account_Origin_Address__r.Numero_Ext_cp__c );
                ubicacion.Domicilio.NumeroInterior =(string.isBlank(datosCPShip.Account_Origin_Address__r.Numero_Int_cat__c) ? '' : datosCPShip.Account_Origin_Address__r.Numero_Int_cat__c );
                ubicacion.Domicilio.Colonia =(datosCPShip.Account_Origin_Address__r.Colonia_cp__c != null ? (string.isBlank(datosCPShip.Account_Origin_Address__r.Colonia_cp__r.Clave_SAT__c)  ? '': datosCPShip.Account_Origin_Address__r.Colonia_cp__r.Clave_SAT__c ) : '' );
                ubicacion.idUbicacion = 'OR' + (string.isBlank(datosCPShip.Account_Origin_Address__r.Folio_Origen_Destino2__c)  ? '': datosCPShip.Account_Origin_Address__r.Folio_Origen_Destino2__c )  ;
                ubicacion.Domicilio.Referencia = (string.isBlank(datosCPShip.Account_Origin_Address__r.referencia__c) ? '' : datosCPShip.Account_Origin_Address__r.referencia__c);
                
                if(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__c != null )
                {
                    ubicacion.Domicilio.CodigoPostal =  (string.isBlank(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.name)  ? '': datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.name ) ;
                    ubicacion.Domicilio.Municipio =(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c != null ? (string.isBlank(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c)  ? '': datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c ) : '' );
                    ubicacion.Domicilio.Estado = (datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c != null ? (string.isBlank(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c)  ? '': datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c ) : '' );
                    ubicacion.Domicilio.Pais = (datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Pais_RefCP__c != null ? (string.isBlank(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c)  ? '': datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c ) : '' );
                    
                    if(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c != null)
                        ubicacion.Domicilio.Localidad = datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c ;
                    
                }
                
            }
            
            CP.Complemento.CartaPorte.Ubicaciones.Ubicacion.add(ubicacion); 
            
            //Ubicaciones Intermedias de DESTINO
            if(repartos.size() > 0 )
            {
                totalKms = 0; 
                ServiceGoogle services = new ServiceGoogle();
                integer pos = 0;
                
                for(Direccion_RepartoSp__c reparto : repartos)
                {
                    Ubicacion ubicacionDestino = new Ubicacion();   
                    ubicacionDestino.TipoUbicacion ='Destino' ;
                    ubicacionDestino.RFCRemitenteDestinatario  =datosCP.client_of_Client__c == null ? (string.isBlank(datosCPShip.account_for__r.TAX_ID__c) ? '' : datosCPShip.account_for__r.TAX_ID__c ) : (string.isBlank(datosCP.client_of_Client__r.TAX_ID__c) ? '' : datosCP.client_of_Client__r.TAX_ID__c ) ;
                        ubicacionDestino.NombreRemitenteDestinatario= datosCP.client_of_Client__c == null ? (string.isBlank(datosCPShip.account_for__r.name) ? '' : datosCPShip.account_for__r.name) : (string.isBlank(datosCP.client_of_Client__r.name) ? '' : datosCP.client_of_Client__r.name);
                            ubicacionDestino.FechaHoraSalidaLlegada = dateLlegada;
                    //los pide la dll
                    ubicacionDestino.TipoEstacion = '';
                    ubicacionDestino.NumRegIdTrib = '';
                    ubicacionDestino.ResidenciaFiscal= '';
                    ubicacionDestino.NumEstacion = '';
                    ubicacionDestino.NombreEstacion = '';
                    ubicacionDestino.NavegacionTrafico = '';
                    
                    if(reparto.Direccion_de_Reparto__C != null )
                    {
                        
                        integer kms = 0;
                        
                        if(pos == 0 && datosCPShip.Account_Origin_Address__c != null )
                            kms  = services.googleMapsDistanceKM(datosCPShip.Account_Origin_Address__r.Address_Coordinates__latitude__s, datosCPShip.Account_Origin_Address__r.Address_Coordinates__longitude__s, reparto.Direccion_de_Reparto__r.Address_Coordinates__latitude__s,reparto.Direccion_de_Reparto__r.Address_Coordinates__longitude__s);
                        else
                            kms  = services.googleMapsDistanceKM(repartos[pos-1].Direccion_de_Reparto__r.Address_Coordinates__latitude__s, repartos[pos-1].Direccion_de_Reparto__r.Address_Coordinates__longitude__s, reparto.Direccion_de_Reparto__r.Address_Coordinates__latitude__s,reparto.Direccion_de_Reparto__r.Address_Coordinates__longitude__s);
                        
                        reparto.kms__c=kms;
                        totalKms += kms;
                        
                        
                        ubicacionDestino.Domicilio =  new Domicilio();
                        
                        ubicacionDestino.Domicilio.Calle =(string.isBlank(reparto.Direccion_de_Reparto__r.Calle_cat__c) ? '' : reparto.Direccion_de_Reparto__r.Calle_cat__c);
                        ubicacionDestino.Domicilio.NumeroExterior =(string.isBlank(reparto.Direccion_de_Reparto__r.Numero_Ext_cp__c) ? '' :  reparto.Direccion_de_Reparto__r.Numero_Ext_cp__c );
                        ubicacionDestino.Domicilio.NumeroInterior =(string.isBlank(reparto.Direccion_de_Reparto__r.Numero_Int_cat__c) ? '' : reparto.Direccion_de_Reparto__r.Numero_Int_cat__c );
                        ubicacionDestino.Domicilio.Colonia =(reparto.Direccion_de_Reparto__r.Colonia_cp__c != null ? (string.isBlank(reparto.Direccion_de_Reparto__r.Colonia_cp__r.Clave_SAT__c)  ? '': reparto.Direccion_de_Reparto__r.Colonia_cp__r.Clave_SAT__c ) : '' );
                        ubicacionDestino.Domicilio.Referencia = (string.isBlank(reparto.Direccion_de_Reparto__r.referencia__c) ? '' :reparto.Direccion_de_Reparto__r.referencia__c);
                        ubicacionDestino.idUbicacion = 'DE'+ (string.isBlank(reparto.Direccion_de_Reparto__r.Folio_Origen_Destino2__c)  ? '': reparto.Direccion_de_Reparto__r.Folio_Origen_Destino2__c )  ;
                        ubicacionDestino.DistanciaRecorrida   = string.valueOf(kms) ;
                        
                        if(reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__c != null)
                        {
                            ubicacionDestino.Domicilio.CodigoPostal = (string.isBlank(reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.name)  ? '': reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.name );                           
                            ubicacionDestino.Domicilio.Municipio =(reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c != null ? (string.isBlank(reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c)  ? '': reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c ) : '' );
                            ubicacionDestino.Domicilio.Estado = (reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c != null ? (string.isBlank(reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c)  ? '': reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c ) : '' );
                            ubicacionDestino.Domicilio.Pais = (reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Pais_RefCP__c != null ? (string.isBlank(reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c)  ? '': reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c ) : '' );
                            
                            if(reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c != null)
                                ubicacionDestino.Domicilio.Localidad = reparto.Direccion_de_Reparto__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c;
                        }  
                    }
                    
                    
                    
                    CP.Complemento.CartaPorte.Ubicaciones.Ubicacion.add(ubicacionDestino); 
                }
                
               datosCPShip.kms__c =  totalKms;
              // update datosCPShip;
               //update repartos;
            }
            
            //Destino
            
            Ubicacion ubicacionDestino = new Ubicacion();
            
            ubicacionDestino.TipoUbicacion ='Destino' ;
            ubicacionDestino.RFCRemitenteDestinatario  =datosCP.client_of_Client__c == null ? (string.isBlank(datosCPShip.account_for__r.TAX_ID__c) ? '' : datosCPShip.account_for__r.TAX_ID__c ) : (string.isBlank(datosCP.client_of_Client__r.TAX_ID__c) ? '' : datosCP.client_of_Client__r.TAX_ID__c ) ;
                ubicacionDestino.NombreRemitenteDestinatario= datosCP.client_of_Client__c == null ? (string.isBlank(datosCPShip.account_for__r.name) ? '' : datosCPShip.account_for__r.name) : (string.isBlank(datosCP.client_of_Client__r.name) ? '' : datosCP.client_of_Client__r.name);
                    ubicacionDestino.FechaHoraSalidaLlegada = dateLlegada;
            
            ubicacionDestino.TipoEstacion = '';
            ubicacionDestino.NumRegIdTrib = '';
            ubicacionDestino.ResidenciaFiscal= '';
            ubicacionDestino.NumEstacion = '';
            ubicacionDestino.NombreEstacion = '';
            ubicacionDestino.NavegacionTrafico = '';
            
            if(datosCPShip.Account_Destination_Address__c != null)
            {
                integer  kms = 0;
                if(repartos.size() > 0 )
                {
                    ServiceGoogle services = new ServiceGoogle();
                    kms  = services.googleMapsDistanceKM(repartos[repartos.size()-1].Direccion_de_Reparto__r.Address_Coordinates__latitude__s, repartos[repartos.size()-1].Direccion_de_Reparto__r.Address_Coordinates__longitude__s, datosCPShip.Account_Destination_Address__r.Address_Coordinates__latitude__s,datosCPShip.Account_Destination_Address__r.Address_Coordinates__longitude__s);
                    
                    totalKms += kms; 
                }  
                
                ubicacionDestino.Domicilio =  new Domicilio();
                
                ubicacionDestino.Domicilio.Calle =(string.isBlank(datosCPShip.Account_Destination_Address__r.Calle_cat__c) ? '' : datosCPShip.Account_Destination_Address__r.Calle_cat__c);
                ubicacionDestino.Domicilio.NumeroExterior =(string.isBlank(datosCPShip.Account_Destination_Address__r.Numero_Ext_cp__c) ? '' :  datosCPShip.Account_Destination_Address__r.Numero_Ext_cp__c );
                ubicacionDestino.Domicilio.NumeroInterior =(string.isBlank(datosCPShip.Account_Destination_Address__r.Numero_Int_cat__c) ? '' : datosCPShip.Account_Destination_Address__r.Numero_Int_cat__c );
                ubicacionDestino.Domicilio.Colonia =(datosCPShip.Account_Destination_Address__r.Colonia_cp__c != null ? (string.isBlank(datosCPShip.Account_Destination_Address__r.Colonia_cp__r.Clave_SAT__c)  ? '': datosCPShip.Account_Destination_Address__r.Colonia_cp__r.Clave_SAT__c ) : '' );
                ubicacionDestino.idUbicacion = 'DE'+ (string.isBlank(datosCPShip.Account_Destination_Address__r.Folio_Origen_Destino2__c)  ? '': datosCPShip.Account_Destination_Address__r.Folio_Origen_Destino2__c )  ;
                ubicacionDestino.DistanciaRecorrida   = repartos.size() == 0 ? string.valueOf(totalKms) :  string.valueOf(kms) ;                  
                ubicacionDestino.Domicilio.Referencia = (string.isBlank(datosCPShip.Account_Destination_Address__r.referencia__c) ? '' : datosCPShip.Account_Destination_Address__r.referencia__c);
                
                if(datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__c != null)
                {
                    ubicacionDestino.Domicilio.CodigoPostal = (string.isBlank(datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.name)  ? '': datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.name );
                    
                    ubicacionDestino.Domicilio.Municipio =(datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c != null ? (string.isBlank(datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c)  ? '': datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c ) : '' );
                    ubicacionDestino.Domicilio.Estado = (datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c != null ? (string.isBlank(datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c)  ? '': datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c ) : '' );
                    ubicacionDestino.Domicilio.Pais = (datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Pais_RefCP__c != null ? (string.isBlank(datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c)  ? '': datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c ) : '' );
                    
                    if(datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c != null )
                        ubicacionDestino.Domicilio.Localidad =  datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c ;
                }
                
                
            }
            
            CP.Complemento.CartaPorte.Ubicaciones.Ubicacion.add(ubicacionDestino); 
            
            //MERCANCIAS
            
            
            CP.Complemento.CartaPorte.Mercancias =  new Mercancias();
            
            // CP.Complemento.CartaPorte.Mercancias.UnidadPeso = (datosCP.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(datosCP.Clave_de_Unidad_de_Peso__r.Clave_SAT__c)  ? '': datosCP.Clave_de_Unidad_de_Peso__r.Clave_SAT__c ) : '' ) ;
            CP.Complemento.CartaPorte.Mercancias.UnidadPeso = 'KGM';
            
            CP.Complemento.CartaPorte.Mercancias.NumTotalMercancias = string.valueof(lines.size()) ;
            CP.Complemento.CartaPorte.Mercancias.CargoPorTasacion = '0.00' ;
            CP.Complemento.CartaPorte.Mercancias.PesoNetoTotal = datosCPShip.Total_Peso_Neto__c == null ? '0.00': string.valueof(datosCPShip.Total_Peso_Neto__c.setScale(2, RoundingMode.HALF_UP));
            
            //if(tipoComprobante == 'I')
            CP.Complemento.CartaPorte.Mercancias.pesoBrutoTotal = datosCPShip.Total_Weight_Kg__c == null ? '0.00':  string.valueof(datosCPShip.Total_Weight_Kg__c.setScale(2, RoundingMode.HALF_UP));
            
            CP.Complemento.CartaPorte.Mercancias.Mercancia = new List<Mercancia>();
            boolean tieneMP = false;
            
            
            for(Shipment_Line__c line : lines)
            {
                Mercancia merca =  new Mercancia();
                merca.BienesTransp = (line.Clave_de_Servicio__c != null ? (string.isBlank(line.Clave_de_Servicio__r.Clave_SAT__c)  ? '': line.Clave_de_Servicio__r.Clave_SAT__c ) : '' ) ;
                merca.Descripcion =(line.Clave_de_Servicio__c != null ? (string.isBlank(line.Clave_de_Servicio__r.NAME)  ? '': (line.Clave_de_Servicio__r.NAME.LENGTH()>19 ? line.Clave_de_Servicio__r.NAME.substring(0, 19) : line.Clave_de_Servicio__r.NAME  ) ): '' ) ;
                merca.ClaveUnidad = (datosCP.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(datosCP.Clave_de_Unidad_de_Peso__r.Clave_SAT__c)  ? '': datosCP.Clave_de_Unidad_de_Peso__r.Clave_SAT__c ) : '' );
                merca.Unidad = (datosCP.Clave_de_Unidad_de_Peso__c != null ? (string.isBlank(datosCP.Clave_de_Unidad_de_Peso__r.name)  ? '': (datosCP.Clave_de_Unidad_de_Peso__r.name.length()>19 ? datosCP.Clave_de_Unidad_de_Peso__r.name.substring(0, 19) : datosCP.Clave_de_Unidad_de_Peso__r.name) ) : '' );
                merca.cantidad = string.ValueOf(line.Units_Shipped__c);
                merca.DescripcionPAK = (string.isBlank(line.CE_Descripcion_PAK__c)  ? '': line.CE_Descripcion_PAK__c )  ;
                
                if(datosCPShip.Shipment_Type__c == 'FI')
                {
                    //if(entradaSalida == 'Entrada' || !string.isBlank(line.pedimento__c)  )
                    merca.Pedimento = (string.isBlank(line.pedimento__c)  ? '': line.pedimento__c )  ;
                   
                    merca.FraccionArancelaria = (line.CP_Fraccion_Arancelaria__c != null ? (string.isBlank(line.CP_Fraccion_Arancelaria__r.Clave_SAT__c)  ? '': line.CP_Fraccion_Arancelaria__r.Clave_SAT__c ) : '' ) ;
                }
                if(line.Clave_de_Servicio__c != null)
                {
                    if( line.Clave_de_Servicio__r.Material_PeligrosoCP__c )
                    {
                        merca.MaterialPeligroso =  'Sí';
                        merca.CveMaterialPeligroso = (line.Material_Peligroso__c != null ? (string.isBlank(line.Material_Peligroso__r.Clave_SAT__c)  ? '': line.Material_Peligroso__r.Clave_SAT__c ) : '' );
                        merca.Embalaje= (line.Embalaje__c != null ? (string.isBlank(line.Embalaje__r.Clave_SAT__c)  ? '': line.Embalaje__r.Clave_SAT__c ) : '' ) ;
                        tieneMP = true;
                    }
                    else if(!line.Clave_de_Servicio__r.Material_PeligrosoCP__c && line.Clave_de_Servicio__r.name.contains('(NP)'))
                    {
                        merca.MaterialPeligroso =  'Sí';
                        merca.CveMaterialPeligroso = (line.Material_Peligroso__c != null ? (string.isBlank(line.Material_Peligroso__r.Clave_SAT__c)  ? '': line.Material_Peligroso__r.Clave_SAT__c ) : '' );
                        merca.Embalaje= (line.Embalaje__c != null ? (string.isBlank(line.Embalaje__r.Clave_SAT__c)  ? '': line.Embalaje__r.Clave_SAT__c ) : '' ) ;
                        tieneMP = true;
                    }
                    
                }
                
                
                merca.PesoEnKg= line.Shipping_Weight_Kg__c == null ? '0.00' : string.valueOf( line.Shipping_Weight_Kg__c.setScale(2, RoundingMode.HALF_UP));
                merca.Moneda = line.CurrencyIsoCode;
                merca.valorMercancia= line.Unit_Origin_Sell_Price__c == null ? '0.00' : string.valueof(line.Unit_Origin_Sell_Price__c.setScale(2, RoundingMode.HALF_UP));
                
                merca.CantidadTransporta = new CantidadTransporta();
                merca.CantidadTransporta.Cantidad = string.ValueOf(line.Units_Shipped__c);
                
                if(datosCPShip.Account_Origin_Address__c != null)
                    merca.CantidadTransporta.IDOrigen = 'OR' + (string.isBlank(datosCPShip.Account_Origin_Address__r.Folio_Origen_Destino2__c)  ? '': datosCPShip.Account_Origin_Address__r.Folio_Origen_Destino2__c )  ;
                
                if(datosCPShip.Account_Destination_Address__c != null)
                    merca.CantidadTransporta.IDDestino =  'DE'+ (string.isBlank(datosCPShip.Account_Destination_Address__r.Folio_Origen_Destino2__c)  ? '': datosCPShip.Account_Destination_Address__r.Folio_Origen_Destino2__c )  ;
                
                CP.Complemento.CartaPorte.Mercancias.Mercancia.add(merca);
            }
            
            CP.Complemento.CartaPorte.Mercancias.Autotransporte = new Autotransporte();
            
            
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.PermSCT = (camion.Tipo_de_Permiso__c != null ? (string.isBlank(camion.Tipo_de_Permiso__r.Clave_SAT__c)  ? '': camion.Tipo_de_Permiso__r.Clave_SAT__c ) : '' )  ;      
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.NumPermisoSCT =  (string.isBlank( camion.Numero_de_Permiso_SCT__c ) ? '' : camion.Numero_de_Permiso_SCT__c) ;
            
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.IdentificacionVehicular = new IdentificacionVehicular();
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.IdentificacionVehicular.ConfigVehicular =  (camion.Configuracion_Vehicularcat__c != null ? (string.isBlank(camion.Configuracion_Vehicularcat__r.Clave_SAT__c)  ? '': camion.Configuracion_Vehicularcat__r.Clave_SAT__c ) : '' );
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.IdentificacionVehicular.PlacaVM = (string.isBlank(camion.Num_Placa_Tracto__c) ? '' :camion.Num_Placa_Tracto__c);
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.IdentificacionVehicular.AnioModeloVM = string.valueof(camion.Ano__c) ;
            
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros = new  Seguros (); 
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros.AseguraCarga = (string.isBlank( camion.Nombre_Aseguradora__c) ? '' :camion.Nombre_Aseguradora__c) ;       
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros.PolizaCarga = (string.isBlank( camion.Numero_Poliza_Seguro__c) ? '' :camion.Numero_Poliza_Seguro__c) ;       
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros.AseguraRespCivil =(string.isBlank( camion.Asegura_Responsabilidad_Civil__c) ? '' :camion.Asegura_Responsabilidad_Civil__c) ;
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros.PolizaRespCivil = (string.isBlank( camion.Poliza_Responsabilidad_civil__c) ? '' :camion.Poliza_Responsabilidad_civil__c)  ; 
            
            if(tieneMP)
            {
                CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros.AseguraMedAmbiente = (string.isBlank( camion.Seguro_Medio_Ambiente__c) ? '' :camion.Seguro_Medio_Ambiente__c)  ;        
                CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros.PolizaMedAmbiente = (string.isBlank( camion.Poliza_Seguro_Medio_Ambiente__c) ? '' :camion.Poliza_Seguro_Medio_Ambiente__c)  ;        
            }
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Seguros.PrimaSeguro= (string.isBlank( camion.Prima_Seguro__c) ? '' :camion.Prima_Seguro__c)   ;
            
            
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Remolques = new Remolques(); 
            CP.Complemento.CartaPorte.Mercancias.Autotransporte.Remolques.Remolque = new List<Remolque>();
            if( camion.Caja_Remolque__c != null)
            {
                Remolque r = new Remolque();
                r.subTipoRem = (camion.Caja_Remolque__r.Tipo_Remolque__c != null ? (string.isBlank(camion.Caja_Remolque__r.Tipo_Remolque__r.Clave_SAT__c)  ? '': camion.Caja_Remolque__r.Tipo_Remolque__r.Clave_SAT__c ) : '' );
                r.placa = (string.isBlank(camion.Caja_Remolque__r.Num_Placa_Caja__c) ? '' : camion.Caja_Remolque__r.Num_Placa_Caja__c);
                
                CP.Complemento.CartaPorte.Mercancias.Autotransporte.Remolques.Remolque.add(r);
            }
            
            if(camion.Caja_Remolque_2__c != null)
            {
                
                Remolque r = new Remolque();
                r.subTipoRem = (camion.Caja_Remolque_2__r.Tipo_Remolque__c != null ? (string.isBlank(camion.Caja_Remolque_2__r.Tipo_Remolque__r.Clave_SAT__c)  ? '': camion.Caja_Remolque_2__r.Tipo_Remolque__r.Clave_SAT__c ) : '' );
                r.placa = (string.isBlank(camion.Caja_Remolque_2__r.Num_Placa_Caja__c) ? '' : camion.Caja_Remolque_2__r.Num_Placa_Caja__c);
                
                CP.Complemento.CartaPorte.Mercancias.Autotransporte.Remolques.Remolque.add(r);
            }
            
            
            
            CP.Complemento.CartaPorte.FiguraTransporte = new FiguraTransporte();          
            CP.Complemento.CartaPorte.FiguraTransporte.TiposFigura = new List<TiposFigura>();
            
            /*01 Operador 
02 Propietario  
03 Arrendador 
04 Notificado*/
            
            if( datosCPShip.National_Operator__c != null)
            {
                
                TiposFigura Operador = new TiposFigura (); 
                Operador.TipoFigura = '01';     
                Operador.RFCFigura = (string.isBlank( datosCPShip.National_Operator__r.RFC_Operador__c) ? '' : datosCPShip.National_Operator__r.RFC_Operador__c);
                Operador.NumLicencia = (string.isBlank( datosCPShip.National_Operator__r.Numlicvig_ope__c) ? '' : datosCPShip.National_Operator__r.Numlicvig_ope__c);
                Operador.NombreFigura  = (string.isBlank(datosCPShip.National_Operator__r.name) ? '' : datosCPShip.National_Operator__r.name);
                // Operador.ResidenciaFiscalFigura;
                
                Operador.Domicilio = new Domicilio ();
                
                Operador.Domicilio.Calle =(string.isBlank(datosCPShip.National_Operator__r.Calle__c) ? '' : datosCPShip.National_Operator__r.Calle__c);
                Operador.Domicilio.NumeroExterior =(string.isBlank(  datosCPShip.National_Operator__r.Num_Exterior__c) ? '' :  datosCPShip.National_Operator__r.Num_Exterior__c);
                // Operador.Domicilio.NumeroInterior = (string.isBlank( datosCPShip.National_Operator__r.Numero_Interior__c) ? '' : datosCPShip.National_Operator__r.Numero_Interior__c);
                Operador.Domicilio.Colonia =( datosCPShip.National_Operator__r.Colonia_Operador__c != null ? (string.isBlank(datosCPShip.National_Operator__r.Colonia_Operador__r.Clave_SAT__c)  ? '': datosCPShip.National_Operator__r.Colonia_Operador__r.Clave_SAT__c ) : '' ) ;
                Operador.Domicilio.Referencia = (string.isBlank(datosCPShip.National_Operator__r.Referencias__c) ? '' :  datosCPShip.National_Operator__r.Referencias__c);
                
                if(datosCPShip.National_Operator__r.Codigo_Postal_Operador__c != null)
                {
                    Operador.Domicilio.CodigoPostal =(string.isBlank(datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Name)  ? '': datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Name ) ;
                    
                    Operador.Domicilio.Municipio =( datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__c != null ? (string.isBlank(datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__r.Clave_SAT__c)  ? '': datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__r.Clave_SAT__c ) : '' );
                    Operador.Domicilio.Estado = ( datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__c != null ? (string.isBlank(datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__r.Clave_SAT__c)  ? '': datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__r.Clave_SAT__c ) : '' )  ;
                    Operador.Domicilio.Pais =  ( datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Pais_RefCP__c != null ? (string.isBlank(datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Pais_RefCP__r.Clave_SAT__c)  ? '': datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Pais_RefCP__r.Clave_SAT__c ) : '' ) ;
                    
                    if(datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Localidad_Ref_CP__c != null )
                        Operador.Domicilio.Localidad =   datosCPShip.National_Operator__r.Codigo_Postal_Operador__r.Localidad_Ref_CP__r.Clave_SAT__c;
                    
                }
                CP.Complemento.CartaPorte.FiguraTransporte.TiposFigura.add(operador);
            }
            
            if( datosCPShip.Operator_2__c != null)
            {
                TiposFigura Operador = new TiposFigura (); 
                Operador.TipoFigura = '01';     
                Operador.RFCFigura = (string.isBlank( datosCPShip.Operator_2__r.RFC_Operador__c) ? '' : datosCPShip.Operator_2__r.RFC_Operador__c);
                Operador.NumLicencia = (string.isBlank( datosCPShip.Operator_2__r.Numlicvig_ope__c) ? '' : datosCPShip.Operator_2__r.Numlicvig_ope__c);
                Operador.NombreFigura  = (string.isBlank(datosCPShip.Operator_2__r.name) ? '' : datosCPShip.Operator_2__r.name);
                
                Operador.Domicilio = new Domicilio ();
                
                Operador.Domicilio.Calle =(string.isBlank(datosCPShip.Operator_2__r.Calle__c) ? '' : datosCPShip.Operator_2__r.Calle__c);
                Operador.Domicilio.NumeroExterior =(string.isBlank(  datosCPShip.Operator_2__r.Num_Exterior__c) ? '' :  datosCPShip.Operator_2__r.Num_Exterior__c);
                // Operador.Domicilio.NumeroInterior = (string.isBlank( datosCPShip.Operator_2__r.Numero_Interior__c) ? '' : datosCPShip.Operator_2__r.Numero_Interior__c);
                Operador.Domicilio.Colonia =( datosCPShip.Operator_2__r.Colonia_Operador__c != null ? (string.isBlank(datosCPShip.Operator_2__r.Colonia_Operador__r.Clave_SAT__c)  ? '': datosCPShip.Operator_2__r.Colonia_Operador__r.Clave_SAT__c ) : '' ) ;   
                Operador.Domicilio.Referencia = (string.isBlank(datosCPShip.Operator_2__r.Referencias__c) ? '' :  datosCPShip.Operator_2__r.Referencias__c);
                
                if(datosCPShip.Operator_2__r.Codigo_Postal_Operador__c != null)
                {
                    Operador.Domicilio.CodigoPostal =(string.isBlank(datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Name)  ? '': datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Name ) ;
                    
                    Operador.Domicilio.Municipio =( datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__c != null ? (string.isBlank(datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__r.Clave_SAT__c)  ? '': datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__r.Clave_SAT__c ) : '' );
                    Operador.Domicilio.Estado = ( datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__c != null ? (string.isBlank(datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__r.Clave_SAT__c)  ? '': datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__r.Clave_SAT__c ) : '' )  ;
                    Operador.Domicilio.Pais =  ( datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Pais_RefCP__c != null ? (string.isBlank(datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Pais_RefCP__r.Clave_SAT__c)  ? '': datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Pais_RefCP__r.Clave_SAT__c ) : '' ) ;
                    
                    if(datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Localidad_Ref_CP__c != null )
                        Operador.Domicilio.Localidad =   datosCPShip.Operator_2__r.Codigo_Postal_Operador__r.Localidad_Ref_CP__r.Clave_SAT__c;
                    
                }
                
                CP.Complemento.CartaPorte.FiguraTransporte.TiposFigura.add(operador);
            }
            
            if(datosCPShip.Forwarder__c == null || tipoComprobante == 'T')
            {
                TiposFigura Propietario = new TiposFigura (); 
                Propietario.TipoFigura = '02';    
                Propietario.RFCFigura=(string.isBlank( datosCPShip.Carrier__r.TAX_ID__c) ? '' :datosCPShip.Carrier__r.TAX_ID__c);
                Propietario.NombreFigura= (string.isBlank(datosCPShip.Carrier__r.name ) ? '' :datosCPShip.Carrier__r.name);
                //  Propietario.numRegIdTribPropietario= '';
                Propietario.ResidenciaFiscalFigura= '';
                
                if(datosCPShip.Carrier__r.Direccion_Principal__c != null)
                {
                    Propietario.Domicilio= new Domicilio();
                    Propietario.Domicilio.calle= (string.isBlank(datosCPShip.Carrier__r.Direccion_Principal__r.Calle_cat__c ) ? '' :datosCPShip.Carrier__r.Direccion_Principal__r.Calle_cat__c);
                    Propietario.Domicilio.numeroExterior= (string.isBlank( datosCPShip.Carrier__r.Direccion_Principal__r.Numero_Ext_cp__c) ? '' : datosCPShip.Carrier__r.Direccion_Principal__r.Numero_Ext_cp__c);
                    //   Propietario.Domicilio.numeroInterior= (string.isBlank( datosCPShip.Carrier__r.Direccion_Principal__r.Numero_Int_cat__c) ? '' :datosCPShip.Carrier__r.Direccion_Principal__r.Numero_Int_cat__c);
                    Propietario.Domicilio.colonia=( datosCPShip.Carrier__r.Direccion_Principal__r.Colonia_cp__c != null ? (string.isBlank(datosCPShip.Carrier__r.Direccion_Principal__r.Colonia_cp__r.Clave_SAT__c)  ? '': datosCPShip.Carrier__r.Direccion_Principal__r.Colonia_cp__r.Clave_SAT__c ) : '' ) ;
                    Propietario.Domicilio.referencia=(string.isBlank(  datosCPShip.Carrier__r.Direccion_Principal__r.Referencia__c) ? '' : datosCPShip.Carrier__r.Direccion_Principal__r.Referencia__c);

                    if(datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__c != null)
                    {
                        Propietario.Domicilio.codigoPostal=(string.isBlank(datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.name)  ? '': datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.name )  ;
                        
                        Propietario.Domicilio.municipio=( datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c != null ? (string.isBlank(datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c)  ? '': datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c ) : '' );
                        Propietario.Domicilio.estado=( datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c != null ? (string.isBlank(datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c)  ? '': datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c ) : '' );
                        Propietario.Domicilio.pais= ( datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__c != null ? (string.isBlank(datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c)  ? '': datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c ) : '' );
                        
                        if(datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c != null)
                            Propietario.Domicilio.localidad=datosCPShip.Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c ;
                        
                    }                
                    
                }
                
            }
            
            if(datosCPShip.Forwarder__c != null &&  tipoComprobante == 'I')
            {
                TiposFigura Arrendatario = new TiposFigura (); 
                Arrendatario.TipoFigura = '03';    
                Arrendatario.RFCFigura=(string.isBlank( datosCPShip.Forwarder__r.TAX_ID__c) ? '' :datosCPShip.Forwarder__r.TAX_ID__c);
                Arrendatario.NombreFigura= (string.isBlank(datosCPShip.Forwarder__r.name ) ? '' :datosCPShip.Forwarder__r.name);
                //Arrendatario.numRegIdTribArrendatario= '';
                Arrendatario.ResidenciaFiscalFigura= '';
                
                if(datosCPShip.Forwarder__r.Direccion_Principal__c != null)
                {
                    Arrendatario.Domicilio= new Domicilio();
                    Arrendatario.Domicilio.calle= (string.isBlank(datosCPShip.Forwarder__r.Direccion_Principal__r.Calle_cat__c ) ? '' :datosCPShip.Forwarder__r.Direccion_Principal__r.Calle_cat__c);
                    Arrendatario.Domicilio.numeroExterior= (string.isBlank( datosCPShip.Forwarder__r.Direccion_Principal__r.Numero_Ext_cp__c) ? '' : datosCPShip.Forwarder__r.Direccion_Principal__r.Numero_Ext_cp__c);
                    //Arrendatario.Domicilio.numeroInterior= (string.isBlank( datosCPShip.Forwarder__r.Direccion_Principal__r.Numero_Int_cat__c) ? '' :datosCPShip.Forwarder__r.Direccion_Principal__r.Numero_Int_cat__c);
                    Arrendatario.Domicilio.colonia=( datosCPShip.Forwarder__r.Direccion_Principal__r.Colonia_cp__c != null ? (string.isBlank(datosCPShip.Forwarder__r.Direccion_Principal__r.Colonia_cp__r.Clave_SAT__c)  ? '': datosCPShip.Forwarder__r.Direccion_Principal__r.Colonia_cp__r.Clave_SAT__c ) : '' ) ;
                    Arrendatario.Domicilio.referencia=(string.isBlank(  datosCPShip.Forwarder__r.Direccion_Principal__r.Referencia__c) ? '' : datosCPShip.Forwarder__r.Direccion_Principal__r.Referencia__c);
                    
                    if(datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__c != null)
                    {
                        Arrendatario.Domicilio.codigoPostal=(string.isBlank(datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.name)  ? '': datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.name )  ;
                        
                        Arrendatario.Domicilio.municipio=( datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c != null ? (string.isBlank(datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c)  ? '': datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c ) : '' );
                        Arrendatario.Domicilio.estado=( datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c != null ? (string.isBlank(datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c)  ? '': datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c ) : '' );
                        Arrendatario.Domicilio.pais= ( datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__c != null ? (string.isBlank(datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c)  ? '': datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c ) : '' );
                        
                        if(datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c != null)
                            Arrendatario.Domicilio.localidad=datosCPShip.Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c ;
                        
                    }  
                    
                    
                }
            }
            
            if(datosCPShip.Shipment_Type__c == 'FI')
            {
                CP.Complemento.CartaPorte.transpInternac  = 'Sí';
                CP.Complemento.CartaPorte.EntradaSalidaMerc = entradaSalida;
                  CP.Complemento.CartaPorte.ViaEntradaSalida = '01' ;
                 CP.Complemento.CartaPorte.PaisOrigenDestino = (datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__C != null ? (string.isBlank(datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c)  ? '': datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c ) : '' );

            }
            else
            {
                CP.Complemento.CartaPorte.transpInternac  = 'No';
                CP.Complemento.CartaPorte.PaisOrigenDestino = '';
            }
            
            CP.Complemento.CartaPorte.totalDistRec = string.valueOf(totalKms);
            CP.Complemento.CartaPorte.version = '2.0';
            
        }
        catch(exception e)
        {
            system.debug(' Error en CP.getComprobante ' + e.getStackTraceString() + ' ' + e.getMessage() );
            throw e;
        }
        
        
        return cp;
        
        
    }
    
    public static DataCP getDataCP(string shipmentID)
    {
        try
        {
            DataCP cp = new DataCP();
            
            list <Company__c> emisores= [SELECT 
                                         RFC__c, //Emisor rfc
                                         Regimen_Fiscal__c, //Emisor regimenFiscal
                                         Name, //Emisor nombre
                                         C_digo_Postal__c
                                         FROM Company__c limit 1];
            
            if(!test.isRunningTest()){
                
                if(emisores.size()==0)
                	throw new BaseException('No existe información de Emisor en Company__c'); 
                
                else 
                    cp.emisor = emisores[0];
                
                if( cp.emisor.RFC__c == null || cp.emisor.Regimen_Fiscal__c == null || cp.emisor.Name == null || cp.emisor.C_digo_Postal__c == null )
                	throw new BaseException('Información de Emisor incompleta en Company__c'); 
            }
            
            
            list<Customer_Quote__c>datosCPs = [SELECT 
                                               id,
                                               // name,
                                               client_of_Client__c,
                                               client_of_Client__r.TAX_ID__c,//Receptor rfc
                                               Client_of_Client__r.name, //Receptor nombre
                                               // FolioResume__c,  //SERIE
                                               Clave_de_Unidad_de_Peso__c,
                                               Clave_de_Unidad_de_Peso__r.name,
                                               Clave_de_Unidad_de_Peso__r.Clave_SAT__c
                                               FROM Customer_Quote__c 
                                               where Last_Shipment__c  =: shipmentID limit 1 ];
            
            if(datosCPs.size()==0)
                throw new BaseException('No se encontró un Folio para este shipment.'); 
            else 
                cp.datosCPquote = datosCPs[0];
            
            if(cp.datosCPquote.Clave_de_Unidad_de_Peso__c == null)
                throw new BaseException('Folio no cuenta con Unidad de Peso'); 
            
            if(cp.datosCPquote.client_of_Client__c != null)
                if(cp.datosCPquote.client_of_Client__r.TAX_ID__c == null)
                throw new BaseException('Client of Client no cuenta con TAX ID/RFC'); 
            
            
            list<shipment__C>datosCPShips = [SELECT 
                                             id,
                                             name,
                                             Shipment_Type__c,
                                             Description_Packages_Goods__c, //DESCRIPCION 
                                             Vehicle__c,
                                             kms__c,
                                             ETD_from_Point_of_Load__c,
                                             ETA_Point_of_Discharge__c,
                                             ETD_Time_from_Point_of_Load__c,
                                             ETA_Time_Point_of_Discharge__c,
                                             Total_Weight_Kg__c,
                                             Total_Peso_Neto__c,
                                             Traslado_Ingreso__c,
                                             Account_Shipment_Reference__c,
                                             Service_Mode__c,
                                             
                                             Account_Origin_Address__c,
                                             Account_Origin_Address__r.Direcci_n__c,
                                             Account_Origin_Address__r.Calle_cat__c,
                                             Account_Origin_Address__r.Numero_Ext_cp__c,
                                             Account_Origin_Address__r.Numero_Int_cat__c,
                                             Account_Origin_Address__r.Colonia_cp__c,
                                             Account_Origin_Address__r.Colonia_cp__r.Clave_SAT__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.Pais_RefCP__c,
                                             //Account_Origin_Address__r.Codigo_PostalCP__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__c,
                                             Account_Origin_Address__r.Codigo_Postal_CP__r.name,
                                             Account_Origin_Address__r.Referencia__c,
                                             Account_Origin_Address__r.Folio_Origen_Destino2__c,
                                             Account_Origin_Address__r.Address_Coordinates__latitude__s,
                                             Account_Origin_Address__r.Address_Coordinates__longitude__s,
                                             
                                             Account_Destination_Address__c,
                                             Account_Destination_Address__r.Direcci_n__c,
                                             Account_Destination_Address__r.Calle_cat__c,
                                             Account_Destination_Address__r.Numero_Ext_cp__c,
                                             Account_Destination_Address__r.Numero_Int_cat__c,
                                             Account_Destination_Address__r.Colonia_cp__c,
                                             Account_Destination_Address__r.Colonia_cp__r.Clave_SAT__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.Pais_RefCP__c,
                                             //Account_Destination_Address__r.Codigo_PostalCP__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__c,
                                             Account_Destination_Address__r.Codigo_Postal_CP__r.name,
                                             Account_Destination_Address__r.Referencia__c,
                                             Account_Destination_Address__r.Folio_Origen_Destino2__c,
                                             Account_Destination_Address__r.Address_Coordinates__latitude__s,
                                             Account_Destination_Address__r.Address_Coordinates__longitude__s,
                                             
                                             
                                             
                                             account_for__c,
                                             account_for__r.TAX_ID__c, //Receptor rfc
                                             account_for__r.CPNumero_Registro_de_ID__c,
                                             account_for__r.name, //Receptor nombre
                                             account_for__r.Direccion_Principal__r.Direcci_n__c,
                                             account_for__r.Direccion_Principal__c,
                                             account_for__r.Direccion_Principal__r.Calle_cat__c,
                                             account_for__r.Direccion_Principal__r.Numero_Ext_cp__c,
                                             account_for__r.Direccion_Principal__r.Numero_Int_cat__c,
                                             account_for__r.Direccion_Principal__r.Colonia_cp__c,
                                             account_for__r.Direccion_Principal__r.Colonia_cp__r.Clave_SAT__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__c,
                                             // account_for__r.Direccion_Principal__r.Codigo_PostalCP__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__c,
                                             account_for__r.Direccion_Principal__r.Codigo_Postal_CP__r.name,
                                             account_for__r.Direccion_Principal__r.Referencia__c,
                                             account_for__r.Direccion_Principal__r.Folio_Origen_Destino2__c,
                                             
                                             National_Operator__c,
                                             National_Operator__r.Direcci_n__c,
                                             National_Operator__r.Calle__c,
                                             National_Operator__r.Num_Exterior__c,
                                             National_Operator__r.Numero_Interior__c,
                                             National_Operator__r.Colonia_Operador__c,
                                             National_Operator__r.Colonia_Operador__r.Clave_SAT__c,
                                             National_Operator__r.Referencias__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Localidad_Ref_CP__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Localidad_Ref_CP__r.Clave_SAT__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__r.Clave_SAT__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Municipio_Ref_CP__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Pais_RefCP__r.Clave_SAT__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.Pais_RefCP__c,                               
                                             // National_Operator__r.Codigo_Postal__c,
                                             National_Operator__r.Codigo_Postal_Operador__c,
                                             National_Operator__r.Codigo_Postal_Operador__r.name,
                                             National_Operator__r.RFC_Operador__c,
                                             National_Operator__r.Numlicvig_ope__c,
                                             National_Operator__r.name,
                                             
                                             
                                             //OP 2
                                             Operator_2__c,
                                             Operator_2__r.Direcci_n__c,
                                             Operator_2__R.Calle__c,
                                             Operator_2__R.Num_Exterior__c,
                                             Operator_2__R.Numero_Interior__c,
                                             Operator_2__R.Colonia_Operador__c,
                                             Operator_2__R.Colonia_Operador__r.Clave_SAT__c,
                                             Operator_2__R.Referencias__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Localidad_Ref_CP__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Localidad_Ref_CP__r.Clave_SAT__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Municipio_Ref_CP__r.Clave_SAT__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Municipio_Ref_CP__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Clave_Relacion_SAT__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Pais_RefCP__r.Clave_SAT__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.Pais_RefCP__c,                
                                             Operator_2__R.Codigo_Postal_Operador__c,
                                             Operator_2__R.Codigo_Postal_Operador__r.name,
                                             Operator_2__R.RFC_Operador__c,
                                             Operator_2__R.Numlicvig_ope__c,
                                             Operator_2__R.name,
                                             
                                             Carrier__c,
                                             Carrier__r.TAX_ID__c,
                                            /* Carrier__R.Numero_de_Permiso_SCT__c,
                                             Carrier__R.Tipo_de_Permiso__c,
                                             Carrier__R.Tipo_de_Permiso__r.Clave_SAT__c,   */ 
                                             Carrier__r.name, 
                                             Carrier__r.Direccion_Principal__c,
                                             Carrier__r.Direccion_Principal__r.Direcci_n__c,
                                             Carrier__r.Direccion_Principal__r.Calle_cat__c,
                                             Carrier__r.Direccion_Principal__r.Numero_Ext_cp__c,
                                             Carrier__r.Direccion_Principal__r.Numero_Int_cat__c,
                                             Carrier__r.Direccion_Principal__r.Colonia_cp__c,
                                             Carrier__r.Direccion_Principal__r.Colonia_cp__r.Clave_SAT__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__c,
                                             //Carrier__r.Direccion_Principal__r.Codigo_PostalCP__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__c,
                                             Carrier__r.Direccion_Principal__r.Codigo_Postal_CP__r.name,
                                             Carrier__r.Direccion_Principal__r.Referencia__c,
                                             Carrier__r.Direccion_Principal__r.Folio_Origen_Destino2__c,
                                             
                                             Forwarder__c,
                                             Forwarder__r.TAX_ID__c, 
                                             Forwarder__r.name,
                                             Forwarder__r.Direccion_Principal__c,
                                             Forwarder__r.Direccion_Principal__r.Direcci_n__c,
                                             Forwarder__r.Direccion_Principal__r.Calle_cat__c,
                                             Forwarder__r.Direccion_Principal__r.Numero_Ext_cp__c,
                                             Forwarder__r.Direccion_Principal__r.Numero_Int_cat__c,
                                             Forwarder__r.Direccion_Principal__r.Colonia_cp__c,
                                             Forwarder__r.Direccion_Principal__r.Colonia_cp__r.Clave_SAT__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.Pais_RefCP__c,
                                             //Forwarder__r.Direccion_Principal__r.Codigo_PostalCP__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__c,
                                             Forwarder__r.Direccion_Principal__r.Codigo_Postal_CP__r.name,
                                             Forwarder__r.Direccion_Principal__r.Referencia__c,
                                             Forwarder__r.Direccion_Principal__r.Folio_Origen_Destino2__c
                                             FROM shipment__C 
                                             where id  =: shipmentID limit 1 ];

            
            if(datosCPShips.size()==0)
                throw new BaseException('No existe información del shipment.'); 
            else 
                cp.datosCPShip = datosCPShips[0];
            
            
            if(cp.datosCPShip.Account_Destination_Address__c == null)
                throw new BaseException('Favor de seleccionar un Destination Address.');  
            else if(cp.datosCPShip.Account_Destination_Address__r.Codigo_Postal_CP__c == null)
                throw new BaseException('Destination Address no cuenta con un codigo postal.');  
            
            if(cp.datosCPShip.Account_Origin_Address__c == null)
                throw new BaseException('Favor de seleccionar un Origin Address.'); 
             else if(cp.datosCPShip.Account_Origin_Address__r.Codigo_Postal_CP__c == null)
                throw new BaseException('Origin Address no cuenta con un codigo postal.');  
            
            if(cp.datosCPShip.account_for__c == null)
                throw new BaseException('Favor de seleccionar un Customer'); 
            if(cp.datosCPShip.Vehicle__c == null)
                throw new BaseException('Favor de seleccionar un Vehicle'); 
            if(cp.datosCPShip.account_for__c == null)
                throw new BaseException('Favor de seleccionar un Customer'); 
            
            if(cp.datosCPShip.National_Operator__c == null)
                throw new BaseException('Favor de seleccionar un Operator');
            else if(cp.datosCPShip.National_Operator__c != null)
            {
                if(cp.datosCPShip.National_Operator__R.Codigo_Postal_Operador__c == null)
                    throw new BaseException('Operator no cuenta con un Domicilio Válido');
                if(cp.datosCPShip.National_Operator__R.RFC_Operador__c == null)
                    throw new BaseException('Operator no cuenta con RFC');
                if(cp.datosCPShip.National_Operator__R.Numlicvig_ope__c == null)
                    throw new BaseException('Operator sin Licencia');                    
            }   
            
            if(cp.datosCPShip.Carrier__c == null && cp.datosCPShip.Forwarder__c == null)
                throw new BaseException('Favor de seleccionar un Carrier o Forwarder');                       
            
            
           /* else if(cp.datosCPShip.Carrier__c != null)
            {
                if(cp.datosCPShip.Carrier__R.Numero_de_Permiso_SCT__c == null )
                    throw new BaseException('Carrier no cuenta con Numero de Permiso SCT');
                
                if(cp.datosCPShip.Carrier__R.Tipo_de_Permiso__c == null )
                    throw new BaseException('Carrier no cuenta con Tipo de Permiso');
                                             
            }
              else if(cp.datosCPShip.Forwarder__c != null)
            {
                if(cp.datosCPShip.Forwarder__r.Numero_de_Permiso_SCT__c == null )
                    throw new BaseException('Forwarder no cuenta con Numero de Permiso SCT');
                
                if(cp.datosCPShip.Forwarder__r.Tipo_de_Permiso__c == null )
                    throw new BaseException('Forwarder no cuenta con Tipo de Permiso');
                                             
            }*/
            
            if(cp.datosCPShip.kms__c == 0)
                throw new BaseException('Favor de recalcular KMS recorridos');
            
             cp.repartos =  [SELECT Id, 
                            Name, 
                            Account__c, 
                            Shipment__c, 
                            Punto_de_Reparto__c, 
                            //Import_Export_Quote_Order__c, 
                            Direccion_de_Reparto__c,      
                            kms__c,
                            Direccion_de_Reparto__r.Direcci_n__c,
                            Direccion_de_Reparto__r.Calle_cat__c,
                            Direccion_de_Reparto__r.Numero_Ext_cp__c,
                            Direccion_de_Reparto__r.Numero_Int_cat__c,
                            Direccion_de_Reparto__r.Colonia_cp__c,
                            Direccion_de_Reparto__r.Colonia_cp__r.Clave_SAT__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Localidad_Ref_CP__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Localidad_Ref_CP__r.Clave_SAT__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Municipio_Ref_CP__r.Clave_SAT__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Municipio_Ref_CP__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Clave_Relacion_SAT__r.Clave_SAT__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Pais_RefCP__r.Clave_SAT__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.Pais_RefCP__c,
                            //Direccion_de_Reparto__r.Codigo_PostalCP__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__c,
                            Direccion_de_Reparto__r.Codigo_Postal_CP__r.name,
                            Direccion_de_Reparto__r.Referencia__c,
                            Direccion_de_Reparto__r.Folio_Origen_Destino2__c,
                            Direccion_de_Reparto__r.Address_Coordinates__latitude__s,
                            Direccion_de_Reparto__r.Address_Coordinates__longitude__s
                            FROM Direccion_RepartoSp__c  
                            where Shipment__c  =:  shipmentID 
                            order by Punto_de_Reparto__c asc];
            
            
            cp.lines = [select id, name,
                        Clave_de_Servicio__c,
                        Clave_de_Servicio__r.Clave_SAT__c,
                        Clave_de_Servicio__r.name,
                        Clave_de_Servicio__r.Material_PeligrosoCP__c,
                        Item_Name__c,
                        Item_Name__r.name,
                        Units_Shipped__c,
                        //HazardousCL__c,
                        Material_Peligroso__c ,
                        Material_Peligroso__r.name,
                        Material_Peligroso__r.Clave_SAT__c,
                        Embalaje__c ,
                        Embalaje__r.Clave_SAT__c,
                        Embalaje__r.name,
                        Supplier_Total_Weight_kg__c,
                        Unit_Origin_Sell_Price__c,
                        CurrencyIsoCode,
                        Peso_Neto__c,
                        Item_Price__c,
                        Supplier_Item_Weight_kg__c,
                        Shipping_Weight_Kg__c,
                        CP_Fraccion_Arancelaria__c,
                        CP_Fraccion_Arancelaria__r.Clave_SAT__c,
                        CP_Fraccion_Arancelaria__r.name,
                        SPCL_Item_Height__c,
                        SPCL_Item_Width_cm__c,
                        SPCL_Item_Lenght_cm__c,
                        SPCL_Item_Volume_m3__c,
                        pedimento__c,
                        CE_Descripcion_PAK__c
                        from Shipment_Line__c 
                        where Shipment__c  =: shipmentID];
            
            if(cp.lines.size()==0)
                throw new BaseException('Favor de agregar Cargo lines.'); 
            
            if(cp.lines.size()>0)
            {
                for(Shipment_Line__c line : cp.lines)
                {
                    if(line.Clave_de_Servicio__c == null)
                        throw new BaseException('Cargo line ' + line.name + ' no cuenta con Clave de servicio'); 
                    if(line.Units_Shipped__c == null)
                        throw new BaseException('Cargo line ' + line.name + ' no cuenta con Unidades'); 
                    if(line.Peso_Neto__c == null)
                        throw new BaseException('Cargo line ' + line.name + ' no cuenta con Peso Neto'); 
                    if(line.Shipping_Weight_Kg__c == null)
                        throw new BaseException('Cargo line ' + line.name + ' no cuenta con Peso bruto'); 
                    if(line.Clave_de_Servicio__c != null)  
                        if(line.Clave_de_Servicio__r.Material_PeligrosoCP__c && (line.Material_Peligroso__c== null || line.Embalaje__c == null ) )
                        throw new BaseException('Cargo line ' + line.name + ' no cuenta Material Peligroso o Embalaje'); 
                        
                      if(cp.datosCPShip.Shipment_Type__c == 'FI' || cp.datosCPShip.Shipment_Type__c == 'PTO')
                      { 
                          if(string.isBlank(line.pedimento__c))
                              throw new BaseException('Cargo line ' + line.name + ' no cuenta con Pedimento'); 
                          
                          if(string.isBlank(line.CP_Fraccion_Arancelaria__c))
                              throw new BaseException('Cargo line ' + line.name + ' no cuenta Fracción Arancelaria'); 
                      }
                }
            }
            
            
            list<Vehicle__c>camiones = [SELECT Id,
                                        Num_Placa_Tracto__c,
                                        Ano__c,
                                        Numero_de_Permiso_SCT__c,
                                        Tipo_de_Permiso__c,
                                        Tipo_de_Permiso__r.Clave_SAT__c,  
                                        Configuracion_Vehicularcat__c,
                                        Configuracion_Vehicularcat__r.Clave_SAT__c,
                                        Caja_Remolque__r.Tipo_Remolque__c,
                                        Caja_Remolque__r.Tipo_Remolque__r.Clave_SAT__c,
                                        Caja_Remolque__r.Num_Placa_Caja__c,
                                        Caja_Remolque__c,
                                        Caja_Remolque_2__r.Tipo_Remolque__c,
                                        Caja_Remolque_2__r.Tipo_Remolque__r.Clave_SAT__c, 
                                        Caja_Remolque_2__r.Num_Placa_Caja__c,
                                        Caja_Remolque_2__c,
                                        Nombre_Aseguradora__c,
                                        Numero_Poliza_Seguro__c,
                                        Asegura_Responsabilidad_Civil__c,
                                        Poliza_Responsabilidad_civil__c,
                                        Seguro_Medio_Ambiente__c,
                                        Poliza_Seguro_Medio_Ambiente__c,
                                        Prima_Seguro__c
                                        FROM Vehicle__c
                                        where id =: cp.datosCPShip.Vehicle__c];
            
            
            if(camiones.size()==0)
                throw new BaseException('No existe información para este Vehicle.');
            else 
                cp.camion = camiones[0]; 
            
            if(cp.camion.Caja_Remolque__c == null && cp.camion.Caja_Remolque_2__c == null )
                throw new BaseException('El Vehicle no cuenta con remolques/cajas asignados.');
            if(cp.camion.Configuracion_Vehicularcat__c == null )
                throw new BaseException('El Vehicle no cuenta con Configuración vehicular');
            if(cp.camion.Num_Placa_Tracto__c == null  )
                throw new BaseException('El Vehicle no cuenta con Numero de placa');
            
             if(cp.camion.Nombre_Aseguradora__c == null )
                throw new BaseException('El Vehicle no cuenta con Nombre Aseguradora');
            if(cp.camion.Numero_Poliza_Seguro__c == null  )
                throw new BaseException('El Vehicle no cuenta con Numero de poliza');
             if(cp.camion.Asegura_Responsabilidad_Civil__c == null )
                throw new BaseException('El Vehicle no cuenta con Aseguradora de Responsabilidad Civil');
            if(cp.camion.Poliza_Responsabilidad_civil__c == null  )
                throw new BaseException('El Vehicle no cuenta con Poliza de Responsabilidad civil');
             if(cp.camion.Prima_Seguro__c == null )
                throw new BaseException('El Vehicle no cuenta con Prima de seguro');
            
            if(cp.camion.Numero_de_Permiso_SCT__c == null )
                throw new BaseException('El Vehicle no cuenta con Numero de Permiso SCT');
            
            if(cp.camion.Tipo_de_Permiso__c == null )
                throw new BaseException('El Vehicle no cuenta con Tipo de Permiso');
             
            
            if(cp.camion.Caja_Remolque__c != null )
            {
                 if(cp.camion.Caja_Remolque__r.Tipo_Remolque__c == null )
                      throw new BaseException('La caja 1 del Vehicle no cuenta Tipo de remolque');
                
                if(cp.camion.Caja_Remolque__r.Num_Placa_Caja__c == null )
                      throw new BaseException('La caja 1 del Vehicle no cuenta Numero de placa');
                   
                               
            }
            
            
            if( cp.camion.Caja_Remolque_2__c != null )
            {
                   if(cp.camion.Caja_Remolque_2__r.Tipo_Remolque__c == null )
                      throw new BaseException('La caja 2 del Vehicle no cuenta Tipo de remolque');
                
                if(cp.camion.Caja_Remolque_2__r.Num_Placa_Caja__c == null )
                      throw new BaseException('La caja 2 del Vehicle no cuenta Numero de placa');
            }
               
            
            
            return cp;
        }
        catch(exception e)
        {
            system.debug(' Error en CP.Obtener info para comprobante ' + e.getMessage() + ' ' + e.getStackTraceString() );
            throw e;
        }
    }
    
    
    
    //CLASSES V2 CARTA PORTE
    public class DataCP
    {
        public Company__c emisor {get;set;}
        public Customer_Quote__c  datosCPquote {get;set;}
        public shipment__C  datosCPShip {get;set;}
        public list<Direccion_RepartoSp__c> repartos {get;set;}
        public list<Shipment_Line__c> lines {get;set;}
        public  Vehicle__c camion {get;set;}
    }
    
    public class Emisor { 
        
        public string Rfc { get; set; } 
        
        public string Nombre { get; set; } 
        
        public string RegimenFiscal { get; set; } 
    }
    
    
    public class Receptor { 
        
        public string Rfc { get; set; } 
        
        public string Nombre { get; set; } 
        
        public string UsoCFDI { get; set; } 
        public string ResidenciaFiscal { get; set; }
        
        public string NumRegIdTributario { get; set; }
    }
    
    public class Concepto { 
        
        public string ClaveProdServ { get; set; } 
        
        public string NoIdentificacion { get; set; } 
        
        public string Cantidad { get; set; } 
        
        public string ClaveUnidad { get; set; } 
        
        public string Unidad { get; set; } 
        
        public string Descripcion { get; set; } 
        
        public string ValorUnitario { get; set; } 
        
        public string Importe { get; set; } 
        
        public string Descuento { get; set; }
    }
    
    
    public class Conceptos { 
        
        public List<Concepto> Concepto { get; set; }
    }
    
    public class Domicilio { 
        
        public string Calle { get; set; } 
        
        public string NumeroExterior { get; set; } 
        
        public string NumeroInterior { get; set; } 
        
        public string Colonia { get; set; } 
        
        public string Localidad { get; set; } 
        
        public string Referencia { get; set; } 
        
        public string Municipio { get; set; } 
        
        public string Estado { get; set; } 
        
        public string Pais { get; set; } 
        
        public string CodigoPostal { get; set; } 
    }
    
    public class Ubicacion { 
        
        public Domicilio Domicilio { get; set; } 
        
        public string IDUbicacion { get; set; } 
        
        public string TipoUbicacion { get; set; } 
        
        public string RFCRemitenteDestinatario { get; set; } 
        
        public string NombreRemitenteDestinatario { get; set; }
        
        public string FechaHoraSalidaLlegada { get; set; } 
        
        public string DistanciaRecorrida { get; set; } 
        
        public string TipoEstacion { get; set; }
        public string NumRegIdTrib { get; set; }
        public string ResidenciaFiscal { get; set; }
        public string NumEstacion { get; set; }
        public string NombreEstacion { get; set; }
        public string NavegacionTrafico { get; set; }
    }
    
    public class Ubicaciones { 
        
        public List<Ubicacion> Ubicacion { get; set; } 
    }
    
    public class CantidadTransporta { 
        
        public string Cantidad { get; set; } 
        
        public string IDOrigen { get; set; } 
        
        public string IDDestino { get; set; } 
    }
    
    public class Mercancia { 
        
        public CantidadTransporta CantidadTransporta { get; set; } 
        
        public string BienesTransp { get; set; } 
        
        public string Descripcion { get; set; } 
        
        public string Cantidad { get; set; } 
        
        public string ClaveUnidad { get; set; }
        
        public string Unidad { get; set; }	
        
        public string PesoEnKg { get; set; } 
        
        public string MaterialPeligroso { get; set; } 
        
        public string CveMaterialPeligroso { get; set; } 
        
        public string Embalaje { get; set; } 
        
        public string Moneda { get; set; }
        
        public string ValorMercancia { get; set; }
        
        public string FraccionArancelaria { get; set; }
        
        public string Pedimento {get;set;}
        
        public string DescripcionPAK {get; set;}
    }
    
    public class IdentificacionVehicular { 
        
        public string ConfigVehicular { get; set; } 
        
        public string PlacaVM { get; set; } 
        
        public string AnioModeloVM { get; set; } 
    }
    
    public class Seguros { 
        
        public string AseguraCarga { get; set; } 
        
        public string PolizaCarga { get; set; } 
        
        public string AseguraRespCivil { get; set; } 
        
        public string PolizaRespCivil { get; set; } 
        
        public string AseguraMedAmbiente { get; set; } 
        
        public string PolizaMedAmbiente { get; set; } 
        
        public string PrimaSeguro { get; set; }
    }
    
    public class Remolque { 
        
        public string SubTipoRem { get; set; } 
        
        public string Placa { get; set; } 
    }
    
    public class Remolques { 
        
        public List<Remolque> Remolque { get; set; } 
    }
    
    public class Autotransporte { 
        
        public IdentificacionVehicular IdentificacionVehicular { get; set; } 
        
        public Seguros Seguros { get; set; } 
        
        public Remolques Remolques { get; set; } 
        
        public string PermSCT { get; set; } 
        
        public string NumPermisoSCT { get; set; } 
    }
    
    public class Mercancias { 
        
        public List<Mercancia> Mercancia { get; set; } 
        
        public Autotransporte Autotransporte { get; set; } 
        
        public string PesoBrutoTotal { get; set; } 
        
        public string PesoNetoTotal { get; set; }
        
        public string UnidadPeso { get; set; } 
        
        public string NumTotalMercancias { get; set; } 
        
        public string CargoPorTasacion { get; set; }
    }
    
    public class TiposFigura { 
        
        public string TipoFigura { get; set; } 
        
        public string RFCFigura { get; set; } 
        
        public string NumLicencia { get; set; } 
        
        public string NombreFigura { get; set; }
        
        public string ResidenciaFiscalFigura { get; set; }
        
        public Domicilio Domicilio { get; set; }
    }
    
    public class FiguraTransporte { 
        
        public List<TiposFigura> TiposFigura { get; set; } 
    }
    
    public class CartaPorte { 
        
        public Ubicaciones Ubicaciones { get; set; } 
        
        public Mercancias Mercancias { get; set; } 
        
        public FiguraTransporte FiguraTransporte { get; set; } 
        
        public string Version { get; set; } 
        
        public string TranspInternac { get; set; } 
        
        public string TotalDistRec { get; set; } 
        public string EntradaSalidaMerc { get; set; }
        public string ViaEntradaSalida { get; set; }
        public string PaisOrigenDestino { get; set; }
    }
    
    public class Complemento { 
        
        public CartaPorte CartaPorte { get; set; } 
    }
    
    public class Comprobante { 
        
        public Emisor Emisor { get; set; } 
        
        public Receptor Receptor { get; set; } 
        
        public Conceptos Conceptos { get; set; } 
        
        public Complemento Complemento { get; set; } 
        
        
        public string Serie { get; set; } 
        
        public string Folio { get; set; } 
        
        public string Fecha { get; set; } 
        
        public string SubTotal { get; set; } 
        
        public string Moneda { get; set; } 
        
        public string Total { get; set; } 
        
        public string TipoDeComprobante { get; set; } 
        
        public string LugarExpedicion { get; set; } 
        
        public string FormaPago { get; set; }
        
        public string CondicionesPago { get; set; }
        public string Descuento { get; set; }
        
        public string TipoCambio { get; set; }
        
        public string Confirmacion { get; set; }
              
    }   
}