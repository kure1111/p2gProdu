global class P2G_CreacionFolioEmail implements Messaging.InboundEmailHandler{
//global String webService;
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        String htmlBody = email.htmlBody;
        String htmlTxt = email.plainTextBody;
        htmlTxt = htmlTxt.replaceAll('\n', '');
        String accountFor;
        String fechaSalida;
        String fechaEntrega;
        String Container;
        String OriAdrres;
        String DestAdrres;
        String PesoB;
        String PesoN;
        String TotalS;
        String ClaveP;
        String units;
        String Reference;
        fechaSalida = htmlTxt.substringBetween('Fecha de carga','Fecha de última entrega');
        fechaEntrega = htmlTxt.substringBetween('Fecha de última entrega', 'Se requiere Dock Scheduling');
        Container = htmlTxt.substringBetween('Equipo', 'Peso Bruto Total por Clave Producto');
        OriAdrres = htmlTxt.substringBetween('Origen', 'Destino');
        DestAdrres = htmlTxt.substringBetween('Destino', 'Peligroso');
        PesoB = htmlTxt.substringBetween('Peso del envío con tarimas', 'Peso del envío sin tarimas');
        PesoN = htmlTxt.substringBetween('Peso del envío sin tarimas', 'Número total de tarimas');
        TotalS = htmlTxt.substringBetween('Volumen total', 'CUMTR');
        ClaveP = htmlTxt.substringBetween('Peso Bruto Total por Clave Producto', 'KG');
        units = htmlTxt.substringBetween('Número total de tarimas', 'Número total de espacios de tarima');
        Reference = htmlTxt.substringBetween('ID de envío', 'Parada');
        String[] parseEtd = fechaSalida.split(' ');
        String etd = parseEtd[0];
        String awaitingLoad = parseEtd[1];
        String[] parseEta = fechaEntrega.split(' ');
        String eta = parseEta[0];
        String awaitingDischar = parseEta[1];
        String[] parseClaveP = ClaveP.split(',');
        String[] parseClaveP2=parseClaveP[0].split('-');
        String Clave = parseClaveP2[0];
        String[] parsePesoB = PesoB.split('-');
        String PesoBruto = parsePesoB[0];
        String[] parsePesoN = PesoN.split('-');
        String PesoNeto = parsePesoN[0];
        String[] total = TotalS.split('KG');
        String TotalV = total[1];
        Pattern accountForPatter = Pattern.compile('de la compa&ntilde;&iacute;a (.*?) Tel&eacute;fono');
        Matcher accFor = accountForPatter.matcher(htmlBody);
        Pattern customerReferen = Pattern.compile('de la compa&ntilde;&iacute;a (.*?) Tel&eacute;fono');
        Matcher cutomerR = customerReferen.matcher(htmlBody);
        
        if(accFor.find()){
            System.debug('Encontrado: '+accFor.group(1));
            accountFor=accFor.group(1);
        }
        P2G_CreacionFoliosWrapper.folio folio = new P2G_CreacionFoliosWrapper.folio();
        folio.idSideLoad = OriAdrres;//'ZM de Toluca';
        folio.idSideDischarged = DestAdrres;//'Villahermosa';
        folio.idAccount = accountFor;
        folio.etd = etd;//'2023-04-20';//
        folio.eta = eta;//'2023-04-20';//
        folio.Awaitingloadtime = awaitingLoad;
        folio.Awaitingunloadtime = awaitingDischar;
        folio.reference = Reference;
        
        P2G_CreacionFoliosWrapper.cargoLine cargo = new P2G_CreacionFoliosWrapper.cargoLine();
        cargo.idConteinerType = Container;// buscaContainer(Container, '0010R000019aZF8QAM');
        cargo.idClaveSat = Clave;
        cargo.currencyIsoCode = 'MXN';
        cargo.units = units;
        cargo.pesoBruto = PesoBruto;
        cargo.pesoNeto = PesoNeto;
        cargo.totalShipping = TotalV;
        try{
            list<Customer_Quote__c> folioCreado = creaFolio(folio, cargo);
            System.debug('Cargo: '+cargo);
            System.debug('Folio: '+folio);
        }
        catch(Exception e){
            System.debug('Error en P2G_CreacionFolioEmail: '+e.getMessage()+' '+e.getLineNumber());   
        }
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        return result;
    }
    public static String buscaContainer(String container,String IdAccount){
        String Cont;
        Equivalencias__c equivalencia = [SELECT Id,Name,Caja_53_FT__c FROM Equivalencias__c WHERE Account__c =:IdAccount limit 1];
        String[] equi = equivalencia.Caja_53_FT__c.split(';');
        if(equi.contains(container)){
            Cont = equivalencia.Name;
        }
        return Cont;   
    }
    public static String getLocation(String OriAdrress){
        String side;
        try{
            Account_Address__c OAdrres = [SELECT Municipio_Cat2__c FROM Account_Address__c WHERE Name=:OriAdrress limit 1];
            String[] equi = OAdrres.Municipio_Cat2__c.split(' ');
            side = equi[1];
        }
        catch(Exception e){
            System.debug('Error en location: '+e.getMessage()+' '+e.getLineNumber());
        }
        return side;
    }
    public static List<Customer_Quote__c> creaFolio(P2G_CreacionFoliosWrapper.folio fleteNacional,P2G_CreacionFoliosWrapper.cargoLine cargo){
        Customer_Quote__c quote = new Customer_Quote__c();
        Account Account = [SELECT Id, Name, DGIEQO_Web_Service_IEQO__c FROM Account WHERE Name =:fleteNacional.idAccount LIMIT 1];
        Account_Address__c AccountOrigin;
        Account_Address__c AccountDestin;
        String NameOrigen;
        String NameDestin;
        if(Test.isRunningTest()){
            NameOrigen = fleteNacional.idSideLoad;
            NameDestin = fleteNacional.idSideDischarged;
        }
        else{
            AccountOrigin = [SELECT Id, Name FROM Account_Address__c WHERE name =:fleteNacional.idSideLoad limit 1];      
            NameOrigen = getLocation(AccountOrigin.Name);
            AccountDestin = [SELECT Id, Name FROM Account_Address__c WHERE name =:fleteNacional.idSideDischarged limit 1];      
            NameDestin = getLocation(AccountDestin.Name);
        }
        List<Location__c> ListaNombre = [SELECT Id, Name FROM Location__c WHERE name LIKE: '%'+NameOrigen+'%' or Name LIKE: '%'+NameDestin+'%'];
        for(Location__c Nombre : ListaNombre){
            if(Nombre.Name == 'ZM de '+NameOrigen){
                fleteNacional.idSideLoad = Nombre.Id;//'a030R000008RxFDQA0';//'a030R000008RxCQQA0';//Nombre.Id;//
            }else if(Nombre.Name == NameOrigen){
                fleteNacional.idSideLoad = Nombre.Id;//'a030R000008RxFDQA0';//'a030R000008RxCQQA0';//Nombre.Id;//
            }
        }
        for(Location__c Nombre : ListaNombre){
            if(Nombre.Name == 'ZM de '+NameDestin){
                fleteNacional.idSideDischarged = Nombre.Id;//'a030R000008RxCVQA0';//'a030R000008RxCRQA0';//Nombre.Id;//
            }else if(Nombre.Name == NameDestin){
                fleteNacional.idSideDischarged = Nombre.Id;//'a030R000008RxCVQA0';//'a030R000008RxCRQA0';//Nombre.Id;//
            }
        }
        
        String Conteiner = buscaContainer(cargo.idConteinerType,Account.Id);
        Container_Type__c ConteinerT = [SELECT id, Name FROM Container_Type__c WHERE Name =: Conteiner limit 1];
        Catalogo_SAT__c ClaveSeProducto = [SELECT Id, Name, Clave_SAT__c FROM Catalogo_SAT__c where Clave_SAT__c =: cargo.idClaveSat limit 1];
        
        fleteNacional.idAccount = Account.Id;
        if(!Test.isRunningTest()){
            fleteNacional.AccountOriginAddress = AccountOrigin.Id;
            fleteNacional.AccountDestinAddress = AccountDestin.Id;
        }
        fleteNacional.numFoliosCrear = 1;
        fleteNacional.comercioExterior = 'No';
        fleteNacional.freighMode = 'Road';
        fleteNacional.serviceMode = 'NATIONAL';
        fleteNacional.servicetype = 'FTL';
        fleteNacional.rurrencyIsoCode = 'MXN';
        fleteNacional.team = 'P2G';
        fleteNacional.CommunityStatus = 'CUSTOMER CREATED';
        fleteNacional.quotationStatus = 'Quote being prepared';
        
        cargo.idConteinerType = ConteinerT.Id;//'a0F4T000000R9qQUAS';//
        cargo.idClaveSat =ClaveSeProducto.Id;
        cargo.extencionItemName = ClaveSeProducto.Name;
        List<Customer_Quote__c> folioCreado;
        folioCreado = P2G_CreacionFolios.creaFolios(fleteNacional, cargo);
        creaService(folioCreado, cargo.currencyIsoCode, ConteinerT.Id/*'a0F4T000000R9qQUAS'*/, Account.Id, Account.DGIEQO_Web_Service_IEQO__c);
        return folioCreado;   
    }
    public static void creaService(List<Customer_Quote__c> listaFolio,string divisa,string idConteinerType,string account,boolean webSer){
        list<Fee__c> listServiceRate = new list<Fee__c>();
        list<Import_Export_Fee_Line__c> listserviceLine= new list<Import_Export_Fee_Line__c>();
        Customer_Quote__c idRoute = [SELECT Id, Name, Route__c, etd__c FROM Customer_Quote__c WHERE Id =: listaFolio limit 1];
        Fee__c buscaTarifario = P2G_CreacionFolios.condicionesTarifario(account,'a1n4T000001XXYCQA4',idConteinerType,idRoute.Route__c);
        if(buscaTarifario==null){
            listServiceRate.add(P2G_CreacionFolios.CreateServiceRate(idRoute.Route__c, divisa, idConteinerType, account));
            insert listServiceRate;
            integer posicionItem = 0;
            for(fee__c service:listServiceRate){
                String idService = service.Id;
                String idQuote = idRoute.Id;
                posicionItem = posicionItem+1;
                listserviceLine.add(P2G_CreacionFolios.CreateServiceLine(idQuote, idService,0,0)); 
            }
            insert listserviceLine;
            updateQuote(idRoute.Id);
        }
        else{
            Customer_Quote__c quote = new Customer_Quote__c();
            String idService = buscaTarifario.Id;
            Decimal feeRate = buscaTarifario.Fee_Rate__c;
            Decimal buyRate = buscaTarifario.Buy_Rate__c;
            String idQuote = idRoute.Id;
            listserviceLine.add(P2G_CreacionFolios.CreateServiceLine(idQuote, idService,feeRate,buyRate));
            insert listserviceLine;
           	updateQuote2(idRoute.Id);
        }
    }
    public static void updateQuote(String Id){
        Customer_Quote__c quote = new Customer_Quote__c();
        quote.Id = Id;
        quote.Quotation_Status__c = 'Awaiting costs suppliers';
        update quote;
        System.debug('folio actualizado' + quote);
    }
    public static void updateQuote2(String IdQuote){
        P2G_UpdateQuoteSchedule myJob = new P2G_UpdateQuoteSchedule(IdQuote);
        DateTime startTime = System.now().addSeconds(5);//addMinutes(1)
        String cronExpr = startTime.second() + ' ' + startTime.minute() + ' ' + startTime.hour() + ' ' + startTime.day() + ' ' + startTime.month() + ' ? ' + startTime.year();
        String jobName = 'Email job '+cronExpr;
        System.schedule(jobName, cronExpr, myJob);
    }
}