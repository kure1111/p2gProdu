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
