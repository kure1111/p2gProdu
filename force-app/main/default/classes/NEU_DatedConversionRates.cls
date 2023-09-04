global class NEU_DatedConversionRates 
{
    // Para probar el proceso desde la Developer:
    /* 
NEU_UpdateDatedConversionRates sched = new NEU_UpdateDatedConversionRates();
String minuto = String.valueof(system.now().minute()+1);
String hora = String.valueof(system.now().hour());
String dia = String.valueof(system.today().day());
String mes = String.valueof(system.today().month());
String anio = String.valueof(system.today().year());
Id job_id = System.schedule('NEU_UpdateDatedConversionRates', '0 '+minuto+' '+hora+' '+dia+' '+mes+' ? '+anio, sched);
*/
    
    @future(callout=true)
    public static void update_data()
    {
        if(UserInfo.isMultiCurrencyOrganization())
        {
            string consulta = 'SELECT Id, IsoCode, ConversionRate, IsActive, DecimalPlaces, IsCorporate FROM CurrencyType';
            List<sObject> conversion = database.query(consulta);
            
            if(conversion.size() > 0)
            {
                Integer TIMEOUT = 50000;
                
                Decimal USD_rate = 0;
                Decimal EUR_rate = 0;
                
                try
                {
                   	DateTime tody = DateTime.newInstance(system.today().year(), system.today().month(), system.today().day());
                    DateTime ayer  = tody.addDays(-1);
                    
                    string start_date = ayer.format('yyyy-MM-dd');// system.today().year()+'-'+system.today().month()+'-'+system.today().day();
                    string end_date = ayer.format('yyyy-MM-dd');//system.today().year()+'-'+system.today().month()+'-'+system.today().day();
                    String fecha = tody.format('yyyy-MM-dd');//system.today().year()+'-'+system.today().month()+'-'+system.today().day();
                    
                    string  fecha1 =  ayer.format('dd-MM-yyyy');
                    string  fecha2 =  ayer.format('dd/MM/yyyy');
                    
                    system.debug('fecha 1  --> ' + fecha1);
                    system.debug('fecha 2  --> ' + fecha2);
                    //CONVERSION RATES (OPCION PAK2GO)
                    
                    //EUR
                    Http h_EUR = new Http();
                    HttpRequest req_EUR = new HttpRequest();
                    req_EUR.setEndpoint('https://www.banxico.org.mx/SieAPIRest/service/v1/series/SF46410/datos/'+start_date+'/'+end_date+'?token=151eed2463c0d26e75848513409564b0465304b7356f2fcc6a155faa35304fa3');
                    req_EUR.setHeader('Content-Type', 'application/json');
                    req_EUR.setMethod('GET');
                    if(!Test.isRunningTest())
                    {
                        HttpResponse res_EUR = h_EUR.send(req_EUR);
                        string JSONResponse = res_EUR.getBody();
                        
                        if(JSONResponse.contains(fecha1)||JSONResponse.contains(fecha2))
                        {
                            EUR_rate = 1 / decimal.valueof(JSONResponse.substringBetween('"dato":"','"'));
                        }
                    }
                    
                    //USD
                    Http h_USD = new Http();
                    HttpRequest req_USD = new HttpRequest();
                    req_USD.setEndpoint('https://www.banxico.org.mx/SieAPIRest/service/v1/series/SF43718/datos/'+start_date+'/'+end_date+'?token=151eed2463c0d26e75848513409564b0465304b7356f2fcc6a155faa35304fa3');
                    req_USD.setHeader('Content-Type', 'application/json');
                    req_USD.setMethod('GET');
                    
                    if(!Test.isRunningTest())
                    {
                        HttpResponse res_USD = h_USD.send(req_USD);
                        string JSONResponse = res_USD.getBody();
                        
                        system.debug('response --> ' + JSONResponse);
                        
                        
                        
                        if(JSONResponse.contains(fecha1)||JSONResponse.contains(fecha2))
                        {
                            system.debug('Entramos ');
                            USD_rate = 1 / decimal.valueof(JSONResponse.substringBetween('"dato":"','"'));
                            system.debug('Entramos USD_rate ' + USD_rate);
                        }
                    }
                    
                    //Si la API no devuelve datos entendemos que el ratio no ha cambiado y asignamos el mismo valor del día anterior
                    if(EUR_rate == 0 || USD_rate == 0)
                    {
                        for(sObject c : conversion)
                        {
                            if(string.valueof(c.get('IsoCode')) == 'USD' && USD_rate == 0)
                                USD_rate = decimal.valueof(string.valueof(c.get('ConversionRate')));
                            if(string.valueof(c.get('IsoCode')) == 'EUR' && EUR_rate == 0)
                                EUR_rate = decimal.valueof(string.valueof(c.get('ConversionRate')));
                        }
                    }
                    
                    for(sObject c : conversion)
                    {
                        if(string.valueof(c.get('IsoCode')) == 'USD') 
                            c.put('ConversionRate',USD_rate);
                        if(string.valueof(c.get('IsoCode')) == 'EUR')
                            c.put('ConversionRate',EUR_rate);
                        if(string.valueof(c.get('IsoCode')) == 'MXN')
                            c.put('ConversionRate',1);
                    }
                    //ACTUALIZACIÓN DE LA DIVISA (USD)
                    Http h2 = new Http();
                    HttpRequest req2 = new HttpRequest();
                    req2.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/DatedConversionRate/');
                    req2.setBody('{ "IsoCode" : "USD", "ConversionRate" : '+USD_rate.setScale(6)+', "StartDate" : "'+fecha+'" }');
                    req2.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
                    req2.setHeader('Content-Type', 'application/json');
                    req2.setMethod('POST');
                    if (!Test.isRunningTest())
                        HttpResponse res2 = h2.send(req2);
                    
                    //ACTUALIZACIÓN DE LA DIVISA (EUR)
                    Http h3 = new Http();
                    HttpRequest req3 = new HttpRequest();
                    req3.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/DatedConversionRate/');
                    req3.setBody('{ "IsoCode" : "EUR", "ConversionRate" : '+EUR_rate.setScale(6)+', "StartDate" : "'+fecha+'" }');
                    req3.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
                    req3.setHeader('Content-Type', 'application/json');
                    req3.setMethod('POST');
                    if (!Test.isRunningTest())
                        HttpResponse res3 = h3.send(req3);
                    
                    for(sObject c : conversion)
                    {
                        //ACTUALIZACIÓN DE LA DIVISA
                        Http h = new Http();
                        HttpRequest req = new HttpRequest();
                        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v28.0/sobjects/CurrencyType/'+string.valueof(c.get('Id'))+'?_HttpMethod=PATCH');
                        req.setBody('{ "ConversionRate" : '+(decimal.valueof(string.valueof(c.get('ConversionRate')))).setScale(6)+' }');
                        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
                        req.setHeader('Content-Type', 'application/json');
                        req.setMethod('POST');
                        if (!Test.isRunningTest())
                            HttpResponse res = h.send(req);
                    }
                }
                catch(Exception ex) 
                {
                    enviarNotificacion('Error Integración Divisas', 'Error: '+ex+' ('+ex.getLineNumber()+')');
                    
                    system.debug('Error Integración Divisas: '+ex+' ('+ex.getLineNumber()+')');
                    
                    // En caso de fallo programamos otra ejecución para la hora siguiente (en caso de ser antes de las 11).
                    if(system.now().hour()<23)
                    {
                        String minuto = String.valueof(system.now().minute());
                        String hora = String.valueof(system.now().hour()+1);
                        String dia = String.valueof(system.today().day());
                        String mes = String.valueof(system.today().month());
                        String anio = String.valueof(system.today().year());					
                        NEU_UpdateDatedConversionRates sched = new NEU_UpdateDatedConversionRates();
                        Id job_id = System.schedule('NEU_UpdateDatedConversionRates_Rerun_'+minuto+hora+dia+mes+anio, '0 '+minuto+' '+hora+' '+dia+' '+mes+' ? '+anio, sched);					
                    }
                }
            }
        }
    }
    
    public static void enviarNotificacion(string asunto, string cuerpo)
    {
        List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
        string[] correos = new  string[]{};
            for(user usr :[select id,email from user where (profile.Name ='Administrador del sistema'   or profile.Name ='System Administrator') and isactive = true])
        {
            correos.add(usr.email);
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(correos);
        mail.setSenderDisplayName('Pak2Go');
        mail.setSubject(asunto);
        mail.setBccSender(false); 
        mail.setUseSignature(false); 
        mail.setCharset('UTF-8');
        mail.setPlainTextBody(cuerpo);
        
        theEmails.add(mail);
        
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        for(Integer j = 0; j < theEmails.size(); j++)
        {
            allMails.add(theEmails.get(j));
        }
        
        try
        {
            if (!Test.isRunningTest())
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
        }
        catch(Exception exc){}		
    }
}