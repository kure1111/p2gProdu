public class P2G_creacionFolioInternacionales {
    @AuraEnabled(cacheable=false)
    public static list<Quote_Item_Line__c> getCargoLine(String idQuote){
        List<Quote_Item_Line__c> listCargo = [SELECT Id ,CE_Descripcion_de_Producto_PAK__c,Name,Container_Type__c,Container_Type__r.Name, Clave_de_Servicio__r.Name,
                                           Extension_Item_Name__c,CurrencyIsoCode,Units__c,Total_Shipping_Weight_Kgs__c,Peso_Neto__c,Total_Shipping_Volume_m3__c,
                                           Material_Peligroso_Cat__r.Name,Embalaje_Cat__r.Name FROM Quote_Item_Line__c WHERE Import_Export_Quote__c =: idQuote];
                                           
        return listCargo;
    }
    @AuraEnabled(cacheable=false)
    public static list<Customer_Quote__c> getFolios(List<P2G_CreacionFoliosWrapper.folio> listFlete){
        Set<String> idFolios = new Set<String>();
        for(P2G_CreacionFoliosWrapper.folio folio: listFlete){
            idFolios.add(folio.id);
        }
        List<Customer_Quote__c> folios = [SELECT Id , Name, Account_for__r.Customer_Id__c FROM Customer_Quote__c WHERE Id IN: idFolios];
        System.debug('folio encontrados: '+folios);
        return folios;
    }  
    @AuraEnabled(cacheable=false)
    public static List<P2G_CreacionFoliosWrapper.folio> creaFolios(P2G_CreacionFoliosWrapper.folio flete,P2G_CreacionFoliosWrapper.cargoLine cargoLine){
        System.debug('folio que llega: '+flete);
        List<Customer_Quote__c> listFolios = new List<Customer_Quote__c>();
        List<Quote_Item_Line__c> listCargo = new List<Quote_Item_Line__c>();
        List<Sourcing_Item__c> listItem = new List<Sourcing_Item__c>();
        List<Fee__c> listServiceRate = new List<Fee__c>();
        List<Import_Export_Fee_Line__c> listServiceLine = new List<Import_Export_Fee_Line__c>();
        Location__c locLoad = new Location__c();
        Location__c locDischarged = new Location__c();
        List<P2G_CreacionFoliosWrapper.folio> listFleteCreado = new List<P2G_CreacionFoliosWrapper.folio>();
        try{
            Catalogo_SAT__c idUnidadPeso = [SELECT Id, Name FROM Catalogo_SAT__c where Name = 'Pallet' limit : 1];
            flete.recordTypeUnidad = idUnidadPeso.Id;
            List<Location__c> location = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:flete.idSideLoad OR Id=:flete.idSideDischarged];
            for(Location__c loc : location){
                if(flete.idSideLoad == loc.Id){
                    locLoad = loc;
                }
                if(flete.idSideDischarged == loc.Id){
                    locDischarged = loc;
                }
            }
            
            flete = P2G_CreacionFoliosWrapper.tipoServicio(flete);
            //Creación de folios y de item dependiendo de el numero de folios a crear
            for(Integer i = 0; i<flete.numFoliosCrear; i++){
                Customer_Quote__c creaFolios = new Customer_Quote__c();
                Sourcing_Item__c creaItem = new Sourcing_Item__c();
                creaFolios = creaImportExportQuote(flete,locLoad,locDischarged);       
                listFolios.add(creaFolios);
                creaItem = creaItemAereos(flete.idAccount, cargoLine);
                listItem.add(creaItem);
            }
            insert listFolios;
            insert listItem;
            //creacion de cargo line
            Integer posicionItem = 0;
            for(Customer_Quote__c folio: listFolios){
                Quote_Item_Line__c creaCargo = new Quote_Item_Line__c();
                cargoLine.idQuote = folio.Id;
                cargoLine.idItem = listItem[posicionItem].Id;
                creaCargo = createCargoLine(cargoLine);
                listCargo.add(creaCargo);
                posicionItem++;
            }
            insert listCargo;
            //consulta IEQO para traer la ruta y si es tarifario
            List<Customer_Quote__c> IEQO = [SELECT id, Name, Route__c, Account_for__c FROM Customer_Quote__c WHERE Id IN: listFolios];
            
                System.debug('consulta folios: '+ IEQO);
            for(Customer_Quote__c folio : IEQO){
                P2G_CreacionFoliosWrapper.folio folioList =new P2G_CreacionFoliosWrapper.folio();
                 folioList = flete;
                listFleteCreado.add(rellenaListFolio(folioList,folio));
            }
            Fee__c buscaTarifario = P2G_CreacionFolios.condicionesTarifario(IEQO[0].Account_for__c,cargoLine.idSST,flete.idConteinerType,IEQO[0].Route__c);
            if(buscaTarifario==null || buscaTarifario.Account_for__c != IEQO[0].Account_for__c){
                //crear service line
                for(Customer_Quote__c folio : IEQO){
                    Fee__c creaServiceRate = new Fee__c();
                    creaServiceRate = CreateServiceRate(folio.Route__c,cargoLine.idSST,flete);
                    listServiceRate.add(creaServiceRate);
                }
                insert listServiceRate;
                //creacion de service line
                Integer posicionFolio = 0;
                for(fee__c rate:listServiceRate){
                    Import_Export_Fee_Line__c creaServiceLine = new Import_Export_Fee_Line__c();
                    creaServiceLine = CreateServiceLine(IEQO[posicionFolio].Id,rate);
                    listServiceLine.add(creaServiceLine);
                    posicionFolio++;
                }
                Insert listServiceLine;
                //pasar al lwc que es no es un tarifario "se reutilizo la variable para no crear otra"
                listFleteCreado[0].warehouseService = false;
            }
            else{
                for(Integer i = 0; i<flete.numFoliosCrear; i++){
                    listServiceRate.add(P2G_CreacionFolios.createServiceRateTarifario(buscaTarifario));
                }
                insert listServiceRate;
                //creacion de service line
                Integer posicionFolio = 0;
                for(fee__c rate:listServiceRate){
                    Import_Export_Fee_Line__c creaServiceLine = new Import_Export_Fee_Line__c();
                    creaServiceLine = CreateServiceLine(IEQO[posicionFolio].Id,rate);
                    listServiceLine.add(creaServiceLine);
                    posicionFolio++;
                }
                Insert listServiceLine;
                //pasar al lwc que es un tarifario "se reutilizo la variable para no crear otra"
                listFleteCreado[0].warehouseService = true;
            }
            
            System.debug('la lista de folios creados: '+listFleteCreado.size()+' '+ listFleteCreado); 
            listFleteCreado[0].error='sin error'; 
        }catch(Exception e){
            flete.error='Error crea Folios: '+e.getMessage()+e.getLineNumber();
            listFleteCreado.add(flete);
            System.debug('Error crea Folios: '+e.getMessage()+e.getLineNumber());     
        } 
        return listFleteCreado;
    }
    public static Customer_Quote__c creaImportExportQuote(P2G_CreacionFoliosWrapper.folio flete,Location__c locationLoad,Location__c locationDischarge){
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        String[] Awaitingloadtime = flete.Awaitingloadtime.split(':');
        String[] Awaitingunloadtime = flete.Awaitingunloadtime.split(':');
            quote.RecordTypeId = recordTypeId;
            if(flete.recordTypeUnidad != '' && flete.recordTypeUnidad != null){
                quote.Clave_de_Unidad_de_Peso__c = flete.recordTypeUnidad;}
            quote.Name='.';
            quote.Account_for__c = flete.idAccount;
            quote.Team__c = flete.team;
            quote.Quotation_Status__c = flete.quotationStatus;
            if(flete.reference != '' && flete.reference != null){
                quote.Customer_Reference__c = flete.reference;}
            if(flete.idReferenceForm != '' && flete.idReferenceForm != null){
                quote.Customer_Reference_Form__c = flete.idReferenceForm;}
            quote.Valid_From__c = system.today();
            quote.Valid_Until__c = system.today();
            quote.Country_ofLoad__c = locationLoad.Country__c;
            quote.State_of_Load__c = locationLoad.State__c;
            quote.Site_of_Load__c = flete.idSideLoad;
            quote.Country_ofDischarge__c = locationDischarge.Country__c;
            quote.State_of_Discharge__c = locationDischarge.State__c;
            quote.Site_of_Discharge__c = flete.idSideDischarged;
            quote.ETD__c = Date.valueOf(flete.etd);
            quote.ETA__c = Date.valueOf(flete.eta);
            quote.Community_Status__c = flete.CommunityStatus;
            quote.Awaiting_load_time__c = Time.newInstance( Integer.valueOf(Awaitingloadtime[0]) //hour
                                                           ,Integer.valueOf(Awaitingloadtime[1]) //min
                                                           ,0,0);
            quote.Awaiting_unload_time__c = Time.newInstance( Integer.valueOf(Awaitingunloadtime[0]) //hour
                                                             ,Integer.valueOf(Awaitingunloadtime[1]) //min
                                                             ,0,0);
            quote.Pricing_Executive__c = UserInfo.getUserId();
            quote.Comercio_Exterior__c = flete.comercioExterior;
            quote.Freight_Mode__c = flete.freighMode;
            quote.Service_Mode__c = flete.serviceMode;
            quote.Service_Type__c = flete.servicetype;
            quote.CurrencyIsoCode = flete.currencyIsoCode;
        //para Transportes
        if(flete.idConteinerType != '' && flete.idConteinerType != null){
            quote.Container_Type__c = flete.idConteinerType;}
        //para Inter y CE
        if(flete.border != '' && flete.border != null){
            quote.Border__c = flete.border;}
        //para Inter y CE
        if(flete.customs != '' && flete.customs != null){
            quote.Customs__c = flete.customs;}
        //para CE
        if(flete.impak != '' && flete.impak != null){
            quote.IMPAK__c = flete.impak;}
        //para CE
        if(flete.servicioIMPAK != '' && flete.servicioIMPAK != null){
            quote.CE_Tipodeservicio_IMPAK__c = flete.servicioIMPAK;}
        //para CE
        if(flete.salesIncoterm != '' && flete.salesIncoterm != null){
            quote.Sales_Incoterm__c = flete.salesIncoterm;}
            return quote;
    }
    public static P2G_CreacionFoliosWrapper.folio rellenaListFolio(P2G_CreacionFoliosWrapper.folio flete,Customer_Quote__c folio){
        P2G_CreacionFoliosWrapper.folio foliocopy =new P2G_CreacionFoliosWrapper.folio();
        foliocopy.id = folio.Id;
        foliocopy.Name = folio.Name;
        foliocopy.idAccount = flete.idAccount;
        foliocopy.grupo = flete.grupo;
        foliocopy.servicetype = flete.servicetype;
        return foliocopy;
    }
    @AuraEnabled(cacheable=false)
    public static Quote_Item_Line__c crearMasCargoLine(List<P2G_CreacionFoliosWrapper.folio> listaFolio,P2G_CreacionFoliosWrapper.cargoLine cargoLine){
        List<Sourcing_Item__c> listItem = new List<Sourcing_Item__c>();
        List<Quote_Item_Line__c> listCargo = new List<Quote_Item_Line__c>();
        Quote_Item_Line__c cargoCreado = new Quote_Item_Line__c();
            System.debug('wrapper llego: '+listaFolio);  
        for(P2G_CreacionFoliosWrapper.folio folio : listaFolio){
                Sourcing_Item__c creaItem = new Sourcing_Item__c();
                creaItem = creaItemAereos(folio.idAccount, cargoLine);
                listItem.add(creaItem);
            }
            insert listItem;
            System.debug('item creado: '+listItem);  
            //creacion de cargo line
            Integer posicionItem = 0;
            for(P2G_CreacionFoliosWrapper.folio folio: listaFolio){
                Quote_Item_Line__c creaCargo = new Quote_Item_Line__c();
                cargoLine.idQuote = folio.id;
                cargoLine.idItem = listItem[posicionItem].Id;
                creaCargo = createCargoLine(cargoLine);
                listCargo.add(creaCargo);
                posicionItem++;
            }
        	if(!Test.isRunningTest()){
            	insert listCargo;
            System.debug('cargo creado: '+listCargo);  
        	cargoCreado = [SELECT Id ,CE_Descripcion_de_Producto_PAK__c,Name,Container_Type__c,Container_Type__r.Name, Clave_de_Servicio__r.Name,
                                           Extension_Item_Name__c,CurrencyIsoCode,Units__c,Total_Shipping_Weight_Kgs__c,Peso_Neto__c,Total_Shipping_Volume_m3__c,
                                           Material_Peligroso_Cat__r.Name,Embalaje_Cat__r.Name FROM Quote_Item_Line__c WHERE Id =: listCargo[0].Id Limit 1];
            }
        return cargoCreado;
    }
    public static Sourcing_Item__c creaItemAereos(string account, P2G_CreacionFoliosWrapper.cargoLine cargo){
        Sourcing_Item__c item = new Sourcing_Item__c();
        item.Name = cargo.extencionItemName;
        item.Account_Owner__c = account;
        item.CurrencyIsoCode = cargo.currencyIsoCode;
        if(cargo.length != '' && cargo.length != null){
        	item.Master_Box_Length_cm__c = Decimal.valueOf(cargo.length);
        }
        if(cargo.width != '' && cargo.width != null){
        	item.Master_Box_Width_cm__c = Decimal.valueOf(cargo.width);
        }
        if(cargo.height != '' && cargo.height != null){
        	item.Master_Box_Height_cm__c = Decimal.valueOf(cargo.height);
        }
        if(cargo.weight != '' && cargo.weight != null){
        	item.Master_Box_Packing_Weight_kg__c = Decimal.valueOf(cargo.weight);
        }
        return item;
    }
    public static Fee__c CreateServiceRate(string route,String idSST,P2G_CreacionFoliosWrapper.folio folio){
        String[] servicio = folio.grupo.split('-');
        String recordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c serviceRate = new Fee__c();
            serviceRate.RecordTypeId = recordTypeId;
            serviceRate.Name = 'Flete '+servicio[2];
            serviceRate.Route__c = route; 
            serviceRate.CurrencyIsoCode = folio.currencyIsoCode; 
            serviceRate.Fee_Category__c = 'Road Freights'; 
            serviceRate.Group__c = folio.grupo; 
            serviceRate.SAP_Service_Type__c = idSST;
            serviceRate.Container_Type__c = folio.idConteinerType;
            serviceRate.TT_Days__c = '1';
            serviceRate.Rate_Type__c = 'Fixed';
            serviceRate.Account_for__c = folio.idAccount;
            serviceRate.Active__c=true;
            if(folio.sellPrice != null && folio.sellPrice != ''){
                serviceRate.Fee_Rate__c = Decimal.valueOf(folio.sellPrice);
            }else{
                serviceRate.Fee_Rate__c = 0;
            }
        	if(folio.sellPrice != null && folio.sellPrice != ''){
                serviceRate.Buy_Rate__c = Decimal.valueOf(folio.buyPrice);
            }else{
                serviceRate.Buy_Rate__c = 0;
            }
            
        return serviceRate; 
    }
    public static Import_Export_Fee_Line__c CreateServiceLine(String idQuote,Fee__c rate){
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
            serviceLine.Import_Export_Quote__c = idQuote;
            serviceLine.Name = '001';
            serviceLine.Conversion_Rate_to_Currency_Header__c= 1;
            serviceLine.Tarifario_ServRate__c = 1;
            serviceLine.Units__c = 1;
            serviceLine.CurrencyIsoCode	= rate.CurrencyIsoCode;
            serviceLine.Service_Rate_Name__c = rate.Id;
            serviceLine.Quote_Sell_Price__c = rate.Fee_Rate__c;
            serviceLine.Quote_Buy_Price__c = rate.Buy_Rate__c;
        return serviceLine;
    }
    public static Quote_Item_Line__c createCargoLine(P2G_CreacionFoliosWrapper.cargoLine cargo){
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.CE_Descripcion_de_Producto_PAK__c=cargo.description;
        cargoLine.Import_Export_Quote__c=cargo.idQuote;
        cargoLine.Name='001';
        cargoLine.Item_Name__c=cargo.idItem;
        if(cargo.idConteinerType != '' && cargo.idConteinerType != null){
            cargoLine.Container_Type__c=cargo.idConteinerType;}
        cargoLine.Clave_de_Servicio__c=cargo.idClaveSat;
        cargoLine.Extension_Item_Name__c=cargo.extencionItemName;
        cargoLine.CurrencyIsoCode=cargo.currencyIsoCode;
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=integer.valueOf(cargo.units);
        cargoLine.Total_Shipping_Weight_Kgs__c=decimal.valueOf(cargo.pesoBruto);
        cargoLine.Peso_Neto__c=decimal.valueOf(cargo.pesoNeto);
        cargoLine.Total_Shipping_Volume_m3__c=double.valueOf(cargo.totalShipping);
        if(cargo.MaterialPeligroso != '' && cargo.MaterialPeligroso != null){
            cargoLine.Material_Peligroso_Cat__c = cargo.MaterialPeligroso;
        }
        if(cargo.Embalaje != '' && cargo.Embalaje != null){
            cargoLine.Embalaje_Cat__c = cargo.Embalaje;
        }
        if(cargo.idFraccionArancelaria != '' && cargo.idFraccionArancelaria != null){
            cargoLine.CP_Fraccion_Arancelaria_IE__c = cargo.idFraccionArancelaria;
        }
        if(cargo.pedimento != '' && cargo.pedimento != null){
            cargoLine.Pedimento__c = cargo.pedimento;
        }
        
            
        return cargoLine;
    }
}