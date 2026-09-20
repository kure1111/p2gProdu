/**
 * Cotizador de costo de compra (CXP) por ruta de flete nacional.
 * Cascada de fuentes (requerimiento de negocio 2026-09-19, versión Salesforce
 * del cotizador de Excel):
 *   1. Par exacto reciente (últimos 6 meses), mínimo 3 viajes  -> mediana del buy
 *   2. Par exacto histórico (desde 2024), mínimo 2 viajes      -> mediana
 *   3. Zona metropolitana reciente, mínimo 3 viajes            -> mediana
 *   4. Zona metropolitana histórico, mínimo 2 viajes           -> mediana
 *   5. Bandas de $/km (Local <100 km usa costo completo mediano de la banda;
 *      Corta/Media/Larga usan km x $/km mediano; Global como último respaldo)
 * Reglas: medianas (anti-outliers), búsqueda BIDIRECCIONAL (ida y vuelta son
 * el mismo par), km = mediana de Kms__c de los viajes reales (el manual lo
 * sobreescribe), y trazabilidad de qué fuente se usó y con cuántos viajes.
 * Fuente de datos: Shipment__c FN con compra real (> 0), sin copiar nada.
 */
public with sharing class P2G_CotizadorCompra {

    @TestVisible private static final Integer MIN_PAR_RECIENTE   = 3;
    @TestVisible private static final Integer MIN_PAR_HISTORICO  = 2;
    @TestVisible private static final Integer MIN_ZONA_RECIENTE  = 3;
    @TestVisible private static final Integer MIN_ZONA_HISTORICO = 2;
    @TestVisible private static final Integer MESES_VENTANA_RECIENTE = 6;
    @TestVisible private static final Date INICIO_HISTORICO = Date.newInstance(2024, 1, 1);
    private static final Decimal KM_LOCAL = 100;
    private static final Decimal KM_CORTA = 300;
    private static final Decimal KM_MEDIA = 700;

    public class Resultado {
        @AuraEnabled public Decimal costo;
        @AuraEnabled public String fuente;
        @AuraEnabled public Integer viajes;
        @AuraEnabled public Decimal km;
        @AuraEnabled public Decimal costoPorKm;
    }

    private class Viaje {
        Decimal buy;
        Decimal km;
        Boolean reciente;
        Viaje(Decimal b, Decimal k, Boolean r) { buy = b; km = k; reciente = r; }
    }

    // Hooks de prueba: el campo de compra no es escribible en todos los orgs
    // (drift UAT), así que los tests inyectan los viajes en lugar de insertarlos
    @TestVisible private static List<Shipment__c> mockPar;
    @TestVisible private static List<Shipment__c> mockZona;
    @TestVisible private static List<Shipment__c> mockBanda;

    @AuraEnabled
    public static Resultado cotizar(Id origenId, Id destinoId, Decimal kmManual) {
        if (origenId == null || destinoId == null) {
            AuraHandledException ex = new AuraHandledException('Selecciona origen y destino');
            ex.setMessage('Selecciona origen y destino');
            throw ex;
        }
        DateTime corteReciente = DateTime.now().addMonths(-MESES_VENTANA_RECIENTE);

        // ---- Niveles 1-2: par exacto (bidireccional) ----
        List<Viaje> par = aViajes(consultaPar(origenId, destinoId), corteReciente);
        List<Viaje> parRecientes = filtraRecientes(par);

        // km de la ruta: manual > mediana del par reciente > mediana del par completo
        Decimal km = kmManual;
        if (km == null) { km = medianaKm(parRecientes); }
        if (km == null) { km = medianaKm(par); }

        if (parRecientes.size() >= MIN_PAR_RECIENTE) {
            return arma(medianaBuy(parRecientes), 'Par exacto reciente (' + parRecientes.size() + ' viajes, últimos ' + MESES_VENTANA_RECIENTE + ' meses)', parRecientes.size(), km);
        }
        if (par.size() >= MIN_PAR_HISTORICO) {
            return arma(medianaBuy(par), 'Par exacto histórico desde 2024 (' + par.size() + ' viajes)', par.size(), km);
        }

        // ---- Niveles 3-4: zona metropolitana ----
        Map<Id, Location__c> locs = new Map<Id, Location__c>(
            [SELECT Id, Zona_Metropolitana__c FROM Location__c WHERE Id IN (:origenId, :destinoId)]);
        Id zonaO = zonaEfectiva(locs.get(origenId), origenId);
        Id zonaD = zonaEfectiva(locs.get(destinoId), destinoId);

        List<Viaje> zona = aViajes(consultaZona(zonaO, zonaD), corteReciente);
        List<Viaje> zonaRecientes = filtraRecientes(zona);
        if (km == null) { km = medianaKm(zonaRecientes); }
        if (km == null) { km = medianaKm(zona); }

        if (zonaRecientes.size() >= MIN_ZONA_RECIENTE) {
            return arma(medianaBuy(zonaRecientes), 'Zona reciente (' + zonaRecientes.size() + ' viajes, últimos ' + MESES_VENTANA_RECIENTE + ' meses)', zonaRecientes.size(), km);
        }
        if (zona.size() >= MIN_ZONA_HISTORICO) {
            return arma(medianaBuy(zona), 'Zona histórico desde 2024 (' + zona.size() + ' viajes)', zona.size(), km);
        }

        // ---- Nivel 5: bandas de $/km sobre TODO el flete nacional reciente ----
        return cotizaPorBanda(km, corteReciente);
    }

    // La banda Local cotiza con el costo COMPLETO mediano de sus viajes (un flete
    // local no escala por km); las demás con km x $/km mediano de la banda.
    private static Resultado cotizaPorBanda(Decimal km, DateTime corteReciente) {
        List<Shipment__c> base = mockBanda != null ? mockBanda : [
            SELECT Kms__c, Total_Services_Std_Buy_Amount__c
            FROM Shipment__c
            WHERE Name LIKE 'SP-FN%'
              AND Total_Services_Std_Buy_Amount__c > 0
              AND Kms__c > 0
              AND CreatedDate >= :corteReciente
            LIMIT 40000
        ];
        if (km == null) {
            // sin km no hay banda: respaldo global (mediana de flete completo)
            List<Decimal> todos = new List<Decimal>();
            for (Shipment__c s : base) { todos.add(s.Total_Services_Std_Buy_Amount__c); }
            Decimal respaldoGlobal = mediana(todos);
            Resultado r = new Resultado();
            r.costo = respaldoGlobal;
            r.viajes = todos.size();
            r.fuente = respaldoGlobal == null
                ? 'Sin datos: no hay historial del par ni de la zona; captura los km para estimar por banda'
                : 'Global (respaldo, sin km): mediana de ' + todos.size() + ' fletes FN recientes';
            return r;
        }

        String nombreBanda = km < KM_LOCAL ? 'Local (<100 km)'
            : km < KM_CORTA ? 'Corta (100-300 km)'
            : km < KM_MEDIA ? 'Media (300-700 km)' : 'Larga (700+ km)';
        List<Decimal> costosBanda = new List<Decimal>();
        List<Decimal> porKmBanda = new List<Decimal>();
        List<Decimal> costosGlobal = new List<Decimal>();
        for (Shipment__c s : base) {
            costosGlobal.add(s.Total_Services_Std_Buy_Amount__c);
            Boolean mismaBanda = (km < KM_LOCAL && s.Kms__c < KM_LOCAL)
                || (km >= KM_LOCAL && km < KM_CORTA && s.Kms__c >= KM_LOCAL && s.Kms__c < KM_CORTA)
                || (km >= KM_CORTA && km < KM_MEDIA && s.Kms__c >= KM_CORTA && s.Kms__c < KM_MEDIA)
                || (km >= KM_MEDIA && s.Kms__c >= KM_MEDIA);
            if (mismaBanda) {
                costosBanda.add(s.Total_Services_Std_Buy_Amount__c);
                porKmBanda.add(s.Total_Services_Std_Buy_Amount__c / s.Kms__c);
            }
        }

        Resultado r = new Resultado();
        r.km = km;
        if (!costosBanda.isEmpty()) {
            r.costo = km < KM_LOCAL ? mediana(costosBanda) : (km * mediana(porKmBanda)).setScale(2);
            r.viajes = costosBanda.size();
            r.fuente = 'Estimado por banda ' + nombreBanda + ' (' + costosBanda.size() + ' fletes FN de referencia, sin historial del par)';
        } else {
            r.costo = mediana(costosGlobal);
            r.viajes = costosGlobal.size();
            r.fuente = r.costo == null
                ? 'Sin datos: no hay fletes FN recientes para estimar'
                : 'Global (respaldo): mediana de ' + costosGlobal.size() + ' fletes FN recientes (banda ' + nombreBanda + ' vacía)';
        }
        if (r.costo != null && km > 0) { r.costoPorKm = (r.costo / km).setScale(2); }
        return r;
    }

    private static List<Shipment__c> consultaPar(Id origenId, Id destinoId) {
        if (mockPar != null) { return mockPar; }
        return [
            SELECT Kms__c, Total_Services_Std_Buy_Amount__c, CreatedDate
            FROM Shipment__c
            WHERE Name LIKE 'SP-FN%'
              AND Total_Services_Std_Buy_Amount__c > 0
              AND CreatedDate >= :INICIO_HISTORICO
              AND ((Site_of_Load__c = :origenId AND Site_of_Discharge__c = :destinoId)
                OR (Site_of_Load__c = :destinoId AND Site_of_Discharge__c = :origenId))
            LIMIT 10000
        ];
    }

    // Una localidad "pertenece" a la zona si su Zona_Metropolitana__c apunta a ella
    // o si ELLA MISMA es la zona (los viajes a "ZM De Guadalajara" van directo a la zona)
    private static List<Shipment__c> consultaZona(Id zonaO, Id zonaD) {
        if (mockZona != null) { return mockZona; }
        return [
            SELECT Kms__c, Total_Services_Std_Buy_Amount__c, CreatedDate
            FROM Shipment__c
            WHERE Name LIKE 'SP-FN%'
              AND Total_Services_Std_Buy_Amount__c > 0
              AND CreatedDate >= :INICIO_HISTORICO
              AND (((Site_of_Load__c = :zonaO OR Site_of_Load__r.Zona_Metropolitana__c = :zonaO)
                    AND (Site_of_Discharge__c = :zonaD OR Site_of_Discharge__r.Zona_Metropolitana__c = :zonaD))
                OR ((Site_of_Load__c = :zonaD OR Site_of_Load__r.Zona_Metropolitana__c = :zonaD)
                    AND (Site_of_Discharge__c = :zonaO OR Site_of_Discharge__r.Zona_Metropolitana__c = :zonaO)))
            LIMIT 10000
        ];
    }

    private static Id zonaEfectiva(Location__c loc, Id fallback) {
        return (loc != null && loc.Zona_Metropolitana__c != null) ? loc.Zona_Metropolitana__c : fallback;
    }

    private static List<Viaje> aViajes(List<Shipment__c> sps, DateTime corteReciente) {
        List<Viaje> viajes = new List<Viaje>();
        for (Shipment__c s : sps) {
            viajes.add(new Viaje(s.Total_Services_Std_Buy_Amount__c, s.Kms__c, s.CreatedDate >= corteReciente));
        }
        return viajes;
    }

    private static List<Viaje> filtraRecientes(List<Viaje> viajes) {
        List<Viaje> recientes = new List<Viaje>();
        for (Viaje v : viajes) { if (v.reciente) { recientes.add(v); } }
        return recientes;
    }

    private static Resultado arma(Decimal costo, String fuente, Integer n, Decimal km) {
        Resultado r = new Resultado();
        r.costo = costo;
        r.fuente = fuente;
        r.viajes = n;
        r.km = km;
        if (costo != null && km != null && km > 0) { r.costoPorKm = (costo / km).setScale(2); }
        return r;
    }

    private static Decimal medianaBuy(List<Viaje> viajes) {
        List<Decimal> valores = new List<Decimal>();
        for (Viaje v : viajes) { valores.add(v.buy); }
        return mediana(valores);
    }

    private static Decimal medianaKm(List<Viaje> viajes) {
        List<Decimal> valores = new List<Decimal>();
        for (Viaje v : viajes) { if (v.km != null && v.km > 0) { valores.add(v.km); } }
        return mediana(valores);
    }

    @TestVisible
    private static Decimal mediana(List<Decimal> valores) {
        if (valores == null || valores.isEmpty()) { return null; }
        valores.sort();
        Integer n = valores.size();
        if (Math.mod(n, 2) == 1) { return valores[n / 2]; }
        return ((valores[n / 2 - 1] + valores[n / 2]) / 2).setScale(2);
    }
}
