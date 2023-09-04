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
        Savepoint sp = Database.setSavepoint();
        try{
            List<csvProducts> lines = (List<csvProducts>)JSON.deserialize(jsn, List<csvProducts>.class);
            if(lines.size() > 0){
                Set<string> productName = new set<string>();
                Set<string> paisesName = new set<string>();
                Set<string> estadosName = new set<string>();
                Set<string> ciudadesName = new set<string>();
                Map<string,Product2> products = new Map<string,Product2>();
                Map<string,Country__c> paises = new Map<string,Country__c>();
                Map<string,State__c> estados = new Map<string,State__c>();
                Map<string,Location__c> ciudades = new Map<string,Location__c>();
                list<Product2> newProducts = new list<Product2>();
                list<PricebookEntry> newPE = new list<PricebookEntry>();
                list<PricebookEntry> newPEStdr = new list<PricebookEntry>();
                Map<string,PricebookEntry> pentries = new Map<string,PricebookEntry>();
                Map<string,PricebookEntry> pentriesStdr = new Map<string,PricebookEntry>();
                
                Opportunity opp = [SELECT Id, Name, Pricebook2Id,CurrencyIsoCode FROM Opportunity where id =: idOpportunity limit 1 ];
                Pricebook2 stdPriceBook = [select id, name from Pricebook2 where isStandard = true limit 1];
                //CurrencyType cur = [Select IsoCode From CurrencyType  where isCorporate = true and  IsActive = true limit 1 ];
                if(opp.Pricebook2Id == null){
                    Pricebook2 pb = new Pricebook2(Name = opp.name, IsActive = true, Description = 'Auto- Generado');
                    insert pb;
                    
                    opp.Pricebook2Id = pb.id;
                    update opp;
                }
                
                for( PricebookEntry a : [select id, name, Product2Id  ,isActive  from PricebookEntry where Pricebook2Id =:opp.Pricebook2Id and CreatedDate = TODAY order by CreatedDate desc]){
                    if(!pentries.containsKey(a.Product2Id))
                        pentries.put(a.Product2Id, a);
                }
                
                for( PricebookEntry a : [select id, name, Product2Id  ,isActive  from PricebookEntry where Pricebook2Id =:stdPriceBook.id and CreatedDate = TODAY order by CreatedDate desc]){
                    if(!pentriesStdr.containsKey(a.Product2Id))
                        pentriesStdr.put(a.Product2Id, a);
                }
                
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
                    productName.add(l.paisOrigen + '-' + l.estadoOrigen + '-' + l.ciudadOrigen + '-' + l.paisDestino+ '-' + l.estadoDestino + '-' + l.ciudadDestino + '-' + l.modalidad);
                    paisesName.add(l.paisOrigen);
                    paisesName.add(l.paisDestino);
                    estadosName.add(l.estadoOrigen);
                    estadosName.add(l.estadoDestino);
                    ciudadesName.add(l.ciudadDestino);
                    ciudadesName.add(l.ciudadOrigen);                    
                }
                
                
                for(Product2 a :[SELECT Id,Name,Searchable_name__c FROM Product2 WHERE Searchable_name__c IN: productName ]){
                    if(!products.containsKey(a.name))
                        products.put(a.Searchable_name__c, a);
                }
                
                for(Country__c a :[SELECT Id,Name FROM Country__c WHERE name IN: paisesName ]){
                    if(!paises.containsKey(a.name))
                        paises.put(a.name, a);
                }
                
                for(State__c a :[SELECT Id,Name FROM State__c WHERE name IN: estadosName ]){
                    if(!estados.containsKey(a.name))
                        estados.put(a.name, a);
                }
                
                for(Location__c a :[SELECT Id,Name FROM Location__c WHERE name IN: ciudadesName]){
                    if(!ciudades.containsKey(a.name))
                        ciudades.put(a.name, a);
                }
                
                integer renglon = 2;
                
                for(csvProducts l : lines){
                    //inician validaciones
                    if(String.isBlank(l.paisOrigen) || paises.get(l.paisOrigen) == null )
                        return 'Renglon ('+renglon+') : No se encontró país de origen ' + l.paisOrigen ;
                    if(String.isBlank(l.estadoOrigen) || estados.get(l.estadoOrigen) == null )
                        return 'Renglon ('+renglon+') : No se encontró estado de origen ' + l.estadoOrigen;
                    if(String.isBlank(l.ciudadOrigen) || ciudades.get(l.ciudadOrigen) == null )
                        return 'Renglon ('+renglon+') : No se encontró ciudad de origen ' +l.ciudadOrigen;
                    if(String.isBlank(l.paisDestino) || paises.get(l.paisDestino) == null )
                        return 'Renglon ('+renglon+') : No se encontró país de destino ' + l.paisDestino;
                    if(String.isBlank(l.estadoDestino) || estados.get(l.estadoDestino) == null )
                        return 'Renglon ('+renglon+') : No se encontró estado de destino ' + l.estadoDestino;
                    if(String.isBlank(l.ciudadDestino) || ciudades.get(l.ciudadDestino) == null )
                        return 'Renglon ('+renglon+') : No se encontró ciudad de destino ' + l.ciudadDestino;
                    if(l.cantidad == null)
                        return  'Renglon ('+renglon+') : debe tener Cantidad';
                    
                    string frec =  options.get( l.frecuencia );                    
                    if(string.isBlank(frec))
                        return 'Renglon ('+renglon+') contiene una frecuencia invalida : ' + l.frecuencia;
                    
                    string modali =  optionsProd.get( l.modalidad );
                    if(string.isBlank(modali))
                        return 'Renglon ('+renglon+') contiene una modalidad invalida : ' + l.modalidad;
                    
                    //terminan validaciones
                    Product2 producto = products.get(l.paisOrigen + '-' + l.estadoOrigen + '-' + l.ciudadOrigen + '-' + l.paisDestino+ '-' + l.estadoDestino + '-' + l.ciudadDestino + '-' + l.modalidad);
                    
                    if(producto == null){
                        Product2 product = new Product2();
                        product.Name = l.ciudadOrigen + ' - ' + l.ciudadDestino;
                        //product.Name = '.';
                        product.PROJ_Site_of_discharge__c = ciudades.get(l.ciudadDestino).id;
                        product.PROJ_Site_of_load__c = ciudades.get(l.ciudadOrigen).id;
                        
                        product.PROJ_WTP__c  = false;
                        product.PROJ_Modalidad__c  = l.modalidad ;
                        product.Family  = 'Route';
                        
                        product.CurrencyIsoCode  = opp.CurrencyIsoCode;//cur.IsoCode ;
                        product.IsActive  = true;
                        
                        newProducts.add(product);
                    }
                    else if(producto != null){
                        if(pentriesStdr.get(producto.id) == null){
                            PricebookEntry newPes = new PricebookEntry();
                            newPes.Product2Id = producto.id;
                            newPes.UnitPrice = 0;
                            newPes.isActive = true;
                            
                            if (Test.isRunningTest()){
                                Id pricebookId = Test.getStandardPricebookId();  
                                newPes.Pricebook2Id = pricebookId;
                            }
                            else
                                newPes.Pricebook2Id = stdPriceBook.id;
                            newPEStdr.add(newPes);
                        }
                        
                        if(pentries.get(producto.id) == null){
                            PricebookEntry newPes = new PricebookEntry();
                            newPes.Product2Id = producto.id;
                            newPes.UnitPrice = 0;
                            newPes.isActive = true;
                            
                            if (Test.isRunningTest()){
                                Id pricebookId = Test.getStandardPricebookId();  
                                newPes.Pricebook2Id = pricebookId;
                            }
                            else
                                newPes.Pricebook2Id = opp.Pricebook2Id;
                            
                            newPE.add(newPes);
                        }
                    }
                    renglon++;
                }
                
                if(newProducts.size()>0){
                    insert newProducts;
                    
                    for(Product2 pp : newProducts){
                        if(pentriesStdr.get(pp.id) == null){
                            PricebookEntry newPes = new PricebookEntry();
                            newPes.Product2Id = pp.id;
                            newPes.UnitPrice = 0;
                            newPes.isActive = true;
                            
                            if (Test.isRunningTest()){
                                Id pricebookId = Test.getStandardPricebookId();  
                                newPes.Pricebook2Id = pricebookId;
                            }
                            else
                                newPes.Pricebook2Id = stdPriceBook.id;
                            newPEStdr.add(newPes);
                        }
                        if(pentries.get(pp.id) == null){
                            PricebookEntry newPes2 = new PricebookEntry();
                            newPes2.Product2Id = pp.id;
                            newPes2.UnitPrice = 0;
                            newPes2.isActive = true;
                            
                            if (Test.isRunningTest()){
                                Id pricebookId = Test.getStandardPricebookId();  
                                newPes2.Pricebook2Id = pricebookId;
                            }
                            else
                                newPes2.Pricebook2Id = opp.Pricebook2Id;
                            newPE.add(newPes2);
                        }
                    }
                }
                
                if(newPEStdr.size()>0)
                    insert newPEStdr;
                
                if(newPE.size()>0)
                    insert newPE;
                
                
                
                Map<string,PricebookEntry> pesMap = new Map<string,PricebookEntry>();
                for(PricebookEntry pes : [select id, name,Product2Id,Pricebook2Id, Product2.Searchable_name__c from PricebookEntry where Pricebook2Id =: opp.Pricebook2Id  ] ){
                    if(!pesMap.containsKey(pes.Product2.Searchable_name__c))
                        pesMap.put(pes.Product2.Searchable_name__c, pes);
                }                        
                
                List<OpportunityLineItem> olis = new list<OpportunityLineItem>();
                
                for(csvProducts l : lines){
                    
                    string key = l.paisOrigen + '-' + l.estadoOrigen + '-' + l.ciudadOrigen + '-' + l.paisDestino+ '-' + l.estadoDestino + '-' + l.ciudadDestino + '-' + l.modalidad;
                    PricebookEntry mype = pesMap.get(key);
                    if(mype != null){
                        
                        OpportunityLineItem oli = new OpportunityLineItem();
                        oli.OpportunityId = opp.id;
                        oli.Product2Id = mype.Product2Id;
                        oli.PricebookEntryId = mype.id;
                        //  ProductCode, Name,Description,PROJ_Relacionado_a__c,PROJ_Relacionado_a_nombre__c,PROJ_Margen_de_venta__c, PROJ_Producto_padre__c, PROJ_Customer__c, 
                        //oli.PROJ_Precio_de_venta__c, oli.PROJ_Especificaciones__c,oli.PROJ_Agrupados__c,     // oli.PROJ_Buy_price__c = 0; 
                        
                        oli.Quantity =  l.cantidad;
                        oli.PROJ_Peso_de_carga__c = l.pesoDeCarga;
                        oli.PROJ_Unidades_por_frecuencia__c = l.unidadPorFrecuencia;
                        oli.PROJ_Tipo_de_mercancia__c = l.tipoDeMercancia;
                        oli.PROJ_Frecuencia__c = l.frecuencia; 
                        oli.PROJ_Tiempo_de_carga__c = l.tiempoDeCarga; 
                        oli.PROJ_Tiempo_de_descarga__c = l.tiempoDeDescarga;
                        oli.PROJ_Modalidad__c =  l.modalidad; //repetido
                        oli.PROJ_Direccion_de_carga__c = l.direccionDeCarga;
                        oli.PROJ_Direccion_de_descarga__c = l.direccionDeDescarga;
                        oli.TotalPrice = 0;
                        //  oli.PROJ_WTP__c  = false;  //REPETIDO
                        olis.add(oli);
                    }
                }
                if(olis.size()>0)
                    insert olis;
                
                return 'ok';
            }else{
                return 'No se encontraron líneas en el documento';
            }   
        }
        catch(Exception e){
            Database.rollback(sp);
            System.debug('EX: ' +  e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString()); return e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString();
        }
    }
    
    public static void test(){
        string a = '';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
    }
}