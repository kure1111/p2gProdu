public class p2G_FoliosEnOportunidades {
    //Asignar Folios Inicia
   @AuraEnabled
    public static List<Customer_Quote__c> getIEQO(String idOppo, String folio){
        List<Customer_Quote__c> listQuote = new List<Customer_Quote__c>();
        string searchKeyword = '%' + folio + '%';
        Opportunity oppo = [SELECT Name, AccountId, Account.Name FROM Opportunity WHERE Id =:idOppo LIMIT 1];
        for(Customer_Quote__c quote : [SELECT Id, Name, Account_for__r.Name, Route__r.Name,Quotation_Status__c FROM Customer_Quote__c
                                       WHERE Account_for__c =: oppo.AccountId AND Name LIKE : searchKeyword AND Opportunity__c !=:idOppo AND Route__c != null]){
            listQuote.add(quote);
        }
        if(listQuote.size() == 0){
            throw new AuraHandledException('Folio no encontrado con el cliente '+ oppo.Account.Name); 
        }
        return listQuote;
    }
    @AuraEnabled
    public static String asignarFolio(String idOppo, String folio){
        System.debug('lo que llega es: '+idOppo + folio);
        Customer_Quote__c quote = new Customer_Quote__c();
        String respuesta;
        try{
            quote.Id = folio;
            quote.Opportunity__c = idOppo;
            update quote;
            respuesta = 'Actualizacion Exitosa';
            System.debug(respuesta+' '+quote);
        }catch(Exception e){
            respuesta = 'Error al asignar el folio a la Oportunidad, en la clase p2G_FoliosEnOportunidades '+e.getMessage()+e.getLineNumber();
            System.debug(respuesta);
        }
        return respuesta;
    }
//Asignar Folios Termina
//Crear Folios Inicia
	public class wrapperProduct{
        @AuraEnabled public String comercioExterior{get;set;}
        @AuraEnabled public String freighMode{get;set;}
        @AuraEnabled public String serviceMode{get;set;}
        @AuraEnabled public String servicetype{get;set;}
        @AuraEnabled public String reference{get;set;}
        @AuraEnabled public String currencyIsoCode{get;set;}
        @AuraEnabled public String team{get;set;}
        @AuraEnabled public String quotationStatus{get;set;}
        @AuraEnabled public String CommunityStatus{get;set;}
        @AuraEnabled public String grupo{get;set;}
        @AuraEnabled public String idOpportunity{get;set;}
        @AuraEnabled public String nameOpportunity{get;set;}
        @AuraEnabled public String idRoute{get;set;}
        @AuraEnabled public String nameRoute{get;set;}
        @AuraEnabled public String idAccount{get;set;}
        @AuraEnabled public String nameAccount{get;set;}
        @AuraEnabled public Decimal buyPrice{get;set;}
        @AuraEnabled public Decimal sellPrice{get;set;}
        @AuraEnabled public String border{get;set;}
        @AuraEnabled public String customs{get;set;}
        @AuraEnabled public String impak{get;set;}
        @AuraEnabled public String servicioIMPAK{get;set;}
        @AuraEnabled public String salesIncoterm{get;set;}
        @AuraEnabled public String loadSite{get;set;}
        @AuraEnabled public String dischargeSite{get;set;}
        @AuraEnabled public Boolean warehouseService{get;set;}
        //para la cargoline
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String idQuote{get;set;}
        @AuraEnabled public String nameQuote{get;set;}
        @AuraEnabled public String idItem{get;set;}
        @AuraEnabled public String idConteinerType{get;set;}
        @AuraEnabled public String nameConteinerType{get;set;}
        @AuraEnabled public String extencionItemName{get;set;}
        @AuraEnabled public Decimal units{get;set;}
        @AuraEnabled public Decimal pesoBruto{get;set;}
        @AuraEnabled public String pesoNeto{get;set;}
        @AuraEnabled public String totalShipping{get;set;}
        @AuraEnabled public String currencyLine{get;set;}
        @AuraEnabled public Boolean seCrea{get;set;}
        @AuraEnabled public String idSST{get;set;}
    }
    @AuraEnabled
    public static List<wrapperProduct> getWrapper(){
        List<wrapperProduct> wrapper = new List<wrapperProduct>();
        return wrapper;
    }
    @AuraEnabled
    public static List<wrapperProduct> getRoute(String idOpportunity){
        Set<wrapperProduct> setProduct = new Set<wrapperProduct>();
        List<wrapperProduct> listProduct = new List<wrapperProduct>();
        List<OpportunityLineItem> listaRoute = [SELECT Id,Name,Product2.Name,OpportunityId,Opportunity.Name,Buy_Price__c,UnitPrice,Opportunity.Group__c,
                                         CurrencyIsoCode,Opportunity.AccountId,Opportunity.Account.Name,PROJ_Modalidad__c,PROJ_Peso_de_carga__c, Incoterm__c,
                                         Quantity,PROJ_Tipo_de_mercancia__c,Product2.PROJ_Site_of_load__c,Product2.PROJ_Site_of_discharge__c,Tipo_de_servicio__c,
                                          Tipo_de_moneda__c, Buy_Price_Converted__c, Sales_Price_Converted__c, Tipo_de_ruta__c, Customs__c, Border__c
                                         FROM OpportunityLineItem WHERE OpportunityId =: idOpportunity  AND (Status__c = 'Cotizada' OR Status__c = 'Aceptada' OR Status__c = 'Negociación con cliente')];
            System.debug('Las ruta: '+listaRoute);
        For(OpportunityLineItem route : listaRoute){
            if(!Test.isRunningTest()){
                if(route.Buy_Price__c == 0 && route.Buy_Price__c == null){
                    throw new AuraHandledException('El producto '+ route.Name+' no tiene Buy Price'); 
                }
                if(route.UnitPrice == 0){
                    throw new AuraHandledException('El producto '+ route.Name+' no tiene Sell Price'); 
                }
            }
            String[] buyPriceConverted;
            String[] salesPriceConverted;
            if(route.Buy_Price_Converted__c != null && route.Buy_Price_Converted__c != ''){
                buyPriceConverted = route.Buy_Price_Converted__c.split(' ');}
            if(route.Sales_Price_Converted__c != null && route.Sales_Price_Converted__c != ''){
                salesPriceConverted = route.Sales_Price_Converted__c.split(' ');}
        	wrapperProduct product = new wrapperProduct();
                product.id = route.Id;
                product.grupo = route.Opportunity.Group__c;
                product.idOpportunity = idOpportunity;
                product.nameOpportunity = route.Opportunity.Name;
                product.nameRoute= route.Product2.Name;
                product.idAccount = route.Opportunity.AccountId;
                product.nameAccount = route.Opportunity.Account.Name;
                product.nameConteinerType = route.PROJ_Modalidad__c;
                product.currencyIsoCode = route.CurrencyIsoCode;
                product.pesoBruto = route.PROJ_Peso_de_carga__c;
                product.units = route.Quantity;
                product.extencionItemName = route.PROJ_Tipo_de_mercancia__c;
                product.loadSite = route.Product2.PROJ_Site_of_load__c;
                product.dischargeSite = route.Product2.PROJ_Site_of_discharge__c;
            	product.seCrea = false;
            if((route.Tipo_de_moneda__c != null && route.Tipo_de_moneda__c != route.CurrencyIsoCode) && (route.Buy_Price_Converted__c != null && route.Buy_Price_Converted__c != '') && (route.Sales_Price_Converted__c != null && route.Sales_Price_Converted__c != '')){
                product.currencyLine = route.Tipo_de_moneda__c;
                product.buyPrice = Decimal.ValueOF(buyPriceConverted[1]);
                product.sellPrice = Decimal.ValueOF(salesPriceConverted[1]);
            }else{
            	product.currencyLine = route.CurrencyIsoCode;
                product.buyPrice = route.Buy_Price__c;
                product.sellPrice = route.UnitPrice;
            }
                                          listProduct.add(product);  
            System.debug('Se agrego la ruta: '+listProduct);
        }
            System.debug('numero de rutas: '+listProduct.size()+' las lineas: '+listProduct);
        return listProduct;
    }
    @AuraEnabled
    public static String foliosACrear(List<wrapperProduct> wrapperProduct){
        List<wrapperProduct> listProduct = new List<wrapperProduct>();
        List<wrapperProduct> listProductFuturo = new List<wrapperProduct>();
        String mensaje;
        if(wrapperProduct.size() > 3){
            for(Integer i=0; i<4; i++){
                listProduct.add(wrapperProduct[i]);
            }
        	mensaje = crearFolios(listProduct);
            for(Integer i=4; i<wrapperProduct.size(); i++){
                listProductFuturo.add(wrapperProduct[i]);
            }
            String json = JSON.serialize(listProductFuturo);
            crearMasFolios(json);
            System.debug('se envio al metodo futuro la lista: '+listProductFuturo);
        }else{
            mensaje = crearFolios(wrapperProduct);
        }
        return mensaje;
    }
    public static String crearFolios(List<wrapperProduct> wrapperProduct){
        String mensaje;
        List<Customer_Quote__c> creaIEQO = new List<Customer_Quote__c>();
        List<Sourcing_Item__c> creaItem = new List<Sourcing_Item__c>();
        List<Quote_Item_Line__c> createCargoLine = new List<Quote_Item_Line__c>();
        List<Fee__c> createServiceRate = new List<Fee__c>();
        List<Import_Export_Fee_Line__c> createServiceLine = new List<Import_Export_Fee_Line__c>();
        List<wrapperProduct> subProdu = new List<wrapperProduct>();
        Set<String> idProducto = new Set<String>();
        Set<String> idLocationLoadSite = new Set<String>();
        Set<String> idLocationDischargeSite = new Set<String>();
        Set<String> nameConteinerType = new Set<String>();
        Set<String> nameClaveServicio = new Set<String>();
        for(wrapperProduct product : wrapperProduct){
            idProducto.add(product.id);
            idLocationLoadSite.add(product.loadSite);
            idLocationDischargeSite.add(product.dischargeSite);
            nameConteinerType.add(product.nameConteinerType);
            nameClaveServicio.add(product.extencionItemName);
        }
        List<SAP_Service_Type__c> sapServiceType = [SELECT Id, Name FROM SAP_Service_Type__c where Group__c =: wrapperProduct[0].grupo];
        System.debug('lista de service type: '+ sapServiceType);
        Catalogo_SAT__c recordTypeUnidad = [SELECT	Id, Name FROM Catalogo_SAT__c WHERE Name = 'Pallet' limit : 1];
        String recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Productos y Servicios cP').getRecordTypeId();
        List<Catalogo_SAT__c> claveServicio = [SELECT Id, Name, RecordTypeId FROM Catalogo_SAT__c WHERE Name IN: nameClaveServicio and RecordTypeId =: recordTypeId ORDER BY CreatedDate DESC];
        List<Location__c> location = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE id IN: idLocationLoadSite OR id IN: idLocationDischargeSite];
        List<Container_Type__c> container = [SELECT Id, Name FROM Container_Type__c WHERE Name IN: nameConteinerType];
        List<String> idOppo = new List<String>();
        try{
            for(wrapperProduct product : wrapperProduct){
                Customer_Quote__c iEQO = new Customer_Quote__c();
        		Sourcing_Item__c item = new Sourcing_Item__c();
                product = grupo(product);
                iEQO = creaIEQO(product, recordTypeUnidad.Id,location,container);
                creaIEQO.add(iEQO);
                if(product.extencionItemName != '' && product.extencionItemName != null && product.extencionItemName != 'na'){
                    item = creaItem(product.extencionItemName, product.idAccount, product.currencyIsoCode);
                    creaItem.add(item);
                }
                idOppo.add(product.idOpportunity);
            }
            insert creaIEQO;
            System.debug('el IEQO creado: '+creaIEQO);
            List<Customer_Quote__c> IEQO = [SELECT Name, Route__c, Container_Type__c FROM Customer_Quote__c WHERE Id IN: creaIEQO];
            Integer posicion = 0;
            for(wrapperProduct product : wrapperProduct){
                Fee__c serviceRate = new Fee__c();
                product = rellenaWrapper(IEQO[posicion], product);
                serviceRate = CreateServiceRate(product,sapServiceType,'SERVICIOS LOGISTICOS');
                createServiceRate.add(serviceRate);
                posicion++;
            }
            insert createServiceRate;
            System.debug('el Rate creado'+CreateServiceRate);
            Integer posicionRate = 0;
            for(wrapperProduct product : wrapperProduct){
                Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
                serviceLine = CreateServiceLine(CreateServiceRate[posicionRate].Id, product,001);
                CreateServiceLine.add(serviceLine);
                posicionRate++;
            }
            Insert CreateServiceLine;
            System.debug('el service Line creado: '+CreateServiceLine);
            if(creaItem.size() != null){
	            insert creaItem;
                System.debug('el item creado'+creaItem);
                Integer posicionItem = 0;
                for(wrapperProduct product : wrapperProduct){
                    Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
                	if(product.extencionItemName != '' && product.extencionItemName != null && product.extencionItemName != 'na'){
                        cargoLine = createCargoLine(creaItem[posicionItem].id,product,claveServicio);
                        createCargoLine.add(cargoLine);
                        posicionItem++;
                    }
                }
            	insert createCargoLine;
                System.debug('el Cargo Line creado: '+createCargoLine);
                mensaje ='Los folios fueron creados correctamente';
            }else{
                mensaje ='Los folios se crearon sin cargo line';
            }
            List<subProducto__c> subProducto = [SELECT SubProduct_Opportunity_Product__c, SubProduct_SAP_Service_Type__c,
                                                SubProduct_Buy_Price__c, SubProduct_Buy_Price_Converted__c,
                                                SubProduct_Sell_Price__c, SubProduct_Sell_Price_Converted__c,CurrencyIsoCode
                                                FROM subProducto__c WHERE SubProduct_Opportunity_Product__c IN: IdProducto];
            if(subProducto.size() != null){
                for(wrapperProduct product : wrapperProduct){
                    for(subProducto__c sub : subProducto){
                        if(sub.SubProduct_Opportunity_Product__c == product.id){
                            subProdu.add(wrapperSubProductos(product,sub));
                        }
                    }
                }
                System.debug('el subproducto es: ' +subProdu);
                List<Fee__c> createServiceRateSub = new List<Fee__c>();
                List<Import_Export_Fee_Line__c> createServiceLineSub = new List<Import_Export_Fee_Line__c>();
                for(wrapperProduct subPro : subProdu){
                    Fee__c serviceRateSub = new Fee__c();
                	serviceRateSub = CreateServiceRate(subPro,sapServiceType,'CARGOS ADICIONALES SERVICIOS');
                    createServiceRateSub.add(serviceRateSub);
                }
                insert createServiceRateSub;
                System.debug('el ServiceRateSub es: ' +createServiceRateSub.size()+' '+createServiceRateSub);
                Integer posicionSub = 0;
                Integer nameLine = 002;
                for(wrapperProduct product : wrapperProduct){
                    for(wrapperProduct subP : subProdu){
                        if(product.id == subP.Id){
                			Import_Export_Fee_Line__c serviceLineSub = new Import_Export_Fee_Line__c();
                            System.debug('el idproducto es: ' +product.id+' el idsub es: '+subP.Id);
                            subP.idQuote = product.idQuote;
                            serviceLineSub = CreateServiceLine(createServiceRateSub[posicionSub].Id, subP,nameLine);
                            CreateServiceLineSub.add(serviceLineSub);
                            posicionSub++;
                            nameLine++;
                        }
                    }
                }
                insert CreateServiceLineSub;
            }
            Opportunity oppo =[SELECT id, Name, Total_IEQO_Creados__c FROM Opportunity WHERE id IN: idOppo LIMIT 1];
                Integer totalI = IEQO.size();
                oppo.Total_IEQO_Creados__c = totalI;
            update oppo;
            return mensaje;
        }
        catch(Exception e){
            System.debug('Error al crear IEQO en la clase p2G_FoliosEnOportunidades'+e.getMessage()+e.getLineNumber());
            return mensaje = 'Error al crear IEQO en la clase p2G_FoliosEnOportunidades'+e.getMessage()+e.getLineNumber();
        }
    }
    public static wrapperProduct rellenaWrapper(Customer_Quote__c quote,wrapperProduct product){
            product.idQuote = quote.Id;
            product.nameQuote = quote.Name;
            product.idRoute = quote.Route__c;
            product.idConteinerType = quote.Container_Type__c;
        return product;
    }
    public static wrapperProduct grupo(wrapperProduct product){
        System.debug('el grupo es: '+product.grupo);
        switch on product.grupo {
            when 'SP-FN-FLETE NACIONAL' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Road';
                product.serviceMode = 'NATIONAL';
                product.servicetype = 'FTL';
            }	
            when 'SP-FI-FLETE INTER' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Road';
                product.serviceMode = 'IMPORT';// dato no fijo
                product.servicetype = 'FTL';
                product.border = 'Norte'; // dato no fijo
                product.customs = 'Agua Prieta'; // dato no fijo
            }
            when 'SP-A-AEREO' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Air';
                product.serviceMode = 'IMPORT';// dato no fijo
                product.servicetype = 'CARGA';//fijo
                product.border = 'Norte'; // dato no fijo
                product.customs = 'Agua Prieta'; // dato no fijo
            }
            when 'SP-CE-COMERCIO EXT' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'Si';
                product.freighMode = 'Air';
                product.serviceMode = 'IMPORT';// dato no fijo
                product.servicetype = 'CARGA';//fijo
                product.border = 'Norte'; // dato no fijo
                product.customs = 'Agua Prieta'; // dato no fijo
                product.impak = 'Si';// dato no fijo
                product.servicioIMPAK ='A';// dato no fijo
                product.salesIncoterm = 'CFR';// dato no fijo
            }
            when 'SP-M-MARITIMO' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Sea';
                product.serviceMode = 'IMPORT';// dato no fijo
                product.servicetype = 'LCL';// dato no fijo
                product.border = 'Norte'; // dato no fijo
                product.customs = 'Agua Prieta'; // dato no fijo
            }
            when 'SP-PTO-PUERTOS' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Road';
                product.serviceMode = 'PORT';
                product.servicetype = 'FTL';// dato no fijo
            }
            when 'SP-R-GLOBAL ROUTING' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'WCA';
                product.comercioExterior = 'No';
                product.freighMode = 'Sea';
                product.serviceMode = 'IMPORT';// dato no fijo
                product.servicetype = 'FCL';// dato no fijo
            }
            when 'SP-EX-SEGUROS' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Road';
                product.serviceMode = 'NATIONAL';
                product.servicetype = 'Extras';
            }
            when 'SP-PQ-PAQUETERIA' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Road';
                product.serviceMode = 'NATIONAL';
                product.servicetype = 'MAYOREO';
            }
            when 'SP-WH-ALMACENAJE' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Road';
                product.warehouseService = true;
            }
            when 'SP-T-CONSOLIDADO' {
                product.quotationStatus = 'Sent awaiting response';
                product.CommunityStatus = 'CUSTOMER CREATED';
                product.team = 'P2G';
                product.comercioExterior = 'No';
                product.freighMode = 'Road';
                product.serviceMode = 'NATIONAL';
                product.servicetype = 'TARIMAS';
            }
            when else {
                System.debug('No hay grupo');
            }
		}
        return product;
    }
    public static Customer_Quote__c creaIEQO(wrapperProduct product, String recordTypeUnidad, List<Location__c> location, List<Container_Type__c> container){
        Customer_Quote__c quote = new Customer_Quote__c();
        System.debug('Lo que llega creaIEQO: '+product);
            String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
            quote.RecordTypeId = recordTypeId;
            quote.Clave_de_Unidad_de_Peso__c = recordTypeUnidad;
            quote.Name='.';
            quote.Account_for__c = product.idAccount;
            quote.Team__c = product.team;
            quote.Quotation_Status__c = product.quotationStatus;
            quote.clave_de_lead__c = 'Cotizado desde Oportunidad Nuevos Negocion';
            quote.Opportunity__c = product.idOpportunity;
            quote.Valid_From__c = system.today();
            quote.Valid_Until__c = system.today();
            quote.ETD__c = system.today();
            quote.ETA__c = system.today()+2;
            quote.Awaiting_load_time__c = Time.newInstance( 08,00,0,0);
            quote.Awaiting_unload_time__c = Time.newInstance(18,00,0,0);
            quote.Pricing_Executive__c = UserInfo.getUserId();
            quote.Community_Status__c = product.CommunityStatus;
            quote.Comercio_Exterior__c = product.comercioExterior;
            quote.Freight_Mode__c = product.freighMode;
            quote.Service_Mode__c = product.serviceMode;
            quote.Service_Type__c = product.servicetype;
            quote.CurrencyIsoCode = product.currencyIsoCode;
        	for(Location__c loc : location){
                if(loc.Id == product.loadSite){
                    quote.Country_ofLoad__c = loc.Country__c;
                    quote.State_of_Load__c = loc.State__c;
                    quote.Site_of_Load__c = loc.Id;
                }
                if(loc.Id == product.dischargeSite){
                    quote.Country_ofDischarge__c = loc.Country__c;
                    quote.State_of_Discharge__c = loc.State__c;
                    quote.Site_of_Discharge__c = loc.Id;
                }
            }
            for(Container_Type__c cont : container){
                if(cont.Name == product.nameConteinerType){
                    quote.Container_Type__c = cont.Id;
                }
            }
            if(product.border != '' && product.border != null){
	            quote.Border__c = product.border;
            }
            if(product.customs != '' && product.customs != null){
	            quote.Customs__c = product.customs;
            }
            if(product.impak != '' && product.impak != null){
	            quote.IMPAK__c = product.impak;
            }
            if(product.servicioIMPAK != '' && product.servicioIMPAK != null){
	            quote.CE_Tipodeservicio_IMPAK__c = product.servicioIMPAK;
            }
            if(product.salesIncoterm != '' && product.salesIncoterm != null){
	            quote.Sales_Incoterm__c = product.salesIncoterm;
            }
        	if(product.warehouseService != null){
            	quote.Only_Warehouse_Service__c = product.warehouseService;
            }
            return quote;
        
    }
    public static Fee__c CreateServiceRate(wrapperProduct product, List<SAP_Service_Type__c> sapServiceType, String nameSST){
            System.debug('Service type: '+sapServiceType);
            System.debug('El grupo es: '+product.grupo);
        String recordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c serviceRate = new Fee__c();
            serviceRate.RecordTypeId = recordTypeId;
        if(nameSST == 'CARGOS ADICIONALES SERVICIOS'){
            serviceRate.Name = nameSST;
        }else{
            serviceRate.Name = 'Flete '+ product.serviceMode;
        }
            serviceRate.Route__c = product.idRoute; 
            serviceRate.CurrencyIsoCode = product.currencyLine; 
            serviceRate.Fee_Category__c = 'Road Freights'; //buscar
            serviceRate.Group__c = product.grupo; 
            serviceRate.Container_Type__c = product.idConteinerType;
            serviceRate.TT_Days__c = '1';
            serviceRate.Rate_Type__c = 'Fixed';
            serviceRate.Account_for__c = product.idAccount;
            serviceRate.Active__c=true;
            serviceRate.Fee_Rate__c = product.sellPrice;
            serviceRate.Buy_Rate__c = product.buyPrice;
            if(product.idSST != null && product.idSST != ''){
                serviceRate.SAP_Service_Type__c = product.idSST;
            }else{
                if(product.grupo == 'SP-PQ-PAQUETERIA'){
                    for(SAP_Service_Type__c sST : sapServiceType){
                        if(sST.Name == 'PREPAGO GLOBAL PAQUETERIAS (IC)(PQ)'){
                            serviceRate.SAP_Service_Type__c = sST.Id;
                        }
                    }
            		serviceRate.Name = 'Flete Paqueteria';
                }else if(product.grupo == 'SP-WH-ALMACENAJE'){
                    for(SAP_Service_Type__c sST : sapServiceType){
                        if(sST.Name == 'SERVICIOS DE ALMACENAJE (IC) (WH)'){
                            serviceRate.SAP_Service_Type__c = sST.Id;
                        }
                    }
            		serviceRate.Name = 'Flete Almacenaje';
                }else if(product.grupo == 'SP-T-CONSOLIDADO'){
                    for(SAP_Service_Type__c sST : sapServiceType){
                        if(sST.Name.contains('SERVICIO LOGISTICO')){
                            serviceRate.SAP_Service_Type__c = sST.Id;
                        }
                    }
            		serviceRate.Name = 'Flete Tarimas';
                }else{
                    for(SAP_Service_Type__c sST : sapServiceType){
                        if(sST.Name.contains(nameSST)){
                            serviceRate.SAP_Service_Type__c = sST.Id;
                        }
                    }
                }
            }
        System.debug('-----'+serviceRate.SAP_Service_Type__c);
        
        
        return serviceRate; 
    }
    public static Import_Export_Fee_Line__c CreateServiceLine(String idService, wrapperProduct product, Integer Name){
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
            serviceLine.Import_Export_Quote__c = product.idQuote;
            serviceLine.Name = '00'+String.ValueOF(Name);
            serviceLine.Units__c = 1;
            serviceLine.CurrencyIsoCode	= product.currencyLine;
            serviceLine.Service_Rate_Name__c = idService;
            serviceLine.Quote_Sell_Price__c = product.sellPrice;
            serviceLine.Quote_Buy_Price__c = product.buyPrice;
        return serviceLine;
    }
    public static Sourcing_Item__c creaItem(string name, string account, string divisa){
        Sourcing_Item__c item = new Sourcing_Item__c();
        item.Name = name;
        item.Account_Owner__c = account;
        item.CurrencyIsoCode = divisa;
        return item;
    }
    public static Quote_Item_Line__c createCargoLine(String item, wrapperProduct cargo, List<Catalogo_SAT__c> claveServicio){
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
            cargoLine.Import_Export_Quote__c=cargo.idQuote;
            cargoLine.Name='001';
            cargoLine.Item_Name__c=item;
            cargoLine.Container_Type__c=cargo.idConteinerType;
            cargoLine.Extension_Item_Name__c=cargo.extencionItemName;
            cargoLine.CurrencyIsoCode=cargo.currencyIsoCode;
            cargoLine.Conversion_Rate_to_Currency_Header__c=1;
            cargoLine.Units__c= cargo.units;
            cargoLine.Total_Shipping_Weight_Kgs__c=cargo.pesoBruto; //no seguro
            cargoLine.Peso_Neto__c= 0; //preguntar
            cargoLine.Total_Shipping_Volume_m3__c=0;//preguntar
            for(Catalogo_SAT__c clave : claveServicio){
                if(clave.Name == cargo.extencionItemName){
                    cargoLine.Clave_de_Servicio__c= clave.Id;
                }
            }
        return cargoLine;
    }
    @future
    public static void crearMasFolios(String wrapperProduct){
        System.debug('el json que llega: '+wrapperProduct);
        List<wrapperProduct> listWrapper = (List<wrapperProduct>)JSON.deserialize(wrapperProduct, List<wrapperProduct>.class);
        List<Customer_Quote__c> crearFoliosFuturo = crearFoliosFuturo(listWrapper);
        enviarCorreo(crearFoliosFuturo, listWrapper[0].nameOpportunity);
    }
    public static List<Customer_Quote__c> crearFoliosFuturo(List<wrapperProduct> wrapperProduct){
        String mensaje;
        List<Customer_Quote__c> creaIEQO = new List<Customer_Quote__c>();
        List<Sourcing_Item__c> creaItem = new List<Sourcing_Item__c>();
        List<Quote_Item_Line__c> createCargoLine = new List<Quote_Item_Line__c>();
        List<Fee__c> createServiceRate = new List<Fee__c>();
        List<Import_Export_Fee_Line__c> createServiceLine = new List<Import_Export_Fee_Line__c>();
        List<wrapperProduct> subProdu = new List<wrapperProduct>();
        Set<String> idProducto = new Set<String>();
        Set<String> idLocationLoadSite = new Set<String>();
        Set<String> idLocationDischargeSite = new Set<String>();
        Set<String> nameConteinerType = new Set<String>();
        Set<String> nameClaveServicio = new Set<String>();
        for(wrapperProduct product : wrapperProduct){
            idProducto.add(product.id);
            idLocationLoadSite.add(product.loadSite);
            idLocationDischargeSite.add(product.dischargeSite);
            nameConteinerType.add(product.nameConteinerType);
            nameClaveServicio.add(product.extencionItemName);
        }
        List<SAP_Service_Type__c> sapServiceType = [SELECT Id, Name FROM SAP_Service_Type__c where Group__c =: wrapperProduct[0].grupo];
        Catalogo_SAT__c recordTypeUnidad = [SELECT 	Id, Name FROM Catalogo_SAT__c WHERE Name = 'Pallet' limit : 1];
        String recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Productos y Servicios cP').getRecordTypeId();
        List<Catalogo_SAT__c> claveServicio = [SELECT Id, Name,RecordTypeId FROM Catalogo_SAT__c 
                                         WHERE Name IN: nameClaveServicio and RecordTypeId =: recordTypeId ORDER BY CreatedDate DESC];
        List<Location__c> location = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE id IN: idLocationLoadSite OR id IN: idLocationDischargeSite];
        List<Container_Type__c> container = [SELECT Id, Name FROM Container_Type__c WHERE Name IN: nameConteinerType];
        try{
            for(wrapperProduct product : wrapperProduct){
                Customer_Quote__c iEQO = new Customer_Quote__c();
        		Sourcing_Item__c item = new Sourcing_Item__c();
                product = grupo(product);
                iEQO = creaIEQO(product, recordTypeUnidad.Id,location,container);
                creaIEQO.add(iEQO);
                if(product.extencionItemName != '' && product.extencionItemName != null && product.extencionItemName != 'na'){
                    item = creaItem(product.extencionItemName, product.idAccount, product.currencyIsoCode);
                    creaItem.add(item);
                }
            }
            insert creaIEQO;
            System.debug('el IEQO creado: '+creaIEQO);
            List<Customer_Quote__c> IEQO = [SELECT Name, Route__c, Container_Type__c FROM Customer_Quote__c WHERE Id IN: creaIEQO];
            Integer posicion = 0;
            for(wrapperProduct product : wrapperProduct){
                Fee__c serviceRate = new Fee__c();
                product = rellenaWrapper(IEQO[posicion], product);
                serviceRate = CreateServiceRate(product,sapServiceType,'SERVICIOS LOGISTICOS');
                createServiceRate.add(serviceRate);
                posicion++;
            }
            insert createServiceRate;
            System.debug('el Rate creado'+CreateServiceRate);
            Integer posicionRate = 0;
            for(wrapperProduct product : wrapperProduct){
                Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
                serviceLine = CreateServiceLine(CreateServiceRate[posicionRate].Id, product,001);
                CreateServiceLine.add(serviceLine);
                posicionRate++;
            }
            Insert CreateServiceLine;
            System.debug('el service Line creado: '+CreateServiceLine);
            if(creaItem.size() != null){
	            insert creaItem;
                System.debug('el item creado'+creaItem);
                Integer posicionItem = 0;
                for(wrapperProduct product : wrapperProduct){
                    Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
                	if(product.extencionItemName != '' && product.extencionItemName != null && product.extencionItemName != 'na'){
                        cargoLine = createCargoLine(creaItem[posicionItem].id,product,claveServicio);
                        createCargoLine.add(cargoLine);
                        posicionItem++;
                    }
                }
            	insert createCargoLine;
                System.debug('el Cargo Line creado: '+createCargoLine);
                mensaje ='Los folios fueron creados correctamente';
            }else{
                mensaje ='Los folios se crearon sin cargo line';
            }
            List<subProducto__c> subProducto = [SELECT SubProduct_Opportunity_Product__c, SubProduct_SAP_Service_Type__c,
                                                SubProduct_Buy_Price__c, SubProduct_Buy_Price_Converted__c,
                                                SubProduct_Sell_Price__c, SubProduct_Sell_Price_Converted__c, CurrencyIsoCode
                                                FROM subProducto__c WHERE SubProduct_Opportunity_Product__c IN: IdProducto];
            if(subProducto.size() != null){
                for(wrapperProduct product : wrapperProduct){
                    for(subProducto__c sub : subProducto){
                        if(sub.SubProduct_Opportunity_Product__c == product.id){
                            subProdu.add(wrapperSubProductos(product,sub));
                        }
                    }
                }
                System.debug('el subproducto es: ' +subProdu);
                List<Fee__c> createServiceRateSub = new List<Fee__c>();
                List<Import_Export_Fee_Line__c> createServiceLineSub = new List<Import_Export_Fee_Line__c>();
                for(wrapperProduct subPro : subProdu){
                    Fee__c serviceRateSub = new Fee__c();
                	serviceRateSub = CreateServiceRate(subPro,sapServiceType,'CARGOS ADICIONALES SERVICIOS');
                    createServiceRateSub.add(serviceRateSub);
                }
                insert createServiceRateSub;
                System.debug('el ServiceRateSub es: ' +createServiceRateSub.size()+' '+createServiceRateSub);
                Integer posicionSub = 0;
                Integer nameLine = 002;
                for(wrapperProduct product : wrapperProduct){
                    for(wrapperProduct subP : subProdu){
                        if(product.id == subP.Id){
                			Import_Export_Fee_Line__c serviceLineSub = new Import_Export_Fee_Line__c();
                            System.debug('el idproducto es: ' +product.id+' el idsub es: '+subP.Id);
                            subP.idQuote = product.idQuote;
                            serviceLineSub = CreateServiceLine(createServiceRateSub[posicionSub].Id, subP, nameLine);
                            CreateServiceLineSub.add(serviceLineSub);
                            posicionSub++;
                            nameLine++;
                        }
                    }
                }
                insert CreateServiceLineSub;
            }
            return creaIEQO;
        }
        catch(Exception e){
            System.debug('Error al crear IEQO en la clase p2G_FoliosEnOportunidades'+e.getMessage()+e.getLineNumber());
            return creaIEQO;
        }
    }
    public static void enviarCorreo(List<Customer_Quote__c> crearFoliosFuturo, String nameOpportunity){
        Integer numeroFolios = crearFoliosFuturo.size();
        List<Customer_Quote__c> folios = [SELECT Id, Name, Opportunity__c, CreatedBy.Email FROM Customer_Quote__c 
                                               WHERE Opportunity__c =: crearFoliosFuturo[0].Opportunity__c ORDER BY CreatedDate desc LIMIT : numeroFolios];
        String correo = folios[0].CreatedBy.Email;
        System.debug('El correo del usuario es: '+correo);
        String bodyHTML = htmlCorreo(folios, nameOpportunity);
        System.debug('El body es: '+bodyHTML);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{correo});
        email.setSubject('Folios creados desde la Oportunidad');
        email.setHtmlBody(bodyHTML);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
    public static String htmlCorreo(List<Customer_Quote__c> folios,string nameOpportunity){
        String bodyHTML ='<html><body>';
        bodyHTML += '<div class="pagina">';
        bodyHTML += '<div class="container">';
        bodyHTML += '<h1>Finalización de la creación de folios en la oportunidad</h1>';
        bodyHTML += '<p>Se crearon los siguientes folios de la oportunidad ';
        bodyHTML += '<a href="https://pak2gologistics.lightning.force.com/lightning/r/Opportunity/'+folios[0].Opportunity__c+'/view">'+nameOpportunity+'</a>';
        bodyHTML += '</p>';
        bodyHTML += '<br/>';
        bodyHTML += '<ol>';
        for(Customer_Quote__c folio : folios){
        	bodyHTML += '<li><a href="https://pak2gologistics.lightning.force.com/lightning/r/Customer_Quote__c/'+folio.Id+'/view">'+folio.Name+'</a></li>';
        }
        bodyHTML += '</ol>';
        bodyHTML += '</div>';
        bodyHTML += '</div>';
        bodyHTML += '</body></html>';
        return bodyHTML;
    }
    Public static wrapperProduct wrapperSubProductos(wrapperProduct product, subProducto__c subProductos){
        wrapperProduct sub = new wrapperProduct();
        	String[] buyConverted;
            String[] sellConverted;
            sub.id = product.Id;
        	sub.serviceMode = product.serviceMode;
            sub.idRoute = product.idRoute;
            sub.grupo = product.grupo; 
            sub.idConteinerType = product.idConteinerType;
            sub.idAccount = product.idAccount;
        System.debug('El converted buy price: '+subProductos.SubProduct_Buy_Price_Converted__c);
        if(subProductos.SubProduct_Buy_Price_Converted__c != null && subProductos.SubProduct_Buy_Price_Converted__c != ''){
            buyConverted = subProductos.SubProduct_Buy_Price_Converted__c.split(' ');
        	sub.buyPrice = Decimal.ValueOF(buyConverted[1]);
            sub.currencyLine = buyConverted[0];
        }else{
            sub.buyPrice = subProductos.SubProduct_Buy_Price__c;
            sub.currencyLine = subProductos.CurrencyIsoCode;
        }
        System.debug('El converted sell price: '+subProductos.SubProduct_Sell_Price_Converted__c);
        if(subProductos.SubProduct_Sell_Price_Converted__c != null && subProductos.SubProduct_Sell_Price_Converted__c != ''){
            sellConverted = subProductos.SubProduct_Sell_Price_Converted__c.split(' ');
        	sub.sellPrice = Decimal.ValueOF(sellConverted[1]);
        }else{
            sub.sellPrice = subProductos.SubProduct_Sell_Price__c;
        }
        if(subProductos.SubProduct_SAP_Service_Type__c != null){
            sub.idSST = subProductos.SubProduct_SAP_Service_Type__c;
        }
        return sub;
    }
}