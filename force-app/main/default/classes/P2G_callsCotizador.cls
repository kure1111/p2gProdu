public class P2G_callsCotizador {
    public static Map<String, Decimal> getCoordinates(String postalCode,String colonia) {
        String coloniaModif = colonia;
		coloniaModif = coloniaModif.replaceAll('(\\s+)','+');
        Map<String, Decimal> coordinates = new Map<String, Decimal>();
        String apiKey = 'AIzaSyDkwLqNdoijG5TO8q9JgMdnXz9yHdEwfWc';
        String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + postalCode + '+' + coloniaModif + '&key=' + apiKey;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (responseBody.containsKey('results') && responseBody.get('results') instanceof List<Object>) {
                List<Object> results = (List<Object>) responseBody.get('results');
                if (!results.isEmpty()) {
                    Map<String, Object> result = (Map<String, Object>) results[0];
                    Map<String, Object> geometry = (Map<String, Object>) result.get('geometry');
                    Map<String, Object> latLng = (Map<String, Object>) geometry.get('location');
                    Double latitude = (Double) latLng.get('lat');
                    Double longitude = (Double) latLng.get('lng');
                    coordinates.put('latitude', latitude);
                    coordinates.put('longitude', longitude);
                    System.debug('coordinates: '+coordinates);
                }
            }
            
        }
        else System.debug('responseCoordinates: '+response);
        return coordinates;
    }
    
    @Future(callout=true)
    public static void altaSAP(String idCuenta,String tipoServicio){
        String IdAcc = idCuenta;
        try{            
            Account ACC = [Select Id,Name,Inerep_cta__c,Acta_Constitutiva_Poder_Rep_Legal__c,Evidencia_de_Visita_del_Vendedor__c,TAX_ID__c,Owner.Workplace__c,Phone,Requiere_Evidencia__c, WCA_ID__c,NEU_Email__c, Workplace_AccOwner__c,
                           Website,Grupo_SAP__c, Tipo_de_Servicio_Prospecto__c, Requiere_Acuse_Sap__c,Tipo_de_Acuse_Sap__c,Requiere_Orden_de_Compra__c,Credit_Terms__c,Monto_Credito_Solicitado__c,Owner.SalesEmployer__c,
                           Credit_Limit__c,Tippag_cta__c,Forpag_cta__c,Uso_CFDI__c,Bank_Name_Supplier_Form2__c,Bank_Account_Number__c,Uso_Portal__c,Periodo_de_Facturacion__c,Fecha_Recepcion_Factura__c,BillingAddress,Payment_Method__c,
                           Portal_de_Proveedores__c,Usuario__c,Contrasena__c,Account_Status__c,Date_Receive_from_SAP__c,Especificaciones__c,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Estado__c, Enviado_SAP__c,Venta_Sap__c,recordTypeId
                           ,Nombre_Contacto_Comercial__c,Plaz_cta__c , Requerimientos_Especiales__c,Giro_Comercial__c,Seguimiento_de_Pedido__c, type,Cliente_internacional__c,Address_in_Sap__c,CurrencyIsoCode,RegFiscal_SAP__c,TipSocNeg_SAP__c,EjecCob_SAP__c,Obsycom_cta__c,
                           Tipo_de_Servicio_Prospecto2__c,CPNumero_Registro_de_ID__c,recordtype.name
                           From Account Where Id=:IdAcc limit 1];
            
            String CamposRequeridos = null;
            
            list<Contact> lsComerciales = [Select Id,Name,Tipcon_cont__c,Phone,Email,Puesto__c,Condiciones__c,Monto_Aproximado__c 
                                           From Contact Where AccountId=:IdAcc and Tipcon_cont__c IN ('Referencias Comerciales de Clientes','Referencias Comerciales de Proveedores')];
            list<Contact> lsPClientes = [Select Id,Name,Tipcon_cont__c,Phone,Email,Puesto__c,Condiciones__c,Monto_Aproximado__c 
                                         From Contact Where AccountId=:IdAcc and Tipcon_cont__c IN ('Contacto Comercial','Otros')];
            list<Contact> lsPFuncionales = [Select Id,Name,Tipcon_cont__c,Phone,Email,Puesto__c,Condiciones__c,Monto_Aproximado__c 
                                            From Contact Where AccountId=:IdAcc and Tipcon_cont__c IN('Encargado de Pagos','Representante de Operación','Representante de Cotizacion','Representante Administrativo','Referencias Comerciales de Clientes')];
            
            String Direccion = ACC.BillingCountry+'|'+ACC.BillingState+'|'+ACC.BillingCity+'|'+ACC.BillingStreet+'|'+ACC.BillingPostalCode;
            String IFE = ACC.Inerep_cta__c == true?'1':'0';
            String Acta = ACC.Acta_Constitutiva_Poder_Rep_Legal__c == true?'1':'0';
            String Evidencia = ACC.Evidencia_de_Visita_del_Vendedor__c==true?'1':'0';
            String OrdenCompra = ACC.Requiere_Orden_de_Compra__c==true?'1':'0';
            String UsoPortal = ACC.Uso_Portal__c == true?'1':'0';
            String PortalProveedores =  ACC.Uso_Portal__c == true?ACC.Portal_de_Proveedores__c:'';
            String Contrasena =  ACC.Uso_Portal__c == true?ACC.Contrasena__c:'';
            String Usuario =  ACC.Uso_Portal__c == true?'IMPAK':'PGL';
            String Fecha = ACC.Fecha_Recepcion_Factura__c != null? ACC.Fecha_Recepcion_Factura__c.format():'';
            String SlpCode = ACC.Owner.SalesEmployer__c;
            String SlpCodeOwner;
            if (tipoServicio == 'SP-FN-FLETE NACIONAL'){
                SlpCodeOwner = '125';
            }else if (tipoServicio == 'SP-FI-FLETE INTER' ){
                SlpCodeOwner = '126';
            }
            
            String Body='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<tem:InsertarCliente>'+
                '<tem:cliente>'+
                '<tem:IFE>'+IFE+'</tem:IFE>'+
                '<tem:Acta>'+Acta+'</tem:Acta>'+
                '<tem:Evidencia>'+Evidencia+'</tem:Evidencia>'+
                '<tem:RazonSocial>'+ACC.Name+'</tem:RazonSocial>'+
                '<tem:NumeroRegistroID>'+ACC.CPNumero_Registro_de_ID__c+'</tem:NumeroRegistroID>'+
                '<tem:RFC>'+ACC.TAX_ID__c+'</tem:RFC>'+
                '<tem:DireccionFiscal>'+Direccion+'</tem:DireccionFiscal>'+
                '<tem:CiudadEstado>'+ACC.Estado__c+'</tem:CiudadEstado>'+
                '<tem:Plaza>'+ACC.Owner.Workplace__c+'</tem:Plaza>'+
                '<tem:Plaza>'+ACC.Workplace_AccOwner__c+'</tem:Plaza>'+                                    
                '<tem:Email>'+ACC.NEU_Email__c+'</tem:Email>'+
                '<tem:WCAId>'+ACC.WCA_ID__c+'</tem:WCAId>'+
                '<tem:Moneda>'+ACC.CurrencyIsoCode+'</tem:Moneda>'+
                /*'<tem:Estatus>'+ACC.Estatus_de_Alta__c +'</tem:Estatus>'+*/
                '<tem:BillingAddress>'+ACC.Billingaddress+'</tem:BillingAddress>'+
                '<tem:TipodePago>'+ACC.Payment_Method__c+'</tem:TipodePago>'+
                '<tem:Telefono>'+ACC.Phone+'</tem:Telefono>'+
                '<tem:PaginaWeb>'+'www.pak2go.com'+'</tem:PaginaWeb>'+
                '<tem:GiroComercial>'+ACC.Giro_Comercial__c+'</tem:GiroComercial>'+
                '<tem:TipoServicio>'+ACC.Tipo_de_Servicio_Prospecto__c+'</tem:TipoServicio>'+
                '<tem:RequiereEvidencia>'+ACC.Requiere_Evidencia__c+'</tem:RequiereEvidencia>'+
                '<tem:TipoEvidenciaAcuse>'+ACC.Tipo_de_Acuse_Sap__c+'</tem:TipoEvidenciaAcuse>'+
                '<tem:RequiereOrdenCompra>'+OrdenCompra+'</tem:RequiereOrdenCompra>'+
                '<tem:DiasCredito>'+ACC.Credit_Terms__c+'</tem:DiasCredito>'+
                '<tem:MontoCreditoSolicitado>'+1.0+'</tem:MontoCreditoSolicitado>'+
                '<tem:MontoCreditoAutorizado>'+ACC.Credit_Limit__c+'</tem:MontoCreditoAutorizado>'+
                '<tem:MetodoPago>'+ACC.Tippag_cta__c+'</tem:MetodoPago>'+
                '<tem:FormaPago>'+ACC.Forpag_cta__c+'</tem:FormaPago>'+
                '<tem:UsoCFDI>'+ACC.Uso_CFDI__c+'</tem:UsoCFDI>'+
                '<tem:Banco>'+ ACC.Bank_Name_Supplier_Form2__c +'</tem:Banco>'+
                '<tem:CuentaBancaria>'+ACC.Bank_Account_Number__c+'</tem:CuentaBancaria>'+
                '<tem:AddressInSAP>'+ACC.Address_in_Sap__c+'</tem:AddressInSAP>'+
                '<tem:Plaza>'+ACC.Plaz_cta__c+'</tem:Plaza>'+
                '<tem:RegimenFiscal>'+ACC.RegFiscal_SAP__c+'</tem:RegimenFiscal>'+
                '<tem:EjecutivoCobranza>'+ACC.EjecCob_SAP__c+'</tem:EjecutivoCobranza>'+
                '<tem:Comentarios>'+ACC.Obsycom_cta__c+'</tem:Comentarios>'+
                '<tem:Servicio>'+ACC.Tipo_de_Servicio_Prospecto2__c+'</tem:Servicio>'+
                '<tem:TipoSocioNegocio>'+ACC.TipSocNeg_SAP__c+'</tem:TipoSocioNegocio>'+
                '<tem:UsoPortal>'+UsoPortal+'</tem:UsoPortal>'+
                '<tem:PeriodoFacturacion>'+ACC.Periodo_de_Facturacion__c+'</tem:PeriodoFacturacion>'+
                '<tem:FechaRecepcionFacturacion>'+Fecha+'</tem:FechaRecepcionFacturacion>'+
                '<tem:PortalProveedores>'+true+'</tem:PortalProveedores>'+
                '<tem:Usuario>'+Usuario+'</tem:Usuario>'+
                '<tem:Contrasena>'+Contrasena+'</tem:Contrasena>'+
                '<tem:Especificaciones>'+'flete'+'</tem:Especificaciones>'+
                '<tem:sfClientId>'+ACC.Id+'</tem:sfClientId>'+
                '<tem:TipoRegistro>'+ACC.recordtype.name+'</tem:TipoRegistro>'+
                '<tem:SlpCode>'+SlpCode+'</tem:SlpCode>'+
                '<tem:SlpCodeOwner>'+SlpCodeOwner+'</tem:SlpCodeOwner>'+
                '<tem:ReferenciasComerciales>';
            system.debug('esto es lo que se manda a SAP: '+Body);
            if(!lsComerciales.isEmpty()){
                for(Contact C: lsComerciales){
                    Body+=  '<tem:ReferenciaComercial>'+
                        '<tem:nombre>'+C.Name+'</tem:nombre>'+
                        '<tem:contacto>'+C.Tipcon_cont__c+'</tem:contacto>'+
                        '<tem:telefono>'+C.Phone+'</tem:telefono>'+
                        '<tem:montoAproximado>'+C.Monto_Aproximado__c+'</tem:montoAproximado>'+
                        '</tem:ReferenciaComercial>';   
                }
            }else{
                Body+='<tem:ReferenciaComercial>'+
                    '<tem:nombre></tem:nombre>'+
                    '<tem:contacto></tem:contacto>'+
                    '<tem:telefono></tem:telefono>'+
                    '<tem:montoAproximado></tem:montoAproximado>'+
                    '</tem:ReferenciaComercial>';
            }
            Body+='</tem:ReferenciasComerciales>'+
                '<tem:PrincipalesClientes>';
            if(!lsPClientes.isEmpty()){
                for(Contact C: lsPClientes){
                    Body+=     '<tem:ClientePrincipal>'+
                        '<tem:nombre>'+C.Name+'</tem:nombre>'+
                        '<tem:contacto>'+C.Tipcon_cont__c+'</tem:contacto>'+
                        '<tem:condicionesVenta>'+C.Condiciones__c+'</tem:condicionesVenta>'+
                        '</tem:ClientePrincipal>';   
                }
            }else{
                Body+='<tem:ClientePrincipal>'+
                    '<tem:nombre></tem:nombre>'+
                    '<tem:contacto></tem:contacto>'+
                    '<tem:condicionesVenta></tem:condicionesVenta>'+
                    '</tem:ClientePrincipal>';
            }
            Body+=  '</tem:PrincipalesClientes>'+
                '<tem:PrincipalesFuncionarios>';
            if(!lsPFuncionales.isEmpty()){
                for(Contact C: lsPFuncionales){
                    Body+='<tem:FuncionarioPrincipal>'+
                        '<tem:nombre>'+C.Name+'</tem:nombre>'+
                        '<tem:puesto>'+C.Tipcon_cont__c+'</tem:puesto>'+
                        '<tem:telefono>'+C.Phone+'</tem:telefono>'+
                        '<tem:mail>'+C.Email+'</tem:mail>'+
                        '</tem:FuncionarioPrincipal>';       
                }
            }else{
                Body+='<tem:FuncionarioPrincipal>'+
                    '<tem:nombre></tem:nombre>'+
                    '<tem:puesto></tem:puesto>'+
                    '<tem:telefono></tem:telefono>'+
                    '<tem:mail></tem:mail>'+
                    '</tem:FuncionarioPrincipal>';
            }
            Body+='</tem:PrincipalesFuncionarios>'+
                '</tem:cliente>'+
                '<tem:nombreUsuario>'+UserInfo.getName()+'</tem:nombreUsuario>'+
                '</tem:InsertarCliente>'+
                '</soapenv:Body>'+
                '</soapenv:Envelope>';
            
            string newBody = Body.replace('&','and');
            Body = newBody;
            System.debug('Complete: '+Body);
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://35.169.18.187/pakws92/WsAltaClientes.asmx');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', 'http://tempuri.org/InsertarCliente');
            request.setBody(Body);
            HttpResponse response = httpProtocol.send(request);
            System.debug('Encabezado : sap ');
            for (Integer i = 0; i < Body.length(); i=i+250)
            {
                Integer iEffectiveEnd = (i+250) > Body.length() ? Body.length()-1 : (i+250);
                    System.debug('LINEA ' +  i + ' - ' + iEffectiveEnd + '  ' + Body.substring(i,iEffectiveEnd));
            }
            
            System.debug('-----------'+response.getBody());
            System.debug('-------------------'+Body);
            if(response.getStatusCode() == 200){
                system.debug('Se ha enviado a sap correctamente:'+response.getStatusCode());
                ACC.Account_Status__c = 'Send to Sap';
                ACC.Date_Receive_from_SAP__c = datetime.now();
                ACC.Enviado_SAP__c = true;
                System.debug('ACC '+ ACC );
                update ACC;
            }else{
                system.debug('Ocurrio un error al enviar a SAP:');
                ACC.Enviado_SAP__c = false;    
            } 
        }
        catch(Exception e){
            System.debug(e.getLineNumber()+'------------'+e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static void enviarArchivosPorCorreo(String correoDestino, String recordId) {
        PageReference pdf = Page.NEU_Import_Export_Quote_pdf_ES;
        pdf.getParameters().put('id', recordId);
        Blob pdfBlob;
        try {
            pdfBlob = pdf.getContent();
        } catch (VisualforceException e) {
            System.debug('Error al generar pdf P2G_callsCotizador con id: '+recordId);
        }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { correoDestino });
        email.setSubject('Cotizacion PAK2GO');
        email.setPlainTextBody('Gracias por cotizar con PAK2GO');
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Cotizacion.pdf');
        attachment.setBody(pdfBlob);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
    @Future(callout=true)
    public static void enviarCorreo(String IdObjeto) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{'omar.rojo@pak2go.com'}); //para quien se envia
        email.setReplyTo('admin2020@force.com');//quien lo envia
        email.setSenderDisplayName('Actualización Sistemas 2021');
        
        //asunto del correo
        email.setSubject('Actualización de Costo:  ' + IdObjeto);
        
        String cuerpoCorreo = '<p>Hola,</p>';
        cuerpoCorreo += '<p>Por favor, actualice el costo de Service Rate:</p>';
        cuerpoCorreo += '<p><strong>Quote:</strong> ' + IdObjeto + '</p>';
        cuerpoCorreo += '<p><a href="https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/' + IdObjeto + '/view">Haga clic aquí para actualizar</a></p>';
        cuerpoCorreo += '<p>Gracias,</p>';
        cuerpoCorreo += '<p>Tu Nombre</p>';
        email.setHtmlBody(cuerpoCorreo);
        
        // Envia el correo electrónico
        Messaging.SendEmailResult[] resultados = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        
        // Verifica los resultados del envío
        if (resultados[0].isSuccess()) {
            System.debug('Correo electrónico enviado con éxito: ');
        } else {
            System.debug('Error al enviar el correo electrónico: ' + resultados[0].getErrors()[0].getMessage());
        }
    }
}