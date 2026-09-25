/**
 * Cubre la cascada completa del cotizador: par reciente, par histórico,
 * zona, bandas de $/km y el caso sin datos.
 * Los viajes se INYECTAN por los hooks de mock construidos con JSON.deserialize:
 * el campo de compra no es escribible en todos los orgs (drift UAT) y así los
 * tests no dependen de eso. El método sin mocks cubre las queries reales.
 */
@IsTest
public class P2G_CotizadorCompraTest {

    private static Map<String, Id> armarLocalidades() {
        Country__c pais = new Country__c(Name = 'Mexico Cot', ISO_Code_2c__c = 'MC', ISO_Code__c = 'MCT');
        insert pais;
        State__c estado = new State__c(Name = 'Estado Cot', ISO_Code_2c__c = 'EC', country__c = pais.Id);
        insert estado;

        Location__c zonaGdl = new Location__c(Name = 'ZM Cot Test', state__c = estado.Id, country__c = pais.Id);
        insert zonaGdl;
        Location__c celaya = new Location__c(Name = 'Celaya Cot', state__c = estado.Id, country__c = pais.Id);
        Location__c tlaquepaque = new Location__c(Name = 'Tlaquepaque Cot', state__c = estado.Id, country__c = pais.Id,
                                                  Zona_Metropolitana__c = zonaGdl.Id);
        Location__c victoria = new Location__c(Name = 'Victoria Cot', state__c = estado.Id, country__c = pais.Id);
        insert new List<Location__c>{ celaya, tlaquepaque, victoria };

        return new Map<String, Id>{
            'zonaGdl' => zonaGdl.Id, 'celaya' => celaya.Id,
            'tlaquepaque' => tlaquepaque.Id, 'victoria' => victoria.Id
        };
    }

    // Construye un viaje EN MEMORIA con campos de solo-lectura poblados (buy, CreatedDate)
    private static Shipment__c viaje(Decimal buy, Decimal km, Integer mesesAtras) {
        DateTime fecha = DateTime.now().addMonths(-mesesAtras);
        return (Shipment__c) JSON.deserialize(
            '{"Total_Services_Std_Buy_Amount__c":' + buy + ',"Kms__c":' + km +
            ',"CreatedDate":"' + fecha.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z"}',
            Shipment__c.class);
    }

    // Versión enriquecida para explicar(): folio, dónde cargó y transportista
    private static Shipment__c viajeFull(Decimal buy, Decimal km, Integer mesesAtras, String folio, Id cargaEn, String fletera) {
        DateTime fecha = DateTime.now().addMonths(-mesesAtras);
        return (Shipment__c) JSON.deserialize(
            '{"Name":"' + folio + '","Total_Services_Std_Buy_Amount__c":' + buy + ',"Kms__c":' + km +
            ',"CreatedDate":"' + fecha.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z"' +
            ',"Site_of_Load__c":"' + cargaEn + '","Carrier__r":{"Name":"' + fletera + '"}}',
            Shipment__c.class);
    }

    @IsTest
    static void testParExactoRecienteConMediana() {
        Map<String, Id> ids = armarLocalidades();
        P2G_CotizadorCompra.mockPar = new List<Shipment__c>{
            viaje(16000, 330, 1), viaje(30000, 340, 1), viaje(17000, 335, 2)
        };

        Test.startTest();
        P2G_CotizadorCompra.Resultado r = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('tlaquepaque'), null);
        Test.stopTest();

        System.assertEquals(17000, r.costo, 'Mediana del par (el outlier de 30k no arrastra)');
        System.assert(r.fuente.contains('Par exacto reciente'), 'Fuente: ' + r.fuente);
        System.assertEquals(3, r.viajes);
        System.assertEquals(335, r.km, 'Km = mediana de los kms reales del par');
        System.assertNotEquals(null, r.costoPorKm);
        System.assertEquals('Alta', r.confianza, 'Par exacto reciente = confianza alta');
        System.assertEquals(false, r.pedirProveedor);
        System.assertEquals(15, r.margenPct);
        System.assertEquals(20000.00, r.ventaSugerida, 'Venta = costo / 0.85 (margen 15% sobre venta)');
    }

    @IsTest
    static void testParHistoricoCuandoRecienteNoAlcanza() {
        Map<String, Id> ids = armarLocalidades();
        // 1 reciente (no llega al umbral de 3) + 2 viejos = 3 del histórico
        P2G_CotizadorCompra.mockPar = new List<Shipment__c>{
            viaje(18000, 330, 1), viaje(19000, 330, 10), viaje(20000, 330, 12)
        };

        Test.startTest();
        P2G_CotizadorCompra.Resultado r = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('tlaquepaque'), null);
        Test.stopTest();

        System.assertEquals(19000, r.costo, 'Mediana de los 3 del histórico');
        System.assert(r.fuente.contains('histórico'), 'Fuente: ' + r.fuente);
        System.assertEquals('Media', r.confianza, 'Par histórico = confianza media');
        System.assertEquals(false, r.pedirProveedor);
    }

    @IsTest
    static void testZonaCuandoNoHayParExacto() {
        Map<String, Id> ids = armarLocalidades();
        P2G_CotizadorCompra.mockPar = new List<Shipment__c>();
        P2G_CotizadorCompra.mockZona = new List<Shipment__c>{
            viaje(16000, 330, 1), viaje(17000, 335, 1), viaje(18000, 340, 2)
        };

        Test.startTest();
        P2G_CotizadorCompra.Resultado r = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('tlaquepaque'), null);
        Test.stopTest();

        System.assertEquals(17000, r.costo, 'Mediana de la zona');
        System.assert(r.fuente.contains('Zona reciente'), 'Fuente: ' + r.fuente);
        System.assertEquals(335, r.km, 'Km estimado de los viajes de la zona');
        System.assertEquals('Media', r.confianza, 'Zona reciente = confianza media');
    }

    @IsTest
    static void testZonaHistorico() {
        Map<String, Id> ids = armarLocalidades();
        P2G_CotizadorCompra.mockPar = new List<Shipment__c>();
        P2G_CotizadorCompra.mockZona = new List<Shipment__c>{
            viaje(20000, 500, 10), viaje(22000, 520, 11)
        };

        Test.startTest();
        P2G_CotizadorCompra.Resultado r = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('tlaquepaque'), null);
        Test.stopTest();

        System.assertEquals(21000, r.costo);
        System.assert(r.fuente.contains('Zona histórico'), 'Fuente: ' + r.fuente);
        System.assertEquals('Baja', r.confianza, 'Zona vieja = confianza baja');
        System.assertEquals(true, r.pedirProveedor, 'Confianza baja pide confirmar con proveedor');
    }

    @IsTest
    static void testBandaPorKmSinHistorialDelPar() {
        Map<String, Id> ids = armarLocalidades();
        P2G_CotizadorCompra.mockPar = new List<Shipment__c>();
        P2G_CotizadorCompra.mockZona = new List<Shipment__c>();
        // la banda Media (300-700) se forma con 2 fletes de 330 km a $50/km
        P2G_CotizadorCompra.mockBanda = new List<Shipment__c>{
            viaje(16500, 330, 1), viaje(16500, 330, 2)
        };

        Test.startTest();
        P2G_CotizadorCompra.Resultado media = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('victoria'), 550);
        P2G_CotizadorCompra.Resultado local = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('victoria'), 50);
        P2G_CotizadorCompra.Resultado sinKm = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('victoria'), null);
        Test.stopTest();

        System.assert(media.fuente.contains('banda Media'), 'Fuente: ' + media.fuente);
        System.assertEquals(27500, media.costo, '550 km x $50/km mediano de la banda');
        System.assertEquals('Baja', media.confianza, 'Banda = confianza baja');
        System.assertEquals(true, media.pedirProveedor);
        System.assertNotEquals(null, media.ventaSugerida, 'Aun con confianza baja se sugiere venta');
        // km<100 sin fletes locales: cae al respaldo global (mediana de flete completo)
        System.assert(local.fuente.contains('Global'), 'Fuente: ' + local.fuente);
        System.assertEquals(16500, local.costo);
        // sin km ni historial del par: respaldo global sin banda
        System.assert(sinKm.fuente.contains('Global'), 'Fuente: ' + sinKm.fuente);
    }

    @IsTest
    static void testSinDatosConQueriesReales() {
        // SIN mocks: cubre las SOQL reales del par, la zona y la banda (vacías en test)
        Map<String, Id> ids = armarLocalidades();

        Test.startTest();
        P2G_CotizadorCompra.Resultado r = P2G_CotizadorCompra.cotizar(ids.get('celaya'), ids.get('victoria'), null);
        Test.stopTest();

        System.assertEquals(null, r.costo, 'Sin viajes y sin km no hay cotización');
        System.assert(r.fuente.contains('Sin datos'), 'Fuente: ' + r.fuente);
        System.assertEquals(null, r.confianza, 'Sin costo no hay confianza que reportar');
        System.assertEquals(null, r.ventaSugerida, 'Sin costo no se sugiere venta');
        System.assertEquals(true, r.pedirProveedor, 'Sin datos siempre manda a proveedor');
    }

    @IsTest
    static void testExplicarParReciente() {
        Map<String, Id> ids = armarLocalidades();
        // 2 cargan en celaya (ida) y 1 en tlaquepaque (vuelta); mediana = 17000
        P2G_CotizadorCompra.mockPar = new List<Shipment__c>{
            viajeFull(16000, 330, 1, 'SP-FN-26-000001', ids.get('celaya'), 'Fletera Uno'),
            viajeFull(18000, 340, 2, 'SP-FN-26-000002', ids.get('tlaquepaque'), 'Fletera Dos'),
            viajeFull(17000, 335, 3, 'SP-FN-26-000003', ids.get('celaya'), 'Fletera Tres')
        };
        P2G_CotizadorCompra.mockZona = new List<Shipment__c>();
        P2G_CotizadorCompra.mockBanda = new List<Shipment__c>();

        Test.startTest();
        P2G_CotizadorCompra.Explicacion ex = P2G_CotizadorCompra.explicar(ids.get('celaya'), ids.get('tlaquepaque'), null);
        Test.stopTest();

        System.assertEquals(17000, ex.resultado.costo, 'El resultado del panel es el mismo que el de cotizar');
        System.assertEquals(5, ex.niveles.size(), 'La matriz enseña los 5 escalones');
        System.assertEquals(true, ex.niveles[0].usado);
        System.assert(ex.niveles[0].veredicto.contains('USADO') && ex.niveles[0].veredicto.contains('Alta'), 'Veredicto: ' + ex.niveles[0].veredicto);
        System.assert(ex.niveles[1].veredicto.contains('no se usó'), 'El histórico alcanzaba pero no ganó: ' + ex.niveles[1].veredicto);
        System.assert(ex.niveles[2].veredicto.contains('no alcanza'), 'Zona sin viajes: ' + ex.niveles[2].veredicto);
        System.assert(ex.niveles[4].veredicto.contains('no se usó'), 'Banda no usada: ' + ex.niveles[4].veredicto);
        System.assertEquals(3, ex.muestra.size());
        System.assertEquals('SP-FN-26-000001', ex.muestra[0].folio, 'Ordenada del más barato al más caro');
        System.assertEquals(true, ex.muestra[1].esMediana, 'La mediana viene marcada');
        System.assertEquals('ida', ex.muestra[0].sentido);
        System.assertEquals(2, ex.viajesIda);
        System.assertEquals(1, ex.viajesVuelta);
        System.assertEquals(16000, ex.minimoBuy);
        System.assertEquals(18000, ex.maximoBuy);
        System.assertEquals(16000, ex.p25);
        System.assertEquals(17000, ex.p75);
        System.assert(ex.origenKm.contains('par'), 'Km del par: ' + ex.origenKm);
        System.assert(ex.viajeMasViejo <= ex.viajeMasReciente);
    }

    @IsTest
    static void testExplicarSinDatos() {
        Map<String, Id> ids = armarLocalidades();
        P2G_CotizadorCompra.mockPar = new List<Shipment__c>();
        P2G_CotizadorCompra.mockZona = new List<Shipment__c>();
        P2G_CotizadorCompra.mockBanda = new List<Shipment__c>();

        Test.startTest();
        P2G_CotizadorCompra.Explicacion ex = P2G_CotizadorCompra.explicar(ids.get('celaya'), ids.get('victoria'), null);
        Test.stopTest();

        System.assertEquals(null, ex.resultado.costo);
        System.assertEquals(true, ex.niveles[4].usado, 'Sin datos la cascada muere en la banda');
        System.assert(ex.niveles[4].veredicto.contains('sin datos'), 'Veredicto: ' + ex.niveles[4].veredicto);
        System.assertEquals(null, ex.muestra, 'Sin ruta ganadora no hay muestra');
        System.assert(ex.notaMuestra.contains('Sin viajes'), 'Nota: ' + ex.notaMuestra);
        System.assert(ex.origenKm.contains('Sin km'), 'Origen km: ' + ex.origenKm);
    }

    @IsTest
    static void testMedianaYValidacion() {
        System.assertEquals(2, P2G_CotizadorCompra.mediana(new List<Decimal>{ 3, 1, 2 }));
        System.assertEquals(2.50, P2G_CotizadorCompra.mediana(new List<Decimal>{ 1, 2, 3, 4 }));
        System.assertEquals(null, P2G_CotizadorCompra.mediana(new List<Decimal>()));
        try {
            P2G_CotizadorCompra.cotizar(null, null, null);
            System.assert(false, 'Debe rechazar sin origen/destino');
        } catch (AuraHandledException e) {
            System.assertEquals('Selecciona origen y destino', e.getMessage());
        }
    }
}
