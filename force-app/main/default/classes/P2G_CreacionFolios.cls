public with sharing class P2G_CreacionFolios {  
    @AuraEnabled(cacheable=false)
    public static List<Customer_Quote__c> creaFolios(P2G_CreacionFoliosWrapper.folio fleteNacional,P2G_CreacionFoliosWrapper.cargoLine cargoLine){
        List<Customer_Quote__c> listaFolios = new List<Customer_Quote__c>();
        List<Quote_Item_Line__c> listaItem = new List<Quote_Item_Line__c>();
        list<Sourcing_Item__c> listItem = new list<Sourcing_Item__c>();
        list<Fee__c> listServiceRate = new list<Fee__c>();
        try{
            string name = cargoLine.extencionItemName;
            string account = fleteNacional.idAccount;
            string divisa = cargoLine.currencyIsoCode;
            for(Integer i = 0; i<fleteNacional.numFoliosCrear; i++){
                listaFolios.add(creaImportExportQuote(fleteNacional));
                listItem.add(creaItem(name, account, divisa));       
            }
            insert listaFolios;
            insert listItem;
            integer posicionItem = 0;
            if(cargoLine.idConteinerType != '' && cargoLine.idConteinerType != null){
                for(Customer_Quote__c item:listaFolios){
                    cargoLine.idQuote = item.Id;
                    cargoLine.idItem = listItem[posicionItem].Id;
                    posicionItem = posicionItem+1;
                    listaItem.add(createCargoLine(cargoLine)); 
                }
                insert listaItem;
            }
        }
        catch(Exception e){
            listaFolios=null;
            System.debug('Error creaFolios: '+e.getMessage()+e.getLineNumber());     
        }
        return listaFolios;  
    }
    
    public static Customer_Quote__c creaImportExportQuote(P2G_CreacionFoliosWrapper.folio fleteNacional){
        Customer_Quote__c quote = new Customer_Quote__c();
        System.debug('fleteNacional.idSideDischarged: '+fleteNacional.idSideDischarged);
        try{
            String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
            Location__c locationLoad = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:fleteNacional.idSideLoad limit 1];
            Location__c locationDischarge = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:fleteNacional.idSideDischarged limit 1];
            //Catalogo_SAT__c recordTypeUnidad = [SELECT 	Id, Name FROM Catalogo_SAT__c where Name = 'Pallet' limit : 1];
            String[] Awaitingloadtime = fleteNacional.Awaitingloadtime.split(':');
            String[] Awaitingunloadtime = fleteNacional.Awaitingunloadtime.split(':');
            quote.RecordTypeId = recordTypeId;
            quote.Clave_de_Unidad_de_Peso__c = fleteNacional.recordTypeUnidad;
            quote.Name='.';
            quote.Account_for__c = fleteNacional.idAccount;
            quote.Team__c = fleteNacional.team;
            quote.Quotation_Status__c = fleteNacional.quotationStatus;
            if(fleteNacional.reference != '' && fleteNacional.reference != null){
                quote.Customer_Reference__c = fleteNacional.reference;}
            if(fleteNacional.idReferenceForm != '' && fleteNacional.idReferenceForm != null){
                quote.Customer_Reference_Form__c = fleteNacional.idReferenceForm;}
            quote.Valid_From__c = system.today();
            quote.Valid_Until__c = system.today();
            //inicio FN-FLET_NACIONAL_IC
            quote.Comercio_Exterior__c = fleteNacional.comercioExterior;
            quote.Freight_Mode__c = fleteNacional.freighMode;
            quote.Service_Mode__c = fleteNacional.serviceMode;
            quote.Service_Type__c = fleteNacional.servicetype;
            quote.CurrencyIsoCode = fleteNacional.rurrencyIsoCode;
            //termino FN-FLET_NACIONAL_IC
            quote.Country_ofLoad__c = locationLoad.Country__c;
            quote.State_of_Load__c = locationLoad.State__c;
            quote.Site_of_Load__c = fleteNacional.idSideLoad;
            quote.Country_ofDischarge__c = locationDischarge.Country__c;
            quote.State_of_Discharge__c = locationDischarge.State__c;
            quote.Site_of_Discharge__c = fleteNacional.idSideDischarged;
            quote.ETD__c = Date.valueOf(fleteNacional.etd);
            quote.ETA__c = Date.valueOf(fleteNacional.eta);
            quote.Community_Status__c = fleteNacional.CommunityStatus;
            quote.Awaiting_load_time__c = Time.newInstance( Integer.valueOf(Awaitingloadtime[0]) //hour
                                                           ,Integer.valueOf(Awaitingloadtime[1]) //min
                                                           ,0,0);
            quote.Awaiting_unload_time__c = Time.newInstance( Integer.valueOf(Awaitingunloadtime[0]) //hour
                                                             ,Integer.valueOf(Awaitingunloadtime[1]) //min
                                                             ,0,0);
            if(fleteNacional.AccountOriginAddress != '' && fleteNacional.AccountOriginAddress != null){
                quote.Account_Origin_Address__c = fleteNacional.AccountOriginAddress;}
            if(fleteNacional.AccountDestinAddress != '' && fleteNacional.AccountDestinAddress != null){
                quote.Account_Destination_Address__c = fleteNacional.AccountDestinAddress;}
            quote.Pricing_Executive__c = UserInfo.getUserId();//0054T000001UCLL
            return quote;
        }
        catch(Exception e){
            System.debug('Error rellenar campos: P2G_CreacionFolios.creaImportExportQuote '+e.getMessage()+e.getLineNumber());
            return quote;
        }     
    }
    
    @AuraEnabled
    public static P2G_CreacionFoliosWrapper.folio getwrapper(){
        P2G_CreacionFoliosWrapper.folio fleteNacional = new P2G_CreacionFoliosWrapper.folio();
        fleteNacional.numFoliosCrear = 1;
        fleteNacional.comercioExterior = 'No';
        fleteNacional.freighMode = 'Road';
        fleteNacional.serviceMode = 'NATIONAL';
        fleteNacional.servicetype = 'FTL';
        fleteNacional.rurrencyIsoCode = 'MXN';
        fleteNacional.etd = '';
        fleteNacional.eta = '';
        fleteNacional.team = 'P2G';
        fleteNacional.quotationStatus = 'Quote being prepared';
        fleteNacional.CommunityStatus = 'CUSTOMER CREATED';
        fleteNacional.idSideLoad = '';
        fleteNacional.idSideDischarged = '';
        fleteNacional.idAccount = '';
        fleteNacional.Awaitingloadtime = '08:00:00.000';
        fleteNacional.Awaitingunloadtime = '18:00:00.000';
        return fleteNacional;
    }
    
    @AuraEnabled
    public static list<Customer_Quote__c> getIdFolio(List<Customer_Quote__c> listaFolio,string divisa,string idConteinerType,string account, String idSST){
        list<Customer_Quote__c> IdFolio = new list<Customer_Quote__c>();
        list<Fee__c> listServiceRate = new list<Fee__c>();
        list<Import_Export_Fee_Line__c> listserviceLine= new list<Import_Export_Fee_Line__c>();
        Customer_Quote__c idRoute = [SELECT Id, Name, Route__c FROM Customer_Quote__c WHERE Id =: listaFolio limit 1];
        Fee__c buscaTarifario = condicionesTarifario(account,idSST,idConteinerType,idRoute.Route__c);
        if(buscaTarifario==null){
            for(Customer_Quote__c IdName : [SELECT Id, Name, Route__c,Account_for__c, Account_for__r.Customer_Id__c FROM Customer_Quote__c WHERE Id =: listaFolio]){
                IdFolio.add(IdName);
                listServiceRate.add(CreateServiceRate(IdName.Route__c, divisa, idConteinerType, account,idSST));
            }
            if(idConteinerType != '' && idConteinerType != null){
                insert listServiceRate;
                integer posicionItem = 0;
                for(fee__c service:listServiceRate){
                    String idService = service.Id;
                    Decimal buyRate = service.Buy_Rate__c;
                    String idQuote = IdFolio[posicionItem].Id;
                    posicionItem = posicionItem+1;
                    listserviceLine.add(CreateServiceLine(idQuote, idService,0,buyRate)); 
                }
                insert listserviceLine;
            }
        }
        else{
            for(Customer_Quote__c IdName : [SELECT Id, Name, Route__c, Account_for__c, Account_for__r.Customer_Id__c FROM Customer_Quote__c WHERE Id =: listaFolio]){
                IdFolio.add(IdName);
            }
            if(idConteinerType != '' && idConteinerType != null){
                for(Customer_Quote__c folio:IdFolio){
                    String idService = buscaTarifario.Id;
                    Decimal feeRate = buscaTarifario.Fee_Rate__c;
                    Decimal buyRate = buscaTarifario.Buy_Rate__c;
                    String idQuote = folio.Id;
                    listserviceLine.add(CreateServiceLine(idQuote, idService,feeRate,buyRate)); 
                }
                insert listserviceLine;
            }
        }
        if(IdFolio.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return IdFolio;
    }
    
    @AuraEnabled(cacheable=false)
    public static List<Quote_Item_Line__c> creaCargoLine(List<Customer_Quote__c> listaFolio,P2G_CreacionFoliosWrapper.cargoLine cargoLine){
        List<Quote_Item_Line__c> listaItem = new List<Quote_Item_Line__c>();
        list<Customer_Quote__c> IdFolio = new list<Customer_Quote__c>();
        list<Sourcing_Item__c> listItem = new list<Sourcing_Item__c>();
        list<Import_Export_Fee_Line__c> listserviceLine= new list<Import_Export_Fee_Line__c>();
        try{
            for(Customer_Quote__c IdName : [SELECT Id, Account_for__c FROM Customer_Quote__c WHERE Id =: listaFolio]){
                IdFolio.add(IdName);}
            
            string name = cargoLine.extencionItemName;
            string account = IdFolio[0].Account_for__c;
            string divisa = cargoLine.currencyIsoCode;
            listItem.add(creaItem(name, account, divisa));
            insert listItem;
            cargoLine.idItem = listItem[0].Id;
            for(Customer_Quote__c idQuote: IdFolio){
                cargoLine.idQuote = idQuote.Id;
                listaItem.add(createCargoLine(cargoLine)); 
            }
            insert listaItem;
        }
        catch(Exception e){
            listaItem=null;
            System.debug('Error al crear Cargo Line: '+e.getMessage()+e.getLineNumber());     
        }
        return listaItem;
    }
    
    public static Fee__c CreateServiceRate(string route,string divisa,string idConteinerType,string account,String idSST){
        String recordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c serviceRate = new Fee__c();
        try{
            
            serviceRate.RecordTypeId = recordTypeId;
            serviceRate.Name = 'Flete Nacional'; //
            serviceRate.Route__c = route; 
            serviceRate.CurrencyIsoCode = divisa; 
            serviceRate.Fee_Category__c = 'Road Freights'; 
            serviceRate.Group__c = 'SP-FN-FLETE NACIONAL'; 
            serviceRate.SAP_Service_Type__c = idSST; //uate a1n0R000001lZceQAE, Prod a1n4T000001XXYCQA4
            serviceRate.Container_Type__c = idConteinerType;
            serviceRate.TT_Days__c = '1';
            serviceRate.Rate_Type__c = 'Fixed';
            serviceRate.Account_for__c = account;
            serviceRate.Active__c=true;
            serviceRate.Fee_Rate__c = 0;
            serviceRate.Buy_Rate__c = 0;
            
        }catch(Exception e){
            System.debug('Error rellenar CreateServiceRate: '+e.getMessage());
            
        }
        
        return serviceRate; 
    }
    
    public static Import_Export_Fee_Line__c CreateServiceLine(String idQuote, String idService, Decimal feeRate, Decimal buyRate){
        String x;
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = idQuote;
        serviceLine.Name = '003';
        serviceLine.Conversion_Rate_to_Currency_Header__c= integer.valueOf('1');
        serviceLine.Tarifario_ServRate__c = integer.valueOf('1');
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= 'MXN';
        serviceLine.Service_Rate_Name__c = idService;
        serviceLine.Quote_Sell_Price__c = feeRate;
        serviceLine.Quote_Buy_Price__c = buyRate;
        return serviceLine;
    }
    
    public static Quote_Item_Line__c createCargoLine(P2G_CreacionFoliosWrapper.cargoLine cargo){
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.CE_Descripcion_de_Producto_PAK__c=cargo.description;
        cargoLine.Import_Export_Quote__c=cargo.idQuote;
        cargoLine.Name='002';
        cargoLine.Item_Name__c=cargo.idItem;
        cargoLine.Container_Type__c=cargo.idConteinerType;
        cargoLine.Clave_de_Servicio__c=cargo.idClaveSat;
        cargoLine.Extension_Item_Name__c=cargo.extencionItemName;
        cargoLine.CurrencyIsoCode=cargo.currencyIsoCode;
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=integer.valueOf(cargo.units);
        cargoLine.Total_Shipping_Weight_Kgs__c=decimal.valueOf(cargo.pesoBruto);
        System.debug(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '+cargo.pesoNeto);
        cargoLine.Peso_Neto__c=decimal.valueOf(cargo.pesoNeto);
        cargoLine.Total_Shipping_Volume_m3__c=double.valueOf(cargo.totalShipping);
        if(cargo.MaterialPeligroso != '' && cargo.MaterialPeligroso != null){
            cargoLine.Material_Peligroso_Cat__c = cargo.MaterialPeligroso;
        }
        if(cargo.Embalaje != '' && cargo.Embalaje != null){
            cargoLine.Embalaje_Cat__c = cargo.Embalaje;
        }
        return cargoLine;
    }
    @AuraEnabled
    public static P2G_CreacionFoliosWrapper.cargoLine getCargoline(){
        P2G_CreacionFoliosWrapper.cargoLine cargo = new P2G_CreacionFoliosWrapper.cargoLine();
        cargo.idQuote='';
        cargo.idItem='';
        cargo.idConteinerType='';
        cargo.idClaveSat='';
        cargo.extencionItemName='papel petalooo';
        cargo.description='';
        cargo.currencyIsoCode='';
        cargo.units='';
        cargo.pesoBruto='';
        cargo.pesoNeto='';
        cargo.itemPrice='';
        cargo.totalShipping='';
        return cargo;
    }
    public static Sourcing_Item__c creaItem(string name, string account, string divisa){
        Sourcing_Item__c item = new Sourcing_Item__c();
        item.Name = name;
        item.Account_Owner__c = account;
        item.CurrencyIsoCode = divisa;
        return item;
    }
    
    @AuraEnabled
    public static Fee__c condicionesTarifario(String idAccount, String idServiceType, String idContainerType,String IdRoute){
        list<Fee__c> tarifarioExiste = new List<Fee__c>();
        list<Fee__c> tarifarioCotizador = new list<Fee__c>();
        Date fechaHoy = Date.today();
        try{
            tarifarioExiste = [SELECT Id, Account_for__c,Route__c, CustomRate__c, Valid_Until__c, Fee_Rate__c, Buy_Rate__c FROM Fee__c
                               WHERE Account_for__c =:idAccount AND Valid_Until__c>:fechaHoy AND CustomRate__c=true
                               AND SAP_Service_Type__c=:idServiceType AND Container_Type__c=:idContainerType AND Route__c=:IdRoute limit 1];
            
        }
        catch(Exception e){
            System.debug('No existe tarifario con idAccount: ');
        }
        try{
            String idCotizador=[SELECT Id, Name FROM Account Where Name = 'Cotizador' limit 1].Id;
            tarifarioCotizador = [SELECT Id, Account_for__c,Route__c, CustomRate__c, Valid_Until__c, Fee_Rate__c, Buy_Rate__c FROM Fee__c
                                  WHERE Account_for__c =:idCotizador AND Valid_Until__c>:fechaHoy AND CustomRate__c=true
                                  AND SAP_Service_Type__c=:idServiceType AND Container_Type__c=:idContainerType AND Route__c=:IdRoute limit 1];
        }
        catch(Exception e){
            System.debug('No existe tarifario con idCotizador: ');
        }
        if(tarifarioExiste.size()>0){
            System.debug('Id de service rate existente:::: '+tarifarioExiste[0].Id);
            return tarifarioExiste[0];
        }
        if(tarifarioCotizador.size()>0){
            System.debug('Id de service rate existente:::: '+tarifarioCotizador[0].Id);
            return tarifarioCotizador[0];
        }
        return null;
    }
    
}