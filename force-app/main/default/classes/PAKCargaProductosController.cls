//AGE
global with sharing class PAKCargaProductosController {
    
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
                for(csvProducts l : lines){                   
                    paisesName.add(l.paisOrigen);
                    paisesName.add(l.paisDestino);
                    estadosName.add(l.estadoOrigen);
                    estadosName.add(l.estadoDestino);
                    ciudadesName.add(l.ciudadDestino);
                    ciudadesName.add(l.ciudadOrigen);                    
                }
                List<Location__c> locationRecords = [SELECT Id, Name, State__c, State__r.Name, Country__c, Country__r.Name FROM Location__c WHERE Name IN :ciudadesName And State__r.Name IN :estadosName LIMIT 49000];
                for (Location__c a : locationRecords) {
                    if (!ciudades.containsKey(a.Name)) {
                        ciudades.put(a.Name, a);
                        estados.put(a.State__r.Name, a.id);
                        paises.put(a.Country__r.Name, a.id);
                    }
                }
                
                integer renglon = 2;
                
                for(csvProducts l : lines){
                    //inician validaciones
                        System.debug('las ciudades son: '+ciudades);
                    if(String.isBlank(l.paisOrigen) || paises.get(l.paisOrigen) == null )
                        return 'Renglon ('+renglon+') : No se encontró país de origen ' + l.paisOrigen ;
                    if(String.isBlank(l.estadoOrigen) || estados.get(l.estadoOrigen) == null )
                        return 'Renglon ('+renglon+') : No se encontró estado de origen ' + l.estadoOrigen;
                    if(String.isBlank(l.ciudadOrigen) || ciudades.get(l.ciudadOrigen) == null )
                        return 'Renglon ('+renglon+') : No se encontró ciudad de origen ' +l.ciudadOrigen;
                    if(String.isBlank(l.paisDestino) || paises.get(l.paisDestino) == null )
                        return 'Renglon ('+renglon+') : No se encontró país de destino ' + l.paisDestino;
                    if(String.isBlank(l.estadoDestino) || estados.get(l.estadoDestino) == null ){
                        return 'Renglon ('+renglon+') : No se encontró estado de destino ' + l.estadoDestino;}
                    if(String.isBlank(l.ciudadDestino) || ciudades.get(l.ciudadDestino) == null )
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
                    //sacar los Ids de origen y destino
                    if((ciudades.get(l.ciudadOrigen).Name == l.ciudadOrigen) && (ciudades.get(l.ciudadOrigen).State__r.Name == l.estadoOrigen) && (ciudades.get(l.ciudadOrigen).Country__r.Name == l.paisOrigen)){
                        origenId = ciudades.get(l.ciudadOrigen).Id;
                    }else{
                        return 'Renglon ('+renglon+') no se encontro la ciudad de Origen: ' + l.ciudadOrigen+' con el estado: '+l.estadoOrigen+' del pais: '+l.paisOrigen;
                    }
                    if((ciudades.get(l.ciudadDestino).Name == l.ciudadDestino) && (ciudades.get(l.ciudadDestino).State__r.Name == l.estadoDestino) && (ciudades.get(l.ciudadDestino).Country__r.Name == l.paisDestino)){
                        destinoId = ciudades.get(l.ciudadDestino).Id;
                    }else{
                        return 'Renglon ('+renglon+') no se encontro la ciudad de Destino: ' + l.ciudadDestino+' con el estado: '+l.estadoDestino+' del pais: '+l.paisDestino;
                    }
                    //cambio de wrapper para la clase P2G_loadProductsCsv
                    P2G_loadProducts.csvProduct csvLoadProducts = csvLoadProducts(l, origenId, destinoId);
                    loadProducts.add(csvLoadProducts);
                	renglon++;
                }
                System.debug('lista de load Products: '+loadProducts);
                String json = JSON.serialize(loadProducts);
                P2G_loadProductsCsv.handleProduct(idOpportunity,json);
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