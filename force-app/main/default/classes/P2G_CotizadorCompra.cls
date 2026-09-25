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
 *
 * Fase 2 (2026-09-23): confianza Alta/Media/Baja según el nivel de la cascada,
 * bandera pedirProveedor cuando el dato no es confiable, y venta sugerida con
 * el margen FN estándar (15% sobre venta, mismo criterio que el precio
 * sugerido de productos: Buy / 0.85). La venta es SOLO una sugerencia: el
 * humano de pricing la ajusta en pantalla y decide el precio final.
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
    // Margen FN estándar sobre venta (venta = buy / 0.85), igual que el flow
    // de precio sugerido de productos OLI
    @TestVisible private static final Decimal MARGEN_VENTA_DEFAULT = 15;

    public class Resultado {
        @AuraEnabled public Decimal costo;
        @AuraEnabled public String fuente;
        @AuraEnabled public Integer viajes;
        @AuraEnabled public Decimal km;
        @AuraEnabled public Decimal costoPorKm;
        @AuraEnabled public String confianza;       // Alta / Media / Baja segun el nivel de la cascada
        @AuraEnabled public Boolean pedirProveedor; // true = dato poco confiable, pedir precio a proveedor
        @AuraEnabled public Decimal margenPct;      // margen default con el que se sugiere la venta
        @AuraEnabled public Decimal ventaSugerida;  // costo / (1 - margen); el humano la ajusta en pantalla
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
            return arma(medianaBuy(parRecientes), 'Par exacto reciente (' + parRecientes.size() + ' viajes, últimos ' + MESES_VENTANA_RECIENTE + ' meses)', parRecientes.size(), km, 'Alta');
        }
        if (par.size() >= MIN_PAR_HISTORICO) {
            return arma(medianaBuy(par), 'Par exacto histórico desde 2024 (' + par.size() + ' viajes)', par.size(), km, 'Media');
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
            return arma(medianaBuy(zonaRecientes), 'Zona reciente (' + zonaRecientes.size() + ' viajes, últimos ' + MESES_VENTANA_RECIENTE + ' meses)', zonaRecientes.size(), km, 'Media');
        }
        if (zona.size() >= MIN_ZONA_HISTORICO) {
            return arma(medianaBuy(zona), 'Zona histórico desde 2024 (' + zona.size() + ' viajes)', zona.size(), km, 'Baja');
        }

        // ---- Nivel 5: bandas de $/km sobre TODO el flete nacional reciente ----
        return cotizaPorBanda(km, corteReciente);
    }

    // La banda Local cotiza con el costo COMPLETO mediano de sus viajes (un flete
    // local no escala por km); las demás con km x $/km mediano de la banda.
    // Cache por transacción: cotizar() y explicar() comparten esta consulta gorda
    // (dos corridas de 40k filas reventarían el límite de 50k query rows).
    private static List<Shipment__c> baseBandaCache;

    private static Resultado cotizaPorBanda(Decimal km, DateTime corteReciente) {
        if (baseBandaCache == null) {
            baseBandaCache = mockBanda != null ? mockBanda : [
                SELECT Kms__c, Total_Services_Std_Buy_Amount__c
                FROM Shipment__c
                WHERE Name LIKE 'SP-FN%'
                  AND Total_Services_Std_Buy_Amount__c > 0
                  AND Kms__c > 0
                  AND CreatedDate >= :corteReciente
                LIMIT 40000
            ];
        }
        List<Shipment__c> base = baseBandaCache;
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
            if (respaldoGlobal != null) { r.confianza = 'Baja'; }
            return finaliza(r);
        }

        String etiquetaBanda = nombreBanda(km);
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
            r.fuente = 'Estimado por banda ' + etiquetaBanda + ' (' + costosBanda.size() + ' fletes FN de referencia, sin historial del par)';
        } else {
            r.costo = mediana(costosGlobal);
            r.viajes = costosGlobal.size();
            r.fuente = r.costo == null
                ? 'Sin datos: no hay fletes FN recientes para estimar'
                : 'Global (respaldo): mediana de ' + costosGlobal.size() + ' fletes FN recientes (banda ' + etiquetaBanda + ' vacía)';
        }
        if (r.costo != null && km > 0) { r.costoPorKm = (r.costo / km).setScale(2); }
        if (r.costo != null) { r.confianza = 'Baja'; }
        return finaliza(r);
    }

    private static List<Shipment__c> consultaPar(Id origenId, Id destinoId) {
        if (mockPar != null) { return mockPar; }
        return [
            SELECT Name, Kms__c, Total_Services_Std_Buy_Amount__c, CreatedDate,
                   Site_of_Load__c, Carrier__r.Name
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
            SELECT Name, Kms__c, Total_Services_Std_Buy_Amount__c, CreatedDate,
                   Site_of_Load__c, Site_of_Load__r.Zona_Metropolitana__c, Carrier__r.Name
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

    private static Resultado arma(Decimal costo, String fuente, Integer n, Decimal km, String confianza) {
        Resultado r = new Resultado();
        r.costo = costo;
        r.fuente = fuente;
        r.viajes = n;
        r.km = km;
        if (costo != null && km != null && km > 0) { r.costoPorKm = (costo / km).setScale(2); }
        r.confianza = confianza;
        return finaliza(r);
    }

    // Capa de venta y bandera de proveedor. La venta es sugerencia: el precio
    // final SIEMPRE lo decide el humano en pantalla.
    private static Resultado finaliza(Resultado r) {
        r.pedirProveedor = (r.costo == null || r.confianza == 'Baja');
        if (r.costo != null) {
            r.margenPct = MARGEN_VENTA_DEFAULT;
            r.ventaSugerida = (r.costo / (1 - MARGEN_VENTA_DEFAULT / 100)).setScale(2, RoundingMode.HALF_UP);
        }
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

    // ---------- "¿Cómo se calculó?": la cascada completa, escalón por escalón ----------
    // Método aparte para que el cotizar de todos los días siga barato: el detalle
    // solo se paga cuando alguien aprieta el botón.

    public class NivelExplicado {
        @AuraEnabled public Integer nivel;
        @AuraEnabled public String nombre;
        @AuraEnabled public String queBusco;
        @AuraEnabled public Integer viajes;
        @AuraEnabled public Integer minimo;
        @AuraEnabled public Decimal mediana;
        @AuraEnabled public Decimal porKm;
        @AuraEnabled public String veredicto;
        @AuraEnabled public Boolean usado;
    }

    public class ViajeMuestra implements Comparable {
        @AuraEnabled public String folio;
        @AuraEnabled public Date fecha;
        @AuraEnabled public String transportista;
        @AuraEnabled public Decimal buy;
        @AuraEnabled public Decimal km;
        @AuraEnabled public String sentido;
        @AuraEnabled public Boolean esMediana;
        public Integer compareTo(Object otro) {
            ViajeMuestra o = (ViajeMuestra) otro;
            if (buy == o.buy) { return 0; }
            return buy > o.buy ? 1 : -1;
        }
    }

    public class Explicacion {
        @AuraEnabled public Resultado resultado;
        @AuraEnabled public List<NivelExplicado> niveles;
        @AuraEnabled public List<ViajeMuestra> muestra;
        @AuraEnabled public String notaMuestra;
        @AuraEnabled public String origenKm;
        @AuraEnabled public Integer viajesIda;
        @AuraEnabled public Integer viajesVuelta;
        @AuraEnabled public Decimal minimoBuy;
        @AuraEnabled public Decimal p25;
        @AuraEnabled public Decimal p75;
        @AuraEnabled public Decimal maximoBuy;
        @AuraEnabled public Date viajeMasViejo;
        @AuraEnabled public Date viajeMasReciente;
    }

    @AuraEnabled
    public static Explicacion explicar(Id origenId, Id destinoId, Decimal kmManual) {
        Explicacion ex = new Explicacion();
        ex.resultado = cotizar(origenId, destinoId, kmManual);

        DateTime corteReciente = DateTime.now().addMonths(-MESES_VENTANA_RECIENTE);
        List<Shipment__c> par = consultaPar(origenId, destinoId);
        List<Shipment__c> parRec = recientesSp(par, corteReciente);

        Map<Id, Location__c> locs = new Map<Id, Location__c>([
            SELECT Id, Name, Zona_Metropolitana__c, Zona_Metropolitana__r.Name
            FROM Location__c WHERE Id IN (:origenId, :destinoId)]);
        Id zonaO = zonaEfectiva(locs.get(origenId), origenId);
        Id zonaD = zonaEfectiva(locs.get(destinoId), destinoId);
        List<Shipment__c> zona = consultaZona(zonaO, zonaD);
        List<Shipment__c> zonaRec = recientesSp(zona, corteReciente);

        // km: misma resolución que cotizar, pero diciendo de dónde salieron
        Decimal km = kmManual;
        if (km != null) { ex.origenKm = 'Capturados a mano'; }
        if (km == null) { km = medianaKmSp(parRec); if (km != null) { ex.origenKm = 'Mediana de los km reales del par (recientes)'; } }
        if (km == null) { km = medianaKmSp(par); if (km != null) { ex.origenKm = 'Mediana de los km reales del par (histórico)'; } }
        if (km == null) { km = medianaKmSp(zonaRec); if (km != null) { ex.origenKm = 'Mediana de los km de la zona (recientes)'; } }
        if (km == null) { km = medianaKmSp(zona); if (km != null) { ex.origenKm = 'Mediana de los km de la zona (histórico)'; } }
        if (km == null) { ex.origenKm = 'Sin km: ni capturados ni en el historial'; }

        String nomO = locs.containsKey(origenId) ? locs.get(origenId).Name : 'origen';
        String nomD = locs.containsKey(destinoId) ? locs.get(destinoId).Name : 'destino';
        String rutaPar = nomO + ' ⇄ ' + nomD;
        String rutaZona = etiquetaZona(locs.get(origenId)) + ' ⇄ ' + etiquetaZona(locs.get(destinoId));

        Integer ganador = 5;
        if (parRec.size() >= MIN_PAR_RECIENTE) { ganador = 1; }
        else if (par.size() >= MIN_PAR_HISTORICO) { ganador = 2; }
        else if (zonaRec.size() >= MIN_ZONA_RECIENTE) { ganador = 3; }
        else if (zona.size() >= MIN_ZONA_HISTORICO) { ganador = 4; }

        ex.niveles = new List<NivelExplicado>{
            nivel(1, 'Par exacto reciente (últimos ' + MESES_VENTANA_RECIENTE + ' meses)', rutaPar, parRec, MIN_PAR_RECIENTE, ganador, 'Alta'),
            nivel(2, 'Par exacto histórico (desde 2024)', rutaPar, par, MIN_PAR_HISTORICO, ganador, 'Media'),
            nivel(3, 'Zona reciente (últimos ' + MESES_VENTANA_RECIENTE + ' meses)', rutaZona, zonaRec, MIN_ZONA_RECIENTE, ganador, 'Media'),
            nivel(4, 'Zona histórico (desde 2024)', rutaZona, zona, MIN_ZONA_HISTORICO, ganador, 'Baja')
        };

        Resultado banda = cotizaPorBanda(km, corteReciente);
        NivelExplicado n5 = new NivelExplicado();
        n5.nivel = 5;
        n5.nombre = 'Banda $/km (todo el flete FN reciente)';
        n5.queBusco = km == null ? 'Sin km no hay banda (respaldo global)' : 'Banda ' + nombreBanda(km);
        n5.viajes = banda.viajes;
        n5.mediana = banda.costo;
        n5.porKm = banda.costoPorKm;
        n5.usado = (ganador == 5);
        n5.veredicto = !n5.usado ? 'no se usó (ganó el nivel ' + ganador + ')'
            : (banda.costo == null ? 'sin datos' : 'USADO · confianza Baja');
        ex.niveles.add(n5);

        // Muestra, ida/vuelta y dispersión: solo aplican a los niveles por ruta (1-4)
        if (ganador <= 4) {
            List<Shipment__c> filas = ganador == 1 ? parRec : (ganador == 2 ? par : (ganador == 3 ? zonaRec : zona));
            Boolean porZona = ganador >= 3;
            Id refOrigen = porZona ? zonaO : origenId;
            List<ViajeMuestra> todos = new List<ViajeMuestra>();
            List<Decimal> buys = new List<Decimal>();
            ex.viajesIda = 0;
            ex.viajesVuelta = 0;
            for (Shipment__c s : filas) {
                ViajeMuestra v = new ViajeMuestra();
                v.folio = s.Name;
                v.fecha = s.CreatedDate == null ? null : s.CreatedDate.date();
                v.transportista = s.Carrier__r != null ? s.Carrier__r.Name : '';
                v.buy = s.Total_Services_Std_Buy_Amount__c;
                v.km = s.Kms__c;
                v.sentido = sentido(s, porZona, refOrigen);
                v.esMediana = false;
                todos.add(v);
                buys.add(v.buy);
                if (v.sentido == 'ida') { ex.viajesIda++; } else if (v.sentido == 'vuelta') { ex.viajesVuelta++; }
                if (v.fecha != null && (ex.viajeMasViejo == null || v.fecha < ex.viajeMasViejo)) { ex.viajeMasViejo = v.fecha; }
                if (v.fecha != null && (ex.viajeMasReciente == null || v.fecha > ex.viajeMasReciente)) { ex.viajeMasReciente = v.fecha; }
            }
            todos.sort();
            Integer n = todos.size();
            if (n > 0) {
                if (Math.mod(n, 2) == 1) { todos[n / 2].esMediana = true; }
                else { todos[n / 2 - 1].esMediana = true; todos[n / 2].esMediana = true; }
            }
            buys.sort();
            if (!buys.isEmpty()) {
                ex.minimoBuy = buys[0];
                ex.maximoBuy = buys[buys.size() - 1];
                ex.p25 = buys[(Integer) Math.floor((buys.size() - 1) * 0.25)];
                ex.p75 = buys[(Integer) Math.floor((buys.size() - 1) * 0.75)];
            }
            ex.muestra = recorta(todos, 20);
            if (n > ex.muestra.size()) {
                ex.notaMuestra = 'Muestra de ' + ex.muestra.size() + ' de los ' + n + ' viajes, repartidos del más barato al más caro e incluyendo la mediana.';
            }
        } else {
            ex.notaMuestra = (banda.viajes == null || banda.viajes == 0)
                ? 'Sin viajes de referencia.'
                : 'La banda usa ' + banda.viajes + ' fletes FN de referencia de todo el país; no hay muestra por ruta.';
        }
        return ex;
    }

    private static NivelExplicado nivel(Integer num, String nombre, String queBusco, List<Shipment__c> filas, Integer minimo, Integer ganador, String confianza) {
        NivelExplicado n = new NivelExplicado();
        n.nivel = num;
        n.nombre = nombre;
        n.queBusco = queBusco;
        n.viajes = filas.size();
        n.minimo = minimo;
        n.mediana = medianaBuySp(filas);
        Decimal kmNivel = medianaKmSp(filas);
        if (n.mediana != null && kmNivel != null && kmNivel > 0) { n.porKm = (n.mediana / kmNivel).setScale(2); }
        n.usado = (ganador == num);
        if (n.usado) { n.veredicto = 'USADO · confianza ' + confianza; }
        else if (filas.size() < minimo) { n.veredicto = 'no alcanza (' + filas.size() + ' de ' + minimo + ')'; }
        else { n.veredicto = 'no se usó (ganó el nivel ' + ganador + ')'; }
        return n;
    }

    private static String nombreBanda(Decimal km) {
        return km < KM_LOCAL ? 'Local (<100 km)'
            : km < KM_CORTA ? 'Corta (100-300 km)'
            : km < KM_MEDIA ? 'Media (300-700 km)' : 'Larga (700+ km)';
    }

    private static List<Shipment__c> recientesSp(List<Shipment__c> filas, DateTime corte) {
        List<Shipment__c> rec = new List<Shipment__c>();
        for (Shipment__c s : filas) { if (s.CreatedDate >= corte) { rec.add(s); } }
        return rec;
    }

    private static Decimal medianaBuySp(List<Shipment__c> filas) {
        List<Decimal> v = new List<Decimal>();
        for (Shipment__c s : filas) { v.add(s.Total_Services_Std_Buy_Amount__c); }
        return mediana(v);
    }

    private static Decimal medianaKmSp(List<Shipment__c> filas) {
        List<Decimal> v = new List<Decimal>();
        for (Shipment__c s : filas) { if (s.Kms__c != null && s.Kms__c > 0) { v.add(s.Kms__c); } }
        return mediana(v);
    }

    private static String etiquetaZona(Location__c loc) {
        if (loc == null) { return 'zona'; }
        return loc.Zona_Metropolitana__c != null ? loc.Zona_Metropolitana__r.Name : loc.Name;
    }

    // ida = cargó en el origen consultado (o en su zona); la búsqueda es bidireccional
    private static String sentido(Shipment__c s, Boolean porZona, Id refOrigen) {
        if (s.Site_of_Load__c == null) { return ''; }
        Boolean ida = s.Site_of_Load__c == refOrigen
            || (porZona && s.Site_of_Load__r != null && s.Site_of_Load__r.Zona_Metropolitana__c == refOrigen);
        return ida ? 'ida' : 'vuelta';
    }

    // Tope de renglones: reparte parejo del más barato al más caro y nunca tira la mediana
    private static List<ViajeMuestra> recorta(List<ViajeMuestra> todos, Integer tope) {
        if (todos.size() <= tope) { return todos; }
        Set<Integer> escogidos = new Set<Integer>();
        for (Integer i = 0; i < tope - 2; i++) {
            escogidos.add((Integer) Math.round(i * (todos.size() - 1) / (Double) (tope - 3)));
        }
        for (Integer i = 0; i < todos.size(); i++) { if (todos[i].esMediana) { escogidos.add(i); } }
        List<Integer> orden = new List<Integer>(escogidos);
        orden.sort();
        List<ViajeMuestra> corte = new List<ViajeMuestra>();
        for (Integer i : orden) { corte.add(todos[i]); }
        return corte;
    }
}
