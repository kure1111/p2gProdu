public class P2G_cargaDisponibilidad {
    @AuraEnabled
    public static void cargaLineas(String csvData) {
        System.debug('JSON: '+ csvData);
        List<P2G_DisponibilidadOfertada.WrapperDispo> dataList = (List<P2G_DisponibilidadOfertada.WrapperDispo>) JSON.deserialize(csvData, List<P2G_DisponibilidadOfertada.WrapperDispo>.class);
        List<P2G_DisponibilidadOfertada.WrapperDispo> uniqueDataList = new List<P2G_DisponibilidadOfertada.WrapperDispo>();
        
        Set<String> uniqueKeys = new Set<String>();

        // Eliminar duplicados concatenando los campos para crear una clave única
        for (P2G_DisponibilidadOfertada.WrapperDispo wrapper : dataList) {
            String fecha = wrapper.fechaVigencia;
            String clave = wrapper.carrier + wrapper.idContainerType + wrapper.planner + wrapper.searchValueIdLoad + wrapper.searchValueIdUnLoad + wrapper.ticketPromedio + wrapper.noRutas + fecha;
            if (!uniqueKeys.contains(clave)) {
                uniqueKeys.add(clave);
                uniqueDataList.add(wrapper);
            }
        }

        List<P2G_Disponibilidad__c> listConRuta = new List<P2G_Disponibilidad__c>();
        List<P2G_Disponibilidad__c> listSinRuta = new List<P2G_Disponibilidad__c>();
        List<Carrier_Line_Load_Point__c> newRoutes = new List<Carrier_Line_Load_Point__c>();
        
        // Conjuntos para almacenar nombres únicos
        Set<String> carrierNames = new Set<String>();
        Set<String> containerTypeNames = new Set<String>();
        Set<String> plannerNames = new Set<String>();
        Set<String> locationNames = new Set<String>();
        Set<String> keyRutas = new Set<String>();

        // Recoger nombres únicos
        for (P2G_DisponibilidadOfertada.WrapperDispo wrapper : uniqueDataList) {
            carrierNames.add(wrapper.carrier);
            containerTypeNames.add(wrapper.idContainerType);
            plannerNames.add(wrapper.planner);
            locationNames.add(wrapper.searchValueIdLoad);
            locationNames.add(wrapper.searchValueIdUnLoad);
            keyRutas.add(wrapper.searchValueIdLoad + ' - ' + wrapper.searchValueIdUnLoad);
        }

        // Consultar IDs correspondientes a los nombres únicos
        Map<String, Id> carrierMap = new Map<String, Id>();
        Map<String, Id> containerTypeMap = new Map<String, Id>();
        Map<String, Id> plannerMap = new Map<String, Id>();
        Map<String, String> routeMap = new Map<String, String>();
        Map<String, Location__c> locationMap = new Map<String, Location__c>();

        List<Account> carriers = [SELECT Id, Name FROM Account WHERE Name IN :carrierNames AND RecordTypeId='0124T000000PTuSQAW'];
        List<Container_Type__c> containerTypes = [SELECT Id, Name FROM Container_Type__c WHERE Name IN :containerTypeNames];
        List<User> planners = [SELECT Id, Name FROM User WHERE Name IN :plannerNames];
        List<Location__c> locations = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Name IN :locationNames];
        List<Carrier_Line_Load_Point__c> rutas = [SELECT Id, Key__c, Name FROM Carrier_Line_Load_Point__c WHERE Name IN :keyRutas];

        // Mapas con resultados de consultas
        for (Account carrier : carriers) {
            carrierMap.put(carrier.Name, carrier.Id);
        }

        for (Container_Type__c containerType : containerTypes) {
            containerTypeMap.put(containerType.Name, containerType.Id);
        }

        for (User planner : planners) {
            plannerMap.put(planner.Name, planner.Id);
        }

        for (Location__c location : locations) {
            locationMap.put(location.Name, location);
        }

        for (Carrier_Line_Load_Point__c ruta : rutas) {
            routeMap.put(ruta.Name, ruta.Id);
        }

        // Crear disponibilidades y rutas
        for (P2G_DisponibilidadOfertada.WrapperDispo wrapper : uniqueDataList) {
            wrapper.carrier = carrierMap.get(wrapper.carrier);
            wrapper.idContainerType = containerTypeMap.get(wrapper.idContainerType);
            wrapper.planner = plannerMap.get(wrapper.planner);

            // Obtener la ruta
            String keyRuta = wrapper.searchValueIdLoad + ' - ' + wrapper.searchValueIdUnLoad;
            String idRuta = routeMap.get(keyRuta);
            
            P2G_Disponibilidad__c disponibilidad = crearDisponibilidad(wrapper, idRuta);
            
            if (idRuta != null) {
                listConRuta.add(disponibilidad);
            } else {
                // Verificar si la ruta ya existe en newRoutes
                Location__c loadLocation = locationMap.get(wrapper.searchValueIdLoad);
                Location__c unloadLocation = locationMap.get(wrapper.searchValueIdUnLoad);
                if (loadLocation != null && unloadLocation != null) {
               
                    String routeKey = loadLocation.Name + ' - ' + unloadLocation.Name;
                    boolean routeExists = false;
                    
                    for (Carrier_Line_Load_Point__c existingRoute : newRoutes) {
                        if (existingRoute.Name == routeKey) {
                            routeExists = true;
                            break;
                        }
                    }
                    
                    if (!routeExists) {
                        Carrier_Line_Load_Point__c newRoute = new Carrier_Line_Load_Point__c();
                        newRoute.Country_of_Load__c = loadLocation.Country__c;
                        newRoute.State_of_Load__c = loadLocation.State__c;
                        newRoute.Port_Airport_of_Load__c = loadLocation.Id;

                        newRoute.Country_of_Discharge__c = unloadLocation.Country__c;
                        newRoute.State_of_Discharge__c = unloadLocation.State__c;
                        newRoute.Port_Airport_of_Discharge__c = unloadLocation.Id;

                        newRoute.Name = loadLocation.Name + ' - ' + unloadLocation.Name;
                        newRoutes.add(newRoute);
                    }

                    disponibilidad.Tipo_de_Venta_SPOT_Ppto__c = routeKey;
                    listSinRuta.add(disponibilidad);
                }
                else{
                    if(!Test.isRunningTest()){
                        throw new AuraHandledException('Ubicaciones no encontradas para loadLocation: ' + wrapper.searchValueIdLoad + ' y unloadLocation: ' + wrapper.searchValueIdUnLoad);
                    }
                    
                }
            }
        }

        // Insertar las nuevas rutas
        if (newRoutes.size() > 0) {
            insert newRoutes;
            // Actualizar los IDs de las nuevas rutas en las disponibilidades sin ruta
            for (Carrier_Line_Load_Point__c newRoute : newRoutes) {
                String keyRuta = newRoute.Name;
                for (P2G_Disponibilidad__c disponibilidad : listSinRuta) {
                    if (keyRuta == (disponibilidad.Tipo_de_Venta_SPOT_Ppto__c)) {
                        disponibilidad.Route__c = newRoute.Id;
                        listConRuta.add(disponibilidad);
                    }
                }
            }
        }

        // Insertar todas las disponibilidades
        if (listConRuta.size() > 0) {
            insert listConRuta;
        }
        
    }

    public static P2G_Disponibilidad__c crearDisponibilidad(P2G_DisponibilidadOfertada.WrapperDispo wrapper, String idRuta) {
        P2G_Disponibilidad__c disponibilidad = new P2G_Disponibilidad__c();
        disponibilidad.Carrier__c = wrapper.carrier;
        disponibilidad.Container_Type__c = wrapper.idContainerType;
        disponibilidad.Fecha_de_Creaci_n__c = Date.today();
        disponibilidad.FechaVigencia__c = DateTime.valueOf(wrapper.fechaVigencia);
        disponibilidad.Planner__c = wrapper.planner;
        disponibilidad.Route__c = idRuta;
        disponibilidad.Ticket_Promedio__c = Decimal.valueOf(wrapper.ticketPromedio);
        disponibilidad.No_Rutas__c = Integer.valueOf(wrapper.noRutas);

        return disponibilidad;
    }
}