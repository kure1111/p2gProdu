public class PAK_UpdateCustomerSAP {
    public ApexPages.StandardController C {get;set;}
    Public Account ACC {get;set;}
    public String IdAcc;
    public PAK_UpdateCustomerSAP(ApexPages.StandardController Controller){
        if(!Test.isRunningTest()){
            C = Controller;
            ACC = (Account)Controller.getRecord();
            IdAcc = Controller.getId();   
        }
    }
    public PAK_UpdateCustomerSAP(){        
    }
    public pageReference SendWS(){
        try{
             system.debug('Entrando al metodo SendWS: ' + IdAcc);
             RecordType ProspectRt = [Select Id From Recordtype Where DeveloperName='Prospect' limit 1];
            
             ACC = [Select Id,Name,Tipo_de_Servicio_TNA__r.Name,Inerep_cta__c,Acta_Constitutiva_Poder_Rep_Legal__c,Evidencia_de_Visita_del_Vendedor__c,TAX_ID__c,Owner.Workplace__c,Phone,Requiere_Evidencia__c, WCA_ID__c,NEU_Email__c, Workplace_AccOwner__c,
             Website,Grupo_SAP__c, Tipo_de_Servicio_Prospecto__c, Requiere_Acuse_Sap__c,Tipo_de_Acuse_Sap__c,Requiere_Orden_de_Compra__c,Credit_Terms__c,Monto_Credito_Solicitado__c,Owner.SalesEmployer__c,
             Credit_Limit__c,Tippag_cta__c,Forpag_cta__c,Uso_CFDI__c,Bank_Name_Supplier_Form2__c,Bank_Account_Number__c,Uso_Portal__c,Periodo_de_Facturacion__c,Fecha_Recepcion_Factura__c,BillingAddress,Payment_Method__c,
             Portal_de_Proveedores__c,Usuario__c,Contrasena__c,Account_Status__c,Date_Receive_from_SAP__c,Especificaciones__c,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Estado__c, Enviado_SAP__c,Venta_Sap__c,recordTypeId
             ,Nombre_Contacto_Comercial__c,Plaz_cta__c , Requerimientos_Especiales__c,Giro_Comercial__c,Seguimiento_de_Pedido__c, type,Cliente_internacional__c,Address_in_Sap__c,CurrencyIsoCode,RegFiscal_SAP__c,TipSocNeg_SAP__c,EjecCob_SAP__c,Obsycom_cta__c,
             Tipo_de_Servicio_Prospecto2__c,CPNumero_Registro_de_ID__c,recordtype.name
             From Account Where Id=:IdAcc limit 1];
            
            String CamposRequeridos = null;
            //if(ACC.Inerep_cta__c == false){CamposRequeridos= 'INE representante legal o dueño';}
            //if(ACC.Acta_Constitutiva_Poder_Rep_Legal__c == false){if(CamposRequeridos != null){CamposRequeridos= ', Acta Constitutiva/Poder Rep Legal';}else{CamposRequeridos= 'Acta Constitutiva/Poder Rep Legal';}}
            //if(ACC.Evidencia_de_Visita_del_Vendedor__c == false){if(CamposRequeridos != null){CamposRequeridos= ', Evidencia de Visita del Vendedor';}else{CamposRequeridos= 'Evidencia de Visita del Vendedor';}}
            
            if(ACC.Workplace_AccOwner__c == 'GLOBAL' && ACC.WCA_ID__c != null){
                
                if(ACC.NEU_Email__c == null){
                    if(CamposRequeridos != null){CamposRequeridos= ', Email';}else{CamposRequeridos= 'Email';}} 
                else if(ACC.Name == null){
                    if(CamposRequeridos != null){CamposRequeridos= ', Name';}else{CamposRequeridos= 'Name';}    
                }
                else if(ACC.BillingAddress == null){
                    if(CamposRequeridos != null){CamposRequeridos= ', BillingAddress';}else{CamposRequeridos= 'BillingAddress';}    
                }
                else if(ACC.Phone == null){
                    if(CamposRequeridos != null){CamposRequeridos= ', Phone';}else{CamposRequeridos= 'Phone';}    
                }
                else if(ACC.Credit_Terms__c == null){
                    if(CamposRequeridos != null){CamposRequeridos= ', Credit Terms';}else{CamposRequeridos= 'Credit Terms';}    
                }
                else if(ACC.TAX_ID__c == null){
                    if(CamposRequeridos != null){CamposRequeridos= ', RFC';}else{CamposRequeridos= 'RFC';}    
                }
            }
            else if(ACC.Workplace_AccOwner__c == 'GLOBAL' && ACC.WCA_ID__c == null){
                 if(ProspectRt.id == ACC.recordTypeId && ACC.Tippag_cta__c =='Contado')
                {
                    if(ACC.Name == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Name';}else{CamposRequeridos= 'Name';}    
                        }
                    if(ACC.TAX_ID__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', RFC';}else{CamposRequeridos= 'RFC';}    
                    }
                    if(ACC.Forpag_cta__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Forma de pago';}else{CamposRequeridos= 'Forma de pago';}    
                        }
                     if(ACC.Payment_Method__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Metodo de pago';}else{CamposRequeridos= 'Metodo de pago';}    
                        }
                    if(ACC.Uso_CFDI__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Uso del CFDI';}else{CamposRequeridos= 'Uso del CFDI';}    
                        }
                    if(ACC.Bank_Name_Supplier_Form2__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Banco';}else{CamposRequeridos= 'Banco';}    
                        }
                     if(ACC.Bank_Account_Number__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Cuenta bancaria';}else{CamposRequeridos= 'Cuenta bancaria';}    
                        }
                   
                }else{
                        if(ACC.TAX_ID__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', CEDULA FISCAL';}else{CamposRequeridos= 'CEDULA FISCAL';}} 
                        else if(ACC.Forpag_cta__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Forma de pago';}else{CamposRequeridos= 'Forma de pago';}    
                        }
                        else if(ACC.Payment_Method__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Metodo de pago';}else{CamposRequeridos= 'Metodo de pago';}    
                        }
                        else if(ACC.Uso_CFDI__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Uso del CFDI';}else{CamposRequeridos= 'Uso del CFDI';}    
                        }
                        else if(ACC.Bank_Name_Supplier_Form2__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Banco';}else{CamposRequeridos= 'Banco';}    
                        }
                        else if(ACC.Name == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Name';}else{CamposRequeridos= 'Name';}    
                        }
                        else if(ACC.Phone == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Phone';}else{CamposRequeridos= 'Phone';}    
                        }
                        else if(ACC.NEU_Email__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Correo';}else{CamposRequeridos= 'Correo';}    
                        }
                }
            }
            if(ACC.Workplace_AccOwner__c != 'GLOBAL'){
                
                if(ProspectRt.id == ACC.recordTypeId && ACC.Tippag_cta__c =='Contado')
                {
                     if(ACC.Name == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Name';}else{CamposRequeridos= 'Name';}    
                        }
                    if(ACC.TAX_ID__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', RFC';}else{CamposRequeridos= 'RFC';}    
                    }
                    if(ACC.Phone == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Phone';}else{CamposRequeridos= 'Phone';}    
                    }
                     if(ACC.NEU_Email__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Correo';}else{CamposRequeridos= 'Correo';}    
                    }
                    if(ACC.Uso_CFDI__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Uso del CFDI';}else{CamposRequeridos= 'Uso del CFDI';}    
                        }
                    if(ACC.Forpag_cta__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Forma de pago';}else{CamposRequeridos= 'Forma de pago';}    
                        }
                     if(ACC.Payment_Method__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Metodo de pago';}else{CamposRequeridos= 'Metodo de pago';}    
                        }
                    
                    if(ACC.Bank_Name_Supplier_Form2__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Banco';}else{CamposRequeridos= 'Banco';}    
                        }
                     if(ACC.Bank_Account_Number__c == null){
                            if(CamposRequeridos != null){CamposRequeridos= ', Cuenta bancaria';}else{CamposRequeridos= 'Cuenta bancaria';}    
                        }
                    if(ACC.BillingAddress == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', BillingAddress';}else{CamposRequeridos= 'BillingAddress';}    
                    }
                }
               else{
                    //|| ACC.Requiere_Evidencia__c == 'No' 
                    if(ACC.Requiere_Evidencia__c == null || ACC.Requiere_Evidencia__c == ''){if(CamposRequeridos != null){CamposRequeridos= ', Requiere Evidencia';}else{CamposRequeridos= 'Requiere Evidencia';}}
                    else if(ACC.Requiere_Evidencia__c == 'Si' && (ACC.Tipo_de_Acuse_Sap__c == '' || ACC.Tipo_de_Acuse_Sap__c == null)){if(CamposRequeridos != null){CamposRequeridos= ', Tipo de Acuse';}else{CamposRequeridos= 'Tipo de Acuse';}}
                    
                    //if(ACC.Requiere_Orden_de_Compra__c == null){if(CamposRequeridos != null){CamposRequeridos= ', Requiere Orden de Compra';}else{CamposRequeridos= 'Requiere Orden de Compra';}}
                    if(ACC.Forpag_cta__c == null){if(CamposRequeridos != null){CamposRequeridos= ', Forma de Pago';}else{CamposRequeridos= 'Forma de Pago';}}
                    if(ACC.Uso_CFDI__c == null){if(CamposRequeridos != null){CamposRequeridos= ', Uso CFDI';}else{CamposRequeridos= 'Uso CFDI';}}
                    //if(ACC.Uso_Portal__c == null){if(CamposRequeridos != null){CamposRequeridos= ', Uso Portal';}else{CamposRequeridos= 'Uso Portal';}}   
                    if(ACC.Periodo_de_Facturacion__c == null || ACC.Periodo_de_Facturacion__c == ''){if(CamposRequeridos != null){CamposRequeridos= ', Periodo de Facturación';}else{CamposRequeridos= 'Periodo de Facturación';}}  
                    if(ACC.Fecha_Recepcion_Factura__c == null){if(CamposRequeridos != null){CamposRequeridos= ', Fecha Recepción Factura';}else{CamposRequeridos= 'Fecha Recepción Factura';}}
                    if(ACC.Uso_Portal__c && (ACC.Portal_de_Proveedores__c == '' || ACC.Portal_de_Proveedores__c == null)){if(CamposRequeridos != null){CamposRequeridos= ', Portal de Proveedores';}else{CamposRequeridos= 'Portal de Proveedores';}}
                    if(ACC.Uso_Portal__c && (ACC.Usuario__c == '' || ACC.Usuario__c == null)){if(CamposRequeridos != null){CamposRequeridos= ', Usuario';}else{CamposRequeridos= 'Usuario';}}
                    if(ACC.Uso_Portal__c && (ACC.Contrasena__c == '' || ACC.Contrasena__c == null)){if(CamposRequeridos != null){CamposRequeridos= ', Contraseña';}else{CamposRequeridos= 'Contraseña';}}
                    if(ACC.TAX_ID__c == null || ACC.TAX_ID__c == ''){if(CamposRequeridos != null){CamposRequeridos= ', TAX ID';}else{CamposRequeridos= 'TAX ID';}}
                    //if(ACC.Estatus_de_Alta__c == null){if(CamposRequeridos != null){CamposRequeridos= ', Estatus de Alta';}else{CamposRequeridos= 'Estatus de Alta';}}            
                    //if(ACC.WCA_ID__c == null){if(CamposRequeridos != null){CamposRequeridos= ', WCA';}else{CamposRequeridos= 'WCA';}}                       
                    //if(ACC.Enviado_SAP__c = false){ACC.Enviado_SAP__c = true;}
                    if(ACC.Phone == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Phone';}else{CamposRequeridos= 'Phone';}    
                    }
                    if(ACC.Name == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Name';}else{CamposRequeridos= 'Name';}    
                    }
                    if(ACC.TAX_ID__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', RFC';}else{CamposRequeridos= 'RFC';}    
                    }
                    if(ACC.Credit_Terms__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Credit Terms';}else{CamposRequeridos= 'Credit Terms';}    
                    }
                    if(ACC.Monto_Credito_Solicitado__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Monto Credito Solicitado';}else{CamposRequeridos= 'amount requested credit';}    
                    }
                    if(ACC.Payment_Method__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Metodo de pago';}else{CamposRequeridos= 'Metodo de pago';}    
                    }
                    if(ACC.Forpag_cta__c == null && ACC.Forpag_cta__c ==''){
                        if(CamposRequeridos != null){CamposRequeridos= ', Forma de pago';}else{CamposRequeridos= 'Forma de pago';}    
                    }
                    if(ACC.Uso_CFDI__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Uso del CFDI';}else{CamposRequeridos= 'Uso del CFDI';}    
                    }
                    if(ACC.Bank_Name_Supplier_Form2__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Banco';}else{CamposRequeridos= 'Banco';}    
                    }
                    if(ACC.Bank_Account_Number__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Cuenta bancaria';}else{CamposRequeridos= 'Cuenta bancaria';}    
                    }
                    if(ACC.BillingAddress == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', BillingAddress';}else{CamposRequeridos= 'BillingAddress';}    
                    }
                    if(ACC.Tippag_cta__c == null){
                        if(CamposRequeridos != null){CamposRequeridos= ', Tipo de pago';}else{CamposRequeridos= 'Tipo de pago';}    
                    }
                   
                   if(ACC.Website == null){
                       if(CamposRequeridos != null){CamposRequeridos= ', Pagina Web';}else{CamposRequeridos= 'Pagina Web';}
                   }
                    if(ACC.Tipo_de_Servicio_Prospecto__c == null){
                       if(CamposRequeridos != null){CamposRequeridos= ', Tipo Servicio';}else{CamposRequeridos= 'Tipo Servicio';}
                   }
                }
                
                
                
            }
            
            if(ApexPages.currentPage() != null){                             
                if(CamposRequeridos != null){
                    system.debug('Validacion Campos Requeridos:'+CamposRequeridos);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Validacion Campos Requeridos: '+CamposRequeridos);
                    ApexPages.addMessage(myMsg);
                    //ACC.Enviado_SAP__c = false;
                    return null;
                }
            }            
            
            
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
            String SlpCodeOwner = ACC.Owner.SalesEmployer__c;
            String espeficicacion = ACC.Tipo_de_Servicio_TNA__r.Name;
            String resultado='';
            
            if (espeficicacion != null) {
                if(espeficicacion.toLowerCase().contains('flete')){
                    resultado = 'flete';
                }
                if(espeficicacion.toLowerCase().contains('logisticos')){
                    resultado = 'logistica';
                }        
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
                '<tem:PaginaWeb>'+ACC.Website+'</tem:PaginaWeb>'+
                '<tem:GiroComercial>'+ACC.Giro_Comercial__c+'</tem:GiroComercial>'+
                '<tem:TipoServicio>'+ACC.Tipo_de_Servicio_Prospecto__c+'</tem:TipoServicio>'+
                '<tem:RequiereEvidencia>'+ACC.Requiere_Evidencia__c+'</tem:RequiereEvidencia>'+
                '<tem:TipoEvidenciaAcuse>'+ACC.Tipo_de_Acuse_Sap__c+'</tem:TipoEvidenciaAcuse>'+
                '<tem:RequiereOrdenCompra>'+OrdenCompra+'</tem:RequiereOrdenCompra>'+
                '<tem:DiasCredito>'+ACC.Credit_Terms__c+'</tem:DiasCredito>'+
                '<tem:MontoCreditoSolicitado>'+ACC.Monto_Credito_Solicitado__c+'</tem:MontoCreditoSolicitado>'+
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
                '<tem:PortalProveedores>'+PortalProveedores+'</tem:PortalProveedores>'+
                '<tem:Usuario>'+Usuario+'</tem:Usuario>'+
                '<tem:Contrasena>'+Contrasena+'</tem:Contrasena>'+
                '<tem:Especificaciones>'+resultado+'</tem:Especificaciones>'+
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
            
            //HttpResponse response;
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
                if(ApexPages.currentPage() != null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'El Cliente se envio correctamente a SAP');
                    ApexPages.addMessage(myMsg);
                }    
                return null;
            }else{
                system.debug('Ocurrio un error al enviar a SAP:');
                if(ApexPages.currentPage() != null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Ocurrio un error porfavor de comunicarse con el administrador del sistema');
                	ApexPages.addMessage(myMsg);
                }                
                ACC.Enviado_SAP__c = false;                
                return null;
            } 
        }catch(Exception e){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'El pedido ya fue enviado anteriormente a SAP');
            //ApexPages.addMessage(myMsg);
            System.debug(e.getLineNumber()+'------------'+e.getMessage());                        
            return null;
        }
    }
    
    public static void TestMetodo(){
        String Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
    }
}