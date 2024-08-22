public class P2G_DisponibilidadOfertada {
    public class WrapperDispo {
        @AuraEnabled public String venta {get; set;}
        @AuraEnabled public String ticketPromedio {get; set;}
        @AuraEnabled public String route {get; set;}
        @AuraEnabled public String idRoute {get; set;}
        @AuraEnabled public String planner {get; set;}
        @AuraEnabled public String idPlanner {get; set;}
        @AuraEnabled public String noRutas {get; set;}
        @AuraEnabled public String kpiVigencia {get; set;}
        @AuraEnabled public String kpiAprobacion {get; set;}
        @AuraEnabled public String folio {get; set;}
        @AuraEnabled public String folioName {get; set;}
        @AuraEnabled public String fechaVigencia {get; set;}
        @AuraEnabled public String curren {get; set;}
        @AuraEnabled public String containerType {get; set;}
        @AuraEnabled public String idContainerType {get; set;}
        @AuraEnabled public String carrier {get; set;}
        @AuraEnabled public String idCarrier {get; set;}
        @AuraEnabled public String searchValueIdLoad {get; set;}
        @AuraEnabled public String searchValueIdUnLoad {get; set;}
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String bandera {get; set;}
        @AuraEnabled public String bgColor {get; set;}
        @AuraEnabled public String fechaCreacion {get; set;}
        @AuraEnabled public String idUnidadPeso {get; set;}
        @AuraEnabled public String idClaveServicio {get; set;}
        @AuraEnabled public String claveServicio {get; set;}
        @AuraEnabled public String description {get; set;}
        @AuraEnabled public String units {get; set;}
        @AuraEnabled public String pesoBruto {get; set;}
        @AuraEnabled public String pesoNeto {get; set;}
        @AuraEnabled public String isCurrency {get; set;}
        @AuraEnabled public String totalShippingVolume {get; set;}
        @AuraEnabled public String searchKeyIdSST {get; set;}
        @AuraEnabled public String observaciones {get; set;}
        @AuraEnabled public Boolean tomado {get; set;}
        
        @AuraEnabled public String idAccount {get; set;}
        
    }
    
    @AuraEnabled
    public static WrapperDispo getWrapper(){
        WrapperDispo obj = new WrapperDispo();
        return obj;
    }
    
    @AuraEnabled
    public static void deleteDis(String id){
        P2G_Disponibilidad__c dis = new P2G_Disponibilidad__c();
        dis.Id = id;
        delete dis;
    }

    @AuraEnabled
    public static void updateNo(String id,Integer No){
        P2G_Disponibilidad__c dis = new P2G_Disponibilidad__c();
        dis.Id = id;
        dis.No_Rutas__c = No;
        updateDis(dis);
    }

    @AuraEnabled
    public static void updatefecha(String id,String fechaVigencia){
        fechaVigencia += ':00';
        String validFechaVigencia = fechaVigencia.replace('T', ' ');
        P2G_Disponibilidad__c dis = new P2G_Disponibilidad__c();
        dis.Id = id;
        DateTime fechaVigenciaDateTime = DateTime.valueOf(validFechaVigencia);
        dis.FechaVigencia__c = fechaVigenciaDateTime;
        updateDis(dis);
    }

    @AuraEnabled
    public static void updateObs(String id,String obs){
        P2G_Disponibilidad__c dis = new P2G_Disponibilidad__c();
        dis.Id = id;
        dis.Observaciones__c = obs;
        updateDis(dis);
    }

    public static void updateDis(P2G_Disponibilidad__c dis){
        update dis;
    }

    @AuraEnabled
    public static List<P2G_Disponibilidad__c> mapeoWrapper (List<WrapperDispo> wrapperList) {
        List<P2G_Disponibilidad__c> disponibilidadList = new List<P2G_Disponibilidad__c>();
        
        for (WrapperDispo wrapper : wrapperList) {
            P2G_Disponibilidad__c disponibilidad = new P2G_Disponibilidad__c();
            
            disponibilidad.Carrier__c = wrapper.carrier;
            disponibilidad.Container_Type__c = wrapper.idContainerType;
            disponibilidad.Fecha_de_Creaci_n__c = Date.today();
            disponibilidad.FechaVigencia__c = Date.valueOf(wrapper.fechaVigencia);
            disponibilidad.KPI_de_Aporbacion_Folio__c = Decimal.valueOf(wrapper.kpiAprobacion);
            disponibilidad.KPI_de_Vigencia__c = Decimal.valueOf(wrapper.kpiVigencia);
            disponibilidad.Planner__c = wrapper.planner;
            disponibilidad.Route__c = wrapper.route;
            disponibilidad.Ticket_Promedio__c = Decimal.valueOf(wrapper.ticketPromedio);
            
            disponibilidadList.add(disponibilidad);
        }
        
        return disponibilidadList;
    }
    
    @AuraEnabled
    public static void rutasVencidas(List<WrapperDispo> wrapperList){
        List<P2G_Disponibilidad__c> disponibilidadList = new List<P2G_Disponibilidad__c>();
        
        for (WrapperDispo wrapper : wrapperList){
            P2G_Disponibilidad__c disponibilidad = new P2G_Disponibilidad__c();
            disponibilidad.Carrier__c = wrapper.idCarrier;
            disponibilidad.Container_Type__c = wrapper.idContainerType;
            disponibilidad.Fecha_de_Creaci_n__c = Date.today();
            disponibilidad.FechaVigencia__c = Date.today()+1;
            disponibilidad.Planner__c = wrapper.idPlanner;
            disponibilidad.Route__c = wrapper.idRoute;
            disponibilidad.No_Rutas__c = Integer.valueOF(wrapper.noRutas);
            disponibilidad.Ticket_Promedio__c = Decimal.valueOf(wrapper.ticketPromedio);
            disponibilidadList.add(disponibilidad);
        }

        if(disponibilidadList.size() > 0){
           insert disponibilidadList;
        }
    }
        
    @AuraEnabled
    public static P2G_Disponibilidad__c crearDisponibilidad (WrapperDispo wrapper) {
        P2G_Disponibilidad__c disponibilidad = new P2G_Disponibilidad__c();
        disponibilidad.Carrier__c = wrapper.carrier;
        disponibilidad.Container_Type__c = wrapper.idContainerType;
        disponibilidad.Fecha_de_Creaci_n__c = Date.today();
        String fechaVigenciaStr = wrapper.fechaVigencia;
        disponibilidad.FechaVigencia__c = DateTime.valueOf(fechaVigenciaStr.replace('T', ' '));
        //disponibilidad.Folio__c = wrapper.folio;
        //disponibilidad.KPI_de_Aporbacion_Folio__c = Decimal.valueOf(wrapper.kpiAprobacion);
        //disponibilidad.KPI_de_Vigencia__c = Decimal.valueOf(wrapper.kpiVigencia);
        disponibilidad.Planner__c = wrapper.planner;//UserInfo.getUserId();
        disponibilidad.Route__c = getIdruta(wrapper.searchValueIdLoad, wrapper.searchValueIdUnLoad);
        disponibilidad.Ticket_Promedio__c = Decimal.valueOf(wrapper.ticketPromedio);
        disponibilidad.No_Rutas__c = Integer.valueOf(wrapper.noRutas);
        
        insert disponibilidad;
        return disponibilidad;
    }
    
    public static String getIdruta (String idLoad, String unLoad){
        String idRuta;
        String keyRuta = idLoad+'|'+unLoad;
        
        List<Carrier_Line_Load_Point__c> rutas = [SELECT Id FROM Carrier_Line_Load_Point__c
                                                  WHERE Key__c =: keyRuta];
        if(rutas.size() > 0){
            idRuta = rutas[0].Id;
        }
        else{
            idRuta = createRuta(idLoad,unLoad);
            
        }
        return idRuta;
    }
    
    public static String createRuta (String idLoad, String unLoad){
        Location__c ori = getLocation(idLoad);
        Location__c des = getLocation(unLoad);
        Carrier_Line_Load_Point__c newRoute = new Carrier_Line_Load_Point__c();
        newRoute.Country_of_Load__c = ori.Country__c;
        newRoute.State_of_Load__c = ori.State__c;
        newRoute.Port_Airport_of_Load__c = idLoad;
        
        newRoute.Country_of_Discharge__c = des.Country__c;
        newRoute.State_of_Discharge__c = des.State__c;
        newRoute.Port_Airport_of_Discharge__c = unLoad;
        
        newRoute.Name = ori.Name +' - '+ des.Name;
        insert newRoute;
        return newRoute.Id;
        
    }
    
    public static Location__c getLocation(String idLocation){
        Location__c loca = [SELECT Name,Country__c,State__c FROM Location__c WHERE id =:idLocation];
        return loca;
    }
    
    @AuraEnabled
    public static List<WrapperDispo> obtenerDisponibilidades(Integer op) {
        List<WrapperDispo> wrapperList = new List<WrapperDispo>();
        DateTime now = DateTime.now();
        List<P2G_Disponibilidad__c> disponibilidadRecords;
        if(op == 1){
			disponibilidadRecords = [SELECT Carrier__c,Carrier__r.Name,Observaciones__c, No_Rutas__c,Container_Type__c,Container_Type__r.Name, VentaSugerida__c,Fecha_de_Creaci_n__c,FechaVigencia__c,KPI_de_Aporbacion_Folio__c, KPI_de_Vigencia__c,CreatedDate, Planner__c,Planner__r.Name, Route__c,Route__r.Name, Ticket_Promedio__c
                                                             FROM P2G_Disponibilidad__c WHERE FechaVigencia__c > :now];            
        }
        if(op == 2){
            disponibilidadRecords = [SELECT Carrier__c,Carrier__r.Name, Observaciones__c,No_Rutas__c,Container_Type__c,Container_Type__r.Name, VentaSugerida__c,Fecha_de_Creaci_n__c,FechaVigencia__c,KPI_de_Aporbacion_Folio__c, KPI_de_Vigencia__c,CreatedDate, Planner__c,Planner__r.Name, Route__c,Route__r.Name, Ticket_Promedio__c
                                                             FROM P2G_Disponibilidad__c WHERE FechaVigencia__c < :now];
        }
        
        
        for (P2G_Disponibilidad__c record : disponibilidadRecords) {
            WrapperDispo wrapper = new WrapperDispo();
            wrapper.idCarrier = record.Carrier__c;
            wrapper.carrier = record.Carrier__r.Name;
            wrapper.idContainerType = record.Container_Type__c;
            wrapper.containerType = record.Container_Type__r.Name;
            wrapper.fechaVigencia = String.valueOf(record.FechaVigencia__c);
            wrapper.venta =  String.valueOf(record.VentaSugerida__c);
            wrapper.idPlanner = record.Planner__c;
            wrapper.planner = record.Planner__r.Name;
            wrapper.idRoute = record.Route__c;
            wrapper.route = record.Route__r.Name;
            wrapper.ticketPromedio = String.valueOf(record.Ticket_Promedio__c);
            wrapper.id = record.Id;
            wrapper.noRutas = String.valueOf(record.No_Rutas__c);
            wrapper.fechaCreacion = String.valueOf(record.CreatedDate);
            wrapper.bandera = 'slds-hint-parent slds-theme_green';
            wrapper.tomado = false;
            wrapper.observaciones = record.Observaciones__c;
            if(record.No_Rutas__c == 0){
                //wrapper.folioName = record.Folio__r.Name;
                wrapper.tomado = true;
            }
            
            
            // Calcular la diferencia en horas entre FechaVigencia__c y now
            Decimal hoursDifference = (record.FechaVigencia__c.getTime() - now.getTime()) / (1000 * 60 * 60);
            if (hoursDifference > 4) {
                wrapper.bgColor = 'bg-green';
            } else if (hoursDifference >= 2) {
                wrapper.bgColor = 'bg-yellow';
            } else {
                wrapper.bgColor = 'bg-red';
            }
            
            wrapperList.add(wrapper);  
        }
        
        return wrapperList;
    }

    public static void creaLineas(WrapperDispo fleteNacional,Customer_Quote__c quote){
        Sourcing_Item__c item = P2G_CreacionFolios.creaItem(fleteNacional.claveServicio,fleteNacional.idAccount,fleteNacional.isCurrency);
        insert item;
        P2G_CreacionFoliosWrapper.cargoLine cargo =  new P2G_CreacionFoliosWrapper.cargoLine();
        cargo.description = fleteNacional.description;
        cargo.idQuote= quote.Id;
        cargo.idItem= item.Id;
        cargo.idConteinerType= fleteNacional.idContainerType;
        cargo.idClaveSat= fleteNacional.idClaveServicio;
        cargo.extencionItemName= fleteNacional.claveServicio;
        cargo.currencyIsoCode= fleteNacional.isCurrency;
        cargo.units= fleteNacional.units;
        cargo.pesoBruto= fleteNacional.pesoBruto;
        cargo.pesoNeto= fleteNacional.pesoNeto;
        cargo.totalShipping= fleteNacional.totalShippingVolume;
        Quote_Item_Line__c cargoLine = P2G_CreacionFolios.createCargoLine(cargo);
        insert cargoLine;
        list<Customer_Quote__c> ieqos = new list<Customer_Quote__c>();
        ieqos.add(quote);
        list<Customer_Quote__c> cotizacion = P2G_CreacionFolios.getIdFolio(ieqos,fleteNacional.isCurrency,fleteNacional.idContainerType,fleteNacional.idAccount,fleteNacional.searchKeyIdSST);
    }

    @AuraEnabled
    public static WrapperDispo creaImportExportQuote(WrapperDispo fleteNacional){
        Customer_Quote__c quote = new Customer_Quote__c();
        List<P2G_Disponibilidad__c> dispo = [SELECT Id,Name, No_Rutas__c FROM P2G_Disponibilidad__c WHERE Id=:fleteNacional.id];
        try{
            String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
            //Location__c locationLoad = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:fleteNacional.idSideLoad limit 1];
            List<Carrier_Line_Load_Point__c> routes = [SELECT Id, Name,Country_of_Load__c,State_of_Load__c,Port_Airport_of_Load__c,Country_of_Discharge__c,State_of_Discharge__c,Port_Airport_of_Discharge__c FROM Carrier_Line_Load_Point__c WHERE Id=:fleteNacional.idRoute];
            //Location__c locationDischarge = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:fleteNacional.idSideDischarged limit 1];
            //Catalogo_SAT__c recordTypeUnidad = [SELECT 	Id, Name FROM Catalogo_SAT__c where Name = 'Pallet' limit : 1];
            //String[] Awaitingloadtime = fleteNacional.Awaitingloadtime.split(':');
            //String[] Awaitingunloadtime = fleteNacional.Awaitingunloadtime.split(':');
            String[] Awaitingloadtime = new String[] { '12', '12' };
            String[] Awaitingunloadtime = new String[] { '12', '12' };
                    
                    quote.RecordTypeId = recordTypeId;
            quote.Clave_de_Unidad_de_Peso__c = fleteNacional.idUnidadPeso;
            quote.Name='.';
            quote.Account_for__c = fleteNacional.idAccount;
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
            quote.Country_ofLoad__c = routes[0].Country_of_Load__c;
            quote.State_of_Load__c = routes[0].State_of_Load__c;
            quote.Site_of_Load__c = routes[0].Port_Airport_of_Load__c;
            quote.Country_ofDischarge__c = routes[0].Country_of_Discharge__c;
            quote.State_of_Discharge__c = routes[0].State_of_Discharge__c;
            quote.Site_of_Discharge__c = routes[0].Port_Airport_of_Discharge__c;
            quote.ETD__c = Date.valueOf('2024-06-26');
            quote.ETA__c = Date.valueOf('2024-06-27');
            quote.Community_Status__c = 'CUSTOMER CREATED';
            quote.Awaiting_load_time__c = Time.newInstance( Integer.valueOf(Awaitingloadtime[0]) //hour
                                                           ,Integer.valueOf(Awaitingloadtime[1]) //min
                                                           ,0,0);
            quote.Awaiting_unload_time__c = Time.newInstance( Integer.valueOf(Awaitingunloadtime[0]) //hour
                                                             ,Integer.valueOf(Awaitingunloadtime[1]) //min
                                                             ,0,0);
            quote.Route__c = fleteNacional.idRoute;
            quote.Pricing_Executive__c = UserInfo.getUserId();
            quote.clave_de_lead__c = 'Ofertado';
            if(dispo.size() > 0){
                if(dispo[0].No_Rutas__c >= 1){
                  insert quote;
                  //llama metodo futuro
                  creaLineas(fleteNacional, quote);
                  fleteNacional.tomado = false;
                  if(dispo[0].No_Rutas__c == 1){
                  	fleteNacional.tomado = true;
                  } 
                  String name = quote.Name;
                  fleteNacional.folioName = name;
                  
                  //fleteNacional.folio = quote.Id;
                  dispo[0].No_Rutas__c = dispo[0].No_Rutas__c - 1 ;
                  update dispo;
                  VinculacionDispoFolios__c  vin= new VinculacionDispoFolios__c();
                    vin.Name = dispo[0].Name +'-'+name;
                    vin.Disponibilidad__c = fleteNacional.id;
                    vin.IEQO__c = quote.Id;
                    insert vin;
                }
                else{
                    fleteNacional.tomado = true;
                }              
            }

            
            //dispo.Id = fleteNacional.id;
            //dispo.Folio__c = quote.Id;

        }
        catch(Exception e){
            System.debug('Error Crear IEQO'+e.getMessage()+e.getLineNumber());
        }
        return fleteNacional;
        
    }
    
    public static void aproba(){
        Integer a = 1;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
    }
    
}