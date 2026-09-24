//AGE
global with sharing class PAKCargaProductosController {

    // normaliza para comparar: minusculas, sin acentos, sin espacios sobrantes.
    // El catalogo guarda 'Azcapotzalco'/'Nuevo Leon' y los archivos traen
    // 'AZCAPOTZALCO'/'Nuevo León': la SOQL no distingue mayusculas pero el map de
    // Apex si, y por eso se rechazaban ciudades que si existen.
    @TestVisible
    private static String normaliza(String texto) {
        if (texto == null) return '';
        String t = texto.trim().toLowerCase();
        t = t.replaceAll('[áàäâã]', 'a').replaceAll('[éèëê]', 'e').replaceAll('[íìïî]', 'i')
             .replaceAll('[óòöôõ]', 'o').replaceAll('[úùüû]', 'u').replaceAll('ñ', 'n');
        return t;
    }

    // normaliza + sin puntuacion (parentesis, comas) ni espacios dobles: para sugerencias
    @TestVisible
    private static String limpia(String texto) {
        String t = normaliza(texto);
        t = t.replaceAll('[^a-z0-9 ]', ' ').replaceAll(' +', ' ').trim();
        return t;
    }

    private static String claveCiudad(String ciudad, String estado, String pais) {
        return normaliza(ciudad) + '|' + normaliza(estado) + '|' + normaliza(pais);
    }

    private static final String P_VACIO = 'La celda está vacía';
    private static final String P_NO_CIUDAD = 'No existe en el catálogo de ciudades';
    private static final String P_NO_ESTADO = 'No existe en el catálogo de estados';
    private static final String P_NO_PAIS = 'No existe en el catálogo de países';
    private static final String P_COMBINACION = 'La ciudad existe pero no en ese estado/país';
    private static final String P_NO_NUMERO = 'No es un número válido';
    private static final Integer MAX_VALORES_SUGERIR = 25;

    // un problema de una celda del archivo; se juntan TODOS y no se carga nada
    public class ErrorCarga {
        @AuraEnabled public Integer renglon;
        @AuraEnabled public String columna;
        @AuraEnabled public String valor;
        @AuraEnabled public String problema;
        @AuraEnabled public String sugerencia;
        public ErrorCarga(Integer renglon, String columna, String valor, String problema) {
            this.renglon = renglon;
            this.columna = columna;
            this.valor = valor == null ? '' : valor;
            this.problema = problema;
            this.sugerencia = '';
        }
    }

    public class csvProducts{
        public string paisOrigen	{get;set;}
        public string estadoOrigen	{get;set;}
        public string ciudadOrigen	{get;set;}
        public string paisDestino	{get;set;}
        public string estadoDestino	{get;set;}
        public string ciudadDestino	{get;set;}
        public decimal cantidad {get;set;}
        public string frecuencia	{get;set;}
        public string modalidad	{get;set;}
        public string unidadPorFrecuencia	 {get;set;}
        public string tipoDeMercancia	{get;set;}
        public decimal pesoDeCarga	{get;set;}
        public integer tiempoDeCarga	{get;set;}
        public integer tiempoDeDescarga {get;set;}
        public string direccionDeCarga{get;set;}
        public string direccionDeDescarga {get;set;}
    }

    @AuraEnabled
    public static string cargarTarifario(string jsn, string idOpportunity){
        System.debug('el jsn que llega es: '+jsn);
        Savepoint sp = Database.setSavepoint();
        try{
            // deserializacion sin tipo: un numero invalido en una celda se reporta con
            // renglon y columna, en vez de tumbar el archivo entero con una excepcion
            List<Object> crudos = (List<Object>) JSON.deserializeUntyped(jsn);
            if(crudos.isEmpty()){
                return 'No se encontraron líneas en el documento';
            }
            List<ErrorCarga> errores = new List<ErrorCarga>();
            List<csvProducts> lines = new List<csvProducts>();
            //celdas numericas que ya fallaron el parseo, para no doblar con "vacía"
            Map<Integer, Set<String>> celdasNumericasMalas = new Map<Integer, Set<String>>();
            //renglones totalmente vacios: UN solo error y no 12 de celda vacia
            Set<Integer> renglonesVacios = new Set<Integer>();
            Integer renglon = 2;
            for (Object crudo : crudos) {
                Map<String, Object> celdas = (Map<String, Object>) crudo;
                Boolean renglonVacio = true;
                for (Object v : celdas.values()) {
                    if (v != null && String.valueOf(v).trim() != '') { renglonVacio = false; break; }
                }
                if (renglonVacio) {
                    errores.add(new ErrorCarga(renglon, '(todo el renglón)', '', 'El renglón está vacío: bórralo del archivo o llénalo'));
                    renglonesVacios.add(renglon);
                    lines.add(new csvProducts());
                    renglon++;
                    continue;
                }
                csvProducts l = new csvProducts();
                l.paisOrigen = texto(celdas, 'paisOrigen');
                l.estadoOrigen = texto(celdas, 'estadoOrigen');
                l.ciudadOrigen = texto(celdas, 'ciudadOrigen');
                l.paisDestino = texto(celdas, 'paisDestino');
                l.estadoDestino = texto(celdas, 'estadoDestino');
                l.ciudadDestino = texto(celdas, 'ciudadDestino');
                l.frecuencia = texto(celdas, 'frecuencia');
                l.modalidad = texto(celdas, 'modalidad');
                l.unidadPorFrecuencia = texto(celdas, 'unidadPorFrecuencia');
                l.tipoDeMercancia = texto(celdas, 'tipoDeMercancia');
                l.direccionDeCarga = texto(celdas, 'direccionDeCarga');
                l.direccionDeDescarga = texto(celdas, 'direccionDeDescarga');
                l.cantidad = numeroDecimal(celdas, 'cantidad', renglon, errores, celdasNumericasMalas);
                l.pesoDeCarga = numeroDecimal(celdas, 'pesoDeCarga', renglon, errores, celdasNumericasMalas);
                l.tiempoDeCarga = numeroEntero(celdas, 'tiempoDeCarga', renglon, errores, celdasNumericasMalas);
                l.tiempoDeDescarga = numeroEntero(celdas, 'tiempoDeDescarga', renglon, errores, celdasNumericasMalas);
                lines.add(l);
                renglon++;
            }

            Map<string,id> paises = new Map<string,id>();
            Map<string,id> estados = new Map<string,id>();
            List<P2G_loadProducts.csvProduct> loadProducts = new List<P2G_loadProducts.csvProduct>();
            String origenId;
            String destinoId;

            Opportunity opp = [SELECT Id, Name, Pricebook2Id,CurrencyIsoCode FROM Opportunity where id =: idOpportunity limit 1 ];

            //PICKLIST
            Schema.sObjectType objType = OpportunityLineItem.getSObjectType();  // Get the object type of the SObject.
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); // Describe the SObject using its object type.
            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();     // Get a map of fields for the SObject
            Map<string,string> options = new Map<string,string>();
            list<Schema.PicklistEntry> values = fieldMap.get('PROJ_Frecuencia__c').getDescribe().getPickListValues(); // Get the list of picklist values for this field.

            // Add these values to the selectoption list.
            //tambien normalizada -> valor oficial del picklist: 'diario' o 'DIARIO'
            //valen y se guarda la escritura oficial (igual que las ciudades)
            Map<string,string> frecuenciaPorNormalizada = new Map<string,string>();
            for (Schema.PicklistEntry a : values){
                options.put( a.getValue(),a.getLabel());
                frecuenciaPorNormalizada.put(normaliza(a.getValue()), a.getValue());
            }

            //PICKLIST
            Schema.sObjectType objTypeProd = Product2.getSObjectType();  // Get the object type of the SObject.
            Schema.DescribeSObjectResult objDescribeProd = objTypeProd.getDescribe(); // Describe the SObject using its object type.
            map<String, Schema.SObjectField> fieldMapProd = objDescribeProd.fields.getMap();     // Get a map of fields for the SObject
            Map<string,string> optionsProd = new Map<string,string>();
            list<Schema.PicklistEntry> valuesProd = fieldMapProd.get('PROJ_Modalidad__c').getDescribe().getPickListValues(); // Get the list of picklist values for this field.

            // Add these values to the selectoption list.
            Map<string,string> modalidadPorNormalizada = new Map<string,string>();
            for (Schema.PicklistEntry a : valuesProd){
                optionsProd.put( a.getValue(),a.getLabel());
                modalidadPorNormalizada.put(normaliza(a.getValue()), a.getValue());
            }

            //PRODUCTOS
            //la SOQL es insensible a mayusculas pero NO a acentos: se consulta
            //tambien la variante sin acentos de cada ciudad del archivo
            Set<string> ciudadesName = new set<string>();
            for(csvProducts l : lines){
                if (String.isNotBlank(l.ciudadOrigen)) {
                    ciudadesName.add(l.ciudadOrigen.trim());
                    ciudadesName.add(normaliza(l.ciudadOrigen));
                }
                if (String.isNotBlank(l.ciudadDestino)) {
                    ciudadesName.add(l.ciudadDestino.trim());
                    ciudadesName.add(normaliza(l.ciudadDestino));
                }
            }
            //sin filtro por estado: un estado acentuado en el archivo dejaba fuera
            //ciudades legitimas; el estado y el pais se validan contra sus catalogos
            List<Location__c> locationRecords = [SELECT Id, Name, State__c, State__r.Name, Country__c, Country__r.Name FROM Location__c WHERE Name IN :ciudadesName LIMIT 49000];
            //mapa por llave compuesta ciudad|estado|pais: dos ciudades homonimas
            //("Santa Catarina" existe en 3 estados) ya no se pisan entre si
            Map<String, Location__c> ciudadesPorClave = new Map<String, Location__c>();
            Set<String> ciudadesExistentes = new Set<String>();
            //por nombre: para sugerir el estado correcto cuando la combinacion no cuadra
            Map<String, List<Location__c>> ciudadesPorNombre = new Map<String, List<Location__c>>();
            for (Location__c a : locationRecords) {
                indexaUbicacion(a, ciudadesPorClave, ciudadesExistentes, ciudadesPorNombre);
            }
            //segunda oportunidad SOLO para lo no hallado: catalogo ACENTUADO vs
            //archivo sin acento (desde 'Merida' no se puede generar 'Mérida'): se
            //busca con comodin '_' en cada vocal y se confirma normalizado en Apex
            Set<String> ciudadesSinHallar = new Set<String>();
            for (csvProducts l : lines) {
                if (String.isNotBlank(l.ciudadOrigen) && !ciudadesExistentes.contains(normaliza(l.ciudadOrigen))) ciudadesSinHallar.add(l.ciudadOrigen.trim());
                if (String.isNotBlank(l.ciudadDestino) && !ciudadesExistentes.contains(normaliza(l.ciudadDestino))) ciudadesSinHallar.add(l.ciudadDestino.trim());
            }
            if (!ciudadesSinHallar.isEmpty()) {
                Set<String> objetivoNormalizado = new Set<String>();
                List<String> filtrosVocal = new List<String>();
                for (String v : ciudadesSinHallar) {
                    objetivoNormalizado.add(normaliza(v));
                    filtrosVocal.add('Name LIKE \'' + String.escapeSingleQuotes(patronVocalComodin(v)) + '\'');
                    if (filtrosVocal.size() >= 50) break;
                }
                for (Location__c a : Database.query('SELECT Id, Name, State__c, State__r.Name, Country__c, Country__r.Name FROM Location__c WHERE ' + String.join(filtrosVocal, ' OR ') + ' LIMIT 2000')) {
                    //el comodin '_' no distingue letras: confirmar normalizado
                    if (!objetivoNormalizado.contains(normaliza(a.Name))) continue;
                    indexaUbicacion(a, ciudadesPorClave, ciudadesExistentes, ciudadesPorNombre);
                }
            }
            //estados y paises contra su catalogo real (son chicos), no contra lo que
            //casualmente regreso la consulta de ciudades: un archivo con las ciudades
            //mal escritas marcaba tambien estado y pais buenos como inexistentes
            Set<String> estadosExistentes = new Set<String>();
            List<State__c> estadosCatalogo = [SELECT Name, Country__r.Name FROM State__c LIMIT 2000];
            for (State__c s : estadosCatalogo) {
                estadosExistentes.add(normaliza(s.Name));
            }
            Set<String> paisesExistentes = new Set<String>();
            List<Country__c> paisesCatalogo = [SELECT Name FROM Country__c LIMIT 1000];
            for (Country__c p : paisesCatalogo) {
                paisesExistentes.add(normaliza(p.Name));
            }

            //valores validos para sugerir en errores de picklist
            String frecuenciasValidas = recorta('Valores válidos: ' + String.join(new List<String>(options.keySet()), ', '));
            String modalidadesValidas = recorta('Valores válidos: ' + String.join(new List<String>(optionsProd.keySet()), ', '));

            //los paises que el archivo trae bien: acotan las sugerencias de estado
            //(el catalogo State__c mezcla Mexico y USA: sin esto, VER sugeria Vermont)
            Set<String> paisesValidosArchivo = new Set<String>();
            renglon = 2;
            for(csvProducts l : lines){
                //un renglon vacio ya tiene su unico error; no validar sus celdas
                if (renglonesVacios.contains(renglon)) {
                    renglon++;
                    continue;
                }
                //validaciones: se ACUMULAN todos los errores del archivo (antes se
                //detenia en el primero); la carga sigue siendo todo-o-nada
                Integer erroresAntes = errores.size();
                Boolean okPaisO = validaLugar(l.paisOrigen, paisesExistentes, renglon, 'paisOrigen', P_NO_PAIS, errores);
                if (okPaisO) paisesValidosArchivo.add(normaliza(l.paisOrigen));
                Boolean okEstadoO = validaLugar(l.estadoOrigen, estadosExistentes, renglon, 'estadoOrigen', P_NO_ESTADO, errores);
                Boolean okCiudadO = validaLugar(l.ciudadOrigen, ciudadesExistentes, renglon, 'ciudadOrigen', P_NO_CIUDAD, errores);
                Boolean okPaisD = validaLugar(l.paisDestino, paisesExistentes, renglon, 'paisDestino', P_NO_PAIS, errores);
                if (okPaisD) paisesValidosArchivo.add(normaliza(l.paisDestino));
                Boolean okEstadoD = validaLugar(l.estadoDestino, estadosExistentes, renglon, 'estadoDestino', P_NO_ESTADO, errores);
                Boolean okCiudadD = validaLugar(l.ciudadDestino, ciudadesExistentes, renglon, 'ciudadDestino', P_NO_CIUDAD, errores);
                //numericos requeridos: antes un vacío aquí tumbaba el archivo entero
                //con la excepción cruda del deserializador
                for (String campoNum : new List<String>{'cantidad', 'pesoDeCarga', 'tiempoDeCarga', 'tiempoDeDescarga'}) {
                    Boolean vacio = (campoNum == 'cantidad' && l.cantidad == null)
                        || (campoNum == 'pesoDeCarga' && l.pesoDeCarga == null)
                        || (campoNum == 'tiempoDeCarga' && l.tiempoDeCarga == null)
                        || (campoNum == 'tiempoDeDescarga' && l.tiempoDeDescarga == null);
                    Boolean yaFallo = celdasNumericasMalas.containsKey(renglon) && celdasNumericasMalas.get(renglon).contains(campoNum);
                    if (vacio && !yaFallo) {
                        errores.add(new ErrorCarga(renglon, campoNum, '', P_VACIO));
                    }
                }
                String frecuenciaOficial = String.isBlank(l.frecuencia) ? null : frecuenciaPorNormalizada.get(normaliza(l.frecuencia));
                if(frecuenciaOficial == null){
                    ErrorCarga e = new ErrorCarga(renglon, 'frecuencia', l.frecuencia,
                        String.isBlank(l.frecuencia) ? P_VACIO : 'Frecuencia inválida');
                    e.sugerencia = frecuenciasValidas;
                    errores.add(e);
                } else {
                    l.frecuencia = frecuenciaOficial;
                }
                String modalidadOficial = String.isBlank(l.modalidad) ? null : modalidadPorNormalizada.get(normaliza(l.modalidad));
                if(modalidadOficial == null){
                    ErrorCarga e = new ErrorCarga(renglon, 'modalidad', l.modalidad,
                        String.isBlank(l.modalidad) ? P_VACIO : 'Modalidad inválida');
                    e.sugerencia = modalidadesValidas;
                    errores.add(e);
                } else {
                    l.modalidad = modalidadOficial;
                }
                //matching compuesto ciudad+estado+pais, solo si las tres partes existen
                Location__c locOrigen;
                Location__c locDestino;
                if (okPaisO && okEstadoO && okCiudadO) {
                    locOrigen = ciudadesPorClave.get(claveCiudad(l.ciudadOrigen, l.estadoOrigen, l.paisOrigen));
                    if (locOrigen == null) {
                        errores.add(errorCombinacion(renglon, 'ciudadOrigen', l.ciudadOrigen, l.estadoOrigen, ciudadesPorNombre));
                    }
                }
                if (okPaisD && okEstadoD && okCiudadD) {
                    locDestino = ciudadesPorClave.get(claveCiudad(l.ciudadDestino, l.estadoDestino, l.paisDestino));
                    if (locDestino == null) {
                        errores.add(errorCombinacion(renglon, 'ciudadDestino', l.ciudadDestino, l.estadoDestino, ciudadesPorNombre));
                    }
                }
                if (errores.size() == erroresAntes) {
                    origenId = locOrigen.Id;
                    destinoId = locDestino.Id;
                    //usar la escritura OFICIAL del catalogo (no la del archivo) para que
                    //"MONTERREY - SALTILLO" y "Monterrey - Saltillo" no dupliquen productos
                    l.ciudadOrigen = locOrigen.Name;
                    l.ciudadDestino = locDestino.Name;
                    //cambio de wrapper para la clase P2G_loadProductsCsv
                    P2G_loadProducts.csvProduct csvLoadProducts = csvLoadProducts(l, origenId, destinoId);
                    loadProducts.add(csvLoadProducts);
                }
                renglon++;
            }

            if (!errores.isEmpty()) {
                //TODO O NADA: con cualquier error no se carga ningun renglon (sin
                //control de duplicados una carga parcial + reintento duplicaria)
                agregaSugerencias(errores, estadosCatalogo, paisesCatalogo, paisesValidosArchivo);
                return JSON.serialize(new Map<String, Object>{
                    'status' => 'errores',
                    'total' => errores.size(),
                    'errores' => errores
                });
            }

            System.debug('lista de load Products: '+loadProducts);
            String json = JSON.serialize(loadProducts);
            P2G_loadProductsCsv.handleProduct(idOpportunity,json,opp.CurrencyIsoCode);
            return 'ok';
        }
        catch(Exception e){
            Database.rollback(sp);
            System.debug('EXSDDSFSF: ' +  e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString()); return e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString();
        }
    }

    private static String texto(Map<String, Object> celdas, String campo) {
        Object v = celdas.get(campo);
        if (v == null) return null;
        String s = String.valueOf(v).trim();
        return s == '' ? null : s;
    }

    // acepta numero JSON o texto; "18,000" del Excel tambien; si no parsea, ERROR con
    // renglon y columna (antes una sola celda asi tumbaba el archivo completo)
    private static Decimal numeroDecimal(Map<String, Object> celdas, String campo, Integer renglon, List<ErrorCarga> errores, Map<Integer, Set<String>> celdasNumericasMalas) {
        Object v = celdas.get(campo);
        if (v == null) return null;
        if (v instanceof Decimal) return (Decimal) v;
        if (v instanceof Integer) return Decimal.valueOf((Integer) v);
        if (v instanceof Long) return Decimal.valueOf((Long) v);
        String s = String.valueOf(v).trim();
        if (s == '') return null;
        try {
            return Decimal.valueOf(s.replace(',', ''));
        } catch (Exception e) {
            errores.add(new ErrorCarga(renglon, campo, s, P_NO_NUMERO));
            if (!celdasNumericasMalas.containsKey(renglon)) {
                celdasNumericasMalas.put(renglon, new Set<String>());
            }
            celdasNumericasMalas.get(renglon).add(campo);
            return null;
        }
    }

    //los tiempos van a Integer: '2.5' se truncaba en silencio y 3,000,000,000
    //desbordaba; ahora son error con renglon y columna
    private static Integer numeroEntero(Map<String, Object> celdas, String campo, Integer renglon, List<ErrorCarga> errores, Map<Integer, Set<String>> celdasNumericasMalas) {
        Decimal d = numeroDecimal(celdas, campo, renglon, errores, celdasNumericasMalas);
        if (d == null) return null;
        String problema;
        if (d.stripTrailingZeros().scale() > 0) {
            problema = 'Debe ser un número entero';
        } else if (d < -2147483648L || d > 2147483647L) {
            problema = 'Número fuera de rango';
        }
        if (problema != null) {
            errores.add(new ErrorCarga(renglon, campo, String.valueOf(d), problema));
            if (!celdasNumericasMalas.containsKey(renglon)) {
                celdasNumericasMalas.put(renglon, new Set<String>());
            }
            celdasNumericasMalas.get(renglon).add(campo);
            return null;
        }
        return d.intValue();
    }

    private static Boolean validaLugar(String valor, Set<String> existentes, Integer renglon, String columna, String problema, List<ErrorCarga> errores) {
        if (String.isBlank(valor)) {
            errores.add(new ErrorCarga(renglon, columna, '', P_VACIO));
            return false;
        }
        if (!existentes.contains(normaliza(valor))) {
            errores.add(new ErrorCarga(renglon, columna, valor, problema));
            return false;
        }
        return true;
    }

    //guardias de null: el catalogo legado tiene ubicaciones sin estado o pais
    //("ALTAMIRA" sin estado) y una homonima sucia tumbaba TODO con NPE
    private static void indexaUbicacion(Location__c a, Map<String, Location__c> ciudadesPorClave, Set<String> ciudadesExistentes, Map<String, List<Location__c>> ciudadesPorNombre) {
        String estadoDeA = a.State__r == null ? '' : a.State__r.Name;
        String paisDeA = a.Country__r == null ? '' : a.Country__r.Name;
        String clave = claveCiudad(a.Name, estadoDeA, paisDeA);
        if (!ciudadesPorClave.containsKey(clave)) {
            ciudadesPorClave.put(clave, a);
        }
        String porNombre = normaliza(a.Name);
        ciudadesExistentes.add(porNombre);
        if (!ciudadesPorNombre.containsKey(porNombre)) {
            ciudadesPorNombre.put(porNombre, new List<Location__c>());
        }
        ciudadesPorNombre.get(porNombre).add(a);
    }

    //cada vocal se vuelve comodin de un caracter: 'MERIDA' -> 'm_r_d_' matchea
    //'Mérida' y 'Merida' bajo LIKE (insensible a mayusculas, sensible a acentos)
    private static String patronVocalComodin(String valor) {
        String v = valor.trim().toLowerCase();
        String patron = '';
        for (Integer i = 0; i < v.length(); i++) {
            String c = v.substring(i, i + 1);
            if ('aeiouáéíóúàèìòùäëïöüâêîôûãõ'.contains(c) || c == '%' || c == '_') {
                patron += '_';
            } else {
                patron += c;
            }
        }
        return patron;
    }

    private static ErrorCarga errorCombinacion(Integer renglon, String columna, String ciudad, String estado, Map<String, List<Location__c>> ciudadesPorNombre) {
        ErrorCarga e = new ErrorCarga(renglon, columna, ciudad, P_COMBINACION);
        List<Location__c> homonimas = ciudadesPorNombre.get(normaliza(ciudad));
        if (homonimas != null) {
            Set<String> estadosReales = new Set<String>();
            for (Location__c h : homonimas) {
                if (h.State__r != null && String.isNotBlank(h.State__r.Name)) {
                    estadosReales.add(h.State__r.Name);
                }
                if (estadosReales.size() >= 4) break;
            }
            if (!estadosReales.isEmpty()) {
                e.sugerencia = '\'' + ciudad + '\' existe en: ' + String.join(new List<String>(estadosReales), ', ') + '. Revisa el estado.';
            }
        }
        return e;
    }

    private static String recorta(String texto) {
        return texto.length() > 180 ? texto.substring(0, 180) + '…' : texto;
    }

    // sugerencias de "quiza quisiste decir": SOLO en la ruta de error. Las ciudades
    // salen de una consulta acotada por LIKE de tokens (el catalogo de Produ tiene
    // 35k filas: traerlo entero reventaria el heap); estados y paises reusan los
    // catalogos ya consultados. Es mejor-esfuerzo: sin candidato cercano, va vacio.
    private static void agregaSugerencias(List<ErrorCarga> errores, List<State__c> estadosCatalogo, List<Country__c> paisesCatalogo, Set<String> paisesValidosArchivo) {
        try {
            Set<String> ciudadesDesconocidas = new Set<String>();
            Set<String> estadosDesconocidos = new Set<String>();
            Set<String> paisesDesconocidos = new Set<String>();
            for (ErrorCarga e : errores) {
                if (e.problema == P_NO_CIUDAD && ciudadesDesconocidas.size() < MAX_VALORES_SUGERIR) ciudadesDesconocidas.add(e.valor);
                if (e.problema == P_NO_ESTADO && estadosDesconocidos.size() < MAX_VALORES_SUGERIR) estadosDesconocidos.add(e.valor);
                if (e.problema == P_NO_PAIS && paisesDesconocidos.size() < MAX_VALORES_SUGERIR) paisesDesconocidos.add(e.valor);
            }

            Map<String, String> sugerenciaCiudad = new Map<String, String>();
            if (!ciudadesDesconocidas.isEmpty()) {
                Map<String, Location__c> candidatos = candidatosCiudad(ciudadesDesconocidas);
                //el mapa generico se arma UNA vez, no en cada llamada (eran hasta
                //4000 puts por valor desconocido)
                Map<String, Object> candidatosGenerico = new Map<String, Object>();
                for (String k : candidatos.keySet()) candidatosGenerico.put(k, candidatos.get(k));
                for (String valor : ciudadesDesconocidas) {
                    Location__c mejor = (Location__c) mejorCandidato(valor, candidatosGenerico);
                    if (mejor != null) {
                        String estado = mejor.State__r == null ? '' : mejor.State__r.Name;
                        sugerenciaCiudad.put(valor, '¿Será \'' + mejor.Name + '\'' + (String.isBlank(estado) ? '' : ' (' + estado + ')') + '?');
                    }
                }
            }
            Map<String, String> sugerenciaEstado = new Map<String, String>();
            if (!estadosDesconocidos.isEmpty()) {
                //solo estados de los paises que el archivo trae bien: sin este
                //filtro, VER sugeria Vermont y MICH Michigan (catalogo con USA)
                Map<String, Object> porNombre = new Map<String, Object>();
                for (State__c s : estadosCatalogo) {
                    String paisDelEstado = s.Country__r == null ? '' : normaliza(s.Country__r.Name);
                    //pais en blanco se queda: 'Edo. Mexico' no tiene pais en el catalogo
                    if (paisesValidosArchivo.isEmpty() || String.isBlank(paisDelEstado) || paisesValidosArchivo.contains(paisDelEstado)) {
                        porNombre.put(limpia(s.Name), s.Name);
                    }
                }
                for (String valor : estadosDesconocidos) {
                    Object mejor = mejorCandidato(valor, porNombre);
                    if (mejor != null) sugerenciaEstado.put(valor, '¿Será \'' + (String) mejor + '\'?');
                }
            }
            Map<String, String> sugerenciaPais = new Map<String, String>();
            if (!paisesDesconocidos.isEmpty()) {
                Map<String, Object> porNombre = new Map<String, Object>();
                for (Country__c p : paisesCatalogo) porNombre.put(limpia(p.Name), p.Name);
                for (String valor : paisesDesconocidos) {
                    Object mejor = mejorCandidato(valor, porNombre);
                    if (mejor != null) sugerenciaPais.put(valor, '¿Será \'' + (String) mejor + '\'?');
                }
            }

            for (ErrorCarga e : errores) {
                if (String.isNotBlank(e.sugerencia)) continue;
                if (e.problema == P_NO_CIUDAD && sugerenciaCiudad.containsKey(e.valor)) e.sugerencia = sugerenciaCiudad.get(e.valor);
                if (e.problema == P_NO_ESTADO && sugerenciaEstado.containsKey(e.valor)) e.sugerencia = sugerenciaEstado.get(e.valor);
                if (e.problema == P_NO_PAIS && sugerenciaPais.containsKey(e.valor)) e.sugerencia = sugerenciaPais.get(e.valor);
            }
        } catch (Exception ex) {
            //las sugerencias nunca deben tumbar el reporte de errores
            System.debug('agregaSugerencias fallo: ' + ex.getMessage());
        }
    }

    // candidatos acotados: LIKE por cada token (>=4 letras) y su prefijo, de cada
    // valor desconocido; deduplicados por nombre, prefiriendo los que tienen estado
    private static Map<String, Location__c> candidatosCiudad(Set<String> valoresDesconocidos) {
        Set<String> patrones = new Set<String>();
        for (String valor : valoresDesconocidos) {
            String lv = limpia(valor);
            Boolean tuvoToken = false;
            for (String tok : lv.split(' ')) {
                if (tok.length() >= 4) {
                    patrones.add('%' + tok + '%');
                    patrones.add(tok.substring(0, 3) + '%');
                    tuvoToken = true;
                }
            }
            if (!tuvoToken && lv.length() >= 3) {
                patrones.add('%' + lv + '%');
            }
            if (patrones.size() > 60) break;
        }
        Map<String, Location__c> unicos = new Map<String, Location__c>();
        if (patrones.isEmpty()) return unicos;
        List<String> filtros = new List<String>();
        for (String p : patrones) {
            filtros.add('Name LIKE \'' + String.escapeSingleQuotes(p) + '\'');
        }
        String q = 'SELECT Name, State__r.Name FROM Location__c WHERE (' + String.join(filtros, ' OR ') + ') LIMIT 4000';
        for (Location__c c : Database.query(q)) {
            String k = limpia(c.Name);
            Location__c previo = unicos.get(k);
            Boolean previoSinEstado = previo != null && (previo.State__r == null || String.isBlank(previo.State__r.Name));
            Boolean esteConEstado = c.State__r != null && String.isNotBlank(c.State__r.Name);
            if (previo == null || (previoSinEstado && esteConEstado)) {
                unicos.put(k, c);
            }
        }
        return unicos;
    }

    // el candidato mas parecido, por prioridad de regla:
    //   0 igualdad
    //   1 lo escrito es el INICIO o esta CONTENIDO en el candidato (CHIH->Chihuahua,
    //     EDOMEX->Edo. Mexico sin espacios, NAUCALPAN->Naucalpan de Juarez)
    //   2-4 error de dedo: Levenshtein 1-3 (Altamirra->Altamira, TUXLA->Tuxtla ...;
    //     mas de 3 NO sugiere: mejor nada que un disparate tipo Valentine,AZ)
    //   5 el candidato esta contenido en lo escrito (CHOLUL, MERIDA->Merida): la mas
    //     debil, para que 'San Jose' no le gane a 'San Jose Iturbide'
    // en empate gana el nombre mas corto
    private static Object mejorCandidato(String valor, Map<String, Object> candidatos) {
        String objetivo = limpia(valor);
        if (objetivo.length() < 3) return null;
        String objetivoSin = objetivo.replace(' ', '');
        Object mejor;
        Integer mejorDist = 999;
        Integer mejorLargo = 999;
        for (String k : candidatos.keySet()) {
            Integer d;
            String kSin = k.replace(' ', '');
            if (k == objetivo) {
                d = 0;
            } else if ((objetivoSin.length() >= 3 && kSin.startsWith(objetivoSin))
                    || (objetivo.length() >= 5 && k.contains(objetivo))) {
                d = 1;
            } else {
                Integer umbral = Math.max(2, (Integer) (Math.max(k.length(), objetivo.length()) * 0.4));
                Integer lev = -1;
                if (Math.abs(k.length() - objetivo.length()) <= umbral) {
                    lev = objetivo.getLevenshteinDistance(k, umbral);
                }
                if (lev >= 0 && lev <= 3) {
                    d = lev + 1;
                } else if (k.length() >= 5 && objetivo.contains(k)) {
                    d = 5;
                } else {
                    continue;
                }
            }
            //empate: en la regla 5 gana el nombre mas LARGO ('Los Mochis' sobre
            //'Ahome' para "LOS MOCHIS (AHOME)"); en las demas, el mas corto
            Boolean empateMejor = (d == mejorDist) && (d == 5 ? k.length() > mejorLargo : k.length() < mejorLargo);
            if (d < mejorDist || empateMejor) {
                mejorDist = d;
                mejorLargo = k.length();
                mejor = candidatos.get(k);
            }
        }
        return mejor;
    }

    public static P2G_loadProducts.csvProduct csvLoadProducts(csvProducts csv,String origenId, String destinoId){
        P2G_loadProducts.csvProduct product = new P2G_loadProducts.csvProduct();
        product.Name = csv.ciudadOrigen+' - '+csv.ciudadDestino;
        product.origen = csv.ciudadOrigen;
        product.destino = csv.ciudadDestino;
        product.origenId = origenId;
        product.destinoId = destinoId;
        product.cantidad = String.valueOF(csv.cantidad);
        product.pesoDeCarga = String.valueOF(csv.pesoDeCarga);
        product.unidadPorFrecuencia = csv.unidadPorFrecuencia;
        product.tipoMercancia = csv.tipoDeMercancia;
        product.frecuencia = csv.frecuencia;
        product.tiempoCarga = String.valueOF(csv.tiempoDeCarga);
        product.tiempoDescarga = String.valueOF(csv.tiempoDeDescarga);
        product.modalidad = csv.modalidad;
        product.direccionCarga = csv.direccionDeCarga;
        product.direccionDescarga = csv.direccionDeDescarga;
        product.buyPrice = '0';
        product.sellPrice = '0';

        return product;
    }
}
