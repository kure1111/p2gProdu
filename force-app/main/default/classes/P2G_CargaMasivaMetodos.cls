public class P2G_CargaMasivaMetodos {
    public static List<Quote_Item_Line__c> creaCargo(List<Customer_Quote__c> fleteNacional,list<P2G_CreacionFoliosWrapper.cargoLine> cargoLine){
        System.debug('folio:'+fleteNacional[0].Id+ fleteNacional.size());
        List<Quote_Item_Line__c> listaCargo = new List<Quote_Item_Line__c>();
        list<Sourcing_Item__c> listItem = new list<Sourcing_Item__c>();
        list<Import_Export_Fee_Line__c> listserviceLine= new list<Import_Export_Fee_Line__c>();
        list<Customer_Quote__c> route = [SELECT Route__c FROM Customer_Quote__c WHERE Id =: fleteNacional];
        try{ 
            Integer posicionBusca = 0;
            for(Customer_Quote__c ruta:route){
                Fee__c buscaTarifario = P2G_CreacionFolios.condicionesTarifario(fleteNacional[posicionBusca].Account_for__c,cargoLine[posicionBusca].idSST,cargoLine[posicionBusca].idConteinerType,ruta.Route__c);
            	System.debug('lista tarifaro: '+buscaTarifario);
                if(buscaTarifario==null){
                    String divisa = cargoLine[posicionBusca].currencyIsoCode;
                    String container = cargoLine[posicionBusca].idConteinerType;
                    Fee__c serviceRate = P2G_CreacionFolios.CreateServiceRate(ruta.Route__c,divisa,container,fleteNacional[posicionBusca].Account_for__c,cargoLine[posicionBusca].idSST);
                    insert serviceRate;
                    System.debug('listServiceRate'+serviceRate);
                    integer posicionItem = 0;
                        String idService = serviceRate.Id;
                        String idQuote = fleteNacional[posicionBusca].Id;
                		Decimal precio = Decimal.valueOf(cargoLine[posicionItem].itemPrice);
                        posicionItem++;
                        listserviceLine.add(P2G_CreacionFolios.CreateServiceLine(idQuote, idService,precio,1));
                    System.debug('idQuote, idService'+idQuote+ idService);
                }
                else{
                    String idService = buscaTarifario.Id;
                    Decimal feeRate = buscaTarifario.Fee_Rate__c;
                    Decimal buyRate = buscaTarifario.Buy_Rate__c;
                    String idQuote = fleteNacional[posicionBusca].Id;
                    listserviceLine.add(P2G_CreacionFolios.CreateServiceLine(idQuote, idService,feeRate,buyRate));
            	}
                posicionBusca++;
            }
                        insert listserviceLine;
            integer posicioncargo = 0;
            for(Customer_Quote__c folio:fleteNacional){
                string name = cargoLine[posicioncargo].extencionItemName;
                string divisa = cargoLine[posicioncargo].currencyIsoCode;
                string account = folio.Account_for__c;
                System.debug('folio Dentro del error::::: '+folio.Id);
                listItem.add(P2G_CreacionFolios.creaItem(name, account, divisa));
                posicioncargo ++; 
            }
            insert listItem;
            integer posicion = 0;
            for(Customer_Quote__c folio:fleteNacional){
                cargoLine[posicion].idQuote = folio.Id;
                cargoLine[posicion].idItem = listItem[posicion].Id;
                listaCargo.add(P2G_CreacionFolios.createCargoLine(cargoLine[posicion]));
                posicion ++; 
            }
            insert listaCargo;
        }
        catch(Exception e){
            listaCargo=null;
            System.debug('Error creaFolios P2G_CargaMasivaMetodos: '+e.getMessage()+e.getLineNumber());     
        }
        return listaCargo;  
    }
    public static P2G_CreacionFoliosWrapper.folioM cambioId(List<P2G_CreacionFoliosWrapper.folioMasivo> lista){
        List<String> idAccount = new List<String>();
        List<String> idReferenceForm = new List<String>();
        List<String> idSideLoad= new List<String>();
        List<String> idSideDischarge= new List<String>();
        List<String> idContainer= new List<String>();
        List<String> idClaveSat= new List<String>();
        List<String> idMaterial= new List<String>();
        List<String> idEmbalaje= new List<String>();
        List<String> idSST= new List<String>();
        List<Customer_Quote__c> listaQuote= new List<Customer_Quote__c>();
        P2G_CreacionFoliosWrapper.folioM cambio = new P2G_CreacionFoliosWrapper.folioM();
        cambio.folio = new List<Customer_Quote__c>();
        cambio.cargo = new List<P2G_CreacionFoliosWrapper.cargoLine>();
        try{
            for(P2G_CreacionFoliosWrapper.folioMasivo item: lista){
                idAccount.add(item.folio.idAccount);
                idSST.add(item.cargo.idSST);
                if(item.folio.idReferenceForm != ''){
                    idReferenceForm.add(item.folio.idReferenceForm);
                }
                idSideLoad.add(item.folio.idSideLoad); 
                idSideDischarge.add(item.folio.idSideDischarged);
                
                idContainer.add(item.cargo.idConteinerType);
                idClaveSat.add(item.cargo.extencionItemName);
                if(item.cargo.MaterialPeligroso != ''){
                    idMaterial.add(item.cargo.MaterialPeligroso);
                }
                if(item.cargo.Embalaje != ''){
                    idEmbalaje.add(item.cargo.Embalaje);
                }
            }
            List<Account> listAccount = [SELECT Id, Name,Customer_Id__c FROM Account WHERE Name IN:idAccount];
            System.debug('la lista buscada---'+listAccount);
            List<Customer_Quote__c> listReferenceForm = [SELECT Id,Name FROM Customer_Quote__c  WHERE Name IN:idReferenceForm];
            List<Location__c> listSideLoad = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE name IN:idSideLoad];
            List<Location__c> listSideDischarge = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE name =:idSideDischarge];
            //cargo
            List<Container_Type__c> listContainer = [SELECT Id, Name , Cargo_Weight_Kg__c, Cargo_Volume_m3__c FROM Container_Type__c where Name IN:idContainer];
            List<Catalogo_SAT__c> listClaveServicioProducto = [SELECT Id, Name, Clave_SAT__c FROM Catalogo_SAT__c where Name IN:idClaveSat];
            List<Catalogo_SAT__c> listMaterial = [SELECT Id, Name, Clave_SAT__c FROM Catalogo_SAT__c where Name IN:idMaterial];
            List<Catalogo_SAT__c> listEmbalaje = [SELECT Id, Name, Clave_SAT__c FROM Catalogo_SAT__c where Name IN:idEmbalaje];
            List<SAP_Service_Type__c> listaSST = [SELECT Id, Name FROM SAP_Service_Type__c WHERE Name IN:idSST];
            Catalogo_SAT__c recordTypeUnidad = [SELECT 	Id, Name FROM Catalogo_SAT__c where Name = 'Pallet' limit : 1];
            String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
            for(P2G_CreacionFoliosWrapper.folioMasivo item: lista){
                Customer_Quote__c quote = new Customer_Quote__c();
                quote = creaImportExportQuote(item.folio, recordTypeUnidad.Id,recordTypeId);
                for(Account acc:listAccount){
                    if(item.folio.idAccount==acc.Name /*&& acc.Customer_Id__c == 'aa'*/){
                        quote.Account_for__c=acc.Id;
                    }
                }
                    if(item.folio.idReferenceForm != ''){
                for(Customer_Quote__c reference:listReferenceForm){
                        if(item.folio.idReferenceForm==reference.Name){
                            quote.Customer_Reference_Form__c=reference.Id;
                        }
                    }
                }
                for(Location__c location:listSideLoad){
                    if(item.folio.idSideLoad==location.Name){
                        quote.Country_ofLoad__c = location.Country__c;
                        quote.State_of_Load__c = location.State__c;
                        quote.Site_of_Load__c = location.Id;
                    }
                }
                for(Location__c location:listSideDischarge){
                    if(item.folio.idSideDischarged==location.Name){
                        quote.Country_ofDischarge__c = location.Country__c;
                        quote.State_of_Discharge__c = location.State__c;
                        quote.Site_of_Discharge__c = location.Id;
                    }
                }
                for(Container_Type__c container:listContainer){
                    if(item.cargo.idConteinerType==container.Name){
                        item.cargo.idConteinerType=container.Id;
                    }
                }
                for(Catalogo_SAT__c producto:listClaveServicioProducto){
                    if(item.cargo.extencionItemName==producto.Name){
                        item.cargo.idClaveSat=producto.Id;
                    }
                }
                    if(item.cargo.MaterialPeligroso != ''){
                for(Catalogo_SAT__c material:listMaterial){
                        if(item.cargo.MaterialPeligroso==material.Name){
                            item.cargo.MaterialPeligroso=material.Id;
                        }
                    }
                }
                    if(item.cargo.Embalaje != ''){
                for(Catalogo_SAT__c embalaje:listEmbalaje){
                        if(item.cargo.Embalaje==embalaje.Name){
                            item.cargo.Embalaje=embalaje.Id;
                        }
                    }
                }
                for(SAP_Service_Type__c sapServiceType:listaSST){
                        if(item.cargo.idSST==sapServiceType.Name){
                            item.cargo.idSST=sapServiceType.Id;
                        }
                    }
                cambio.folio.add(quote);
                cambio.cargo.add(item.cargo);
            }
        }catch(Exception e){
            System.debug('Error P2G_CargaMasivaMetodos: '+e.getMessage()+' '+e.getLineNumber());
        }
        return cambio;
    }
    public static Customer_Quote__c creaImportExportQuote(P2G_CreacionFoliosWrapper.folio fleteNacional,String IdrecordTypeUnidad,String recordTypeId){
        Customer_Quote__c quote = new Customer_Quote__c();
        try{
            String[] Awaitingloadtime = fleteNacional.Awaitingloadtime.split(':');
            String[] Awaitingunloadtime = fleteNacional.Awaitingunloadtime.split(':');
            quote.RecordTypeId = recordTypeId;
            quote.Clave_de_Unidad_de_Peso__c = IdrecordTypeUnidad;
            quote.Name='.';
            quote.Team__c = fleteNacional.team;
            if(fleteNacional.reference != ''){
            	quote.Customer_Reference__c = fleteNacional.reference;
            }
            quote.Quotation_Status__c = fleteNacional.quotationStatus;
            quote.Valid_From__c = system.today();
            quote.Valid_Until__c = system.today();
            quote.Comercio_Exterior__c = fleteNacional.comercioExterior;
            quote.Freight_Mode__c = fleteNacional.freighMode;
            quote.Service_Mode__c = fleteNacional.serviceMode;
            quote.Service_Type__c = fleteNacional.servicetype;
            quote.CurrencyIsoCode = fleteNacional.rurrencyIsoCode;
            quote.ETD__c = Date.valueOf(fleteNacional.etd);
            quote.ETA__c = Date.valueOf(fleteNacional.eta);
            quote.Community_Status__c = fleteNacional.CommunityStatus;
            quote.Awaiting_load_time__c = Time.newInstance( Integer.valueOf(Awaitingloadtime[0]) //hour
                                                           ,Integer.valueOf(Awaitingloadtime[1]) //min
                                                           ,0,0);
            quote.Awaiting_unload_time__c = Time.newInstance( Integer.valueOf(Awaitingunloadtime[0]) //hour
                                                             ,Integer.valueOf(Awaitingunloadtime[1]) //min
                                                             ,0,0);
            quote.Pricing_Executive__c = UserInfo.getUserId();
            return quote;
        }
        catch(Exception e){
            System.debug('Error rellenar campos: P2G_CargaMasivaMetodos.creaImportExportQuote '+e.getMessage()+' '+e.getLineNumber());
            return quote;
        }     
    }
}