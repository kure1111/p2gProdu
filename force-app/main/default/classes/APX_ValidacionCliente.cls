public class APX_ValidacionCliente {

    //Clase para llamar al metodo SendWS de la clase PAK_UpdateCustomerSAP  para ejecutarlo en el flow P2G Validación Clientes SAP
    
    @InvocableMethod(label='Send to SAP')
    public static void senToSap(List<String> ids){
        
        try{
            
            system.debug('Entrando al metodo APX_ValidacionCliente.senToSap:' + ids);
            
            Account acc = [Select Id,Name,Inerep_cta__c,Acta_Constitutiva_Poder_Rep_Legal__c,Evidencia_de_Visita_del_Vendedor__c,TAX_ID__c,Owner.Workplace__c,Phone,Requiere_Evidencia__c, WCA_ID__c,NEU_Email__c, Workplace_AccOwner__c,
                           Website,Grupo_SAP__c, Tipo_de_Servicio_Prospecto__c, Requiere_Acuse_Sap__c,Tipo_de_Acuse_Sap__c,Requiere_Orden_de_Compra__c,Credit_Terms__c,Monto_Credito_Solicitado__c,Owner.SalesEmployer__c,
                           Credit_Limit__c,Tippag_cta__c,Forpag_cta__c,Uso_CFDI__c,Bank_Name_Supplier_Form2__c,Bank_Account_Number__c,Uso_Portal__c,Periodo_de_Facturacion__c,Fecha_Recepcion_Factura__c,BillingAddress,Payment_Method__c,
                           Portal_de_Proveedores__c,Usuario__c,Contrasena__c,Account_Status__c,Date_Receive_from_SAP__c,Especificaciones__c,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Estado__c, Enviado_SAP__c,Venta_Sap__c,recordTypeId
                           ,Nombre_Contacto_Comercial__c,Plaz_cta__c , Requerimientos_Especiales__c,Giro_Comercial__c,Seguimiento_de_Pedido__c, type,Cliente_internacional__c,Address_in_Sap__c,CurrencyIsoCode,RegFiscal_SAP__c,TipSocNeg_SAP__c,EjecCob_SAP__c,Obsycom_cta__c,
                           Tipo_de_Servicio_Prospecto2__c,CPNumero_Registro_de_ID__c,recordtype.name, Fecha_Alta_Cliente_SAP__c,Fecha_Actualizacion_Cliente_SAP__c
                           From Account Where Id=:ids[0]];                        
            if(!Test.isRunningTest()){PAK_UpdateCustomerSAP ucs = new PAK_UpdateCustomerSAP(); ucs.IdAcc = acc.Id; ucs.SendWS();}
                                        
            DateTime data = Datetime.now();

            String zonaH = data.format('yyyy-MM-dd HH:mm:ss','America/Mexico_City');
            Datetime nowTime = Datetime.valueOfGMT(zonaH);            
            
            if(acc.Fecha_Alta_Cliente_SAP__c== null){acc.Fecha_Alta_Cliente_SAP__c = data;}
            else if(acc.Fecha_Alta_Cliente_SAP__c != null){acc.Fecha_Actualizacion_Cliente_SAP__c = data;}
            
            update acc;
            System.debug('Fecha_Actualizacion_Cliente_SAP__c:  '+acc.Fecha_Actualizacion_Cliente_SAP__c );
            System.debug('Fecha_Alta_Cliente_SAP__c:  '+acc.Fecha_Actualizacion_Cliente_SAP__c );
            
        }catch(Exception e){system.debug('Occurrio un error APX_ValidacionCliente.senToSap: ' + e.getMessage());}
    }
}