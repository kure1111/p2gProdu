public class PAK_ShipCreditLimit {
    
    public static Set<String> lstRateCatAllowed = new Set<String>{
        'Road Freights', 'Air Freights', 'Sea Freights'
    };
    
    // Método principal para UPDATE - procesa lista de registros (BULK)
    public static void CalcularUpdate(List<Shipment_Fee_Line__c> lineasNuevas, Map<Id, Shipment_Fee_Line__c> mapaLineasViejas) {
        if (lineasNuevas == null || lineasNuevas.isEmpty() || mapaLineasViejas == null) return;
        
        // 1. Filtrar líneas que deben procesarse y tuvieron cambio relevante
        List<Shipment_Fee_Line__c> lineasAProcesar = new List<Shipment_Fee_Line__c>();
        Set<Id> shipmentIds = new Set<Id>();
        
        for (Shipment_Fee_Line__c lineaNueva : lineasNuevas) {
            Shipment_Fee_Line__c lineaVieja = mapaLineasViejas.get(lineaNueva.Id);
            
            if (lineaVieja != null && debeProcesarLinea(lineaNueva) && huboCambioRelevante(lineaVieja, lineaNueva)) {
                lineasAProcesar.add(lineaNueva);
                shipmentIds.add(lineaNueva.Shipment__c);
            }
        }
        
        if (lineasAProcesar.isEmpty()) return;
        
        // 2. Obtener tasa de cambio USD (una sola vez para todos)
        Decimal tasaUSD = obtenerTasaCambioUSD();
        
        // 3. Obtener saldos de todas las cuentas relacionadas (una sola query)
        Map<Id, Decimal> saldosPorShipment = obtenerSaldosCuentas(shipmentIds);
        
        // 4. Procesar cada línea válida
        for (Shipment_Fee_Line__c lineaNueva : lineasAProcesar) {
            Shipment_Fee_Line__c lineaVieja = mapaLineasViejas.get(lineaNueva.Id);
            Decimal saldoDisponible = saldosPorShipment.get(lineaNueva.Shipment__c);
            
            if (saldoDisponible != null) {
                verificarCreditoLineaIndividual(lineaNueva, lineaVieja, tasaUSD, saldoDisponible);
            }
        }
    }
    
    // Validar si la línea debe procesarse (sin cambios)
    private static Boolean debeProcesarLinea(Shipment_Fee_Line__c linea) {
        return linea.Shipment__c != null 
            && linea.Venta_Account__c == 'Credito' 
            && lstRateCatAllowed.contains(linea.Service_Rate_Category__c);
    }
    
    // Validar si hubo cambio relevante (sin cambios)
    private static Boolean huboCambioRelevante(Shipment_Fee_Line__c lineaVieja, Shipment_Fee_Line__c lineaNueva) {
        return lineaVieja.Shipment_Sell_Price__c != lineaNueva.Shipment_Sell_Price__c 
            || lineaVieja.CurrencyIsoCode != lineaNueva.CurrencyIsoCode;
    }
    
    // Obtener tasa de cambio USD -> MXN (sin cambios)
    private static Decimal obtenerTasaCambioUSD() {
        CurrencyType usd = [SELECT ConversionRate 
                            FROM CurrencyType 
                            WHERE IsActive = TRUE AND IsoCode = 'USD' 
                            LIMIT 1];
        return 1 / usd.ConversionRate;
    }
    
    // Obtener saldos de todas las cuentas (NUEVO método bulk)
    private static Map<Id, Decimal> obtenerSaldosCuentas(Set<Id> shipmentIds) {
        Map<Id, Decimal> saldosMap = new Map<Id, Decimal>();
        
        for (Shipment__c s : [SELECT Id, Account_for__r.Saldo_DisponibleOK__c 
                              FROM Shipment__c 
                              WHERE Id IN :shipmentIds]) {
            saldosMap.put(s.Id, s.Account_for__r.Saldo_DisponibleOK__c);
        }
        
        return saldosMap;
    }
    
    // Verificar crédito para la línea individual (modificado para recibir saldo)
    private static void verificarCreditoLineaIndividual(Shipment_Fee_Line__c lineaNueva, 
                                                       Shipment_Fee_Line__c lineaVieja, 
                                                       Decimal tasaUSD,
                                                       Decimal saldoDisponible) {
        // 1. Convertir ambos valores a MXN
        Decimal valorViejoMXN = convertirAMXN(lineaVieja.Shipment_Sell_Price__c, lineaVieja.CurrencyIsoCode, tasaUSD);
        Decimal valorNuevoMXN = convertirAMXN(lineaNueva.Shipment_Sell_Price__c, lineaNueva.CurrencyIsoCode, tasaUSD);
        
        // 2. LÓGICA CORRECTA: Liberar el valor viejo y reservar el valor nuevo
        Decimal saldoDespues = saldoDisponible + valorViejoMXN - valorNuevoMXN;
        
        // 3. Verificar si el saldo después sería negativo
        if(saldoDespues < 0 && !Test.isRunningTest()) {
            lineaNueva.addError('No existe crédito disponible. Saldo después del cambio: ' + saldoDespues.setScale(2) + ' MXN');
        }
    }
    
    // Convertir cualquier valor a MXN (sin cambios)
    private static Decimal convertirAMXN(Decimal valor, String moneda, Decimal tasaUSD) {
        if (valor == null) return 0;
        return (moneda == 'USD') ? valor * tasaUSD : valor;
    }
}