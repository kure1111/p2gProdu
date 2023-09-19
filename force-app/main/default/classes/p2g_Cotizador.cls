public class p2g_Cotizador {
    
    public static Lead crearLead(P2G_PruebaMetodos.wrapperCotizador cotizador) {
        Lead lead = new Lead();
        lead.Mkt_Executive__c = 'Comercial';//hacer spot
        lead.LeadSource='Other'; //hacer uno Spot
        lead.LastName = 'perez';
        lead.Company ='p2g';
        lead.Medio_de_Contacto__c='Radio';//agregar Spot
        lead.Tipo_de_Servicio_Prospecto__c ='Seguros';//Fn por ahora
        lead.Description ='Spot';
        lead.Mercancia__c='Viable';
        lead.Status='Open';
        lead.Customs_Broker_Required__c='No';
        lead.Rating='A';
        lead.Industry='Automotriz';//Otras industrias o actividades

        
        lead.FirstName = cotizador.nameCliente;
        lead.Phone = cotizador.telefonoCliente;
        lead.Email = cotizador.emailCliente;
        try {
            //insert lead;
            return lead;
            
        } catch (Exception e) {
            System.debug('Error al crear el Lead: ' + e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static P2G_PruebaMetodos.wrapperCotizador Cotizador(P2G_PruebaMetodos.wrapperCotizador cotizador, Integer ban){
        Lead lead = crearLead(cotizador);
        cotizador.tarifario = false;
        Customer_Quote__c quote = creaIeqCotizador(cotizador);
        Customer_Quote__c idQuote = [SELECT Route__c, Name FROM Customer_Quote__c WHERE Id =: quote.Id];
        Fee__c tarifario = P2G_CreacionFolios.condicionesTarifario('noTomarId',cotizador.sapServiceType,cotizador.containerType,idQuote.Route__c);
        if(tarifario!=null){
            cotizador.costo = String.valueOf(tarifario.Fee_Rate__c);
            cotizador.iva = String.valueOf(tarifario.Buy_Rate__c);
        	cotizador.otroGasto = '4444';
            cotizador.tarifario = true;
            cotizador.quoteId = quote.Id;
            cotizador.quoteName = idQuote.Name;
            
            return cotizador;
        }
        else{
            cotizador.tarifario = false;
            cotizador.quoteId = quote.Id;
            cotizador.quoteName = idQuote.Name;
            enviarCorreo(quote.Id);
            return cotizador;	
        }
    }
    
    public static Customer_Quote__c creaIeqCotizador(P2G_PruebaMetodos.wrapperCotizador wrapper){
        Customer_Quote__c quote = new Customer_Quote__c();
        try{
            String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
            Location__c locationLoad = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:wrapper.siteLoad limit 1];
            Location__c locationDischarge = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:wrapper.siteDischarge limit 1];
            Catalogo_SAT__c recordTypeUnidad = [SELECT 	Id, Name FROM Catalogo_SAT__c where Name = 'Pallet' limit : 1];
            quote.RecordTypeId = recordTypeId;
            quote.Clave_de_Unidad_de_Peso__c = recordTypeUnidad.Id;
            quote.Name='.';
            quote.Account_for__c = [SELECT Id, Name FROM Account Where Name = 'Cotizador' limit 1].Id;
            quote.Team__c = 'P2G';
            quote.Quotation_Status__c = 'Quote being prepared';          
            quote.Valid_From__c = system.today();
            quote.Valid_Until__c = system.today();
            //inicio FN-FLET_NACIONAL_IC
            quote.Comercio_Exterior__c = 'No';
            quote.Freight_Mode__c = 'Road';
            quote.Service_Mode__c = 'NATIONAL';
            quote.Service_Type__c = 'FTL';
            quote.CurrencyIsoCode = 'MXN';
            //termino FN-FLET_NACIONAL_IC
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
            insert quote;
            return quote;
        }
        catch(Exception e){
            System.debug('Error rellenar campos: creaIeqCotizador '+e.getMessage()+e.getLineNumber());
            return quote;
        }     
    }
    
    @AuraEnabled
    public static void declinado(P2G_PruebaMetodos.wrapperCotizador wrapper){
        updateQuote(wrapper.quoteId,2);    
    }
    
    @AuraEnabled
    public static boolean crearEmbarque(P2G_PruebaMetodos.wrapperCotizador wrapper){
        updateQuote(wrapper.quoteId,3);  
        return true;
    }
    
    public static void enviarCorreo(String IdObjeto) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{'alberto.garcia@pak2go.com'});
        email.setReplyTo('alberto.garcia@pak2go.com');
        email.setSenderDisplayName('Albert');
        
        //asunto del correo
        email.setSubject('Actualización de Costo:  ' + IdObjeto);
        
        String cuerpoCorreo = '<p>Hola,</p>';
        cuerpoCorreo += '<p>Por favor, actualice el costo de Service Rate:</p>';
        cuerpoCorreo += '<p><strong>Quote:</strong> ' + IdObjeto + '</p>';
        cuerpoCorreo += '<p><a href="https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Customer_Quote__c/' + IdObjeto + '/view">Haga clic aquí para actualizar</a></p>';
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
    
    public static void updateQuote(String idQuote, Integer opcion) {
    Customer_Quote__c quote = new Customer_Quote__c();
    quote.Id = idQuote;

    switch on opcion {
       when 1 {
           quote.Quotation_Status__c = 'Awaiting costs suppliers';
       }
       when 2 {
           quote.Quotation_Status__c = 'Quote Declined';
       }
       when 3 {
           //quote.Quotation_Status__c = 'Quote Approved';
           //ETD,ETA, Cargo
       }
       when else {
           System.debug('default');
       }
    }
    update quote;
}

    
}