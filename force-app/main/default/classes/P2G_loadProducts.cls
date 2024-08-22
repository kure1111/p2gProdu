public class P2G_loadProducts {
    public class csvProduct {
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String origen { get; set; }
        @AuraEnabled public String destino { get; set; }
        @AuraEnabled public String origenId { get; set; }
        @AuraEnabled public String destinoId { get; set; }
        @AuraEnabled public String cantidad { get; set; } //
        @AuraEnabled public String pesoDeCarga { get; set; } //
        @AuraEnabled public String unidadPorFrecuencia { get; set; } //
        @AuraEnabled public String tipoMercancia { get; set; } //
        @AuraEnabled public String frecuencia { get; set; } //
        @AuraEnabled public String tiempoCarga { get; set; } //
        @AuraEnabled public String tiempoDescarga { get; set; } //
        @AuraEnabled public String modalidad { get; set; }
        @AuraEnabled public String direccionCarga { get; set; }
        @AuraEnabled public String direccionDescarga { get; set; }
        @AuraEnabled public String comentarios { get; set; } //
        @AuraEnabled public Boolean modificar { get; set; }
        @AuraEnabled public String buyPrice { get; set; }
        @AuraEnabled public String sellPrice  { get; set; }
        @AuraEnabled public String IdOli  { get; set; }
        @AuraEnabled public Boolean showFila  { get; set; }
        @AuraEnabled public String currencyOli  { get; set; }
    }
    
    @AuraEnabled
    public static csvProduct getCsv(){
        csvProduct csv = new csvProduct();
        return csv;
    }
    
    @AuraEnabled
    public static void handleProduct(String opportunityId,String jsonProduct) {
        System.debug('jsonProduct: '+jsonProduct);
       	P2G_loadProducts.csvProduct productInfo = (P2G_loadProducts.csvProduct)JSON.deserialize(jsonProduct, P2G_loadProducts.csvProduct.class);
        String productName = productInfo.origen + ' - ' + productInfo.destino;
        //Savepoint sp = Database.setSavepoint();
        	
            Opportunity opp = [SELECT Id, Name, Pricebook2Id, CurrencyIsoCode FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            if (opp.Pricebook2Id == null) {
                // Si no tiene un libro de precios, crea uno automáticamente
                Pricebook2 pb = new Pricebook2(Name = opp.Name + ' Pricebook', IsActive = true, Description = 'Auto-Generado');
                insert pb;
                
                // Asigna el nuevo libro de precios a la oportunidad y actualiza la oportunidad
                opp.Pricebook2Id = pb.Id;
                update opp;
            }
            // Luego, busca la entrada de lista de precios del producto
            List<PricebookEntry> opportunityEntries = [
                SELECT Id, Product2Id, Product2.Name
                FROM PricebookEntry
                WHERE Pricebook2Id = :opp.Pricebook2Id
                AND Product2.Name = :productName
                AND CurrencyIsoCode = :opp.CurrencyIsoCode
                LIMIT 1
            ];
            
            OpportunityLineItem newOpportunityLineItem;
            
            if (opportunityEntries != null && !opportunityEntries.isEmpty()) {
                PricebookEntry opportunityEntry = opportunityEntries[0];
                // Si el producto está en el libro de la oportunidad, imprime un mensaje
                System.debug('Producto encontrado en el libro de la oportunidad: ' + opportunityEntry.Product2.Name);
                newOpportunityLineItem = createOpporLi(opportunityId, opportunityEntry.Product2Id, opportunityEntry.Id,productInfo);
            } else {
                // Buscar el producto en el libro de precios estándar
                    List<PricebookEntry> standardEntries = [
                        SELECT Id, Product2Id, Product2.Name, UnitPrice
                        FROM PricebookEntry
                        WHERE Pricebook2.IsStandard = true
                        AND Product2.Name = :productName
                		AND CurrencyIsoCode = :opp.CurrencyIsoCode
                        LIMIT 1
                    ];
                
                if (standardEntries != null && !standardEntries.isEmpty()) {
                    // Si el producto está en el libro de precios estándar, crea una entrada en el libro de la oportunidad
                    Id opportunityPricebookId = [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opportunityId LIMIT 1].Pricebook2Id;
                    Pricebook2 opportunityPricebook = [SELECT Id FROM Pricebook2 WHERE Id = :opportunityPricebookId LIMIT 1];
                    
                    PricebookEntry newOpportunityEntry = new PricebookEntry(
                        Product2Id = standardEntries[0].Product2Id,
                        UnitPrice = standardEntries[0].UnitPrice,
                        IsActive = true,
                        Pricebook2Id = opportunityPricebook.Id,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                    
                    insert newOpportunityEntry;
                    
                    // Crea un OpportunityLineItem asociado al producto y la entrada de lista de precios de la oportunidad
                    newOpportunityLineItem = createOpporLi(opportunityId, standardEntries[0].Product2Id, newOpportunityEntry.Id,productInfo);
                    
                    System.debug('Producto encontrado en el libro de precios estándar. Se creó una entrada en el libro de la oportunidad.');
                } else {
                    // Si el producto no está en ninguno de los libros, crea una entrada en el libro de precios estándar y otra en el de la oportunidad
                    Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
                    Product2 newProduct = new Product2(
                        Name = productName,
                        PROJ_Site_of_load__c = productInfo.origenId,
                        PROJ_Site_of_discharge__c = productInfo.destinoId,
                        PROJ_Modalidad__c = productInfo.modalidad,
                        Family = 'Route',
                        IsActive = True,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                    insert newProduct;
                    
                    PricebookEntry newStandardEntry = new PricebookEntry(
                        Product2Id = newProduct.Id,
                        UnitPrice = 0,
                        IsActive = true,
                        Pricebook2Id = standardPricebook.Id,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                    insert newStandardEntry;
                    
                    // Crea una entrada en el libro de la oportunidad
                    Id opportunityPricebookId = [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opportunityId LIMIT 1].Pricebook2Id;
                    Pricebook2 opportunityPricebook = [SELECT Id FROM Pricebook2 WHERE Id = :opportunityPricebookId LIMIT 1];
                    
                    PricebookEntry newOpportunityEntry = new PricebookEntry(
                        Product2Id = newProduct.Id,
                        UnitPrice = 100,  // Puedes ajustar el precio según sea necesario
                        IsActive = true,
                        Pricebook2Id = opportunityPricebook.Id,
                        CurrencyIsoCode = opp.CurrencyIsoCode
                    );
                    
                    insert newOpportunityEntry;
                    
                    // Crea un OpportunityLineItem asociado al producto y la entrada de lista de precios de la oportunidad
                    newOpportunityLineItem = createOpporLi(opportunityId, newProduct.Id, newOpportunityEntry.Id, productInfo);
                    
                    System.debug('Producto no encontrado en ningún libro. Se creó una entrada en el libro de precios estándar y otra en el de la oportunidad.');
                }
            }
            
            // Puedes utilizar el nuevo OpportunityLineItem según sea necesario
            if (newOpportunityLineItem != null) {
                insert newOpportunityLineItem;
                System.debug('Se creó un OpportunityLineItem con Id: ' + newOpportunityLineItem.Id);
            }
        
            //Database.rollback(sp);
        
    }
    
    public static OpportunityLineItem createOpporLi(String opportunityId, Id product2Id, Id pricebookEntryId,csvProduct productInfo) {
        OpportunityLineItem rellena = new OpportunityLineItem();
        rellena.OpportunityId = opportunityId;
        rellena.Product2Id = product2Id;
        rellena.PricebookEntryId = pricebookEntryId;
        
        rellena.Quantity = Integer.valueOf(productInfo.cantidad);
        rellena.PROJ_Peso_de_carga__c = Decimal.valueOf(productInfo.pesoDeCarga);
        rellena.PROJ_Unidades_por_frecuencia__c = productInfo.unidadPorFrecuencia;
        rellena.PROJ_Tipo_de_mercancia__c = productInfo.tipoMercancia;
        rellena.PROJ_Frecuencia__c = productInfo.frecuencia; 
        rellena.PROJ_Tiempo_de_carga__c = Decimal.valueOF(productInfo.tiempoCarga);
        rellena.PROJ_Tiempo_de_descarga__c = Decimal.ValueOF(productInfo.tiempoDescarga);
        rellena.PROJ_Modalidad__c =  productInfo.modalidad; //repetido
        rellena.PROJ_Direccion_de_carga__c = productInfo.direccionCarga;
        rellena.PROJ_Direccion_de_descarga__c = productInfo.direccionDescarga;
        rellena.Comentarios__c = productInfo.comentarios;
        rellena.Tipo_de_moneda__c = productInfo.currencyOli;
        
        rellena.TotalPrice = 0;
        return rellena;
    }
    
    @AuraEnabled
    public static List<csvProduct> getOpportunityLineItems(String opportunityId) {
        List<csvProduct> csvProductsList = new List<csvProduct>();
        if (String.isNotBlank(opportunityId)) {
            List<OpportunityLineItem> opportunityLineItems = [SELECT Id,Ruta__c,Name, Quantity, PROJ_Peso_de_carga__c, PROJ_Unidades_por_frecuencia__c, 
                    PROJ_Tipo_de_mercancia__c, PROJ_Frecuencia__c, PROJ_Tiempo_de_carga__c, 
                    PROJ_Tiempo_de_descarga__c, PROJ_Modalidad__c, PROJ_Direccion_de_carga__c, 
                    PROJ_Direccion_de_descarga__c, TotalPrice,Comentarios__c,Buy_Price__c,UnitPrice
                    FROM OpportunityLineItem
                    WHERE OpportunityId = :opportunityId];
            
            for (OpportunityLineItem oli : opportunityLineItems) {
                csvProductsList.add(rellenagetItems(oli));
            }
        }
        return csvProductsList;
    }
    
    
    public static csvProduct rellenagetItems(OpportunityLineItem oli){
        csvProduct product = new csvProduct();
        product.Name = oli.Ruta__c;
        product.origen = oli.PROJ_Direccion_de_carga__c;
        product.destino = oli.PROJ_Direccion_de_descarga__c;
        product.cantidad = String.valueOf(oli.Quantity);
        product.pesoDeCarga = String.valueOf(oli.PROJ_Peso_de_carga__c);
        product.unidadPorFrecuencia = oli.PROJ_Unidades_por_frecuencia__c;
        product.tipoMercancia = oli.PROJ_Tipo_de_mercancia__c;
        product.frecuencia = oli.PROJ_Frecuencia__c;
        product.tiempoCarga = String.valueOf(oli.PROJ_Tiempo_de_carga__c);
        product.tiempoDescarga = String.valueOf(oli.PROJ_Tiempo_de_descarga__c);
        product.modalidad = oli.PROJ_Modalidad__c;
        product.direccionCarga = oli.PROJ_Direccion_de_carga__c;
        product.direccionDescarga = oli.PROJ_Direccion_de_descarga__c;
        product.comentarios = oli.Comentarios__c;
        product.modificar = false;
        product.showFila = false;
        product.IdOli = oli.Id;
        product.buyPrice = String.valueOf(oli.Buy_Price__c);
        product.sellPrice = String.valueOf(oli.UnitPrice);
        return product;
    }
    
    @AuraEnabled
    public static void updateOli(String jsonProduct){
        List<OpportunityLineItem> Olis = new List<OpportunityLineItem>();
        List<P2G_loadProducts.csvProduct> producstInfo = (List<P2G_loadProducts.csvProduct>)JSON.deserialize(jsonProduct, List<P2G_loadProducts.csvProduct>.class);
        for(csvProduct item: producstInfo){
            Olis.add(rellenaOpporLi(item));      
        }
        update Olis;
    }
    
    public static OpportunityLineItem rellenaOpporLi(csvProduct productInfo) {
    OpportunityLineItem oli = new OpportunityLineItem();
    oli.Id = productInfo.IdOli;

    // Comprobaciones antes de la conversión
    oli.Quantity = !String.isBlank(productInfo.cantidad) ? Integer.valueOf(productInfo.cantidad) : null;
    oli.PROJ_Peso_de_carga__c = !String.isBlank(productInfo.pesoDeCarga) ? Decimal.valueOf(productInfo.pesoDeCarga) : null;
    oli.PROJ_Unidades_por_frecuencia__c = productInfo.unidadPorFrecuencia;
    oli.PROJ_Tipo_de_mercancia__c = productInfo.tipoMercancia;
    oli.PROJ_Frecuencia__c = productInfo.frecuencia; 
    oli.PROJ_Tiempo_de_carga__c = !String.isBlank(productInfo.tiempoCarga) ? Decimal.valueOF(productInfo.tiempoCarga) : null;
    oli.PROJ_Tiempo_de_descarga__c = !String.isBlank(productInfo.tiempoDescarga) ? Decimal.ValueOF(productInfo.tiempoDescarga) : null;
    oli.PROJ_Modalidad__c =  productInfo.modalidad;
    oli.PROJ_Direccion_de_carga__c = productInfo.direccionCarga;
    oli.PROJ_Direccion_de_descarga__c = productInfo.direccionDescarga;
    oli.Comentarios__c = productInfo.comentarios;
    oli.Buy_Price__c = !String.isBlank(productInfo.buyPrice) ? Decimal.ValueOf(productInfo.buyPrice) : null;

    return oli;
}

    
    public static void quitar(){
        csvProduct product = new csvProduct();
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        product.origen = '';
        product.destino = '';
        product.cantidad = '';
        product.pesoDeCarga = '';
        product.unidadPorFrecuencia = '';
        product.tipoMercancia = '';
        product.frecuencia = '';
        product.tiempoCarga = '';
        product.tiempoDescarga = '';
        product.modalidad = '';
        product.direccionCarga = '';
        product.direccionDescarga = '';
        product.comentarios = '';
        product.modificar = false;
        product.IdOli = '';
        product.buyPrice = '';
        product.sellPrice = '';
        
    }
    
    
}