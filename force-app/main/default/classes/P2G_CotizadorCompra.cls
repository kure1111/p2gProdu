/**
 * Cotizador de costo de compra (CXP) por ruta de flete.
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
 * Fuente de datos: Shipment__c del servicio elegido con compra real (> 0).
 *
 * Fase 2 (2026-09-23): confianza Alta/Media/Baja según el nivel de la cascada,
 * bandera pedirProveedor cuando el dato no es confiable, y venta sugerida con
 * el margen FN estándar (15% sobre venta, mismo criterio que el precio
 * sugerido de productos: Buy / 0.85). La venta es SOLO una sugerencia: el
 * humano de pricing la ajusta en pantalla y decide el precio final.
 *
 * Fase 4 (2026-09-25): servicio parametrizado (FN/FI/PTO/T/M/CE/PQ — T, M, CE
 * y PQ no tienen km capturados: niveles 1-4 funcionan a costo completo y el
 * respaldo es el costo completo mediano, nunca un $/km inventado); modalidad
 * (Container_Type__c) con GUARDA: solo filtra el historial si quedan
 * suficientes viajes, si no cae a todas las modalidades y lo dice; km
 * adicionales cobrados al $/km de la MISMA fuente que dio el precio (nunca en
 * banda Local ni respaldo global, que no escalan por km); y promedio/mediana/
 * ponderado del $/km de la banda expuestos (el cálculo SIGUE siendo con
 * mediana, decisión pendiente de negocio).
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
    @TestVisible private static final Set<String> SERVICIOS = new Set<String>{ 'FN', 'FI', 'PTO', 'T', 'M', 'CE', 'PQ' };

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
        @AuraEnabled public String servicio;        // FN / FI / PTO / T / M / CE / PQ
        @AuraEnabled public String modalidadNota;   // aviso cuando la modalidad elegida no pudo filtrar
        @AuraEnabled public Decimal costoBase;      // costo de la ruta sin km adicionales
        @AuraEnabled public Decimal kmAdicionales;
        @AuraEnabled public Decimal costoAdicional; // kmAdicionales x $/km de la fuente ganadora
        @AuraEnabled public Boolean escalaPorKm;    // false en banda Local y respaldos globales
        @AuraEnabled public Decimal bandaPromedioKm;  // $/km promedio simple de la banda usada
        @AuraEnabled public Decimal bandaMedianaKm;   // $/km mediano (el que se usa para calcular)
        @AuraEnabled public Decimal bandaPonderadoKm; // dinero total / km totales de la banda
    }

    // Hooks de prueba: el campo de compra no es escribible en todos los orgs
    // (drift UAT), así que los tests inyectan los viajes en lugar de insertarlos
    @TestVisible private static List<Shipment__c> mockPar;
    @TestVisible private static List<Shipment__c> mockZona;
    @TestVisible private static List<Shipment__c> mockBanda;

    @AuraEnabled
    public static Resultado cotizar(Id origenId, Id destinoId, Decimal kmManual, String servicio, Id modalidadId, Decimal kmAdicionales) {
        if (origenId == null || destinoId == null) {
            throw aura('Selecciona origen y destino');
        }
        String svc = normalizaServicio(servicio);
        DateTime corteReciente = DateTime.now().addMonths(-MESES_VENTANA_RECIENTE);

        // ---- Niveles 1-2: par exacto (bidireccional) ----
        List<Shipment__c> par = consultaPar(origenId, destinoId, svc);
        List<Shipment__c> parRec = recientesSp(par, corteReciente);

        // km de la ruta: manual > mediana del par reciente > mediana del par completo
        // (los km salen del historial SIN filtrar por modalidad: la distancia no depende de la caja)
        Decimal km = kmManual;
        if (km == null) { km = medianaKmSp(parRec); }
        if (km == null) { km = medianaKmSp(par); }

        Resultado r;
        SetNivel s1 = eligeFilas(parRec, modalidadId, MIN_PAR_RECIENTE);
        SetNivel s2 = eligeFilas(par, modalidadId, MIN_PAR_HISTORICO);
        if (s1.filas.size() >= MIN_PAR_RECIENTE) {
            r = arma(medianaBuySp(s1.filas), 'Par exacto reciente (' + s1.filas.size() + ' viajes, últimos ' + MESES_VENTANA_RECIENTE + ' meses)', s1.filas.size(), km, 'Alta');
            anotaModalidad(r, modalidadId, s1);
        } else if (s2.filas.size() >= MIN_PAR_HISTORICO) {
            r = arma(medianaBuySp(s2.filas), 'Par exacto histórico desde 2024 (' + s2.filas.size() + ' viajes)', s2.filas.size(), km, 'Media');
            anotaModalidad(r, modalidadId, s2);
        } else {
            // ---- Niveles 3-4: zona metropolitana ----
            Map<Id, Location__c> locs = new Map<Id, Location__c>(
                [SELECT Id, Zona_Metropolitana__c FROM Location__c WHERE Id IN (:origenId, :destinoId)]);
            Id zonaO = zonaEfectiva(locs.get(origenId), origenId);
            Id zonaD = zonaEfectiva(locs.get(destinoId), destinoId);

            List<Shipment__c> zona = consultaZona(zonaO, zonaD, svc);
            List<Shipment__c> zonaRec = recientesSp(zona, corteReciente);
            if (km == null) { km = medianaKmSp(zonaRec); }
            if (km == null) { km = medianaKmSp(zona); }

            SetNivel s3 = eligeFilas(zonaRec, modalidadId, MIN_ZONA_RECIENTE);
            SetNivel s4 = eligeFilas(zona, modalidadId, MIN_ZONA_HISTORICO);
            if (s3.filas.size() >= MIN_ZONA_RECIENTE) {
                r = arma(medianaBuySp(s3.filas), 'Zona reciente (' + s3.filas.size() + ' viajes, últimos ' + MESES_VENTANA_RECIENTE + ' meses)', s3.filas.size(), km, 'Media');
                anotaModalidad(r, modalidadId, s3);
            } else if (s4.filas.size() >= MIN_ZONA_HISTORICO) {
                r = arma(medianaBuySp(s4.filas), 'Zona histórico desde 2024 (' + s4.filas.size() + ' viajes)', s4.filas.size(), km, 'Baja');
                anotaModalidad(r, modalidadId, s4);
            } else {
                // ---- Nivel 5: bandas de $/km sobre todo el flete del servicio ----
                r = cotizaPorBanda(km, corteReciente, svc);
                if (modalidadId != null) {
                    r.modalidadNota = 'Las bandas de $/km no distinguen modalidad: son la referencia de todo el servicio.';
                }
            }
        }
        r.servicio = svc;
        aplicaAdicionales(r, kmAdicionales);
        return finaliza(r);
    }

    // La banda Local cotiza con el costo COMPLETO mediano de sus viajes (un flete
    // local no escala por km); las demás con km x $/km mediano de la banda.
    // La consulta trae TAMBIÉN viajes sin km: para servicios que no capturan
    // kilómetros (T/M/CE/PQ) el respaldo global es el costo completo mediano.
    // Cache por transacción: cotizar() y explicar() comparten esta consulta gorda
    // (dos corridas de 40k filas reventarían el límite de 50k query rows).
    private static List<Shipment__c> baseBandaCache;
    private static String baseBandaSvc;

    private static List<Shipment__c> baseBanda(DateTime corteReciente, String svc) {
        if (baseBandaCache == null || baseBandaSvc != svc) {
            String patron = 'SP-' + svc + '%';
            baseBandaSvc = svc;
            baseBandaCache = mockBanda != null ? mockBanda : [
                SELECT Kms__c, Total_Services_Std_Buy_Amount__c
                FROM Shipment__c
                WHERE Name LIKE :patron
                  AND Total_Services_Std_Buy_Amount__c > 0
                  AND CreatedDate >= :corteReciente
                LIMIT 40000
            ];
        }
        return baseBandaCache;
    }

    private static Resultado cotizaPorBanda(Decimal km, DateTime corteReciente, String svc) {
        List<Shipment__c> base = baseBanda(corteReciente, svc);
        if (km == null) {
            // sin km no hay banda: respaldo global (mediana de flete completo, con o sin km)
            List<Decimal> todos = new List<Decimal>();
            for (Shipment__c s : base) { todos.add(s.Total_Services_Std_Buy_Amount__c); }
            Decimal respaldoGlobal = mediana(todos);
            Resultado r = new Resultado();
            r.costo = respaldoGlobal;
            r.viajes = todos.size();
            r.escalaPorKm = false;
            r.fuente = respaldoGlobal == null
                ? 'Sin datos: no hay historial del par ni de la zona; captura los km para estimar por banda'
                : 'Global (respaldo, sin km): costo completo mediano de ' + todos.size() + ' fletes ' + svc + ' recientes';
            if (respaldoGlobal != null) { r.confianza = 'Mala'; }
            return r;
        }

        String etiquetaBanda = nombreBanda(km);
        List<Decimal> costosBanda = new List<Decimal>();
        List<Decimal> porKmBanda = new List<Decimal>();
        List<Decimal> costosGlobal = new List<Decimal>();
        Decimal sumaPorKm = 0;
        Decimal sumaBuyBanda = 0;
        Decimal sumaKmBanda = 0;
        for (Shipment__c s : base) {
            costosGlobal.add(s.Total_Services_Std_Buy_Amount__c);
            if (s.Kms__c == null || s.Kms__c <= 0) { continue; }
            Boolean mismaBanda = (km < KM_LOCAL && s.Kms__c < KM_LOCAL)
                || (km >= KM_LOCAL && km < KM_CORTA && s.Kms__c >= KM_LOCAL && s.Kms__c < KM_CORTA)
                || (km >= KM_CORTA && km < KM_MEDIA && s.Kms__c >= KM_CORTA && s.Kms__c < KM_MEDIA)
                || (km >= KM_MEDIA && s.Kms__c >= KM_MEDIA);
            if (mismaBanda) {
                costosBanda.add(s.Total_Services_Std_Buy_Amount__c);
                Decimal pk = s.Total_Services_Std_Buy_Amount__c / s.Kms__c;
                porKmBanda.add(pk);
                sumaPorKm += pk;
                sumaBuyBanda += s.Total_Services_Std_Buy_Amount__c;
                sumaKmBanda += s.Kms__c;
            }
        }

        Resultado r = new Resultado();
        r.km = km;
        if (!costosBanda.isEmpty()) {
            if (km < KM_LOCAL) {
                r.costo = mediana(costosBanda);
                r.escalaPorKm = false;
            } else {
                r.bandaMedianaKm = mediana(porKmBanda);
                r.bandaPromedioKm = (sumaPorKm / porKmBanda.size()).setScale(2, RoundingMode.HALF_UP);
                if (sumaKmBanda > 0) { r.bandaPonderadoKm = (sumaBuyBanda / sumaKmBanda).setScale(2, RoundingMode.HALF_UP); }
                r.costo = (km * r.bandaMedianaKm).setScale(2);
                r.escalaPorKm = true;
            }
            r.viajes = costosBanda.size();
            r.fuente = 'Estimado por banda ' + etiquetaBanda + ' (' + costosBanda.size() + ' fletes ' + svc + ' de referencia, sin historial del par)';
        } else {
            r.costo = mediana(costosGlobal);
            r.viajes = costosGlobal.size();
            r.escalaPorKm = false;
            r.fuente = r.costo == null
                ? 'Sin datos: no hay fletes ' + svc + ' recientes para estimar'
                : 'Global (respaldo): costo completo mediano de ' + costosGlobal.size() + ' fletes ' + svc + ' recientes (banda ' + etiquetaBanda + ' vacía)';
        }
        if (r.costo != null && km > 0) { r.costoPorKm = (r.costo / km).setScale(2); }
        // Mala (debajo de Baja): el numero sale del promedio general del servicio,
        // no de viajes de la ruta ni de su zona (decision de Alberto 2026-09-25)
        if (r.costo != null) { r.confianza = 'Mala'; }
        return r;
    }

    private static List<Shipment__c> consultaPar(Id origenId, Id destinoId, String svc) {
        if (mockPar != null) { return mockPar; }
        String patron = 'SP-' + svc + '%';
        return [
            SELECT Name, Kms__c, Total_Services_Std_Buy_Amount__c, CreatedDate,
                   Site_of_Load__c, Carrier__r.Name, Container_Type__c
            FROM Shipment__c
            WHERE Name LIKE :patron
              AND Total_Services_Std_Buy_Amount__c > 0
              AND CreatedDate >= :INICIO_HISTORICO
              AND ((Site_of_Load__c = :origenId AND Site_of_Discharge__c = :destinoId)
                OR (Site_of_Load__c = :destinoId AND Site_of_Discharge__c = :origenId))
            LIMIT 10000
        ];
    }

    // Una localidad "pertenece" a la zona si su Zona_Metropolitana__c apunta a ella
    // o si ELLA MISMA es la zona (los viajes a "ZM De Guadalajara" van directo a la zona)
    private static List<Shipment__c> consultaZona(Id zonaO, Id zonaD, String svc) {
        if (mockZona != null) { return mockZona; }
        String patron = 'SP-' + svc + '%';
        return [
            SELECT Name, Kms__c, Total_Services_Std_Buy_Amount__c, CreatedDate,
                   Site_of_Load__c, Site_of_Load__r.Zona_Metropolitana__c, Carrier__r.Name, Container_Type__c
            FROM Shipment__c
            WHERE Name LIKE :patron
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

    // ---- Modalidad: filtra solo si quedan suficientes viajes; si no, todas y se dice ----

    private class SetNivel {
        List<Shipment__c> filas;
        Boolean modalidadAplicada;
    }

    private static SetNivel eligeFilas(List<Shipment__c> filas, Id modalidadId, Integer minimo) {
        SetNivel s = new SetNivel();
        if (modalidadId == null) {
            s.filas = filas;
            s.modalidadAplicada = false;
            return s;
        }
        List<Shipment__c> filtradas = new List<Shipment__c>();
        for (Shipment__c x : filas) {
            if (x.Container_Type__c == modalidadId) { filtradas.add(x); }
        }
        if (filtradas.size() >= minimo) {
            s.filas = filtradas;
            s.modalidadAplicada = true;
        } else {
            s.filas = filas;
            s.modalidadAplicada = false;
        }
        return s;
    }

    private static void anotaModalidad(Resultado r, Id modalidadId, SetNivel s) {
        if (modalidadId == null) { return; }
        if (s.modalidadAplicada) {
            r.fuente += ', solo la modalidad elegida';
        } else {
            r.modalidadNota = 'Sin historial suficiente de esa modalidad en la ruta: se usó el de todas las modalidades.';
        }
    }

    // ---- Km adicionales: al $/km de la MISMA fuente que dio el precio ----

    private static void aplicaAdicionales(Resultado r, Decimal kmAdicionales) {
        r.costoBase = r.costo;
        if (kmAdicionales == null || kmAdicionales <= 0 || r.costo == null) { return; }
        if (r.escalaPorKm == true && r.costoPorKm != null && r.costoPorKm > 0) {
            r.kmAdicionales = kmAdicionales;
            r.costoAdicional = (kmAdicionales * r.costoPorKm).setScale(2, RoundingMode.HALF_UP);
            r.costo = r.costoBase + r.costoAdicional;
            r.fuente += ' + ' + kmAdicionales + ' km adicionales a $' + r.costoPorKm + '/km';
        } else {
            r.fuente += ' (los ' + kmAdicionales + ' km adicionales no se aplicaron: esta fuente no escala por km)';
        }
    }

    private static Resultado arma(Decimal costo, String fuente, Integer n, Decimal km, String confianza) {
        Resultado r = new Resultado();
        r.costo = costo;
        r.fuente = fuente;
        r.viajes = n;
        r.km = km;
        if (costo != null && km != null && km > 0) { r.costoPorKm = (costo / km).setScale(2); }
        r.escalaPorKm = (r.costoPorKm != null);
        r.confianza = confianza;
        return r;
    }

    // Capa de venta y bandera de proveedor. La venta es sugerencia: el precio
    // final SIEMPRE lo decide el humano en pantalla.
    private static Resultado finaliza(Resultado r) {
        // Al reves a proposito: pide proveedor TODO lo que no sea Alta o Media.
        // Asi un nivel nuevo (como Mala) nunca se escapa del aviso por olvido.
        r.pedirProveedor = (r.costo == null || (r.confianza != 'Alta' && r.confianza != 'Media'));
        if (r.costo != null) {
            r.margenPct = MARGEN_VENTA_DEFAULT;
            r.ventaSugerida = (r.costo / (1 - MARGEN_VENTA_DEFAULT / 100)).setScale(2, RoundingMode.HALF_UP);
        }
        return r;
    }

    private static String normalizaServicio(String servicio) {
        String svc = String.isBlank(servicio) ? 'FN' : servicio.trim().toUpperCase();
        if (!SERVICIOS.contains(svc)) {
            throw aura('Servicio no soportado: ' + servicio);
        }
        return svc;
    }

    private static AuraHandledException aura(String msg) {
        AuraHandledException ex = new AuraHandledException(msg);
        ex.setMessage(msg);
        return ex;
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
        @AuraEnabled public String nota; // qué pasó con la modalidad en este nivel
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
    public static Explicacion explicar(Id origenId, Id destinoId, Decimal kmManual, String servicio, Id modalidadId, Decimal kmAdicionales) {
        Explicacion ex = new Explicacion();
        ex.resultado = cotizar(origenId, destinoId, kmManual, servicio, modalidadId, kmAdicionales);
        String svc = ex.resultado.servicio;

        DateTime corteReciente = DateTime.now().addMonths(-MESES_VENTANA_RECIENTE);
        List<Shipment__c> par = consultaPar(origenId, destinoId, svc);
        List<Shipment__c> parRec = recientesSp(par, corteReciente);

        Map<Id, Location__c> locs = new Map<Id, Location__c>([
            SELECT Id, Name, Zona_Metropolitana__c, Zona_Metropolitana__r.Name
            FROM Location__c WHERE Id IN (:origenId, :destinoId)]);
        Id zonaO = zonaEfectiva(locs.get(origenId), origenId);
        Id zonaD = zonaEfectiva(locs.get(destinoId), destinoId);
        List<Shipment__c> zona = consultaZona(zonaO, zonaD, svc);
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

        SetNivel s1 = eligeFilas(parRec, modalidadId, MIN_PAR_RECIENTE);
        SetNivel s2 = eligeFilas(par, modalidadId, MIN_PAR_HISTORICO);
        SetNivel s3 = eligeFilas(zonaRec, modalidadId, MIN_ZONA_RECIENTE);
        SetNivel s4 = eligeFilas(zona, modalidadId, MIN_ZONA_HISTORICO);

        Integer ganador = 5;
        if (s1.filas.size() >= MIN_PAR_RECIENTE) { ganador = 1; }
        else if (s2.filas.size() >= MIN_PAR_HISTORICO) { ganador = 2; }
        else if (s3.filas.size() >= MIN_ZONA_RECIENTE) { ganador = 3; }
        else if (s4.filas.size() >= MIN_ZONA_HISTORICO) { ganador = 4; }

        ex.niveles = new List<NivelExplicado>{
            nivel(1, 'Par exacto reciente (últimos ' + MESES_VENTANA_RECIENTE + ' meses)', rutaPar, s1, MIN_PAR_RECIENTE, ganador, 'Alta', modalidadId),
            nivel(2, 'Par exacto histórico (desde 2024)', rutaPar, s2, MIN_PAR_HISTORICO, ganador, 'Media', modalidadId),
            nivel(3, 'Zona reciente (últimos ' + MESES_VENTANA_RECIENTE + ' meses)', rutaZona, s3, MIN_ZONA_RECIENTE, ganador, 'Media', modalidadId),
            nivel(4, 'Zona histórico (desde 2024)', rutaZona, s4, MIN_ZONA_HISTORICO, ganador, 'Baja', modalidadId)
        };

        Resultado banda = cotizaPorBanda(km, corteReciente, svc);
        NivelExplicado n5 = new NivelExplicado();
        n5.nivel = 5;
        n5.nombre = 'Precio promedio por km (banda de todo el flete ' + svc + ')';
        n5.queBusco = km == null ? 'Sin km no hay banda (respaldo global a costo completo)' : 'Banda ' + nombreBanda(km);
        n5.viajes = banda.viajes;
        n5.mediana = banda.costo;
        n5.porKm = banda.costoPorKm;
        n5.usado = (ganador == 5);
        n5.veredicto = !n5.usado ? 'no se usó (ganó el nivel ' + ganador + ')'
            : (banda.costo == null ? 'sin datos' : 'USADO · confianza Mala');
        if (banda.bandaMedianaKm != null) {
            n5.nota = '$/km de la banda: promedio ' + banda.bandaPromedioKm + ' · mediana ' + banda.bandaMedianaKm + ' (la usada) · ponderado ' + banda.bandaPonderadoKm;
        }
        ex.niveles.add(n5);

        // Muestra, ida/vuelta y dispersión: solo aplican a los niveles por ruta (1-4)
        if (ganador <= 4) {
            List<Shipment__c> filas = ganador == 1 ? s1.filas : (ganador == 2 ? s2.filas : (ganador == 3 ? s3.filas : s4.filas));
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
                : 'El respaldo usa ' + banda.viajes + ' fletes ' + svc + ' de referencia de todo el país; no hay muestra por ruta.';
        }
        return ex;
    }

    private static NivelExplicado nivel(Integer num, String nombre, String queBusco, SetNivel s, Integer minimo, Integer ganador, String confianza, Id modalidadId) {
        NivelExplicado n = new NivelExplicado();
        n.nivel = num;
        n.nombre = nombre;
        n.queBusco = queBusco;
        n.viajes = s.filas.size();
        n.minimo = minimo;
        n.mediana = medianaBuySp(s.filas);
        Decimal kmNivel = medianaKmSp(s.filas);
        if (n.mediana != null && kmNivel != null && kmNivel > 0) { n.porKm = (n.mediana / kmNivel).setScale(2); }
        n.usado = (ganador == num);
        if (n.usado) { n.veredicto = 'USADO · confianza ' + confianza; }
        else if (s.filas.size() < minimo) { n.veredicto = 'no alcanza (' + s.filas.size() + ' de ' + minimo + ')'; }
        else { n.veredicto = 'no se usó (ganó el nivel ' + ganador + ')'; }
        if (modalidadId != null) {
            n.nota = s.modalidadAplicada ? 'solo la modalidad elegida' : 'todas las modalidades (la elegida no alcanza sola)';
        }
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
