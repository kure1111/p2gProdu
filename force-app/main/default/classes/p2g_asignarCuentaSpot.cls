public class p2g_asignarCuentaSpot {
	@AuraEnabled
    public static p2g_Cotizador.wrapperCotizador validacionRfc(String rfc,String correo, String quoteId){
        System.debug('RFC: '+rfc+' Correo: '+correo+' quoteId: '+quoteId);
        p2g_Cotizador.wrapperCotizador cuenta = datosQuote(quoteId);
        Lead Lead =[SELECT LastName, Email, Phone FROM Lead WHERE Id =: cuenta.idLead];
       	List<Contact> contacto =[SELECT Id, LastName, Email, Phone FROM Contact WHERE Email =: correo ORDER BY LastModifiedDate desc LIMIT 1];
       	List<Account> cuentaExistente = [SELECT Id,Name, TAX_ID__c,Phone,NEU_Email__c,Bank_Name_Supplier_Form2__c, Bank_Account_Number__c,Direccion_Principal__c
                                         FROM Account WHERE (TAX_ID__c != null AND TAX_ID__c =: rfc) OR (NEU_Email__c =: correo AND NEU_Email__c != null) ORDER BY LastModifiedDate desc LIMIT 1];
        try{
            if(cuentaExistente.size()>0){
                cuenta.tarifario = true; //para saber que el rfc existe en una cuenta
                cuenta = llenarCuenta(cuentaExistente[0],cuenta);
            }else if(contacto.size()>0){
                cuenta.tarifario = false;
                cuenta.telefonoCliente = contacto[0].Phone;
                cuenta.emailCliente = contacto[0].Email;
                cuenta.rfc = rfc;
            }else{
                cuenta.tarifario = false;
                cuenta.telefonoCliente = Lead.Phone;
                cuenta.emailCliente = Lead.Email;
                cuenta.rfc = rfc;
            }
        }catch(Exception e){
            System.debug(e.getLineNumber()+'Error al obtener una cuenta '+e.getMessage()); 
        }
        return cuenta;
    }
    public static p2g_Cotizador.wrapperCotizador llenarCuenta(Account cuentaExistente,p2g_Cotizador.wrapperCotizador cuenta){
        List<Account_Address__c> address = [SELECT Id,Calle_cat__c,Numero_Ext_cp__c,Numero_Int_cat__c,Codigo_Postal_CP__c,Colonia_cp__c,Codigo_Postal_CP__r.Name,Colonia_cp__r.Name
                                             FROM Account_Address__c WHERE Id =: cuentaExistente.Direccion_Principal__c ORDER BY LastModifiedDate desc LIMIT 1];
                cuenta.cuentaId = cuentaExistente.Id;
                cuenta.rfc = cuentaExistente.TAX_ID__c;
                cuenta.telefonoCliente = cuentaExistente.Phone;
                cuenta.emailCliente = cuentaExistente.NEU_Email__c;
                cuenta.razonSocial = cuentaExistente.Name;
                cuenta.banco = cuentaExistente.Bank_Name_Supplier_Form2__c;
                cuenta.numeroCuenta = cuentaExistente.Bank_Account_Number__c;
                if(address.size()>0){
                    cuenta.idAddress = address[0].Id; //para guardar el id del account address
                    cuenta.calleFiscal = address[0].Calle_cat__c;
                    cuenta.exteriorFiscal = address[0].Numero_Ext_cp__c;
                    cuenta.interiorFiscal = address[0].Numero_Int_cat__c;
                    cuenta.cPFiscalId = address[0].Codigo_Postal_CP__c;
                    cuenta.cPFiscal = address[0].Codigo_Postal_CP__r.Name;
                    cuenta.coloniaFiscalId = address[0].Colonia_cp__c;
                    cuenta.coloniaFiscal = address[0].Colonia_cp__r.Name;
                }
        return cuenta;
    }
   @AuraEnabled
   public static void guardarDatos(p2g_Cotizador.wrapperCotizador cotizador){
       System.debug('lo que llega es: '+cotizador);
       try{
           Map<String, Decimal> cordenadasFiscal = P2G_callsCotizador.getCoordinates(cotizador.cPFiscal,cotizador.coloniaFiscal);
           Map<String, Decimal> cordenadasOrigen = P2G_callsCotizador.getCoordinates(cotizador.cPOrigen,cotizador.coloniaOrigen);
           Map<String, Decimal> cordenadasDestino = P2G_callsCotizador.getCoordinates(cotizador.cPDestino,cotizador.coloniaDestino);
           System.debug('las coordenadas son:' +cordenadasFiscal + ' ' + cordenadasOrigen +' '+ cordenadasDestino);
           if(cotizador.tarifario == true){
               crearAccount(cotizador,cordenadasOrigen,cordenadasDestino);
               //Actualiza cuenta
               actualizacionCuenta(cotizador,cordenadasFiscal);
        	   P2G_callsCotizador.altaSAP(cotizador.cuentaId,cotizador.tipoServicio);
           }else{
                //crea cuenta,account address,actualiza cuenta,actualiza IEQO y envia a SAP
               cotizador =p2g_cotizador.crearEmbarque(cotizador);
               //convierte lead
           }
           convertLead(cotizador.idLead, cotizador.cuentaId);
      System.debug('se logro XD');
       }catch(Exception e){
            System.debug(e.getLineNumber()+'Error al crear o actualizar cuenta '+e.getMessage()); 
       }
    }    
    public static void convertLead(String leadId, String accountId) {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        lc.setAccountId(accountId);
        lc.setConvertedStatus('Qualified');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        if (lcr.isSuccess()) {
            System.debug('Lead convertido con éxito');
        } else {
            System.debug('Error al convertir el Lead: ' + lcr.getErrors()[0].getMessage());
        }
    }
    public static p2g_Cotizador.wrapperCotizador datosQuote(String quoteId){
        p2g_Cotizador.wrapperCotizador wrapper = new p2g_Cotizador.wrapperCotizador();
        Customer_Quote__c quote =[SELECT Final_Client_Pak__c,FolioResume__c FROM Customer_Quote__c WHERE Id=:quoteId LIMIT 1];
       switch on quote.FolioResume__c {
            when 'FN' {
                wrapper.tipoServicio = 'SP-FN-FLETE NACIONAL';
            }
            when 'FI' {
                wrapper.tipoServicio = 'SP-FI-FLETE INTER';
            }
            when else {
                System.debug('default');
            }
        }
        wrapper.idLead = quote.Final_Client_Pak__c;
        wrapper.quoteId = quoteId;
        
        return wrapper;
    }
    public static void actualizacionCuenta(p2g_Cotizador.wrapperCotizador wrapper, Map<String, Decimal> cordenadasFiscal){
        List<Catalogo_SAT__c> cp = p2g_Cotizador.codigoPostal(wrapper.cPFiscal,1,'');
        String ciudad;
        String estado;
        String pais;
        String localidad;
        for(Catalogo_SAT__c codigo : cp){
            if(codigo.id == wrapper.cPFiscalId){
        		ciudad = codigo.Municipio_Ref_CP__r.Name; 
                estado = codigo.Clave_Relacion_SAT__r.Name;
        		pais = codigo.Pais_RefCP__r.Name;
                localidad = codigo.Localidad_Ref_CP__r.Name;
            }
        }
        Account cuenta = new Account();
        	cuenta.Id = wrapper.cuentaId;
            cuenta.TAX_ID__c = wrapper.rfc;
            cuenta.Phone = wrapper.telefonoCliente;
            cuenta.NEU_Email__c = wrapper.emailCliente;
            cuenta.Name = wrapper.razonSocial;
            cuenta.Bank_Name_Supplier_Form2__c = wrapper.banco;
            cuenta.Bank_Account_Number__c = wrapper.numeroCuenta;
        	cuenta.BillingStreet = wrapper.calleFiscal;//DireccionFiscal (Dirección de Fiscal)
            cuenta.BillingCity = ciudad; 
            cuenta.BillingState = estado; 
            cuenta.BillingPostalCode = wrapper.cPFiscal;
            cuenta.BillingCountry = pais;
            cuenta.Estado__c = localidad; //Dirección de Fiscal
            cuenta.Address_in_Sap__c = 'Calle: '+wrapper.calleFiscal+' CP: '+wrapper.cPFiscal+', '+ciudad+', '+estado+', '+pais;//Copiar Billing Address = Address_in_Sap__c
        System.debug('Cuenta a actualizar '+cuenta);
        Account_Address__c address =new Account_Address__c();
            address.Calle_cat__c = wrapper.calleFiscal;
            address.Numero_Ext_cp__c = wrapper.exteriorFiscal;
            address.Numero_Int_cat__c = wrapper.interiorFiscal;
            address.Codigo_Postal_CP__c = wrapper.cPFiscalId;
            address.Colonia_cp__c = wrapper.coloniaFiscalId;
        if(wrapper.idAddress != null){
        	address.Id = wrapper.idAddress; //es el id del account address
        	update address;
        }else{
            //account Fiscal
            Account_Address__c accountFiscal = p2g_Cotizador.creAccountAddres('Fiscal ',cuenta.Id,cuenta.Name,wrapper.calleFiscal,wrapper.exteriorFiscal,wrapper.interiorFiscal,wrapper.cPFiscalId,wrapper.coloniaFiscalId,cordenadasFiscal);
            insert accountFiscal;
        System.debug('no tiene direccion principal '+accountFiscal);
            cuenta.Direccion_Principal__c = accountFiscal.Id;
        }
        System.debug('actualiza cuenta '+cuenta.Direccion_Principal__c);
        update cuenta;
    }
    public static void crearAccount(p2g_Cotizador.wrapperCotizador cotizador, Map<String, Decimal> cordenadasOrigen, Map<String, Decimal> cordenadasDestino){
        //account origen
        Account_Address__c accountOrigen = p2g_Cotizador.creAccountAddres('Origen ',cotizador.cuentaId,cotizador.razonSocial,cotizador.calleOrigen,cotizador.exteriorOrigen,cotizador.interiorOrigen,cotizador.cPOrigenId,cotizador.coloniaOrigenId,cordenadasOrigen);
        //account destino
        Account_Address__c accountDestino = p2g_Cotizador.creAccountAddres('Destino ',cotizador.cuentaId,cotizador.razonSocial,cotizador.calleDestino,cotizador.exteriorDestino,cotizador.interiorDestino,cotizador.cPDestinoId,cotizador.coloniaDestinoId,cordenadasDestino);
        insert accountOrigen;
        insert accountDestino;
        
        p2g_Cotizador.updateQuote(cotizador.quoteId, 3, cotizador.cuentaId,cotizador.etd,cotizador.eta,accountOrigen.Id,accountDestino.Id);
    }
}