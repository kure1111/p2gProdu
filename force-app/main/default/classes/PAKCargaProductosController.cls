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

    private static String claveCiudad(String ciudad, String estado, String pais) {
        return normaliza(ciudad) + '|' + normaliza(estado) + '|' + normaliza(pais);
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
            List<csvProducts> lines = (List<csvProducts>)JSON.deserialize(jsn, List<csvProducts>.class);
            System.debug('las lines son: '+lines);
            if(lines.size() > 0){
                Set<string> paisesName = new set<string>();
                Set<string> estadosName = new set<string>();
                Set<string> ciudadesName = new set<string>();
                Map<string,id> paises = new Map<string,id>();
                Map<string,id> estados = new Map<string,id>();
                Map<string,Location__c> ciudades = new Map<string,Location__c>();
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
                for (Schema.PicklistEntry a : values){ 
                    options.put( a.getValue(),a.getLabel()); 
                }
                
                //PICKLIST 
                Schema.sObjectType objTypeProd = Product2.getSObjectType();  // Get the object type of the SObject.
                Schema.DescribeSObjectResult objDescribeProd = objTypeProd.getDescribe(); // Describe the SObject using its object type.  
                map<String, Schema.SObjectField> fieldMapProd = objDescribeProd.fields.getMap();     // Get a map of fields for the SObject
                Map<string,string> optionsProd = new Map<string,string>();
                list<Schema.PicklistEntry> valuesProd = fieldMapProd.get('PROJ_Modalidad__c').getDescribe().getPickListValues(); // Get the list of picklist values for this field.
                
                // Add these values to the selectoption list.
                for (Schema.PicklistEntry a : valuesProd){ 
                    optionsProd.put( a.getValue(),a.getLabel()); 
                }
                //PRODUCTOS
                //la SOQL es insensible a mayusculas pero NO a acentos: se consulta
                //tambien la variante sin acentos de cada ciudad del archivo
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
                //ciudades legitimas; el estado y el pais se validan abajo, normalizados
                List<Location__c> locationRecords = [SELECT Id, Name, State__c, State__r.Name, Country__c, Country__r.Name FROM Location__c WHERE Name IN :ciudadesName LIMIT 49000];
                //mapa por llave compuesta ciudad|estado|pais: dos ciudades homonimas
                //("Santa Catarina" existe en 3 estados) ya no se pisan entre si
                Map<String, Location__c> ciudadesPorClave = new Map<String, Location__c>();
                Set<String> ciudadesExistentes = new Set<String>();
                Set<String> estadosExistentes = new Set<String>();
                Set<String> paisesExistentes = new Set<String>();
                for (Location__c a : locationRecords) {
                    String clave = claveCiudad(a.Name, a.State__r.Name, a.Country__r.Name);
                    if (!ciudadesPorClave.containsKey(clave)) {
                        ciudadesPorClave.put(clave, a);
                    }
                    ciudadesExistentes.add(normaliza(a.Name));
                    estadosExistentes.add(normaliza(a.State__r.Name));
                    paisesExistentes.add(normaliza(a.Country__r.Name));
                }
                
                integer renglon = 2;
                
                for(csvProducts l : lines){
                    //inician validaciones (comparaciones normalizadas: sin acentos ni mayusculas)
                    if(String.isBlank(l.paisOrigen) || !paisesExistentes.contains(normaliza(l.paisOrigen)) )
                        return 'Renglon ('+renglon+') : No se encontró país de origen ' + l.paisOrigen ;
                    if(String.isBlank(l.estadoOrigen) || !estadosExistentes.contains(normaliza(l.estadoOrigen)) )
                        return 'Renglon ('+renglon+') : No se encontró estado de origen ' + l.estadoOrigen;
                    if(String.isBlank(l.ciudadOrigen) || !ciudadesExistentes.contains(normaliza(l.ciudadOrigen)) )
                        return 'Renglon ('+renglon+') : No se encontró ciudad de origen ' +l.ciudadOrigen;
                    if(String.isBlank(l.paisDestino) || !paisesExistentes.contains(normaliza(l.paisDestino)) )
                        return 'Renglon ('+renglon+') : No se encontró país de destino ' + l.paisDestino;
                    if(String.isBlank(l.estadoDestino) || !estadosExistentes.contains(normaliza(l.estadoDestino)) ){
                        return 'Renglon ('+renglon+') : No se encontró estado de destino ' + l.estadoDestino;}
                    if(String.isBlank(l.ciudadDestino) || !ciudadesExistentes.contains(normaliza(l.ciudadDestino)) )
                        return 'Renglon ('+renglon+') : No se encontró ciudad de destino ' + l.ciudadDestino;
                    if(l.cantidad == null)
                        return  'Renglon ('+renglon+') : debe tener Cantidad';
                    
                    string frec =  options.get( l.frecuencia );                    
                    if(string.isBlank(frec))
                        return 'Renglon ('+renglon+') contiene una frecuencia invalida : ' + l.frecuencia;
                    
                    string modali =  optionsProd.get( l.modalidad );
                    if(string.isBlank(modali)){
                        return 'Renglon ('+renglon+') contiene una modalidad invalida : ' + l.modalidad;
                    }
                    //terminan validaciones
                    //sacar los Ids de origen y destino por llave compuesta ciudad+estado+pais
                    Location__c locOrigen = ciudadesPorClave.get(claveCiudad(l.ciudadOrigen, l.estadoOrigen, l.paisOrigen));
                    if(locOrigen != null){
                        origenId = locOrigen.Id;
                    }else{
                        return 'Renglon ('+renglon+') no se encontro la ciudad de Origen: ' + l.ciudadOrigen+' con el estado: '+l.estadoOrigen+' del pais: '+l.paisOrigen;
                    }
                    Location__c locDestino = ciudadesPorClave.get(claveCiudad(l.ciudadDestino, l.estadoDestino, l.paisDestino));
                    if(locDestino != null){
                        destinoId = locDestino.Id;
                    }else{
                        return 'Renglon ('+renglon+') no se encontro la ciudad de Destino: ' + l.ciudadDestino+' con el estado: '+l.estadoDestino+' del pais: '+l.paisDestino;
                    }
                    //usar la escritura OFICIAL del catalogo (no la del archivo) para que
                    //"MONTERREY - SALTILLO" y "Monterrey - Saltillo" no dupliquen productos
                    l.ciudadOrigen = locOrigen.Name;
                    l.ciudadDestino = locDestino.Name;
                    //cambio de wrapper para la clase P2G_loadProductsCsv
                    P2G_loadProducts.csvProduct csvLoadProducts = csvLoadProducts(l, origenId, destinoId);
                    loadProducts.add(csvLoadProducts);
                	renglon++;
                }
                System.debug('lista de load Products: '+loadProducts);
                String json = JSON.serialize(loadProducts);
                P2G_loadProductsCsv.handleProduct(idOpportunity,json,opp.CurrencyIsoCode);
                return 'ok';
            }else{
                return 'No se encontraron líneas en el documento';
            }   
        }
        catch(Exception e){
            Database.rollback(sp);
            System.debug('EXSDDSFSF: ' +  e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString()); return e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString();
        }
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