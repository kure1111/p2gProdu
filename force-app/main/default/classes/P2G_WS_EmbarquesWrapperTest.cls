@isTest
public class P2G_WS_EmbarquesWrapperTest {
    @isTest
    public static void embarques(){
        P2G_WS_EmbarquesWrapper.buscaEmbarques bEmbarques = new P2G_WS_EmbarquesWrapper.buscaEmbarques();
        List<P2G_WS_EmbarquesWrapper.response> listResponse = new List<P2G_WS_EmbarquesWrapper.response>();
        P2G_WS_EmbarquesWrapper.response response = new P2G_WS_EmbarquesWrapper.response();
        response.details = new List<P2G_WS_EmbarquesWrapper.AppointmentLoadDetail>();
        P2G_WS_EmbarquesWrapper.AppointmentLoadDetail Appoin = new P2G_WS_EmbarquesWrapper.AppointmentLoadDetail();
        P2G_WS_EmbarquesWrapper.getUserToken getToken = new P2G_WS_EmbarquesWrapper.getUserToken();
        P2G_WS_EmbarquesWrapper.getUserTokenError getTokenError = new P2G_WS_EmbarquesWrapper.getUserTokenError();
        P2G_WS_EmbarquesWrapper.cargaEmbarques cargaEmbarques = new P2G_WS_EmbarquesWrapper.cargaEmbarques();
        cargaEmbarques.parameters = new List<P2G_WS_EmbarquesWrapper.Parameters>();
        P2G_WS_EmbarquesWrapper.Parameters parameter = new P2G_WS_EmbarquesWrapper.Parameters();
        parameter.truck = new P2G_WS_EmbarquesWrapper.truck();
        parameter.Driver = new P2G_WS_EmbarquesWrapper.Driver();
        parameter.source = new P2G_WS_EmbarquesWrapper.source();
        parameter.source.planning = new P2G_WS_EmbarquesWrapper.Planning();
        parameter.source.planning.plan = new List<P2G_WS_EmbarquesWrapper.Plan>();
        P2G_WS_EmbarquesWrapper.Plan plan = new P2G_WS_EmbarquesWrapper.Plan();
        plan.Code = new P2G_WS_EmbarquesWrapper.Code();
        parameter.Product = new P2G_WS_EmbarquesWrapper.Product();
        parameter.destinies = new P2G_WS_EmbarquesWrapper.Destinies();
        parameter.destinies.destiny = new List<P2G_WS_EmbarquesWrapper.Destiny>();
        P2G_WS_EmbarquesWrapper.Destiny destino = new P2G_WS_EmbarquesWrapper.Destiny();
        destino.planning = new P2G_WS_EmbarquesWrapper.Planning();
        destino.planning.plan = new List<P2G_WS_EmbarquesWrapper.Plan>();
        parameter.trailers = new P2G_WS_EmbarquesWrapper.trailers();
        parameter.Transline = new P2G_WS_EmbarquesWrapper.Transline();
        P2G_WS_EmbarquesWrapper.searchFilters searchFilters = new P2G_WS_EmbarquesWrapper.searchFilters();
        P2G_WS_EmbarquesWrapper.respuestaSearch respuestaSearch = new P2G_WS_EmbarquesWrapper.respuestaSearch();
        respuestaSearch.source = new P2G_WS_EmbarquesWrapper.SourceRes();
        respuestaSearch.destiny = new List<P2G_WS_EmbarquesWrapper.destinyRes>();
        respuestaSearch.vehicle = new P2G_WS_EmbarquesWrapper.Vehicle();
        P2G_WS_EmbarquesWrapper.destinyRes destiny = new P2G_WS_EmbarquesWrapper.destinyRes();
        respuestaSearch.tendering = new P2G_WS_EmbarquesWrapper.Tendering();
        respuestaSearch.trailer_1 = new P2G_WS_EmbarquesWrapper.Vehicle();
        respuestaSearch.trailer_2 = new P2G_WS_EmbarquesWrapper.Vehicle();
        respuestaSearch.source.track = new List<P2G_WS_EmbarquesWrapper.Track>();
        P2G_WS_EmbarquesWrapper.Track track = new P2G_WS_EmbarquesWrapper.Track();
        track.driver = new P2G_WS_EmbarquesWrapper.driverRes();
        track.carrier = new P2G_WS_EmbarquesWrapper.Carrier();
        track.vehicle = new P2G_WS_EmbarquesWrapper.Vehicle();
        track.evidence = new List<P2G_WS_EmbarquesWrapper.Evidence>();
        P2G_WS_EmbarquesWrapper.Evidence evidence = new P2G_WS_EmbarquesWrapper.Evidence();
        respuestaSearch.source.plan = new List<P2G_WS_EmbarquesWrapper.PlanRes>();
        P2G_WS_EmbarquesWrapper.PlanRes planRes= new P2G_WS_EmbarquesWrapper.PlanRes();
        planRes.carrier = new P2G_WS_EmbarquesWrapper.Carrier();
        destiny.plan = new List<P2G_WS_EmbarquesWrapper.PlanRes>();
        destiny.track = new List<P2G_WS_EmbarquesWrapper.Track>();
        P2G_WS_EmbarquesWrapper.error error = new P2G_WS_EmbarquesWrapper.error();
		error.error = new P2G_WS_EmbarquesWrapper.respuestaSearchError();
        destiny.location_equiv = new List<String>();
        respuestaSearch.source.location_equiv = new List<String>();
        destiny.Reject = new P2G_WS_EmbarquesWrapper.Reject();
        P2G_WS_EmbarquesWrapper.Requerido requerido = new P2G_WS_EmbarquesWrapper.Requerido();
        
        bEmbarques.accountOriginAddress = 'Prueba 1';
        bEmbarques.entradaCarga = 'Prueba 2';
        bEmbarques.shipment = 'Prueba 3';
        bEmbarques.idAccountOriginAddress = 'Prueba 4';
        bEmbarques.equivalenteLT = 'Prueba 5';
        bEmbarques.accountDestinationAddress = 'Prueba 6';
        bEmbarques.idAccountDestinationAddress = 'Prueba 7';
        bEmbarques.entradaDestino = 'Prueba 8';
        bEmbarques.operadorNumRcontrol = 'Prueba 9';
        bEmbarques.operadorSinRcontrol = 'Prueba 10';
        bEmbarques.unidad = 'Prueba 11';
        bEmbarques.cliente = 'Prueba 12';
        
        Appoin.appointment_load_detail_id = 13;
        Appoin.status = 'Prueba 14';
        Appoin.shipment = 'Prueba 15';
        Appoin.activityNum = 'Prueba 16';
        Appoin.error_type = 'Prueba 17';
        Appoin.error_message = 'Prueba 18';
        Appoin.field = 'Prueba 19';
        response.details.add(Appoin);
        
        getToken.userId = 20;
        getToken.companyId = 21;
        getToken.lastLogin = Datetime.valueOf('2023-05-22 04:03:34');
        getToken.locationName = 'Prueba 23';
        getToken.token = 'Prueba 24';
        getToken.created = Datetime.valueOf('2023-05-25 04:03:34');
        getToken.expires = Datetime.valueOf('2023-05-26 04:03:34');
        
        getTokenError.key = 'Prueba 27';
        getTokenError.code = 28;
        getTokenError.severity = 29;
        getTokenError.layer = 30;
        getTokenError.message = 'Prueba 31';
        getTokenError.messageArgs = 'Prueba 32';
        
        cargaEmbarques.token = 'Prueba 33';
        
        parameter.shipment = 'Prueba 34';
        parameter.type_operation = 'Prueba 35';
        parameter.type_operacion_id = 'Prueba 36';
        parameter.truck.eco = 'Prueba 37';
        parameter.truck.plate = 'Prueba 38';
        parameter.truck.type = 'Prueba 39';
        parameter.truck.type_description = 'Prueba 40';
        parameter.driver.credential = 'Prueba 41';
        parameter.driver.phone = 'Prueba 42';
        parameter.driver.aux_1 = 'Prueba 43';
        parameter.driver.aux_2 = 'Prueba 44';
        parameter.driver.aux_3 = 'Prueba 45';
        parameter.driver.email = 'Prueba 46';
        parameter.driver.fiscal_code = 'Prueba 47';
        parameter.driver.name = 'Prueba 48';
        parameter.source.aux_1 = 'Prueba 49';
        parameter.source.aux_2 = 'Prueba 50';
        parameter.source.aux_3 = 'Prueba 51';
        parameter.source.aux_4 = 'Prueba 52';
        parameter.source.aux_5 = 'Prueba 53';
        parameter.source.country_code = 'Prueba 54';
        parameter.source.muni_code = 'Prueba 55';
        parameter.source.customer_equiv = 'Prueba 56';
        parameter.source.customer_name = 'Prueba 57';
        parameter.source.latitude = 'Prueba 58';
        parameter.source.longitude = 'Prueba 59';
        parameter.source.phone = 'Prueba 60';
        parameter.source.equiv = 'Prueba 61';
        parameter.source.address = 'Prueba 62';
        parameter.source.description = 'Prueba 63';
        plan.Code.value = 'Prueba 64';
        plan.name = 'Prueba 65';
        plan.dateti = 'Prueba 66';
        parameter.source.planning.plan.add(plan);
        parameter.product.aux_1 = 'Prueba 67';
        parameter.product.aux_2 = 'Prueba 68';
        parameter.product.aux_3 = 'Prueba 69';
        parameter.product.description = 'Prueba 70';
        parameter.product.product_type = 'Prueba 71';
        parameter.product.equiv = 'Prueba 72';
        parameter.product.quantity = 73;
        parameter.product.sku = 'Prueba 74';
        parameter.product.volume = 75;
        parameter.product.weigth = 75;
        destino.aux_1 = 'Prueba 75';
        destino.aux_2 = 'Prueba 76';
        destino.aux_3 = 'Prueba 77';
        destino.aux_4 = 'Prueba 78';
        destino.aux_5 = 'Prueba 79';
        destino.chep_pallets = 'Prueba 80';
        destino.pallets_01 = 'Prueba 81';
        destino.pallets_02 = 'Prueba 82';
        destino.country_code = 'Prueba 83';
        destino.dsta_uss_external_company = 'Prueba 84';
        destino.muni_code = 'Prueba 85';
        destino.customer_equiv = 'Prueba 86';
        destino.customer_name = 'Prueba 87';
        destino.latitude = 'Prueba 88';
        destino.longitude = 'Prueba 89';
        destino.phone = 'Prueba 90';
        destino.confirmation = 'Prueba 91';
        destino.activitynum = 'Prueba 92';
        destino.equiv = 'Prueba 93';
        destino.address = 'Prueba 94';
        destino.autorized_person = 'Prueba 95';
        destino.description = 'Prueba 96';
        destino.seal_1 = 'Prueba 97';
        destino.seal_2 = 'Prueba 98';
        destino.seal_3 = 'Prueba 99';
        destino.state_code = 'Prueba 100';
        destino.sequence = 'Prueba 101';
        parameter.destinies.destiny.add(destino);
        parameter.trailers.eco = 'Prueba 102';
        parameter.trailers.plate = 'Prueba 103';
        parameter.trailers.order = 104;
        parameter.trailers.type = 'Prueba 105';
        parameter.trailers.type_description = 'Prueba 106';
        parameter.transline.equiv = 'Prueba 107';
        parameter.transline.description = 'Prueba 108';
        parameter.transline.fiscal_code = 'Prueba 109';
        cargaEmbarques.parameters.add(parameter);
        
        searchFilters.key = 'Prueba 110';
        searchFilters.company_type = 'Prueba 112';
        searchFilters.activity_num = 'Prueba 113';
        searchFilters.shipment = 'Prueba 116';
        
        respuestaSearch.stop_id = 'Prueba 140';
        respuestaSearch.shipment = 'Prueba 141';
        respuestaSearch.vehicle_type = 'Prueba 142';
        respuestaSearch.supplier_name = 'Prueba 143';
        respuestaSearch.supply_chain_id = 144;
        track.dat = 'Prueba 117';
        track.latitude = 118;
        track.longitude = 119;
        track.event_key = 'Prueba 120';
        track.driver.certified = 'Prueba 121';
        track.driver.full_name = 'Prueba 122';
        track.driver.fiscal_code = 'Prueba 123';
        track.carrier.fiscal_code = 'Prueba 124';
        track.carrier.company_name = 'Prueba 125';
        track.vehicle.eco = 'Prueba 126';
        track.vehicle.plate = 'Prueba 127';
        evidence.path = 'Prueba 128';
        evidence.type = 'Prueba 129';
        track.evidence.add(evidence);
        respuestaSearch.source.track.add(track);
        planRes.dat = '2023-01-30 04:03:34';
        planRes.event_key = 'Prueba 131';
        planRes.carrier.fiscal_code = 'Prueba 132';
        planRes.carrier.company_name = 'Prueba 133';
        respuestaSearch.source.plan.add(planRes);
        destiny.ETA = Date.valueOf('2023-01-04');
        destiny.semaphore = 'Prueba 135';
        destiny.region_name = 'Prueba 136';
        destiny.activity_num = 'Prueba 137';
        destiny.location_name = 'Prueba 138';
        destiny.location_equiv.add('Prueba 139');
        destiny.plan.add(planRes);
        destiny.track.add(track);
        destiny.Reject.type = 'Prueba 165';
        destiny.Reject.cause = 'Prueba 166';
        destiny.Reject.status = 'Prueba 167';
        destiny.orden = 168;
        destiny.dst_aux_1 = 'Prueba 169';
        respuestaSearch.destiny.add(destiny);
        respuestaSearch.vehicle.eco = 'Prueba 126';
        respuestaSearch.vehicle.plate = 'Prueba 127';
        respuestaSearch.trailer_1.eco = 'Prueba 140';
        respuestaSearch.trailer_1.plate = 'Prueba 141';
        respuestaSearch.trailer_2.eco = 'Prueba 142';
        respuestaSearch.trailer_2.plate = 'Prueba 143';
        respuestaSearch.tendering.status = 'Prueba 144';
        respuestaSearch.tendering.created = 'Prueba 145';
        respuestaSearch.tendering.finish_tendering = 'Prueba 146';
        respuestaSearch.tendering.confirmed_date = 'Prueba 147';
        respuestaSearch.PDFCartaPorte = true;
        respuestaSearch.source.region_name = 'Prueba 155';
        respuestaSearch.source.location_name = 'Prueba 156';
        respuestaSearch.source.location_equiv.add('Prueba 157');
        respuestaSearch.source.seal_1 = 'Prueba 158';
        respuestaSearch.source.seal_2 = 'Prueba 159';
        respuestaSearch.source.ori_aux_1 = 'Prueba 160';
        respuestaSearch.source.ori_aux_2 = 'Prueba 161';
        respuestaSearch.source.ori_aux_3 = 'Prueba 162';
        respuestaSearch.source.ori_aux_4 = 'Prueba 163';
        respuestaSearch.source.ori_aux_5 = 'Prueba 164';
        
        error.error.key = 'Prueba 148';
        error.error.code = 149;
        error.error.severity = 150;
        error.error.layer = 151;
        error.error.message = 'Prueba 152';
        error.error.message_args = 'Prueba 153';
        error.error.sql_state = 'Prueba 154';
        
        requerido.vehicle_NumPlacaTracto = 'Prueba 165';
        requerido.operationExecutive = 'Prueba 167';
        requerido.operator1_Name = 'Prueba 168';
        requerido.accountOriginAddress = 'Prueba 169';
        requerido.ETD = DATE.valueOf('2023-12-13');
        requerido.ETDTime = time.newInstance(08, 00, 00, 00);
        requerido.accountForCustomer_Name = 'Prueba 171';
        requerido.customerReference = 'Prueba 172';
        requerido.accountDestinationAddress = 'Prueba 173';
        requerido.ETA = DATE.valueOf('2023-12-13');
        requerido.ETATime = time.newInstance(08, 00, 00, 00);
        requerido.carrier_CustomerId = 'Prueba 175';
        requerido.shipment_Name = 'Prueba 176';
    }
}