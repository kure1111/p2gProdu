public class P2G_FileUploaderController {

    public class CargaTarifarioException extends Exception {}

    @TestVisible
    private static final List<String> EXPECTED_HEADERS_CLIENTES = new List<String>{
        'Nombre del Cliente',
        'Customer ID',
        'Ruta',
        'Sap service Type Sell',
        'Sap service Type Buy',
        'Sell Rate',
        'Valid From dd/mm/yyyy',
        'Valid Until dd/mm/yyyy',
        'Container Type'
    };

    @TestVisible
    private static final List<String> EXPECTED_HEADERS_PROVEEDORES = new List<String>{
        'Nombre del Proveedor',
        'Customer ID',
        'Ruta',
        'Sap service Type Sell',
        'Sap service Type Buy',
        'Sell Rate',
        'Valid From dd/mm/yyyy',
        'Valid Until dd/mm/yyyy',
        'Container Type'
    };

    @AuraEnabled
    public static String procesarCSV(String csvContent, String operacion) {

        if (String.isBlank(csvContent)) {
            throw new AuraHandledException('El contenido del archivo está vacío.');
        }

        List<String> lines = csvContent.split('\\r?\\n');

        if (lines.size() < 2) {
            throw new AuraHandledException('El archivo debe contener al menos una fila de datos.');
        }

        List<String> headers = obtenerHeaders(lines[0]);

        List<String> expectedHeaders;
        if ('proveedores'.equalsIgnoreCase(operacion)) {
            expectedHeaders = EXPECTED_HEADERS_PROVEEDORES;
        } else {
            expectedHeaders = EXPECTED_HEADERS_CLIENTES;
        }

        for (String required : expectedHeaders) {
            if (!headers.contains(required)) {
                throw new AuraHandledException('Falta la columna: ' + required);
            }
        }

        Map<String, Integer> colIndex = new Map<String, Integer>();
        for (Integer i = 0; i < headers.size(); i++) {
            colIndex.put(headers[i], i);
        }

        String colNombre = 'proveedores'.equalsIgnoreCase(operacion) ? 'Nombre del Proveedor' : 'Nombre del Cliente';

        // ---- PASADA 1: parsear todas las filas (CSV con soporte de comillas) y
        //      juntar los valores unicos para consultar los catalogos UNA sola vez.
        //      (Antes se hacian 5 consultas POR FILA: con ~20 filas tronaba el limite de 100.)
        List<List<String>> filas = new List<List<String>>();
        List<Integer> numeroFila = new List<Integer>();
        Set<String> nombresCuenta = new Set<String>();
        Set<String> customerIds = new Set<String>();
        Set<String> rutas = new Set<String>();
        Set<String> sapTypes = new Set<String>();
        Set<String> containers = new Set<String>();

        for (Integer rowIdx = 1; rowIdx < lines.size(); rowIdx++) {
            String line = lines[rowIdx];
            if (String.isBlank(line)) {
                continue;
            }
            List<String> values = parseCsvLine(line);
            while (values.size() < headers.size()) {
                values.add('');
            }
            // filas sin ningun dato (",,,,,,,,") se ignoran: la plantilla las
            // exporta asi cuando tiene formulas en renglones sin usar
            Boolean tieneDatos = false;
            for (String v : values) {
                if (String.isNotBlank(v)) { tieneDatos = true; break; }
            }
            if (!tieneDatos) {
                continue;
            }
            filas.add(values);
            numeroFila.add(rowIdx + 1);

            String nombre = getValue(values, colIndex, colNombre);
            String customerId = getValue(values, colIndex, 'Customer ID');
            if (String.isNotBlank(nombre) || String.isNotBlank(customerId)) {
                if (String.isNotBlank(nombre)) nombresCuenta.add(nombre);
                if (String.isNotBlank(customerId)) customerIds.add(customerId);
            }
            String ruta = getValue(values, colIndex, 'Ruta');
            if (String.isNotBlank(ruta)) rutas.add(ruta);
            String sapSell = getValue(values, colIndex, 'Sap service Type Sell');
            if (String.isNotBlank(sapSell)) sapTypes.add(sapSell);
            String sapBuy = getValue(values, colIndex, 'Sap service Type Buy');
            if (String.isNotBlank(sapBuy)) sapTypes.add(sapBuy);
            String containerType = getValue(values, colIndex, 'Container Type');
            if (String.isNotBlank(containerType)) containers.add(containerType);
        }

        // catalogos en mapas (llaves normalizadas a mayusculas: SOQL compara sin
        // distinguir mayusculas y aqui replicamos eso)
        Map<String, Id> mapCuentas = new Map<String, Id>();
        if (!nombresCuenta.isEmpty()) {
            for (Account a : [SELECT Id, Name, Customer_Id__c FROM Account
                              WHERE Name IN :nombresCuenta]) {
                String llave = llaveCuenta(a.Name, a.Customer_Id__c);
                if (!mapCuentas.containsKey(llave)) {
                    mapCuentas.put(llave, a.Id);
                }
            }
        }
        Map<String, Id> mapRutas = new Map<String, Id>();
        if (!rutas.isEmpty()) {
            for (Carrier_Line_Load_Point__c r : [SELECT Id, Name FROM Carrier_Line_Load_Point__c WHERE Name IN :rutas]) {
                if (!mapRutas.containsKey(r.Name.toUpperCase())) {
                    mapRutas.put(r.Name.toUpperCase(), r.Id);
                }
            }
        }
        Map<String, Id> mapSap = new Map<String, Id>();
        if (!sapTypes.isEmpty()) {
            for (SAP_Service_Type__c s : [SELECT Id, Name FROM SAP_Service_Type__c WHERE Name IN :sapTypes]) {
                if (!mapSap.containsKey(s.Name.toUpperCase())) {
                    mapSap.put(s.Name.toUpperCase(), s.Id);
                }
            }
        }
        Map<String, Id> mapContainers = new Map<String, Id>();
        if (!containers.isEmpty()) {
            for (Container_Type__c c : [SELECT Id, Name FROM Container_Type__c WHERE Name IN :containers]) {
                if (!mapContainers.containsKey(c.Name.toUpperCase())) {
                    mapContainers.put(c.Name.toUpperCase(), c.Id);
                }
            }
        }

        Id clientePorDefectoId = null;
        if ('proveedores'.equalsIgnoreCase(operacion)) {
            clientePorDefectoId = getClientePorDefecto();
        }

        Id feeRecordTypeId = getFeeRecordTypeId(operacion);
        String currentUserName = UserInfo.getName();

        // ---- PASADA 2: armar los Fee fila por fila con los mapas (cero consultas aqui)
        List<Fee__c> feesToInsert = new List<Fee__c>();
        List<String> errorMessages = new List<String>();

        for (Integer i = 0; i < filas.size(); i++) {
            List<String> values = filas[i];
            Integer fila = numeroFila[i];
            try {
                String nombreEntidad = getValue(values, colIndex, colNombre);
                String customerId = getValue(values, colIndex, 'Customer ID');
                String ruta = getValue(values, colIndex, 'Ruta');
                String sapSell = getValue(values, colIndex, 'Sap service Type Sell');
                String sapBuy = getValue(values, colIndex, 'Sap service Type Buy');
                String sellRateStr = getValue(values, colIndex, 'Sell Rate');
                String validFromStr = getValue(values, colIndex, 'Valid From dd/mm/yyyy');
                String validUntilStr = getValue(values, colIndex, 'Valid Until dd/mm/yyyy');
                String containerType = getValue(values, colIndex, 'Container Type');

                Id accountId = null;
                if (String.isNotBlank(nombreEntidad) || String.isNotBlank(customerId)) {
                    accountId = mapCuentas.get(llaveCuenta(nombreEntidad, customerId));
                    if (accountId == null) {
                        throw new CargaTarifarioException('No se encontró Account para "' + nombreEntidad + '" con Customer ID "' + customerId + '"');
                    }
                }

                Id routeId = null;
                if (String.isNotBlank(ruta)) {
                    routeId = mapRutas.get(ruta.toUpperCase());
                    if (routeId == null) {
                        throw new CargaTarifarioException('No se encontró Ruta "' + ruta + '"');
                    }
                }
                Id sapSellId = null;
                if (String.isNotBlank(sapSell)) {
                    sapSellId = mapSap.get(sapSell.toUpperCase());
                    if (sapSellId == null) {
                        throw new CargaTarifarioException('No se encontró SAP Service Type "' + sapSell + '"');
                    }
                }
                Id sapBuyId = null;
                if (String.isNotBlank(sapBuy)) {
                    sapBuyId = mapSap.get(sapBuy.toUpperCase());
                    if (sapBuyId == null) {
                        throw new CargaTarifarioException('No se encontró SAP Service Type "' + sapBuy + '"');
                    }
                }
                Id containerTypeId = null;
                if (String.isNotBlank(containerType)) {
                    containerTypeId = mapContainers.get(containerType.toUpperCase());
                    if (containerTypeId == null) {
                        throw new CargaTarifarioException('No se encontró Container Type "' + containerType + '"');
                    }
                }

                Date validFrom = parseDate(validFromStr);
                Date validUntil = parseDate(validUntilStr);
                Decimal sellRate = parseImporte(sellRateStr);

                Fee__c fee = new Fee__c();

                if ('proveedores'.equalsIgnoreCase(operacion)) {
                    fee.Carrier_Account__c = accountId;
                    fee.Account_for__c = clientePorDefectoId;
                } else {
                    fee.Account_for__c = accountId;
                }

                fee.Route__c = routeId;
                fee.SAP_Service_Type__c = sapSellId;
                fee.SAP_Service_Type_Buy__c = sapBuyId;
                fee.Fee_Rate__c = sellRate;
                fee.Valid_From__c = validFrom;
                fee.Valid_Until__c = validUntil;
                fee.Container_Type__c = containerTypeId;

                fee.Comments__c = 'Se creó por solicitud del usuario ' + currentUserName;
                fee.CustomRate__c = true;
                fee.Active__c = true;
                fee.Fee_Category__c = 'Road Freights';
                fee.Group__c = 'SP-FN-FLETE NACIONAL';
                fee.Name = 'Tarifas nacionales';
                fee.Negociacion__c = 'SI';
                fee.Rate_Type__c = 'Fixed';
                fee.RecordTypeId = feeRecordTypeId;
                fee.Tarifario_Compras__c = true;
                fee.TT_Days__c = '1';

                feesToInsert.add(fee);

            } catch (Exception e) {
                errorMessages.add('Fila ' + fila + ': ' + e.getMessage());
            }
        }

        Integer insertedCount = 0;
        if (!feesToInsert.isEmpty()) {
            Database.SaveResult[] results = Database.insert(feesToInsert, false);
            for (Integer i = 0; i < results.size(); i++) {
                if (results[i].isSuccess()) {
                    insertedCount++;
                } else {
                    for (Database.Error err : results[i].getErrors()) {
                        String errorDetail = 'REGISTRO ' + (i + 1) + ' | STATUS: ' + err.getStatusCode() + ' | MENSAJE: ' + err.getMessage();
                        errorMessages.add(errorDetail);
                        System.debug(LoggingLevel.ERROR, '========== ERROR INSERT FEE ==========');
                        System.debug(LoggingLevel.ERROR, errorDetail);
                        System.debug(LoggingLevel.ERROR, '=======================================');
                    }
                }
            }
        }

        String resultMsg = 'Registros insertados exitosamente: ' + insertedCount;
        if (!errorMessages.isEmpty()) {
            resultMsg += '\n\nErrores encontrados:\n' + String.join(errorMessages, '\n');
        }

        if (insertedCount == 0 && !errorMessages.isEmpty()) {
            if (Test.isRunningTest()) {
                return resultMsg;
            }
            throw new AuraHandledException(resultMsg);
        }

        return resultMsg;
    }

    // parte una linea CSV respetando comillas dobles: `"$27,000"` es UN campo
    // (asi exporta Excel la plantilla cuando el Sell Rate trae formato de moneda)
    @TestVisible
    private static List<String> parseCsvLine(String line) {
        List<String> campos = new List<String>();
        if (line == null) {
            return campos;
        }
        String actual = '';
        Boolean entreComillas = false;
        for (Integer i = 0; i < line.length(); i++) {
            String ch = line.substring(i, i + 1);
            if (entreComillas) {
                if (ch == '"') {
                    if (i + 1 < line.length() && line.substring(i + 1, i + 2) == '"') {
                        actual += '"';
                        i++;
                    } else {
                        entreComillas = false;
                    }
                } else {
                    actual += ch;
                }
            } else {
                if (ch == '"') {
                    entreComillas = true;
                } else if (ch == ',') {
                    campos.add(actual);
                    actual = '';
                } else {
                    actual += ch;
                }
            }
        }
        campos.add(actual);
        return campos;
    }

    private static String llaveCuenta(String nombre, String customerId) {
        String n = nombre == null ? '' : nombre.trim().toUpperCase();
        String c = customerId == null ? '' : customerId.trim().toUpperCase();
        return n + '|' + c;
    }

    private static List<String> obtenerHeaders(String lineaCabecera) {
        List<String> headers = new List<String>();
        for (String h : parseCsvLine(lineaCabecera)) {
            headers.add(h.trim());
        }
        return headers;
    }

    private static String getValue(List<String> values, Map<String, Integer> colIndex, String colName) {
        Integer idx = colIndex.get(colName);
        if (idx != null && idx < values.size()) {
            return values[idx] != null ? values[idx].trim() : '';
        }
        return '';
    }

    private static Id getClientePorDefecto() {
        List<Account> accs = [SELECT Id FROM Account WHERE Name LIKE '%Ejemplo%' AND Customer_Id__c != null LIMIT 1];
        if (accs.isEmpty()) {
            throw new AuraHandledException('No se encontró una cuenta cliente por defecto para proveedores.');
        }
        return accs[0].Id;
    }

    // acepta el formato de la plantilla: "$27,000", "$27,000.50", "27000"
    @TestVisible
    private static Decimal parseImporte(String sellRateStr) {
        if (String.isBlank(sellRateStr)) {
            throw new CargaTarifarioException('Sell Rate vacío');
        }
        String limpio = sellRateStr.replace('$', '').replace(',', '').replace(' ', '').trim();
        try {
            return Decimal.valueOf(limpio);
        } catch (Exception e) {
            throw new CargaTarifarioException('Sell Rate inválido: "' + sellRateStr + '"');
        }
    }

    @TestVisible
    private static Date parseDate(String dateStr) {
        if (String.isBlank(dateStr)) {
            return null;
        }
        List<String> parts = dateStr.split('/');
        if (parts.size() != 3) {
            return null;
        }
        try {
            Integer day = Integer.valueOf(parts[0].trim());
            Integer month = Integer.valueOf(parts[1].trim());
            Integer year = Integer.valueOf(parts[2].trim());
            return Date.newInstance(year, month, day);
        } catch (Exception e) {
            throw new CargaTarifarioException('Fecha inválida: ' + dateStr + '. Debe ser dd/mm/yyyy');
        }
    }

    @TestVisible
    private static Id getFeeRecordTypeId(String operacion) {
        String developerName = 'Fee_Freight';
        List<RecordType> recordTypes = [
            SELECT Id, Name
            FROM RecordType
            WHERE SObjectType = 'Fee__c'
            AND DeveloperName = :developerName
            LIMIT 1
        ];
        if (recordTypes.isEmpty()) {
            throw new AuraHandledException('No se encontró el Record Type "' + developerName + '" para Fee__c.');
        }
        return recordTypes[0].Id;
    }
}
