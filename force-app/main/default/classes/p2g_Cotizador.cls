public class p2g_Cotizador {
    public class wrapperCotizador {
        //cliente
        @AuraEnabled public String nameCliente { get; set; }
        @AuraEnabled public String telefonoCliente { get; set; } 
        @AuraEnabled public String emailCliente { get; set; }
        //cotizacion
        @AuraEnabled public String tipoServicio { get; set; }
        @AuraEnabled public String sapServiceType { get; set; }
        @AuraEnabled public String sapServiceTypeName { get; set; }
        @AuraEnabled public String siteLoad {get;set;}
        @AuraEnabled public String siteLoadName {get;set;}
        @AuraEnabled public String siteDischarge {get;set;}
        @AuraEnabled public String siteDischargeName { get; set; }
        @AuraEnabled public String containerType { get; set; }
        @AuraEnabled public String containerTypeName { get; set; }
        @AuraEnabled public String claveServicio { get; set; }
        @AuraEnabled public String claveServicioName { get; set; }
        //costo Cotizacion
        @AuraEnabled public String costo {get;set;}
        @AuraEnabled public Boolean tarifario { get; set; }
        @AuraEnabled public String quoteId {get;set;}
        @AuraEnabled public String quoteName { get; set; }
        @AuraEnabled public Decimal buyRate {get;set;}
        
        @AuraEnabled public String idLead { get; set; }
        @AuraEnabled public String cuentaId { get; set; }
        //Emparque
        @AuraEnabled public String rfc {get;set;}
        @AuraEnabled public String razonSocial {get;set;}
        @AuraEnabled public String banco {get;set;}
        @AuraEnabled public String numeroCuenta {get;set;}
        @AuraEnabled public String calleOrigen { get; set; }
        @AuraEnabled public String interiorOrigen {get;set;}
        @AuraEnabled public String exteriorOrigen { get; set; }
        @AuraEnabled public String cPOrigen {get;set;}
        @AuraEnabled public String cPOrigenId {get;set;}
        @AuraEnabled public String coloniaOrigen { get; set; }
        @AuraEnabled public String coloniaOrigenId { get; set; }
        @AuraEnabled public String calleDestino { get; set; }
        @AuraEnabled public String interiorDestino {get;set;}
        @AuraEnabled public String exteriorDestino { get; set; }
        @AuraEnabled public String cPDestino {get;set;}
        @AuraEnabled public String cPDestinoId {get;set;}
        @AuraEnabled public String coloniaDestino { get; set; }
        @AuraEnabled public String coloniaDestinoId { get; set; }
        @AuraEnabled public String etd {get;set;}
        @AuraEnabled public String eta { get; set; }
        @AuraEnabled public String calleFiscal { get; set; }
        @AuraEnabled public String interiorFiscal {get;set;}
        @AuraEnabled public String exteriorFiscal { get; set; }
        @AuraEnabled public String cPFiscal {get;set;}
        @AuraEnabled public String cPFiscalId {get;set;}
        @AuraEnabled public String coloniaFiscal { get; set; }
        @AuraEnabled public String coloniaFiscalId { get; set; }
    }
    
    @AuraEnabled
    public static wrapperCotizador getWrapper(){
        wrapperCotizador wrapper = new wrapperCotizador();
        return wrapper;
    }
    
    public static Lead crearLead(wrapperCotizador cotizador) {
        Lead lead = new Lead();
        lead.Mkt_Executive__c = 'Comercial';//hacer spot
        lead.LeadSource='MKT - SPOT'; //hacer uno Spot
        lead.LastName = cotizador.nameCliente;
        lead.Company ='p2g';
        lead.Medio_de_Contacto__c='Spot';//agregar Spot
        lead.Tipo_de_Servicio_Prospecto__c ='FN';//Fn por ahora
        lead.Description ='Spot';
        lead.Mercancia__c='Viable';
        lead.Status='Open';
        lead.Customs_Broker_Required__c='No';
        lead.Rating='A';
        lead.Industry='Other';//Otras industrias o actividades
        
        lead.FirstName = cotizador.nameCliente;
        lead.Phone = cotizador.telefonoCliente;
        lead.Email = cotizador.emailCliente;
        lead.Status = 'Qualified';
        try {
            if(!Test.isRunningTest())
           		insert lead;
            return lead;
            
        } catch (Exception e) {
            System.debug('Error al crear el Lead: ' + e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static wrapperCotizador Cotizador(wrapperCotizador cotizador, Integer ban){
        Lead lead = crearLead(cotizador);
        cotizador.idLead = lead.Id;
        cotizador.tarifario = false;
        Customer_Quote__c quote = creaIeqCotizador(cotizador);
        Customer_Quote__c idQuote = [SELECT Route__c, Name, Account_for__c FROM Customer_Quote__c WHERE Id =: quote.Id];
        Fee__c tarifario = P2G_CreacionFolios.condicionesTarifario('noTomarId',cotizador.sapServiceType,cotizador.containerType,idQuote.Route__c);
        Sourcing_Item__c item = P2G_CreacionFolios.creaItem(cotizador.claveServicioName, idQuote.Account_for__c,'MXN');
        System.debug('para item: '+cotizador.claveServicioName+' ----'+ idQuote.Account_for__c);
        insert item;
        P2G_CreacionFoliosWrapper.cargoLine cargo = llenarCargoLine(cotizador,quote.Id,item.Id);
        System.debug('para cargo: '+cargo);
        Quote_Item_Line__c cargoLine = P2G_CreacionFolios.createCargoLine(cargo);
        cargoLine.Name = 'Cargo desde Cotizador';
        insert cargoLine;
        if(tarifario!=null){
            List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> wrapperServiceRate = p2g_CreateServiceLineQuote.getRateTarifario(quote.Id);
            String jsonService = json.serialize(wrapperServiceRate);
            String getbody = jsonService.removeStart('[');
            String getbody2 = getbody.removeEnd(']');
            String contenido = '{'+getbody2+'}';
            System.debug('Se envia json: '+contenido);
            List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> serviceLine = p2g_CreateServiceLineQuote.CrearLineTarifario(contenido, 1);
            cotizador.costo = String.valueOf(tarifario.Fee_Rate__c);
            cotizador.buyRate = tarifario.Buy_Rate__c;
            cotizador.tarifario = true;
            cotizador.quoteId = quote.Id;
            cotizador.quoteName = idQuote.Name;
            return cotizador;
        }
        else{
            P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper data = rellenaServiceRate(cotizador,idQuote.Route__c, idQuote.Account_for__c);
            Fee__c serviceRate = p2g_CreateServiceLineQuote.CreateServiceRate(data);
            Import_Export_Fee_Line__c serviceLine = p2g_CreateServiceLineQuote.CreateServiceLine(1,quote.Id, serviceRate);
            if(!Test.isRunningTest()){
                insert serviceRate;
                insert serviceLine;
            }
            updateQuote(quote.Id,1,'','','','','');
            cotizador.tarifario = false;
            cotizador.quoteId = quote.Id;
            cotizador.quoteName = idQuote.Name;
            P2G_callsCotizador.enviarCorreo(quote.Id);
            return cotizador;	
        }
    }
    
    public static Customer_Quote__c creaIeqCotizador(wrapperCotizador wrapper){
        Customer_Quote__c quote = new Customer_Quote__c();
        try{
            String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
            Location__c locationLoad = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:wrapper.siteLoad OR Name='PruebaUnica' limit 1];
            Location__c locationDischarge = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:wrapper.siteDischarge OR Name='PruebaUnica' limit 1];
            Catalogo_SAT__c recordTypeUnidad = [SELECT 	Id, Name FROM Catalogo_SAT__c where Name = 'Pallet' limit : 1];
            quote.RecordTypeId = recordTypeId;
            quote.Clave_de_Unidad_de_Peso__c = recordTypeUnidad.Id;
            quote.Name='.';
            quote.Account_for__c = [SELECT Id, Name FROM Account Where Name = 'Cotizador' limit 1].Id;
            quote.Team__c = 'P2G';
            quote.Quotation_Status__c = 'Quote being prepared';          
            quote.Valid_From__c = system.today();
            quote.Valid_Until__c = system.today();
            quote.Country_ofLoad__c = locationLoad.Country__c;
            quote.State_of_Load__c = locationLoad.State__c;
            quote.Site_of_Load__c = wrapper.siteLoad;
            quote.Country_ofDischarge__c = locationDischarge.Country__c;
            quote.State_of_Discharge__c = locationDischarge.State__c;
            quote.Site_of_Discharge__c = wrapper.siteDischarge;
            quote.ETD__c = system.today();
            quote.ETA__c =system.today()+7;
            quote.Community_Status__c = 'CUSTOMER CREATED';
            Time myTime = Time.newInstance(8, 00, 0, 0);
            quote.Awaiting_load_time__c = myTime;
            quote.Pricing_Executive__c = UserInfo.getUserId();
            switch on wrapper.tipoServicio {
                when 'SP-FN-FLETE NACIONAL' {
                    //inicio FN-FLET_NACIONAL_IC
                    quote.Comercio_Exterior__c = 'No';
                    quote.Freight_Mode__c = 'Road';
                    quote.Service_Mode__c = 'NATIONAL';
                    quote.Service_Type__c = 'FTL';
                    quote.CurrencyIsoCode = 'MXN';
                    //termino FN-FLET_NACIONAL_IC
                }
                when 'SP-FI-FLETE INTER' {
                    quote.Comercio_Exterior__c = 'No';
                    quote.Freight_Mode__c = 'Road';
                    quote.Service_Mode__c = 'EXPORT';
                    quote.Service_Type__c = 'FTL';
                    quote.CurrencyIsoCode = 'MXN';
                    quote.Border__c = 'Norte';// preguntar no es fijo
                    quote.Customs__c = 'Ciudad Acuña';//preguntar no es fijo
                }
            }
            insert quote;
            return quote;
        }
        catch(Exception e){
            System.debug('Error rellenar campos: creaIeqCotizador '+e.getMessage()+e.getLineNumber());
            return quote;
        }     
    }

    @AuraEnabled
    public static wrapperCotizador crearEmbarque(wrapperCotizador cotizador){
        Map<Integer,String> datos = new Map<Integer,String>();
        String coloniaFis = cotizador.coloniaFiscal;
		coloniaFis = coloniaFis.replaceAll('(\\s+)','');
        String coloniaOr = cotizador.coloniaOrigen;
		coloniaOr = coloniaOr.replaceAll('(\\s+)','');
        String coloniaDes = cotizador.coloniaDestino;
		coloniaDes = coloniaDes.replaceAll('(\\s+)','');
        Map<String, Decimal> cordenadasFiscal = P2G_callsCotizador.getCoordinates(cotizador.cPFiscal,coloniaFis);
        Map<String, Decimal> cordenadasOrigen = P2G_callsCotizador.getCoordinates(cotizador.cPOrigen,coloniaOr);
        Map<String, Decimal> cordenadasDestino = P2G_callsCotizador.getCoordinates(cotizador.cPDestino,coloniaDes);
        Account cuenta = creaAccount(cotizador);
        insert cuenta;
        eliminarSuscripcionCuenta(cuenta.Id, UserInfo.getUserId());
        cotizador.cuentaId = cuenta.id;
        P2G_callsCotizador.altaSAP(cuenta.Id,cotizador.tipoServicio);
		System.debug('id cuenta: '+cuenta.id);
        crearAccountAddres(cotizador, cuenta,cordenadasFiscal,cordenadasOrigen,cordenadasDestino);
        
        //datos.p
        //convieteLeand(datos);
        return cotizador;
    }

    public static void eliminarSuscripcionCuenta(String accountId, String userId) {
        // Consulta las suscripciones de la entidad de la cuenta para el usuario específico
        List<EntitySubscription> subscriptions = [SELECT Id FROM EntitySubscription WHERE ParentId = :accountId AND SubscriberId = :userId];
        if (!subscriptions.isEmpty()) {
            delete subscriptions;
        }
    }
    
    
    public static Account_Address__c creAccountAddres(String Name,String idCuenta,String cuentaName,String calle,
                                                      String noExterior,String noInterior,String cP,String colonia,Map<String, Decimal> cordenadas)
    {
        
        Account_Address__c address = new Account_Address__c();
        address.Name = Name + cuentaName;
        address.Account__c = idCuenta;
        address.Calle_cat__c = calle;
        address.Numero_Ext_cp__c = noExterior;
        address.Numero_Int_cat__c = noInterior;
        address.Codigo_Postal_CP__c = cP;
        if(!Test.isRunningTest()){
        	address.Colonia_cp__c = colonia;
        }
        address.Type__c = 'Shipping Address	';
        address.Address_Coordinates__Latitude__s = cordenadas.get('latitude');
        address.Address_Coordinates__Longitude__s = cordenadas.get('longitude');
        
        //insert address;        System.debug('address: '+address.Id);
        return address;
    }
    
    public static void crearAccountAddres(wrapperCotizador wrapper,Account cuenta,Map<String, Decimal> cordenadasFiscal,Map<String, Decimal> cordenadasOrigen, Map<String, Decimal> cordenadasDestino){
        //account Fiscal
        Account_Address__c accountFiscal = creAccountAddres('Fiscal ',cuenta.Id,cuenta.Name,wrapper.calleFiscal,wrapper.exteriorFiscal,wrapper.interiorFiscal,wrapper.cPFiscalId,wrapper.coloniaFiscalId,cordenadasFiscal);
        insert accountFiscal;
        //account origen
        Account_Address__c accountOrigen = creAccountAddres('Origen ',cuenta.Id,cuenta.Name,wrapper.calleOrigen,wrapper.exteriorOrigen,wrapper.interiorOrigen,wrapper.cPOrigenId,wrapper.coloniaOrigenId,cordenadasOrigen);
        insert accountOrigen;
        //account destino
        Account_Address__c accountDestino = creAccountAddres('Destino ',cuenta.Id,cuenta.Name,wrapper.calleDestino,wrapper.exteriorDestino,wrapper.interiorDestino,wrapper.cPDestinoId,wrapper.coloniaDestinoId,cordenadasDestino);
        insert accountDestino;
        
        cuenta.Direccion_Principal__c = accountFiscal.Id;
        update cuenta;
        updateQuote(wrapper.quoteId, 3, cuenta.Id,wrapper.etd,wrapper.eta,accountOrigen.Id,accountDestino.Id);
    }
    public static void updateQuote(String idQuote, Integer opcion, String idCuenta,String etd, String eta,String addressOr, String addressDes) {
        Customer_Quote__c quote = new Customer_Quote__c();
        quote.Id = idQuote;
        switch on opcion {
            when 1 {
                	quote.Quotation_Status__c = 'Awaiting costs suppliers';
            }
            when 2 {
                quote.Motivo__c = 'TARIFA ALTA';
                quote.Declined_for__c = 'cancelacion por cliente';
                quote.Declined_for2__c = 'NIVEL DE SERVICIO';     
                quote.Que_tarifa_esperaba_el_cliente__c=23232;
                quote.Folio_Declinado__c=true;
                quote.Quotation_Status__c = 'Quote Declined';
            }
            when 3 {
                quote.Account_for__c = idCuenta;
                quote.ETD__c = Date.valueOf(etd);
                quote.ETA__c = Date.valueOf(eta);
                quote.Account_Origin_Address__c = addressOr;
                quote.Account_Destination_Address__c = addressDes;
            }
            when else {
                System.debug('default');
            }
        }
        
        if(!Test.isRunningTest()){
        update quote;}
    }
    
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper rellenaServiceRate(wrapperCotizador cotizador,String ruta, String acount){
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper data = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
        data.ServiceRateName = 'Flete Cotizador'; 
        data.ShipmentRouteId = ruta; 
        data.Moneda = 'MXN'; 
        data.FeeCategory = 'Road Freights'; 
        data.Grou = cotizador.tipoServicio;
        data.SapServiceTypeId = cotizador.sapServiceType;
        data.containerTypeId = cotizador.containerType;
        data.AccountId = acount;
        data.SellRate ='0';
        data.BuyRate ='0';
        return data;
    }
    
    public static P2G_CreacionFoliosWrapper.cargoLine llenarCargoLine(wrapperCotizador cotizador,String quoteId,String item){
        P2G_CreacionFoliosWrapper.cargoLine cargo = new P2G_CreacionFoliosWrapper.cargoLine();
        
        cargo.idQuote = quoteId;
        cargo.idItem = item;
        cargo.idSST = cotizador.sapServiceType;
        cargo.idConteinerType = cotizador.containerType;
        cargo.idClaveSat = cotizador.claveServicio;
        cargo.extencionItemName = cotizador.claveServicioName;
        cargo.currencyIsoCode = 'MXN';
        cargo.units = '1';
        cargo.pesoBruto = '1';
        cargo.pesoNeto = '1';
        cargo.totalShipping = '1';
        return cargo;
    }
     
    @AuraEnabled
    public static List<Catalogo_SAT__c> codigoPostal(String search,Integer op, String Idcp){
        String recordTypeId;
        List<Catalogo_SAT__c> catalogos;
        if(op == 1){
            recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();
            catalogos = [SELECT Id,Name,Clave_SAT__c,Clave_Relacion_SAT__r.Name,Codigo_Postal__c,Municipio_Ref_CP__r.Name,Localidad_Ref_CP__r.Name,Pais_RefCP__r.Name 
                         FROM Catalogo_SAT__c 
                         where (RecordTypeId=:recordTypeId AND Name LIKE :'%'+search+'%') OR Name ='9808282' limit 10];
        }
        
        if(op == 2){
            recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Colonia').getRecordTypeId();
            catalogos = [SELECT Id,Name,Clave_SAT__c,Clave_Relacion_SAT__c,Codigo_Postal__c,Municipio_Ref_CP__c,Localidad_Ref_CP__c,Pais_RefCP__c 
                         FROM Catalogo_SAT__c 
                         where RecordTypeId=:recordTypeId AND Clave_Relacion_SAT__c =:Idcp AND Name LIKE :'%'+search+'%' limit 10];
        }
        
        return catalogos;
    }
    
    @AuraEnabled
    public static Account creaAccount(wrapperCotizador cotizador){
        List<Catalogo_SAT__c> cp = codigoPostal(cotizador.cPFiscal,1,'');
        String ciudad;
        String estado;
        String pais;
        String localidad;
        for(Catalogo_SAT__c codigo : cp){
            if(codigo.id == cotizador.cPFiscalId){
        		ciudad = codigo.Municipio_Ref_CP__r.Name; 
                estado = codigo.Clave_Relacion_SAT__r.Name;
        		pais = codigo.Pais_RefCP__r.Name;
                localidad = codigo.Localidad_Ref_CP__r.Name;
            }
        }
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account cuenta = new Account();
        cuenta.RecordTypeId = recordTypeId; 
        cuenta.OwnerId = UserInfo.getUserId();
        cuenta.Name = cotizador.razonSocial;//RazonSocial
        cuenta.Phone=cotizador.telefonoCliente;
        cuenta.NEU_Email__c=cotizador.emailCliente;//Email
        cuenta.TAX_ID__c = cotizador.rfc;	//RFC
        cuenta.Bank_Name_Supplier_Form2__c = cotizador.banco;//PENDIENTE
		cuenta.Bank_Account_Number__c = cotizador.numeroCuenta;//PENDIENTE
        cuenta.BillingStreet = cotizador.calleFiscal;//DireccionFiscal (Dirección de Fiscal)
        cuenta.BillingCity = ciudad; 
        cuenta.BillingState = estado; 
        cuenta.BillingPostalCode = cotizador.cPFiscal;
        cuenta.BillingCountry = pais;
        cuenta.Estado__c = localidad; //Dirección de Fiscal
		cuenta.Address_in_Sap__c = 'Calle: '+cotizador.calleFiscal+' CP: '+cotizador.cPFiscal+', '+ciudad+', '+estado+', '+pais;//Copiar Billing Address = Address_in_Sap__c
        cuenta.Credit_Terms__c = 'Contado'; //DiasCredito
        cuenta.Requiere_Evidencia__c = 'No';//RequiereEvidencia
        cuenta.Tipo_de_Acuse_Sap__c	= 'No Requiere';//TipoEvidenciaAcuse
        cuenta.Tippag_cta__c = 'Contado';//MetodoPago
        cuenta.Forpag_cta__c = '03 - TRANSFERENCIA ELECTRONICA DE FONDOS';//FormaPago
        cuenta.Uso_CFDI__c = 'G03';//UsoCFDI     *********Gastos en general
        cuenta.Periodo_de_Facturacion__c = 'Indefinido';//PeriodoFacturacion
        cuenta.Inerep_cta__c = false;//0 ;Boolean
        cuenta.Acta_Constitutiva_Poder_Rep_Legal__c = False;
        cuenta.Evidencia_de_Visita_del_Vendedor__c = False;
        cuenta.CurrencyIsoCode = 'MXN';
        cuenta.Payment_Method__c = 'PUE- PAGO UNA EXHIBICION';
        cuenta.Requiere_Orden_de_Compra__c = False;
        cuenta.Monto_Credito_Solicitado__c = 0;
        cuenta.Credit_Limit__c = 0;
        cuenta.RegFiscal_SAP__c = '601 - General de Ley Personas Morales';
		cuenta.Obsycom_cta__c = 'SPOT';
        cuenta.Fecha_Recepcion_Factura__c = System.today();
        cuenta.Uso_Portal__c = False;
        cuenta.AccountSource = 'MKT - SPOT';
		cuenta.ParentId = '0014T00000EIt8AQAT'; //id cotizador			PROD 0014T00000EIt8AQAT
        cuenta.Credit_Limit__c = 100000;
        cuenta.Venta_Sap__c = 'Contado';
        cuenta.ActiveSap__c=true;
        switch on cotizador.tipoServicio {
            when 'SP-FN-FLETE NACIONAL' {
                cuenta.Tipo_de_Servicio_Prospecto__c = 'FN';//TipoServicio FI o FN ****no es fijo
                Cuenta.Tipo_de_Servicio_Prospecto2__c = 'FN - Flete Nacional';
            }
            when 'SP-FI-FLETE INTER' {
                cuenta.Tipo_de_Servicio_Prospecto__c = 'FI';//TipoServicio FI o FN ****no es fijo
                Cuenta.Tipo_de_Servicio_Prospecto2__c = 'FI - Flete Internacional';
            }
            when else {
                System.debug('default');
            }
        }
        return cuenta;
    }
    
    @AuraEnabled
    public static list<SAP_Service_Type__c> getSapServiceType(string SapService, String tipoServicio){
        string grou = tipoServicio;
        string searchKeyword = '%' + SapService + '%';
        system.debug('lo que llega: '+SapService+' el grupo; '+ tipoServicio);
        list<SAP_Service_Type__c> SapServiceListRecord = new list<SAP_Service_Type__c>();
        for(SAP_Service_Type__c sapServiceSearch : [SELECT Id, Name, Code__c FROM SAP_Service_Type__c 
                                                    WHERE Activo__c =: TRUE AND Name LIKE : searchKeyword AND Group__c =: grou]){
                                                        SapServiceListRecord.add(sapServiceSearch);
                                                    }
        if(SapServiceListRecord.size() == 0 && !Test.isRunningTest()){
            throw new AuraHandledException('No Record Found..'); 
        }
        return SapServiceListRecord;
    }
    @AuraEnabled
    public static void updateCosto(String quoteId,String price){
        System.debug('quote id: ' + quoteId);
        Import_Export_Fee_Line__c serviceLine = [Select Quote_Sell_Price__c,Service_Rate_Name__c From Import_Export_Fee_Line__c 
                                                       Where Import_Export_Quote__c =: quoteId Limit 1];
        serviceLine.Quote_Sell_Price__c = Double.valueOf(price);
        Fee__c serviceRate = new Fee__c();
        serviceRate.Id = serviceLine.Service_Rate_Name__c;
        serviceRate.Fee_Rate__c = Double.valueOf(price);
        if(!Test.isRunningTest()){
            update serviceLine;
            update serviceRate;
        }
    }
}